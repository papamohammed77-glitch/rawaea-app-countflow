
BEGIN;

ALTER VIEW public.count_control_reconciliation_runs SET (security_invoker=true);
ALTER VIEW public.count_control_reconciliation_lines SET (security_invoker=true);

CREATE INDEX IF NOT EXISTS count_clients_created_by_idx
  ON public.count_clients(created_by);
CREATE INDEX IF NOT EXISTS count_catalog_products_created_by_idx
  ON public.count_catalog_products(created_by);
CREATE INDEX IF NOT EXISTS count_catalog_products_updated_by_idx
  ON public.count_catalog_products(updated_by);
CREATE INDEX IF NOT EXISTS count_client_members_created_by_idx
  ON public.count_client_members(created_by);
CREATE INDEX IF NOT EXISTS count_client_products_created_by_idx
  ON public.count_client_products(created_by);
CREATE INDEX IF NOT EXISTS count_client_products_updated_by_idx
  ON public.count_client_products(updated_by);
CREATE INDEX IF NOT EXISTS count_roles_created_by_idx
  ON public.count_roles(created_by);
CREATE INDEX IF NOT EXISTS count_roles_updated_by_idx
  ON public.count_roles(updated_by);
CREATE INDEX IF NOT EXISTS count_products_client_product_fk_idx
  ON public.count_products(client_product_id) WHERE client_product_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS count_sessions_branch_project_fk_idx
  ON public.count_sessions(branch_location_id,project_id) WHERE branch_location_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS count_presence_queue_resolved_by_idx
  ON public.count_presence(queue_resolved_by) WHERE queue_resolved_by IS NOT NULL;
CREATE INDEX IF NOT EXISTS count_shelf_images_created_by_idx
  ON public.count_shelf_images(created_by) WHERE created_by IS NOT NULL;
CREATE INDEX IF NOT EXISTS count_shelf_images_member_id_idx
  ON public.count_shelf_images(member_id) WHERE member_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS count_shelf_images_session_id_idx
  ON public.count_shelf_images(session_id) WHERE session_id IS NOT NULL;

CREATE OR REPLACE FUNCTION counting_private.guard_count_catalog_product_image_path()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE v_path text; v_lower text;
BEGIN
  v_path:=nullif(btrim(NEW.image_storage_path),'');
  IF v_path IS NULL THEN
    NEW.image_storage_path:=NULL;
    RETURN NEW;
  END IF;
  v_lower:=lower(v_path);
  IF v_path !~ ('^catalog/products/'||NEW.id::text||'/[A-Za-z0-9][A-Za-z0-9._-]{0,180}$')
     OR v_lower ~ '(^|/)\.\.?(/|$)'
     OR v_lower !~ '\.(jpg|jpeg|png|webp)$'
     OR position('://' in v_path)>0 THEN
    RAISE EXCEPTION 'INVALID_GLOBAL_CATALOG_IMAGE_PATH';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS count_catalog_product_image_path_guard ON public.count_catalog_products;
CREATE TRIGGER count_catalog_product_image_path_guard
BEFORE INSERT OR UPDATE OF image_storage_path,id
ON public.count_catalog_products
FOR EACH ROW
EXECUTE FUNCTION counting_private.guard_count_catalog_product_image_path();

REVOKE ALL ON FUNCTION counting_private.guard_count_catalog_product_image_path() FROM PUBLIC,anon;

DROP POLICY IF EXISTS count_catalog_image_read ON storage.objects;
CREATE POLICY count_catalog_image_read
ON storage.objects
FOR SELECT TO authenticated
USING (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=3
  AND (storage.foldername(name))[1]='catalog'
  AND (storage.foldername(name))[2]='products'
  AND EXISTS (
    SELECT 1 FROM public.count_catalog_products cp
    WHERE cp.id::text=(storage.foldername(objects.name))[3]
      AND cp.image_storage_path=objects.name
      AND cp.is_active
  )
  AND counting_private.can_browse_catalog()
);

DROP POLICY IF EXISTS count_catalog_image_upload ON storage.objects;
CREATE POLICY count_catalog_image_upload
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=3
  AND (storage.foldername(name))[1]='catalog'
  AND (storage.foldername(name))[2]='products'
  AND counting_private.is_platform_owner()
  AND EXISTS (
    SELECT 1 FROM public.count_catalog_products cp
    WHERE cp.id::text=(storage.foldername(objects.name))[3]
  )
);

DROP POLICY IF EXISTS count_catalog_image_update ON storage.objects;
CREATE POLICY count_catalog_image_update
ON storage.objects
FOR UPDATE TO authenticated
USING (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=3
  AND (storage.foldername(name))[1]='catalog'
  AND (storage.foldername(name))[2]='products'
  AND counting_private.is_platform_owner()
  AND EXISTS (
    SELECT 1 FROM public.count_catalog_products cp
    WHERE cp.id::text=(storage.foldername(objects.name))[3]
  )
)
WITH CHECK (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=3
  AND (storage.foldername(name))[1]='catalog'
  AND (storage.foldername(name))[2]='products'
  AND counting_private.is_platform_owner()
  AND EXISTS (
    SELECT 1 FROM public.count_catalog_products cp
    WHERE cp.id::text=(storage.foldername(objects.name))[3]
  )
);

DROP POLICY IF EXISTS count_catalog_image_delete ON storage.objects;
CREATE POLICY count_catalog_image_delete
ON storage.objects
FOR DELETE TO authenticated
USING (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=3
  AND (storage.foldername(name))[1]='catalog'
  AND (storage.foldername(name))[2]='products'
  AND counting_private.is_platform_owner()
  AND EXISTS (
    SELECT 1 FROM public.count_catalog_products cp
    WHERE cp.id::text=(storage.foldername(objects.name))[3]
  )
);

COMMIT;
