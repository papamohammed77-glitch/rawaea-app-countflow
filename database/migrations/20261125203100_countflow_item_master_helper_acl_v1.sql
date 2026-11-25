-- Keep internal barcode/UoM validation helpers private.
REVOKE ALL ON FUNCTION counting_private.gs1_check_digit(text) FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.is_valid_gtin(text) FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.resolve_item_barcode_type(text,text) FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.normalize_product_units(jsonb,text,text,text,text) FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.assert_unique_product_barcodes(text,uuid,uuid,text,jsonb) FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.validate_global_product_master() FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.validate_project_product_master() FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION counting_private.validate_client_product_units() FROM PUBLIC,anon,authenticated;

-- The count-entry trigger is SECURITY INVOKER and needs this pure helper at insert time.
REVOKE ALL ON FUNCTION counting_private.infer_item_unit_class(text) FROM PUBLIC,anon;
GRANT EXECUTE ON FUNCTION counting_private.infer_item_unit_class(text) TO authenticated;
