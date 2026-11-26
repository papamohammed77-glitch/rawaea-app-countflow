# CountFlow database migrations

Live project: Supabase rawaea-staging (hfzznsiprnwkpayskzhu). Scope is CountFlow objects only.

## Selected SQL migration sources documented here (18 entries; 41 SQL files tracked at LVE-749)

1. 20261119190750_countflow_revoke_unsafe_anon_and_ddl_privileges.sql
2. 20261119191119_countflow_reconciliation_approved_recount_override_v1.sql
3. 20261119191232_countflow_unit_conversion_snapshots_and_effective_totals_v1.sql
4. 20261119191603_countflow_remove_exposed_security_definer_helpers.sql
5. 20261119191833_countflow_automatic_anomaly_alerts_v1.sql
6. 20261119191854_countflow_fix_repeat_alert_uuid_aggregate.sql
7. 20261119192509_countflow_approval_requires_all_positions_counted.sql
8. 20261119192958_countflow_live_kpi_and_alert_index_tuning_v1.sql
9. 20261119193513_countflow_assignments_nulls_not_distinct_unique_scope_v1.sql
10. 20261119193620_countflow_expected_balance_snapshot_guard_v1.sql
11. 20261119194632_countflow_admin_audit_triggers_v1.sql
12. 20261119194738_countflow_audit_skip_service_member_provision_v1.sql
13. 20261119195303_countflow_rpc_and_immutable_ledger_acl_hardening_v1.sql
14. 20261119195630_countflow_import_batch_sku_lookup_index_v1.sql
15. 20261120170000_countflow_platform_owner_verified_email.sql
16. 20261120171000_countflow_license_settings_unbounded_emails.sql
17. 20261120200000_countflow_atomic_engagement_and_operation_create.sql
18. 20261121145000_countflow_p1_owner_only_admin_and_counter_only.sql

## Live migration ledger reconciliation — 2026-11-19

Read-only comparison of the Supabase migration ledger against the current Git folder found:

- Latest read-only ledger query (2026-11-20): **56** applied `countflow_*` entries and **12** earlier `counting_*` entries, **68 combined CountFlow/Counting migration entries**.
- **41** SQL migration files are tracked in the repository tree as of 2026-11-21; the 18 entries above are a selected, non-exhaustive subset.
- The three new migration names are present in the live ledger. The connector generated live version timestamps `20261119232523`, `20261119232615`, and `20261120004422` for the named owner, license-settings and atomic-engagement migrations respectively; do not infer ledger version from the filename.
- **51** applied CountFlow/Counting ledger entries have no standalone one-to-one SQL source in the current Git folder. The previously recorded 7-foundation/60-total figure in the 2026-11-19 archive is retained as historical evidence but is superseded by this latest catalog query, which identifies 12 `counting_*` and 56 `countflow_*` names.
- The current folder is therefore NOT a complete replayable migration history or a clean-install baseline.

### Applied ledger entries without a standalone Git SQL artifact (39)

The missing entries are preserved below exactly as reported by the live ledger; do not recreate them from memory or reapply them blindly.

1. 20261119182050 countflow_enterprise_data_model_v1
2. 20261119182153 countflow_enterprise_security_storage_v1
3. 20261119182705 countflow_import_pipeline_v1
4. 20261119182926 countflow_import_pipeline_hardening_v1
5. 20261119183711 countflow_reconciliation_recount_presence_v1
6. 20261119183721 countflow_presence_rls_self_scope_fix
7. 20261119183927 countflow_import_image_and_presence_stream_v1
8. 20261119184026 countflow_fk_indexes_and_device_policy_consolidation
9. 20261119184103 countflow_import_uuid_location_lookup_fix
10. 20261119184201 countflow_kpis_and_anomaly_alert_engine_v1
11. 20261119184224 countflow_alerts_and_recount_realtime_publication
12. 20261119184230 countflow_import_image_reference_validation
13. 20261119184250 countflow_recount_entry_secure_rpc_v1
14. 20261119184532 countflow_recount_idempotency_retry_fix
15. 20261119184632 countflow_private_realtime_broadcast_architecture_v1
16. 20261119184706 countflow_recount_review_and_reconciliation_approval_v1
17. 20261119185002 countflow_evidence_owner_cleanup_policy
18. 20261119185027 countflow_session_project_broadcast_event
19. 20261119185123 countflow_import_mapping_relation_and_raw_source_preservation
20. 20261119185154 countflow_single_default_import_mapping_per_format
21. 20261119185210 countflow_all_location_assignment_uniqueness
22. 20261119185240 countflow_server_side_device_and_product_scope_enforcement
23. 20261119185300 countflow_assignment_scope_rls_and_enforcement
24. 20261119185320 countflow_device_realtime_broadcast
25. 20261119185755 countflow_member_data_isolation_and_audit_write_restriction
26. 20261119185811 countflow_evidence_storage_member_scope
27. 20261119185920 countflow_append_only_insert_policy_full_validation
28. 20261119185943 countflow_device_status_supervisor_only
29. 20261119190029 countflow_first_device_autoapproval_and_new_device_supervisor_gate
30. 20261119190037 countflow_persist_pending_device_registration
31. 20261119190249 countflow_fk_and_duplicate_index_advisor_fixes
32. 20261119190309 countflow_realtime_evidence_and_location_updates
33. 20261119190448 countflow_idempotent_retries_after_member_pause
34. 20261119192305 countflow_reconciliation_approval_freeze_v1
35. 20261119192405 countflow_atomic_reconciliation_freeze_watermark_v1
36. 20261119192409 countflow_approved_session_insert_error_order_fix
37. 20261119192427 countflow_count_entry_guard_definer_lock_fix
38. 20261119195107 countflow_location_hierarchy_guard_and_session_heatmap_v1
39. 20261119195202 countflow_session_heatmap_helper_contract_fix_v1

