-- CountFlow Control role: project-scoped read-only access for active auditors.
-- Scope: rawaea-staging CountFlow objects only. No business rows, memberships,
-- Auth identities, count entries, inventory balances, exports or accounting data are changed.
-- Owner display/audit records remain hidden from non-owner project users.

CREATE OR REPLACE FUNCTION counting_private.is_platform_owner_actor(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM auth.users u
    WHERE u.id = p_user_id
      AND lower(coalesce(u.email, '')) = 'owner@rawaea.com'
      AND u.email_confirmed_at IS NOT NULL
  );
$function$;

CREATE OR REPLACE FUNCTION counting_private.is_auditor(p_project uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.project_id = p_project
      AND m.user_id = (SELECT auth.uid())
      AND m.role = 'auditor'
      AND m.status = 'active'
  );
$function$;

REVOKE ALL ON FUNCTION counting_private.is_platform_owner_actor(uuid) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION counting_private.is_auditor(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION counting_private.is_platform_owner_actor(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION counting_private.is_auditor(uuid) TO authenticated;

-- Hide the platform owner's membership row from all non-owner users.
-- Auditors can see team identity/role/status, but no owner display name or username.
ALTER POLICY count_members_read ON public.count_members
USING (
  counting_private.is_platform_owner()
  OR (
    NOT counting_private.is_platform_owner_actor(user_id)
    AND (
      counting_private.is_supervisor(project_id)
      OR counting_private.is_auditor(project_id)
      OR user_id = (SELECT auth.uid())
    )
  )
);

-- Team allocation is visible to active supervisors and active auditors.
-- Counters retain their previous self-assignment visibility only.
ALTER POLICY count_assignments_read ON public.count_assignments
USING (
  counting_private.is_platform_owner()
  OR EXISTS (
    SELECT 1
    FROM public.count_sessions s
    JOIN public.count_members m
      ON m.id = count_assignments.member_id
     AND m.project_id = s.project_id
    WHERE s.id = count_assignments.session_id
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
      AND (
        counting_private.is_supervisor(s.project_id)
        OR counting_private.is_auditor(s.project_id)
        OR (m.user_id = (SELECT auth.uid()) AND m.status = 'active')
      )
  )
);

-- Supervisors and auditors can read project/session count events.
-- Counters keep access to their own events. Owner-created identity rows stay hidden.
ALTER POLICY count_entries_read ON public.count_entries
USING (
  counting_private.is_platform_owner()
  OR EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.id = count_entries.member_id
      AND m.project_id = count_entries.project_id
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
      AND (
        counting_private.is_supervisor(count_entries.project_id)
        OR counting_private.is_auditor(count_entries.project_id)
        OR m.user_id = (SELECT auth.uid())
      )
  )
);

-- Evidence read access follows the owning project. No upload/update/delete rights are added.
ALTER POLICY count_entry_images_read ON public.count_entry_images
USING (
  counting_private.is_platform_owner()
  OR (
    NOT counting_private.is_platform_owner_actor(uploaded_by)
    AND (
      uploaded_by = (SELECT auth.uid())
      OR counting_private.is_supervisor(project_id)
      OR counting_private.is_auditor(project_id)
    )
  )
);

ALTER POLICY count_devices_read ON public.count_devices
USING (
  counting_private.is_platform_owner()
  OR EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.id = count_devices.member_id
      AND m.project_id = count_devices.project_id
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
      AND (
        counting_private.is_supervisor(count_devices.project_id)
        OR counting_private.is_auditor(count_devices.project_id)
        OR m.user_id = (SELECT auth.uid())
      )
  )
);

ALTER POLICY count_presence_read ON public.count_presence
USING (
  counting_private.is_platform_owner()
  OR EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.id = count_presence.member_id
      AND m.project_id = count_presence.project_id
      AND NOT counting_private.is_platform_owner_actor(m.user_id)
      AND (
        counting_private.is_supervisor(count_presence.project_id)
        OR counting_private.is_auditor(count_presence.project_id)
        OR m.user_id = (SELECT auth.uid())
      )
  )
);

