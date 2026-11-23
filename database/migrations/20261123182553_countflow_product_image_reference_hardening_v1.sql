-- CountFlow: enforce safe, project-owned product image references end-to-end.
-- Product image references are either safe HTTPS URLs or one object under:
--   <project UUID>/products/<filename>
-- Private Storage remains private. No Storage metadata rows are written here.

CREATE OR REPLACE FUNCTION counting_private.is_valid_product_image_reference(
  p_project_id uuid,
  p_reference text,
  p_require_storage_object boolean DEFAULT false
)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_reference text;
  v_prefix text;
  v_filename text;
  v_host text;
BEGIN
  IF p_reference IS NULL OR p_reference = '' THEN RETURN true; END IF;
  IF p_project_id IS NULL THEN RETURN false; END IF;

  v_reference := btrim(p_reference);
  IF v_reference <> p_reference
     OR length(v_reference) > 2048
     OR v_reference ~ '[[:space:]]'
     OR strpos(v_reference, chr(92)) > 0 THEN
    RETURN false;
  END IF;

  IF v_reference ~* '^https://' THEN
    v_host := split_part(split_part(split_part(v_reference, '/', 3), '?', 1), '#', 1);
    IF v_host = ''
       OR strpos(v_host, '@') > 0
       OR v_host !~ '^[A-Za-z0-9.-]+(:[0-9]{1,5})?$' THEN
      RETURN false;
    END IF;
    RETURN true;
  END IF;

  IF v_reference ~* '^[a-z][a-z0-9+.-]*://' THEN RETURN false; END IF;

  v_prefix := p_project_id::text || '/products/';
  IF left(v_reference, length(v_prefix)) <> v_prefix THEN RETURN false; END IF;
  v_filename := substr(v_reference, length(v_prefix) + 1);
  IF v_filename !~ '^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$' THEN RETURN false; END IF;

  IF NOT p_require_storage_object THEN RETURN true; END IF;

  RETURN EXISTS (
    SELECT 1
    FROM storage.objects o
    WHERE o.bucket_id = 'counting-product-images'
      AND o.name = v_reference
      AND o.metadata->>'mimetype' IN ('image/jpeg','image/png')
      AND CASE
        WHEN coalesce(o.metadata->>'size','') ~ '^[0-9]+$'
          THEN (o.metadata->>'size')::bigint BETWEEN 1 AND 1048576
        ELSE false
      END
  );
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.is_valid_product_image_reference(uuid,text,boolean)
  FROM PUBLIC, anon, authenticated;

ALTER POLICY count_image_read ON storage.objects
USING (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=2
  AND (storage.foldername(name))[2]='products'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (SELECT 1 FROM public.count_projects p WHERE p.id::text=(storage.foldername(name))[1])
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(name))[1]
        AND m.status IN ('active','paused')
    )
  )
);

ALTER POLICY count_image_upload ON storage.objects
WITH CHECK (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=2
  AND (storage.foldername(name))[2]='products'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (SELECT 1 FROM public.count_projects p WHERE p.id::text=(storage.foldername(name))[1])
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(name))[1]
        AND m.role='supervisor'
        AND m.status='active'
    )
  )
);

ALTER POLICY count_image_update ON storage.objects
USING (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=2
  AND (storage.foldername(name))[2]='products'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (SELECT 1 FROM public.count_projects p WHERE p.id::text=(storage.foldername(name))[1])
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(name))[1]
        AND m.role='supervisor'
        AND m.status='active'
    )
  )
)
WITH CHECK (
  bucket_id='counting-product-images'
  AND cardinality(storage.foldername(name))=2
  AND (storage.foldername(name))[2]='products'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (SELECT 1 FROM public.count_projects p WHERE p.id::text=(storage.foldername(name))[1])
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(name))[1]
        AND m.role='supervisor'
        AND m.status='active'
    )
  )
);

DO $countflow_image_import_validation$
DECLARE
  v_oid regprocedure;
  v_definition text;
  v_updated text;
  v_anchor text;
