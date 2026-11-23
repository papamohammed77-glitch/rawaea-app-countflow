-- A signed Storage download URL is temporary, not a durable catalog image reference.
CREATE OR REPLACE FUNCTION counting_private.is_valid_product_image_reference(
  p_project_id uuid,
  p_reference text,
  p_require_storage_object boolean DEFAULT false
)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_reference text;
  v_prefix text;
  v_filename text;
  v_host text;
BEGIN
  IF p_reference IS NULL OR p_reference = '' THEN RETURN true; END IF;
  IF p_project_id IS NULL THEN RETURN false; END IF;
  v_reference := btrim(p_reference);
  IF v_reference <> p_reference
     OR length(v_reference) > 2048
     OR v_reference ~ '[[:space:]]'
     OR strpos(v_reference, chr(92)) > 0 THEN RETURN false; END IF;

  IF v_reference ~* '^https://' THEN
    IF v_reference ~* '/storage/v1/object/sign/'
       OR v_reference ~* '[?&](token|expiresin)=' THEN RETURN false; END IF;
    v_host := split_part(split_part(split_part(v_reference, '/', 3), '?', 1), '#', 1);
    IF v_host = '' OR strpos(v_host, '@') > 0
       OR v_host !~ '^[A-Za-z0-9.-]+(:[0-9]{1,5})?$' THEN RETURN false; END IF;
    RETURN true;
  END IF;

  IF v_reference ~* '^[a-z][a-z0-9+.-]*://' THEN RETURN false; END IF;
  v_prefix := p_project_id::text || '/products/';
  IF left(v_reference, length(v_prefix)) <> v_prefix THEN RETURN false; END IF;
  v_filename := substr(v_reference, length(v_prefix) + 1);
  IF v_filename !~ '^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$' THEN RETURN false; END IF;
  IF NOT p_require_storage_object THEN RETURN true; END IF;

  RETURN EXISTS (
    SELECT 1 FROM storage.objects o
    WHERE o.bucket_id='counting-product-images'
      AND o.name=v_reference
      AND o.metadata->>'mimetype' IN ('image/jpeg','image/png')
      AND CASE
        WHEN coalesce(o.metadata->>'size','') ~ '^[0-9]+$'
          THEN (o.metadata->>'size')::bigint BETWEEN 1 AND 1048576
        ELSE false
      END
  );
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.is_valid_product_image_reference(uuid,text,boolean)
  FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION counting_private.is_valid_product_image_reference(uuid,text,boolean)
IS 'Validates durable CountFlow product image references: non-ephemeral HTTPS external URL or a safe same-project products object; optional object existence/type/size check.';
