
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
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE v_id uuid;
BEGIN
 IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
 IF NOT counting_private.has_client_permission(p_client_id,'catalog.manage') THEN
   RAISE EXCEPTION 'CLIENT_CATALOG_MANAGE_PERMISSION_REQUIRED';
 END IF;
 IF NOT EXISTS(SELECT 1 FROM public.count_clients c WHERE c.id=p_client_id AND c.status='active') THEN
   RAISE EXCEPTION 'CLIENT_NOT_FOUND_OR_INACTIVE';
 END IF;
 IF NOT EXISTS(SELECT 1 FROM public.count_catalog_products c WHERE c.id=p_catalog_product_id AND c.is_active) THEN
   RAISE EXCEPTION 'CATALOG_PRODUCT_NOT_FOUND_OR_INACTIVE';
 END IF;
 IF p_units_override IS NOT NULL AND jsonb_typeof(p_units_override)<>'array' THEN
   RAISE EXCEPTION 'UNITS_OVERRIDE_MUST_BE_ARRAY';
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
REVOKE ALL ON FUNCTION public.count_upsert_client_product(uuid,uuid,text,text,text,text,text,jsonb,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_upsert_client_product(uuid,uuid,text,text,text,text,text,jsonb,text) TO authenticated,service_role;
