-- CountFlow Item Master: GS1 validation, internal identifiers, UoM barcodes,
-- server-side quantity precision and bounded global catalog chunk upsert.
-- No new product master tables: preserve Global / Client / Project contracts.

CREATE OR REPLACE FUNCTION counting_private.gs1_check_digit(p_payload text)
RETURNS integer LANGUAGE plpgsql IMMUTABLE SET search_path TO ''
AS $function$
DECLARE v_sum integer:=0; v_weight integer:=3; v_i integer;
BEGIN
  IF p_payload IS NULL OR p_payload !~ '^[0-9]+$' OR length(p_payload)<1 THEN RETURN NULL; END IF;
  FOR v_i IN REVERSE length(p_payload)..1 LOOP
    v_sum:=v_sum+substr(p_payload,v_i,1)::integer*v_weight;
    v_weight:=CASE WHEN v_weight=3 THEN 1 ELSE 3 END;
  END LOOP;
  RETURN (10-(v_sum%10))%10;
END;
$function$;

CREATE OR REPLACE FUNCTION counting_private.is_valid_gtin(p_code text)
RETURNS boolean LANGUAGE sql IMMUTABLE SET search_path TO ''
AS $function$
  SELECT p_code ~ '^[0-9]+$'
     AND length(p_code) IN (8,12,13,14)
     AND right(p_code,1)::integer =
         counting_private.gs1_check_digit(left(p_code,length(p_code)-1));
$function$;

CREATE OR REPLACE FUNCTION counting_private.resolve_item_barcode_type(p_code text,p_requested_type text DEFAULT 'AUTO')
RETURNS text LANGUAGE plpgsql IMMUTABLE SET search_path TO ''
AS $function$
DECLARE v_type text:=upper(coalesce(nullif(btrim(p_requested_type),''),'AUTO')); v_length integer:=length(coalesce(p_code,''));
BEGIN
  IF nullif(btrim(p_code),'') IS NULL THEN RETURN NULL; END IF;
  IF p_code<>btrim(p_code) OR p_code ~ '[[:cntrl:]]' THEN RAISE EXCEPTION 'INVALID_BARCODE_CHARACTERS'; END IF;
  IF v_type IN ('AUTO','UNKNOWN') THEN
    IF p_code ~ '^[0-9]+$' AND v_length IN (8,12,13,14) THEN
      IF NOT counting_private.is_valid_gtin(p_code) THEN RAISE EXCEPTION 'INVALID_GS1_CHECK_DIGIT'; END IF;
      RETURN CASE v_length WHEN 8 THEN 'EAN8' WHEN 12 THEN 'UPC_A' WHEN 13 THEN 'EAN13' ELSE 'GTIN14' END;
    END IF;
    IF p_code ~ '^CFI-[A-F0-9-]{8,48}$' THEN RETURN 'INTERNAL'; END IF;
    v_type:='CODE128';
  END IF;
  IF v_type IN ('EAN8','UPC_A','EAN13','GTIN14') THEN
    IF v_length<>(CASE v_type WHEN 'EAN8' THEN 8 WHEN 'UPC_A' THEN 12 WHEN 'EAN13' THEN 13 ELSE 14 END)
       OR NOT counting_private.is_valid_gtin(p_code) THEN
      RAISE EXCEPTION 'INVALID_GS1_CHECK_DIGIT_OR_LENGTH';
    END IF;
    RETURN v_type;
  END IF;
  IF v_type='INTERNAL' THEN
    IF p_code !~ '^CFI-[A-F0-9-]{8,48}$' OR v_length>48 THEN RAISE EXCEPTION 'INVALID_INTERNAL_BARCODE'; END IF;
    RETURN 'INTERNAL';
  END IF;
  IF v_type='CODE128' THEN
    IF p_code !~ '^[ -~]{1,48}$' THEN RAISE EXCEPTION 'INVALID_CODE128_VALUE'; END IF;
    RETURN 'CODE128';
  END IF;
  RAISE EXCEPTION 'UNSUPPORTED_BARCODE_TYPE';
