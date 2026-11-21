-- CountFlow: a server-enforced device queue barrier before reconciliation approval and session finalization.
-- Offline count rows remain on their originating device until the server acknowledges them.
-- A disconnected device cannot be silently ignored; only an explicit owner waiver permits bypass.

ALTER TABLE public.count_sessions
  ADD COLUMN IF NOT EXISTS sync_barrier_version bigint NOT NULL DEFAULT 1;

ALTER TABLE public.count_presence
  ADD COLUMN IF NOT EXISTS pending_queue_count integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS pending_queue_digest text,
  ADD COLUMN IF NOT EXISTS queue_reported_at timestamptz,
  ADD COLUMN IF NOT EXISTS acknowledged_lifecycle_version bigint NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS queue_resolution text,
  ADD COLUMN IF NOT EXISTS queue_resolution_reason text,
  ADD COLUMN IF NOT EXISTS queue_resolved_by uuid REFERENCES auth.users(id),
  ADD COLUMN IF NOT EXISTS queue_resolved_at timestamptz;

DO $constraints$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='count_presence_pending_queue_count_nonnegative') THEN
    ALTER TABLE public.count_presence ADD CONSTRAINT count_presence_pending_queue_count_nonnegative
      CHECK (pending_queue_count>=0) NOT VALID;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='count_presence_queue_resolution_valid') THEN
    ALTER TABLE public.count_presence ADD CONSTRAINT count_presence_queue_resolution_valid
      CHECK (queue_resolution IS NULL OR queue_resolution='waived') NOT VALID;
  END IF;
END
$constraints$;
ALTER TABLE public.count_presence VALIDATE CONSTRAINT count_presence_pending_queue_count_nonnegative;
ALTER TABLE public.count_presence VALIDATE CONSTRAINT count_presence_queue_resolution_valid;

