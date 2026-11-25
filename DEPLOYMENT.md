# CountFlow — النشر المستقل على Cloudflare Pages

## مصدر النشر الصحيح

- المستودع المستقل: `papamohammed77-glitch/rawaea-app-countflow`، الفرع `main`.
- جذر المشروع هو جذر هذا المستودع؛ لا تستخدم مسارات `companies/company-2/Counting` القديمة من `erp-frontend`.
- Build command: `bash scripts/build-pages.sh`.
- Build output directory: `dist`. The build writes `build-info.json` containing the exact 40-character source commit SHA; CI waits for the Pages Production origin to serve the expected SHA before declaring deployment parity.
- صفحة الجذر: `index.html` وتحوّل إلى `countflow-admin.html`.
- النظام الأم: `/countflow-admin.html`.
- تطبيق المندوب: `/countflow.html`.
- لوحة المشرف: `/Countflow-supervisor.html`.
- Control للمراقب/المراجع (قراءة فقط): `/countflow-control.html`.
- Supabase: المشروع `rawaea-staging` فقط (`hfzznsiprnwkpayskzhu`).

## إعداد Cloudflare Pages — الحالة الحية

- مشروع Pages المستقل `rawaea-app-countflow` موجود بالفعل في حساب Cloudflare، ويعرض Production / `main` مع Automatic deployments enabled في مراجعة المتصفح للوحة Cloudflare بتاريخ 2026-11-21.
- عنوان Pages الإنتاجي المؤكد: `https://rawaea-app-countflow.pages.dev`. لا يوجد دومين مخصص مثبت هنا؛ لا تخمّن نطاقاً ولا تضف alias إلى RAWAEA ERP.
- المصدر الصحيح: المستودع `papamohammed77-glitch/rawaea-app-countflow`، الفرع `main`.
- Build command المعتمد في هذا الدليل: `bash scripts/build-pages.sh`.
- Build output directory المعتمد في هذا الدليل: `dist`.
- آخر مطابقة موثقة لـCloudflare Production بعد LVE-763: commit `f26b8b6c0e91bfe626e997e2f654cf6df2905516`، main CI run `45232321254`، واختبارات Production Playwright **3/3 PASS** شملت مطابقة SHA الدقيقة وواجهات RTL على الهاتف. شملت نسخة الويب شريط Gamification للمندوب وتبويب إنجازاتي.
- لا تنشئ مشروع Pages ثانياً. عند تحديث main، راقب سجل Production حتى يكتمل النشر التلقائي، ثم افتح صفحات Admin وCounter وSupervisor وControl على نطاق Pages الإنتاجي وتأكد من عدم وجود أخطاء تحميل أو stale assets.
- لا تستخدم `erp-frontend` أو `companies/company-1` أو `rawaea-erp.pages.dev` كجذر أو alias أو redirect.

ينشئ `scripts/build-pages.sh` مجلد `dist` من قائمة سماح من أحد عشر ملفاً: خمس صفحات HTML (بوابة الدخول والتطبيقات الأربعة)، وملفات Core/SW/manifest/icon الأربعة، `_headers` و`build-info.json` الذي يسجل SHA المصدر. لا ينسخ `database/` أو `functions/` أو `tests/` أو ملفات Markdown أو SQL أو TypeScript إلى المخرجات العامة.

## أصول PWA وOffline

- `countflow-core.js` هو النواة المستقلة للتطبيقات الأربعة، ويثبت عميل Supabase على مشروع CountFlow فقط.
- `countflow-sw.js` يخزن أغلفة التطبيقات والملفات الثابتة ومكتبات CDN المعتمدة لتوفير إمكانية فتح الواجهة بعد تحميلها أول مرة.
- طلبات Supabase Auth وREST وStorage وEdge Functions تظل Network-only ولا تدخل Cache Storage.
- Service Worker لا يفرض إعادة تحميل قسرية على تبويبات العمل المفتوحة عند تحديثه.
- وجود ملفات PWA لا يثبت وحده نجاح Offline؛ يجب تنفيذ اختبار متصفح فعلي بعد أول فتح متصل، ثم قطع الشبكة وإعادة فتح تطبيق المندوب والتحقق من IndexedDB queue والمزامنة بعد عودة الاتصال.

## حدود النشر الحالية

- ملفات الواجهة تستخدم Supabase Publishable Key فقط. لا تضف Service Role Key إلى ملفات الواجهة أو متغيرات Pages العامة.
- Edge Functions الخاصة بـCountFlow يجب أن تبقى على مشروع `rawaea-staging`، مع JWT verification مفعّل. في 2026-11-23 نُشرت `counting-export-session` بالإصدار **v15 ACTIVE** و`verify_jwt=true`؛ محتوى `index.ts` الحي يطابق حرفياً Git blob `500552796f988e56aa944fd2942c0d9e98efe34e`، وبصمة Edge runtime `8d3d8de9b2cf39351346325a5279c8b8d8c27f0b35d183639e1656f3d8ea61c4`.
- مشروع Pages ونطاق الإنتاج موجودان. إثبات SHA بعد دمج LVE-763 هو `f26b8b6c0e91bfe626e997e2f654cf6df2905516` في run `45232321254`؛ فحص `build-info.json` طابق Cloudflare Production مع هذا الـSHA. فحوص CI على `main` تنتظر `build-info.json` وتطابق SHA التطبيق الفعلي. تحقق من أحدث run بعد كل دمج. لا يوجد دليل على تعديل DNS أو إضافة دومين مخصص.
- بعد ظهور نشر يطابق HEAD: شغّل Playwright باستخدام حسابَي مشرف ومندوب معتمدين، ثم اختبر دورة جرد QA قابلة للتنظيف في `rawaea-staging` فقط. لا تستخدم بيانات تشغيل حقيقية ولا تنفذ ترحيلاً إلى ERP.