END;
$function$;

CREATE OR REPLACE FUNCTION counting_private.infer_item_unit_class(p_unit text)
RETURNS text LANGUAGE sql IMMUTABLE SET search_path TO ''
AS $function$
  SELECT CASE
    WHEN lower(regexp_replace(coalesce(p_unit,''),'[[:space:]_.-]+','','g')) IN
      ('kg','kgs','kilogram','kilograms','g','gm','gram','grams','mg','lb','lbs','oz','ton','tonne','tonnes',
       'كجم','كيلوجرام','كيلوغرام','جرام','غرام','جم','ملجم') THEN 'mass'
    WHEN lower(regexp_replace(coalesce(p_unit,''),'[[:space:]_.-]+','','g')) IN
      ('l','lt','liter','litre','liters','litres','ml','milliliter','millilitre','لتر','ملليلتر','مليلتر') THEN 'volume'
    WHEN lower(regexp_replace(coalesce(p_unit,''),'[[:space:]_.-]+','','g')) IN
      ('m','meter','metre','cm','mm','km','inch','in','ft','متر','سم','مم','كم') THEN 'length'
    WHEN lower(regexp_replace(coalesce(p_unit,''),'[[:space:]_.-]+','','g')) IN
      ('m2','sqm','sqft','ft2','مترمربع','م٢') THEN 'area'
    WHEN lower(regexp_replace(coalesce(p_unit,''),'[[:space:]_.-]+','','g')) IN
      ('ea','each','pc','pcs','piece','pieces','unit','units','dozen','dz','قطعة','عدد','وحدة','حبة','علبة','كرتونة','كرتون','عبوة','باكيت','دستة') THEN 'count'
    ELSE 'other'
  END;
$function$;

CREATE OR REPLACE FUNCTION counting_private.normalize_product_units(
  p_units jsonb,p_base_unit text,p_primary_barcode text,p_primary_barcode_type text,p_item_kind text
)
RETURNS jsonb LANGUAGE plpgsql IMMUTABLE SET search_path TO ''
AS $function$
DECLARE
  v_row jsonb; v_meta jsonb:='{}'::jsonb; v_clean jsonb:='[]'::jsonb; v_normalized jsonb:='[]'::jsonb;
  v_meta_count integer:=0; v_family text; v_kind text; v_precision integer; v_precision_text text;
  v_name text; v_factor_text text; v_factor numeric; v_unit_barcode text; v_unit_barcode_type text;
  v_names text[]:=ARRAY[]::text[]; v_codes text[]:=ARRAY[]::text[];
