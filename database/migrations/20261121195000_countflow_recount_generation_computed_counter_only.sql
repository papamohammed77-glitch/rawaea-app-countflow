-- CountFlow: recount tasks must originate from an unapproved computed run
-- and can only be assigned to active counter members.
-- This changes one RPC definition only; no operational data is modified.
DO $countflow_recount_generation_hardening$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef(
    'public.count_generate_recount_tasks(uuid,uuid,numeric)'::regprocedure
  ) INTO v_definition;

  v_updated := replace(
    v_definition,
    'IF v_run.status NOT IN (''computed'',''approved'') THEN',
    'IF v_run.status <> ''computed'' THEN'
  );
  IF v_updated = v_definition THEN
    RAISE EXCEPTION 'COUNT_RECOUNT_GENERATION_STATUS_GUARD_NOT_FOUND';
  END IF;

  v_definition := v_updated;
  v_updated := replace(
    v_definition,
    'role IN (''counter'',''auditor'') AND status=''active''',
    'role = ''counter'' AND status=''active'''
  );
  IF v_updated = v_definition THEN
    RAISE EXCEPTION 'COUNT_RECOUNT_GENERATION_ASSIGNEE_GUARD_NOT_FOUND';
  END IF;

  IF position(''approved'' IN v_updated) > 0
     OR position(''auditor'' IN v_updated) > 0 THEN
    RAISE EXCEPTION 'COUNT_RECOUNT_GENERATION_UNSAFE_ROLE_OR_STATUS_REMAINS';
  END IF;

  EXECUTE v_updated;
END
$countflow_recount_generation_hardening$;

COMMENT ON FUNCTION public.count_generate_recount_tasks(uuid,uuid,numeric)
IS 'CountFlow owner-only recount generation; accepts only computed runs and active counter assignees. Approved/frozen runs cannot spawn new recount work.';
