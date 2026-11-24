# التقرير التنفيذي التفصيلي — LVE-771
## إصلاح توقف إقلاع النظام الأم CountFlow Admin بسبب صلاحية SELECT على count_projects

**التاريخ:** 24 نوفمبر 2026 (Africa/Cairo)  
**المشروع:** CountFlow / Supabase `rawaea-staging`  
**Supabase Project ID:** `hfzznsiprnwkpayskzhu`  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`  
**النطاق:** إصلاح إقلاع Admin فقط؛ لم تُعدّل سجلات الجرد أو عمليات الأعمال.

---

## 1. ملخص تنفيذي

تم تحديد السبب المباشر لتوقف النظام الأم بعد تسجيل الدخول. صفحة Admin الموجودة على فرع `main` كانت تنفذ استعلام تحميل المشاريع:

```js
db.from('count_projects')
  .select('id,name,code,status,created_at,created_by')
  .order('created_at', { ascending: false })
  .range(offset, offset + pageSize - 1);
```

كان العمود `created_by` محجوباً عمداً عن دور `authenticated` ضمن سياسة إخفاء هوية منشئ المشروع/مالك المنصة. لذلك كان استعلام PostgREST يفشل بـHTTP 403 / SQLSTATE 42501، وكان `loadProjects()` يرمي الخطأ إلى مسار فشل تسجيل الدخول، فتظل الشاشة في واجهة الدخول ولا تكتمل عملية تهيئة النظام.

**الحل المطبق:** إزالة `created_by` من projection الخاص بتحميل المشاريع. العمود لم يكن مستخدماً في تكوين الجدول أو قائمة اختيار المشروع؛ بيانات العرض تعتمد على الاسم والكود والحالة وتاريخ الإنشاء فقط. أبقينا حماية العمود قائمة، ولم نمنح `SELECT` شاملاً للجدول.

## 2. الأدلة قبل الإصلاح

### 2.1 أثر Console المقدم

```
GET /rest/v1/count_projects
  ?select=id,name,code,status,created_at,created_by
  &order=created_at.desc&offset=0&limit=500
403 Forbidden

Admin sign-in failed
code: 42501
message: permission denied for table count_projects
hint: Grant the required privileges ... SELECT ON public.count_projects TO authenticated
```

### 2.2 مقارنة فرعي المصدر

| المصدر | SHA قبل الإصلاح | projection |
|---|---|---|
| `main/countflow-admin.html` | `6a84965093ab3872a56b477198909e3e2bcfbaa2` | `id,name,code,status,created_at,created_by` |
| `work/lve-765-admin-ui-final-mainline/countflow-admin.html` | `c6b370047f408d0065f1e1979188cc02f1515572` | `id,name,code,status,created_at,updated_at` |

إذن كان هناك اختلاف حقيقي بين المصدر المنشور من `main` وفرع العمل الأحدث. ظهور `created_by` في Console يتطابق مع نسخة `main` القديمة، لا مع projection الآمن الموجود في فرع العمل.

### 2.3 حالة الامتيازات قبل التعديل

تمت مراجعة `information_schema.table_privileges` و`information_schema.column_privileges` مباشرة على المشروع:

- لا يوجد table-level `SELECT` على `public.count_projects` للدور `authenticated`.
- توجد امتيازات قراءة على الأعمدة التشغيلية المطلوبة، ومنها `id`, `name`, `code`, `status`, `created_at`.
- امتياز `SELECT` على `created_by` غير ممنوح للدور `authenticated`.
- امتياز `SELECT` على `updated_at` موجود، لكن لا حاجة إليه في جدول الإقلاع.

### 2.4 سياسة RLS الحالية

سياسة القراءة على `count_projects` هي:

```sql
USING (
  counting_private.is_platform_owner()
  OR counting_private.is_member(id)
)
```

لم تكن سياسة الصفوف هي سبب الفشل. كان الفشل على مستوى column privilege بسبب طلب عمود محجوب. السياسة لم تُضعف ولم تُستبدل في هذا الإصلاح.

## 3. لماذا لم نطبق اقتراح منح SELECT شاملاً؟

اقتراح PostgreSQL الوارد في رسالة الخطأ كان:

```sql
GRANT SELECT ON public.count_projects TO authenticated;
```

لم يُنفذ هذا الاقتراح للأسباب التالية:

1. يمنح الدور `authenticated` حق قراءة جميع أعمدة الجدول، وليس فقط الحقول التي يحتاجها Admin.
2. من شأنه إلغاء أثر إخفاء `created_by` الذي تم اعتماده لحماية هوية المالك.
3. استعلام قائمة المشاريع لا يستخدم `created_by` في أي جزء من واجهة العرض؛ لذلك لا توجد حاجة تشغيلية لمنح قراءته.
4. PostgreSQL/PostgREST يستطيع تنفيذ projection على الأعمدة المصرح بها، مع بقاء RLS مسؤولة عن تحديد الصفوف التي يراها كل مستخدم.

**القرار الأمني:** تصحيح الاستعلام هو الحل الأقل امتيازاً والأكثر اتساقاً مع نموذج الخصوصية. لم نمنح امتيازاً جديداً على الجدول أو العمود.

## 4. التعديل البرمجي

### 4.1 الملف: `countflow-admin.html`

المسار: مستودع CountFlow / فرع `main`.

قبل:

```js
db.from('count_projects')
  .select('id,name,code,status,created_at,created_by')
  .order('created_at', { ascending: false })
  .range(offset, offset + pageSize - 1);