BEGIN
  IF p_units IS NULL OR jsonb_typeof(p_units)<>'array' THEN RAISE EXCEPTION 'PRODUCT_UNITS_MUST_BE_ARRAY'; END IF;
  IF jsonb_array_length(p_units)>51 THEN RAISE EXCEPTION 'PRODUCT_HAS_TOO_MANY_UOM_ROWS'; END IF;
  FOR v_row IN SELECT value FROM jsonb_array_elements(p_units) AS x(value) LOOP
    IF jsonb_typeof(v_row)='object' AND coalesce(v_row->>'__countflow_unit_meta','false')='true' THEN
      v_meta_count:=v_meta_count+1; v_meta:=v_row;
    ELSE
      v_clean:=v_clean||jsonb_build_array(v_row);
    END IF;
  END LOOP;
  IF v_meta_count>1 THEN RAISE EXCEPTION 'DUPLICATE_PRODUCT_UNIT_METADATA'; END IF;

  v_family:=coalesce(nullif(v_meta->>'unit_class',''),counting_private.infer_item_unit_class(p_base_unit));
  IF v_family NOT IN ('count','mass','volume','length','area','other') THEN RAISE EXCEPTION 'INVALID_PRODUCT_UNIT_CLASS'; END IF;
  v_precision_text:=coalesce(nullif(v_meta->>'decimal_precision',''),CASE WHEN v_family='count' THEN '0' ELSE '3' END);
  IF v_precision_text !~ '^[0-6]$' THEN RAISE EXCEPTION 'INVALID_PRODUCT_DECIMAL_PRECISION'; END IF;
  v_precision:=v_precision_text::integer;
  v_kind:=coalesce(nullif(v_meta->>'item_kind',''),nullif(p_item_kind,''),CASE
    WHEN v_family='mass' THEN 'WEIGHED' WHEN p_primary_barcode_type='INTERNAL' THEN 'NO_BARCODE' ELSE 'BARCODED' END);
  IF v_kind NOT IN ('BARCODED','WEIGHED','NO_BARCODE') THEN RAISE EXCEPTION 'INVALID_PRODUCT_ITEM_KIND'; END IF;
  IF v_kind='WEIGHED' AND v_family<>'mass' THEN RAISE EXCEPTION 'WEIGHED_ITEM_REQUIRES_MASS_UNIT_CLASS'; END IF;
  IF v_kind='NO_BARCODE' AND p_primary_barcode_type IS NOT NULL AND p_primary_barcode_type<>'INTERNAL' THEN
    RAISE EXCEPTION 'NO_BARCODE_ITEM_CANNOT_USE_EXTERNAL_BARCODE';
  END IF;
  IF v_kind='BARCODED' AND p_primary_barcode_type='INTERNAL' THEN RAISE EXCEPTION 'BARCODED_ITEM_REQUIRES_EXTERNAL_BARCODE'; END IF;

  FOR v_row IN SELECT value FROM jsonb_array_elements(v_clean) AS x(value) LOOP
    IF jsonb_typeof(v_row)<>'object' THEN RAISE EXCEPTION 'INVALID_PRODUCT_UOM_ROW'; END IF;
    v_name:=nullif(btrim(v_row->>'name'),'');
    IF v_name IS NULL OR length(v_name)>40 THEN RAISE EXCEPTION 'INVALID_PRODUCT_UOM_NAME'; END IF;
    IF lower(v_name)=lower(btrim(p_base_unit)) THEN RAISE EXCEPTION 'ALTERNATE_UOM_MATCHES_BASE_UNIT'; END IF;
    IF lower(v_name)=ANY(v_names) THEN RAISE EXCEPTION 'DUPLICATE_PRODUCT_UOM_NAME'; END IF;
    v_names:=array_append(v_names,lower(v_name));
    v_factor_text:=coalesce(v_row->>'factor_to_base',v_row->>'conversion_factor',v_row->>'factor');
    IF v_factor_text IS NULL OR v_factor_text !~ '^[0-9]+([.][0-9]{1,8})?$' THEN RAISE EXCEPTION 'INVALID_PRODUCT_UOM_FACTOR'; END IF;
    v_factor:=v_factor_text::numeric;
    IF v_factor<=0 OR v_factor>1000000000 THEN RAISE EXCEPTION 'INVALID_PRODUCT_UOM_FACTOR'; END IF;
    v_unit_barcode:=nullif(btrim(v_row->>'barcode'),'');
    IF v_unit_barcode IS NOT NULL THEN
      v_unit_barcode_type:=counting_private.resolve_item_barcode_type(v_unit_barcode,coalesce(v_row->>'barcode_type','AUTO'));
      IF lower(v_unit_barcode)=lower(coalesce(p_primary_barcode,'')) THEN RAISE EXCEPTION 'UOM_BARCODE_EQUALS_PRIMARY_BARCODE'; END IF;
      IF lower(v_unit_barcode)=ANY(v_codes) THEN RAISE EXCEPTION 'DUPLICATE_UOM_BARCODE'; END IF;
      v_codes:=array_append(v_codes,lower(v_unit_barcode));
      v_row:=jsonb_set(v_row,'{barcode}',to_jsonb(v_unit_barcode),true);
      v_row:=jsonb_set(v_row,'{barcode_type}',to_jsonb(v_unit_barcode_type),true);
    ELSE
      v_row:=v_row-'barcode_type';
      IF nullif(v_row->>'barcode','') IS NULL THEN v_row:=v_row-'barcode'; END IF;
    END IF;
    v_row:=jsonb_set(v_row,'{name}',to_jsonb(v_name),true);
    v_row:=jsonb_set(v_row,'{factor_to_base}',to_jsonb(v_factor),true);
    v_normalized:=v_normalized||jsonb_build_array(v_row);
  END LOOP;
  IF p_primary_barcode IS NOT NULL AND lower(p_primary_barcode)=ANY(v_codes) THEN RAISE EXCEPTION 'PRIMARY_BARCODE_REUSED_BY_ALTERNATE_UOM'; END IF;
  v_meta:=v_meta||jsonb_build_object(
    '__countflow_unit_meta',true,'unit_class',v_family,'decimal_precision',v_precision,
    'item_kind',v_kind,'barcode_type',p_primary_barcode_type
  );
  RETURN v_normalized||jsonb_build_array(v_meta);
