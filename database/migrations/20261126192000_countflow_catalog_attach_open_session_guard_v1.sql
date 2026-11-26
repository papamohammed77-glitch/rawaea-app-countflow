-- Defense-in-depth for catalog attachment: project item membership is not changed
-- while a count session is active, paused, or awaiting review.
-- This is not an inventory posting; expected_qty remains caller supplied (UI passes NULL).

CREATE OR REPLACE FUNCTION counting_private.count_attach_catalog_product_impl(
  p_project_id uuid,
  p_client_product_id uuid,
  p_expected_qty numeric
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
 v_client_id uuid;
 v_cp public.count_client_products;
 v_cat public.count_catalog_products;
 v_sku text;
 v_barcode text;
 v_name text;
 v_category text;
 v_unit text;
 v_units jsonb;
 v_existing public.count_products;
 v_product_id uuid;
BEGIN
 SELECT p.client_id INTO v_client_id
 FROM public.count_projects p
 WHERE p.id=p_project_id
 FOR UPDATE;

 IF NOT FOUND OR v_client_id IS NULL THEN
   RAISE EXCEPTION 'PROJECT_CLIENT_SCOPE_REQUIRED';
 END IF;

 IF NOT (
   counting_private.has_project_permission(p_project_id,'catalog.attach')
   OR counting_private.has_client_permission(v_client_id,'catalog.manage')
 ) THEN
   RAISE EXCEPTION 'CATALOG_ATTACH_PERMISSION_REQUIRED';
 END IF;

 IF EXISTS (
   SELECT 1
   FROM public.count_sessions s
   WHERE s.project_id=p_project_id
     AND s.status IN ('active','paused','review')
 ) THEN
   RAISE EXCEPTION 'PROJECT_CATALOG_ATTACHMENT_BLOCKED_DURING_OPEN_SESSION';
 END IF;

 SELECT * INTO v_cp
 FROM public.count_client_products cp
 WHERE cp.id=p_client_product_id
   AND cp.client_id=v_client_id
   AND cp.is_active;
 IF NOT FOUND THEN
   RAISE EXCEPTION 'CLIENT_PRODUCT_NOT_FOUND_OR_INACTIVE';
 END IF;

 SELECT * INTO v_cat
 FROM public.count_catalog_products c
 WHERE c.id=v_cp.catalog_product_id
   AND c.is_active;
 IF NOT FOUND THEN
   RAISE EXCEPTION 'CATALOG_PRODUCT_NOT_FOUND_OR_INACTIVE';
 END IF;

 v_sku:=coalesce(nullif(v_cp.client_sku,''),nullif(v_cat.canonical_sku,''));
 v_barcode:=coalesce(nullif(v_cp.client_barcode,''),nullif(v_cat.barcode,''));
 v_name:=coalesce(nullif(v_cp.name_override,''),v_cat.name);
 v_category:=coalesce(nullif(v_cp.category_override,''),v_cat.category);
 v_unit:=coalesce(nullif(v_cp.base_unit_override,''),v_cat.base_unit);
 v_units:=coalesce(v_cp.units_override,v_cat.units,'[]'::jsonb);

 IF v_sku IS NULL AND v_barcode IS NULL THEN
   RAISE EXCEPTION 'CATALOG_PRODUCT_REQUIRES_SKU_OR_BARCODE';
 END IF;

 SELECT * INTO v_existing
 FROM public.count_products p
 WHERE p.project_id=p_project_id
   AND (
     (v_sku IS NOT NULL AND lower(p.sku)=lower(v_sku))
     OR (v_barcode IS NOT NULL AND lower(p.barcode)=lower(v_barcode))
   )
 ORDER BY p.created_at
 LIMIT 1
 FOR UPDATE;

 IF FOUND THEN
   IF v_existing.client_product_id=p_client_product_id
      AND v_existing.catalog_product_id=v_cat.id THEN
     RETURN jsonb_build_object(
       'product_id',v_existing.id,
       'already_linked',true,
       'catalog_product_id',v_cat.id
     );
   END IF;
   RAISE EXCEPTION 'PROJECT_PRODUCT_IDENTITY_CONFLICT';
 END IF;

 INSERT INTO public.count_products(
   project_id,sku,barcode,name,category,base_unit,units,expected_qty,
   image_url,is_active,catalog_product_id,client_product_id
 )
 VALUES (
   p_project_id,v_sku,v_barcode,v_name,v_category,v_unit,v_units,p_expected_qty,
   v_cat.image_storage_path,true,v_cat.id,v_cp.id
 )
 RETURNING id INTO v_product_id;

 RETURN jsonb_build_object(
   'product_id',v_product_id,
   'already_linked',false,
   'catalog_product_id',v_cat.id
 );
END;
$function$;

COMMENT ON FUNCTION counting_private.count_attach_catalog_product_impl(uuid,uuid,numeric)
IS 'Attaches an active client catalog mapping to a client-scoped project only when no count session is active, paused, or in review; copies effective client/global UoM into project products and does not create any balance unless an explicit expected quantity is supplied.';
