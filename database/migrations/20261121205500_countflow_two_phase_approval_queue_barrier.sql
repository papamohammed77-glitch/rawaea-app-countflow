-- CountFlow: two-phase owner approval barrier.
-- Requesting approval rotates the lifecycle version and freezes devices as soon as they attest
-- that their local queue is empty. Offline/unresponsive devices cannot silently pass the barrier.
ALTER TABLE public.count_sessions
  ADD COLUMN IF NOT EXISTS queue_barrier_action text,
  ADD COLUMN IF NOT EXISTS queue_barrier_run_id uuid REFERENCES public.count_reconciliation_runs(id),
  ADD COLUMN IF NOT EXISTS queue_barrier_requested_at timestamptz;

DO $constraint$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='count_sessions_queue_barrier_action_valid') THEN
    ALTER TABLE public.count_sessions ADD CONSTRAINT count_sessions_queue_barrier_action_valid
      CHECK (queue_barrier_action IS NULL OR queue_barrier_action='approve') NOT VALID;
  END IF;
END
$constraint$;
ALTER TABLE public.count_sessions VALIDATE CONSTRAINT count_sessions_queue_barrier_action_valid;

CREATE OR REPLACE FUNCTION counting_private.request_session_queue_barrier(
  p_session_id uuid,
  p_run_id uuid
)
RETURNS bigint
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session public.count_sessions;
  v_version bigint;
BEGIN
  IF NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'PLATFORM_OWNER_REQUIRED';
  END IF;
  SELECT * INTO v_session FROM public.count_sessions WHERE id=p_session_id FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'SESSION_NOT_FOUND'; END IF;
  IF v_session.status<>'active' THEN RAISE EXCEPTION 'SESSION_MUST_BE_ACTIVE_FOR_QUEUE_DRAIN'; END IF;

  IF v_session.queue_barrier_action='approve' AND v_session.queue_barrier_run_id=p_run_id THEN
    RETURN v_session.sync_barrier_version;
  END IF;
  IF v_session.queue_barrier_action IS NOT NULL THEN
    RAISE EXCEPTION 'SESSION_QUEUE_BARRIER_ALREADY_PENDING';
  END IF;

  PERFORM set_config('countflow.queue_barrier_internal','on',true);
  UPDATE public.count_sessions
  SET sync_barrier_version=sync_barrier_version+1,
      queue_barrier_action='approve',
      queue_barrier_run_id=p_run_id,
      queue_barrier_requested_at=now()
  WHERE id=p_session_id
  RETURNING sync_barrier_version INTO v_version;
  PERFORM set_config('countflow.queue_barrier_internal','off',true);

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(v_session.project_id,(SELECT auth.uid()),'session.device_queue_barrier_requested',
    'count_session',p_session_id,
    jsonb_build_object('session_id',p_session_id,'run_id',p_run_id,'lifecycle_version',v_version));

  RETURN v_version;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.request_session_queue_barrier(uuid,uuid) FROM PUBLIC,anon,authenticated;

