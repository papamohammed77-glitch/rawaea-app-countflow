-- CountFlow import commit validates each staged row against prior committed
-- rows in the same batch. Partial expression indexes keep these normalized
-- duplicate checks selective as the batch grows to tens of thousands of rows.
CREATE INDEX IF NOT EXISTS count_import_rows_committed_batch_sku_location_ci_idx
  ON public.count_import_rows
  USING btree (batch_id, lower(btrim(sku)), (nullif(btrim(location_code),'')))
  WHERE sku IS NOT NULL AND row_status='committed';

CREATE INDEX IF NOT EXISTS count_import_rows_committed_batch_barcode_location_idx
  ON public.count_import_rows
  USING btree (batch_id, btrim(barcode), (nullif(btrim(location_code),'')))
  WHERE barcode IS NOT NULL AND row_status='committed';

COMMENT ON INDEX public.count_import_rows_committed_batch_sku_location_ci_idx IS
  'Accelerates CountFlow import commit duplicate checks against committed rows in the same batch.';
COMMENT ON INDEX public.count_import_rows_committed_batch_barcode_location_idx IS
  'Accelerates CountFlow import commit duplicate checks against committed barcode rows in the same batch.';
