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
- GitHub CI #203 / run ID 45240309793 على commit ea8553583258b6bab6b8d6da1d1f15524cd757ef: SUCCESS. Node 41/41 PASS، Deno type-check PASS، Pages build PASS، Playwright 2 PASS و1 SKIPPED (شرط مطابقة SHA لـmain لا ينطبق على PR branch).

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
- application commit: `b09b0920d519ead01787011e604a100a5083c649`.
- migration-source/documentation commit: `ea8553583258b6bab6b8d6da1d1f15524cd757ef`.
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
