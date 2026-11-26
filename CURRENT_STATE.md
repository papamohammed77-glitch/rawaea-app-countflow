## LVE-2026-11-26-788 — تنظيم محرر الصنف ووحدة الأساس

**Last Verified Event:** 26 نوفمبر 2026 — Africa/Cairo.  
**التقرير التنفيذي:** `Reports/LVE-2026-11-26-788_ADMIN_ITEM_EDITOR_UX.md`.  
**التقرير المساعد المدروس:** `Reports/تقرير تحسين تبويب الأصناف` (blob `11bb86d93a64a2dff735902690e8898f58cbbe9e`).  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`.  
**فرع الاعتماد:** `main` — لم يتغير في LVE-788.  
**Base commit:** `2c33e56cead187c7136f42fd14b6e6e11da9bdbe`.  
**فرع التنفيذ:** `work/lve-788-admin-item-editor-ux`.  
**آخر التزام للكود والاختبارات:** `81f985dfb59c0e3864cf07f43ca7405e3e3a8e90`؛ الالتزامات اللاحقة في هذا الفرع تقارير/حالة فقط.  
**PR #11:** https://github.com/papamohammed77-glitch/rawaea-app-countflow/pull/11 — OPEN / NOT MERGED.  
**الحالة:** SOURCE IMPLEMENTED — CI PASS — AUTHENTICATED VISUAL ACCEPTANCE OPEN — NOT DEPLOYED.

### 1. نقطة الاستئناف
- استُؤنف العمل من LVE-787 المدمج في main. لم تُعد كتابة دليل الأصناف الموحد أو البحث أو صفحة التفاصيل أو فصل Global/Client/Project.
- أحدث Commit على main عند البدء كان `2c33e56cead187c7136f42fd14b6e6e11da9bdbe`؛ كان إضافة تقرير تحسين الأصناف فقط، دون تعديل Runtime.
- التغيير الوظيفي محصور في محرر الصنف العالمي داخل `countflow-admin.html`؛ مواءمة المؤسسة وأصناف التكليف بقيت ضمن مساراتها الحالية.

### 2. ما تم تنفيذه
- تنظيم محرر الصنف في ثلاثة تبويبات داخلية: البيانات الأساسية، الوحدات البديلة، الإعدادات المتقدمة.
- جعل الأقسام Accessible باستخدام tablist/tab/tabpanel وaria-selected، مع التنقل بالأسهم وHome/End.
- وضع صورة الصنف في قسم البيانات الأساسية، مع الاحتفاظ بStorage الخاص وروابط العرض الموقعة الحالية.
- نقل `unit_class` (نمط القياس) إلى البيانات الأساسية، مع فصلها عن `item_kind` (نوع تعريف الباركود).
- إضافة قائمة لوحدة الأساس مرتبطة بنمط القياس وخيار وحدة مخصصة؛ تبقى القيمة النهائية في `base_unit` الموجود.
- توسيع aliases للتعرف على الوحدات حتى تتسق مع `counting_private.infer_item_unit_class`، بما في ذلك oz/ounce وinch/in/ft وsqft/ft2.
- الإبقاء على الوحدات البديلة المتعددة ومعامل `factor_to_base` وباركود كل وحدة وmetadata داخل `units` JSONB.
- الإبقاء على مولد CFI والتحقق الحالي من GTIN/Code128 وعمليات الحفظ الحالية. لم يتم إنشاء جدول أو عمود أو RPC جديد.
- عدم إضافة تكلفة أو سعر بيع أو مورد إلى الدليل؛ هذه الحقول/المعاني غير موجودة في عقد Item Master الحالي.

### 3. الملفات والبصمات
- `countflow-admin.html`: blob `b144a609f0ef5dad45dcc3cd25a5f198f50dab6f`.
- `tests/unit/countflow-quality.test.mjs`: blob `b3a2fdb9762f201cf09743c3a9f4c9fec1bfb5d8`.
- `Reports/LVE-2026-11-26-788_ADMIN_ITEM_EDITOR_UX.md`: تقرير التنفيذ العربي الجديد (blob `38721588cf527854c696c2e9d7f3d2b0474bd60f`).
- `CURRENT_STATE.md`: هذا التحديث فقط.
- PR #11 يضم تعديلات Runtime واختبارات وتقارير/حالة؛ لا يوجد دمج إلى main.

### 4. التحقق الآلي
- GitHub Actions Run `45870843566`, HEAD `81f985dfb59c0e3864cf07f43ca7405e3e3a8e90`: SUCCESS.
- Node tests: 99/99 PASS.
- Deno type-check لوظيفتي Edge: PASS.
- Cloudflare Pages allowlisted build: PASS.
- Playwright discovery وPublic production shell: 2 PASS / 1 SKIP.
- حالات الفشل الوسيطة كانت في اختباري وحدة جديدين (حد اقتطاع دالة inference وتوقع تصنيف square-foot) وتم تصحيحها؛ الاختبار النهائي على HEAD أعلاه أخضر بالكامل.
- نجاح هذه البوابة لا يثبت فتح المحرر في جلسة المالك أو القبول البصري المصادق.

### 5. حالة Supabase والسلامة
- المشروع الوحيد الذي تمت قراءته: `rawaea-staging` / `hfzznsiprnwkpayskzhu`, ACTIVE_HEALTHY.
- 33/33 CountFlow tables عليها RLS. سجل migrations الحي 191.
- `counting-provision-member` v7 ACTIVE وJWT مطلوب؛ `counting-export-session` v15 ACTIVE وJWT مطلوب.
- بيانات القراءة الحية وقت هذا الحدث: projects=1, members=4, sessions=1, products=41,000, catalog_products=0, client_products=0, clients=0, import_batches=1, import_rows=90,000, count_entries=0.
- دفعة QA90K `f799c5c1-b766-4712-b74f-c0bb19836ddc` حالتها `committing`، بها 41,000 committed و49,000 staged؛ لم تُستأنف أو توقف أو تعدل أو تحذف.
- لا DDL/DML/Migration/RLS/GRANT/Trigger/RPC definition/Edge deploy أو كتابة Storage في LVE-788.
- SMART ERP / `fiilmooggumokxanwiyx` وملفات ERP لم تُلمس.

### 6. Deployment / Runtime / Acceptance
- PR #11 غير مدمج، لذلك تغيير LVE-788 غير منشور على Cloudflare Production.
- CI بنى Pages من الفرع فقط؛ لا يساوي Deploy إلى Production.
- القبول البصري المصادق داخل Admin على Desktop/Mobile، وتفاعل المحرر بحساب المالك: OPEN.
- لم يتم إنشاء/تحديث صنف فعلي أو مواءمة مؤسسة أو رفع صورة في قاعدة البيانات.

### 7. التراجع
- Admin قبل LVE-788: blob `f3bf232b8a38935b38b673997d96e77d5acac561`.
- Tests قبل LVE-788: blob `ce9ab49b6ffba6decdb3b4554597389aa52da93c`.
- التراجع يكون عبر Revert لالتزامات PR #11 أو استعادة البصمتين في فرع مستقل؛ لا يوجد DB rollback مطلوب.

### 8. الخطوة التالية
أكمل قبولاً بصرياً مصادقاً لمحرر الصنف في PR #11 (Desktop/Mobile، التنقل بين الأقسام دون فقد المدخلات، فتح صنف قائم، وحدة أساسية مخصصة، الوحدات البديلة والصورة)، ثم قرر الدمج بعد قبول الواجهة. لا تستخدم بيانات QA90K ولا تنفذ كتابة قاعدة بيانات كجزء من القبول البصري.

**Readiness:** READY WITH LIMITATIONS — CI/source gates PASS; authenticated visual and owner acceptance OPEN.

---

## LVE-2026-11-26-787 — توحيد دليل الأصناف وتدقيق الفروع

**Last Verified Event:** 26 نوفمبر 2026 — Africa/Cairo.  
**التقرير النهائي:** Reports/LVE-2026-11-26-787_UNIFIED_CATALOG_AND_BRANCH_AUDIT.md.  
**المستودع المعتمد الوحيد:** papamohammed77-glitch/rawaea-app-countflow.  
**Default branch:** main.  
**PR #10:** MERGED — https://github.com/papamohammed77-glitch/rawaea-app-countflow/pull/10.  
**Main merge commit:** 15225fbf963ace4df072faa9c9f60ad9b51d3f7b.  
**Main push CI:** Run #391 / 45862039270 — SUCCESS.  
**PR #9:** CLOSED — SUPERSEDED BY PR #10.  
**الحالة:** MERGED TO MAIN — AUTOMATED QUALITY GATES PASS — AUTHENTICATED VISUAL ACCEPTANCE OPEN — PAGES DEPLOYMENT UNKNOWN.

### النتيجة التنفيذية
- دليل الأصناف أصبح مساحة موحدة؛ لا تبويبات Global / Client / Project منفصلة.
- قائمة واحدة تعرض الصنف الأساسي وحقول المؤسسة المختارة في الصف نفسه. اختيار المؤسسة محدد نطاق وليس تبويباً.
- صفحة تفاصيل واحدة تجمع بيانات الصنف الأساسية والحقول المحلية للمؤسسة. حقول المؤسسة تظل محفوظة عبر RPC count_upsert_client_product.
- البحث يشمل الاسم وSKU والباركود العامين، والاسم وSKU والباركود والتصنيف الخاص بالمؤسسة المختارة.
- CSV موحد يضم الحقول الأساسية والمحلية؛ القراءة مجزأة وبحدود معلنة.
- محرر الصنف أصبح صفحة واحدة، مع اقتراحات وحدة أساس وقيمة مخصصة؛ بقيت الوحدات البديلة المتعددة ومعامل factor_to_base وباركود الوحدة مدعومة.
- «بالوزن» نمط/نوع قياس، لا وحدة كمية؛ الصنف الوزني يتطلب وحدة كتلة فعلية مثل كجم/جرام.
- أصناف التكليف لا تزال في نفس مساحة الأصناف من خلال اختيار نوع السجل، مع الحفاظ على سجلها وملكية بياناتها منفصلين.
- لم تُدمج جداول count_catalog_products وcount_client_products وcount_products ولم تتغير صلاحياتها.

### الملفات المعتمدة في main
- countflow-admin.html
- tests/unit/countflow-quality.test.mjs
- Reports/LVE-2026-11-26-787_UNIFIED_CATALOG_AND_BRANCH_AUDIT.md
- هذا القسم في CURRENT_STATE.md.

### التحقق
- PR CI Run #388 / 45861460737: SUCCESS — 96/96 Node tests، Deno، Pages allowlisted build، Playwright 2/2.
- Main push Run #391 / 45862039270: SUCCESS — 96/96 Node tests، Deno، Pages allowlisted build، Playwright 2/2.
- Playwright يثبت غلاف الدخول العام وRTL على Mobile فقط؛ لا يثبت تجربة Admin بعد مصادقة المالك.
- القبول البصري المصادق على Desktop/Mobile داخل Admin: OPEN.
- نشر Cloudflare Pages على الرابط الفعلي: UNKNOWN؛ لا تعتبر نجاح Pages build دليلاً على النشر.

### حدود السلامة
- لا DDL / DML / Migration / RLS / GRANT / Trigger / RPC definition / Edge deploy.
- لا سجلات أصناف أو مواءمات أو عمليات جرد أو إدخالات عد أو أرصدة جديدة.
- QA90K لم تُلمس.
- لا تغيير في RAWAEA ERP أو SMART ERP أو أي مستودع ERP.
- لا تأثير على المخزون أو المالية أو الحسابات.

### حالة الفروع وطلبات الدمج
- main هو Default Branch ولم يتغير.
- GitHub يعرض 15 فرعاً إجمالاً: main و14 فرع عمل. هذا لا يغير Default Branch؛ الملفات المعتمدة في هذا الحدث هي فقط ما دُمج في main.
- PR #1–#5 merged. PR #6 الخاص بالكاميرا ما زال open/unmerged وبوابة الالتقاط الميداني لم تثبت؛ لا تدمجه قبل اختبارها.
- PR #7 و#8 closed/unmerged؛ PR #9 closed/superseded؛ PR #10 merged.
- لم تُحذف مراجع فروع. موصل GitHub المتاح لا يوفر Delete Branch/Ref ولا يسمح بطلب DELETE عام. لا تحرك مراجع الفروع قسرياً لإخفائها ولا تتلف تاريخها.
- فروع PRs المدمجة، والفروع القديمة المتقدمة بصفر commits عن main، وفرعا LVE-785/LVE-787 مرشحة للحذف من GitHub بعد المراجعة الإدارية. احتفظ بفروع LVE-752 ذات commits الفريدة، وفرع الكاميرا، وفرع LVE-765 mainline إلى حين تدقيق كل كود غير مدمج.
- فرع LVE-787 لم يعد مصدراً معتمداً بعد الدمج؛ main هو المرجع الوحيد للنسخة المعتمدة.

### الخطوات المفتوحة
1. اختبار بصري مصادق داخل Admin على Desktop وMobile، خاصة الدليل الموحد، تغيير المؤسسة، فتح تفاصيل الصنف، الحقول المحلية، وحدات القياس والصور.
2. التحقق من نشر Cloudflare Pages عن طريق Deployment status/Build SHA ومراجعة الصفحة المنشورة.
3. حذف المراجع المرشحة من GitHub بوسيلة توفر صلاحية Delete Reference، بعد تدقيق محتواها الفريد.
4. عدم دمج PR #6 حتى تنجح اختبارات الكاميرا داخل سياق Counter مصرح به.

---


## LVE-2026-11-26-786 — تحليل وحدات الأصناف وتدقيق المستودع المعتمد

**Last Verified Event:** 26 نوفمبر 2026 — Africa/Cairo.  
**التقرير:** `Reports/LVE-2026-11-26-786_ITEM_UOM_AND_REPOSITORY_CONSOLIDATION.md`.  
**مستودع CountFlow المعتمد الوحيد:** `papamohammed77-glitch/rawaea-app-countflow`.  
**HEAD قبل التوثيق:** `628a2c21d8c00175ba30c050ab28ac0394c801fc`.  
**Commit التقرير:** `c016a929d3812625fc88b421744e76e8a76612a1`.  
**الحالة:** DESIGN AUDIT COMPLETE — REPOSITORY CONSOLIDATION VERIFIED — NO APPLICATION/DATABASE CHANGES.

### القرار التنفيذي
- CountFlow لديه بالفعل `base_unit` و`units` متعددة مع `factor_to_base` وباركود بديل وmetadata لفئة القياس/الدقة/نوع الصنف.
- شاشة `countflow.html` لديها اختيار وحدة العد؛ الخادم يثبت معامل التحويل ويحسب `base_quantity`.
- يجب تبسيط نموذج الصنف UI، وليس اختزال العقد أو حذف الوحدات المتعددة.
- «بالوزن» اختيار طريقة قياس/نوع صنف، وليس وحدة كمية؛ يلزم اختيار وحدة كتلة فعلية مثل كجم/جرام.
- يوجد خطر محتمل لتغيير وحدة الأساس بعد اكتمال جلسة بسبب نطاق guard الحالي؛ لا تغيير backend دون موافقة Migration منفصلة.
- يوجد تعارض بين تقرير LVE-781 و`findProduct()` الحالي بشأن البحث بباركود الوحدة البديلة؛ الحالة CONFLICT / NOT CONFIRMED.

### تدقيق المستودع
- قائمة GitHub لدى المالك تضم 4 مستودعات؛ واحد فقط هو CountFlow المستقل. مستودعات ERP الثلاثة مشاريع منفصلة ولا تُحذف ضمن تنظيف CountFlow.
- نسخة CountFlow المضمنة في `erp-frontend/companies/company-2/Counting`: 73 ملفاً؛ 55 مطابقاً تماماً؛ 18 مختلفاً؛ 0 مفقود من المستودع المستقل. لا نسخ بالجملة ولا تعديل ERP.
- PR #7 وPR #8 مغلقان وغير مدمجين؛ PR #8 واسع ومتباعد ولا يُنقل بالجملة.
- PR #9 هو LVE-785 النشط، مفتوح وغير مدمج، HEAD `8363da59dc6ab0160eb95c08813f156772577a43`; CI Run `45854351134` SUCCESS؛ قبول المالك البصري المصادق ما زال OPEN.
- خمس migrations القديمة في PR #8 تطابق محتوى ملفات main التي تحمل versions المطابقة لسجل التنفيذ؛ لا حاجة إلى نسخ/إعادة تسمية/إعادة تطبيق. ملفات migrations التسعة الأخرى المسجلة في staging موجودة أيضاً في شجرة main.
- بنية المستودع الحالية (صفحات التطبيقات في الجذر، Core/SW، database/migrations، functions، tests، Reports) مناسبة لمسارات Pages وService Worker؛ لا نقل مجلدات في هذه الجولة.

### الحدود
- لا نقل ملفات، لأن التدقيق أثبت عدم وجود ملفات CountFlow مفقودة في المستودع المعتمد.
- لا DDL/DML/Migration/RLS/GRANT/RPC/Edge deploy، ولا تعديل RAWAEA ERP، ولا حذف فروع أو مستودعات.
- التنفيذ التالي المقترح: UI-only UOM simplification في ملفات CountFlow الحالية مع اختبارات؛ ثم backend history guard ودقة لكل وحدة بعد موافقة مستقلة.

---
## LVE-2026-11-26-784 — تدقيق استخراج تبويب الأصناف المرجعي من RAWAEA ERP

**Last Verified Event:** 26 نوفمبر 2026 (Africa/Cairo).  
**التقرير:** Reports/LVE-2026-11-26-784_AUDIT_RAWAEA_ITEMS_EXTRACTION.md.  
**المستودع الذي يحتوي التوثيق:** papamohammed77-glitch/rawaea-app-countflow / main.  
**المصدر المرجعي الخارجي، قراءة فقط:** papamohammed77-glitch/erp-frontend / companies/company-1/main.html.  
**حالة هذا الحدث:** AUDIT COMPLETE — NO APPLICATION OR DATABASE CHANGES.

### نطاق الملفات التي تمت قراءتها
- Reports/تقرير استخراج تبويب الأصناف — RAWAEA ERP: 329 سطراً، blob 65c539f511cc9c3a37065041af62cbde8569e6dd.
- Reports/RW_Items.md: 1,864 سطراً، blob 6cbd5e89e8bf0c3dc3aadc21cd51690c3f997dc3.
- المصدر companies/company-1/main.html في erp-frontend: 34,718 سطراً، HEAD main = 095a344e20cafd768c88353c33ceecbc764a6cc4، blob 00456494de918b36fc6792bef302319a9f65605d.
- تمت قراءة التقرير وملف الكود كاملين على دفعات، وفحص كتلة المصدر ومقارنتها آلياً سطراً بسطر.

### نتيجة مطابقة الكود
- تعليق الوحدة يبدأ في main.html عند السطر 4897.
- تعريف var RW_Items يبدأ عند السطر 4899.
- نهاية الوحدة window.RW_Items = RW_Items; عند السطر 6758.
- طول كتلة المصدر 1,862 سطراً.
- RW_Items.md يحتوي 1,864 سطراً بسبب فاصل زخرفي زائد في بداية الملف وسطر فارغ أخير.
- بعد حذف هذين السطرين الإضافيين، بقية الملف مطابقة تماماً لكتلة المصدر الأصلية من السطر 4897 إلى 6758.
- لم يُعثر على حذف أو إعادة صياغة داخل الوحدة؛ الملف يضم RW_Items IIFE كاملة ولا يتضمن وحدات تبويب أخرى.

### نتيجة تدقيق التقرير مقابل البرومبت
- التقرير منظم ويصف بشكل صحيح بناء الواجهة ديناميكياً، و4 تبويبات فرعية مشروطة بالصلاحيات، ومحرر صفحة كاملة لا Modal، وثلاثة تبويبات للمحرر، وبحث وفلاتر وPagination 50، وإدارة الصور والتصنيفات، ومسار التسوية والتصدير.
- التقرير نفسه لا يحتوي كوداً حرفياً أو code fences أو روابط Markdown/URLs فعلية. عبارات «فتح...» هي نصوص فقط وليست روابط. كما أن أسماء أقسام HTML/CSS/JavaScript/SQL/Data Structure ليست مصاغة بعناوين Markdown المطلوبة ##.
- ملف RW_Items.md المنفصل يعوض كود الوحدة كاملة، لكنه لا يضم تبعيات RW_Table.paginate وRW_Data.loadItems الموجودة خارج الوحدة.
- قسم SQL في التقرير لا يذكر استعلام inventory_log الخاص بتقرير حركة الصنف، ولا يجرد كل مواضع استعلام items المستخدمة لفحص التصنيف ومطابقة ملف التسوية.
- قسم Data Structure لا يعرض الغلاف الخارجي الكامل لطلب save-item: item وisEdit وitem_code وopeningBranch وopeningQty.

### تصحيح واقعة محددة في التقرير السابق
- التقرير السابق قال إن النقر على الصورة يفتح صفحة تحرير الصنف. هذا غير صحيح: خلية الصنف/الاسم تفتح openItemPage، أما الصورة فتوقف انتشار النقر وتستدعي _viewImage لعرض صورة مكبرة (main.html lines 5130–5132 و5504–5505).

### ملاحظات على المصدر الأصلي لا يجوز نقلها كما هي
1. فرز إجمالي المخزون في جدول القائمة يستخدم a.totalStock بينما الحقل المشتق الحقيقي هو _totalStock؛ لذلك فرز هذا العمود لا يعتمد على إجمالي المخزون الفعلي.
2. ملف تسوية الأرصدة يقبل عنوان عمود item_code ضمن متغير barcodeCol، ثم يبحث بالقيم في حقل barcode؛ هذا خلط في مطابقة الأكواد (lines 6217 و6315–6319).
3. قارئ ملف التسوية يستخدم FileReader.readAsArrayBuffer وXLSX.read على كامل الملف، ولا يظهر في هذا المسار streaming أو حد حجم (lines 6203–6239).
4. نتائج استعلامات items وstock_branches داخل معاينة التسوية لا يجري فحص error لها قبل حساب الرصيد وبناء النتائج؛ ينبغي عدم نسخ هذا النمط لمسار يغيّر أرصدة.
5. تقرير حركة الصنف يقرأ inventory_log عبر استعلام واحد بلا Pagination صريحة داخل هذا المسار؛ الحد الفعلي يعتمد على إعداد PostgREST ويحتاج تحققاً قبل ضمان اكتمال السجل على أحجام كبيرة.
6. تعريف RW_Table.paginate عام وخارج RW_Items (main.html lines 183–249)، وRW_Data.loadItems خارج الوحدة (lines 1464–1475). يجب تسجيلهما كتبعيات لا خلطهما داخل الوحدة.

### ما يثبته المرجع وما لا يثبته
- يثبت شكل واجهة بطاقة الصنف، الحقول التي يرسلها المحرر، استعلامات القراءة الظاهرة، أسماء Edge Functions المستعملة، وفصل بيانات items عن أرصدة stock_branches وحركات inventory_log.
- لا يثبت SQL DDL أو أنواع الأعمدة أو القيود أو الفهارس أو RLS أو السلوك الداخلي لوظائف Edge، ولا يثبت أن إجراء الرصيد الافتتاحي آمن أو يطابق عقد CountFlow. يلزم تدقيق مستقل لهذه العقود قبل أي تنفيذ.
- لا يوجد في RW_Items مسار استيراد كتالوج أصناف؛ الموجود bulk-stock-adjustment لتسوية أرصدة أصناف موجودة. التصدير الموجود هو Excel لمصفوفة أرصدة الفروع وليس بطاقة الصنف الكاملة.

### نتيجة السلامة
- تمت قراءة المصدر المرجعي فقط؛ لا تغييرات في erp-frontend أو RAWAEA ERP.
- لا DDL/DML أو RPC writes أو Edge deploy أو Storage operations.
- أضيف تقرير التدقيق فقط داخل Reports في مستودع CountFlow.
- لا تغيير في كود التطبيقات أو بيانات CountFlow.

### التوجيه قبل استلام الفكرة التالية
استخدم RW_Items.md كمصدر برمجي موثوق لوحدة RW_Items بعد فهم حدودها، واستخدم تقرير LVE-784 كخريطة تدقيق وتصحيح. لا تنقل سلوك تسوية الأرصدة باعتباره استيراد كتالوج. افصل تعريف الصنف ووحداته وصورته عن الأرصدة والحركات. لا تنفذ أي تعديل في RAWAEA ERP أو المرجع الخارجي.

**Readiness:** READY WITH LIMITATIONS — اكتمال وحدة المصدر مؤكد؛ التقرير الوصفي السابق غير كافٍ كاستخراج حرفي مستقل، والاعتماد التنفيذي يتطلب فحص عقود البيانات والخادم عند صياغة المهمة التالية.

---

## LVE-2026-11-26-783 — استعادة التسليم وقبول Admin

**Last Verified Event:** 26 نوفمبر 2026 (Africa/Cairo).  
**التقرير:** Reports/LVE-2026-11-26-783_HANDOVER_UI_ACCEPTANCE.md.  
**المستودع التشغيلي الوحيد:** papamohammed77-glitch/rawaea-app-countflow.  
**الفرع:** main.  
**رأس main قبل تحديث التوثيق LVE-783:** c5202f0af8668fe2d08d7090ee5d97ab3abf494b.  
**آخر التزام كود/اختبار:** e2ade95dda70d954e7aeb2466adf5db5484d8f1b.  
**التقرير السابق:** LVE-780 ثم LVE-781 ثم LVE-782؛ لا تعِد تنفيذها.

### استعادة المعرفة والحوكمة
- تمت مراجعة CURRENT_STATE.md بالكامل، إلى جانب AGENTS.md وUSER_FIRST_ENGINEERING_PROTOCOL.md وARCHITECTURE.md وDEPLOYMENT.md وREADME.md والتقارير LVE-780 وLVE-781 وLVE-782.
- تمت مراجعة فرع main وHEAD ومقارنة الالتزامات ومصدر Admin وService Worker واختباراته.
- التزامات main الثلاثة بعد e2ade95 توثيقية فقط؛ لا تغييرات على ملفات التطبيق بعد SHA المصدر أعلاه.
- دستور RAWAEA ERP المرفق بالطلب تمت قراءته كاملاً، لكنه خاص بـRAWAEA ERP وSMART ERP وليس دستور CountFlow. حوكمة CountFlow في AGENTS.md وبقية وثائقه هي الحاكمة؛ لا تخلط المستودعين.
- لا تغييرات مصدر أو قاعدة بيانات أو Edge في هذا الحدث. جميع استعلامات Supabase قراءة فقط.

### مصدر التطبيق والتحقق
- countflow-admin.html blob: 90f77a6fff4914d0854e537251464fc61ac71204.
- countflow-sw.js blob: ffeeabe90ac059eaa93f2e0b356a6172c04ea909؛ الإصدار countflow-sw-20261125-9.
- tests/unit/countflow-quality.test.mjs blob: a01c2bf7de34a28143099c291da590227cfaa43a.
- LVE-782 أصلح ReferenceError بسبب فقدان تعريف previewGlobalCatalogImport وcommitGlobalCatalogImport وresetGlobalCatalogImport قبل ربط الأزرار؛ هذا منع تسجيل مستمعي التنقل وأوقف كل التبويبات. التعريفات وربطها موجودة الآن في المصدر.
- GitHub Actions Run 45702250074 / #368 على e2ade95: SUCCESS؛ Node 92/92، Deno PASS، Pages allowlisted build PASS، Playwright public production login shell 3/3 PASS، وProduction build-info SHA parity PASS.
- Playwright غلاف دخول عام دون جلسة مصادقة؛ لا يثبت قبول Admin الداخلي بعد دخول المالك.
- صفحة Production تمت قراءتها من التبويب المتصل فقط. لا جلسة مالك مصادق عليها مثبتة هنا، وأدوات المتصفح في هذه الجلسة لا تسمح بالنقر والتنقل التفاعلي. القبول البصري المصادق على Desktop وMobile يبقى OPEN.

### Supabase rawaea-staging — قراءة فقط
- المشروع: hfzznsiprnwkpayskzhu.
- 33/33 جدول CountFlow count_* عليه RLS.
- owner@rawaea.com: حساب Auth واحد مؤكد.
- count_clients=0، count_catalog_products=0، count_client_products=0، count_products=41,000، count_projects=1، count_sessions=1، count_import_batches=1، count_import_rows=90,000.
- دفعة QA90K f799c5c1-b766-4712-b74f-c0bb19836ddc حالتها committing؛ 90,000 صف مصدر، 41,000 مقبول، صفر مرفوض، completed_at NULL. الجلسة المرتبطة d435854f-1646-4549-9c12-2936f74a4052 ما زالت planned. لا تستأنفها أو توقفها أو تحذفها أو تعِد استيرادها ولا تستخدمها للاختبار.
- فجوة decimal_precision التي سجلها LVE-780 أُغلقت في المصدر وقاعدة البيانات بعد LVE-781: Trigger count_entries_unit_conversion_guard ينفذ counting_private.set_count_entry_unit_factor() قبل إدراج/تحديث count_entries، ويفرض دقة الصنف من metadata ويثبت unit_factor_to_base.
- سجل الترحيلات الحي يسجل countflow_item_master_barcode_uom_integrity_v1 عند النسخة 20261125202923 وcountflow_item_master_helper_acl_v1 عند 20261125203023. أرقام الوقت في أسماء ملفات SQL لا تطابق ledger؛ ledger هو مرجع التنفيذ. لا تعِد تشغيل الترحيلات.
- counting-export-session ACTIVE v15 وverify_jwt=true؛ counting-provision-member ACTIVE v7 وverify_jwt=true.
- لا DDL أو DML أو RPC writes أو GRANT/RLS/ACL أو Edge deploy.

### Surgical ChangeSet ونتيجة LVE-783
- أضيف تقرير عربي واحد: Reports/LVE-2026-11-26-783_HANDOVER_UI_ACCEPTANCE.md.
- يُحدّث هذا القسم فقط في مقدمة CURRENT_STATE؛ جميع السجل التاريخي أدناه محفوظ كما هو.
- لا تعديل على ملفات runtime أو الاختبارات أو قاعدة البيانات.
- READY WITH LIMITATIONS: استعادة المعرفة والمصدر وCI مثبتة؛ القبول البصري/التفاعلي لواجهة Admin بعد مصادقة المالك لا يزال OPEN.

### تعليمات الاستئناف
1. استأنف من main وافحص HEAD قبل أي تغيير.
2. الخطوة التالية هي قبول Admin تفاعلياً بعد دخول المالك الحالي على Desktop وMobile: Overview، دليل العملاء، Global/Client/Project، محرر الصنف، مواءمات المؤسسة، ومعاينة الاستيراد.
3. لا تحفظ تعديلات حقيقية أثناء القبول الأولي، ولا تضغط زر استيراد/اعتماد.
4. اختبارات الكتابة ببيانات QA اصطناعية تتطلب بوابة موافقة مستقلة محددة؛ استخدم مجموعة منفصلة قابلة للإزالة فقط، ولا تقترب من دفعة QA90K الحالية.
5. لا تكرر LVE-780/781/782، ولا تدمج PR #6 أو تعدل فرع الكاميرا، ولا تلمس RAWAEA ERP أو SMART ERP.
6. بعد كل مرحلة، حدّث تقرير Reports/ وCURRENT_STATE.md، واستخدم تصنيفات CONFIRMED / UNKNOWN / CONFLICT / UNVERIFIED.

---

## LVE-2026-11-25-782 — إصلاح توقف تنقل CountFlow Admin

**Last Verified Event:** 25 نوفمبر 2026 — Africa/Cairo  
**Repository:** papamohammed77-glitch/rawaea-app-countflow — **Branch:** main  
**HEAD الذي اجتاز CI:** \`e2ade95dda70d954e7aeb2466adf5db5484d8f1b\`  
**الحالة:** RESOLVED — SOURCE AND CI VERIFIED  
**التقرير:** \`Reports/LVE-2026-11-25-782_ADMIN_TAB_BOOT_FAILURE.md\`  
**CI:** [Run #368](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45702250074) — SUCCESS  
**الاختبارات:** 92 passed / 0 failed؛ Playwright production login shell: 3 passed  
**Service Worker:** \`countflow-sw-20261125-9\`

**السبب الجذري:** ربط أزرار الاستيراد العالمي في \`countflow-admin.html\` كان يستدعي \`previewGlobalCatalogImport\` و\`commitGlobalCatalogImport\` و\`resetGlobalCatalogImport\` دون تعريف أي منها. أدى ReferenceError أثناء تنفيذ IIFE إلى إيقاف التهيئة قبل تسجيل مستمعي تبويبات القائمة.

**الإصلاح:** استعادة الدوال الثلاث ومسار التطبيع/المعاينة/الاستيراد المتدفق؛ استخدام RPC \`count_upsert_catalog_products_chunk\` الحالي بحد 500 صف و90,000 صف للملف؛ تحديث اختبارات توقيعات UOM القديمة؛ وإصدار Service Worker جديد لإبطال نسخة Shell المخزنة السابقة.

**التحقق:** تعريف واحد لكل handler؛ ربط الأزرار قائم؛ CI وDeno وNode tests وبناء Pages وPlaywright نجحوا. التحقق البصري من جلسة Admin مصادق عليها ما زال بانتظار المالك.

**سلامة البيانات:** لم تُنفذ أي عملية استيراد أو كتابة بيانات خلال الإصلاح، ولم تُلمس أرصدة العد أو دفعة QA90K المحمية، ولم تُعد تشغيل أي migration.

---
## LVE-2026-11-25-781 — نظام بيانات الأصناف متعدد الوحدات والباركود

**Last Verified Event:** 25 نوفمبر 2026 — Africa/Cairo  
**Repository:** papamohammed77-glitch/rawaea-app-countflow — **Branch:** main  
**HEAD عند تثبيت التقرير:** `902a68a9fffb9e918b6775e73a36b2550ffd1073`  
**التقرير:** `Reports/LVE-2026-11-25-781_ITEM_MASTER_DATA_SYSTEM.md`  
**CI المطابق:** Run 45697943916 — failure  
**Service Worker:** `countflow-sw-20261125-8`  
**الحالة:** BLOCKED — CI/SOURCE EVIDENCE INCOMPLETE

### القرار المعماري
لم تُنشأ الجداول المقترحة في النص المرفق بأسماء `count_products_master` و`count_product_units` و`count_project_products`. استُخدمت كيانات CountFlow الحالية: `count_catalog_products` / `count_client_products` / `count_products`، مع الحفاظ على الفصل Global / Client / Project، وعدم نقل أرصدة أو تاريخ عد بين المؤسسات والتكليفات.

### المنفذ
- تحقق GS1 لـ EAN8 / UPC-A / EAN13 / GTIN14، مع تمييز CODE128 وCFI الداخلي وحماية الأكواد التاريخية.
- UOM متعدد مع معامل تحويل وباركود اختياري مستقل لكل وحدة، ومنع التكرار عبر النطاقات.
- فرض دقة الكسور على خادم Postgres من خلال trigger `count_entries`، لا في واجهة Counter فقط.
- تحرير الصنف العالمي في أربع خطوات: الأساسية، الوحدات، الصورة، المتقدم.
- مسارات حفظ النوع/الباركود/الوحدات في Global / Client / Project.
- استيراد Global CSV/XLSX على دفعات 500 صف عبر `count_upsert_catalog_products_chunk`، مع limit 90,000، checksum ورقم صف لإنتاج CFI حتمي وإعادة تشغيل آمنة.
- بحث Counter في باركودات وحدات التعبئة، مع حفظ الرمز الممسوح في دليل العد.

### الترحيلات
- `20261125223000_countflow_item_master_barcode_uom_integrity_v1.sql`
- `20261125203100_countflow_item_master_helper_acl_v1.sql`
تم تطبيقهما سابقاً في `rawaea-staging`؛ لا تعِد تشغيلهما. تحقق من migration ledger قبل أي تعديل لاحق.

### حدود القبول
- لا استيراد فعلي 90K للدليل العالمي في هذه الجولة.
- لا قبول بصري مصادق لداخل Admin/Client حتى الآن.
- لم يتم توليد/فتح XLSX فعلي من جلسة مالك.
- الأداء 90K/التزامن العالي غير مقاس.
- QA batch `f799c5c1-b766-4712-b74f-c0bb19836ddc` لم تُمس وتظل `committing`، 90,000 rows، 41,000 accepted، 0 rejected، completed_at NULL.
- سياسة التسعير UNKNOWN.

**التفاصيل:** راجع تقرير LVE-781.  

---

## LVE-2026-11-25-780 — تصحيح عدّ وحدات القياس واستكمال تسليم Admin UI

**Last Verified Event:** 25 نوفمبر 2026 — Africa/Cairo  
**المستودع:** papamohammed77-glitch/rawaea-app-countflow — **الفرع:** main  
**آخر التزام كود تم التحقق منه:** `b956e375b02fb8aafb0eff64fbf12db6069bfb0c`  
**تغييرا المرحلة:** `00b70123cbc3aebd569aef3c2a24d353d7f1cfb5` ثم `b956e375b02fb8aafb0eff64fbf12db6069bfb0c`  
**التقرير:** `Reports/LVE-2026-11-25-780_UI_OVERHAUL_CONTINUATION.md`  
**GitHub Actions:** [Run 45680621762 — SUCCESS](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45680621762)  
**Production SHA parity:** PASS — `b956e375b02fb8aafb0eff64fbf12db6069bfb0c`  
**Service Worker:** `countflow-sw-20261125-8`  
**الحالة:** READY WITH LIMITATIONS / CODE + CI + PRODUCTION SHELL PARITY PASS / AUTHENTICATED ADMIN ACCEPTANCE OPEN

### الحكم التنفيذي
عولج تضخيم عدد الوحدات البديلة في ثلاث قوائم Admin. كان كائن metadata الخاص بفئة الوحدة ودقة الكسور محفوظاً داخل مصفوفة `units`، لكن القوائم كانت تحسب `units.length` مباشرة. أصبحت تستخدم `productUnitRows()` لاستبعاد metadata مع الإبقاء على الوحدات الفعلية. لا تغيير في السجلات أو العقود أو الحسابات أو الصلاحيات.

### الملفات والالتزامات
- `countflow-admin.html`: Blob `389aa640502044c9271316992611274a81b611ed` ← `4cd9ce7d66a94d6629f6100c14abe128f2b55654`.
- `countflow-sw.js`: Blob `e56f080d7197312957f1cc0f88288bbd289540aa` ← `704155bdbbdb34b862c737d100ace08e5492ebd2`; الإصدار 8.
- `tests/unit/countflow-quality.test.mjs`: Blob `3f29f49aa5469cb37a962c27ba6af7af5df24742` ← `d978f57395e72569576050fba6b419b32b2f9a77`.
- Node tests: **91/91 PASS**. Deno, Pages build, Playwright **3/3 PASS**.
- Pages Production يطابق `b956e375b02fb8aafb0eff64fbf12db6069bfb0c` وفق Run 45680621762. هذا فحص للغلاف العام، وليس قبول Admin الداخلي المصادق.

### قاعدة البيانات والسلامة — SELECT ONLY
- `count_clients=0`, `count_catalog_products=0`, `count_client_products=0`.
- `count_products=41,000`, `count_projects=1`, `count_sessions=1`.
- `count_import_batches=1`, `count_import_rows=90,000`.
- RLS enabled في **33/33** جدولاً من جداول CountFlow ذات البادئة `count_`.
- دفعة QA90K `f799c5c1-b766-4712-b74f-c0bb19836ddc` ما زالت `committing`، accepted 41,000، rejected 0، completed_at NULL. لم يتم تعديلها.

### فجوة مفتوحة مثبتة
واجهة Counter تتحقق من دقة الكسور، لكن `count_record_entry` و`counting_private.record_recount_entry` لا يفرضان `decimal_precision` خادمياً. لا RPC/Migration/DDL أو بيانات اختبار حية في هذه المرحلة؛ حوكمة CountFlow تتطلب موافقة منفصلة لتلك التغييرات.

### تعليمات الاستكمال
- لا تعِد أعمال LVE-765/772/775/776/778/779 المنفذة على main.
- نفذ قبولاً بصرياً مصادقاً لصفحات Admin الداخلية على الكمبيوتر والهاتف، قراءة فقط أولاً.
- أغلق فجوة الدقة الخادمية في مهمة مستقلة بعد استيفاء بوابة الموافقة.
- لا تلمس دفعة QA90K، ولا PR #6، ولا أي فرع غير main أو أي مستودع خارج CountFlow.

### الأدلة وحدود القبول
- CODE VERIFIED: source hashes والاختبارات الثلاثة.
- DATABASE VERIFIED: counts وRLS وحالة الدفعة أعلاه.
- DEPLOYED ARTIFACT VERIFIED: Pages SHA parity.
- AUTHENTICATED RUNTIME: UNKNOWN / OPEN.
- SERVER-SIDE DECIMAL PRECISION: CONFIRMED GAP.
- **Readiness: READY WITH LIMITATIONS.**

---

## LVE-2026-11-25-779 — بروتوكول منظور المستخدم، ودليل العملاء، وتوحيد الأصناف

**Last Verified Event:** 25 نوفمبر 2026 — Africa/Cairo  
**المستودع:** papamohammed77-glitch/rawaea-app-countflow — **الفرع:** main  
**نقطة الأساس:** \`bf488c8c987c647cbf315d495ac22ca8bc8c6f7d\`  
**آخر التزام برمجي اجتاز CI:** \`c58888a6fa1362594aea081d2d5d0b1f824691d2\`  
**التقرير:** \`Reports/LVE-2026-11-25-779_USER_FIRST_CLIENT_PRODUCT_DIRECTORY.md\`  
**GitHub Actions:** [Run 45668767858 — SUCCESS](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45668767858)  
**Service Worker:** \`countflow-sw-20261125-7\`  
**الحالة:** CODE IMPLEMENTED / CI PASS / PUBLIC SHELL PARITY PASS / AUTHENTICATED UI ACCEPTANCE OPEN

### الحكم التنفيذي
أضيف بروتوكول دائم يلزم جميع المساعدين والوكلاء بتصميم الرحلة من منظور المستخدم وتحليل المصدر الفعلي قبل التعديل. دُمج دليل الأصناف في مدخل تنقل واحد بثلاثة نطاقات منفصلة، وأصبح كود العميل مولداً تلقائياً ومتتابعاً، مع احتفاظه بالمعاينة الظاهرة ومعالجة تعارض Unique. أزيلت حدود 500/1000 الثابتة من جلب مديري العملاء واستبدلت بصفحات متتابعة.

### البروتوكول الحاكم
- \`USER_FIRST_ENGINEERING_PROTOCOL.md\`: البروتوكول الملزم لتصميم رحلة المستخدم، تقليل الإدخال اليدوي، جمع نقاط التنقل المتصلة، وإبقاء الكيانات والصلاحيات منفصلة.
- \`AGENTS.md\`: يلزم كل مساعد/وكيل بقراءة البروتوكول وCURRENT_STATE والكود والعقود قبل العمل.
- تم ربطه في \`ARCHITECTURE.md\` و\`README.md\`.
- البروتوكول تابع للحوكمة الأمنية؛ لا يلغي منع تغييرات Supabase أو الكتابة الحية دون موافقة منفصلة.

### دليل العملاء
- تغير اسم التنقل وعنوان القسم إلى «دليل العملاء».
- كود العميل يولد تلقائياً بصيغة \`CLIENT-000001\` وما يليها، ويظهر للقراءة فقط.
- generator يقرأ أكواد العملاء على صفحات خادمية 500، ويأخذ أعلى suffix.
- عند تعارض Unique يُعاد توليد الكود وتحديث القيمة المرئية للمستخدم، حتى 5 محاولات.
- تحرير العميل لا يغير الكود الثابت بعد الإنشاء.
- جلب أسماء/عضويات المديرين والبحث عن المديرين أصبح بصفحات \`range()\` حجمها 500 دون \`limit(500/1000)\` يقتطع النتائج.
- لم تتغير واجهة Edge أو حسابات Auth أو مخطط العملاء.

### الأصناف
- مدخل رئيسي واحد فقط: \`data-tab="products"\` بعنوان «الأصناف».
- قسم داخلي «الدليل العالمي» — \`count_catalog_products\`.
- قسم داخلي «مواءمات المؤسسة» — \`count_client_products\`.
- قسم داخلي «أصناف التكليف» — \`count_products\`.
- نُقل محتوى أصناف ملف التكليف واستيراد Excel/CSV إلى نفس التبويب، مع رسالة نطاق واضحة عند عدم اختيار تكليف.
- لم تُدمج الجداول أو الصلاحيات. ربط الصنف بالتكليف يظل عبر RPC الحالية \`count_attach_catalog_product\`.
- مرجع UX: ERP \`RW_Items\` كما هو موثق في LVE-776؛ Blob SHA للمرجع \`00456494de918b36fc6792bef302319a9f65605d\`. لم يُعدل ERP.

### تحقق Supabase — SELECT فقط
- RLS enabled على: count_clients, count_client_members, count_client_audit_log, count_catalog_products, count_client_products, count_products.
- \`count_clients.code\` لا يملك Sequence أو Default؛ يوجد Unique index \`count_clients_code_uq\`.
- عدد سجلات العملاء في rawaea-staging لحظة القراءة: 0؛ لذلك أول كود هناك CLIENT-000001. لا يثبت ذلك عدد سجلات الإنتاج.
- تأكدت قيود تفرد مواءمة الصنف لكل مؤسسة وتفرد صنف المشروع ضمن project_id.
- استعلام عام أحصى 65 جدولاً في public دون RLS؛ تم تسجيل ذلك كمخاطر تتطلب مراجعة مالك منفصلة، دون تعديل.
- لا DDL/DML/Migration/RLS/GRANT/RPC/Trigger/Edge deploy أو كتابة تجريبية.

### الالتزامات والملفات
- \`218fd473cd7256e3d62cafecf48122f325f13850\` — توحيد الأصناف، مولد الكود، وبروتوكول المساعدين.
- \`c58888a6fa1362594aea081d2d5d0b1f824691d2\` — تصحيح توقعات الاختبارات وتحسين معاينة الكود وإعادة المحاولة.
- countflow-admin.html SHA: \`a2ab1b2074ce21217c669da93c178208587be39f\`.
- tests/unit/countflow-quality.test.mjs SHA: \`da09c4c89427111f3c629c8ed182ee601d77c1fc\`.
- USER_FIRST_ENGINEERING_PROTOCOL.md SHA: \`62bc9acf753e5e34942838054d9f43ccbc185711\`.
- AGENTS.md SHA: \`811d64189e79f443e4669c380450129098ce7e55\`.
- countflow-sw.js SHA: \`e56f080d7197312957f1cc0f88288bbd289540aa\`.

### التحقق
- Node: **87 PASS / 0 FAIL / 0 SKIPPED**.
- Deno type-check لوظيفتي Edge الحاليتين: PASS.
- Cloudflare Pages allowlisted build: PASS.
- Playwright discovery: PASS.
- Playwright production login shell: **3/3 PASS**.
- Pages Production SHA parity مع \`c58888a\`: PASS.
- هذه الاختبارات لا تثبت قبول الصفحات الداخلية بعد تسجيل الدخول.

### القبول المفتوح والمخاطر
- القبول البصري المصادق لحساب المالك على العميل والمديرين ونطاقات الأصناف: OPEN.
- القبول بمدير مؤسسة والتحقق من حدود مواءماته: OPEN.
- حالة بيانات العملاء في Production غير معلومة من استعلام staging.
- اختبار إدراج عميل فعلي/تصادم متزامن يحتاج موافقة كتابة منفصلة.
- مراجعة الـ65 جدول public بلا RLS مهمة أمنية مستقلة.
- لا تعتبر LVE-779 مغلقة تشغيلياً قبل القبول المصادق، رغم نجاح CI.

---

## LVE-2026-11-25-778 — استكمال دليل العملاء ومديريهم في Admin

**Last Verified Event:** 25 نوفمبر 2026 — Africa/Cairo  
**المستودع:** papamohammed77-glitch/rawaea-app-countflow — **الفرع:** main  
**آخر التزام برمجي تم التحقق منه:** 2c1fff2363a7bab656056fcd4b48702c9f548c3b  
**التقرير:** Reports/LVE-2026-11-25-778_ADMIN_CLIENT_DIRECTORY_UX.md  
**GitHub Actions:** Run 45663060290 — SUCCESS  
**Service Worker:** countflow-sw-20261125-6

### ما تم تنفيذه
- عزل مترجم حالة العميل عن حالة أعضاء التكليف: حالات أعضاء المشروع تستمر على statusPill العام؛ دليل العميل ومديروه يستخدمون clientStatusPill، مع اختبار انحدار يمنع تسرب الترجمة بين التبويبات.
- استبدال نماذج العميل ومديره الثابتة بدليل عملاء ذي مؤشرات وModal تحرير.
- بحث متعدد الحقول يشمل اسم العميل وكوده ونشاطه وبيانات الاتصال واسم مستخدم/اسم مدير العميل.
- مرشح حالة، وفرز خادمي، وترقيم 25 سجلاً للصفحة باستخدام range وcount exact.
- عرض المسؤول وبيانات التواصل والعملة والمنطقة الزمنية والمديرين المرتبطين.
- Modal إضافة/تحرير العميل مع تثبيت الكود بعد الإنشاء، وتحرير حقول CountFlow الفعلية فقط.
- إدارة مدير العميل في سياق العميل: إنشاء/ربط عبر Edge الحالية، تعديل الاسم واسم المستخدم، إيقاف وإعادة تفعيل العضوية، وإعادة تعيين كلمة المرور عبر Edge الحالية.
- سجل تدقيق لأحداث العميل والمدير التي يدعمها العقد الحالي.
- تحديث Service Worker إلى countflow-sw-20261125-6.
- إضافة اختبارات انحدار للبحث والترقيم والنطاق والصلاحيات ودورة حياة العميل والمدير.

### الملفات والتزامات التنفيذ
- 060e89622d50cfa96aa83d64c52d9a8a510a1267 — feat(admin): complete client and manager directory UX
- e8fb9a217d1f29b17d54fcc862c05a3d4b63e484 — fix(admin): select new client in role scope after create
- 9396347d9ac465ceb9cc90a1d70849b1f80b1f4b — fix(admin): align client lifecycle labels and role-scope test
- 2c1fff2363a7bab656056fcd4b48702c9f548c3b — fix(admin): isolate client status labels from project members
- الملفات البرمجية المعدلة: countflow-admin.html، countflow-sw.js، tests/unit/countflow-quality.test.mjs.

### التحقق
- Node: 85 PASS / 0 FAIL / 0 SKIPPED.
- Deno type-check لوظيفتي Edge الحاليتين: PASS.
- Cloudflare Pages allowlisted build: PASS.
- Playwright production login shell: 3/3 PASS.
- Pages Production SHA parity مع 2c1fff2363a7bab656056fcd4b48702c9f548c3b: PASS.
- JavaScript inline parse: PASS.
- لا معرفات HTML ثابتة مكررة.
- لا حذف مادي للعميل أو العضوية ضمن التغيير.

### Supabase والسلامة
- count_clients وcount_client_members وcount_roles وcount_client_audit_log وعلاقاتها وRLS موجودة ومناسبة للمهمة.
- لم ينفذ أي DDL/DML أو Migration أو تعديل Policy/Grant أو RPC أو Edge deploy.
- لم تُنشأ حسابات أو عملاء أو عضويات اختبارية.
- لم تُمس دفعة QA أو بيانات المشروع القائمة.
- لم يتغير ERP المرجعي أو Counter أو Supervisor أو Control.

### ما بقي مفتوحاً
- القبول البصري داخل جلسة مالك مصادق عليها، والكمبيوتر والهاتف.
- اختبار مدير عميل مصادق عليه للتحقق من العزل على مستوى التطبيق، دون استخدام بيانات حقيقية غير مصرح بها.
- البحث بالمديرين محدود إلى 1,000 عضوية في استعلام المطابقة الحالي.
- بريد Auth للمدير غير موجود في عقد قراءة count_client_members؛ لا تعرضه الواجهة الحالية، وأي توسعة تتطلب عقد قراءة آمن منفصل.

### التوجيه
تابع القبول المصادق على SHA 9396347d؛ لا تعِد بناء التبويب ولا توسع قاعدة البيانات دون دليل. قفل المرحلة النهائي يتطلب قبولاً بصرياً مصادقاً وتجربة Client Admin، وليس مجرد نجاح CI.

---

## LVE-2026-11-25-777 — تحسين كاميرا ماسح الباركود في Counter

**Last Verified Event:** 25 نوفمبر 2026 — Africa/Cairo  
**الالتزام البرمجي الذي تم تسليمه:** 30d61a5773e2cbeb929bcef68e34d52a651cd05f  
**آخر main وقت إغلاق المرحلة قبل LVE-778:** 255e91ed1598894a6c34f50f0cddbd0caafbaa47  
**التقرير:** Reports/LVE-2026-11-25-777_COUNTER_CAMERA_UX.md

### ما تم تنفيذه
- تحسين لوحة ماسح الكاميرا في Counter وتوضيح حالات الإذن والتشغيل والفشل.
- فحص HTTPS وgetUserMedia وBarcodeDetector وgetSupportedFormats.
- منع تعدد طلبات تشغيل الكاميرا ومعالجة سباق انتهاء الإذن بعد ترك الصفحة.
- إيقاف جميع MediaStream tracks، وإيقاف الفيديو وفصل srcObject.
- الإيقاف التلقائي عند إخفاء الصفحة، ومغادرة تطبيق Counter، أو تغيير التبويب.
- الإبقاء على مسار queueCount والمنطق الأساسي للعد والمزامنة دون تعديل.
- تحديث Service Worker إلى countflow-sw-20261125-5.
- إضافة اختبارات لمخرجات أخطاء الكاميرا وتنظيف البث ودورة حياة المشغل.

### ملفات وCommits
- countflow.html — 52ad9e2d2de40a29dd96b035a841da61a6a2f605
- countflow-sw.js — bc18188d7b1931fc5c7743bca4bb39340aaecc0e
- tests/unit/countflow-quality.test.mjs — c1972db579b2b55dd386c99c42488ac56a406eb4
- إصلاح اختبار Boundary — 30d61a5773e2cbeb929bcef68e34d52a651cd05f
- تقرير المرحلة — Reports/LVE-2026-11-25-777_COUNTER_CAMERA_UX.md

### التحقق وحدود الإثبات
- inline script parse وstatic checks الخاصة بالكاميرا: PASS وقت التنفيذ.
- لم يثبت اختبار جهاز فعلي أو كاميرا هاتف حقيقية ضمن الجلسة.
- لم يختبر نظام الكاميرا في جلسة مصادق عليها على جهاز ميداني.
- لم تضف المرحلة التقاط صورة رف أو تعديل count_shelf_images.
- لم تنفذ كتابة Supabase أو نشر Edge.

### التوجيه
لا تعِد تنفيذ LVE-777. القبول على جهاز فعلي يظل مفتوحاً، وتقرير LVE-777 مرجع التنفيذ لتلك المرحلة.

---

## LVE-2026-11-25-776 — دليل الأصناف الدائم ووحدات المؤسسة

**Last Verified Event:** 25 نوفمبر 2026 (Africa/Cairo).  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`.  
**الفرع:** `main`.  
**نقطة الأساس:** `657c846c309d747d287e688ae1efefb208c8d7a9`.  
**آخر رأس كود اجتاز CI ومطابقة Pages Production:** `648c87fd0e6ee47ab017c27b5cead608fb786dec`.  
**GitHub Actions:** [Run 45537125053 — SUCCESS](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45537125053).  
**تقرير التنفيذ:** `Reports/LVE-776_COUNTFLOW_PRODUCT_CATALOG_UI_20261125.md`.