### Special mappings / caveats

- The four approval/freeze entries 19192305, 19192405, 19192409, and 19192427 are described in the existing migration documentation as consolidated into the final tracked contract 19192509. Their ledger entries still exist; the consolidated file is not proof that the original SQL text is preserved.
- The location hierarchy/heatmap migrations 19195107 and 19195202 are applied in Supabase but absent from Git. Their exact original SQL must be recovered from execution artifacts if available. Do not invent a replacement migration from the current catalog.
- The tracked source file 19195630_countflow_import_batch_sku_lookup_index_v1.sql corresponds by name to live ledger version 20261119195750. The index exists in the live catalog. Record this as timestamp mapping drift; do not rename or reapply without a reviewed lineage decision.
- The prior README listed only 12 files and stated 19194738 as latest. That statement was stale as of this audit.

## Safety rules

- Do not rerun these migrations blindly against a database with existing objects.
- Do not apply DDL, ACL, RLS, GRANT, REVOKE, or Edge deployment without a specific approved Change Set.
- Rollback tests must begin with BEGIN and finish with ROLLBACK; prove no residual CountFlow rows or Auth identities.
- CountFlow SQL must not write to ERP inventory, sales, treasury, customer/supplier ledgers, or accounting tables.
- No legacy ERP table/function/policy in rawaea-staging may be changed under this CountFlow scope.


## 2026-11-19 — live migration-ledger recovery

A read-only reconciliation against `supabase_migrations.schema_migrations` in `rawaea-staging` recovered the exact recorded SQL for all **60** migrations belonging to the CountFlow/Counting system: 7 earlier `counting_*` foundation rows plus 53 `countflow_*` rows.

- The current folder still contains 14 standalone SQL files. There are 46 applied ledger rows without a one-to-one standalone file (39 within the `countflow_*` set plus the 7 foundation rows).
- The exact applied statements are preserved in [COUNTFLOW_APPLIED_MIGRATION_LEDGER_ARCHIVE_20261119.md](../COUNTFLOW_APPLIED_MIGRATION_LEDGER_ARCHIVE_20261119.md).
- **The archive is evidence only. Do not apply or replay it.** The ledger has no rollback SQL recorded for these 60 rows.
- A whitespace/comment-insensitive SQL-token comparison found 4 of the 14 tracked files equivalent to their matching ledger statement; the other 10 require semantic reconciliation before anyone treats the tracked file as the exact applied source.
- `20261119195630_countflow_import_batch_sku_lookup_index_v1.sql` maps to live ledger version `20261119195750`; this is timestamp drift. `20261119192509_countflow_approval_requires_all_positions_counted.sql` is a consolidated source for incremental finality changes, not a one-to-one copy of a single ledger row.

Do not replay, rename, or rewrite any migration based only on its filename. Use the live schema and the archived applied statements as separate evidence sources.


## 2026-11-20 — CountFlow engagement and operation workflow additions

The following CountFlow-only migrations were applied and their source files committed:

- `20261120170000_countflow_platform_owner_verified_email.sql`: global owner identity gate bound to the confirmed Auth email `owner@rawaea.com`.
- `20261120171000_countflow_license_settings_unbounded_emails.sql`: owner-only license/contact email settings; no application-level list cap.
- `20261120200000_countflow_atomic_engagement_and_operation_create.sql`: SECURITY INVOKER RPC to atomically create the contracting-party engagement workspace and its first named count operation.

