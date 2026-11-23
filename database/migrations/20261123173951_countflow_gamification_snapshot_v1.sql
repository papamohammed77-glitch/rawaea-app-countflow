-- LVE-763: server-derived CountFlow gamification snapshot.
-- No mutable points column is added to count_members. Points are derived from
-- distinct, persisted first-count product/location slots.

CREATE OR REPLACE FUNCTION counting_private.count_gamification_snapshot(p_session_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_user_id uuid := (SELECT auth.uid());
  v_session public.count_sessions;
  v_member public.count_members;
  v_has_assignments boolean := false;
  v_expected_slots bigint := 0;
  v_overall_completed bigint := 0;
  v_member_target bigint := 0;
  v_member_completed bigint := 0;
  v_member_items bigint := 0;
  v_member_points bigint := 0;
  v_member_rank bigint := NULL;
  v_leaderboard jsonb := '[]'::jsonb;
  v_badges jsonb := '[]'::jsonb;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'AUTH_REQUIRED';
  END IF;

  SELECT s.* INTO v_session
  FROM public.count_sessions s
  WHERE s.id = p_session_id
    AND s.status IN ('active','paused','review');

  IF NOT FOUND THEN
    RAISE EXCEPTION 'SESSION_NOT_AVAILABLE';
  END IF;

  SELECT m.* INTO v_member
  FROM public.count_members m
  WHERE m.project_id = v_session.project_id
    AND m.user_id = v_user_id
    AND m.role = 'counter'
    AND m.status = 'active'
  LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'COUNTER_MEMBERSHIP_REQUIRED';
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM public.count_assignments a
    WHERE a.session_id = p_session_id
  ) INTO v_has_assignments;

  WITH expected_slots AS MATERIALIZED (
    SELECT eb.id, eb.product_id, eb.location_id
    FROM public.count_expected_balances eb
    WHERE eb.session_id = p_session_id
  ),
  first_count_slots AS MATERIALIZED (
    SELECT DISTINCT e.member_id, e.product_id, e.location_id
    FROM public.count_entries e
    WHERE e.session_id = p_session_id
      AND e.recount_task_id IS NULL
      AND e.count_round = 1
      AND e.revision = 1
  )
  SELECT
    (SELECT count(*) FROM expected_slots),
    (SELECT count(*)
       FROM expected_slots eb
      WHERE EXISTS (
        SELECT 1
        FROM first_count_slots fc
        WHERE fc.product_id = eb.product_id
          AND fc.location_id IS NOT DISTINCT FROM eb.location_id
      ))
  INTO v_expected_slots, v_overall_completed;

  WITH expected_slots AS MATERIALIZED (
    SELECT eb.id, eb.product_id, eb.location_id
    FROM public.count_expected_balances eb
    WHERE eb.session_id = p_session_id
  ),
  first_count_slots AS MATERIALIZED (
    SELECT DISTINCT e.member_id, e.product_id, e.location_id
    FROM public.count_entries e
    WHERE e.session_id = p_session_id
      AND e.recount_task_id IS NULL
      AND e.count_round = 1
      AND e.revision = 1
  )
  SELECT
    count(*) FILTER (
      WHERE NOT v_has_assignments
         OR EXISTS (
           SELECT 1
           FROM public.count_assignments a
           WHERE a.session_id = p_session_id
             AND a.member_id = v_member.id
             AND a.status IN ('assigned','active')
             AND (a.location_id IS NULL OR a.location_id IS NOT DISTINCT FROM eb.location_id)
         )
    ),
    count(*) FILTER (
      WHERE (NOT v_has_assignments
         OR EXISTS (
           SELECT 1
           FROM public.count_assignments a
           WHERE a.session_id = p_session_id
             AND a.member_id = v_member.id
             AND a.status IN ('assigned','active')
             AND (a.location_id IS NULL OR a.location_id IS NOT DISTINCT FROM eb.location_id)
         ))
        AND EXISTS (
          SELECT 1
          FROM first_count_slots fc
          WHERE fc.member_id = v_member.id
            AND fc.product_id = eb.product_id
            AND fc.location_id IS NOT DISTINCT FROM eb.location_id
        )
    )
  INTO v_member_target, v_member_completed
  FROM expected_slots eb;

  WITH first_count_slots AS MATERIALIZED (
    SELECT DISTINCT e.product_id, e.location_id
    FROM public.count_entries e
    WHERE e.session_id = p_session_id
      AND e.member_id = v_member.id
      AND e.recount_task_id IS NULL
      AND e.count_round = 1
      AND e.revision = 1
  )
  SELECT count(*) INTO v_member_items
  FROM first_count_slots;

  v_member_points := v_member_items * 10;

  WITH expected_slots AS MATERIALIZED (
    SELECT eb.id, eb.product_id, eb.location_id
    FROM public.count_expected_balances eb
    WHERE eb.session_id = p_session_id
  ),
  first_count_slots AS MATERIALIZED (
    SELECT DISTINCT e.member_id, e.product_id, e.location_id
    FROM public.count_entries e
    WHERE e.session_id = p_session_id
      AND e.recount_task_id IS NULL
      AND e.count_round = 1
      AND e.revision = 1
  ),
  participants AS (
    SELECT m.id, m.display_name
    FROM public.count_members m
    WHERE m.project_id = v_session.project_id
      AND m.role = 'counter'
      AND m.status = 'active'
      AND (
        m.id = v_member.id
        OR NOT v_has_assignments
        OR EXISTS (
          SELECT 1
          FROM public.count_assignments a
          WHERE a.session_id = p_session_id
            AND a.member_id = m.id
            AND a.status IN ('assigned','active')
        )
        OR EXISTS (
          SELECT 1
          FROM first_count_slots fc
          WHERE fc.member_id = m.id
        )
      )
  ),
  scored AS (
    SELECT
      p.id,
      p.display_name,
      COALESCE(items.item_count,0)::bigint AS item_count,
      COALESCE(targets.target_count,0)::bigint AS target_count,
      COALESCE(completed.completed_count,0)::bigint AS completed_count
    FROM participants p
    LEFT JOIN LATERAL (
      SELECT count(*)::bigint AS item_count
      FROM first_count_slots fc
      WHERE fc.member_id = p.id
    ) items ON true
    LEFT JOIN LATERAL (
      SELECT count(*)::bigint AS target_count
      FROM expected_slots eb
      WHERE NOT v_has_assignments
         OR EXISTS (
           SELECT 1
           FROM public.count_assignments a
           WHERE a.session_id = p_session_id
             AND a.member_id = p.id
             AND a.status IN ('assigned','active')
             AND (a.location_id IS NULL OR a.location_id IS NOT DISTINCT FROM eb.location_id)
         )
    ) targets ON true
    LEFT JOIN LATERAL (
      SELECT count(*)::bigint AS completed_count
      FROM expected_slots eb
      WHERE (NOT v_has_assignments
         OR EXISTS (
           SELECT 1
           FROM public.count_assignments a
           WHERE a.session_id = p_session_id
             AND a.member_id = p.id
             AND a.status IN ('assigned','active')
             AND (a.location_id IS NULL OR a.location_id IS NOT DISTINCT FROM eb.location_id)
         ))
        AND EXISTS (
          SELECT 1
          FROM first_count_slots fc
          WHERE fc.member_id = p.id
            AND fc.product_id = eb.product_id
            AND fc.location_id IS NOT DISTINCT FROM eb.location_id
        )
    ) completed ON true
  ),
  ranked AS (
    SELECT
      s.*,
      s.item_count * 10 AS points,
      CASE WHEN s.target_count > 0
        THEN round((s.completed_count::numeric * 100) / s.target_count,1)
        ELSE NULL
      END AS progress_percent,
      row_number() OVER (
        ORDER BY
          CASE WHEN s.target_count > 0
            THEN s.completed_count::numeric / s.target_count
            ELSE NULL
          END DESC NULLS LAST,
          s.item_count DESC,
          s.completed_count DESC,
          s.display_name ASC,
          s.id ASC
      ) AS position
    FROM scored s
  )
  SELECT
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'position',r.position,
          'display_name',r.display_name,
          'points',r.points,
          'counted_items',r.item_count,
          'completed_slots',r.completed_count,
          'target_slots',r.target_count,
          'progress_percent',r.progress_percent,
          'is_me',(r.id = v_member.id)
        )
        ORDER BY r.position
      ) FILTER (WHERE r.position <= 10 OR r.id = v_member.id),
      '[]'::jsonb
    ),
    max(r.position) FILTER (WHERE r.id = v_member.id)
  INTO v_leaderboard, v_member_rank
  FROM ranked r;

  v_badges := jsonb_build_array(
    jsonb_build_object(
      'id','first_10',
      'title','انطلاقة قوية',
      'description','إتمام عد 10 أصناف/مواقع فريدة',
      'earned',(v_member_items >= 10)
    ),
    jsonb_build_object(
      'id','first_50',
      'title','مندوب نشيط',
      'description','إتمام عد 50 صنفًا/موقعًا فريدًا',
      'earned',(v_member_items >= 50)
    ),
    jsonb_build_object(
      'id','first_100',
      'title','خبير الجرد',
      'description','إتمام عد 100 صنف/موقع فريد',
      'earned',(v_member_items >= 100)
    ),
    jsonb_build_object(
      'id','scope_complete',
      'title','أكملت نطاقك',
      'description','إتمام جميع الأصناف/المواقع المسندة إليك',
      'earned',(v_member_target > 0 AND v_member_completed >= v_member_target)
    )
  );

  RETURN jsonb_build_object(
    'session_id',p_session_id,
    'member',jsonb_build_object(
      'display_name',v_member.display_name,
      'points',v_member_points,
      'counted_items',v_member_items,
      'completed_slots',v_member_completed,
      'target_slots',v_member_target,
      'progress_percent',CASE WHEN v_member_target > 0
        THEN round((v_member_completed::numeric * 100) / v_member_target,1)
        ELSE NULL
      END,
      'position',v_member_rank
    ),
    'overall',jsonb_build_object(
      'completed_slots',v_overall_completed,
      'target_slots',v_expected_slots,
      'progress_percent',CASE WHEN v_expected_slots > 0
        THEN round((v_overall_completed::numeric * 100) / v_expected_slots,1)
        ELSE NULL
      END
    ),
    'badges',v_badges,
    'leaderboard',v_leaderboard,
    'scoring',jsonb_build_object(
      'points_per_unique_slot',10,
      'basis','unique first-count product/location slots; recounts and duplicate scans do not add points'
    )
  );
