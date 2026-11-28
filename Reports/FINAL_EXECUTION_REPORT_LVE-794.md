# تقرير التنفيذ — LVE-794
## نقل واجهة تصوير الرف (Shelf Camera MVP) من العمل التاريخي إلى main

**التاريخ:** 28 نوفمبر 2026 — Africa/Cairo  
**المستودع:** `papamohammed77-glitch/rawaea-app-countflow`  
**قاعدة البيانات:** `rawaea-staging` / `hfzznsiprnwkpayskzhu`  
**نقطة main قبل التغيير:** `98c1ae2d9d828dbe98ff6793c11e9605bd91312a`  
**العمل التاريخي:** PR #6 — `work/lve-765-camera-mvp` — كان مفتوحًا، Draft، وغير قابل للدمج المباشر بسبب تباعد تاريخ الفرع عن main.  
**قرار التنفيذ:** نقل أجزاء الميزة المطلوبة جراحيًا إلى النسخة الحالية من `countflow.html`، لا نسخ ملف الفرع القديم فوق main ولا إعادة تطبيق SQL.

---

## 1. ملخص القرار الهندسي

لم يكن غياب الكاميرا يعني غياب مخطط قاعدة البيانات. أظهر المصدر الحالي أن ملفي الترحيل موجودان بالفعل على main، كما أظهر سجل Supabase الحي أن كليهما مطبق. الفجوة التي عولجت هنا كانت واجهة المندوب ومسار الرفع واختبارات المصدر، مع المحافظة على نسخة Counter الأحدث التي تتضمن تحسينات BarcodeDetector وGamification وتغييرات ما بعد 23 نوفمبر.

لم يُستخدم PR #6 كدمج مباشر؛ فالمقارنة الحية أظهرت أنه يحتوي على أربعة commits إضافية لكنه متأخر عن main بنحو 150 commit، وGitHub أعاد `mergeable=false`. نقل محتوى الملف كله كان سيستبدل تغييرات أحدث. لذلك تم استخراج مكونات Shelf Camera فقط ودمجها في نقاط الارتكاز الحالية.

## 2. فحص Supabase الحي — READ ONLY

المشروع: `hfzznsiprnwkpayskzhu`.

| الفحص | النتيجة |
|---|---|
| Migration `20261123211241` | موجودة باسم `countflow_shelf_image_camera_mvp_v1` |
| Migration `20261123211841` | موجودة باسم `countflow_shelf_image_integrity_and_cleanup_v1` |
| Bucket `shelf-images` | موجودة |
| Bucket public | `true` |
| File size limit | 10,485,760 bytes (10 MiB) |
| MIME allowlist | image/jpeg, image/png, image/webp |
| `count_shelf_images` RLS | enabled |
| Storage upload/delete policies | 2 موجودة بالاسمين المتوقعين |
| Registered shelf-image rows | 0 |

**لم يتم تنفيذ أي DDL/DML أو تعديل Storage أو صلاحيات.** لم تُرفع صورة، ولم تُنشأ بيانات QA، ولم تتغير جلسة الجرد أو إسناداتها. صفر السجلات نتيجة قراءة فقط.

## 3. التغييرات البرمجية

### 3.1 `countflow.html`

أضيفت لوحة تصوير مستقلة مباشرة أسفل حقل باركود الصنف، قبل إرشادات مسح الأصناف. تتضمن:

- إدخال ملف هاتف `accept="image/*" capture="environment"` لطلب الكاميرا الخلفية على الأجهزة التي تدعم هذا التلميح.
- زر تشغيل معطل حتى يصبح سياق المندوب/الجلسة/الموقع مؤهلاً.
- معاينة محلية للصورة قبل الحفظ، مع الإلغاء وتحرير Object URL عند الاستبدال أو الإغلاق.
- زر تأكيد مستقل لمنع رفع الصورة تلقائيًا بمجرد الالتقاط.
- تحذير خصوصية يصرح بأن Bucket عام، وأن حامل رابط الكائن يستطيع مشاهدة الصورة.

**الفصل عن Barcode camera:** بقي مسار `BarcodeDetector` الحالي لقراءة الأكواد مستقلاً. لا يرسل Frame من فيديو المسح إلى Storage، ولا يغير مسار `findProduct` وظيفة الكاميرا القائمة.

### 3.2 قيود السياق والتحقق من الملف