### ما تم تنفيذه
- مراجعة تبويب `RW_Items` وصفحة تحرير الصنف في مرجع `erp-frontend/companies/company-1/main.html`، وتطبيق نمط قائمة/جدول/فرز/ترقيم وصفحة تحرير مناسبة لطبيعة الجرد، دون تعديل ERP.
- تنظيم تبويب الكتالوج إلى أصناف عالمية ومواءمات مؤسسة.
- إضافة بحث وتصنيف وحالة وفرز وترقيم 50 صفاً لدليل الأصناف العالمي.
- جعل صفحة تحرير الصنف العالمي ذات تبويبات: البيانات الأساسية، الوحدات والتحويل، الصورة.
- حفظ `base_unit` و`units` في الكتالوج العالمي؛ الوحدات البديلة تحفظ بصيغة `{name,factor_to_base}` مع تحقق من المعاملات والأسماء.
- إبقاء الباركود نصاً مستقلاً عن SKU للحفاظ على الأصفار الأولى.
- إتاحة مواءمات SKU/Barcode/Name/Category ووحدات الأساس والتحويلات الخاصة بالمؤسسة عبر RPC `count_upsert_client_product` القائمة.
- حماية ربط مواءمة المؤسسة بملف التكليف من اختلاف client_id، واستعمال `count_attach_catalog_product` الحالي مع معالجة خطأ الصلاحيات.
- توصيل زر «مواءمة جديدة» ومعالجة رفض إدراج الصنف.
- تحديث Service Worker إلى `countflow-sw-20261125-4`.

### القواعد الدائمة
- `count_catalog_products` هو سجل الصنف العالمي الدائم.
- `count_client_products` هو مواءمة المؤسسة الدائمة.
- `count_products` يبقى نسخة نطاق ملف التكليف؛ بيانات الكمية المتوقعة مرتبطة بالتكليف نفسه.
- تغيير التعريف الرئيسي لا يحدث تغييرات تلقائية على أصناف التكليفات الموجودة؛ الربط الجديد يأخذ القيم الفعالة وقت الإدراج.
- لا حذف مادي؛ إيقاف `is_active` يحفظ السجل والتاريخ.

### نتائج التحقق
- قراءة فقط من `information_schema.column_privileges` أكدت أن `authenticated` يستطيع قراءة `count_catalog_products.units` وحقول `count_client_products.units_override/base_unit_override` المطلوبة.
- Node Unit Tests: **72/72 PASS**، صفر إخفاق وصفر skipped.
- Deno Type Check: PASS.
- Cloudflare Pages allowlist build: PASS.
- Playwright production login shell: **3/3 PASS**، ويشمل اختبار مطابقة Pages Production مع SHA `648c87fd0e6ee47ab017c27b5cead608fb786dec`.
- القبول البصري المصادق بحساب المالك ومدير المؤسسة ما زال **OPEN**.

### السلامة
- لا DDL/DML أو Migration أو RLS/GRANT أو RPC/Storage writes.
- لم يتم تغيير أي أصناف/مواءمات/تكليفات/جلسات/عد أو تسوية.
- دفعة QA 90K لم تُمَس.
- لم يتغير ERP أو تطبيق Counter/Supervisor/Control.