END;
$function$;

CREATE OR REPLACE FUNCTION counting_private.assert_unique_product_barcodes(
  p_scope text,p_scope_id uuid,p_item_id uuid,p_primary_barcode text,p_units jsonb
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_code text; v_duplicate boolean; v_scope_key text:=coalesce(p_scope_id::text,'GLOBAL');
BEGIN
  FOR v_code IN
    SELECT DISTINCT lower(btrim(code)) FROM (
      SELECT nullif(btrim(p_primary_barcode),'') AS code
      UNION ALL
      SELECT nullif(btrim(value->>'barcode'),'')
      FROM jsonb_array_elements(coalesce(p_units,'[]'::jsonb)) AS x(value)
      WHERE jsonb_typeof(value)='object'
    ) s WHERE code IS NOT NULL ORDER BY 1
  LOOP
    PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(p_scope||':'||v_scope_key||':'||v_code,0));
    IF p_scope='GLOBAL' THEN
      SELECT EXISTS(SELECT 1 FROM public.count_catalog_products p
        WHERE p.id IS DISTINCT FROM p_item_id
          AND (lower(btrim(p.barcode))=v_code OR EXISTS(
            SELECT 1 FROM jsonb_array_elements(coalesce(p.units,'[]'::jsonb)) u(value)
            WHERE lower(btrim(coalesce(u.value->>'barcode','')))=v_code
          ))) INTO v_duplicate;
    ELSIF p_scope='CLIENT' THEN
      SELECT EXISTS(SELECT 1 FROM public.count_client_products p
        WHERE p.client_id=p_scope_id AND p.id IS DISTINCT FROM p_item_id
          AND (lower(btrim(p.client_barcode))=v_code OR EXISTS(
            SELECT 1 FROM jsonb_array_elements(coalesce(p.units_override,'[]'::jsonb)) u(value)
            WHERE lower(btrim(coalesce(u.value->>'barcode','')))=v_code
          ))) INTO v_duplicate;
    ELSIF p_scope='PROJECT' THEN
      SELECT EXISTS(SELECT 1 FROM public.count_products p
        WHERE p.project_id=p_scope_id AND p.id IS DISTINCT FROM p_item_id
          AND (lower(btrim(p.barcode))=v_code OR EXISTS(
            SELECT 1 FROM jsonb_array_elements(coalesce(p.units,'[]'::jsonb)) u(value)
            WHERE lower(btrim(coalesce(u.value->>'barcode','')))=v_code
          ))) INTO v_duplicate;
    ELSE
      RAISE EXCEPTION 'INVALID_ITEM_BARCODE_SCOPE';
    END IF;
    IF v_duplicate THEN RAISE EXCEPTION 'ITEM_BARCODE_ALREADY_ASSIGNED_IN_SCOPE'; END IF;
  END LOOP;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.assert_unique_product_barcodes(text,uuid,uuid,text,jsonb) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION counting_private.assert_unique_product_barcodes(text,uuid,uuid,text,jsonb) TO authenticated;

