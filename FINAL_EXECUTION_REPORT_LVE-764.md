# تقرير تنفيذ LVE-764 — ضبط روابط صور الأصناف

**التاريخ:** 23 نوفمبر 2026  
**المستودع:** papamohammed77-glitch/rawaea-app-countflow  
**الحالة:** DB والشفرة والاختبارات الآلية مكتملة؛ اختبار Storage المصادق والعرض والتصدير الفعلي ما زال مفتوحًا. لم يحدث merge أو Production deploy.

## 1. نتيجة الفحص الأساسي

حقل `public.count_products.image_url` موجود مسبقًا كـ nullable `text`. قاعدة البيانات تضم 41,000 صنف، وكل قيم image_url فارغة. مخزن `counting-product-images` موجود وخاص (`public=false`) ويحتوي صفر ملفات. لذا لم أضف عمودًا مكررًا، ولم أختلق صورًا أو روابط placeholder، ولم أعدّل بيانات المنتجات.

## 2. ما نُفّذ

**Supabase:** طبّقت migration `20261123182553` (`countflow_product_image_reference_hardening_v1`) و`20261123182644` (`countflow_reject_ephemeral_product_image_urls_v1`). أصبحت مفاتيح التخزين الخاصة محصورة في `<project UUID>/products/<single filename>`. ضُيقت سياسات Storage الحالية مع الحفاظ على أدوار المالك والمشرف وعضويات المشروع. أضيف validator آمن وtrigger على count_products؛ staging يتحقق من صيغة المرجع، وcommit النهائي يتحقق من وجود ملف JPEG/PNG وألا يتجاوز 1 MiB. signed URLs المؤقتة ممنوعة كمرجع دائم. لم أكتب إلى `storage.objects` مباشرة.

**Admin:** عرض thumbnail ورفع الصورة موجودان أصلًا. تم تشديد filter لإنشاء signed URLs إلى products folder فقط، وتوحيد التحقق من روابط HTTPS الخارجية ورفض بيانات الاعتماد والروابط الموقّتة. عولج تعارض مهم: اختيار ملف جديد الآن يتغلب على URL قديم في حقل التحرير.

**Counter:** أضيف resolver واحد للبحث المعتاد وإعادة العد. لا يوقّع إلا مسارات المشروع داخل products، ويستخدم الدلو الخاص، ويقدم fallback للصورة الفارغة/الفاشلة، ويمنع طلبًا قديمًا من استبدال الصورة بعد تبديل الصنف أو المشروع.

**Client Balance XLSX:** مسار التصدير كان يضمّن bytes الصور بالفعل باستخدام signed URL قصير العمر ثم يضع الصورة داخل المصنف. تم تضييق قبول المرجع إلى products folder فقط. حافظت على الحدود القائمة (500 صورة، 1 MiB للصورة، وميزانية الذاكرة). الروابط الخارجية لا تُضمّن كصور داخل المصنف.

## 3. التحقق

- Supabase migrations ledger يؤكد الإصدارين 20261123182553 و20261123182644.
- المسار الصحيح للمشروع/مجلد المنتجات مقبول لمرحلة staging؛ wrong folder/traversal/cross-project مرفوضة.
- مرجع صورة غير موجودة مرفوض عند التحقق النهائي؛ HTTP وFTP وuserinfo والروابط الموقعة المؤقتة مرفوضة؛ HTTPS خارجي صالح مقبول.
- الدلو ظل خاصًا؛ 0 Storage objects؛ 41,000 منتج؛ 0 منتجات بصور؛ trigger حاضر. لم تتغير صفوف المنتجات.
- GitHub CI #203 / run ID 45240309793 على commit `ea8553583258b6bab6b8d6da1d1f15524cd757ef`: SUCCESS.
- GitHub CI #204 / run ID 45240926256 على commit `4cd281e19f11aed47621bcbcd493aa9ae0da5000`: SUCCESS.
- GitHub CI #208 / run ID 45254320320 على commit `57260b7872db2acf941f2d595b82969a5b2dbc6c`: SUCCESS. آخر بوابة على رأس الفرع: Node 41/41 PASS، 0 FAIL؛ Deno type-check PASS؛ Cloudflare Pages build PASS؛ Playwright 2 PASS / 1 SKIPPED (اختبار مطابقة SHA لـmain متخطى على فرع PR). هذه ليست اختبارات رفع صورة مصادق.
- GitHub CI #210 / run ID `45254617954` على commit `193b8362f09c744f2827620f22e8194a2fba4ddf`: SUCCESS، 41/41 Node، Deno، Pages؛ Playwright 2 PASS / 1 SKIPPED.
- GitHub CI #211 / run ID `45255276526` على commit `1baa2fc756ea95a4b96bba9e4e7fc6b602fbd4bf`: SUCCESS، 41/41 Node، Deno، Pages؛ Playwright 2 PASS / 1 SKIPPED. هذه البوابة تشمل آخر إضافة لتقرير Advisor.
- GitHub CI #212 / run ID `45255695241` على commit `15bb46ae90f309a076df423ed79645b6f9f37066`: SUCCESS، 41/41 Node، Deno type-check، Pages build؛ Playwright 2 PASS / 1 SKIPPED. هذا آخر تحقق آلي مكتمل للفرع قبل هذا الملحق.
- GitHub CI #213 / run ID `45256146718` على commit `28c064715f8222afb3eb8121f09badd84bde39ce`: SUCCESS، 41/41 Node tests، Deno type-check، Pages build؛ Playwright 2 PASS / 1 SKIPPED. شمل التقرير و`CURRENT_STATE.md` ونسخة `Reports/`.