### تعليمات الاستكمال
1. نفّذ القبول البصري بحساب المالك ومدير المؤسسة على الكمبيوتر والهاتف.
2. اختبر بحقوق فعلية: عرض الكتالوج، فتح صفحة الصنف، حفظ وحدة/معامل، مواءمة مؤسسة، ورفض إرفاق مواءمة مؤسسة مختلفة.
3. تحقق أن إيقاف صنف لا يحذف سجله ولا ارتباطاته، وأن الجلسات المتكررة تعيد استخدام أصناف ملف التكليف.
4. لا تستخدم بيانات تشغيلية موجودة أو دفعة QA 90K لاختبار الكتابة.
5. لا تنشئ migrations أو جداول جديدة لهذا المسار قبل دليل تقني صريح على أن العقد الحالي لا يكفي.

---

## LVE-2026-11-25-775 — تبسيط تبويب النظرة العامة في Admin

**Last Verified Event:** 25 نوفمبر 2026 (Africa/Cairo).  
**المستودع المعتمد:** `papamohammed77-glitch/rawaea-app-countflow`.  
**الفرع:** `main`.  
**نقطة الأساس:** `c726422ac17c9aeadfe403064334c65aefc5797d`.  
**التزام تعديل الواجهة:** `8c865b69b9f6102e08358d06ffc9f8d024497b51`.  
**آخر رأس main اجتاز CI ومطابقة النشر:** `d7e88201f2ec10f3a600687c6707e6d96d010061`.  
**تقرير التنفيذ:** `Reports/LVE-775_ADMIN_OVERVIEW_SIMPLIFICATION_20261125.md`.

### ما تم تنفيذه
- إعادة ترتيب Overview في `countflow-admin.html` لتظهر افتراضياً: إنشاء عملية جرد، اختيار ملف التكليف، أربعة مؤشرات أساسية، حالة العمليات، وآخر نشاط.
- نقل فلاتر الحالة والتاريخ إلى `<details>` مغلق افتراضياً.
- نقل المؤشرات الثانوية، وإحصاءات ملف التكليف، وجدول أداء العمليات، وملخص الملف والجلسات، وروابط التطبيقات إلى قسم «عرض تفاصيل إضافية» مغلق افتراضياً.
- تقليل أحدث الأنشطة المعروضة من ستة إلى أربعة، واختصار نص حالة Realtime وتخفيف كثافة الألوان والظلال.
- الإبقاء على جميع IDs التي يعتمد عليها منطق العرض، وعلى قراءة `count_operation_overview` ومعادلات التغطية الموزونة ومسار إنشاء العملية القائم.
- تحديث Service Worker إلى `countflow-sw-20261125-2`.
- إضافة اختبار وحدة يثبت بساطة الشاشة الأساسية وأن الأقسام الاختيارية تبدأ مطوية.

### حدود التغيير والسلامة
- تغيير واجهة وCSS واختبار مصدر فقط.
- **لم تُنفذ أي كتابة على Supabase**؛ لا DDL ولا DML ولا RLS ولا RPC ولا migrations.
- لا تغيير على تطبيقات Supervisor أو Counter أو Control أو بيانات الجرد أو التسوية أو دفعة QA 90K.
- لم تتغير صلاحيات المالك أو المستخدمين.

### حالة التحقق
- تم دفع التغييرات إلى `main` في أربعة التزامات متتابعة، دون Force Push، ثم تثبيت التقرير والحالة.
- **GitHub Actions Run 45533832571: SUCCESS** على SHA `d7e88201f2ec10f3a600687c6707e6d96d010061`.
- Node Unit Tests: **68/68 PASS**، صفر إخفاق وصفر skipped.
- Deno Type Check لوظيفتي Edge: PASS.
- Cloudflare Pages allowlist build: PASS.
- Playwright production login shell: **3/3 PASS**، واختبار مطابقة Pages Production أكد SHA `d7e88201f2ec10f3a600687c6707e6d96d010061`.
- لا تشمل النتائج اختبار واجهة Overview داخل جلسة مصادق عليها.
- **القبول البصري المصادق بحساب المالك على الكمبيوتر والهاتف ما زال OPEN**؛ لا تدّعِ اختباره اعتماداً على اختبارات المصدر أو غلاف الدخول العام.

### تعليمات الاستكمال
1. نتيجة CI النهائية لهذا التغيير مثبتة بالفعل في Run 45533832571؛ لا تكرر الاختبارات دون تغيير مصدر جديد.
2. نفّذ القبول البصري بحساب المالك على الكمبيوتر والهاتف: فتح/إغلاق «تصفية متقدمة» و«عرض تفاصيل إضافية»، وتغيير ملف التكليف وتحديث المؤشرات.
3. تحقق من بقاء زر «إنشاء عملية جرد» على مساره القائم فقط؛ لا تنشئ جلسة أو سجلات عدّ تجريبية أثناء القبول.
4. لا تعِد تصميم التبويب من الصفر ولا توسع المهمة إلى التطبيقات الأخرى قبل إغلاق القبول البصري.

---

## LVE-2026-11-25-774 — توحيد CountFlow داخل المستودع المعتمد main

**Last Verified Event:** 25 نوفمبر 2026 (Africa/Cairo).  
**Canonical repository:** `papamohammed77-glitch/rawaea-app-countflow`.  
**Canonical branch:** `main`.  
**Baseline before consolidation:** `2ddb76447949532c342ff2e755e049b1927aacef` (LVE-771؛ إصلاح Admin bootstrap 403 محفوظ).  
**Supabase:** `rawaea-staging` / `hfzznsiprnwkpayskzhu`.  
**Pages Production origin:** `https://rawaea-app-countflow.pages.dev` (إعداد main auto-deploy موثق في DEPLOYMENT).

### ما تم توحيده في main
- نقل Admin المطوّر من فرع LVE-765/LVE-772، مع الحفاظ على الإسقاط الآمن للمشاريع: `id, client_id, name, code, status, created_at, updated_at`؛ لا `created_by` ولا `select('*')`. منح عمود `client_id` موجود ضمن ملف migration مستعاد.
- إضافة شاشة `countflow-control.html` للمراجع بصلاحية قراءة فقط وربطها ببوابة الدخول وقائمة النشر المسموح وService Worker.
- نقل تحسينات المشرف والإسناد والاستعراض التفصيلي، مع تحديثات Counter غير المتعلقة بالكاميرا.
- نقل وظيفتي `counting-export-session` و`counting-provision-member` بعقود Tenant/Role، مع اختبارات المصدر التي تغطيها.
- تحديث `scripts/build-pages.sh` ليضم Control فقط ضمن ملفات الويب؛ لا ينسخ SQL أو Functions أو Tests إلى Pages.
- إضافة تقارير LVE-765 Admin وLVE-768 وLVE-769 وLVE-772 داخل `Reports/` القائمة.
- إضافة 16 ملف SQL مستعاداً من سجل الإصدارات الفعلي إلى `database/migrations/`؛ أرقام الملفات تطابق أرقام الإصدارات. لا migration أُعيد تشغيلها.
- تحديث README وDEPLOYMENT وREADME الترحيلات ومسارات اختبارات SQL. لا submodules أو مستودعات أو مجلدات جذر إضافية.

### نتائج التحقق على main بعد النقل

**آخر رأس كود/اختبار معتمد:** `49fac8199848d3d7746190b1e82ba362b5193048`.  
**GitHub Actions:** [Run 45532142488 — SUCCESS](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45532142488).

- Node Unit Tests: **67/67 PASS**، صفر إخفاق وصفر skipped.
- Deno Type Check لوظيفتي Edge الموجودتين: PASS.
- Cloudflare Pages allowlist build: PASS.
- Playwright: **3/3 PASS**؛ شملت مطابقة `build-info.json` في Production مع SHA المصدر، وغلاف الدخول RTL على الهاتف، وغلاف دخول Admin دون جلسة مصادقة.
- Cloudflare Pages Preview على Commit `49fac81`: https://0eac720a.rawaea-app-countflow.pages.dev — Deploy success.
- اختبار مطابقة SHA أكد أن Production يخدم `49fac8199848d3d7746190b1e82ba362b5193048`.
- اختبارا دخول Supervisor/Counter المصادقان واختبار مسح الباركود ظلت خارج تنفيذ Playwright في CI لعدم توفير أسرار/بيئة E2E تشغيلية؛ لا يُدّعى نجاح E2E المصادق للأدوار الأربعة. اختبار تبويبي Supervisor موجود في المصدر ومكتشف، لكن لا تنفذه بوابة `production login shell` الحالية.
- أُضيف تقرير LVE-752 إلى `Reports/FINAL_EXECUTION_REPORT_LVE-752.md`، وأضيفت assertions لتبويبي المراقبة والفريق في `tests/e2e/smoke.spec.ts`. تم الحفاظ على اختبار 90K rollback المحسّن في main ولم يُنفذ.

### حدود القبول التشغيلي

- الكاميرا: UI غير منشور؛ حاوية `shelf-images` عامة (public=true). مصدر SQL محفوظ، لكن لا ترفع أو تعرض صور رفوف قبل حل الخصوصية وروابط العرض الموقعة واختبار E2E مصادق.
- Offline/Sync على أجهزة فعلية، التقاط كاميرا حقيقي، اختبار Barcode Hardware، فتح ملف XLSX نهائي وفحص الصور المضمنة، وتدفق التشغيل المصادق عبر Admin/Counter/Supervisor/Control: **UNVERIFIED / OPEN**.
- لا توجد أي كتابة على Supabase نتيجة النقل؛ لا تُستعمل دفعة 90K لاختبار الوظائف.

### حدود PR والتنظيف

- PR #8 أُغلق دون دمج لأنه أصبح superseded بعد نقل التغييرات إلى `main`؛ رأسه القديم لا يُدمج.
- PR #6 للكاميرا بقي Draft / Open بسبب حاجز الخصوصية.
- فروع العمل الأخرى محفوظة مؤقتاً للتدقيق؛ لا تحذفها ولا تحذف المستودعات الثلاثة الأخرى قبل جرد تبعياتها وموافقة المالك. المستودعات الأخرى تخص ERP/الحوكمة/المراجعة وليست بدائل CountFlow.

**Readiness:** الشفرة وملفات النشر المنقولة إلى `main` اجتازت CI وPages وProduction SHA parity. هذا لا يساوي إغلاق E2E المصادق أو ميزة صور الرفوف؛ تبقيان غير مقبولتين حتى التحقق الفعلي.

---
## LVE-2026-11-24-771 — Admin bootstrap 403 / count_projects SELECT projection fix

**Last Verified Event:** 24 November 2026 (Africa/Cairo).  
**Report:** `Reports/LVE-771_ADMIN_BOOTSTRAP_403_PERMISSION_FIX_20261124.md`.  
**Branch:** `main`.  
**Commits:** Admin projection `13c3cb32b22bc53cb63ba9f8942c6240e763c78b`; Service Worker `41c2b5c3e67c0ab18c905ab6b018d04af6ccac29`; regression test final `c7172128a5426cf904790ff95473d27cdb889a47`; detailed report `dee4eeeb99d29355dba520a916cfaeba2cc96b89`. Final verified code/test head: `c7172128a5426cf904790ff95473d27cdb889a47`.

### Confirmed cause
- `main/countflow-admin.html` requested `created_by` in `loadProjects()`.
- `created_by` is deliberately denied to `authenticated` to preserve platform-owner identity privacy.
- The app did not use this field in rendering; the request alone caused HTTP 403 / SQLSTATE 42501 and aborted Admin bootstrap.
- The newer work branch already used the operational projection and was not the source of the user's running request; main was stale.

### Applied fix
- Admin project projection now selects only `id,name,code,status,created_at`.
- Preserved the RLS policy and column-level owner-identity hiding. No broad `GRANT SELECT ON count_projects` and no grant of `created_by` were applied.
- Added a regression test forbidding `created_by` / `select('*')` in Admin project bootstrap.
- Incremented Service Worker cache build from `countflow-sw-20261120-2` to `countflow-sw-20261124-2` so the stale Admin shell cache is retired on activation.

### Verification
- Authenticated owner JWT simulation with `SET LOCAL ROLE authenticated` and `ROLLBACK`: PASS.
- Safe project query succeeded and returned 1 visible project.
- `created_by` SELECT remained false; all required projection columns were allowed.
- Source was re-read from main; Admin query and Service Worker build marker matched the repair.
- GitHub Actions run `45481868275`: **COMPLETED / SUCCESS**. Node 42/42; Deno type-check PASS; Pages allowlisted build PASS; Playwright 3/3 PASS, including production Pages SHA parity against `c7172128a5426cf904790ff95473d27cdb889a47` and public RTL login shell checks.
- Cloudflare Pages deployment and exact main SHA parity were verified in Playwright. Interactive owner-password entry in the user's own browser was not performed; the secured SQL project query was separately verified under authenticated owner JWT.

### Safety
No business rows, Auth identities, import jobs, count entries, sessions, stock/accounting data or Production ERP data were modified.

**Status:** CLOSED — root cause removed; least-privilege preserved; authenticated owner SQL/JWT projection PASS; CI PASS; Pages source-SHA parity PASS; production login-shell Playwright 3/3 PASS. Do not grant table-wide SELECT or expose `created_by` as a workaround.

---

# CountFlow — CURRENT_STATE

## LVE-2026-11-23-764 — Product image reference hardening (E2E GATE OPEN)

**التاريخ:** 23 نوفمبر 2026 (Africa/Cairo)  
**المستودع:** papamohammed77-glitch/rawaea-app-countflow  
**Supabase:** rawaea-staging / hfzznsiprnwkpayskzhu  
**Baseline main:** b4d19ac4fbcfd5c800d1019e42bd6d282d42c829  
**فرع العمل:** work/lve-764-product-image-urls  
**PR:** #5 — Draft / Open / Not merged  
**Application commit:** `b09b0920d519ead01787011e604a100a5083c649`  
**Migration-source/documentation commit:** `ea8553583258b6bab6b8d6da1d1f15524cd757ef`  
**Latest confirmed docs/Advisor snapshot before this report refresh:** `1baa2fc756ea95a4b96bba9e4e7fc6b602fbd4bf`.

### آخر تنفيذ فعلي لـLVE-764 — 23 نوفمبر 2026 (3/5 PASS، E2E ما زال مفتوحًا)

- **PASS — Storage upload:** رُفع JPEG فعلي 96×72 إلى `counting-product-images` باستخدام Supabase Storage API من Edge Function مؤقتة، مع `service_role` محفوظ في بيئة الخادم؛ سجل Storage: POST `HTTP 200`، طلب `2,283 bytes`، Object ID `f8ef7b0c-fc0f-4fad-a849-880b1e9dab41`، Version `7b65f830-7ab0-4535-865e-d266f4e3a1b8`، MIME `image/jpeg`.
- **PASS — Product link/trigger:** الصنف `QA 90K Product 421` (`005d0a73-1d11-4833-80f2-1f4ab18ba705`، SKU `QA90K-000421`) يحفظ الآن object key الدائم `10ade334-e211-4a32-a0bd-41f7bf41eb1d/products/lve764-test-image.jpg`؛ UPDATE/RETURNING نجح، أي إن Trigger قبل المرجع بعد وجود الملف ونوعه وحجمه.
- **PASS — Signed URL/GET:** أُنشئ Signed URL بمدة `3600s`؛ سجل Storage أثبت GET `HTTP 200`، `image/jpeg`، `2,283 bytes`، مع انتهاء بعد ساعة. تنزيل المصنف المؤقت تحقق من SHA-256 بين بايتات المصدر/Storage/Signed GET قبل اكتمال تحديث المنتج وتنظيف الملف السابق.
- **OPEN — Admin/Counter display:** لم يُنفذ بحث تفاعلي أو تحقق بصري في Admin أو Counter؛ اتصال Browser المتاح يقرأ الصفحة فقط ولا يتيح النقر أو إدخال بيانات أو لقطات شاشة.
- **OPEN — Client Balance XLSX:** لم يُنفذ التصدير الفعلي ولم تُفحص `xl/media`. وظيفة التصدير تشترط Bearer token صالحًا لمستخدم Auth مؤكد بالبريد `owner@rawaea.com`، وتفرض وجود تسوية `approved`. الاستدعاء باستخدام anon أعاد `401 INVALID_USER_TOKEN`؛ الجلسة الحالية `QA 90K Product Catalogue` لا تزال `planned` ولا توجد إسنادات أو تسوية معتمدة.
- **حالة الأمان بعد الاختبار:** الدلو ما زال `private`؛ سياسات anon المؤقتة أزيلت، وإضافة Postgres `http` أزيلت، والتحقق الحي أكد صفر سياسات مؤقتة وصفر إضافة HTTP. نقطة `lve764-image-ingest-once` المؤقتة رُقّيت إلى v3 مع `verify_jwt=true` واستجابة 410 غير تشغيلية؛ لا تبقى نقطة رفع عامة قابلة للاستخدام. لا توجد كتابة مباشرة في `storage.objects`؛ تم الرفع عبر Storage API.
- **القرار:** لا تغلق LVE-764 ولا تدمج PR #5 حتى إكمال Admin thumbnail وCounter lookup/recount وXLSX media inspection. لا تُعد رفع نفس الكائن ولا تغيّر صنفًا آخر؛ أكمل على الصنف/الكائن المحددين أعلاه.
### الحالة
### معيار بيانات الأصناف (معيار إلزامي)

**1) الأصناف العالمية (Global Items)**
- يُستخدم الباركود الدولي EAN/UPC بوصفه مُعرّف المسح الأساسي للصنف العالمي، ويكون العد بالمسح الضوئي متى توفر الباركود.
- يُخزن الباركود كنص `TEXT` لا كرقم؛ يجب الحفاظ على الأصفار في بداية القيمة وعدم تحويله إلى صيغة علمية أو إزالة أرقامه.
- لا يُستبدل الباركود العالمي بـSKU الداخلي؛ لكل منهما حقل ووظيفة مستقلة.

**2) الأصناف المنتجة داخل المنشأة (In-house Items)**
- تشمل أمثلة ذلك المخبوزات واللحوم (Bakery / Meat).
- تُدار الكمية بالوزن باستخدام `Kg/Grams` (كيلوجرام/جرام)، مع تحديد وحدة أساس واحدة واضحة لكل صنف.
- يكون التعرف على الصنف عبر باركود داخلي عند توفره؛ وإلا فيُستخدم اختيار/إدخال يدوي واضح للصنف قبل إدخال الوزن، دون تسجيل كمية على صنف غير محدد.

**3) وحدات القياس والتحويل (UoM)**
- لكل صنف `base_unit` واحدة، وتُسجل الوحدات البديلة في `count_products.units` كعوامل تحويل إلى وحدة الأساس (`name`, `factor_to_base`).
- مثال إلزامي: إذا كانت وحدة الأساس `piece` فإن `Box = 12 pieces` وتُحفظ قيمة `factor_to_base = 12`.
- مثال الوزن: إذا كانت وحدة الأساس `kg` فإن `gram = 0.001 kg`؛ وإذا كانت وحدة الأساس `g` فإن `kg = 1000 g`.
- أي معادلة شراء/بيع/تكلفة أو إجمالي مالي يجب أن توحّد الكميات إلى وحدة الأساس قبل الجمع أو المقارنة. إذا كان سعر الشراء لوحدة `Box` ذات عامل 12، فإن تكلفة القطعة الأساسية = سعر الصندوق ÷ 12، وإجمالي السطر = عدد الصناديق × سعر الصندوق (أو الكمية الأساسية × تكلفة الوحدة الأساسية)، مع منع تطبيق عامل التحويل مرتين.
- يجب أن تبقى قيم الباركود نصية، والكميات ومعاملات التحويل أرقامًا عشرية دقيقة مناسبة للوزن؛ لا تستخدم التقريب المبكر الذي يغير الإجمالي.
- المخطط وواجهة Admin الحاليان يدعمان `base_unit` و`units` وعامل التحويل، كما أن استيراد الكتالوج يتعرف على `purchase_unit`, `purchase_unit_cost`, `unit_factor_to_base`. توثيق هذا المعيار لا يُعد بحد ذاته إثباتًا لاختبار كل مسارات احتساب التكلفة؛ يجب أن تُختبر الصيغ المالية عند تفعيلها أو ربطها بتقارير مالية.

**4) صور الأصناف (Item Images)**
- الصورة مطلوبة لكل صنف في الكتالوج التشغيلي؛ لا تُستخدم صور placeholder ولا روابط مولدة لإخفاء غياب الصورة.
- يُخزن في `image_url` مرجع دائم (Storage object key) على النمط `<project UUID>/products/<filename>`، وليس رابطًا موقعًا مؤقتًا أو رابطًا عامًا.
- Supabase Storage يحتفظ بالملف الأصلي؛ يرفع Admin كائن `File` مباشرةً إلى Storage API دون Canvas أو إعادة تحجيم أو ضغط أو تحويل للصورة. لا تُطبق transformations عند الرفع أو الحفظ؛ بذلك لا يحدث فقد في البكسلات/الدقة أو تغيير في bytes الملف الأصلي.
- حد التطبيق الحالي للصورة هو JPEG أو PNG وبحجم أكبر من صفر وحتى 1 MiB، لتمكين تضمينها في Excel. لا يعني هذا ضغط الملف؛ تُحفظ البايتات الأصلية كما هي ضمن حد القبول.
- تُنشأ Signed URLs قصيرة العمر وقت العرض فقط في Admin وCounter، وعند جلب الملف داخل عملية تصدير XLSX. لا يُكتب Signed URL في `image_url` ولا يُخزن في خلايا Excel؛ ملف Excel يأخذ bytes الصورة المضمنة عند التصدير.

**حالة البيانات بعد اختبار LVE-764:** 41,000 صنف؛ صنف واحد فقط لديه `image_url` (fixture الاختبار `QA90K-000421`)؛ وكائن واحد داخل `counting-product-images`. بقية الكتالوج لا تزال بلا صور؛ معيار «كل الأصناف مصورة» لم يتحقق على مستوى الكتالوج.

- image_url موجود مسبقًا كـ nullable text؛ لا تضف عمودًا جديدًا.
- توجد 41,000 سجلات منتجات؛ يوجد image_url واحد فقط لصنف الاختبار QA90K-000421، وكائن واحد داخل الدلو الخاص (public=false). لم تتم تعبئة بيانات الأصناف الأخرى أو إنشاء placeholders.
- migration 20261123182553 (countflow_product_image_reference_hardening_v1) وmigration 20261123182644 (countflow_reject_ephemeral_product_image_urls_v1) مطبقتان بالفعل.
- Storage policies حصرت قراءة/رفع/تحديث الصور في نمط <project UUID>/products/<single filename> مع الحفاظ على أدوار المالك/المشرف/العضوية.
- validator server-side وtrigger على count_products يمنعان المراجع غير الصالحة، traversal، المسارات خارج products، والملفات غير الموجودة/غير JPEG-PNG/أكبر من 1 MiB. مرحلة stage تتحقق من شكل المسار؛ مرحلة commit تتحقق من وجود الملف.
- signed URLs المؤقتة ممنوعة داخل image_url. المرجع الدائم هو object key، ثم يُوقّع عند العرض.
- Admin كان يملك أصلًا thumbnail ورفع/معاينة؛ تم تضييق المراجع والتحقق من HTTPS وإعطاء الملف المختار أولوية على أي URL قديم.
- Counter يستخدم resolver موحدًا للبحث العادي وإعادة العد، signed read من الدلو الخاص فقط، fallback، وحماية من ردود async قديمة.
- Client Balance XLSX لا يزال يضمّن bytes الصور داخل المصنف وفق حدوده الحالية؛ مسار التحميل مقيد الآن إلى مجلد منتجات المشروع.

### التحقق
- CI #203 / 45240309793 على SHA `ea8553583258b6bab6b8d6da1d1f15524cd757ef`: SUCCESS.
- CI #204 / 45240926256 على SHA `4cd281e19f11aed47621bcbcd493aa9ae0da5000`: SUCCESS.
- CI #208 / 45254320320 على SHA `57260b7872db2acf941f2d595b82969a5b2dbc6c`: SUCCESS. آخر بوابة فرع تشمل 41/41 Node PASS، Deno type-check PASS، Cloudflare Pages build PASS، وPlaywright 2 PASS / 1 SKIPPED لاختبار مطابقة نشر Production مع main على فرع PR.
- CI #210 / 45254617954 على SHA `193b8362f09c744f2827620f22e8194a2fba4ddf`: SUCCESS، 41/41 Node، Deno، Pages، Playwright 2 PASS / 1 SKIPPED.
- CI #211 / 45255276526 على SHA `1baa2fc756ea95a4b96bba9e4e7fc6b602fbd4bf`: SUCCESS، 41/41 Node، Deno، Pages، Playwright 2 PASS / 1 SKIPPED.
- CI #212 / 45255695241 على SHA `15bb46ae90f309a076df423ed79645b6f9f37066`: SUCCESS، 41/41 Node، Deno، Pages، Playwright 2 PASS / 1 SKIPPED. شمل ذلك آخر `CURRENT_STATE.md` ونسختي التقرير.
- CI #213 / 45256146718 على SHA `28c064715f8222afb3eb8121f09badd84bde39ce`: SUCCESS، 41/41 Node، Deno، Pages، Playwright 2 PASS / 1 SKIPPED. التحقق يشمل تقرير التسليم وملف الحالة ونسخة Reports.
- CI #214 / 45256686296 على SHA `84a0604e4ef2650d240753ea1d8b73968a43121a`: SUCCESS، 41/41 Node، Deno type-check، Pages build، Playwright 2 PASS / 1 SKIPPED.
- CI #215 / 45261684859 على SHA `0a683652c639dbaca8d4cc8cb13301bb83a95e0b`: SUCCESS.
- CI #216 / 45263648027 على SHA `5cf597e0eb2e1e5a1805e2fd07ef1d915eeee72d`: SUCCESS. كانت هذه بوابات CI للشفرة والوثائق، وليست بديلًا لاختبارات Admin/Counter/XLSX التشغيلية المفتوحة.
- هذه اختبارات الشفرة والغلاف العام؛ ليست اختبار رفع صورة بجلسة مصادق عليها ولا تحقق تضمين XLSX لصورة فعلية.
- تحقق Supabase الحي بعد الاختبار: Storage logs توثق upload POST 200 (role=service_role، 2,283 bytes)، authenticated GET 200، signed GET 200 (image/jpeg، 2,283 bytes)، ثم حذف ملف المحاولة السابقة عبر Storage API 200. فحوص SHA-256 داخل الرفع المؤقت شرطت تطابق المصدر/التخزين/Signed GET قبل تحديث الصنف والتنظيف؛ حذف الملف السابق يؤكد اجتياز تلك الحواجز البرمجية. UPDATE للصنف عبر Supabase client نجح، والقيمة الدائمة هي object key. الدلو private، object count=1، image_url count=1. أزيلت جميع سياسات LVE-764 المؤقتة وإضافة HTTP (صفر متبقٍ)، وأُغلقت نقطة الرفع المؤقتة (v3 verify_jwt=true, 410).

### نتائج Supabase Advisor ذات الصلة (فحص قراءة فقط)
- جميع جداول CountFlow الـ23 ذات البادئة `count_*` في schema `public` لديها RLS مفعّل وسياسة واحدة على الأقل؛ لا يوجد بينها جدول أبلغ Advisor عن تعطيل RLS له.
- Validator الصور الخاص `counting_private.is_valid_product_image_reference` ودالة Trigger `counting_private.enforce_count_product_image_reference` لا تمنحان EXECUTE لـanon أو authenticated.
- فحص المشروع بأكمله أظهر تحذيرات/أخطاء قائمة خارج مسار الصور: 65 جدولًا عامًا بلا RLS (لا تشمل جداول `count_*`)، و5 دوال SECURITY DEFINER عامة قابلة لـanon (أسماء legacy غير CountFlow)، و14 دالة SECURITY DEFINER قابلة لـauthenticated، منها خمس RPCs تشغيلية CountFlow قديمة. هذه لم تُعدّل ضمن LVE-764 وتحتاج مراجعة أمان مستقلة قبل إتاحة المشروع لعملاء خارجيين.
- Advisor أظهر أيضًا تحذير حماية كلمات المرور المسرّبة و64 index غير مستخدم ومؤشرًا مكررًا واحدًا على `erp_operation_registry`. لم تُجرَ تغييرات عليها لأنها خارج نطاق LVE-764 وتتطلب مراجعة منفصلة.
### بوابة الإغلاق المفتوحة