```

بعد:

```js
db.from('count_projects')
  .select('id,name,code,status,created_at')
  .order('created_at', { ascending: false })
  .range(offset, offset + pageSize - 1);
```

لا يوجد تغيير في:
- ترتيب المشاريع تنازلياً حسب `created_at`.
- آلية pagination وحجم الصفحة 500.
- `projectPicker` أو جدول المشاريع.
- اختيار المشروع الحالي أو تحميل بياناته.
- سياسات RLS أو عضويات المستخدمين أو بيانات المشاريع.

العمود المحذوف لم يكن يُستهلك في العرض. بذلك أصبح الاستعلام مطابقاً تماماً للحقول المسموح بها.

**Commit:** `13c3cb32b22bc53cb63ba9f8942c6240e763c78b`

### 4.2 اختبار منع الانحدار

أضيف اختبار إلى `tests/unit/countflow-quality.test.mjs` يتأكد من:

- وجود الدالة `loadProjects()`.
- استخدام projection الآمن `id,name,code,status,created_at`.
- عدم وجود `created_by` ضمن استعلام تحميل المشاريع.
- عدم استخدام `select('*')` في هذا المسار.

**Commit:** `17cd8cd1e9ec79c7f1051c3b71ee6a153b1c370d`

## 5. معالجة Service Worker والنسخة القديمة

وجدنا أن Service Worker على `main` كان يستخدم:

```js
var CF_SW_BUILD = 'countflow-sw-20261120-2';
```

كما أن `countflow-admin.html` ضمن قائمة ملفات shell المخزنة. بقاء cache version القديم قد يجعل المتصفح يعيد تقديم HTML السابق حتى بعد تحديث المصدر.

تم تحديث الإصدار إلى:

```js
var CF_SW_BUILD = 'countflow-sw-20261124-2';
```

وبذلك يتكون cache جديد، وتتعرف آلية `activate` الموجودة على النسخة القديمة وتحذف cache shell/static القديمين وفق سياسة التنظيف المطبقة في Service Worker.

**Commit:** `41c2b5c3e67c0ab18c905ab6b018d04af6ccac29`

لم يتم تغيير استراتيجية عدم تخزين بيانات الأعمال أو نتائج REST/Realtime في Service Worker.

## 6. الاختبارات والتحقق

### 6.1 اختبار RLS / PostgreSQL بهوية المالك

نُفذ اختبار داخل معاملة مؤقتة باستخدام:

- JWT claims لحساب المالك المؤكد `owner@rawaea.com`.
- `SET LOCAL ROLE authenticated`.
- استعلام يعادل استعلام Admin بعد التصحيح.
- `ROLLBACK` لإنهاء الاختبار دون تغيير بيانات.

النتيجة التي أعادها الاستعلام:

| الفحص | النتيجة |
|---|---|
| تنفيذ الاستعلام بالحقول التشغيلية | PASS |
| عدد المشاريع التي رآها المالك في الاختبار | 1 |
| امتياز قراءة `created_by` | FALSE |
| امتياز قراءة الحقول المطلوبة | TRUE |
| تأثير الاختبار على بيانات الأعمال | لا يوجد؛ المعاملة ROLLBACK |

نتيجة الاختبار المهيكلة:

```json
{
  "query_succeeded": true,
  "visible_projects": 1,
  "created_by_select_allowed": false,
  "required_projection_allowed": true
}
```

### 6.2 فحص المصدر بعد التعديل

تمت إعادة قراءة `countflow-admin.html` من `main` والتحقق من أن `loadProjects()` يستخدم:

```
id,name,code,status,created_at
```

كما تمت إعادة قراءة Service Worker والتحقق من `countflow-sw-20261124-2`.

### 6.3 GitHub Actions

تشغيل Quality Gate المرتبط بآخر تغيير مصدر حتى وقت إعداد هذا التقرير:

- Run ID: `45481534540`
- URL: https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45481534540

النتيجة النهائية: **COMPLETED / SUCCESS** على الرأس `c7172128a5426cf904790ff95473d27cdb889a47`.

تفصيل نتائج التشغيل:
- Node test suite: **42/42 PASS**، بما فيها اختبار منع إعادة إدراج `created_by` في استعلام Admin.
- Deno type-check: PASS.
- Allowlisted Cloudflare Pages build: PASS.
- Playwright production login shell: **3/3 PASS**:
  1. نشر Cloudflare Pages يطابق رأس `main` المتوقع `c7172128a5426cf904790ff95473d27cdb889a47`.
  2. شاشة الدخول العامة تعرض RTL على عرض الهاتف دون جلسة مصادقة.
  3. شاشة الدخول العامة تعمل دون جلسة مصادقة.
- التشغيل: https://github.com/papamohammed77-glitch/rawaea-app-countflow/actions/runs/45481868275

اجتياز اختبار Pages parity يؤكد أن النسخة المستضافة وقت الاختبار كانت على رأس `main` الذي يتضمن إزالة `created_by` وتحديث إصدار Service Worker. اختبار Playwright هنا يثبت shell العام وتطابق المصدر، وليس تسجيل دخول تفاعلي ببيانات مالك حقيقية؛ صلاحية استعلام المشاريع بعد المصادقة تم إثباتها منفصلة بمحاكاة JWT في قاعدة البيانات.

## 7. حدود التحقق المتبقية

- لم يتم إدخال كلمة مرور المالك وتنفيذ جلسة دخول تفاعلية في متصفح المستخدم. تحقق Playwright من صفحة الدخول العامة وتطابق Pages، بينما تحقق SQL/JWT أثبت السماح بالاستعلام المقيد بعد المصادقة.
- تم إثبات نشر Pages ومطابقة SHA عبر Playwright في run `45481868275`; لا تزال إعادة الدخول يدوياً من جلسة المالك في متصفح المستخدم فحص قبول نهائياً اختيارياً، وليست شرطاً لإثبات إزالة سبب 403.
- إذا استمر ظهور request القديم بعد اكتمال النشر، يجب التأكد من أن الصفحة تقدم build الجديد ثم إعادة تحميل التطبيق بعد تفعيل Service Worker الجديد. لا ينبغي منح `created_by` أو table-wide SELECT كحل التفافي.

## 8. الأثر الأمني والتشغيلي

- بقي `created_by` محجوباً عن `authenticated`.
- لم تُضف امتيازات جدول أو أعمدة جديدة.
- لم تُعدل سياسات RLS.
- لم تُنشأ أو تُعدل أو تُحذف مشاريع أو جلسات أو أصناف أو إدخالات جرد.
- لم تُلمس دفعة الاستيراد التجريبية ذات 90,000 صف.
- لم تُجر تغييرات على مستودع RAWAEA ERP أو مشروع SMART ERP.

## 9. ملفات وCommits الإصلاح

| الملف | التعديل | Commit |
|---|---|---|
| `countflow-admin.html` | إزالة العمود المحجوب من project bootstrap projection | `13c3cb3` |
| `tests/unit/countflow-quality.test.mjs` | إضافة regression test لعدم طلب هوية المنشئ | `17cd8cd` |
| `countflow-sw.js` | رفع cache build version لإبطال Admin shell القديم | `41c2b5c` |

**الفرع:** `main`  
**الحالة الهندسية:** **CLOSED — Root cause removed, least-privilege preserved, SQL/JWT check PASS, CI PASS, Cloudflare Pages SHA parity PASS, production login-shell Playwright 3/3 PASS.** لا تُسجل مصادقة يدوية ببيانات المالك على أنها نُفذت.
