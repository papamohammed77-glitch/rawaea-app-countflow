-- CountFlow: reconciliation/finalization must account for devices that actually submitted count events.
-- This closes the case where a presence row is missing even though the server has accepted entries from that device.
CREATE OR REPLACE FUNCTION counting_private.assert_session_device_queues_clear(p_session_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_version bigint;
  v_blocked integer;
  v_missing_presence integer;
BEGIN
  SELECT s.sync_barrier_version INTO v_version
  FROM public.count_sessions s
  WHERE s.id=p_session_id;
  IF v_version IS NULL THEN
    RAISE EXCEPTION 'SESSION_NOT_FOUND';
  END IF;

  SELECT count(*) INTO v_blocked
  FROM public.count_presence p
  JOIN public.count_members m ON m.id=p.member_id AND m.project_id=p.project_id
  WHERE p.session_id=p_session_id
    AND m.role='counter'
    AND NOT (
      p.pending_queue_count=0
      AND p.acknowledged_lifecycle_version=v_version
    )
    AND NOT (
      p.queue_resolution='waived'
      AND nullif(btrim(p.queue_resolution_reason),'') IS NOT NULL
      AND p.queue_resolved_by IS NOT NULL
      AND p.queue_resolved_at IS NOT NULL
    );

  SELECT count(*) INTO v_missing_presence
  FROM (
    SELECT DISTINCT e.member_id,e.device_id
    FROM public.count_entries e
    JOIN public.count_members m ON m.id=e.member_id AND m.project_id=e.project_id
    WHERE e.session_id=p_session_id
      AND e.device_id IS NOT NULL
      AND m.role='counter'
  ) used_devices
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.count_presence p
    WHERE p.session_id=p_session_id
      AND p.member_id=used_devices.member_id
      AND p.device_id=used_devices.device_id
  );

  v_blocked:=v_blocked+v_missing_presence;
  IF v_blocked>0 THEN
    RAISE EXCEPTION 'SESSION_HAS_UNACKNOWLEDGED_DEVICE_QUEUES:%',v_blocked;
  END IF;
END;
$function$;
REVOKE ALL ON FUNCTION counting_private.assert_session_device_queues_clear(uuid) FROM PUBLIC,anon,authenticated;
