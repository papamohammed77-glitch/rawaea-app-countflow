-- LVE-793 — CountFlow child-side foreign-key indexes.
-- Scope: CountFlow tables only. Non-unique B-tree indexes; no row or business-state changes.
-- Live Supabase ledger: 20261128000731 / countflow_fk_performance_indexes_v1.

CREATE INDEX IF NOT EXISTS idx_count_assignments_member_project_fk
  ON public.count_assignments (member_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_assignments_session_project_fk
  ON public.count_assignments (session_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_session_team_members_link_project_fk
  ON public.count_session_team_members (session_team_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_session_team_members_member_project_fk
  ON public.count_session_team_members (member_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_session_teams_assigned_by
  ON public.count_session_teams (assigned_by);

CREATE INDEX IF NOT EXISTS idx_count_session_teams_session_project_fk
  ON public.count_session_teams (session_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_session_teams_team_project_fk
  ON public.count_session_teams (team_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_sessions_queue_barrier_run_id
  ON public.count_sessions (queue_barrier_run_id);

CREATE INDEX IF NOT EXISTS idx_count_team_members_added_by
  ON public.count_team_members (added_by);

CREATE INDEX IF NOT EXISTS idx_count_team_members_member_project_fk
  ON public.count_team_members (member_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_team_members_team_project_fk
  ON public.count_team_members (team_id, project_id);

CREATE INDEX IF NOT EXISTS idx_count_teams_created_by
  ON public.count_teams (created_by);
