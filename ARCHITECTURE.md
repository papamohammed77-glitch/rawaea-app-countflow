# CountFlow — Architecture & Operating Model

**Scope:** standalone repository `papamohammed77-glitch/rawaea-app-countflow`; application HTML, Core, Service Worker, Functions, SQL and tests are rooted in this repository.  
**Backend:** Supabase project `rawaea-staging` — `hfzznsiprnwkpayskzhu`.  
**Isolation rule:** Never connect CountFlow to SMART ERP (`fiilmooggumokxanwiyx`) or load RAWAEA's `companies/company-1/core.js`.

## 1. Engagement and concurrent-operation model

CountFlow is the inventory-counting service provider's internal operating system. Contracting organizations are temporary and variable engagements, **not a permanent customer master**.

The existing schema already supports this separation without adding another business table:

- **Engagement workspace = one `count_projects` row.** `count_projects.name` stores the contracting party name (e.g. Carrefour); `code` is the unique engagement reference. It is not a canonical customer record and the same company name may appear in many separate engagements.
- **Named count operation = one `count_sessions` row.** `count_sessions.name` stores the exact operation/task name (e.g. "جرد شهر يناير 2027 - كارفور فرع المعادي"). Each operation belongs to one engagement workspace. A workspace may contain multiple named operations over its lifecycle.
- **Workforce = `count_members` + `count_assignments`.** Membership is scoped to the engagement; an assignment binds a member to a specific operation and optionally to a location. Removing an assignment removes that member from that operation only. It does not delete the Auth account, engagement membership, historical count entries, or their audit trail.
- **Independent repeat contracts.** A second Carrefour count is created as a new engagement workspace with a new unique code; it must not reuse or merge the earlier engagement's catalog, sites, team assignments, expected balances, evidence, or count history.
- **Concurrent work.** Multiple operations across multiple engagement workspaces may be active concurrently. Each operation has its own team assignments, count entries, imports, reconciliation, exports and status history.

The first engagement/operation pair is created atomically by `public.count_create_engagement(p_client_name,p_engagement_code,p_operation_name)`. The database transaction inserts the engagement workspace and the first planned operation together; a failed second insert cannot leave an incomplete engagement. The RPC is SECURITY INVOKER, requires `auth.uid()`, and is executable by `authenticated` but not `anon`.

The master and supervisor applications both use that contract. A new operation added later within an existing engagement is a new `count_sessions` row; the operation register provides historical search, status/date filters, sorting, paging, detail preview, printing, and server-generated exports.

## 2. Owner identity and authority boundary

The platform owner identity is reserved as `owner@rawaea.com`. Global authority is server-enforced and never derived from browser metadata:

- `counting_private.is_platform_owner()` recognizes only the authenticated Supabase Auth identity whose email is exactly `owner@rawaea.com` and whose email has been confirmed.
- `counting_private.is_member(uuid)` and `counting_private.is_supervisor(uuid)` include this verified platform-owner check, so RLS continues to authorize access through the existing policy contracts for every CountFlow engagement.
- The server-side functions `counting-provision-member` and `counting-export-session` require the verified platform-owner identity. JWT validation remains enabled; a supervisor membership does not grant account provisioning or export authority.
- Public first-user sign-up was removed from the master login to prevent an arbitrary visitor from taking over initial ownership.
- **The Auth identity is confirmed present** in the read-only Supabase check on 2026-11-21: exactly one Auth user matches `owner@rawaea.com`, and its `email_confirmed_at` is non-NULL. This is an identity-existence check, not permission to expose or recreate its password. Do not assign one of the legacy Auth users by guess.

Only the verified platform owner can create a new engagement and its first operation through `count_create_engagement`. A supervisor cannot create engagements, provision accounts, or import/export; the supervisor application is limited to live monitoring and team/location assignment. The owner identity is the initial authority for every engagement.

## 3. Master dashboard and operation register

The CountFlow master dashboard provides:

