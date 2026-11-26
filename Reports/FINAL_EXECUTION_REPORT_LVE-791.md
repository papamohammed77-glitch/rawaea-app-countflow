# تقرير التنفيذ النهائي — LVE-791
## استكمال سلامة نطاق التسليم والتحقق من وحدة تكلفة الشراء

**التاريخ:** 26 نوفمبر 2026 — Africa/Cairo  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`  
**قاعدة CountFlow الوحيدة:** `rawaea-staging` / `hfzznsiprnwkpayskzhu`  
**نقطة البداية الفعلية:** `dda38bd4be886631009ab69385d504c624c202d3`  
**الفرع الوحيد للمهمة:** `work/lve-791-export-coverage-cost-unit-integrity`  
**النطاق:** CountFlow only — لا تعديل على RAWAEA ERP أو جداول ERP القديمة.

---

## 1. القرار الهندسي المنطلق من الهدف النهائي

المنتج المطلوب ليس شاشة إدخال كميات. إنه خط تسليم مخزوني متعدد المستويات:

1. ملف تكليف يثبت كتالوج الجهة الدائم وحدود العميل.
2. بنية مواقع تمثل الفروع والمباني والطوابق والمخازن والأقسام والممرات والرفوف.
3. خطة عد تغطي كل صنف في كل موقع مطلوب، لا كل صنف ظهر له حدث عد فقط.
4. تنفيذ ميداني يثبت هوية المستخدم والجهاز والموقع والباركود والوحدة والكمية الخام.
5. تطبيع الكمية في الخادم إلى وحدة الأساس وفق تحويل موثق للصنف.
6. تسوية تثبت اكتمال المواقع والعدّ والأحداث ومهام إعادة العد والطابور قبل الاعتماد.
7. ربط تكلفة شراء للعملية يثبت وحدة الشراء ومعاملها ومصدرها وعملتها وتاريخها.
8. توليد ملف عميل يوضح الرصيد الفعلي النهائي والتفاصيل والأدلة والفجوات، دون ملء المفقود بصفر أو تحويل العملة أو وصف قيمة مشتقة بأنها تقييم محاسبي.

القاعدة الحرجة: **كتالوج الصنف، وحدود المواقع، ونتائج العد، وتكلفة الشراء أربعة أبعاد منفصلة**. لا يجوز اعتبار وجود الصنف أو سعره دليلاً على اكتمال جرده.

## 2. مصدر الحقيقة الذي تم التحقق منه

لم يُعتمد تقرير سابق كحقيقة تشغيلية منفردة. تمت مراجعة GitHub HEAD والمصدر الفعلي للـAdmin والـCounter وEdge exporter والاختبارات ومخطط Supabase وسياساته وعلاقاته ووظائفه ومشغلاته.

### حقائق مؤكدة في البداية

| البند | ما أثبته المصدر الحي |
|---|---|
| Git HEAD | `dda38bd4be886631009ab69385d504c624c202d3` |
| CI على HEAD | Node 109/109، Deno PASS، Pages PASS، Playwright 3/3 |
| جداول CountFlow | 33 جدولاً بـRLS |
| علاقات CountFlow | 109 FK معتمدة |
| وصول anon لبيانات CountFlow | لا امتيازات anon على جداول CountFlow ولا RPC CountFlow عامة |
| مشروع QA | `QA90K-20261121` — سجل تجريبي |
| الأصناف في المشروع | 41,000 |
| دفعة 90k | 90,000 صف؛ 41,000 committed و49,000 staged؛ status=committing؛ لم يتم لمسها |
| جلسة العد | مخططة؛ لا توجد أحداث عد |
| البيانات المرجعية | لا عملاء CountFlow نشطين ولا مشاريع مرتبطة بعميل في لقطة البداية |

تم التحقق كذلك من أن تحويل وحدة العد ودقة الكسور يجري في قاعدة البيانات عبر trigger `count_entries_unit_conversion_guard`؛ وأن اعتماد التسوية يفرض لقطة أحداث ثابتة ومهام إعادة عد مغلقة وتنبيهات حرجة معالجة وإقرار طوابير الأجهزة. لم يُعد بناء تلك الضوابط.

## 3. الفجوات المثبتة

### 3.1 نقص تغطية الكتالوج في ملف تسليم العميل

كان مسار `client_balance` يبني مجموعة المنتجات من اتحاد ما ظهر في:

- أسطر التسوية الأخيرة؛
- صفوف الاستيراد المرتبطة بالجلسة؛
- لقطات التكلفة؛
- أحداث العد.

هذا الاتحاد لا يساوي دليل أصناف التكليف. المنتج الموجود في `count_products` بلا حدث عد وبلا سطر تسوية وبلا تكلفة كان يغيب عن الملف تماماً، فلا يدخل في العدد المستبعد ولا في سجل الفجوات. وكان العداد `notCountedProducts` و`partiallyCountedProducts` يبدأ من صفر ولا تزيد قيمتهما في loop، فيعرض نتائج غير صحيحة.

**الأثر:** يمكن أن يبدو تقرير التسليم مكتملاً بينما لا يتضمن منتجات التكليف التي لم تظهر بعد في أي مجموعة أدلة.

### 3.2 خطأ منهج تقدير الذاكرة

كان حد التقدير 160 MiB، وكانت معادلة عدد المنتجات تستخدم `Math.min(projectProductCount, lineCount + imported + cost + entries)`. هذا ليس حدّاً أعلى آمناً؛ إنه اتحاد تقريبي قد يقل عن حجم كتالوج المشروع. كما أن حد ذاكرة Edge Function هو 256MB، وليس 160MB مساحة حرة مضمونة، وتوجد كلفة إضافية للمصفوفات ونصوص XML والصور ونسخ ZIP.

**الأثر:** لا يجوز الادعاء أن نجاح قارئ CSV/XLSX لـ90 ألف صف يثبت قدرة بناء مصنف التسليم النهائي. كما لا يجوز رفع رقم الذاكرة وحده؛ يجب بناء توليد مجزأ/خلفي قابل للاستئناف.

### 3.3 عدم اكتمال حالة الاستيراد

كان التصدير يحسب accepted upper bound من الدفعات ذات status=committed فقط، دون رفض وجود دفعة preview أو committing مرتبطة بالجلسة. ويمكن أن يتزامن التصدير مع استيراد لم يكتمل.

### 3.4 ضعف تحقق تكلفة الشراء

كان staging يتحقق من أن معامل تكلفة الشراء موجب، لكنه لا يثبت أن `purchase_unit` وحدة موجودة فعلاً في سجل الصنف ولا يطابق معاملها. مثال: صنف بوحدة أساس each وسعر شراء بوحدة QA_INVALID_PURCHASE_UNIT ومعامل 12 كان يمكن أن يبدو صالحاً حسابياً رغم عدم وجود هذه الوحدة في تعريف الصنف.

**الأثر:** يمكن احتساب قيمة رصيد صحيحة حسابياً على مدخلات ذات دلالة وحدوية خاطئة.

## 4. التغييرات البرمجية المنفذة

### 4.1 مصدر التغطية = كامل دليل التكليف

في `functions/counting-export-session/index.ts`:

- بقيت خطوة preflight قبل قراءة العلاقات الكبيرة.
- أصبح `projectProductCount` الدقيق هو أساس حساب المنتجات المتوقع؛ لم يعد اتحاد أحداث العد والتسوية يُستخدم لتخمين حجم الدليل.
- أصبحت قائمة المنتجات تُقرأ من `count_products` حسب `project_id` كاملة، ثم تتم مطابقة عدد الصفوف مع exact count؛ أي اختلاف يعطل التسليم بدلاً من إنتاج ملف ناقص.
- أصبحت حالات التغطية تُشتق لكل منتج: complete / partial / not_counted.
- أصبح `partiallyCountedProducts` و`notCountedProducts` محسوبين من جميع أصناف التكليف.
- أي صنف لا يملك سطر تسوية يظهر في ورقة `استكمالات البيانات` بسبب صريح وإجراء مطلوب.
- أي موقع غير معدود لصنف جزئي يظهر كسطر مستقل في سجل الفجوات.
- تظل الأصناف التي لا تكتمل كل مواقعها خارج ورقة الرصيد الفعلي النهائي؛ لا تتحول NULL إلى صفر.
- التصدير يرفض وجود دفعات import بحالة preview/committing مرتبطة بالجلسة، حتى لا ينتج تسليم من لقطة استيراد غير مستقرة.
- تم إضافة `PURCHASE_UNIT_FACTOR_MISMATCH` إلى قائمة التحذيرات المانعة لاحتساب القيمة.

### 4.2 تحقق موحد لوحدة شراء التكلفة

أُضيف migration:

`database/migrations/20261126213000_countflow_purchase_unit_factor_integrity_v1.sql`

ويضيف دالة trigger خاصة:

`counting_private.validate_purchase_cost_unit_snapshot()`

السلوك:

1. لا تنشئ الدالة جدولاً موازياً ولا تعدل نموذج المنتجات.
2. تستدعي helper الحالي `counting_private.unit_factor_to_base(product_id, purchase_unit)`.
3. تقارن المعامل المقدم مع المعامل الفعلي للوحدة الأساسية/البديلة بدقة 6 منازل.
4. عند عدم تطابق الوحدة أو المعامل، تضيف `PURCHASE_UNIT_FACTOR_MISMATCH` إلى warning_codes دون تغيير السعر أو الوحدة أو المعامل الوارد.
5. عند تصحيح الوحدة والمعامل، تزيل التحذير تلقائياً.
6. تطبق على `count_import_rows` حتى أثناء commit عند ربط product_id، وعلى `count_session_product_costs` عند الإدخال/التحديث المباشر.
7. الدالة SECURITY DEFINER و`search_path='' `، مع REVOKE عن PUBLIC/anon وGRANT محدود لـauthenticated/service_role لتشغيل الـtrigger.

النتيجة: لا يستطيع المصدر غير المتوافق إنتاج قيمة مالية محسوبة؛ يبقى السعر ظاهراً في سجل البيانات مع تحذير صريح حتى يصحح.

## 5. ملفات التغيير

| الملف | التغيير |
|---|---|
| `functions/counting-export-session/index.ts` | تغطية الكتالوج الكامل، exact preflight، رفض الاستيراد غير النهائي، تصنيف كامل/جزئي/غير معدود، وقفل قيمة التكلفة عند mismatch |
| `database/migrations/20261126213000_countflow_purchase_unit_factor_integrity_v1.sql` | Trigger function + trigger على جدول الاستيراد ولقطات تكلفة العملية |
| `tests/unit/countflow-quality.test.mjs` | اختبارات regression لتغطية الكتالوج والتصنيف وحراسة معامل وحدة الشراء |
| `tests/cost-unit-integrity-rollback.sql` | اختبار وحدة الشراء/التحذير وتصحيحها داخل transaction ينتهي بـROLLBACK |
| `tests/import_90k_rollback.sql` | توحيد أسماء fixtures إلى `QA_` مع الحفاظ على `ROLLBACK`؛ تشغيله الفعلي تعذر بأداة SQL، لذلك نتيجته NOT VERIFIED |
| `database/migrations/README.md` | توثيق عقد migration |
| `CURRENT_STATE.md` | LVE-791 وحالة الاستمرار |
| `Reports/FINAL_EXECUTION_REPORT_LVE-791.md` | هذا التقرير |

## 6. الاختبارات والبيانات

اختبارات المصدر الجديدة تغطي:

- إدراج كل أصناف المشروع في نطاق التسليم حتى عند غياب العد.
- عدم مساواة الدليل بمجموعة أصناف العد/الاستيراد/التكلفة.
- احتساب partial وnot counted من كل أصناف المشروع.
- تسجيل المنتج الذي لا توجد له نتيجة تسوية.
- رفض التصدير مع دفعات preview/committing.
- منع تسعير وحدة غير معرفة أو بمعامل غير مطابق.
- إزالة التحذير بعد تصحيح وحدة الشراء ومعاملها.

ملف SQL `tests/cost-unit-integrity-rollback.sql` يستخدم فقط سجلات QA90K الموجودة ويرفق اسم اختبار QA صريحاً؛ إدخال التكلفة وتحديث صف الاستيراد داخل transaction، وتنتهي المعاملة بـROLLBACK. لا تُنشأ بيانات باقية.

لم يتم تعديل أو استئناف أو حذف دفعة 90,000 صف الحالية في هذه المهمة. لم يتم تسجيل عد أو اعتماد تسوية أو إنشاء مخزون أو حسابات.


### 6.1 نتائج التحقق المنشور — LVE-791
- Live database migrations: `20261126213437 / countflow_purchase_unit_factor_integrity_v1` and `20261126215042 / countflow_purchase_cost_trigger_acl_v1`.
- `counting-export-session` deployed as version **16**, ACTIVE, `verify_jwt=true`, entrypoint `index.ts`; deployed source hash `f6a18caeafeecea77cae396fb8893a37367050a9240ce150677fcaf31ce07562`. The repository source blob is `548ab79bdc931940248cefceabfe6f90c758cf0e`.
- GitHub Actions run [45899839584](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45899839584) on `f721b52403053b50070a25c1fb87f531c3612478`: Node **111/111 PASS**, zero failed/skipped; Deno type check PASS; Pages build PASS; Playwright production shell: **2 PASS / 1 SKIPPED**. The skipped case is the main-branch-only production SHA equality assertion; the two PR-safe public shell/RTL cases passed.
- The first CI attempt exposed one outdated assertion requiring the old evidence-derived product filter. The assertion was rewritten to test the full-project catalog coverage contract; the final CI run is green.
- Cost-unit rollback smoke: PASS. The new trigger added `PURCHASE_UNIT_FACTOR_MISMATCH` to an invalid purchase UoM factor, removed it after correction to `each / 1`, then the transaction rolled back. Post-check: 0 cost rows for the QA session, the committed import row has its original blank cost values, and the existing 90k QA batch remains `committing / 41,000 accepted / 0 rejected`.
- Separate 5k and 90k import rollback calls failed inside the SQL tool before a result was returned. Both were followed by read-only residue checks: zero `QA_5K_Rollback` and `QA_90K_Rollback` projects, zero corresponding batches/products. They are **NOT VERIFIED**, not passed.


### 6.2 تضييق صلاحيات دالة التحقق — trigger-only

بعد مراجعة ACL والمشغلات الحية، تبيّن أن `validate_purchase_cost_unit_snapshot()` لا تستدعى من العميل ولا من التطبيق كـRPC؛ هي مربوطة فقط بمشغّلين BEFORE INSERT/UPDATE. لذلك أُضيف ترحيل ثانٍ:

`database/migrations/20261126215000_countflow_purchase_cost_trigger_acl_v1.sql`

- يسحب EXECUTE من PUBLIC وanon وauthenticated وservice_role.
- جرى اختبار ذلك قبل التطبيق داخل معاملة rollback: سُحبت صلاحية التنفيذ مؤقتًا، ثم أُدخلت لقطة تكلفة QA غير صحيحة من مالك قاعدة البيانات؛ اشتغل المشغّل وأعاد التحذير المتوقع، ثم ROLLBACK.
- هذا يقلل سطح SECURITY DEFINER؛ لا يمكن استدعاء الدالة كـRPC من واجهة Data API.

## 7. فجوات لم تُغلق بعد — لا تُخفى

### 7.1 تصدير 90,000 صنف وما فوق

لم أرفع سقف الذاكرة لإظهار نجاح شكلي. التوليد الحالي يجمع بيانات المنتجات والتسويات والأحداث في arrays ثم يبني XML ثم ZIP في الذاكرة. مع 90,000 منتج يتجاوز تقدير preflight المحافظ 160 MiB قبل بناء المصنف. كذلك `MAX_LINES=150000` و`MAX_ENTRIES=150000` لا يكفيان لعملية 90k ذات عدد كبير من المواقع أو أحداث العد.

المرحلة المعمارية المطلوبة لإغلاق ذلك بالكامل:

- Export Job durable state machine (queued / processing / chunked / assembling / ready / failed).
- Snapshot موحد برقم نسخة reconciliation وentry watermark وimport watermark.
- Query pagination/keyset على `count_reconciliation_lines` و`count_entries` و`count_products`، لا تجميع الكل.
- Streaming worksheet XML وZIP مع رفع resumable/chunked إلى Storage، أو تقسيم ملف العميل إلى ملفات أجزاء واضحة مع manifest/checksums ثم تجميعها بطريقة streaming.
- Retry/idempotency على chunk numbers وjob ID؛ cancellation/cleanup للأجزاء اليتيمة.
- اختبار حمل 5k ثم 90k ثم سيناريو 90k × مواقع متعددة وقياس CPU/memory/duration/Storage.
- اختبار فتح workbook في Excel والتحقق من الصور والمعادلات والصفوف والأعمدة والـSHA-256.

لا تعتبر هذه المرحلة منجزة بزيادة `MAX_EXPORT_ESTIMATED_MEMORY`.

### 7.2 بيانات متعددة الفروع/الطوابق/المخازن

الهيكل الهرمي `count_locations.parent_id` موجود، ومخرجات التسوية على مستوى المنتج/الموقع موجودة. لكن لقطة QA الحالية لا تحتوي مواقع أو أرصدة أو أحداث عد. لذا إثبات التغطية متعددة المواقع يحتاج ملف QA جديد يحمل مواقع متعددة مع Expected Balances ونتائج عد، ضمن transaction قابلة للـROLLBACK.

### 7.3 سياسة الأسعار والعملات

لا توجد سياسة مالك معتمدة لاختيار last purchase أو weighted average أو invoice-specific price. يبقى السعر المشتق من لقطة تكلفة العملية، ويجب أن تظهر العملة كما وردت دون FX. لم أصف القيمة بأنها تقييم محاسبي أو أنشئ قيوداً مالية.

### 7.4 القبول التفاعلي/المرئي

CI الحالي يختبر المصدر وبناء Pages وغلاف الدخول العام فقط. لم يتم إثبات قبول Admin بعد الدخول أو كاميرا Counter على هاتف حقيقي أو رحلة ميدانية على مئات الأجهزة.

## 8. أثر التعديل والتراجع

- لا حذف أو تعديل لسجلات QA أو عد أو تسوية أو تكلفة تشغيلية باقية.
- التراجع عن trigger: إزالة triggerين ثم إسقاط الدالة الخاصة فقط، إذا لم تُستعمل التحذيرات في تقارير أو workflows. لا تحذف البيانات أو migration history.
- التراجع عن export code: revert commit LVE-791 بعد حفظ ملفات التقارير وترك الـmigration additive؛ لا تُسقط function/trigger ما لم يتم التأكد من عدم وجود بيانات تحمل التحذير.
- لم يتم لمس أي جدول أو دالة ERP قديمة.

## 9. الحكم

**READY WITH LIMITATIONS** لسلامة النطاق وUoM للشراء والتصنيف الصحيح للمنتجات التي لم تُعد بعد، بشرط نجاح CI وrollback smoke.  
**NOT READY** لادعاء أن تصدير 90,000+ متعدد المواقع أصبح مكتملاً؛ ما زالت هناك حاجة إلى pipeline تصدير streaming/background واختبار حمل متكامل وفتح ملف فعلي في Excel.

هذا التفريق مقصود: المنصة يجب أن ترفض إخراج ملف ناقص أو قيمة مشتقة من وحدة خاطئة بدلاً من إظهار نتيجة تبدو سليمة بلا دليل.
