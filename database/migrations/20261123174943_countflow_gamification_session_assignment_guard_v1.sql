-- LVE-763 follow-up: only session participants may view the gamification snapshot.
-- An active Counter membership in the same project is not sufficient when the
-- session has explicit assignments; the caller must have an active assignment.

CREATE OR REPLACE FUNCTION counting_private.assert_gamification_session_participation(p_session_id uuid)
RETURNS void
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_user_id uuid := (SELECT auth.uid());
  v_project_id uuid;
  v_member_id uuid;
  v_has_assignments boolean := false;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'AUTH_REQUIRED';
  END IF;

  SELECT s.project_id
    INTO v_project_id
  FROM public.count_sessions s
  WHERE s.id = p_session_id
    AND s.status IN ('active','paused','review');

  IF NOT FOUND THEN
    RAISE EXCEPTION 'SESSION_NOT_AVAILABLE';
  END IF;

  SELECT m.id
    INTO v_member_id
  FROM public.count_members m
  WHERE m.project_id = v_project_id
    AND m.user_id = v_user_id
    AND m.role = 'counter'
    AND m.status = 'active'
  LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'COUNTER_MEMBERSHIP_REQUIRED';
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM public.count_assignments a
    WHERE a.session_id = p_session_id
  ) INTO v_has_assignments;

  IF v_has_assignments AND NOT EXISTS (
    SELECT 1
    FROM public.count_assignments a
    WHERE a.session_id = p_session_id
      AND a.member_id = v_member_id
      AND a.status IN ('assigned','active')
  ) THEN
    RAISE EXCEPTION 'COUNTER_NOT_ASSIGNED_TO_SESSION';
  END IF;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.assert_gamification_session_participation(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION counting_private.assert_gamification_session_participation(uuid) FROM anon;
GRANT EXECUTE ON FUNCTION counting_private.assert_gamification_session_participation(uuid) TO authenticated;

CREATE OR REPLACE FUNCTION public.count_get_gamification_snapshot(p_session_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path TO ''
AS $function$
BEGIN
  PERFORM counting_private.assert_gamification_session_participation(p_session_id);
  RETURN counting_private.count_gamification_snapshot(p_session_id);
END;
$function$;

REVOKE ALL ON FUNCTION public.count_get_gamification_snapshot(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.count_get_gamification_snapshot(uuid) FROM anon;
GRANT EXECUTE ON FUNCTION public.count_get_gamification_snapshot(uuid) TO authenticated;

COMMENT ON FUNCTION counting_private.assert_gamification_session_participation(uuid)
IS 'Requires the authenticated caller to be an active Counter member of the requested session; when session assignments exist, the caller must own at least one active/assigned row.';

COMMENT ON FUNCTION public.count_get_gamification_snapshot(uuid)
IS 'Authenticated CountFlow gamification RPC. A server-side session participation guard runs before the server-derived snapshot.';
