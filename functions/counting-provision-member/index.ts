import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const reply = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

type RoleRecord = {
  id: string;
  role_key: string;
  name: string;
  scope: "client" | "project";
  client_id: string | null;
  is_system: boolean;
  is_active: boolean;
};

async function findAuthUserByEmail(admin: any, normalizedEmail: string) {
  const perPage = 1000;
  const maxPages = 50;
  for (let page = 1; page <= maxPages; page++) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage });
    if (error) throw new Error("AUTH_USER_LOOKUP_FAILED: " + error.message);
    const users = data?.users || [];
    const matches = users.filter((u: any) =>
      String(u.email || "").trim().toLowerCase() === normalizedEmail
    );
    if (matches.length > 1) throw new Error("DUPLICATE_AUTH_EMAIL_IDENTITIES");
    if (matches.length === 1) return matches[0];
    if (users.length < perPage) return null;
  }
  throw new Error("AUTH_USER_LOOKUP_LIMIT_REACHED");
}

async function callerPermission(caller: any, rpcName: string, args: Record<string, unknown>) {
  const { data, error } = await caller.rpc(rpcName, args);
  if (error) throw new Error("PERMISSION_CHECK_FAILED: " + error.message);
  return data === true;
}

async function ensureAuthIdentity(admin: any, email: string, password: string, displayName: string) {
  let authUser = await findAuthUserByEmail(admin, email);
  let accountCreated = false;
  let accountReused = false;

  if (authUser) {
    if (!authUser.email_confirmed_at) {
      throw new Error("ACCOUNT_EXISTS_UNCONFIRMED");
    }
    accountReused = true;
  } else {
    if (password.length < 10) throw new Error("PASSWORD_REQUIRED_FOR_NEW_ACCOUNT");
    const { data: created, error } = await admin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { counting_display_name: displayName },
    });
    if (error || !created.user) throw new Error(error?.message || "USER_CREATE_FAILED");
    authUser = created.user;
    accountCreated = true;
  }
  return { authUser, accountCreated, accountReused };
}