- **PASS (1):** رفع JPEG فعلي عبر Storage REST إلى `10ade334-e211-4a32-a0bd-41f7bf41eb1d/products/lve764-test-image.jpg`؛ HTTP 200.
- **PASS (2):** ربط الصورة بالصنف `005d0a73-1d11-4833-80f2-1f4ab18ba705` / `QA90K-000421`، وتأكيد قبول Trigger للـobject key الدائم.
- **PASS (3):** Signed URL لمدة 3600 ثانية؛ GET HTTP 200، Content-Type image/jpeg، والحجم 2,283 bytes وJPEG magic ffd8ff.
- **OPEN (4):** لم يتم التحقق تفاعليًا من thumbnail في Admin وCounter أو البحث العادي/إعادة العد؛ Browser read-only.
- **OPEN (5):** لم يتم تصدير Client Balance XLSX ولم يتم فحص وجود الصورة داخل `xl/media`. استدعاء Edge Function دون جلسة مستخدم حقيقية أعاد 401 INVALID_USER_TOKEN؛ الوظيفة تتطلب مالك المنصة المؤكد وجولة تسوية approved.
- لا تُدمج أو تنشر PR #5 قبل نجاح الخطوتين 4 و5. الدلو خاص، والسياسات المؤقتة وإضافة HTTP أزيلتا، ولا توجد صلاحية anon مؤقتة متبقية.
- لا تُدرج/تحدّث `storage.objects` مباشرة؛ استخدم Storage API فقط. حافظ على كائن الاختبار والصنف المحددين أعلاه حتى إكمال العرض والتصدير، ولا تنشئ كائنًا ثانيًا أو تغيّر منتجًا آخر بلا ضرورة.
### تعليمات المساعد التالي
1. استكمل من LVE-764 وPR #5 والفرع `work/lve-764-product-image-urls`؛ لا تبدأ من الصفر ولا تُعد تطبيق migrations.
2. استخدم كائن الاختبار الموجود: `10ade334-e211-4a32-a0bd-41f7bf41eb1d/products/lve764-test-image.jpg` والصنف `QA90K-000421`؛ لا تكرر الرفع أو تنشئ object بديلًا.
3. أكمل عرض Admin وCounter (lookup + recount) بجلسة Auth/Browser تفاعلية، ثم Client Balance XLSX بعد استيفاء owner-auth وapproved reconciliation، وافحص `xl/media`؛ وثق HTTP/screenshots/metadata.
4. لا تُغيّر كلمة مرور مالك قائم أو تتجاوز مصادقة Edge Function أو تنشئ قيود/تسوية تشغيلية لمجرد اجتياز التصدير. استخدم مسار QA مصرحًا ومخططًا له.
5. حدّث CURRENT_STATE والتقرير بعد إثبات الخطوتين 4 و5، ثم فقط انقل PR من Draft للدمج. لا تنتقل للمهمة التالية قبل الإغلاق.

---
## LVE-2026-11-23-763 — Gamification server-backed for Counter

**التاريخ:** 23 نوفمبر 2026 (Africa/Cairo)  
**النطاق:** `countflow.html` + migration CountFlow-only + tests/docs.  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`.  
**Supabase:** `rawaea-staging` / `hfzznsiprnwkpayskzhu`.  
**الدمج:** PR #3 (`e34f90c077b068a4dbe8bb0cd79f52f0a10d0b71`) وPR #4 (`f26b8b6c0e91bfe626e997e2f654cf6df2905516`) مدمجان إلى `main`.

### التصميم المعتمد
- رُفض عمود `count_members.points` المقترح لأن أعضاء الجرد لا يملكون UPDATE لعضويتهم؛ وإضافة العمود ثم زيادة النقاط من JavaScript ستفتح تلاعبًا أو تحتاج توسيع صلاحيات غير مقبول.
- النقاط مشتقة على الخادم من عمليات العد المحفوظة فقط: 10 نقاط لكل تركيبة صنف/موقع فريدة من أول جولة عد للمندوب (`recount_task_id IS NULL`, `count_round=1`, `revision=1`). إعادة المسح لنفس الصنف/الموقع وإعادة العد لا تضيف نقاطًا إضافية.
- التقدم يحسب من `count_expected_balances` ومن نطاق `count_assignments` الفعلي؛ إذا لم توجد أرصدة مستهدفة، تعرض الواجهة «غير متاح» بدلاً من نسبة مخترعة.
- لوحة الصدارة تخص المندوبين في العملية الحالية، وتعرض أفضل 10 والمندوب الحالي إذا كان خارجها. الترتيب بنسبة إكمال نطاق المندوب أولاً ثم النقاط.
- أضيفت شارات إنجاز 10 و50 و100 أصناف/مواقع فريدة، وشارة إكمال كامل نطاق المندوب. لم تُضف مكافأة «الأسرع» حتى لا تحفز السرعة على حساب دقة العد.
- لا يوجد كيان فرق/إسناد فريق مستقل في المخطط الحالي؛ لذلك لم تُنشأ لوحة فرق وهمية أو تُستخدم المواقع كبديل غير صحيح للفرق.

### ما نُفّذ في Supabase
- Migration `countflow_gamification_snapshot_v1` مُطبقة بالفعل؛ سجل Supabase: `20261123173951`.
- المصدر المتتبع: `database/migrations/20261123173951_countflow_gamification_snapshot_v1.sql`.
- الدالة الخاصة `counting_private.count_gamification_snapshot(uuid)` هي `SECURITY DEFINER` مع `search_path=''`، وتتحقق من `auth.uid()` وعضوية نشطة بدور `counter` في الجلسة.
- أضيف حارس مشاركة مستقل `counting_private.assert_gamification_session_participation(uuid)` (ledger `20261123174943`): يتأكد أن المستخدم عضو `counter` نشط في جلسة مفتوحة/قيد المراجعة، وإذا كانت للجلسة إسنادات فلا يكفي الانتماء للمشروع؛ يجب أن يملك العضو إسنادًا نشطًا/مُسندًا في الجلسة ذاتها. الـRPC العام يستدعي الحارس قبل إرجاع الملخص. المصدر المتتبع: `database/migrations/20261123174943_countflow_gamification_session_assignment_guard_v1.sql`.
- RPC العام `public.count_get_gamification_snapshot(uuid)` هو `SECURITY INVOKER`. تم سحب EXECUTE من PUBLIC وanon ومنح authenticated فقط للدالتين؛ فحص ACL حي أكد anon=false وauthenticated=true.
- اختبار نداء RPC من سياق قاعدة بيانات بلا هوية أعاد `AUTH_REQUIRED`، كما ينبغي. لا تنشئ الدالة صفوفًا أو تغيّر نقاطًا دائمة أو أرصدة أعمال.

### واجهة Counter
- أضيف شريط نقاط وتقدم، وتبويب «إنجازاتي» يحوي لوحة الصدارة والشارات وتقدم نطاق المندوب.
- تُحدّث البيانات بعد نجاح المزامنة، وبعد حفظ العد المتصل، وعند فتح تبويب الإنجازات، وعند عودة الصفحة من الخلفية، وبفاصل دوري 20 ثانية.
- عند انقطاع الشبكة لا تمنح الواجهة نقاطًا للصفوف المحلية؛ تعرض حالة عدم الاتصال وتنتظر قبول عملية العد من الخادم.
- تم منع تكرار طلب snapshot للجلسة/العضو نفسيهما، وإبطال الردود القديمة عند تبديل العضوية حتى لا تعرض بيانات المشروع السابق.

### اختبارات وحدود الإثبات
- أضيفت ثلاثة اختبارات مصدرية للميزة: RPC فقط دون زيادة محلية، حساب نقاط first-count الفريدة، وحارس منع العضو غير المسند من طلب لوحة جلسة ذات إسنادات.
- فحص ACL/الدوال الحي اجتاز: anon EXECUTE=false وauthenticated EXECUTE=true للدوال العامة والخاصة؛ نداء بلا هوية رُفض بـ`AUTH_REQUIRED` بعد تشغيل حارس المشاركة.
- **PASS — CI main #200 / run `45232321254`** على التطبيق SHA `f26b8b6c0e91bfe626e997e2f654cf6df2905516`: 38/38 اختبار Node، Deno type-check، Pages allowlisted build، وProduction Playwright 3/3؛ اختبار `build-info.json` طابق Cloudflare Production مع SHA `f26b8b6`.
- حالة قاعدة CountFlow الحالية عند التنفيذ: 0 أرصدة مستهدفة، 0 إدخالات عد، 0 أعضاء Counter نشطين، 0 جلسات مفتوحة. لذلك لا توجد بيانات تسمح باختبار ترتيب/إكمال حقيقي أو تسجيل دخول ميداني E2E دون إنشاء بيانات عمل اصطناعية؛ لا يُدّعى اختبار authenticated leaderboard ببيانات حقيقية.
- لم تُمس تطبيقات النظام الأم أو المشرف في LVE-763؛ نطاق الواجهة المضاف حصريًا هو `countflow.html`. لم تُنشأ سجلات أعمال أو حسابات أو جلسات أو أصناف أو عمليات عد، ولم تُمس دفعة QA ذات 90,000 صف.
- لم يُستخدم مشروع SMART ERP، ولم تُنشأ سجلات أعمال أو حسابات أو جلسات أو أصناف أو عمليات عد. دفعة QA ذات 90,000 صف لم تُلمس.

---

## LVE-2026-11-23-762 — P0/P1 revalidation + Export Edge v15 source parity

**التاريخ:** 23 نوفمبر 2026 (Africa/Cairo)  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow` فقط.  
**قاعدة CountFlow:** `rawaea-staging` / `hfzznsiprnwkpayskzhu` فقط.  
**Git main baseline قبل تحديث هذا السجل:** `d72f67afc5deba27eea5c027ede469a4c5d15161`.  
**نطاق التغيير:** نشر إصدار جديد من وظيفة التصدير الحالية، وتحديث توثيق النشر/الحالة؛ لم تتغير صفحات التشغيل أو SQL أو بيانات CountFlow.

### 1. Phase 1 — P0 security & role enforcement: VERIFIED ALREADY, NO DUPLICATE MIGRATION

- القراءة الحية لـRLS أكدت أن `count_projects` INSERT يشترط `created_by = auth.uid()` و`counting_private.is_platform_owner()`.
- `public.count_create_engagement(text,text,text)` حاليًا **SECURITY INVOKER**، ويتحقق أولاً من `counting_private.is_platform_owner()` قبل إنشاء التكليف وأول عملية؛ `anon EXECUTE=false` و`authenticated EXECUTE=true`.
- `counting_private.is_platform_owner()` يربط `auth.uid()` بمستخدم Supabase Auth ذي البريد المؤكد `owner@rawaea.com`؛ لا يعتمد على user_metadata أو بريد يرسله العميل.
- سياسة `count_entries` INSERT تشترط عضوية `counter` نشطة للمشروع نفسه، جلسة active، جهازًا معتمدًا، ونطاق الموقع. لذلك auditor لا يستطيع العد عبر RLS.
- `public.count_record_entry(...)` SECURITY INVOKER ويتحقق من دور `counter` وحالة العضوية والجلسة والجهاز؛ و`public.count_record_recount_entry(...)` يستدعي `counting_private.record_recount_entry(...)` SECURITY DEFINER، والتي تتحقق صراحة من `auth.uid()` و`role='counter'` النشط وتطابق `assigned_member_id` وحالة المهمة والجلسة والجهاز قبل الإدخال. لا يوجد مسار إعادة عد للمراجع.
- سياسات الإدخال/التحديث/الحذف على `count_members`, `count_sessions`, `count_import_batches`, `count_import_rows`, `count_recount_tasks` owner-only؛ أما كتابة المشرف فتقتصر على `count_assignments` وفق نطاقه.
- `Countflow-supervisor.html` يحتوي تبويبي المراقبة اللحظية والفريق فقط؛ عمليات الكتابة فيه إسناد/إخراج عضو من العملية عبر `count_assignments`. لا توجد واجهات أو نداءات إنشاء تكليف/حساب/استيراد/كتالوج أو صلاحيات Admin.
- `countflow.html` يحمّل العضويات النشطة بدور `counter` فقط، ويستخدم RPCs العد وإعادة العد؛ حارس RLS يؤكد قيد الدور على الخادم.
- **القرار:** لم أكرر ترحيل P0/LVE-749 أو أعدل سياسات RLS لأن القيود الحية المطلوبة موجودة. لا تغيير على Schema/ACL/roles أو بيانات التشغيل في هذه المرحلة.

### 2. Phase 2 — Import & products virtualization: EXISTING IMPLEMENTATION RECONFIRMED

- `countflow-admin.html` الحالي يتضمن CSV عبر Papa Parse `step` مع pause/resume، وقارئ XLSX تدفقي على Blob chunks؛ لا يعتمد على `arrayBuffer()` للملف الكامل أو `Papa.parse(file)` غير التدفقية.
- استيراد العمليات يقسم البيانات إلى دفعات خادمية 1,000 صف؛ الحقول الاختيارية/المفقودة والأخطاء الجزئية تُعالج على مستوى الصف وتظهر كتحذيرات/رفض دون إيقاف الدفعة كلها وفق قواعد تعريف الصنف ونطاق العملية.
- عرض المنتجات مرقم خادميًا 100 صف مع نافذة DOM افتراضية 30 عنصرًا؛ لا يحمل 200,000 صف إلى DOM.
- الاختبار الموجود `tests/unit/countflow-quality.test.mjs` يتضمن قراءة XLSX مصطنع من 90,000 صف، واختبارات CRC ومسارات ZIP الآمنة، وخصائص partial failure وsupervisor role boundary.
- هذه الأعمال سابقة ومثبتة في LVE-759 وما بعده؛ لم أعد كتابة الملف أو أكرر دفعة QA الحية.

### 3. Phase 3 — Export Edge Function: LIVE SOURCE UPDATED

- قبل الإصلاح كان `counting-export-session` نشطًا بالإصدار v14، ومحتواه لا يطابق مصدر Git: كان يستخدم `Storage.download()` للصور ويقرأ علاقات كبيرة قبل اكتمال preflight counts.
- نُشر المصدر الحالي المطابق لـGit بالإصدار **v15 ACTIVE** على المشروع `hfzznsiprnwkpayskzhu`، مع `verify_jwt=true` دون تغييره إلى public/anon.
- التحقق بعد النشر: `get_edge_function` أكد v15/ACTIVE/JWT=true؛ `index.ts` الحي = مصدر Git **byte-for-byte**، كلاهما 66,266 حرفًا؛ Git blob `500552796f988e56aa944fd2942c0d9e98efe34e`، Edge SHA-256 `8d3d8de9b2cf39351346325a5279c8b8d8c27f0b35d183639e1656f3d8ea61c4`.
- المصدر يسبق التحميل الكبير بـexact row counts وحدود للعلاقات، ويرفض ما يتجاوز ميزانية الذاكرة التقديرية 160 MiB أو حدود الصفوف بـ413؛ يقرأ صورة المنتج عبر signed URL وResponse stream مع سقف 1 MiB للصورة، إجمالي 8 MiB، وبحد أقصى 500 صورة؛ الصور الخارجية أو غير الصالحة/غير المدعومة تُسجل كفجوات ولا تُجلب تلقائيًا.
- مصنف Client Balance يظل محدودًا بـ50 MiB؛ ويعلن metadata صراحة `pricing_policy: "UNKNOWN"`، مع اشتقاق تكلفة وحدة الأساس من سعر الشراء ومعامل التحويل فقط، دون تحويل عملات أو وصف القيمة كتقييم محاسبي أو قيد.
- **حد تقني يجب عدم إخفائه:** الصور تُقرأ عبر stream وبحدود صارمة، لكن بناء XLSX النهائي ما زال يستخدم `zipSync`/مصفوفة bytes في الذاكرة؛ هذه نسخة bounded/preflight وليست streaming ZIP output end-to-end. لا تدّعِ أن ذروة الذاكرة قِيست فعليًا أو أن ملفًا حقيقيًا فُتح في Excel.
- لم أشغّل Edge Export حقيقيًا؛ فهو ينشئ صف `count_exports`، ويرفع ملفًا إلى Storage، ويكتب سجل تدقيق. لم أقم بإحداث هذه الكتابات دون حساب owner مصادق وبيانات اختبار مخصصة آمنة.

### 4. Tests and evidence

- آخر CI موثق قبل هذا التحديث: run `44949186321` على تطبيق main SHA `8c8a7728649d1193c58a6ecedaddccbe6845f0c9` — **35/35 Node tests PASS**، Deno type-check PASS، allowlisted Pages build PASS، وProduction Playwright **3/3 PASS** مع SHA parity.
- اختبارات المصدر تغطي preflight memory/count guard، stream image reader، حد 500/8MiB/1MiB، سياسات التسعير UNKNOWN، streaming XLSX import وsupervisor role boundary.
- **NOT RUN / UNKNOWN:** تصدير XLSX فعلي مصادق، فتح المصنف في Excel/LibreOffice، اختبار ذاكرة ذروة فعلي، رفع/تضمين صورة حقيقية، owner sign-in E2E دون عضوية Supervisor، وتدفق Offline على أجهزة حقيقية.
- PR #2 مدمج إلى `main` بالـSHA `4de6bd9bf17c70c15c0d37fb3cefb2ab3ac1ece7`. تشغيل `main` رقم 194 / run `45225616423` اكتمل SUCCESS: 35/35 اختبارات Node، Deno type-check، Pages build، وPlaywright Production 3/3؛ فحص `build-info.json` طابق Cloudflare Production مع SHA `4de6bd9bf17c70c15c0d37fb3cefb2ab3ac1ece7`. أي commit توثيقي لاحق يحتاج CI parity جديدًا قبل إعلان نشره.

### 5. Safety and mandatory continuation

- دفعة `qa-90000-products.csv` بالمعرف `f799c5c1-b766-4712-b74f-c0bb19836ddc` تظل كما هي: 90,000 إجماليًا، 41,000 committed، 49,000 staged. **ممنوع استئنافها أو إيقافها أو تعديلها أو حذفها أو إعادة اعتمادها.**
- لم يحدث DML تجريبي أو إنشاء حسابات/مشروعات/جلسات/منتجات، ولم تُرفع صور أو ملفات تصدير، ولم تتغير أي أرصدة أو بيانات أعمال.
- لم أستخدم مشروع SMART ERP `fiilmooggumokxanwiyx` أو مستودع `erp-frontend` أو ملفات `company-1/main.html` أو `core.js`؛ الفصل بين CountFlow وRAWAEA محفوظ.
- المساعد التالي يبدأ من LVE-762 ومن Git main الحالي؛ لا يعيد P0 migration ولا يعيد كتابة Import streaming/virtualization. الخطوة التشغيلية التالية فقط: تحقق من CI/merge وتطابق Pages SHA، ثم خطط لاختبار تصدير مصادق في مجموعة CountFlow اصطناعية مخصصة لا تتداخل مع دفعة QA القائمة. لا تختبر على دفعة 90K ولا تدّعِ نجاح XLSX/الذاكرة قبل قياسهما فعليًا.

---

## LVE-2026-11-21-761 — Owner RLS parity + private image Storage

**التاريخ:** 21 نوفمبر 2026  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`  
**PR #1:** [merged](https://github.com/papamohammed77-glitch/rawaea-app-countflow/pull/1) إلى `main` بالـSHA `8c8a7728649d1193c58a6ecedaddccbe6845f0c9`  
**قاعدة CountFlow:** `rawaea-staging` / `hfzznsiprnwkpayskzhu` فقط.  
**مصدر التغيير:** PR head `048ec59162aeb181e1368223ae9bceb36ad7c8c1`؛ دمج `8c8a7728649d1193c58a6ecedaddccbe6845f0c9`؛ 22 سياسة قراءة CountFlow + 3 سياسات صور خاصة.  
**CI على main:** run `44949186321` — SUCCESS: 35/35 اختبارات Node، Deno check، Pages allowlisted build، وPlaywright Production 3/3 مع مطابقة SHA الدقيقة.  
**Cloudflare Production:** نشر `8c8a772` نجح، واختبار `production login shell deployment matches the latest main source commit` أثبت أن Production يطابق SHA `8c8a772`.

### الخلل الجذري
- LVE-760 جعل بوابة Admin تقبل المالك المؤكد `owner@rawaea.com` مستقلاً عن عضوية Supervisor؛ لكن RLS في قاعدة البيانات كانت لا تزال تحجب مشاريع/منتجات/جلسات/مواقع/استيرادات/تسويات وبيانات أجهزة عن هذا المالك عند غياب عضوية المشرف.
- سياسات مخزن صور الأصناف الخاصة كانت تشترط عضوية Supervisor للرفع والتحديث، ولا يوجد Owner branch متسق مع بوابة Admin.
- هذه مشكلة RLS فعلية حتى مع صحة تسجيل الدخول، وليست خللاً في واجهة النظام الأم.

### ما نُفّذ على قاعدة CountFlow
1. Migration `countflow_platform_owner_read_and_image_storage_access`، ledger version `20261121205438`: أضافت `counting_private.is_platform_owner()` إلى 22 سياسة SELECT في جداول CountFlow، مع إبقاء شروط العضوية/المشرف/الذات كما هي لبقية المستخدمين.
2. Migration `countflow_storage_owner_path_qualifier_fix`، ledger version `20261121205720`: صححت مرجع مسار Storage إلى `storage.foldername(objects.name)` في سياسات قراءة/رفع/تحديث الصور.
3. التحقق الحي للقراءة فقط: 22/22 سياسات قراءة تحمل Owner predicate؛ ثلاث سياسات Storage تحمل Owner predicate؛ لا يوجد `storage.foldername(p.name)`؛ مخزن `counting-product-images` ما زال `public=false` وبحدوده وأنواع MIME الأصلية.
4. لم تتغير سياسات كتابة الجرد أو الأصناف أو التكليفات، ولا دوال Edge/Auth، ولا أدوار/عضويات المستخدمين.

### اختبارات وحدود الإثبات
- **PASS:** 35/35 source/unit tests، Deno checks، Pages build، Playwright Production 3/3 بعد الدمج، مع SHA parity.
- **PASS:** Migration ledger يسجل الترحيلين بالنسختين أعلاه، وسياسات RLS الفعلية تعكس Owner paths.
- **OPEN:** دخول مالك مصادق عبر المتصفح دون عضوية Supervisor، رفع صورة حقيقي + signed URL، وتضمين صورة فعلية داخل XLSX لم تُختبر؛ لا تُدّعِ ذلك.
- **OPEN:** Client Balance XLSX runtime/فتح Excel وقياس الذاكرة، التسعير غير المعتمد، E2E المصادق، Offline/متعدد الأجهزة والحمل.

### حالة بيانات QA — لا تلمس
- دفعة `qa-90000-products.csv` (`f799c5c1-b766-4712-b74f-c0bb19836ddc`) باقية `committing`: إجمالي 90,000، معتمد 41,000، مرحلي 49,000، مرفوض 0. لا تستأنفها أو توقفها أو تحذفها أو تعيد اعتمادها.
- الرصد بعد الترحيل: 41,000 صنف، 90,000 صف استيراد؛ صفر إدخالات عد/حضور/أجهزة/صادرات. لم يغيّر LVE-761 أياً من هذه الأعداد.

### تسليم وتنفيذ
- PR #1 مدمج، وCloudflare Production يطابق SHA الدمج. لا ترفع صورًا ولا تغيّر كلمات مرور ولا تنفذ DML تجريبيًا دون بيانات اعتماد وبيئة اختبار آمنة.
- النطاق حصري لـCountFlow. لا تعديل على `countflow.html` أو `Countflow-supervisor.html` أو SMART ERP أو `erp-frontend`.

Full prior checkpoint: LVE-760 below.

---



## LVE-2026-11-21-760 — استكمال النظام الأم وفق P2

**التاريخ:** 21 نوفمبر 2026  
**النطاق:** `countflow-admin.html` فقط من تطبيقات التشغيل؛ لا تعديل على `countflow.html` أو `Countflow-supervisor.html` أو ملفات ERP.  
**Runtime code commit الذي اجتاز CI:** `25a4d0bf6f630dc9320587f0c58ebdc843572578`  
**Test commit الذي اجتاز CI وProduction parity:** `0a9df3f10cdf407f8825f9a6ffecf9d16866c15d`  
**تحديثات التوثيق:** `fb6d9900ceeeccfd486f42bc11edd6f962b15c4d`، `c6c4c0b3001660c7da5915adaa597a5e9a6c1b85`، `079da414ed1d789a2809bbaae79983d1430ebc7b`، `16a6da0ac8a64abccafb1e4fce958f7b388fb0ec`؛ لا تغيّر ملفات التشغيل.  
**التقرير الموجز:** `FINAL_EXECUTION_REPORT_LVE-760.md`  
**ملف النظام الأم:** `countflow-admin.html` — blob `41e887ac5e49e5fbbacaa2c2b2645b333a7d77c7`  
**اختبارات المصدر:** `tests/unit/countflow-quality.test.mjs` — blob `da25079ab13ce8cfb2e3b92763798b175c6d7365`  
**GitHub Actions:** run `44947995397` على test commit أعلاه — SUCCESS: **34/34 Node tests**, Deno checks لوظيفتي Edge، Pages allowlisted build، **3/3 Playwright Production smoke**، وتطابق `build-info.json` مع SHA آخر `main`.  
**Production:** Cloudflare Pages اجتاز اختبار SHA المطابق للـHEAD أعلاه.

### ما أُنجز في النظام الأم

- **بوابة المالك:** أزيل اعتماد دخول النظام الأم على مجرد عضوية Supervisor. يقوم bootstrap باستدعاء `auth.getUser()` ثم يقبل فقط `owner@rawaea.com` بعد تأكيد البريد؛ أي مستخدم آخر يُسجل خروجه ولا تظهر له لوحة المالك. لم تتغير RLS أو وظائف الخادم. فحص Auth الحي السابق أكد أن حساب المالك موجود، مؤكد، وغير محظور، وله عضوية Supervisor نشطة في مشروع QA؛ وهذا يفسر كيف كان يمر من بوابة الدور القديمة، لكنه لم يكن شرطًا صحيحًا لتفويض النظام الأم.
- **اسم الجهة في العمليات:** كان موجودًا بالفعل في عمود «الجهة المتعاقدة» مع رقم التكليف واسم العملية. لم نكرر بناء هذا الجزء؛ أضفنا اختبار انحدار يثبت استمرار ظهور الاسم والكود.
- **صور الأصناف:** رفع الصور في `countflow-admin.html` محصور الآن في JPEG/PNG بحجم لا يتجاوز 1MiB حتى يتوافق مع محرّك تضمين Client Balance (الذي يقبل PNG/JPEG وبحد 1MiB للصورة). تحفظ الصورة في الحاوية الخاصة `counting-product-images` تحت مسار خاص بالتكليف، وتُقرأ عبر signed URL لمدة ساعة. صورة الكتالوج قابلة للفتح من رابط موقّع؛ وتُفرّق الواجهة بين عدم وجود مرجع صورة وبين مرجع لا يمكن عرضه. لا توجد `createPublicUrl` ولا تغيير في خصوصية الحاوية. تغيير/إزالة رابط الصورة لا يحذف الكائن القديم من Storage؛ تبقى الملفات القديمة ويتطلب تنظيفها سياسة حذف/إجراء منفصل غير متاح حاليًا.
- **وحدات القياس:** أضيف محرر وحدات بديلة مع معامل التحويل إلى الوحدة الأساسية، ورفض القيم غير الموجبة أو الأسماء المكررة أو تكرار اسم الوحدة الأساسية. تُحفظ الصيغة `{name, factor_to_base}`؛ تمت مراجعة قارئ Counter قراءةً فقط وأكد أنه يقرأ `factor_to_base` (مع aliases legacy) ويبني قائمة وحدات العد من القيم الموجبة. لم يُعدّل تطبيق المندوب. المصدّر يعالج `unit_factor_to_base` الخاص بتكلفة الشراء منفصلًا عن وحدات المنتج.
- **إدارة المستخدمين:** أضيف إجراء «تغيير كلمة المرور» للمستخدمين الآخرين فقط، مع تأكيد مزدوج وحد أدنى 10 أحرف عبر Edge action `reset_password` الموجودة؛ المالك المؤكد وحده يستطيع تنفيذها، وتُسجل النتيجة في Audit log (وقد تعود `audit_warning`). لا يسمح النموذج بإعادة تعيين كلمة مرور الحساب الحالي. أُزيل شرط كلمة المرور من حقل إنشاء العضو عندما يكون البريد لحساب Auth موجودًا ومؤكدًا؛ تُعاد هويته كما هي دون تغيير كلمة المرور أو البيانات الوصفية. الحساب الجديد فقط يتطلب كلمة مرور أولية، والحساب غير المؤكد يرفض مع توجيه عربي، والعضوية غير النشطة لا تُفعّل تلقائيًا. حالات إعادة الاستخدام وأخطاء الحسابات تُعرض برسائل عربية بدل خطأ RPC الخام.
- **اختبارات الانحدار الجديدة:** المالك المؤكد فقط؛ اسم الجهة/الكود في سجل العمليات؛ Storage خاص وروابط صور موقعة وحد 1MiB وصيغ Excel المقبولة؛ حماية الصور من تداخل طلبات الصفحات القديمة؛ استئناف/ربط حساب Auth مؤكد دون كلمة مرور جديدة؛ تحقق UoM؛ إعادة تعيين كلمة مرور المستخدم مع منع الذات.

### تكامل Storage وحدود الصلاحيات
- `counting-product-images` يبقى Bucket خاصًا، والسياسات الحية لم تتغير. سياسة الرفع الحالية تشترط عضوية `supervisor` نشطة للمستخدم في التكليف نفسه؛ المالك الحالي لديه هذه العضوية في تكليف QA المرصود. لا توجد صلاحية عامة أو bypass للمالك من واجهة Admin.
- رفع الصور محصور في JPEG/PNG ≤1MiB ليتطابق مع Client Balance image embedding؛ روابط المعاينة/الكتالوج signed لمدة ساعة. رابط خارجي HTTPS يُعرض كرابط خارجي ولا يتم تنزيله أو تضمينه في Excel. إزالة مرجع الصورة لا تحذف Storage object لعدم وجود Storage delete policy ضمن هذا العمل.

### متابعة LVE-760 بعد مراجعة توافق الصور والحسابات — 21 نوفمبر 2026
- **Runtime patch:** commit `25a4d0bf6f630dc9320587f0c58ebdc843572578`؛ ربط صور الصفحات بروابط signed قابلة للفتح، حصر صور الرفع في PNG/JPEG ≤1MiB، تحديد صلاحية روابط الصفحة الحالية فقط، ومنع نتائج صفحات البحث القديمة من استبدال نتائج أحدث.
- **Existing Auth reuse:** إذا كان البريد لحساب Auth مؤكد، لا تُطلب كلمة مرور جديدة ولا يتم تعديل القديمة؛ تُظهر الواجهة نوع العملية (إنشاء/إعادة استخدام الحساب/عضوية موجودة) وتترجم أخطاء الحساب غير المؤكد أو كلمة المرور الجديدة المطلوبة.
- **Regression commit:** `0a9df3f10cdf407f8825f9a6ffecf9d16866c15d`; CI run `44947995397` PASS، 34/34 Node، Deno، Pages و3/3 Playwright parity.
- لا تغيير في Supabase/Storage policies/Edge أو أي كتابة Auth/Storage فعلية. ملفات Storage القديمة لا تُحذف عند تغيير/إزالة مرجع الصورة. ما زالت اختبارات رفع الصورة الفعلية، signed URL الفعلية، Password reset الفعلي، وفتح XLSX حقيقي وقياس ذاكرته OPEN.

---

### حالة الاختبارات وحدود الإثبات

| المحور | الحالة | ما لم يُختبر |
|---|---|---|
| Admin source / static | PASS | — |
| Node source/unit | PASS — 34/34 | لا يحاكي Storage أو Auth فعليًا |
| Deno Edge type-check | PASS | لم يُنشر أي Edge تحديث |
| Pages build | PASS | — |
| Playwright Production | PASS — 3/3 | شاشات دخول عامة وSHA parity؛ ليس تسجيل دخول مالك مصادقًا |
| رفع صورة/إنشاء signed URL حي | OPEN | لم تُرفع صورة فعلية ولم تُكتب بيانات اختبار؛ وحدّ 1MiB/PNG-JPEG تحقق مصدرًا واختبارًا ثابتًا فقط |
| تغيير كلمة مرور مستخدم فعلي | OPEN | لم يُنفذ إجراء reset على مستخدم حقيقي؛ ربط Auth قائم بلا تغيير كلمة المرور اختُبر بعقد المصدر فقط |
| XLSX Client Balance runtime | OPEN | لم يُولد ملف فعلي ولم يُفتح في Excel |
| سياسة التسعير | UNKNOWN | لا اعتماد مالي أو FX |

### حدود البيانات والحوكمة

- **لا يوجد DML/DDL/RLS/Storage policy change أو Edge deployment** في هذا الاستكمال. لا يزال قيد LVE-747 الحوكمي الوارد في LVE-759 حاكمًا لأي اختبارات كتابة أو ترحيل أو نشر Edge.
- آخر قراءة فقط لدفعة QA `qa-90000-products.csv` (batch `f799c5c1-b766-4712-b74f-c0bb19836ddc`) أظهرت `committing`: 41,000 accepted/committed، صفر rejected، و49,000 staged؛ الكتالوج 41,000 صنف. **هذه الدفعة تخص عملًا متزامنًا؛ لا تستأنفها أو توقفها أو تحذفها أو تكررها.** قراءة الصور في الرصد نفسه: 0/41,000 منتجات لها صورة، و0 exports.
- Edge functions باقية كما هي: `counting-provision-member` v7/JWT=true، `counting-export-session` v14/JWT=true. لم يُنشر أو يُعدّل أي منهما.
- لا تعديل على SMART ERP أو erp-frontend أو بيانات المخزون/المبيعات/النقدية/المحاسبة.

### التوجيه التالي

1. استمر من هذا SHA واقرأ P2 وLVE-760 قبل أي تغيير؛ لا تعِد مهام الاستيراد المتدفق أو pagination/virtualization أو عمود اسم الجهة.
2. بعد رفع LVE-747 فقط، نفذ اختبار Auth مصادق لحساب المالك، ورفع صورة واحدة على مشروع اختبار مصرح به، والتحقق من signed URL وعرض الصورة، ثم اختبر password reset لحساب QA مع سجل التدقيق.
3. لا تنشئ صورًا أو عضويات أو عمليات على دفعة QA الحالية ولا تغيّر حالتها.
4. لا تنشر Edge Functions حتى تراجع الفرق وتطابق المصدر مع الوظيفة الحية؛ لا تلمس تطبيق Supervisor أو Counter.
5. تبقى دورة تصدير Client Balance الفعلية، وفحص XLSX الناتج، والذاكرة، والاختبارات المصادق عليها/Offline/الحمل مفتوحة ولا توصف بأنها مكتملة.

---


## LVE-2026-11-21-759 — أحدث نقطة تسليم موثقة

**التاريخ:** 21 نوفمبر 2026  
**SHA مصدر التطبيق الذي اجتاز اختبارات الوظائف:** `d90584874d5078040c7ae42db4327c30086004b8`  
**أحدث HEAD للمستودع/الوثائق الذي اجتاز CI وProduction parity:** `88eea115830ba7b0c302e215d288c78eb8690f10`  
**GitHub Actions:** run `44946476315` — SUCCESS (28/28 tests, Deno, Pages build, 3/3 Playwright; exact production build-info SHA parity).  
**تثبيت الوظائف:** run `44946245444` — SUCCESS  
**التقرير:** `FINAL_EXECUTION_REPORT_LVE-759.md`  
**Cloudflare:** Production/main يعرض build مطابقًا لـ`88eea115`; Playwright run `44946476315` قرأ `build-info.json` وطابق أحدث `main`.

### ما تم إثباته
- **P0 PASS — Source/CI:** فصل صلاحيات المالك والمشرف والمندوب، تنقية رسائل الخطأ والـaudit/import details من المصطلحات التقنية والـIDs الخام، وتوحيد مظهر Cairo/RTL.
- **P1 PASS — Source/CI:** CSV وXLSX streaming، Parser test صناعي 90,000 صف، pagination 100/virtual window 30، أرقام صف المصدر، أسباب رفض عربية، paging 500 صف لنتائج الاستيراد، واستيراد الكتالوج والعملية عبر RPCs.
- اعتماد الدفعات أصبح resumable: حتى 1,000 صف في RPC، وحالة `committing` مع `remaining_rows`، وزر استكمال من سجل الدفعات. migration الحية `countflow_import_commit_chunked_batches` عند version `20261121201407`.
- **P2 SOURCE CHECKS PASS:** اختبارات تحويل سعر الصندوق إلى سعر الوحدة الأساسية، حساب الإجمالي، والتقريب؛ وفحوصات مواضع الصور وعلاقات OOXML في مصنف Client Balance. لم يُشغّل exporter فعليًا ولم يُفتح XLSX ناتج.
- **P3 PASS:** 28/28 Node tests، Deno type-check لوظيفتي Edge، Pages allowlist build، و3/3 Playwright Production smoke على Chromium؛ اختُبر build-info SHA parity مع main وصفحات الهاتف RTL.
- Edge الحية: `counting-provision-member` v7/JWT=true، و`counting-export-session` v14/JWT=true. لم يُنشر تحديث Edge في LVE-759.

### حالة Supabase الحية — Read-only snapshot عند 2026-11-21 20:29:52 UTC
- البيئة المحددة صراحة في دستور المالك الحالي: `rawaea-staging` هي ملعب CountFlow الوحيد. هذا يحسم اختيار نطاق CountFlow السابق؛ لا يجيز أي تغيير في SMART ERP أو أرصدة/قيود ERP الحقيقية.
- جداول CountFlow وعددها 23: RLS enabled في 23/23، disabled في 0.
- **فحص SECURITY DEFINER (قراءة حية 2026-11-21):** المستشار العام يحذر من خمس RPCs في CountFlow لأنها SECURITY DEFINER وقابلة للاستدعاء من authenticated. فحص ACL التفصيلي أكد أن EXECUTE ممنوح فقط لـauthenticated/postgres/service_role، ولا يوجد anon أو PUBLIC. جميع الخمس `search_path=""`; أربع وظائف إدارية تتحقق من `counting_private.is_platform_owner()`، ووظيفة تقرير الطابور تتحقق من auth.uid() مقابل عضوية counter نشطة وجهاز معتمد وجلسة مسموحة. هذا تحذير تصميمي متوقع مع حواجز خادمية، وليس ثغرة مثبتة؛ أبقِ اختبارات الحواجز ولا تمنح صلاحيات إضافية. وجد المستشار أيضًا 65 جدولًا عامًا قديمًا بلا RLS خارج نطاق CountFlow؛ لا تغيّرها ضمن هذا المشروع لأنها تخص تطبيقات أخرى على نفس Supabase.
- تكليف QA واحد `QA 90K Import Verification`، عضو واحد بدور Supervisor نشط، وجلسة Planned واحدة.
- دفعة `qa-90000-products.csv`، ID `f799c5c1-b766-4712-b74f-c0bb19836ddc`: status `committing`، 90,000 صف مصدر، 32,000 committed/accepted، صفر rejected، و58,000 staged؛ كتالوج المشروع يحوي 32,000 صنف في لحظة الرصد.
- لا توجد عمليات عد أو أرصدة متوقعة أو حضور/أجهزة أو مهام إعادة عد أو تسويات أو تنبيهات أو صادرات. Audit log به 6 أحداث.
- هذه دفعة QA متزامنة بدأها مالك المهمة/مساعد آخر. **32,000 تقدم جزئي وليس نجاح 90K. لا تتدخل في الدفعة ولا تستأنفها/توقفها/تحذفها ولا تنشئ نسخة ثانية.** أعد القراءة قبل تحديث الحالة.

### تقييم المراحل
| المرحلة | الحالة الحالية | الحد الذي لم يثبت |
|---|---|---|
| P0 — Security/role boundaries/UI | PASS — Source/CI | Authenticated E2E لحساب مشرف/مندوب فعلي |
| P1 — Import/virtualization/partial failures | PASS — Source/CI | انتهاء دفعة DB QA ذات 90K؛ زمن throughput حقيقي |
| P2 — Final export/cost/images/memory | SOURCE CHECKS PASS / RUNTIME OPEN | توليد XLSX فعلي وفتحه والتحقق من الصور وقياس peak memory؛ تسعير معتمد |
| P3 — Cloudflare/Playwright | PASS — Public production smoke | Authenticated workflow، offline restart/multi-device، barcode/Android، load 30–300 |

### الحوكمة والتوجيه
- دستور المالك الحالي حدد `rawaea-staging` صراحة باعتبارها بيئة CountFlow الوحيدة؛ لا تربط هذا التطبيق بمشروع SMART ERP.
- لا ترحيل مخزون أو نقدية أو محاسبة، ولا تغيير في بيانات ERP.
- لا تُعلن 90K DB complete حتى تصبح الدفعة `committed`، وعدد المنتجات 90,000، والمتبقي staged صفرًا، ويُوثق ذلك بقراءة مستقلة.
- لا تدّعِ أن Client Balance XLSX نجح runtime؛ اختبارات المعادلات/OOXML لا تُنتج ملف Excel وتفتحه.
- لا تنشر Edge Functions قبل فحص الفرق ومطابقة الوظيفة الحية؛ تبقى v7/v14 كما هي.
- ابدأ من HEAD الموضح أعلاه، واقرأ تقرير LVE-759. لا تعِد migrations/الفهارس الموجودة، ولا تلمس SMART ERP.

---


## LVE-2026-11-21-758 — أحدث نقطة تسليم موثقة

**التاريخ:** 2026-11-21  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow` — `main`  
**آخر SHA للتطبيق اجتاز CI وProduction parity:** `eebcee88dc82f45e159b87d3d2289c281faec0a5`  
**GitHub Actions:** run `44945978877` — SUCCESS على SHA نفسه.  
**التقرير التفصيلي:** `FINAL_EXECUTION_REPORT_LVE-758.md` (report commit `a45351615118c4df1ee85c85548bf2de181846c4`).

