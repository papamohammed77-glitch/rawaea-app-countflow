-- LVE-761: platform-owner read parity and private product-image Storage access.

-- Preserve existing project member/supervisor predicates for all non-owner users.

-- No business rows, membership rows, Auth users, bucket visibility, or capture writes change.



ALTER POLICY count_projects_read ON public.count_projects
USING (counting_private.is_platform_owner() OR counting_private.is_member(id));

ALTER POLICY count_products_read ON public.count_products
USING (counting_private.is_platform_owner() OR counting_private.is_member(project_id));

ALTER POLICY count_sessions_read ON public.count_sessions
USING (counting_private.is_platform_owner() OR counting_private.is_member(project_id));

ALTER POLICY count_locations_read ON public.count_locations
USING (counting_private.is_platform_owner() OR counting_private.is_member(project_id));

ALTER POLICY count_members_read ON public.count_members
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id) OR user_id=(SELECT auth.uid()));

ALTER POLICY count_assignments_read ON public.count_assignments
USING (
  counting_private.is_platform_owner()
  OR EXISTS (
    SELECT 1 FROM public.count_sessions s
    WHERE s.id=count_assignments.session_id
      AND (
        counting_private.is_supervisor(s.project_id)
        OR EXISTS (
          SELECT 1 FROM public.count_members m
          WHERE m.id=count_assignments.member_id
            AND m.project_id=s.project_id
            AND m.user_id=(SELECT auth.uid())
            AND m.status='active'
        )
      )
  )
);

ALTER POLICY count_audit_read ON public.count_audit_log
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_alerts_read ON public.count_alerts
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_anomaly_rules_read ON public.count_anomaly_rules
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_devices_read ON public.count_devices
USING (
  counting_private.is_platform_owner()
  OR counting_private.is_supervisor(project_id)
  OR EXISTS (
    SELECT 1 FROM public.count_members m
    WHERE m.id=count_devices.member_id
      AND m.project_id=count_devices.project_id
      AND m.user_id=(SELECT auth.uid())
  )
);

ALTER POLICY count_entries_read ON public.count_entries
USING (
  counting_private.is_platform_owner()
  OR counting_private.is_supervisor(project_id)
  OR EXISTS (
    SELECT 1 FROM public.count_members m
    WHERE m.id=count_entries.member_id
      AND m.project_id=count_entries.project_id
      AND m.user_id=(SELECT auth.uid())
  )
);

ALTER POLICY count_entry_images_read ON public.count_entry_images
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id) OR uploaded_by=(SELECT auth.uid()));

ALTER POLICY count_expected_read ON public.count_expected_balances
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_exports_read ON public.count_exports
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_import_read ON public.count_import_batches
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_import_mappings_read ON public.count_import_mappings
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_import_rows_read ON public.count_import_rows
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_presence_read ON public.count_presence
USING (
  counting_private.is_platform_owner()
  OR counting_private.is_supervisor(project_id)
  OR EXISTS (
    SELECT 1 FROM public.count_members m
    WHERE m.id=count_presence.member_id
      AND m.project_id=count_presence.project_id
      AND m.user_id=(SELECT auth.uid())
  )
);

ALTER POLICY count_recon_lines_read ON public.count_reconciliation_lines
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_recon_runs_read ON public.count_reconciliation_runs
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_recount_tasks_read ON public.count_recount_tasks
USING (counting_private.is_platform_owner() OR counting_private.can_access_recount_task(project_id,assigned_member_id));

ALTER POLICY count_session_product_costs_read ON public.count_session_product_costs
USING (counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id));

ALTER POLICY count_image_read ON storage.objects
USING (
  bucket_id='counting-product-images'
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(name))[1]
      )
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
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(name))[1]
      )
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
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(name))[1]
      )
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
  AND (
    (
      counting_private.is_platform_owner()
      AND EXISTS (
        SELECT 1 FROM public.count_projects p
        WHERE p.id::text=(storage.foldername(name))[1]
      )
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

COMMENT ON POLICY count_projects_read ON public.count_projects
IS 'Project members retain their scoped read access; the confirmed platform owner has CountFlow-wide read access independent of project membership.';

COMMENT ON POLICY count_image_read ON storage.objects
IS 'Private CountFlow product images: confirmed owner can read objects within existing CountFlow project paths; members retain their original scoped access.';

COMMENT ON POLICY count_image_upload ON storage.objects
IS 'Private CountFlow product images: confirmed owner or an active project supervisor can upload within an existing project path.';

COMMENT ON POLICY count_image_update ON storage.objects
IS 'Private CountFlow product images: confirmed owner or an active project supervisor can update within an existing project path.';