## 4. العقبات

1. فشلت المحاولة الأولى للترحيل بسبب خطأ اقتباس داخل SQL ديناميكي. لم تُسجّل migration أو تترك تغييرات جزئية؛ تم فحص ledger والسياسات والدوال، ثم تصحيح النص وتطبيق migration بنجاح.
2. أدوات المتصفح المتاحة read-only، ولا توجد أداة Storage upload أو جلسة owner تفاعلية متاحة. لذلك لم أرفع صورة ولم أُنشئ metadata مزيفة.
3. لم يقدّم المصدر صورًا أو mapping موثوقًا للأصناف الـ41,000؛ لا يمكن جعل لكل صنف رابط صورة صالح دون ملفات فعلية أو mapping موثوق (SKU/Barcode → image).

## 5. أخطاء/قصور الأمر والشفرة والتصحيح

- افتراض أن عمود image_url غير موجود كان خطأ؛ هو موجود بالفعل، وإضافة العمود ثانيةً غير مطلوبة.
- إلزام كل صنف برابط صورة لا يمكن إنجازه بتوليد URL شكلي؛ يلزم وجود ملف حقيقي أو مصدر بيانات يربط المنتج بالصورة.
- Admin كان يعرض thumbnails أصلًا، لكن نطاق المسارات كان واسعًا أكثر من اللازم، والتحقق من HTTPS لم يمنع signed URLs المؤقتة.
- Counter كان يكرر منطق التوقيع بين البحث وإعادة العد ويوقّع أي مسار غير HTTP تقريبًا. تم توحيد المنطق وتقييده وإضافة fallback.
- سياسات Storage والتحقق في استيراد المنتجات كانت أقل تحديدًا من المطلوب؛ تم تقييد products folder والتحقق من وجود الملف عند commit.
- تصدير XLSX كان يضمّن صورًا بالفعل؛ كان يحتاج فقط إلى تشديد مسار الصورة وليس إعادة بناء آلية تضمين الصور.

## 6. Git والتسليم

- branch: `work/lve-764-product-image-urls`.
- PR #5: https://github.com/papamohammed77-glitch/rawaea-app-countflow/pull/5 — Draft / Open / Not merged.
- standards/report copy: `Reports/FINAL_EXECUTION_REPORT_LVE-764.md` (verified byte-for-byte equal to root report).
- current verified CI head before this documentation refresh: `57260b7872db2acf941f2d595b82969a5b2dbc6c`.
- application commit: `b09b0920d519ead01787011e604a100a5083c649`.
- migration-source/documentation commit: `ea8553583258b6bab6b8d6da1d1f15524cd757ef`.
- standards + Reports copy commit: `57260b7872db2acf941f2d595b82969a5b2dbc6c`.
- CI evidence documentation commit: `6e0fe09970ca5d6916dd0e939345e175283adbc6`.
- explicit `Kg/Grams` standard commit: `193b8362f09c744f2827620f22e8194a2fba4ddf`.
- Supabase Advisor handover commit: `1baa2fc756ea95a4b96bba9e4e7fc6b602fbd4bf`.
- CI #212 / final state and report commit: `15bb46ae90f309a076df423ed79645b6f9f37066`.
- CI #213 / final report refresh commit: `28c064715f8222afb3eb8121f09badd84bde39ce`.
- `CURRENT_STATE.md` محدث. هذا التقرير هو سجل التسليم لهذه المرحلة.

## 7. بوابة الإغلاق — ما يزال مفتوحًا

لا تعتبر المهمة مكتملة 100% قبل رفع صورة حقيقية عبر Storage API بجلسة owner مصادق عليها في مشروع/منتج QA معزول عن دفعة QA 90K، ثم تأكيد أن image_url يخزن object key، وأن Admin وCounter (مسح عادي وإعادة عد) يعرضان الصورة، وأن Client Balance XLSX يحتوي صورة مضمّنة فعلًا داخل `xl/media`. نظّف فقط بيانات الاختبار التي ثبت أنها أنشئت خصيصًا لهذا الغرض. لا تدمج ولا تنشر حتى توثيق هذه النتائج.