CREATE OR REPLACE FUNCTION counting_private.validate_global_product_master()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_meta jsonb; v_item_kind text; v_barcode_type text; v_unit_class text; v_auto_barcode boolean;
BEGIN
  NEW.canonical_sku:=nullif(btrim(NEW.canonical_sku),'');
  NEW.base_unit:=nullif(btrim(NEW.base_unit),'');
  IF NEW.base_unit IS NULL THEN RAISE EXCEPTION 'PRODUCT_BASE_UNIT_REQUIRED'; END IF;
  v_auto_barcode:=nullif(btrim(NEW.barcode),'') IS NULL;
  IF NEW.canonical_sku IS NULL THEN NEW.canonical_sku:='CFI-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,24)); END IF;
  IF v_auto_barcode THEN NEW.barcode:='CFI-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,24));
  ELSE NEW.barcode:=btrim(NEW.barcode); END IF;
  SELECT value INTO v_meta FROM jsonb_array_elements(coalesce(NEW.units,'[]'::jsonb)) AS x(value)
  WHERE value->>'__countflow_unit_meta'='true' LIMIT 1;
  v_unit_class:=coalesce(nullif(v_meta->>'unit_class',''),counting_private.infer_item_unit_class(NEW.base_unit));
  v_item_kind:=coalesce(nullif(v_meta->>'item_kind',''),CASE WHEN v_auto_barcode THEN
    CASE WHEN v_unit_class='mass' THEN 'WEIGHED' ELSE 'NO_BARCODE' END
    WHEN v_unit_class='mass' THEN 'WEIGHED' ELSE 'BARCODED' END);
  v_barcode_type:=counting_private.resolve_item_barcode_type(NEW.barcode,coalesce(v_meta->>'barcode_type',CASE WHEN v_auto_barcode THEN 'INTERNAL' ELSE 'AUTO' END));
  NEW.units:=counting_private.normalize_product_units(coalesce(NEW.units,'[]'::jsonb),NEW.base_unit,NEW.barcode,v_barcode_type,v_item_kind);
  PERFORM counting_private.assert_unique_product_barcodes('GLOBAL',NULL,NEW.id,NEW.barcode,NEW.units);
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION counting_private.validate_project_product_master()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_meta jsonb; v_item_kind text; v_barcode_type text; v_unit_class text; v_auto_barcode boolean;
BEGIN
  NEW.sku:=nullif(btrim(NEW.sku),'');
  NEW.base_unit:=nullif(btrim(NEW.base_unit),'');
  IF NEW.base_unit IS NULL THEN RAISE EXCEPTION 'PRODUCT_BASE_UNIT_REQUIRED'; END IF;
  v_auto_barcode:=nullif(btrim(NEW.barcode),'') IS NULL;
  IF NEW.sku IS NULL THEN NEW.sku:='CFI-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,24)); END IF;
  IF v_auto_barcode THEN NEW.barcode:='CFI-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,24));
  ELSE NEW.barcode:=btrim(NEW.barcode); END IF;
  SELECT value INTO v_meta FROM jsonb_array_elements(coalesce(NEW.units,'[]'::jsonb)) AS x(value)
  WHERE value->>'__countflow_unit_meta'='true' LIMIT 1;
  v_unit_class:=coalesce(nullif(v_meta->>'unit_class',''),counting_private.infer_item_unit_class(NEW.base_unit));
  v_item_kind:=coalesce(nullif(v_meta->>'item_kind',''),CASE WHEN v_auto_barcode THEN
    CASE WHEN v_unit_class='mass' THEN 'WEIGHED' ELSE 'NO_BARCODE' END
    WHEN v_unit_class='mass' THEN 'WEIGHED' ELSE 'BARCODED' END);
  v_barcode_type:=counting_private.resolve_item_barcode_type(NEW.barcode,coalesce(v_meta->>'barcode_type',CASE WHEN v_auto_barcode THEN 'INTERNAL' ELSE 'AUTO' END));
  NEW.units:=counting_private.normalize_product_units(coalesce(NEW.units,'[]'::jsonb),NEW.base_unit,NEW.barcode,v_barcode_type,v_item_kind);
  PERFORM counting_private.assert_unique_product_barcodes('PROJECT',NEW.project_id,NEW.id,NEW.barcode,NEW.units);
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION counting_private.validate_client_product_units()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_meta jsonb; v_item_kind text; v_barcode_type text; v_unit_class text;
BEGIN
  IF NEW.client_barcode IS NOT NULL THEN
    NEW.client_barcode:=btrim(NEW.client_barcode);
    SELECT value INTO v_meta FROM jsonb_array_elements(coalesce(NEW.units_override,'[]'::jsonb)) AS x(value)
    WHERE value->>'__countflow_unit_meta'='true' LIMIT 1;
    v_barcode_type:=counting_private.resolve_item_barcode_type(NEW.client_barcode,coalesce(v_meta->>'barcode_type','AUTO'));
  ELSE
    v_barcode_type:=NULL;
  END IF;
  IF NEW.units_override IS NOT NULL THEN
    IF NEW.base_unit_override IS NULL THEN RAISE EXCEPTION 'CLIENT_UOM_OVERRIDE_REQUIRES_BASE_UNIT'; END IF;
    v_meta:=NULL;
    SELECT value INTO v_meta FROM jsonb_array_elements(NEW.units_override) AS x(value)
    WHERE value->>'__countflow_unit_meta'='true' LIMIT 1;
    v_unit_class:=coalesce(nullif(v_meta->>'unit_class',''),counting_private.infer_item_unit_class(NEW.base_unit_override));
    v_item_kind:=coalesce(nullif(v_meta->>'item_kind',''),CASE WHEN v_unit_class='mass' THEN 'WEIGHED' ELSE 'BARCODED' END);
    NEW.units_override:=counting_private.normalize_product_units(NEW.units_override,NEW.base_unit_override,NEW.client_barcode,v_barcode_type,v_item_kind);
  END IF;
  IF NEW.client_barcode IS NOT NULL OR NEW.units_override IS NOT NULL THEN
    PERFORM counting_private.assert_unique_product_barcodes('CLIENT',NEW.client_id,NEW.id,NEW.client_barcode,coalesce(NEW.units_override,'[]'::jsonb));
  END IF;
  RETURN NEW;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.validate_global_product_master() FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION counting_private.validate_project_product_master() FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION counting_private.validate_client_product_units() FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION counting_private.validate_global_product_master() TO authenticated;
