-- Allow active project auditors to read only registered count evidence in their own project.
-- Keep counting-evidence private. No upload, update, delete, bucket-public or object metadata writes.
ALTER POLICY count_evidence_read ON storage.objects
USING (
  bucket_id = 'counting-evidence'
  AND CASE
    WHEN (
      ((storage.foldername(name))[1] ~* '^[0-9a-f-]{36}$')
      AND ((storage.foldername(name))[2] ~* '^[0-9a-f-]{36}$')
      AND ((storage.foldername(name))[3] ~* '^[0-9a-f-]{36}$')
    ) THEN (
      counting_private.is_platform_owner(((storage.foldername(name))[1])::uuid)
      OR (
        EXISTS (
          SELECT 1
          FROM public.count_entry_images i
          WHERE i.storage_path = objects.name
            AND i.project_id = ((storage.foldername(objects.name))[1])::uuid
            AND NOT counting_private.is_platform_owner_actor(i.uploaded_by)
        )
        AND (
          counting_private.is_supervisor(((storage.foldername(name))[1])::uuid)
          OR counting_private.is_auditor(((storage.foldername(name))[1])::uuid)
          OR EXISTS (
            SELECT 1
            FROM public.count_entries e
            JOIN public.count_members m ON m.id = e.member_id
            WHERE e.id = ((storage.foldername(objects.name))[3])::uuid
              AND e.session_id = ((storage.foldername(objects.name))[2])::uuid
              AND e.project_id = ((storage.foldername(objects.name))[1])::uuid
              AND m.user_id = (SELECT auth.uid())
              AND m.status = 'active'
              AND NOT counting_private.is_platform_owner_actor(m.user_id)
          )
        )
      )
    )
    ELSE false
  END
);