The latest function/ACL verification confirmed authenticated EXECUTE=true and anon EXECUTE=false for `public.count_create_engagement(text,text,text)`. No test engagement or Auth identity was created. These migrations do not touch ERP objects.


## 2026-11-21 — LVE-749 P1 owner-only administration and counter-only capture

Applied in `rawaea-staging` as `countflow_p1_owner_only_admin_and_counter_only`; source: `20261121145000_countflow_p1_owner_only_admin_and_counter_only.sql`.

- Verified project and engagement creation plus project bootstrap require the confirmed `owner@rawaea.com` platform identity.
- CountFlow Admin write policies previously allowing supervisors now require `counting_private.is_platform_owner()`; assignment, self-presence, audit and device workflow policies remain separately scoped.
- Product import RPCs and reconciliation/session lifecycle RPCs are owner-only.
- Direct entry INSERT, primary/recount RPCs and recount assignment require active `counter`; `auditor` cannot record counts.
- A non-owner denial probe ran within a transaction ending in `ROLLBACK`; no project, member or session rows were created.

Historical paragraphs below retain their original audit dates; earlier file counts are superseded by the 2026-11-21 Git tree count above.

## 2026-11-21 — LVE-755 queue-barrier and finality migration reconciliation

A further **read-only** reconciliation against the live migration ledger and CountFlow schema on `rawaea-staging` found 16 applied ledger entries after the P1 migration `20261121180246 countflow_p1_owner_only_admin_and_counter_only`. This addendum is an inventory only; it does not authorize replay.

### Live applied entries after P1

| Live ledger version | Live migration name | Tracked source / status |
|---|---|---|
| `20261121181642` | `countflow_import_row_level_location_validation` | No one-to-one SQL file found in current Git tree; recover exact SQL from ledger archive before any replay |
| `20261121184957` | `countflow_recount_generation_computed_counter_only` | Source `20261121195000_countflow_recount_generation_computed_counter_only.sql` (filename timestamp differs) |
| `20261121185757` | `countflow_session_device_queue_barrier` | Source `20261121202000_countflow_session_device_queue_barrier.sql` |
| `20261121185842` | `countflow_owner_helper_signature_fix` | Source `20261121201500_countflow_owner_helper_signature_fix.sql` |
| `20261121190030` | `countflow_queue_waiver_owner_helper_fix` | Source `20261121202500_countflow_queue_waiver_owner_helper_fix.sql` |
| `20261121190130` | `countflow_owner_alert_resolution` | Source `20261121203000_countflow_owner_alert_resolution.sql` |
| `20261121190239` | `countflow_device_queue_missing_presence_guard` | Source `20261121204000_countflow_device_queue_missing_presence_guard.sql` |
| `20261121190329` | `countflow_alert_status_rpc_null_and_idempotency` | Source `20261121203500_countflow_alert_status_rpc_null_and_idempotency.sql` |
| `20261121190455` | `countflow_approval_requires_paused_session` | Source `20261121204500_countflow_approval_requires_paused_session.sql` |
| `20261121190711` | `countflow_device_queue_waiver_audit_key_fix` | Source `20261121204500_countflow_device_queue_waiver_audit_key_fix.sql` |
| `20261121190914` | `countflow_queue_waiver_reject_clear_device` | Source `20261121205000_countflow_queue_waiver_reject_clear_device.sql` |
| `20261121191421` | `countflow_approval_rpc_security_definer_fix` | Source `20261121211000_countflow_approval_rpc_security_definer_fix.sql` |
| `20261121191944` | `countflow_two_phase_approval_queue_barrier` | No standalone source file found; historical/intermediate experimental ledger entry; do not reconstruct from memory |
| `20261121192051` | `countflow_two_phase_approval_security_definer` | No standalone source file found; historical/intermediate experimental ledger entry; do not reconstruct from memory |
| `20261121192512` | `countflow_restore_pause_first_queue_approval` | Source `20261121212000_countflow_restore_pause_first_queue_approval.sql`; final source contract is pause-first |
| `20261121194759` | `countflow_import_normalized_lookup_indexes` | Source `20261121212500_countflow_import_normalized_lookup_indexes.sql` (filename timestamp differs); all three live index definitions verified |

### Verified live behavior — read only