-- Presence is operational heartbeat data. Auditor/control remains strictly read-only.
ALTER POLICY count_presence_write_self_insert ON public.count_presence
WITH CHECK (
  counting_private.is_member(project_id)
  AND EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.id = count_presence.member_id
      AND m.project_id = count_presence.project_id
      AND m.user_id = (SELECT auth.uid())
      AND m.status = 'active'
      AND m.role IN ('supervisor','counter')
  )
);

ALTER POLICY count_presence_write_self_update ON public.count_presence
USING (
  counting_private.is_member(project_id)
  AND EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.id = count_presence.member_id
      AND m.project_id = count_presence.project_id
      AND m.user_id = (SELECT auth.uid())
      AND m.status = 'active'
      AND m.role IN ('supervisor','counter')
  )
)
WITH CHECK (
  counting_private.is_member(project_id)
  AND EXISTS (
    SELECT 1
    FROM public.count_members m
    WHERE m.id = count_presence.member_id
      AND m.project_id = count_presence.project_id
      AND m.user_id = (SELECT auth.uid())
      AND m.status = 'active'
      AND m.role IN ('supervisor','counter')
  )
);

ALTER POLICY count_alerts_read ON public.count_alerts
USING (
  counting_private.is_platform_owner()
  OR (
    (
      counting_private.is_supervisor(project_id)
      OR counting_private.is_auditor(project_id)
    )
    AND NOT counting_private.is_platform_owner_actor(acknowledged_by)
    AND NOT counting_private.is_platform_owner_actor(resolved_by)
  )
);

-- Preserve counter access to assigned recount work. Project supervisors/auditors
-- can monitor all non-owner-assigned recount tasks in their own project.
ALTER POLICY count_recount_tasks_read ON public.count_recount_tasks
USING (
  counting_private.is_platform_owner()
  OR (
    NOT EXISTS (
      SELECT 1
      FROM public.count_members m
      WHERE m.id = count_recount_tasks.assigned_member_id
        AND m.project_id = count_recount_tasks.project_id
        AND counting_private.is_platform_owner_actor(m.user_id)
    )
    AND (
      counting_private.is_supervisor(project_id)
      OR counting_private.is_auditor(project_id)
      OR counting_private.can_access_recount_task(project_id, assigned_member_id)
    )
  )
);

-- Owner administration/audit records are not visible in operational audit/export lists.
ALTER POLICY count_audit_read ON public.count_audit_log
USING (
  counting_private.is_platform_owner()
  OR (
    counting_private.is_supervisor(project_id)
    AND NOT counting_private.is_platform_owner_actor(actor_id)
  )
);

ALTER POLICY count_exports_read ON public.count_exports
USING (
  counting_private.is_platform_owner()
  OR (
    counting_private.is_supervisor(project_id)
    AND NOT counting_private.is_platform_owner_actor(requested_by)
  )
);

-- Private Realtime topics: auditors can join only project/session topics for
-- projects with an active auditor membership. The owner member topic stays owner-only.
CREATE OR REPLACE FUNCTION counting_private.can_access_countflow_topic(p_topic text)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_id uuid;
BEGIN
  IF p_topic ~ '^countflow:project:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' THEN
    v_id := split_part(p_topic,':',3)::uuid;
    RETURN counting_private.is_supervisor(v_id)
      OR counting_private.is_auditor(v_id);
  ELSIF p_topic ~ '^countflow:session:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' THEN
    v_id := split_part(p_topic,':',3)::uuid;
    RETURN EXISTS (
      SELECT 1
      FROM public.count_sessions s
      WHERE s.id = v_id
        AND (
          counting_private.is_supervisor(s.project_id)
          OR counting_private.is_auditor(s.project_id)
        )
    );
  ELSIF p_topic ~ '^countflow:member:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' THEN
    v_id := split_part(p_topic,':',3)::uuid;
    RETURN EXISTS (
      SELECT 1
      FROM public.count_members m
      WHERE m.id = v_id
        AND (
          counting_private.is_platform_owner()
          OR (
            NOT counting_private.is_platform_owner_actor(m.user_id)
            AND (
              (m.user_id = (SELECT auth.uid()) AND m.status IN ('active','paused'))
              OR counting_private.is_supervisor(m.project_id)
              OR counting_private.is_auditor(m.project_id)
            )
          )
        )
    );
  END IF;
  RETURN false;
