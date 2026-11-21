-- Reconcile production DB back to the pause-first contract in main.
-- The experimental two-phase DB migration ran before its source was removed by a concurrent commit.
-- This forward-only migration restores approval to the durable source contract without deleting
-- migration history or dropping additive queue metadata columns.
CREATE OR REPLACE FUNCTION public.count_approve_reconciliation(p_run_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_run public.count_reconciliation_runs;
  v_session public.count_sessions;
  v_open_tasks integer;
  v_critical_alerts integer;
  v_later_runs integer;
  v_current_entry_count bigint;
  v_uncovered_imported_products bigint;
BEGIN
  SELECT * INTO v_run
  FROM public.count_reconciliation_runs
  WHERE id=p_run_id
  FOR UPDATE;

  IF NOT FOUND OR NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'RECONCILIATION_NOT_FOUND_OR_FORBIDDEN';
  END IF;
  IF v_run.status<>'computed' THEN
    RAISE EXCEPTION 'RECONCILIATION_NOT_COMPUTED';
  END IF;

  SELECT * INTO v_session
  FROM public.count_sessions
  WHERE id=v_run.session_id
  FOR UPDATE;

  IF NOT FOUND OR v_session.status<>'paused' THEN
    RAISE EXCEPTION 'SESSION_NOT_READY_FOR_APPROVAL';
  END IF;

  SELECT count(*) INTO v_later_runs
  FROM public.count_reconciliation_runs
  WHERE session_id=v_run.session_id AND run_number>v_run.run_number;
  IF v_later_runs>0 THEN RAISE EXCEPTION 'RECONCILIATION_NOT_LATEST'; END IF;

  SELECT count(*) INTO v_current_entry_count
  FROM public.count_entries
  WHERE session_id=v_run.session_id;
  IF v_current_entry_count<>v_run.entry_count_snapshot THEN
    RAISE EXCEPTION 'COUNT_DATA_CHANGED_AFTER_RECONCILIATION:%',
      v_current_entry_count-v_run.entry_count_snapshot;
  END IF;
  IF v_run.uncounted_rows>0 THEN
    RAISE EXCEPTION 'UNCOUNTED_POSITIONS_REMAINING:%',v_run.uncounted_rows;
  END IF;

  SELECT count(*) INTO v_uncovered_imported_products
  FROM (
    SELECT DISTINCT r.product_id
    FROM public.count_import_rows r
    JOIN public.count_import_batches b ON b.id=r.batch_id
    WHERE b.session_id=v_run.session_id
      AND r.row_status='committed'
      AND r.product_id IS NOT NULL
  ) imported
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.count_reconciliation_lines l
    WHERE l.run_id=p_run_id
      AND l.product_id=imported.product_id
      AND l.counted_quantity IS NOT NULL
  );
  IF v_uncovered_imported_products>0 THEN
    RAISE EXCEPTION 'IMPORTED_PRODUCTS_WITHOUT_ANY_COUNT:%',v_uncovered_imported_products;
  END IF;

  SELECT count(*) INTO v_open_tasks
  FROM public.count_recount_tasks
  WHERE session_id=v_run.session_id
    AND status NOT IN ('reviewed','cancelled');
  SELECT count(*) INTO v_critical_alerts
  FROM public.count_alerts
  WHERE session_id=v_run.session_id
    AND severity='critical'
    AND status IN ('open','acknowledged');

  IF v_open_tasks>0 THEN RAISE EXCEPTION 'RECOUNT_REVIEW_REQUIRED:%',v_open_tasks; END IF;
  IF v_critical_alerts>0 THEN RAISE EXCEPTION 'CRITICAL_ALERTS_UNRESOLVED:%',v_critical_alerts; END IF;

  -- The owner pauses the session first. Each field device must then acknowledge
  -- its full IndexedDB queue against the resulting lifecycle version.
  PERFORM counting_private.assert_session_device_queues_clear(v_run.session_id);

  UPDATE public.count_reconciliation_runs
  SET status='approved',
      approved_by=(SELECT auth.uid()),
      approved_at=now()
  WHERE id=p_run_id;

  UPDATE public.count_sessions
  SET status='review'
  WHERE id=v_run.session_id AND status='paused';

  INSERT INTO public.count_audit_log(project_id,actor_id,action,entity_type,entity_id,details)
  VALUES(
    v_run.project_id,
    (SELECT auth.uid()),
    'reconciliation.approved',
    'reconciliation_run',
    p_run_id,
    jsonb_build_object(
      'session_id',v_run.session_id,
      'run_number',v_run.run_number,
      'session_frozen',true,
      'entry_count_snapshot',v_run.entry_count_snapshot,
      'queue_barrier_version',v_session.sync_barrier_version
    )
  );

  RETURN jsonb_build_object(
    'run_id',p_run_id,
    'status','approved',
    'approved_at',now(),
    'session_status','review'
  );
END;
$function$;

ALTER FUNCTION public.count_approve_reconciliation(uuid) SECURITY DEFINER;
ALTER FUNCTION public.count_approve_reconciliation(uuid) SET search_path TO '';

COMMENT ON FUNCTION public.count_approve_reconciliation(uuid)
IS 'Owner-only pause-first approval. Requires the latest computed run, unchanged count snapshot, all imported products counted, reviewed recounts, resolved critical alerts and all device queues acknowledged at the current lifecycle version.';
