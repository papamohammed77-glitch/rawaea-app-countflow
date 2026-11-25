
CREATE OR REPLACE FUNCTION counting_private.guard_count_member_role()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE v_client_id uuid; v_role_key text; v_scope text; v_role_client uuid; v_system boolean;
BEGIN
 SELECT p.client_id INTO v_client_id FROM public.count_projects p WHERE p.id=NEW.project_id;
 IF NOT FOUND THEN RAISE EXCEPTION 'PROJECT_NOT_FOUND'; END IF;

 IF TG_OP='UPDATE' AND NEW.role IS DISTINCT FROM OLD.role AND NEW.role_id IS NOT DISTINCT FROM OLD.role_id THEN
   NEW.role_id:=NULL;
 END IF;

 IF NEW.role_id IS NULL THEN
   IF NEW.role='custom' THEN RAISE EXCEPTION 'CUSTOM_ROLE_ID_REQUIRED'; END IF;
   SELECT r.id INTO NEW.role_id
   FROM public.count_roles r
   WHERE r.role_key=NEW.role AND r.scope='project' AND r.client_id IS NULL AND r.is_system AND r.is_active;
 END IF;

 SELECT r.role_key,r.scope,r.client_id,r.is_system
 INTO v_role_key,v_scope,v_role_client,v_system
 FROM public.count_roles r WHERE r.id=NEW.role_id AND r.is_active;

 IF NOT FOUND OR v_scope<>'project' THEN RAISE EXCEPTION 'PROJECT_ROLE_NOT_FOUND_OR_INACTIVE'; END IF;
 IF v_role_client IS NOT NULL AND v_role_client IS DISTINCT FROM v_client_id THEN
   RAISE EXCEPTION 'PROJECT_ROLE_CLIENT_SCOPE_MISMATCH';
 END IF;
 IF v_system THEN
   NEW.role:=v_role_key;
 ELSE
   NEW.role:='custom';
 END IF;
 RETURN NEW;
END;
$$;

DROP POLICY IF EXISTS count_role_permissions_insert ON public.count_role_permissions;
CREATE POLICY count_role_permissions_insert ON public.count_role_permissions
FOR INSERT TO authenticated
WITH CHECK (
 EXISTS (
   SELECT 1
   FROM public.count_roles r
   JOIN public.count_permissions p ON p.code=count_role_permissions.permission_code
   WHERE r.id=count_role_permissions.role_id
     AND r.client_id IS NOT NULL
     AND NOT r.is_system
     AND counting_private.has_client_permission(r.client_id,'role.manage')
     AND p.scope<>'platform'
     AND (r.scope='client' OR p.scope='project')
 )
);

DROP POLICY IF EXISTS count_sessions_insert ON public.count_sessions;
CREATE POLICY count_sessions_insert ON public.count_sessions
FOR INSERT TO authenticated
WITH CHECK (
 counting_private.is_platform_owner()
 OR (
   created_by=(SELECT auth.uid())
   AND counting_private.has_project_permission(project_id,'operation.create')
 )
);

DROP POLICY IF EXISTS count_sessions_update ON public.count_sessions;
CREATE POLICY count_sessions_update ON public.count_sessions
FOR UPDATE TO authenticated
USING (
 counting_private.is_platform_owner()
 OR counting_private.has_project_permission(project_id,'operation.manage')
)
WITH CHECK (
 counting_private.is_platform_owner()
 OR counting_private.has_project_permission(project_id,'operation.manage')
);

