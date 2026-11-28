# تقرير التنفيذ — LVE-793
## فهرسة علاقات CountFlow، تصحيح الحوكمة، واختبارات التحقق الحي

**التاريخ:** 28 نوفمبر 2026 — Africa/Cairo  
**المستودع الوحيد:** `papamohammed77-glitch/rawaea-app-countflow`  
**قاعدة CountFlow:** `rawaea-staging` / `hfzznsiprnwkpayskzhu`  
**نقطة البداية الفعلية:** `2dfc997c415545220e4c3004e5bf4fa27406ed75`  
**آخر حدث مصدر قبل هذه المهمة:** LVE-2026-11-27-792.  
**ترحيل Supabase:** `countflow_fk_performance_indexes_v1` / `20261128000731` — APPLIED.  
**التزام المصدر على main:** `a8bb0650e82a87a961416740b3f50db374d27e88`.  
**CI main:** [run 46086708899](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/46086708899) — SUCCESS: Node 113/113، Deno PASS، Cloudflare Pages PASS، Playwright 3/3 PASS، وProduction/Main SHA parity PASS.  
**النتيجة الحالية:** ترحيل قاعدة البيانات مطبق ومتحقق؛ اختبارات SQL/Node وDeno وPages وPlaywright ناجحة؛ تنظيف الفروع محجوب بقدرة الاتصال الحالية.

---

## 1. تصحيح تعليمات المشروع المعتمدة

أثبت المالك في 28 نوفمبر 2026 ما يلي:

1. مكان كل تقرير تنفيذ جديد هو `Reports/` داخل المستودع الحالي.
2. الملف الخارجي `writing-block-8888-10.md` مستعار منهجياً من مشروع آخر، وهو مرجع لأسلوب التنفيذ فقط؛ ليس دستور CountFlow ولا يعلو على قرارات المالك أو تعليمات CountFlow.
3. كل المشروع وبياناته الحالية تجريبية وقيد التطوير، ولا يجوز وصفها بأنها بيانات تشغيل نهائية أو نموذج مكتمل.
4. في كل استكمال يجب الرجوع إلى HEAD الفعلي وSupabase الحي والكود المنشور، والتقارير التاريخية لا تقوم مقام المصدر.
5. `main` هو الفرع الوحيد المسموح؛ لا تنشأ فروع أو مستودعات جديدة.

تم تطبيق هذا التصحيح في `AGENTS.md` و`Reports/MASTER HANDOVER` وملف سياسة التنفيذ الصارمة، مع إضافة هذا الحدث في `CURRENT_STATE.md`.

## 2. خط الأساس الذي تم التحقق منه قبل التغيير

### GitHub

- HEAD الفعلي لـ`main` عند البدء: `2dfc997c415545220e4c3004e5bf4fa27406ed75`.
- هذا الالتزام كان تحديث تقرير LVE-792 فقط؛ آخر كود وظيفي مدمج قبله هو `676700459ff7901c89d5c45df9b5d585c8dcff64`.
- قراءة إعدادات حماية الفرع عبر Branch Protection endpoint محجوبة من اتصال GitHub (403 Resource not accessible by integration)، لذلك لم أستنتج حالة الحماية من فشل القراءة.
- فحص الفروع أعاد `main` و17 فرع عمل غير رئيسي:
- `work/lve-752-streamed-operation-import`
- `work/lve-752-streamed-operation-import-v2`
- `work/lve-753-queue-security-and-import-closure`
- `work/lve-756-presence-acl-ui-purification`
- `work/lve-761-admin-image-owner-storage-access`
- `work/lve-762-export-edge-parity-docs`
- `work/lve-763-countflow-gamification`
- `work/lve-763-session-participation-guard`
- `work/lve-764-product-image-urls`
- `work/lve-765-admin-ui-final-mainline`
- `work/lve-765-admin-ui-surgical`
- `work/lve-765-camera-mvp`
- `work/lve-785-admin-catalog-ux`
- `work/lve-787-unified-catalog`
- `work/lve-788-admin-item-editor-ux`
- `work/lve-791-export-coverage-cost-unit-integrity`
- `work/lve-792-enterprise-teams-operation-types-kpis`
- PR #6، Camera MVP، ما زال OPEN وغير مدمج وGitHub وصفه `mergeable=false`. شروطه المنشورة تقول إن اختبار Counter المصادق في جلسة فعالة وموقع مسند لم يُنفذ بعد؛ لم أدمجه تلقائياً.
- دمج PR لا يعني حذف فرع المصدر، وإغلاق PR لا يعني حذف فرعه.

