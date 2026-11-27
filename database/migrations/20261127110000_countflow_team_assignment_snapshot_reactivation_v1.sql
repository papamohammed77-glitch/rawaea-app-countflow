-- LVE-792 follow-up: preserve ownership of an assignment across team unassign/reassign cycles.
CREATE OR REPLACE FUNCTION counting_private.count_team_assign_to_session_impl(
  p_team_id uuid,
  p_session_id uuid,
  p_allow_create_permission boolean DEFAULT false
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
  v_session_status text;
  v_team_status text;
  v_session_team_id uuid;
  v_member record;
  v_assignment_id uuid;
  v_assignment_status text;
  v_assignment_origin text;
  v_previous_origin text;
  v_member_count integer := 0;
  v_created_count integer := 0;
  v_reused_count integer := 0;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN
    RAISE EXCEPTION 'AUTHENTICATION_REQUIRED';
  END IF;

  SELECT s.project_id, s.status INTO v_project_id, v_session_status
  FROM public.count_sessions s
  WHERE s.id = p_session_id
  FOR UPDATE;

  IF v_project_id IS NULL THEN RAISE EXCEPTION 'SESSION_NOT_FOUND'; END IF;

  SELECT t.status INTO v_team_status
  FROM public.count_teams t
  WHERE t.id = p_team_id AND t.project_id = v_project_id
  FOR UPDATE;

  IF v_team_status IS NULL THEN RAISE EXCEPTION 'TEAM_NOT_FOUND_IN_PROJECT'; END IF;
  IF v_team_status <> 'active' THEN RAISE EXCEPTION 'TEAM_NOT_ACTIVE'; END IF;
  IF v_session_status NOT IN ('planned','active','paused','review') THEN
    RAISE EXCEPTION 'SESSION_NOT_ASSIGNABLE';
  END IF;
  IF NOT counting_private.has_project_permission(v_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;
  IF p_allow_create_permission THEN
    IF NOT (
      counting_private.has_project_permission(v_project_id, 'operation.manage')
      OR counting_private.has_project_permission(v_project_id, 'operation.create')
    ) THEN
      RAISE EXCEPTION 'OPERATION_MANAGE_PERMISSION_REQUIRED';
    END IF;
  ELSIF NOT counting_private.has_project_permission(v_project_id, 'operation.manage') THEN
    RAISE EXCEPTION 'OPERATION_MANAGE_PERMISSION_REQUIRED';
  END IF;

  INSERT INTO public.count_session_teams(project_id, session_id, team_id, status, assigned_by, removed_at)
  VALUES (v_project_id, p_session_id, p_team_id, 'active', (SELECT auth.uid()), NULL)
  ON CONFLICT (session_id, team_id)
  DO UPDATE SET status = 'active', assigned_by = EXCLUDED.assigned_by,
                updated_at = now(), removed_at = NULL
  RETURNING id INTO v_session_team_id;

  FOR v_member IN
    SELECT tm.member_id
    FROM public.count_team_members tm
    JOIN public.count_members m
      ON m.id = tm.member_id AND m.project_id = tm.project_id
    WHERE tm.team_id = p_team_id
      AND tm.project_id = v_project_id
      AND tm.status = 'active'
      AND m.status = 'active'
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
    ORDER BY tm.member_id
  LOOP
    v_member_count := v_member_count + 1;

    IF EXISTS (
      SELECT 1
      FROM public.count_session_teams other_team
      JOIN public.count_session_team_members other_member
        ON other_member.session_team_id = other_team.id
      WHERE other_team.session_id = p_session_id
        AND other_team.project_id = v_project_id
        AND other_team.status = 'active'
        AND other_team.id <> v_session_team_id
        AND other_member.member_id = v_member.member_id
        AND other_member.status IN ('assigned','active','paused')
    ) THEN
      RAISE EXCEPTION 'TEAM_MEMBER_ALREADY_ASSIGNED_TO_ANOTHER_TEAM:%', v_member.member_id;
    END IF;

    SELECT stm.assignment_origin INTO v_previous_origin
    FROM public.count_session_team_members stm
    WHERE stm.session_team_id = v_session_team_id
      AND stm.member_id = v_member.member_id;

    SELECT a.id, a.status INTO v_assignment_id, v_assignment_status
    FROM public.count_assignments a
    WHERE a.session_id = p_session_id
      AND a.member_id = v_member.member_id
      AND a.location_id IS NULL
    FOR UPDATE;

    IF v_assignment_id IS NULL THEN
      IF EXISTS (
        SELECT 1 FROM public.count_assignments a
        WHERE a.session_id = p_session_id
          AND a.member_id = v_member.member_id
      ) THEN
        RAISE EXCEPTION 'TEAM_MEMBER_HAS_LOCATION_SCOPED_ASSIGNMENT:%', v_member.member_id;
      END IF;

      INSERT INTO public.count_assignments(session_id, member_id, location_id, status)
      VALUES (p_session_id, v_member.member_id, NULL, 'assigned')
      RETURNING id INTO v_assignment_id;
      v_assignment_status := 'assigned';
      v_assignment_origin := 'team_created';
      v_created_count := v_created_count + 1;
    ELSE
      IF v_assignment_status = 'done' THEN
        RAISE EXCEPTION 'TEAM_MEMBER_ALREADY_COMPLETED_THIS_SESSION:%', v_member.member_id;
      END IF;
      IF v_assignment_status = 'paused' THEN
        IF v_previous_origin IS DISTINCT FROM 'team_created' THEN
          RAISE EXCEPTION 'TEAM_MEMBER_ASSIGNMENT_PAUSED:%', v_member.member_id;
        END IF;
        UPDATE public.count_assignments
        SET status = 'assigned'
        WHERE id = v_assignment_id;
        v_assignment_status := 'assigned';
      END IF;
      v_assignment_origin := CASE
        WHEN v_previous_origin = 'team_created' THEN 'team_created'
        ELSE 'preexisting'
      END;
      v_reused_count := v_reused_count + 1;
    END IF;

    INSERT INTO public.count_session_team_members(
      project_id, session_team_id, member_id, assignment_id, assignment_origin, status, removed_at
    )
    VALUES (
      v_project_id, v_session_team_id, v_member.member_id, v_assignment_id,
      v_assignment_origin, v_assignment_status, NULL
    )
    ON CONFLICT (session_team_id, member_id)
    DO UPDATE SET assignment_id = EXCLUDED.assignment_id,
                  assignment_origin = EXCLUDED.assignment_origin,
                  status = EXCLUDED.status,
                  removed_at = NULL;
  END LOOP;

  IF v_member_count = 0 THEN RAISE EXCEPTION 'TEAM_HAS_NO_ACTIVE_MEMBERS'; END IF;

  RETURN jsonb_build_object(
    'team_id', p_team_id,
    'session_id', p_session_id,
    'session_team_id', v_session_team_id,
    'member_count', v_member_count,
    'created_assignments', v_created_count,
    'reused_assignments', v_reused_count
  );
END;
$function$;

