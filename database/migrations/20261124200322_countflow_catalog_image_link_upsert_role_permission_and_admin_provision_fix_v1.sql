
BEGIN;

CREATE OR REPLACE FUNCTION public.count_update_role_permissions(
 p_role_id uuid,
 p_permission_codes text[]
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
 v_role public.count_roles;
 v_invalid text[];
 v_count integer;
BEGIN
 SELECT * INTO v_role FROM public.count_roles r WHERE r.id=p_role_id;
 IF NOT FOUND OR v_role.client_id IS NULL OR v_role.is_system OR NOT v_role.is_active THEN
   RAISE EXCEPTION 'CUSTOM_CLIENT_ROLE_NOT_FOUND_OR_NOT_EDITABLE';
 END IF;
 IF NOT counting_private.has_client_permission(v_role.client_id,'role.manage') THEN
   RAISE EXCEPTION 'ROLE_MANAGE_PERMISSION_REQUIRED';
 END IF;
 SELECT array_agg(x.code) INTO v_invalid
 FROM (SELECT DISTINCT unnest(coalesce(p_permission_codes,ARRAY[]::text[])) AS code) x
 LEFT JOIN public.count_permissions p ON p.code=x.code
 WHERE p.code IS NULL
    OR p.scope='platform'
    OR (v_role.scope='project' AND p.scope<>'project')
    OR (p.code IN ('client.members.manage','client.manage','role.manage')
        AND NOT counting_private.is_platform_owner());
 IF v_invalid IS NOT NULL THEN
   RAISE EXCEPTION 'INVALID_OR_ESCALATED_ROLE_PERMISSIONS:%',array_to_string(v_invalid,',');
 END IF;
 DELETE FROM public.count_role_permissions WHERE role_id=p_role_id;
 INSERT INTO public.count_role_permissions(role_id,permission_code)
 SELECT p_role_id,x.code
 FROM (SELECT DISTINCT unnest(coalesce(p_permission_codes,ARRAY[]::text[])) AS code) x;
 GET DIAGNOSTICS v_count=ROW_COUNT;
 UPDATE public.count_roles SET updated_by=(SELECT auth.uid()) WHERE id=p_role_id;
 RETURN jsonb_build_object('role_id',p_role_id,'permission_count',v_count);
END;
$$;

CREATE OR REPLACE FUNCTION counting_private.is_valid_product_image_reference(
 p_project_id uuid,
 p_reference text,
 p_require_storage_object boolean DEFAULT false
)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
 v_reference text;
 v_prefix text;
 v_filename text;
 v_host text;
BEGIN
 IF p_reference IS NULL OR p_reference='' THEN RETURN true; END IF;
 IF p_project_id IS NULL THEN RETURN false; END IF;
 v_reference:=btrim(p_reference);
 IF v_reference<>p_reference OR length(v_reference)>2048
    OR v_reference ~ '[[:space:]]' OR strpos(v_reference,chr(92))>0 THEN
   RETURN false;
 END IF;

 IF v_reference ~* '^https://' THEN
   IF v_reference ~* '/storage/v1/object/sign/'
      OR v_reference ~* '[?&](token|expiresin)=' THEN RETURN false; END IF;
   v_host:=split_part(split_part(split_part(v_reference,'/',3),'?','1'),'#',1);
   IF v_host='' OR strpos(v_host,'@')>0
      OR v_host !~ '^[A-Za-z0-9.-]+(:[0-9]{1,5})?$' THEN RETURN false; END IF;
   RETURN true;
 END IF;

 IF v_reference ~* '^[a-z][a-z0-9+.-]*://' THEN RETURN false; END IF;

 -- Global catalog images are reusable only when the product is explicitly linked
 -- to this project through the matching client mapping.
 IF v_reference ~ '^catalog/products/[0-9a-fA-F-]{36}/[A-Za-z0-9][A-Za-z0-9._-]{0,180}$' THEN
   IF NOT p_require_storage_object THEN
     RETURN EXISTS(
       SELECT 1
       FROM public.count_products p
       JOIN public.count_projects pr ON pr.id=p.project_id
       JOIN public.count_client_products cp ON cp.id=p.client_product_id
         AND cp.client_id=pr.client_id AND cp.catalog_product_id=p.catalog_product_id
       JOIN public.count_catalog_products c ON c.id=p.catalog_product_id
         AND c.id::text=split_part(split_part(v_reference,'/',3), '/',1)
         AND c.image_storage_path=v_reference AND c.is_active
       WHERE p.project_id=p_project_id AND p.image_url=v_reference AND cp.is_active
     );
   END IF;
   RETURN EXISTS(
     SELECT 1
     FROM public.count_products p
     JOIN public.count_projects pr ON pr.id=p.project_id
     JOIN public.count_client_products cp ON cp.id=p.client_product_id
       AND cp.client_id=pr.client_id AND cp.catalog_product_id=p.catalog_product_id
     JOIN public.count_catalog_products c ON c.id=p.catalog_product_id
       AND c.image_storage_path=v_reference AND c.is_active
     JOIN storage.objects o ON o.bucket_id='counting-product-images' AND o.name=v_reference
     WHERE p.project_id=p_project_id AND p.image_url=v_reference AND cp.is_active
       AND o.metadata->>'mimetype' IN ('image/jpeg','image/png','image/webp')
       AND CASE WHEN coalesce(o.metadata->>'size','') ~ '^[0-9]+$'
         THEN (o.metadata->>'size')::bigint BETWEEN 1 AND 5242880 ELSE false END
   );
 END IF;

 v_prefix:=p_project_id::text||'/products/';
 IF left(v_reference,length(v_prefix))<>v_prefix THEN RETURN false; END IF;
 v_filename:=substr(v_reference,length(v_prefix)+1);
 IF v_filename !~ '^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$' THEN RETURN false; END IF;
 IF NOT p_require_storage_object THEN RETURN true; END IF;
 RETURN EXISTS(
   SELECT 1 FROM storage.objects o
   WHERE o.bucket_id='counting-product-images'
     AND o.name=v_reference
     AND o.metadata->>'mimetype' IN ('image/jpeg','image/png')
     AND CASE WHEN coalesce(o.metadata->>'size','') ~ '^[0-9]+$'
       THEN (o.metadata->>'size')::bigint BETWEEN 1 AND 1048576 ELSE false END
 );
END;
$$;

CREATE OR REPLACE FUNCTION counting_private.count_attach_catalog_product_impl(
 p_project_id uuid,
 p_client_product_id uuid,
 p_expected_qty numeric
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
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
 SELECT p.client_id INTO v_client_id FROM public.count_projects p WHERE p.id=p_project_id;
 IF NOT FOUND OR v_client_id IS NULL THEN RAISE EXCEPTION 'PROJECT_CLIENT_SCOPE_REQUIRED'; END IF;
 IF NOT (counting_private.has_project_permission(p_project_id,'catalog.attach')
   OR counting_private.has_client_permission(v_client_id,'catalog.manage')) THEN
   RAISE EXCEPTION 'CATALOG_ATTACH_PERMISSION_REQUIRED';
 END IF;
 SELECT * INTO v_cp FROM public.count_client_products cp
 WHERE cp.id=p_client_product_id AND cp.client_id=v_client_id AND cp.is_active;
 IF NOT FOUND THEN RAISE EXCEPTION 'CLIENT_PRODUCT_NOT_FOUND_OR_INACTIVE'; END IF;
 SELECT * INTO v_cat FROM public.count_catalog_products c WHERE c.id=v_cp.catalog_product_id AND c.is_active;
 IF NOT FOUND THEN RAISE EXCEPTION 'CATALOG_PRODUCT_NOT_FOUND_OR_INACTIVE'; END IF;
 v_sku:=coalesce(nullif(v_cp.client_sku,''),nullif(v_cat.canonical_sku,''));
 v_barcode:=coalesce(nullif(v_cp.client_barcode,''),nullif(v_cat.barcode,''));
 v_name:=coalesce(nullif(v_cp.name_override,''),v_cat.name);
 v_category:=coalesce(nullif(v_cp.category_override,''),v_cat.category);
 v_unit:=coalesce(nullif(v_cp.base_unit_override,''),v_cat.base_unit);
 v_units:=coalesce(v_cp.units_override,v_cat.units,'[]'::jsonb);
 IF v_sku IS NULL AND v_barcode IS NULL THEN RAISE EXCEPTION 'CATALOG_PRODUCT_REQUIRES_SKU_OR_BARCODE'; END IF;

 SELECT * INTO v_existing FROM public.count_products p
 WHERE p.project_id=p_project_id
   AND ((v_sku IS NOT NULL AND lower(p.sku)=lower(v_sku))
     OR (v_barcode IS NOT NULL AND lower(p.barcode)=lower(v_barcode)))
 ORDER BY p.created_at LIMIT 1 FOR UPDATE;
 IF FOUND THEN
   IF v_existing.client_product_id=p_client_product_id AND v_existing.catalog_product_id=v_cat.id THEN
     RETURN jsonb_build_object('product_id',v_existing.id,'already_linked',true,'catalog_product_id',v_cat.id);
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
 RETURN jsonb_build_object('product_id',v_product_id,'already_linked',false,'catalog_product_id',v_cat.id);
END;
$$;

CREATE OR REPLACE FUNCTION public.count_upsert_client_product(
 p_client_id uuid,
 p_catalog_product_id uuid,
 p_client_sku text DEFAULT NULL,
 p_client_barcode text DEFAULT NULL,
 p_name_override text DEFAULT NULL,
 p_category_override text DEFAULT NULL,
 p_base_unit_override text DEFAULT NULL,
 p_units_override jsonb DEFAULT NULL,
 p_image_storage_path_override text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE v_id uuid;
BEGIN
 IF NOT counting_private.has_client_permission(p_client_id,'catalog.manage') THEN
   RAISE EXCEPTION 'CLIENT_CATALOG_MANAGE_PERMISSION_REQUIRED';
 END IF;
 INSERT INTO public.count_client_products(
   client_id,catalog_product_id,client_sku,client_barcode,name_override,
   category_override,base_unit_override,units_override,image_storage_path_override,
   is_active,created_by
 )
 VALUES (
   p_client_id,p_catalog_product_id,nullif(btrim(p_client_sku),''),nullif(btrim(p_client_barcode),''),
   nullif(btrim(p_name_override),''),nullif(btrim(p_category_override),''),
   nullif(btrim(p_base_unit_override),''),p_units_override,
   nullif(btrim(p_image_storage_path_override),''),true,(SELECT auth.uid())
 )
 ON CONFLICT(client_id,catalog_product_id) DO UPDATE SET
   client_sku=EXCLUDED.client_sku,
   client_barcode=EXCLUDED.client_barcode,
   name_override=EXCLUDED.name_override,
   category_override=EXCLUDED.category_override,
   base_unit_override=EXCLUDED.base_unit_override,
   units_override=EXCLUDED.units_override,
   image_storage_path_override=EXCLUDED.image_storage_path_override,
   is_active=true,
   updated_by=(SELECT auth.uid()),
   updated_at=now()
 RETURNING id INTO v_id;
 RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION counting_private.guard_count_client_member()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE v_scope text; v_role_client uuid; v_role_key text; v_trusted_service boolean;
BEGIN
 v_trusted_service:=coalesce((SELECT auth.role()),'')='service_role';
 IF counting_private.is_platform_owner_actor(NEW.user_id) THEN
   RAISE EXCEPTION 'PLATFORM_OWNER_CANNOT_BE_CLIENT_MEMBER';
 END IF;
 SELECT r.scope,r.client_id,r.role_key INTO v_scope,v_role_client,v_role_key
 FROM public.count_roles r WHERE r.id=NEW.role_id AND r.is_active;
 IF NOT FOUND OR v_scope<>'client' THEN RAISE EXCEPTION 'CLIENT_MEMBERSHIP_REQUIRES_ACTIVE_CLIENT_ROLE'; END IF;
 IF v_role_client IS NOT NULL AND v_role_client IS DISTINCT FROM NEW.client_id THEN RAISE EXCEPTION 'CLIENT_ROLE_SCOPE_MISMATCH'; END IF;
 IF v_role_key='client_admin' AND NOT (counting_private.is_platform_owner() OR v_trusted_service) THEN
   RAISE EXCEPTION 'ONLY_PLATFORM_OWNER_CAN_PROVISION_CLIENT_ADMIN';
 END IF;
 RETURN NEW;
END;
$$;

DROP POLICY IF EXISTS count_client_audit_insert ON public.count_client_audit_log;
CREATE POLICY count_client_audit_insert ON public.count_client_audit_log
FOR INSERT TO authenticated
WITH CHECK (
 actor_id=(SELECT auth.uid())
 AND counting_private.is_platform_owner()
);
GRANT INSERT(client_id,actor_id,action,entity_type,entity_id,details)
 ON public.count_client_audit_log TO authenticated;

REVOKE ALL ON FUNCTION public.count_upsert_client_product(uuid,uuid,text,text,text,text,text,jsonb,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_upsert_client_product(uuid,uuid,text,text,text,text,text,jsonb,text) TO authenticated,service_role;

COMMIT;
