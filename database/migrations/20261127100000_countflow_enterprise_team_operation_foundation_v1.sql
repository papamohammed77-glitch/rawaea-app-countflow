-- LVE-792: reusable project teams, operation taxonomy, KPI contracts and realtime scope.
-- CountFlow objects only. Legacy ERP schemas are deliberately untouched.

ALTER TABLE public.count_sessions
  ADD COLUMN IF NOT EXISTS operation_type text NOT NULL DEFAULT 'unclassified';

ALTER TABLE public.count_sessions
  DROP CONSTRAINT IF EXISTS count_sessions_operation_type_check;

ALTER TABLE public.count_sessions
  ADD CONSTRAINT count_sessions_operation_type_check
  CHECK (operation_type = ANY (ARRAY[
    'unclassified','full_inventory','cycle_count','spot_check','recount','audit','other'
  ]));

-- Project scope on assignments is derived from the session, never trusted from the client.
ALTER TABLE public.count_assignments ADD COLUMN IF NOT EXISTS project_id uuid;

UPDATE public.count_assignments a
SET project_id = s.project_id
FROM public.count_sessions s
WHERE s.id = a.session_id
  AND (a.project_id IS NULL OR a.project_id <> s.project_id);

DO $migration$
BEGIN
  IF EXISTS (SELECT 1 FROM public.count_assignments WHERE project_id IS NULL) THEN
    RAISE EXCEPTION 'COUNT_ASSIGNMENT_PROJECT_BACKFILL_INCOMPLETE';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.count_assignments'::regclass
      AND conname = 'count_assignments_session_project_fk'
  ) THEN
    ALTER TABLE public.count_assignments
      ADD CONSTRAINT count_assignments_session_project_fk
      FOREIGN KEY (session_id, project_id)
      REFERENCES public.count_sessions(id, project_id) ON DELETE CASCADE;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.count_assignments'::regclass
      AND conname = 'count_assignments_member_project_fk'
  ) THEN
    ALTER TABLE public.count_assignments
      ADD CONSTRAINT count_assignments_member_project_fk
      FOREIGN KEY (member_id, project_id)
      REFERENCES public.count_members(id, project_id) ON DELETE CASCADE;
  END IF;
END
$migration$;

ALTER TABLE public.count_assignments ALTER COLUMN project_id SET NOT NULL;
CREATE INDEX IF NOT EXISTS count_assignments_project_session_idx
  ON public.count_assignments(project_id, session_id, status);

CREATE OR REPLACE FUNCTION counting_private.set_count_assignment_project_id()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session_project uuid;
  v_member_project uuid;
BEGIN
  SELECT s.project_id INTO v_session_project
  FROM public.count_sessions s
  WHERE s.id = NEW.session_id;

  IF v_session_project IS NULL THEN
    RAISE EXCEPTION 'COUNT_ASSIGNMENT_SESSION_NOT_FOUND';
  END IF;

  SELECT m.project_id INTO v_member_project
  FROM public.count_members m
  WHERE m.id = NEW.member_id;

  IF v_member_project IS NULL THEN
    RAISE EXCEPTION 'COUNT_ASSIGNMENT_MEMBER_NOT_FOUND';
  END IF;

  IF v_member_project <> v_session_project THEN
    RAISE EXCEPTION 'COUNT_ASSIGNMENT_PROJECT_SCOPE_MISMATCH';
  END IF;

  IF NEW.project_id IS NOT NULL AND NEW.project_id <> v_session_project THEN
    RAISE EXCEPTION 'COUNT_ASSIGNMENT_PROJECT_SCOPE_MISMATCH';
  END IF;

  NEW.project_id := v_session_project;
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS count_assignments_project_scope_guard ON public.count_assignments;
CREATE TRIGGER count_assignments_project_scope_guard
BEFORE INSERT OR UPDATE OF session_id, member_id, project_id
ON public.count_assignments
FOR EACH ROW EXECUTE FUNCTION counting_private.set_count_assignment_project_id();

REVOKE ALL ON FUNCTION counting_private.set_count_assignment_project_id()
  FROM PUBLIC, anon, authenticated, service_role;

