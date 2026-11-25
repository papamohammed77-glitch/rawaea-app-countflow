
GRANT SELECT(client_id) ON public.count_projects TO authenticated;
GRANT SELECT,INSERT,UPDATE(
 operation_code,planned_start_at,planned_end_at,schedule_timezone,priority,
 counting_mode,show_expected_quantity,capture_images,require_images,
 allow_unknown_products,instructions,branch_location_id
) ON public.count_sessions TO authenticated;
GRANT SELECT(user_id) ON public.count_client_members TO authenticated;
GRANT SELECT(catalog_product_id,client_product_id) ON public.count_products TO authenticated;