- The current `count_report_device_queue(uuid,text,integer,text)` RPC is SECURITY DEFINER, has an empty `search_path`, is executable by authenticated but not anon, and accepts only an active Counter membership plus its approved active device. It records pending queue count/digest and the current lifecycle version.
- The current `count_waive_device_queue(uuid,uuid,text,text)` RPC is SECURITY DEFINER, empty `search_path`, authenticated EXECUTE / anon denied, and checks the confirmed platform owner identity inside the body. It requires a documented reason and preserves count/digest details in the audit log.
- `count_approve_reconciliation(uuid)` is SECURITY DEFINER only so it can call the server-private queue assertion; it has an empty `search_path`, authenticated EXECUTE / anon denied, explicit owner gate, and requires a latest computed run with a paused session. It checks unchanged count snapshot, counted imported products, reviewed recounts, resolved critical alerts and device queue acknowledgements before approval.
- `count_generate_recount_tasks` requires a computed (not approved) reconciliation and assigns only to an active `counter`, never an `auditor`.
- `count_presence` RLS remains self-scoped for insert/update to the active authenticated member; read is limited to supervisor/owner scope or the row owner.
- The application `countflow.html` calls `count_report_device_queue` after queue changes/synchronization, after device presence heartbeat, on reconnect, and periodically. The owner-only system master renders each device queue and exposes the documented waiver action. Queue reporting is a device self-attestation: the server stores the reported digest and blocks finality until the device reports zero at the current lifecycle version or the owner records an explicit waiver; it cannot independently read browser IndexedDB.
- The current lifecycle trigger contains additive `queue_barrier_action`, `queue_barrier_run_id` and `queue_barrier_requested_at` columns from the experimental two-phase migrations. The final public approval RPC was restored to the pause-first contract by `countflow_restore_pause_first_queue_approval`; these columns remain additive historical schema. No destructive cleanup was attempted.

### Import lookup indexes — APPLIED AND VERIFIED

Tracked source: `20261121212500_countflow_import_normalized_lookup_indexes.sql`.

Live Supabase migration ledger entry:
- Version: `20261121194759`
- Name: `countflow_import_normalized_lookup_indexes`
- The filename timestamp differs from the migration ledger version; do not rename or replay it on that basis.

A read-only `pg_indexes` query confirmed all three definitions exist in `rawaea-staging` and match the tracked SQL expressions:

1. `count_import_rows_batch_sku_location_ci_idx` on `(batch_id, lower(btrim(sku)), nullif(btrim(location_code),'')) WHERE sku IS NOT NULL`.
2. `count_import_rows_batch_barcode_location_idx` on `(batch_id, btrim(barcode), nullif(btrim(location_code),'')) WHERE barcode IS NOT NULL`.
3. `count_locations_project_code_idx` on `(project_id, code)`.

The migration is therefore **APPLIED / source present / catalog definitions verified**. No reapplication or destructive index maintenance is required. Query-plan improvement and 5k/90k database throughput have not been measured; the presence of indexes alone is not a benchmark.

### Current tracked SQL source inventory

- Git tree at LVE-755 contains **54** `.sql` migration files.
- The latest live CountFlow/Counting ledger inventory includes the original 68 entries at the LVE-749 audit plus P1 and **16 post-P1** entries above. Four of the 16 entries have no standalone one-to-one SQL artifact (the import row-level location validation entry and two experimental two-phase entries; note the remaining timestamp/source mapping discrepancies). The repository is still not a clean-install/replayable baseline.
- No SQL test in `tests/` was executed during LVE-755. The 5k and 90k rollback scripts are source artifacts only; their existence is not proof of database/RPC performance.
- All current CountFlow business tables queried in the same read-only check remained at zero rows; the one confirmed `owner@rawaea.com` Auth identity remains present.

Do not replay, rename, delete, or reconstruct any of these migration entries based on filenames alone. Treat the live ledger, tracked SQL artifacts and current schema as separate evidence sets.

### Resumable large-import commit — APPLIED / read-only contract verified 2026-11-21

Tracked SQL sources:
- `20261121213000_countflow_import_commit_duplicate_lookup_indexes.sql`
- `20261121214000_countflow_import_commit_chunked_batches.sql`

Live Supabase migration ledger:
- `20261121200720` — `countflow_import_commit_duplicate_lookup_indexes`
- `20261121201407` — `countflow_import_commit_chunked_batches`

**Important:** Both live ledger versions differ from the timestamp prefixes of the tracked filenames. This is an existing source/ledger mapping, not a reason to rename or replay either file. Read-only queries on 2026-11-21 confirmed both ledger names, both duplicate-lookup indexes, and the live chunked function behavior. No migration was applied or re-applied by the LVE-757 continuation.

