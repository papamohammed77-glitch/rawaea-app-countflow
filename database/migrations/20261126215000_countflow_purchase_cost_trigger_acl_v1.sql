-- This is a trigger-only SECURITY DEFINER function. PostgreSQL invokes
-- it through the bound triggers; client/service roles do not need EXECUTE.
-- Keep it unreachable as a direct PostgREST RPC.
REVOKE ALL ON FUNCTION counting_private.validate_purchase_cost_unit_snapshot()
FROM PUBLIC, anon, authenticated, service_role;

COMMENT ON FUNCTION counting_private.validate_purchase_cost_unit_snapshot()
IS 'CountFlow trigger-only function. No client/service role EXECUTE privilege; invoked only by the two BEFORE INSERT/UPDATE triggers.';