### قاعدة البيانات — حدود النطاق

- `rawaea-staging` هي قاعدة CountFlow الوحيدة.
- فُحصت 37 جدولاً عاماً باسم `count_*`. كل جدول منها لديه RLS enabled وسياسة RLS واحدة على الأقل: **37/37**.
- توجد جداول ERP أخرى في نفس مشروع Supabase، لكنها خارج نطاق CountFlow. لم يتم تعديلها.
- قبل الإصلاح أظهر Performance Advisor 31 تحذيراً لمفاتيح خارجية غير مفهرسة على مستوى المخطط العام؛ 12 منها تخص جداول CountFlow و19 تخص جداول خارج نطاق CountFlow.
- القراءة الحية للبيانات: ملف QA واحد، جلسة مخططة واحدة، 4 عضويات، 41,000 صنف، 90,000 صف استيراد، صفر مواقع، صفر إسنادات، صفر أحداث عد، وصفر فرق/عضويات فرق/إسنادات فرق.
- دفعة `qa-90000-products.csv` ما زالت بحالة `committing`: 41,000 صف committed و49,000 staged. لم تُستكمل أو تُحذف أو يعاد تصنيفها أو ربطها بتكليف آخر.

## 3. Change Set — فهارس الأداء

### المشكلة المثبتة

12 علاقة FK على جداول الفريق والإسناد ودورة الجلسة كانت بلا فهرس مطابق في الجانب الابن وفق فحص الكتالوج ونتائج Supabase Advisor. هذا قد يؤدي إلى مسح جدول عند فحص المرجع الأب، ويزداد أثره مع نمو الإسنادات والأعضاء والفرق.

### التعديل

ملف الترحيل:

`database/migrations/20261128000731_countflow_fk_performance_indexes_v1.sql`

أضاف 12 فهرس B-tree غير فريد:

| الجدول | الأعمدة | عدد الفهارس |
|---|---|---:|
| `count_assignments` | `(member_id, project_id)`, `(session_id, project_id)` | 2 |
| `count_session_team_members` | `(session_team_id, project_id)`, `(member_id, project_id)` | 2 |
| `count_session_teams` | `(assigned_by)`, `(session_id, project_id)`, `(team_id, project_id)` | 3 |
| `count_sessions` | `(queue_barrier_run_id)` | 1 |
| `count_team_members` | `(added_by)`, `(member_id, project_id)`, `(team_id, project_id)` | 3 |
| `count_teams` | `(created_by)` | 1 |
| **الإجمالي** |  | **12** |

لم تتغير قيود FK أو uniqueness أو مصدر الإسناد أو نموذج ملكية الفرق. الفهارس لا تنشئ صفوفاً ولا تعدّل بيانات موجودة.

## 4. تطبيق Supabase والتحقق الحي

### سجل الترحيلات

تم تطبيق الترحيل مرة واحدة باستخدام أداة تطبيق ترحيل Supabase:

- الاسم: `countflow_fk_performance_indexes_v1`
- الإصدار الفعلي في سجل Supabase: `20261128000731`
- نتيجة التطبيق: `success=true`

### تجربة ما قبل التنفيذ

شغّلت DDL للفهرسة داخل `BEGIN`، تحققت من ظهور 12 فهرساً داخل المعاملة، ثم نفذت `ROLLBACK`. قراءة الكتالوج بعد التراجع أعادت `persisted_test_indexes_after_rollback = 0`. لم يبق أي كائن من اختبار التمرين.

### التحقق بعد التطبيق

ملف الاختبار read-only:

`tests/countflow-fk-indexes-verify.sql`

يتحقق من وجود كل فهرس من الفهارس الاثني عشر على الجدول الصحيح وبترتيب الأعمدة المطلوب، وأنه صالح وجاهز وغير فريد وغير جزئي. كما يثبت أن كل جدول CountFlow أساسي لديه RLS enabled وسياسة واحدة على الأقل. لا ينشئ بيانات أو fixtures.

تم تشغيل محتوى الاختبار مباشرة على `rawaea-staging` واجتاز دون استثناءات:

| القياس | النتيجة |
|---|---:|
| جداول CountFlow الأساسية | 37 |
| جداول CountFlow مع RLS وسياسة | 37 |
| الفهارس المطلوبة المتحقق منها | 12 |

