-- CountFlow: count_presence is a composite-key table without a surrogate id.
-- Audit a device queue waiver against the owning session id and identify the device in details.
CREATE OR REPLACE FUNCTION public.count_waive_device_queue(
  p_session_id uuid,
  p_member_id uuid,
  p_device_id text,
  p_reason text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session public.count_sessions;
  v_presence public.count_presence;
  v_actor uuid := (SELECT auth.uid());
BEGIN
  IF nullif(btrim(p_reason),'') IS NULL OR length(btrim(p_reason))<10 OR length(p_reason)>1000 THEN
    RAISE EXCEPTION 'DEVICE_QUEUE_WAIVER_REASON_REQUIRED';
  END IF;

  SELECT * INTO v_session FROM public.count_sessions WHERE id=p_session_id FOR UPDATE;
  IF NOT FOUND OR NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'SESSION_NOT_FOUND_OR_FORBIDDEN';
  END IF;
  IF v_session.status='completed' THEN RAISE EXCEPTION 'SESSION_ALREADY_COMPLETED'; END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.count_members m
    WHERE m.id=p_member_id AND m.project_id=v_session.project_id AND m.role='counter'
  ) THEN
    RAISE EXCEPTION 'COUNTER_DEVICE_NOT_FOUND';
  END IF;

  SELECT * INTO v_presence
  FROM public.count_presence p
  WHERE p.session_id=p_session_id AND p.member_id=p_member_id AND p.device_id=p_device_id
  FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'DEVICE_PRESENCE_NOT_FOUND'; END IF;

  UPDATE public.count_presence
  SET queue_resolution='waived',
      queue_resolution_reason=btrim(p_reason),
      queue_resolved_by=v_actor,
      queue_resolved_at=now(),
      acknowledged_lifecycle_version=v_session.sync_barrier_version
  WHERE session_id=p_session_id AND member_id=p_member_id AND device_id=p_device_id
  RETURNING * INTO v_presence;

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(
    v_session.project_id,v_actor,'device.queue_waived','count_device_queue',p_session_id,
    jsonb_build_object(
      'session_id',p_session_id,'member_id',p_member_id,'device_id',p_device_id,
      'pending_queue_count',v_presence.pending_queue_count,
      'pending_queue_digest',v_presence.pending_queue_digest,
      'last_queue_reported_at',v_presence.queue_reported_at,
      'lifecycle_version',v_session.sync_barrier_version,
      'reason',btrim(p_reason)
    )
  );

  RETURN jsonb_build_object(
    'ok',true,'session_id',p_session_id,'member_id',p_member_id,
    'device_id',p_device_id,'resolution','waived',
    'pending_queue_count',v_presence.pending_queue_count,
    'pending_queue_digest',v_presence.pending_queue_digest
  );
END;
$function$;

REVOKE ALL ON FUNCTION public.count_waive_device_queue(uuid,uuid,text,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_waive_device_queue(uuid,uuid,text,text) TO authenticated;
