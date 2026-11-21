-- 5,000-row CountFlow database import regression (rollback-only).
-- The synthetic project, Auth user, import batch, staged rows and products are
-- created in one transaction and rolled back. Never remove the final ROLLBACK.
BEGIN;
SET LOCAL statement_timeout='180s';
CREATE TEMP TABLE countflow_5k_result(result jsonb) ON COMMIT DROP;
DO $countflow_5k$
DECLARE
  v_owner uuid; v_project uuid; v_batch uuid;
  v_rows jsonb; v_chunk_result jsonb; v_commit jsonb; v_offset integer;
  v_staged bigint; v_products bigint;
BEGIN
  SELECT id INTO v_owner FROM auth.users
  WHERE lower(email)='owner@rawaea.com' AND email_confirmed_at IS NOT NULL;
  IF v_owner IS NULL THEN RAISE EXCEPTION 'QA_OWNER_IDENTITY_NOT_CONFIRMED'; END IF;
  PERFORM set_config('request.jwt.claim.sub',v_owner::text,true);
  PERFORM set_config('request.jwt.claims',jsonb_build_object('sub',v_owner,'role','authenticated','aud','authenticated')::text,true);
  PERFORM set_config('role','authenticated',true);
  INSERT INTO public.count_projects(name,code,created_by)
  VALUES('QA 5K Rollback','QA5K-'||substr(replace(gen_random_uuid()::text,'-',''),1,12),v_owner)
  RETURNING id INTO v_project;
  v_batch := public.count_create_import_batch(v_project,NULL,'qa-5000-products.csv','csv',encode(digest('countflow-5k-qa','sha256'),'hex'));
  FOR v_offset IN 0..4000 BY 1000 LOOP
    SELECT jsonb_agg(jsonb_build_object(
      '_row_number',v_offset+g+1,
      'sku','QA5K-'||lpad((v_offset+g+1)::text,6,'0'),
      'barcode','QA5KB-'||lpad((v_offset+g+1)::text,6,'0'),
      'name','QA 5K Product '||(v_offset+g+1),
      'base_unit','each','units','[]'::jsonb
    )) INTO v_rows FROM generate_series(0,999) g;
    v_chunk_result := public.count_stage_import_rows(v_batch,v_rows,v_offset);
  END LOOP;
  v_commit := public.count_commit_import_batch(v_batch);
  SELECT count(*) INTO v_staged FROM public.count_import_rows WHERE batch_id=v_batch;
  SELECT count(*) INTO v_products FROM public.count_products WHERE project_id=v_project;
  IF v_commit->>'status'<>'committed' OR (v_commit->>'accepted_rows')::bigint<>5000 OR v_staged<>5000 OR v_products<>5000
  THEN RAISE EXCEPTION 'QA_5K_IMPORT_ASSERTION_FAILED: %, staged %, products %',v_commit,v_staged,v_products; END IF;
  PERFORM set_config('role','none',true);
  INSERT INTO pg_temp.countflow_5k_result(result)
  VALUES(jsonb_build_object('status','PASS','rows_submitted',5000,'rows_staged',v_staged,
    'rows_accepted',(v_commit->>'accepted_rows')::bigint,'products_committed',v_products,
    'batch_chunks',5,'rollback_only',true));
END
$countflow_5k$;
SELECT result FROM pg_temp.countflow_5k_result;
ROLLBACK;