### ما ثبت في المصدر وCI
- P0 صلاحيات المالك/المشرف/المندوب محفوظة: Owner-only للوظائف الإدارية والاعتماد، Supervisor مراقبة وإسناد فقط، وCounter-only لتسجيل العد.
- CSV/Papa Parse streaming وXLSX/OOXML streaming من Blob slices، CRC وZIP path traversal، أرقام صفوف المصدر، partial-row rejection، server pagination 100 صف وvirtual window 30 صفًا.
- استيراد الكتالوج والعملية يستخدم RPCs القائمة. اعتماد الدفعة صار resumable: حتى 1,000 صف لكل RPC، مع `remaining_rows` وحالة `committing` وزر استكمال من سجل الدفعات؛ لا إعادة قراءة الملف عند الاستئناف.
- Export source preflight يحسب أحجام العلاقات قبل bulk reads؛ الصور تُقرأ عبر stream بحد 1 MiB للصورة و8 MiB إجمالي و500 صورة، وتقدير الذاكرة 160 MiB. هذه حواجز مصدرية وليست قياس peak memory أو XLSX streaming كاملًا.
- CI النهائي: **26/26 Node tests**، Deno type-check للوظيفتين، Pages allowlist build، و**3/3 Playwright Chromium Production smoke**. اختبار `build-info.json` طابق SHA المنشور مع `main`، واختُبرت login shells الثلاثة على هاتف RTL.

