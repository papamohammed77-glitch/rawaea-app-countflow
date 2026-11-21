-- A reconciliation freeze must start from a paused session. This ensures
-- counters cannot add new local work after the owner checks device queues.
DO $countflow_approval_requires_paused_session$
DECLARE
  v_oid regprocedure := to_regprocedure('public.count_approve_reconciliation(uuid)');
  v_definition text;
  v_updated text;
BEGIN
  IF v_oid IS NULL THEN RAISE EXCEPTION 'COUNT_APPROVE_RECONCILIATION_MISSING'; END IF;
  v_definition:=pg_get_functiondef(v_oid::oid);
  v_updated:=replace(
    v_definition,
    'v_session_status NOT IN (''active'',''paused'',''review'')',
    'v_session_status<>''paused'''
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_APPROVAL_STATUS_GUARD_ANCHOR_NOT_FOUND'; END IF;
  IF v_updated ~ 'v_session_status NOT IN' THEN RAISE EXCEPTION 'COUNT_APPROVAL_STATUS_GUARD_VALIDATION_FAILED'; END IF;
  EXECUTE v_updated;
END
$countflow_approval_requires_paused_session$;

COMMENT ON FUNCTION public.count_approve_reconciliation(uuid)
IS 'Owner-only reconciliation approval requires a paused session and current device queue acknowledgements; review lifecycle requires a fresh acknowledgement before completion.';