async function cleanupNewIdentity(admin: any, userId: string, accountCreated: boolean) {
  if (!accountCreated) return;
  const { error } = await admin.auth.admin.deleteUser(userId);
  if (error) console.error("New Auth identity cleanup failed", error);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return reply({ error: "METHOD_NOT_ALLOWED" }, 405);

  try {
    const url = Deno.env.get("SUPABASE_URL");
    const anon = Deno.env.get("SUPABASE_ANON_KEY");
    const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!url || !anon || !service) return reply({ error: "SERVER_CONFIGURATION_MISSING" }, 500);

    const authHeader = req.headers.get("Authorization") || "";
    if (!authHeader.startsWith("Bearer ")) return reply({ error: "UNAUTHORIZED" }, 401);
    const caller = createClient(url, anon, {
      global: { headers: { Authorization: authHeader } },
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data: authData, error: authError } = await caller.auth.getUser();
    if (authError || !authData.user) return reply({ error: "UNAUTHORIZED" }, 401);

    const admin = createClient(url, service, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const body = await req.json();
    const action = String(body.action || "create");
    const email = String(body.email || "").trim().toLowerCase();
    const password = String(body.password || "");
    const displayName = String(body.display_name || "").trim();
    const username = String(body.username || email).trim();
    const isPlatformOwner =
      String(authData.user.email || "").trim().toLowerCase() === "owner@rawaea.com" &&
      Boolean(authData.user.email_confirmed_at);

    if (email === "owner@rawaea.com" && action !== "reset_password") {
      return reply({ error: "PLATFORM_OWNER_IDENTITY_CANNOT_BE_ADDED_AS_A_MEMBER" }, 409);
    }

    if (action === "reset_password") {
      const memberId = String(body.member_id || "");
      const newPassword = String(body.new_password || "");
      const memberType = String(body.member_type || "project");
      if (!memberId || newPassword.length < 10) return reply({ error: "INVALID_INPUT" }, 400);

      if (memberType === "client") {
        const clientId = String(body.client_id || "");
        if (!clientId || !isPlatformOwner) return reply({ error: "PLATFORM_OWNER_REQUIRED" }, 403);
        const { data: target, error } = await admin.from("count_client_members")
          .select("id,user_id,role_id,display_name")
          .eq("client_id", clientId).eq("id", memberId).maybeSingle();
        if (error || !target) return reply({ error: "CLIENT_MEMBER_NOT_FOUND" }, 404);
        const { error: updateError } = await admin.auth.admin.updateUserById(target.user_id, { password: newPassword });
        if (updateError) return reply({ error: updateError.message }, 400);
        const { error: auditError } = await admin.from("count_client_audit_log").insert({
          client_id: clientId, actor_id: authData.user.id, action: "client_admin.password_reset",
          entity_type: "client_member", entity_id: target.id, details: { role_id: target.role_id },
        });
        return reply({ ok: true, action, member_id: target.id, audit_warning: auditError?.message || null });
      }

      if (memberType !== "project") return reply({ error: "INVALID_MEMBER_TYPE" }, 400);
      const projectId = String(body.project_id || "");
      if (!projectId) return reply({ error: "INVALID_INPUT" }, 400);
      if (!isPlatformOwner && !(await callerPermission(caller, "count_can_manage_project_members", { p_project_id: projectId }))) {
        return reply({ error: "TEAM_MANAGE_PERMISSION_REQUIRED" }, 403);
      }
      const { data: target, error: targetError } = await admin.from("count_members")
        .select("id,user_id,role,display_name").eq("project_id", projectId).eq("id", memberId).maybeSingle();
      if (targetError || !target) return reply({ error: "MEMBER_NOT_FOUND" }, 404);
      const { error: updateError } = await admin.auth.admin.updateUserById(target.user_id, { password: newPassword });
      if (updateError) return reply({ error: updateError.message }, 400);
      const { error: auditError } = await admin.from("count_audit_log").insert({
        project_id: projectId, actor_id: authData.user.id, action: "member.password_reset",
        entity_type: "member", entity_id: target.id, details: { role: target.role },
      });
      return reply({ ok: true, action, member_id: target.id, audit_warning: auditError?.message || null });
    }

    if (action === "create_client_admin") {
      if (!isPlatformOwner) return reply({ error: "PLATFORM_OWNER_REQUIRED" }, 403);
      const clientId = String(body.client_id || "");
      if (!clientId || !email || !displayName || !username) return reply({ error: "INVALID_INPUT" }, 400);
      const roleIdInput = String(body.role_id || "");
      const { data: client, error: clientError } = await admin.from("count_clients")
        .select("id,status,name").eq("id", clientId).maybeSingle();
      if (clientError || !client || client.status !== "active") return reply({ error: "CLIENT_NOT_FOUND_OR_INACTIVE" }, 404);

      let roleQuery = admin.from("count_roles")
        .select("id,role_key,name,scope,client_id,is_system,is_active")
        .eq("scope", "client").eq("is_active", true);
      roleQuery = roleIdInput
        ? roleQuery.eq("id", roleIdInput)
        : roleQuery.eq("role_key", "client_admin").eq("is_system", true);
      const { data: role, error: roleError } = await roleQuery.maybeSingle();
      if (roleError || !role || (role.client_id && role.client_id !== clientId)) {
        return reply({ error: "CLIENT_ADMIN_ROLE_NOT_FOUND" }, 400);
      }
      if (role.role_key !== "client_admin") {
        const { data: perms, error: permsError } = await admin.from("count_role_permissions")
          .select("permission_code").eq("role_id", role.id);
        if (permsError) return reply({ error: "ROLE_PERMISSION_LOOKUP_FAILED" }, 500);
        const codes = new Set((perms || []).map((x: any) => x.permission_code));
        if (!codes.has("client.members.manage") || !codes.has("project.create")) {
          return reply({ error: "ROLE_DOES_NOT_HAVE_CLIENT_ADMIN_CAPABILITIES" }, 400);
        }
      }

      const { authUser, accountCreated, accountReused } =
        await ensureAuthIdentity(admin, email, password, displayName);
      const { data: existing, error: lookupError } = await admin.from("count_client_members")
        .select("id,status,display_name,username")
        .eq("client_id", clientId).eq("user_id", authUser.id).maybeSingle();
      if (lookupError) {
        await cleanupNewIdentity(admin, authUser.id, accountCreated);
        return reply({ error: "CLIENT_MEMBERSHIP_LOOKUP_FAILED" }, 500);
      }
      if (existing) {
        if (existing.status !== "active") {
          await cleanupNewIdentity(admin, authUser.id, accountCreated);
          return reply({ error: "CLIENT_MEMBERSHIP_EXISTS_NOT_ACTIVE" }, 409);
        }
        const { error: auditError } = await admin.from("count_client_audit_log").insert({
          client_id: clientId, actor_id: authData.user.id, action: "client_admin.reused",
          entity_type: "client_member", entity_id: existing.id,
          details: { email, auth_identity_reused: true },
        });
        return reply({
          ok: true, user_id: authUser.id, member_id: existing.id,
          account_reused: true, membership_reused: true,
          existing_password_changed: false, audit_warning: auditError?.message || null,
        });
      }

      const { data: member, error: insertError } = await admin.from("count_client_members").insert({
        client_id: clientId, user_id: authUser.id, role_id: role.id,
        display_name: displayName, username, status: "active", created_by: authData.user.id,
      }).select("id").single();
      if (insertError || !member) {
        await cleanupNewIdentity(admin, authUser.id, accountCreated);
        return reply({ error: insertError?.message || "CLIENT_ADMIN_CREATE_FAILED" }, 409);
      }
      const { error: auditError } = await admin.from("count_client_audit_log").insert({
        client_id: clientId, actor_id: authData.user.id,
        action: accountReused ? "client_admin.attached_existing_auth" : "client_admin.created",
        entity_type: "client_member", entity_id: member.id,
        details: { email, username, role_key: role.role_key, account_reused: accountReused, password_initialized: accountCreated },
      });
      return reply({
        ok: true, user_id: authUser.id, member_id: member.id, username,
        role: role.role_key, account_reused: accountReused, membership_reused: false,
        existing_password_changed: false, password_initialized: accountCreated,
        audit_warning: auditError?.message || null,
      });
    }

    if (action !== "create") return reply({ error: "UNSUPPORTED_ACTION" }, 400);
    const projectId = String(body.project_id || "");
    if (!projectId || !email || !displayName || !username) return reply({ error: "INVALID_INPUT" }, 400);
    if (!isPlatformOwner && !(await callerPermission(caller, "count_can_manage_project_members", { p_project_id: projectId }))) {
      return reply({ error: "TEAM_MANAGE_PERMISSION_REQUIRED" }, 403);
    }

    const { data: project, error: projectError } = await admin.from("count_projects")
      .select("id,client_id").eq("id", projectId).maybeSingle();
    if (projectError || !project) return reply({ error: "PROJECT_NOT_FOUND" }, 404);

    const roleIdInput = String(body.role_id || "");
    const roleKeyInput = String(body.role || "counter");
    let roleQuery = admin.from("count_roles")
      .select("id,role_key,name,scope,client_id,is_system,is_active")
      .eq("scope", "project").eq("is_active", true);
    roleQuery = roleIdInput
      ? roleQuery.eq("id", roleIdInput)
      : roleQuery.eq("role_key", roleKeyInput).eq("client_id", "00000000-0000-0000-0000-000000000000");
    // System roles use a NULL client_id; query their key separately to avoid relying on implicit NULL filters.
    const { data: role, error: roleError } = roleIdInput
      ? await roleQuery.maybeSingle()
      : await admin.from("count_roles").select("id,role_key,name,scope,client_id,is_system,is_active")
          .eq("scope", "project").eq("role_key", roleKeyInput).eq("is_system", true).is("client_id", null).eq("is_active", true).maybeSingle();
    if (roleError || !role || (role.client_id && role.client_id !== project.client_id)) {
      return reply({ error: "PROJECT_ROLE_NOT_FOUND_OR_OUT_OF_SCOPE" }, 400);
    }
    if (role.role_key === "client_admin" || role.scope !== "project") {
      return reply({ error: "CLIENT_ADMIN_ROLE_CANNOT_BE_ASSIGNED_TO_PROJECT_TEAM" }, 400);
    }

    const { authUser, accountCreated, accountReused } =
      await ensureAuthIdentity(admin, email, password, displayName);
    const { data: existingMembership, error: membershipLookupError } = await admin.from("count_members")
      .select("id,role,role_id,status,display_name,username")
      .eq("project_id", projectId).eq("user_id", authUser.id).maybeSingle();
    if (membershipLookupError) {
      await cleanupNewIdentity(admin, authUser.id, accountCreated);
      return reply({ error: "MEMBERSHIP_LOOKUP_FAILED: " + membershipLookupError.message }, 500);
    }
    if (existingMembership) {
      if (existingMembership.status !== "active") {
        await cleanupNewIdentity(admin, authUser.id, accountCreated);
        return reply({
          error: "MEMBERSHIP_EXISTS_NOT_ACTIVE",
          membership_id: existingMembership.id,
          membership_status: existingMembership.status,
          message: "الحساب مرتبط بهذا التكليف بعضوية غير نشطة. لا نعيد تفعيلها تلقائياً؛ استخدم إدارة المستخدمين لاستئناف العضوية.",
        }, 409);
      }
      const { error: auditError } = await admin.from("count_audit_log").insert({
        project_id: projectId, actor_id: authData.user.id, action: "member.reused",
        entity_type: "member", entity_id: existingMembership.id,
        details: { email, username: existingMembership.username, role: existingMembership.role, auth_identity_reused: true },
      });
      return reply({
        ok: true, user_id: authUser.id, member_id: existingMembership.id,
        username: existingMembership.username, role: existingMembership.role,
        role_id: existingMembership.role_id,
        account_reused: true, membership_reused: true,
        existing_password_changed: false, audit_warning: auditError?.message || null,
      });
    }

    const memberRole = role.is_system ? role.role_key : "custom";
    const { data: memberRecord, error: insertError } = await admin.from("count_members").insert({
      project_id: projectId, user_id: authUser.id, display_name: displayName,
      username, role: memberRole, role_id: role.id, status: "active",
    }).select("id,role,role_id").single();
    if (insertError || !memberRecord) {
      await cleanupNewIdentity(admin, authUser.id, accountCreated);
      return reply({ error: insertError?.message || "MEMBERSHIP_CREATE_FAILED" }, 409);
    }
    const { error: auditError } = await admin.from("count_audit_log").insert({
      project_id: projectId, actor_id: authData.user.id,
      action: accountReused ? "member.attached_existing_auth" : "member.created",
      entity_type: "member", entity_id: memberRecord.id,
      details: {
        email, username, role: memberRecord.role, role_id: memberRecord.role_id,
        account_reused: accountReused, existing_password_changed: false, password_initialized: accountCreated,
      },
    });
    return reply({
      ok: true, user_id: authUser.id, member_id: memberRecord.id, username,
      role: memberRecord.role, role_id: memberRecord.role_id,
      account_reused: accountReused, membership_reused: false,
      existing_password_changed: false, password_initialized: accountCreated,
      audit_warning: auditError?.message || null,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";
    const known: Record<string, number> = {
      ACCOUNT_EXISTS_UNCONFIRMED: 409,
      PASSWORD_REQUIRED_FOR_NEW_ACCOUNT: 400,
      DUPLICATE_AUTH_EMAIL_IDENTITIES: 409,
      AUTH_USER_LOOKUP_LIMIT_REACHED: 503,
    };
    return reply({ error: message }, known[message] || 500);
  }
});