The active commit contract observed read-only:
- `public.count_commit_import_batch(uuid)` is a SQL wrapper with empty `search_path`; its EXECUTE ACL includes `authenticated`, `service_role` and `postgres`, not `anon`.
- `counting_private.count_commit_import_batch_impl(uuid)` is `SECURITY DEFINER`, checks the confirmed platform owner identity, and only accepts batches in `preview` or `committing` (with `committed` returning an idempotent success).
- At most 1,000 staged rows are selected with `ORDER BY row_number,id LIMIT 1000 FOR UPDATE` per RPC invocation.
- If staged rows remain, the function persists cumulative accepted/rejected counts and returns `status=committing` plus `remaining_rows`. It finalizes expected balances, cost snapshots, batch completion and audit only when no staged rows remain.
- A failed later chunk keeps an initially `committing` batch resumable; a failure in the first transition from `preview` leaves the batch failed.

The Admin UI now calls the same commit RPC sequentially from both catalog and operation imports. The history views expose **استكمال الاعتماد** for batches still in `committing`; a resumed request continues from the staged rows without uploading or parsing the original file again. The UI does not display raw batch IDs or RPC errors.

### 5k/90k rollback script limitation

- `tests/import_5k_rollback.sql` and `tests/import_90k_rollback.sql` now loop over the commit RPC until the server reports `committed`, with a bounded maximum of 100 additional calls and final row/product assertions.
- Each script still has one outer `BEGIN` and a final `ROLLBACK`. Repeated function invocations in this harness occur inside that single database transaction; therefore these scripts can test chunk selection, row-state transitions and final results, but **cannot prove independent HTTP transaction durability, recovery after a real network interruption, or production 90k throughput**.
- Neither script was executed in the LVE-757 continuation. The LVE-747 governance hold still blocks new database write tests until explicitly reconciled. Do not remove `ROLLBACK` or convert either script to a persistent seed.

Do not replay either import migration, rename files to force version matching, or infer live state from filenames. The Supabase ledger and read-only live function/index catalog are the authority for current applied state.


## 2026-11-21 — LVE-761 platform owner read and private image Storage

- `20261121220000_countflow_platform_owner_read_and_image_storage_access.sql` was applied to `rawaea-staging`; Supabase ledger version: `20261121205438`.
- The migration adds the confirmed platform-owner predicate to 22 CountFlow SELECT policies while preserving the existing member/supervisor/self access branches for all other identities.
- It also adds the canonical owner to the private product-image read/upload/update policies, still restricted to the `counting-product-images` bucket and existing CountFlow project paths.
- Post-apply verification identified an unqualified `name` reference resolving to `count_projects.name` inside a nested storage policy subquery. This was corrected by follow-up migration `20261121210000_countflow_storage_owner_path_qualifier_fix.sql`, ledger version `20261121205720`, explicitly using `storage.foldername(objects.name)`.
- Verified read-only: 22/22 owner-aware public read policies; all three image policies owner-aware and using `objects.name`; no bad `p.name` path reference; bucket remains private (`public=false`).
- No business data DML, Auth user changes, images uploaded/deleted, stock/finance/accounting changes, or field-app changes.
## 2026-11-23 — Product image reference hardening (LVE-764)

Live Supabase ledger entries:
- Version 20261123182553 — countflow_product_image_reference_hardening_v1
- Version 20261123182644 — countflow_reject_ephemeral_product_image_urls_v1

Tracked SQL sources:
- 20261123182553_countflow_product_image_reference_hardening_v1.sql
- 20261123182644_countflow_reject_ephemeral_product_image_urls_v1.sql

public.count_products.image_url already existed as nullable text; no duplicate column or data backfill was required. The counting-product-images bucket remains private. Its policies now allow only <project UUID>/products/<single filename> while preserving owner/supervisor/member role gates. The server validator accepts safe HTTPS references or same-project private product keys, rejects signed/temporary URLs, traversal and cross-folder references, and verifies committed Storage objects are JPEG/PNG and at most 1 MiB. Import staging validates path shape; import commit checks object existence. A trigger protects direct product writes and imports.

Read-only live verification:
- Valid project/products path accepted for staging; missing object rejected for commit.
- Wrong folder, traversal, HTTP/FTP, userinfo URLs and temporary signed Storage URLs rejected.
- Bucket remains public=false; zero Storage objects; zero products changed.
- No Storage metadata tables were written; file operations must use Storage API.