قبل إتاحة الالتقاط/الرفع، تتحقق الواجهة من:
1. وجود مستخدم Auth.
2. عضوية نشطة بدور `counter`.
3. وجود مشروع وجلسة حالتها `active`.
4. اختيار موقع من قائمة المواقع التي حمّلها التطبيق بعد تصفية نطاق الإسناد.
5. اتصال الإنترنت.

الملفات المقبولة: JPEG/PNG/WebP فقط، أكبر من صفر، وبحد أقصى 10 MiB. هذه حراسة واجهة وليست بديلًا عن الخادم؛ فحدود Bucket وسياسات Storage وRLS على سجل الصور وTrigger تطابق MIME والحجم موجودة في الترحيلات المطبقة.

### 3.3 مسار الرفع وسلامة الربط

- اسم الكائن يتكون من `project/session/member/location/shelf-timestamp-uuid.ext`.
- الرفع يستخدم `upsert:false` والملف الأصلي `File` دون Canvas أو إعادة ضغط أو Resize.
- بعد نجاح Storage upload، يعيد التطبيق فحص سياق الواجهة ثم ينشئ سجل `count_shelf_images` بقيم project/session/member/location/MIME/size.
- إذا فشل إنشاء السجل، يحاول حذف الكائن غير المسجل وفق سياسة rollback المحدودة.
- إذا تغير سياق المشروع أو الجلسة أو الموقع، يحاول حذف الكائن ويرفض تسجيله.
- يمنع الحارس المحلي النقر المكرر خلال الرفع، ويعطل اختيار المشروع/الموقع مؤقتًا.
- لا يطبع التطبيق Public URL أو object path في Console.

### 3.4 Service Worker

تم تحديث `CF_SW_BUILD` من `countflow-sw-20261125-9` إلى `countflow-sw-20261128-1` لإبطال shell cache السابق، كي لا يستمر الجهاز في عرض نسخة Counter القديمة بعد نشر الصفحة الجديدة.

### 3.5 اختبارات المصدر

تم تحديث `tests/unit/countflow-quality.test.mjs`:
- إضافة اختبار LVE-794 للواجهة ومكانها وقيود العضوية والجلسة والموقع والاتصال وMIME والحجم ورفع الملف الأصلي وتسجيله والتراجع عند الفشل.
- إصلاح فحص الفصل بين Barcode camera وShelf camera: الاختبار السابق كان يمنع وجود `count_shelf_images` في كامل ملف Counter، وهو شرط يتعارض مع إضافة مسار صورة منفصل. أصبح الفحص يقتصر على lifecycle الخاص بكاميرا الباركود نفسها، مع بقاء شرط عدم تداخل المسارين.

### 3.6 حوكمة المصدر والتوثيق

- `database/migrations/README.md`: تصحيح الملاحظة التاريخية التي قالت إن UI لم يُنقل؛ تسجيل نقله في LVE-794 والتنبيه إلى عدم إعادة الترحيلات.
- `CURRENT_STATE.md`: إضافة LVE-794 في أعلى الملف كنقطة استئناف.
- `Reports/FINAL_EXECUTION_REPORT_LVE-794.md`: هذا التقرير.
- لم تُستبدل تقارير LVE-765 التاريخية الأخرى؛ الاسم `LVE-765` استُخدم سابقًا في سجل Admin UI أيضًا، ولذلك اختير رقم متابعة فريد LVE-794 لتجنب الكتابة فوق سجل آخر.

## 4. الملفات المعدلة

| الملف | سبب التعديل |
|---|---|
| `countflow.html` | دمج لوحة تصوير الرف ووظائف التحقق والرفع في نسخة main الحالية |
| `countflow-sw.js` | تحديث cache build |
| `tests/unit/countflow-quality.test.mjs` | اختبارات LVE-794 وعزل اختبار كاميرا الباركود |
| `database/migrations/README.md` | توثيق حالة ترحيلات الكاميرا ونقل الواجهة |
| `CURRENT_STATE.md` | تثبيت LVE-794 كأحدث Last Verified Event |
| `Reports/FINAL_EXECUTION_REPORT_LVE-794.md` | تقرير التنفيذ |

**ملفات SQL لم تُعدل ولم تُعد كتابتها:** migration source موجودة بالفعل على main؛ لم نكرر schema.

## 5. اختبارات القبول وحدودها

### إثبات حالي
- GitHub source baseline وPR branch تمت مراجعتهما.
- Supabase migrations/bucket/RLS/policies/row-count تحققنا منها بقراءة SQL فقط.
- Automated source test أضيف واختبار barcode isolation جرى تصحيحه.