-- Reusable team master, scoped to one project.
CREATE TABLE IF NOT EXISTS public.count_teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL REFERENCES public.count_projects(id) ON DELETE CASCADE,
  code text NOT NULL,
  name text NOT NULL,
  description text,
  status text NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','paused','archived')),
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT count_teams_code_check CHECK (code ~ '^TEAM-[A-F0-9]{10}$'),
  CONSTRAINT count_teams_name_check CHECK (length(btrim(name)) BETWEEN 2 AND 120),
  CONSTRAINT count_teams_project_code_uq UNIQUE (project_id, code),
  CONSTRAINT count_teams_id_project_uq UNIQUE (id, project_id)
);

CREATE TABLE IF NOT EXISTS public.count_team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  team_id uuid NOT NULL,
  member_id uuid NOT NULL,
  team_role text NOT NULL DEFAULT 'member'
    CHECK (team_role IN ('leader','member')),
  status text NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','paused','removed')),
  added_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT count_team_members_team_member_uq UNIQUE (team_id, member_id),
  CONSTRAINT count_team_members_id_project_uq UNIQUE (id, project_id),
  CONSTRAINT count_team_members_team_project_fk
    FOREIGN KEY (team_id, project_id)
    REFERENCES public.count_teams(id, project_id) ON DELETE CASCADE,
  CONSTRAINT count_team_members_member_project_fk
    FOREIGN KEY (member_id, project_id)
    REFERENCES public.count_members(id, project_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS count_team_members_one_active_leader_uq
  ON public.count_team_members(team_id)
  WHERE status = 'active' AND team_role = 'leader';
CREATE INDEX IF NOT EXISTS count_team_members_project_status_idx
  ON public.count_team_members(project_id, status, team_id);
CREATE INDEX IF NOT EXISTS count_team_members_member_idx
  ON public.count_team_members(member_id, status);

-- A team-to-operation link is independent of an individual counter assignment.
CREATE TABLE IF NOT EXISTS public.count_session_teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  session_id uuid NOT NULL,
  team_id uuid NOT NULL,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active','removed')),
  assigned_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  removed_at timestamptz,
  CONSTRAINT count_session_teams_session_team_uq UNIQUE (session_id, team_id),
  CONSTRAINT count_session_teams_id_project_uq UNIQUE (id, project_id),
  CONSTRAINT count_session_teams_session_project_fk
    FOREIGN KEY (session_id, project_id)
    REFERENCES public.count_sessions(id, project_id) ON DELETE CASCADE,
  CONSTRAINT count_session_teams_team_project_fk
    FOREIGN KEY (team_id, project_id)
    REFERENCES public.count_teams(id, project_id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS count_session_teams_project_status_idx
  ON public.count_session_teams(project_id, status, session_id);

-- Immutable-in-practice operation roster snapshot. Later team edits apply to future assignments only.
CREATE TABLE IF NOT EXISTS public.count_session_team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  session_team_id uuid NOT NULL,
  member_id uuid NOT NULL,
  assignment_id uuid REFERENCES public.count_assignments(id) ON DELETE SET NULL,
  assignment_origin text NOT NULL CHECK (assignment_origin IN ('team_created','preexisting')),
  status text NOT NULL DEFAULT 'assigned'
    CHECK (status IN ('assigned','active','paused','done','removed')),
  created_at timestamptz NOT NULL DEFAULT now(),
  removed_at timestamptz,
  CONSTRAINT count_session_team_members_link_member_uq UNIQUE (session_team_id, member_id),
  CONSTRAINT count_session_team_members_id_project_uq UNIQUE (id, project_id),
  CONSTRAINT count_session_team_members_link_project_fk
    FOREIGN KEY (session_team_id, project_id)
    REFERENCES public.count_session_teams(id, project_id) ON DELETE CASCADE,
  CONSTRAINT count_session_team_members_member_project_fk
    FOREIGN KEY (member_id, project_id)
    REFERENCES public.count_members(id, project_id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS count_session_team_members_project_member_idx
  ON public.count_session_team_members(project_id, member_id, status);
CREATE INDEX IF NOT EXISTS count_session_team_members_assignment_idx
  ON public.count_session_team_members(assignment_id)
  WHERE assignment_id IS NOT NULL;

ALTER TABLE public.count_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.count_team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.count_session_teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.count_session_team_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS count_teams_read ON public.count_teams;
CREATE POLICY count_teams_read ON public.count_teams
  FOR SELECT TO authenticated
  USING (counting_private.has_project_permission(project_id, 'team.read'));

DROP POLICY IF EXISTS count_team_members_read ON public.count_team_members;
CREATE POLICY count_team_members_read ON public.count_team_members
  FOR SELECT TO authenticated
  USING (counting_private.has_project_permission(project_id, 'team.read'));

DROP POLICY IF EXISTS count_session_teams_read ON public.count_session_teams;
CREATE POLICY count_session_teams_read ON public.count_session_teams
  FOR SELECT TO authenticated
  USING (counting_private.has_project_permission(project_id, 'team.read'));

DROP POLICY IF EXISTS count_session_team_members_read ON public.count_session_team_members;
CREATE POLICY count_session_team_members_read ON public.count_session_team_members
  FOR SELECT TO authenticated
  USING (counting_private.has_project_permission(project_id, 'team.read'));

REVOKE ALL ON TABLE public.count_teams, public.count_team_members,
  public.count_session_teams, public.count_session_team_members FROM PUBLIC, anon;
GRANT SELECT ON TABLE public.count_teams, public.count_team_members,
  public.count_session_teams, public.count_session_team_members TO authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.count_teams, public.count_team_members,
  public.count_session_teams, public.count_session_team_members FROM authenticated;

-- Permission contract: client administrators and supervisors holding team.read
-- can see project memberships/assignments; each user retains access to their own membership.
DROP POLICY IF EXISTS count_members_read ON public.count_members;
CREATE POLICY count_members_read ON public.count_members
  FOR SELECT TO authenticated
  USING (
    counting_private.is_platform_owner()
    OR (
      NOT counting_private.is_platform_owner_actor(user_id)
      AND (
        user_id = (SELECT auth.uid())
        OR counting_private.has_project_permission(project_id, 'team.read')
      )
    )
  );

DROP POLICY IF EXISTS count_assignments_read ON public.count_assignments;
CREATE POLICY count_assignments_read ON public.count_assignments
  FOR SELECT TO authenticated
  USING (
    counting_private.is_platform_owner()
    OR (
      NOT EXISTS (
        SELECT 1 FROM public.count_members own_member
        WHERE own_member.id = count_assignments.member_id
          AND counting_private.is_platform_owner_actor(own_member.user_id)
      )
      AND (
        counting_private.has_project_permission(project_id, 'team.read')
        OR EXISTS (
          SELECT 1 FROM public.count_members own_member
          WHERE own_member.id = count_assignments.member_id
            AND own_member.user_id = (SELECT auth.uid())
            AND own_member.status = 'active'
        )
      )
    )
  );

-- Audit each master/assignment change through the existing CountFlow audit contract.
DROP TRIGGER IF EXISTS countflow_audit_row_change ON public.count_teams;
CREATE TRIGGER countflow_audit_row_change
AFTER INSERT OR UPDATE OR DELETE ON public.count_teams
FOR EACH ROW EXECUTE FUNCTION counting_private.audit_countflow_row_change();

DROP TRIGGER IF EXISTS countflow_audit_row_change ON public.count_team_members;
CREATE TRIGGER countflow_audit_row_change
AFTER INSERT OR UPDATE OR DELETE ON public.count_team_members
FOR EACH ROW EXECUTE FUNCTION counting_private.audit_countflow_row_change();

DROP TRIGGER IF EXISTS countflow_audit_row_change ON public.count_session_teams;
CREATE TRIGGER countflow_audit_row_change
AFTER INSERT OR UPDATE OR DELETE ON public.count_session_teams
FOR EACH ROW EXECUTE FUNCTION counting_private.audit_countflow_row_change();

DROP TRIGGER IF EXISTS countflow_audit_row_change ON public.count_session_team_members;
CREATE TRIGGER countflow_audit_row_change
AFTER INSERT OR UPDATE OR DELETE ON public.count_session_team_members
FOR EACH ROW EXECUTE FUNCTION counting_private.audit_countflow_row_change();

-- Internal helper. Existing mobile apps continue consuming count_assignments;
-- team membership is materialized into that established contract.
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
        UPDATE public.count_assignments
        SET status = 'assigned'
        WHERE id = v_assignment_id;
        v_assignment_status := 'assigned';
      END IF;
      v_assignment_origin := 'preexisting';
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

REVOKE ALL ON FUNCTION counting_private.count_team_assign_to_session_impl(uuid, uuid, boolean)
  FROM PUBLIC, anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.count_team_create(
  p_project_id uuid,
  p_name text,
  p_description text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_id uuid;
  v_code text := 'TEAM-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10));
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  IF NOT counting_private.has_project_permission(p_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;
  IF nullif(btrim(p_name), '') IS NULL OR length(btrim(p_name)) NOT BETWEEN 2 AND 120
     OR length(coalesce(p_description,'')) > 1000 THEN
    RAISE EXCEPTION 'INVALID_TEAM_INPUT';
  END IF;

  INSERT INTO public.count_teams(project_id, code, name, description, created_by)
  VALUES (p_project_id, v_code, btrim(p_name), nullif(btrim(coalesce(p_description,'')),''), (SELECT auth.uid()))
  RETURNING id INTO v_id;

  RETURN jsonb_build_object('id', v_id, 'project_id', p_project_id, 'code', v_code, 'status', 'active');
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_set_status(
  p_team_id uuid,
  p_status text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  SELECT project_id INTO v_project_id
  FROM public.count_teams WHERE id = p_team_id FOR UPDATE;
  IF v_project_id IS NULL THEN RAISE EXCEPTION 'TEAM_NOT_FOUND'; END IF;
  IF NOT counting_private.has_project_permission(v_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;
  IF p_status NOT IN ('active','paused','archived') THEN RAISE EXCEPTION 'INVALID_TEAM_STATUS'; END IF;

  IF p_status IN ('paused','archived') AND EXISTS (
    SELECT 1
    FROM public.count_session_teams st
    JOIN public.count_sessions s ON s.id = st.session_id AND s.project_id = st.project_id
    WHERE st.team_id = p_team_id AND st.status = 'active'
      AND s.status IN ('planned','active','paused','review')
  ) THEN
    RAISE EXCEPTION 'TEAM_HAS_OPEN_OPERATIONS_UNASSIGN_FIRST';
  END IF;

  UPDATE public.count_teams
  SET status = p_status, updated_at = now()
  WHERE id = p_team_id;
  RETURN jsonb_build_object('team_id', p_team_id, 'status', p_status);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_add_members(
  p_team_id uuid,
  p_member_ids uuid[]
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
  v_valid_count integer;
  v_input_count integer;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  SELECT project_id INTO v_project_id
  FROM public.count_teams WHERE id = p_team_id AND status = 'active' FOR UPDATE;
  IF v_project_id IS NULL THEN RAISE EXCEPTION 'ACTIVE_TEAM_NOT_FOUND'; END IF;
  IF NOT counting_private.has_project_permission(v_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;

  v_input_count := coalesce(cardinality(p_member_ids), 0);
  IF v_input_count < 1 OR v_input_count > 500 THEN RAISE EXCEPTION 'INVALID_TEAM_MEMBER_BATCH_SIZE'; END IF;

  SELECT count(DISTINCT x) INTO v_valid_count
  FROM unnest(p_member_ids) AS x
  JOIN public.count_members m ON m.id = x
  WHERE m.project_id = v_project_id
    AND m.status = 'active'
    AND NOT counting_private.is_platform_owner_actor(m.user_id);

  IF v_valid_count <> (SELECT count(DISTINCT x) FROM unnest(p_member_ids) AS x) THEN
    RAISE EXCEPTION 'TEAM_MEMBERS_MUST_BE_ACTIVE_IN_SAME_PROJECT';
  END IF;

  INSERT INTO public.count_team_members(project_id, team_id, member_id, team_role, status, added_by)
  SELECT v_project_id, p_team_id, x, 'member', 'active', (SELECT auth.uid())
  FROM (SELECT DISTINCT unnest(p_member_ids) AS x) selected
  ON CONFLICT (team_id, member_id)
  DO UPDATE SET status = 'active', updated_at = now(), added_by = EXCLUDED.added_by;

  RETURN jsonb_build_object('team_id', p_team_id, 'added_or_reactivated', v_valid_count);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_set_member_role(
  p_team_id uuid,
  p_member_id uuid,
  p_team_role text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  SELECT project_id INTO v_project_id FROM public.count_teams
  WHERE id = p_team_id AND status = 'active' FOR UPDATE;
  IF v_project_id IS NULL THEN RAISE EXCEPTION 'ACTIVE_TEAM_NOT_FOUND'; END IF;
  IF NOT counting_private.has_project_permission(v_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;
  IF p_team_role NOT IN ('leader','member') THEN RAISE EXCEPTION 'INVALID_TEAM_ROLE'; END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.count_team_members
    WHERE team_id = p_team_id AND member_id = p_member_id AND status = 'active'
  ) THEN RAISE EXCEPTION 'ACTIVE_TEAM_MEMBER_NOT_FOUND'; END IF;

  IF p_team_role = 'leader' THEN
    UPDATE public.count_team_members
    SET team_role = 'member', updated_at = now()
    WHERE team_id = p_team_id AND status = 'active' AND member_id <> p_member_id;
  END IF;

  UPDATE public.count_team_members
  SET team_role = p_team_role, updated_at = now()
  WHERE team_id = p_team_id AND member_id = p_member_id;

  RETURN jsonb_build_object('team_id', p_team_id, 'member_id', p_member_id, 'team_role', p_team_role);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_remove_member(
  p_team_id uuid,
  p_member_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  SELECT project_id INTO v_project_id FROM public.count_teams
  WHERE id = p_team_id FOR UPDATE;
  IF v_project_id IS NULL THEN RAISE EXCEPTION 'TEAM_NOT_FOUND'; END IF;
  IF NOT counting_private.has_project_permission(v_project_id, 'team.manage') THEN
    RAISE EXCEPTION 'TEAM_MANAGE_PERMISSION_REQUIRED';
  END IF;

  UPDATE public.count_team_members
  SET status = 'removed', updated_at = now()
  WHERE team_id = p_team_id AND member_id = p_member_id AND status <> 'removed';

  IF NOT FOUND THEN RAISE EXCEPTION 'TEAM_MEMBER_NOT_FOUND'; END IF;
  RETURN jsonb_build_object('team_id', p_team_id, 'member_id', p_member_id, 'status', 'removed',
    'existing_operation_snapshots_preserved', true);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_assign_to_session(
  p_team_id uuid,
  p_session_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
BEGIN
  RETURN counting_private.count_team_assign_to_session_impl(p_team_id, p_session_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_assign_many_to_session(
  p_session_id uuid,
  p_team_ids uuid[]
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_team_id uuid;
  v_results jsonb := '[]'::jsonb;
  v_count integer;
BEGIN
  IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
  v_count := coalesce(cardinality(p_team_ids), 0);
  IF v_count < 1 OR v_count > 100 THEN RAISE EXCEPTION 'INVALID_TEAM_ASSIGNMENT_BATCH_SIZE'; END IF;
  IF v_count <> (SELECT count(DISTINCT x) FROM unnest(p_team_ids) AS x) THEN
    RAISE EXCEPTION 'DUPLICATE_TEAM_IDS';
  END IF;

  FOREACH v_team_id IN ARRAY p_team_ids LOOP
    v_results := v_results || jsonb_build_array(
      counting_private.count_team_assign_to_session_impl(v_team_id, p_session_id, false)
    );
  END LOOP;
  RETURN jsonb_build_object('session_id', p_session_id, 'teams', v_results);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_team_unassign_from_session(
  p_team_id uuid,
  p_session_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
  v_session_status text;
  v_link_id uuid;
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

  SELECT id INTO v_link_id
  FROM public.count_session_teams
  WHERE team_id = p_team_id AND session_id = p_session_id
    AND project_id = v_project_id AND status = 'active'
  FOR UPDATE;

  IF v_link_id IS NULL THEN RAISE EXCEPTION 'ACTIVE_SESSION_TEAM_NOT_FOUND'; END IF;

  UPDATE public.count_session_teams
  SET status = 'removed', removed_at = now(), updated_at = now()
  WHERE id = v_link_id;

  UPDATE public.count_session_team_members
  SET status = 'removed', removed_at = now()
  WHERE session_team_id = v_link_id AND status <> 'removed';

  UPDATE public.count_assignments a
  SET status = 'paused'
  FROM public.count_session_team_members stm
  WHERE stm.session_team_id = v_link_id
    AND stm.assignment_id = a.id
    AND stm.assignment_origin = 'team_created'
    AND a.status IN ('assigned','active')
    AND NOT EXISTS (
      SELECT 1
      FROM public.count_session_team_members other_member
      JOIN public.count_session_teams other_team
        ON other_team.id = other_member.session_team_id
      WHERE other_team.session_id = p_session_id
        AND other_team.status = 'active'
        AND other_member.member_id = stm.member_id
        AND other_member.status IN ('assigned','active','paused')
    );

  RETURN jsonb_build_object('team_id', p_team_id, 'session_id', p_session_id,
    'status', 'removed', 'count_history_preserved', true);
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_create_operation_with_teams(
  p_client_id uuid,
  p_project_name text,
  p_project_code text,
  p_operation_name text,
  p_operation_code text,
  p_operation_type text,
  p_branch_name text,
  p_branch_code text,
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
  p_team_ids uuid[] DEFAULT ARRAY[]::uuid[]
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_result jsonb;
  v_session_id uuid;
  v_team_id uuid;
  v_team_count integer := 0;
  v_team_results jsonb := '[]'::jsonb;
BEGIN
  IF p_operation_type NOT IN ('unclassified','full_inventory','cycle_count','spot_check','recount','audit','other') THEN
    RAISE EXCEPTION 'INVALID_OPERATION_TYPE';
  END IF;
  IF coalesce(cardinality(p_team_ids),0) > 100
     OR coalesce(cardinality(p_team_ids),0) <> (
       SELECT count(DISTINCT x) FROM unnest(coalesce(p_team_ids, ARRAY[]::uuid[])) AS x
     ) THEN
    RAISE EXCEPTION 'INVALID_OPERATION_TEAM_IDS';
  END IF;

  v_result := counting_private.count_create_operation_impl(
    p_client_id,p_project_name,p_project_code,p_operation_name,p_operation_code,
    p_branch_name,p_branch_code,p_planned_start_at,p_planned_end_at,p_timezone,
    p_priority,p_counting_mode,p_show_expected_quantity,p_capture_images,
    p_require_images,p_allow_unknown_products,p_instructions
  );

  v_session_id := (v_result->>'session_id')::uuid;
  UPDATE public.count_sessions SET operation_type = p_operation_type WHERE id = v_session_id;

  FOREACH v_team_id IN ARRAY coalesce(p_team_ids, ARRAY[]::uuid[]) LOOP
    v_team_results := v_team_results || jsonb_build_array(
      counting_private.count_team_assign_to_session_impl(v_team_id, v_session_id, true)
    );
    v_team_count := v_team_count + 1;
  END LOOP;

  RETURN v_result || jsonb_build_object(
    'operation_type', p_operation_type,
    'teams_assigned', v_team_count,
    'team_results', v_team_results
  );
END;
$function$;

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
    SELECT count(*) FROM public.count_members m
    WHERE m.id = ANY(p_member_ids)
      AND m.project_id = p_project_id
      AND m.status = 'active'
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
  ) THEN
    RAISE EXCEPTION 'OPERATION_MEMBERS_MUST_BE_ACTIVE_IN_PROJECT';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.count_members m
    JOIN public.count_assignments a ON a.member_id = m.id
    WHERE a.session_id IS NULL AND false
  ) THEN
    RAISE EXCEPTION 'INVALID_OPERATION_ASSIGNEES';
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
CREATE OR REPLACE VIEW public.count_team_overview
WITH (security_invoker = true)
AS
WITH roster AS (
  SELECT tm.team_id,
         count(DISTINCT tm.member_id) FILTER (WHERE tm.status = 'active' AND m.status = 'active') AS active_members
  FROM public.count_team_members tm
  JOIN public.count_members m ON m.id = tm.member_id AND m.project_id = tm.project_id
  GROUP BY tm.team_id
),
operations AS (
  SELECT st.team_id,
         count(DISTINCT st.session_id) FILTER (WHERE st.status = 'active') AS assigned_operations,
         count(DISTINCT st.session_id) FILTER (WHERE st.status = 'active' AND s.status = 'active') AS active_operations,
         count(DISTINCT st.session_id) FILTER (WHERE st.status = 'active' AND s.status = 'completed') AS completed_operations
  FROM public.count_session_teams st
  JOIN public.count_sessions s ON s.id = st.session_id AND s.project_id = st.project_id
  GROUP BY st.team_id
),
activity AS (
  SELECT st.team_id,
         count(DISTINCT e.id) AS entry_events,
         count(DISTINCT e.member_id) AS active_counters,
         count(DISTINCT e.product_id) AS counted_products,
         max(e.counted_at) AS last_counted_at
  FROM public.count_session_teams st
  JOIN public.count_session_team_members stm
    ON stm.session_team_id = st.id AND stm.project_id = st.project_id
  JOIN public.count_entries e
    ON e.session_id = st.session_id AND e.member_id = stm.member_id
  WHERE st.status = 'active' AND stm.status IN ('assigned','active','done')
  GROUP BY st.team_id
)
SELECT t.id AS team_id, t.project_id, t.code AS team_code, t.name AS team_name,
       t.description, t.status, t.created_at, t.updated_at,
       coalesce(r.active_members,0)::bigint AS active_members,
       coalesce(o.assigned_operations,0)::bigint AS assigned_operations,
       coalesce(o.active_operations,0)::bigint AS active_operations,
       coalesce(o.completed_operations,0)::bigint AS completed_operations,
       coalesce(a.entry_events,0)::bigint AS entry_events,
       coalesce(a.active_counters,0)::bigint AS active_counters,
       coalesce(a.counted_products,0)::bigint AS counted_products,
       a.last_counted_at
FROM public.count_teams t
LEFT JOIN roster r ON r.team_id = t.id
LEFT JOIN operations o ON o.team_id = t.id
LEFT JOIN activity a ON a.team_id = t.id;

-- Platform counters use Cairo's calendar month and remain subject to underlying RLS.
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
      WHERE (p_project_id IS NULL OR t.project_id = p_project_id)
        AND t.status = 'active' AND tm.status = 'active' AND m.status = 'active'
        AND NOT counting_private.is_platform_owner_actor(m.user_id)),
    (SELECT count(DISTINCT m.user_id)::bigint
       FROM public.count_assignments a
       JOIN public.count_sessions s ON s.id = a.session_id AND s.project_id = a.project_id
       JOIN public.count_members m ON m.id = a.member_id AND m.project_id = a.project_id
      WHERE (p_project_id IS NULL OR a.project_id = p_project_id)
        AND s.status = 'active'
        AND a.status IN ('assigned','active')
        AND m.status = 'active'
        AND NOT counting_private.is_platform_owner_actor(m.user_id));
$function$;

-- Preserve the existing overview contract and append the new fields.
CREATE OR REPLACE VIEW public.count_operation_overview AS
SELECT p.client_id,
       p.id AS project_id,
       p.name AS project_name,
       p.code AS project_code,
       p.status AS project_status,
       s.id AS session_id,
       s.name AS operation_name,
       s.operation_code,
       s.status AS operation_status,
       s.planned_start_at,
       s.planned_end_at,
       s.schedule_timezone,
       s.priority,
       s.counting_mode,
       s.show_expected_quantity,
       s.capture_images,
       s.require_images,
       s.branch_location_id,
       coalesce(prod.active_products,0::bigint) AS active_products,
       coalesce(ent.entry_events,0::bigint) AS entry_events,
       coalesce(ent.counted_products,0::bigint) AS counted_products,
       coalesce(ent.counted_locations,0::bigint) AS counted_locations,
       coalesce(ent.active_counters,0::bigint) AS active_counters,
       coalesce(team.assigned_members,0::bigint) AS assigned_members,
       coalesce(team.active_assignments,0::bigint) AS active_assignments,
       coalesce(loc.location_count,0::bigint) AS location_count,
       ent.last_counted_at,
       s.created_at AS operation_created_at,
       s.operation_type,
       coalesce(team_scope.active_teams,0::bigint) AS active_teams,
       coalesce(team_scope.active_team_members,0::bigint) AS active_team_members
FROM public.count_projects p
JOIN public.count_sessions s ON s.project_id = p.id
LEFT JOIN LATERAL (
  SELECT count(*) AS active_products
  FROM public.count_products cp
  WHERE cp.project_id = p.id AND cp.is_active
) prod ON true
LEFT JOIN LATERAL (
  SELECT count(*) AS entry_events,
         count(DISTINCT e.product_id) AS counted_products,
         count(DISTINCT e.location_id) FILTER (WHERE e.location_id IS NOT NULL) AS counted_locations,
         count(DISTINCT e.member_id) AS active_counters,
         max(e.counted_at) AS last_counted_at
  FROM public.count_entries e
  WHERE e.session_id = s.id AND e.project_id = p.id
) ent ON true
LEFT JOIN LATERAL (
  SELECT count(DISTINCT a.member_id) AS assigned_members,
         count(*) FILTER (WHERE a.status = ANY (ARRAY['assigned'::text,'active'::text])) AS active_assignments
  FROM public.count_assignments a
  WHERE a.session_id = s.id AND a.project_id = p.id
) team ON true
LEFT JOIN LATERAL (
  SELECT count(*) AS location_count
  FROM public.count_locations l
  WHERE l.project_id = p.id
) loc ON true
LEFT JOIN LATERAL (
  SELECT count(DISTINCT st.team_id) FILTER (WHERE st.status = 'active') AS active_teams,
         count(DISTINCT stm.member_id) FILTER (
           WHERE st.status = 'active' AND stm.status IN ('assigned','active','done')
         ) AS active_team_members
  FROM public.count_session_teams st
  LEFT JOIN public.count_session_team_members stm ON stm.session_team_id = st.id
  WHERE st.session_id = s.id AND st.project_id = p.id
) team_scope ON true;

REVOKE ALL ON FUNCTION public.count_team_create(uuid,text,text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_set_status(uuid,text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_add_members(uuid,uuid[]) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_set_member_role(uuid,uuid,text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_remove_member(uuid,uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_assign_to_session(uuid,uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_assign_many_to_session(uuid,uuid[]) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_team_unassign_from_session(uuid,uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_create_operation_with_teams(uuid,text,text,text,text,text,text,text,timestamptz,timestamptz,text,smallint,text,boolean,boolean,boolean,boolean,text,uuid[]) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_create_session_with_teams(uuid,text,text,text,uuid,timestamptz,timestamptz,text,smallint,text,boolean,boolean,boolean,boolean,text,uuid[],uuid[]) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.count_admin_platform_kpis(uuid) FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.count_team_create(uuid,text,text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_set_status(uuid,text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_add_members(uuid,uuid[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_set_member_role(uuid,uuid,text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_remove_member(uuid,uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_assign_to_session(uuid,uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_assign_many_to_session(uuid,uuid[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_team_unassign_from_session(uuid,uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_create_operation_with_teams(uuid,text,text,text,text,text,text,text,timestamptz,timestamptz,text,smallint,text,boolean,boolean,boolean,boolean,text,uuid[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_create_session_with_teams(uuid,text,text,text,uuid,timestamptz,timestamptz,text,smallint,text,boolean,boolean,boolean,boolean,text,uuid[],uuid[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_admin_platform_kpis(uuid) TO authenticated;

GRANT SELECT ON public.count_team_overview TO authenticated;

-- Supabase Postgres Changes requires publication membership for the project-scoped filters.
DO $publication$
DECLARE
  v_table text;
BEGIN
  FOREACH v_table IN ARRAY ARRAY[
    'count_assignments','count_teams','count_team_members',
    'count_session_teams','count_session_team_members'
  ] LOOP
    IF NOT EXISTS (
      SELECT 1 FROM pg_publication_tables
      WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = v_table
    ) THEN
      EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE public.%I', v_table);
    END IF;
  END LOOP;
END
$publication$;

COMMENT ON TABLE public.count_teams IS
  'Reusable project-scoped teams. Team membership changes apply to future operation snapshots; they do not rewrite historical assignments.';
COMMENT ON TABLE public.count_session_teams IS
  'Team assignment to a specific counting operation.';
COMMENT ON TABLE public.count_session_team_members IS
  'Operation-scoped snapshot of the members belonging to an assigned team.';
COMMENT ON COLUMN public.count_sessions.operation_type IS
  'Business classification of the counting operation; separate from counting_mode, which describes barcode/manual capture.';
COMMENT ON COLUMN public.count_assignments.project_id IS
  'Derived by a database trigger from the session; enables tenant-safe project-scoped reads and realtime filters.';
