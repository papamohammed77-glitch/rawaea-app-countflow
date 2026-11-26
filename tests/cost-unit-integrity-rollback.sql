-- CountFlow QA-only transactional regression for LVE-791.
-- All writes below are rolled back; this file must never be run without QA_ identities.
BEGIN;

DO $test$
DECLARE
  v_project_id uuid := '10ade334-e211-4a32-a0bd-41f7bf41eb1d';
  v_session_id uuid := 'd435854f-1646-4549-9c12-2936f74a4052';
  v_batch_id uuid := 'f799c5c1-b766-4712-b74f-c0bb19836ddc';
  v_product_id uuid;
  v_import_row_id bigint;
  v_original record;
  v_cost_id uuid;
  v_warnings text[];
BEGIN
  SELECT id INTO STRICT v_product_id
  FROM public.count_products
  WHERE project_id=v_project_id AND sku='QA90K-000001'
    AND base_unit='each' AND is_active;

  INSERT INTO public.count_session_product_costs(
    project_id,session_id,product_id,purchase_unit_cost,currency_code,
    purchase_unit,unit_factor_to_base,source_type,source_reference,warning_codes
  ) VALUES (
    v_project_id,v_session_id,v_product_id,12.50,'EGP',
    'QA_INVALID_PURCHASE_UNIT',12,'QA_TEST','QA_LVE791_COST_UNIT_GUARD',ARRAY[]::text[]
  ) RETURNING id,warning_codes INTO v_cost_id,v_warnings;

  IF NOT ('PURCHASE_UNIT_FACTOR_MISMATCH'=ANY(v_warnings)) THEN
    RAISE EXCEPTION 'COST_TABLE_MISMATCH_WARNING_NOT_ADDED';
  END IF;

  UPDATE public.count_session_product_costs
  SET purchase_unit='each',unit_factor_to_base=1
  WHERE id=v_cost_id
  RETURNING warning_codes INTO v_warnings;

  IF 'PURCHASE_UNIT_FACTOR_MISMATCH'=ANY(v_warnings) THEN
    RAISE EXCEPTION 'COST_TABLE_MISMATCH_WARNING_NOT_CLEARED';
  END IF;

  SELECT id,purchase_unit_cost,currency_code,purchase_unit,unit_factor_to_base,
         cost_source_type,cost_source_reference,cost_source_date,warning_codes
  INTO STRICT v_import_row_id,v_original
  FROM public.count_import_rows
  WHERE batch_id=v_batch_id AND row_status='committed'
    AND product_id=v_product_id
  ORDER BY row_number
  LIMIT 1;

  UPDATE public.count_import_rows
  SET purchase_unit_cost=12.50,currency_code='EGP',
      purchase_unit='QA_INVALID_PURCHASE_UNIT',unit_factor_to_base=12,
      cost_source_type='QA_TEST',cost_source_reference='QA_LVE791_COST_UNIT_GUARD'
  WHERE id=v_import_row_id
  RETURNING warning_codes INTO v_warnings;

  IF NOT ('PURCHASE_UNIT_FACTOR_MISMATCH'=ANY(v_warnings)) THEN
    RAISE EXCEPTION 'IMPORT_ROW_MISMATCH_WARNING_NOT_ADDED';
  END IF;

  UPDATE public.count_import_rows
  SET purchase_unit='each',unit_factor_to_base=1
  WHERE id=v_import_row_id
  RETURNING warning_codes INTO v_warnings;

  IF 'PURCHASE_UNIT_FACTOR_MISMATCH'=ANY(v_warnings) THEN
    RAISE EXCEPTION 'IMPORT_ROW_MISMATCH_WARNING_NOT_CLEARED';
  END IF;
END;
$test$;

ROLLBACK;
