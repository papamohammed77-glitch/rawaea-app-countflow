# LVE-2026-11-26-789 — تحقيق وإصلاح تعذر تحميل دليل الأصناف الموحد

**Last Verified Event:** 26 نوفمبر 2026 — Africa/Cairo.  
**المستودع المعتمد:** papamohammed77-glitch/rawaea-app-countflow.  
**مسار التنفيذ:** main فقط؛ لم يُنشأ فرع عمل أو مستودع مؤقت.  
**Commit المصدر والاختبارات النهائي:** f5fdaac14389f58620b8bdac7b20afb466748f33.  
**ملف التطبيق:** countflow-admin.html — blob 010f4bdd1f2fb6a803b956e4ada70d9778d0e3cf.  
**ملف الاختبارات:** tests/unit/countflow-quality.test.mjs — blob 022a968e9d70b34025376a22892d46d7f4b0c562.  
**CI:** Run 45875097398 — SUCCESS على نفس Commit main.  
**الحالة:** ROOT CAUSE CONFIRMED — FIXED ON MAIN — 101/101 TESTS PASS — PRODUCTION SOURCE PARITY PASS — AUTHENTICATED CATALOG INTERACTION NOT MANUALLY VERIFIED.

---

## 1. ملخص الحادثة

رسالة المستخدم:

    تعذر تحميل دليل الأصناف الموحد
    TypeError: q.range is not a function
    at loadCatalog (countflow-admin:3117:67)

يظهر الخطأ عند دخول مساحة الأصناف، ويتبعه عرض شاشة الدخول من جديد. تمت مقارنة Trace المستخدم بالمصدر الحالي على main، ثم تتبع الدالة المساعدة إلى جميع مستهلكيها، ومراجعة تاريخ إدخالها، ومراجعة سلوك PostgREST Query Builder.

**النتيجة الجنائية:** الخطأ ليس ناتجاً عن فقدان جدول، أو عمود، أو صلاحية RLS، ولا عن عدم دعم Supabase للدالة range. السبب هو إرجاع PostgREST Query Builder من دالة async ثم استلامه بواسطة await؛ وبما أن Query Builder كائن thenable فإن await ينفذ الاستعلام ويعيد نتيجة الطلب بدلاً من إعادة كائن الاستعلام. بعد ذلك يستدعي الكود range على Response object لا يملك هذه الدالة.

## 2. السبب الجذري — Root Cause

### 2.1 مسار الكود الذي تسبب في الخطأ

في LVE-787 / PR #10 أُضيفت الدالة applyUnifiedCatalogFilters على النحو التالي:

    async function applyUnifiedCatalogFilters(query, filters, clientId) {
      query = applyCatalogFilters(query, { ...filters, term: '' });
      if (!filters.term) return query;
      ...
      return query.or(conditions.join(','));
    }

ثم استُخدمت في مسار تحميل القائمة ومسار تصدير CSV بهذه الصورة:

    q = await applyUnifiedCatalogFilters(q, filters, clientId);
    q = q.range(...);

هذا النمط معيب مع Supabase PostgREST Query Builder.

### 2.2 لماذا يحدث ذلك تحديداً؟

- PostgrestBuilder يطبق then() ويعمل ككائن PromiseLike / thenable.
- عند تنفيذ return query من دالة async، تطبق JavaScript Promise Resolution Procedure مبدأ thenable assimilation؛ فيتم استدعاء query.then().
- تنفيذ then() في PostgrestBuilder يرسل طلب fetch إلى PostgREST ثم يحل الوعد بقيمة الاستجابة التي تتضمن data وerror وcount وstatus.
- لذلك فإن await applyUnifiedCatalogFilters(...) لا يعيد Query Builder. بل يعيد نتيجة الطلب.
- بعدها يصل التنفيذ إلى q.range(...)، لكن q أصبح نتيجة استجابة، فتظهر TypeError: q.range is not a function.

النتيجة نفسها تحدث سواء كان البحث فارغاً أو غير فارغ؛ كما أن مسار التصدير كان يحمل العيب ذاته، ولم يكن العطل محصوراً في loadCatalog.

### 2.3 إثبات مصدر الخلل وتاريخه

- مراجعة Diff الخاص بـ PR #10 أثبتت أن applyUnifiedCatalogFilters أُدخلت في LVE-787 وهي async وتعيد query مباشرة.
- مراجعة source الحالية أثبتت وجود await غير آمن في المستهلكين الاثنين: loadCatalog وexportGlobalCatalogCsv.
- وثائق Supabase تنص على استعمال range بعد select والفلاتر: https://supabase.com/docs/reference/javascript/using-modifiers-range.
- تطبيق PostgrestBuilder يوضح أن then() ينفذ fetch ويرجع PromiseLike للاستجابة: https://github.com/supabase/postgrest-js/blob/master/src/PostgrestBuilder.ts.

إذن لا يوجد دليل على أن range اختفت من Supabase أو تغيرت واجهتها. الخلل في حدود async/await وthenable assimilation داخل تطبيق CountFlow.