بعد الترحيل أعاد Supabase Performance Advisor `unindexed_foreign_keys = 19`. تفاصيل التحذيرات المتبقية كانت لجداول خارج CountFlow مثل customer_ledger وdelivery_* وdriver_ledger وinventory_log وjournal_entries وsupplier_ledger. **لم يعد Advisor يعرض FK ناقص الفهرسة داخل CountFlow.** لم ألمس هذه الجداول لأنها تخص تطبيقات/نطاقات أخرى.

## 5. اختبارات المصدر

أُضيف اختبار Node انحداري في نهاية `tests/unit/countflow-quality.test.mjs` باسم LVE-793. يثبت وجود تعريفات الفهارس الاثني عشر في ملف الترحيل ويربطها بملف التحقق SQL.

- اختبار SQL المباشر على Supabase: PASS.
- فحص catalog بعد الترحيل: PASS.
- Supabase Performance Advisor لنطاق CountFlow: PASS — صفر FK warnings لـCountFlow.
- GitHub Actions main run `46086708899` على الالتزام `a8bb0650e82a87a961416740b3f50db374d27e88`: **SUCCESS**.
- Node: **113/113 PASS، 0 failed**.
- Deno type check: **PASS**.
- Cloudflare Pages allowlisted build: **PASS**.
- Playwright: **3/3 PASS**؛ فحص Production shell تطابق مع SHA `a8bb0650e82a87a961416740b3f50db374d27e88`، RTL mobile shell PASS، وunauthenticated login shell PASS.
- لا يوجد اختبار أداء زمني أو ضغط فعلي؛ بيانات staging الحالية لا تمثل تشغيل عميل أو حملاً إنتاجياً.

## 6. مراجعة معيارية للمنتجات المنافسة

هذه مراجعة مرجعية لآليات المنتج وليست ادعاءً بنسخ واجهاتها:

- **Microsoft Dynamics 365 Supply Chain Management:** دورة العد تتضمن إنشاء أعمال العد، تنفيذ العد عبر جهاز محمول، ثم إحالة الفروقات إلى Pending review؛ وتدعم العد الموجه للمستخدم أو من النظام وتجميع مهام المواقع/المناطق. كما تسمح بسياسات Reason Codes اختيارية/إلزامية وإجراءات مراجعة قبل الاعتماد. مراجع رسمية: https://learn.microsoft.com/en-us/dynamics365/supply-chain/warehousing/cycle-counting وhttps://learn.microsoft.com/en-us/dynamics365/supply-chain/warehousing/reason-codes-for-counting-journals
- **SAP S/4HANA:** توثق فصل المراحل إلى Preparation ثم Count ثم Analysis، مع إعادة العد عند الحاجة ومراجعة فروقات الجرد. وتفرق بين الجرد الدوري وCycle Counting والجرد المستمر، وتستخدم تصنيف ABC لتكرار العد. مراجع رسمية: https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/91b21005dded4984bcccf4a69ae1300c/2761bd534f22b44ce10000000a174cb4.html وhttps://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/9905622a5c1f49ba84e9076fc83a9c2c/e89bc7536e8e2a4be10000000a174cb4.html
- **Oracle Fusion Cloud Inventory Management:** تفصل مهام دورة العد المستمرة عن الجرد الفعلي، وتوجد خطوات مستقلة لتسجيل Count Sequences واعتمادها، ومراجعة سجلات الواجهة، واعتماد تعديلات الجرد الفعلي. مرجع رسمي: https://docs.oracle.com/en/cloud/saas/supply-chain-and-manufacturing/26c/famli/overview-of-tasks-from-the-inventory-management-work-area.html

### أثر المقارنة على تصميم CountFlow

المعيار الذي ينبغي البناء عليه هو دورة محكومة لا مجرد تسجيل كمية: خطة تغطية صنف × موقع، توجيه للعمل، عد ميداني محمول/Offline، سبب للفرق، مراجعة مستقلة، إعادة عد، تجميد اللقطة، ثم اعتماد وتصدير قابل لإعادة الإنتاج. لدى CountFlow أجزاء مهمة من هذا المسار (queue barrier وreconciliation وrecount وفصل الأدوار)، لكنه لا يثبت بعد قبولاً ميدانياً كاملاً أو تصديراً واسع النطاق 90K+.

## 7. الفجوات المتبقية — لا تُخفى عن المساعد التالي

