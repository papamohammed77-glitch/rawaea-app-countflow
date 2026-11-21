-- A device that has already acknowledged a zero queue for the current
-- lifecycle version cannot be waived; waiver is only for unresolved/stale work.
DO $countflow_queue_waiver_clear_device_guard$
DECLARE
  v_oid regprocedure := to_regprocedure('public.count_waive_device_queue(uuid,uuid,text,text)');
  v_definition text;
  v_updated text;
  v_anchor text := '  IF NOT FOUND THEN RAISE EXCEPTION ''DEVICE_PRESENCE_NOT_FOUND''; END IF;';
  v_guard text := E'  IF v_presence.pending_queue_count=0\n     AND v_presence.acknowledged_lifecycle_version=v_session.sync_barrier_version\n     AND v_presence.queue_resolution IS DISTINCT FROM ''waived'' THEN\n    RAISE EXCEPTION ''DEVICE_QUEUE_ALREADY_CLEAR'';\n  END IF;';
BEGIN
  IF v_oid IS NULL THEN RAISE EXCEPTION 'COUNT_QUEUE_WAIVER_FUNCTION_MISSING'; END IF;
  v_definition:=pg_get_functiondef(v_oid::oid);
  IF position(v_anchor IN v_definition)=0 THEN RAISE EXCEPTION 'COUNT_QUEUE_WAIVER_PRESENCE_ANCHOR_NOT_FOUND'; END IF;
  v_updated:=replace(v_definition,v_anchor,v_anchor||E'\n'||v_guard);
  IF v_updated=v_definition OR position('DEVICE_QUEUE_ALREADY_CLEAR' IN v_updated)=0 THEN
    RAISE EXCEPTION 'COUNT_QUEUE_WAIVER_CLEAR_GUARD_REWRITE_FAILED';
  END IF;
  EXECUTE v_updated;
END
$countflow_queue_waiver_clear_device_guard$;

COMMENT ON FUNCTION public.count_waive_device_queue(uuid,uuid,text,text)
IS 'Owner-only audit of unresolved device-local queue risk; a device already acknowledged empty at the current lifecycle version cannot be waived.';
