# تقرير تنفيذ LVE-2026-11-28-ITEMS-TAB — المرحلة الأولى

**الحالة:** PHASE 1 COMPLETED; PHASE 2 SOURCE IMPLEMENTED — CI verification pending.  
**Last Verified Event:** 28 نوفمبر 2026 — Africa/Cairo.  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`.  
**الفرع:** `main` فقط.  
**Base HEAD:** `097ab07feb1d9e1da8851adef84c34b8f60c3ad3`.  
**Source commit:** `107a1ff284e06e498e79479f015f7c4c613a957c`.  
**CI:** [GitHub Actions run 46174583822 — SUCCESS](https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/46174583822).

## 1. ما تم التحقق منه قبل التنفيذ

- تمت قراءة `Reports/CONSTITUTION.md` كاملاً، و`CURRENT_STATE.md` كاملاً، والمهمة التنفيذية وملحقها كامليْن.
- تمت مراجعة README وAGENTS وARCHITECTURE وUSER_FIRST_ENGINEERING_PROTOCOL، وتقارير LVE-792 وLVE-793 وLVE-794، وتقارير تصميم وتنفيذ الكتالوج LVE-785 إلى LVE-790.
- تمت قراءة مرجع `Reports/RW_Items.html` ووثيقة استخراجه؛ استُخدم نمط UX فقط ولم تُنقل جداول الروائع أو الأرصدة/الأسعار أو وظائف التسوية إلى CountFlow.
- تمت مطابقة مخطط Supabase الحي: التصنيف حقل نصي في الكتالوج والمواءمة؛ لا يوجد كيان CountFlow مستقل للتصنيفات ولا حاجة لإضافته في هذه المرحلة.

## 2. تشخيص الفجوة

صفحة الصنف لم تكن غائبة: محرر كامل موجود في `countflow-admin.html` بثلاثة أقسام داخلية Accessible، وحقول نمط القياس ووحدة الأساس، ومحرر وحدات بديلة، وصورة، وإعدادات الباركود ودقة الكمية. إعادة إنشائها كانت ستكرر منطقاً مستقراً وتزيد مخاطر الانحدار.

الفجوة المثبتة كانت حقل التصنيف: نص حر في الصنف العالمي ونص حر في مواءمة المؤسسة، دون قائمة اختيار فعلية.

## 3. التغيير المنفذ

- استبدال حقل التصنيف العالمي بحقل اختيار Native Select مع قائمة مقترحات عربية تغطي الفئات العامة الشائعة، وخيار «إضافة تصنيف جديد».
- تطبيق النمط نفسه على تصنيف المؤسسة مع الإبقاء على استقلال `category` و`category_override`.
- دمج الاقتراحات العامة مع قيم التصنيف الموجودة في صفحة الدليل الحالية، وإزالة التكرار دون تغيير قيمة السجل.
- عند تحرير سجل قديم ذي تصنيف غير موجود في المقترحات، يُعرض التصنيف القديم كخيار محفوظ، ولا يُستبدل تلقائياً.
- عند اختيار تصنيف جديد، يظهر حقل نصي مساعد، وتُحفظ قيمته في نفس الحقل النصي الموجود؛ لا يتغير عقد Supabase.
- أضيف اختبار مصدر يتحقق من وجود القوائم، والاحتفاظ بقيم التصنيف القديمة، والاقتراحات، والتخصيص، وعدم إنشاء جدول تصنيفات موازٍ.

## 4. الملفات

1. `countflow-admin.html` — واجهة اختيار التصنيف وربطها بقيم حفظ Global/Client.
2. `tests/unit/countflow-quality.test.mjs` — اختبار انحدار للخيارات والتصنيفات المخصصة والمحافظة على القيم السابقة.
3. `CURRENT_STATE.md` — نقطة استئناف LVE-2026-11-28-ITEMS-TAB.
4. `Reports/FINAL_EXECUTION_REPORT_LVE-2026-11-28-ITEMS-TAB.md` — هذا التقرير المرحلي، وسيُستكمل بعد المراحل التالية.

## 5. الاختبارات والنتائج

- أضيف اختبار انحدار في `tests/unit/countflow-quality.test.mjs` لتثبيت عقد الاختيارات والاحتفاظ بالقيم السابقة وضم التصنيفات المحفوظة من النطاقين Global/Client.
- GitHub Actions run `46174583822` على SHA `107a1ff284e06e498e79479f015f7c4c613a957c`: **SUCCESS**.
- Node/source tests: **115/115 PASS**, 0 failures, 0 skipped.
- Deno type-check: **PASS**.
- Cloudflare Pages allowlisted build: **PASS**.
- Playwright Production smoke: **3/3 PASS**؛ شمل build SHA parity وRTL mobile shell وpublic login shell.
- Production/Main SHA parity: **PASS**؛ Cloudflare Production يطابق `main` على SHA `107a1ff284e06e498e79479f015f7c4c613a957c`.
- **Supabase schema:** DATABASE VERIFIED READ-ONLY — لا جدول فئات؛ الحقول النصية الحالية هي العقد المعتمد. لا Migration مطلوبة لهذا التغيير.
- **Existing data:** لم يحدث أي DML، ولم تُستخدم أي سجلات QA، ولم تُمس دفعة QA90K.
- **Authenticated Admin visual acceptance:** UNKNOWN — لم يتم تسجيل دخول Admin تفاعلياً؛ Playwright تحقق من الغلاف العام فقط.

## 6. السلامة والحوكمة

- التغيير محصور في CountFlow.
- لا تعديل على RAWAEA ERP أو SMART ERP أو `erp-frontend`.
- لا تتغير جداول أو علاقات أو صلاحيات Supabase، ولا تُنشر Edge Function.
- لا أسعار أو موردين أُضيفوا إلى Global Item Master؛ تكلفة الشراء تظل داخل Snapshot العملية وفق نموذج CountFlow.
- لم تُنشأ بيانات اختبار، ولم يُحذف أي سجل قائم.

**لم أترك أي فرع، أي بيانات تجريبية، أي ملفات مؤقتة.** الفرع الوحيد المرصود هو `main`.

## 8. المرحلة الثانية — الحقول الأساسية وباركود RCN-13

### الهدف والفجوة
طلبت المهمة توليد باركود داخلي يبدأ بـ20. المولد السابق كان ينشئ CFI-<hex> ويصنفه INTERNAL؛ لذلك لم يحقق سلوك الباركود الرقمي الذي طلبه المستخدم. بقية الحقول الأساسية كانت مرتبطة بالفعل بعقد قاعدة البيانات، فلم أعد تنفيذها.

### التعديل المرئي
- حقل باركود أساسي مع مساحة عرض منفصلة.
- زر "توليد رمز محلي 20" وزر "نسخ الرمز".
- مؤشر تحقق حي يوضح نوع الرمز ونتيجة التحقق مع رسائل عربية موجهة للمستخدم.
- تنسيق responsive لحقل الإدخال والأزرار ومؤشر الحالة.

### معيار الرمز
- RCN-13 يتكون من بادئة 20–29 + 10 أرقام مرجعية + Check Digit من GS1 Mod-10.
- الرمز يمر عبر حامل EAN-13 في عقد الخادم الحالي، لكن هذا لا يجعله GTIN عالمياً.
- عرض الواجهة يميز RCN المقيّد عن EAN/GTIN التجاري وCFI القديم.
- مولد الرمز يستخدم crypto.getRandomValues، ويستبعد القيم التي لا تحقق توزيعاً رقمياً متساوياً عند التحويل إلى decimal digits.
- قبل عرض المقترح، يُفحص عدم وجوده في الباركود الأساسي أو الوحدات البديلة أو معرّفات الكتالوج. تبقى قيود الخادم وحارس التفرد هي المرجع النهائي ضد سباق الكتابة أو التعارض.

### تحقق عقد Supabase / Counter
- DATABASE VERIFIED READ-ONLY: counting_private.resolve_item_barcode_type يكتشف الرمز الرقمي الصحيح ذي 13 رقماً بوصفه EAN13، ويتحقق من Mod-10.
- DATABASE VERIFIED READ-ONLY: Trigger count_catalog_product_master_guard يستدعي validate_global_product_master ثم normalize_product_units وassert_unique_product_barcodes؛ لا يحتاج هذا التغيير trigger أو RPC جديداً.
- CODE VERIFIED: تطبيق Counter يبحث عن primary barcode عبر count_products.barcode وعن alternate-unit barcode داخل units، ويرسل الرمز الممسوح في scan_code. لم أغير تطبيق Counter لأن المسار الحالي يحافظ على الأرقام كما هي.
- GS1: المجال 20–29 مخصص لأرقام Restricted Circulation داخل النطاق الجغرافي الذي تحدده منظمة GS1 المحلية؛ لا يُعد GTIN عالمياً مفتوحاً. يلزم تخصيص/اعتماد منظمة GS1 المحلية قبل التداول خارج البيئة المقيدة. المرجع الرسمي: https://ref.gs1.org/standards/genspecs/

### اختبارات المرحلة الثانية
- اختبار مولد RCN-13 (بادئة 20، طول 13، رقم تحقق صحيح).
- اختبار تصنيف RCN وعدم وسم EAN-13 عادي بأنه RCN.
- اختبار رفض check digit غير صحيح.
- اختبار وجود لوحة التحقق والنسخ والفحص المسبق للتكرار.
- اختبار بقاء lookup في Counter للباركود الأساسي والوحدات والرمز الفعلي الممسوح.
- CI لهذه المرحلة ما زال قيد التشغيل عند كتابة هذه النسخة من التقرير؛ لا تصنف المرحلة PASS حتى صدور SUCCESS ومطابقة Production.

### الملفات
- countflow-admin.html — واجهة RCN والتحقق والنسخ والفحص المسبق.
- tests/unit/countflow-quality.test.mjs — اختبارا انحدار جديدان.
- CURRENT_STATE.md — نقطة LVE المرحلية.
- Reports/FINAL_EXECUTION_REPORT_LVE-2026-11-28-ITEMS-TAB.md — توثيق المرحلة.

### ما لم يتغير
- لا تغييرات DDL/DML أو migration أو trigger أو RPC أو grants أو RLS.
- لم تُنشأ بيانات QA، ولم تتغير سجلات count_products أو count_entries أو دفعة QA90K.
- لم تضف أسعاراً أو مورداً إلى Global Master؛ تكاليف الشراء تبقى في جدول تكلفة الجلسة.
- لم أترك أي فرع، أي بيانات تجريبية، أي ملفات مؤقتة.


## 9. نقطة التسليم

- **المرحلة 1:** COMPLETED — صفحة الصنف/التبويبات الثلاثة موجودة، فجوة اختيار التصنيف أُغلقت، CI ناجح 115/115، Deno/Pages ناجحان، وProduction يطابق SHA المصدر.
- المرحلة 2: المصدر منفذ؛ CI وProduction/Main parity قيد التحقق. لا تُعلن مكتملة قبل توثيق التشغيل النهائي.
- المرحلة 3 لم تبدأ: تدقيق تكامل الوحدات البديلة والتحويل في Admin/Counter/الخادم.
- لا تبدأ المرحلة التالية قبل إغلاق بوابة المرحلة الثانية في CURRENT_STATE.
