-- CountFlow alert status RPC: reject NULL targets and make acknowledgement idempotent.
CREATE OR REPLACE FUNCTION public.count_set_alert_status(
  p_alert_id uuid,
  p_target_status text,
  p_note text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_alert public.count_alerts;
  v_actor uuid := (SELECT auth.uid());
  v_note text := nullif(btrim(p_note),'');
BEGIN
  IF p_target_status IS NULL OR p_target_status NOT IN ('acknowledged','resolved') THEN
    RAISE EXCEPTION 'INVALID_ALERT_TARGET_STATUS';
  END IF;
  IF p_target_status='resolved' AND (v_note IS NULL OR length(v_note)<10 OR length(v_note)>1000) THEN
    RAISE EXCEPTION 'ALERT_RESOLUTION_NOTE_REQUIRED';
  END IF;
  IF p_target_status='acknowledged' AND v_note IS NOT NULL AND length(v_note)>1000 THEN
    RAISE EXCEPTION 'ALERT_NOTE_TOO_LONG';
  END IF;

  SELECT * INTO v_alert FROM public.count_alerts WHERE id=p_alert_id FOR UPDATE;
  IF NOT FOUND OR NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'ALERT_NOT_FOUND_OR_FORBIDDEN';
  END IF;

  IF v_alert.status='resolved' THEN
    IF p_target_status='resolved' THEN
      RETURN jsonb_build_object('alert_id',v_alert.id,'status','resolved','idempotent',true,'resolved_at',v_alert.resolved_at);
    END IF;
    RAISE EXCEPTION 'RESOLVED_ALERT_IS_FINAL';
  END IF;
  IF v_alert.status='acknowledged' AND p_target_status='acknowledged' THEN
    RETURN jsonb_build_object('alert_id',v_alert.id,'status','acknowledged','idempotent',true,'acknowledged_at',v_alert.acknowledged_at);
  END IF;
  IF v_alert.status NOT IN ('open','acknowledged') THEN
    RAISE EXCEPTION 'ALERT_NOT_ACTIONABLE';
  END IF;

  IF p_target_status='acknowledged' THEN
    UPDATE public.count_alerts
    SET status='acknowledged',
        acknowledged_by=coalesce(acknowledged_by,v_actor),
        acknowledged_at=coalesce(acknowledged_at,now()),
        details=CASE WHEN v_note IS NULL THEN details ELSE details||jsonb_build_object('acknowledgement_note',v_note) END
    WHERE id=p_alert_id
    RETURNING * INTO v_alert;
  ELSE
    UPDATE public.count_alerts
    SET status='resolved',
        acknowledged_by=coalesce(acknowledged_by,v_actor),
        acknowledged_at=coalesce(acknowledged_at,now()),
        resolved_by=v_actor,
        resolved_at=now(),
        details=details||jsonb_build_object('resolution_note',v_note)
    WHERE id=p_alert_id
    RETURNING * INTO v_alert;
  END IF;

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(v_alert.project_id,v_actor,
    CASE WHEN p_target_status='acknowledged' THEN 'alert.acknowledged' ELSE 'alert.resolved' END,
    'count_alert',v_alert.id,
    jsonb_build_object('session_id',v_alert.session_id,'previous_status','open_or_acknowledged','status',v_alert.status,'note',v_note));

  RETURN jsonb_build_object('alert_id',v_alert.id,'status',v_alert.status,
    'acknowledged_at',v_alert.acknowledged_at,'resolved_at',v_alert.resolved_at);
END;
$function$;
