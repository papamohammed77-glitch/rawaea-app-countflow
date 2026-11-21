-- The queue-barrier migration introduced the final stale project-argument call.
-- The shared CountFlow owner helper is global and accepts no project UUID.
DO $queue_waiver_owner_helper_fix$
DECLARE
  v_oid regprocedure := to_regprocedure('public.count_waive_device_queue(uuid,uuid,text,text)');
  v_definition text;
  v_corrected text;
BEGIN
  IF v_oid IS NULL THEN RAISE EXCEPTION 'COUNT_QUEUE_WAIVER_FUNCTION_MISSING'; END IF;
  v_definition:=pg_get_functiondef(v_oid::oid);
  IF v_definition !~ 'counting_private\.is_platform_owner\([^)]{1,}\)' THEN
    RAISE EXCEPTION 'COUNT_QUEUE_WAIVER_OBSOLETE_OWNER_CALL_NOT_FOUND';
  END IF;
  v_corrected:=regexp_replace(
    v_definition,
    'counting_private\.is_platform_owner\([^)]*\)',
    'counting_private.is_platform_owner()',
    'g'
  );
  IF v_corrected=v_definition OR v_corrected ~ 'counting_private\.is_platform_owner\([^)]{1,}' THEN
    RAISE EXCEPTION 'COUNT_QUEUE_WAIVER_OWNER_CALL_REWRITE_FAILED';
  END IF;
  EXECUTE v_corrected;
END
$queue_waiver_owner_helper_fix$;

COMMENT ON FUNCTION public.count_waive_device_queue(uuid,uuid,text,text)
IS 'Owner-only audited waiver for a device-local queue that cannot be recovered; uses the zero-argument platform-owner identity helper.';