GRANT EXECUTE ON FUNCTION counting_private.validate_project_product_master() TO authenticated;
GRANT EXECUTE ON FUNCTION counting_private.validate_client_product_units() TO authenticated;

DROP TRIGGER IF EXISTS count_catalog_product_master_guard ON public.count_catalog_products;
CREATE TRIGGER count_catalog_product_master_guard
BEFORE INSERT OR UPDATE OF canonical_sku,barcode,base_unit,units ON public.count_catalog_products
FOR EACH ROW EXECUTE FUNCTION counting_private.validate_global_product_master();

DROP TRIGGER IF EXISTS count_project_product_master_guard ON public.count_products;
CREATE TRIGGER count_project_product_master_guard
BEFORE INSERT OR UPDATE OF sku,barcode,base_unit,units ON public.count_products
FOR EACH ROW EXECUTE FUNCTION counting_private.validate_project_product_master();

DROP TRIGGER IF EXISTS count_client_product_units_guard ON public.count_client_products;
CREATE TRIGGER count_client_product_units_guard
BEFORE INSERT OR UPDATE OF client_id,client_barcode,base_unit_override,units_override ON public.count_client_products
FOR EACH ROW EXECUTE FUNCTION counting_private.validate_client_product_units();

CREATE UNIQUE INDEX IF NOT EXISTS count_catalog_products_sku_ci_uq
  ON public.count_catalog_products (lower(btrim(canonical_sku)))
  WHERE canonical_sku IS NOT NULL AND btrim(canonical_sku)<>'';