Open end-to-end gate: authenticated image upload, Admin thumbnail, Counter thumbnail and Client Balance XLSX embedded-image verification. The available browser connector is read-only and there is no Storage upload API action in the current tool set. Do not insert into storage.objects directly. Keep this phase open and do not merge/deploy until those E2E checks pass.

---

## 2026-11-25 — LVE-774: استعادة مصادر الترحيلات المطبقة إلى main

تمت قراءة سجل `supabase_migrations.schema_migrations` في `rawaea-staging` فقط، واستعادة 16 ملف SQL إلى `database/migrations/` بأرقام الإصدارات الفعلية المسجلة. نُقلت نصوص `statements[1]` كما أعادها السجل؛ جميعها تحوي statement واحدة و`rollback_count=0`.

- `20261123211241_countflow_shelf_image_camera_mvp_v1.sql`
- `20261123211841_countflow_shelf_image_integrity_and_cleanup_v1.sql`
- `20261124182140_countflow_auditor_read_only_control_scope_v1.sql`
- `20261124182507_countflow_auditor_evidence_read_v1.sql`
- `20261124183136_countflow_control_safe_reconciliation_views_and_owner_realtime_redaction_v1.sql`
- `20261124184201_countflow_hide_owner_actor_columns_from_clients_v1.sql`
- `20261124184611_countflow_hide_owner_actor_audit_columns_v1.sql`
- `20261124194925_countflow_rbac_custom_role_guard_and_operation_policy_fix_v1.sql`
- `20261124195207_countflow_catalog_image_isolation_control_view_rls_and_fk_indexes_v1.sql`
- `20261124195257_countflow_client_admin_isolation_audit_and_atomic_dynamic_permissions_v1.sql`
- `20261124200322_countflow_catalog_image_link_upsert_role_permission_and_admin_provision_fix_v1.sql`
- `20261124200430_countflow_dynamic_role_permissions_in_field_rpc_and_recount_v1.sql`
- `20261124200647_countflow_hide_platform_owner_activity_from_client_audit_v1.sql`
- `20261124201102_countflow_role_permission_rpc_column_least_privilege_fix_v1.sql`
- `20261124201132_countflow_client_product_upsert_narrow_definer_rpc_v2.sql`
- `20261124201230_countflow_new_tenant_operation_catalog_column_grants_v1.sql`

### ضوابط الاستعادة
- هذه الملفات توثق ترحيلات مطبقة بالفعل؛ لم تُنفذ خلال LVE-774 ولم يحدث أي DDL/DML أو تعديل صلاحيات.
- طوابع الخمسة ملفات الخاصة بـControl وRBAC أصبحت مطابقة لقيم `version` في سجل Supabase؛ تم تحديث مسارات الاختبار إلى الأسماء المعتمدة.
- ملف Camera integrity استُعيد من نص سجل Supabase الفعلي؛ كود واجهة الكاميرا لم يُنقل إلى صفحات main بسبب كون `shelf-images` عاماً، وبسبب بقاء اختبار التصوير المصادق مفتوحاً.
- لا تعِد تشغيل هذه الملفات على `rawaea-staging` أو أي بيئة. تحقق من سجل الإصدار قبل أي إجراء مستقبلي.
- هذه الاستعادة تغلق فجوة مصادر إصدارات 2026-11-23/24 المذكورة هنا، ولا تدّعي أن كل تاريخ CountFlow الأقدم صار baseline قابلاً لإعادة الإنشاء؛ الأرشيف التاريخي السابق يظل مرجعاً مستقلاً.


## 2026-11-26 — LVE-790: Client catalog import upsert and unit-of-measure parity

LVE-790 added a bounded owner-only batch RPC for importing an institution's item file into the unified CountFlow catalogue. The RPC resolves global identity by canonical SKU, primary barcode, registered catalog identifier, alternate-UoM barcode, or an existing institution-local identifier. A matched global product is never updated by this path. Missing global products are created through the existing global-master triggers and then linked to the selected client. Institution-specific differences are saved in `count_client_products`.

### Source SQL files and live ledger mappings

| Repository source file | Live Supabase migration version | Live ledger name |
|---|---:|---|
| `20261126190000_countflow_client_catalog_import_upsert_v1.sql` | `20261126185715` | `countflow_client_catalog_import_upsert_v1` |
| `20261126190500_countflow_client_catalog_import_upsert_row_atomicity_v2.sql` | `20261126185813` | `countflow_client_catalog_import_upsert_row_atomicity_v2` |
| `20261126191000_countflow_client_catalog_import_uom_override_v3.sql` | `20261126191110` | `countflow_client_catalog_import_uom_override_v3` |