END;
$function$;

REVOKE ALL ON FUNCTION counting_private.count_gamification_snapshot(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION counting_private.count_gamification_snapshot(uuid) FROM anon;
GRANT EXECUTE ON FUNCTION counting_private.count_gamification_snapshot(uuid) TO authenticated;

CREATE OR REPLACE FUNCTION public.count_get_gamification_snapshot(p_session_id uuid)
RETURNS jsonb
LANGUAGE sql
SECURITY INVOKER
SET search_path TO ''
AS $function$
  SELECT counting_private.count_gamification_snapshot(p_session_id);
$function$;

REVOKE ALL ON FUNCTION public.count_get_gamification_snapshot(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.count_get_gamification_snapshot(uuid) FROM anon;
GRANT EXECUTE ON FUNCTION public.count_get_gamification_snapshot(uuid) TO authenticated;

COMMENT ON FUNCTION counting_private.count_gamification_snapshot(uuid)
IS 'Returns only server-derived CountFlow gamification aggregates to the active counter who belongs to the requested session. Points are based on distinct persisted first-count product/location slots; no points column is writable by clients.';

COMMENT ON FUNCTION public.count_get_gamification_snapshot(uuid)
IS 'Authenticated CountFlow RPC wrapper for the session-scoped, server-derived gamification snapshot.';
