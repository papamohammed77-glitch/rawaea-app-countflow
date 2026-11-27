-- LVE-792: count-capable direct assignments and append-preserving removal.
CREATE OR REPLACE FUNCTION public.count_create_session_with_teams(
  p_project_id uuid,
  p_name text,
  p_operation_code text,
  p_operation_type text,
  p_branch_location_id uuid,
  p_planned_start_at timestamptz,
  p_planned_end_at timestamptz,
  p_timezone text,
  p_priority smallint,
  p_counting_mode text,
  p_show_expected_quantity boolean,
  p_capture_images boolean,
  p_require_images boolean,
  p_allow_unknown_products boolean,
  p_instructions text,
  p_member_ids uuid[],
  p_team_ids uuid[]
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session_id uuid;
  v_member_count integer;
  v_team_count integer;
  v_team_id uuid;
  v_team_results jsonb := '[]'::jsonb;
  v_timezone text := coalesce(nullif(btrim(p_timezone),''),'Africa/Cairo');
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  IF NOT counting_private.has_project_permission(p_project_id, 'operation.create') THEN
    RAISE EXCEPTION 'OPERATION_CREATE_PERMISSION_REQUIRED';
  END IF;
  IF nullif(btrim(p_name),'') IS NULL OR length(btrim(p_name)) > 160
     OR (p_operation_code IS NOT NULL AND btrim(p_operation_code) !~ '^[A-Za-z0-9_-]{2,40}$')
     OR p_operation_type NOT IN ('unclassified','full_inventory','cycle_count','spot_check','recount','audit','other')
     OR coalesce(p_priority,3) NOT BETWEEN 1 AND 5
     OR coalesce(p_counting_mode,'mixed') NOT IN ('barcode','manual','mixed')
     OR (p_planned_start_at IS NOT NULL AND p_planned_end_at IS NOT NULL AND p_planned_end_at <= p_planned_start_at)
     OR NOT EXISTS (SELECT 1 FROM pg_catalog.pg_timezone_names z WHERE z.name = v_timezone)
     OR (coalesce(p_require_images,false) AND NOT coalesce(p_capture_images,true))
     OR length(coalesce(p_instructions,'')) > 2000 THEN
    RAISE EXCEPTION 'INVALID_OPERATION_CONFIGURATION';
  END IF;
  IF p_branch_location_id IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM public.count_locations l
    WHERE l.id = p_branch_location_id AND l.project_id = p_project_id
  ) THEN
    RAISE EXCEPTION 'BRANCH_NOT_FOUND_IN_PROJECT';
  END IF;

  v_member_count := coalesce(cardinality(p_member_ids),0);
  v_team_count := coalesce(cardinality(p_team_ids),0);
  IF v_member_count > 500 OR v_team_count > 100 THEN
    RAISE EXCEPTION 'OPERATION_TEAM_BATCH_TOO_LARGE';
  END IF;
  IF (v_member_count > 0 OR v_team_count > 0)
     AND NOT counting_private.has_project_permission(p_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;
  IF v_member_count <> (
    SELECT count(DISTINCT x) FROM unnest(coalesce(p_member_ids, ARRAY[]::uuid[])) AS x
  ) OR v_team_count <> (
    SELECT count(DISTINCT x) FROM unnest(coalesce(p_team_ids, ARRAY[]::uuid[])) AS x
  ) THEN
    RAISE EXCEPTION 'DUPLICATE_OPERATION_ASSIGNEES';
  END IF;
  IF v_member_count > 0 AND v_member_count <> (
    SELECT count(*)
    FROM public.count_members m
    JOIN public.count_roles r
      ON r.id = m.role_id AND r.is_active AND r.scope = 'project'
    JOIN public.count_role_permissions rp
      ON rp.role_id = r.id AND rp.permission_code = 'count.entry.create'
    WHERE m.id = ANY(p_member_ids)
      AND m.project_id = p_project_id
      AND m.status = 'active'
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
  ) THEN
    RAISE EXCEPTION 'OPERATION_MEMBERS_MUST_BE_ACTIVE_IN_PROJECT';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.count_team_members tm
    JOIN public.count_teams t ON t.id = tm.team_id
    WHERE tm.team_id = ANY(coalesce(p_team_ids, ARRAY[]::uuid[]))
      AND (tm.project_id <> p_project_id OR t.status <> 'active')
  ) THEN
    RAISE EXCEPTION 'OPERATION_TEAM_NOT_ACTIVE_IN_PROJECT';
  END IF;

  INSERT INTO public.count_sessions(
    project_id, name, status, created_by, operation_code, operation_type,
    branch_location_id, planned_start_at, planned_end_at, schedule_timezone,
    priority, counting_mode, show_expected_quantity, capture_images,
    require_images, allow_unknown_products, instructions
  )
  VALUES (
    p_project_id, btrim(p_name), 'planned', (SELECT auth.uid()),
    nullif(upper(btrim(coalesce(p_operation_code,''))),''), p_operation_type,
    p_branch_location_id, p_planned_start_at, p_planned_end_at, v_timezone,
    coalesce(p_priority,3), coalesce(p_counting_mode,'mixed'),
    coalesce(p_show_expected_quantity,false), coalesce(p_capture_images,true),
    coalesce(p_require_images,false), coalesce(p_allow_unknown_products,false),
    nullif(btrim(coalesce(p_instructions,'')),'')
  )
  RETURNING id INTO v_session_id;

  IF v_member_count > 0 THEN
    INSERT INTO public.count_assignments(session_id, member_id, location_id, status)
    SELECT v_session_id, x, NULL, 'assigned'
    FROM unnest(p_member_ids) AS x;
  END IF;

  FOREACH v_team_id IN ARRAY coalesce(p_team_ids, ARRAY[]::uuid[]) LOOP
    v_team_results := v_team_results || jsonb_build_array(
      counting_private.count_team_assign_to_session_impl(v_team_id, v_session_id, true)
    );
  END LOOP;

  RETURN jsonb_build_object(
    'session_id', v_session_id,
    'project_id', p_project_id,
    'operation_type', p_operation_type,
    'individual_assignments', v_member_count,
    'teams_assigned', v_team_count,
    'team_results', v_team_results,
    'status', 'planned'
  );
