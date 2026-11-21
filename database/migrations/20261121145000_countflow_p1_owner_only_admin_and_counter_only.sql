-- CountFlow P1 security boundary: platform-owner administration and counter-only field counting.
-- Scope: CountFlow objects in rawaea-staging only. No application data is modified.
CREATE OR REPLACE FUNCTION public.count_bootstrap_project_owner()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE v_email text; v_confirmed_at timestamptz;
BEGIN
  SELECT lower(coalesce(u.email,'')), u.email_confirmed_at INTO v_email,v_confirmed_at
  FROM auth.users u WHERE u.id=NEW.created_by;
  IF NOT FOUND OR v_email<>'owner@rawaea.com' OR v_confirmed_at IS NULL THEN
    RAISE EXCEPTION 'PLATFORM_OWNER_REQUIRED';
  END IF;
  INSERT INTO public.count_members(project_id,user_id,display_name,username,role,status)
  VALUES(NEW.id,NEW.created_by,'مالك CountFlow','owner@rawaea.com','supervisor','active')
  ON CONFLICT(project_id,user_id) DO NOTHING;
  RETURN NEW;
END
$function$;

ALTER POLICY count_projects_create ON public.count_projects WITH CHECK (
  created_by=(SELECT auth.uid()) AND counting_private.is_platform_owner()
);

DO $policy_hardening$
DECLARE r record; v_using text; v_check text;
BEGIN
 FOR r IN
  SELECT tablename,policyname,cmd,qual,with_check FROM pg_policies
  WHERE schemaname='public' AND tablename LIKE 'count_%'
   AND cmd IN ('INSERT','UPDATE','DELETE')
   AND tablename NOT IN ('count_assignments','count_audit_log','count_presence','count_entries','count_entry_images','count_devices')
   AND (coalesce(qual,'')||' '||coalesce(with_check,'')) LIKE '%counting_private.is_supervisor(%'
 LOOP
  v_using:=CASE WHEN r.qual IS NULL THEN NULL ELSE regexp_replace(r.qual,'counting_private[.]is_supervisor[(][^)]*[)]','counting_private.is_platform_owner()','g') END;
  v_check:=CASE WHEN r.with_check IS NULL THEN NULL ELSE regexp_replace(r.with_check,'counting_private[.]is_supervisor[(][^)]*[)]','counting_private.is_platform_owner()','g') END;
  IF r.cmd='INSERT' THEN EXECUTE format('ALTER POLICY %I ON public.%I WITH CHECK (%s)',r.policyname,r.tablename,v_check);
  ELSIF r.cmd='UPDATE' THEN EXECUTE format('ALTER POLICY %I ON public.%I USING (%s) WITH CHECK (%s)',r.policyname,r.tablename,v_using,v_check);
  ELSIF r.cmd='DELETE' THEN EXECUTE format('ALTER POLICY %I ON public.%I USING (%s)',r.policyname,r.tablename,v_using);
  END IF;
 END LOOP;
END
$policy_hardening$;

DO $engagement_hardening$
DECLARE v_def text; v_new text; v_sig regprocedure:='public.count_create_engagement(text,text,text)'::regprocedure;
BEGIN
 SELECT pg_get_functiondef(v_sig) INTO v_def;
 v_new:=replace(v_def,E'begin\n  if (select auth.uid()) is null then',
  E'begin\n  if not counting_private.is_platform_owner() then\n    raise exception ''PLATFORM_OWNER_REQUIRED'';\n  end if;\n\n  if (select auth.uid()) is null then');
 IF v_new=v_def OR position('counting_private.is_platform_owner()' IN v_new)=0 THEN RAISE EXCEPTION 'COUNT_CREATE_ENGAGEMENT_SOURCE_DID_NOT_MATCH_EXPECTED_CONTRACT'; END IF;
 EXECUTE v_new;
END
$engagement_hardening$;