The timestamps above intentionally distinguish the Git filename prefix from the version actually recorded by Supabase. Always use the live ledger version when referring to applied state; do not rename or replay these files to make timestamps match.

### RPC contract and safeguards

- RPC: `public.count_upsert_client_catalog_chunk(uuid,jsonb)`; accepts 1–500 rows per call.
- Runs with `SECURITY DEFINER` and an empty `search_path`; checks a non-null `auth.uid()`, `counting_private.is_platform_owner()`, and an active `count_clients` target before processing any row.
- Execute privilege: `authenticated` only; `PUBLIC` and `anon` are revoked. Anonymous execute was verified false; authenticated execute verified true. The platform-owner check is enforced inside the function and must not be removed.
- Advisory transaction locks serialize concurrent imports of SKU, barcode, alternate-unit barcode, and institution identifier keys before resolving the canonical product.
- If identity resolves to more than one global product, the row is rejected as ambiguous instead of guessing.
- Existing global rows remain immutable in this import path. Differences in name/category/SKU/barcode/base unit are expressed as client overlays where supported.
- Alternate-unit name, factor and barcode differences are compared semantically and stored in the client's `units_override` rather than replacing global `units`.
- New global products are inserted only after no existing identity match is found; a new master must have a name and base unit. Existing products may be linked with identity fields even when the institution file omits a repeated global base-unit value.
- Client overlay insert/update is atomic per row via `ON CONFLICT (client_id,catalog_product_id) DO UPDATE`. Duplicate counters and the per-chunk seen-product set are updated only after the overlay write succeeds.
- Result counters distinguish new global masters, matched global products, new client links, updated client links, duplicates ignored, and rejected rows.

### Data and operational boundary

- The import RPC writes only `count_catalog_products` and `count_client_products`; it does not write `count_products`, expected balances, count entries, reconciliation, costs, or inventory ledgers.
- No import RPC was called during LVE-790. No client records, catalog rows, mappings, operational test data, or QA90K rows were created or modified.
- Latest read-only check during LVE-790 found 0 rows in `count_catalog_products`, 0 in `count_client_products`, 41,000 in `count_products`, 0 in `count_entries`, and 0 clients (0 active clients). Consequently the client-import workflow is implemented and its database contract/security verified, but a real customer-file import could not be end-to-end exercised without an active client and an approved business file.
- The CountFlow counter's existing `count_record_entry` and recount RPC contracts accept the selected unit name; the installed `count_entries` trigger snapshots `unit_factor_to_base` and `base_quantity`. The browser must send the entered quantity in its selected unit and must not multiply it by the conversion factor.


### Follow-up source verification and operational attachment — 2026-11-26

Two additional CountFlow-only migrations were applied after source review of the complete flow from client import to the field counter:

| Repository source file | Live Supabase migration version | Live ledger name |
|---|---:|---|
| `20261126191500_countflow_client_import_identity_alias_resolution_v4.sql` | `20261126194742` | `countflow_client_import_identity_alias_resolution_v4` |
| `20261126192000_countflow_catalog_attach_open_session_guard_v1.sql` | `20261126194745` | `countflow_catalog_attach_open_session_guard_v1` |

- **Identity alias resolution (v4):** If the file maps its SKU/barcode to a client-specific column, the server also checks those values against global canonical SKU, primary barcode, alternate-UoM barcode and registered catalog identifiers before creating a new master. Advisory locks cover the same alias keys. The client values remain local overrides when they do not equal the global identity.
- **Project attachment:** Existing RPC `public.count_attach_catalog_product(project_id,client_product_id,expected_qty)` is the only supported bridge from the client catalogue into the project-scoped `count_products` read by the field counter. It copies the effective local/global name, SKU/barcode, base unit and units JSONB. It retains the existing client/project scope and permission checks.
- **Open-session guard:** The existing private implementation `counting_private.count_attach_catalog_product_impl` now locks the project row and rejects catalogue attachment while a project session is `active`, `paused`, or `review`. The public wrapper and its existing ACL remain unchanged. The Admin UI also hides/disables the action outside a matching client scope and while an open session is shown.
- The Admin passes `p_expected_qty: null`. Linking a catalogue item therefore does not create a reference balance; it is not an inventory movement or a count entry.
- The field counter's unit selector now displays the barcode alongside each alternative unit and its `factor_to_base`. The scanned unit name, raw entered quantity and scanned barcode are sent to the existing record-entry RPC. The browser does not multiply the quantity.
- This attachment action is available only when the selected client equals the selected project's `client_id`, and an active `count_client_products` row exists. Projects without a client scope (the current live project has none) will not show the action.

