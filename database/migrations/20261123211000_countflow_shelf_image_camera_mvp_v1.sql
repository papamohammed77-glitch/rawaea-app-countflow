-- LVE-765 Camera MVP: public shelf-photo delivery with project/session-scoped upload authorization.
INSERT INTO storage.buckets
  (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('shelf-images', 'shelf-images', true, 10485760,
   ARRAY['image/jpeg','image/png','image/webp']::text[])
ON CONFLICT (id) DO NOTHING;

DO $bucket_verify$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM storage.buckets b
    WHERE b.id='shelf-images'
      AND b.name='shelf-images'
      AND b.public IS TRUE
      AND b.file_size_limit=10485760
      AND b.allowed_mime_types=ARRAY['image/jpeg','image/png','image/webp']::text[]
  ) THEN
    RAISE EXCEPTION 'SHELF_IMAGES_BUCKET_CONFIGURATION_MISMATCH';
  END IF;
END;
$bucket_verify$;

CREATE TABLE IF NOT EXISTS public.count_shelf_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL REFERENCES public.count_projects(id) ON DELETE CASCADE,
  session_id uuid NOT NULL REFERENCES public.count_sessions(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES public.count_members(id) ON DELETE RESTRICT,
  location_id uuid NOT NULL REFERENCES public.count_locations(id) ON DELETE RESTRICT,
  storage_path text NOT NULL UNIQUE,
  mime_type text NOT NULL CHECK (mime_type IN ('image/jpeg','image/png','image/webp')),
  size_bytes bigint NOT NULL CHECK (size_bytes BETWEEN 1 AND 10485760),
  created_by uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT count_shelf_images_storage_path_scope CHECK (
    storage_path ~ (
      '^' || project_id::text || '/' ||
      session_id::text || '/' ||
      member_id::text || '/' ||
      location_id::text ||
      '/shelf-[0-9]{13}-[0-9a-f-]{36}\.(jpg|png|webp)$'
    )
  ),
  CONSTRAINT count_shelf_images_mime_extension CHECK (
    (mime_type='image/jpeg' AND storage_path ~* '\.(jpg|jpeg)$')
    OR (mime_type='image/png' AND storage_path ~* '\.png$')
    OR (mime_type='image/webp' AND storage_path ~* '\.webp$')
  )
);

CREATE INDEX IF NOT EXISTS idx_count_shelf_images_project_session_created
  ON public.count_shelf_images(project_id,session_id,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_count_shelf_images_location_created
  ON public.count_shelf_images(location_id,created_at DESC);

ALTER TABLE public.count_shelf_images ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.count_shelf_images FROM PUBLIC, anon;
GRANT SELECT, INSERT ON TABLE public.count_shelf_images TO authenticated;

DROP POLICY IF EXISTS count_shelf_images_read ON public.count_shelf_images;
CREATE POLICY count_shelf_images_read
ON public.count_shelf_images
FOR SELECT
TO authenticated
USING (
  counting_private.is_platform_owner()
  OR counting_private.is_supervisor(project_id)
  OR EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.project_id=count_shelf_images.project_id
      AND m.user_id=(SELECT auth.uid())
      AND m.status IN ('active','paused')
  )
);

DROP POLICY IF EXISTS count_shelf_images_insert_counter ON public.count_shelf_images;
CREATE POLICY count_shelf_images_insert_counter
ON public.count_shelf_images
FOR INSERT
TO authenticated
WITH CHECK (
  created_by=(SELECT auth.uid())
  AND EXISTS (
    SELECT 1
    FROM public.count_members m
    JOIN public.count_sessions s
      ON s.id=count_shelf_images.session_id
     AND s.project_id=m.project_id
    JOIN public.count_locations l
      ON l.id=count_shelf_images.location_id
     AND l.project_id=m.project_id
    WHERE m.id=count_shelf_images.member_id
      AND m.project_id=count_shelf_images.project_id
      AND m.user_id=(SELECT auth.uid())
      AND m.role='counter'
      AND m.status='active'
      AND s.status='active'
      AND (
        NOT counting_private.session_has_assignments(s.id)
        OR counting_private.member_has_location_assignment(s.id,m.id,l.id)
      )
  )
);

-- Public buckets serve an object to anyone holding its URL. Listing, upload, update and
-- delete remain controlled separately; only an assigned active counter may upload.
DROP POLICY IF EXISTS shelf_images_counter_upload ON storage.objects;
CREATE POLICY shelf_images_counter_upload
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id='shelf-images'
  AND CASE
    WHEN cardinality(storage.foldername(objects.name))=4
      AND (storage.foldername(objects.name))[1] ~* '^[0-9a-f-]{36}$'
      AND (storage.foldername(objects.name))[2] ~* '^[0-9a-f-]{36}$'
      AND (storage.foldername(objects.name))[3] ~* '^[0-9a-f-]{36}$'
      AND (storage.foldername(objects.name))[4] ~* '^[0-9a-f-]{36}$'
      AND split_part(objects.name,'/',5) ~ '^shelf-[0-9]{13}-[0-9a-f-]{36}\.(jpg|png|webp)$'
      AND objects.metadata->>'mimetype' IN ('image/jpeg','image/png','image/webp')
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
        AND m.status='active'
        AND s.status='active'
        AND (
          NOT counting_private.session_has_assignments(s.id)
          OR counting_private.member_has_location_assignment(s.id,m.id,l.id)
        )
    )
    ELSE false
  END
);

COMMENT ON TABLE public.count_shelf_images IS
  'CountFlow shelf photo register. Each row links a public Storage object to its project, active counting session, counter membership and authorized location.';
COMMENT ON POLICY shelf_images_counter_upload ON storage.objects IS
  'Only an active counter may upload a shelf photo to its own active session and assigned location; object names are project/session/member/location scoped.';
