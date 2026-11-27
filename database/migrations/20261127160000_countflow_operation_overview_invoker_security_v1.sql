-- LVE-792 security follow-up: make operation overview obey caller RLS.
-- count_projects already has a project-membership SELECT policy; grant table-level SELECT
-- so invoker-security views can evaluate that policy instead of bypassing it.

GRANT SELECT ON public.count_projects TO authenticated;

ALTER VIEW public.count_operation_overview
  SET (security_invoker = true);

REVOKE ALL ON public.count_operation_overview FROM anon;
REVOKE ALL ON public.count_operation_overview FROM authenticated;
REVOKE ALL ON public.count_operation_overview FROM service_role;

GRANT SELECT ON public.count_operation_overview TO authenticated, service_role;

COMMENT ON VIEW public.count_operation_overview IS
  'Project-scoped operational overview. Uses security_invoker so every underlying table RLS policy is evaluated for the querying role.';