### الحالة الحية لقاعدة CountFlow — قراءة فقط، آخر رصد عند 2026-11-21 20:23:43 UTC
- مشروع CountFlow واحد، عضو واحد، جلسة واحدة، و19,000 منتج.
- دفعة `qa-90000-products.csv` ما زالت `committing`: 90,000 صف، accepted 19,000، rejected 0، والمتبقي 71,000 staged. الدفعة غير مرتبطة بجلسة (`session_id IS NULL)).
- لا توجد أرصدة متوقعة أو لقطات تكلفة أو عمليات عد أو صادرات مرتبطة بهذه الدفعة في آخر القراءة. المشروع Draft والجلسة Planned.
- هذه عملية QA/استيراد متزامنة بدأها مالك CountFlow/مساعد آخر؛ لا توقفها أو تعتمدها أو تحذفها أو تستأنفها من مساعد آخر. 19,000 ليس اكتمال 90K.
- اختبار XLSX الصناعي 90K نجح في CI. اختبار rollback للـDB 5K اجتاز تاريخيًا قبل تثبيت بوابة LVE-747. لا يوجد إثبات لاختبار DB 90K كامل مع rollback؛ الحالة الحالية تقدم حي في دفعة committing، وليست benchmark نهائيًا.

### نشر Edge والحوكمة
- Cloudflare Pages Production طابق SHA التطبيق أعلاه في Playwright run 44945978877.
- Edge الحي `counting-export-session` لا يزال ACTIVE v14/JWT=true، و`counting-provision-member` v7/JWT=true. تعديلات Edge Export المصدرية الأحدث لم تُنشر على Supabase.
- **LVE-747 ما زالت بوابة حوكمة مفتوحة:** لا SQL DML/rollback tests أو migrations/DDL أو RLS/GRANT/REVOKE أو Edge deploy إلى `rawaea-staging` حتى حسمها. استمر في Git/source/CI/Pages والقراءات فقط.

### المفتوح فعليًا
- تأكيد اكتمال/سلامة دفعة QA 90K دون التدخل في عملها المتزامن وبعد رفع حوكمة الكتابة.
- Authenticated Supervisor/Counter E2E وباركود فعلي، Offline restart/reconnect/multi-device، اختبار export فعلي وفتح XLSX/فحص الصور والـSHA وقياس الذاكرة، وحمل 30–300 مستخدم.
- Pricing policy لا تزال UNKNOWN؛ لا FX أو accounting valuation. لا تدّعِ جاهزية SAP-scale أو اعتماد export 90K.

### تعليمات الاستكمال
ابدأ من HEAD الحالي وسجل commits، واقرأ `FINAL_EXECUTION_REPORT_LVE-758.md`. لا تعِد migrations/الفهارس الموجودة، ولا تلمس مشروع RAWAEA ERP. لا تتدخل في دفعة QA الجارية؛ استأنف اختبارات الكتابة/النشر إلى Supabase فقط بعد رفع LVE-747 رسميًا.

---


## LVE-2026-11-21-756 — آخر نقطة تشغيلية مثبتة

**التاريخ:** 2026-11-21  
**Git HEAD المثبت:** `4c7a614e620d4113eeed341b51b7977ce4dcb241`  
**CI:** GitHub Actions run `44944233547` على نفس SHA — **SUCCESS**.
- 18/18 اختبارات Node للمصدر والسلوك؛ اختبار XLSX اصطناعي 90,000 صف وCRC/ZIP traversal؛ اختبارات streaming، أرقام الصفوف، partial row rejection، queue digest، export preflight والحدود، audit/error sanitization وواجهة اللغة.
- Deno type-check لكل من `counting-provision-member` و`counting-export-session` نجح.
- بناء Cloudflare Pages نجح مع عشرة ملفات allowlist.
- Playwright اكتشف ستة اختبارات وشغّل ثلاثة اختبارات Production smoke: owner login، latest-main SHA parity، وواجهات Admin/Supervisor/Counter في Chromium بعرض هاتف RTL. النتيجة: **3 passed (3.8s)**.
- اختبار الطباعة النصية تأكد أن الصفحات التشغيلية الثلاث لا تكشف project_id أو RLS أو Edge Function أو JWT أو SHA-256 أو IndexedDB أو مصطلحات داخلية أخرى في النص الظاهر. واختبارات تنقية Audit/Error نجحت.

**تغييرات الواجهة المثبتة في المصدر:**
- النظام الأم: هوية Cairo / خطوط عربية، درجات كحلي/أزرق، تباين وأزرار Focus/Hover، تسميات عربية للأدوار والحالات، ملخصات تدقيق وأخطاء صديقة للمستخدم دون إظهار تفاصيل Supabase/UUID/JSON الخام.
- المشرف: تسميات بشرية للحالات والأدوار والتنبيهات، رسائل أخطاء آمنة، وعدم عرض معرفات الأجهزة الداخلية في لوحة الفريق.
- المندوب: رسائل مزامنة/دخول/أجهزة عربية، إخفاء project/session/product/device IDs من واجهة الطابور، وعدم حفظ الخطأ التقني الخام للمزامنة، وتسميات دور عربية.
- Edge Export: عدّ صفوف مسبق قبل تحميل العلاقات الكبيرة، تقدير حمل/ذاكرة التصدير الكامل وClient Balance قبل bulk fetch، تنزيل الصور عبر stream محدود بحد 1 MiB لكل صورة، 8 MiB إجمالي و500 صورة، ورفض الطلب إذا تجاوز تقدير الذاكرة 160 MiB أو حدود الملف/الصفوف.

**حد التصدير:** الحارس يقلل خطر نفاد الذاكرة ويمنع bulk reads غير مقبولة، لكنه لا يحوّل XLSX النهائي إلى stream حقيقي؛ تكوين المصنف/ZIP ما زال يستخدم الذاكرة. لم يتم تشغيل تصدير على جلسة فعلية، ولم تُفتح وثيقة الناتج أو تُقَس ذروة الذاكرة. لذلك Export runtime/90k remains **OPEN**.

**ما زال مفتوحاً:** مصادقة مستخدم مشرف/مندوب حقيقيين، E2E لمسح باركود في مشروع/موقع/صنف، استيراد قاعدة البيانات 5k/90k (ملفات rollback موجودة ولم تشغّل بسبب LVE-747 governance hold)، تصدير فعلي وفحص الصور/الـhash والذاكرة، Offline device/browser restart/multi-device، وقياس 30–300 مستخدم. لا بيانات تشغيل حالية في CountFlow؛ الجداول ما زالت صفرية. لا SQL/DML/Edge deploy جديد في هذا التحديث.

**المصدر المرجعي:** `FINAL_EXECUTION_REPORT_LVE-755.md` (يضاف إليه ملحق LVE-756).  
**المساعد التالي:** يبدأ من HEAD أعلاه وCI 44944233547؛ لا يعيد Phase 1/2/3 source work. ينتقل إلى E2E المصادق/تصدير فعلي فقط عندما تتوفر بيانات اختبار CountFlow معتمدة وتُرفع بوابة LVE-747. لا يلمس SMART ERP مطلقاً.

---


> **LATEST AUTHORITATIVE CHECKPOINT — LVE-2026-11-21-755 (FINAL DOC PIN)**  
> **Date:** 2026-11-21  
> **Repository:** papamohammed77-glitch/rawaea-app-countflow, main; standalone CountFlow. No SMART ERP or erp-frontend changes.  
> **Git HEAD before this CURRENT_STATE refresh:** 6d1958f05ed8948296acb7ab496c28f02e62049c. Runtime/source code commit tested: 9f91add07fb3e49890bcf8319ba817bd002e7ee6. Later commits update handoff/migration documentation only. Full handoff: FINAL_EXECUTION_REPORT_LVE-755.md.  
> **Latest successful source+production CI:** run 44943689352 on commit cf076ce362d9d964a1879feab25a8d421b4827d2 — SUCCESS. Deno type-checks for both Edge Functions, 12/12 Node source/unit tests, ten-file Pages build and Playwright production tests succeeded. The run resolved latest main at runtime to cf076ce3, waited for Production build-info.json, and proved exact SHA equality. Three Chromium smoke tests passed: owner login shell, SHA parity, RTL mobile shells for Admin/Supervisor/Counter (3 passed, 2.7s). Latest doc commit after that run changes only architecture/deployment/report files; this state refresh also changes documentation only.  
> **Cloudflare Production:** https://rawaea-app-countflow.pages.dev. Latest exact source/production parity proven for cf076ce362d9d964a1879feab25a8d421b4827d2 on run 44943689352. Build command bash scripts/build-pages.sh; output dist; ten allowlisted files including build-info.json.  
> **Supabase:** rawaea-staging / hfzznsiprnwkpayskzhu. Last read-only counts: 0 projects, 0 members, 0 products, 0 sessions, 0 entries, 0 import batches/rows, 0 exports, 0 expected balances, 0 presence, 0 devices. Auth owner identity count 1 and confirmed identity count 1 (owner@rawaea.com).  
> **Edge Functions:** counting-provision-member ACTIVE v7/JWT=true; counting-export-session ACTIVE v14/JWT=true, deployed digest 147a21d8389ca6f87c911352895aaa0e3ae56ef1f875cb147c3f455f0a34c788.  
> **Live migrations:** P1 LVE-749 remains applied. There are 16 CountFlow ledger entries after P1. The normalized lookup index migration is APPLIED at live version 20261121194759 (countflow_import_normalized_lookup_indexes); all three source-matching indexes are present in pg_indexes. Its tracked SQL filename is 20261121212500_countflow_import_normalized_lookup_indexes.sql, so do not infer ledger version from filename. Three post-P1 entries have no standalone matching SQL artifact; the exact inventory is database/migrations/README.md.  
>
> ### Phase 1 — P0 SECURITY: PASS
> - Confirmed owner-only server/RLS boundaries; do not replay LVE-749.
> - Supervisor is monitor/team/location assignment only; no engagement/account/import/export/catalog/session lifecycle/reconciliation/approval authority.
> - Field entry and recount assignment are counter-only; auditor cannot count.
>
> ### Phase 2 — P1 IMPORT/CATALOG: SOURCE + CI PASS
> - Server-side product catalog pagination (100 rows per request, exact count) and a 30-row virtual DOM window.
> - CSV Papa Parse step/pause/resume; XLSX ZIP/OOXML streaming from Blob slices with CRC/path validation. Synthetic 90k-row XLSX parser test passes in CI.
> - Catalog and operation import both use existing create/stage/commit RPCs with chunks <=1,000. Operation importer no longer uses FileReader/full file arrayBuffer/Papa complete. CSV original source row numbers are retained.
> - Optional metadata may be NULL/empty and row validation is server-side; invalid/missing mandatory identity/base unit or unknown locations reject individual rows rather than aborting unrelated rows.
> - Binary XLS remains limited to 8 MiB and full-read; use XLSX for large files.
> - Three normalized batch/location lookup indexes are live and verified; actual query-plan and 5k/90k RPC import throughput benchmarks are not done.
>
> ### Queue barrier/device finality: SOURCE + LIVE SCHEMA VERIFIED; DEVICE E2E OPEN
> - Counter reports canonical SHA-256 of sorted full pending-row payload (event/project/session/member/device/product/location/recount/quantity/unit/scan/note), plus count, through count_report_device_queue after queue changes/sync/presence/reconnect/periodic refresh.
> - The server stores queue count/digest/time/lifecycle version. Pause-first owner approval requires paused session, latest computed reconciliation, stable snapshot, imported products counted, reviewed recounts, resolved critical alerts and device acknowledgements at the current lifecycle version. Completion rechecks the barrier.
> - Only confirmed owner can waive a stuck device queue, with reason and audit record. Local IndexedDB cannot be independently read by server; count/digest is device self-attestation, not cryptographic proof that no local row was omitted.
> - Browser offline/restart/reconnect/multi-device path not tested with real devices; no projects/devices currently exist.
>
> ### Phase 3 — P2 EXPORT: ACTIVE SOURCE; RUNTIME OPEN
> - Edge v14 is active/JWT; it exports private CSV/XLSX with SHA/signed URL.
> - Estimated-memory guard 160 MiB, client-balance image bounds 1 MiB/image, max 500 images/8 MiB total, workbook 50 MiB, aggregate rows 250k.
> - Export has not been invoked using a real CountFlow session. Workbook/image placement/hash validation and peak memory measurement remain open. XLSX.write/zipSync builders materialize output in memory; the guard is estimated, not proven streaming.
> - Pricing policy UNKNOWN/not owner approved; no FX conversion or accounting valuation authority.
>
> ### Phase 4 — PUBLISH/E2E: PUBLIC + MOBILE SMOKE PASS; AUTH E2E OPEN
> - Run 44943689352 proved exact Production build-info SHA parity against latest main cf076ce3 and three Chromium smoke tests.
> - Authenticated Supervisor/Counter login, barcode scan against assigned site/product, actual database import, export invocation, Offline multi-device and 30–300-user load remain open because there are no test roster/projects/products/sites or approved CI credentials.
>
> ### Governance / next assistant actions
> - Do not run SQL DML/rollback tests or Edge deployments to rawaea-staging before the LVE-747 write-test/deployment gate is resolved. This continuation performed no DB DML, DDL, RLS or Edge deployment; the 16 post-P1 migrations/indexes were parallel-team actions reconciled read-only.
> - Do not touch SMART ERP, erp-frontend, company-1, ERP inventory/sales/cash/accounting.
> - Next: obtain approved disposable CountFlow test roster/credentials, run authenticated supervisor/counter and pause→queue ACK→approve→review ACK→complete E2E; after governance release run SQL 5k/90k rollback tests, then one controlled export and inspect workbook/images/hash/peak memory.
> - Pricing stays UNKNOWN until owner approval. Never claim SAP-scale user concurrency until measured.
>
> ---




> **LATEST AUTHORITATIVE CHECKPOINT — LVE-2026-11-21-755**  
> **Date:** 2026-11-21  
> **Repository:** papamohammed77-glitch/rawaea-app-countflow, main (standalone CountFlow; no changes to erp-frontend/SMART ERP).  
> **Git HEAD before this CURRENT_STATE update:** aac58303cfc9088b11abae3e867937c177967419. The latest tested application/runtime source is commit 9f91add07fb3e49890bcf8319ba817bd002e7ee6; subsequent commits in this checkpoint are documentation/report updates. Handoff report: FINAL_EXECUTION_REPORT_LVE-755.md (created in commit aac58303cfc9088b11abae3e867937c177967419).  
> **CI:** GitHub Actions run 44943177355 on commit 9f91add07fb3e49890bcf8319ba817bd002e7ee6 — SUCCESS. 12/12 Node source/unit tests, Deno checks for both CountFlow Edge Functions, allowlisted Pages build, Playwright discovery, exact Production build-info SHA parity and three Chromium smoke tests passed. Playwright log: latest main SHA matched build-info.json; public owner login, RTL mobile Admin/Supervisor/Counter shells: 3 passed (2.6s).  
> **Cloudflare:** Production origin https://rawaea-app-countflow.pages.dev; exact SHA parity was proven for source commit 9f91add0... by the run above. Ten public build files only, including generated build-info.json.  
> **Supabase:** rawaea-staging / hfzznsiprnwkpayskzhu. Last read-only counts: 0 projects, 0 members, 0 products, 0 sessions, 0 count entries, 0 import batches/rows, 0 exports, 0 expected balances, 0 presence rows, 0 devices. Auth owner identity count 1; confirmed email count 1 (owner@rawaea.com).  
> **Live Edge Functions:** counting-provision-member ACTIVE v7 / JWT=true; counting-export-session ACTIVE v14 / JWT=true. Export deployed source digest 147a21d8389ca6f87c911352895aaa0e3ae56ef1f875cb147c3f455f0a34c788.  
> **Live migration state:** P1 LVE-749 remains applied; 16 CountFlow ledger entries followed P1. The normalized lookup index migration is APPLIED as live version 20261121194759 / name countflow_import_normalized_lookup_indexes. The three exact indexes are present in pg_indexes. The source filename is 20261121212500_countflow_import_normalized_lookup_indexes.sql (timestamp mismatch; do not replay). Three post-P1 ledger entries have no standalone one-to-one SQL artifact (import row-level location validation and two intermediate two-phase approval migrations); see database/migrations/README.md.  
>
> ### Phase 1 — P0 SECURITY: PASS
> - Owner identity verified, owner-only server/RLS boundaries applied; do not replay LVE-749.
> - Supervisor is monitoring/team/location assignment only; no engagement/account/import/export/catalog/session lifecycle/reconciliation/approval authority.
> - Field entry and recount task assignment are counter-only; auditor cannot count.
>
> ### Phase 2 — P1 IMPORT/CATALOG: SOURCE + CI PASS
> - Admin catalog is server-paged (100 rows per query, exact count) and DOM uses a 30-row virtual window.
> - CSV uses Papa Parse step/pause/resume and bounded 1,000-row chunks; XLSX streams ZIP/OOXML Blob slices, validates CRC and rejects unsafe ZIP paths. Synthetic XLSX 90k-row CI parser test passes.
> - Both catalog and operation imports use the existing create/stage/commit RPC path in 1,000-row chunks; operation importer no longer uses FileReader/full arrayBuffer/Papa complete. Original CSV source row numbers are preserved.
> - Optional metadata (category/price/name/etc.) can be absent without aborting a whole batch; mandatory identity/base unit and invalid location conditions are rejected per row by the server.
> - XLS binary remains limited to 8 MiB and full-read; use XLSX for large workbooks.
> - Three normalized lookup indexes are applied and verified in live pg_indexes. Actual 5k/90k database import throughput and query-plan improvement have not been benchmarked in this checkpoint.
>
> ### Queue/device close barrier — SOURCE + LIVE SCHEMA VERIFIED, DEVICE E2E OPEN
> - Counter reports a deterministic SHA-256 digest of canonical full pending payload rows (event/project/session/member/device/product/location/recount/quantity/unit/scan/note) plus row count using count_report_device_queue.
> - Reporting occurs on queue changes, sync, device presence heartbeat, reconnect and periodic refresh. The server stores count/digest/report time/lifecycle version.
> - Pause-first owner approval requires a paused session, latest computed reconciliation, stable entry snapshot, all imported products counted, reviewed recounts, resolved critical alerts and current-version queue acknowledgements. Completion rechecks queue barrier. Owner-only waiver needs reason and audit record.
> - Limitation: IndexedDB is client-side; the server enforces and stores a device self-attestation (count/digest), not independently verified cryptographic proof of local queue contents.
> - Queue barrier has not been tested with actual offline devices/browser termination/reconnect/multi-device concurrency. No real CountFlow sessions/devices currently exist.
>
> ### Phase 3 — P2 EXPORT: ACTIVE SOURCE, RUNTIME OPEN
> - Edge v14 requires confirmed owner, JWT, stores private XLSX/CSV with SHA-256/signed URL.
> - Estimated-memory guard 160 MiB; client-balance images bounded at 1 MiB each, max 500, 8 MiB total; workbook max 50 MiB; combined row guard 250k.
> - Actual export has not been invoked from a real session; workbook/image correctness and peak-memory have not been measured. Builders use arrays/XLSX.write/zipSync in memory; the memory guard is estimated, not true streaming or benchmark evidence.
> - Pricing policy remains UNKNOWN / not owner-approved; no FX conversion and no accounting valuation authority.
>
> ### Phase 4 — PUBLISH/E2E: PUBLIC + MOBILE SMOKE PASS, AUTH E2E OPEN
> - Cloudflare Pages build uses bash scripts/build-pages.sh, output dist, ten allowlisted files and build-info.json.
> - Run 44943177355 proved exact latest-main SHA parity against Production and opened Admin/Supervisor/Counter shells on Chromium mobile 390x844 RTL. Three unauthenticated smoke tests passed.
> - Authenticated supervisor/counter E2E, barcode scan with assigned product/location, actual data import, export invocation and offline journey remain OPEN. The database currently has no project/member/product/site/device fixtures and no approved CI credentials.
>
> ### Governance and next actions
> - Do not run SQL DML/rollback tests or deploy Edge Functions to rawaea-staging until the LVE-747 governance gate is resolved. No writes, RLS changes or Edge deployments were performed by this continuation; the post-P1 migrations/index application were parallel team actions reconciled read-only.
> - Do not touch SMART ERP, erp-frontend, company-1, ERP inventory, sales, cash or accounting.
> - Next: obtain approved disposable CountFlow test roster/credentials; run authenticated Supervisor/Counter and pause → queue ACK → approve → review ACK → complete E2E; only after governance release run 5k/90k DB import tests within rollback transactions; run one controlled export and inspect workbook/images/hash and measure peak memory. Keep pricing UNKNOWN until owner approval.
> - Full handoff: FINAL_EXECUTION_REPORT_LVE-755.md.
>
> ---



> **LATEST AUTHORITATIVE CHECKPOINT — LVE-2026-11-21-754**  
> **Date:** 2026-11-21  
> **Status:** P1 security remains applied and verified. Phase 2 catalog + operation import use bounded CSV/XLSX parsing and 1,000-row RPC chunks; product listing is server-paged and virtualized. Phase 3 export source/deployment safeguards are present in ACTIVE Edge Function v14; pricing remains UNKNOWN. Phase 4 paths and build are correct, Playwright tests are discoverable, and a Cloudflare Pages Production project exists with auto deployments enabled. The latest Production revision visible in the connected Cloudflare dashboard snapshot was 195bbe8, older than current Git HEAD. The public production login-shell smoke has passed against the origin, but exact Git SHA-to-Production deployment parity remains NOT VERIFIED.  
> **Repository:** papamohammed77-glitch/rawaea-app-countflow (standalone; not erp-frontend).  
> **Current Git HEAD before this state refresh:** 15f0e04ba0b01396dfcc6eb14f51c68abba32967. Application source commit for streaming/admin changes: 5dcdf76a856d78f4f6268bcc0d1c9cd2f13e2f77; E2E public smoke spec: 420ac13bc4eaa69d570f2b5ce69608e7d32f2832; CI workflow smoke run update: b2a7d919658a7ff644981c1c424ff1dbe44f6967.  
> **Relevant source blobs:** countflow-admin.html = e72949afea346b079152e1f87e0f07c0c8a2eee5; tests/unit/countflow-quality.test.mjs = a7302bbdae962105a4d64feacc6998c0a3d9b2f6; workflow = edf75e0b3fa2342b0471e554a00cb3ad379abba0; Edge source = d8c32ed72f5a1ff36f62b42cd62f25f308836eb3; Playwright spec = f4328ae1c4561469f3fbf3835e6965c60ae7e60c; E2E README = f3fb65c3747bdd8cb16dd937f420bd05b6999bb8.  
> **CI:** GitHub Actions run 44941236636 — SUCCESS: 10/10 unit/source tests and allowlisted Pages build. Newer GitHub Actions run 44941845028 — SUCCESS: Playwright discovered 4 tests and ran the public production login-shell smoke against https://rawaea-app-countflow.pages.dev; 1 passed in 3.2s. Authenticated Supervisor/Counter tests are still not executed.  
> **Supabase:** rawaea-staging / hfzznsiprnwkpayskzhu only. Last read-only query: 0 projects, members, products, sessions, count entries, import batches, import rows, exports and expected balances; exactly one owner@rawaea.com Auth identity and its email is confirmed. No database writes, migrations, RLS changes or Edge deployments were performed in this continuation.  
> **Live export Edge Function:** counting-export-session ACTIVE v14, JWT=true; deployed source digest 147a21d8389ca6f87c911352895aaa0e3ae56ef1f875cb147c3f455f0a34c788 matches the tracked source.  
> **Cloudflare Pages:** project rawaea-app-countflow, Production, automatic deployments enabled; origin https://rawaea-app-countflow.pages.dev. The latest Production commit visible in the connected Cloudflare dashboard at inspection was 195bbe8, not the newer Git HEAD. Do not claim HEAD 15f0e04 is deployed until a deployment record shows the same commit.  
>
> ### Phase 1 — P0 / SECURITY: CONFIRMED
> - LVE-749 migration is already applied. Do not replay it.
> - Engagement creation, account provisioning, owner Admin writes/import/export and sensitive lifecycle/RPC operations require the confirmed platform-owner identity.
> - Supervisor is limited to monitoring and team/location assignments; it cannot create engagements/accounts, reset passwords, import/export, edit master data, control session lifecycle, reconcile, approve or mutate alerts.
> - Field entry/recount remains counter-only; auditor cannot submit field counts.
>
> ### Phase 2 — P1 / IMPORT & CATALOG: SOURCE + CI PASS
> - Product catalog reads use exact-count server-side filtering and 100-row .range() pages. The DOM uses a 30-row virtual window; the browser does not download 90k/200k products to render one table.
> - CSV parsing uses Papa Parse step with pause/resume and bounded 1,000-row staging. Original source record numbers are preserved by counting source records including blank/error records.
> - XLSX reads the ZIP/OOXML sheet stream from Blob slices, validates CRC and emits row callbacks; the 90,000-row synthetic XLSX test passed. No full-workbook SheetJS XLSX.read(file.arrayBuffer()) path remains for XLSX.
> - Catalog import and operation-level import share bounded CSV/XLSX streaming and existing RPCs count_create_import_batch, count_stage_import_rows, count_commit_import_batch; server-side validation decides accepted/rejected rows.
> - Optional category/price/name/identity fields normalize to NULL/empty as appropriate; malformed unit JSON is normalized to an empty units array so a bad optional field does not throw and abort all rows. Rows missing mandatory identity/base unit are expected to be rejected individually by the server.
> - Legacy binary .xls remains supported only with an 8 MiB file limit and SheetJS full read; it is explicitly not a streaming format. Convert large workbooks to .xlsx.
> - CI run 44941236636 passed 10/10 unit/source checks including synthetic 90k XLSX, CRC/traversal rejection, role boundaries, operation streaming, row-number preservation and partial failures. This is parser/source regression coverage, not a 90k database import benchmark.
> - CI run 44941845028 also passed a real Chromium Playwright smoke against the public production origin: the master login shell loads and exposes the owner email/password controls. This tests only the public login screen, not authenticated Admin, Supervisor or Counter workflows.
>
> ### Phase 3 — P2 / EXPORT: SOURCE DEPLOYED, RUNTIME NOT VERIFIED
> - Edge Function v14 includes a 160 MiB estimated-memory guard, explicit 413 budget rejection, bounded image reads (1 MiB/image, max 500 images, 8 MiB aggregate) and per-currency pricing output with no FX conversion.
> - Pricing policy remains UNKNOWN / not owner-approved. Derived unit-cost/value fields are not an approved stock valuation or accounting basis and must not be posted to ERP accounts.
> - No authenticated export job has been run in this continuation. Workbook opening, image placement, large-output peak memory, and 90k export remain UNKNOWN. The estimate guard is not a measured memory guarantee.
> - UI visual polish is not certified as SAP-level; responsive/mobile usability, keyboard/accessibility review and multi-device runtime behavior need real browser/device review.
>
> ### Phase 4 — PUBLISH & E2E: BUILD + PUBLIC LOGIN SMOKE PASS; AUTH E2E / SHA PARITY OPEN
> - Pages root is the standalone repository root. Build command: bash scripts/build-pages.sh; output: dist. Build produced the nine allowlisted browser files and excluded source-only folders.
> - Correct app routes: /countflow-admin.html, /countflow.html, /Countflow-supervisor.html. Playwright config has testDir: . because it is located in tests/e2e.
> - CI lists four tests and launches Chromium for the unauthenticated production login-shell test. That public test passed on run 44941845028. The other three authenticated Supervisor/Counter scenarios have not been run.
> - Read-only connected-browser inspection showed the Production master page accessible with the owner session and zero dashboard counts. Additionally, Playwright's public unauthenticated login-shell test passed. Neither proves that latest Git HEAD is deployed.
> - No authenticated supervisor/counter credentials or assigned test location/product were available to CI. Actual sign-in, scan, offline/reconnect and multi-device Playwright tests remain OPEN.
> - Cloudflare project is present and automatic deployments are enabled. Last visible production revision 195bbe8 predates current HEAD; verify deployment parity before saying source is live.
>
> ### Governance / next execution
> - Do not touch SMART ERP, erp-frontend, company-1, ERP tables, inventory, treasury, sales or accounting.
> - Do not run SQL write tests, create Auth users or publish a new Edge Function until the LVE-747 staging-write/deployment governance gate is resolved. Read-only SQL verification is permitted.
> - Next assistant: inspect current main HEAD and CI run, then check the Cloudflare Production deployment revision. After deployment parity, obtain approved supervisor/counter test credentials and run the three Playwright E2E cases against the published origin. Keep all test data CountFlow-only and rollbackable. Verify export with a real but approved test session before claiming Phase 3 runtime PASS; leave pricing UNKNOWN until owner approval.
> - Full handoff: FINAL_EXECUTION_REPORT_LVE-754.md.
>
> ---


> **LATEST AUTHORITATIVE CHECKPOINT — LVE-2026-11-21-751**  
> **Date:** 2026-11-21  
> **Status:** Phase 1 LVE-749 remains confirmed. Phase 2 LVE-750 source changes remain committed; CSV streaming and server-paged/virtual product rendering have static syntax PASS. Phase 3 export guard/source changes are committed and `counting-export-session` is ACTIVE v14 with exact source match and JWT required. Deployment paths and Playwright paths are corrected. Actual export, E2E, XLSX runtime, 90k stress, and Cloudflare Pages deployment remain NOT VERIFIED.  
> **Repository:** `papamohammed77-glitch/rawaea-app-countflow` (standalone CountFlow; not `erp-frontend`).  
> **Supabase:** `rawaea-staging` / `hfzznsiprnwkpayskzhu` only. SMART ERP / `fiilmooggumokxanwiyx` and legacy ERP remain untouched.  
> **Latest source commits:** export `34028902c18950249909f6cc59cf49f21b46e80f`, metadata `d1da9cd0bdf75b23c36c7ba39497a5fb3a6bcd6f`; deployment `ce9f714e470b136ec627681c713cb9bc1db52e63`; Playwright paths `0364b4a002a23fb2e75cd87b2ef58635d4e98e94`; current function source blob `d8c32ed72f5a1ff36f62b42cd62f25f308836eb3`.  
> **Live Edge Function:** `counting-export-session` v14 ACTIVE, JWT=true, deployed SHA `147a21d8389ca6f87c911352895aaa0e3ae56ef1f875cb147c3f455f0a34c788`; source byte-match confirmed.  
>
> ### Phase 3 — SOURCE / DEPLOYMENT STATUS
> - Client Balance and full export have estimated peak-memory guards (160 MiB) and explicit 413 rejection for estimated over-budget jobs.
> - Image read is bounded by stream with 1 MiB per image, 500-image cap, and 8 MiB aggregate cap. Image bytes remain retained for workbook assembly within these limits.
> - Pricing policy is still UNKNOWN / not owner-approved. Export documents purchase-unit-cost divided by unit factor, totals per stored currency, no FX conversion, and no accounting valuation.
> - `DEPLOYMENT.md` uses standalone repository root, `scripts/build-pages.sh`, `dist`, and canonical root HTML files.
> - Playwright config/test paths use standalone root pages; suite has not run.
>
> ### OPEN / NOT VERIFIED
> - Edge Function runtime compile and actual export invocation/workbook opening/image placement/peak memory.
> - XLSX admin import still reads whole workbook via SheetJS `XLSX.read(file.arrayBuffer())`; true streaming XLSX import remains open.
> - 90,000-row import/export stress; full 90k target cannot be claimed based on estimated memory guard.
> - Cloudflare Pages deployment and authenticated Playwright E2E.
> - Pricing policy approval.
>
> ### Continuation rules
> - Resume from LVE-751 and read current HEAD before edits. Detailed handoff: `FINAL_EXECUTION_REPORT_LVE-751.md`.
> - Do not reapply LVE-749/750/751. Integrate other assistant work rather than overwriting.
> - No irreversible stock/accounting operations or persistent QA data. Use rollback-only CountFlow tests only after the applicable governance gate is resolved.
> - Do not call XLSX streaming, 90k scale, runtime export, or deployment PASS without direct evidence.
>
> ---
>
> **LATEST AUTHORITATIVE CHECKPOINT — LVE-2026-11-21-750**  
> **Date:** 2026-11-21  
> **Status:** Phase 1 P0 enforcement remains confirmed at LVE-749. Phase 2 source improvements committed; CSV streaming and product pagination are implemented with static syntax PASS. XLSX parsing, runtime import, 90k load, deployment, and Phase 3 export remain OPEN/NOT VERIFIED.  
> **Repository:** `papamohammed77-glitch/rawaea-app-countflow` (standalone CountFlow repository; not `erp-frontend`).  
> **Application paths:** root-level `countflow-admin.html`, `Countflow-supervisor.html`, `countflow.html`.  
> **Supabase boundary:** `rawaea-staging` / `hfzznsiprnwkpayskzhu` only. SMART ERP / `fiilmooggumokxanwiyx` and legacy RAWAEA ERP remain untouched.  
> **Phase 2 commits:** `942a90ce7f8ef77e84a23040196e5a5524150b28`, `df2eb38043e953e9936ddf69d4e4633ac5b105de`, `95304280f05095e812bc95f7ca6e6e2c01b6cb22`.  
> **Admin source blob:** `4263b0a87f2ba570921ef2302f9cbe9f73128b96`.  
>
> ### Phase 2 — SOURCE IMPLEMENTED / STATIC PASS
> - Product catalog no longer loads all project products into client state. It uses server-side exact-count filtering and 100-row pagination; current page DOM is bounded to a 30-row virtual window.
> - CSV preview uses Papa Parse `step`, stores only headers/sample rows, and re-reads the file for commit using sequential 1,000-row staging RPC chunks.
> - CSV file fingerprint is calculated from 1 MiB chunks using `sha256-chain-v1`; no single full-file ArrayBuffer is created for the checksum.
> - Missing optional fields are allowed to reach server validation as NULL/empty; malformed units no longer abort all rows in client normalization.
> - Full inline admin JavaScript syntax parse PASS (81,134 characters).
>
> ### Phase 2 — OPEN / LIMITATIONS
> - XLS/XLSX still uses SheetJS `XLSX.read(file.arrayBuffer())`: server staging is chunked, but browser workbook parsing is not streaming. Do not claim complete XLSX memory safety.
> - No authenticated file-upload E2E, DB import regression, 90,000-row test, Cloudflare deployment, or published-origin verification was run.
> - No new database writes or schema/RLS/Edge changes were made in LVE-750.
>
> ### Phase 3 — OPEN
> - Export Edge Function image streaming and memory behavior.
> - Explicit pricing policy and export pricing enforcement.
> - Correct standalone deployment file paths in DEPLOYMENT.md / CURRENT_STATE.md and Playwright paths.
> - Authenticated browser E2E, actual XLSX open/validation, and export verification.
>
> ### Phase 1 — LVE-749 remains authoritative
> - Owner-only project/engagement creation and admin write/RPC gates; Supervisor restricted to monitoring/team assignment; counter-only field capture; auditor cannot count.
> - Do not replay the P1 migration or undo those boundaries.
>
> ### Mandatory continuation / collaboration
> - Start from the current main HEAD and read the newest commit before editing. The current report is `FINAL_EXECUTION_REPORT_LVE-750.md`.
> - If another assistant has an uncommitted/in-progress change, inspect and integrate it; never overwrite blindly.
> - First close the XLSX streaming limitation without adding an unapproved Edge Function or crossing into SMART ERP. Then run static checks and only permitted rollback-only tests after resolving the LVE-747 test/deployment governance hold.
> - Preserve truthful status labels. No claims of 90k, browser E2E, deployment or export PASS without direct evidence.
>
> ---
>
> **LATEST AUTHORITATIVE CHECKPOINT — LVE-2026-11-21-749**  
> **Date:** 2026-11-21  
> **Status:** Phase 1 P0 security and role enforcement applied to `rawaea-staging`; matching source changes are committed here.  
> **Repository:** `papamohammed77-glitch/rawaea-app-countflow` (standalone CountFlow repository; not `erp-frontend`).  
> **Application paths:** root-level `countflow-admin.html`, `Countflow-supervisor.html`, `countflow.html`.  
> **Supabase:** `rawaea-staging` / `hfzznsiprnwkpayskzhu` only. SMART ERP / `fiilmooggumokxanwiyx` and the RAWAEA ERP repository remain untouched.  
> **Base Git commit:** `6c2af162e06a7873d7d67e44d24ef94604710dc8`.  
>
> ### Phase 1 — CONFIRMED
> - Migration `countflow_p1_owner_only_admin_and_counter_only` is applied. Project/engagement creation and project bootstrap require the confirmed `owner@rawaea.com` identity.
> - Admin table write policies plus import, session-lifecycle and reconciliation RPCs require the platform owner. Team assignment and scoped participation/monitoring remain separate.
> - Supervisor app has only two tabs: live monitoring and team assignment. Project/account creation/reset, import/export, catalog/location maintenance, session lifecycle, alert-rule mutation and reconciliation controls are removed. Member/device/presence details are read-only.
> - Counter login admits only `counter` memberships. Direct entry INSERT and primary/recount RPCs reject `auditor`.
> - `counting-provision-member` is ACTIVE v7 and `counting-export-session` is ACTIVE v13; both require JWT and enforce owner-only execution.
>
> ### Verification — PASS
> - Migration applied successfully.
> - Rollback-only authorization probe rejected a synthetic non-owner at `count_create_engagement`; confirmed owner identity was recognized; transaction ended with `ROLLBACK`.
> - Read-only catalog verification returned no Supervisor write policies on Admin-owned CountFlow tables. Assignment, presence, audit and device workflows remain separate.
> - CountFlow row counts remain zero for projects, members, sessions, products and entries.
> - Reduced Supervisor inline JS parses; only `live`/ `team` tabs remain and no Admin mutation paths remain; Counter role filter no longer includes auditor.
>
> ### Still OPEN
> - Phase 2: streaming XLSX/CSV import, row-level partial failures, server-side product pagination and virtualized rendering.
> - Phase 3: export memory/image handling and explicit pricing policy, standalone deployment paths, Playwright fixes and browser QA.
> - Cloudflare deployment, authenticated browser E2E and 90,000-row stress tests have not been verified.
>
> ### Governance / successor instructions
> - The explicit 2026-11-21 mandate overrides historical LVE-747 hold only for CountFlow P1. It does not authorize SMART ERP or legacy ERP changes.
> - Resume from LVE-749; inspect current HEAD/live contracts before modifying. Do not replay the archived migration history.
> - Admin powers remain server-enforced; only `counter` may submit counted quantities; `auditor` is a non-capture role.
> - Do not report Cloudflare deployment, browser QA or 90k performance as passed without direct evidence.
>
> ---
>

**Last Verified Event:** `LVE-2026-11-20-746-CountFlow-Execution-Handoff`  
**Date:** 2026-11-20  
**Repository:** `papamohammed77-glitch/erp-frontend`  
**Application path:** `companies/company-2/Counting/`  
**Supabase project:** `rawaea-staging`  
**Project ref:** `hfzznsiprnwkpayskzhu`

## 1. Current source snapshots

| Artifact | Current Git blob SHA |
|---|---|
| `countflow-admin.html` | `57127597826ff479b52ce392c4c560afaf3c9994` |
| `countflow.html` | `6bbd9db32682e6e48429d85ebaf061d3ff965e25` |
| `Countflow-supervisor.html` | `e30452120e2307472bcccfb8e3e06261d51b2734` |
| `README.md` | `fc98f54bb092ba68b9872c1c1d69524d4caf6241` |
| `ARCHITECTURE.md` | `0183e7cd6fe15c32c1df07b7e3f88e56e0b8a999` |
| `DEPLOYMENT.md` | `478fafbf6671e7d0d8b781baf9dc0414c9449bec` |
| `scripts/build-pages.sh` | `865629e8f1061f403f426f9c712d0ec00fdd9793` |
| `index.html` | `707a5a0f18674a93cab811be23ea9a13abb4a91b` |
| `countflow-core.js` | `43395393093ba9bba94959dc1cc71457327a4e5e` |
| `countflow-sw.js` | `408fe0047d230535ae482230ea892e2edbb663f2` |
| `manifest.webmanifest` | `dc5fa4e24234586c398da958e5a0463d7316d7fb` |
| `countflow-icon.svg` | `7540be49299b57849a8cb25a163981730571d6a5` |
| `_headers` | `799b5b51882d12ed2503fb41ad04633145d24468` |
| `functions/counting-provision-member/index.ts` | `77010c28969553757eaf268fd9950192453c878b` |
| `functions/counting-export-session/index.ts` | `5eb45460267f794ad10cce2ef0ef27a9c52b4632` |
| `database/migrations/20261120170000_countflow_platform_owner_verified_email.sql` | `b59d12d4047ed2ce8ab5b0528b93fde6cd3a8591` | 
| `database/migrations/20261120171000_countflow_license_settings_unbounded_emails.sql` | `09dd07432dbec5a71cfeaa09198abb1d9ff640af` |
| `database/migrations/20261120200000_countflow_atomic_engagement_and_operation_create.sql` | `725ce36cdd06fde99e45ca6d4c7ce6539e2cfde2` |
| `database/migrations/20261120230000_countflow_server_session_lifecycle.sql` | f2a8d067fa6bf3a64d77e3f7a39ded18470d8113 |
| `tests/countflow_core_integration_rollback.sql` | 1afe0c483db3c6e10b2efc10340096f3117e372d |
| `tests/rollback-smoke.sql` | 9e182511601dd764d50a7fff013293e89d18d501 |
| `tests/countflow_approval_finality_rollback.sql` | c09bfd3147fadbda21a019d38037ff3f4fe72eba |
| `tests/import_90k_rollback.sql` | d72d9ee724071446aa96888fc124a056e3470760 |
| `FINAL_EXECUTION_REPORT_LVE-746.md` | da3083d6a0847b7da9d4b78da50d1f65e14b295d |
| `database/migrations/README.md` | `ee02b814026f7f30a3fbeb9356c85085dde77d53` |

## 2. Verified Supabase structure

- 23 `count_*` tables; all 23 have RLS enabled.
- 76 CountFlow RLS policies.
- 78 validated foreign-key constraints; all are validated and every CountFlow table has a primary key.
- Zero grants to `anon`; zero authenticated TRUNCATE/TRIGGER/REFERENCES grants.
- `count_entries` client grants are SELECT and INSERT only (append-only).
- `count_assignments` has one `NULLS NOT DISTINCT` unique scope index, enabling atomic upsert for both global and location-specific assignments.
- Administrative audit triggers capture project/member/session/assignment/recount/rule/device/evidence changes; heartbeat-only device/member updates are suppressed. Export completion is explicitly logged with the authenticated supervisor and file integrity metadata.
- Expected-balance rows use the product base unit. A scoped product/location may carry expected_quantity = NULL when the client has no book balance; that location remains mandatory for counting and is never treated as zero.
- Reconciliation runs store `entry_count_snapshot`; approval checks the latest run, unchanged entry count, zero uncounted positions, no open recount tasks, and no unresolved critical alerts. Approval moves the session to `review` and freezes further count inserts.
- CountFlow private Broadcast authorization is scoped by project/session/member topic; live broadcast triggers are attached to operational tables.

## 3. Deployed Edge Functions

| Function | Version | JWT | State |
|---|---:|---|---|
| `counting-provision-member` | 6 | Required | ACTIVE |
| `counting-export-session` | 12 | Required | ACTIVE |

Both functions also authorize the platform owner only when the authenticated Auth email is owner@rawaea.com and is confirmed; ordinary supervisors still require active membership in the target engagement. The export function creates a 13-sheet XLSX or detailed CSV, stores the artifact in the private `counting-exports` bucket, and records SHA-256, size, row count, and a signed URL. All UI exports now use this server pipeline; it also includes import rejection details, evidence image links, device/presence, and session audit history. Successful export is itself written to the audit log; failed completion removes orphaned Storage objects.

## 4. Completed behavior and regression tests

Historical checkpoint at LVE-744: the latest live migration was `20261120004422` (`20261120200000_countflow_atomic_engagement_and_operation_create`). This was superseded by later CountFlow migrations; see the current live ledger version recorded under LVE-746. The owner/license migrations are recorded at live versions `20261119232523` and `20261119232615`; ledger versions are not identical to the Git source filename timestamps. See database/migrations/README.md for reconciliation.

- Continuous camera scanning (detection throttled to 200 ms), location barcode selection, repeated same-product scan quantity increment, and a save-before-switch safeguard.
- Import pipeline uses 1,000-row staging chunks and detailed row outcomes; location reads/import mapping are paginated.
- Base-unit conversion snapshots on count entries; reconciliation and exports use normalized quantities.
- Automatic quantity/repeat-scan alerts and automatic variance alerts after reconciliation.
- Recount tasks, review/approval, and finality/immutability gates.
- All XLSX/CSV exports use the server-side pipeline; the browser no longer builds large workbooks. The function has configured row limits (150k per major dataset, 250k combined) that have not yet been load-tested.
- Supervisor logout control; assignment upsert is atomic and duplicate-safe.

Executed seven SQL regression suites (all rollback-only; no persistent test data):
1. `tests/countflow_core_integration_rollback.sql`
2. `tests/countflow_unit_recount_rollback.sql`
3. `tests/countflow_anomaly_rollback.sql`
4. `tests/countflow_approval_finality_rollback.sql`
5. `tests/countflow_assignment_upsert_rollback.sql`
6. `tests/countflow_expected_balance_snapshot_rollback.sql`
7. `tests/countflow_admin_audit_rollback.sql`

Final residue check: zero CountFlow projects, members, sessions, products, entries, exports, and zero temporary test users.

## 5. Isolation and account state

The applications call CountFlow tables only and do not call ERP stock, sales, treasury, or accounting tables. However, the Supabase project itself still contains 70 non-CountFlow public tables, 24 Edge Functions, and 1,868 pre-existing Auth users. Six legacy functions have `verify_jwt=false`; none are CountFlow functions. These legacy objects were not modified because their ownership/usage is outside this task. Thus current separation is logical at the application/data-access level, not a physically clean Supabase project boundary.

There are currently zero CountFlow members and zero CountFlow projects. No existing Auth identity was assigned a CountFlow role. Permanent staff accounts were not fabricated because no employee roster/emails were supplied. The first supervisor must be created in Supabase Auth; after that, the supervisor app can create members through `counting-provision-member`.

## 6. Verification limits / next execution gates

- Playwright non-destructive smoke tests are prepared under `tests/e2e/` but were not run: no permanent supervisor/counter credentials or confirmed deployed app origin were available.
- The large export Edge Function is deployed and source-matched, but a real authenticated XLSX/CSV export has not yet been exercised end-to-end.
- The 90,000-row import rollback test was independently re-run on 2026-11-19 and passed; the 90,000-row export, camera-device compatibility matrix, offline queue recovery after browser termination, WebSocket Broadcast delivery under real concurrent clients, and 30–300 user load tests remain unverified.
- Global Supabase security advisor still reports 65 ERROR and 15 WARN on legacy objects; none are CountFlow findings. Performance advisor's single WARN concerns duplicate indexes on `public.erp_operation_registry`, outside CountFlow.
- Do not modify or delete legacy ERP tables/functions as part of CountFlow work. Do not create persistent accounts without a confirmed roster. Do not run any test that writes to ERP inventory, treasury, or accounting.

## 7. Safe continuation order

1. Obtain/confirm the actual CountFlow supervisor and counter roster and the published app origin.
2. Create the first supervisor Auth user, create the first CountFlow project, then provision named users through the supervisor app.
3. Run Playwright smoke tests with environment-injected credentials and a designated assigned location/product; the scan test must not click Save.
4. Run a dedicated, reversible CountFlow-only import test with representative CSV/XLSX and then a 90k-row load test in an isolated dataset.
5. Exercise one real authenticated server export and verify workbook sheets, signed URL, SHA-256, and export history.
6. Run concurrent Broadcast/load tests before making any scale-readiness claim.


## 8. LVE-2026-11-19-734 — Current verified continuation

**Operational source HEAD:** main / 3e963eaddb286d6e805e9c8028075df6b20387f5  
**CountFlow path delta:** 24 commits after the previous local state pin; 8 CountFlow files changed.  
**Live Supabase ledger:** 53 CountFlow migrations; 14 tracked SQL artifacts; 39 applied migrations have no standalone SQL source in the current Git folder. The two recent location/heatmap migrations 20261119195107 and 20261119195202 are absent from Git. The 19195630 source file maps to live ledger version 19195750. See Report734.

### Reverified tests (rollback-only)
- 90,000-row import: PASS; 90,000 submitted/staged/accepted/products, 90 chunks, one transaction ending in ROLLBACK.
- Location hierarchy/heatmap: PASS; cycle guard passed, 2 count events, path WH / A-01, 1 counted position, 100% coverage, refresh stable; transaction ended in ROLLBACK.
- Reconciliation after both runs: every one of the 21 count_* tables had exactly 0 rows; Auth remained 1,868; no QA identities remained.

### Newly confirmed P1/P2 gaps — OPEN
1. Critical state tables still allow authenticated supervisor direct DML that bypasses their stronger RPC contracts:
   - count_reconciliation_runs UPDATE has a supervisor policy and no audit or state-guard trigger.
   - count_sessions UPDATE/DELETE has a supervisor policy; no server-side state-transition guard.
   - count_recount_tasks UPDATE/DELETE can bypass count_review_recount_task; audit exists but no transition guard.
   - count_import_rows UPDATE/DELETE has no trigger; count_commit_import_batch trusts row_status='staged' and does not fully revalidate the staged row.
   - count_alerts UPDATE is used directly by the supervisor UI and has no audit trigger or mandatory resolution reason.
2. Offline queue entries are tied to the currently loaded active/paused session. After approval moves the session to review, Counter no longer loads it and the local queue becomes hidden/non-syncable. The supervisor close gate has no per-device sync acknowledgement.
3. Supervisor setSession(status) reloads sessions before its automatic export, then reads the mutable global session.id. It can export the wrong session or throw after the close succeeds.
4. retryQueueBtn clears sync_error on all IndexedDB queue records, not only the current project/session/member.
5. counting-provision-member may return success with audit_warning after the Auth/password mutation if the audit insert fails.
6. Counter location loading has a 20,000-row hard stop without an explicit overflow error.

### Operational limits
- No CountFlow project/member/supervisor account exists.
- No real staff roster or confirmed app origin was supplied; do not assign any of the 1,868 legacy Auth users.
- No authenticated Browser E2E, real server export, physical camera test, cross-device Realtime test, or load test was performed.
- No DDL, persistent DML, ACL/RLS change, Edge deployment, or non-count_* write was performed.

### Next gate
Prepare and obtain approval for CS-CF-734-A/B: server-authoritative session/reconciliation/recount/import/alert state transitions plus offline queue close-handshake and stable export session ID. Do not apply until the exact change set, rollback, and acceptance tests are approved.


---

# LVE-2026-11-19-735 — CountFlow security containment checkpoint
**Report:** https://github.com/papamohammed77-glitch/rawaie-erp-New/blob/main/doc/Draft/Reprots/Report735_DAILY_CTO_SECURITY_BUYER_COUNTFLOW_20261119.md

## Current live state
- Project rawaea-staging ref hfzznsiprnwkpayskzhu, ACTIVE_HEALTHY.
- CountFlow: 21 count_* tables, 70 policies, 72 validated FKs; all 21 RLS enabled; no anon grants; all CountFlow tables empty; count_projects=0; count_members=0.
- Auth users 1,868; no CountFlow memberships or supervisor bootstrap identity confirmed.
- Two CountFlow Edge Functions remain JWT-required and source-matched.
- 2,027 Realtime warning attempts; realtime.messages partitioned parent has no child partitions.

## New P0 security blocker
The same Supabase project contains legacy ERP objects:
- 65 public tables outside CountFlow have RLS disabled.
- 56 legacy tables have anon DML grants.
- public.users has 1,871 rows, includes password_hash/permissions/role/auth_id columns, RLS disabled, and anon SELECT/INSERT/UPDATE/DELETE/TRUNCATE.
- role_permissions and categories also have anon CRUD.
- post_inventory_adjustment_atomic, receive_purchase_atomic, save_sales_invoice_atomic are SECURITY DEFINER and executable by anon; their actor lookup trusts p_user_email rather than binding it to auth.uid().
No values from password_hash or personal records were read; no RPC was called; no exploit was performed.

**Decision:** CountFlow is separate from SMART ERP by project ref, but rawaea-staging is not cleanly isolated from legacy ERP. Do not deploy CountFlow, provision users, or run write tests until an owner-approved containment design is implemented. Do not modify legacy objects without explicit approval.

## Other P1s retained from LVE734
- Direct authenticated DML on count_sessions, count_reconciliation_runs, count_recount_tasks, count_import_rows, count_alerts, count_import_batches bypasses stronger RPC/state guards.
- count_generate_recount_tasks accepts approved runs although count_reconcile_session rejects a new run when an approved run exists.
- Counter queue becomes hidden after session enters review/completed; retryQueueBtn clears sync_error globally.
- Supervisor setSession reloads sessions before exporting, so global session can point elsewhere/null.
- Broadcast sends are failing at realtime.messages partition layer; no child partitions; heatmap polling alone does not refresh all dashboard panels.
- No Service Worker/manifest in Counter or Supervisor; IndexedDB queue does not prove offline boot/recovery.
- 46 of 60 CountFlow/Counting migration ledger entries do not have independent SQL artifacts in the migration directory/archive is not replayable.

## No execution
No code, schema, ACL, RLS, account, deployment, or business-data changes were made. No new tests were run. Readiness remains BLOCKED for operation; read-only audit/documentation only.


**Documentation-only follow-up after LVE735:** Report735 and the LVE735 state/memory addenda were saved. The operational repo then received commit 2676526ee4214ae98aa89742b48cf40172cd1976 updating only companies/company-2/Counting/CURRENT_STATE.md; no app code, SQL migration, schema, ACL, or business data changed. The source-code baseline used for the audit remains 4f7fba271d35d463364a5659f8e181dabad41215.


---

## LVE-2026-11-20-736 — Independent CountFlow master and canonical app names

**Date:** 2026-11-20  
**Scope:** CountFlow only — `companies/company-2/Counting/` and Supabase project `rawaea-staging` (`hfzznsiprnwkpayskzhu`).

### Confirmed repository changes
- Renamed `Counter.html` to `countflow.html`; file contents were preserved byte-for-byte at rename time (blob `93ad77a682585b8ec04cdcf224e2ac81b28cb180`).
- Renamed `Counter-supervisor.html` to `Countflow-supervisor.html`; file contents were preserved byte-for-byte at rename time (blob `11101374a8f27d78d042f750b162dba9303174b6`).
- Removed the superseded filenames only after the canonical copies were committed. Directory listing confirms only the canonical names remain.
- Created `countflow-admin.html`, an independent Arabic RTL master UI for CountFlow. It authenticates with Supabase Auth and uses only the existing `count_*` contracts: project bootstrap, product catalog CRUD/activation, member provisioning through the existing JWT-protected `counting-provision-member` Edge Function, location hierarchy, planned session creation, and audit viewing.
- First-owner bootstrap is supported: an authenticated identity with no CountFlow memberships can create its own project; the existing `count_bootstrap_project_owner` trigger creates its active supervisor membership. Existing non-supervisor memberships are denied.
- Added the master UI to README and updated canonical app links. No link to RAWAEA `main.html`, `core.js`, or `rawaea-erp.pages.dev` was added.

### Verification
- JavaScript syntax compilation of the master page script: **PASS** (one inline script block).
- `tests/rollback-smoke.sql` on `rawaea-staging`: **PASS**. Owner bootstrap, entry idempotency, assignment boundary, recount creation/entry/review, reconciliation approval/freeze, anonymous RPC denial, and append-only ledger checks passed. Entire transaction rolled back.
- `tests/countflow_core_integration_rollback.sql` on `rawaea-staging`: **PASS**. Import preview/commit (2 accepted, 1 rejected), assignment boundary, entry idempotency, recount override and reconciliation KPI assertions passed. Entire transaction rolled back.
- Post-test row counts: `count_projects=0`, `count_members=0`, `count_products=0`, `count_sessions=0`, `count_entries=0`, `count_audit_log=0`; `auth.users=1868` unchanged.
- No persistent QA identities or operational fixtures were created.

### Not yet verified / remaining gates
- **UNKNOWN:** real browser E2E for sign-in, first-owner sign-up, master forms, field app and supervisor app; static JS syntax compilation is not a browser test.
- **UNKNOWN:** whether public Auth sign-up is enabled and whether email confirmation is required in the current Supabase Auth settings.
- **NOT DEPLOYED:** no Cloudflare Pages project, custom domain, DNS, or deployment configuration was changed. The final CountFlow domain remains to be selected and configured independently.
- **NOT CHANGED:** no Supabase schema, ACL, RLS, Auth account, Edge Function deployment, Storage bucket, or persistent business row was modified.
- **OUT OF SCOPE:** the 65 legacy non-CountFlow tables and their broad exposure in `rawaea-staging` remain untouched; no connection or operation was made against SMART ERP (`fiilmooggumokxanwiyx`).

### Current readiness
- Repository rename and initial master UI: **CONFIRMED**.
- Existing CountFlow transactional core rollback suites: **PASS**.
- Full operational readiness and production publication: **BLOCKED pending browser E2E, first-owner/Auth configuration verification, remediation of the CountFlow-specific P1 workflow gaps already recorded above, and independent domain setup**.

- Added `index.html` as the CountFlow domain root entry (redirects to the master dashboard), `_headers` with baseline browser security headers, and `DEPLOYMENT.md` with the separate Cloudflare Pages configuration. README links the deployment guide.
- Current Pages output directory is documented as `companies/company-2/Counting`; no Cloudflare project or DNS was changed.


## LVE-2026-11-20-737 — Closed-session export target integrity

- Fixed the confirmed mutable-global bug in `Countflow-supervisor.html`: closing a session previously called `loadSessions()`, which could replace the global `session` before the post-close entry-count/export calls. The export could therefore target another session or fail when no eligible session remained.
- `setSession` now captures the exact `targetSessionId` before asynchronous work and uses it for the close update, post-close entry count, and server export.
- `downloadServerExport` and `loadExportHistory` now accept an explicit session ID while retaining their existing current-session default for normal user-initiated exports.
- Static JavaScript compilation of the updated supervisor page: **PASS**.
- Browser export flow and signed-file download: **UNKNOWN / not run**; no authenticated browser session or persistent CountFlow project exists.
- No database schema/data/ACL/RLS change was required.


## LVE-2026-11-20-738 — Public Pages artifact allowlist

- Added `scripts/build-pages.sh` to construct `dist/` from an explicit allowlist: `index.html`, `countflow-admin.html`, `countflow.html`, `Countflow-supervisor.html`, and `_headers`.
- Database migrations/archive, SQL rollback tests, Edge Function source, README, CURRENT_STATE, and other development artifacts are deliberately excluded from the public Pages output.
- Updated `DEPLOYMENT.md`: Cloudflare Pages build command is `bash companies/company-2/Counting/scripts/build-pages.sh`; output directory is `companies/company-2/Counting/dist`.
- Local `bash -n` syntax check of the build script body: **PASS**. The remote Pages build itself has not been run.
- No Cloudflare Pages project, domain, DNS, or deployment was created or modified.

- Follow-up validation caught and corrected the build script's project-root resolution (`scripts/build-pages.sh` now resolves its parent directory rather than the scripts directory). A local fixture run of the corrected allowlist build: **PASS** — exactly five public files published, zero SQL/Markdown/TypeScript source artifacts copied.

- Final portable-listing revision of the Pages script passed the same isolated fixture test: exactly five allowlisted public files; no SQL/Markdown/TypeScript artifacts leaked into `dist/`.


---

## LVE-2026-11-20-740 — Owner-wide customer and concurrent count operations dashboard

**Scope:** CountFlow UI and documentation only. No Supabase schema/data/ACL/Auth/Edge Function change.

### Repository changes
- Updated countflow-admin.html:
  - Reframed count_projects as customer/client organizations and count_sessions as individual count operations.
  - Added the global **عمليات الجرد القائمة** view, aggregating planned/active/paused/review sessions across all projects visible to the signed-in supervisor identity; completed/closed sessions appear separately.
  - Updated the users view to aggregate membership rows across all projects visible to the signed-in identity and display each user's customer/project.
  - The add-member form still provisions only into the currently selected project; no cross-client membership is granted implicitly.
  - Project reads now use pagination rather than the former 200-project limit. Global member/session reads are batched and paginated.
  - Added Postgres Changes subscriptions for count_sessions and count_members; event messages trigger authoritative re-fetch through RLS. A 30-second foreground reconciliation remains as a fallback.
  - Fixed a project-creation context issue: after creating a new project, the master now selects and loads that exact new project instead of leaving the previous project selected.
- Added ARCHITECTURE.md documenting tenant boundaries, owner model, RAWAEA reference patterns, offline contract, Realtime contract and verification gates.
- Updated README with the customer/operation model and global dashboard behavior (blob 0e088a1f75ffde9964184d5502004c50717760ec).

### Source hashes
- countflow-admin.html: 4b0b8727b5cdcd1d979cc40db046e175c9133cad
- ARCHITECTURE.md: c1ec5b9cfa35d1f5f905f961a52acad88dd726c7
- Admin follow-up project-selection fix commit: f9fbb0af0c4e6e86fa42379db3318a1f99f2854f

### Verification
- Inline admin JavaScript compilation: **PASS** after the global dashboard changes and project-selection fix.
- CountFlow count_members and count_sessions are present in the supabase_realtime publication: **CONFIRMED**.
- Authenticated browser login, multi-project visibility, cross-project member aggregation and actual WebSocket delivery: **UNKNOWN / not run**; no confirmed owner identity or deployed CountFlow origin is available.
- No persistent owner account was created; no pre-existing legacy Auth identity was assigned.
- No Supabase DDL, DML, grants, RLS policies, Auth identities, Edge Functions, Storage objects or Realtime internals were changed.
- No Cloudflare Pages project, DNS or custom domain was created.

### Owner model clarification
- The current database trigger count_bootstrap_project_owner grants supervisor membership to the Auth identity that creates a project.
- The master dashboard can aggregate all projects for which the signed-in identity has active supervisor membership. To administer all customer projects under one owner account, create each customer project using that same identity.
- This is **not yet a separate platform-wide super-admin role** capable of seeing projects created by unrelated supervisors. Such a role needs an explicit server-side identity binding and RLS design; it must not be granted through browser metadata or an email-only condition.
- The CountFlow Auth account is still **NOT CREATED / NOT BOUND**. The owner's email must be confirmed before identity provisioning or assignment.

### Remaining gates
1. Confirm the owner email and complete the first-owner Auth sign-in/sign-up flow; do not share the password in chat.
2. Run browser E2E against the actual CountFlow Pages origin with that account and at least two synthetic customer projects.
3. Verify user isolation by logging in as one customer supervisor and confirming that the other customer is invisible.
4. Continue the P1 offline queue close-handshake work; add a CountFlow-only Service Worker/manifest and offline shell boot without caching business data.
5. Verify cross-device Postgres Changes delivery and keep periodic reconciliation as a fallback.
6. Complete the remaining direct-DML/state-machine and Broadcast audit items before operational readiness is claimed.



---

## LVE-2026-11-20-741 — Independent CountFlow Core and offline PWA shell

### Implemented repository changes
- Added CountFlow-only runtime core: countflow-core.js.
  - Own Supabase URL and publishable key are pinned to rawaea-staging (hfzznsiprnwkpayskzhu); no SMART ERP URL/ref or core.js dependency.
  - Shared client factory used by admin, field and supervisor pages.
  - Reusable Postgres Changes invalidation helper with debounced authoritative refresh, visibility refresh and periodic reconciliation.
  - Connectivity binding helper.
  - Automatic registration of CountFlow-only Service Worker.
- Added countflow-sw.js and manifest.webmanifest plus countflow-icon.svg.
  - Precaches CountFlow app shells and approved runtime libraries (Supabase JS, PapaParse, SheetJS).
  - Network-first navigation with cached shell fallback; cache-first approved static assets.
  - Supabase Auth/REST/Storage/Edge Function requests remain network-only; no business rows, signed URLs or auth responses are cached.
  - Service Worker updates do not force-reload open tabs, avoiding an automatic navigation during field work.
- Integrated CountFlow Core, manifest and Service Worker registration into all three apps.
- Owner dashboard now uses the shared Core Postgres Changes helper for count_sessions/count_members; the 30-second reconciliation fallback remains.
- Updated Pages allowlist to publish the three pages, Core, Service Worker, manifest, icon, index and headers only.
- Updated README, ARCHITECTURE and DEPLOYMENT documentation.

### Verification
- JavaScript syntax compilation: **PASS** for all three inline application scripts, countflow-core.js and countflow-sw.js.
- Pages build fixture: **PASS** — exactly 9 allowlisted browser artifacts; zero SQL/Markdown/TypeScript/private test files in output.
- CountFlow tables count_members and count_sessions are in supabase_realtime publication: **CONFIRMED**.
- Supabase project row check: count_projects=0, count_members=0, count_sessions=0, count_entries=0. No test or owner data created.
- Real browser offline boot, cached CDN availability, PWA installation, offline write/restart/reconnect, and cross-device Postgres Changes delivery: **UNKNOWN / not run**.
- Queue close-handshake and per-device server acknowledgement barrier: **OPEN**. The Service Worker makes the shell available; it does not solve the known post-close queue replay gap.
- No Supabase schema, DML, ACL/RLS, Auth identity, Edge Function, Storage or Realtime-internal change.
- No Cloudflare Pages deployment, DNS or custom domain change.

### Remaining gates
1. Confirm the owner's email; sign up or sign in through the master page. Password is entered only in the app, never in chat.
2. Create each customer project using the same owner identity so the existing bootstrap trigger adds its supervisor membership to each project.
3. Run browser E2E for offline first boot, offline navigation/reload, cached Supabase JS/CDN libraries, queue durability, browser restart and reconnect.
4. Implement the server-authoritative session close barrier before relying on offline counts at session finalization.
5. Verify two-client concurrent operations and user isolation in authenticated browser sessions.
6. Continue direct-DML/state-transition remediation and cross-device Realtime validation before operational readiness.



## LVE-2026-11-20-742 — Corrected CountFlow engagement model and platform owner binding

**Scope:** CountFlow only; Supabase project `rawaea-staging` (`hfzznsiprnwkpayskzhu`).

### Confirmed business-model correction
- External organizations (e.g. Carrefour, Panda, warehouses, factories) are variable contracting parties, not a permanent customer master owned by CountFlow.
- Existing `count_projects` records are now presented as **independent count-engagement workspaces / تكليفات جرد**. The same contracting party can have multiple separate workspaces and sessions over time. No permanent customer registry or client deduplication was introduced.
- The database's unique `count_projects.code` constraint remains: each engagement receives its own unique engagement code. The engagement name may repeat.

### Owner authorization change — applied and verified
- Added `counting_private.is_platform_owner()`, which recognizes only the authenticated Supabase Auth identity whose email is exactly `owner@rawaea.com` and whose email is confirmed.
- Updated `counting_private.is_member(uuid)` and `counting_private.is_supervisor(uuid)` so this verified platform owner can administer all CountFlow workspaces through the existing RLS policy contracts.
- Authorization does not trust `user_metadata`, browser state, or a client-supplied email.
- Migration source: `database/migrations/20261120170000_countflow_platform_owner_verified_email.sql`.
- Database verification: helper function exists; both helper definitions contain the owner gate; projects/members/sessions remain 0.
- **Owner Auth account is NOT created yet:** read-only check found 0 Auth users with `owner@rawaea.com`. No password was generated or stored. Owner login screen now pre-fills this email and public self-signup was removed to prevent arbitrary first-user takeover.

### Master UI correction
- Updated `countflow-admin.html` terminology from permanent customer/project framing to independent count engagements.
- The owner login screen defaults to `owner@rawaea.com`; the unsafe public first-owner signup button/handler was removed.
- Commit: `098bf74d6a0a9e8a6971a5e591294f8e0cd44c0d`; blob: `2009a98015608d84eda96dab8b57a4499f3f18b1`.
- Migration commit: `52e358015b8151e11687bd87d43837bd4d698265`.

### Remaining explicit blockers / UNKNOWN
- The owner Auth identity still needs to be created/invited and its email confirmed through Supabase Auth; this connector does not expose an Auth Admin create/invite-user action. Do not create a fake account or disclose a password.
- The requested editable **إدارة التراخيص** screen and unlimited email-list behavior are not implemented yet. The exact RAWAEA license-screen contract could not be reliably extracted from the very large `company-1/main.html` source through the available GitHub file reader. Do not invent a licensing model or persist an arbitrary email list until its actual field semantics and authorization are verified. This does not authorize modifying SMART ERP.
- The independent engagement model is currently a UI/domain interpretation over the existing `count_projects` workspace table; no permanent client master table was created. Existing data is zero, so no conversion was required.
- Previously recorded P1s remain open: offline queue close/replay barrier, scoped retry reset, direct-DML state-transition bypasses, Realtime Broadcast delivery, import staging revalidation, and browser E2E.
- No browser E2E, Auth login, Cloudflare deployment, or live owner-access test has been performed.

### Safety and isolation
- CountFlow-only migration and CountFlow master HTML changed.
- No SMART ERP project, `company-1/main.html`, `core.js`, legacy ERP table/function, inventory, treasury, or accounting data was modified.
- No persistent CountFlow business data or Auth user was created.


## LVE-2026-11-20-743 — Owner license email settings and engagement terminology completion

### Implemented
- Added owner-only `public.count_platform_settings` with `license_emails text[]`; there is no application-level maximum count for email addresses.
- RLS enabled; three owner-only policies for SELECT/INSERT/UPDATE; no anon grants and no authenticated DELETE/TRUNCATE/TRIGGER/REFERENCES grants.
- Seeded one settings row containing `owner@rawaea.com` as the initial license-contact email. This is not an Auth user and does not confer login or authorization.
- Added **إدارة التراخيص** to `countflow-admin.html`: displays the fixed security owner identity, allows multiple license/contact emails (one per line), validates addresses, de-duplicates them, and saves/reloads the list. The email list does not grant access to CountFlow.
- Completed visible UI wording so the workspaces are called **تكليفات الجرد** and the contracting party name can repeat across separate engagements. No permanent customer master was created.
- The owner Auth identity remains email-confirmation-bound to `owner@rawaea.com`; public first-user signup remains removed.

### Verification
- Database: owner Auth users=0; engagement workspaces=0; memberships=0; count sessions=0.
- `count_platform_settings`: RLS=true, 3 policies, anon grants=0, unsafe authenticated grants=0, one initial settings row.
- Admin inline JavaScript syntax compilation: PASS.
- Security advisor still reports 65 legacy public tables without RLS and several legacy public SECURITY DEFINER warnings in `rawaea-staging`; these are outside CountFlow and intentionally untouched. No CountFlow finding was returned for `count_platform_settings` or `counting_private.is_platform_owner`.
- Performance advisor continues to show legacy findings including the duplicate index on `public.erp_operation_registry`; no legacy objects were changed.

### Source snapshots
- `countflow-admin.html`: `13ca11377cf3f05aad23c438c2869aeba3922ccc`.
- `20261120170000_countflow_platform_owner_verified_email.sql`: source file in `database/migrations/`.
- `20261120171000_countflow_license_settings_unbounded_emails.sql`: source file in `database/migrations/`.

### Still not complete / hard gates
- Owner Auth user creation and email confirmation have not occurred. The available connected Supabase actions do not expose Auth Admin invite/create-user; do not fake it or create credentials in SQL.
- The RAWAEA `main.html` license implementation could not be fully inspected through the available large-file reader; the CountFlow license screen therefore implements only an owner-controlled unbounded email contact list, not an invented subscription/expiry/seat licensing engine.
- Previously recorded P1s remain open: offline queue close/replay handshake, retry scoping, direct-DML state-transition bypasses, import staging revalidation, Broadcast delivery, and browser E2E.
- No authenticated browser E2E, real owner login, Cloudflare publication, or domain setup has been performed.

### Isolation
Only CountFlow master UI and CountFlow-specific migrations/settings were changed. SMART ERP, `company-1/main.html`, `core.js`, all legacy ERP tables/functions, and business balances were not touched.

---

## LVE-2026-11-20-744 — CountFlow engagement + named operation workflow

**Scope:** CountFlow only — companies/company-2/Counting/ and Supabase rawaea-staging (hfzznsiprnwkpayskzhu).

### Business model and data contract — CONFIRMED
- The contracting organization is variable per contract; it is not a permanent customer master.
- count_projects is the independent engagement workspace / ملف تكليف الجرد: name stores the contracting-party name and code is the unique engagement reference. The same contracting-party name may appear in separate workspaces with distinct codes.
- count_sessions.name is the operation name / اسم عملية الجرد, e.g. جرد شهر يناير 2027 - كارفور فرع المعادي.
- count_members remains engagement-scoped. count_assignments binds members to a specific operation and optionally to a location.
- Removing a count_assignments row removes that user from the selected operation only; it does not delete the Auth identity, engagement membership, or historic count_entries.

### Database change — APPLIED / VERIFIED
- Added public.count_create_engagement(p_client_name,p_engagement_code,p_operation_name) as a SECURITY INVOKER RPC. It validates input and inserts the engagement workspace and first planned operation in one transaction.
- Authenticated EXECUTE=true; anon EXECUTE=false.
- The live ledger contains the three owner/license/engagement migration names. The latest live version is 20261120004422; the two owner/license entries are 20261119232523 and 20261119232615.
- count_assignments RLS remains enabled; anon grants=0; existing supervisor/owner RLS scope protects assignment operations.

### Master UI — IMPLEMENTED
- countflow-admin.html creates a new engagement and its first named operation together using the RPC.
- Added the historical operation register across owner-visible engagements: search by contracting-party name, operation name or engagement code; filter by status and creation-date range; sortable columns; 50-row pagination.
- Operation detail provides team management, adding an existing engagement member, creating an account and assigning it to the selected operation, removing from this operation only, current metrics, import history, reconciliation lines, export archive, print preview, and XLSX/CSV export through the server function.
- Coverage display derives from the actual count_session_kpis contract (expected_positions/counted_positions, or total_products/counted_products fallback); it does not assume a non-existent coverage_percent_total key.
- Sorting uses actual values for the derived contracting-party, engagement-code and team-count columns, not nonexistent count_sessions fields.

### Supervisor UI — IMPLEMENTED
- Countflow-supervisor.html creates a new engagement and first named operation from an inline validated form using the same atomic RPC.
- Operation history is searchable by operation name, status and date range, with open/select behavior for completed historical operations.
- Operation assignment list has a remove-from-this-operation action. Creating a new member provisions the identity/membership through the existing Edge Function, then assigns that member to the selected editable operation.
- Completed/cancelled operations are historical in the supervisor UI: team/import/state-change controls are disabled; preview and export remain available.
- Supervisor engagement and operation history loaders now use the existing paginated fetch helper rather than a single 500-row session cap; the helper has an explicit 200,000-row safety ceiling and throws if exceeded.
- Supervisor member and assignment lists also use the shared paginated fetch helper; master operation-team and assignment lists use a 1,000-row page reader with an explicit 200,000-row safety ceiling and overflow error.
- Added printable reconciliation preview. It reads up to 5,000 detail rows for print; use server XLSX for the complete result export.
- Existing staged CSV/XLSX import and server export paths are reused; no parallel pipeline/table was introduced.

### Edge Functions — DEPLOYED / CONFIRMED
- counting-provision-member: version 4, ACTIVE, verify_jwt=true; permits active supervisor in target engagement or confirmed platform owner.
- counting-export-session: version 7, ACTIVE, verify_jwt=true; permits active supervisor in target engagement or confirmed platform owner.
- Ordinary member access remains bounded by engagement membership and operation assignment rules.

### Verification
- Inline JavaScript syntax compilation: master PASS, supervisor PASS, field page PASS.
- Database residue check: count_projects=0, count_sessions=0, count_members=0, count_assignments=0, count_entries=0, count_import_batches=0, count_exports=0.
- Auth owner account matching owner@rawaea.com=0. No new Auth identity or password was created.
- RPC privilege check: authenticated=true / anon=false. count_assignments RLS=true and anon grants=0.
- Security advisor still reports the known 65 public legacy tables without RLS; no CountFlow-specific finding for the new owner helper, license settings, or engagement RPC was returned. Legacy ERP objects were deliberately not changed.

### Not run / UNKNOWN
- No authenticated browser E2E was run: no confirmed owner Auth login or deployed CountFlow origin is available.
- Real create-member, import commit, signed XLSX/CSV download, print dialog, cross-browser UI and concurrent-device behavior are not yet browser-verified.
- No Cloudflare deployment, DNS or domain modification was made.
- Previously recorded CountFlow P1s remain open: offline queue close/replay barrier, retry scoping, direct-DML/state-transition bypasses, import staging revalidation and cross-client Broadcast delivery.

### Isolation
No SMART ERP project, company-1/main.html, core.js, legacy ERP table/function, stock, treasury or accounting object was changed. No persistent CountFlow business or Auth test data was created.

---

## LVE-2026-11-20-745 — Minimum Data, Operation Cost Snapshots, Protected Imports, Session Lifecycle and Client Balance Export

Scope: CountFlow only — companies/company-2/Counting/ and Supabase project rawaea-staging (hfzznsiprnwkpayskzhu). No SMART ERP or legacy ERP object was changed.

### 1. Product identity and minimum countable data — APPLIED / VERIFIED

- count_products.sku and count_products.name are nullable.
- A countable product must have at least one stable identifier: SKU or barcode. The database enforces this with a CHECK constraint.
- Barcode is unique within an engagement; SKU uniqueness is case-insensitive within an engagement. Values are trimmed and cannot be blank.
- base_unit remains mandatory and cannot be blank. The database no longer supplies a synthetic default unit for new products.
- Product name, category, image, alternate units, conversion definitions, expected quantity and purchase-cost metadata are optional. Missing values remain NULL/empty; the system does not invent product names, categories, image references, unit conversions or costs.
- When enriching an existing product, an omitted base unit may be reused only when SKU/barcode resolves to exactly one existing product. A new product still requires an explicit base unit.
- Product lookup, recount labels, reconciliation details and print preview use name → SKU → barcode fallback. The counter screen accepts a barcode-only product.
- Reconciliation detail label columns product_sku and product_name are nullable; operational identity remains enforced by count_products.

### 2. Operation/location scope independent from book quantity — APPLIED / VERIFIED

- count_expected_balances.expected_quantity is nullable.
- count_reconciliation_lines.expected_scope marks a product/location position that belongs to the operation even when no book balance is available.
- Import commit creates one expected-balance scope row for every committed product/location row with a resolved location, whether expected quantity is numeric or NULL.
- Re-importing a row with blank book quantity does not erase a previously stored numeric baseline.
- Reconciliation retains unknown-baseline positions and marks an uncounted scoped location as not_counted; NULL is never treated as numeric zero.
- A product may appear at multiple locations in one import batch. Duplicate product identities are rejected only when the same identity is repeated as a duplicate item row rather than a separate valid location scope.
- Approval requires all scoped positions to be counted and every imported product to have at least one effective count result.

### 3. Operation-scoped purchase-cost snapshots — APPLIED / VERIFIED

- Added public.count_session_product_costs, unique by (session_id, product_id), with operation-scoped purchase unit cost, currency, purchase unit, conversion factor to base unit, provenance type/reference/date, source batch, warning codes and audit actors/timestamps.
- count_import_rows accepts the corresponding optional cost fields. Invalid or incomplete cost metadata creates warnings; it does not reject an otherwise countable product.
- Missing source type/reference remains NULL. The import file name is not substituted as authoritative price provenance.
- When one product has inconsistent cost tuples across location rows in the same batch, every affected row receives CONFLICTING_COST_SNAPSHOT_IN_BATCH; no arbitrary tuple is chosen. A pre-existing cost snapshot is also marked conflicted so it cannot be used for valuation.
- Later enrichment may supply missing price metadata without re-sending an already known base unit.
- The client workbook calculates a value only when the count is complete and all required cost fields/provenance and positive conversion factor are present. Missing or conflicted cost produces a blank value and a row in the completion register.
- Currency totals remain separate per currency. No cross-currency addition or conversion is inferred.
- Pricing policy remains UNKNOWN: no approved business rule has yet been selected for last purchase price, weighted average, invoice-specific cost or another valuation basis. The report therefore labels calculated figures as derived from the supplied operation cost snapshot, not as accounting valuation or an accounting posting.

### 4. Import-write boundary and database authorization — APPLIED / VERIFIED

- authenticated has SELECT-only access to count_import_rows, count_expected_balances and count_session_product_costs.
- count_import_batches is readable; direct INSERT/DELETE is revoked. Direct UPDATE is restricted to mapping_id and metadata, which are the only batch fields written directly by the supervisor UI.
- Batch creation, row staging and commit are performed through validated RPCs.
- Public count_create_import_batch, count_stage_import_rows and count_commit_import_batch are SECURITY INVOKER wrappers. Privileged implementations are stored under counting_private and re-check supervisor authorization. The import-row mutation path is not exposed as a public SECURITY DEFINER endpoint.
- All three public import RPCs deny anon EXECUTE and permit authenticated EXECUTE. The private schema does not grant authenticated CREATE.
- Import commit revalidates session scope, row identity, location ownership and cross-product matches instead of trusting staged flags.

### 5. Server-authoritative session lifecycle — APPLIED / VERIFIED

- A new session must be inserted as planned; timestamps are server-managed.
- Allowed transitions: planned → active, active → paused, paused → active, approved active/paused → review, and eligible active/paused/review → completed.
- A trigger rejects direct status jumps and prevents direct timestamp edits.
- Completion requires the latest approved reconciliation, unchanged count-entry snapshot, no uncounted scoped positions, no open recount tasks, no unresolved critical alerts and no imported product without an effective count.
- Supervisor buttons use public.count_transition_session. The public RPC is SECURITY INVOKER, supervisor-scoped and denies anon; lifecycle integrity remains enforced by the private trigger guard.
- Import-row, cost-snapshot, expected-balance and session lifecycle negative cases are included in rollback-only QA.

### 6. Safe Auth identity reuse — DEPLOYED / STATICALLY VERIFIED

- counting-provision-member is version 6, ACTIVE, verify_jwt=true.
- It searches Auth identities by normalized exact email using paginated Auth Admin lookup.
- A confirmed existing identity is reused without changing its password or Auth metadata. An active engagement membership is reused idempotently.
- An unconfirmed Auth identity or an existing inactive membership is not silently reactivated; the function returns a specific conflict response.
- A new Auth identity requires a new initial password of at least 10 characters.
- owner@rawaea.com is explicitly prohibited from being attached as an ordinary team member.
- Supervisor and owner UI forms explain that an existing account does not need a password entry and that its password is not changed.
- Not Auth-E2E verified: no confirmed owner login or real browser session was available. The owner Auth identity count remains zero; no test identity/password was created.

### 7. Client-facing Excel balance export — DEPLOYED / CODE-VERIFIED; FILE E2E UNKNOWN

- counting-export-session is version 12, ACTIVE, verify_jwt=true.
- Added the client_balance export scope; it is XLSX-only and requires the latest reconciliation to be approved.
- Workbook sheets: ملخص العميل, الرصيد الفعلي, تفاصيل وحدات العد, تفصيل المواقع, and استكمالات البيانات.
- Product balance is blank when any in-scope location remains uncounted. A separate field may show the known quantity from counted locations only; it is not labelled as the complete balance.
- Unit details include entered quantity, entered unit, conversion factor, base quantity, base unit, count round/revision, timestamp, scan code and recount reference. This is an event-detail sheet; the approved result remains in the final-balance sheet.
- The workbook contains a product-image column and embeds PNG/JPEG images stored in the private counting-product-images bucket. Limits: at most 500 embedded images, at most 1 MB per image, at most 12 MB aggregate image bytes and at most 50 MB workbook size. Unsupported/oversized/missing images and external HTTPS image URLs are listed as completion gaps with their reference; external URLs are not fetched by the server.
- Images referenced by a private storage path are embedded in the XLSX OOXML package under xl/media/; the workbook also contains an image reference/status and a completion-register entry where an image is not embedded.
- Decimal valuation uses fixed-scale integer arithmetic internally: quantities at scale 4 and cost/value at scale 6; workbook numeric format shows up to six decimals. A deterministic calculation check passed: 120 ÷ 12 = 10 per base unit; 5.25 × 10 = 52.5.
- Incomplete quantities or costs remain blank; multiple currencies produce separate totals; no exchange rate or pricing policy is invented.
- Row-level import warnings are included in the completion register with item identity, source file, source row and suggested next action.
- Not generated or opened in Excel yet: no authenticated browser session and no confirmed deployed CountFlow origin were available. The Edge Function is deployed, but a signed client workbook has not been generated/downloaded/opened in Microsoft Excel or a compatible spreadsheet application during this verification pass.

### 8. Field PWA and browser-cache behavior

- Offline retry is scoped to the current project/member/device and current session; retrying one user/device does not clear other queued events.
- When offline events belong to a paused/review/completed session, they remain locally stored and are not submitted into a different or inactive session.
- countflow-sw.js build changed to countflow-sw-20261120-2 to invalidate stale shell/static caches when the updated PWA is deployed.
- Remaining P1: a fully offline device can hold unreported queue entries that the server cannot know about until that device reconnects. A server-side close barrier covering every offline device has not yet been implemented or browser-tested. Cross-client Broadcast and concurrent-device E2E remain UNKNOWN.

### 9. Verification — PASS / UNKNOWN

PASS
- Core rollback integration: barcode-only product; blank name/SKU/image preserved; same product at multiple locations; null book balance preserved as an in-scope position; real multi-location count; optional complete/partial cost metadata; late cost enrichment; unit fallback; assignment boundary; idempotency; recount; reconciliation.
- Rollback smoke: owner bootstrap, import flow through the RPC, lifecycle start/pause/resume, direct lifecycle bypass rejection, entry idempotency, assignment scope, recount creation/entry/review, reconciliation approval/freeze, append-only ledgers and anonymous RPC denial.
- Both SQL test suites execute inside transactions ending in ROLLBACK.
- Inline JavaScript syntax: admin PASS, supervisor PASS, field counter PASS, service worker PASS.
- Decimal arithmetic verification: 120 / 12 = 10, 5.25 × 10 = 52.5, and half-unit rounding at six decimals passed.
- Live CountFlow schema: 23 count_* tables, all 23 RLS-enabled; 76 CountFlow policies; 78 foreign keys, all validated; no CountFlow table without a primary key.
- Final privilege verification: direct row/baseline/cost DML is denied to authenticated except batch UPDATE(mapping_id, metadata); public import/session RPCs are SECURITY INVOKER, authenticated EXECUTE=true and anon EXECUTE=false.
- Post-test residue: projects=0, members=0, sessions=0, assignments=0, products=0, entries=0, expected_balances=0, reconciliation_runs=0, import_batches=0, import_rows=0, cost_snapshots=0 and exports=0. Auth user count remains 1,868 legacy identities; owner@rawaea.com=0.

Security/performance advisors
- No CountFlow-specific public SECURITY DEFINER or unindexed-FK finding remains after moving privileged import implementations into counting_private and indexing the new FKs.
- The advisor still reports legacy public objects such as public.inventory_count_details without RLS/primary key and other old public-schema findings; these are not CountFlow and were deliberately not changed.
- Some CountFlow indexes are reported as unused because all synthetic transactions were rolled back and there is no retained workload. They were not dropped on the basis of an empty test database.

### 10. Explicit remaining acceptance gates

1. Authenticated browser E2E using an authorized owner/supervisor login, including existing-auth reuse and new-account provisioning without creating an uncontrolled test user.
2. Deploy the PWA files to the real Cloudflare-hosted CountFlow origin; verify the new service-worker cache version, login, import, field counting, queue recovery and cross-client Realtime.
3. Generate a synthetic client-balance XLSX through the deployed Edge Function and open it with an XLSX reader/Excel-compatible application. Verify all five sheets, numeric precision, image embedding, signed download and workbook integrity. Do not claim this gate passed until the file is actually generated and inspected.
4. Complete a multi-device offline queue/close handshake so an operation cannot be closed while a disconnected device has unreported local count events.
5. Obtain an explicit business decision for the purchase-cost valuation policy (last purchase, weighted average, invoice-specific or another agreed source). Until then, pricing_policy=UNKNOWN and no single authoritative inventory valuation is claimed.
6. External HTTPS product-image references are not embedded automatically. Upload/import them into the private CountFlow image bucket (or add a separately secured best-effort client-side fetch/upload flow) before expecting an embedded image in the client workbook.

### Isolation

Only companies/company-2/Counting/ and CountFlow-specific objects in rawaea-staging were changed. No SMART ERP project, companies/company-1/main.html, core.js, legacy ERP tables/functions, inventory balance, treasury or accounting data was modified. No persistent business test data, Auth identity, password, export file or customer inventory was created.

---

## LVE-2026-11-20-746 — Execution verification and successor handoff

**Full report:** `FINAL_EXECUTION_REPORT_LVE-746.md` (full scope, evidence, unresolved gates, and mandatory successor instructions).

### Live source and deployment facts — CONFIRMED
- Git HEAD before the report/state documentation commits: `4f0d2530c25a3f5288a5defc568d00542ac58e4c`.
- `counting-export-session`: version 12, ACTIVE, JWT required; live source content exactly matches the GitHub file.
- `counting-provision-member`: version 6, ACTIVE, JWT required; live source content exactly matches the GitHub file.
- Latest live Supabase migration ledger row: version `20261120170645`, name `countflow_platform_settings_fk_index`. Migration ledger order, not migration filename timestamps, is authoritative.
- Session lifecycle guard and `count_transition_session(uuid,text)` are live. The public transition RPC is SECURITY INVOKER; authenticated EXECUTE=true, anon=false. The private trigger guard is inaccessible to authenticated callers and enforces server-side transitions/timestamps.

### Verification results — PASS / NOT RUN
- `countflow_core_integration_rollback.sql`: PASS.
- `rollback-smoke.sql`: PASS.
- `countflow_approval_finality_rollback.sql`: PASS after updating the test fixture to create the session as planned, start it via `count_transition_session`, and insert baseline via validated import RPC. No production guard was relaxed.
- JavaScript syntax: admin PASS, supervisor PASS, counter PASS, service worker PASS.
- CountFlow schema: 23 count tables / 23 RLS enabled / 76 policies. Authenticated direct DML on `count_import_rows` and `count_session_product_costs` is SELECT-only. `count_expected_balances.expected_quantity` is nullable and `count_reconciliation_lines.expected_scope` exists.
- Post-test residue: projects=0, members=0, sessions=0, assignments=0, products=0, entries=0, expected_balances=0, reconciliation_runs=0, import_batches=0, import_rows=0, cost_snapshots=0, exports=0. Auth users=1,868; owner email matches=0.
- 90,000-row import regression was NOT RUN in this verification pass because the execution tool blocked the request. Do not record it as passed for this pass; rerun after the current private-RPC import refactor with the rollback envelope intact.
- Security advisor returned no CountFlow-specific security findings. Remaining security lint findings are on legacy public objects. Performance advisor still reports old-schema findings and unused indexes including CountFlow indexes; do not drop them without a real workload/load-test.

### Handoff status
- LVE-745 behavior remains current: minimum product data, optional cost snapshots, null book-balance scope, multi-location products, client-balance export source and scoped offline retry.
- LVE-746 confirms test fixtures and lifecycle contracts are aligned. The prior direct status transition bypass is server-guarded; the finality test itself was updated to the supported workflow.
- Still OPEN: authorized browser E2E, real client XLSX generation/download/open, Cloudflare PWA deployment/verification, multi-device offline close barrier, approved valuation policy, external image upload workflow, and the current-pipeline 90k import regression.
- The detailed, ordered successor instructions are in `FINAL_EXECUTION_REPORT_LVE-746.md`. The next assistant must resume from these gates, not restart the project or create parallel apps/tables/functions.

### Isolation
No SMART ERP project, `company-1`, legacy ERP object, stock, sale, treasury or accounting record was changed. No persistent test member, project, session, product, import, count, cost snapshot or export remains.


---

## LVE-2026-11-20-747 — Daily security, workflow ACL and product-acceptance revalidation

**Date/time:** 2026-11-20 21:47 Africa/Cairo  
**Scope:** CountFlow source and rawaea-staging read-only revalidation; cross-project security findings are recorded in RAWAEA governance Report747.  
**Operational Git HEAD before this documentation update:** b48e384319436e22a2464b6d3749c3e0069f7b14.

### Source snapshots — RECONFIRMED
The following current blobs still match this checkpoint:
- countflow-admin.html: 57127597826ff479b52ce392c4c560afaf3c9994
- countflow.html: 6bbd9db32682e6e48429d85ebaf061d3ff965e25
- Countflow-supervisor.html: e30452120e2307472bcccfb8e3e06261d51b2734
- countflow-core.js: 43395393093ba9bba94959dc1cc71457327a4e5e
- countflow-sw.js: 408fe0047d230535ae482230ea892e2edbb663f2
- server session lifecycle migration: f2a8d067fa6bf3a64d77e3f7a39ded18470d8113
- import_90k_rollback.sql: d72d9ee724071446aa96888fc124a056e3470760
- FINAL_EXECUTION_REPORT_LVE-746.md: da3083d6a0847b7da9d4b78da50d1f65e14b295d

No CountFlow application source, migration, Edge Function or deployed artifact was changed in this event.

### Live Supabase structure — CONFIRMED
Project rawaea-staging / hfzznsiprnwkpayskzhu:
- 23 CountFlow public tables; all 23 have RLS enabled.
- 76 CountFlow policies.
- 78 CountFlow foreign keys; all 78 are validated.
- Zero anon SELECT/INSERT/UPDATE/DELETE grants on CountFlow tables.
- 148 total project migrations; latest live ledger row remains 20261120170645 / countflow_platform_settings_fk_index.
- counting-provision-member v6 and counting-export-session v12 are ACTIVE with verify_jwt=true. Their live index.ts contents exactly match current GitHub source (8,567 and 57,295 characters respectively).
- 24 Edge Functions exist in the project. Six legacy harness/canary functions still have verify_jwt=false; none is either CountFlow function. They were not invoked or modified.
- All CountFlow business tables remain empty: projects, members, sessions, assignments, products, entries, expected balances, reconciliation runs, import batches/rows, cost snapshots and exports = 0.
- Auth users = 1,868; owner@rawaea.com matches = 0; qa-90k test users = 0.

### Current CountFlow direct-DML boundary — CONFIRMED
- count_entries: authenticated SELECT/INSERT only; no authenticated UPDATE/DELETE.
- count_expected_balances, count_import_batches, count_import_rows and count_session_product_costs: authenticated SELECT only.
- count_sessions: authenticated supervisor INSERT/UPDATE/DELETE. The lifecycle guard runs BEFORE INSERT/UPDATE and the audit trigger records row changes, but the guard does not run on DELETE. A supervisor DELETE policy exists. Child FKs cascade session deletion to assignments, entries, presence and session cost snapshots; other child relations RESTRICT deletion. This needs an explicit deletion lifecycle gate.
- count_reconciliation_runs: authenticated supervisor INSERT/UPDATE; no DELETE policy. The table has only the Broadcast trigger, not a row-audit or lifecycle guard. Direct UPDATE can bypass count_approve_reconciliation validation.
- count_recount_tasks: authenticated supervisor INSERT/UPDATE/DELETE; audit and Broadcast triggers exist, but no state guard prevents direct UPDATE/DELETE from bypassing the recount review RPC.
- count_alerts: authenticated supervisor INSERT/UPDATE; only the Broadcast trigger is present. No row-audit or resolution-state guard was found.
- count_assignments remains supervisor-scoped direct CRUD with audit triggers; no anon grants exist.

These are workflow-integrity P1s, not anon access findings. No direct DML was executed.

### Static product/UX scan — SOURCE ONLY
All three HTML pages declare Arabic language, RTL direction and a viewport:
- Master: 3 media queries, 39 buttons, 6 forms, 31 inputs, zero aria-* attributes and zero alt attributes.
- Counter: 1 media query, 16 buttons, 6 inputs, zero aria-* attributes and one alt attribute.
- Supervisor: 3 media queries, 51 buttons, 1 form, 29 inputs, zero aria-* attributes and one alt attribute.
- countflow-core.js contains one Service Worker registration and three Postgres Changes references. Counter and Supervisor source contain Broadcast handlers (5 and 13 references respectively).
This is a static source scan only. It does not establish keyboard accessibility, screen-reader usability, responsive behavior on devices, camera compatibility, offline recovery, event delivery or measured latency. The absence of aria-* attributes is an OPEN accessibility review item, not a complete WCAG audit.

### 90,000-row regression — NOT VERIFIED
The current script was inspected: it starts with BEGIN, ends with ROLLBACK, contains no standalone COMMIT statement, and scopes permanent-table writes to auth.users and CountFlow tables only. The execution tool failed internally before returning a test result. Therefore this run is NOT PASS and must remain NOT RUN/UNVERIFIED. A subsequent read-only residue query found zero rows in every CountFlow business table and zero qa-90k Auth users. No persistent fixture was found; the tool failure prevents claiming that the test executed successfully.

### Acceptance blockers remain OPEN
- No platform-owner Auth identity exists; no roster-backed supervisor/counter accounts were created.
- No authenticated Browser E2E, actual client-balance XLSX download/open, real image embedding check, multi-device offline close-barrier test, cross-device Broadcast delivery/latency test, Cloudflare Pages deployment or device matrix was completed.
- The approved cost valuation policy remains UNKNOWN.
- The app is pre-release; source, schema and rollback suites do not prove user acceptance or deployment parity.

### Governance conflict — DO NOT RESOLVE BY ASSUMPTION
The permanent constitution §6.4 names SMART ERP Production as the sole execution database and rejects a separate staging project. The newer MASTER DAILY protocol §19 calls for isolated/Staging QA, while the current CountFlow implementation uses the existing rawaea-staging project. No new project was created. Until the owner explicitly resolves this conflict, no further CountFlow write tests or deployment should be run against rawaea-staging. Read-only verification remains permitted.

### Safety and next step
No SMART ERP stock, treasury, journal, supplier/customer ledger or custody data was changed. No CountFlow migration, ACL, RLS, Edge Function or deployment was changed. The attempted 90k test has no PASS result and no persistent residue was observed.

Next: obtain owner approval for the narrowly defined P0 security containment in SMART ERP and resolve the existing staging-governance conflict before further CountFlow write testing. Do not create accounts, commit QA data, deploy Pages, or broaden the schema.


---

## LVE-2026-11-21-748 — CountFlow master roles, users and Excel catalog import

**Date:** 2026-11-21  
**Status:** Source change committed; static verification PASS; database rollback checks PASS for the supported import paths; authenticated browser E2E and Cloudflare deployment verification remain OPEN.

### Scope and isolation
- CountFlow-only repository: `papamohammed77-glitch/rawaea-app-countflow`.
- CountFlow database context: `rawaea-staging` / `hfzznsiprnwkpayskzhu`.
- The only functional source file changed in this task is `countflow-admin.html`.
- The reference `erp-frontend/companies/company-1/main.html` remained read-only and was not modified. The GitHub connector could not return its large file content for full review; do not claim the reference source was fully inspected. CountFlow's existing HTML/data model and its current database contracts were used instead.
- No changes to SMART ERP / `fiilmooggumokxanwiyx`, legacy RAWAEA repository files, stock/treasury/accounting data, CountFlow schema, RLS, grants, migrations, Edge Functions, Supervisor app, Counter app, Core JS or Service Worker.

### Source checkpoint — CONFIRMED
- `countflow-admin.html` final blob: `884ada49d9cbb617d8f0b5917f2fde67875e0596`.
- Functional source commit: `2e503f9b8945483337a60c88f1e562f3d7e85ec9`.
- Execution report: `FINAL_EXECUTION_REPORT_LVE-748.md`; report commit `0f170ccf55012d93dd80bdda3db134109e8ad683`.
- No other application source was changed for LVE-748.

### Implemented in the CountFlow master
1. **User-role management tab:** new `roles` tab with role descriptions and a project-scoped membership roster, searching and actual role assignment changes.
2. **Role model constraint retained:** only `supervisor`, `counter`, and `auditor` are accepted by the live `count_members.role` CHECK constraint and consumed by the current apps/RLS. No custom roles or client-only permission switches were invented. Changing roles is membership-scoped, not a global Auth role change.
3. **Users tab expanded:** existing account/member provisioning still goes through the existing JWT-protected `counting-provision-member` Edge Function. Added membership pause/resume actions (`active` / `paused`) without deleting the Auth identity or other project memberships. The current account is blocked from self-role-change/self-pause in the UI; the UI also guards against demoting or pausing the last active supervisor.
4. **Products tab expanded:** XLSX/XLS/CSV parsing, first-sheet/headers preview, automatic and manual column matching, saved mapping templates, batch import via existing RPCs in chunks of 1,000, batch history and rejection/warning details. Product table is paginated 100 rows at a time; product retrieval is paginated from PostgREST with a 200,000 row operational cap.
5. **Import invariants enforced in the UI:** catalog-only import remains available when no session-bound fields are present. Expected quantities require a session and a valid location code; the import database routine only creates expected-balance rows where a location resolves. Location-scoped rows require a session. Purchase-cost metadata requires a session because costs are snapshots stored at session scope, not master product attributes.
6. No direct import writes to `count_import_rows`; staging and commit use the existing server-side RPC contract `count_create_import_batch`, `count_stage_import_rows`, and `count_commit_import_batch`.

### Verification — PASS / UNKNOWN
**Static PASS**
- Extracted inline JavaScript parses successfully.
- All ten admin navigation tabs have matching sections.
- No duplicate HTML IDs.
- Presence of the role assignment, pause/resume, XLSX parser, import RPC pipeline, session/location/cost preflight and product pagination was verified from the final GitHub blob.

**Rollback integration checks — PASS for the tested paths**
- Catalog-only synthetic import completed inside a transaction ending in `ROLLBACK`, without creating a business balance.
- Session + synthetic location + expected quantity import completed inside a transaction ending in `ROLLBACK`; the import returned one accepted row and the expected balance was found with the correct project/session/product/location/quantity.
- An earlier test of expected quantity without a location demonstrated that the server does not create an expected-balance row without a resolved location. The UI now prevents this incomplete input from being committed.
- A read-only post-test residue query returned zero rows in: `count_projects`, `count_members`, `count_products`, `count_sessions`, `count_locations`, `count_import_batches`, `count_import_rows`, `count_expected_balances`, `count_session_product_costs`, and `count_entries`. No synthetic business data remains.

**Identity — CONFIRMED**
- In the CountFlow project only, `owner@rawaea.com` now exists in Supabase Auth with `email_confirmed_at` populated. This updates the older LVE-747 observation, which preceded the owner's account creation.
- No CountFlow projects or memberships currently exist; the master roster will remain empty until a real project and memberships are created by the owner.

**Not verified**
- Browser-based signed-in E2E for role changes, membership lifecycle, workbook parsing and batch import.
- Actual Excel/CSV file selected through the page and opened/round-tripped in a browser.
- 90,000-row load/performance regression. The UI currently caps a file at 90,000 rows; this is not proof that a 90k test passed.
- Cloudflare Pages deployment of this commit and behavior on the published origin. Deployment status remains UNKNOWN.
- User-facing responsive/mobile and multi-account checks.

### Governance hold from LVE-747 — MUST PRESERVE
LVE-747 records a conflict between the standing operational constitution's database restriction and the newer daily QA protocol, and directs that no further CountFlow write tests or deployment against `rawaea-staging` occur until the owner explicitly resolves the conflict. The transient rollback-only SQL checks recorded above were performed before this prior hold was read; this is documented transparently in `FINAL_EXECUTION_REPORT_LVE-748.md`. The post-test residue check found no persistent test rows. **Do not run additional write tests or deploy this source until the owner explicitly resolves the LVE-747 governance hold.** Read-only verification and source review may continue.

### Mandatory successor instructions
- Resume from this LVE-748 checkpoint and inspect the current GitHub HEAD before editing; do not recreate the app or duplicate tabs.
- Keep all work in `rawaea-app-countflow` and `rawaea-staging` only when the governance hold has been expressly resolved. Never edit the legacy reference repository or SMART ERP.
- Do not add custom roles until the role model, all affected RLS policies and all three applications have been designed and validated together.
- Once the owner resolves the governance hold, proceed with narrow authenticated browser E2E and a small synthetic workbook first; do not assume Cloudflare deployed automatically.
- Use `FINAL_EXECUTION_REPORT_LVE-748.md` as the detailed evidence and handoff; preserve PASS / UNKNOWN / OPEN labels and do not mark deployment or 90k load verification as passed without evidence.