END;
$function$;

-- Do not broadcast the platform-owner member row to the shared project topic.
-- Its private member topic remains readable only by the owner (see policy above).
CREATE OR REPLACE FUNCTION public.countflow_broadcast_changes()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  v_project_id uuid;
  v_session_id uuid;
  v_member_id uuid;
  v_topic text;
  m record;
BEGIN
  IF TG_TABLE_NAME='count_sessions' THEN
    v_project_id := coalesce(NEW.project_id,OLD.project_id);
    v_session_id := coalesce(NEW.id,OLD.id);
    v_topic := 'countflow:session:'||v_session_id::text;
    PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    PERFORM realtime.broadcast_changes(v_topic,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    FOR m IN SELECT id FROM public.count_members WHERE project_id=v_project_id AND status IN ('active','paused') LOOP
      PERFORM realtime.broadcast_changes('countflow:member:'||m.id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    END LOOP;
  ELSIF TG_TABLE_NAME='count_members' THEN
    v_project_id := coalesce(NEW.project_id,OLD.project_id);
    v_member_id := coalesce(NEW.id,OLD.id);
    IF NOT counting_private.is_platform_owner_actor(coalesce(NEW.user_id,OLD.user_id)) THEN
      PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    END IF;
    PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  ELSIF TG_TABLE_NAME='count_assignments' THEN
    SELECT project_id INTO v_project_id
    FROM public.count_sessions WHERE id=coalesce(NEW.session_id,OLD.session_id);
    v_member_id := coalesce(NEW.member_id,OLD.member_id);
    PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  ELSIF TG_TABLE_NAME='count_entry_images' THEN
    v_project_id := coalesce(NEW.project_id,OLD.project_id);
    SELECT session_id INTO v_session_id
    FROM public.count_entries WHERE id=coalesce(NEW.entry_id,OLD.entry_id);
    IF v_session_id IS NOT NULL THEN
      PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    END IF;
  ELSIF TG_TABLE_NAME='count_locations' THEN
    v_project_id := coalesce(NEW.project_id,OLD.project_id);
    PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_SCHEMA,NEW,OLD);
    FOR m IN SELECT id FROM public.count_members WHERE project_id=v_project_id AND status IN ('active','paused') LOOP
      PERFORM realtime.broadcast_changes('countflow:member:'||m.id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    END LOOP;
  ELSIF TG_TABLE_NAME='count_devices' THEN
    v_project_id := coalesce(NEW.project_id,OLD.project_id);
    v_member_id := coalesce(NEW.member_id,OLD.member_id);
    PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  ELSIF TG_TABLE_NAME='count_import_batches' THEN
    v_project_id := coalesce(NEW.project_id,OLD.project_id);
    PERFORM realtime.broadcast_changes('countflow:project:'||v_project_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
  ELSE
    v_session_id := coalesce(NEW.session_id,OLD.session_id);
    IF v_session_id IS NOT NULL THEN
      PERFORM realtime.broadcast_changes('countflow:session:'||v_session_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_TABLE_SCHEMA,NEW,OLD);
    END IF;
    IF TG_TABLE_NAME='count_recount_tasks' THEN
      v_member_id := coalesce(NEW.assigned_member_id,OLD.assigned_member_id);
      IF v_member_id IS NOT NULL THEN
        PERFORM realtime.broadcast_changes('countflow:member:'||v_member_id::text,TG_OP,TG_OP,TG_TABLE_NAME,TG_SCHEMA,NEW,OLD);
      END IF;
    END IF;
  END IF;
  RETURN NULL;
END;
$function$;
