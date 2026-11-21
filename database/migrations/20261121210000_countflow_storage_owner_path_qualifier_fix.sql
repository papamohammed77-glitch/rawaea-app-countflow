-- LVE-761 corrective migration:
-- Qualify the outer Storage object name inside the nested project existence check.
-- Without the qualifier, PostgreSQL resolves "name" to count_projects.name in the subquery.

ALTER POLICY count_image_read ON storage.objects
USING (
  bucket_id='counting-product-images'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(objects.name))[1]
      )
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(objects.name))[1]
        AND m.status IN ('active','paused')
    )
  )
);

ALTER POLICY count_image_upload ON storage.objects
WITH CHECK (
  bucket_id='counting-product-images'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(objects.name))[1]
      )
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(objects.name))[1]
        AND m.role='supervisor'
        AND m.status='active'
    )
  )
);

ALTER POLICY count_image_update ON storage.objects
USING (
  bucket_id='counting-product-images'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(objects.name))[1]
      )
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(objects.name))[1]
        AND m.role='supervisor'
        AND m.status='active'
    )
  )
)
WITH CHECK (
  bucket_id='counting-product-images'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(objects.name))[1]
      )
    )
    OR EXISTS (
      SELECT 1 FROM public.count_members m
      WHERE m.user_id=(SELECT auth.uid())
        AND m.project_id::text=(storage.foldername(objects.name))[1]
        AND m.role='supervisor'
        AND m.status='active'
    )
  )
);

COMMENT ON POLICY count_image_read ON storage.objects
IS 'Private CountFlow product images: confirmed owner can read objects in existing CountFlow projects using the qualified Storage object path; members retain their original scope.';
COMMENT ON POLICY count_image_upload ON storage.objects
IS 'Private CountFlow product images: confirmed owner or active project supervisor may upload to an existing project path.';
COMMENT ON POLICY count_image_update ON storage.objects
IS 'Private CountFlow product images: confirmed owner or active project supervisor may update within an existing project path.';