1. **تصدير 90K+ قابل للاستئناف:** Edge exporter الحالي يقرأ صفحات 1,000 لكنه يجمع جميع الصفوف في الذاكرة ويستخدم `zipSync` لتكوين ZIP النهائي في الذاكرة؛ هذا ليس streaming/resumable حقيقياً. يجب تصميم job/checkpoint/chunk/hash/idempotency/expiry ثم قياس 5K و90K+ على ملف XLSX صالح، مع المحافظة على ضوابط التغطية والتكلفة والوحدات وNULL مقابل صفر.
2. **توزيع الفرق على المواقع:** جداول `count_session_teams` و`count_session_team_members` تحفظ إسناد الفريق ولقطته التاريخية، بينما `count_assignments` يحمل `location_id`. لا يوجد ربط واضح حتى الآن بين الفريق ومجموعة مواقع متعددة. لا تضف `location_id` وحيداً للفريق قبل تعريف علاقة الفريق متعدد المواقع، وتداخل الأعضاء، والتغطية الهرمية، ومنع التعارض.
3. **Camera MVP / PR #6:** اختبار هاتف فعلي عبر Counter مصادق في جلسة وموقع مسند غير مثبت؛ bucket `shelf-images` public حسب عقد PR #6، ويجب مراجعة مخاطر الوصول العام للصور قبل الإغلاق.
4. **قبول Admin المصادق:** لا يوجد دليل على قبول بصري/تفاعلي بعد دخول المالك على Desktop/Mobile؛ اختبارات الغلاف العام لا تثبت هذا القبول.
5. **اختبارات الاستيراد:** وجود `tests/import_5k_rollback.sql` و`tests/import_90k_rollback.sql` لا يعني نجاحها. يلزم تشغيلها في جلسة rollback-only بأسماء QA_ وإثبات أعداد الصفوف قبل/بعد.
6. **اكتمال سجل الترحيلات:** `database/migrations/README.md` يذكر أن المجلد ليس baseline نظيفاً قابلاً لإعادة التشغيل؛ توجد migrations تاريخية مطبقة لا يطابق كل منها ملف مستقل. يجب إجراء reconciliation كامل بين ledger والملفات دون إعادة تنفيذ القديم.
7. **إعدادات Auth وEdge:** يوجد تحذير Leaked Password Protection. يلزم مراجعة إعداد Auth وRPC/Edge bodies وACL وفق سيناريوهات الأدوار دون تعطيل تدفقات المستخدمين؛ لم يجر تعديل عام هنا.
8. **الاختبارات المصادقة:** لا توجد حالياً جلسة فعالة وإسنادات ومواقع مخصصة لاختبار الرحلة كاملة. لا تنشئ بيانات جديدة إلا مع أسماء QA_ وخطة تنظيف rollback.
9. **نظافة الفروع:** طلب المالك `main` فقط، لكن الاتصال الحالي لا يتيح عملية GitHub `DELETE /git/refs/{ref}`. توجد 17 فروع غير رئيسية في آخر listing؛ لم ينشأ فرع في هذه المهمة ولم تحذف فروع.

## 8. سجل التغييرات والآثار

- SQL migration حي في Supabase: `countflow_fk_performance_indexes_v1` / `20261128000731`.
- ملفات المستودع في هذا التغيير: migration، SQL verification، اختبار Node، `database/migrations/README.md`، `AGENTS.md`، `Reports/MASTER HANDOVER`، strict protocol، `CURRENT_STATE.md`، وهذا التقرير.
- لم تتغير واجهات Admin أو Counter أو Supervisor أو Core أو Edge Function code.
- لا DML ولا صفوف QA أو Auth Users أو Storage Buckets أو Count Events جديدة.
- دفعة QA90K بقيت دون تغيير؛ لا حركات مخزون أو قيود مالية.
- لا فرع أو مستودع جديد؛ ولا ملفات مؤقتة/Debug أضيفت.

## 9. قرار الجاهزية

**SOURCE COMMIT + CI + PRODUCTION PARITY PASS — LVE-793 performance-index slice.**

المثبت: الإصلاح مطبق في Supabase، الفهارس الـ12 موجودة، اختبار SQL read-only ناجح، 37/37 CountFlow tables لديها RLS وسياسات، وAdvisor لا يرصد FK غير مفهرس داخل CountFlow.

غير المثبت بعد: CI الجديد، القبول المصادق والمرئي، اختبار كاميرا فعلي، تصدير 90K+، الأداء تحت حمل فعلي، وتصفية الفروع إلى main فقط. لا يُعلن اكتمال CountFlow كله.
