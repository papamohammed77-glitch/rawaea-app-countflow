
CREATE OR REPLACE FUNCTION public.count_update_role_permissions(
 p_role_id uuid,
 p_permission_codes text[]
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
 v_role public.count_roles;
 v_invalid text[];
 v_count integer;
BEGIN
 SELECT r.id,r.client_id,r.is_system,r.is_active,r.scope
 INTO v_role
 FROM public.count_roles r WHERE r.id=p_role_id;
 IF NOT FOUND OR v_role.client_id IS NULL OR v_role.is_system OR NOT v_role.is_active THEN
   RAISE EXCEPTION 'CUSTOM_CLIENT_ROLE_NOT_FOUND_OR_NOT_EDITABLE';
 END IF;
 IF NOT counting_private.has_client_permission(v_role.client_id,'role.manage') THEN
   RAISE EXCEPTION 'ROLE_MANAGE_PERMISSION_REQUIRED';
 END IF;
 SELECT array_agg(x.code) INTO v_invalid
 FROM (SELECT DISTINCT unnest(coalesce(p_permission_codes,ARRAY[]::text[])) AS code) x
 LEFT JOIN public.count_permissions p ON p.code=x.code
 WHERE p.code IS NULL
    OR p.scope='platform'
    OR (v_role.scope='project' AND p.scope<>'project')
    OR (p.code IN ('client.members.manage','client.manage','role.manage')
        AND NOT counting_private.is_platform_owner());
 IF v_invalid IS NOT NULL THEN
   RAISE EXCEPTION 'INVALID_OR_ESCALATED_ROLE_PERMISSIONS:%',array_to_string(v_invalid,',');
 END IF;
 DELETE FROM public.count_role_permissions WHERE role_id=p_role_id;
 INSERT INTO public.count_role_permissions(role_id,permission_code)
 SELECT p_role_id,x.code
 FROM (SELECT DISTINCT unnest(coalesce(p_permission_codes,ARRAY[]::text[])) AS code) x;
 GET DIAGNOSTICS v_count=ROW_COUNT;
 UPDATE public.count_roles SET updated_by=(SELECT auth.uid()) WHERE id=p_role_id;
 RETURN jsonb_build_object('role_id',p_role_id,'permission_count',v_count);
END;
$$;
