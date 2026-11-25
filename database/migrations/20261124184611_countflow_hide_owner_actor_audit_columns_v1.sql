-- Remove direct authenticated SELECT on platform-owner actor metadata columns.
-- All operational columns remain readable under existing RLS policies.
-- Write permissions and service_role access remain unchanged.

REVOKE SELECT ON TABLE public.count_presence FROM PUBLIC, anon, authenticated;
GRANT SELECT (
  project_id,session_id,member_id,device_id,presence_state,current_location_id,
  started_at,last_seen_at,pending_queue_count,pending_queue_digest,queue_reported_at,
  acknowledged_lifecycle_version,queue_resolution,queue_resolution_reason,queue_resolved_at
) ON TABLE public.count_presence TO authenticated;

REVOKE SELECT ON TABLE public.count_devices FROM PUBLIC, anon, authenticated;
GRANT SELECT (
  id,project_id,member_id,device_id,device_label,platform,app_version,status,
  first_seen_at,last_seen_at,revoked_at
) ON TABLE public.count_devices TO authenticated;

REVOKE SELECT ON TABLE public.count_recount_tasks FROM PUBLIC, anon, authenticated;
GRANT SELECT (
  id,project_id,session_id,reconciliation_line_id,product_id,location_id,
  assigned_member_id,status,reason,first_count_quantity,second_count_quantity,
  variance_percent,created_at,assigned_at,started_at,completed_at,reviewed_at,notes
) ON TABLE public.count_recount_tasks TO authenticated;

REVOKE SELECT ON TABLE public.count_reconciliation_runs FROM PUBLIC, anon, authenticated;
GRANT SELECT (
  id,project_id,session_id,run_number,status,expected_rows,counted_rows,
  matched_rows,variance_rows,uncounted_rows,total_expected,total_counted,
  created_at,computed_at,approved_at,entry_count_snapshot
) ON TABLE public.count_reconciliation_runs TO authenticated;
