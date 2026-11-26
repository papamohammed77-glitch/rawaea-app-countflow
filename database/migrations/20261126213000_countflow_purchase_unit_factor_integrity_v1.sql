-- CountFlow only: reject purchase-cost unit factors that do not match the
-- product's configured base/alternate unit. The raw imported cost is preserved
-- and annotated; it is never silently coerced into a different unit.
CREATE OR REPLACE FUNCTION counting_private.validate_purchase_cost_unit_snapshot()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_expected_factor numeric;
  v_warnings text[] := coalesce(NEW.warning_codes, ARRAY[]::text[]);
BEGIN
  IF NEW.product_id IS NULL THEN
    NEW.warning_codes := array_remove(v_warnings, 'PURCHASE_UNIT_FACTOR_MISMATCH');
    RETURN NEW;
  END IF;

  IF nullif(btrim(NEW.purchase_unit), '') IS NULL
     OR NEW.unit_factor_to_base IS NULL THEN
    NEW.warning_codes := array_remove(v_warnings, 'PURCHASE_UNIT_FACTOR_MISMATCH');
    RETURN NEW;
  END IF;

  v_expected_factor := counting_private.unit_factor_to_base(
    NEW.product_id,
    NEW.purchase_unit
  );

  IF v_expected_factor IS NULL
     OR round(v_expected_factor, 6) <> round(NEW.unit_factor_to_base, 6) THEN
    IF NOT ('PURCHASE_UNIT_FACTOR_MISMATCH' = ANY(v_warnings)) THEN
      v_warnings := array_append(v_warnings, 'PURCHASE_UNIT_FACTOR_MISMATCH');
    END IF;
  ELSE
    v_warnings := array_remove(v_warnings, 'PURCHASE_UNIT_FACTOR_MISMATCH');
  END IF;

  NEW.warning_codes := v_warnings;
  RETURN NEW;
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.validate_purchase_cost_unit_snapshot() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION counting_private.validate_purchase_cost_unit_snapshot() TO authenticated, service_role;

DROP TRIGGER IF EXISTS count_import_rows_purchase_unit_guard ON public.count_import_rows;
CREATE TRIGGER count_import_rows_purchase_unit_guard
BEFORE INSERT OR UPDATE ON public.count_import_rows
FOR EACH ROW
EXECUTE FUNCTION counting_private.validate_purchase_cost_unit_snapshot();

DROP TRIGGER IF EXISTS count_session_product_costs_purchase_unit_guard ON public.count_session_product_costs;
CREATE TRIGGER count_session_product_costs_purchase_unit_guard
BEFORE INSERT OR UPDATE ON public.count_session_product_costs
FOR EACH ROW
EXECUTE FUNCTION counting_private.validate_purchase_cost_unit_snapshot();

COMMENT ON FUNCTION counting_private.validate_purchase_cost_unit_snapshot()
IS 'CountFlow: preserve purchase cost inputs but flag a purchase unit whose factor does not match the product base/alternate UoM. Used by import staging/commit and direct operation-cost writes.';