CREATE OR REPLACE FUNCTION counting_private.assert_session_device_queues_clear(p_session_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_version bigint;
  v_blocked integer;
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

  IF v_blocked>0 THEN
    RAISE EXCEPTION 'SESSION_HAS_UNACKNOWLEDGED_DEVICE_QUEUES:%',v_blocked;
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.count_report_device_queue(
  p_session_id uuid,
  p_device_id text,
  p_pending_count integer,
  p_queue_digest text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session public.count_sessions;
  v_member public.count_members;
  v_device_status text;
  v_presence public.count_presence;
BEGIN
  IF nullif(btrim(p_device_id),'') IS NULL
     OR p_pending_count IS NULL
     OR p_pending_count<0
     OR p_pending_count>100000
     OR (p_pending_count>0 AND coalesce(p_queue_digest,'') !~ '^[0-9a-f]{64}$')
     OR (p_queue_digest IS NOT NULL AND p_queue_digest !~ '^[0-9a-f]{64}$') THEN
    RAISE EXCEPTION 'INVALID_DEVICE_QUEUE_REPORT';
  END IF;

  SELECT * INTO v_session
  FROM public.count_sessions
  WHERE id=p_session_id
  FOR UPDATE;
  IF NOT FOUND OR v_session.status NOT IN ('active','paused','review') THEN
    RAISE EXCEPTION 'SESSION_NOT_REPORTABLE';
  END IF;

  SELECT * INTO v_member
  FROM public.count_members
  WHERE project_id=v_session.project_id
    AND user_id=(SELECT auth.uid())
    AND role='counter'
    AND status='active'
  LIMIT 1;
  IF NOT FOUND THEN RAISE EXCEPTION 'COUNTER_MEMBERSHIP_REQUIRED'; END IF;

  SELECT d.status INTO v_device_status
  FROM public.count_devices d
  WHERE d.project_id=v_session.project_id
    AND d.member_id=v_member.id
    AND d.device_id=p_device_id;
  IF NOT FOUND OR v_device_status<>'active' THEN
    RAISE EXCEPTION 'ACTIVE_APPROVED_DEVICE_REQUIRED';
  END IF;

  INSERT INTO public.count_presence AS cp(
    project_id,session_id,member_id,device_id,presence_state,
    started_at,last_seen_at,pending_queue_count,pending_queue_digest,
    queue_reported_at,acknowledged_lifecycle_version
  )
  VALUES(
    v_session.project_id,p_session_id,v_member.id,p_device_id,'online',
    now(),now(),p_pending_count,CASE WHEN p_pending_count=0 THEN NULL ELSE p_queue_digest END,
    now(),v_session.sync_barrier_version
  )
  ON CONFLICT(session_id,member_id,device_id) DO UPDATE SET
    presence_state='online',
    last_seen_at=now(),
    pending_queue_count=EXCLUDED.pending_queue_count,
    pending_queue_digest=EXCLUDED.pending_queue_digest,
    queue_reported_at=now(),
    acknowledged_lifecycle_version=v_session.sync_barrier_version,
    queue_resolution=CASE
      WHEN v_session.status='review' AND cp.queue_resolution='waived'
        AND cp.pending_queue_count=EXCLUDED.pending_queue_count
        AND cp.pending_queue_digest IS NOT DISTINCT FROM EXCLUDED.pending_queue_digest
        THEN cp.queue_resolution
      ELSE NULL
    END,
    queue_resolution_reason=CASE
      WHEN v_session.status='review' AND cp.queue_resolution='waived'
        AND cp.pending_queue_count=EXCLUDED.pending_queue_count
        AND cp.pending_queue_digest IS NOT DISTINCT FROM EXCLUDED.pending_queue_digest
        THEN cp.queue_resolution_reason
      ELSE NULL
    END,
    queue_resolved_by=CASE
      WHEN v_session.status='review' AND cp.queue_resolution='waived'
        AND cp.pending_queue_count=EXCLUDED.pending_queue_count
        AND cp.pending_queue_digest IS NOT DISTINCT FROM EXCLUDED.pending_queue_digest
        THEN cp.queue_resolved_by
      ELSE NULL
    END,
    queue_resolved_at=CASE
      WHEN v_session.status='review' AND cp.queue_resolution='waived'
        AND cp.pending_queue_count=EXCLUDED.pending_queue_count
        AND cp.pending_queue_digest IS NOT DISTINCT FROM EXCLUDED.pending_queue_digest
        THEN cp.queue_resolved_at
      ELSE NULL
    END
  RETURNING * INTO v_presence;

  RETURN jsonb_build_object(
    'ok',true,'session_id',p_session_id,'session_status',v_session.status,
    'lifecycle_version',v_session.sync_barrier_version,
    'pending_queue_count',v_presence.pending_queue_count,
    'queue_reported_at',v_presence.queue_reported_at,
    'queue_resolution',v_presence.queue_resolution
  );
END;
$function$;

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
  IF NOT FOUND OR NOT counting_private.is_platform_owner(v_session.project_id) THEN
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
  WHERE session_id=p_session_id AND member_id=p_member_id AND device_id=p_device_id;

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(
    v_session.project_id,v_actor,'device.queue_waived','count_presence',v_presence.id,
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
    'pending_queue_count',v_presence.pending_queue_count
  );
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.assert_session_device_queues_clear(uuid) FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION public.count_report_device_queue(uuid,text,integer,text) FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.count_waive_device_queue(uuid,uuid,text,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_report_device_queue(uuid,text,integer,text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.count_waive_device_queue(uuid,uuid,text,text) TO authenticated;

-- A new lifecycle version is created whenever the session is paused, resumed, started or enters review.
-- Every counter device must report its local queue against that exact version before approval/closure.
DO $lifecycle_guard_barrier$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef('counting_private.guard_session_lifecycle()'::regprocedure)
  INTO v_definition;

  v_updated:=replace(
    v_definition,
    E'    IF NEW.status<>''planned'' OR NEW.started_at IS NOT NULL OR NEW.closed_at IS NOT NULL THEN\n      RAISE EXCEPTION ''SESSION_MUST_BE_CREATED_AS_PLANNED'';\n    END IF;\n    RETURN NEW;',
    E'    IF NEW.status<>''planned'' OR NEW.started_at IS NOT NULL OR NEW.closed_at IS NOT NULL THEN\n      RAISE EXCEPTION ''SESSION_MUST_BE_CREATED_AS_PLANNED'';\n    END IF;\n    NEW.sync_barrier_version:=1;\n    RETURN NEW;'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_SESSION_INSERT_VERSION_ANCHOR_NOT_FOUND'; END IF;

  v_definition:=v_updated;
  v_updated:=replace(
    v_definition,
    E'    IF NEW.started_at IS DISTINCT FROM OLD.started_at\n       OR NEW.closed_at IS DISTINCT FROM OLD.closed_at THEN\n      RAISE EXCEPTION ''SESSION_LIFECYCLE_TIMESTAMPS_ARE_SERVER_MANAGED'';\n    END IF;\n    RETURN NEW;',
    E'    IF NEW.started_at IS DISTINCT FROM OLD.started_at\n       OR NEW.closed_at IS DISTINCT FROM OLD.closed_at THEN\n      RAISE EXCEPTION ''SESSION_LIFECYCLE_TIMESTAMPS_ARE_SERVER_MANAGED'';\n    END IF;\n    IF NEW.sync_barrier_version IS DISTINCT FROM OLD.sync_barrier_version THEN\n      RAISE EXCEPTION ''SESSION_SYNC_BARRIER_VERSION_IS_SERVER_MANAGED'';\n    END IF;\n    RETURN NEW;'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_SESSION_SAME_STATUS_VERSION_ANCHOR_NOT_FOUND'; END IF;

  v_definition:=v_updated;
  v_updated:=replace(
    v_definition,
    E'    RETURN NEW;\n  END IF;\n\n  IF OLD.status=''planned'' AND NEW.status=''active'' THEN',
    E'    RETURN NEW;\n  END IF;\n\n  IF NEW.status<>''completed'' THEN\n    NEW.sync_barrier_version:=coalesce(OLD.sync_barrier_version,0)+1;\n  END IF;\n\n  IF OLD.status=''planned'' AND NEW.status=''active'' THEN'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_SESSION_LIFECYCLE_VERSION_ANCHOR_NOT_FOUND'; END IF;

  v_definition:=v_updated;
  v_updated:=replace(
    v_definition,
    E'    NEW.started_at:=OLD.started_at;\n    NEW.closed_at:=now();',
    E'    PERFORM counting_private.assert_session_device_queues_clear(OLD.id);\n    NEW.started_at:=OLD.started_at;\n    NEW.closed_at:=now();'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_SESSION_CLOSE_QUEUE_BARRIER_ANCHOR_NOT_FOUND'; END IF;

  EXECUTE v_updated;
END
$lifecycle_guard_barrier$;

-- Do not freeze a reconciliation while any registered counter device still has a pending or unacknowledged queue.
DO $approve_barrier$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef('public.count_approve_reconciliation(uuid)'::regprocedure)
  INTO v_definition;

  v_updated:=replace(
    v_definition,
    E'  UPDATE public.count_reconciliation_runs SET status=''approved''',
    E'  PERFORM counting_private.assert_session_device_queues_clear(v_run.session_id);\n  UPDATE public.count_reconciliation_runs SET status=''approved'''
  );
  IF v_updated=v_definition THEN
    RAISE EXCEPTION 'COUNT_RECONCILIATION_APPROVAL_QUEUE_BARRIER_ANCHOR_NOT_FOUND';
  END IF;
  EXECUTE v_updated;
END
$approve_barrier$;

-- Presence heartbeats continue during review so devices can acknowledge the final review barrier,
-- but the authoritative entry RPCs still accept new field counts only in active sessions.
DO $presence_review$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef('public.count_touch_presence(uuid,text,text,text,text,text,uuid)'::regprocedure)
  INTO v_definition;

  v_updated:=replace(
    v_definition,
    'v_session.status NOT IN (''active'',''paused'')',
    'v_session.status NOT IN (''active'',''paused'',''review'')'
  );
  IF v_updated=v_definition THEN
    RAISE EXCEPTION 'COUNT_PRESENCE_REVIEW_STATUS_ANCHOR_NOT_FOUND';
  END IF;

  v_definition:=v_updated;
  v_updated:=replace(
    v_definition,
    'RETURN jsonb_build_object(''ok'',true,''member_id'',v_member.id,''session_id'',p_session_id,''last_seen_at'',now());',
    'RETURN jsonb_build_object(''ok'',true,''member_id'',v_member.id,''session_id'',p_session_id,''session_status'',v_session.status,''lifecycle_version'',v_session.sync_barrier_version,''last_seen_at'',now());'
  );
  IF v_updated=v_definition THEN
    RAISE EXCEPTION 'COUNT_PRESENCE_REVIEW_RESPONSE_ANCHOR_NOT_FOUND';
  END IF;
  EXECUTE v_updated;
END
$presence_review$;

COMMENT ON COLUMN public.count_sessions.sync_barrier_version IS 'Incremented by every lifecycle transition except final completion; counter clients must report queue state against this version before approval/finalization.';
COMMENT ON COLUMN public.count_presence.pending_queue_count IS 'Local IndexedDB events not yet acknowledged by server for this device and session.';
COMMENT ON COLUMN public.count_presence.acknowledged_lifecycle_version IS 'Latest count_sessions.sync_barrier_version acknowledged by this client while reporting its local queue.';
COMMENT ON COLUMN public.count_presence.queue_resolution IS 'Owner-only explicit waiver for a device queue that cannot be recovered; the queue count/digest remain visible and audited.';
