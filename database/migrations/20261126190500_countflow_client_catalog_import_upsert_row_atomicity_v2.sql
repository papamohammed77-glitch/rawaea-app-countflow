CREATE OR REPLACE FUNCTION public.count_upsert_client_catalog_chunk(
  p_client_id uuid,
  p_rows jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_actor uuid := (SELECT auth.uid());
  v_row jsonb;
  v_row_number integer;
  v_sku text;
  v_barcode text;
  v_name text;
  v_brand text;
  v_category text;
  v_base_unit text;
  v_units jsonb;
  v_client_sku text;
  v_client_barcode text;
  v_client_name text;
  v_client_category text;
  v_client_base_unit text;
  v_client_units jsonb;
  v_matches uuid[];
  v_product_id uuid;
  v_catalog public.count_catalog_products;
  v_mapping_id uuid;
  v_mapping_exists boolean;
  v_catalog_was_inserted boolean;
  v_barcode_matches_alt_uom boolean;
  v_lock_key text;
  v_error text;
  v_errors jsonb := '[]'::jsonb;
  v_seen_products uuid[] := ARRAY[]::uuid[];
  v_processed integer := 0;
  v_catalog_inserted integer := 0;
  v_catalog_matched integer := 0;
  v_client_inserted integer := 0;
  v_client_updated integer := 0;
  v_duplicates integer := 0;
  v_rejected integer := 0;
BEGIN
  IF v_actor IS NULL OR NOT counting_private.is_platform_owner() THEN
    RAISE EXCEPTION 'PLATFORM_OWNER_REQUIRED';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.count_clients c
    WHERE c.id = p_client_id
      AND c.status = 'active'
  ) THEN
    RAISE EXCEPTION 'CLIENT_NOT_FOUND_OR_INACTIVE';
  END IF;

  IF p_rows IS NULL
     OR jsonb_typeof(p_rows) <> 'array'
     OR jsonb_array_length(p_rows) < 1
     OR jsonb_array_length(p_rows) > 500 THEN
    RAISE EXCEPTION 'CLIENT_CATALOG_IMPORT_CHUNK_MUST_CONTAIN_1_TO_500_ROWS';
  END IF;

  FOR v_row IN
    SELECT value
    FROM jsonb_array_elements(p_rows) AS rows(value)
  LOOP
    v_processed := v_processed + 1;
    v_error := NULL;
    v_row_number := 0;
    v_catalog_was_inserted := false;

    IF jsonb_typeof(v_row) = 'object'
       AND (v_row->>'_row_number') ~ '^[0-9]+$' THEN
      v_row_number := (v_row->>'_row_number')::integer;
    END IF;

    v_sku := nullif(btrim(coalesce(v_row->>'canonical_sku', v_row->>'sku')), '');
    v_barcode := nullif(btrim(v_row->>'barcode'), '');
    v_name := nullif(btrim(v_row->>'name'), '');
    v_brand := nullif(btrim(v_row->>'brand'), '');
    v_category := nullif(btrim(v_row->>'category'), '');
    v_base_unit := nullif(btrim(v_row->>'base_unit'), '');
    v_units := CASE
      WHEN jsonb_typeof(v_row->'units') = 'array' THEN v_row->'units'
      ELSE '[]'::jsonb
    END;

    v_client_sku := nullif(btrim(v_row->>'client_sku'), '');
    v_client_barcode := nullif(btrim(v_row->>'client_barcode'), '');
    v_client_name := nullif(btrim(coalesce(v_row->>'client_name_override', v_row->>'client_name')), '');
    v_client_category := nullif(btrim(coalesce(v_row->>'client_category_override', v_row->>'client_category')), '');
    v_client_base_unit := nullif(btrim(coalesce(v_row->>'client_base_unit_override', v_row->>'client_base_unit')), '');
    v_client_units := CASE
      WHEN jsonb_typeof(v_row->'client_units_override') = 'array' THEN v_row->'client_units_override'
      WHEN jsonb_typeof(v_row->'client_units') = 'array' THEN v_row->'client_units'
      ELSE NULL
    END;

    BEGIN
      IF jsonb_typeof(v_row) <> 'object' THEN
        RAISE EXCEPTION 'INVALID_ROW_SHAPE';
      END IF;
      IF v_name IS NOT NULL AND length(v_name) > 240 THEN
        RAISE EXCEPTION 'PRODUCT_NAME_TOO_LONG';
      END IF;
      IF v_brand IS NOT NULL AND length(v_brand) > 120 THEN
        RAISE EXCEPTION 'PRODUCT_BRAND_TOO_LONG';
      END IF;
      IF v_category IS NOT NULL AND length(v_category) > 120 THEN
        RAISE EXCEPTION 'PRODUCT_CATEGORY_TOO_LONG';
      END IF;
      IF v_sku IS NOT NULL AND length(v_sku) > 100 THEN
        RAISE EXCEPTION 'PRODUCT_SKU_TOO_LONG';
      END IF;
      IF v_barcode IS NOT NULL AND length(v_barcode) > 120 THEN
        RAISE EXCEPTION 'PRODUCT_BARCODE_TOO_LONG';
      END IF;
      IF v_base_unit IS NOT NULL AND length(v_base_unit) > 40 THEN
        RAISE EXCEPTION 'PRODUCT_BASE_UNIT_TOO_LONG';
      END IF;
      IF v_client_sku IS NOT NULL AND length(v_client_sku) > 100 THEN
        RAISE EXCEPTION 'CLIENT_SKU_TOO_LONG';
      END IF;
      IF v_client_barcode IS NOT NULL AND length(v_client_barcode) > 120 THEN
        RAISE EXCEPTION 'CLIENT_BARCODE_TOO_LONG';
      END IF;
      IF v_client_units IS NOT NULL AND jsonb_typeof(v_client_units) <> 'array' THEN
        RAISE EXCEPTION 'CLIENT_UNITS_OVERRIDE_MUST_BE_ARRAY';
      END IF;
      IF v_client_units IS NOT NULL AND v_client_base_unit IS NULL THEN
        v_client_base_unit := v_base_unit;
      END IF;
      IF v_client_base_unit IS NOT NULL AND v_client_units IS NULL THEN
        v_client_units := '[]'::jsonb;
      END IF;

      -- Serialize concurrent imports of the same SKU, primary barcode, local identifiers,
      -- or alternate-UoM barcode before resolving the canonical product.
      FOR v_lock_key IN
        SELECT DISTINCT lock_key
        FROM (
          SELECT 'catalog-sku:' || lower(v_sku) AS lock_key WHERE v_sku IS NOT NULL
          UNION ALL
          SELECT 'catalog-barcode:' || lower(v_barcode) WHERE v_barcode IS NOT NULL
          UNION ALL
          SELECT 'client-sku:' || p_client_id::text || ':' || lower(v_client_sku) WHERE v_client_sku IS NOT NULL
          UNION ALL
          SELECT 'client-barcode:' || p_client_id::text || ':' || lower(v_client_barcode) WHERE v_client_barcode IS NOT NULL
          UNION ALL
          SELECT 'catalog-uom-barcode:' || lower(btrim(u.value->>'barcode'))
          FROM jsonb_array_elements(v_units) AS u(value)
          WHERE nullif(btrim(u.value->>'barcode'), '') IS NOT NULL
        ) lock_keys
        ORDER BY lock_key
      LOOP
        PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(v_lock_key, 0));
      END LOOP;

      -- Resolve by canonical SKU, primary barcode, known catalog identifiers,
      -- alternate-unit barcodes, or an existing institution-specific identifier.
      SELECT array_agg(DISTINCT candidate.product_id ORDER BY candidate.product_id)
      INTO v_matches
      FROM (
        SELECT p.id AS product_id
        FROM public.count_catalog_products p
        WHERE
          (v_sku IS NOT NULL AND lower(btrim(coalesce(p.canonical_sku, ''))) = lower(v_sku))
          OR (v_barcode IS NOT NULL AND lower(btrim(coalesce(p.barcode, ''))) = lower(v_barcode))
          OR (v_barcode IS NOT NULL AND EXISTS (
            SELECT 1
            FROM jsonb_array_elements(coalesce(p.units, '[]'::jsonb)) AS u(value)
            WHERE lower(btrim(coalesce(u.value->>'barcode', ''))) = lower(v_barcode)
          ))
        UNION
        SELECT i.catalog_product_id AS product_id
        FROM public.count_catalog_product_identifiers i
        WHERE
          (v_sku IS NOT NULL AND lower(btrim(coalesce(i.normalized_value, i.identifier_value))) = lower(v_sku))
          OR (v_barcode IS NOT NULL AND lower(btrim(coalesce(i.normalized_value, i.identifier_value))) = lower(v_barcode))
        UNION
        SELECT cp.catalog_product_id AS product_id
        FROM public.count_client_products cp
        WHERE cp.client_id = p_client_id
          AND (
            (v_client_sku IS NOT NULL AND lower(btrim(coalesce(cp.client_sku, ''))) = lower(v_client_sku))
            OR (v_client_barcode IS NOT NULL AND lower(btrim(coalesce(cp.client_barcode, ''))) = lower(v_client_barcode))
          )
      ) candidate;

      IF coalesce(array_length(v_matches, 1), 0) > 1 THEN
        RAISE EXCEPTION 'PRODUCT_IDENTITY_MATCHES_MULTIPLE_CATALOG_ROWS';
      END IF;

      IF coalesce(array_length(v_matches, 1), 0) = 1 THEN
        v_product_id := v_matches[1];
        SELECT * INTO v_catalog
        FROM public.count_catalog_products p
        WHERE p.id = v_product_id
        FOR UPDATE;

        IF NOT FOUND THEN
          RAISE EXCEPTION 'CATALOG_PRODUCT_NOT_FOUND';
        END IF;
        IF NOT v_catalog.is_active THEN
          RAISE EXCEPTION 'CATALOG_PRODUCT_INACTIVE';
        END IF;


        -- If the client file uses a different value than the global identity,
        -- preserve it as a client override rather than mutating the global master.
        IF v_client_sku IS NULL
           AND v_sku IS NOT NULL
           AND lower(v_sku) <> lower(coalesce(v_catalog.canonical_sku, '')) THEN
          v_client_sku := v_sku;
        END IF;

        IF v_client_barcode IS NULL AND v_barcode IS NOT NULL THEN
          v_barcode_matches_alt_uom := EXISTS (
            SELECT 1
            FROM jsonb_array_elements(coalesce(v_catalog.units, '[]'::jsonb)) AS u(value)
            WHERE lower(btrim(coalesce(u.value->>'barcode', ''))) = lower(v_barcode)
          );
          IF lower(v_barcode) <> lower(coalesce(v_catalog.barcode, ''))
             AND NOT v_barcode_matches_alt_uom THEN
            v_client_barcode := v_barcode;
          END IF;
        END IF;

        IF v_client_name IS NULL
           AND v_name IS NOT NULL
           AND v_name IS DISTINCT FROM v_catalog.name THEN
          v_client_name := v_name;
        END IF;
        IF v_client_category IS NULL
           AND v_category IS NOT NULL
           AND v_category IS DISTINCT FROM v_catalog.category THEN
          v_client_category := v_category;
        END IF;
        IF v_client_base_unit IS NULL
           AND v_base_unit IS NOT NULL
           AND v_base_unit IS DISTINCT FROM v_catalog.base_unit THEN
          v_client_base_unit := v_base_unit;
          v_client_units := coalesce(v_client_units, v_units, '[]'::jsonb);
        END IF;
      ELSE
        -- No existing identity: only this owner-authorized path may create the global master.
        IF v_name IS NULL THEN
          RAISE EXCEPTION 'PRODUCT_NAME_REQUIRED_FOR_NEW_MASTER';
        END IF;
        IF v_base_unit IS NULL THEN
          RAISE EXCEPTION 'PRODUCT_BASE_UNIT_REQUIRED_FOR_NEW_MASTER';
        END IF;

        INSERT INTO public.count_catalog_products (
          canonical_sku,
          barcode,
          name,
          brand,
          category,
          base_unit,
          units,
          source_type,
          is_active,
          created_by,
          updated_by
        )
        VALUES (
          v_sku,
          v_barcode,
          v_name,
          v_brand,
          v_category,
          v_base_unit,
          v_units,
          'verified_import',
          true,
          v_actor,
          v_actor
        )
        RETURNING id INTO v_product_id;

        SELECT * INTO v_catalog
        FROM public.count_catalog_products p
        WHERE p.id = v_product_id;
        v_catalog_was_inserted := true;
      END IF;

      -- Repeated rows that resolve to the same canonical product within this chunk
      -- are counted as duplicates and ignored; the browser also deduplicates across chunks.
      IF v_product_id = ANY(v_seen_products) THEN
        v_duplicates := v_duplicates + 1;
        CONTINUE;
      END IF;
      PERFORM pg_catalog.pg_advisory_xact_lock(
        pg_catalog.hashtextextended('client-product:' || p_client_id::text || ':' || v_product_id::text, 0)
      );

      SELECT cp.id INTO v_mapping_id
      FROM public.count_client_products cp
      WHERE cp.client_id = p_client_id
        AND cp.catalog_product_id = v_product_id
      FOR UPDATE;
      v_mapping_exists := FOUND;

      INSERT INTO public.count_client_products (
        client_id,
        catalog_product_id,
        client_sku,
        client_barcode,
        name_override,
        category_override,
        base_unit_override,
        units_override,
        is_active,
        created_by,
        updated_by
      )
      VALUES (
        p_client_id,
        v_product_id,
        v_client_sku,
        v_client_barcode,
        v_client_name,
        v_client_category,
        v_client_base_unit,
        v_client_units,
        true,
        v_actor,
        v_actor
      )
      ON CONFLICT (client_id, catalog_product_id) DO UPDATE SET
        client_sku = coalesce(EXCLUDED.client_sku, count_client_products.client_sku),
        client_barcode = coalesce(EXCLUDED.client_barcode, count_client_products.client_barcode),
        name_override = coalesce(EXCLUDED.name_override, count_client_products.name_override),
        category_override = coalesce(EXCLUDED.category_override, count_client_products.category_override),
        base_unit_override = coalesce(EXCLUDED.base_unit_override, count_client_products.base_unit_override),
        units_override = coalesce(EXCLUDED.units_override, count_client_products.units_override),
        updated_by = v_actor,
        updated_at = now();

      IF v_mapping_exists THEN
        v_client_updated := v_client_updated + 1;
      ELSE
        v_client_inserted := v_client_inserted + 1;
      END IF;
      v_seen_products := array_append(v_seen_products, v_product_id);
      IF v_catalog_was_inserted THEN
        v_catalog_inserted := v_catalog_inserted + 1;
      ELSE
        v_catalog_matched := v_catalog_matched + 1;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      GET STACKED DIAGNOSTICS v_error = MESSAGE_TEXT;
      v_rejected := v_rejected + 1;
      IF jsonb_array_length(v_errors) < 30 THEN
        v_errors := v_errors || jsonb_build_array(jsonb_build_object(
          'row_number', v_row_number,
          'sku', coalesce(v_sku, ''),
          'barcode', coalesce(v_barcode, ''),
          'error', v_error
        ));
      END IF;
    END;
  END LOOP;

  RETURN jsonb_build_object(
    'processed', v_processed,
    'catalog_inserted', v_catalog_inserted,
    'catalog_matched', v_catalog_matched,
    'client_inserted', v_client_inserted,
    'client_updated', v_client_updated,
    'duplicates', v_duplicates,
    'rejected', v_rejected,
    'errors', v_errors
  );
END;
$function$;


REVOKE ALL ON FUNCTION public.count_upsert_client_catalog_chunk(uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.count_upsert_client_catalog_chunk(uuid, jsonb) TO authenticated;

COMMENT ON FUNCTION public.count_upsert_client_catalog_chunk(uuid, jsonb)
IS 'Owner-only, bounded client catalog import v2. Counters and within-chunk duplicate tracking are committed only after the client overlay upsert succeeds; matched global masters remain immutable.';
