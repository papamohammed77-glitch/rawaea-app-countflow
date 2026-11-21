-- CountFlow large imports: process at most 1,000 staged rows per RPC call.
-- Each call is a separate transaction, making long commits resumable without
-- re-reading an entire 90k-row batch in one database request.
DO $countflow_chunked_import_commit$
DECLARE
  v_oid regprocedure := to_regprocedure('counting_private.count_commit_import_batch_impl(uuid)');
  v_definition text;
  v_updated text;
  v_anchor text;
  v_loop_anchor text;
BEGIN
  IF v_oid IS NULL THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_IMPL_MISSING'; END IF;
  v_definition:=pg_get_functiondef(v_oid::oid);

  IF v_definition NOT LIKE '%v_batch.status <> ''preview''%'
     OR v_definition NOT LIKE '%ORDER BY row_number, id%FOR UPDATE%'
     OR v_definition NOT LIKE '%count_import_rows%row_status=''staged''%'
     OR v_definition NOT LIKE '%SET status=''failed''%' THEN
    RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_SOURCE_CONTRACT_CHANGED';
  END IF;

  -- Capture the original state before any transition. A later chunk can be
  -- retried after a transient request failure; a first-call failure stays failed.
  v_anchor := '  v_expected integer;'||E'\nBEGIN';
  v_updated:=replace(
    v_definition,
    v_anchor,
    '  v_expected integer;'||E'\n  v_remaining bigint;'||E'\n  v_initial_status text;'||E'\n  v_chunk_processed integer := 0;'||E'\nBEGIN'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_DECLARATION_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  v_anchor := '  IF NOT FOUND OR NOT counting_private.is_platform_owner() THEN';
  v_updated:=replace(
    v_definition,
    v_anchor,
    '  IF NOT FOUND THEN RAISE EXCEPTION ''IMPORT_BATCH_NOT_FOUND_OR_FORBIDDEN''; END IF;'||E'\n  v_initial_status := v_batch.status;'||E'\n  IF NOT counting_private.is_platform_owner() THEN'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_OWNER_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  v_anchor := '  IF v_batch.status <> ''preview'' THEN';
  v_updated:=replace(
    v_definition,
    v_anchor,
    '  IF v_batch.status NOT IN (''preview'',''committing'') THEN'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_RESUME_STATUS_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  v_anchor := '  UPDATE public.count_import_batches'||E'\n  SET status=''committing'', updated_at=now()'||E'\n  WHERE id=p_batch_id;';
  v_updated:=replace(v_definition,v_anchor,
    '  IF v_batch.status=''preview'' THEN'||E'\n'||v_anchor||E'\n  END IF;'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_START_TRANSITION_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  v_anchor := '    ORDER BY row_number, id'||E'\n    FOR UPDATE';
  v_updated:=replace(v_definition,v_anchor,
    '    ORDER BY row_number, id'||E'\n    LIMIT 1000'||E'\n    FOR UPDATE'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_ROW_LIMIT_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  v_loop_anchor := '  END LOOP;'||E'\n\n  IF v_batch.session_id IS NOT NULL THEN'||E'\n    INSERT INTO public.count_expected_balances(';
  v_updated:=replace(v_definition,v_loop_anchor,
    '    v_chunk_processed := v_chunk_processed + 1;'||E'\n  END LOOP;'||E'\n\n'||
    '  SELECT count(*) FILTER (WHERE row_status=''staged''),'||E'\n'||
    '         count(*) FILTER (WHERE row_status=''committed''),'||E'\n'||
    '         count(*) FILTER (WHERE row_status=''rejected'')'||E'\n'||
    '  INTO v_remaining,v_accepted,v_rejected'||E'\n'||
    '  FROM public.count_import_rows WHERE batch_id=p_batch_id;'||E'\n\n'||
    '  IF v_remaining>0 THEN'||E'\n'||
    '    UPDATE public.count_import_batches'||E'\n'||
    '    SET status=''committing'', accepted_count=coalesce(v_accepted,0),'||E'\n'||
    '        rejected_count=coalesce(v_rejected,0), updated_at=now()'||E'\n'||
    '    WHERE id=p_batch_id;'||E'\n'||
    '    RETURN jsonb_build_object(''batch_id'',p_batch_id,''status'',''committing'','||E'\n'||
    '      ''processed_rows'',v_chunk_processed,''remaining_rows'',v_remaining,'||E'\n'||
    '      ''accepted_rows'',coalesce(v_accepted,0),''rejected_rows'',coalesce(v_rejected,0));'||E'\n'||
    '  END IF;'||E'\n\n'||
    '  IF v_batch.session_id IS NOT NULL THEN'||E'\n    INSERT INTO public.count_expected_balances('
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_CHUNK_RETURN_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  v_anchor := '  UPDATE public.count_import_batches'||E'\n  SET status=''failed'','||E'\n      completed_at=now(),';
  v_updated:=replace(v_definition,v_anchor,
    '  UPDATE public.count_import_batches'||E'\n  SET status=CASE WHEN v_initial_status=''committing'' THEN ''committing'' ELSE ''failed'' END,'||E'\n      completed_at=CASE WHEN v_initial_status=''committing'' THEN NULL ELSE now() END,'
  );
  IF v_updated=v_definition THEN RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_RETRYABLE_ERROR_ANCHOR_NOT_FOUND'; END IF;
  v_definition:=v_updated;

  IF v_definition !~ 'LIMIT 1000'
     OR v_definition !~ 'v_batch.status NOT IN \(''preview'',''committing''\)'
     OR v_definition !~ 'remaining_rows'
     OR v_definition !~ 'v_initial_status=''committing'' THEN ''committing''' THEN
    RAISE EXCEPTION 'COUNT_IMPORT_COMMIT_REWRITE_VALIDATION_FAILED';
  END IF;

  EXECUTE v_definition;
END
$countflow_chunked_import_commit$;

COMMENT ON FUNCTION counting_private.count_commit_import_batch_impl(uuid)
IS 'Resumable CountFlow import commit: processes at most 1,000 staged rows per RPC transaction, records cumulative counts, and finalizes balances/cost snapshots/audit only after the final chunk.';