DO $rpc_hardening$
DECLARE v_sig regprocedure; v_def text; v_new text;
v_signatures regprocedure[]:=ARRAY[
 'counting_private.count_create_import_batch_impl(uuid,uuid,text,text,text)'::regprocedure,
 'counting_private.count_stage_import_rows_impl(uuid,jsonb,integer)'::regprocedure,
 'counting_private.count_commit_import_batch_impl(uuid)'::regprocedure,
 'public.count_approve_reconciliation(uuid)'::regprocedure,
 'public.count_assign_recount_task(uuid,uuid)'::regprocedure,
 'public.count_evaluate_session_alerts(uuid)'::regprocedure,
 'public.count_generate_recount_tasks(uuid,uuid,numeric)'::regprocedure,
 'public.count_reconcile_session(uuid)'::regprocedure,
 'public.count_review_recount_task(uuid,text,text)'::regprocedure,
 'public.count_transition_session(uuid,text)'::regprocedure
];
BEGIN
 FOREACH v_sig IN ARRAY v_signatures LOOP
  SELECT pg_get_functiondef(v_sig) INTO v_def;
  v_new:=replace(v_def,'counting_private.is_supervisor(','counting_private.is_platform_owner(');
  IF v_new=v_def THEN RAISE EXCEPTION 'EXPECTED_SUPERVISOR_GATE_NOT_FOUND_IN_RPC: %',v_sig; END IF;
  EXECUTE v_new;
 END LOOP;
END
$rpc_hardening$;

DO $counter_only$
DECLARE v_def text; v_new text; v_expr text; v_new_expr text; v_sig regprocedure;
BEGIN
 v_sig:='public.count_record_entry(uuid,uuid,uuid,numeric,text,uuid,text,text,text)'::regprocedure;
 SELECT pg_get_functiondef(v_sig) INTO v_def;
 v_new:=replace(v_def,'role IN (''counter'',''auditor'')','role = ''counter''');
 IF v_new=v_def THEN RAISE EXCEPTION 'COUNT_RECORD_ENTRY_ROLE_GUARD_NOT_FOUND'; END IF; EXECUTE v_new;

 v_sig:='counting_private.record_recount_entry(uuid,numeric,text,uuid,text,text,text)'::regprocedure;
 SELECT pg_get_functiondef(v_sig) INTO v_def;
 v_new:=replace(v_def,'role IN (''counter'',''auditor'')','role = ''counter''');
 IF v_new=v_def THEN RAISE EXCEPTION 'COUNT_RECOUNT_ENTRY_ROLE_GUARD_NOT_FOUND'; END IF; EXECUTE v_new;

 v_sig:='public.count_assign_recount_task(uuid,uuid)'::regprocedure;
 SELECT pg_get_functiondef(v_sig) INTO v_def;
 v_new:=replace(v_def,'role IN (''counter'',''auditor'')','role = ''counter''');
 IF v_new=v_def THEN RAISE EXCEPTION 'COUNT_ASSIGN_RECOUNT_ROLE_GUARD_NOT_FOUND'; END IF; EXECUTE v_new;

 SELECT pg_get_expr(polwithcheck,polrelid) INTO v_expr
 FROM pg_policy WHERE polrelid='public.count_entries'::regclass AND polname='count_entries_insert';
 v_new_expr:=replace(v_expr,'m.role = ANY (ARRAY[''counter''::text, ''auditor''::text])','m.role = ''counter''::text');
 IF v_expr IS NULL OR v_new_expr=v_expr THEN RAISE EXCEPTION 'COUNT_ENTRIES_INSERT_ROLE_POLICY_NOT_FOUND'; END IF;
 EXECUTE format('ALTER POLICY count_entries_insert ON public.count_entries WITH CHECK (%s)',v_new_expr);
END
$counter_only$;

REVOKE ALL ON FUNCTION public.count_create_engagement(text,text,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_create_engagement(text,text,text) TO authenticated,service_role;
REVOKE ALL ON FUNCTION public.count_create_import_batch(uuid,uuid,text,text,text) FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.count_stage_import_rows(uuid,jsonb,integer) FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.count_commit_import_batch(uuid) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_create_import_batch(uuid,uuid,text,text,text) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.count_stage_import_rows(uuid,jsonb,integer) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.count_commit_import_batch(uuid) TO authenticated,service_role;
REVOKE ALL ON FUNCTION public.count_record_entry(uuid,uuid,uuid,numeric,text,uuid,text,text,text) FROM PUBLIC,anon;
REVOKE ALL ON FUNCTION public.count_record_recount_entry(uuid,numeric,text,uuid,text,text,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION public.count_record_entry(uuid,uuid,uuid,numeric,text,uuid,text,text,text) TO authenticated,service_role;
GRANT EXECUTE ON FUNCTION public.count_record_recount_entry(uuid,numeric,text,uuid,text,text,text) TO authenticated,service_role;