- **Engagement directory:** create and select an independent count engagement using the contracting party name and unique engagement code. The initial named count operation is created in the same transaction.
- **Users:** aggregate CountFlow memberships visible to the platform owner, with each row showing the engagement. User provisioning remains scoped to the selected engagement.
- **Operation register:** one searchable historical register across owner-visible engagements. Filters include contracting-party/operation/code search, operation status, and creation-date range. Columns are sortable and results are paginated.
- **Operation detail:** open a specific operation to view its team, current KPIs, import batches, reconciliation result, and export archive; add an existing engagement member or create a new account and assign it to that operation; remove a member from that operation without deleting their account or engagement membership.
- **Import/export/print:** import CSV/XLSX item catalogs and session expected balances using the existing staged CountFlow import RPCs. XLSX/CSV result exports use the server-side `counting-export-session` pipeline. The printable preview presents reconciliation details; the server XLSX remains the complete export artifact.
- **History preservation:** completed operations remain available for review, preview and export. Historical operations cannot be reopened or have their team/import altered from the supervisor UI.
- **Live refresh:** `count_sessions` and `count_members` Postgres Changes events invalidate the dashboard snapshot; the UI re-fetches authoritative rows through RLS. A 30-second visible-page reconciliation remains the fallback.

The supervisor page is limited to live operational monitoring and scoped team participation: read-only member/device/presence visibility, assignment and removal of counter-to-session/location assignments, and live count/coverage observation. Engagement creation, account provisioning/password reset, catalog/location administration, import/export, session lifecycle, alert-rule mutation, reconciliation, recount generation/review, and approval remain in the owner-only Admin application.

## 4. RAWAEA architecture patterns adopted by principle, not by code

The reference implementation was inspected in:

- `companies/company-1/core.js`: `RW_Auth`, `RW_SW`, and `RW_Realtime`.
- `companies/company-1/sw.js` and `register-sw.js`.
- `companies/company-1/warehouse/picker.html` as an example PWA that uses Dexie/IndexedDB and loads the shared core.

Patterns worth adopting:

1. A single app-scoped Supabase client and a clear auth/session lifecycle.
2. A small shared application core with explicit modules and contracts.
3. Service Worker update coordination and deterministic versioning.
4. Static shell/asset caching separated from business data.
5. Realtime events are invalidation signals; consumers re-fetch authoritative rows under RLS.
6. Reconciliation after subscription, after reconnect, on visibility return, and periodically.
7. Offline mutations are persisted locally with unique operation IDs, then replayed idempotently through server-side RPCs.

Patterns that must **not** be copied verbatim:

- RAWAEA `core.js` contains a hard-coded Supabase URL/ref for SMART ERP. Importing it would violate CountFlow isolation.
- RAWAEA's employee/company profile and role model is not the CountFlow tenant/membership model.
- The RAWAEA Service Worker is not a data-sync engine. It keeps HTML/API/runtime network-backed, caches only approved static presentation assets, and does not cache authentication or business records.

CountFlow now has its own `countflow-core.js` and `countflow-sw.js`, configured only for the CountFlow Supabase project and CountFlow app paths. The core creates the CountFlow client, exposes a reusable Postgres Changes + reconciliation helper, reports connectivity, and registers the CountFlow Service Worker. All three CountFlow pages load this core; the master dashboard uses its Postgres Changes helper. The field and supervisor pages retain their existing domain-specific channel handlers for now.

## 5. Offline-first contract — current state and required completion

**Confirmed current behavior:** `countflow.html` stores count operations in native IndexedDB (`countflow-offline-v1`) with `client_event_id` as the key. Online replay uses `count_record_entry` or `count_record_recount_entry`, both designed around idempotent operation IDs.

**Current verified behavior and remaining gaps:**

