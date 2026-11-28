-- LVE-793 read-only verification. No QA fixtures or business rows are created or changed.
DO $$
DECLARE
  v_missing text[];
  v_bad_rls text[];
BEGIN
  WITH expected(index_name, table_name, columns) AS (
    VALUES
      ('idx_count_assignments_member_project_fk','count_assignments',ARRAY['member_id','project_id']::text[]),
      ('idx_count_assignments_session_project_fk','count_assignments',ARRAY['session_id','project_id']::text[]),
      ('idx_count_session_team_members_link_project_fk','count_session_team_members',ARRAY['session_team_id','project_id']::text[]),
      ('idx_count_session_team_members_member_project_fk','count_session_team_members',ARRAY['member_id','project_id']::text[]),
      ('idx_count_session_teams_assigned_by','count_session_teams',ARRAY['assigned_by']::text[]),
      ('idx_count_session_teams_session_project_fk','count_session_teams',ARRAY['session_id','project_id']::text[]),
      ('idx_count_session_teams_team_project_fk','count_session_teams',ARRAY['team_id','project_id']::text[]),
      ('idx_count_sessions_queue_barrier_run_id','count_sessions',ARRAY['queue_barrier_run_id']::text[]),
      ('idx_count_team_members_added_by','count_team_members',ARRAY['added_by']::text[]),
      ('idx_count_team_members_member_project_fk','count_team_members',ARRAY['member_id','project_id']::text[]),
      ('idx_count_team_members_team_project_fk','count_team_members',ARRAY['team_id','project_id']::text[]),
      ('idx_count_teams_created_by','count_teams',ARRAY['created_by']::text[])
  )
  SELECT array_agg(e.index_name ORDER BY e.index_name)
    INTO v_missing
  FROM expected e
  WHERE NOT EXISTS (
    SELECT 1
    FROM pg_class tbl
    JOIN pg_namespace ns ON ns.oid=tbl.relnamespace
    JOIN pg_index i ON i.indrelid=tbl.oid
    JOIN pg_class idx ON idx.oid=i.indexrelid
    WHERE ns.nspname='public'
      AND tbl.relname=e.table_name
      AND idx.relname=e.index_name
      AND i.indisvalid AND i.indisready
      AND i.indisunique = false
      AND i.indpred IS NULL
      AND i.indexprs IS NULL
      AND (SELECT array_agg(a.attname::text ORDER BY k.ord)
           FROM unnest(i.indkey::smallint[]) WITH ORDINALITY k(attnum,ord)
           JOIN pg_attribute a ON a.attrelid=tbl.oid AND a.attnum=k.attnum
           WHERE k.ord <= cardinality(e.columns)) = e.columns
  );

  IF v_missing IS NOT NULL THEN
    RAISE EXCEPTION 'COUNTFLOW_EXPECTED_INDEX_MISSING_OR_INVALID: %', array_to_string(v_missing, ', ');
  END IF;

  SELECT array_agg(t.relname ORDER BY t.relname)
    INTO v_bad_rls
  FROM pg_class t
  JOIN pg_namespace ns ON ns.oid=t.relnamespace
  WHERE ns.nspname='public'
    AND t.relkind='r'
    AND t.relname LIKE 'count\_%' ESCAPE '\'
    AND (
      NOT t.relrowsecurity
      OR NOT EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid=t.oid)
    );

  IF v_bad_rls IS NOT NULL THEN
    RAISE EXCEPTION 'COUNTFLOW_TABLE_WITHOUT_RLS_POLICY: %', array_to_string(v_bad_rls, ', ');
  END IF;
END
$$;

SELECT
  (SELECT count(*) FROM pg_class t JOIN pg_namespace ns ON ns.oid=t.relnamespace
   WHERE ns.nspname='public' AND t.relkind='r' AND t.relname LIKE 'count\_%' ESCAPE '\') AS countflow_tables,
  (SELECT count(*) FROM pg_class t JOIN pg_namespace ns ON ns.oid=t.relnamespace
   WHERE ns.nspname='public' AND t.relkind='r' AND t.relname LIKE 'count\_%' ESCAPE '\'
     AND t.relrowsecurity
     AND EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid=t.oid)) AS countflow_tables_with_rls_and_policy,
  12 AS expected_fk_indexes;