## 3. السبب الثانوي لظهور شاشة الدخول

الخلل الثاني كان في معالجة فشل تهيئة التطبيق:

- مسار bootstrap كان ينفذ await loadCatalog مباشرة بعد التحقق من المستخدم وعرض واجهة التطبيق.
- TypeError كانت تخرج من bootstrap إلى معالج الاستعادة النهائي.
- المعالج النهائي كان يستدعي showLogin(friendlyErrorMessage(error)) لأي خطأ غير معالج، بما في ذلك أخطاء تحميل بيانات النظام.
- بذلك تم إخفاء appView وعرض loginView، رغم أن هذا المسار لم يستدع db.auth.signOut().

**التمييز الأمني المهم:** هذه الحالة كانت UI bounce إلى شاشة الدخول، وليست دليلاً على إبطال جلسة Auth أو تنفيذ signOut. تظل عمليات تسجيل الخروج الصريحة قائمة في حالات رفض العضوية أو الصلاحية؛ ولم يتم تجاوزها أو إضعافها في الإصلاح.

## 4. الإصلاح المنفذ على main

### 4.1 فصل Query Builder عن نتيجة Promise

تم تعديل applyUnifiedCatalogFilters بحيث تعيد Envelope عادياً غير thenable:

    if (!filters.term) return { query };
    ...
    return { query: query.or(conditions.join(',')) };

والآن يستلم المستهلك envelope، ثم يستخرج builder ويطبق range قبل تنفيذ الطلب:

    const filtered = await applyUnifiedCatalogFilters(q, filters, clientId);
    q = filtered.query.range(offset, offset + pageSize - 1);

تم تطبيق التصحيح على المسارين:
- loadCatalog: تحميل قائمة الدليل الموحد مع count والترقيم بواقع 50 صفاً للصفحة.
- exportGlobalCatalogCsv: التصدير بصفحات 500 سجل مع الحفاظ على بيانات المؤسسة المختارة.

أما استعلام count_client_products المستخدم لاستخراج معرفات الأصناف المطابقة محلياً، فيظل awaited عمداً لأنه طلب بيانات فعلي ومحدد، ثم يُضاف نطاق المعرفات إلى استعلام الكتالوج النهائي دون تنفيذ ذلك الاستعلام مبكراً.

### 4.2 عزل فشل الدليل عن المصادقة

- في مساري bootstrap للمالك ومدير العميل أصبح فشل loadCatalog محصوراً في معالج fail الخاص بالدليل، ولا يرفض bootstrap كله.
- معالج أخطاء startup العام يحافظ على appView إذا كانت state.user مثبتة، ويعرض خطأ قابلاً للاسترجاع بدلاً من عرض شاشة الدخول.
- حالات رفض عضوية العميل أو صلاحية client.read ما زالت تستدعي signOut صراحة وتعيد المستخدم إلى شاشة الدخول؛ لم يتم خفض الحماية.

### 4.3 واجهة استرداد واضحة

أضيف إلى loadCatalog مسار catch:
- يتحقق من requestToken حتى لا يكتب خطأ طلب قديم فوق نتيجة طلب أحدث.
- يستبدل مؤشر التحميل برسالة خطأ داخل الجدول ذات role=alert.
- يوضح أن جلسة الدخول محفوظة.
- يمسح ترقيم النتائج القديم حتى لا يعرض أرقاماً مضللة.
- يبقي إجراء تحديث الدليل متاحاً لإعادة المحاولة.
- يعيد رمي الخطأ إلى المعالج المناسب لتسجيله وعرض الإشعار، دون إخفائه.

## 5. اختبارات منع عودة الحادثة

أضيف اختبار سلوكي يستخرج دوال التصفية الفعلية من ملف Admin ويشغلها في VM مع PostgREST builder اصطناعي يحاكي thenable الحقيقي:

- في حالة البحث الفارغ، يعيد helper الغلاف ويظل استدعاء then على Query Builder الأساسي صفراً.
- يظل range متاحاً على Query Builder بعد انتهاء helper.
- في بحث المؤسسة، ينفذ استعلام معرفات count_client_products المقصود مرة واحدة وبنطاق 0–499.
- لا ينفذ استعلام count_catalog_products النهائي قبل أن يصل إلى المستهلك ويطبق range.
- يضيف تعبير id.in للنتائج المطابقة محلياً إلى البحث الموحد.
- يثبت الاختبار أن مساري CSV والقائمة يطبقان range على filtered.query.

وأضيفت اختبارات لحماية جلسة المستخدم:
- مسارا bootstrap للمالك ومدير العميل يعزلان فشل تحميل الدليل.
- فشل startup بعد تثبيت state.user لا يعرض شاشة الدخول قسراً.
- يبقى signOut قائماً عند فشل العضوية/الصلاحية الصريح.
- فشل تحميل الدليل يعرض alert قابلاً للاسترجاع ويحافظ على إجراء التحديث.

