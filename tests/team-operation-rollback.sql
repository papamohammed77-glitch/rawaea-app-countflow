-- LVE-792 integration smoke test. All QA writes are inside one transaction and rolled back.
-- Requires the existing QA90K project in rawaea-staging; it never edits the import batch.

BEGIN;

SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT u.id::text FROM auth.users u
   WHERE lower(coalesce(u.email,'')) = 'owner@rawaea.com'
     AND u.email_confirmed_at IS NOT NULL
   LIMIT 1),
  true
);

SET LOCAL ROLE authenticated;

DO $test$
DECLARE
  v_project uuid;
  v_session uuid;
  v_counter uuid;
  v_supervisor uuid;
  v_auditor uuid;
  v_team uuid;
  v_new_session uuid;
  v_direct_session uuid;
  v_result jsonb;
  v_count bigint;
  v_type text;
  v_active_people bigint;
  v_scope_guarded boolean := false;
BEGIN
  SELECT p.id INTO v_project
  FROM public.count_projects p
  WHERE p.code = 'QA90K-20261121'
  LIMIT 1;

  IF v_project IS NULL THEN
    RAISE NOTICE 'SKIP LVE-792: QA90K project is not present in this environment';
    RETURN;
  END IF;

  SELECT s.id INTO v_session
  FROM public.count_sessions s
  WHERE s.project_id = v_project
  ORDER BY s.created_at
  LIMIT 1;

  SELECT m.id INTO v_counter
  FROM public.count_members m
  WHERE m.project_id = v_project AND m.role = 'counter'
    AND m.status = 'active'
    AND NOT counting_private.is_platform_owner_actor(m.user_id)
  ORDER BY m.created_at
  LIMIT 1;

  SELECT m.id INTO v_auditor
  FROM public.count_members m
  WHERE m.project_id = v_project AND m.role = 'auditor'
    AND m.status = 'active'
    AND NOT counting_private.is_platform_owner_actor(m.user_id)
  ORDER BY m.created_at
  LIMIT 1;

  SELECT m.id INTO v_supervisor
  FROM public.count_members m
  WHERE m.project_id = v_project AND m.role = 'supervisor'
    AND m.status = 'active'
    AND NOT counting_private.is_platform_owner_actor(m.user_id)
  ORDER BY m.created_at
  LIMIT 1;

  IF v_session IS NULL OR v_counter IS NULL OR v_supervisor IS NULL THEN
    RAISE EXCEPTION 'LVE792_QA_FIXTURE_INCOMPLETE';
  END IF;
  IF NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'LVE792_AUTH_OWNER_REQUIRED';
  END IF;

  -- Reusable team creation and roster management.
  v_result := public.count_team_create(v_project, 'QA_LVE792_TEAM_ROLLBACK', 'rollback-only team smoke test');
  v_team := (v_result->>'id')::uuid;

  IF v_auditor IS NOT NULL THEN
    BEGIN
      PERFORM public.count_team_add_members(v_team, ARRAY[v_auditor]::uuid[]);
      RAISE EXCEPTION 'LVE792_AUDITOR_WAS_ALLOWED_IN_COUNT_TEAM';
    EXCEPTION WHEN OTHERS THEN
      IF SQLERRM <> 'TEAM_MEMBERS_MUST_BE_ACTIVE_COUNT_CAPABLE_IN_SAME_PROJECT' THEN
        RAISE;
      END IF;
    END;
  END IF;

  PERFORM public.count_team_add_members(v_team, ARRAY[v_counter,v_supervisor]::uuid[]);
  PERFORM public.count_team_set_member_role(v_team, v_supervisor, 'leader');

  -- Team assignments must still populate the established mobile-app assignment table.
  v_result := public.count_team_assign_to_session(v_team, v_session);
  IF (v_result->>'member_count')::integer <> 2 THEN
    RAISE EXCEPTION 'LVE792_TEAM_ASSIGNMENT_COUNT_FAILED:%', v_result;
  END IF;

  SELECT count(*) INTO v_count
  FROM public.count_assignments a
  WHERE a.project_id = v_project AND a.session_id = v_session
    AND a.member_id = ANY(ARRAY[v_counter,v_supervisor]::uuid[]);
  IF v_count <> 2 THEN RAISE EXCEPTION 'LVE792_ASSIGNMENT_BRIDGE_FAILED:%', v_count; END IF;

  SELECT count(*) INTO v_count
  FROM public.count_session_team_members stm
  JOIN public.count_session_teams st ON st.id = stm.session_team_id
  WHERE st.team_id = v_team AND st.session_id = v_session
    AND stm.status = 'assigned';
  IF v_count <> 2 THEN RAISE EXCEPTION 'LVE792_TEAM_SNAPSHOT_FAILED:%', v_count; END IF;

  -- Removing someone from the reusable roster must not rewrite an existing operation snapshot.
  PERFORM public.count_team_remove_member(v_team, v_counter);
  SELECT count(*) INTO v_count
  FROM public.count_session_team_members stm
  JOIN public.count_session_teams st ON st.id = stm.session_team_id
  WHERE st.team_id = v_team AND st.session_id = v_session
    AND stm.member_id = v_counter AND stm.status = 'assigned';
  IF v_count <> 1 THEN RAISE EXCEPTION 'LVE792_SNAPSHOT_MUTATED_BY_ROSTER_EDIT'; END IF;

  -- Team-created assignments are paused, not deleted; count history remains intact.
  PERFORM public.count_team_unassign_from_session(v_team, v_session);
  SELECT count(*) INTO v_count
  FROM public.count_assignments a
  WHERE a.project_id = v_project AND a.session_id = v_session
    AND a.member_id = ANY(ARRAY[v_counter,v_supervisor]::uuid[])
    AND a.status = 'paused';
  IF v_count <> 2 THEN RAISE EXCEPTION 'LVE792_TEAM_UNASSIGN_FAILED:%', v_count; END IF;

  -- Re-adding a team member and reassigning the same team must retain team ownership.
  PERFORM public.count_team_add_members(v_team, ARRAY[v_counter]::uuid[]);
  v_result := public.count_team_assign_to_session(v_team, v_session);
  IF (v_result->>'member_count')::integer <> 2 THEN
    RAISE EXCEPTION 'LVE792_TEAM_REASSIGN_FAILED:%', v_result;
  END IF;
  PERFORM public.count_team_unassign_from_session(v_team, v_session);
  SELECT count(*) INTO v_count
  FROM public.count_assignments a
  WHERE a.project_id = v_project AND a.session_id = v_session
    AND a.member_id = ANY(ARRAY[v_counter,v_supervisor]::uuid[])
    AND a.status = 'paused';
  IF v_count <> 2 THEN RAISE EXCEPTION 'LVE792_TEAM_OWNERSHIP_LOST_AFTER_REASSIGN:%', v_count; END IF;

  -- The scope column is DB-derived and cannot be forged by an API client.
  BEGIN
    UPDATE public.count_assignments
    SET project_id = gen_random_uuid()
    WHERE session_id = v_session AND member_id = v_counter AND location_id IS NULL;
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM = 'COUNT_ASSIGNMENT_PROJECT_SCOPE_MISMATCH' THEN
      v_scope_guarded := true;
    ELSE
      RAISE;
    END IF;
  END;
  IF NOT v_scope_guarded THEN RAISE EXCEPTION 'LVE792_ASSIGNMENT_PROJECT_GUARD_NOT_ENFORCED'; END IF;

  -- Atomic session creation, operation taxonomy and team assignment.
  v_result := public.count_create_session_with_teams(
    v_project,
    'QA_LVE792_SESSION_ROLLBACK',
    'QA-LVE792-01',
    'cycle_count',
    NULL::uuid,
    NULL::timestamptz,
    NULL::timestamptz,
    'Africa/Cairo',
    3::smallint,
    'barcode',
    false,
    true,
    false,
    false,
    'rollback-only integration test',
    ARRAY[]::uuid[],
    ARRAY[v_team]::uuid[]
  );
  v_new_session := (v_result->>'session_id')::uuid;

  IF v_result->>'operation_type' <> 'cycle_count'
     OR (v_result->>'teams_assigned')::integer <> 1 THEN
    RAISE EXCEPTION 'LVE792_ATOMIC_SESSION_CREATE_FAILED:%', v_result;
  END IF;

  SELECT s.operation_type INTO v_type
  FROM public.count_sessions s WHERE s.id = v_new_session;
  IF v_type <> 'cycle_count' THEN RAISE EXCEPTION 'LVE792_OPERATION_TYPE_NOT_SAVED:%', v_type; END IF;

  SELECT count(*) INTO v_count
  FROM public.count_assignments a
  WHERE a.project_id = v_project AND a.session_id = v_new_session
    AND a.member_id = ANY(ARRAY[v_counter,v_supervisor]::uuid[])
    AND a.status = 'assigned';
  IF v_count <> 2 THEN RAISE EXCEPTION 'LVE792_ATOMIC_TEAM_ASSIGNMENT_BRIDGE_FAILED:%', v_count; END IF;

  SELECT k.active_team_people INTO v_active_people
  FROM public.count_admin_platform_kpis(v_project) k;
  IF v_active_people <> 2 THEN RAISE EXCEPTION 'LVE792_PLATFORM_KPI_FAILED:%', v_active_people; END IF;

  SELECT t.active_members INTO v_count
  FROM public.count_team_overview t WHERE t.team_id = v_team;
  IF v_count <> 2 THEN RAISE EXCEPTION 'LVE792_TEAM_KPI_FAILED:%', v_count; END IF;

  SELECT count(*) INTO v_count
  FROM public.count_operation_overview o
  WHERE o.session_id = v_new_session
    AND o.operation_type = 'cycle_count'
    AND o.active_teams = 1
    AND o.active_team_members = 2;
  IF v_count <> 1 THEN RAISE EXCEPTION 'LVE792_OPERATION_OVERVIEW_FAILED:%', v_count; END IF;

  -- Direct individual assignment: enforce count permission and preserve an auditable paused state.
  v_result := public.count_create_session_with_teams(
    v_project,'QA_LVE792_DIRECT_SESSION_ROLLBACK','QA-LVE792-DIRECT','spot_check',
    NULL::uuid,NULL::timestamptz,NULL::timestamptz,'Africa/Cairo',3::smallint,'mixed',
    false,true,false,false,'rollback-only direct assignment test',
    ARRAY[]::uuid[],ARRAY[]::uuid[]
  );
  v_direct_session := (v_result->>'session_id')::uuid;

  IF v_auditor IS NOT NULL THEN
    BEGIN
      PERFORM public.count_assign_member_to_session(v_direct_session,v_auditor);
      RAISE EXCEPTION 'LVE792_AUDITOR_WAS_ALLOWED_DIRECT_ASSIGNMENT';
    EXCEPTION WHEN OTHERS THEN
      IF SQLERRM <> 'SESSION_MEMBER_NOT_COUNT_CAPABLE' THEN RAISE; END IF;
    END;
  END IF;

  v_result := public.count_assign_member_to_session(v_direct_session,v_counter);
  SELECT count(*) INTO v_count FROM public.count_assignments
  WHERE id=(v_result->>'assignment_id')::uuid
    AND project_id=v_project AND status='assigned';
  IF v_count <> 1 THEN RAISE EXCEPTION 'LVE792_DIRECT_ASSIGNMENT_FAILED:%',v_count; END IF;

  v_result := public.count_remove_member_from_session(v_direct_session,v_counter);
  IF v_result->>'status' <> 'paused' OR v_result->>'assignment_preserved' <> 'true' THEN
    RAISE EXCEPTION 'LVE792_DIRECT_ASSIGNMENT_REMOVE_DID_NOT_PRESERVE:%',v_result;
  END IF;

  v_result := public.count_assign_member_to_session(v_direct_session,v_counter);
  IF v_result->>'status' <> 'assigned' OR v_result->>'reactivated' <> 'true' THEN
    RAISE EXCEPTION 'LVE792_DIRECT_ASSIGNMENT_REACTIVATION_FAILED:%',v_result;
  END IF;
  PERFORM public.count_remove_member_from_session(v_direct_session,v_counter);

  RAISE NOTICE 'PASS: reusable team, roster snapshot, safe unassign/reassign, project scope, atomic session, operation type and KPIs';
END
$test$;

ROLLBACK;
