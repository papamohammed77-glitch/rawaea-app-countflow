# تقرير استلام واستكشاف معماري — LVE-769
## CountFlow: Global Catalog / Client Admin / Dynamic RBAC / Operation Form

**التاريخ:** 24 نوفمبر 2026 — Africa/Cairo  
**نوع التنفيذ:** استعادة نقطة الاستئناف + تدقيق عقود للقراءة فقط  
**الحكم:** READY WITH LIMITATIONS — Discovery verified; next additive architecture phase not yet implemented  
**المستودع الوحيد:** `papamohammed77-glitch/rawaea-app-countflow`  
**فرع الاستمرار:** `work/lve-765-admin-ui-final-mainline`  
**PR:** [#8](https://github.com/papamohammed77-glitch/rawaea-app-countflow/pull/8) — OPEN / UNMERGED  
**PR head عند الاستلام:** `6a29e5d56a834c904350a5ec4e4a537462f122f8`  
**Base:** `2bd494d7028723fbdb278b2c2b56fff9669f881b`  
**آخر رأس كود واختبار موثق:** `ffec2c4e2119b63b7ebed9f76f440ad93d4668f4`  
**رأس PR الحالي:** CI run `45463890990` — SUCCESS.  
**Preview:** https://work-lve-765-admin-ui-final.rawaea-app-countflow.pages.dev

---

## 1. استعادة المهمة وعدم تكرار العمل

تم استلام المهمة من آخر نقطة موثقة في `CURRENT_STATE.md` على فرع PR #8، وهي **LVE-768 — Product vision first implementation**. لم أبدأ من LVE-764 ولم أكرر LVE-765.

- PR #7: CLOSED / superseded / not merged؛ التاريخ محفوظ.
- PR #8: OPEN / UNMERGED / mergeable.
- PR #5 الخاص بـLVE-764 مدمج بالفعل في main؛ بوابة عرض الصور وXLSX ما زالت قبولًا تشغيليًا مفتوحًا، ولا يعني الدمج أن تلك الاختبارات أصبحت PASS.
- لا يوجد نشر Production ضمن هذه المرحلة.
- لا تعديل على `erp-frontend` أو SMART ERP.

## 2. التقارير والمصادر التي تمت مراجعتها

| المصدر | SHA / الحالة | ما تم استخلاصه |
|---|---|---|
| `CURRENT_STATE.md` على فرع PR #8 | blob `2d4de2a95188f39f8e0f4e812945f90d35c44d08` | LVE-768 هو أحدث checkpoint؛ PR #8 مفتوح؛ تعليمات حماية دفعة QA |
| `Reports/P6` | `5f8a3fe7fde2b6349413ed3b49308a78817ba66e` | P6 توثيق تسليم LVE-765، وليس تغييرًا تشغيليًا |
| `Reports/FINAL_EXECUTION_REPORT_LVE-764.md` | `509cd67b99c59b52a257d11848582916bddf55fd` | صور المنتج: upload/link/signed GET PASS؛ Admin/Counter display وXLSX ما زالا OPEN |
| `Reports/FINAL_EXECUTION_REPORT_LVE-765.md` | `a13f87323d5432b0971f8a0e0f5996652e3b8fbb` | Admin UI overhaul مكتمل على مستوى المصدر والاختبارات؛ قبول بصري مصادق وProduction parity غير مثبتين |
| `Reports/PRODUCT_VISION_EXECUTION_LVE-768.md` | `f739130d490a5f758d02d6a2068ed9103d398c09` | أول موجة من رؤية المنتج؛ قائمة الفجوات المتبقية هي نطاق المرحلة التالية |
| الدستور المرسل | `writing-block-8888-10.md`, SHA `928a98e94624e1c0a5bf4b3e97aaff560c33fcd8`, 27,617 حرفًا | تمت قراءة النص كاملًا؛ هو دستور RAWAEA ERP العام، وليس ملف CountFlow خاصًا، وتُطبق منه قواعد الحاكمية وحماية البيانات وعدم ادعاء نجاح غير مثبت |

**ملاحظة الحالة:** نسخة `CURRENT_STATE.md` على `main` كانت لا تزال تحمل تاريخ LVE-764 القديم. نسخة فرع PR #8 هي نقطة الاستئناف الصحيحة في الوقت الحالي؛ لا تعتمد main حتى دمج PR #8.

## 3. GitHub / المصدر / الاختبارات

- PR #8 عنوانه `LVE-765 — CountFlow Admin UI overhaul (mainline continuation)`، لكنه يحمل أيضًا تنفيذ رؤية المنتج LVE-768.
- أحدث commit في PR وقت الفحص: `6a29e5d`، رسالة commit تحديث handover/report.
- آخر رأس كود/اختبار كامل موثق: `ffec2c4`، 53/53 Node tests، Deno Type Check PASS، Pages allowlisted build PASS، Playwright 2 PASS / 1 SKIPPED.
- CI الحالي على رأس PR: run `45463890990` — SUCCESS. لم أنقل عدد اختبارات الرأس `ffec2c4` إلى رأس PR الحالي؛ النجاح الحالي مؤكد، وتفاصيل العدد موثقة للرأس المختبر السابق.
- المصدر الحالي الذي تمت قراءته:
  - Admin `countflow-admin.html`: SHA `6927e52ce189a1e8f9fc046a695a4a45814e0d7a`
  - Supervisor `Countflow-supervisor.html`: SHA `0d8c9807cfe336ae08adb36a012d6682454afcee`
  - Counter `countflow.html`: SHA `0ad7d32cd84bb1d6a8253b3c96a78cd74fdd20b5`
  - Control `countflow-control.html`: SHA `32e45fc77e2e9fa8be3bb14f17da59a94f915708`
  - `counting-provision-member/index.ts`: SHA `e344c35f25218fac57014346fe5c5d7a78927997`

## 4. المرجع التصميمي RAWAEA ERP — حدود الإثبات

- POS `companies/company-1/sales/pos.html`: SHA `4b34e63747b4b533c663e488049e80a1b81dd537`. النمط المرئي الذي تمت مراجعته: بحث اسم/كود/باركود، زر كاميرا بجانب حقل البحث، تصنيفات سريعة، شبكة أصناف، وسلة ثابتة واضحة.
- Picker `companies/company-1/warehouse/picker.html`: SHA `d1baa1ea7caebf515d4e750b1b4be78a698949f6`. تم الرجوع إلى الملف كمرجع تصميم فقط، ولم يتم تعديله.
- Parent `companies/company-1/main.html`: الملف كبير جدًا؛ استدعاء GitHub لم يُرجع محتوى قابلًا للقراءة في هذه الجلسة. توجد نتائج موثقة في السياق السابق عن RW_Roles وRW_Users: بحث/تصفية، أدوار نظامية ومخصصة، إنشاء/تعديل/نسخ، مجموعات صلاحيات، مستخدمون مرتبطون وتأثير الدور؛ وقائمة مستخدمين مع بحث/تصفية، ربط الدور، الحالة والفروع المسموحة وترقيم الصفحات. **لم أتحقق في هذه الجلسة من تفاصيل modal أو مصدر main.html الحالي/مواضع السطور؛ لذلك لا أدعي مراجعة byte-for-byte كاملة للملف الكبير.** يبقى مرجع تصميم فقط ولا يُعدّل.

## 5. Supabase — قراءة حية فقط

**المشروع:** `rawaea-staging` / `hfzznsiprnwkpayskzhu` — ACTIVE_HEALTHY. لم أتصل بـSMART ERP.

### 5.1 Counts وRLS

استعلامات قراءة فقط أكدت:

- 24/24 جدول CountFlow (`count_*`) لديه RLS مفعّل.
- 78 سياسة RLS عبر 24 جدول CountFlow.
- `count_products`: 41,000 صف.
- `count_projects`: 1؛ `count_members`: 4؛ `count_sessions`: 1.
- `count_entries`: 0؛ `count_assignments`: 0.
- `count_import_batches`: 1؛ `count_import_rows`: 90,000.

هذه الأعداد تطابق snapshot LVE-768 في النقاط التي أُعيد فحصها.

### 5.2 دفعة QA — ممنوع لمسها

`qa-90000-products.csv` / batch `f799c5c1-b766-4712-b74f-c0bb19836ddc` لا تزال `committing`:
- 90,000 صف إجمالي.
- 41,000 مقبول.
- 0 مرفوض.
- لا يوجد `completed_at`.

لم أستأنفها أو أوقفها أو أحذفها أو أكررها أو أعدلها. لم أنشئ عدًا أو إسنادًا أو مستخدم Auth أو تسوية أو تصديرًا.

### 5.3 العقود الحالية التي تمنع واجهة سطحية

**Products**
- `count_products.project_id` إلزامي؛ المنتج مرتبط بملف تكليف واحد.
- SKU فريد ضمن المشروع؛ الباركود فريد ضمن المشروع بعد التطبيع، وليس global.
- `base_unit` إلزامي، و`units` JSONB، والصورة مرجع اختياري.
- قيد الهوية يطلب SKU أو barcode.
- Counter وAdmin وControl يقرؤون `count_products` مع `project_id`؛ Counter يبحث بالباركود ثم SKU. Supervisor يقرأ إجمالي الأصناف داخل المشروع.
- لا يوجد جدول Global Catalog أو Client Product Mapping في المخطط الحالي.

**Projects / Sessions**
- `count_projects` يحوي `name, code, status, created_by`؛ لا يوجد سجل Client مستقل أو `client_id`.
- `count_sessions` يحوي الاسم والحالة ووقت البدء/الإغلاق وحقول Queue Barrier؛ لا يحتوي نموذج العملية المطلوب للفرع/الجدول/الهيكل المكاني/الموارد.
- `count_create_engagement(p_client_name,p_engagement_code,p_operation_name)` ينشئ Project + Session أولى في معاملة واحدة، ويتحقق من platform owner.

**Members / Roles**
- `count_members.role` مقيد حاليًا بالقيم الثلاث: `supervisor / counter / auditor`.
- العضوية فريدة لكل `project_id,user_id` ولكل `project_id,username`.
- `counting_private.is_supervisor` و`is_auditor` يستخدمان الدور الثابت؛ `is_member` يتحقق من العضوية وحالتها.
- RLS وواجهات Supervisor/Counter/Control تعتمد هذا العقد؛ تغيير الدور إلى جدول ديناميكي ليس تعديل UI فقط.
- Edge Function `counting-provision-member` الحالية تتطلب platform owner المؤكد، وتسمح بالأدوار الثلاثة فقط، وتستخدم service-role لإنشاء/إعادة استخدام حساب Auth. Client Admin يحتاج تحققًا خادميًا جديدًا من tenant/client scope، وليس صلاحية service-role داخل المتصفح.

**Locations**
- `count_locations` مرتبطة بـproject؛ الأنواع الحالية: `store, warehouse, department, aisle, shelf, bin, zone, role`.
- الشجرة عبر `parent_id`، ولا يوجد type صريح لـbranch أو floor.
- الإسنادات والنتائج والمصالحة تعتمد على مفاتيح مركبة project-scoped؛ يجب الحفاظ على هذا العزل.

## 6. الفجوات المؤكدة في رؤية المالك

| المجال | الحالة الحقيقية |
|---|---|
| Admin UI: SweetAlert2 / Font Awesome / Sidebar grouping / Sticky headers / Skeletons | CODE VERIFIED ضمن LVE-765؛ لا يعاد تنفيذها |
| Global Catalog across clients | NOT IMPLEMENTED؛ المنتجات الحالية project-scoped |
| Client Product Mapping / Branch overrides | NOT IMPLEMENTED |
| Client Admin / tenant user administration | NOT IMPLEMENTED؛ provisioning owner-only |
| Dynamic Roles / Permission Editor | NOT IMPLEMENTED؛ role CHECK وRLS helpers ثابتة |
| Full Operation Creation Form | NOT IMPLEMENTED؛ button موجود لكن schema/session fields محدودة |
| Branch / floor / department / aisle / rack / shelf hierarchy | PARTIAL؛ hierarchy موجودة لكن types لا تشمل branch/floor/rack |
| Power BI-style analytics | PARTIAL؛ KPIs الحالية بسيطة؛ لا توجد لوحة اتجاهات/مقارنات شاملة |
| Counter camera/barcode/offline field E2E | UNVERIFIED على أجهزة فعلية |
| Authenticated human E2E for owner/supervisor/counter/auditor | OPEN |
| XLSX actual file + `xl/media` validation | OPEN |
| Full owner-data privacy across all tables/functions/channels | OPEN; LVE-768 covered selected fields only |

## 7. Surgical ChangeSet — المرحلة التالية (تصميم، لم يُطبق)

**لا يوجد تغيير مصدر أو قاعدة بيانات في LVE-769.** لا أضع SQL أو واجهة وهمية قبل تثبيت العلاقات النهائية.

الحد الأدنى من التصميم المطلوب قبل التنفيذ:

1. **Client/Tenant entity:** فصل العميل التجاري عن Engagement/Project؛ ربط مشاريع جديدة بعميل مع الحفاظ على المشاريع القديمة دون backfill غير مراجع.
2. **Global catalog:** سجل صنف canonical مستقل عن مشروع الجرد؛ GTIN/Barcode نصي مع الحفاظ على leading zeros؛ SKU عالمي منفصل؛ base UoM + conversion factors؛ الصورة كـobject key خاص.
3. **Client mapping:** ربط الصنف العالمي بكود/باركود/اسم/وحدة العميل، مع override محدود ومحدد للفرع عند الحاجة.
4. **Project snapshot/compatibility:** عدم إعادة كتابة 41,000 سجل `count_products` أو تغيير مفاتيح نتائج العد. أي ربط عالمي يجب أن يكون nullable/additive أولًا، مع استمرار قراءة التطبيقات الحالية حتى اعتماد migration path.
5. **Dynamic RBAC:** role definitions + permission keys + role-permission relation + membership role reference؛ ثم تحديث helpers/RLS/Edge/app consumers مع compatibility للثلاثة أدوار الحالية. لا يُفعّل دور جديد قبل اختبار server-side enforcement.
6. **Client Admin:** user provisioning server-side scoped to client, invitations/confirmed identity, project membership, branch/location scope, status and audit. ممنوع service-role في browser.
7. **Operation form:** تحديد fields typed المطلوبة في session/project، وربطها بالـlocation hierarchy والassignment؛ لا تُخزن حقول business-critical في JSON عشوائي دون عقد.
8. **KPI dashboard:** استخدام RPC/aggregates موجودة فقط عند ثبوت تعريف المؤشر؛ لا عرض أرقام تقديرية أو نسبة إكمال بلا denominator.

### أثر التغيير
- **Source:** Admin + Counter + Supervisor + Control + import RPC/Edge + tests + migrations.
- **Database:** additive schema/RLS/grants/functions في rawaea-staging فقط بعد اكتمال ChangeSet؛ لا DML على batch QA أو count entries.
- **Inventory/accounting:** لا أثر مخزون أو محاسبي؛ CountFlow counting data only.
- **Rollback:** إيقاف استعمال الجداول الجديدة والعودة إلى project-scoped `count_products`؛ لا حذف بيانات أو إسقاط جداول بعد بدء الاستخدام.
- **Acceptance:** contract/schema/RLS → unit/integration → staging with isolated synthetic fixtures → authenticated role E2E → import compatibility at scale → browser/runtime. لا تُعتبر migration مكتملة بمجرد نجاح SQL.

## 8. ما لم يُنفذ ولماذا

لم أبدأ migration أو أغير واجهة Admin في هذه المرحلة؛ لأن Global Catalog وClient Admin وDynamic RBAC تعتمد على حدود tenant والهوية والعقود الحالية، وأي UI فقط سيعطي صلاحيات/كتالوجًا وهميًا أو يتجاوز enforcement. هذه مرحلة اكتشاف/تثبيت عقد، وليست إعادة تأجيل عشوائية.

## 9. LAST VERIFIED EVENT

**LVE-2026-11-24-769 — CountFlow contract discovery**  
Read-only GitHub + Supabase inspection completed. No code, SQL, data, auth, storage, edge deployment, merge, or production changes.  
**Next single execution step:** إكمال تصميم tenant/client + global catalog + project mapping + role-permission contract من جميع consumers/RLS/Edge، ثم إعداد migration وsource ChangeSet additive ومحدد لاختبارها في rawaea-staging دون لمس دفعة QA القائمة.

**الجاهزية:** READY WITH LIMITATIONS. نقطة الاستئناف واضحة؛ المرحلة التالية جاهزة للتصميم التنفيذي، لكن لا يجوز إعلان Global Catalog أو Client Admin أو Dynamic RBAC منجزًا حتى تنفيذ العقود واختبارها.