A fresh read-only schema/function/grant check confirmed the two migrations are in the live ledger, both import and attachment public RPCs remain executable by `authenticated` and not `anon`, and the import RPC retains its internal platform-owner gate. Do not expose the private implementation as a new public RPC.


### LVE-790 source-review hardening — live ledger 2026-11-26

| Repository source file | Live Supabase migration version | Live ledger name |
|---|---:|---|
| `20261126191500_countflow_client_import_identity_alias_resolution_v4.sql` | `20261126194742` | `countflow_client_import_identity_alias_resolution_v4` |
| `20261126192000_countflow_catalog_attach_open_session_guard_v1.sql` | `20261126194745` | `countflow_catalog_attach_open_session_guard_v1` |

- The v4 import resolver matches both canonical and client-mapped SKU/barcode values against global canonical SKU, primary barcode, alternate-UoM barcode and registered catalogue identifiers before deciding to create a master. Advisory transaction locks cover the same identity aliases.
- The attachment guard changes only the existing private implementation `counting_private.count_attach_catalog_product_impl(uuid,uuid,numeric)`. It locks the project row, checks permissions and matching active client mapping, then rejects attachment while any project session is `active`, `paused`, or `review`. The public invoker wrapper and its ACL are unchanged.
- The Admin uses the existing public `count_attach_catalog_product(uuid,uuid,numeric)` RPC, only for a matching selected client/project and an active mapping; it passes `p_expected_qty=null`. No manual insert into `count_products` is used by this attachment action.
- The counter option label now shows each alternative UoM barcode beside its factor-to-base. The selected unit name, raw quantity and actual scanned barcode continue through the existing recording RPC and server conversion trigger.

Live schema/function/ACL verification confirmed both migrations in the Supabase ledger. For both public RPCs, `authenticated` execute is true and `anon` execute is false. These source migrations must not be replayed; consult the live migration ledger first.


| Repository source file | Live Supabase migration version | Live ledger name |
|---|---:|---|
| `20261126192500_countflow_client_import_uom_barcode_primary_conflict_v5.sql` | `20261126195037` | `countflow_client_import_uom_barcode_primary_conflict_v5` |

The v5 import guard prevents a barcode that matches the global primary barcode or one of the matched global product's alternate-UoM barcodes from being written into `count_client_products.client_barcode`. The code remains the primary identity or the alternate-unit barcode in the appropriate source. This avoids a project attachment promoting a carton barcode to the product's primary barcode while retaining the same barcode on an alternate UoM, which the project master trigger correctly rejects.

These migrations are additive and preserve the existing three catalogue scopes: global catalogue, client overlays, and project-scoped `count_products`. Do not create a parallel `count_products_master` or `count_product_units` model.


### 2026-11-26 — LVE-791 purchase-unit factor integrity

Source migration: `20261126213000_countflow_purchase_unit_factor_integrity_v1.sql`.

- Adds the private trigger function `counting_private.validate_purchase_cost_unit_snapshot()`.
- Both `count_import_rows` and `count_session_product_costs` now validate the submitted `purchase_unit` against the product's configured base/alternate UoM through the existing `counting_private.unit_factor_to_base(product_id, unit)` contract.
- A mismatch is preserved as source data and annotated with `PURCHASE_UNIT_FACTOR_MISMATCH`; it is not silently converted, overwritten, or used for a value calculation.
- Correcting the purchase unit/factor removes that warning automatically.
- The function is SECURITY DEFINER with an empty search_path, is not executable by PUBLIC/anon, and is granted only to authenticated/service_role for trigger execution.
- Test file: `tests/cost-unit-integrity-rollback.sql`; it exercises insert/update on the existing QA90K project inside an explicit transaction and ends with ROLLBACK. It must not be committed as live data.

### 2026-11-26 — LVE-791 trigger-only ACL hardening

Source migration: `20261126215000_countflow_purchase_cost_trigger_acl_v1.sql`.

- `counting_private.validate_purchase_cost_unit_snapshot()` is bound only as a BEFORE INSERT/UPDATE trigger function on `count_import_rows` and `count_session_product_costs`.
- A rollback-only database probe revoked EXECUTE from PUBLIC, anon, authenticated and service_role, then inserted an intentionally mismatched QA cost row as the database owner; trigger logic and the mismatch warning still executed correctly.
- EXECUTE is therefore revoked persistently from all client/service roles. The function is not a PostgREST RPC and is not intended for direct invocation.
- The trigger owner remains postgres; the function keeps an empty search_path and uses schema-qualified helper references.
