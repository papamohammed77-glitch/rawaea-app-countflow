CREATE OR REPLACE VIEW public.count_control_reconciliation_runs WITH (security_barrier = true) AS
SELECT id,project_id,session_id,run_number,status,expected_rows,counted_rows,matched_rows,variance_rows,uncounted_rows,total_expected,total_counted,created_at,computed_at,approved_at,entry_count_snapshot
FROM public.count_reconciliation_runs
WHERE counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id) OR counting_private.is_auditor(project_id);
CREATE OR REPLACE VIEW public.count_control_reconciliation_lines WITH (security_barrier = true) AS
SELECT id,project_id,run_id,session_id,product_id,location_id,product_sku,product_name,location_path,unit,expected_quantity,counted_quantity,variance_quantity,variance_percent,counted_events,counter_count,result_status,computed_at,expected_scope
FROM public.count_reconciliation_lines
WHERE counting_private.is_platform_owner() OR counting_private.is_supervisor(project_id) OR counting_private.is_auditor(project_id);
REVOKE ALL ON public.count_control_reconciliation_runs FROM PUBLIC,anon;
REVOKE ALL ON public.count_control_reconciliation_lines FROM PUBLIC,anon;
GRANT SELECT ON public.count_control_reconciliation_runs TO authenticated;
GRANT SELECT ON public.count_control_reconciliation_lines TO authenticated;

CREATE OR REPLACE FUNCTION public.countflow_broadcast_changes()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO ''
AS $function$
DECLARE
 v_project_id uuid;
 v_session_id uuid;
 v_member_id uuid;
 v_actor_id uuid;
 m record;
 v_session_new public.count_sessions%ROWTYPE;
 v_session_old public.count_sessions%ROWTYPE;
 v_alert_new public.count_alerts%ROWTYPE;
 v_alert_old public.count_alerts%ROWTYPE;
 v_recount_new public.count_recount_tasks%ROWTYPE;
 v_recount_old public.count_recount_tasks%ROWTYPE;
 v_run_new public.count_reconciliation_runs%ROWTYPE;
 v_run_old public.count_reconciliation_runs%ROWTYPE;
 v_presence_new public.count_presence%ROWTYPE;
 v_presence_old public.count_presence%ROWTYPE;