### اختبارات لا يجوز ادعاء نجاحها قبل تنفيذها
- التقاط فعلي من هاتف Android/iOS أو جهاز camera-enabled.
- Preview حقيقي للصورة الملتقطة من المتصفح.
- Upload فعلي عبر جلسة Counter مصادقة ونشطة.
- إنشاء صف `count_shelf_images` بعد Storage upload.
- Public GET للملف.
- رفض Counter غير مسند أو عضوية غير نشطة أو جلسة غير نشطة أو موقع غير مصرح.
- رفض MIME غير مدعوم أو ملف يتجاوز 10 MiB.
- اختبار cleanup لملف Storage إذا فشل INSERT.

لم توجد جلسة `active` أو صورة مسجلة أو إسنادات تشغيلية في فحص قاعدة البيانات؛ لم ننشئ هذه البيانات لمجرد اختبار الواجهة. لذلك لا توجد كتابة تجريبية باقية.

## 6. المخاطر والقرار الأمني

**مخاطرة مؤكدة:** `shelf-images` عامة. كما توضح وثائق Supabase، الوصول إلى الملفات في الـpublic bucket يتجاوز ضوابط القراءة: أي حامل لرابط الأصل يستطيع استرجاعه، رغم أن الرفع والحذف يظلان محكومين بالسياسات. مرجع Supabase: [Storage Buckets — Access model](https://supabase.com/docs/guides/storage/buckets/fundamentals).

تم الإفصاح عن ذلك داخل واجهة المندوب. لم نحول Bucket إلى Private في هذه المهمة حتى لا نغير سلوك Storage قائمًا دون تصميم القراءة والمراجعة والروابط الموقعة. **التوصية التالية:** مهمة مستقلة لتحويلها إلى Private مع سياسة SELECT مبنية على صلاحية المالك/المشرف/عضوية المشروع، وإضافة مسار Signed URL آمن لعرض الصور في سجل المراجعة. لا تُعلن سرية صور الرف في الحالة الحالية.

## 7. البيانات والأثر التشغيلي

- Auth users created: 0.
- Projects/sessions/assignments created or changed: 0.
- Shelf-image rows added: 0.
- Storage objects uploaded/deleted: 0.
- Count entries/reconciliation/stock/accounting rows changed: 0.
- QA fixtures: 0.
- Supabase migrations replayed: 0.
- Repositories/branches created: 0.
- No ERP/SMART ERP repository or database was touched.

## 8. نتائج CI والنشر

**CI على الالتزام الجديد:** PENDING عند إنشاء هذا التقرير؛ يجب انتظار GitHub Actions على `main` والتحقق من جميع الوظائف، وخصوصًا Node quality tests وDeno وPages وPlaywright/Production SHA parity.  
**Production parity:** يجب أن يثبت CI أو سجل Cloudflare أن إصدار Production يطابق commit main الناتج.  
**القبول الميداني:** OPEN حتى تنفيذ الاختبار المصادق من هاتف داخل جلسة QA نشطة وموقع مسند.  
**قرار المهمة:** `READY WITH LIMITATIONS` فقط بعد CI الأخضر ومطابقة النشر؛ لا تعني اكتمال CountFlow.

## 9. التراجع

- يمكن التراجع عن الواجهة باستخراج الكتل الجديدة من `countflow.html` وحذف CSS/markup/handlers الخاصة بـShelf Camera، دون المساس بكاميرا BarcodeDetector.
- يمكن إعادة إصدار Service Worker build لاحقًا؛ لا تحذف cache يدويًا من أجهزة المستخدمين.
- يمكن إزالة اختبارات LVE-794 أو تحديثها مع الحفاظ على اختبار عزل Barcode camera.
- لا تُسقط `count_shelf_images` ولا Bucket أو سياساتها أو ترحيلاتها ضمن rollback لواجهة الويب؛ فهي موجودة ومطبقة قبل هذه المهمة.

## 10. الحكم التنفيذي

نُقلت واجهة Shelf Camera إلى نسخة main الحالية جراحيًا مع إبقاء Barcode camera والمزايا الأحدث. مخطط قاعدة البيانات موجود ومطبق ولم يُكرر. لم يتغير أي صف أو ملف Storage أو سياق جرد فعلي.

الحالة لا تصبح READY إلا بعد CI الأخضر والتحقق من Production SHA. ويظل اختبار الهاتف المصادق ومراجعة قرار Public/Private مفتوحين حتى التنفيذ.