- The CountFlow-only Service Worker precaches the app shells, Core, manifest, icon and approved CDN libraries; it uses network-first HTML with cached fallback, caches only static dependencies, and never caches Supabase Auth/REST/Storage/Edge responses. Build artifacts are restricted to the public allowlist. Real offline boot, browser restart and reconnect remain unverified.
- IndexedDB rows retain project/session/member/device identity and immutable client_event_id. Counter queue reports now send a deterministic SHA-256 digest of canonical payload fields (event/project/session/member/device/product/location/recount/quantity/unit/scan/note) plus pending row count to count_report_device_queue after queue changes, sync, presence heartbeat, reconnect and periodic refresh.
- The server stores pending_queue_count, pending_queue_digest, queue_reported_at and acknowledged_lifecycle_version. Lifecycle transitions advance sync_barrier_version; the current owner-only pause-first count_approve_reconciliation requires a paused session, latest computed reconciliation, unchanged entry snapshot, all imported products counted, reviewed recounts, resolved critical alerts and every device queue acknowledged at the current version. Final completion rechecks the device queue barrier in the lifecycle trigger.
- A queue that cannot be flushed is not silently deleted. The owner Admin view lists member/device, last presence, reported queue count, report timestamp and lifecycle acknowledgement. Only the verified owner can record a reasoned count_waive_device_queue action; the audit log preserves the count/digest and the UI warns that local operations may be lost.
- Integrity limitation: queue contents live in browser IndexedDB. The server enforces the reporting protocol and records the device's self-attested count/digest; it cannot independently inspect the browser's local database. Treat this as an audited device acknowledgement, not cryptographic proof that no local payload was omitted.
- Queue replay remains limited to an active session and uses idempotent count RPCs. Pending rows for paused/review sessions remain held locally until the session is resumed or the owner records an audited waiver. Retry remains scoped to exact project/member/device/current session.
- Supervisor cockpit has authoritative 30-second polling and a separate 10-second heatmap refresh fallback in addition to Broadcast invalidation.

**Remaining verification:**

1. OPEN: Real device offline boot, browser-termination recovery, offline entry, reconnect, duplicate replay and multi-device concurrency E2E.
2. OPEN: Authenticated Playwright tests for actual supervisor/counter credentials, membership and location assignments. No persistent member/project/product roster exists yet.
3. OPEN: Test the pause → queue acknowledgement → approval → review acknowledgement → completion path using approved disposable CountFlow fixtures after the governance gate is resolved.
4. Do not post inventory, cash or accounting transactions during these tests; CountFlow remains a counting/reconciliation service only.

## 6. Realtime contract

RAWAEA's `RW_Realtime` uses Postgres Changes subscriptions and a reconciliation callback. It does not treat the event payload as a trusted business snapshot. CountFlow's admin dashboard now follows that principle for project-scoped session/member events.

CountFlow field/supervisor apps still use their existing private Broadcast contracts in parts of the UI. Prior audit records include Broadcast delivery warnings in the hosted Realtime message path. Do not claim real-time delivery is proven until browser tests confirm it across two authenticated devices. Keep authoritative reads and polling reconciliation as a fallback; do not modify Supabase-managed `realtime.messages` partition internals manually.

## 7. Safety boundaries

- No CountFlow action posts inventory, accounting, cash or ERP transactions.
- No SMART ERP project ref, credentials, tables, RPCs, Edge Functions or domains are used.
- The legacy non-CountFlow objects in `rawaea-staging` remain outside scope and must not be changed as part of this work.
- Never expose a service-role key in a browser.
- Do not create persistent owner/staff identities or use legacy Auth users without a confirmed roster and explicit identity mapping.
- Keep QA data synthetic, CountFlow-only, rollbackable and residue-checked.

## 8. Historical verification status at LVE-740 (superseded by LVE-754)

- Admin JavaScript syntax: **PASS**.
- Master UI global member/session aggregation: **implemented; browser behavior UNKNOWN**.
- CountFlow Core and Service Worker syntax: **PASS**; build fixture publishes ten allowlisted files (four HTML entry points, four runtime/PWA assets, headers and build-info commit marker) and excludes private artifacts. Real offline boot remains **UNKNOWN**.
- Realtime table publication: **CONFIRMED** for `count_members` and `count_sessions`; live event delivery: **UNKNOWN**.
- Supabase schema/data: **unchanged by this UI update**.
- Owner Auth account: **CONFIRMED PRESENT / email confirmed** in read-only check 2026-11-21.
- Offline shell boot and safe close barrier: **OPEN / NOT IMPLEMENTED**.
- Cloudflare deployment/domain: **NOT DEPLOYED**.