**نتيجة الاختبارات:** 101/101 PASS — صفر فشل.

## 6. التحقق الشامل والإنتاج

GitHub Actions Run 45875097398:

| بوابة التحقق | النتيجة |
|---|---|
| Node unit/source/streaming tests | 101/101 PASS |
| Deno type-check لوظيفتي Edge الحاليّتين | PASS |
| Cloudflare Pages allowlisted build | PASS |
| Playwright production deployment/source parity | PASS |
| Playwright RTL mobile login shell | PASS |
| Playwright public login shell | PASS |
| إجمالي Playwright | 3/3 PASS |
| إجمالي Workflow | SUCCESS |

والأهم أن اختبار production login shell deployment matches the latest main source commit نجح، وكان COUNTFLOW_EXPECTED_COMMIT يساوي f5fdaac14389f58620b8bdac7b20afb466748f33. هذا يثبت أن Cloudflare Pages كان يعرض نسخة المصدر المطابقة لآخر main الذي يحتوي الإصلاح عند تشغيل الاختبار.

هذا تحقق من تطابق النسخة المنشورة والغلاف العام، وليس اختباراً بصرياً تفاعلياً كاملاً لكل وظائف الكتالوج بحساب المالك. لم يتم إنشاء صنف أو تعديل صنف أو مواءمة مؤسسة بغرض الاختبار.

## 7. التحقق من قاعدة البيانات وحدود السلامة

تم تنفيذ استعلام SQL للقراءة فقط في rawaea-staging / hfzznsiprnwkpayskzhu:

| الجدول | العدد المقروء |
|---|---:|
| count_catalog_products | 0 |
| count_client_products | 0 |

نجح الاستعلام دون أخطاء. هذه القراءة لا تُستخدم لتفسير TypeError؛ إنها تثبت فقط أن الجدولين موجودان وقابلان للقراءة من اتصال التدقيق. الخطأ يحدث في طبقة JavaScript قبل استدعاء range على builder، وليس بسبب نتائج صفوف الجدولين.

لم يتم تنفيذ أي مما يلي:
- لا DDL أو DML أو Migration أو تعديل Schema.
- لا تغيير RLS أو Policies أو GRANT أو Triggers أو RPC definitions.
- لا Deploy أو تعديل لوظائف Edge.
- لا تعديل أو استئناف أو حذف لدفعة QA90K.
- لا كتابة Storage أو تغيير صورة أو صنف أو مواءمة مؤسسة.
- لا تعديل على RAWAEA ERP أو SMART ERP أو أي مستودع آخر.

## 8. سلسلة الإصدارات على main

- b0653e863d84bdee99285101f33f5a587267d48a — إصلاح thenable والاحتفاظ بجلسة المصادقة.
- 90e5fe64e2440b9b9eb5d5ff279b12bafd241d0a — إضافة اختبار thenable والجلسة.
- 5ade65134a1d87cbb5269c6ab9b972cc6cc0719d — تصحيح صياغة Assertions الاختبارية؛ CI ناجح 101/101 وProduction parity على هذا commit.
- 7541af4bb1874b08eb76bf291960e6817691a6e7 — إضافة واجهة خطأ قابلة للاسترجاع.
- f5fdaac14389f58620b8bdac7b20afb466748f33 — إضافة تغطية رسالة الخطأ وإجراء retry؛ وهو HEAD الذي اجتاز CI النهائي.

جميع هذه الالتزامات على main. لم يُنشأ branch أو PR لهذه الحادثة.

## 9. التراجع

الإصلاح UI واختبارات فقط ولا يتطلب DB rollback. عند الحاجة إلى التراجع، يجب استخدام Revert لالتزامات LVE-789 على main مع الإبقاء على بقية تحسينات LVE-788 وLVE-787، وعدم استعادة الملف كاملاً من نسخة أقدم دون مراجعة؛ لأن ذلك قد يلغي تحسينات واجهة سابقة.

## 10. الحالة النهائية وما بقي

**ROOT CAUSE CONFIRMED — FIXED ON MAIN — AUTOMATED QUALITY GATES PASS — PRODUCTION SOURCE PARITY PASS.**

المتبقي الوحيد هو قبول تشغيلي بصري بعد دخول المالك إلى Admin، وتجربة فتح تبويب الأصناف والبحث وتغيير المؤسسة والتصدير في جلسة مصادق عليها. لم تتوفر في جلسة التنفيذ وسيلة تفاعلية للنقر على هذه العناصر داخل المتصفح؛ لذلك لم يُعلن هذا الجزء مختبراً.

خطوات التحقق اليدوي الآمنة: تحديث صفحة Admin تحديثاً قسرياً، فتح تبويب الأصناف، اختبار تحميل القائمة والبحث وتغيير المؤسسة، ثم تجربة تصدير CSV دون حفظ أو تعديل بيانات.

**Readiness:** READY WITH LIMITATIONS — Source, regression tests, deployment parity, and CI are confirmed; authenticated catalog interaction remains an owner/runtime acceptance step.