-- LVE-765 integrity: enforce existence/type/size match for every shelf-photo register row.
-- Permit Storage rollback only for the current counter's own unregistered upload.

CREATE OR REPLACE FUNCTION counting_private.enforce_count_shelf_image_storage_reference()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_metadata jsonb;
  v_size bigint;
BEGIN
  SELECT o.metadata INTO v_metadata
  FROM storage.objects o
  WHERE o.bucket_id='shelf-images'
    AND o.name=NEW.storage_path;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE='23514', MESSAGE='SHELF_IMAGE_STORAGE_OBJECT_MISSING';
  END IF;
  IF v_metadata->>'mimetype' IS DISTINCT FROM NEW.mime_type THEN
    RAISE EXCEPTION USING ERRCODE='23514', MESSAGE='SHELF_IMAGE_STORAGE_MIME_MISMATCH';
  END IF;
  IF coalesce(v_metadata->>'size','') !~ '^[0-9]+$' THEN
    RAISE EXCEPTION USING ERRCODE='23514', MESSAGE='SHELF_IMAGE_STORAGE_SIZE_INVALID';
  END IF;
  v_size := (v_metadata->>'size')::bigint;
  IF v_size <> NEW.size_bytes OR v_size NOT BETWEEN 1 AND 10485760 THEN
    RAISE EXCEPTION USING ERRCODE='23514', MESSAGE='SHELF_IMAGE_STORAGE_SIZE_MISMATCH';
  END IF;
  RETURN NEW;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.enforce_count_shelf_image_storage_reference()
  FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS count_shelf_images_storage_guard ON public.count_shelf_images;
CREATE TRIGGER count_shelf_images_storage_guard
BEFORE INSERT ON public.count_shelf_images
FOR EACH ROW
EXECUTE FUNCTION counting_private.enforce_count_shelf_image_storage_reference();

COMMENT ON FUNCTION counting_private.enforce_count_shelf_image_storage_reference()
IS 'Ensures each shelf-photo register row points to an existing shelf-images Storage object with matching MIME and byte size.';

DROP POLICY IF EXISTS shelf_images_counter_delete_unregistered_own ON storage.objects;
CREATE POLICY shelf_images_counter_delete_unregistered_own
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id='shelf-images'
  AND CASE
    WHEN cardinality(storage.foldername(objects.name))=4
      AND (storage.foldername(objects.name))[1] ~* '^[0-9a-f-]{36}$'
      AND (storage.foldername(objects.name))[2] ~* '^[0-9a-f-]{36}$'
      AND (storage.foldername(objects.name))[3] ~* '^[0-9a-f-]{36}$'
      AND (storage.foldername(objects.name))[4] ~* '^[0-9a-f-]{36}$'
      AND split_part(objects.name,'/',5) ~ '^shelf-[0-9]{13}-[0-9a-f-]{36}\.(jpg|png|webp)$'
    THEN EXISTS (
      SELECT 1
      FROM public.count_members m
      JOIN public.count_sessions s
        ON s.id=((storage.foldername(objects.name))[2])::uuid
       AND s.project_id=m.project_id
      JOIN public.count_locations l
        ON l.id=((storage.foldername(objects.name))[4])::uuid
       AND l.project_id=m.project_id
      WHERE m.id=((storage.foldername(objects.name))[3])::uuid
        AND m.project_id=((storage.foldername(objects.name))[1])::uuid
        AND m.user_id=(SELECT auth.uid())
        AND m.role='counter'
        AND m.status IN ('active','paused')
        AND (
          NOT counting_private.session_has_assignments(s.id)
          OR counting_private.member_has_location_assignment(s.id,m.id,l.id)
        )
        AND NOT EXISTS (
          SELECT 1 FROM public.count_shelf_images i
          WHERE i.storage_path=objects.name
        )
    )
    ELSE false
  END
);

COMMENT ON POLICY shelf_images_counter_delete_unregistered_own ON storage.objects IS
  'Allows a counter to roll back only their own unregistered shelf-image upload; images already registered for review cannot be deleted by a client.';