CREATE OR REPLACE FUNCTION public.count_cancel_session_queue_barrier(
  p_session_id uuid,
  p_reason text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session public.count_sessions;
  v_version bigint;
  v_reason text:=nullif(btrim(p_reason),'');
BEGIN
  IF v_reason IS NULL OR length(v_reason)<10 OR length(v_reason)>1000 THEN
    RAISE EXCEPTION 'QUEUE_BARRIER_CANCEL_REASON_REQUIRED';
  END IF;
  SELECT * INTO v_session FROM public.count_sessions WHERE id=p_session_id FOR UPDATE;
  IF NOT FOUND OR NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'SESSION_NOT_FOUND_OR_FORBIDDEN';
  END IF;
  IF v_session.status<>'active' OR v_session.queue_barrier_action IS DISTINCT FROM 'approve' THEN
    RAISE EXCEPTION 'SESSION_QUEUE_BARRIER_NOT_PENDING';
  END IF;

  PERFORM set_config('countflow.queue_barrier_internal','on',true);
  UPDATE public.count_sessions
  SET sync_barrier_version=sync_barrier_version+1,
      queue_barrier_action=NULL,queue_barrier_run_id=NULL,queue_barrier_requested_at=NULL
  WHERE id=p_session_id
  RETURNING sync_barrier_version INTO v_version;
  PERFORM set_config('countflow.queue_barrier_internal','off',true);

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(v_session.project_id,(SELECT auth.uid()),'session.device_queue_barrier_cancelled',
    'count_session',p_session_id,
    jsonb_build_object('session_id',p_session_id,'previous_run_id',v_session.queue_barrier_run_id,
      'new_lifecycle_version',v_version,'reason',v_reason));

  RETURN jsonb_build_object('ok',true,'session_id',p_session_id,'status','active',
    'lifecycle_version',v_version,'barrier_cancelled',true);
END;
$function$;

REVOKE ALL ON FUNCTION public.count_cancel_session_queue_barrier(uuid,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_cancel_session_queue_barrier(uuid,text) TO authenticated;

-- Replace lifecycle guard so same-status barrier version rotations are possible only inside
-- the private SECURITY DEFINER request/cancel helpers. Owner UI cannot set these columns directly.
CREATE OR REPLACE FUNCTION counting_private.guard_session_lifecycle()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_latest public.count_reconciliation_runs;
  v_current_entries bigint;
  v_open_tasks bigint;
  v_critical_alerts bigint;
  v_uncovered_products bigint;
  v_internal boolean:=coalesce(current_setting('countflow.queue_barrier_internal',true),'')='on';
BEGIN
  IF TG_OP='INSERT' THEN
    IF NEW.status<>'planned' OR NEW.started_at IS NOT NULL OR NEW.closed_at IS NOT NULL THEN
      RAISE EXCEPTION 'SESSION_MUST_BE_CREATED_AS_PLANNED';
    END IF;
    NEW.sync_barrier_version:=1;
    NEW.queue_barrier_action:=NULL;
    NEW.queue_barrier_run_id:=NULL;
    NEW.queue_barrier_requested_at:=NULL;
    RETURN NEW;
  END IF;

  IF NEW.started_at IS DISTINCT FROM OLD.started_at
     OR NEW.closed_at IS DISTINCT FROM OLD.closed_at THEN
    IF NEW.status IS NOT DISTINCT FROM OLD.status THEN
      RAISE EXCEPTION 'SESSION_LIFECYCLE_TIMESTAMPS_ARE_SERVER_MANAGED';
    END IF;
  END IF;

  IF NOT v_internal AND (
    NEW.queue_barrier_action IS DISTINCT FROM OLD.queue_barrier_action
    OR NEW.queue_barrier_run_id IS DISTINCT FROM OLD.queue_barrier_run_id
    OR NEW.queue_barrier_requested_at IS DISTINCT FROM OLD.queue_barrier_requested_at
  ) THEN
    RAISE EXCEPTION 'SESSION_QUEUE_BARRIER_FIELDS_ARE_SERVER_MANAGED';
  END IF;

  IF NEW.status IS NOT DISTINCT FROM OLD.status THEN
    IF NEW.sync_barrier_version IS DISTINCT FROM OLD.sync_barrier_version
       AND NOT (v_internal AND NEW.sync_barrier_version=OLD.sync_barrier_version+1) THEN
      RAISE EXCEPTION 'SESSION_SYNC_BARRIER_VERSION_IS_SERVER_MANAGED';
    END IF;
    RETURN NEW;
  END IF;

  IF OLD.queue_barrier_action='approve'
     AND NEW.status IS DISTINCT FROM OLD.status
     AND NOT (NEW.status='review'
       AND OLD.queue_barrier_run_id IS NOT NULL
       AND NEW.queue_barrier_action IS NULL
       AND NEW.queue_barrier_run_id IS NULL
       AND NEW.queue_barrier_requested_at IS NULL) THEN
    RAISE EXCEPTION 'SESSION_QUEUE_BARRIER_IN_PROGRESS';
  END IF;

  IF NEW.status<>'completed'
     AND NOT (NEW.status='review' AND OLD.queue_barrier_action='approve') THEN
    NEW.sync_barrier_version:=coalesce(OLD.sync_barrier_version,0)+1;
  END IF;

  IF OLD.status='planned' AND NEW.status='active' THEN
    NEW.started_at:=coalesce(OLD.started_at,now());
    NEW.closed_at:=NULL;
    RETURN NEW;
  ELSIF OLD.status='active' AND NEW.status='paused' THEN
    NEW.started_at:=OLD.started_at;
    NEW.closed_at:=NULL;
    RETURN NEW;
  ELSIF OLD.status='paused' AND NEW.status='active' THEN
    NEW.started_at:=OLD.started_at;
    NEW.closed_at:=NULL;
    RETURN NEW;
  ELSIF OLD.status IN ('active','paused') AND NEW.status='review' THEN
    IF NOT EXISTS (
      SELECT 1
      FROM public.count_reconciliation_runs r
      WHERE r.session_id=OLD.id
        AND r.status='approved'
        AND r.approved_at IS NOT NULL
        AND r.run_number=(SELECT max(x.run_number) FROM public.count_reconciliation_runs x WHERE x.session_id=OLD.id)
    ) THEN
      RAISE EXCEPTION 'SESSION_REVIEW_REQUIRES_LATEST_APPROVED_RECONCILIATION';
    END IF;
    NEW.started_at:=OLD.started_at;
    NEW.closed_at:=NULL;
    RETURN NEW;
  ELSIF OLD.status IN ('active','paused','review') AND NEW.status='completed' THEN
    SELECT * INTO v_latest
    FROM public.count_reconciliation_runs r
    WHERE r.session_id=OLD.id
    ORDER BY r.run_number DESC
    LIMIT 1;

    IF NOT FOUND OR v_latest.status<>'approved' OR v_latest.approved_at IS NULL THEN
      RAISE EXCEPTION 'SESSION_CLOSE_REQUIRES_LATEST_APPROVED_RECONCILIATION';
    END IF;
    SELECT count(*) INTO v_current_entries FROM public.count_entries e WHERE e.session_id=OLD.id;
    IF v_current_entries<>v_latest.entry_count_snapshot THEN
      RAISE EXCEPTION 'COUNT_DATA_CHANGED_AFTER_APPROVED_RECONCILIATION';
    END IF;
    IF v_latest.uncounted_rows>0 THEN RAISE EXCEPTION 'SESSION_HAS_UNCOUNTED_POSITIONS:%',v_latest.uncounted_rows; END IF;

    SELECT count(*) INTO v_open_tasks
    FROM public.count_recount_tasks t
    WHERE t.session_id=OLD.id AND t.status NOT IN ('reviewed','cancelled');
    IF v_open_tasks>0 THEN RAISE EXCEPTION 'SESSION_HAS_OPEN_RECOUNT_TASKS:%',v_open_tasks; END IF;

    SELECT count(*) INTO v_critical_alerts
    FROM public.count_alerts a
    WHERE a.session_id=OLD.id AND a.severity='critical' AND a.status IN ('open','acknowledged');
    IF v_critical_alerts>0 THEN RAISE EXCEPTION 'SESSION_HAS_UNRESOLVED_CRITICAL_ALERTS:%',v_critical_alerts; END IF;

    SELECT count(*) INTO v_uncovered_products
    FROM (
      SELECT DISTINCT r.product_id
      FROM public.count_import_rows r
      JOIN public.count_import_batches b ON b.id=r.batch_id
      WHERE b.session_id=OLD.id AND r.row_status='committed' AND r.product_id IS NOT NULL
    ) imported
    WHERE NOT EXISTS (
      SELECT 1
      FROM public.count_reconciliation_lines l
      WHERE l.run_id=v_latest.id AND l.product_id=imported.product_id AND l.counted_quantity IS NOT NULL
    );
    IF v_uncovered_products>0 THEN
      RAISE EXCEPTION 'SESSION_HAS_IMPORTED_PRODUCTS_WITHOUT_ANY_COUNT:%',v_uncovered_products;
    END IF;

    PERFORM counting_private.assert_session_device_queues_clear(OLD.id);
    NEW.started_at:=OLD.started_at;
    NEW.closed_at:=now();
    RETURN NEW;
  ELSE
    RAISE EXCEPTION 'INVALID_SESSION_STATUS_TRANSITION:%->%',OLD.status,NEW.status;
  END IF;
END;
$function$;

-- Approval is a two-step handshake only when the session is active. First call requests a
-- new device queue version and returns pending. Each device must sync and report zero on that
-- version; a subsequent owner call performs the actual reconciliation approval.
CREATE OR REPLACE FUNCTION public.count_approve_reconciliation(p_run_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path TO ''
AS $function$
DECLARE
  v_run public.count_reconciliation_runs;
  v_session public.count_sessions;
  v_barrier_version bigint;
  v_open_tasks integer;
  v_critical_alerts integer;
  v_later_runs integer;
  v_current_entry_count bigint;
  v_uncovered_imported_products bigint;
BEGIN
  SELECT * INTO v_run FROM public.count_reconciliation_runs WHERE id=p_run_id FOR UPDATE;
  IF NOT FOUND OR NOT counting_private.is_platform_owner() THEN RAISE EXCEPTION 'RECONCILIATION_NOT_FOUND_OR_FORBIDDEN'; END IF;
  IF v_run.status<>'computed' THEN RAISE EXCEPTION 'RECONCILIATION_NOT_COMPUTED'; END IF;
  SELECT * INTO v_session FROM public.count_sessions WHERE id=v_run.session_id FOR UPDATE;
  IF NOT FOUND OR v_session.status NOT IN ('active','paused') THEN RAISE EXCEPTION 'SESSION_NOT_READY_FOR_APPROVAL'; END IF;

  SELECT count(*) INTO v_later_runs FROM public.count_reconciliation_runs WHERE session_id=v_run.session_id AND run_number>v_run.run_number;
  IF v_later_runs>0 THEN RAISE EXCEPTION 'RECONCILIATION_NOT_LATEST'; END IF;
  SELECT count(*) INTO v_current_entry_count FROM public.count_entries WHERE session_id=v_run.session_id;
  IF v_current_entry_count<>v_run.entry_count_snapshot THEN
    RAISE EXCEPTION 'COUNT_DATA_CHANGED_AFTER_RECONCILIATION:%',v_current_entry_count-v_run.entry_count_snapshot;
  END IF;
  IF v_run.uncounted_rows>0 THEN RAISE EXCEPTION 'UNCOUNTED_POSITIONS_REMAINING:%',v_run.uncounted_rows; END IF;

  SELECT count(*) INTO v_uncovered_imported_products
  FROM (
    SELECT DISTINCT r.product_id
    FROM public.count_import_rows r
    JOIN public.count_import_batches b ON b.id=r.batch_id
    WHERE b.session_id=v_run.session_id AND r.row_status='committed' AND r.product_id IS NOT NULL
  ) scoped
  WHERE NOT EXISTS (
    SELECT 1 FROM public.count_reconciliation_lines l
    WHERE l.run_id=p_run_id AND l.product_id=scoped.product_id AND l.counted_quantity IS NOT NULL
  );
  IF v_uncovered_imported_products>0 THEN RAISE EXCEPTION 'IMPORTED_PRODUCTS_WITHOUT_ANY_COUNT:%',v_uncovered_imported_products; END IF;

  SELECT count(*) INTO v_open_tasks FROM public.count_recount_tasks WHERE session_id=v_run.session_id AND status NOT IN ('reviewed','cancelled');
  SELECT count(*) INTO v_critical_alerts FROM public.count_alerts WHERE session_id=v_run.session_id AND severity='critical' AND status IN ('open','acknowledged');
  IF v_open_tasks>0 THEN RAISE EXCEPTION 'RECOUNT_REVIEW_REQUIRED:%',v_open_tasks; END IF;
  IF v_critical_alerts>0 THEN RAISE EXCEPTION 'CRITICAL_ALERTS_UNRESOLVED:%',v_critical_alerts; END IF;

  IF v_session.status='paused' AND v_session.queue_barrier_action IS NULL THEN
    -- A paused session cannot upload queued events. Resume it, let counters sync, then pause again.
    PERFORM counting_private.assert_session_device_queues_clear(v_session.id);
  ELSIF v_session.status='active' AND v_session.queue_barrier_action IS DISTINCT FROM 'approve' THEN
    v_barrier_version:=counting_private.request_session_queue_barrier(v_session.id,p_run_id);
    RETURN jsonb_build_object('run_id',p_run_id,'status','queue_barrier_pending',
      'lifecycle_version',v_barrier_version,'session_status','active');
  ELSIF v_session.queue_barrier_action IS DISTINCT FROM 'approve'
     OR v_session.queue_barrier_run_id IS DISTINCT FROM p_run_id THEN
    RAISE EXCEPTION 'SESSION_QUEUE_BARRIER_RUN_MISMATCH';
  END IF;

  PERFORM counting_private.assert_session_device_queues_clear(v_run.session_id);
  UPDATE public.count_reconciliation_runs
  SET status='approved',approved_by=(SELECT auth.uid()),approved_at=now()
  WHERE id=p_run_id;
  UPDATE public.count_sessions
  SET status='review',
      queue_barrier_action=NULL,
      queue_barrier_run_id=NULL,
      queue_barrier_requested_at=NULL
  WHERE id=v_run.session_id AND status IN ('active','paused');

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(v_run.project_id,(SELECT auth.uid()),'reconciliation.approved','reconciliation_run',p_run_id,
    jsonb_build_object('session_id',v_run.session_id,'run_number',v_run.run_number,
      'session_frozen',true,'entry_count_snapshot',v_run.entry_count_snapshot,
      'queue_barrier_version',v_session.sync_barrier_version));

  RETURN jsonb_build_object('run_id',p_run_id,'status','approved','approved_at',now(),'session_status','review');
END;
$function$;

-- The reconciliation function will not create a new run while a barrier is pending. The owner
-- must explicitly cancel the barrier first; the cancel RPC rotates the version and audits reason.
DO $patch_reconcile$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef('public.count_reconcile_session(uuid)'::regprocedure) INTO v_definition;
  v_updated:=replace(
    v_definition,
    E'  IF v_session.status NOT IN (''active'',''paused'',''review'',''completed'') THEN RAISE EXCEPTION ''SESSION_NOT_READY_FOR_RECONCILIATION''; END IF;',
    E'  IF v_session.status NOT IN (''active'',''paused'',''review'',''completed'') THEN RAISE EXCEPTION ''SESSION_NOT_READY_FOR_RECONCILIATION''; END IF;\n  IF v_session.queue_barrier_action IS NOT NULL THEN RAISE EXCEPTION ''SESSION_QUEUE_BARRIER_IN_PROGRESS_USE_CANCEL''; END IF;'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_RECONCILE_QUEUE_BARRIER_ANCHOR_NOT_FOUND'; END IF;
  EXECUTE v_updated;
END
$patch_reconcile$;

-- Add the barrier action to the queue report payload used by the Counter application.
DO $patch_report$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef('public.count_report_device_queue(uuid,text,integer,text)'::regprocedure) INTO v_definition;
  v_updated:=replace(
    v_definition,
    E'    ''queue_resolution'',v_presence.queue_resolution\n  );',
    E'    ''queue_resolution'',v_presence.queue_resolution,\n    ''queue_barrier_action'',v_session.queue_barrier_action\n  );'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_REPORT_QUEUE_BARRIER_RESPONSE_ANCHOR_NOT_FOUND'; END IF;
  EXECUTE v_updated;
END
$patch_report$;

DO $patch_presence$
DECLARE
  v_definition text;
  v_updated text;
BEGIN
  SELECT pg_get_functiondef('public.count_touch_presence(uuid,text,text,text,text,text,uuid)'::regprocedure) INTO v_definition;
  v_updated:=replace(
    v_definition,
    E'''lifecycle_version'',v_session.sync_barrier_version,''last_seen_at'',now());',
    E'''lifecycle_version'',v_session.sync_barrier_version,''queue_barrier_action'',v_session.queue_barrier_action,''last_seen_at'',now());'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_TOUCH_PRESENCE_BARRIER_RESPONSE_ANCHOR_NOT_FOUND'; END IF;
  EXECUTE v_updated;
END
$patch_presence$;

-- An already-acknowledged device cannot insert a new count after it claimed that its queue is empty.
CREATE OR REPLACE FUNCTION counting_private.guard_count_entry_queue_barrier()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_session public.count_sessions;
BEGIN
  SELECT * INTO v_session FROM public.count_sessions WHERE id=NEW.session_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'SESSION_NOT_FOUND'; END IF;
  IF v_session.queue_barrier_action='approve' AND EXISTS (
    SELECT 1 FROM public.count_presence p
    WHERE p.session_id=NEW.session_id
      AND p.member_id=NEW.member_id
      AND p.device_id=NEW.device_id
      AND p.acknowledged_lifecycle_version=v_session.sync_barrier_version
      AND (p.pending_queue_count=0 OR p.queue_resolution='waived')
  ) THEN
    RAISE EXCEPTION 'SESSION_QUEUE_BARRIER_FROZEN_DEVICE';
  END IF;
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS count_entries_queue_barrier_guard ON public.count_entries;
CREATE TRIGGER count_entries_queue_barrier_guard
BEFORE INSERT ON public.count_entries
FOR EACH ROW EXECUTE FUNCTION counting_private.guard_count_entry_queue_barrier();

REVOKE ALL ON FUNCTION counting_private.guard_count_entry_queue_barrier() FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.assert_session_device_queues_clear(uuid) FROM PUBLIC,anon,authenticated;

COMMENT ON COLUMN public.count_sessions.queue_barrier_action IS 'Owner-requested finalization barrier; counter clients freeze new counts and drain their local queue before reconciliation approval.';
COMMENT ON COLUMN public.count_sessions.queue_barrier_run_id IS 'Computed run whose owner approval is waiting for all device queue acknowledgements.';
COMMENT ON COLUMN public.count_sessions.queue_barrier_requested_at IS 'When the owner rotated the lifecycle version for the finalization queue handshake.';