CREATE UNIQUE INDEX IF NOT EXISTS count_catalog_products_barcode_ci_uq
  ON public.count_catalog_products (lower(btrim(barcode)))
  WHERE barcode IS NOT NULL AND btrim(barcode)<>'';
CREATE INDEX IF NOT EXISTS count_products_units_barcode_gin_idx
  ON public.count_products USING gin (units jsonb_path_ops);

CREATE OR REPLACE FUNCTION counting_private.set_count_entry_unit_factor()
RETURNS trigger LANGUAGE plpgsql SET search_path TO ''
AS $function$
DECLARE v_factor numeric; v_units jsonb; v_meta jsonb; v_precision integer:=3; v_precision_text text; v_base_unit text;
BEGIN
  v_factor:=counting_private.unit_factor_to_base(NEW.product_id,NEW.unit);
  IF v_factor IS NULL THEN
    RAISE EXCEPTION 'UNIT_CONVERSION_REQUIRED: define a positive factor_to_base for every non-base unit';
  END IF;
  SELECT units,base_unit INTO v_units,v_base_unit FROM public.count_products WHERE id=NEW.product_id;
  SELECT value INTO v_meta FROM jsonb_array_elements(coalesce(v_units,'[]'::jsonb)) AS x(value)
  WHERE value->>'__countflow_unit_meta'='true' LIMIT 1;
  v_precision_text:=v_meta->>'decimal_precision';
  IF v_precision_text ~ '^[0-6]$' THEN v_precision:=v_precision_text::integer;
  ELSIF counting_private.infer_item_unit_class(v_base_unit)='count' THEN v_precision:=0;
  END IF;
  IF NEW.quantity IS NULL OR NEW.quantity<0 OR NEW.quantity<>round(NEW.quantity,v_precision) THEN
    RAISE EXCEPTION 'QUANTITY_PRECISION_EXCEEDED: item allows at most % decimal places',v_precision;
  END IF;
  NEW.unit_factor_to_base:=v_factor;
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS count_entries_unit_conversion_guard ON public.count_entries;
CREATE TRIGGER count_entries_unit_conversion_guard
BEFORE INSERT OR UPDATE OF product_id,quantity,unit ON public.count_entries
FOR EACH ROW EXECUTE FUNCTION counting_private.set_count_entry_unit_factor();
REVOKE ALL ON FUNCTION counting_private.set_count_entry_unit_factor() FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION counting_private.set_count_entry_unit_factor() TO authenticated;

CREATE OR REPLACE FUNCTION public.count_upsert_catalog_products_chunk(p_rows jsonb)
RETURNS jsonb LANGUAGE plpgsql SECURITY INVOKER SET search_path TO ''
AS $function$
DECLARE
  v_row jsonb; v_row_number integer; v_sku text; v_barcode text; v_name text; v_brand text;
  v_category text; v_base_unit text; v_units jsonb; v_source_reference text; v_matches uuid[];
  v_match_count integer; v_product_id uuid; v_inserted integer:=0; v_updated integer:=0;
  v_rejected integer:=0; v_errors jsonb:='[]'::jsonb; v_error text; v_row_number_text text;