## 9. LVE-2026-11-21-754 — verified continuation status

- Repository HEAD at this checkpoint: `5dcdf76a856d78f4f6268bcc0d1c9cd2f13e2f77`. The latest admin source implements bounded CSV step parsing and XLSX ZIP/XML streaming for both the catalog importer and the operation-level importer. The legacy binary XLS parser remains limited to 8 MB and is not described as streaming.
- Catalog reads use server-side pagination (100 rows per request) and a 30-row virtual window. Import staging uses the existing CountFlow RPC in groups of 1,000 rows; row validation/acceptance/rejection remains server-side. Original CSV record numbers are retained, including when blank or malformed records are skipped.
- GitHub quality gate run `44941236636` passed: unit/source checks, the synthetic 90,000-row XLSX parser test, allowlisted Pages build, and Playwright test discovery. The Playwright suite itself was not run against authenticated accounts.
- `counting-export-session` remains ACTIVE v14 with JWT enabled and deployed source digest `147a21d8389ca6f87c911352895aaa0e3ae56ef1f875cb147c3f455f0a34c788`, matching the tracked source. Its image and estimated-memory guards are implementation safeguards, not a measured 90k export/load benchmark. Pricing policy remains unapproved and `UNKNOWN`.
- Cloudflare Pages project `rawaea-app-countflow` is configured for Production with automatic deployments enabled at `https://rawaea-app-countflow.pages.dev`. The latest production revision visible during the read-only browser check was `195bbe8`; it predates repository HEAD above. Do not claim the new HEAD is live until the Cloudflare deployment record shows the matching commit.
- A read-only view of the production master page showed the authenticated owner identity and zero projects, products, members and sessions. A read-only Supabase query confirmed zero CountFlow projects, members, products, sessions, entries, import batches/rows, exports and expected balances; the single `owner@rawaea.com` identity is confirmed.
- Authenticated Playwright E2E, actual file upload and import against a project, runtime workbook/image inspection, export memory profiling, Cloudflare deployment parity, offline multi-device testing and 30–300 concurrent-user load remain unverified.

## 10. LVE-2026-11-21-755 — current security, queue and verification state

- The P1 owner-only/Counter-only boundary remains applied. Owner membership, device queue waiver, alert resolution, reconciliation approval and session lifecycle authority stay server-enforced. The Supervisor UI is monitoring/team assignment only, with a 30-second authoritative polling fallback.
- Fifteen CountFlow ledger entries were applied after the P1 migration by parallel project work. Their exact mapping, tracked source files, missing intermediate artifacts and current-schema observations are recorded in database/migrations/README.md. The queue barrier sources include a pause-first approval finality path; two intermediate two-phase migration ledger entries have no standalone source and must not be reconstructed/replayed.
- Live read-only SQL verification confirms authenticated-only queue/approval/waiver RPC ACLs, owner gate in privileged RPC bodies, search_path = empty, and self-scoped count_presence RLS. No CountFlow project/member/product/session/count/import/export/expected-balance rows existed at the LVE-755 read.
- The proposed 20261121212500_countflow_import_normalized_lookup_indexes.sql is NOT APPLIED; the three named indexes were absent in the live catalog. Do not treat this source file as a live performance optimization.
- The production Pages origin was verified by Playwright against exact main commit 5a86a3115b5624e30882dd497934f0e7260b6f18 on CI run 44943001441. Deno type-check, source/unit tests, Pages allowlist build, production commit parity and three Chromium smoke tests (owner login shell, exact SHA parity, three RTL mobile shells) passed. Authenticated supervisor/counter E2E, actual DB import, workbook/image export inspection, measured peak memory, real offline multi-device journeys and concurrency load remain OPEN.
- The streamed synthetic XLSX parser handles 90,000 generated rows in CI; this is not proof of a 90,000-row RPC import or 30–300 concurrent-user capacity. The SQL rollback load tests are source artifacts and were not executed in this checkpoint.
- Edge Functions remain counting-provision-member v7 and counting-export-session v14 with JWT verification enabled. Pricing policy remains UNKNOWN and is not an approved accounting valuation basis.
