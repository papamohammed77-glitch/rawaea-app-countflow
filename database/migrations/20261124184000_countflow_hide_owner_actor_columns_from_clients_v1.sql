-- Restrict direct PostgREST reads of platform-owner identity fields.
-- Authenticated apps retain SELECT on operational columns only.
-- INSERT/UPDATE/DELETE privileges and service_role access are unchanged.

REVOKE SELECT ON TABLE public.count_projects FROM PUBLIC, anon, authenticated;
GRANT SELECT (id,name,code,status,created_at,updated_at)
  ON TABLE public.count_projects TO authenticated;

REVOKE SELECT ON TABLE public.count_sessions FROM PUBLIC, anon, authenticated;
GRANT SELECT (
  id,project_id,name,status,started_at,closed_at,created_at,updated_at,
  sync_barrier_version,queue_barrier_action,queue_barrier_run_id,queue_barrier_requested_at
) ON TABLE public.count_sessions TO authenticated;
