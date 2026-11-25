
BEGIN;
DO $$
DECLARE v_oid oid; v_name text; v_def text; v_new text;
 v_targets text[]:=ARRAY[
 'counting_private.assert_gamification_session_participation(uuid)',
 'counting_private.assert_session_device_queues_clear(uuid)',
 'public.count_assign_recount_task(uuid,uuid)',
 'counting_private.count_gamification_snapshot(uuid)',
 'public.count_generate_recount_tasks(uuid,uuid,numeric)',
 'public.count_get_assignment_scope(uuid)',
 'public.count_record_entry(uuid,uuid,uuid,numeric,text,uuid,text,text,text)',
 'public.count_report_device_queue(uuid,text,integer,text)',
 'public.count_touch_presence(uuid,text,text,text,text,text,uuid)',
 'public.count_waive_device_queue(uuid,uuid,text,text)',
 'counting_private.record_recount_entry(uuid,numeric,text,uuid,text,text,text)'
];
BEGIN
 FOREACH v_name IN ARRAY v_targets LOOP
  v_oid:=to_regprocedure(v_name);
  IF v_oid IS NULL THEN RAISE EXCEPTION 'EXPECTED_COUNTFLOW_FUNCTION_MISSING:%',v_name; END IF;
  v_def:=pg_get_functiondef(v_oid);v_new:=v_def;
  IF v_name='counting_private.assert_gamification_session_participation(uuid)' THEN
    v_new:=replace(v_new,'AND m.role = ''counter''','AND m.status = ''active'' AND counting_private.has_project_permission(m.project_id, ''count.entry.create'')');
  ELSIF v_name='counting_private.assert_session_device_queues_clear(uuid)' THEN
    v_new:=replace(v_new,'m.role=''counter''','EXISTS (SELECT 1 FROM public.count_role_permissions rp WHERE rp.role_id=m.role_id AND rp.permission_code=''count.entry.create'')');
  ELSIF v_name='public.count_assign_recount_task(uuid,uuid)' THEN
    v_new:=replace(v_new,'role = ''counter'' AND status=''active''','role_id IN (SELECT rp.role_id FROM public.count_role_permissions rp WHERE rp.permission_code=''count.entry.create'') AND status=''active''');
  ELSIF v_name='public.count_generate_recount_tasks(uuid,uuid,numeric)' THEN
    v_new:=replace(v_new,'role = ''counter'' AND status=''active''','role_id IN (SELECT rp.role_id FROM public.count_role_permissions rp WHERE rp.permission_code=''count.entry.create'') AND status=''active''');
  ELSIF v_name='counting_private.count_gamification_snapshot(uuid)' THEN
    v_new:=replace(v_new,'m.role = ''counter''','m.status = ''active'' AND counting_private.has_project_permission(m.project_id, ''count.entry.create'')');
  ELSIF v_name='public.count_get_assignment_scope(uuid)' THEN
    v_new:=replace(v_new,'role IN (''counter'',''auditor'') AND status=''active''','status=''active'' AND (counting_private.has_project_permission(project_id, ''count.entry.create'') OR counting_private.has_project_permission(project_id, ''count.entry.read'') OR counting_private.has_project_permission(project_id, ''control.read''))');
  ELSIF v_name='public.count_record_entry(uuid,uuid,uuid,numeric,text,uuid,text,text,text)' THEN
    v_new:=replace(v_new,'role = ''counter'';','status = ''active'' AND counting_private.has_project_permission(project_id, ''count.entry.create'');');
  ELSIF v_name='public.count_report_device_queue(uuid,text,integer,text)' THEN
    v_new:=replace(v_new,'role=''counter''','counting_private.has_project_permission(project_id, ''count.entry.create'')');
  ELSIF v_name='public.count_touch_presence(uuid,text,text,text,text,text,uuid)' THEN
    v_new:=replace(v_new,'role IN (''counter'',''auditor'') AND status=''active''','status=''active'' AND (counting_private.has_project_permission(project_id, ''count.entry.create'') OR counting_private.has_project_permission(project_id, ''control.read'') OR counting_private.has_project_permission(project_id, ''count.entry.read''))');
  ELSIF v_name='public.count_waive_device_queue(uuid,uuid,text,text)' THEN
    v_new:=replace(v_new,'m.role=''counter''','EXISTS (SELECT 1 FROM public.count_role_permissions rp WHERE rp.role_id=m.role_id AND rp.permission_code=''count.entry.create'')');
  ELSIF v_name='counting_private.record_recount_entry(uuid,numeric,text,uuid,text,text,text)' THEN
    v_new:=replace(v_new,'role = ''counter'';','status = ''active'' AND counting_private.has_project_permission(project_id, ''count.entry.create'');');
  END IF;
  IF v_new=v_def THEN RAISE EXCEPTION 'ROLE_PREDICATE_PATCH_NOT_APPLIED:%',v_name; END IF;
  EXECUTE v_new;
 END LOOP;
END $$;
COMMIT;
