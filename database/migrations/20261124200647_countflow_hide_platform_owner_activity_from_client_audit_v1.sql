
DROP POLICY IF EXISTS count_client_audit_read ON public.count_client_audit_log;
CREATE POLICY count_client_audit_read ON public.count_client_audit_log
FOR SELECT TO authenticated
USING (
 counting_private.is_platform_owner()
 OR (
   NOT counting_private.is_platform_owner_actor(actor_id)
   AND counting_private.has_client_permission(client_id,'client.read')
 )
);