BEGIN
 IF TG_TABLE_NAME='count_sessions' THEN
  v_session_new:=NEW; v_session_old:=OLD;
  IF counting_private.is_platform_owner_actor(v_session_new.created_by) THEN v_session_new.created_by:=NULL; END IF;
  IF counting_private.is_platform_owner_actor(v_session_old.created_by) THEN v_session_old.created_by:=NULL; END IF;
  v_project_id:=coalesce(NEW.project_id,OLD.project_id);
  v_session_id:=coalesce(NEW.id,OLD.id);
  PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_session_new,v_session_old);
  PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_session_new,v_session_old);
  FOR m IN SELECT id FROM public.count_members WHERE project_id=v_project_id AND status IN ('active','paused') LOOP
   PERFORM realtime.broadcast_changes('countflow:member:'||m.id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_session_new,v_session_old);
  END LOOP;
 ELSIF TG_TABLE_NAME='count_members' THEN
  v_project_id:=coalesce(NEW.project_id,OLD.project_id);
  v_member_id:=coalesce(NEW.id,OLD.id);
  IF NOT counting_private.is_platform_owner_actor(coalesce(NEW.user_id,OLD.user_id)) THEN
   PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  END IF;
  PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
 ELSIF TG_TABLE_NAME='count_assignments' THEN
  SELECT project_id INTO v_project_id FROM public.count_sessions WHERE id=coalesce(NEW.session_id,OLD.session_id);
  v_member_id:=coalesce(NEW.member_id,OLD.member_id);
  SELECT user_id INTO v_actor_id FROM public.count_members WHERE id=v_member_id;
  IF NOT counting_private.is_platform_owner_actor(v_actor_id) THEN
   PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
   PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  END IF;
 ELSIF TG_TABLE_NAME='count_entry_images' THEN
  IF NOT counting_private.is_platform_owner_actor(coalesce(NEW.uploaded_by,OLD.uploaded_by)) THEN
   SELECT session_id INTO v_session_id FROM public.count_entries WHERE id=coalesce(NEW.entry_id,OLD.entry_id);
   IF v_session_id IS NOT NULL THEN
    PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
   END IF;
  END IF;
 ELSIF TG_TABLE_NAME='count_locations' THEN
  v_project_id:=coalesce(NEW.project_id,OLD.project_id);
  PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  FOR m IN SELECT id FROM public.count_members WHERE project_id=v_project_id AND status IN ('active','paused') LOOP
   PERFORM realtime.broadcast_changes('countflow:member:'||m.id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  END LOOP;
 ELSIF TG_TABLE_NAME='count_devices' THEN
  v_member_id:=coalesce(NEW.member_id,OLD.member_id);
  SELECT user_id INTO v_actor_id FROM public.count_members WHERE id=v_member_id;
  IF NOT counting_private.is_platform_owner_actor(v_actor_id) THEN
   v_project_id:=coalesce(NEW.project_id,OLD.project_id);
   PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
   PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  END IF;
 ELSIF TG_TABLE_NAME='count_import_batches' THEN
  IF NOT counting_private.is_platform_owner_actor(coalesce(NEW.imported_by,OLD.imported_by)) THEN
   v_project_id:=coalesce(NEW.project_id,OLD.project_id);
   PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  END IF;
 ELSE
  v_session_id:=coalesce(NEW.session_id,OLD.session_id);
  IF TG_TABLE_NAME='count_alerts' THEN
   v_alert_new:=NEW; v_alert_old:=OLD;
   IF counting_private.is_platform_owner_actor(v_alert_new.acknowledged_by) THEN v_alert_new.acknowledged_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_alert_new.resolved_by) THEN v_alert_new.resolved_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_alert_old.acknowledged_by) THEN v_alert_old.acknowledged_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_alert_old.resolved_by) THEN v_alert_old.resolved_by:=NULL; END IF;
   IF v_session_id IS NOT NULL THEN
    PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_alert_new,v_alert_old);
   END IF;
  ELSIF TG_TABLE_NAME='count_recount_tasks' THEN
   v_recount_new:=NEW; v_recount_old:=OLD;
   IF counting_private.is_platform_owner_actor(v_recount_new.created_by) THEN v_recount_new.created_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_recount_new.reviewed_by) THEN v_recount_new.reviewed_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_recount_old.created_by) THEN v_recount_old.created_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_recount_old.reviewed_by) THEN v_recount_old.reviewed_by:=NULL; END IF;
   IF v_recount_new.assigned_member_id IS NOT NULL AND EXISTS (SELECT 1 FROM public.count_members x WHERE x.id=v_recount_new.assigned_member_id AND counting_private.is_platform_owner_actor(x.user_id)) THEN v_recount_new.assigned_member_id:=NULL; END IF;
   IF v_recount_old.assigned_member_id IS NOT NULL AND EXISTS (SELECT 1 FROM public.count_members x WHERE x.id=v_recount_old.assigned_member_id AND counting_private.is_platform_owner_actor(x.user_id)) THEN v_recount_old.assigned_member_id:=NULL; END IF;
   IF v_session_id IS NOT NULL THEN
    PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_recount_new,v_recount_old);
   END IF;
   v_member_id:=coalesce(NEW.assigned_member_id,OLD.assigned_member_id);
   SELECT user_id INTO v_actor_id FROM public.count_members WHERE id=v_member_id;
   IF v_member_id IS NOT NULL AND NOT counting_private.is_platform_owner_actor(v_actor_id) THEN
    PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_recount_new,v_recount_old);
   END IF;
  ELSIF TG_TABLE_NAME='count_reconciliation_runs' THEN
   v_run_new:=NEW; v_run_old:=OLD;
   IF counting_private.is_platform_owner_actor(v_run_new.created_by) THEN v_run_new.created_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_run_new.approved_by) THEN v_run_new.approved_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_run_old.created_by) THEN v_run_old.created_by:=NULL; END IF;
   IF counting_private.is_platform_owner_actor(v_run_old.approved_by) THEN v_run_old.approved_by:=NULL; END IF;
   v_run_new.metadata:='{}'::jsonb; v_run_old.metadata:='{}'::jsonb;
   IF v_session_id IS NOT NULL THEN
    PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_run_new,v_run_old);
   END IF;
  ELSIF TG_TABLE_NAME='count_presence' THEN
   v_presence_new:=NEW; v_presence_old:=OLD;
   v_member_id:=coalesce(NEW.member_id,OLD.member_id);
   SELECT user_id INTO v_actor_id FROM public.count_members WHERE id=v_member_id;
   IF NOT counting_private.is_platform_owner_actor(v_actor_id) AND v_session_id IS NOT NULL THEN
    PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,v_presence_new,v_presence_old);
   END IF;
  ELSE
   IF v_session_id IS NOT NULL THEN
    PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
   END IF;
  END IF;
 END IF;
 RETURN NULL;
END;
$function$;