BEGIN
  IF (SELECT auth.uid()) IS NULL OR NOT counting_private.is_platform_owner() THEN RAISE EXCEPTION 'PLATFORM_OWNER_REQUIRED'; END IF;
  IF jsonb_typeof(p_rows)<>'array' OR jsonb_array_length(p_rows)<1 OR jsonb_array_length(p_rows)>500 THEN
    RAISE EXCEPTION 'CATALOG_IMPORT_CHUNK_MUST_CONTAIN_1_TO_500_ROWS';
  END IF;
  FOR v_row IN SELECT value FROM jsonb_array_elements(p_rows) AS x(value) LOOP
    v_error:=NULL; v_row_number:=0; v_row_number_text:=v_row->>'_row_number';
    IF v_row_number_text ~ '^[0-9]+$' THEN v_row_number:=v_row_number_text::integer; END IF;
    v_sku:=nullif(btrim(v_row->>'canonical_sku'),''); v_barcode:=nullif(btrim(v_row->>'barcode'),'');
    v_name:=nullif(btrim(v_row->>'name'),''); v_brand:=nullif(btrim(v_row->>'brand'),'');
    v_category:=nullif(btrim(v_row->>'category'),''); v_base_unit:=nullif(btrim(v_row->>'base_unit'),'');
    v_units:=CASE WHEN jsonb_typeof(v_row->'units')='array' THEN v_row->'units' ELSE '[]'::jsonb END;
    v_source_reference:=nullif(btrim(v_row->>'source_reference'),'');
    IF jsonb_typeof(v_row)<>'object' THEN v_error:='INVALID_ROW_SHAPE';
    ELSIF v_name IS NULL THEN v_error:='PRODUCT_NAME_REQUIRED';
    ELSIF length(v_name)>240 THEN v_error:='PRODUCT_NAME_TOO_LONG';
    ELSIF v_base_unit IS NULL OR length(v_base_unit)>40 THEN v_error:='PRODUCT_BASE_UNIT_REQUIRED';
    END IF;
    IF v_error IS NULL THEN
      BEGIN
        SELECT array_agg(p.id ORDER BY p.id) INTO v_matches
        FROM public.count_catalog_products p
        WHERE (v_sku IS NOT NULL AND lower(btrim(p.canonical_sku))=lower(v_sku))
           OR (v_barcode IS NOT NULL AND lower(btrim(p.barcode))=lower(v_barcode));
        v_match_count:=coalesce(array_length(v_matches,1),0);
        IF v_match_count>1 THEN
          RAISE EXCEPTION 'PRODUCT_IDENTITY_MATCHES_MULTIPLE_CATALOG_ROWS';
        ELSIF v_match_count=1 THEN
          UPDATE public.count_catalog_products
          SET canonical_sku=coalesce(v_sku,canonical_sku),barcode=coalesce(v_barcode,barcode),
              name=v_name,brand=coalesce(v_brand,brand),category=coalesce(v_category,category),
              base_unit=v_base_unit,units=v_units,source_reference=coalesce(v_source_reference,source_reference),
              updated_by=(SELECT auth.uid()),updated_at=now()
          WHERE id=v_matches[1] RETURNING id INTO v_product_id;
          v_updated:=v_updated+1;
        ELSE
          INSERT INTO public.count_catalog_products(
            canonical_sku,barcode,name,brand,category,base_unit,units,source_type,source_reference,
            is_active,created_by,updated_by
          ) VALUES (
            v_sku,v_barcode,v_name,v_brand,v_category,v_base_unit,v_units,'verified_import',v_source_reference,
            true,(SELECT auth.uid()),(SELECT auth.uid())
          ) RETURNING id INTO v_product_id;
          v_inserted:=v_inserted+1;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
      END;
    END IF;
    IF v_error IS NOT NULL THEN
      v_rejected:=v_rejected+1;
      IF jsonb_array_length(v_errors)<20 THEN
        v_errors:=v_errors||jsonb_build_array(jsonb_build_object(
          'row_number',v_row_number,'sku',coalesce(v_sku,''),'barcode',coalesce(v_barcode,''),'error',v_error
        ));
      END IF;
    END IF;
  END LOOP;
  RETURN jsonb_build_object('processed',jsonb_array_length(p_rows),'inserted',v_inserted,'updated',v_updated,'rejected',v_rejected,'errors',v_errors);
END;
$function$;

REVOKE ALL ON FUNCTION public.count_upsert_catalog_products_chunk(jsonb) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_upsert_catalog_products_chunk(jsonb) TO authenticated;