CREATE OR REPLACE FUNCTION counting_private.count_create_operation_impl(
 p_client_id uuid,p_project_name text,p_project_code text,p_operation_name text,
 p_operation_code text,p_branch_name text,p_branch_code text,
 p_planned_start_at timestamptz,p_planned_end_at timestamptz,p_timezone text,
 p_priority smallint,p_counting_mode text,p_show_expected_quantity boolean,
 p_capture_images boolean,p_require_images boolean,p_allow_unknown_products boolean,
 p_instructions text
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
 v_project_id uuid; v_session_id uuid; v_branch_id uuid;
 v_timezone text:=coalesce(nullif(btrim(p_timezone),''),'Africa/Cairo');
 v_project_code text:=upper(btrim(p_project_code));
 v_branch_code text:=upper(btrim(p_branch_code));
 v_operation_code text:=nullif(upper(btrim(coalesce(p_operation_code,''))),'');
 v_counting_mode text:=coalesce(nullif(btrim(p_counting_mode),''),'barcode');
BEGIN
 IF (SELECT auth.uid()) IS NULL THEN RAISE EXCEPTION 'AUTHENTICATION_REQUIRED'; END IF;
 IF NOT (
   counting_private.has_client_permission(p_client_id,'project.create')
   AND counting_private.has_client_permission(p_client_id,'operation.create')
 ) THEN RAISE EXCEPTION 'CLIENT_OPERATION_CREATE_PERMISSION_REQUIRED'; END IF;
 IF NOT EXISTS(SELECT 1 FROM public.count_clients c WHERE c.id=p_client_id AND c.status='active') THEN RAISE EXCEPTION 'CLIENT_NOT_FOUND_OR_INACTIVE'; END IF;
 IF nullif(btrim(p_project_name),'') IS NULL OR length(btrim(p_project_name))>160
   OR nullif(v_project_code,'') IS NULL OR v_project_code !~ '^[A-Z0-9_-]{2,40}$'
   OR nullif(btrim(p_operation_name),'') IS NULL OR length(btrim(p_operation_name))>160
   OR nullif(btrim(p_branch_name),'') IS NULL OR length(btrim(p_branch_name))>120
   OR nullif(v_branch_code,'') IS NULL OR v_branch_code !~ '^[A-Z0-9_-]{2,40}$'
   OR (v_operation_code IS NOT NULL AND v_operation_code !~ '^[A-Z0-9_-]{2,40}$')
   OR v_counting_mode NOT IN ('barcode','manual','mixed')
   OR coalesce(p_priority,3) NOT BETWEEN 1 AND 5
   OR (p_planned_start_at IS NOT NULL AND p_planned_end_at IS NOT NULL AND p_planned_end_at<=p_planned_start_at)
   OR NOT EXISTS(SELECT 1 FROM pg_catalog.pg_timezone_names z WHERE z.name=v_timezone)
   OR (coalesce(p_require_images,false) AND NOT coalesce(p_capture_images,true)) THEN
   RAISE EXCEPTION 'INVALID_OPERATION_CONFIGURATION';
 END IF;
 INSERT INTO public.count_projects(name,code,status,created_by,client_id)
 VALUES (btrim(p_project_name),v_project_code,'draft',(SELECT auth.uid()),p_client_id)
 RETURNING id INTO v_project_id;
 INSERT INTO public.count_locations(project_id,parent_id,location_type,code,name,sort_order)
 VALUES (v_project_id,NULL,'branch',v_branch_code,btrim(p_branch_name),0)
 RETURNING id INTO v_branch_id;
 INSERT INTO public.count_sessions(
   project_id,name,status,created_by,operation_code,planned_start_at,planned_end_at,
   schedule_timezone,priority,counting_mode,show_expected_quantity,capture_images,
   require_images,allow_unknown_products,instructions,branch_location_id
 )
 VALUES (
   v_project_id,btrim(p_operation_name),'planned',(SELECT auth.uid()),v_operation_code,
   p_planned_start_at,p_planned_end_at,v_timezone,coalesce(p_priority,3),v_counting_mode,
   coalesce(p_show_expected_quantity,false),coalesce(p_capture_images,true),
   coalesce(p_require_images,false),coalesce(p_allow_unknown_products,false),
   nullif(btrim(coalesce(p_instructions,'')),''),v_branch_id
 )
 RETURNING id INTO v_session_id;
 RETURN jsonb_build_object('client_id',p_client_id,'project_id',v_project_id,'session_id',v_session_id,
   'branch_location_id',v_branch_id,'project_code',v_project_code,'operation_code',v_operation_code,'session_status','planned');
END;
$$;

REVOKE ALL ON FUNCTION counting_private.count_create_operation_impl(uuid,text,text,text,text,text,text,timestamptz,timestamptz,text,smallint,text,boolean,boolean,boolean,boolean,text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION counting_private.count_create_operation_impl(uuid,text,text,text,text,text,text,timestamptz,timestamptz,text,smallint,text,boolean,boolean,boolean,boolean,text) TO authenticated,service_role;