## 8. توجيهات المساعد التالي

- ابدأ من LVE-764 وPR #5، ولا تعِد تطبيق الترحيلين.
- لا تكتب SQL مباشرة إلى `storage.objects`؛ استخدم Storage API.
- لا تغيّر أو تعيد استخدام منتجات/دفعة QA 90K القائمة. أنشئ/استخدم مشروع QA منفصلًا فقط لملف صورة/منتج واحد.
- نفّذ upload → verify image_url → Admin thumbnail → Counter lookup/recount → Client Balance XLSX image media.
- بعد ذلك حدّث CURRENT_STATE والتقرير وPR body، ثم انقل PR من Draft للمراجعة. لا تدمج أو تنشر قبل تحقق E2E.
- لا تنتقل إلى المهمة التالية قبل إغلاق هذه البوابة.
## 9. معايير بيانات الأصناف المعتمدة

### Global Items
- الأصناف العالمية تُعرّف بباركود دولي EAN/UPC ويكون العد بالمسح الضوئي هو المسار الأساسي.
- يخزن الباركود في `barcode` كنص؛ يجب الحفاظ على الأصفار البادئة والقيمة الأصلية، وعدم معاملته كعدد أو استبداله بـSKU.

### In-house Items
- المخبوزات واللحوم من أمثلة الأصناف الداخلية التي تُدار بالوزن (Kg/Grams).
- يستخدم الصنف باركودًا داخليًا عند توفره، أو اختيارًا/إدخالًا يدويًا يحدد الصنف بوضوح قبل تسجيل الوزن.

### UoM and financial conversion
- كل صنف له وحدة أساس واحدة، والوحدات البديلة تُخزن في `count_products.units` بصيغة `{ name, factor_to_base }`.
- مثال: `Box = 12 pieces` عند جعل `piece` وحدة الأساس؛ معامل التحويل 12. ومثال وزن: `gram = 0.001 kg` إذا كانت `kg` وحدة الأساس.
- عمليات التكلفة والقيمة المالية يجب أن تطبع quantity/cost إلى وحدة الأساس دون تطبيق التحويل مرتين. مثال: تكلفة القطعة = تكلفة الصندوق ÷ 12، وإجمالي الصندوق = سعر الصندوق × عدد الصناديق.
- مخطط CountFlow وواجهة وحدة القياس الحالية يدعمان تخزين عامل التحويل؛ واستيراد المنتجات يتعرف على `purchase_unit`, `purchase_unit_cost`, `unit_factor_to_base`. لم يُجرِ هذا التنفيذ اختبارًا حسابيًا شاملًا لجميع تقارير التكاليف/المالية؛ لا تدّعِ إغلاق هذا الجانب حتى اختباره في مساره المالي الفعلي.

### Images and original quality
- يجب تصوير كل صنف في الكتالوج التشغيلي. غياب الصورة يعني أن معيار اكتمال بيانات الصنف لم يتحقق؛ لا تستخدم placeholders.
- `image_url` يحتفظ بمفتاح الملف الدائم `<project UUID>/products/<filename>`. لا تخزن signed URL أو رابطًا عامًا.
- Admin يرفع كائن `File` الأصلي عبر Supabase Storage API مباشرةً مع `upsert:false`، ولا يوجد Canvas أو resize/compression/transform في مسار الرفع الحالي. لذلك تُحفظ البايتات الأصلية والدقة دون خفض جودة.
- القيد الحالي: JPEG/PNG وبحجم `0 < size <= 1 MiB` كي يمكن تضمين الصور في XLSX. هذا حد قبول وليس ضغطًا للصورة.
- تُنشأ الروابط الموقعة وقت العرض فقط في Admin/Counter، ويستخدم المصدر الموقّع مؤقتًا على الخادم لقراءة bytes الصور وتضمينها داخل XLSX؛ المرجع الدائم يبقى object key.

## 10. محاولة إغلاق الاختبار الفعلي — النتيجة الحالية

**لم يتم رفع أي صورة ولم يتم إنشاء/تعديل أي صنف للاختبار في هذا التنفيذ.** لم تُنشأ بيانات وهمية في `storage.objects` ولم تُعدّل المنتجات الـ41,000.