END;
$function$;

-- Per-team operational KPIs; coverage denominators remain location/session scoped.

CREATE OR REPLACE FUNCTION public.count_admin_platform_kpis(p_project_id uuid DEFAULT NULL)
RETURNS TABLE (
  operations_this_month bigint,
  active_operations bigint,
  completed_operations bigint,
  active_teams bigint,
  active_team_people bigint,
  active_assigned_people bigint
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path TO ''
AS $function$
  SELECT
    (SELECT count(*)::bigint
       FROM public.count_sessions s
      WHERE (p_project_id IS NULL OR s.project_id = p_project_id)
        AND timezone('Africa/Cairo', s.created_at) >= date_trunc('month', timezone('Africa/Cairo', now()))
        AND timezone('Africa/Cairo', s.created_at) < date_trunc('month', timezone('Africa/Cairo', now())) + interval '1 month'),
    (SELECT count(*)::bigint
       FROM public.count_sessions s
      WHERE (p_project_id IS NULL OR s.project_id = p_project_id)
        AND s.status = 'active'),
    (SELECT count(*)::bigint
       FROM public.count_sessions s
      WHERE (p_project_id IS NULL OR s.project_id = p_project_id)
        AND s.status = 'completed'),
    (SELECT count(*)::bigint
       FROM public.count_teams t
      WHERE (p_project_id IS NULL OR t.project_id = p_project_id)
        AND t.status = 'active'),
    (SELECT count(DISTINCT m.user_id)::bigint
       FROM public.count_team_members tm
       JOIN public.count_teams t ON t.id = tm.team_id AND t.project_id = tm.project_id
       JOIN public.count_members m ON m.id = tm.member_id AND m.project_id = tm.project_id
       JOIN public.count_roles r ON r.id = m.role_id AND r.is_active AND r.scope = 'project'
       JOIN public.count_role_permissions rp
         ON rp.role_id = r.id AND rp.permission_code = 'count.entry.create'
      WHERE (p_project_id IS NULL OR t.project_id = p_project_id)
        AND t.status = 'active' AND tm.status = 'active' AND m.status = 'active'
        AND NOT counting_private.is_platform_owner_actor(m.user_id)),
    (SELECT count(DISTINCT m.user_id)::bigint
       FROM public.count_assignments a
       JOIN public.count_sessions s ON s.id = a.session_id AND s.project_id = a.project_id
       JOIN public.count_members m ON m.id = a.member_id AND m.project_id = a.project_id
       JOIN public.count_roles r ON r.id = m.role_id AND r.is_active AND r.scope = 'project'
       JOIN public.count_role_permissions rp
         ON rp.role_id = r.id AND rp.permission_code = 'count.entry.create'
      WHERE (p_project_id IS NULL OR a.project_id = p_project_id)
        AND s.status = 'active'
        AND a.status IN ('assigned','active')
        AND m.status = 'active'
        AND NOT counting_private.is_platform_owner_actor(m.user_id));
$function$;

-- Preserve the existing overview contract and append the new fields.


-- Direct individual assignment uses the same role-permission contract as team assignments.
CREATE OR REPLACE FUNCTION public.count_assign_member_to_session(
  p_session_id uuid,
  p_member_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
  v_session_status text;
  v_member_status text;
  v_member_user_id uuid;
  v_existing_id uuid;
  v_existing_status text;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;

  SELECT s.project_id, s.status INTO v_project_id, v_session_status
  FROM public.count_sessions s WHERE s.id = p_session_id FOR UPDATE;
  IF v_project_id IS NULL THEN RAISE EXCEPTION 'SESSION_NOT_FOUND'; END IF;
  IF v_session_status NOT IN ('planned','active','paused','review') THEN
    RAISE EXCEPTION 'SESSION_NOT_ASSIGNABLE';
  END IF;
  IF NOT counting_private.has_project_permission(v_project_id, 'team.manage')
     OR NOT counting_private.has_project_permission(v_project_id, 'operation.manage') THEN
    RAISE EXCEPTION 'TEAM_AND_OPERATION_MANAGE_PERMISSION_REQUIRED';
  END IF;

  SELECT m.status, m.user_id INTO v_member_status, v_member_user_id
  FROM public.count_members m
  WHERE m.id = p_member_id AND m.project_id = v_project_id
  FOR UPDATE;
  IF v_member_status IS DISTINCT FROM 'active'
     OR v_member_user_id IS NULL
     OR counting_private.is_platform_owner_actor(v_member_user_id)
     OR NOT EXISTS (
       SELECT 1
       FROM public.count_members m
       JOIN public.count_roles r ON r.id = m.role_id AND r.is_active AND r.scope = 'project'
       JOIN public.count_role_permissions rp
         ON rp.role_id = r.id AND rp.permission_code = 'count.entry.create'
       WHERE m.id = p_member_id AND m.project_id = v_project_id AND m.status = 'active'
     ) THEN
    RAISE EXCEPTION 'SESSION_MEMBER_NOT_COUNT_CAPABLE';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.count_session_team_members stm
    JOIN public.count_session_teams st ON st.id = stm.session_team_id
    WHERE st.session_id = p_session_id AND st.project_id = v_project_id
      AND st.status = 'active'
      AND stm.member_id = p_member_id
      AND stm.status IN ('assigned','active','paused')
  ) THEN
    RAISE EXCEPTION 'SESSION_MEMBER_ALREADY_ASSIGNED_VIA_TEAM';
  END IF;

  SELECT a.id, a.status INTO v_existing_id, v_existing_status
  FROM public.count_assignments a
  WHERE a.session_id = p_session_id AND a.member_id = p_member_id AND a.location_id IS NULL
  FOR UPDATE;

  IF v_existing_id IS NOT NULL THEN
    IF v_existing_status IN ('assigned','active') THEN
      RETURN jsonb_build_object('assignment_id',v_existing_id,'status',v_existing_status,'already_assigned',true);
    END IF;
    IF v_existing_status = 'done' THEN RAISE EXCEPTION 'SESSION_MEMBER_ASSIGNMENT_ALREADY_COMPLETED'; END IF;
    IF EXISTS (
      SELECT 1 FROM public.count_session_team_members stm
      WHERE stm.assignment_id = v_existing_id AND stm.assignment_origin = 'team_created'
    ) THEN
      RAISE EXCEPTION 'TEAM_OWNED_ASSIGNMENT_MUST_BE_REASSIGNED_THROUGH_TEAM';
    END IF;
    UPDATE public.count_assignments SET status = 'assigned'
    WHERE id = v_existing_id;
    RETURN jsonb_build_object('assignment_id',v_existing_id,'status','assigned','reactivated',true);
  END IF;

  INSERT INTO public.count_assignments(session_id,member_id,location_id,status)
  VALUES (p_session_id,p_member_id,NULL,'assigned')
  RETURNING id INTO v_existing_id;

  RETURN jsonb_build_object('assignment_id',v_existing_id,'status','assigned','already_assigned',false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_remove_member_from_session(
  p_session_id uuid,
  p_member_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
  v_session_status text;
  v_assignment_id uuid;
  v_assignment_status text;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  SELECT s.project_id,s.status INTO v_project_id,v_session_status
  FROM public.count_sessions s WHERE s.id=p_session_id FOR UPDATE;
  IF v_project_id IS NULL THEN RAISE EXCEPTION 'SESSION_NOT_FOUND'; END IF;
  IF v_session_status NOT IN ('planned','active','paused','review') THEN
    RAISE EXCEPTION 'SESSION_NOT_ASSIGNABLE';
  END IF;
  IF NOT counting_private.has_project_permission(v_project_id,'team.manage')
     OR NOT counting_private.has_project_permission(v_project_id,'operation.manage') THEN
    RAISE EXCEPTION 'TEAM_AND_OPERATION_MANAGE_PERMISSION_REQUIRED';
  END IF;

  SELECT a.id,a.status INTO v_assignment_id,v_assignment_status
  FROM public.count_assignments a
  WHERE a.session_id=p_session_id AND a.member_id=p_member_id AND a.location_id IS NULL
  FOR UPDATE;
  IF v_assignment_id IS NULL THEN RAISE EXCEPTION 'SESSION_MEMBER_ASSIGNMENT_NOT_FOUND'; END IF;
  IF v_assignment_status='done' THEN RAISE EXCEPTION 'COMPLETED_ASSIGNMENT_CANNOT_BE_REMOVED'; END IF;
  IF EXISTS (
    SELECT 1 FROM public.count_session_team_members stm
    JOIN public.count_session_teams st ON st.id=stm.session_team_id
    WHERE st.session_id=p_session_id AND st.project_id=v_project_id
      AND st.status='active' AND stm.assignment_id=v_assignment_id
      AND stm.status IN ('assigned','active','paused')
  ) THEN
    RAISE EXCEPTION 'MEMBER_ASSIGNED_VIA_TEAM_USE_TEAM_UNASSIGN';
  END IF;

  UPDATE public.count_assignments SET status='paused' WHERE id=v_assignment_id;
  RETURN jsonb_build_object(
    'assignment_id',v_assignment_id,
    'status','paused',
    'assignment_preserved',true,
    'count_history_preserved',true
  );
END;
$function$;

REVOKE ALL ON FUNCTION public.count_assign_member_to_session(uuid,uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_remove_member_from_session(uuid,uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.count_assign_member_to_session(uuid,uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_remove_member_from_session(uuid,uuid) TO authenticated;
