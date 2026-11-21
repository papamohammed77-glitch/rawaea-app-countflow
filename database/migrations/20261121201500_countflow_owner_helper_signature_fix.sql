-- CountFlow P1 compatibility repair:
-- is_platform_owner() is a global Auth identity helper and has no project argument.
-- Ten existing RPC/internal functions retained the obsolete project_id parameter.
-- Update only these exact function signatures, preserving security mode and all other logic.
DO $countflow_owner_helper_signature_fix$
DECLARE
  v_signature text;
  v_oid regprocedure;
  v_definition text;
  v_corrected text;
  v_signatures text[] := ARRAY[
    'counting_private.count_commit_import_batch_impl(uuid)',
    'counting_private.count_create_import_batch_impl(uuid,uuid,text,text,text)',
    'counting_private.count_stage_import_rows_impl(uuid,jsonb,integer)',
    'public.count_approve_reconciliation(uuid)',
    'public.count_assign_recount_task(uuid,uuid)',
    'public.count_evaluate_session_alerts(uuid)',
    'public.count_generate_recount_tasks(uuid,uuid,numeric)',
    'public.count_reconcile_session(uuid)',
    'public.count_review_recount_task(uuid,text,text)',
    'public.count_transition_session(uuid,text)'
  ];
  v_changed integer := 0;
BEGIN
  FOREACH v_signature IN ARRAY v_signatures LOOP
    v_oid := to_regprocedure(v_signature);
    IF v_oid IS NULL THEN
      RAISE EXCEPTION 'COUNTFLOW_OWNER_HELPER_TARGET_MISSING:%', v_signature;
    END IF;

    v_definition := pg_get_functiondef(v_oid::oid);
    IF v_definition !~ 'counting_private\.is_platform_owner\([^)]{1,}\)' THEN
      RAISE EXCEPTION 'COUNTFLOW_OWNER_HELPER_OBSOLETE_CALL_NOT_FOUND:%', v_signature;
    END IF;

    v_corrected := regexp_replace(
      v_definition,
      'counting_private\.is_platform_owner\([^)]*\)',
      'counting_private.is_platform_owner()',
      'g'
    );

    IF v_corrected = v_definition
       OR v_corrected ~ 'counting_private\.is_platform_owner\([^)]{1,}' THEN
      RAISE EXCEPTION 'COUNTFLOW_OWNER_HELPER_REWRITE_VALIDATION_FAILED:%', v_signature;
    END IF;

    EXECUTE v_corrected;
    v_changed := v_changed + 1;
  END LOOP;

  IF v_changed <> 10 THEN
    RAISE EXCEPTION 'COUNTFLOW_OWNER_HELPER_CHANGED_COUNT_MISMATCH:%', v_changed;
  END IF;
END
$countflow_owner_helper_signature_fix$;

COMMENT ON FUNCTION public.count_transition_session(uuid,text)
IS 'CountFlow owner-only session state transition; uses the zero-argument platform owner identity helper.';
COMMENT ON FUNCTION public.count_reconcile_session(uuid)
IS 'CountFlow owner-only reconciliation; uses the zero-argument platform owner identity helper.';
COMMENT ON FUNCTION public.count_approve_reconciliation(uuid)
IS 'CountFlow owner-only reconciliation approval; uses the zero-argument platform owner identity helper.';
COMMENT ON FUNCTION public.count_generate_recount_tasks(uuid,uuid,numeric)
IS 'CountFlow owner-only recount generation; only computed runs and active counter assignees are accepted.';