نتائج التحقق الإضافية من بيئة `rawaea-staging`:
- يوجد مشروع CountFlow واحد فقط ظاهر في `count_projects`: `QA 90K Import Verification`، ويضم 41,000 صنف. لا يوجد مشروع QA منفصل/صغير جاهز لاستخدامه في اختبار الصورة.
- الحسابات/العضويات موجودة: المالك `owner@rawaea.com`، مستخدم `countflow-supervisor1` بدور supervisor، `countflow1` بدور counter، و`countflow-adim1` بدور auditor؛ العضويات الأربع نشطة.
- جلسة المشروع الموجودة `QA 90K Product Catalogue` حالتها `planned`، وجدول `count_assignments` لا يحتوي أي إسناد. لذلك لا توجد جلسة ميدانية فعالة مسندة يمكن استخدامها لاختبار Counter كمندوب.
- صفحة Admin المفتوحة تعرض لوحة المالك، لكن أداة Browser في سياق التنفيذ الحالي تتيح قراءة الصفحة فقط ولا تتيح النقر/اختيار ملف/إرسال نموذج. كما لا توجد أداة Storage upload مباشرة في الأدوات المتاحة.
- نتيجة ذلك أن اختبار upload → حفظ `image_url` → Admin thumbnail → Counter lookup/recount → XLSX embedded media لم يُنفذ. لا يجوز تسجيله PASS أو إغلاق LVE-764.

**القرار:** تبقى PR #5 Draft وغير مدمجة ولا يوجد نشر Production. لاستكمال الإغلاق، يلزم توفير جلسة Browser ذات صلاحية تفاعل/رفع أو تنفيذ التجربة من جلسة Owner فعلية، مع مشروع/تكليف QA مستقل وجلسة active وإسناد عضو Counter، ثم إكمال جميع خطوات E2E. لا تستخدم مشروع QA 90K الحالي كبيانات اختبار إضافية ولا تمس دفعة 90K.

## 11. التحقق النهائي والتسليم

- CI #204 / run ID `45240926256` على commit `4cd281e19f11aed47621bcbcd493aa9ae0da5000`: SUCCESS؛ 41/41 Node PASS، Deno PASS، Pages build PASS، Playwright 2 PASS / 1 SKIPPED (production SHA parity test skipped on PR branch).
- لا merge ولا نشر؛ بوابة E2E ما زالت مفتوحة.
- تم تثبيت هذه المعايير في `CURRENT_STATE.md` ونسخة التقرير في `Reports/FINAL_EXECUTION_REPORT_LVE-764.md`.
- توجيه المساعد التالي: لا يبدأ من الصفر ولا يعيد migrations؛ يجهز مشروع/جلسة/إسناد QA معزولًا، ينفذ رفع صورة أصلية مصادقًا عليه، يثبت ظهورها في Admin وCounter، يصدّر XLSX ويتحقق من `xl/media`، ثم فقط يغلق التقرير وينقل PR للمراجعة والدمج.
## 12. نتائج Supabase Advisor — ملاحظات أمان خارج نطاق LVE-764

تم إجراء فحص Security وPerformance Advisor بعد ترحيلات الصور:
- جداول CountFlow العامة الـ23 ذات البادئة `count_*` جميعها RLS مفعّل ولديها سياسة واحدة على الأقل؛ لا يوجد جدول CountFlow ضمن نتائج `rls_disabled_in_public`.
- دالتا التحقق من مرجع الصورة والـTrigger في `counting_private` لا تسمحان بتنفيذ anon أو authenticated؛ هذا هو الحد المقصود لدوال التحقق الداخلية.
- على مستوى المشروع كاملًا، ظهر 65 finding لجدول public بلا RLS، و5 دوال SECURITY DEFINER عامة يمكن لـanon تنفيذها، و14 دالة SECURITY DEFINER قابلة لـauthenticated. قائمة anon المعروضة تتضمن دوال legacy مثل `fn_audit_trigger`, `fn_delivery_relation_guard`, `post_inventory_adjustment_atomic`, `receive_purchase_atomic`, `save_sales_invoice_atomic`؛ لا تخص مسار الصور.
- ضمن دوال authenticated توجد خمس CountFlow RPCs قائمة: `count_approve_reconciliation`, `count_cancel_session_queue_barrier`, `count_report_device_queue`, `count_set_alert_status`, `count_waive_device_queue` (anon EXECUTE=false, authenticated EXECUTE=true). هي خارج تعديل LVE-764 ولم أغيّرها أو أزعم مراجعة داخلية شاملة لمنطقها. يلزم تدقيق منفصل لسياسات التفويض قبل تشغيل عملاء خارجيين.
- ظهر تحذير Auth لحماية كلمات المرور المسرّبة، و64 index غير مستخدم ومؤشر مكرر واحد على جدول ERP `erp_operation_registry`. لم تُجرَ أي تغييرات عليها في هذه المهمة.

هذه النتائج لا تغيّر نتيجة اختبارات الصور؛ لكنها مخاطر/مهام منفصلة يجب ألا تُخفى أو تُعالَج عشوائيًا داخل PR الصور، خصوصًا أن المشروع يحتوي جداول legacy غير مرتبطة بكتالوج CountFlow.
