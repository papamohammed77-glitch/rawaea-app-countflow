-- CountFlow import throughput: index the exact normalized predicates used
-- in stage/commit duplicate checks and per-row location code validation.
-- No data rows or business rules are changed.
CREATE INDEX IF NOT EXISTS count_import_rows_batch_sku_location_ci_idx
  ON public.count_import_rows
  USING btree (
    batch_id,
    lower(btrim(sku)),
    (nullif(btrim(location_code),''))
  )
  WHERE sku IS NOT NULL;

CREATE INDEX IF NOT EXISTS count_import_rows_batch_barcode_location_idx
  ON public.count_import_rows
  USING btree (
    batch_id,
    btrim(barcode),
    (nullif(btrim(location_code),''))
  )
  WHERE barcode IS NOT NULL;

CREATE INDEX IF NOT EXISTS count_locations_project_code_idx
  ON public.count_locations
  USING btree (project_id, code);

COMMENT ON INDEX public.count_import_rows_batch_sku_location_ci_idx IS
  'Supports normalized per-batch SKU duplicate checks in streamed import staging and commit.';
COMMENT ON INDEX public.count_import_rows_batch_barcode_location_idx IS
  'Supports normalized per-batch barcode duplicate checks in streamed import staging and commit.';
COMMENT ON INDEX public.count_locations_project_code_idx IS
  'Supports per-row project-scoped location code validation during large imports.';
