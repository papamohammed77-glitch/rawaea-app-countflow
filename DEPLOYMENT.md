# CountFlow — النشر المستقل على Cloudflare Pages

## مصدر النشر الصحيح

- المستودع المستقل: `papamohammed77-glitch/rawaea-app-countflow`، الفرع `main`.
- جذر المشروع هو جذر هذا المستودع؛ لا تستخدم مسارات `companies/company-2/Counting` القديمة من `erp-frontend`.
- Build command: `bash scripts/build-pages.sh`.
- Build output directory: `dist`.
- صفحة الجذر: `index.html` وتحوّل إلى `countflow-admin.html`.
- النظام الأم: `/countflow-admin.html`.
- تطبيق المندوب: `/countflow.html`.
- لوحة المشرف: `/Countflow-supervisor.html`.
- Supabase: المشروع `rawaea-staging` فقط (`hfzznsiprnwkpayskzhu`).

## إعداد Cloudflare Pages

1. أنشئ مشروع Pages مستقلًا باسم CountFlow، ولا تربطه بمشروع Pages الخاص بـRAWAEA ERP.
2. اربط مستودع `papamohammed77-glitch/rawaea-app-countflow` والفرع `main`.
3. عيّن Build command إلى `bash scripts/build-pages.sh`.
4. عيّن Build output directory إلى `dist`.
5. لا تستخدم `erp-frontend` أو `companies/company-1` أو `rawaea-erp.pages.dev` كجذر أو alias أو redirect.
6. اختبر الصفحات الثلاث على عنوان Pages المؤقت قبل ربط دومين مخصص.
7. أضف الدومين بعد أن يحدده مالك المشروع؛ لا توجد قيمة دومين مؤكدة في هذا المستند، ولا يجوز تخمينها.

ينشئ `scripts/build-pages.sh` مجلد `dist` من قائمة سماح تضم صفحات HTML الأربعة وملفات Core/SW/PWA و`_headers`. لا ينسخ `database/` أو `functions/` أو `tests/` أو ملفات Markdown أو SQL أو TypeScript إلى المخرجات العامة.

## أصول PWA وOffline

- `countflow-core.js` هو النواة المستقلة للتطبيقات الثلاثة، ويثبت عميل Supabase على مشروع CountFlow فقط.
- `countflow-sw.js` يخزن أغلفة التطبيقات والملفات الثابتة ومكتبات CDN المعتمدة لتوفير إمكانية فتح الواجهة بعد تحميلها أول مرة.
- طلبات Supabase Auth وREST وStorage وEdge Functions تظل Network-only ولا تدخل Cache Storage.
- Service Worker لا يفرض إعادة تحميل قسرية على تبويبات العمل المفتوحة عند تحديثه.
- وجود ملفات PWA لا يثبت وحده نجاح Offline؛ يجب تنفيذ اختبار متصفح فعلي بعد أول فتح متصل، ثم قطع الشبكة وإعادة فتح تطبيق المندوب والتحقق من IndexedDB queue والمزامنة بعد عودة الاتصال.

## حدود النشر الحالية

- ملفات الواجهة تستخدم Supabase Publishable Key فقط. لا تضف Service Role Key إلى ملفات الواجهة أو متغيرات Pages العامة.
- Edge Functions الخاصة بـCountFlow يجب أن تبقى على مشروع `rawaea-staging`، مع JWT verification مفعّل.
- هذا الدليل وتصحيح المسارات لا يثبتان نشر Pages أو تعديل DNS. حالة النشر الفعلي تبقى UNKNOWN حتى تحقق مباشر من Cloudflare وorigin.
- قبل الإطلاق: نفّذ اختبارًا فعليًا لتسجيل الدخول، bootstrap المالك، إنشاء مشروع، إنشاء مستخدم عبر Edge Function، وإكمال دورة جرد تجريبية قابلة للحذف، بعد إزالة قيود الحوكمة ذات الصلة.
