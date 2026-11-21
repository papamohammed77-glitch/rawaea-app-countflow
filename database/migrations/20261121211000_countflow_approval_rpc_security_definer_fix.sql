-- Critical P1 runtime repair: reconciliation approval invokes private server-only
-- queue checks. Keep the public RPC executable by authenticated, but run its body as the
-- trusted function owner with an empty search_path and its existing explicit owner identity gate.
ALTER FUNCTION public.count_approve_reconciliation(uuid) SECURITY DEFINER;
ALTER FUNCTION public.count_approve_reconciliation(uuid) SET search_path TO '';

DO $verify$
DECLARE
  v record;
BEGIN
  SELECT p.prosecdef,p.proconfig,pg_get_functiondef(p.oid) definition
  INTO v
  FROM pg_proc p
  WHERE p.oid='public.count_approve_reconciliation(uuid)'::regprocedure;
  IF NOT v.prosecdef THEN RAISE EXCEPTION 'COUNT_APPROVAL_MUST_BE_SECURITY_DEFINER'; END IF;
  IF NOT EXISTS (SELECT 1 FROM unnest(v.proconfig) c WHERE c='search_path=""') THEN
    RAISE EXCEPTION 'COUNT_APPROVAL_EMPTY_SEARCH_PATH_REQUIRED';
  END IF;
  IF position('counting_private.is_platform_owner()' IN v.definition)=0 THEN
    RAISE EXCEPTION 'COUNT_APPROVAL_OWNER_GATE_MISSING';
  END IF;
END
$verify$;

COMMENT ON FUNCTION public.count_approve_reconciliation(uuid)
IS 'Owner-only CountFlow reconciliation approval. SECURITY DEFINER is required for the server-only device queue barrier helper; owner identity is verified inside the function and search_path is empty.';