BEGIN
  v_oid := to_regprocedure('counting_private.count_stage_import_rows_impl(uuid,jsonb,integer)');
  IF v_oid IS NULL THEN RAISE EXCEPTION 'COUNT_STAGE_IMPORT_IMPL_MISSING'; END IF;
  v_definition := pg_get_functiondef(v_oid::oid);
  v_anchor := $old$
      IF v_image_url IS NOT NULL AND (
        length(v_image_url) > 2048
        OR (v_image_url ~* '^[a-z][a-z0-9+.-]*://' AND v_image_url !~* '^https://')
        OR v_image_url LIKE '/%'
        OR v_image_url LIKE '%..%'
      ) THEN
        v_errors := array_append(v_errors,'INVALID_IMAGE_REFERENCE');
      END IF;
$old$;
  v_updated := replace(v_definition,v_anchor,$new$
      IF v_image_url IS NOT NULL
         AND NOT counting_private.is_valid_product_image_reference(v_batch.project_id,v_image_url,false) THEN
        v_errors := array_append(v_errors,'INVALID_IMAGE_REFERENCE');
      END IF;
$new$);
  IF v_updated = v_definition THEN RAISE EXCEPTION 'COUNT_STAGE_IMPORT_IMAGE_VALIDATION_ANCHOR_NOT_FOUND'; END IF;
  EXECUTE v_updated;

  v_oid := to_regprocedure('counting_private.count_commit_import_batch_impl(uuid)');
  IF v_oid IS NULL THEN RAISE EXCEPTION 'COUNT_COMMIT_IMPORT_IMPL_MISSING'; END IF;
  v_definition := pg_get_functiondef(v_oid::oid);
  v_anchor := $old$
    ELSIF v_image_url IS NOT NULL AND (
      length(v_image_url)>2048
      OR (v_image_url ~* '^[a-z][a-z0-9+.-]*://' AND v_image_url !~* '^https://')
      OR v_image_url LIKE '/%'
      OR v_image_url LIKE '%..%'
    ) THEN
      v_error := 'INVALID_IMAGE_REFERENCE';
$old$;
  v_updated := replace(v_definition,v_anchor,$new$
    ELSIF v_image_url IS NOT NULL
       AND NOT counting_private.is_valid_product_image_reference(v_batch.project_id,v_image_url,true) THEN
      v_error := 'INVALID_IMAGE_REFERENCE';
$new$);
  IF v_updated = v_definition THEN RAISE EXCEPTION 'COUNT_COMMIT_IMPORT_IMAGE_VALIDATION_ANCHOR_NOT_FOUND'; END IF;
  EXECUTE v_updated;
END;
$countflow_image_import_validation$;

CREATE OR REPLACE FUNCTION counting_private.enforce_count_product_image_reference()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
BEGIN
  NEW.image_url := nullif(btrim(NEW.image_url),'');
  IF NOT counting_private.is_valid_product_image_reference(NEW.project_id,NEW.image_url,true) THEN
    RAISE EXCEPTION USING ERRCODE='23514', MESSAGE='INVALID_PRODUCT_IMAGE_REFERENCE';
  END IF;
  RETURN NEW;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.enforce_count_product_image_reference()
  FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS count_products_product_image_reference_guard ON public.count_products;
CREATE TRIGGER count_products_product_image_reference_guard
BEFORE INSERT OR UPDATE OF project_id,image_url
ON public.count_products
FOR EACH ROW
EXECUTE FUNCTION counting_private.enforce_count_product_image_reference();

COMMENT ON FUNCTION counting_private.is_valid_product_image_reference(uuid,text,boolean)
IS 'Validates CountFlow product image references: HTTPS external URL or a safe same-project products object; optional object existence/type/size check.';
COMMENT ON FUNCTION counting_private.enforce_count_product_image_reference()
IS 'Rejects invalid, cross-project, missing, unsupported or oversized private product-image references before catalog persistence.';
COMMENT ON POLICY count_image_read ON storage.objects
IS 'Private CountFlow product images: only objects at <project>/products/<filename> are visible to platform owner and active/paused project members.';
COMMENT ON POLICY count_image_upload ON storage.objects
IS 'Private CountFlow product images: owner or active supervisor can upload only to <project>/products/<filename>.';
COMMENT ON POLICY count_image_update ON storage.objects
IS 'Private CountFlow product images: owner or active supervisor can update only objects at <project>/products/<filename>.';
