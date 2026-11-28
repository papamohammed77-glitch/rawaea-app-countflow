# CountFlow — Items Tab Extraction Report

Extracted on: 2026-11-28
Source: https://raw.githubusercontent.com/papamohammed77-glitch/rawaea-app-countflow/main/countflow-admin.html
Source SHA (commit): 66ecd9cf494282de09b1e1ebe95be5e873059ef6
Source Blob SHA (countflow-admin.html): 602ade4ad3bb44bf44b9788f79f27df2d6feb269
Source file line count: 4211

## 1. HTML Structure

### Complete Items Tab section (tab-products)

```html
L0485 |     <section id="tab-products" class="section">
L0486 |      <div class="headrow"><div><h2>دليل الأصناف</h2><p class="hint">دليل موحد: الصنف الأساسي وبياناته الخاصة بكل مؤسسة في صفحة واحدة وجدول واحد، مع إبقاء سجلات التكليف مرتبطة بالعملية المحددة.</p></div></div>
L0487 |      <div id="catalogWorkspaceSelector" class="panel cf-catalog-unified-toolbar"><div class="cf-catalog-search-row">
L0488 |        <div class="field"><label for="catalogClientScope">المؤسسة لعرض بياناتها المحلية</label><select id="catalogClientScope"><option value="">اختر المؤسسة</option></select></div>
L0489 |        <div class="field"><label for="catalogMode">سجل العرض</label><select id="catalogMode"><option value="global">الأصناف الموحدة (العامة + المحلية)</option><option value="project">أصناف ملف التكليف المحدد</option></select></div>
L0490 |       </div><div id="catalogClientScopeLabel" class="hint" style="margin-top:8px">تعرض القائمة الصنف الأساسي وحقول المؤسسة المختارة في الصف نفسه، دون فصلها إلى تبويبات.</div></div>
L0491 |      <div id="catalogGlobalView">
L0492 |       <div class="panel cf-catalog-toolbar">
L0493 |        <div class="cf-catalog-primary-actions"><div><b>إجراءات دليل الأصناف</b><small>ابدأ باستيراد دليل المؤسسة أو ابحث في الدليل الموحد قبل إضافة صنف جديد.</small></div><div class="actions"><button id="catalogOpenGlobalImport" type="button" class="primary" data-owner-only>استيراد الدليل العالمي</button><button id="catalogOpenClientImport" type="button" class="soft" data-owner-only disabled>استيراد أصناف المؤسسة</button><button id="catalogAddProduct" class="soft" type="button" data-owner-only>إضافة صنف يدوي</button></div></div>
L0494 |        <div class="cf-catalog-search-row">
L0495 |        <div class="field"><label for="catalogSearch">بحث بالاسم أو SKU أو الباركود</label><input id="catalogSearch" type="search" autocomplete="off" maxlength="90" placeholder="ابحث عن اسم الصنف أو SKU أو الباركود…"></div>
L0496 |        <div class="field"><label for="catalogCategoryFilter">التصنيف</label><input id="catalogCategoryFilter" placeholder="كل التصنيفات"></div>
L0497 |        <div class="field"><label for="catalogStatusFilter">الحالة</label><select id="catalogStatusFilter"><option value="active">النشطة</option><option value="all">الكل</option><option value="inactive">الموقوفة</option></select></div>
L0498 |       </div><div class="row cf-catalog-actions"><span id="catalogResultCount" class="hint grow" aria-live="polite">سجل الأصناف العالمية</span><button id="catalogResetFilters" class="soft" type="button">إعادة ضبط</button><button id="catalogRefresh" class="soft" type="button">تحديث</button><button id="catalogExport" class="soft" type="button">تصدير النتائج CSV</button></div></div>
L0499 |       <details class="cf-catalog-tools" id="globalCatalogImportTools" data-owner-only><summary><span>استيراد الدليل العالمي <small>CSV / XLSX · معاينة الأعمدة · معالجة متدفقة بحدود آمنة</small></span></summary><div class="cf-catalog-tools-content"><div class="panel" data-owner-only><h3>استيراد الدليل العالمي — حتى 90,000 صنف</h3><p class="hint">يدعم CSV وXLSX بالقراءة المتدفقة وإرسال 500 صف في كل دفعة. الأكواد غير المكررة تُولّد بصورة ثابتة من بصمة الملف ورقم الصف؛ يمكن إعادة تشغيل الملف نفسه لاستكمال الدفعات بأمان. لا تُنشأ أرصدة أو حركات جرد من هذا الاستيراد.</p><div class="fields"><div class="field"><label for="globalCatalogImportFile">ملف الدليل (CSV / XLSX)</label><input id="globalCatalogImportFile" type="file" accept=".csv,.xlsx,text/csv,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"></div></div><div class="actions"><button id="globalCatalogImportPreview" type="button" class="soft">قراءة الملف ومعاينة الأعمدة</button><button id="globalCatalogImportCommit" type="button" class="primary" disabled>استيراد الدليل</button><button id="globalCatalogImportReset" type="button" class="soft">إلغاء الملف</button></div><div id="globalCatalogImportMapping" class="hidden" style="margin-top:12px"></div><div id="globalCatalogImportPreviewText" class="hint" style="margin-top:10px"></div><div id="globalCatalogImportProgress" class="hint" style="margin-top:10px" aria-live="polite">لم يبدأ الاستيراد</div><div style="height:8px;background:#e8edf3;border-radius:99px;overflow:hidden;margin-top:6px"><div id="globalCatalogImportProgressFill" style="height:100%;width:0%;background:#2563eb;transition:width .15s"></div></div><div id="globalCatalogImportErrors" class="tablewrap" style="margin-top:10px"></div></div></div></details><details class="cf-catalog-tools" id="clientCatalogImportTools" data-owner-only><summary><span>استيراد أصناف المؤسسة <small>مطابقة الباركود وSKU بالدليل العالمي · إنشاء الناقص · حفظ الاختلافات محلياً</small></span></summary><div class="cf-catalog-tools-content"><div class="panel"><h3>استيراد ملف المؤسسة إلى دليلها الموحد</h3><p id="clientCatalogImportTarget" class="hint">اختر المؤسسة من محدد المؤسسة أعلى الدليل. الأصناف المطابقة ستُربط دون تعديل بيانات الصنف العالمي؛ الناقص منها فقط يُنشأ في الدليل العالمي ثم يُربط بالمؤسسة.</p><div class="fields"><div class="field"><label for="clientCatalogImportFile">ملف أصناف المؤسسة (CSV / XLSX)</label><input id="clientCatalogImportFile" type="file" accept=".csv,.xlsx,text/csv,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"></div></div><div class="actions"><button id="clientCatalogImportPreview" type="button" class="soft">قراءة الملف ومعاينة الأعمدة</button><button id="clientCatalogImportCommit" type="button" class="primary" disabled>استيراد وربط الأصناف</button><button id="clientCatalogImportReset" type="button" class="soft">إلغاء الملف</button></div><div id="clientCatalogImportMapping" class="hidden" style="margin-top:12px"></div><div id="clientCatalogImportPreviewText" class="hint" style="margin-top:10px"></div><div id="clientCatalogImportProgress" class="hint" style="margin-top:10px" aria-live="polite">لم يبدأ الاستيراد</div><div style="height:8px;background:#e8edf3;border-radius:99px;overflow:hidden;margin-top:6px"><div id="clientCatalogImportProgressFill" style="height:100%;width:0%;background:#2563eb;transition:width .15s"></div></div><div id="clientCatalogImportSummary" class="cf-catalog-import-summary"></div><div id="clientCatalogImportErrors" class="tablewrap" style="margin-top:10px"></div></div></div></details><div class="panel"><div id="catalogTable" class="tablewrap"><div class="empty">جار تحميل دليل الأصناف…</div></div><div id="catalogPagination" class="row" style="justify-content:space-between;margin-top:12px"></div></div>
L0500 |      </div>
L0501 |      
L0502 |      <div id="projectProductsView" class="hidden"><div id="projectProductScopeNotice" class="empty hidden" role="status">اختر ملف تكليف من المحدد أعلى النظام لعرض أصنافه واستيرادها أو تحريرها.</div><div id="projectProductsContent">
L0503 |      <div class="headrow"><div><h2>أصناف ملف التكليف</h2><p class="hint">قائمة التكليف المحدد فقط؛ لا تختلط بالدليل العالمي أو بقوائم تكليف آخر.</p></div><div class="actions"><span class="pill" id="productCount">0 صنف</span><button id="projectCatalogExport" type="button" class="soft">تصدير أصناف التكليف CSV</button><button id="addProjectProduct" type="button" class="primary">إضافة صنف للتكليف</button></div></div>
L0504 |      <p class="hint">هذا سجل الأصناف الدائم داخل ملف التكليف؛ لا تُحذف أصنافه عند إغلاق أي جلسة جرد. تُربط كل عملية جرد بجلسة مستقلة وتستخدم أصناف الجهة المعتمدة.</p>
L0505 |      <details class="cf-catalog-tools" id="projectProductImportTools"><summary><span>استيراد أصناف من ملف <small>CSV / XLSX / XLS · مطابقة الحقول ومعاينة النتائج وسجل الدفعات</small></span></summary><div class="cf-catalog-tools-content"><div class="panel">
L0506 |       <h3>استيراد الأصناف من Excel / CSV</h3>
L0507 |       <p class="hint">ارفع ملف XLSX أو CSV للاستيراد المتدفق، أو ملف XLS قديم لا يتجاوز 8MB. طابق الأعمدة وراجع العينة قبل الاعتماد. يُنفذ الاستيراد عبر دفعات CountFlow المعتمدة، ولا ينشئ حركة مخزون. اختر «كتالوج فقط» عند استيراد بيانات التعريف دون رصيد مرجعي.</p>
L0508 |       <div class="fields">
L0509 |        <div class="field"><label for="productImportFile">ملف الأصناف</label><input id="productImportFile" type="file" accept=".xlsx,.xls,.csv,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel,text/csv"></div>
L0510 |        <div class="field"><label for="productImportSession">جلسة ربط الكميات والمواقع المرجعية (اختياري)</label><select id="productImportSession"><option value="">كتالوج فقط</option></select></div>
L0511 |       </div>
L0512 |       <div class="actions"><button id="productImportPreviewBtn" type="button" class="soft">قراءة الملف ومعاينة الأعمدة</button><button id="productImportCommitBtn" type="button" class="primary" disabled>اعتماد الاستيراد</button><button id="productImportResetBtn" type="button" class="soft">إلغاء الملف الحالي</button></div>
L0513 |       <div id="productImportMapping" class="hidden" style="margin-top:12px"></div>
L0514 |       <div id="productImportPreview" class="hint" style="margin-top:12px"></div>
L0515 |       <div id="productImportResult" class="hint" style="margin-top:10px"></div>
L0516 |       <div id="productImportHistory" class="tablewrap" style="margin-top:14px"><div class="empty">اختر تكليفاً لعرض سجل الاستيراد.</div></div>
L0517 |       <div id="productImportDetails" class="tablewrap" style="margin-top:10px"></div>
L0518 |      </div>
L0519 |      </div></details>
L0520 |      <div class="split" id="projectProductWorkspace">
L0521 |       <div class="panel hidden" id="projectProductEditorPanel"><div class="row cf-catalog-view-heading"><h3 id="productFormTitle">إضافة صنف</h3><button id="projectProductEditorClose" type="button" class="soft">إغلاق المحرر</button></div><form id="productForm"><input id="productId" type="hidden"><div class="fields">
L0522 |        <div class="field"><label>كود الصنف SKU (اختياري عند إدخال الباركود)</label><input id="sku" maxlength="100" placeholder="يمكن تركه فارغاً"></div><div class="field"><label>الباركود</label><input id="barcode" maxlength="120"></div>
L0523 |        <div class="field full"><label>اسم الصنف (اختياري)</label><input id="productName" maxlength="200" placeholder="يمكن استكمال الاسم لاحقاً"></div>
L0524 |        <div class="field"><label>التصنيف</label><input id="category" maxlength="120"></div><div class="field"><label>وحدة القياس الأساسية</label><input id="baseUnit" required maxlength="40" placeholder="مثال: قطعة، كجم، لتر"></div><div class="field"><label for="unitItemKind">نوع الصنف</label><select id="unitItemKind"><option value="BARCODED">بباركود</option><option value="WEIGHED">وزني</option><option value="NO_BARCODE">بدون باركود</option></select></div><div class="field"><label for="unitBarcodeType">نوع الباركود</label><select id="unitBarcodeType"><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128 / PLU</option><option value="INTERNAL">داخلي</option></select></div><div class="field"><label for="unitClass">فئة وحدة القياس</label><select id="unitClass"><option value="count">عدد / قطعة</option><option value="mass">وزن / كتلة</option><option value="volume">حجم / سعة</option><option value="length">طول</option><option value="area">مساحة</option><option value="other" selected>وحدة خاصة / تعبئة</option></select><small class="hint">اختر البعد: عدد، وزن، حجم، طول، مساحة أو وحدة خاصة.</small></div><div class="field"><label for="unitPrecision">دقة الكمية</label><select id="unitPrecision"><option value="0" >0 منازل عشرية</option><option value="1" >1 منازل عشرية</option><option value="2" >2 منازل عشرية</option><option value="3" selected>3 منازل عشرية</option><option value="4" >4 منازل عشرية</option><option value="5" >5 منازل عشرية</option><option value="6" >6 منازل عشرية</option></select><small class="hint">عدد المنازل العشرية المسموح بها في العد.</small></div>
L0525 |        <div class="field full"><label>الوحدات البديلة ومعامل التحويل</label><p class="hint">أدخل معامل كل وحدة مقارنة بالوحدة الأساسية؛ مثال: كرتونة = 12 قطعة، وجرام = 0.001 كجم.</p><div id="productUnitsEditor" class="product-unit-list"></div><div class="actions"><button id="addProductUnit" type="button" class="soft">إضافة وحدة بديلة</button></div></div>
L0526 |        <div class="field"><label>الكمية الدفترية المرجعية (اختياري)</label><input id="expectedQty" type="number" min="0" step="0.0001"></div><div class="field full"><label for="imageUrl">رابط صورة خارجي آمن (اختياري)</label><input id="imageUrl" type="url" placeholder="https://example.com/product.jpg"></div>
L0527 |        <div class="field full"><label for="productImageFile">رفع صورة الصنف من الجهاز (JPEG / PNG · حتى 1MiB لتضمينها في Excel)</label><input id="productImageFile" type="file" accept="image/jpeg,image/png"><div id="productImagePreview" class="product-image-preview hidden"><img id="productImagePreviewImg" alt="معاينة صورة الصنف"><div class="grow"><b id="productImagePreviewTitle">صورة الصنف</b><p id="productImagePreviewNote" class="hint">تُحفظ الصورة داخل مساحة CountFlow الخاصة بهذا التكليف.</p><button type="button" id="clearProductImage" class="danger">إزالة الصورة</button></div></div></div>
L0528 |       </div><div class="actions"><button class="primary">حفظ الصنف</button><button type="button" id="productCancel" class="soft">إلغاء</button></div></form></div>
L0529 |       <div class="panel"><div class="cf-catalog-list-tools"><h3>الأصناف المسجلة</h3><span class="cf-catalog-export-note">بحث بالاسم أو الكود أو الباركود</span></div><div class="toolbar"><input id="productSearch" type="search" autocomplete="off" placeholder="بحث بالكود أو الاسم أو الباركود"></div><div id="productTable" class="tablewrap"><div class="empty">لا توجد أصناف بعد.</div></div><div id="productPager" class="actions"></div></div>
L0530 |      </div>
L0531 |     </div></div><div id="catalogProductEditor" class="hidden">
L0532 |       <div class="headrow"><div><h2 id="globalProductFormTitle">إضافة صنف عالمي</h2><p class="hint">بيانات الصنف الأساسية. أدخل بياناته مرة واحدة، ثم أضف الاختلافات الخاصة بالمؤسسة في الجزء التالي عند الحاجة.</p></div><button id="globalProductCancel" class="soft" type="button">العودة إلى الدليل</button></div>
L0533 |       <form id="globalProductForm"><input id="globalProductId" type="hidden">
L0534 |        
L0535 |        
L0536 |        <div id="globalProductEditorTabs" class="cf-catalog-tabs" role="tablist" aria-label="أقسام بيانات الصنف">
L0537 |         <button id="globalProductTab-basic" class="cf-catalog-tab active" type="button" role="tab" data-global-product-tab="basic" aria-controls="globalProductPanel-basic" aria-selected="true" tabindex="0">البيانات الأساسية</button>
L0538 |         <button id="globalProductTab-units" class="cf-catalog-tab" type="button" role="tab" data-global-product-tab="units" aria-controls="globalProductPanel-units" aria-selected="false" tabindex="-1">الوحدات البديلة</button>
L0539 |         <button id="globalProductTab-advanced" class="cf-catalog-tab" type="button" role="tab" data-global-product-tab="advanced" aria-controls="globalProductPanel-advanced" aria-selected="false" tabindex="-1">الإعدادات المتقدمة</button>
L0540 |        </div>
L0541 |        <div class="panel cf-catalog-editor-panel" id="globalProductPanel-basic" role="tabpanel" aria-labelledby="globalProductTab-basic">
L0542 |         <div id="globalCatalogLookupPanel" class="cf-catalog-lookup"><div><b>ابحث في الدليل العالمي أولاً</b><small>اكتب باركوداً أو SKU أو جزءاً من اسم الصنف؛ عند اختيار نتيجة سنفتح سجلها الحالي بدلاً من إنشاء نسخة مكررة.</small></div><div class="cf-catalog-lookup-controls"><input id="globalCatalogLookupInput" type="search" maxlength="120" autocomplete="off" placeholder="باركود أو SKU أو اسم الصنف"><button id="globalCatalogLookupButton" type="button" class="soft">بحث في الدليل</button></div><div id="globalCatalogLookupResults" class="hint" role="status" aria-live="polite"></div></div>
L0543 |         <div class="fields">
L0544 |          <div class="field"><label for="globalSku">SKU العالمي</label><input id="globalSku" maxlength="100"></div>
L0545 |          <div class="field full cf-catalog-barcode-field">
L0546 |           <label for="globalBarcode">الباركود الأساسي أو الرمز المحلي</label>
L0547 |           <div class="cf-catalog-barcode-entry">
L0548 |            <input id="globalBarcode" inputmode="text" maxlength="120" autocomplete="off" placeholder="امسح الرمز أو أدخل EAN / UPC / PLU">
L0549 |            <div class="cf-catalog-barcode-actions">
L0550 |             <button type="button" id="globalGenerateBarcode" class="soft">توليد رمز محلي 20</button>
L0551 |             <button type="button" id="globalBarcodeCopy" class="soft" disabled>نسخ الرمز</button>
L0552 |            </div>
L0553 |           </div>
L0554 |           <small id="globalBarcodeHint" class="hint">يمكنك إدخال باركود المورد أو توليد نمط RCN-13 محلي يبدأ بـ 20 مع رقم تحقق. التوليد لا يعني تخصيص البادئة أو اعتمادها من GS1.</small>
L0555 |           <div id="globalBarcodeStatus" class="cf-catalog-barcode-status" data-state="empty" role="status" aria-live="polite">لم يُدخل باركود بعد.</div>
L0556 |          </div>
L0557 |          <div class="field"><label for="globalItemKind">نوع تعريف الصنف</label><select id="globalItemKind"><option value="BARCODED">صنف بباركود</option><option value="WEIGHED">صنف وزني (كجم / جرام)</option><option value="NO_BARCODE">بدون باركود (معرف داخلي)</option></select><small class="hint">هذا الاختيار يحدد هوية الباركود، وليس فئة وحدة القياس.</small></div>
L0558 |          <div class="field full cf-catalog-internal-id-note"><label>معرف CountFlow عند عدم توفر باركود</label><small class="hint">عند اختيار "بدون باركود" وترك حقل الرمز فارغاً، ينشئ الخادم معرف CFI داخلياً تلقائياً. يظل CFI منفصلاً عن باركود المورد ورموز GS1.</small></div>
L0559 |          <div class="field full"><label for="globalName">اسم الصنف</label><input id="globalName" required maxlength="240"></div>
L0560 |          <div class="field"><label for="globalBrand">العلامة التجارية</label><input id="globalBrand" maxlength="120"></div>
L0561 |          <div class="field"><label for="globalCategoryChoice">التصنيف</label><select id="globalCategoryChoice" aria-describedby="globalCategoryHint"><option value="">بدون تصنيف</option></select><input id="globalCategoryCustom" class="hidden" maxlength="120" autocomplete="off" placeholder="اكتب التصنيف الجديد" aria-label="التصنيف المخصص"><input id="globalCategory" type="hidden" value=""><small id="globalCategoryHint" class="hint">اختر تصنيفاً من القائمة أو أضف تصنيفاً جديداً؛ تظل قيمة التصنيف محفوظة في سجل الصنف.</small></div>
L0562 |          <div class="field"><label for="globalUnitClass">نمط القياس</label><select id="globalUnitClass"><option value="count">عدد / قطعة</option><option value="mass">وزن / كتلة</option><option value="volume">حجم / سعة</option><option value="length">طول</option><option value="area">مساحة</option><option value="other">وحدة خاصة / تعبئة</option></select><small class="hint">يفصل نوع القياس عن اسم الوحدة نفسها؛ اختر الوزن ثم اختر كجم أو جرام كوحدة أساس.</small></div>
L0563 |          <div class="field"><label for="globalBaseUnitChoice">الوحدة الأساسية</label><select id="globalBaseUnitChoice" required><option value="">اختر الوحدة الأساسية</option></select><input id="globalBaseUnit" type="hidden" value=""><small id="globalBaseUnitHint" class="hint">اختر وحدة معرفة مسبقاً وفق نمط القياس؛ لن يقبل المحرر قيماً نصية غير معتمدة.</small></div>
L0564 |         </div>
L0565 |         <div id="globalProductPanel-image" class="panel cf-catalog-image-panel"><h3>صورة الصنف</h3><p class="hint">الصورة تحفظ في Storage الخاص، ولا يُحفظ رابط العرض المؤقت داخل السجل.</p><div class="field"><label for="globalImageFile">JPEG / PNG / WEBP حتى 5MB</label><input id="globalImageFile" type="file" accept="image/jpeg,image/png,image/webp"></div><div id="globalImageCurrent" class="hint"></div><div id="globalImagePreview" class="product-image-preview cf-catalog-editor-preview hidden"><img id="globalImagePreviewImg" alt="معاينة صورة الصنف"><div class="grow"><b id="globalImagePreviewTitle">صورة الصنف</b><p id="globalImagePreviewNote" class="hint">معاينة الصورة الحالية أو المختارة.</p><button type="button" id="clearGlobalImage" class="danger">إزالة ربط الصورة</button></div></div></div>
L0566 |        </div>
L0567 |        <div class="panel cf-catalog-editor-panel hidden" id="globalProductPanel-units" role="tabpanel" aria-labelledby="globalProductTab-units"><h3>الوحدات البديلة</h3><p class="hint">أضف وحدات بديلة عند الحاجة. المعامل يعني عدد وحدات الأساس داخل وحدة واحدة بديلة؛ مثال: 1 كرتونة = 12 قطعة. يمكن إضافة أكثر من وحدة، ولكل وحدة باركود مستقل اختياري.</p><div id="globalProductUnitsEditor" class="product-unit-list"></div><button id="addGlobalProductUnit" class="soft" type="button">إضافة وحدة بديلة</button></div>
L0568 |        <div class="panel cf-catalog-editor-panel hidden" id="globalProductPanel-advanced" role="tabpanel" aria-labelledby="globalProductTab-advanced"><h3>الإعدادات المتقدمة</h3><p class="hint">إعدادات التحقق من رموز التعريف ودقة الكمية. لا تُسجل أسعاراً أو مورداً في الدليل العالمي.</p><div class="fields"><div class="field"><label for="globalBarcodeType">نوع الباركود</label><select id="globalBarcodeType"><option value="AUTO">اكتشاف تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128 / PLU</option><option value="INTERNAL">معرف CountFlow داخلي</option></select></div><div class="field"><label for="globalUnitPrecision">دقة الكمية</label><select id="globalUnitPrecision"><option value="0">0 منازل</option><option value="1">1 منزلة</option><option value="2">2 منزلتان</option><option value="3" selected>3 منازل</option><option value="4">4 منازل</option><option value="5">5 منازل</option><option value="6">6 منازل</option></select></div></div></div>
L0569 | <div class="panel"><div class="actions"><button id="globalProductSave" class="primary" type="submit">إضافة إلى الدليل الدائم</button><button id="globalProductCancelBottom" class="soft" type="button">إلغاء</button></div></div>
L0570 |       </form>
L0571 |       <div id="clientCatalogEditorShell" class="hidden"><div class="panel" id="clientProductEditorPanel"><div class="row cf-catalog-view-heading"><h3 id="clientProductFormTitle">البيانات الخاصة بالمؤسسة</h3><button id="clientCatalogEditorClose" type="button" class="soft">إغلاق المحرر</button></div><p class="hint">أدخل الأكواد والتسميات التي تختلف لهذه المؤسسة. تظل بيانات الصنف الأساسية والوحدات العامة في نفس صفحة الصنف.</p>
L0572 |         <form id="clientProductForm"><input id="clientProductImagePath" type="hidden">
L0573 |          <div class="field hidden"><label for="clientProductLookup">بحث في الأصناف</label><input id="clientProductLookup" placeholder="الاسم أو SKU أو الباركود"></div>
L0574 |          <div class="field hidden"><label for="clientProductCatalog">الصنف</label><select id="clientProductCatalog" required></select></div>
L0575 |          <div class="fields">
L0576 |           <div class="field"><label for="clientProductSku">SKU المؤسسة</label><input id="clientProductSku" maxlength="100"></div>
L0577 |           <div class="field"><label for="clientProductBarcode">باركود المؤسسة (نصي)</label><input id="clientProductBarcode" inputmode="text" maxlength="120"></div>
L0578 |           <div class="field"><label for="clientProductName">اسم المؤسسة</label><input id="clientProductName" maxlength="240"></div>
L0579 |           <div class="field"><label for="clientProductCategoryChoice">تصنيف المؤسسة</label><select id="clientProductCategoryChoice" aria-describedby="clientProductCategoryHint"><option value="">بدون تصنيف محلي</option></select><input id="clientProductCategoryCustom" class="hidden" maxlength="120" autocomplete="off" placeholder="اكتب تصنيف المؤسسة الجديد" aria-label="تصنيف المؤسسة المخصص"><input id="clientProductCategory" type="hidden" value=""><small id="clientProductCategoryHint" class="hint">اختر تصنيفاً أو أضف وصفاً محلياً لهذه المؤسسة.</small></div>
L0580 |          </div>
L0581 |          <div class="cf-catalog-custom-units"><label class="cf-checkline"><input id="clientUnitsOverrideToggle" type="checkbox"> تخصيص وحدة الأساس والتحويل لهذه المؤسسة</label>
L0582 |           <div id="clientUnitsOverrideFields" class="hidden"><div class="field"><label for="clientProductUnit">وحدة الأساس للمؤسسة</label><select id="clientProductUnit"><option value="">اختر الوحدة الأساسية</option></select><small class="hint">الوحدات المتاحة تتغير بحسب نمط القياس المختار.</small></div><div class="field"><label for="clientItemKind">نوع الصنف</label><select id="clientItemKind"><option value="BARCODED">بباركود</option><option value="WEIGHED">وزني</option><option value="NO_BARCODE">بدون باركود</option></select></div><div class="field"><label for="clientBarcodeType">نوع الباركود</label><select id="clientBarcodeType"><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128 / PLU</option><option value="INTERNAL">داخلي</option></select></div><div class="field"><label for="clientUnitClass">نمط القياس</label><select id="clientUnitClass"><option value="count" >عدد / قطعة</option><option value="mass" >وزن / كتلة</option><option value="volume" >حجم / سعة</option><option value="length" >طول</option><option value="area" >مساحة</option><option value="other" selected>وحدة خاصة / تعبئة</option></select></div><div class="field"><label for="clientUnitPrecision">دقة الكمية</label><select id="clientUnitPrecision"><option value="0" >0 منازل عشرية</option><option value="1" >1 منازل عشرية</option><option value="2" >2 منازل عشرية</option><option value="3" selected>3 منازل عشرية</option><option value="4" >4 منازل عشرية</option><option value="5" >5 منازل عشرية</option><option value="6" >6 منازل عشرية</option></select></div><div class="field"><label>الوحدات البديلة ومعامل التحويل</label><p class="hint">المعامل = عدد وحدات الأساس داخل الوحدة البديلة.</p><div id="clientProductUnitsEditor" class="product-unit-list"></div><button id="addClientProductUnit" class="soft" type="button">إضافة وحدة بديلة</button></div></div>
L0583 |          </div>
L0584 |          <div class="actions"><button class="primary" type="submit">حفظ بيانات المؤسسة</button><button id="clientProductReset" class="soft" type="button">مسح حقول المؤسسة</button></div>
L0585 |         </form>
L0586 |        </div></div>
L0587 |      </div>
L0588 |     </section>
```

## 2. Item Edit Page (openItemPage equivalent)

The file does not define a function named openItemPage. The editor template is inline in tab-products; the form and equivalent editor-opening functions are extracted below.

### Global item editor — three tabs, fields and image panel

```html
L0533 |       <form id="globalProductForm"><input id="globalProductId" type="hidden">
L0534 |        
L0535 |        
L0536 |        <div id="globalProductEditorTabs" class="cf-catalog-tabs" role="tablist" aria-label="أقسام بيانات الصنف">
L0537 |         <button id="globalProductTab-basic" class="cf-catalog-tab active" type="button" role="tab" data-global-product-tab="basic" aria-controls="globalProductPanel-basic" aria-selected="true" tabindex="0">البيانات الأساسية</button>
L0538 |         <button id="globalProductTab-units" class="cf-catalog-tab" type="button" role="tab" data-global-product-tab="units" aria-controls="globalProductPanel-units" aria-selected="false" tabindex="-1">الوحدات البديلة</button>
L0539 |         <button id="globalProductTab-advanced" class="cf-catalog-tab" type="button" role="tab" data-global-product-tab="advanced" aria-controls="globalProductPanel-advanced" aria-selected="false" tabindex="-1">الإعدادات المتقدمة</button>
L0540 |        </div>
L0541 |        <div class="panel cf-catalog-editor-panel" id="globalProductPanel-basic" role="tabpanel" aria-labelledby="globalProductTab-basic">
L0542 |         <div id="globalCatalogLookupPanel" class="cf-catalog-lookup"><div><b>ابحث في الدليل العالمي أولاً</b><small>اكتب باركوداً أو SKU أو جزءاً من اسم الصنف؛ عند اختيار نتيجة سنفتح سجلها الحالي بدلاً من إنشاء نسخة مكررة.</small></div><div class="cf-catalog-lookup-controls"><input id="globalCatalogLookupInput" type="search" maxlength="120" autocomplete="off" placeholder="باركود أو SKU أو اسم الصنف"><button id="globalCatalogLookupButton" type="button" class="soft">بحث في الدليل</button></div><div id="globalCatalogLookupResults" class="hint" role="status" aria-live="polite"></div></div>
L0543 |         <div class="fields">
L0544 |          <div class="field"><label for="globalSku">SKU العالمي</label><input id="globalSku" maxlength="100"></div>
L0545 |          <div class="field full cf-catalog-barcode-field">
L0546 |           <label for="globalBarcode">الباركود الأساسي أو الرمز المحلي</label>
L0547 |           <div class="cf-catalog-barcode-entry">
L0548 |            <input id="globalBarcode" inputmode="text" maxlength="120" autocomplete="off" placeholder="امسح الرمز أو أدخل EAN / UPC / PLU">
L0549 |            <div class="cf-catalog-barcode-actions">
L0550 |             <button type="button" id="globalGenerateBarcode" class="soft">توليد رمز محلي 20</button>
L0551 |             <button type="button" id="globalBarcodeCopy" class="soft" disabled>نسخ الرمز</button>
L0552 |            </div>
L0553 |           </div>
L0554 |           <small id="globalBarcodeHint" class="hint">يمكنك إدخال باركود المورد أو توليد نمط RCN-13 محلي يبدأ بـ 20 مع رقم تحقق. التوليد لا يعني تخصيص البادئة أو اعتمادها من GS1.</small>
L0555 |           <div id="globalBarcodeStatus" class="cf-catalog-barcode-status" data-state="empty" role="status" aria-live="polite">لم يُدخل باركود بعد.</div>
L0556 |          </div>
L0557 |          <div class="field"><label for="globalItemKind">نوع تعريف الصنف</label><select id="globalItemKind"><option value="BARCODED">صنف بباركود</option><option value="WEIGHED">صنف وزني (كجم / جرام)</option><option value="NO_BARCODE">بدون باركود (معرف داخلي)</option></select><small class="hint">هذا الاختيار يحدد هوية الباركود، وليس فئة وحدة القياس.</small></div>
L0558 |          <div class="field full cf-catalog-internal-id-note"><label>معرف CountFlow عند عدم توفر باركود</label><small class="hint">عند اختيار "بدون باركود" وترك حقل الرمز فارغاً، ينشئ الخادم معرف CFI داخلياً تلقائياً. يظل CFI منفصلاً عن باركود المورد ورموز GS1.</small></div>
L0559 |          <div class="field full"><label for="globalName">اسم الصنف</label><input id="globalName" required maxlength="240"></div>
L0560 |          <div class="field"><label for="globalBrand">العلامة التجارية</label><input id="globalBrand" maxlength="120"></div>
L0561 |          <div class="field"><label for="globalCategoryChoice">التصنيف</label><select id="globalCategoryChoice" aria-describedby="globalCategoryHint"><option value="">بدون تصنيف</option></select><input id="globalCategoryCustom" class="hidden" maxlength="120" autocomplete="off" placeholder="اكتب التصنيف الجديد" aria-label="التصنيف المخصص"><input id="globalCategory" type="hidden" value=""><small id="globalCategoryHint" class="hint">اختر تصنيفاً من القائمة أو أضف تصنيفاً جديداً؛ تظل قيمة التصنيف محفوظة في سجل الصنف.</small></div>
L0562 |          <div class="field"><label for="globalUnitClass">نمط القياس</label><select id="globalUnitClass"><option value="count">عدد / قطعة</option><option value="mass">وزن / كتلة</option><option value="volume">حجم / سعة</option><option value="length">طول</option><option value="area">مساحة</option><option value="other">وحدة خاصة / تعبئة</option></select><small class="hint">يفصل نوع القياس عن اسم الوحدة نفسها؛ اختر الوزن ثم اختر كجم أو جرام كوحدة أساس.</small></div>
L0563 |          <div class="field"><label for="globalBaseUnitChoice">الوحدة الأساسية</label><select id="globalBaseUnitChoice" required><option value="">اختر الوحدة الأساسية</option></select><input id="globalBaseUnit" type="hidden" value=""><small id="globalBaseUnitHint" class="hint">اختر وحدة معرفة مسبقاً وفق نمط القياس؛ لن يقبل المحرر قيماً نصية غير معتمدة.</small></div>
L0564 |         </div>
L0565 |         <div id="globalProductPanel-image" class="panel cf-catalog-image-panel"><h3>صورة الصنف</h3><p class="hint">الصورة تحفظ في Storage الخاص، ولا يُحفظ رابط العرض المؤقت داخل السجل.</p><div class="field"><label for="globalImageFile">JPEG / PNG / WEBP حتى 5MB</label><input id="globalImageFile" type="file" accept="image/jpeg,image/png,image/webp"></div><div id="globalImageCurrent" class="hint"></div><div id="globalImagePreview" class="product-image-preview cf-catalog-editor-preview hidden"><img id="globalImagePreviewImg" alt="معاينة صورة الصنف"><div class="grow"><b id="globalImagePreviewTitle">صورة الصنف</b><p id="globalImagePreviewNote" class="hint">معاينة الصورة الحالية أو المختارة.</p><button type="button" id="clearGlobalImage" class="danger">إزالة ربط الصورة</button></div></div></div>
L0566 |        </div>
L0567 |        <div class="panel cf-catalog-editor-panel hidden" id="globalProductPanel-units" role="tabpanel" aria-labelledby="globalProductTab-units"><h3>الوحدات البديلة</h3><p class="hint">أضف وحدات بديلة عند الحاجة. المعامل يعني عدد وحدات الأساس داخل وحدة واحدة بديلة؛ مثال: 1 كرتونة = 12 قطعة. يمكن إضافة أكثر من وحدة، ولكل وحدة باركود مستقل اختياري.</p><div id="globalProductUnitsEditor" class="product-unit-list"></div><button id="addGlobalProductUnit" class="soft" type="button">إضافة وحدة بديلة</button></div>
L0568 |        <div class="panel cf-catalog-editor-panel hidden" id="globalProductPanel-advanced" role="tabpanel" aria-labelledby="globalProductTab-advanced"><h3>الإعدادات المتقدمة</h3><p class="hint">إعدادات التحقق من رموز التعريف ودقة الكمية. لا تُسجل أسعاراً أو مورداً في الدليل العالمي.</p><div class="fields"><div class="field"><label for="globalBarcodeType">نوع الباركود</label><select id="globalBarcodeType"><option value="AUTO">اكتشاف تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128 / PLU</option><option value="INTERNAL">معرف CountFlow داخلي</option></select></div><div class="field"><label for="globalUnitPrecision">دقة الكمية</label><select id="globalUnitPrecision"><option value="0">0 منازل</option><option value="1">1 منزلة</option><option value="2">2 منزلتان</option><option value="3" selected>3 منازل</option><option value="4">4 منازل</option><option value="5">5 منازل</option><option value="6">6 منازل</option></select></div></div></div>
L0569 | <div class="panel"><div class="actions"><button id="globalProductSave" class="primary" type="submit">إضافة إلى الدليل الدائم</button><button id="globalProductCancelBottom" class="soft" type="button">إلغاء</button></div></div>
L0570 |       </form>
```

### Client-specific item editor form

```html
L0572 |         <form id="clientProductForm"><input id="clientProductImagePath" type="hidden">
L0573 |          <div class="field hidden"><label for="clientProductLookup">بحث في الأصناف</label><input id="clientProductLookup" placeholder="الاسم أو SKU أو الباركود"></div>
L0574 |          <div class="field hidden"><label for="clientProductCatalog">الصنف</label><select id="clientProductCatalog" required></select></div>
L0575 |          <div class="fields">
L0576 |           <div class="field"><label for="clientProductSku">SKU المؤسسة</label><input id="clientProductSku" maxlength="100"></div>
L0577 |           <div class="field"><label for="clientProductBarcode">باركود المؤسسة (نصي)</label><input id="clientProductBarcode" inputmode="text" maxlength="120"></div>
L0578 |           <div class="field"><label for="clientProductName">اسم المؤسسة</label><input id="clientProductName" maxlength="240"></div>
L0579 |           <div class="field"><label for="clientProductCategoryChoice">تصنيف المؤسسة</label><select id="clientProductCategoryChoice" aria-describedby="clientProductCategoryHint"><option value="">بدون تصنيف محلي</option></select><input id="clientProductCategoryCustom" class="hidden" maxlength="120" autocomplete="off" placeholder="اكتب تصنيف المؤسسة الجديد" aria-label="تصنيف المؤسسة المخصص"><input id="clientProductCategory" type="hidden" value=""><small id="clientProductCategoryHint" class="hint">اختر تصنيفاً أو أضف وصفاً محلياً لهذه المؤسسة.</small></div>
L0580 |          </div>
L0581 |          <div class="cf-catalog-custom-units"><label class="cf-checkline"><input id="clientUnitsOverrideToggle" type="checkbox"> تخصيص وحدة الأساس والتحويل لهذه المؤسسة</label>
L0582 |           <div id="clientUnitsOverrideFields" class="hidden"><div class="field"><label for="clientProductUnit">وحدة الأساس للمؤسسة</label><select id="clientProductUnit"><option value="">اختر الوحدة الأساسية</option></select><small class="hint">الوحدات المتاحة تتغير بحسب نمط القياس المختار.</small></div><div class="field"><label for="clientItemKind">نوع الصنف</label><select id="clientItemKind"><option value="BARCODED">بباركود</option><option value="WEIGHED">وزني</option><option value="NO_BARCODE">بدون باركود</option></select></div><div class="field"><label for="clientBarcodeType">نوع الباركود</label><select id="clientBarcodeType"><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128 / PLU</option><option value="INTERNAL">داخلي</option></select></div><div class="field"><label for="clientUnitClass">نمط القياس</label><select id="clientUnitClass"><option value="count" >عدد / قطعة</option><option value="mass" >وزن / كتلة</option><option value="volume" >حجم / سعة</option><option value="length" >طول</option><option value="area" >مساحة</option><option value="other" selected>وحدة خاصة / تعبئة</option></select></div><div class="field"><label for="clientUnitPrecision">دقة الكمية</label><select id="clientUnitPrecision"><option value="0" >0 منازل عشرية</option><option value="1" >1 منازل عشرية</option><option value="2" >2 منازل عشرية</option><option value="3" selected>3 منازل عشرية</option><option value="4" >4 منازل عشرية</option><option value="5" >5 منازل عشرية</option><option value="6" >6 منازل عشرية</option></select></div><div class="field"><label>الوحدات البديلة ومعامل التحويل</label><p class="hint">المعامل = عدد وحدات الأساس داخل الوحدة البديلة.</p><div id="clientProductUnitsEditor" class="product-unit-list"></div><button id="addClientProductUnit" class="soft" type="button">إضافة وحدة بديلة</button></div></div>
L0583 |          </div>
L0584 |          <div class="actions"><button class="primary" type="submit">حفظ بيانات المؤسسة</button><button id="clientProductReset" class="soft" type="button">مسح حقول المؤسسة</button></div>
L0585 |         </form>
```

### Equivalent editor-opening functions

### openGlobalProductEditor() — lines 3239-3256

```javascript
L3239 | function openGlobalProductEditor(product=null){
L3240 |  if(!state.platformOwner)return notify('لا تملك صلاحية تعديل بيانات الصنف الأساسية.',true);
L3241 |  const p=product||null;resetGlobalImagePreview();state.globalImageCleared=false;
L3242 |  $('globalProductForm').classList.remove('hidden');$('unifiedProductReadOnlySummary')?.classList.add('hidden');
L3243 |  $('globalProductForm').reset();$('globalProductId').value=p?.id||'';$('globalSku').value=p?.canonical_sku||'';$('globalBarcode').value=p?.barcode||'';$('globalName').value=p?.name||'';$('globalBrand').value=p?.brand||'';setCatalogCategoryPicker('global',p?.category||'');$('globalBaseUnit').value=p?.base_unit||'';$('globalImageFile').value='';
L3244 |  $('globalImageCurrent').textContent=p?.image_storage_path?'جار تجهيز معاينة الصورة…':'لا توجد صورة مرتبطة بهذا الصنف.';
L3245 |  renderCatalogUnitEditor('globalProductUnitsEditor',p?.units||[]);setUnitMetaFields('global',p?.units||[],$('globalBaseUnit').value);
L3246 |  if(!p){$('globalItemKind').value='BARCODED';$('globalBarcodeType').value='AUTO';$('globalUnitClass').value='other';$('globalUnitPrecision').value='3';}
L3247 |  $('globalCatalogLookupPanel')?.classList.toggle('hidden',!!p);
L3248 |  if($('globalCatalogLookupResults'))$('globalCatalogLookupResults').textContent='';
L3249 |  if($('globalCatalogLookupInput')&&!p)$('globalCatalogLookupInput').value='';
L3250 |  setGlobalBaseUnit(p?.base_unit||'',true);renderGlobalBarcodeStatus();
L3251 |  $('globalProductFormTitle').textContent=p?'تفاصيل الصنف وتعديل بياناته':'إضافة صنف جديد';$('globalProductSave').textContent=p?'حفظ بيانات الصنف':'إضافة الصنف';
L3252 |  $('catalogGlobalView').classList.add('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.add('hidden');$('catalogProductEditor').classList.remove('hidden');
L3253 |  $('clientCatalogEditorShell')?.classList.add('hidden');resetClientProductForm();
L3254 |  if(p?.image_storage_path)loadGlobalProductImagePreview(p).catch(error=>console.warn('Global image preview failed',error));
L3255 |  switchGlobalProductTab('basic');window.scrollTo({top:0,behavior:'smooth'});
L3256 | }
```

### openUnifiedCatalogItem() — lines 3262-3298

```javascript
L3262 | async function openUnifiedCatalogItem(product){
L3263 |  if(!product)return;
L3264 |  const clientId=state.catalogClientId;
L3265 |  await refreshClientCatalogPermission();
L3266 |  if(state.platformOwner)openGlobalProductEditor(product);
L3267 |  else{
L3268 |   $('globalProductForm').classList.add('hidden');
L3269 |   $('catalogGlobalView').classList.add('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.add('hidden');
L3270 |   $('catalogProductEditor').classList.remove('hidden');
L3271 |   let summary=$('unifiedProductReadOnlySummary');
L3272 |   if(!summary){summary=document.createElement('div');summary.id='unifiedProductReadOnlySummary';summary.className='panel';$('catalogProductEditor').prepend(summary);}
L3273 |   summary.classList.remove('hidden');
L3274 |   summary.innerHTML='<h3>بيانات الصنف الأساسية — عرض فقط</h3><p><b>'+esc(product.name)+'</b></p><p class="hint">SKU: '+esc(product.canonical_sku||'—')+' · الباركود: '+esc(product.barcode||'—')+' · وحدة الأساس: '+esc(product.base_unit||'—')+'</p>';
L3275 |  }
L3276 |  if(!clientId){notify('اختر المؤسسة أولاً لعرض أو تعديل بياناتها المحلية.',true);return;}
L3277 |  if(!state.canManageClientCatalog){notify('حسابك يستطيع عرض الصنف، ولا يملك صلاحية تعديل بيانات المؤسسة.',true);return;}
L3278 |  const mapping=(state.catalogClientRows||[]).find(x=>x.catalog_product_id===product.id)||null;
L3279 |  $('clientProductForm').reset();
L3280 |  $('clientProductCatalog').innerHTML='<option value="'+esc(product.id)+'">'+esc(product.name)+'</option>';
L3281 |  $('clientProductCatalog').value=product.id;
L3282 |  $('clientProductSku').value=mapping?.client_sku||'';
L3283 |  $('clientProductBarcode').value=mapping?.client_barcode||'';
L3284 |  $('clientProductName').value=mapping?.name_override||'';
L3285 |  setCatalogCategoryPicker('client',mapping?.category_override||'');
L3286 |  $('clientProductImagePath').value=mapping?.image_storage_path_override||'';
L3287 |  const custom=!!(mapping?.base_unit_override||mapping?.units_override);
L3288 |  $('clientUnitsOverrideToggle').checked=custom;
L3289 |  $('clientUnitsOverrideFields').classList.toggle('hidden',!custom);
L3290 |  setUnitMetaFields('client',mapping?.units_override||product.units||[], mapping?.base_unit_override||product.base_unit||'');
L3291 |  setClientBaseUnit(mapping?.base_unit_override||product.base_unit||'',true);
L3292 |  renderCatalogUnitEditor('clientProductUnitsEditor',mapping?.units_override||[]);
L3293 |  $('clientProductFormTitle').textContent=mapping?'تعديل بيانات المؤسسة لهذا الصنف':'إضافة بيانات المؤسسة لهذا الصنف';
L3294 |  openClientCatalogEditor();
L3295 |  $('catalogProductEditor').classList.remove('hidden');
L3296 |  $('catalogGlobalView').classList.add('hidden');
L3297 |  window.scrollTo({top:0,behavior:'smooth'});
L3298 | }
```

### closeGlobalProductEditor() — lines 3257-3261

```javascript
L3257 | function closeGlobalProductEditor(){
L3258 |  $('catalogProductEditor').classList.add('hidden');$('catalogGlobalView').classList.remove('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.remove('hidden');
L3259 |  state.catalogView='global';if($('catalogMode'))$('catalogMode').value='global';
L3260 |  $('globalProductForm').classList.remove('hidden');$('globalProductForm').reset();setCatalogCategoryPicker('global','');$('globalProductId').value='';$('globalProductSave').textContent='إضافة الصنف';$('globalImageCurrent').textContent='';state.globalImageCleared=false;resetGlobalImagePreview();renderCatalogUnitEditor('globalProductUnitsEditor',[]);renderGlobalBarcodeStatus();resetClientProductForm();
L3261 | }
```

### openClientCatalogEditor() — lines 3302-3305

```javascript
L3302 | function openClientCatalogEditor(){
L3303 |  if(!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة مواءمات المؤسسة.',true);
L3304 |  $('clientCatalogEditorShell').classList.remove('hidden');$('clientProductSku')?.focus();$('clientCatalogEditorShell').scrollIntoView({behavior:'smooth',block:'start'});
L3305 | }
```

### switchGlobalProductTab() — lines 3122-3130

```javascript
L3122 | function switchGlobalProductTab(tab='basic',focus=false){
L3123 |  const keys=['basic','units','advanced'],active=keys.includes(tab)?tab:'basic';
L3124 |  keys.forEach(key=>{
L3125 |   const panel=$('globalProductPanel-'+key),button=$('globalProductTab-'+key),selected=key===active;
L3126 |   panel?.classList.toggle('hidden',!selected);
L3127 |   if(button){button.setAttribute('aria-selected',String(selected));button.tabIndex=selected?0:-1;button.classList.toggle('active',selected);}
L3128 |  });
L3129 |  if(focus)$('globalProductTab-'+active)?.focus();
L3130 | }
```

### bindGlobalProductTabs() — lines 3131-3152

```javascript
L3131 | function bindGlobalProductTabs(){
L3132 |  const host=$('globalProductEditorTabs');
L3133 |  if(!host||host.dataset.bound==='true')return;
L3134 |  host.dataset.bound='true';
L3135 |  host.addEventListener('click',event=>{
L3136 |   const button=event.target.closest('[data-global-product-tab]');
L3137 |   if(button)switchGlobalProductTab(button.dataset.globalProductTab);
L3138 |  });
L3139 |  host.addEventListener('keydown',event=>{
L3140 |   const button=event.target.closest('[data-global-product-tab]');
L3141 |   if(!button)return;
L3142 |   const keys=['basic','units','advanced'],index=keys.indexOf(button.dataset.globalProductTab);
L3143 |   if(index<0)return;
L3144 |   let next=index;
L3145 |   if(event.key==='ArrowLeft')next=(index+1)%keys.length;
L3146 |   else if(event.key==='ArrowRight')next=(index-1+keys.length)%keys.length;
L3147 |   else if(event.key==='Home')next=0;
L3148 |   else if(event.key==='End')next=keys.length-1;
L3149 |   else return;
L3150 |   event.preventDefault();switchGlobalProductTab(keys[next],true);
L3151 |  });
L3152 | }
```

## 3. CSS Related to Items

The following are item/catalog-specific CSS source lines from the file's style block. Utility classes in the Items Tab are CountFlow custom classes; no Tailwind utility-class stylesheet or Tailwind class set was found in this file.

```css
L0011 | .product-thumb{display:block}.product-image-link{display:inline-flex;line-height:0;border-radius:13px;text-decoration:none;cursor:zoom-in}.product-image-link:focus-visible{outline:3px solid #93c5fd;outline-offset:3px}.product-image-placeholder{width:52px;height:52px;flex:0 0 52px;border-radius:13px;border:1px solid var(--line);background:#f1f5f9;object-fit:cover;display:grid;place-items:center;color:var(--muted);font-size:10px;text-align:center;overflow:hidden}
L0012 | .product-image-preview{display:flex;align-items:center;gap:12px;flex-wrap:wrap;margin-top:8px;padding:10px;border:1px solid var(--line);border-radius:14px;background:#f8fafc}
L0013 | .product-image-preview img{width:84px;height:84px;object-fit:cover;border-radius:12px;border:1px solid var(--line);background:#fff}
L0014 | .product-unit-list{display:grid;gap:8px;margin-top:8px}
L0015 | .product-unit-row{display:grid;grid-template-columns:minmax(0,1fr) minmax(130px,.55fr) auto;gap:8px;align-items:center;padding:9px;border:1px solid var(--line);border-radius:13px;background:#fbfdff}
L0016 | .product-unit-row input{width:100%;min-width:0;padding:9px 10px;border:1px solid var(--line);border-radius:9px;background:#fff}
L0138 | /* LVE-776 permanent catalog UI */
L0139 | .cf-catalog-tabs,.cf-catalog-editor-tabs{display:flex;gap:8px;flex-wrap:wrap;margin:0 0 12px;padding:8px;background:#fff;border:1px solid var(--line);border-radius:14px}
L0140 | .cf-catalog-tab,.cf-catalog-editor-tabs button{background:#f8fafc;color:#475569;border:1px solid #e8edf3;padding:9px 13px;font-size:12px;border-radius:10px}
L0141 | .cf-catalog-tab.active,.cf-catalog-editor-tabs button.active{background:#2563eb;border-color:#2563eb;color:#fff}
L0142 | .cf-catalog-toolbar{box-shadow:none;padding:14px}
L0143 | .cf-catalog-primary-actions{display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap;padding:2px 0 13px;border-bottom:1px solid var(--line);margin-bottom:13px}
L0144 | .cf-catalog-primary-actions>div:first-child{display:grid;gap:3px}.cf-catalog-primary-actions b{font-size:14px;color:var(--navy)}.cf-catalog-primary-actions small{font-size:11px;color:var(--muted);line-height:1.6}
L0145 | .cf-catalog-primary-actions .actions{margin:0;display:flex;gap:8px;flex-wrap:wrap}
L0146 | #catalogOpenGlobalImport{min-height:42px;padding:10px 18px;background:#1d4ed8;color:#fff;border:1px solid #1d4ed8;box-shadow:0 5px 14px #1d4ed826}
L0147 | #catalogOpenGlobalImport:hover{background:#1e40af;transform:translateY(-1px)}
L0148 | #catalogOpenClientImport:disabled{opacity:.55;cursor:not-allowed;transform:none}
L0149 | .cf-catalog-search-row{display:grid;grid-template-columns:minmax(220px,1.4fr) minmax(150px,.7fr) minmax(140px,.6fr);gap:10px;align-items:end}
L0150 | .cf-catalog-search-row .field{min-width:0}.cf-catalog-search-row input,.cf-catalog-search-row select{width:100%;padding:10px;border:1px solid var(--line);border-radius:10px;background:#fff}
L0151 | .cf-catalog-actions{margin-top:10px}.cf-catalog-table{min-width:880px}.cf-catalog-table thead th{position:sticky;top:0;background:#f8fafc;z-index:4}
L0152 | .cf-catalog-lookup{display:grid;gap:10px;padding:12px 14px;margin-bottom:14px;border:1px solid #cbd5e1;border-radius:13px;background:#f8fafc}
L0153 | .cf-catalog-lookup>div:first-child{display:grid;gap:3px}.cf-catalog-lookup>div:first-child b{font-size:13px}.cf-catalog-lookup>div:first-child small{font-size:11px;color:var(--muted);line-height:1.6}
L0154 | .cf-catalog-lookup-controls{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:8px}
L0155 | .cf-catalog-lookup-controls input{min-width:0;padding:10px 12px;border:1px solid var(--line);border-radius:10px;background:#fff}
L0156 | .cf-catalog-lookup-results{display:grid;gap:6px}.cf-catalog-lookup-result{display:flex;justify-content:space-between;align-items:center;gap:10px;padding:8px 10px;background:#fff;border:1px solid var(--line);border-radius:9px}
L0157 | .cf-catalog-lookup-result small{color:var(--muted);overflow-wrap:anywhere}
L0158 | .cf-catalog-import-summary{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:8px;margin-top:10px}
L0159 | .cf-catalog-import-summary span{display:block;padding:9px 10px;background:#f8fafc;border:1px solid var(--line);border-radius:9px;font-size:11px;line-height:1.5}
L0160 | .cf-catalog-import-summary b{display:block;font-size:17px;color:var(--navy);font-variant-numeric:tabular-nums}
L0162 |  .cf-catalog-primary-actions{align-items:stretch}
L0163 |  .cf-catalog-primary-actions>div:first-child{flex:1 1 100%}
L0164 |  .cf-catalog-primary-actions .actions{width:100%}
L0165 |  .cf-catalog-primary-actions .actions button{flex:1 1 145px}
L0166 |  .cf-catalog-lookup-controls{grid-template-columns:1fr}
L0167 |  .cf-catalog-import-summary{grid-template-columns:repeat(2,minmax(0,1fr))}
L0168 |  .cf-catalog-lookup-result{align-items:flex-start;flex-direction:column}
L0171 |  .cf-catalog-primary-actions .actions button{flex-basis:100%}
L0172 |  .cf-catalog-import-summary{grid-template-columns:1fr 1fr;gap:6px}
L0175 | .cf-catalog-sort{padding:0;background:transparent;color:inherit;font-weight:800;border-radius:0}.cf-catalog-sort:hover{transform:none;color:#2563eb}
L0176 | .cf-catalog-scope-panel{display:grid;grid-template-columns:minmax(220px,360px) minmax(0,1fr);align-items:end;gap:12px;box-shadow:none}.cf-catalog-scope-panel select{width:100%;padding:10px;border:1px solid var(--line);border-radius:10px;background:#fff}
L0177 | .cf-catalog-custom-units{margin-top:12px;padding:12px;border:1px solid var(--line);border-radius:12px;background:#f8fafc}.cf-checkline{display:flex;gap:9px;align-items:flex-start;font-size:12px;font-weight:800}.cf-catalog-editor-panel{min-height:220px}
L0178 | #globalProductPanel-image input{width:100%;padding:10px;border:1px solid var(--line);border-radius:10px;background:#fff}
L0179 | @media(max-width:780px){.cf-catalog-search-row{grid-template-columns:1fr 1fr}.cf-catalog-search-row .field:first-child{grid-column:1/-1}.cf-catalog-scope-panel{grid-template-columns:1fr}}
L0180 | @media(max-width:520px){.cf-catalog-search-row{grid-template-columns:1fr}.cf-catalog-search-row .field:first-child{grid-column:auto}.cf-catalog-tabs{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:5px}.cf-catalog-tab{padding:8px 5px;font-size:11px}.cf-catalog-editor-tabs{display:grid;grid-template-columns:1fr 1fr}}
L0226 | /* LVE-785 — Admin catalogue workspace */
L0227 | .cf-catalog-tools{margin:0 0 14px;border:1px solid var(--line);border-radius:18px;background:#fff;box-shadow:var(--shadow);overflow:hidden}
L0228 | .cf-catalog-tools>summary{display:flex;align-items:center;justify-content:space-between;gap:12px;cursor:pointer;list-style:none;padding:14px 17px;font-size:13px;font-weight:850;color:#1e293b}
L0229 | .cf-catalog-tools>summary::-webkit-details-marker{display:none}
L0230 | .cf-catalog-tools>summary:after{content:"＋";display:grid;place-items:center;width:28px;height:28px;border-radius:9px;background:#eff6ff;color:#2563eb;font-size:17px}
L0231 | .cf-catalog-tools[open]>summary:after{content:"−"}
L0232 | .cf-catalog-tools>summary small{display:block;font-size:10px;font-weight:500;color:var(--muted);margin-top:2px}
L0233 | .cf-catalog-tools-content{padding:0 12px 12px}
L0234 | .cf-catalog-tools-content>.panel{margin:0;box-shadow:none;border:0;padding:7px}
L0235 | .cf-catalog-workspace{display:grid;grid-template-columns:minmax(0,1fr);gap:12px}
L0236 | .cf-catalog-view-heading{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
L0237 | .cf-catalog-view-heading h3{margin:0}
L0238 | .cf-catalog-list-tools{display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;margin-bottom:10px}
L0239 | .cf-catalog-list-tools .toolbar{margin:0;flex:1}
L0240 | .cf-catalog-table{min-width:820px}
L0241 | .cf-catalog-table tbody tr{transition:background .15s ease}
L0242 | .cf-catalog-table tbody tr:hover{background:#f8fbff}
L0243 | .cf-catalog-sort{padding:4px 0;background:transparent;color:inherit;font-size:inherit}
L0244 | .cf-catalog-sort:hover{transform:none;color:#2563eb}
L0245 | .cf-catalog-image-button{display:inline-grid;place-items:center;padding:0;width:48px;height:48px;border:1px solid #e2e8f0;border-radius:12px;background:#f8fafc;overflow:hidden;cursor:zoom-in}
L0246 | .cf-catalog-image-button:hover{transform:none;border-color:#93c5fd}
L0247 | .cf-catalog-thumb{display:block;width:48px;height:48px;object-fit:cover}
L0248 | .cf-catalog-image-empty{width:48px;height:48px;display:grid;place-items:center;border:1px dashed #cbd5e1;border-radius:12px;background:#f8fafc;color:#94a3b8;font-size:17px}
L0249 | .cf-catalog-editor-preview{min-height:92px}
L0250 | .cf-catalog-editor-preview img{width:104px;height:104px;object-fit:contain;background:#fff}
L0251 | .cf-catalog-export-note{font-size:11px;color:var(--muted)}
L0252 | #projectProductWorkspace:not(.cf-catalog-editor-open){grid-template-columns:minmax(0,1fr)}
L0253 | .split:has(>#projectProductEditorPanel.hidden){grid-template-columns:minmax(0,1fr)}
L0254 | #catalogTable[aria-busy="true"]{opacity:.62;pointer-events:none}
L0255 | @media(max-width:760px){.cf-catalog-tools>summary{align-items:flex-start;padding:12px}.cf-catalog-tools-content{padding:0 8px 8px}.cf-catalog-table{min-width:760px}.cf-catalog-list-tools{align-items:stretch}.cf-catalog-list-tools .toolbar{min-width:100%}.cf-catalog-view-heading{align-items:flex-start}}
L0257 | .cf-catalog-tabs{display:flex;gap:8px;flex-wrap:wrap;margin:0 0 12px;padding:6px;background:#f1f5f9;border:1px solid var(--line);border-radius:14px}
L0258 | .cf-catalog-tab{flex:1 1 145px;background:#fff;color:var(--muted);border:1px solid var(--line);padding:10px 12px}
L0259 | .cf-catalog-tab[aria-selected="true"]{background:var(--navy);color:#fff;border-color:var(--navy)}
L0260 | .cf-catalog-tab:focus-visible{outline:3px solid #93c5fd;outline-offset:2px}
L0261 | .cf-catalog-image-panel{margin-top:12px}
L0262 | .cf-catalog-barcode-field{padding:14px;border:1px solid var(--line);border-radius:14px;background:linear-gradient(180deg,#fff,#f8fafc)}
L0263 | .cf-catalog-barcode-entry{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:8px;align-items:center}
L0264 | .cf-catalog-barcode-entry input{min-width:0;width:100%;padding:12px 13px;border:1px solid var(--line);border-radius:10px;background:#fff;font-variant-numeric:tabular-nums;letter-spacing:.04em}
L0265 | .cf-catalog-barcode-actions{display:flex;gap:7px;flex-wrap:wrap}
L0266 | .cf-catalog-barcode-actions button{min-height:42px;white-space:nowrap}
L0267 | .cf-catalog-barcode-actions button:disabled{opacity:.5;cursor:not-allowed}
L0268 | .cf-catalog-barcode-status{display:flex;align-items:flex-start;gap:8px;margin-top:10px;padding:10px 12px;border:1px solid var(--line);border-radius:10px;background:#f8fafc;color:var(--muted);font-size:12px;line-height:1.7}
L0269 | .cf-catalog-barcode-status[data-state="restricted"]{border-color:#fed7aa;background:#fff7ed;color:#9a3412}
L0270 | .cf-catalog-barcode-status[data-state="valid"]{border-color:#bbf7d0;background:#f0fdf4;color:#166534}
L0271 | .cf-catalog-barcode-status[data-state="internal"]{border-color:#bfdbfe;background:#eff6ff;color:#1d4ed8}
L0272 | .cf-catalog-barcode-status[data-state="invalid"]{border-color:#fecaca;background:#fef2f2;color:#b91c1c}
L0273 | @media(max-width:600px){.cf-catalog-tabs{display:grid;grid-template-columns:1fr}.cf-catalog-tab{width:100%;text-align:center}.cf-catalog-barcode-entry{grid-template-columns:1fr}.cf-catalog-barcode-actions{display:grid;grid-template-columns:1fr 1fr}.cf-catalog-barcode-actions button{width:100%}}
```

## 4. JavaScript Functions

The following complete function bodies are copied from the source with original line numbers. The set covers project items, unified catalog operations, item editing, measurement units, categories, barcode handling, item images, and import/export. Each function is presented separately.

### renderProductImportSessions() — lines 895-901

```javascript
L0895 | function renderProductImportSessions(){
L0896 |   const select=$('productImportSession');if(!select)return;
L0897 |   const keep=select.value;
L0898 |   const eligible=(state.sessions||[]).filter(s=>['planned','active','paused','review'].includes(s.status));
L0899 |   select.innerHTML='<option value="">كتالوج فقط</option>'+eligible.map(s=>'<option value="'+s.id+'">'+esc(s.name)+' · '+esc(statusName(s.status))+'</option>').join('');
L0900 |   if(eligible.some(s=>s.id===keep))select.value=keep;
L0901 |  }
```

### loadProductsPage() — lines 910-925

```javascript
L0910 | async function loadProductsPage(page=1,query=state.productQuery){
L0911 |   if(!state.project)return;
L0912 |   return withTableSkeletons([['productTable',6,6]],async()=>{
L0913 |    const pid=state.project.id,requestToken=++state.productImageToken,limit=100,q=String(query||'').trim().replace(/[(),]/g,' ').replace(/[%_]/g,' ').slice(0,100);
L0914 |    let request=db.from('count_products').select('*',{count:'exact'}).eq('project_id',pid);
L0915 |    if(q)request=request.or(['name','sku','barcode','category'].map(k=>k+'.ilike.%'+q+'%').join(','));
L0916 |    const {data,error,count}=await request.order('name',{ascending:true}).order('id',{ascending:true}).range((Math.max(1,page)-1)*limit,Math.max(1,page)*limit-1);
L0917 |    if(error)throw error;
L0918 |    if(state.project?.id!==pid||state.productImageToken!==requestToken)return;
L0919 |    state.productImageUrls.clear();
L0920 |    await loadProductImageUrls(data||[],pid,requestToken);
L0921 |    if(state.project?.id!==pid||state.productImageToken!==requestToken)return;
L0922 |    state.products=data||[];state.productTotal=count||0;state.productPage=Math.max(1,page);state.productQuery=query||'';state.productScrollTop=0;
L0923 |    renderProducts();
L0924 |   });
L0925 |  }
```

### isProjectProductImagePath() — lines 927-931

```javascript
L0927 | function isProjectProductImagePath(reference,projectId){
L0928 |   const value=String(reference??''),prefix=String(projectId||'')+'/products/';
L0929 |   if(!projectId||!value.startsWith(prefix))return false;
L0930 |   return /^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$/.test(value.slice(prefix.length));
L0931 |  }
```

### safeExternalProductImageUrl() — lines 932-940

```javascript
L0932 | function safeExternalProductImageUrl(reference){
L0933 |   const value=String(reference??'').trim();
L0934 |   try{
L0935 |    const url=new URL(value);
L0936 |    if(url.protocol!=='https:'||!url.hostname||url.username||url.password||/[\\\s]/.test(value)
L0937 |       ||/\/storage\/v1\/object\/sign\//i.test(url.pathname)||url.searchParams.has('token')||url.searchParams.has('expiresIn'))return '';
L0938 |    return url.href;
L0939 |   }catch(_){return ''}
L0940 |  }
```

### loadProductImageUrls() — lines 941-951

```javascript
L0941 | async function loadProductImageUrls(rows,projectId,token){
L0942 |   const paths=[...new Set((rows||[]).map(p=>String(p.image_url||'').trim()).filter(path=>
L0943 |    isProjectProductImagePath(path,projectId)
L0944 |   ))];
L0945 | 
L0946 |   if(!paths.length)return;
L0947 |   const {data,error}=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L0948 |   if(error){console.warn('Product image signing failed',error);return;}
L0949 |   if(state.project?.id!==projectId||state.productImageToken!==token)return;
L0950 |   for(const item of data||[])if(item.path&&item.signedUrl)state.productImageUrls.set(projectId+'|'+item.path,item.signedUrl);
L0951 |  }
```

### productImageDisplayUrl() — lines 952-959

```javascript
L0952 | function productImageDisplayUrl(product){
L0953 |   const reference=String(product?.image_url||'').trim();
L0954 |   const externalUrl=safeExternalProductImageUrl(reference);
L0955 |   if(externalUrl)return externalUrl;
L0956 |   const projectId=state.project?.id||'';
L0957 |   if(!isProjectProductImagePath(reference,projectId))return '';
L0958 |   return state.productImageUrls.get(projectId+'|'+reference)||'';
L0959 |  }
```

### renderProducts() — lines 961-979

```javascript
L0961 | function renderProducts(){
L0962 |   const rows=state.products||[],pageSize=100,totalPages=Math.max(1,Math.ceil(state.productTotal/pageSize)),windowSize=30,rowHeight=76;
L0963 |   state.productPage=Math.min(Math.max(1,state.productPage),totalPages);
L0964 |   const first=Math.min(Math.max(0,Math.floor((state.productScrollTop||0)/rowHeight)),Math.max(0,rows.length-windowSize)),visible=rows.slice(first,first+windowSize);
L0965 |   const rowHtml=x=>{
L0966 |    const imageUrl=productImageDisplayUrl(x),hasImageReference=Boolean(String(x.image_url||'').trim()),image=imageUrl?'<a class="product-image-link" href="'+esc(imageUrl)+'" target="_blank" rel="noopener noreferrer" aria-label="فتح صورة '+esc(x.name||x.sku||'الصنف')+'"><img class="product-thumb" data-product-image="1" src="'+esc(imageUrl)+'" alt="'+esc(x.name||'صورة الصنف')+'" loading="lazy" decoding="async" referrerpolicy="no-referrer"></a>':'<span class="product-image-placeholder">'+(hasImageReference?'الصورة غير متاحة':'بدون صورة')+'</span>';
L0967 |    const units=productUnitRows(Array.isArray(x.units)?x.units:[]),unitSummary=units.length?units.length+' وحدات بديلة':'الوحدة الأساسية فقط';
L0968 |    return '<tr><td>'+image+'</td><td><b>'+esc(x.name||'اسم غير متوفر')+'</b><span class="sub">'+esc(x.category||'بدون تصنيف')+'</span></td><td>'+esc(x.sku||x.barcode||'—')+'<span class="sub">'+esc(x.sku&&x.barcode?x.barcode:'')+'</span></td><td>'+esc(x.base_unit)+'<span class="sub">'+esc(unitSummary)+'</span></td><td>'+statusPill(x.is_active?'نشط':'موقوف')+'</td><td><button class="soft" data-edit-product="'+x.id+'">تعديل</button> <button class="'+(x.is_active?'danger':'soft')+'" data-toggle-product="'+x.id+'">'+(x.is_active?'إيقاف':'تفعيل')+'</button></td></tr>';
L0969 |   };
L0970 |   const top=first*rowHeight,bottom=Math.max(0,(rows.length-first-visible.length)*rowHeight);
L0971 |   $('productCount').textContent=state.productTotal.toLocaleString('en-US')+' نتيجة · صفحة '+state.productPage+' من '+totalPages;
L0972 |   $('productTable').innerHTML=rows.length?'<div id="productVirtualScroller" style="max-height:520px;overflow:auto;position:relative"><table><thead><tr><th>الصورة</th><th>الصنف</th><th>كود الصنف / باركود</th><th>الوحدة والتحويلات</th><th>الحالة</th><th>إجراء</th></tr></thead><tbody>'+(top?'<tr aria-hidden="true"><td colspan="6" style="height:'+top+'px;padding:0;border:0"></td></tr>':'')+visible.map(rowHtml).join('')+(bottom?'<tr aria-hidden="true"><td colspan="6" style="height:'+bottom+'px;padding:0;border:0"></td></tr>':'')+'</tbody></table></div>':'<div class="empty">لا توجد نتائج مطابقة.</div>';
L0973 |   $('productTable').querySelectorAll('[data-product-image]').forEach(img=>img.addEventListener('error',()=>{const fallback=document.createElement('span');fallback.className='product-image-placeholder';fallback.textContent='الصورة غير متاحة';const link=img.closest('.product-image-link');(link||img).replaceWith(fallback);},{once:true}));
L0974 |   $('productPager').innerHTML=state.productTotal>pageSize?'<span class="hint">إجمالي '+state.productTotal.toLocaleString('en-US')+' صنف</span><button type="button" class="soft" data-product-page="'+Math.max(1,state.productPage-1)+'" '+(state.productPage===1?'disabled':'')+'>السابق</button><button type="button" class="soft" data-product-page="'+Math.min(totalPages,state.productPage+1)+'" '+(state.productPage===totalPages?'disabled':'')+'>التالي</button>':'';
L0975 |   const scroller=$('productVirtualScroller');if(scroller){scroller.scrollTop=state.productScrollTop||0;scroller.onscroll=()=>{state.productScrollTop=scroller.scrollTop;renderProducts();};}
L0976 |   $('productTable').querySelectorAll('[data-edit-product]').forEach(b=>b.onclick=()=>editProduct(b.dataset.editProduct));
L0977 |   $('productTable').querySelectorAll('[data-toggle-product]').forEach(b=>b.onclick=()=>toggleProduct(b.dataset.toggleProduct));
L0978 |   $('productPager').querySelectorAll('[data-product-page]').forEach(b=>b.onclick=()=>loadProductsPage(Number(b.dataset.productPage),state.productQuery).catch(e=>fail('تعذر تحميل صفحة الأصناف',e)));
L0979 |  }
```

### zipRead16() — lines 1216-1216

```javascript
L1216 | function zipRead16(view,offset){return view.getUint16(offset,true);}
```

### zipRead32() — lines 1217-1217

```javascript
L1217 | function zipRead32(view,offset){return view.getUint32(offset,true);}
```

### openXlsxZip() — lines 1218-1244

```javascript
L1218 | async function openXlsxZip(file){
L1219 |   if(!file||typeof file.slice!=='function'||!file.stream)throw new Error('المتصفح لا يدعم قراءة ملفات Excel المتدفقة.');
L1220 |   if(file.size>256*1024*1024)throw new Error('حجم ملف XLSX يتجاوز الحد الآمن 256MB. قسّم الملف إلى أجزاء أصغر.');
L1221 |   const tailSize=Math.min(file.size,65557),tail=new Uint8Array(await file.slice(file.size-tailSize).arrayBuffer()),tailView=new DataView(tail.buffer,tail.byteOffset,tail.byteLength);
L1222 |   let eocd=-1;for(let i=tail.length-22;i>=0;i--){if(zipRead32(tailView,i)===0x06054b50){eocd=i;break;}}
L1223 |   if(eocd<0)throw new Error('ملف XLSX غير صالح أو لا يحتوي على ZIP directory.');
L1224 |   if(zipRead16(tailView,eocd+4)!==0||zipRead16(tailView,eocd+6)!==0)throw new Error('ملفات Excel متعددة الأقراص غير مدعومة.');
L1225 |   const entries=zipRead16(tailView,eocd+10),entriesOnDisk=zipRead16(tailView,eocd+8),directorySize=zipRead32(tailView,eocd+12),directoryOffset=zipRead32(tailView,eocd+16),commentLength=zipRead16(tailView,eocd+20);
L1226 |   const eocdAbsolute=file.size-tailSize+eocd;
L1227 |   if(entries!==entriesOnDisk||entries===0xffff||directorySize===0xffffffff||directoryOffset===0xffffffff||eocd+22+commentLength!==tail.length)throw new Error('صيغة XLSX ZIP64 أو بنية أرشيف غير مدعومة.');
L1228 |   if(entries>10000||directorySize>32*1024*1024||directoryOffset+directorySize>eocdAbsolute)throw new Error('بيانات فهرس XLSX تتجاوز الحدود الآمنة.');
L1229 |   const directory=new Uint8Array(await file.slice(directoryOffset,directoryOffset+directorySize).arrayBuffer()),view=new DataView(directory.buffer,directory.byteOffset,directory.byteLength),map=new Map();let offset=0;
L1230 |   for(let i=0;i<entries;i++){
L1231 |    if(offset+46>directory.length||zipRead32(view,offset)!==0x02014b50)throw new Error('فهرس XLSX المركزي تالف.');
L1232 |    const flags=zipRead16(view,offset+8),method=zipRead16(view,offset+10),crc32=zipRead32(view,offset+16),compressedSize=zipRead32(view,offset+20),uncompressedSize=zipRead32(view,offset+24),nameLength=zipRead16(view,offset+28),extraLength=zipRead16(view,offset+30),comment=zipRead16(view,offset+32),disk=zipRead16(view,offset+34),localOffset=zipRead32(view,offset+42);
L1233 |    if(disk!==0||(flags&1)||(flags&0x40)||![0,8].includes(method)||compressedSize===0xffffffff||uncompressedSize===0xffffffff||localOffset===0xffffffff)throw new Error('ملف XLSX يحتوي على تشفير أو ضغط أو امتداد ZIP غير مدعوم.');
L1234 |    if(offset+46+nameLength+extraLength+comment>directory.length)throw new Error('بيانات اسم ملف داخل XLSX غير مكتملة.');
L1235 |    const name=new TextDecoder('utf-8').decode(directory.slice(offset+46,offset+46+nameLength)).replace(/\\/g,'/');
L1236 |    if(name.startsWith('/')||name.split('/').includes('..'))throw new Error('مسار داخلي غير صالح في ملف XLSX.');
L1237 |    if(map.has(name))throw new Error('أرشيف XLSX يحتوي على اسم عنصر مكرر.');
L1238 |    map.set(name,{name,flags,method,crc32,compressedSize,uncompressedSize,localOffset});
L1239 |    offset+=46+nameLength+extraLength+comment;
L1240 |   }
L1241 |   if(offset!==directory.length)throw new Error('حجم فهرس ZIP لا يطابق عدد عناصر XLSX.');
L1242 |   if(!map.has('xl/workbook.xml'))throw new Error('لم يتم العثور على xl/workbook.xml؛ الملف ليس XLSX صالحاً.');
L1243 |   return map;
L1244 |  }
```

### streamZipEntry() — lines 1246-1269

```javascript
L1246 | async function streamZipEntry(file,entry,maxBytes,onChunk){
L1247 |   if(!entry)throw new Error('عنصر مطلوب غير موجود داخل ملف XLSX.');
L1248 |   if(entry.uncompressedSize>maxBytes)throw new Error('ورقة Excel أو جدول النصوص يتجاوز حد القراءة الآمن ('+Math.round(maxBytes/1024/1024)+'MB). قسّم الملف.');
L1249 |   const header=new DataView(await file.slice(entry.localOffset,entry.localOffset+30).arrayBuffer());
L1250 |   if(header.byteLength<30||zipRead32(header,0)!==0x04034b50)throw new Error('رأس عنصر XLSX المحلي غير صالح.');
L1251 |   const nameLength=zipRead16(header,26),extraLength=zipRead16(header,28),dataStart=entry.localOffset+30+nameLength+extraLength,dataEnd=dataStart+entry.compressedSize;
L1252 |   if(dataEnd>file.size)throw new Error('بيانات عنصر XLSX تتجاوز نهاية الملف.');
L1253 |   let stream=file.slice(dataStart,dataEnd).stream();
L1254 |   if(entry.method===8){
L1255 |    if(typeof DecompressionStream!=='function')throw new Error('هذا المتصفح لا يدعم فك ضغط XLSX المتدفق. استخدم متصفحاً حديثاً أو صدّر الملف CSV.');
L1256 |    try{stream=stream.pipeThrough(new DecompressionStream('deflate-raw'));}catch(e){throw new Error('تعذر تهيئة فك ضغط XLSX المتدفق: '+(e?.message||e));}
L1257 |   }
L1258 |   const reader=stream.getReader();let total=0,crc=0xffffffff;
L1259 |   try{
L1260 |    while(true){
L1261 |     const {value,done}=await reader.read();if(done)break;if(!value)continue;
L1262 |     total+=value.byteLength;if(total>maxBytes||total>entry.uncompressedSize){await reader.cancel();throw new Error('حجم المحتوى المفكوك في XLSX يتجاوز الحدود المعلنة.');}
L1263 |     for(let i=0;i<value.length;i++)crc=xlsxCrcTable[(crc^value[i])&255]^(crc>>>8);
L1264 |     await onChunk(value);
L1265 |    }
L1266 |   }catch(error){try{await reader.cancel(error);}catch(_){}throw error;}finally{reader.releaseLock();}
L1267 |   if(total!==entry.uncompressedSize)throw new Error('حجم عنصر XLSX بعد فك الضغط لا يطابق الفهرس.');
L1268 |   if(((crc^0xffffffff)>>>0)!==(entry.crc32>>>0))throw new Error('فشل التحقق من سلامة CRC لبيانات XLSX.');
L1269 |  }
```

### readXlsxEntryText() — lines 1270-1274

```javascript
L1270 | async function readXlsxEntryText(file,entry,maxBytes){
L1271 |   const decoder=new TextDecoder('utf-8',{fatal:false});let text='';
L1272 |   await streamZipEntry(file,entry,maxBytes,chunk=>{text+=decoder.decode(chunk,{stream:true});if(text.length>maxBytes)throw new Error('ملف XML داخل XLSX أكبر من الحد الآمن.');});
L1273 |   text+=decoder.decode();return text;
L1274 |  }
```

### xmlAttr() — lines 1275-1280

```javascript
L1275 | function xmlAttr(source,name){
L1276 |   const doubleQuoted=new RegExp('\\b'+name+'\\s*=\\s*"([^"]*)"','i').exec(source||'');
L1277 |   if(doubleQuoted)return doubleQuoted[1];
L1278 |   const singleQuoted=new RegExp("\\b"+name+"\\s*=\\s*'([^']*)'","i").exec(source||'');
L1279 |   return singleQuoted?singleQuoted[1]:'';
L1280 |  }
```

### xmlText() — lines 1281-1281

```javascript
L1281 | function xmlText(value){return String(value??'').replace(/&#x([0-9a-f]+);/gi,(_,h)=>String.fromCodePoint(parseInt(h,16))).replace(/&#([0-9]+);/g,(_,n)=>String.fromCodePoint(parseInt(n,10))).replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&quot;/g,'"').replace(/&apos;/g,"'").replace(/&amp;/g,'&');}
```

### streamXmlRecords() — lines 1282-1299

```javascript
L1282 | async function streamXmlRecords(file,entry,tag,maxBytes,maxRecordBytes,onRecord){
L1283 |   const decoder=new TextDecoder('utf-8',{fatal:false}),startRe=new RegExp('<'+tag+'\\b[^>]*>','i'),close='</'+tag+'>';let pending='';
L1284 |   const drain=async()=>{
L1285 |    while(true){
L1286 |     const start=pending.search(startRe);if(start<0){pending=pending.slice(-64);return;}
L1287 |     if(start>0)pending=pending.slice(start);
L1288 |     const openEnd=pending.indexOf('>');if(openEnd<0)return;
L1289 |     if(pending[openEnd-1]==='/'){pending=pending.slice(openEnd+1);continue;}
L1290 |     const closeAt=pending.indexOf(close,openEnd+1);if(closeAt<0)return;
L1291 |     const record=pending.slice(0,closeAt+close.length);pending=pending.slice(closeAt+close.length);
L1292 |     if(record.length>maxRecordBytes)throw new Error('صف Excel واحد يتجاوز حد الحجم الآمن.');
L1293 |     await onRecord(record);
L1294 |    }
L1295 |   };
L1296 |   await streamZipEntry(file,entry,maxBytes,async chunk=>{pending+=decoder.decode(chunk,{stream:true});await drain();if(pending.length>maxRecordBytes+128)throw new Error('سجل XML في XLSX أكبر من الحد الآمن.');});
L1297 |   pending+=decoder.decode();await drain();
L1298 |   if(pending.includes('<'+tag))throw new Error('انتهى ملف XLSX داخل سجل XML غير مكتمل.');
L1299 |  }
```

### parseXlsxSharedString() — lines 1300-1300

```javascript
L1300 | function parseXlsxSharedString(record){let result='';for(const m of record.matchAll(/<t\b[^>]*>([\s\S]*?)<\/t>/g))result+=xmlText(m[1]);return result;}
```

### excelColumnIndex() — lines 1308-1308

```javascript
L1308 | function excelColumnIndex(reference){const letters=/^[A-Z]+/i.exec(reference||'')?.[0]?.toUpperCase()||'';let n=0;for(const c of letters)n=n*26+c.charCodeAt(0)-64;return n?n-1:-1;}
```

### excelSerialDate() — lines 1309-1309

```javascript
L1309 | function excelSerialDate(serial,date1904){const base=date1904?Date.UTC(1904,0,1):Date.UTC(1899,11,30),d=new Date(base+Number(serial)*86400000);return Number.isNaN(d.getTime())?'':(Number(serial)%1?d.toISOString():d.toISOString().slice(0,10));}
```

### xlsxCellValue() — lines 1310-1320

```javascript
L1310 | function xlsxCellValue(cellXml,attrs,shared,styles,date1904){
L1311 |   const type=xmlAttr(attrs,'t'),style=Number(xmlAttr(attrs,'s')||0);
L1312 |   if(type==='inlineStr'){let text='';for(const m of cellXml.matchAll(/<t\b[^>]*>([\s\S]*?)<\/t>/g))text+=xmlText(m[1]);return text;}
L1313 |   const v=/<v\b[^>]*>([\s\S]*?)<\/v>/i.exec(cellXml)?.[1];if(v===undefined)return '';
L1314 |   const raw=xmlText(v);
L1315 |   if(type==='s'){const i=Number(raw);if(!Number.isInteger(i)||i<0||i>=shared.length)throw new Error('مرجع shared string غير صالح في XLSX.');return shared[i];}
L1316 |   if(type==='b')return raw==='1'?'TRUE':'FALSE';
L1317 |   if(type==='e'||type==='d')return raw;
L1318 |   if(styles[style]&&raw!==''&&Number.isFinite(Number(raw)))return excelSerialDate(raw,date1904);
L1319 |   return raw;
L1320 |  }
```

### makeUniqueXlsxHeaders() — lines 1321-1323

```javascript
L1321 | function makeUniqueXlsxHeaders(values){
L1322 |   const used=new Set();return values.map((v,i)=>{const base=String(v??'').trim()||('Column '+(i+1));let name=base,n=2;while(used.has(name.toLowerCase()))name=base+' ('+(n++)+')';used.add(name.toLowerCase());return name;});
L1323 |  }
```

### parseProductImportFile() — lines 1355-1379

```javascript
L1355 | async function parseProductImportFile(file){
L1356 |   const ext=(file.name.split('.').pop()||'').toLowerCase();
L1357 |   if(ext==='xlsx'){
L1358 |    const sample=[],parsed=await streamXlsxProductRows(file,row=>{if(sample.length<20)sample.push(row);});
L1359 |    return {rows:null,sample,count:parsed.count,headers:parsed.headers,streaming:true};
L1360 |   }
L1361 |   if(ext==='xls'){
L1362 |    if(file.size>8*1024*1024)throw new Error('ملفات XLS الثنائية القديمة محدودة بـ8MB لتجنب استهلاك الذاكرة. احفظ الملف بصيغة XLSX ثم أعد المحاولة.');
L1363 |    if(!window.XLSX)throw new Error('مكتبة قراءة ملفات XLS القديمة غير متاحة.');
L1364 |    const book=XLSX.read(await file.arrayBuffer(),{type:'array',cellDates:false});
L1365 |    if(!book.SheetNames?.length)throw new Error('ملف XLS لا يحتوي على أوراق عمل.');
L1366 |    const rows=XLSX.utils.sheet_to_json(book.Sheets[book.SheetNames[0]],{defval:'',raw:false,blankrows:false});
L1367 |    return {rows,sample:rows.slice(0,20),count:rows.length,headers:Object.keys(rows[0]||{}),streaming:false,legacyBinary:true};
L1368 |   }
L1369 |   if(ext==='csv'){
L1370 |    if(!window.Papa)throw new Error('مكتبة قراءة CSV غير متاحة. أعد تحميل الصفحة ثم حاول مرة أخرى.');
L1371 |    return await new Promise((resolve,reject)=>{
L1372 |     const sample=[],headers=[];let count=0,parseErrors=0;
L1373 |     Papa.parse(file,{header:true,skipEmptyLines:'greedy',dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L1374 |      step:r=>{if(r.errors?.length){parseErrors+=r.errors.length;return;}const row=r.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;if(!headers.length)headers.push(...(r.meta?.fields||Object.keys(row)));count++;if(sample.length<20)sample.push(row);},
L1375 |      complete:()=>resolve({rows:null,sample,count,headers,streaming:true,parseErrors}),error:reject});
L1376 |    });
L1377 |   }
L1378 |   throw new Error('امتداد الملف غير مدعوم. استخدم XLSX أو CSV أو XLS صغيراً حتى 8MB.');
L1379 |  }
```

### hashFileInChunks() — lines 1380-1388

```javascript
L1380 | async function hashFileInChunks(file){
L1381 |   let previous=new Uint8Array(32),offset=0;const chunkSize=1024*1024;
L1382 |   while(offset<file.size){
L1383 |    const part=new Uint8Array(await file.slice(offset,Math.min(file.size,offset+chunkSize)).arrayBuffer());
L1384 |    const input=new Uint8Array(previous.length+part.length);input.set(previous);input.set(part,previous.length);
L1385 |    previous=new Uint8Array(await crypto.subtle.digest('SHA-256',input));offset+=part.length;
L1386 |   }
L1387 |   return 'sha256-chain-v1:'+Array.from(previous,v=>v.toString(16).padStart(2,'0')).join('');
L1388 |  }
```

### globalCatalogImportValue() — lines 1402-1405

```javascript
L1402 | function globalCatalogImportValue(row,key,mapping=state.globalCatalogImport.mapping){
L1403 |   const header=mapping?.[key];
L1404 |   return header&&Object.prototype.hasOwnProperty.call(row,header)?row[header]:'';
L1405 |  }
```

### renderGlobalCatalogImportMapping() — lines 1406-1423

```javascript
L1406 | function renderGlobalCatalogImportMapping(){
L1407 |   const g=state.globalCatalogImport,host=$('globalCatalogImportMapping'),headers=g.headers||[];
L1408 |   if(!headers.length)throw new Error('لم يتم العثور على عناوين أعمدة في الملف.');
L1409 |   g.mapping=g.mapping||{};
L1410 |   for(const field of globalCatalogImportFields){
L1411 |    if(!Object.prototype.hasOwnProperty.call(g.mapping,field.key)){
L1412 |     const aliases=field.aliases.map(x=>String(x).trim().toLocaleLowerCase());
L1413 |     g.mapping[field.key]=headers.find(h=>aliases.includes(String(h).trim().toLocaleLowerCase()))||'';
L1414 |    }
L1415 |   }
L1416 |   host.classList.remove('hidden');
L1417 |   host.innerHTML='<div class="panel" style="box-shadow:none;margin:0;padding:12px"><b>مطابقة أعمدة الملف مع الدليل العالمي</b><p class="hint">اسم الصنف ووحدة الأساس إلزاميان. SKU والباركود اختياريان؛ عند غيابهما يُنشأ SKU داخلي ثابت من بصمة الملف ورقم الصف. لا ينشئ هذا المسار أرصدة أو حركات جرد أو قيوداً مالية.</p><div class="fields">'+globalCatalogImportFields.map(f=>'<div class="field"><label>'+esc(f.label)+'</label><select data-global-catalog-import-map="'+f.key+'"><option value="">— تجاهل الحقل —</option>'+headers.map(h=>'<option value="'+esc(h)+'" '+(g.mapping[f.key]===h?'selected':'')+'>'+esc(h)+'</option>').join('')+'</select></div>').join('')+'</div></div>';
L1418 |   host.querySelectorAll('[data-global-catalog-import-map]').forEach(select=>select.onchange=()=>{
L1419 |    g.mapping[select.dataset.globalCatalogImportMap]=select.value;
L1420 |    $('globalCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||!g.mapping.base_unit;
L1421 |   });
L1422 |   $('globalCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||!g.mapping.base_unit;
L1423 |  }
```

### renderGlobalCatalogImportPreview() — lines 1424-1428

```javascript
L1424 | function renderGlobalCatalogImportPreview(){
L1425 |   const g=state.globalCatalogImport,headers=g.headers||[],rows=(g.sample||[]).slice(0,8);
L1426 |   const sample=rows.length?'<div class="tablewrap"><table><thead><tr>'+headers.slice(0,8).map(h=>'<th>'+esc(h)+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+headers.slice(0,8).map(h=>'<td>'+esc(String(r[h]??'').slice(0,80))+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>':'';
L1427 |   $('globalCatalogImportPreviewText').innerHTML='<b>معاينة الملف: '+Number(g.count||0).toLocaleString('en-US')+' صف</b><span class="sub"> أول ورقة / أول 8 صفوف للمعاينة · '+headers.length+' عمود</span>'+sample;
L1428 |  }
```

### resetGlobalCatalogImport() — lines 1429-1443

```javascript
L1429 | function resetGlobalCatalogImport(){
L1430 |   const g=state.globalCatalogImport;
L1431 |   if(g?.busy)return notify('لا يمكن إلغاء الملف أثناء تنفيذ دفعة؛ انتظر اكتمال الاستدعاء الحالي.',true);
L1432 |   state.globalCatalogImport={file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',parseErrors:0,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}};
L1433 |   $('globalCatalogImportFile').value='';
L1434 |   $('globalCatalogImportMapping').classList.add('hidden');
L1435 |   $('globalCatalogImportMapping').innerHTML='';
L1436 |   $('globalCatalogImportPreviewText').textContent='';
L1437 |   $('globalCatalogImportProgress').textContent='لم يبدأ الاستيراد';
L1438 |   $('globalCatalogImportProgressFill').style.width='0%';
L1439 |   $('globalCatalogImportErrors').innerHTML='';
L1440 |   $('globalCatalogImportCommit').disabled=true;
L1441 |   $('globalCatalogImportPreview').disabled=false;
L1442 |   $('globalCatalogImportReset').disabled=false;
L1443 |  }
```

### previewGlobalCatalogImport() — lines 1444-1474

```javascript
L1444 | async function previewGlobalCatalogImport(){
L1445 |   if(!state.platformOwner)return notify('استيراد الدليل العالمي متاح لمالك المنصة فقط.',true);
L1446 |   const file=$('globalCatalogImportFile').files?.[0];
L1447 |   if(!file)return notify('اختر ملف CSV أو XLSX أولاً.',true);
L1448 |   if(state.globalCatalogImport?.busy)return;
L1449 |   const previewButton=$('globalCatalogImportPreview'),commitButton=$('globalCatalogImportCommit'),resetButton=$('globalCatalogImportReset');
L1450 |   previewButton.disabled=true;commitButton.disabled=true;resetButton.disabled=true;
L1451 |   $('globalCatalogImportProgress').textContent='جار فحص بنية الملف وقراءة عينة من الصفوف…';
L1452 |   $('globalCatalogImportErrors').innerHTML='';
L1453 |   try{
L1454 |    const parsed=await parseProductImportFile(file);
L1455 |    if(!parsed.count)throw new Error('لا توجد صفوف بيانات قابلة للقراءة.');
L1456 |    if(parsed.count>90000)throw new Error('الحد الأقصى للدليل العالمي 90,000 صف في الملف الواحد.');
L1457 |    const ext=(file.name.split('.').pop()||'').toLowerCase();
L1458 |    if(!['csv','xlsx','xls'].includes(ext))throw new Error('امتداد الملف غير مدعوم. استخدم CSV أو XLSX.');
L1459 |    state.globalCatalogImport={file,count:parsed.count,headers:parsed.headers||Object.keys((parsed.sample||parsed.rows||[])[0]||{}),sample:parsed.sample||parsed.rows||[],mapping:{},busy:false,checksum:'',sourceFormat:ext==='csv'?'csv':ext==='xlsx'?'xlsx':'xls',parseErrors:Number(parsed.parseErrors||0),stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}};
L1460 |    renderGlobalCatalogImportMapping();
L1461 |    renderGlobalCatalogImportPreview();
L1462 |    $('globalCatalogImportProgress').textContent=(parsed.streaming?'تم فحص الملف دون تحميل جميع صفوفه إلى الذاكرة. ':'تمت قراءة الملف. ')+Number(parsed.count).toLocaleString('en-US')+' صف؛ راجع مطابقة الأعمدة قبل الاستيراد.';
L1463 |    if(parsed.parseErrors)$('globalCatalogImportProgress').textContent+=' أخطاء تحليل CSV المتجاوزة في المعاينة: '+parsed.parseErrors;
L1464 |   }catch(error){
L1465 |    state.globalCatalogImport={file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',parseErrors:0,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}};
L1466 |    $('globalCatalogImportPreviewText').textContent='';
L1467 |    $('globalCatalogImportMapping').classList.add('hidden');
L1468 |    $('globalCatalogImportProgress').textContent='تعذرت المعاينة: '+friendlyErrorMessage(error);
L1469 |    fail('تعذرت معاينة ملف الدليل العالمي',error);
L1470 |   }finally{
L1471 |    previewButton.disabled=false;resetButton.disabled=false;
L1472 |    commitButton.disabled=!state.globalCatalogImport.count||!state.globalCatalogImport.mapping.name||!state.globalCatalogImport.mapping.base_unit;
L1473 |   }
L1474 |  }
```

### normalizeGlobalCatalogImportRow() — lines 1475-1519

```javascript
L1475 | function normalizeGlobalCatalogImportRow(row,index,sourceRowNumber=null,checksum='',mapping=state.globalCatalogImport.mapping,allowMissingBaseUnit=false){
L1476 |   const value=key=>String(globalCatalogImportValue(row,key,mapping)??'').trim();
L1477 |   const rowNumber=Number(sourceRowNumber||row.__countflowRowNumber||index+2);
L1478 |   const name=value('name'),baseUnit=value('base_unit');
L1479 |   if(!name)throw new Error('اسم الصنف مطلوب.');
L1480 |   if(name.length>240)throw new Error('اسم الصنف يتجاوز 240 حرفاً.');
L1481 |   if(!baseUnit&&!allowMissingBaseUnit)throw new Error('وحدة الأساس مطلوبة.');
L1482 |   if(baseUnit.length>40)throw new Error('اسم وحدة الأساس يتجاوز 40 حرفاً.');
L1483 |   let sku=value('sku')||null,barcode=value('barcode')||null;
L1484 |   if(sku&&sku.length>100)throw new Error('SKU يتجاوز 100 حرف.');
L1485 |   if(barcode&&barcode.length>120)throw new Error('الباركود يتجاوز 120 حرفاً.');
L1486 |   const unitClassRaw=value('unit_class'),unitClass=['count','mass','volume','length','area','other'].includes(unitClassRaw)?unitClassRaw:inferProductUnitClass(baseUnit);
L1487 |   const precisionRaw=value('decimal_precision'),decimalPrecision=precisionRaw===''?defaultProductUnitPrecision(unitClass):Number(precisionRaw);
L1488 |   let itemKind=value('item_kind').toUpperCase(),barcodeType=barcode?cfResolveBarcodeType(barcode,value('barcode_type')||'AUTO'):'INTERNAL';
L1489 |   const deterministic='CFI-'+String(checksum||'IMPORT').replace(/[^A-F0-9]/gi,'').slice(-12).toUpperCase().padStart(12,'0')+'-'+String(rowNumber).padStart(7,'0');
L1490 |   if(!sku)sku=deterministic;
L1491 |   if(!itemKind)itemKind=unitClass==='mass'?'WEIGHED':(barcode?'BARCODED':'NO_BARCODE');
L1492 |   if(!['BARCODED','WEIGHED','NO_BARCODE'].includes(itemKind))throw new Error('نوع الصنف غير مدعوم.');
L1493 |   if(itemKind==='WEIGHED'&&unitClass!=='mass'&&!allowMissingBaseUnit)throw new Error('الصنف الوزني يجب أن يستخدم فئة قياس الوزن.');
L1494 |   if(itemKind==='BARCODED'&&(!barcode||barcodeType==='INTERNAL')&&!allowMissingBaseUnit)throw new Error('الصنف المحدد كصنف بباركود يحتاج باركوداً خارجياً صالحاً.');
L1495 |   if(itemKind==='NO_BARCODE'&&barcode&&barcodeType!=='INTERNAL')throw new Error('الصنف بدون باركود لا يقبل رمزاً خارجياً.');
L1496 |   const parsedUnits=cfParseUnitRows(value('units'));
L1497 |   if(!Array.isArray(parsedUnits)||parsedUnits.length>50)throw new Error('عدد الوحدات البديلة يجب ألا يتجاوز 50 وحدة.');
L1498 |   const seenNames=new Set(),seenCodes=new Set();if(barcode)seenCodes.add(barcode.toLocaleLowerCase());
L1499 |   const units=parsedUnits.map(entry=>{
L1500 |    if(!entry||typeof entry!=='object'||Array.isArray(entry))throw new Error('صيغة إحدى الوحدات البديلة غير صحيحة.');
L1501 |    const unitName=String(entry.name??'').trim(),factor=Number(entry.factor_to_base??entry.conversion_factor??entry.factor);
L1502 |    if(!unitName||unitName.length>40)throw new Error('اسم الوحدة البديلة مطلوب ولا يتجاوز 40 حرفاً.');
L1503 |    const key=normalizeUnitName(unitName);
L1504 |    if(key===normalizeUnitName(baseUnit)||seenNames.has(key))throw new Error('الوحدة البديلة مكررة أو تطابق وحدة الأساس.');
L1505 |    if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل تحويل الوحدة البديلة غير صالح.');
L1506 |    const unit={name:unitName,factor_to_base:factor},unitBarcode=String(entry.barcode??'').trim();
L1507 |    if(unitBarcode){
L1508 |     if(unitBarcode.length>120)throw new Error('باركود الوحدة البديلة أطول من الحد المسموح.');
L1509 |     const codeKey=unitBarcode.toLocaleLowerCase();
L1510 |     if(seenCodes.has(codeKey))throw new Error('باركود الصنف أو إحدى وحداته مكرر.');
L1511 |     seenCodes.add(codeKey);unit.barcode=unitBarcode;unit.barcode_type=cfResolveBarcodeType(unitBarcode,entry.barcode_type||'AUTO');
L1512 |    }
L1513 |    seenNames.add(key);return unit;
L1514 |   });
L1515 |   const brand=value('brand'),category=value('category');
L1516 |   if(brand.length>120)throw new Error('اسم العلامة التجارية يتجاوز 120 حرفاً.');
L1517 |   if(category.length>120)throw new Error('اسم التصنيف يتجاوز 120 حرفاً.');
L1518 |   return {_row_number:rowNumber,canonical_sku:sku,barcode:barcode||null,name,brand:brand||null,category:category||null,base_unit:baseUnit,units:withProductUnitMeta(units,unitClass,decimalPrecision,{item_kind:itemKind,barcode_type:barcodeType})};
L1519 |  }
```

### renderGlobalCatalogImportErrors() — lines 1520-1523

```javascript
L1520 | function renderGlobalCatalogImportErrors(){
L1521 |   const errors=state.globalCatalogImport?.stats?.errors||[];
L1522 |   $('globalCatalogImportErrors').innerHTML=errors.length?'<table><thead><tr><th>صف المصدر</th><th>SKU</th><th>الباركود</th><th>سبب الرفض</th></tr></thead><tbody>'+errors.map(e=>'<tr><td>'+Number(e.row_number||0)+'</td><td>'+esc(e.sku||'')+'</td><td>'+esc(e.barcode||'')+'</td><td>'+esc(e.error||'تعذر قبول الصف')+'</td></tr>').join('')+'</tbody></table>':'';
L1523 |  }
```

### catalogImportIdentityKeys() — lines 1524-1531

```javascript
L1524 | function catalogImportIdentityKeys(row){
L1525 |  const keys=[],add=(kind,value)=>{const normalized=String(value||'').trim().toLocaleLowerCase();if(normalized)keys.push(kind+':'+normalized);};
L1526 |  add('sku',row?.canonical_sku);add('sku',row?.sku);add('client-sku',row?.client_sku);
L1527 |  add('barcode',row?.barcode);add('barcode',row?.client_barcode);add('client-sku',row?.client_sku);
L1528 |  for(const unit of Array.isArray(row?.units)?row.units:[])add('barcode',unit?.barcode);
L1529 |  for(const unit of [...(Array.isArray(row?.client_units)?row.client_units:[]),...(Array.isArray(row?.client_units_override)?row.client_units_override:[])])add('barcode',unit?.barcode);
L1530 |  return [...new Set(keys)];
L1531 | }
```

### reserveCatalogImportIdentities() — lines 1532-1536

```javascript
L1532 | function reserveCatalogImportIdentities(row,seen){
L1533 |  const keys=catalogImportIdentityKeys(row);
L1534 |  if(keys.some(key=>seen.has(key)))return false;
L1535 |  keys.forEach(key=>seen.add(key));return true;
L1536 | }
```

### updateGlobalCatalogImportProgress() — lines 1537-1542

```javascript
L1537 | function updateGlobalCatalogImportProgress(){
L1538 |   const g=state.globalCatalogImport,stats=g.stats||{},total=Math.max(0,Number(g.count||0)),processed=Math.min(total,Number(stats.processed||0)),percent=total?Math.min(100,Math.round(processed/total*100)):0;
L1539 |   $('globalCatalogImportProgressFill').style.width=percent+'%';
L1540 |   $('globalCatalogImportProgress').textContent='المعالجة '+processed.toLocaleString('en-US')+' / '+total.toLocaleString('en-US')+' · أضيف '+Number(stats.inserted||0).toLocaleString('en-US')+' · حُدث '+Number(stats.updated||0).toLocaleString('en-US')+' · مكرر متجاهل '+Number(stats.duplicates||0).toLocaleString('en-US')+' · رُفض '+Number(stats.rejected||0).toLocaleString('en-US');
L1541 |   renderGlobalCatalogImportErrors();
L1542 |  }
```

### commitGlobalCatalogChunk() — lines 1543-1555

```javascript
L1543 | async function commitGlobalCatalogChunk(rows){
L1544 |   if(!rows.length)return;
L1545 |   const {data,error}=await db.rpc('count_upsert_catalog_products_chunk',{p_rows:rows});
L1546 |   if(error)throw error;
L1547 |   if(!data||typeof data!=='object')throw new Error('استجابة RPC لاستيراد الدليل غير صالحة.');
L1548 |   const stats=state.globalCatalogImport.stats;
L1549 |   stats.processed+=rows.length;stats.inserted+=Number(data.inserted||0);stats.updated+=Number(data.updated||0);stats.rejected+=Number(data.rejected||0);
L1550 |   for(const item of (Array.isArray(data.errors)?data.errors:[])){
L1551 |    if(stats.errors.length>=120)break;
L1552 |    stats.errors.push({row_number:item.row_number,sku:item.sku,barcode:item.barcode,error:item.error||'رفض الخادم الصف'});
L1553 |   }
L1554 |   updateGlobalCatalogImportProgress();
L1555 |  }
```

### commitGlobalCatalogImport() — lines 1556-1637

```javascript
L1556 | async function commitGlobalCatalogImport(){
L1557 |   if(!state.platformOwner)return notify('استيراد الدليل العالمي متاح لمالك المنصة فقط.',true);
L1558 |   const g=state.globalCatalogImport,file=$('globalCatalogImportFile').files?.[0];
L1559 |   if(g.busy)return;
L1560 |   if(!g.file||!file||file!==g.file)return notify('الملف الحالي تغير؛ أعد معاينته قبل الاستيراد.',true);
L1561 |   if(!g.mapping?.name||!g.mapping?.base_unit)return notify('اربط عمود اسم الصنف ووحدة الأساس أولاً.',true);
L1562 |   if(g.count<1||g.count>90000)return notify('عدد الصفوف خارج الحد التشغيلي 1–90,000.',true);
L1563 |   g.busy=true;g.stats={processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]};
L1564 |   const controls=['globalCatalogImportPreview','globalCatalogImportCommit','globalCatalogImportReset'];
L1565 |   controls.forEach(id=>$(id).disabled=true);
L1566 |   $('globalCatalogImportFile').disabled=true;
L1567 |   $('globalCatalogImportProgress').textContent='جار حساب بصمة الملف وتجهيز الاستيراد…';
L1568 |   $('globalCatalogImportErrors').innerHTML='';
L1569 |   let pending=[],rowIndex=0,parseErrors=0;const seenIdentities=new Set();
L1570 |   const recordLocalError=(row,rowNumber,error)=>{
L1571 |    const stats=state.globalCatalogImport.stats;stats.processed++;stats.rejected++;
L1572 |    if(stats.errors.length<120)stats.errors.push({row_number:rowNumber,sku:String(globalCatalogImportValue(row,'sku')||''),barcode:String(globalCatalogImportValue(row,'barcode')||''),error:error?.message||String(error)});
L1573 |    updateGlobalCatalogImportProgress();
L1574 |   };
L1575 |   const acceptRow=(row,sourceRowNumber)=>{
L1576 |    try{
L1577 |     const normalized=normalizeGlobalCatalogImportRow(row,rowIndex,sourceRowNumber,g.checksum);
L1578 |     if(!reserveCatalogImportIdentities(normalized,seenIdentities)){
L1579 |      const stats=state.globalCatalogImport.stats;stats.processed++;stats.duplicates++;updateGlobalCatalogImportProgress();
L1580 |     }else pending.push(normalized);
L1581 |    }catch(error){recordLocalError(row,sourceRowNumber,error);}
L1582 |    rowIndex++;
L1583 |   };
L1584 |   const flush=async()=>{if(!pending.length)return;const rows=pending;pending=[];await commitGlobalCatalogChunk(rows);};
L1585 |   try{
L1586 |    g.checksum=await hashFileInChunks(file);
L1587 |    if(g.sourceFormat==='csv'){
L1588 |     await new Promise((resolve,reject)=>{
L1589 |      let chain=Promise.resolve(),sourceRowNumber=2,settled=false;
L1590 |      const failParse=error=>{if(settled)return;settled=true;reject(error);};
L1591 |      Papa.parse(file,{header:true,skipEmptyLines:'greedy',dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L1592 |       step:(result,parser)=>{
L1593 |        const rowNumber=sourceRowNumber++;
L1594 |        if(result.errors?.length){parseErrors+=result.errors.length;recordLocalError(result.data||{},rowNumber,new Error('تعذر تحليل صف CSV: '+result.errors.map(x=>x.message).join('، ')));return;}
L1595 |        const row=result.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;
L1596 |        acceptRow(row,rowNumber);
L1597 |        if(pending.length>=500){
L1598 |         parser.pause();const chunk=pending;pending=[];
L1599 |         chain=chain.then(()=>commitGlobalCatalogChunk(chunk)).then(()=>parser.resume()).catch(error=>{parser.abort();failParse(error);});
L1600 |        }
L1601 |       },
L1602 |       complete:async()=>{
L1603 |        if(settled)return;
L1604 |        try{await chain;await flush();if(!rowIndex&&!state.globalCatalogImport.stats.rejected)throw new Error('لم يتم العثور على صفوف بيانات قابلة للقراءة.');settled=true;resolve();}
L1605 |        catch(error){failParse(error);}
L1606 |       },error:failParse});
L1607 |     });
L1608 |    }else if(g.sourceFormat==='xlsx'){
L1609 |     const parsed=await streamXlsxProductRows(file,async row=>{
L1610 |      const rowNumber=Number(row.__countflowRowNumber||rowIndex+2);
L1611 |      acceptRow(row,rowNumber);
L1612 |      if(pending.length>=500)await flush();
L1613 |     });
L1614 |     if(parsed.count!==g.count)throw new Error('تغير عدد صفوف XLSX بعد المعاينة. أعد معاينة الملف قبل الاستيراد.');
L1615 |     await flush();
L1616 |    }else{
L1617 |     const parsed=await parseProductImportFile(file),rows=parsed.rows||[];
L1618 |     if(parsed.count!==g.count||!rows.length)throw new Error('تعذر إعادة قراءة ملف XLS؛ أعد المعاينة.');
L1619 |     for(let i=0;i<rows.length;i++){acceptRow(rows[i],i+2);if(pending.length>=500)await flush();}
L1620 |     await flush();
L1621 |    }
L1622 |    if(rowIndex>g.count)throw new Error('عدد الصفوف أثناء الاستيراد تجاوز العدد الذي تمت معاينته.');
L1623 |    const stats=g.stats;
L1624 |    $('globalCatalogImportProgressFill').style.width='100%';
L1625 |    $('globalCatalogImportProgress').textContent='اكتمل فحص الملف · صفوف '+rowIndex.toLocaleString('en-US')+' · أضيف '+stats.inserted.toLocaleString('en-US')+' · حُدث '+stats.updated.toLocaleString('en-US')+' · مكرر متجاهل '+Number(stats.duplicates||0).toLocaleString('en-US')+' · رُفض '+stats.rejected.toLocaleString('en-US')+(parseErrors?' · أخطاء تحليل '+parseErrors:'');
L1626 |    renderGlobalCatalogImportErrors();
L1627 |    notify('اكتمل استيراد الدليل العالمي. الأرصدة وحركات الجرد لم تتغير.');
L1628 |    try{await loadCatalog();}catch(refreshError){fail('اكتمل الاستيراد لكن تعذر تحديث عرض الدليل',refreshError);}
L1629 |   }catch(error){
L1630 |    $('globalCatalogImportProgress').textContent='توقف الاستيراد عند '+Number(g.stats.processed||0).toLocaleString('en-US')+' صف. الدفعات التي قُبلت محفوظة؛ أعد تشغيل الملف نفسه لاستكمال/تحديث السجلات بأمان. '+friendlyErrorMessage(error);
L1631 |    fail('تعذر استكمال استيراد الدليل العالمي',error);
L1632 |   }finally{
L1633 |    g.busy=false;$('globalCatalogImportFile').disabled=false;
L1634 |    controls.forEach(id=>$(id).disabled=false);
L1635 |    $('globalCatalogImportCommit').disabled=!g.count||!g.mapping?.name||!g.mapping?.base_unit;
L1636 |   }
L1637 |  }
```

### clientCatalogImportValue() — lines 1657-1659

```javascript
L1657 | function clientCatalogImportValue(row,key,mapping=state.clientCatalogImport.mapping){
L1658 |  const header=mapping?.[key];return header&&Object.prototype.hasOwnProperty.call(row,header)?row[header]:'';
L1659 | }
```

### renderClientCatalogImportMapping() — lines 1660-1677

```javascript
L1660 | function renderClientCatalogImportMapping(){
L1661 |  const g=state.clientCatalogImport,host=$('clientCatalogImportMapping'),headers=g.headers||[];
L1662 |  if(!headers.length)throw new Error('لم يتم العثور على عناوين أعمدة في ملف المؤسسة.');
L1663 |  g.mapping=g.mapping||{};
L1664 |  for(const field of clientCatalogImportFields){
L1665 |   if(!Object.prototype.hasOwnProperty.call(g.mapping,field.key)){
L1666 |    const aliases=field.aliases.map(x=>String(x).trim().toLocaleLowerCase());
L1667 |    g.mapping[field.key]=headers.find(h=>aliases.includes(String(h).trim().toLocaleLowerCase()))||'';
L1668 |   }
L1669 |  }
L1670 |  host.classList.remove('hidden');
L1671 |  host.innerHTML='<div class="panel" style="box-shadow:none;margin:0;padding:12px"><b>مطابقة أعمدة ملف المؤسسة</b><p class="hint">اسم الصنف ومعرّف SKU أو باركود مطلوب. وحدة الأساس مطلوبة فقط عند إنشاء صنف عالمي جديد؛ الصنف الموجود يمكن ربطه دون إعادة إدخال وحدة الأساس. الاختلافات الخاصة بالمؤسسة تحفظ كحقول محلية ولا تُستبدل البيانات العالمية.</p><div class="fields">'+clientCatalogImportFields.map(f=>'<div class="field"><label>'+esc(f.label)+'</label><select data-client-catalog-import-map="'+f.key+'"><option value="">— تجاهل الحقل —</option>'+headers.map(h=>'<option value="'+esc(h)+'" '+(g.mapping[f.key]===h?'selected':'')+'>'+esc(h)+'</option>').join('')+'</select></div>').join('')+'</div></div>';
L1672 |  host.querySelectorAll('[data-client-catalog-import-map]').forEach(select=>select.onchange=()=>{
L1673 |   g.mapping[select.dataset.clientCatalogImportMap]=select.value;
L1674 |   $('clientCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||(!g.mapping.sku&&!g.mapping.barcode&&!g.mapping.client_sku&&!g.mapping.client_barcode);
L1675 |  });
L1676 |  $('clientCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||(!g.mapping.sku&&!g.mapping.barcode&&!g.mapping.client_sku&&!g.mapping.client_barcode);
L1677 | }
```

### renderClientCatalogImportPreview() — lines 1678-1682

```javascript
L1678 | function renderClientCatalogImportPreview(){
L1679 |  const g=state.clientCatalogImport,headers=g.headers||[],rows=(g.sample||[]).slice(0,8);
L1680 |  const sample=rows.length?'<div class="tablewrap"><table><thead><tr>'+headers.slice(0,8).map(h=>'<th>'+esc(h)+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+headers.slice(0,8).map(h=>'<td>'+esc(String(r[h]??'').slice(0,80))+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>':'';
L1681 |  $('clientCatalogImportPreviewText').innerHTML='<b>معاينة الملف: '+Number(g.count||0).toLocaleString('en-US')+' صف</b><span class="sub"> أول 8 صفوف · '+headers.length+' عمود</span>'+sample;
L1682 | }
```

### renderClientCatalogImportErrors() — lines 1683-1686

```javascript
L1683 | function renderClientCatalogImportErrors(){
L1684 |  const errors=state.clientCatalogImport?.stats?.errors||[];
L1685 |  $('clientCatalogImportErrors').innerHTML=errors.length?'<table><thead><tr><th>صف الملف</th><th>SKU</th><th>الباركود</th><th>سبب الرفض</th></tr></thead><tbody>'+errors.map(e=>'<tr><td>'+Number(e.row_number||0)+'</td><td>'+esc(e.sku||'')+'</td><td>'+esc(e.barcode||'')+'</td><td>'+esc(e.error||'تعذر قبول الصف')+'</td></tr>').join('')+'</tbody></table>':'';
L1686 | }
```

### updateClientCatalogImportProgress() — lines 1687-1692

```javascript
L1687 | function updateClientCatalogImportProgress(){
L1688 |  const g=state.clientCatalogImport,stats=g.stats||{},total=Math.max(0,Number(g.count||0)),processed=Math.min(total,Number(stats.processed||0)),percent=total?Math.min(100,Math.round(processed/total*100)):0;
L1689 |  $('clientCatalogImportProgressFill').style.width=percent+'%';
L1690 |  $('clientCatalogImportProgress').textContent='المعالجة '+processed.toLocaleString('en-US')+' / '+total.toLocaleString('en-US')+' · أصناف عالمية جديدة '+Number(stats.catalogInserted||0).toLocaleString('en-US')+' · مطابقة مع الدليل '+Number(stats.catalogMatched||0).toLocaleString('en-US')+' · ربط جديد '+Number(stats.clientInserted||0).toLocaleString('en-US')+' · مواءمات محدثة '+Number(stats.clientUpdated||0).toLocaleString('en-US')+' · مكرر متجاهل '+Number(stats.duplicates||0).toLocaleString('en-US')+' · مرفوض '+Number(stats.rejected||0).toLocaleString('en-US');
L1691 |  renderClientCatalogImportErrors();
L1692 | }
```

### normalizeClientCatalogImportRow() — lines 1693-1732

```javascript
L1693 | function normalizeClientCatalogImportRow(row,index,sourceRowNumber,checksum,mapping){
L1694 |  const value=key=>String(globalCatalogImportValue(row,key,mapping)??'').trim();
L1695 |  const source=normalizeGlobalCatalogImportRow(row,index,sourceRowNumber,checksum,mapping,true);
L1696 |  // Global-import normalizer generates a deterministic CFI SKU when its SKU column is blank.
L1697 |  // Client import must not mistake that internal fallback for an institution SKU when a
L1698 |  // matching global product is resolved by barcode or by an existing client identifier.
L1699 |  if(!value('sku'))source.canonical_sku=null;
L1700 |  if(!value('barcode'))source.barcode=null;
L1701 |  if(!source.base_unit&&value('units'))throw new Error('وحدة الأساس مطلوبة للتحقق من معاملات الوحدات البديلة.');
L1702 |  const localSku=value('client_sku')||null,localBarcode=value('client_barcode')||null;
L1703 |  if(!value('sku')&&!value('barcode')&&!localSku&&!localBarcode)throw new Error('لا يمكن منع تكرار هذا الصف دون SKU أو باركود عالمي أو محلي؛ أضف المعرّف قبل الاستيراد.');
L1704 |  const localName=value('client_name_override')||null,localCategory=value('client_category_override')||null;
L1705 |  const localBase=value('client_base_unit_override')||null,localUnitsText=value('client_units_override');
L1706 |  if(localSku&&localSku.length>100)throw new Error('SKU المؤسسة يتجاوز 100 حرف.');
L1707 |  if(localBarcode){if(localBarcode.length>120)throw new Error('باركود المؤسسة يتجاوز 120 حرفاً.');cfResolveBarcodeType(localBarcode,'AUTO');}
L1708 |  if(localName&&localName.length>240)throw new Error('اسم المؤسسة يتجاوز 240 حرفاً.');
L1709 |  if(localCategory&&localCategory.length>120)throw new Error('تصنيف المؤسسة يتجاوز 120 حرفاً.');
L1710 |  if(localBase&&localBase.length>40)throw new Error('وحدة الأساس المحلية تتجاوز 40 حرفاً.');
L1711 |  const output={...source,client_sku:localSku,client_barcode:localBarcode,client_name_override:localName,client_category_override:localCategory};
L1712 |  if(localBase)output.client_base_unit_override=localBase;
L1713 |  if(localUnitsText){
L1714 |   const rows=cfParseUnitRows(localUnitsText);
L1715 |   if(!Array.isArray(rows)||rows.length>50)throw new Error('عدد وحدات المؤسسة البديلة يجب ألا يتجاوز 50 وحدة.');
L1716 |   const base=localBase||source.base_unit,unitClass=inferProductUnitClass(base),meta=readProductUnitMeta(source.units,source.base_unit);
L1717 |   const seenNames=new Set(),seenCodes=new Set();if(localBarcode)seenCodes.add(localBarcode.toLocaleLowerCase());
L1718 |   const normalized=rows.map(entry=>{
L1719 |    if(!entry||typeof entry!=='object'||Array.isArray(entry))throw new Error('صيغة إحدى وحدات المؤسسة غير صحيحة.');
L1720 |    const name=String(entry.name??'').trim(),factor=Number(entry.factor_to_base??entry.conversion_factor??entry.factor);
L1721 |    if(!name||name.length>40)throw new Error('اسم وحدة المؤسسة مطلوب ولا يتجاوز 40 حرفاً.');
L1722 |    const key=normalizeUnitName(name);
L1723 |    if(key===normalizeUnitName(base)||seenNames.has(key))throw new Error('وحدة المؤسسة مكررة أو تطابق وحدة الأساس.');
L1724 |    if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل تحويل وحدة المؤسسة غير صالح.');
L1725 |    const unit={name,factor_to_base:factor},barcode=String(entry.barcode??'').trim();
L1726 |    if(barcode){if(barcode.length>120)throw new Error('باركود وحدة المؤسسة أطول من الحد.');const code=barcode.toLocaleLowerCase();if(seenCodes.has(code))throw new Error('باركود الصنف أو وحداته المحلية مكرر.');seenCodes.add(code);unit.barcode=barcode;unit.barcode_type=cfResolveBarcodeType(barcode,entry.barcode_type||'AUTO');}
L1727 |    seenNames.add(key);return unit;
L1728 |   });
L1729 |   output.client_units_override=withProductUnitMeta(normalized,unitClass,meta.decimal_precision??defaultProductUnitPrecision(unitClass),{item_kind:localBarcode?'BARCODED':meta.item_kind||'NO_BARCODE',barcode_type:localBarcode?cfResolveBarcodeType(localBarcode,'AUTO'):meta.barcode_type||'INTERNAL'});
L1730 |  }else if(localBase)output.client_units_override=[];
L1731 |  return output;
L1732 | }
```

### commitClientCatalogChunk() — lines 1733-1751

```javascript
L1733 | async function commitClientCatalogChunk(rows,clientId){
L1734 |  if(!rows.length)return;
L1735 |  const {data,error}=await db.rpc('count_upsert_client_catalog_chunk',{p_client_id:clientId,p_rows:rows});
L1736 |  if(error)throw error;
L1737 |  if(!data||typeof data!=='object')throw new Error('استجابة ربط أصناف المؤسسة غير صالحة.');
L1738 |  const stats=state.clientCatalogImport.stats;
L1739 |  stats.processed+=rows.length;
L1740 |  stats.catalogInserted+=Number(data.catalog_inserted||0);
L1741 |  stats.catalogMatched+=Number(data.catalog_matched||0);
L1742 |  stats.clientInserted+=Number(data.client_inserted||0);
L1743 |  stats.clientUpdated+=Number(data.client_updated||0);
L1744 |  stats.duplicates+=Number(data.duplicates||0);
L1745 |  stats.rejected+=Number(data.rejected||0);
L1746 |  for(const item of Array.isArray(data.errors)?data.errors:[]){
L1747 |   if(stats.errors.length>=120)break;
L1748 |   stats.errors.push({row_number:item.row_number,sku:item.sku,barcode:item.barcode,error:item.error||'رفض الخادم الصف'});
L1749 |  }
L1750 |  updateClientCatalogImportProgress();
L1751 | }
```

### resetClientCatalogImport() — lines 1752-1759

```javascript
L1752 | function resetClientCatalogImport(){
L1753 |  const g=state.clientCatalogImport;if(g?.busy)return notify('لا يمكن إلغاء الملف أثناء تنفيذ دفعة؛ انتظر اكتمال الاستدعاء الحالي.',true);
L1754 |  state.clientCatalogImport={file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}};
L1755 |  $('clientCatalogImportFile').value='';$('clientCatalogImportMapping').classList.add('hidden');$('clientCatalogImportMapping').innerHTML='';
L1756 |  $('clientCatalogImportPreviewText').textContent='';$('clientCatalogImportProgress').textContent='لم يبدأ الاستيراد';
L1757 |  $('clientCatalogImportProgressFill').style.width='0%';$('clientCatalogImportErrors').innerHTML='';$('clientCatalogImportSummary').innerHTML='';
L1758 |  $('clientCatalogImportPreview').disabled=false;$('clientCatalogImportCommit').disabled=true;$('clientCatalogImportReset').disabled=false;
L1759 | }
```

### previewClientCatalogImport() — lines 1760-1784

```javascript
L1760 | async function previewClientCatalogImport(){
L1761 |  if(!state.platformOwner)return notify('استيراد أصناف المؤسسة متاح لمالك المنصة فقط.',true);
L1762 |  const client=state.clients.find(item=>item.id===state.catalogClientId&&item.status==='active');
L1763 |  if(!client)return notify('اختر مؤسسة نشطة أولاً من محدد المؤسسة أعلى دليل الأصناف.',true);
L1764 |  const file=$('clientCatalogImportFile').files?.[0];if(!file)return notify('اختر ملف أصناف المؤسسة أولاً.',true);
L1765 |  if(state.clientCatalogImport?.busy)return;
L1766 |  const preview=$('clientCatalogImportPreview'),commit=$('clientCatalogImportCommit'),reset=$('clientCatalogImportReset');
L1767 |  preview.disabled=true;commit.disabled=true;reset.disabled=true;
L1768 |  $('clientCatalogImportTarget').textContent='وجهة الاستيراد: '+client.name+' · '+client.code+'. لن تُنقل أصناف التكليف أو الأرصدة المرجعية.';
L1769 |  $('clientCatalogImportProgress').textContent='جار فحص الملف وقراءة عينة من الصفوف…';$('clientCatalogImportErrors').innerHTML='';
L1770 |  try{
L1771 |   const parsed=await parseProductImportFile(file),ext=(file.name.split('.').pop()||'').toLowerCase();
L1772 |   if(!parsed.count)throw new Error('لا توجد صفوف بيانات قابلة للقراءة.');
L1773 |   if(parsed.count>90000)throw new Error('الحد الأقصى لملف المؤسسة 90,000 صف.');
L1774 |   if(!['csv','xlsx'].includes(ext))throw new Error('يدعم الاستيراد CSV وXLSX فقط.');
L1775 |   state.clientCatalogImport={file,clientId:client.id,count:parsed.count,headers:parsed.headers||Object.keys((parsed.sample||parsed.rows||[])[0]||{}),sample:parsed.sample||parsed.rows||[],mapping:{},busy:false,checksum:'',sourceFormat:ext,stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}};
L1776 |   renderClientCatalogImportMapping();renderClientCatalogImportPreview();
L1777 |   $('clientCatalogImportProgress').textContent=(parsed.streaming?'تمت معاينة الملف بالقراءة المتدفقة. ':'تمت قراءة الملف. ')+parsed.count.toLocaleString('en-US')+' صف؛ راجع مطابقة الأعمدة قبل التنفيذ.';
L1778 |  }catch(error){
L1779 |   resetClientCatalogImport();$('clientCatalogImportProgress').textContent='تعذرت معاينة الملف: '+friendlyErrorMessage(error);fail('تعذرت معاينة ملف المؤسسة',error);
L1780 |  }finally{
L1781 |   preview.disabled=false;reset.disabled=false;
L1782 |   commit.disabled=!state.clientCatalogImport.count||!state.clientCatalogImport.mapping?.name||(!state.clientCatalogImport.mapping?.sku&&!state.clientCatalogImport.mapping?.barcode&&!state.clientCatalogImport.mapping?.client_sku&&!state.clientCatalogImport.mapping?.client_barcode);
L1783 |  }
L1784 | }
```

### commitClientCatalogImport() — lines 1785-1855

```javascript
L1785 | async function commitClientCatalogImport(){
L1786 |  if(!state.platformOwner)return notify('استيراد أصناف المؤسسة متاح لمالك المنصة فقط.',true);
L1787 |  const g=state.clientCatalogImport,file=$('clientCatalogImportFile').files?.[0],client=state.clients.find(item=>item.id===state.catalogClientId&&item.status==='active');
L1788 |  if(g.busy)return;
L1789 |  if(!client||g.clientId!==client.id)return notify('تغيرت المؤسسة المحددة. أعد معاينة الملف على المؤسسة الجديدة.',true);
L1790 |  if(!g.file||!file||file!==g.file)return notify('الملف الحالي تغير؛ أعد معاينته قبل الاستيراد.',true);
L1791 |  if(!g.mapping?.name)return notify('اربط عمود اسم الصنف أولاً.',true);if(!g.mapping.sku&&!g.mapping.barcode&&!g.mapping.client_sku&&!g.mapping.client_barcode)return notify('اربط عمود SKU أو باركود عالمي أو محلي حتى يمكن منع التكرار.',true);
L1792 |  if(g.count<1||g.count>90000)return notify('عدد الصفوف خارج الحد التشغيلي 1–90,000.',true);
L1793 |  g.busy=true;g.stats={processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]};
L1794 |  const controls=['clientCatalogImportPreview','clientCatalogImportCommit','clientCatalogImportReset'];controls.forEach(id=>$(id).disabled=true);
L1795 |  $('clientCatalogImportFile').disabled=true;$('clientCatalogImportErrors').innerHTML='';
L1796 |  $('clientCatalogImportProgress').textContent='جار حساب بصمة الملف وتجهيز دفعات المؤسسة…';
L1797 |  let pending=[],rowIndex=0,parseErrors=0;const seenIdentities=new Set();
L1798 |  const recordError=(row,rowNumber,error)=>{
L1799 |   const stats=state.clientCatalogImport.stats;stats.processed++;stats.rejected++;
L1800 |   if(stats.errors.length<120)stats.errors.push({row_number:rowNumber,sku:String(globalCatalogImportValue(row,'sku',g.mapping)||''),barcode:String(globalCatalogImportValue(row,'barcode',g.mapping)||''),error:error?.message||String(error)});
L1801 |   updateClientCatalogImportProgress();
L1802 |  };
L1803 |  const acceptRow=(row,rowNumber)=>{
L1804 |   try{
L1805 |    const normalized=normalizeClientCatalogImportRow(row,rowIndex,rowNumber,g.checksum,g.mapping);
L1806 |    if(!reserveCatalogImportIdentities(normalized,seenIdentities)){
L1807 |     const stats=state.clientCatalogImport.stats;stats.processed++;stats.duplicates++;updateClientCatalogImportProgress();
L1808 |    }else pending.push(normalized);
L1809 |   }catch(error){recordError(row,rowNumber,error);}
L1810 |   rowIndex++;
L1811 |  };
L1812 |  const flush=async()=>{if(!pending.length)return;const chunk=pending;pending=[];await commitClientCatalogChunk(chunk,client.id);};
L1813 |  try{
L1814 |   g.checksum=await hashFileInChunks(file);
L1815 |   if(g.sourceFormat==='csv'){
L1816 |    await new Promise((resolve,reject)=>{
L1817 |     let chain=Promise.resolve(),sourceRow=2,settled=false;
L1818 |     const failParse=error=>{if(settled)return;settled=true;reject(error);};
L1819 |     Papa.parse(file,{header:true,skipEmptyLines:'greedy',dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L1820 |      step:(result,parser)=>{
L1821 |       const current=sourceRow++;
L1822 |       if(result.errors?.length){parseErrors+=result.errors.length;recordError(result.data||{},current,new Error('تعذر تحليل صف CSV: '+result.errors.map(x=>x.message).join('، ')));return;}
L1823 |       const row=result.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;
L1824 |       acceptRow(row,current);
L1825 |       if(pending.length>=500){parser.pause();const chunk=pending;pending=[];chain=chain.then(()=>commitClientCatalogChunk(chunk,client.id)).then(()=>parser.resume()).catch(error=>{parser.abort();failParse(error);});}
L1826 |      },
L1827 |      complete:async()=>{if(settled)return;try{await chain;await flush();if(!rowIndex&&!state.clientCatalogImport.stats.rejected)throw new Error('لم يتم العثور على صفوف بيانات قابلة للقراءة.');settled=true;resolve();}catch(error){failParse(error);}},
L1828 |      error:failParse
L1829 |     });
L1830 |    });
L1831 |   }else{
L1832 |    const parsed=await streamXlsxProductRows(file,async row=>{
L1833 |     const number=Number(row.__countflowRowNumber||rowIndex+2);acceptRow(row,number);if(pending.length>=500)await flush();
L1834 |    });
L1835 |    if(parsed.count!==g.count)throw new Error('تغير عدد صفوف XLSX بعد المعاينة؛ أعد معاينة الملف.');await flush();
L1836 |   }
L1837 |   if(rowIndex>g.count)throw new Error('عدد صفوف الاستيراد تجاوز العدد الذي تمت معاينته.');
L1838 |   const s=g.stats;
L1839 |   $('clientCatalogImportProgressFill').style.width='100%';
L1840 |   $('clientCatalogImportProgress').textContent='اكتمل الاستيراد بعد معالجة '+s.processed.toLocaleString('en-US')+' صف.';
L1841 |   $('clientCatalogImportSummary').innerHTML=[
L1842 |    ['أصناف عالمية جديدة',s.catalogInserted],['أصناف موجودة تم التعرف عليها',s.catalogMatched],
L1843 |    ['مواءمات مؤسسة جديدة',s.clientInserted],['مواءمات محدثة',s.clientUpdated],
L1844 |    ['صفوف مكررة تم تجاهلها',s.duplicates],['صفوف مرفوضة',s.rejected]
L1845 |   ].map(([label,value])=>'<span>'+label+'<b>'+Number(value||0).toLocaleString('en-US')+'</b></span>').join('');
L1846 |   renderClientCatalogImportErrors();notify('اكتمل استيراد وربط أصناف مؤسسة '+client.name+'. لم تُنشأ أرصدة أو حركات جرد.');
L1847 |   state.catalogPage=1;await loadCatalog();
L1848 |  }catch(error){
L1849 |   $('clientCatalogImportProgress').textContent='توقف الاستيراد عند '+Number(g.stats.processed||0).toLocaleString('en-US')+' صف. الدفعات الناجحة محفوظة، ويمكن إعادة تشغيل الملف نفسه بصورة آمنة. '+friendlyErrorMessage(error);
L1850 |   fail('تعذر استكمال استيراد أصناف المؤسسة',error);
L1851 |  }finally{
L1852 |   g.busy=false;$('clientCatalogImportFile').disabled=false;controls.forEach(id=>$(id).disabled=false);
L1853 |   $('clientCatalogImportCommit').disabled=!g.count||!g.mapping?.name||(!g.mapping?.sku&&!g.mapping?.barcode&&!g.mapping?.client_sku&&!g.mapping?.client_barcode);
L1854 |  }
L1855 | }
```

### resetProductImport() — lines 1856-1861

```javascript
L1856 | function resetProductImport(){
L1857 |   state.productImportRows=[];state.productImportRowCount=0;state.productImportHeaders=[];state.productImportMapping={};state.productImportMappingId=null;state.productImportFileName='';
L1858 |   $('productImportFile').value='';$('productImportMapping').classList.add('hidden');$('productImportMapping').innerHTML='';
L1859 |   $('productImportPreview').textContent='';$('productImportResult').textContent='';$('productImportCommitBtn').disabled=true;
L1860 |   $('productImportDetails').innerHTML='';
L1861 |  }
```

### renderProductImportMapping() — lines 1862-1872

```javascript
L1862 | async function renderProductImportMapping(){
L1863 |   const headers=Object.keys(state.productImportRows[0]||{});if(!headers.length)throw new Error('لم يتم العثور على عناوين أعمدة في الصف الأول.');
L1864 |   const {data:saved,error}=await db.from('count_import_mappings').select('id,name,column_mapping,is_default').eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat).eq('is_default',true).order('created_at',{ascending:false}).limit(1).maybeSingle();
L1865 |   if(error)throw error;
L1866 |   state.productImportMappingId=saved?.id||null;state.productImportMapping={};
L1867 |   for(const f of productImportFields){const candidate=saved?.column_mapping?.[f.key];state.productImportMapping[f.key]=headers.includes(candidate)?candidate:guessProductImportHeader(headers,f.key);}
L1868 |   $('productImportMapping').classList.remove('hidden');
L1869 |   $('productImportMapping').innerHTML='<div class="panel" style="box-shadow:none;margin:0;padding:12px"><b>مطابقة أعمدة الملف مع بيانات CountFlow</b><p class="hint">يجب ربط SKU أو الباركود والوحدة الأساسية. لا تُنشئ عمليات الاستيراد وحدات تحويل أو تكلفة غير موجودة في الملف.</p><div class="fields">'+productImportFields.map(f=>'<div class="field"><label>'+f.label+'</label><select data-product-import-map="'+f.key+'"><option value="">— تجاهل الحقل —</option>'+headers.map(h=>'<option value="'+esc(h)+'" '+(state.productImportMapping[f.key]===h?'selected':'')+'>'+esc(h)+'</option>').join('')+'</select></div>').join('')+'</div><div class="actions"><input id="productImportMappingName" placeholder="اسم تخطيط الأعمدة" value="'+esc(saved?.name||'')+'" style="min-width:180px;padding:9px;border:1px solid var(--line);border-radius:10px"><label class="hint"><input id="productImportMappingDefault" type="checkbox" '+(saved?.is_default?'checked':'')+'> جعله التخطيط الافتراضي لهذا النوع من الملفات</label><button type="button" id="saveProductImportMapping" class="soft">حفظ تخطيط الأعمدة</button></div></div>';
L1870 |   $('productImportMapping').querySelectorAll('[data-product-import-map]').forEach(s=>s.onchange=()=>{state.productImportMapping[s.dataset.productImportMap]=s.value;state.productImportMappingId=null;});
L1871 |   $('saveProductImportMapping').onclick=saveProductImportMapping;
L1872 |  }
```

### saveProductImportMapping() — lines 1873-1888

```javascript
L1873 | async function saveProductImportMapping(){
L1874 |   if(!state.project)return notify('اختر تكليفاً أولاً.',true);
L1875 |   const mapping=state.productImportMapping;
L1876 |   if(!mapping.name)return notify('اربط عمود اسم الصنف.',true);
L1877 |   if(!mapping.base_unit)return notify('اربط عمود الوحدة الأساسية.',true);
L1878 |   const name=$('productImportMappingName').value.trim()||('تخطيط '+exportFormatLabel(state.productImportSourceFormat));
L1879 |   const makeDefault=$('productImportMappingDefault').checked;
L1880 |   try{
L1881 |    if(makeDefault){
L1882 |     const {error}=await db.from('count_import_mappings').update({is_default:false}).eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat);
L1883 |     if(error)throw error;
L1884 |    }
L1885 |    const {data,error}=await db.from('count_import_mappings').upsert({project_id:state.project.id,name,source_format:state.productImportSourceFormat,column_mapping:mapping,is_default:makeDefault,created_by:state.user.id},{onConflict:'project_id,name'}).select('id').single();
L1886 |    if(error)throw error;state.productImportMappingId=data.id;notify('تم حفظ تخطيط الأعمدة وإعادة استخدامه لهذا التكليف.');
L1887 |   }catch(err){fail('تعذر حفظ تخطيط الأعمدة',err);}
L1888 |  }
```

### productImportValue() — lines 1889-1892

```javascript
L1889 | function productImportValue(row,key){
L1890 |   const header=state.productImportMapping[key];
L1891 |   return header&&Object.prototype.hasOwnProperty.call(row,header)?row[header]:'';
L1892 |  }
```

### normalizeProductImportRow() — lines 1893-1906

```javascript
L1893 | function normalizeProductImportRow(row,index,sourceRowNumber=null){
L1894 |   const value=key=>String(productImportValue(row,key)??'').trim(),rowNumber=Number(sourceRowNumber||row.__countflowRowNumber||index+2);
L1895 |   let units=cfParseUnitRows(productImportValue(row,'units'));
L1896 |   const baseUnit=value('base_unit'),rawClass=value('unit_class'),rawPrecision=value('decimal_precision');
L1897 |   const unitClass=CF_UNIT_CLASSES.some(x=>x.value===rawClass)?rawClass:inferProductUnitClass(baseUnit),decimalPrecision=rawPrecision===''?defaultProductUnitPrecision(unitClass):Number(rawPrecision);
L1898 |   let barcode=value('barcode')||'',sku=value('sku')||'',itemKind=value('item_kind').toUpperCase(),requestedType=value('barcode_type')||'AUTO';
L1899 |   const deterministic='CFI-'+String(state.productImportChecksum||'IMPORT').replace(/[^A-F0-9]/gi,'').slice(-12).toUpperCase().padStart(12,'0')+'-'+String(rowNumber).padStart(7,'0');
L1900 |   if(!barcode){barcode=deterministic;if(!itemKind)itemKind=unitClass==='mass'?'WEIGHED':'NO_BARCODE';requestedType='INTERNAL';}
L1901 |   else{requestedType=cfResolveBarcodeType(barcode,requestedType);if(!itemKind)itemKind=unitClass==='mass'?'WEIGHED':'BARCODED';}
L1902 |   if(itemKind==='BARCODED'&&requestedType==='INTERNAL')throw new Error('الصنف المحدد كصنف بباركود يحتاج باركوداً خارجياً صالحاً.');
L1903 |   if(!sku)sku=deterministic;
L1904 |   units=withProductUnitMeta(units,unitClass,decimalPrecision,{item_kind:itemKind,barcode_type:requestedType});
L1905 |   return {_row_number:rowNumber,_source_row:row,sku,barcode,name:value('name')||null,category:value('category')||null,base_unit:baseUnit,units,expected_qty:value('expected_qty'),location_code:value('location_code'),image_url:value('image_url')||null,purchase_unit_cost:value('purchase_unit_cost')||null,currency_code:value('currency_code').toUpperCase()||null,purchase_unit:value('purchase_unit')||null,unit_factor_to_base:value('unit_factor_to_base')||null,cost_source_type:value('cost_source_type')||null,cost_source_reference:value('cost_source_reference')||null,cost_source_date:value('cost_source_date')||null};
L1906 |  }
```

### renderProductImportPreview() — lines 1907-1912

```javascript
L1907 | function renderProductImportPreview(){
L1908 |   const headers=Object.keys(state.productImportRows[0]||{}),rows=state.productImportRows.slice(0,8);
L1909 |   const sample=rows.length?'<div class="tablewrap"><table><thead><tr>'+headers.slice(0,8).map(h=>'<th>'+esc(h)+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+headers.slice(0,8).map(h=>'<td>'+esc(String(r[h]??'').slice(0,80))+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>':'';
L1910 |   $('productImportPreview').innerHTML='<b>معاينة الملف: '+state.productImportRowCount.toLocaleString('en-US')+' صف بيانات</b><span class="sub"> أول ورقة في الملف · عينة من '+rows.length+' صفوف · '+headers.length+' عمود</span>'+sample;
L1911 |   $('productImportCommitBtn').disabled=!state.productImportRows.length||!state.productImportMapping.name||!state.productImportMapping.base_unit;
L1912 |  }
```

### previewProductImport() — lines 1913-1929

```javascript
L1913 | async function previewProductImport(){
L1914 |   const file=$('productImportFile').files[0];if(!file)return notify('اختر ملف Excel أو CSV أولاً.',true);
L1915 |   if(!state.project)return notify('اختر تكليفاً أولاً.',true);
L1916 |   const projectId=state.project.id;
L1917 |   $('productImportPreviewBtn').disabled=true;$('productImportCommitBtn').disabled=true;$('projectPicker').disabled=true;$('productImportFile').disabled=true;$('productImportSession').disabled=true;$('productImportResetBtn').disabled=true;$('productImportResult').textContent='جار قراءة الملف تدريجياً ومعاينة أول الصفوف…';
L1918 |   try{
L1919 |    const parsed=await parseProductImportFile(file);
L1920 |    if(!parsed.count)throw new Error('لا توجد صفوف بيانات قابلة للقراءة.');
L1921 |    if(parsed.count>90000)throw new Error('الحد التشغيلي المعتمد لهذه الدفعة هو 90,000 صف. قسّم الملف إلى دفعات أصغر');
L1922 |    state.productImportRows=parsed.rows||parsed.sample||[];state.productImportRowCount=parsed.count;state.productImportHeaders=parsed.headers||Object.keys(state.productImportRows[0]||{});state.productImportFileName=file.name;
L1923 |    const ext=(file.name.split('.').pop()||'').toLowerCase();state.productImportSourceFormat=ext==='xls'||ext==='xlsx'?'xlsx':'csv';
L1924 |    await renderProductImportMapping();renderProductImportPreview();
L1925 |    $('productImportResult').textContent=parsed.streaming?(state.productImportSourceFormat==='xlsx'?'تمت قراءة XLSX على مستوى سجلات XML مع التحقق من CRC دون تحميل ورقة العمل كاملة.':'تمت معاينة CSV باستخدام step دون الاحتفاظ بجميع الصفوف؛ سيُعاد قراءته أثناء الاعتماد على دفعات.'):'تمت قراءة ملف XLS القديم ضمن حد ذاكرة صارم؛ يوصى بتحويل الملفات الكبيرة إلى XLSX.';
L1926 |    if(parsed.parseErrors)$('productImportResult').textContent+=' · أخطاء تحليل CSV المتجاوزة: '+parsed.parseErrors;
L1927 |   }catch(err){state.productImportRows=[];state.productImportRowCount=0;$('productImportPreview').textContent='';$('productImportCommitBtn').disabled=true;fail('تعذر معاينة ملف الأصناف',err);}
L1928 |   finally{$('productImportPreviewBtn').disabled=false;$('projectPicker').disabled=false;$('productImportFile').disabled=false;$('productImportSession').disabled=false;$('productImportResetBtn').disabled=false;}
L1929 |  }
```

### commitImportBatchInChunks() — lines 1930-1942

```javascript
L1930 | async function commitImportBatchInChunks(batchId,onProgress){
L1931 |   let result=null,attempt=0;
L1932 |   while(attempt++<10000){
L1933 |    const {data,error}=await db.rpc('count_commit_import_batch',{p_batch_id:batchId});
L1934 |    if(error){console.warn('CountFlow import commit chunk failed',error);throw new Error('تعذر اعتماد جزء من الاستيراد حالياً. بقيت الدفعة محفوظة ويمكن استئنافها بعد التحقق من الاتصال.');}
L1935 |    result=data||{};
L1936 |    if(result.status==='committed')return result;
L1937 |    if(result.status!=='committing'){console.warn('Unexpected CountFlow import commit status',result.status);throw new Error('تعذر استكمال اعتماد الاستيراد. أعد المحاولة أو راجع سجل الاستيراد.');}
L1938 |    if(!Number.isInteger(Number(result.remaining_rows))||Number(result.remaining_rows)<1)throw new Error('استجابة اعتماد الدفعة لا تتضمن عدد الصفوف المتبقية بصورة صحيحة.');
L1939 |    if(typeof onProgress==='function')onProgress(result);
L1940 |   }
L1941 |   throw new Error('تجاوز اعتماد الدفعة الحد الأقصى لعدد الأجزاء. بقيت الدفعة محفوظة ويمكن استئنافها.');
L1942 |  }
```

### resumeImportBatchFromHistory() — lines 1943-1973

```javascript
L1943 | async function resumeImportBatchFromHistory(batchId,scope,button){
L1944 |   if(!batchId||!['product','operation'].includes(scope))return;
L1945 |   const original=button?.textContent||'استكمال الاعتماد';
L1946 |   if(button){button.disabled=true;button.textContent='جار استكمال الاعتماد…';}
L1947 |   try{
L1948 |    const committed=await commitImportBatchInChunks(batchId,progress=>{
L1949 |     if(button)button.textContent='متبقٍ '+Number(progress.remaining_rows||0).toLocaleString('ar-EG')+' صف';
L1950 |    });
L1951 |    if(committed?.status!=='committed')throw new Error('لم تكتمل دفعة الاستيراد بعد. يمكنك استئنافها من السجل.');
L1952 |    notify('اكتمل استكمال دفعة الاستيراد · مقبول '+Number(committed.accepted_rows||0)+' · مرفوض '+Number(committed.rejected_rows||0));
L1953 |    try{
L1954 |     if(scope==='product'){
L1955 |      await loadProjectData();
L1956 |     }else{
L1957 |      await loadOperationImportHistory();
L1958 |      await loadProjectData();
L1959 |      await loadOperationMetrics();
L1960 |     }
L1961 |    }catch(refreshError){
L1962 |     fail('اكتمل اعتماد الدفعة لكن تعذر تحديث العرض',refreshError);
L1963 |     if(scope==='product')await loadProductImportHistory();
L1964 |     else await loadOperationImportHistory();
L1965 |    }
L1966 |   }catch(error){
L1967 |    fail('تعذر استكمال دفعة الاستيراد',error);
L1968 |    if(scope==='product')await loadProductImportHistory();
L1969 |    else await loadOperationImportHistory();
L1970 |   }finally{
L1971 |    if(button&&button.isConnected){button.disabled=false;button.textContent=original;}
L1972 |   }
L1973 |  }
```

### commitProductImport() — lines 1974-2039

```javascript
L1974 | async function commitProductImport(){
L1975 |   if(!state.project||!state.productImportRowCount)return notify('عاين الملف واختر تكليفاً قبل الاعتماد.',true);
L1976 |   if(!state.productImportMapping.name)return notify('اربط عمود اسم الصنف.',true);
L1977 |   if(!state.productImportMapping.base_unit)return notify('اربط عمود الوحدة الأساسية.',true);
L1978 |   const projectId=state.project.id,sessionId=$('productImportSession').value||null,session=sessionId?state.sessions.find(s=>s.id===sessionId):null;
L1979 |   if(sessionId&&!session)return notify('جلسة الربط لم تعد ضمن قائمة الجلسات المتاحة. حدّث البيانات.',true);
L1980 |   if(session&&!['planned','active','paused','review'].includes(session.status))return notify('لا يمكن ربط الاستيراد بهذه الجلسة بسبب حالتها الحالية.',true);
L1981 |   const file=$('productImportFile').files[0];if(!file)return notify('أعد اختيار ملف الاستيراد.',true);
L1982 |   const btn=$('productImportCommitBtn');btn.disabled=true;const oldText=btn.textContent;btn.textContent='جار تجهيز الدفعة…';$('projectPicker').disabled=true;$('productImportFile').disabled=true;$('productImportSession').disabled=true;$('productImportPreviewBtn').disabled=true;$('productImportResetBtn').disabled=true;
L1983 |   try{
L1984 |    const checksum=await hashFileInChunks(file);state.productImportChecksum=checksum;
L1985 |    const {data:batchId,error:createError}=await db.rpc('count_create_import_batch',{p_project_id:projectId,p_session_id:sessionId,p_source_name:file.name,p_source_format:state.productImportSourceFormat,p_source_checksum:checksum});
L1986 |    if(createError)throw createError;
L1987 |    const {error:mappingError}=await db.from('count_import_batches').update({mapping_id:state.productImportMappingId,metadata:{column_mapping:state.productImportMapping,headers:state.productImportHeaders,import_surface:'countflow-admin',checksum_algorithm:'sha256-chain-v1'}}).eq('id',batchId).eq('project_id',projectId);
L1988 |    if(mappingError)throw mappingError;
L1989 |    let stagedAccepted=0,stagedRejected=0,processed=0,parseErrors=0;
L1990 |    const stage=async(chunk,offset)=>{
L1991 |     if(!chunk.length)return;
L1992 |     const {data:staged,error}=await db.rpc('count_stage_import_rows',{p_batch_id:batchId,p_rows:chunk,p_row_offset:offset});
L1993 |     if(error){console.warn('CountFlow product import staging failed',error);throw new Error('تعذر فحص بيانات الملف بدءاً من الصف '+(offset+2)+'. راجع هذا الصف ثم أعد المحاولة.');}
L1994 |     stagedAccepted+=Number(staged?.accepted_rows||0);stagedRejected+=Number(staged?.rejected_rows||0);processed+=chunk.length;
L1995 |     $('productImportResult').textContent='فحص الأصناف · '+processed.toLocaleString('en-US')+' / '+state.productImportRowCount.toLocaleString('en-US')+' صف · مقبول '+stagedAccepted+' · مرفوض '+stagedRejected;
L1996 |    };
L1997 |    if(state.productImportSourceFormat==='csv'){
L1998 |     await new Promise((resolve,reject)=>{
L1999 |      let pending=[],rowIndex=0,sourceRowNumber=2,chain=Promise.resolve(),settled=false;
L2000 |      const failParse=err=>{if(settled)return;settled=true;reject(err);};
L2001 |      Papa.parse(file,{header:true,skipEmptyLines:false,dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L2002 |       step:(r,parser)=>{
L2003 |        const currentSourceRow=sourceRowNumber++;
L2004 |        if(r.errors?.length){parseErrors+=r.errors.length;return;}
L2005 |        const row=r.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;
L2006 |        pending.push(normalizeProductImportRow(row,rowIndex,currentSourceRow));rowIndex++;
L2007 |        if(pending.length>=1000){
L2008 |         parser.pause();const chunk=pending;pending=[];
L2009 |         chain=chain.then(()=>stage(chunk,rowIndex-chunk.length)).then(()=>parser.resume()).catch(err=>{parser.abort();failParse(err);});
L2010 |        }
L2011 |       },
L2012 |       complete:async()=>{
L2013 |        if(settled)return;
L2014 |        try{await chain;await stage(pending,rowIndex-pending.length);if(!rowIndex)throw new Error('لم يتم العثور على صفوف بيانات صالحة.');settled=true;resolve();}
L2015 |        catch(err){failParse(err);}
L2016 |       },error:failParse});
L2017 |     });
L2018 |    }else if(state.productImportSourceFormat==='xlsx'){
L2019 |     let pending=[],rowIndex=0;
L2020 |     const parsed=await streamXlsxProductRows(file,async row=>{
L2021 |      pending.push(normalizeProductImportRow(row,rowIndex));rowIndex++;
L2022 |      if(pending.length>=1000){const chunk=pending;pending=[];await stage(chunk,rowIndex-chunk.length);}
L2023 |     });
L2024 |     if(parsed.count!==state.productImportRowCount)throw new Error('تغير عدد صفوف ملف XLSX بعد المعاينة. أعد المعاينة قبل الاعتماد.');
L2025 |     await stage(pending,rowIndex-pending.length);
L2026 |    }else{
L2027 |     const rows=state.productImportRows||[];
L2028 |     for(let i=0;i<rows.length;i+=1000)await stage(rows.slice(i,i+1000).map((r,j)=>normalizeProductImportRow(r,i+j)),i);
L2029 |    }
L2030 |    const committed=await commitImportBatchInChunks(batchId,progress=>{$('productImportResult').textContent='اعتماد الدفعة · مقبول '+Number(progress.accepted_rows||0)+' · مرفوض '+Number(progress.rejected_rows||0)+' · متبقٍ '+Number(progress.remaining_rows||0);});
L2031 |    const successMessage='اكتمل الاستيراد · صفوف معالجة '+processed+' · مقبول '+Number(committed?.accepted_rows??stagedAccepted)+' · مرفوض '+Number(committed?.rejected_rows??stagedRejected)+' · أرصدة مرجعية '+Number(committed?.expected_balance_rows||0)+' · تم حفظ النتيجة في السجل'+(parseErrors?' · صفوف متجاوزة بسبب تنسيق غير صحيح '+parseErrors:'');
L2032 |    notify('اكتمل استيراد الأصناف من خلال مسار CountFlow الآمن.');
L2033 |    resetProductImport();$('productImportResult').textContent=successMessage;
L2034 |    try{if(state.project?.id===projectId)await loadProjectData();}catch(reloadError){fail('تم اعتماد الاستيراد لكن تعذر تحديث عرض الكتالوج',reloadError);await loadProductImportHistory();}
L2035 |   }catch(err){
L2036 |    $('productImportResult').textContent='لم يكتمل اعتماد الدفعة. بقي سجلها متاحاً للمراجعة؛ لم يتم تجاوز فحص الخادم. '+friendlyErrorMessage(err);
L2037 |    fail('فشل استيراد الأصناف',err);await loadProductImportHistory();
L2038 |   }finally{btn.disabled=!state.productImportRowCount;btn.textContent=oldText;$('projectPicker').disabled=false;$('productImportFile').disabled=false;$('productImportSession').disabled=false;$('productImportPreviewBtn').disabled=false;$('productImportResetBtn').disabled=false;}
L2039 |  }
```

### loadProductImportHistory() — lines 2040-2051

```javascript
L2040 | async function loadProductImportHistory(){
L2041 |   $('productImportDetails').innerHTML='';
L2042 |   if(!state.project){$('productImportHistory').innerHTML='<div class="empty">اختر تكليفاً لعرض سجل الاستيراد.</div>';return;}
L2043 |   const {data,error}=await db.from('count_import_batches').select('id,source_name,source_format,row_count,accepted_count,rejected_count,status,error_report,created_at,session_id,metadata').eq('project_id',state.project.id).order('created_at',{ascending:false}).limit(20);
L2044 |   if(error){$('productImportHistory').textContent='تعذر تحميل سجل الاستيراد. حاول تحديث الصفحة.';return;}
L2045 |   $('productImportHistory').innerHTML='<b>سجل دفعات الاستيراد لهذا التكليف</b>'+(data||[]).map(b=>{
L2046 |    const canResume=b.status==='committing'&&b.metadata?.import_surface==='countflow-admin';
L2047 |    return '<div class="row" style="padding:8px 0;border-bottom:1px solid var(--line)"><div style="flex:1;min-width:180px"><b>'+esc(b.source_name)+'</b><span class="sub">'+date(b.created_at)+' · '+esc(exportFormatLabel(b.source_format))+' · '+esc(statusName(b.status))+' · إجمالي '+Number(b.row_count||0)+' · مقبول '+Number(b.accepted_count||0)+' · مرفوض '+Number(b.rejected_count||0)+' · أرصدة مرجعية '+Number(b.error_report?.expected_balance_rows||0)+' · تحذيرات '+Number(b.error_report?.warning_count||0)+'</span></div><div class="actions">'+(canResume?'<button type="button" class="primary" data-resume-product-import="'+b.id+'">استكمال الاعتماد</button>':'')+'<button type="button" class="soft" data-product-import-detail="'+b.id+'">تفاصيل النتائج</button></div></div>';
L2048 |   }).join('')||'<p class="hint">لا توجد دفعات استيراد سابقة لهذا التكليف.</p>';
L2049 |   $('productImportHistory').querySelectorAll('[data-product-import-detail]').forEach(b=>b.onclick=()=>showProductImportDetails(b.dataset.productImportDetail));
L2050 |   $('productImportHistory').querySelectorAll('[data-resume-product-import]').forEach(b=>b.onclick=()=>resumeImportBatchFromHistory(b.dataset.resumeProductImport,'product',b));
L2051 |  }
```

### importIssueLabel() — lines 2052-2082

```javascript
L2052 | function importIssueLabel(code,kind='error'){
L2053 |   const errors={
L2054 |    INVALID_ROW_SHAPE:'تنسيق الصف غير مفهوم',
L2055 |    MISSING_PRODUCT_IDENTIFIER:'أدخل كود الصنف أو الباركود',
L2056 |    SKU_TOO_LONG:'كود الصنف أطول من الحد المسموح',
L2057 |    BARCODE_TOO_LONG:'الباركود أطول من الحد المسموح',
L2058 |    PRODUCT_NAME_TOO_LONG:'اسم الصنف أطول من الحد المسموح',
L2059 |    MISSING_BASE_UNIT:'وحدة القياس الأساسية مطلوبة',
L2060 |    BASE_UNIT_TOO_LONG:'اسم الوحدة الأساسية طويل',
L2061 |    CATEGORY_TOO_LONG:'اسم التصنيف أطول من الحد المسموح',
L2062 |    INVALID_IMAGE_REFERENCE:'رابط أو مرجع صورة الصنف غير صالح',
L2063 |    INVALID_EXPECTED_QUANTITY:'الرصيد المرجعي ليس رقماً صالحاً',
L2064 |    NEGATIVE_EXPECTED_QUANTITY:'الرصيد المرجعي لا يقبل قيمة سالبة',
L2065 |    SESSION_REQUIRED_FOR_EXPECTED_QTY:'اختر عملية جرد عند استيراد أرصدة مرجعية',
L2066 |    LOCATION_REQUIRED_FOR_EXPECTED_QUANTITY:'حدد موقع الرصيد المرجعي',
L2067 |    UNKNOWN_LOCATION_CODE:'كود الموقع غير موجود في هذا التكليف',
L2068 |    AMBIGUOUS_LOCATION_CODE:'كود الموقع يشير إلى أكثر من موقع',
L2069 |    DUPLICATE_PRODUCT_IDENTIFIER_AT_SAME_LOCATION:'الصنف مكرر للموقع نفسه داخل الملف',
L2070 |    PRODUCT_IDENTITY_MATCHES_MULTIPLE_PRODUCTS:'الكود أو الباركود يطابق أكثر من صنف'
L2071 |   };
L2072 |   const warnings={
L2073 |    INVALID_PURCHASE_UNIT_COST:'سعر وحدة الشراء غير صالح',
L2074 |    INVALID_CURRENCY_CODE:'رمز العملة غير صالح',
L2075 |    INVALID_UNIT_FACTOR:'معامل تحويل وحدة الشراء غير صالح',
L2076 |    INVALID_COST_SOURCE_DATE:'تاريخ مصدر التكلفة غير صالح',
L2077 |    COST_DATA_INCOMPLETE:'بيانات تكلفة الشراء غير مكتملة',
L2078 |    COST_REQUIRES_OPERATION_SCOPE:'بيانات التكلفة تتطلب ربط الملف بعملية جرد'
L2079 |   };
L2080 |   const labels=kind==='warning'?warnings:errors;
L2081 |   return labels[String(code||'').toUpperCase()]||'تحتاج بيانات هذا الصف إلى مراجعة';
L2082 |  }
```

### importIssueRowsHtml() — lines 2083-2085

```javascript
L2083 | function importIssueRowsHtml(rows,key,kind){
L2084 |   return rows.map(r=>'<tr><td>'+Number(r.row_number||0)+'</td><td>'+esc(r.sku||'')+'</td><td>'+esc(r.barcode||'')+'</td><td>'+esc(r.product_name||'')+'</td><td>'+esc((r[key]||[]).map(code=>importIssueLabel(code,kind)).join('، '))+'</td></tr>').join('');
L2085 |  }
```

### loadMoreProductImportDetails() — lines 2086-2103

```javascript
L2086 | async function loadMoreProductImportDetails(kind){
L2087 |   if(!importDetailBatchId||!['errors','warnings'].includes(kind))return;
L2088 |   const target=$(importDetailTargetId);if(!target)return;
L2089 |   const offset=importDetailOffsets[kind],key=kind==='errors'?'error_codes':'warning_codes';
L2090 |   let query=db.from('count_import_rows').select('row_number,sku,barcode,product_name,'+key,{count:'exact'})
L2091 |    .eq('batch_id',importDetailBatchId).order('row_number').range(offset,offset+IMPORT_DETAIL_PAGE_SIZE-1);
L2092 |   query=kind==='errors'?query.eq('row_status','rejected'):query.not('warning_codes','eq','{}');
L2093 |   const {data,error,count}=await query;
L2094 |   if(error){console.warn('Import detail page load failed',error);notify('تعذر تحميل بقية النتائج. حاول مرة أخرى.',true);return;}
L2095 |   const rows=data||[];
L2096 |   const body=$(importDetailTargetId+'-'+kind);
L2097 |   if(body&&rows.length)body.insertAdjacentHTML('beforeend',importIssueRowsHtml(rows,key,kind));
L2098 |   importDetailOffsets[kind]+=rows.length;
L2099 |   const counter=$(importDetailTargetId+'-'+kind+'-count');
L2100 |   if(counter)counter.textContent=importDetailOffsets[kind]+' من '+Number(importDetailTotals[kind]||count||0);
L2101 |   const button=$(importDetailTargetId+'-'+kind+'-more');
L2102 |   if(button)button.hidden=importDetailOffsets[kind]>=Number(importDetailTotals[kind]||count||0)||rows.length===0;
L2103 |  }
```

### showProductImportDetails() — lines 2104-2121

```javascript
L2104 | async function showProductImportDetails(batchId,targetId='productImportDetails'){
L2105 |   importDetailBatchId=batchId;importDetailTargetId=targetId;importDetailOffsets={errors:0,warnings:0};importDetailTotals={errors:0,warnings:0};
L2106 |   const [rejected,warnings]=await Promise.all([
L2107 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,error_codes',{count:'exact'}).eq('batch_id',batchId).eq('row_status','rejected').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1),
L2108 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,warning_codes',{count:'exact'}).eq('batch_id',batchId).not('warning_codes','eq','{}').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1)
L2109 |   ]);
L2110 |   if(rejected.error||warnings.error)return fail('تعذر قراءة تفاصيل الاستيراد',rejected.error||warnings.error);
L2111 |   const errRows=rejected.data||[],warnRows=warnings.data||[];
L2112 |   importDetailOffsets.errors=errRows.length;importDetailOffsets.warnings=warnRows.length;
L2113 |   importDetailTotals.errors=Number(rejected.count||0);importDetailTotals.warnings=Number(warnings.count||0);
L2114 |   const table=(rows,key,title,kind,total)=>'<section class="panel"><div class="headrow"><h4>'+title+'</h4><span class="hint" id="'+targetId+'-'+kind+'-count">'+rows.length+' من '+total+'</span></div><div class="tablewrap"><table><thead><tr><th>الصف</th><th>كود الصنف</th><th>باركود</th><th>اسم الصنف</th><th>النتيجة</th></tr></thead><tbody id="'+targetId+'-'+kind+'">'+(rows.length?importIssueRowsHtml(rows,key,kind):'<tr><td colspan="5">لا توجد سجلات في هذه الفئة.</td></tr>')+'</tbody></table></div><button type="button" class="soft" id="'+targetId+'-'+kind+'-more" '+(rows.length>=total?'hidden':'')+'>عرض 500 نتيجة أخرى</button></section>';
L2115 |   const container=$(targetId);if(!container)return;
L2116 |   const closeId=targetId+'-close';
L2117 |   container.innerHTML='<div class="panel"><div class="headrow"><h3>تفاصيل نتائج الاستيراد</h3><button type="button" class="soft" id="'+closeId+'">إغلاق التفاصيل</button></div>'+table(errRows,'error_codes','الصفوف المرفوضة','errors',importDetailTotals.errors)+table(warnRows,'warning_codes','ملاحظات استكمال البيانات','warnings',importDetailTotals.warnings)+'</div>';
L2118 |   $(closeId).onclick=()=>{container.innerHTML='';importDetailBatchId=null;};
L2119 |   $(targetId+'-errors-more').onclick=()=>loadMoreProductImportDetails('errors');
L2120 |   $(targetId+'-warnings-more').onclick=()=>loadMoreProductImportDetails('warnings');
L2121 |  }
```

### normalizeUnitName() — lines 2920-2923

```javascript
L2920 | function normalizeUnitName(value){
L2921 |  return String(value??'').normalize('NFKC').trim().toLocaleLowerCase()
L2922 |   .replace(/[ًٌٍَُِّْـ]/g,'').replace(/[.\s_-]+/g,' ');
L2923 | }
```

### inferProductUnitClass() — lines 2924-2931

```javascript
L2924 | function inferProductUnitClass(unitName){
L2925 |  const normalized=normalizeUnitName(unitName),compact=normalized.replace(/\s+/g,'');
L2926 |  for(const cls of CF_UNIT_CLASSES){
L2927 |   if(cls.value==='other')continue;
L2928 |   if(cls.aliases.some(alias=>normalizeUnitName(alias)===normalized||normalizeUnitName(alias).replace(/\s+/g,'')===compact))return cls.value;
L2929 |  }
L2930 |  return 'other';
L2931 | }
```

### defaultProductUnitPrecision() — lines 2932-2935

```javascript
L2932 | function defaultProductUnitPrecision(unitClass){
L2933 |  const entry=CF_UNIT_CLASSES.find(x=>x.value===unitClass);
L2934 |  return entry?entry.precision:3;
L2935 | }
```

### productUnitRows() — lines 2936-2938

```javascript
L2936 | function productUnitRows(units){
L2937 |  return Array.isArray(units)?units.filter(row=>!(row&&typeof row==='object'&&row[CF_UNIT_META_FLAG]===true)):[];
L2938 | }
```

### cfGs1CheckDigit() — lines 2939-2939

```javascript
L2939 | function cfGs1CheckDigit(payload){const code=String(payload||'');if(!/^[0-9]+$/.test(code))return null;let sum=0,weight=3;for(let i=code.length-1;i>=0;i--){sum+=Number(code[i])*weight;weight=weight===3?1:3;}return (10-(sum%10))%10;}
```

### cfIsValidGtin() — lines 2940-2940

```javascript
L2940 | function cfIsValidGtin(code){const value=String(code||'');if(!/^[0-9]+$/.test(value)||![8,12,13,14].includes(value.length))return false;return Number(value.slice(-1))===cfGs1CheckDigit(value.slice(0,-1));}
```

### cfResolveBarcodeType() — lines 2941-2941

```javascript
L2941 | function cfResolveBarcodeType(code,requested='AUTO'){const value=String(code??'').trim(),kind=String(requested||'AUTO').toUpperCase();if(!value)return null;if(value!==String(code)||/[\u0000-\u001f\u007f]/.test(value))throw new Error('الباركود يحتوي مسافات طرفية أو رموز تحكم غير مسموحة.');if(kind==='AUTO'||kind==='UNKNOWN'){if(/^[0-9]+$/.test(value)&&[8,12,13,14].includes(value.length)){if(!cfIsValidGtin(value))throw new Error('رقم GTIN غير صحيح: راجع الطول ورقم التحقق GS1.');return ({8:'EAN8',12:'UPC_A',13:'EAN13',14:'GTIN14'})[value.length];}if(/^CFI-[A-F0-9-]{8,48}$/.test(value))return 'INTERNAL';if(!/^[ -~]{1,48}$/.test(value))throw new Error('Code 128 يقبل 1 إلى 48 حرفاً قابلاً للطباعة.');return 'CODE128';}if(['EAN8','UPC_A','EAN13','GTIN14'].includes(kind)){const lengths={EAN8:8,UPC_A:12,EAN13:13,GTIN14:14};if(value.length!==lengths[kind]||!cfIsValidGtin(value))throw new Error('الباركود '+kind+' غير صحيح أو رقم التحقق GS1 غير مطابق.');return kind;}if(kind==='INTERNAL'){if(!/^CFI-[A-F0-9-]{8,48}$/.test(value))throw new Error('المعرف الداخلي يجب أن يبدأ بـ CFI-.');return 'INTERNAL';}if(kind==='CODE128'){if(!/^[ -~]{1,48}$/.test(value))throw new Error('قيمة Code 128 يجب أن تكون 1 إلى 48 حرفاً قابلاً للطباعة.');return 'CODE128';}throw new Error('نوع الباركود المحدد غير مدعوم.');}
```

### cfIsRestrictedCirculationBarcode() — lines 2942-2942

```javascript
L2942 | function cfIsRestrictedCirculationBarcode(code){const value=String(code||'');return /^2[0-9]\d{11}$/.test(value)&&cfIsValidGtin(value);}
```

### cfGenerateInternalBarcode() — lines 2943-2943

```javascript
L2943 | function cfGenerateInternalBarcode(){const digits=[];while(digits.length<10){const bytes=new Uint8Array(20);crypto.getRandomValues(bytes);for(const byte of bytes){if(byte<250&&digits.length<10)digits.push(String(byte%10));}}const payload='20'+digits.join('');return payload+String(cfGs1CheckDigit(payload));}
```

### cfParseUnitRows() — lines 2944-2944

```javascript
L2944 | function cfParseUnitRows(value){if(Array.isArray(value))return value;const raw=String(value??'').trim();if(!raw)return [];try{const parsed=JSON.parse(raw);if(Array.isArray(parsed))return parsed;}catch(_){}return raw.split('|').map(part=>{const bits=part.trim().split(/[:=]/);if(bits.length<2)return null;const factor=Number(bits[1]);return bits[0].trim()&&Number.isFinite(factor)?{name:bits[0].trim(),factor_to_base:factor}:null;}).filter(Boolean);}
```

### readProductUnitMeta() — lines 2945-2945

```javascript
L2945 | function readProductUnitMeta(units,baseUnit){const meta=Array.isArray(units)?units.find(row=>row&&typeof row==='object'&&row[CF_UNIT_META_FLAG]===true):null,allowed=CF_UNIT_CLASSES.map(x=>x.value),validClass=meta&&allowed.includes(meta.unit_class),unitClass=validClass?meta.unit_class:inferProductUnitClass(baseUnit),precision=Number(meta?.decimal_precision);return {unit_class:unitClass,decimal_precision:Number.isInteger(precision)&&precision>=0&&precision<=6?precision:defaultProductUnitPrecision(unitClass),item_kind:['BARCODED','WEIGHED','NO_BARCODE'].includes(meta?.item_kind)?meta.item_kind:(unitClass==='mass'?'WEIGHED':'BARCODED'),barcode_type:['EAN8','UPC_A','EAN13','GTIN14','CODE128','INTERNAL'].includes(meta?.barcode_type)?meta.barcode_type:'AUTO',inferred:!validClass};}
```

### withProductUnitMeta() — lines 2946-2946

```javascript
L2946 | function withProductUnitMeta(units,unitClass,decimalPrecision,extra={}){const selected=CF_UNIT_CLASSES.some(x=>x.value===unitClass)?unitClass:'other',precision=Number(decimalPrecision);if(!Number.isInteger(precision)||precision<0||precision>6)throw new Error('دقة الكسور يجب أن تكون من صفر إلى 6 منازل عشرية.');const itemKind=['BARCODED','WEIGHED','NO_BARCODE'].includes(extra.item_kind)?extra.item_kind:null,barcodeType=['EAN8','UPC_A','EAN13','GTIN14','CODE128','INTERNAL'].includes(extra.barcode_type)?extra.barcode_type:null;return [...productUnitRows(units),{[CF_UNIT_META_FLAG]:true,unit_class:selected,decimal_precision:precision,...(itemKind?{item_kind:itemKind}:{}),...(barcodeType?{barcode_type:barcodeType}:{})}];}
```

### bindUnitPrecisionDefaults() — lines 2947-2952

```javascript
L2947 | function bindUnitPrecisionDefaults(){
L2948 |  [['globalUnitClass','globalUnitPrecision'],['unitClass','unitPrecision'],['clientUnitClass','clientUnitPrecision']].forEach(([classId,precisionId])=>{
L2949 |   const cls=$(classId),precision=$(precisionId);if(!cls||!precision)return;
L2950 |   cls.addEventListener('change',()=>{precision.value=String(defaultProductUnitPrecision(cls.value));});
L2951 |  });
L2952 | }
```

### setUnitMetaFields() — lines 2953-2953

```javascript
L2953 | function setUnitMetaFields(prefix,units,baseUnit){const meta=readProductUnitMeta(units,baseUnit),cls=$(prefix+'UnitClass'),precision=$(prefix+'UnitPrecision'),kind=$(prefix+'ItemKind'),barcodeType=$(prefix+'BarcodeType');if(cls)cls.value=meta.unit_class;if(precision)precision.value=String(meta.decimal_precision);if(kind)kind.value=meta.item_kind;if(barcodeType)barcodeType.value=meta.barcode_type;}
```

### getUnitMetaFields() — lines 2954-2954

```javascript
L2954 | function getUnitMetaFields(prefix,units,extra={}){const cls=$(prefix+'UnitClass'),precision=$(prefix+'UnitPrecision'),kind=$(prefix+'ItemKind'),barcodeType=$(prefix+'BarcodeType');return withProductUnitMeta(units,cls?.value||'other',Number(precision?.value??3),{item_kind:kind?.value||extra.item_kind,barcode_type:barcodeType?.value||extra.barcode_type});}
```

### renderCatalogUnitEditor() — lines 2956-2956

```javascript
L2956 | function renderCatalogUnitEditor(containerId,units=[]){const el=$(containerId);if(!el)return;const list=productUnitRows(units).map(u=>({name:String(u?.name||''),factor_to_base:String(u?.factor_to_base??u?.conversion_factor??u?.factor??''),barcode:String(u?.barcode||''),barcode_type:String(u?.barcode_type||'AUTO')}));el.innerHTML=(list.length?list:[{name:'',factor_to_base:'',barcode:'',barcode_type:'AUTO'}]).map(u=>'<div class="product-unit-row" data-catalog-unit-row><div class="field"><label>اسم الوحدة البديلة</label><input data-catalog-unit-name value="'+esc(u.name)+'" maxlength="40"></div><div class="field"><label>تعادل من وحدة الأساس</label><input data-catalog-unit-factor type="number" min="0.000001" step="0.000001" value="'+esc(u.factor_to_base)+'"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-catalog-unit-barcode value="'+esc(u.barcode)+'" maxlength="120" inputmode="text"></div><div class="field"><label>نوع الرمز</label><select data-catalog-unit-barcode-type><option value="AUTO" '+(u.barcode_type==='AUTO'?'selected':'')+'>تلقائي</option><option value="EAN8" '+(u.barcode_type==='EAN8'?'selected':'')+'>EAN-8</option><option value="UPC_A" '+(u.barcode_type==='UPC_A'?'selected':'')+'>UPC-A</option><option value="EAN13" '+(u.barcode_type==='EAN13'?'selected':'')+'>EAN-13</option><option value="GTIN14" '+(u.barcode_type==='GTIN14'?'selected':'')+'>GTIN-14</option><option value="CODE128" '+(u.barcode_type==='CODE128'?'selected':'')+'>Code 128</option></select></div><button type="button" class="danger" data-catalog-unit-remove>إزالة</button></div>').join('');el.querySelectorAll('[data-catalog-unit-remove]').forEach(b=>b.onclick=()=>{b.closest('[data-catalog-unit-row]')?.remove();if(!el.querySelector('[data-catalog-unit-row]'))renderCatalogUnitEditor(containerId,[]);});}
```

### readCatalogUnits() — lines 2957-2957

```javascript
L2957 | function readCatalogUnits(containerId,baseUnit,primaryBarcode=null){const el=$(containerId);if(!el)throw new Error('محرر الوحدات غير متاح.');const out=[],seen=new Set(),codes=new Set(),base=String(baseUnit||'').trim().toLocaleLowerCase();if(primaryBarcode)codes.add(String(primaryBarcode).trim().toLowerCase());for(const row of el.querySelectorAll('[data-catalog-unit-row]')){const name=row.querySelector('[data-catalog-unit-name]').value.trim(),raw=row.querySelector('[data-catalog-unit-factor]').value.trim(),barcode=row.querySelector('[data-catalog-unit-barcode]')?.value.trim()||'',requested=row.querySelector('[data-catalog-unit-barcode-type]')?.value||'AUTO';if(!name&&!raw&&!barcode)continue;if(!name||!raw)throw new Error('أكمل اسم الوحدة البديلة ومعامل التحويل معاً.');const key=name.toLocaleLowerCase(),factor=Number(raw);if(key===base)throw new Error('الوحدة البديلة يجب أن تختلف عن وحدة الأساس.');if(seen.has(key))throw new Error('لا تكرر اسم الوحدة البديلة.');if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل التحويل يجب أن يكون رقماً موجباً وصالحاً.');const unit={name,factor_to_base:factor};if(barcode){const type=cfResolveBarcodeType(barcode,requested);if(codes.has(barcode.toLowerCase()))throw new Error('لا يمكن تكرار الباركود بين الصنف ووحداته أو داخل الوحدات.');codes.add(barcode.toLowerCase());unit.barcode=barcode;unit.barcode_type=type;}seen.add(key);out.push(unit);}return out;}
```

### getCatalogCategoryChoices() — lines 2973-2984

```javascript
L2973 | function getCatalogCategoryChoices(){
L2974 |  const saved=[
L2975 |   ...(Array.isArray(state.catalogProducts)?state.catalogProducts.map(row=>row?.category):[]),
L2976 |   ...(Array.isArray(state.catalogClientRows)?state.catalogClientRows.map(row=>row?.category_override):[])
L2977 |  ];
L2978 |  const unique=new Map();
L2979 |  [...CF_PRODUCT_CATEGORY_SUGGESTIONS,...saved].forEach(raw=>{
L2980 |   const value=String(raw??'').trim();
L2981 |   if(value&&value.length<=120&&!unique.has(value.toLocaleLowerCase()))unique.set(value.toLocaleLowerCase(),value);
L2982 |  });
L2983 |  return [...unique.values()].sort((a,b)=>a.localeCompare(b,'ar'));
L2984 | }
```

### setCatalogCategoryPicker() — lines 2985-2999

```javascript
L2985 | function setCatalogCategoryPicker(prefix,value=''){
L2986 |  const select=$(prefix+'CategoryChoice'),backing=$(prefix+'Category'),custom=$(prefix+'CategoryCustom');
L2987 |  if(!select||!backing||!custom)return;
L2988 |  const current=String(value??'').trim(),choices=getCatalogCategoryChoices();
L2989 |  const known=choices.find(item=>item.toLocaleLowerCase()===current.toLocaleLowerCase());
L2990 |  const legacy=current&&!known?current:'';
L2991 |  select.innerHTML='<option value="">بدون تصنيف</option>'
L2992 |   +choices.map(item=>'<option value="'+esc(item)+'">'+esc(item)+'</option>').join('')
L2993 |   +(legacy?'<option value="'+esc(legacy)+'" data-legacy="true">'+esc(legacy)+' — تصنيف محفوظ</option>':'')
L2994 |   +'<option value="__cf_add_category__">+ إضافة تصنيف جديد</option>';
L2995 |  select.value=known||legacy||'';
L2996 |  backing.value=current;
L2997 |  custom.value='';
L2998 |  custom.classList.add('hidden');
L2999 | }
```

### bindCatalogCategoryPickers() — lines 3000-3014

```javascript
L3000 | function bindCatalogCategoryPickers(){
L3001 |  ['global','client'].forEach(prefix=>{
L3002 |   const select=$(prefix+'CategoryChoice'),backing=$(prefix+'Category'),custom=$(prefix+'CategoryCustom');
L3003 |   if(!select||!backing||!custom||select.dataset.bound==='true')return;
L3004 |   select.dataset.bound='true';
L3005 |   select.addEventListener('change',()=>{
L3006 |    if(select.value==='__cf_add_category__'){
L3007 |     custom.classList.remove('hidden');custom.value='';backing.value='';custom.focus();return;
L3008 |    }
L3009 |    custom.classList.add('hidden');custom.value='';backing.value=select.value||'';
L3010 |   });
L3011 |   custom.addEventListener('input',()=>{backing.value=custom.value.trim();});
L3012 |   custom.addEventListener('blur',()=>{custom.value=custom.value.trim();backing.value=custom.value;});
L3013 |  });
L3014 | }
```

### renderGlobalBarcodeStatus() — lines 3015-3038

```javascript
L3015 | function renderGlobalBarcodeStatus(){
L3016 |  const input=$('globalBarcode'),status=$('globalBarcodeStatus'),hint=$('globalBarcodeHint'),copy=$('globalBarcodeCopy');
L3017 |  if(!input||!status)return;
L3018 |  const code=String(input.value||'').trim();
L3019 |  if(copy)copy.disabled=!code;
L3020 |  if(!code){status.dataset.state='empty';status.textContent='لم يُدخل باركود بعد.';if(hint)hint.textContent='يمكنك إدخال باركود المورد أو توليد نمط RCN-13 محلي يبدأ بـ 20 مع رقم تحقق. التوليد لا يعني تخصيص البادئة أو اعتمادها من GS1.';return;}
L3021 |  try{
L3022 |   const type=cfResolveBarcodeType(code,$('globalBarcodeType')?.value||'AUTO');
L3023 |   if(cfIsRestrictedCirculationBarcode(code)){
L3024 |    status.dataset.state='restricted';
L3025 |    status.textContent='نمط RCN-13 محلي مقيّد · رقم تحقق Mod-10 صحيح · ليس GTIN عالمياً.';
L3026 |    if(hint)hint.textContent='هذا تحقق شكلي فقط؛ لا يثبت تخصيص نطاق من GS1. استخدمه داخل بيئة مقيدة، وبعد اعتماد منظمة GS1 المحلية عند الحاجة.';
L3027 |   }else if(type==='INTERNAL'){
L3028 |    status.dataset.state='internal';status.textContent='معرف CountFlow داخلي CFI؛ ليس باركود EAN/UPC.';
L3029 |    if(hint)hint.textContent='يظل معرف CFI متاحاً للسجلات القديمة وللأصناف التي لا تحمل باركوداً خارجياً.';
L3030 |   }else{
L3031 |    status.dataset.state='valid';status.textContent='باركود '+type+' · الطول ورقم التحقق صحيحان.';
L3032 |    if(hint)hint.textContent='تم التحقق من صيغة الرمز ورقم التحقق قبل الحفظ؛ سيعيد الخادم التحقق عند الكتابة.';
L3033 |   }
L3034 |  }catch(error){
L3035 |   status.dataset.state='invalid';status.textContent='الرمز غير صالح: '+String(error?.message||error);
L3036 |   if(hint)hint.textContent='راجع عدد الأرقام ونوع الرمز ورقم التحقق، ثم أعد المحاولة.';
L3037 |  }
L3038 | }
```

### generateUniqueGlobalRestrictedBarcode() — lines 3039-3053

```javascript
L3039 | async function generateUniqueGlobalRestrictedBarcode(){
L3040 |  for(let attempt=0;attempt<8;attempt++){
L3041 |   const candidate=cfGenerateInternalBarcode();
L3042 |   const [primary,alternate,aliases]=await Promise.all([
L3043 |    db.from('count_catalog_products').select('id').ilike('barcode',candidate).limit(1),
L3044 |    db.from('count_catalog_products').select('id').contains('units',[{barcode:candidate}]).limit(1),
L3045 |    db.from('count_catalog_product_identifiers').select('id').or('normalized_value.eq.'+candidate+',identifier_value.eq.'+candidate).limit(1)
L3046 |   ]);
L3047 |   if(primary.error)throw primary.error;
L3048 |   if(alternate.error)throw alternate.error;
L3049 |   if(aliases.error)throw aliases.error;
L3050 |   if(!(primary.data||[]).length&&!(alternate.data||[]).length&&!(aliases.data||[]).length)return candidate;
L3051 |  }
L3052 |  throw new Error('تعذر توليد رمز غير مستخدم بعد عدة محاولات؛ أعد المحاولة.');
L3053 | }
```

### handleGenerateGlobalBarcode() — lines 3054-3067

```javascript
L3054 | async function handleGenerateGlobalBarcode(){
L3055 |  const button=$('globalGenerateBarcode');if(button.disabled)return;
L3056 |  button.disabled=true;
L3057 |  try{
L3058 |   const code=await generateUniqueGlobalRestrictedBarcode();
L3059 |   $('globalBarcode').value=code;
L3060 |   $('globalBarcodeType').value='EAN13';
L3061 |   $('globalItemKind').value=$('globalUnitClass').value==='mass'?'WEIGHED':'BARCODED';
L3062 |   renderGlobalBarcodeStatus();
L3063 |   $('globalBarcode').focus();$('globalBarcode').select();
L3064 |   notify('تم توليد نمط RCN-13 بالبادئة 20 ورقم تحقق صحيح؛ يلزم اعتماد GS1 المحلي للتداول المقيد الرسمي.');
L3065 |  }catch(error){fail('تعذر توليد الرمز المحلي',error);}
L3066 |  finally{button.disabled=false;}
L3067 | }
```

### copyGlobalBarcode() — lines 3068-3079

```javascript
L3068 | async function copyGlobalBarcode(){
L3069 |  const code=String($('globalBarcode')?.value||'').trim();
L3070 |  if(!code)return notify('لا يوجد رمز لنسخه.',true);
L3071 |  try{
L3072 |   if(!navigator.clipboard?.writeText)throw new Error('CLIPBOARD_UNAVAILABLE');
L3073 |   await navigator.clipboard.writeText(code);
L3074 |   notify('تم نسخ الباركود.');
L3075 |  }catch(_){
L3076 |   $('globalBarcode').focus();$('globalBarcode').select();
L3077 |   notify('تم تحديد الرمز؛ انسخه باستخدام Ctrl+C أو أمر النسخ في جهازك.',true);
L3078 |  }
L3079 | }
```

### getGlobalBaseUnitValue() — lines 3080-3085

```javascript
L3080 | function getGlobalBaseUnitValue(){
L3081 |  const select=$('globalBaseUnitChoice'),backing=$('globalBaseUnit');
L3082 |  const value=String(select?.value||'').trim();
L3083 |  if(backing)backing.value=value;
L3084 |  return value;
L3085 | }
```

### setGlobalBaseUnit() — lines 3086-3097

```javascript
L3086 | function setGlobalBaseUnit(value='',preserveExisting=true){
L3087 |  const select=$('globalBaseUnitChoice'),backing=$('globalBaseUnit');
L3088 |  if(!select||!backing)return;
L3089 |  const current=String(value||'').trim(),unitClass=$('globalUnitClass')?.value||'other';
L3090 |  const choices=CF_BASE_UNIT_SUGGESTIONS[unitClass]||[];
L3091 |  const legacy=!!(preserveExisting&&current&&!choices.includes(current));
L3092 |  select.innerHTML='<option value="">اختر الوحدة الأساسية</option>'+choices.map(item=>'<option value="'+esc(item)+'">'+esc(item)+'</option>').join('')+(legacy?'<option value="'+esc(current)+'" data-legacy="true">'+esc(current)+' — وحدة محفوظة من سجل سابق</option>':'');
L3093 |  select.value=current&&(choices.includes(current)||legacy)?current:'';
L3094 |  backing.value=select.value;
L3095 |  const hint=$('globalBaseUnitHint');
L3096 |  if(hint)hint.textContent=unitClass==='mass'?'وحدات الكتلة المتاحة: كجم، جرام، ملجم، طن، رطل وغيرها من الوحدات المعتمدة.':unitClass==='count'?'وحدات العدد المتاحة: قطعة، علبة، كرتونة، عبوة وغيرها.':'اختر وحدة من القائمة المقيدة حسب نمط القياس؛ القيم القديمة تظهر للقراءة والتحرير فقط.';
L3097 | }
```

### setClientBaseUnit() — lines 3098-3105

```javascript
L3098 | function setClientBaseUnit(value='',preserveExisting=true){
L3099 |  const select=$('clientProductUnit');if(!select)return;
L3100 |  const current=String(value||'').trim(),unitClass=$('clientUnitClass')?.value||'other';
L3101 |  const choices=CF_BASE_UNIT_SUGGESTIONS[unitClass]||[];
L3102 |  const legacy=!!(preserveExisting&&current&&!choices.includes(current));
L3103 |  select.innerHTML='<option value="">اختر الوحدة الأساسية</option>'+choices.map(item=>'<option value="'+esc(item)+'">'+esc(item)+'</option>').join('')+(legacy?'<option value="'+esc(current)+'" data-legacy="true">'+esc(current)+' — وحدة محفوظة</option>':'');
L3104 |  select.value=current&&(choices.includes(current)||legacy)?current:'';
L3105 | }
```

### bindGlobalBaseUnitSelector() — lines 3106-3121

```javascript
L3106 | function bindGlobalBaseUnitSelector(){
L3107 |  const select=$('globalBaseUnitChoice'),unitClass=$('globalUnitClass'),clientUnitClass=$('clientUnitClass');
L3108 |  if(!select||select.dataset.bound==='true')return;
L3109 |  select.dataset.bound='true';
L3110 |  select.addEventListener('change',()=>getGlobalBaseUnitValue());
L3111 |  unitClass?.addEventListener('change',()=>{
L3112 |   const current=getGlobalBaseUnitValue(),dimension=inferProductUnitClass(current);
L3113 |   const keep=current&&(CF_BASE_UNIT_SUGGESTIONS[unitClass.value]||[]).includes(current);
L3114 |   setGlobalBaseUnit(keep?current:(unitClass.value==='mass'?'كجم':''),false);
L3115 |  });
L3116 |  clientUnitClass?.addEventListener('change',()=>{
L3117 |   const current=$('clientProductUnit')?.value||'';
L3118 |   const choices=CF_BASE_UNIT_SUGGESTIONS[clientUnitClass.value]||[];
L3119 |   setClientBaseUnit(choices.includes(current)?current:'',false);
L3120 |  });
L3121 | }
```

### switchGlobalProductTab() — lines 3122-3130

```javascript
L3122 | function switchGlobalProductTab(tab='basic',focus=false){
L3123 |  const keys=['basic','units','advanced'],active=keys.includes(tab)?tab:'basic';
L3124 |  keys.forEach(key=>{
L3125 |   const panel=$('globalProductPanel-'+key),button=$('globalProductTab-'+key),selected=key===active;
L3126 |   panel?.classList.toggle('hidden',!selected);
L3127 |   if(button){button.setAttribute('aria-selected',String(selected));button.tabIndex=selected?0:-1;button.classList.toggle('active',selected);}
L3128 |  });
L3129 |  if(focus)$('globalProductTab-'+active)?.focus();
L3130 | }
```

### bindGlobalProductTabs() — lines 3131-3152

```javascript
L3131 | function bindGlobalProductTabs(){
L3132 |  const host=$('globalProductEditorTabs');
L3133 |  if(!host||host.dataset.bound==='true')return;
L3134 |  host.dataset.bound='true';
L3135 |  host.addEventListener('click',event=>{
L3136 |   const button=event.target.closest('[data-global-product-tab]');
L3137 |   if(button)switchGlobalProductTab(button.dataset.globalProductTab);
L3138 |  });
L3139 |  host.addEventListener('keydown',event=>{
L3140 |   const button=event.target.closest('[data-global-product-tab]');
L3141 |   if(!button)return;
L3142 |   const keys=['basic','units','advanced'],index=keys.indexOf(button.dataset.globalProductTab);
L3143 |   if(index<0)return;
L3144 |   let next=index;
L3145 |   if(event.key==='ArrowLeft')next=(index+1)%keys.length;
L3146 |   else if(event.key==='ArrowRight')next=(index-1+keys.length)%keys.length;
L3147 |   else if(event.key==='Home')next=0;
L3148 |   else if(event.key==='End')next=keys.length-1;
L3149 |   else return;
L3150 |   event.preventDefault();switchGlobalProductTab(keys[next],true);
L3151 |  });
L3152 | }
```

### switchCatalogView() — lines 3154-3169

```javascript
L3154 | function switchCatalogView(view){
L3155 |   const allowed=['global','project'];state.catalogView=allowed.includes(view)?view:'global';
L3156 |   $('catalogGlobalView').classList.toggle('hidden',state.catalogView!=='global');
L3157 |   $('catalogWorkspaceSelector').classList.remove('hidden');
L3158 |   $('projectProductsView').classList.toggle('hidden',state.catalogView!=='project');
L3159 |   $('projectProductScopeNotice').classList.toggle('hidden',!!state.project);
L3160 |   $('projectProductsContent').classList.toggle('hidden',!state.project);
L3161 |   $('catalogProductEditor').classList.add('hidden');
L3162 |   if($('catalogMode'))$('catalogMode').value=state.catalogView;
L3163 |   if(state.catalogView==='project'){
L3164 |    renderProductImportSessions();
L3165 |    if(state.project)loadProductsPage(1,$('productSearch')?.value.trim()||'').catch(e=>fail('تعذر تحميل أصناف ملف التكليف',e));
L3166 |   }else{
L3167 |    refreshClientCatalogPermission().then(()=>loadCatalog()).catch(e=>fail('تعذر تحميل دليل الأصناف الموحد',e));
L3168 |   }
L3169 |  }
```

### attachClientCatalogProductToProject() — lines 3170-3196

```javascript
L3170 | async function attachClientCatalogProductToProject(clientProductId,button=null){
L3171 |  const project=state.project,clientId=state.catalogClientId;
L3172 |  if(!project?.id||!project.client_id)return notify('ملف التكليف الحالي غير مرتبط بمؤسسة؛ لا يمكن ربط أصناف دليل المؤسسة به.',true);
L3173 |  if(clientId!==project.client_id)return notify('اختر نفس المؤسسة المرتبطة بملف التكليف قبل الإضافة.',true);
L3174 |  if(!state.platformOwner&&!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة دليل المؤسسة.',true);
L3175 |  if((state.sessions||[]).some(item=>['active','paused','review'].includes(item.status)))return notify('قائمة الأصناف مقفلة أثناء جلسة جرد نشطة أو متوقفة أو قيد المراجعة. أتمم الجلسة أولاً.',true);
L3176 |  const mapping=(state.catalogClientRows||[]).find(item=>item.id===clientProductId&&item.is_active);
L3177 |  if(!mapping)return notify('مواءمة المؤسسة غير نشطة أو لم تعد متاحة. حدّث الدليل ثم أعد المحاولة.',true);
L3178 |  const product=(state.catalogProducts||[]).find(item=>item.id===mapping.catalog_product_id);
L3179 |  if(!product||!product.is_active)return notify('الصنف العالمي غير نشط أو لم يعد متاحاً.',true);
L3180 |  const projectId=project.id;
L3181 |  if(button)button.disabled=true;
L3182 |  try{
L3183 |   const {data,error}=await db.rpc('count_attach_catalog_product',{
L3184 |    p_project_id:projectId,p_client_product_id:clientProductId,p_expected_qty:null
L3185 |   });
L3186 |   if(error)throw error;
L3187 |   if(state.project?.id!==projectId)return;
L3188 |   await loadProductsPage(1,state.productQuery||'');
L3189 |   $('kProducts').textContent=String(state.productTotal||0);
L3190 |   notify(data?.already_linked
L3191 |    ?'هذا الصنف مرتبط بالفعل بملف التكليف؛ لم يُنشأ سجل مكرر.'
L3192 |    :'تم إضافة الصنف ونسخ وحدته الأساسية ووحداته البديلة وباركوداتها إلى أصناف التكليف. لم يُنشأ رصيد مرجعي أو حركة جرد.');
L3193 |  }catch(error){
L3194 |   fail('تعذر ربط صنف المؤسسة بملف التكليف',error);
L3195 |  }finally{if(button)button.disabled=false;}
L3196 | }
```

### updateCatalogImportActions() — lines 3197-3202

```javascript
L3197 | function updateCatalogImportActions(){
L3198 |  const client=state.clients.find(item=>item.id===state.catalogClientId&&item.status==='active');
L3199 |  const allowed=!!(state.platformOwner&&client);
L3200 |  const button=$('catalogOpenClientImport');if(button){button.disabled=!allowed;button.title=allowed?'استيراد ملف أصناف إلى '+client.name:'اختر مؤسسة نشطة أولاً؛ استيراد المؤسسة متاح لمالك المنصة فقط.';}
L3201 |  const target=$('clientCatalogImportTarget');if(target)target.textContent=client?'وجهة الاستيراد: '+client.name+' · '+client.code+'. الأصناف المطابقة ستُربط دون تعديل بيانات الصنف العالمي؛ الناقص فقط سيُنشأ ثم يُربط.':'اختر مؤسسة نشطة من محدد المؤسسة أعلى الدليل.';
L3202 | }
```

### searchGlobalCatalogBeforeManualAdd() — lines 3203-3228

```javascript
L3203 | async function searchGlobalCatalogBeforeManualAdd(){
L3204 |  if(!state.platformOwner)return notify('البحث في الدليل العالمي متاح لمالك المنصة فقط.',true);
L3205 |  const term=String($('globalCatalogLookupInput')?.value||'').trim();
L3206 |  const host=$('globalCatalogLookupResults');if(!term){host.textContent='اكتب باركوداً أو SKU أو اسماً للبحث.';return;}
L3207 |  if(term.length<2){host.textContent='أدخل حرفين على الأقل للبحث بالاسم.';return;}
L3208 |  const button=$('globalCatalogLookupButton');button.disabled=true;host.textContent='جار البحث في الدليل العالمي…';
L3209 |  try{
L3210 |   const projection='id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path';
L3211 |   const [barcode,sku,unit,name]=await Promise.all([
L3212 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('barcode',term).limit(5),
L3213 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('canonical_sku',term).limit(5),
L3214 |    db.from('count_catalog_products').select(projection).eq('is_active',true).contains('units',[{barcode:term}]).limit(5),
L3215 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('name','%'+term.replace(/[%_,]/g,' ').slice(0,80)+'%').order('name',{ascending:true}).limit(8)
L3216 |   ]);
L3217 |   for(const result of [barcode,sku,unit,name])if(result.error)throw result.error;
L3218 |   const products=new Map();for(const result of [barcode,sku,unit,name])for(const item of result.data||[])products.set(item.id,item);
L3219 |   const rows=[...products.values()].slice(0,12);
L3220 |   if(!rows.length){host.innerHTML='<div class="empty">لم يُعثر على تطابق. يمكنك إغلاق البحث ومتابعة إضافة صنف جديد.</div>';return;}
L3221 |   host.innerHTML='<div class="hint">تم العثور على '+rows.length+' نتيجة؛ اختر الصنف المطابق لفتح سجله الحالي وتجنب إنشاء نسخة أخرى.</div><div class="cf-catalog-lookup-results">'+rows.map(item=>'<div class="cf-catalog-lookup-result"><div><b>'+esc(item.name)+'</b><small>SKU: '+esc(item.canonical_sku||'—')+' · باركود: '+esc(item.barcode||'—')+' · وحدة الأساس: '+esc(item.base_unit||'—')+'</small></div><button type="button" class="soft" data-use-global-lookup="'+esc(item.id)+'">فتح الصنف</button></div>').join('')+'</div>';
L3222 |   host.querySelectorAll('[data-use-global-lookup]').forEach(choice=>choice.onclick=()=>{
L3223 |    const selected=rows.find(item=>item.id===choice.dataset.useGlobalLookup);
L3224 |    if(selected)openUnifiedCatalogItem(selected).catch(error=>fail('تعذر فتح الصنف المطابق',error));
L3225 |   });
L3226 |  }catch(error){host.textContent='تعذر البحث حالياً. '+friendlyErrorMessage(error);fail('تعذر البحث في الدليل العالمي',error);}
L3227 |  finally{button.disabled=false;}
L3228 | }
```

### bindCatalogImportActions() — lines 3229-3238

```javascript
L3229 | function bindCatalogImportActions(){
L3230 |  const globalButton=$('catalogOpenGlobalImport'),clientButton=$('catalogOpenClientImport');
L3231 |  if(globalButton)globalButton.onclick=()=>{if(!state.platformOwner)return notify('استيراد الدليل العالمي متاح لمالك المنصة فقط.',true);const panel=$('globalCatalogImportTools');panel.open=true;panel.scrollIntoView({behavior:'smooth',block:'start'});$('globalCatalogImportFile').focus();};
L3232 |  if(clientButton)clientButton.onclick=()=>{updateCatalogImportActions();if(clientButton.disabled)return notify('اختر مؤسسة نشطة أولاً.',true);const panel=$('clientCatalogImportTools');panel.open=true;panel.scrollIntoView({behavior:'smooth',block:'start'});$('clientCatalogImportFile').focus();};
L3233 |  $('clientCatalogImportPreview').onclick=previewClientCatalogImport;
L3234 |  $('clientCatalogImportCommit').onclick=commitClientCatalogImport;
L3235 |  $('clientCatalogImportReset').onclick=resetClientCatalogImport;
L3236 |  $('globalCatalogLookupButton').onclick=searchGlobalCatalogBeforeManualAdd;
L3237 |  $('globalCatalogLookupInput').addEventListener('keydown',event=>{if(event.key==='Enter'){event.preventDefault();searchGlobalCatalogBeforeManualAdd();}});
L3238 | }
```

### openGlobalProductEditor() — lines 3239-3256

```javascript
L3239 | function openGlobalProductEditor(product=null){
L3240 |  if(!state.platformOwner)return notify('لا تملك صلاحية تعديل بيانات الصنف الأساسية.',true);
L3241 |  const p=product||null;resetGlobalImagePreview();state.globalImageCleared=false;
L3242 |  $('globalProductForm').classList.remove('hidden');$('unifiedProductReadOnlySummary')?.classList.add('hidden');
L3243 |  $('globalProductForm').reset();$('globalProductId').value=p?.id||'';$('globalSku').value=p?.canonical_sku||'';$('globalBarcode').value=p?.barcode||'';$('globalName').value=p?.name||'';$('globalBrand').value=p?.brand||'';setCatalogCategoryPicker('global',p?.category||'');$('globalBaseUnit').value=p?.base_unit||'';$('globalImageFile').value='';
L3244 |  $('globalImageCurrent').textContent=p?.image_storage_path?'جار تجهيز معاينة الصورة…':'لا توجد صورة مرتبطة بهذا الصنف.';
L3245 |  renderCatalogUnitEditor('globalProductUnitsEditor',p?.units||[]);setUnitMetaFields('global',p?.units||[],$('globalBaseUnit').value);
L3246 |  if(!p){$('globalItemKind').value='BARCODED';$('globalBarcodeType').value='AUTO';$('globalUnitClass').value='other';$('globalUnitPrecision').value='3';}
L3247 |  $('globalCatalogLookupPanel')?.classList.toggle('hidden',!!p);
L3248 |  if($('globalCatalogLookupResults'))$('globalCatalogLookupResults').textContent='';
L3249 |  if($('globalCatalogLookupInput')&&!p)$('globalCatalogLookupInput').value='';
L3250 |  setGlobalBaseUnit(p?.base_unit||'',true);renderGlobalBarcodeStatus();
L3251 |  $('globalProductFormTitle').textContent=p?'تفاصيل الصنف وتعديل بياناته':'إضافة صنف جديد';$('globalProductSave').textContent=p?'حفظ بيانات الصنف':'إضافة الصنف';
L3252 |  $('catalogGlobalView').classList.add('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.add('hidden');$('catalogProductEditor').classList.remove('hidden');
L3253 |  $('clientCatalogEditorShell')?.classList.add('hidden');resetClientProductForm();
L3254 |  if(p?.image_storage_path)loadGlobalProductImagePreview(p).catch(error=>console.warn('Global image preview failed',error));
L3255 |  switchGlobalProductTab('basic');window.scrollTo({top:0,behavior:'smooth'});
L3256 | }
```

### closeGlobalProductEditor() — lines 3257-3261

```javascript
L3257 | function closeGlobalProductEditor(){
L3258 |  $('catalogProductEditor').classList.add('hidden');$('catalogGlobalView').classList.remove('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.remove('hidden');
L3259 |  state.catalogView='global';if($('catalogMode'))$('catalogMode').value='global';
L3260 |  $('globalProductForm').classList.remove('hidden');$('globalProductForm').reset();setCatalogCategoryPicker('global','');$('globalProductId').value='';$('globalProductSave').textContent='إضافة الصنف';$('globalImageCurrent').textContent='';state.globalImageCleared=false;resetGlobalImagePreview();renderCatalogUnitEditor('globalProductUnitsEditor',[]);renderGlobalBarcodeStatus();resetClientProductForm();
L3261 | }
```

### openUnifiedCatalogItem() — lines 3262-3298

```javascript
L3262 | async function openUnifiedCatalogItem(product){
L3263 |  if(!product)return;
L3264 |  const clientId=state.catalogClientId;
L3265 |  await refreshClientCatalogPermission();
L3266 |  if(state.platformOwner)openGlobalProductEditor(product);
L3267 |  else{
L3268 |   $('globalProductForm').classList.add('hidden');
L3269 |   $('catalogGlobalView').classList.add('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.add('hidden');
L3270 |   $('catalogProductEditor').classList.remove('hidden');
L3271 |   let summary=$('unifiedProductReadOnlySummary');
L3272 |   if(!summary){summary=document.createElement('div');summary.id='unifiedProductReadOnlySummary';summary.className='panel';$('catalogProductEditor').prepend(summary);}
L3273 |   summary.classList.remove('hidden');
L3274 |   summary.innerHTML='<h3>بيانات الصنف الأساسية — عرض فقط</h3><p><b>'+esc(product.name)+'</b></p><p class="hint">SKU: '+esc(product.canonical_sku||'—')+' · الباركود: '+esc(product.barcode||'—')+' · وحدة الأساس: '+esc(product.base_unit||'—')+'</p>';
L3275 |  }
L3276 |  if(!clientId){notify('اختر المؤسسة أولاً لعرض أو تعديل بياناتها المحلية.',true);return;}
L3277 |  if(!state.canManageClientCatalog){notify('حسابك يستطيع عرض الصنف، ولا يملك صلاحية تعديل بيانات المؤسسة.',true);return;}
L3278 |  const mapping=(state.catalogClientRows||[]).find(x=>x.catalog_product_id===product.id)||null;
L3279 |  $('clientProductForm').reset();
L3280 |  $('clientProductCatalog').innerHTML='<option value="'+esc(product.id)+'">'+esc(product.name)+'</option>';
L3281 |  $('clientProductCatalog').value=product.id;
L3282 |  $('clientProductSku').value=mapping?.client_sku||'';
L3283 |  $('clientProductBarcode').value=mapping?.client_barcode||'';
L3284 |  $('clientProductName').value=mapping?.name_override||'';
L3285 |  setCatalogCategoryPicker('client',mapping?.category_override||'');
L3286 |  $('clientProductImagePath').value=mapping?.image_storage_path_override||'';
L3287 |  const custom=!!(mapping?.base_unit_override||mapping?.units_override);
L3288 |  $('clientUnitsOverrideToggle').checked=custom;
L3289 |  $('clientUnitsOverrideFields').classList.toggle('hidden',!custom);
L3290 |  setUnitMetaFields('client',mapping?.units_override||product.units||[], mapping?.base_unit_override||product.base_unit||'');
L3291 |  setClientBaseUnit(mapping?.base_unit_override||product.base_unit||'',true);
L3292 |  renderCatalogUnitEditor('clientProductUnitsEditor',mapping?.units_override||[]);
L3293 |  $('clientProductFormTitle').textContent=mapping?'تعديل بيانات المؤسسة لهذا الصنف':'إضافة بيانات المؤسسة لهذا الصنف';
L3294 |  openClientCatalogEditor();
L3295 |  $('catalogProductEditor').classList.remove('hidden');
L3296 |  $('catalogGlobalView').classList.add('hidden');
L3297 |  window.scrollTo({top:0,behavior:'smooth'});
L3298 | }
```

### resetClientProductForm() — lines 3299-3301

```javascript
L3299 | function resetClientProductForm(){
L3300 |  $('clientProductForm').reset();setCatalogCategoryPicker('client','');$('clientProductImagePath').value='';$('clientUnitClass').value='other';$('clientUnitPrecision').value='3';$('clientProductFormTitle').textContent='مواءمة صنف للمؤسسة';$('clientUnitsOverrideFields').classList.add('hidden');setClientBaseUnit('',false);renderCatalogUnitEditor('clientProductUnitsEditor',[]);$('clientCatalogEditorShell')?.classList.add('hidden');
L3301 | }
```

### openClientCatalogEditor() — lines 3302-3305

```javascript
L3302 | function openClientCatalogEditor(){
L3303 |  if(!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة مواءمات المؤسسة.',true);
L3304 |  $('clientCatalogEditorShell').classList.remove('hidden');$('clientProductSku')?.focus();$('clientCatalogEditorShell').scrollIntoView({behavior:'smooth',block:'start'});
L3305 | }
```

### appendCatalogUnitRow() — lines 3306-3306

```javascript
L3306 | function appendCatalogUnitRow(id){const el=$(id);if(!el)return;const row=document.createElement('div');row.className='product-unit-row';row.dataset.catalogUnitRow='';row.innerHTML='<div class="field"><label>اسم الوحدة البديلة</label><input data-catalog-unit-name maxlength="40"></div><div class="field"><label>كم تعادل من وحدة الأساس؟</label><input data-catalog-unit-factor type="number" min="0.000001" step="0.000001"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-catalog-unit-barcode maxlength="120"></div><div class="field"><label>نوع الرمز</label><select data-catalog-unit-barcode-type><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128</option></select></div><button type="button" class="danger" data-catalog-unit-remove>إزالة</button>';el.appendChild(row);row.querySelector('[data-catalog-unit-remove]').onclick=()=>{row.remove();if(!el.querySelector('[data-catalog-unit-row]'))renderCatalogUnitEditor(id,[]);};}
```

### refreshClientCatalogPermission() — lines 3307-3313

```javascript
L3307 | function refreshClientCatalogPermission(){
L3308 |  const id=state.catalogClientId,shell=$('clientCatalogEditorShell'),panel=$('clientProductEditorPanel');
L3309 |  if(!id){state.canManageClientCatalog=false;panel?.classList.add('hidden');shell?.classList.add('hidden');return Promise.resolve(false);}
L3310 |  const apply=allowed=>{state.canManageClientCatalog=!!allowed;panel?.classList.toggle('hidden',!allowed);if(!allowed)shell?.classList.add('hidden');return state.canManageClientCatalog;};
L3311 |  if(state.platformOwner)return Promise.resolve(apply(true));
L3312 |  return db.rpc('count_has_client_permission',{p_client_id:id,p_permission_code:'catalog.manage'}).then(({data,error})=>apply(!error&&data===true));
L3313 | }
```

### renderProductUnitEditor() — lines 3314-3322

```javascript
L3314 | function renderProductUnitEditor(units=[]){
L3315 |   const container=$('productUnitsEditor');if(!container)return;
L3316 |   const rows=productUnitRows(units).map(u=>({name:String(u?.name||''),factor_to_base:String(u?.factor_to_base??u?.conversion_factor??u?.factor??''),barcode:String(u?.barcode||''),barcode_type:String(u?.barcode_type||'AUTO')}));
L3317 |   container.innerHTML=(rows.length?rows:[{name:'',factor_to_base:'',barcode:'',barcode_type:'AUTO'}]).map((u,i)=>'<div class="product-unit-row" data-product-unit-row><div class="field"><label>اسم الوحدة البديلة</label><input data-unit-name value="'+esc(u.name)+'" maxlength="40" placeholder="مثال: كرتونة"></div><div class="field"><label>كم تعادل من الوحدة الأساسية؟</label><input data-unit-factor type="number" min="0.000001" step="0.000001" value="'+esc(u.factor_to_base)+'" placeholder="مثال: 12"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-unit-barcode value="'+esc(u.barcode)+'" maxlength="120"></div><div class="field"><label>نوع الرمز</label><select data-unit-barcode-type><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128</option></select></div><button type="button" class="danger" data-remove-product-unit aria-label="إزالة الوحدة">إزالة</button></div>').join('');
L3318 |   container.querySelectorAll('[data-remove-product-unit]').forEach(button=>button.onclick=()=>{
L3319 |    button.closest('[data-product-unit-row]')?.remove();
L3320 |    if(!container.querySelector('[data-product-unit-row]'))renderProductUnitEditor([]);
L3321 |   });
L3322 |  }
```

### readProductUnits() — lines 3323-3336

```javascript
L3323 | function readProductUnits(baseUnit,primaryBarcode=null){
L3324 |   const rows=[...$('productUnitsEditor').querySelectorAll('[data-product-unit-row]')],units=[],seen=new Set(),codes=new Set(),base=String(baseUnit||'').trim().toLocaleLowerCase();if(primaryBarcode)codes.add(String(primaryBarcode).trim().toLowerCase());
L3325 |   for(const row of rows){
L3326 |    const name=row.querySelector('[data-unit-name]').value.trim(),raw=row.querySelector('[data-unit-factor]').value.trim(),barcode=row.querySelector('[data-unit-barcode]')?.value.trim()||'',requested=row.querySelector('[data-unit-barcode-type]')?.value||'AUTO';
L3327 |    if(!name&&!raw&&!barcode)continue;
L3328 |    if(!name||!raw)throw new Error('أكمل اسم الوحدة البديلة ومعامل التحويل معاً.');
L3329 |    const key=name.toLocaleLowerCase(),factor=Number(raw);
L3330 |    if(key===base)throw new Error('الوحدة البديلة يجب أن تختلف عن الوحدة الأساسية.');
L3331 |    if(seen.has(key))throw new Error('لا تكرر اسم الوحدة البديلة في الصنف نفسه.');
L3332 |    if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل التحويل يجب أن يكون رقماً موجباً وصالحاً.');
L3333 |    const unit={name,factor_to_base:factor};if(barcode){const type=cfResolveBarcodeType(barcode,requested);if(codes.has(barcode.toLowerCase()))throw new Error('لا يمكن تكرار باركود الصنف أو وحداته.');codes.add(barcode.toLowerCase());unit.barcode=barcode;unit.barcode_type=type;}seen.add(key);units.push(unit);
L3334 |   }
L3335 |   return units;
L3336 |  }
```

### showProductImagePreview() — lines 3337-3342

```javascript
L3337 | function showProductImagePreview(source,title,note=''){
L3338 |   const box=$('productImagePreview');if(!box)return;
L3339 |   if(!source){box.classList.add('hidden');$('productImagePreviewImg').removeAttribute('src');return;}
L3340 |   $('productImagePreviewImg').src=source;$('productImagePreviewTitle').textContent=title||'صورة الصنف';$('productImagePreviewNote').textContent=note||'تُحفظ الصورة داخل مساحة CountFlow الخاصة بهذا التكليف.';box.classList.remove('hidden');
L3341 |   $('clearProductImage').hidden=false;
L3342 |  }
```

### resetProductImagePreview() — lines 3343-3346

```javascript
L3343 | function resetProductImagePreview(){
L3344 |   if(state.productImagePreviewObjectUrl){URL.revokeObjectURL(state.productImagePreviewObjectUrl);state.productImagePreviewObjectUrl=null;}
L3345 |   $('productImageFile').value='';$('imageUrl').value='';$('productImagePreview').classList.add('hidden');$('productImagePreviewImg').removeAttribute('src');$('clearProductImage').hidden=true;
L3346 |  }
```

### uploadProductImage() — lines 3347-3356

```javascript
L3347 | async function uploadProductImage(file,projectId){
L3348 |   const extensions={'image/jpeg':'jpg','image/png':'png'};
L3349 |   const extension=extensions[file?.type];
L3350 |   if(!file||!extension)throw new Error('اختر صورة JPEG أو PNG؛ هذه الصيغ فقط مدعومة للتضمين في ملف Excel.');
L3351 |   if(file.size<=0||file.size>MAX_PRODUCT_IMAGE_BYTES)throw new Error('حجم الصورة يجب ألا يتجاوز 1MiB حتى يمكن تضمينها في ملف Excel.');
L3352 |   const path=projectId+'/products/'+crypto.randomUUID()+'.'+extension;
L3353 |   const {error}=await db.storage.from('counting-product-images').upload(path,file,{cacheControl:'3600',contentType:file.type,upsert:false});
L3354 |   if(error){console.warn('Product image upload failed',error);throw new Error('تعذر رفع الصورة. تحقق من اتصالك وصلاحية العضوية ثم أعد المحاولة.');}
L3355 |   return path;
L3356 |  }
```

### editProduct() — lines 3357-3364

```javascript
L3357 | async function editProduct(id){
L3358 |  const p=state.products.find(x=>x.id===id);if(!p)return;
L3359 |  $('projectProductEditorPanel').classList.remove('hidden');$('projectProductWorkspace').classList.add('cf-catalog-editor-open');
L3360 |  resetProductImagePreview();$('productId').value=p.id;$('sku').value=p.sku;$('barcode').value=p.barcode||'';$('productName').value=p.name||'';$('category').value=p.category||'';$('baseUnit').value=p.base_unit;$('expectedQty').value=p.expected_qty??'';
L3361 |  state.editingProductImageRef=p.image_url||null;state.productImageCleared=false;$('imageUrl').value=safeExternalProductImageUrl(p.image_url);
L3362 |  const displayUrl=productImageDisplayUrl(p);if(displayUrl)showProductImagePreview(displayUrl,'الصورة الحالية للصنف','هذه الصورة محفوظة في مساحة CountFlow الخاصة. عند الاستبدال أو إزالة الربط يبقى الملف القديم في التخزين ولا يُحذف تلقائياً.');
L3363 |  renderProductUnitEditor(p.units||[]);setUnitMetaFields('unit',p.units||[],p.base_unit);$('productFormTitle').textContent='تعديل الصنف';$('projectProductEditorPanel').scrollIntoView({behavior:'smooth',block:'start'});
L3364 | }
```

### resetProductForm() — lines 3365-3368

```javascript
L3365 | function resetProductForm(){
L3366 |  $('productForm').reset();$('productId').value='';$('baseUnit').value='وحدة';$('unitClass').value='count';$('unitPrecision').value='0';$('unitItemKind').value='BARCODED';$('unitBarcodeType').value='AUTO';$('productFormTitle').textContent='إضافة صنف';
L3367 |  state.editingProductImageRef=null;state.productImageCleared=false;resetProductImagePreview();renderProductUnitEditor([]);$('projectProductEditorPanel')?.classList.add('hidden');$('projectProductWorkspace')?.classList.remove('cf-catalog-editor-open');
L3368 | }
```

### toggleProduct() — lines 3369-3373

```javascript
L3369 | async function toggleProduct(id){
L3370 |   const p=state.products.find(x=>x.id===id);if(!p)return;
L3371 |   const {error}=await db.from('count_products').update({is_active:!p.is_active,updated_at:new Date().toISOString()}).eq('id',id).eq('project_id',state.project.id);
L3372 |   if(error)return fail('تعذر تحديث حالة الصنف',error);notify(p.is_active?'تم إيقاف الصنف':'تم تفعيل الصنف');await loadProjectData();
L3373 |  }
```

### safeCatalogProductImagePath() — lines 3709-3714

```javascript
L3709 | function safeCatalogProductImagePath(product){
L3710 |  const id=String(product?.id||''),path=String(product?.image_storage_path||'');
L3711 |  if(!id||!path.startsWith('catalog/products/'+id+'/'))return '';
L3712 |  const name=path.slice(('catalog/products/'+id+'/').length);
L3713 |  return /^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$/.test(name)?path:'';
L3714 | }
```

### loadCatalogImageUrls() — lines 3715-3725

```javascript
L3715 | async function loadCatalogImageUrls(rows,requestToken){
L3716 |  const paths=[...new Set((rows||[]).filter(p=>p.is_active).map(safeCatalogProductImagePath).filter(Boolean))];
L3717 |  state.catalogImageUrls=new Map();
L3718 |  if(!paths.length||requestToken!==state.catalogRequestToken)return;
L3719 |  try{
L3720 |   const result=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L3721 |   if(result.error)throw result.error;
L3722 |   if(requestToken!==state.catalogRequestToken)return;
L3723 |   for(const item of result.data||[])if(item.path&&item.signedUrl)state.catalogImageUrls.set(item.path,item.signedUrl);
L3724 |  }catch(error){console.warn('Catalogue image preview URLs unavailable',error);}
L3725 | }
```

### catalogImageMarkup() — lines 3726-3731

```javascript
L3726 | function catalogImageMarkup(product){
L3727 |  const path=safeCatalogProductImagePath(product),url=path?state.catalogImageUrls.get(path):'';
L3728 |  if(url)return '<button type="button" class="cf-catalog-image-button" data-preview-catalog-image="'+esc(product.id)+'" aria-label="معاينة صورة '+esc(product.name||'الصنف')+'"><img class="cf-catalog-thumb" src="'+esc(url)+'" alt="" loading="lazy"></button>';
L3729 |  const hint=product.image_storage_path?(product.is_active?'تعذر تحميل الصورة':'الصورة غير متاحة للصنف الموقوف'):'لا توجد صورة';
L3730 |  return '<span class="cf-catalog-image-empty" title="'+esc(hint)+'" aria-label="'+esc(hint)+'"><i class="fa-regular fa-image" aria-hidden="true"></i></span>';
L3731 | }
```

### openCatalogImage() — lines 3732-3736

```javascript
L3732 | function openCatalogImage(product){
L3733 |  const path=safeCatalogProductImagePath(product),url=path?state.catalogImageUrls.get(path):'';
L3734 |  if(!url)return notify('صورة هذا الصنف غير متاحة للعرض حالياً.',true);
L3735 |  if(window.Swal?.fire)window.Swal.fire({title:product.name||'صورة الصنف',imageUrl:url,imageAlt:product.name||'صورة الصنف',imageWidth:720,showConfirmButton:false,showCloseButton:true,customClass:{popup:'cf-swal-popup'}});
L3736 | }
```

### resetGlobalImagePreview() — lines 3737-3741

```javascript
L3737 | function resetGlobalImagePreview(){
L3738 |  state.catalogEditorImageToken=(state.catalogEditorImageToken||0)+1;
L3739 |  if(state.globalImagePreviewObjectUrl){URL.revokeObjectURL(state.globalImagePreviewObjectUrl);state.globalImagePreviewObjectUrl=null;}
L3740 |  $('globalImagePreview').classList.add('hidden');$('globalImagePreviewImg').removeAttribute('src');$('globalImageFile').value='';
L3741 | }
```

### showGlobalImagePreview() — lines 3742-3745

```javascript
L3742 | function showGlobalImagePreview(url,title,note){
L3743 |  if(!url)return;
L3744 |  $('globalImagePreviewImg').src=url;$('globalImagePreviewTitle').textContent=title||'صورة الصنف';$('globalImagePreviewNote').textContent=note||'تُحفظ الصورة داخل مساحة CountFlow الخاصة.';$('globalImagePreview').classList.remove('hidden');
L3745 | }
```

### loadGlobalProductImagePreview() — lines 3746-3758

```javascript
L3746 | async function loadGlobalProductImagePreview(product){
L3747 |  resetGlobalImagePreview();
L3748 |  const token=state.catalogEditorImageToken,path=safeCatalogProductImagePath(product);
L3749 |  if(!path){$('globalImageCurrent').textContent='لا توجد صورة مرتبطة بهذا الصنف.';return;}
L3750 |  $('globalImageCurrent').textContent='جار تحميل معاينة الصورة المحفوظة…';
L3751 |  try{
L3752 |   const result=await db.storage.from('counting-product-images').createSignedUrl(path,3600);
L3753 |   if(token!==state.catalogEditorImageToken)return;
L3754 |   if(result.error||!result.data?.signedUrl)throw result.error||new Error('Signed image URL unavailable');
L3755 |   $('globalImageCurrent').textContent='الصورة الحالية محفوظة في مساحة CountFlow الخاصة.';
L3756 |   showGlobalImagePreview(result.data.signedUrl,'الصورة الحالية للصنف','رابط عرض مؤقت؛ لا يُحفظ الرابط داخل سجل الصنف.');
L3757 |  }catch(error){if(token===state.catalogEditorImageToken)$('globalImageCurrent').textContent='تعذر عرض الصورة الحالية؛ سيظل سجل الصنف محفوظاً.';console.warn('Global catalogue image preview failed',error);}
L3758 | }
```

### csvCell() — source lines 3759-3763

```javascript
L3759 | function csvCell(value){
L3760 |  let text=value===null||value===undefined?'':(typeof value==='object'?JSON.stringify(value):String(value));
L3761 |  if(typeof value==='string'&&/^[=+@-]/.test(text.trimStart()))text="'"+text;
L3762 |  return '"'+text.replace(/"/g,'""')+'"';
L3763 | }
```

### downloadCatalogCsv() — lines 3764-3770

```javascript
L3764 | function downloadCatalogCsv(filename,headers,rows){
L3765 |  const content='\uFEFF'+[headers,...rows].map(row=>row.map(csvCell).join(',')).join('\r\n');
L3766 |  const blob=new Blob([content],{type:'text/csv;charset=utf-8;'});
L3767 |  const url=URL.createObjectURL(blob),anchor=document.createElement('a');
L3768 |  anchor.href=url;anchor.download=filename;anchor.style.display='none';document.body.appendChild(anchor);anchor.click();anchor.remove();
L3769 |  setTimeout(()=>URL.revokeObjectURL(url),1500);
L3770 | }
```

### applyCatalogFilters() — lines 3774-3779

```javascript
L3774 | function applyCatalogFilters(query,filters){
L3775 |  if(filters.status==='active')query=query.eq('is_active',true);else if(filters.status==='inactive')query=query.eq('is_active',false);
L3776 |  if(filters.category)query=query.ilike('category','%'+filters.category+'%');
L3777 |  if(filters.term)query=query.or(['name','canonical_sku','barcode','brand'].map(k=>k+'.ilike.%'+filters.term+'%').join(','));
L3778 |  return query;
L3779 | }
```

### applyUnifiedCatalogFilters() — lines 3780-3799

```javascript
L3780 | async function applyUnifiedCatalogFilters(query,filters,clientId){
L3781 |  query=applyCatalogFilters(query,{...filters,term:''});
L3782 |  if(!filters.term)return {query};
L3783 |  const value=filters.term,conditions=['name','canonical_sku','barcode','brand'].map(k=>k+'.ilike.%'+value+'%');
L3784 |  if(clientId){
L3785 |   const ids=[];let offset=0,pageSize=500;
L3786 |   while(true){
L3787 |    const result=await db.from('count_client_products').select('catalog_product_id').eq('client_id',clientId)
L3788 |     .or(['client_sku','client_barcode','name_override','category_override'].map(k=>k+'.ilike.%'+value+'%').join(','))
L3789 |     .order('catalog_product_id',{ascending:true}).range(offset,offset+pageSize-1);
L3790 |    if(result.error)throw result.error;
L3791 |    const page=result.data||[];ids.push(...page.map(x=>x.catalog_product_id).filter(Boolean));
L3792 |    if(page.length<pageSize)break;offset+=pageSize;
L3793 |    if(ids.length>90000)throw new Error('تجاوز بحث المؤسسة 90,000 نتيجة؛ استخدم كلمة بحث أكثر تحديداً.');
L3794 |   }
L3795 |   const unique=[...new Set(ids)];
L3796 |   if(unique.length)conditions.push('id.in.('+unique.join(',')+')');
L3797 |  }
L3798 |  return {query:query.or(conditions.join(','))};
L3799 | }
```

### exportGlobalCatalogCsv() — lines 3800-3823

```javascript
L3800 | async function exportGlobalCatalogCsv(){
L3801 |  if(!state.user)return notify('سجّل الدخول أولاً.',true);
L3802 |  const button=$('catalogExport');button.disabled=true;
L3803 |  try{
L3804 |   const f=currentCatalogFilters(),rows=[],clientRows=new Map(),pageSize=500,clientId=state.catalogClientId;let offset=0;
L3805 |   while(true){
L3806 |    let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path').order(f.sort,{ascending:f.ascending}).order('id',{ascending:true});
L3807 |    const filtered=await applyUnifiedCatalogFilters(q,f,clientId);q=filtered.query.range(offset,offset+pageSize-1);
L3808 |    const result=await q;if(result.error)throw result.error;
L3809 |    const page=result.data||[];
L3810 |    if(clientId&&page.length){
L3811 |     const local=await db.from('count_client_products').select('catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',clientId).in('catalog_product_id',page.map(p=>p.id));
L3812 |     if(local.error)throw local.error;
L3813 |     for(const item of local.data||[])clientRows.set(item.catalog_product_id,item);
L3814 |    }
L3815 |    rows.push(...page);if(page.length<pageSize)break;offset+=pageSize;
L3816 |    if(rows.length>90000)throw new Error('تجاوزت النتائج 90,000 سجل؛ ضيّق البحث أو صدّر على دفعات أصغر.');
L3817 |   }
L3818 |   downloadCatalogCsv('CountFlow-unified-catalog-'+new Date().toISOString().slice(0,10)+'.csv',
L3819 |    ['SKU الأساسي','باركود الصنف الأساسي','اسم الصنف الأساسي','العلامة التجارية','التصنيف الأساسي','وحدة الأساس','الوحدات والتحويلات الأساسية JSON','SKU المؤسسة','باركود المؤسسة','اسم المؤسسة','تصنيف المؤسسة','وحدة الأساس للمؤسسة','وحدات المؤسسة JSON','الحالة العامة','حالة المؤسسة','مسار الصورة الخاص','مسار صورة المؤسسة الخاص'],
L3820 |    rows.map(p=>{const local=clientRows.get(p.id);return [p.canonical_sku,p.barcode,p.name,p.brand,p.category,p.base_unit,p.units,local?.client_sku,local?.client_barcode,local?.name_override,local?.category_override,local?.base_unit_override,local?.units_override,p.is_active?'نشط':'موقوف',local?(local.is_active?'نشط':'موقوف'):'غير مواءم',p.image_storage_path,local?.image_storage_path_override];}));
L3821 |   notify('تم تصدير '+rows.length.toLocaleString('ar-EG')+' صنفاً مع حقول المؤسسة المختارة.');
L3822 |  }catch(error){fail('تعذر تصدير دليل الأصناف الموحد',error);}finally{button.disabled=false;}
L3823 | }
```

### exportProjectCatalogCsv() — lines 3824-3839

```javascript
L3824 | async function exportProjectCatalogCsv(){
L3825 |  const project=state.project;if(!project)return notify('اختر ملف تكليف أولاً.',true);
L3826 |  const button=$('projectCatalogExport');button.disabled=true;
L3827 |  try{
L3828 |   const rows=[],pageSize=500;let offset=0;
L3829 |   while(true){
L3830 |    const result=await db.from('count_products').select('sku,barcode,name,category,base_unit,units,expected_qty,image_url,is_active').eq('project_id',project.id).order('name',{ascending:true}).order('id',{ascending:true}).range(offset,offset+pageSize-1);
L3831 |    if(result.error)throw result.error;const page=result.data||[];rows.push(...page);if(page.length<pageSize)break;offset+=pageSize;
L3832 |    if(rows.length>=200000)throw new Error('تجاوزت أصناف التكليف 200,000 سجل؛ يرجى تقسيم التصدير.');
L3833 |   }
L3834 |   downloadCatalogCsv('CountFlow-project-products-'+String(project.project_code||project.id).replace(/[^A-Za-z0-9_-]/g,'-')+'-'+new Date().toISOString().slice(0,10)+'.csv',
L3835 |    ['SKU','الباركود','اسم الصنف','التصنيف','وحدة الأساس','الوحدات JSON','الكمية المرجعية','مرجع الصورة','الحالة'],
L3836 |    rows.map(p=>[p.sku,p.barcode,p.name,p.category,p.base_unit,p.units,p.expected_qty,p.image_url,p.is_active?'نشط':'موقوف']));
L3837 |   notify('تم تصدير '+rows.length.toLocaleString('ar-EG')+' صنفاً من التكليف المحدد.');
L3838 |  }catch(error){fail('تعذر تصدير أصناف التكليف',error);}finally{button.disabled=false;}
L3839 | }
```

### loadCatalog() — lines 3840-3877

```javascript
L3840 | async function loadCatalog(){
L3841 |  if(!state.user)return;
L3842 |  const requestToken=state.catalogRequestToken=(state.catalogRequestToken||0)+1;
L3843 |  const filters=currentCatalogFilters(),sort=filters.sort,table=$('catalogTable');
L3844 |  table?.setAttribute('aria-busy','true');
L3845 |  try{
L3846 |   let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path',{count:'exact'}).order(sort,{ascending:state.catalogSortAsc}).order('id',{ascending:true});
L3847 |   const filtered=await applyUnifiedCatalogFilters(q,filters,state.catalogClientId);
L3848 |   const size=50,page=Math.max(1,Number(state.catalogPage)||1);q=filtered.query.range((page-1)*size,page*size-1);
L3849 |   const x=await q;if(x.error)throw x.error;if(requestToken!==state.catalogRequestToken)return;
L3850 |   state.catalogProducts=x.data||[];state.catalogTotal=Number(x.count||0);
L3851 |   const scopedClient=state.catalogClientId,productIds=state.catalogProducts.map(p=>p.id);
L3852 |   state.catalogClientRows=[];
L3853 |   if(scopedClient&&productIds.length){
L3854 |    const local=await db.from('count_client_products').select('id,client_id,catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',scopedClient).in('catalog_product_id',productIds);
L3855 |    if(local.error)throw local.error;state.catalogClientRows=local.data||[];
L3856 |   }
L3857 |   await loadCatalogImageUrls(state.catalogProducts,requestToken);if(requestToken!==state.catalogRequestToken)return;
L3858 |   $('catalogResultCount').textContent=state.catalogTotal.toLocaleString('ar-EG')+' صنفاً في الدليل'+(scopedClient?' · مع بيانات المؤسسة المختارة':'');
L3859 |   const localByProduct=new Map((state.catalogClientRows||[]).map(r=>[r.catalog_product_id,r]));
L3860 |   table.innerHTML=state.catalogProducts.length?'<table class="cf-catalog-table"><thead><tr><th>الصورة</th><th>#</th><th><button class="cf-catalog-sort" data-sort-catalog="name" type="button">الصنف '+(sort==='name'?(state.catalogSortAsc?'↑':'↓'):'↕')+'</button></th><th><button class="cf-catalog-sort" data-sort-catalog="canonical_sku" type="button">SKU الأساسي '+(sort==='canonical_sku'?(state.catalogSortAsc?'↑':'↓'):'↕')+'</button></th><th>بيانات المؤسسة المختارة</th><th><button class="cf-catalog-sort" data-sort-catalog="barcode" type="button">الباركود الأساسي '+(sort==='barcode'?(state.catalogSortAsc?'↑':'↓'):'↕')+'</button></th><th><button class="cf-catalog-sort" data-sort-catalog="category" type="button">التصنيف</button></th><th><button class="cf-catalog-sort" data-sort-catalog="base_unit" type="button">وحدة الأساس</button></th><th>الوحدات البديلة</th><th>الحالة</th></tr></thead><tbody>'+state.catalogProducts.map((p,i)=>{const units=productUnitRows(Array.isArray(p.units)?p.units:[]),m=localByProduct.get(p.id),localMarkup=scopedClient?(m?'<b>'+esc(m.name_override||p.name)+'</b><span class="sub">SKU: '+esc(m.client_sku||'—')+' · باركود: '+esc(m.client_barcode||'—')+'</span>':'<span class="muted">لا توجد بيانات محلية</span>'):'<span class="muted">اختر مؤسسة لعرض الحقول المحلية</span>';const localEdit=state.canManageClientCatalog&&scopedClient?'<button class="soft" type="button" data-edit-client-map="'+esc(p.id)+'">'+(m?'بيانات المؤسسة':'إضافة بيانات المؤسسة')+'</button>':'';const attachScope=!!(state.project?.client_id&&state.project.client_id===scopedClient&&state.canManageClientCatalog&&m?.id&&m.is_active&&p.is_active),attachLocked=(state.sessions||[]).some(session=>['active','paused','review'].includes(session.status)),projectAttach=attachScope?'<button class="soft" type="button" data-attach-client-catalog-product="'+esc(m.id)+'" '+(attachLocked?'disabled title="مقفول أثناء جلسة الجرد"':'')+'>إضافة إلى التكليف المحدد</button>':'';const actions=(state.platformOwner?'<button class="soft" type="button" data-edit-catalog="'+esc(p.id)+'">فتح التفاصيل</button><button class="'+(p.is_active?'danger':'soft')+'" type="button" data-catalog-state="'+esc(p.id)+'">'+(p.is_active?'إيقاف':'تفعيل')+'</button>':'')+localEdit+projectAttach;return '<tr tabindex="0" data-open-catalog-item="'+esc(p.id)+'" aria-label="فتح تفاصيل '+esc(p.name)+'"><td>'+catalogImageMarkup(p)+'</td><td>'+((page-1)*size+i+1)+'</td><td><b>'+esc(p.name)+'</b><span class="sub">'+esc(p.brand||'صنف عام')+'</span></td><td>'+esc(p.canonical_sku||'—')+'</td><td>'+localMarkup+'</td><td><span dir="ltr">'+esc(p.barcode||'—')+'</span></td><td>'+esc(p.category||'—')+'</td><td>'+esc(p.base_unit||'—')+'</td><td>'+units.length+'</td><td>'+statusPill(p.is_active?'active':'paused')+'<div class="cf-inline-actions">'+actions+'</div></td></tr>';}).join('')+'</tbody></table>':'<div class="empty">لا توجد أصناف مطابقة للبحث والمرشحات الحالية.</div>';
L3861 |   table.querySelectorAll('[data-preview-catalog-image]').forEach(b=>b.onclick=e=>{e.stopPropagation();const p=state.catalogProducts.find(x=>x.id===b.dataset.previewCatalogImage);if(p)openCatalogImage(p);});
L3862 |   table.querySelectorAll('[data-sort-catalog]').forEach(b=>b.onclick=e=>{e.stopPropagation();const k=b.dataset.sortCatalog;if(state.catalogSort===k)state.catalogSortAsc=!state.catalogSortAsc;else{state.catalogSort=k;state.catalogSortAsc=true;}state.catalogPage=1;loadCatalog().catch(e=>fail('تعذر ترتيب الأصناف',e));});
L3863 |   table.querySelectorAll('[data-open-catalog-item]').forEach(row=>{const open=()=>{const p=state.catalogProducts.find(x=>x.id===row.dataset.openCatalogItem);if(p)openUnifiedCatalogItem(p).catch(e=>fail('تعذر فتح تفاصيل الصنف',e));};row.addEventListener('click',e=>{if(e.target.closest('button'))return;open();});row.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();open();}});});
L3864 |   table.querySelectorAll('[data-edit-catalog]').forEach(b=>b.onclick=e=>{e.stopPropagation();const p=state.catalogProducts.find(x=>x.id===b.dataset.editCatalog);if(p)openUnifiedCatalogItem(p).catch(err=>fail('تعذر فتح الصنف',err));});
L3865 |   table.querySelectorAll('[data-edit-client-map]').forEach(b=>b.onclick=e=>{e.stopPropagation();const p=state.catalogProducts.find(x=>x.id===b.dataset.editClientMap);if(p)openUnifiedCatalogItem(p).catch(err=>fail('تعذر فتح بيانات المؤسسة',err));});
L3866 |   table.querySelectorAll('[data-attach-client-catalog-product]').forEach(b=>b.onclick=e=>{e.stopPropagation();attachClientCatalogProductToProject(b.dataset.attachClientCatalogProduct,b);});
L3867 |   table.querySelectorAll('[data-catalog-state]').forEach(b=>b.onclick=e=>{e.stopPropagation();toggleCatalogProduct(b.dataset.catalogState);});
L3868 |   const pages=Math.max(1,Math.ceil(state.catalogTotal/size));$('catalogPagination').innerHTML='<span class="hint">عرض '+(state.catalogTotal?(page-1)*size+1:0)+'–'+Math.min(page*size,state.catalogTotal)+' من '+state.catalogTotal+' · الصفحة '+page+' / '+pages+'</span><div class="actions"><button id="catalogPrev" class="soft" type="button" '+(page<=1?'disabled':'')+'>السابق</button><button id="catalogNext" class="soft" type="button" '+(page>=pages?'disabled':'')+'>التالي</button></div>';$('catalogPrev').onclick=()=>{if(state.catalogPage>1){state.catalogPage--;loadCatalog().catch(e=>fail('تعذر تحميل الصفحة',e));}};$('catalogNext').onclick=()=>{if(state.catalogPage<pages){state.catalogPage++;loadCatalog().catch(e=>fail('تعذر تحميل الصفحة',e));}};
L3869 |  }catch(error){
L3870 |   if(requestToken===state.catalogRequestToken){
L3871 |    if(table)table.innerHTML='<div class="empty" role="alert">تعذر تحميل دليل الأصناف الآن. بقي تسجيل الدخول محفوظاً؛ تحقق من الاتصال أو الصلاحية ثم اضغط «تحديث» لإعادة المحاولة.</div>';
L3872 |    const count=$('catalogResultCount');if(count)count.textContent='تعذر تحديث نتائج الدليل';
L3873 |    const pagination=$('catalogPagination');if(pagination)pagination.innerHTML='';
L3874 |   }
L3875 |   throw error;
L3876 |  }finally{if(requestToken===state.catalogRequestToken)table?.removeAttribute('aria-busy');}
L3877 | }
```

### toggleCatalogProduct() — lines 3878-3886

```javascript
L3878 | async function toggleCatalogProduct(id){
L3879 |   if(!state.platformOwner)return notify('تعديل الكتالوج العالمي للمالك فقط.',true);
L3880 |   const p=state.catalogProducts.find(x=>x.id===id);if(!p)return;
L3881 |   if(p.is_active&&!await confirmAction('سيتم إيقاف الصنف عن الاستخدام في عمليات الجرد الجديدة. ستظل بياناته وروابطه التاريخية محفوظة. هل تريد المتابعة؟',{title:'إيقاف صنف عالمي',confirmText:'إيقاف الصنف'}))return;
L3882 |   const {error}=await db.from('count_catalog_products').update({is_active:!p.is_active,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',id);
L3883 |   if(error)throw error;
L3884 |   notify(p.is_active?'تم إيقاف الصنف مع الاحتفاظ بسجله وروابطه.':'تمت إعادة تفعيل الصنف.');
L3885 |   await loadCatalog();
L3886 |  }
```

### resetGlobalProductForm() — lines 3887-3890

```javascript
L3887 | function resetGlobalProductForm(){
L3888 |   $('globalProductForm').reset();$('globalProductId').value='';$('globalUnitClass').value='other';$('globalUnitPrecision').value='3';
L3889 |   $('globalProductFormTitle').textContent='إضافة صنف عالمي';$('globalProductSave').textContent='إضافة للكتالوج';
L3890 |  }
```

### bindUnitPrecisionDefaults() — lines 3892-3897

```javascript
L3892 | function bindUnitPrecisionDefaults(){
L3893 |  [['globalUnitClass','globalUnitPrecision'],['unitClass','unitPrecision'],['clientUnitClass','clientUnitPrecision']].forEach(([classId,precisionId])=>{
L3894 |   const cls=$(classId),precision=$(precisionId);if(!cls||!precision)return;
L3895 |   cls.addEventListener('change',()=>{precision.value=defaultProductUnitPrecision(cls.value);});
L3896 |  });
L3897 | }
```

### Global item save/update — inline submit listener

```javascript
L3899 |  $('globalProductForm').addEventListener('submit',async e=>{
L3900 |   e.preventDefault();if(!state.platformOwner)return notify('إدارة الأصناف العالمية للمالك فقط.',true);const f=e.currentTarget;setBusy(f,true);
L3901 |   try{
L3902 |    const id=$('globalProductId').value||null,sku=$('globalSku').value.trim()||null,barcode=$('globalBarcode').value.trim()||null,base=getGlobalBaseUnitValue(),itemKind=$('globalItemKind').value,requestedType=$('globalBarcodeType').value,unitClass=$('globalUnitClass').value;
L3903 |    if(!base)throw new Error('وحدة الأساس مطلوبة.');
L3904 |    const inferredUnitClass=inferProductUnitClass(base);if(inferredUnitClass!=='other'&&inferredUnitClass!==unitClass)throw new Error('الوحدة الأساسية لا تتوافق مع نمط القياس المحدد؛ اختر وحدة مناسبة أو غيّر نمط القياس.');
L3905 |    if(itemKind==='BARCODED'&&!barcode)throw new Error('الصنف الذي يحمل باركوداً يحتاج رمزاً خارجياً؛ اختر بدون باركود لتوليد معرف داخلي.');
L3906 |    if(itemKind==='WEIGHED'&&$('globalUnitClass').value!=='mass')throw new Error('الصنف الوزني يحتاج فئة وحدة قياس من الوزن.');
L3907 |    const barcodeType=barcode?cfResolveBarcodeType(barcode,requestedType):'INTERNAL';
L3908 |    if(itemKind==='NO_BARCODE'&&barcode&&barcodeType!=='INTERNAL')throw new Error('الصنف بدون باركود لا يقبل GTIN أو Code 128 خارجي.');
L3909 |    const units=getUnitMetaFields('global',readCatalogUnits('globalProductUnitsEditor',base,barcode),{item_kind:itemKind,barcode_type:barcodeType}),file=$('globalImageFile').files[0]||null;
L3910 |    if(file&&(file.size<=0||file.size>5*1024*1024||!['image/jpeg','image/png','image/webp'].includes(file.type)))throw new Error('الصورة يجب ألا تتجاوز 5MB وأن تكون JPEG/PNG/WEBP.');
L3911 |    const row={canonical_sku:sku,barcode:barcode||null,name:$('globalName').value.trim(),brand:$('globalBrand').value.trim()||null,category:$('globalCategory').value.trim()||null,base_unit:base,units,updated_by:state.user.id,updated_at:new Date().toISOString()};if(state.globalImageCleared&&!file)row.image_storage_path=null;
L3912 |    if(!row.name)throw new Error('اسم الصنف مطلوب.');let pid=id;
L3913 |    if(id){const u=await db.from('count_catalog_products').update(row).eq('id',id);if(u.error)throw u.error;}
L3914 |    else{const x=await db.from('count_catalog_products').insert({...row,is_active:true,source_type:'curated',created_by:state.user.id}).select('id').single();if(x.error)throw x.error;pid=x.data.id;}
L3915 |    let warning='';if(file){const ext=file.type==='image/png'?'png':file.type==='image/webp'?'webp':'jpg',path='catalog/products/'+pid+'/'+Date.now()+'.'+ext,up=await db.storage.from('counting-product-images').upload(path,file,{contentType:file.type,upsert:false});if(up.error)warning=' تعذر رفع الصورة.';else{const u=await db.from('count_catalog_products').update({image_storage_path:path,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',pid);if(u.error)warning=' تعذر ربط الصورة.';}}
L3916 |    closeGlobalProductEditor();state.catalogPage=1;await loadCatalog();notify((id?'تم تحديث بيانات الصنف ووحداته وباركوداته.':'تمت إضافة الصنف إلى الدليل الموحد.')+(barcode?'':' · سيولد النظام معرفاً داخلياً تلقائياً.')+warning,!!warning);
L3917 |   }catch(err){fail('تعذر حفظ الصنف العالمي',err);}finally{setBusy(f,false);}
L3918 |  });
```

### Client-specific item override save — inline submit listener

```javascript
L3926 |  $('clientProductForm').addEventListener('submit',async e=>{
L3927 |   e.preventDefault();const client=state.catalogClientId||(state.platformOwner?null:state.clientId);if(!client)return notify('اختر المؤسسة أولاً.',true);if(!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة مواءمات المؤسسة.',true);const f=e.currentTarget;setBusy(f,true);
L3928 |   try{const cat=$('clientProductCatalog').value;if(!cat)throw new Error('اختر الصنف العالمي.');let base=null,units=null;if($('clientUnitsOverrideToggle').checked){base=$('clientProductUnit').value.trim();if(!base)throw new Error('أدخل وحدة الأساس للمؤسسة.');const clientBarcode=$('clientProductBarcode').value.trim()||null,itemKind=$('clientItemKind').value,barcodeType=clientBarcode?cfResolveBarcodeType(clientBarcode,$('clientBarcodeType').value):'INTERNAL';if(itemKind==='WEIGHED'&&$('clientUnitClass').value!=='mass')throw new Error('الصنف الوزني للمؤسسة يحتاج فئة وحدة قياس من الوزن.');if(clientBarcode&&itemKind==='BARCODED'&&barcodeType==='INTERNAL')throw new Error('أدخل باركوداً خارجياً صالحاً أو غيّر نوع الصنف.');if(itemKind==='NO_BARCODE'&&clientBarcode&&barcodeType!=='INTERNAL')throw new Error('صنف المؤسسة بدون باركود لا يقبل رمزاً خارجياً.');units=getUnitMetaFields('client',readCatalogUnits('clientProductUnitsEditor',base,clientBarcode),{item_kind:itemKind,barcode_type:barcodeType});}
L3929 |    const p={p_client_id:client,p_catalog_product_id:cat,p_client_sku:$('clientProductSku').value.trim()||null,p_client_barcode:$('clientProductBarcode').value.trim()||null,p_name_override:$('clientProductName').value.trim()||null,p_category_override:$('clientProductCategory').value.trim()||null,p_base_unit_override:base,p_units_override:units,p_image_storage_path_override:$('clientProductImagePath').value.trim()||null};const x=await db.rpc('count_upsert_client_product',p);if(x.error)throw x.error;resetClientProductForm();await loadCatalog();notify('تم حفظ بيانات المؤسسة وربطها بالصنف في الدليل الموحد.');
L3930 |   }catch(err){fail('تعذر حفظ مواءمة المؤسسة',err);}finally{setBusy(f,false);}
L3931 |  });
```

### Project item save/update — inline submit listener

```javascript
L3958 |  $('productForm').addEventListener('submit',async e=>{e.preventDefault();if(!state.project)return notify('سجّل تكليفاً أولاً',true);const f=e.currentTarget;setBusy(f,true);try{
L3959 |   const id=$('productId').value,sku=$('sku').value.trim()||null,barcode=$('barcode').value.trim()||null,name=$('productName').value.trim()||null,baseUnit=$('baseUnit').value.trim(),itemKind=$('unitItemKind').value,requestedBarcodeType=$('unitBarcodeType').value;
L3960 |   if(!baseUnit)throw new Error('وحدة القياس الأساسية مطلوبة قبل إتاحة الصنف للعد.');
L3961 |   if(itemKind==='BARCODED'&&!barcode)throw new Error('الصنف الذي يحمل باركوداً يحتاج رمزاً خارجياً؛ اختر بدون باركود لتوليد معرف داخلي.');
L3962 |   if(itemKind==='WEIGHED'&&$('unitClass').value!=='mass')throw new Error('الصنف الوزني يحتاج فئة وحدة قياس من الوزن.');
L3963 |   const barcodeType=barcode?cfResolveBarcodeType(barcode,requestedBarcodeType):'INTERNAL';
L3964 |   if(itemKind==='NO_BARCODE'&&barcode&&barcodeType!=='INTERNAL')throw new Error('الصنف بدون باركود لا يقبل رمزاً خارجياً.');
L3965 |   const units=getUnitMetaFields('unit',readProductUnits(baseUnit,barcode),{item_kind:itemKind,barcode_type:barcodeType}),file=$('productImageFile').files[0]||null;
L3966 |   let imageRef=file?null:($('imageUrl').value.trim()|| (state.productImageCleared?null:state.editingProductImageRef||null));
L3967 |   const externalImageInput=$('imageUrl').value.trim();
L3968 |   if(externalImageInput&&!file){
L3969 |    const externalImageUrl=safeExternalProductImageUrl(externalImageInput);
L3970 |    if(!externalImageUrl)throw new Error('رابط الصورة الخارجية غير صالح أو مؤقت؛ استخدم HTTPS دائماً أو ارفع الصورة إلى مساحة CountFlow الخاصة.');
L3971 |    imageRef=externalImageUrl;
L3972 |   }
L3973 | 
L3974 |   const projectId=state.project.id;
L3975 |   if(file)imageRef=await uploadProductImage(file,projectId);
L3976 |   const row={project_id:projectId,sku,barcode,name,category:$('category').value.trim()||null,base_unit:baseUnit,units,expected_qty:$('expectedQty').value===''?null:Number($('expectedQty').value),image_url:imageRef,updated_at:new Date().toISOString()};
L3977 |   const result=id?await db.from('count_products').update(row).eq('id',id).eq('project_id',projectId):await db.from('count_products').insert({...row,is_active:true});
L3978 |   if(result.error)throw result.error;
L3979 |   state.editingProductImageRef=imageRef;state.productImageCleared=false;
L3980 |   notify(id?'تم تحديث الصنف ووحداته وصورته.':'تمت إضافة الصنف ووحداته وصورته.');resetProductForm();await loadProjectData();
L3981 |  }catch(err){fail('تعذر حفظ الصنف',err);}finally{setBusy(f,false);}});
L3982 |  $('productCancel').onclick=resetProductForm;$('addProjectProduct').onclick=()=>{if(!state.project)return notify('اختر ملف تكليف أولاً.',true);resetProductForm();$('projectProductEditorPanel').classList.remove('hidden');$('projectProductWorkspace').classList.add('cf-catalog-editor-open');$('sku').focus();$('projectProductEditorPanel').scrollIntoView({behavior:'smooth',block:'start'});};$('projectProductEditorClose').onclick=resetProductForm;$('projectCatalogExport').onclick=exportProjectCatalogCsv;
L3983 |  $('addProductUnit').addEventListener('click',()=>{
L3984 |   const container=$('productUnitsEditor'),row=document.createElement('div');row.className='product-unit-row';row.dataset.productUnitRow='';
L3985 |   row.innerHTML='<div class="field"><label>اسم الوحدة البديلة</label><input data-unit-name maxlength="40" placeholder="مثال: كرتونة"></div><div class="field"><label>كم تعادل من الوحدة الأساسية؟</label><input data-unit-factor type="number" min="0.000001" step="0.000001" placeholder="مثال: 12"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-unit-barcode maxlength="120"></div><div class="field"><label>نوع الرمز</label><select data-unit-barcode-type><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128</option></select></div><button type="button" class="danger" data-remove-product-unit>إزالة</button>';
L3986 |   container.appendChild(row);row.querySelector('[data-remove-product-unit]').onclick=()=>{row.remove();if(!container.querySelector('[data-product-unit-row]'))renderProductUnitEditor([]);};row.querySelector('[data-unit-name]').focus();
L3987 |  });
```

### Requested function names not present verbatim

- renderItems() — NOT FOUND by this name; renderProducts() renders the project-scoped table, while loadCatalog() renders the unified catalog.
- openItemPage(itemCode) — NOT FOUND by this name; equivalents are openGlobalProductEditor(product) and openUnifiedCatalogItem(product).
- _handleSaveFromPage(isEdit) — NOT FOUND by this name; saving is implemented as inline form submit listeners.
- _handleDeleteFromPage() — NOT FOUND; catalog products are deactivated/reactivated, not hard-deleted by this UI.
- _switchItemTab(tabId) — NOT FOUND by this name; equivalent is switchGlobalProductTab(tab).
- _loadCategoriesIntoSelect() — NOT FOUND by this name; equivalents are getCatalogCategoryChoices(), setCatalogCategoryPicker(), bindCatalogCategoryPickers().
- _openCategoryModal(), _addCategory(), _editCategory(), _deleteCategory() — NOT FOUND.
- saveItem() — NOT FOUND by this name; save behavior is implemented in inline submit listeners.
- generateInternalBarcode() — NOT FOUND by this name; equivalent is cfGenerateInternalBarcode().

### Global catalog / barcode / tab / category / client-scope event wiring

```javascript
L3918 |  });
L3919 |  $('catalogAddProduct').onclick=()=>openGlobalProductEditor(null);bindCatalogImportActions();$('globalProductCancel').onclick=closeGlobalProductEditor;$('globalProductCancelBottom').onclick=closeGlobalProductEditor;$('catalogExport').onclick=exportGlobalCatalogCsv;
L3920 |  $('globalGenerateBarcode').onclick=()=>handleGenerateGlobalBarcode();$('globalBarcodeCopy').onclick=copyGlobalBarcode;$('globalBarcode').addEventListener('input',renderGlobalBarcodeStatus);$('globalBarcodeType').addEventListener('change',renderGlobalBarcodeStatus);$('globalItemKind').onchange=()=>{if($('globalItemKind').value==='WEIGHED'){$('globalUnitClass').value='mass';$('globalUnitPrecision').value='3';if(!getGlobalBaseUnitValue())setGlobalBaseUnit('كجم');else setGlobalBaseUnit(getGlobalBaseUnitValue());}else if($('globalItemKind').value==='NO_BARCODE'&&!$('globalBarcode').value.trim())$('globalBarcodeType').value='INTERNAL';renderGlobalBarcodeStatus();};$('globalCatalogImportPreview').onclick=previewGlobalCatalogImport;$('globalCatalogImportCommit').onclick=commitGlobalCatalogImport;$('globalCatalogImportReset').onclick=resetGlobalCatalogImport;$('addGlobalProductUnit').onclick=()=>appendCatalogUnitRow('globalProductUnitsEditor');$('addClientProductUnit').onclick=()=>appendCatalogUnitRow('clientProductUnitsEditor');$('clientUnitsOverrideToggle').onchange=()=>$('clientUnitsOverrideFields').classList.toggle('hidden',!$('clientUnitsOverrideToggle').checked);$('clientProductReset').onclick=resetClientProductForm;$('clientCatalogEditorClose').onclick=resetClientProductForm;
L3921 |  bindUnitPrecisionDefaults();bindGlobalBaseUnitSelector();bindGlobalProductTabs();bindCatalogCategoryPickers();
L3922 |  $('catalogMode').addEventListener('change',()=>switchCatalogView($('catalogMode').value));
L3923 |  $('catalogClientScope').addEventListener('change',async()=>{if(state.clientCatalogImport?.busy){$('catalogClientScope').value=state.catalogClientId||'';return notify('لا يمكن تغيير المؤسسة أثناء تنفيذ دفعة الاستيراد الحالية.',true);}if(state.clientCatalogImport?.file)resetClientCatalogImport();state.catalogClientId=$('catalogClientScope').value||null;updateCatalogImportActions();try{await refreshClientCatalogPermission();$('catalogClientScopeLabel').textContent=state.catalogClientId?'يتم عرض الحقول المحلية للمؤسسة المختارة بجوار بيانات الصنف الأساسي.':'اختر مؤسسة لعرض حقولها المحلية في الجدول وصفحة الصنف.';state.catalogPage=1;await loadCatalog();}catch(e){fail('تعذر تغيير المؤسسة المحددة',e);}});$('catalogResetFilters').onclick=()=>{$('catalogSearch').value='';$('catalogCategoryFilter').value='';$('catalogStatusFilter').value='active';state.catalogPage=1;loadCatalog().catch(e=>fail('تعذر إعادة ضبط المرشحات',e));};
L3924 |  function scheduleCatalogReload(){clearTimeout(state.catalogSearchTimer);state.catalogSearchTimer=setTimeout(()=>{state.catalogPage=1;loadCatalog().catch(e=>fail('تعذر تحديث نتائج البحث',e));},260);} $('catalogSearch').oninput=scheduleCatalogReload;$('catalogCategoryFilter').oninput=scheduleCatalogReload;$('catalogStatusFilter').onchange=()=>{state.catalogPage=1;loadCatalog().catch(e=>fail('تعذر تغيير الحالة',e));};$('catalogRefresh').onclick=()=>loadCatalog().catch(e=>fail('تعذر التحديث',e));let catalogSearchTimer=null;
L3925 | 
```

## 5. Database Calls

The Admin file uses the Supabase client alias db, not the identifier supabase. The following are the item/catalog/import-related direct db.from(...) and db.rpc(...) call sites detected in this file, plus the product-image Storage call. Table projections, columns, filters, and RPC argument keys are preserved verbatim in each source line.

```javascript
L0914 |    let request=db.from('count_products').select('*',{count:'exact'}).eq('project_id',pid);
L0947 |   const {data,error}=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L1545 |   const {data,error}=await db.rpc('count_upsert_catalog_products_chunk',{p_rows:rows});
L1735 |  const {data,error}=await db.rpc('count_upsert_client_catalog_chunk',{p_client_id:clientId,p_rows:rows});
L1864 |   const {data:saved,error}=await db.from('count_import_mappings').select('id,name,column_mapping,is_default').eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat).eq('is_default',true).order('created_at',{ascending:false}).limit(1).maybeSingle();
L1882 |     const {error}=await db.from('count_import_mappings').update({is_default:false}).eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat);
L1885 |    const {data,error}=await db.from('count_import_mappings').upsert({project_id:state.project.id,name,source_format:state.productImportSourceFormat,column_mapping:mapping,is_default:makeDefault,created_by:state.user.id},{onConflict:'project_id,name'}).select('id').single();
L1933 |    const {data,error}=await db.rpc('count_commit_import_batch',{p_batch_id:batchId});
L1985 |    const {data:batchId,error:createError}=await db.rpc('count_create_import_batch',{p_project_id:projectId,p_session_id:sessionId,p_source_name:file.name,p_source_format:state.productImportSourceFormat,p_source_checksum:checksum});
L1987 |    const {error:mappingError}=await db.from('count_import_batches').update({mapping_id:state.productImportMappingId,metadata:{column_mapping:state.productImportMapping,headers:state.productImportHeaders,import_surface:'countflow-admin',checksum_algorithm:'sha256-chain-v1'}}).eq('id',batchId).eq('project_id',projectId);
L1992 |     const {data:staged,error}=await db.rpc('count_stage_import_rows',{p_batch_id:batchId,p_rows:chunk,p_row_offset:offset});
L2043 |   const {data,error}=await db.from('count_import_batches').select('id,source_name,source_format,row_count,accepted_count,rejected_count,status,error_report,created_at,session_id,metadata').eq('project_id',state.project.id).order('created_at',{ascending:false}).limit(20);
L2090 |   let query=db.from('count_import_rows').select('row_number,sku,barcode,product_name,'+key,{count:'exact'})
L2107 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,error_codes',{count:'exact'}).eq('batch_id',batchId).eq('row_status','rejected').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1),
L2108 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,warning_codes',{count:'exact'}).eq('batch_id',batchId).not('warning_codes','eq','{}').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1)
L2147 |    db.from('count_recount_tasks').select('id,product_id,location_id,assigned_member_id,status,reason,first_count_quantity,second_count_quantity,variance_percent,created_at,assigned_at,started_at,completed_at,reviewed_at,notes').eq('session_id',sessionId).order('created_at',{ascending:false}).limit(500),
L2685 |    db.from('count_products').select('id',{count:'exact',head:true}).eq('project_id',s.project_id).eq('is_active',true),
L2696 |   const {data,error}=await db.from('count_import_batches').select('id,source_name,source_format,row_count,accepted_count,rejected_count,status,created_at,metadata').eq('session_id',s.id).order('created_at',{ascending:false}).limit(30);
L2825 |     const {data:batchId,error:createError}=await db.rpc('count_create_import_batch',{
L2833 |      const {data,error}=await db.rpc('count_stage_import_rows',{p_batch_id:batchId,p_rows:normalized,p_row_offset:processed});
L2873 |   const latest=runs[0],{data:lines,error:lineError}=await db.from('count_reconciliation_lines').select('product_sku,product_name,location_path,unit,expected_quantity,counted_quantity,variance_quantity,variance_percent,result_status').eq('run_id',latest.id).order('product_sku').limit(5000);
L2885 |     db.from('count_products').select('id',{count:'exact',head:true}).eq('project_id',p.id).eq('is_active',true),
L2891 |    if(latest){const q=await db.from('count_reconciliation_lines').select('product_sku,product_name,location_path,unit,expected_quantity,counted_quantity,variance_quantity,variance_percent,result_status').eq('run_id',latest.id).order('product_sku').limit(5000);if(q.error)throw q.error;lines=q.data||[];}
L3043 |    db.from('count_catalog_products').select('id').ilike('barcode',candidate).limit(1),
L3044 |    db.from('count_catalog_products').select('id').contains('units',[{barcode:candidate}]).limit(1),
L3045 |    db.from('count_catalog_product_identifiers').select('id').or('normalized_value.eq.'+candidate+',identifier_value.eq.'+candidate).limit(1)
L3183 |   const {data,error}=await db.rpc('count_attach_catalog_product',{
L3212 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('barcode',term).limit(5),
L3213 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('canonical_sku',term).limit(5),
L3214 |    db.from('count_catalog_products').select(projection).eq('is_active',true).contains('units',[{barcode:term}]).limit(5),
L3215 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('name','%'+term.replace(/[%_,]/g,' ').slice(0,80)+'%').order('name',{ascending:true}).limit(8)
L3312 |  return db.rpc('count_has_client_permission',{p_client_id:id,p_permission_code:'catalog.manage'}).then(({data,error})=>apply(!error&&data===true));
L3353 |   const {error}=await db.storage.from('counting-product-images').upload(path,file,{cacheControl:'3600',contentType:file.type,upsert:false});
L3371 |   const {error}=await db.from('count_products').update({is_active:!p.is_active,updated_at:new Date().toISOString()}).eq('id',id).eq('project_id',state.project.id);
L3720 |   const result=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L3752 |   const result=await db.storage.from('counting-product-images').createSignedUrl(path,3600);
L3787 |    const result=await db.from('count_client_products').select('catalog_product_id').eq('client_id',clientId)
L3806 |    let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path').order(f.sort,{ascending:f.ascending}).order('id',{ascending:true});
L3811 |     const local=await db.from('count_client_products').select('catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',clientId).in('catalog_product_id',page.map(p=>p.id));
L3830 |    const result=await db.from('count_products').select('sku,barcode,name,category,base_unit,units,expected_qty,image_url,is_active').eq('project_id',project.id).order('name',{ascending:true}).order('id',{ascending:true}).range(offset,offset+pageSize-1);
L3846 |   let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path',{count:'exact'}).order(sort,{ascending:state.catalogSortAsc}).order('id',{ascending:true});
L3854 |    const local=await db.from('count_client_products').select('id,client_id,catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',scopedClient).in('catalog_product_id',productIds);
L3882 |   const {error}=await db.from('count_catalog_products').update({is_active:!p.is_active,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',id);
L3913 |    if(id){const u=await db.from('count_catalog_products').update(row).eq('id',id);if(u.error)throw u.error;}
L3914 |    else{const x=await db.from('count_catalog_products').insert({...row,is_active:true,source_type:'curated',created_by:state.user.id}).select('id').single();if(x.error)throw x.error;pid=x.data.id;}
L3915 |    let warning='';if(file){const ext=file.type==='image/png'?'png':file.type==='image/webp'?'webp':'jpg',path='catalog/products/'+pid+'/'+Date.now()+'.'+ext,up=await db.storage.from('counting-product-images').upload(path,file,{contentType:file.type,upsert:false});if(up.error)warning=' تعذر رفع الصورة.';else{const u=await db.from('count_catalog_products').update({image_storage_path:path,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',pid);if(u.error)warning=' تعذر ربط الصورة.';}}
L3915 |    let warning='';if(file){const ext=file.type==='image/png'?'png':file.type==='image/webp'?'webp':'jpg',path='catalog/products/'+pid+'/'+Date.now()+'.'+ext,up=await db.storage.from('counting-product-images').upload(path,file,{contentType:file.type,upsert:false});if(up.error)warning=' تعذر رفع الصورة.';else{const u=await db.from('count_catalog_products').update({image_storage_path:path,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',pid);if(u.error)warning=' تعذر ربط الصورة.';}}
L3929 |    const p={p_client_id:client,p_catalog_product_id:cat,p_client_sku:$('clientProductSku').value.trim()||null,p_client_barcode:$('clientProductBarcode').value.trim()||null,p_name_override:$('clientProductName').value.trim()||null,p_category_override:$('clientProductCategory').value.trim()||null,p_base_unit_override:base,p_units_override:units,p_image_storage_path_override:$('clientProductImagePath').value.trim()||null};const x=await db.rpc('count_upsert_client_product',p);if(x.error)throw x.error;resetClientProductForm();await loadCatalog();notify('تم حفظ بيانات المؤسسة وربطها بالصنف في الدليل الموحد.');
L3943 |   const {data:canRead,error:permError}=await db.rpc('count_has_client_permission',{p_client_id:state.clientId,p_permission_code:'client.read'});
L3977 |   const result=id?await db.from('count_products').update(row).eq('id',id).eq('project_id',projectId):await db.from('count_products').insert({...row,is_active:true});
L3977 |   const result=id?await db.from('count_products').update(row).eq('id',id).eq('project_id',projectId):await db.from('count_products').insert({...row,is_active:true});
```

SQL DDL or full SQL/RPC signatures are not embedded in this HTML file; only client-side RPC names and argument objects are present above.

## 6. Data Structures

### Shared state initializer

```javascript
L0784 | const state={user:null,platformOwner:false,clientId:null,clientRole:null,clients:[],clientDirectoryRows:[],clientDirectoryManagers:[],clientDirectoryPage:1,clientDirectoryPageSize:25,clientDirectoryTotal:0,clientSort:'created_at',clientSortAsc:false,clientSearchTimer:null,roles:[],permissions:[],roleMap:new Map(),rolePermissions:new Map(),catalogProducts:[],catalogPage:1,catalogTotal:0,catalogSort:'name',catalogSortAsc:true,catalogImageUrls:new Map(),catalogImageToken:0,catalogRequestToken:0,catalogEditorImageToken:0,catalogSearchTimer:null,globalImagePreviewObjectUrl:null,globalImageCleared:false,catalogClientId:null,catalogOptionProducts:[],catalogClientRows:[],catalogView:'global',canManageClientCatalog:false,overviewRows:[],overviewLoadedAt:null,overviewRequestToken:0,overviewError:null,overviewRealtimeStatus:'CONNECTING',platformKpis:{},teamRows:[],teamRosterRows:[],teamSelectedId:null,project:null,projects:[],products:[],members:[],locations:[],sessions:[],allMembers:[],allSessions:[],assignmentCounts:{},productImageUrls:new Map(),productImageToken:0,editingProductImageRef:null,productImageCleared:false,productImagePreviewObjectUrl:null,passwordResetMemberId:null,selectedSession:null,workflowSessionId:null,workflowData:null,operationImportRows:[],operationImportRowCount:0,operationImportFormat:'csv',globalCatalogImport:{file:null,count:0,headers:[],sample:[],mapping:{},busy:false,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}},clientCatalogImport:{file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}},productImportChecksum:'',productImportRows:[],productImportRowCount:0,productImportHeaders:[],productImportMapping:{},productImportMappingId:null,productImportSourceFormat:'csv',productImportFileName:'',productPage:1,productTotal:0,productQuery:'',productScrollTop:0,operationSort:'created_at',operationSortAsc:false,operationPage:1,globalChannel:null,globalRefreshTimer:null,globalPollTimer:null,busy:false};
```

### Project item import field schema

```javascript
L1192 | const productImportFields=[
L1193 |   {key:'sku',label:'كود الصنف SKU',aliases:['sku','code','item_code','product_code','كود الصنف','كود','رمز الصنف']},
L1194 |   {key:'barcode',label:'الباركود',aliases:['barcode','bar_code','ean','upc','باركود','الباركود']},
L1195 |   {key:'name',label:'اسم الصنف',aliases:['name','item_name','product_name','اسم الصنف','الصنف','الاسم']},
L1196 |   {key:'category',label:'الفئة / التصنيف',aliases:['category','group','الفئة','التصنيف']},
L1197 |   {key:'base_unit',label:'الوحدة الأساسية (مطلوبة للصنف الجديد)',aliases:['base_unit','unit','uom','الوحدة','وحدة القياس']},
L1198 |   {key:'units',label:'الوحدات والتحويلات',aliases:['units','unit_options','الوحدات']},
L1199 |   {key:'unit_class',label:'فئة وحدة القياس',aliases:['unit_class','measurement_class','فئة الوحدة','نوع القياس']},
L1200 |   {key:'decimal_precision',label:'دقة الكمية',aliases:['decimal_precision','quantity_precision','دقة الكمية','المنازل العشرية']},
L1201 |   {key:'expected_qty',label:'الكمية الدفترية المرجعية (تتطلب جلسة)',aliases:['expected_qty','expected_quantity','book_qty','الكمية الدفترية','الرصيد الدفتري']},
L1202 |   {key:'location_code',label:'كود الموقع (يتطلب جلسة)',aliases:['location_code','location','bin','shelf','الموقع','كود الموقع']},
L1203 |   {key:'image_url',label:'رابط الصورة HTTPS',aliases:['image_url','image','photo','رابط الصورة']},
L1204 |   {key:'purchase_unit_cost',label:'سعر شراء الوحدة (اختياري)',aliases:['purchase_unit_cost','purchase_price','unit_cost','price','سعر الشراء','سعر الشراء للوحدة']},
L1205 |   {key:'currency_code',label:'العملة',aliases:['currency_code','currency','العملة','عملة السعر']},
L1206 |   {key:'purchase_unit',label:'وحدة الشراء',aliases:['purchase_unit','purchase_uom','unit_of_purchase','وحدة الشراء','وحدة سعر الشراء']},
L1207 |   {key:'unit_factor_to_base',label:'معامل التحويل للوحدة الأساسية',aliases:['unit_factor_to_base','purchase_unit_factor_to_base','conversion_factor_to_base','معامل التحويل للوحدة الأساسية']},
L1208 |   {key:'cost_source_type',label:'نوع مصدر السعر',aliases:['cost_source_type','price_source','source_type','مصدر السعر']},
L1209 |   {key:'cost_source_reference',label:'مرجع مصدر السعر',aliases:['cost_source_reference','invoice_reference','price_reference','مرجع السعر']},
L1210 |   {key:'cost_source_date',label:'تاريخ السعر',aliases:['cost_source_date','price_date','تاريخ السعر']}
L1211 |  ];
```

### Global catalog import field schema

```javascript
L1389 | const globalCatalogImportFields=[
L1390 |   {key:'sku',label:'SKU / كود الصنف',aliases:['sku','code','item_code','product_code','canonical_sku','كود الصنف','كود','رمز الصنف']},
L1391 |   {key:'barcode',label:'الباركود الأساسي',aliases:['barcode','bar_code','ean','upc','gtin','باركود','الباركود']},
L1392 |   {key:'name',label:'اسم الصنف (مطلوب)',aliases:['name','item_name','product_name','اسم الصنف','الصنف','الاسم']},
L1393 |   {key:'brand',label:'العلامة التجارية',aliases:['brand','manufacturer','العلامة التجارية','الماركة']},
L1394 |   {key:'category',label:'التصنيف',aliases:['category','group','الفئة','التصنيف']},
L1395 |   {key:'base_unit',label:'وحدة الأساس (مطلوبة)',aliases:['base_unit','unit','uom','الواحدة','الوحدة','وحدة القياس']},
L1396 |   {key:'units',label:'الوحدات البديلة ومعاملاتها',aliases:['units','unit_options','الوحدات','وحدات التعبئة']},
L1397 |   {key:'unit_class',label:'نمط القياس',aliases:['unit_class','measurement_class','فئة الوحدة','نوع القياس']},
L1398 |   {key:'decimal_precision',label:'دقة الكمية',aliases:['decimal_precision','quantity_precision','دقة الكمية','المنازل العشرية']},
L1399 |   {key:'item_kind',label:'نوع الصنف',aliases:['item_kind','product_kind','نوع الصنف']},
L1400 |   {key:'barcode_type',label:'نوع الباركود',aliases:['barcode_type','symbology','نوع الباركود']}
L1401 |  ];
```

### Client catalog import field schema

```javascript
L1638 | const clientCatalogImportFields=[
L1639 |  {key:'sku',label:'SKU / الكود العالمي',aliases:['sku','code','item_code','product_code','canonical_sku','كود الصنف','كود','رمز الصنف']},
L1640 |  {key:'barcode',label:'الباركود العالمي الأساسي',aliases:['barcode','bar_code','ean','upc','gtin','باركود','الباركود']},
L1641 |  {key:'name',label:'اسم الصنف (مطلوب)',aliases:['name','item_name','product_name','اسم الصنف','الصنف','الاسم']},
L1642 |  {key:'brand',label:'العلامة التجارية',aliases:['brand','manufacturer','العلامة التجارية','الماركة']},
L1643 |  {key:'category',label:'التصنيف الأساسي',aliases:['category','group','الفئة','التصنيف']},
L1644 |  {key:'base_unit',label:'وحدة الأساس (مطلوبة لإنشاء صنف جديد)',aliases:['base_unit','unit','uom','الواحدة','الوحدة','وحدة القياس']},
L1645 |  {key:'units',label:'الوحدات البديلة ومعاملاتها',aliases:['units','unit_options','الوحدات','وحدات التعبئة']},
L1646 |  {key:'unit_class',label:'نمط القياس',aliases:['unit_class','measurement_class','فئة الوحدة','نمط القياس','نوع القياس']},
L1647 |  {key:'decimal_precision',label:'دقة الكمية',aliases:['decimal_precision','quantity_precision','دقة الكمية','المنازل العشرية']},
L1648 |  {key:'item_kind',label:'نوع الصنف',aliases:['item_kind','product_kind','نوع الصنف']},
L1649 |  {key:'barcode_type',label:'نوع الباركود العالمي',aliases:['barcode_type','symbology','نوع الباركود']},
L1650 |  {key:'client_sku',label:'SKU المؤسسة (اختياري)',aliases:['client_sku','tenant_sku','organization_sku','كود المؤسسة','sku المؤسسة']},
L1651 |  {key:'client_barcode',label:'باركود المؤسسة (اختياري)',aliases:['client_barcode','tenant_barcode','organization_barcode','باركود المؤسسة']},
L1652 |  {key:'client_name_override',label:'اسم المؤسسة (اختياري)',aliases:['client_name','client_name_override','tenant_name','اسم المؤسسة']},
L1653 |  {key:'client_category_override',label:'تصنيف المؤسسة (اختياري)',aliases:['client_category','client_category_override','tenant_category','تصنيف المؤسسة']},
L1654 |  {key:'client_base_unit_override',label:'وحدة الأساس للمؤسسة (اختياري)',aliases:['client_base_unit','client_base_unit_override','tenant_base_unit','وحدة المؤسسة']},
L1655 |  {key:'client_units_override',label:'وحدات المؤسسة ومعاملاتها (JSON اختياري)',aliases:['client_units','client_units_override','tenant_units','وحدات المؤسسة']}
L1656 | ];
```

### Measurement classes and aliases

```javascript
L2911 | const CF_UNIT_CLASSES=[
L2912 |  {value:'count',label:'عدد / قطعة',precision:0,aliases:['each','ea','pc','pcs','piece','pieces','unit','units','dozen','dz','box','boxes','carton','cartons','case','cases','pack','packet','عدد','قطعة','وحدة','حبة','علبة','كرتونة','كرتون','عبوة','باكيت','دستة']},
L2913 |  {value:'mass',label:'وزن / كتلة',precision:3,aliases:['kg','kgs','kilogram','kilograms','g','gm','gram','grams','mg','milligram','milligrams','oz','ounce','ounces','ton','tons','tonne','tonnes','lb','lbs','pound','pounds','كجم','كيلوجرام','كيلوغرام','كيلو جرام','كيلو','جم','جرام','غرام','مجم','ملجم','مليجرام','طن','أطنان','رطل']},
L2914 |  {value:'volume',label:'حجم / سعة',precision:3,aliases:['l','lt','liter','litre','liters','litres','ml','milliliter','millilitre','m3','cm3','لتر','مل','مليلتر','ملي لتر','متر مكعب','سم مكعب']},
L2915 |  {value:'length',label:'طول',precision:3,aliases:['m','meter','metre','meters','metres','cm','centimeter','centimetre','mm','millimeter','millimetre','km','inch','in','inches','ft','foot','feet','كيلومتر','متر','سم','سنتيمتر','مم','ملليمتر']},
L2916 |  {value:'area',label:'مساحة',precision:3,aliases:['m2','sqm','cm2','sqft','ft2','square meter','square metre','متر مربع','سم مربع','متر²','سم²']},
L2917 |  {value:'other',label:'وحدة خاصة / تعبئة',precision:3,aliases:[]}
L2918 | ];
```

### Base-unit suggestions by measurement class

```javascript
L2959 | const CF_BASE_UNIT_SUGGESTIONS={
L2960 |  count:['قطعة','حبة','عدد','وحدة','علبة','كرتونة','كرتون','عبوة','باكيت','دستة','each','ea','piece','pc','pcs','unit','dozen','dz'],
L2961 |  mass:['كجم','جرام','جم','ملجم','طن','kilogram','kg','gram','g','mg','oz','ounce','lb','رطل'],
L2962 |  volume:['لتر','مليلتر','ملليلتر','متر مكعب','liter','litre','l','ml'],
L2963 |  length:['متر','سم','مم','كيلومتر','بوصة','قدم','meter','metre','m','cm','mm','km','inch','in','ft'],
L2964 |  area:['متر مربع','سم مربع','m2','sqm','sqft','ft2'],
L2965 |  other:['وحدة','عبوة']
L2966 | };
```

### Product category suggestions

```javascript
L2967 | const CF_PRODUCT_CATEGORY_SUGGESTIONS=[
L2968 |  'مواد غذائية','أغذية جافة','مشروبات','ألبان وأجبان','مخبوزات','لحوم ودواجن',
L2969 |  'أسماك ومأكولات بحرية','خضروات وفاكهة','مجمدات','حلويات وتسالي','منظفات',
L2970 |  'عناية شخصية','ورقيات ومناديل','مستلزمات منزلية','أدوات ومعدات',
L2971 |  'ملابس ومنسوجات','إلكترونيات','قطع غيار','مواد خام','مواد تعبئة وتغليف','مستلزمات تشغيل'
L2972 | ];
```

### Global item row object prepared by the save handler

```javascript
L3911 |    const row={canonical_sku:sku,barcode:barcode||null,name:$('globalName').value.trim(),brand:$('globalBrand').value.trim()||null,category:$('globalCategory').value.trim()||null,base_unit:base,units,updated_by:state.user.id,updated_at:new Date().toISOString()};if(state.globalImageCleared&&!file)row.image_storage_path=null;
```

### Unit metadata functions defining the JSONB entry shape

```javascript
L2944 | function cfParseUnitRows(value){if(Array.isArray(value))return value;const raw=String(value??'').trim();if(!raw)return [];try{const parsed=JSON.parse(raw);if(Array.isArray(parsed))return parsed;}catch(_){}return raw.split('|').map(part=>{const bits=part.trim().split(/[:=]/);if(bits.length<2)return null;const factor=Number(bits[1]);return bits[0].trim()&&Number.isFinite(factor)?{name:bits[0].trim(),factor_to_base:factor}:null;}).filter(Boolean);}
L2945 | function readProductUnitMeta(units,baseUnit){const meta=Array.isArray(units)?units.find(row=>row&&typeof row==='object'&&row[CF_UNIT_META_FLAG]===true):null,allowed=CF_UNIT_CLASSES.map(x=>x.value),validClass=meta&&allowed.includes(meta.unit_class),unitClass=validClass?meta.unit_class:inferProductUnitClass(baseUnit),precision=Number(meta?.decimal_precision);return {unit_class:unitClass,decimal_precision:Number.isInteger(precision)&&precision>=0&&precision<=6?precision:defaultProductUnitPrecision(unitClass),item_kind:['BARCODED','WEIGHED','NO_BARCODE'].includes(meta?.item_kind)?meta.item_kind:(unitClass==='mass'?'WEIGHED':'BARCODED'),barcode_type:['EAN8','UPC_A','EAN13','GTIN14','CODE128','INTERNAL'].includes(meta?.barcode_type)?meta.barcode_type:'AUTO',inferred:!validClass};}
L2946 | function withProductUnitMeta(units,unitClass,decimalPrecision,extra={}){const selected=CF_UNIT_CLASSES.some(x=>x.value===unitClass)?unitClass:'other',precision=Number(decimalPrecision);if(!Number.isInteger(precision)||precision<0||precision>6)throw new Error('دقة الكسور يجب أن تكون من صفر إلى 6 منازل عشرية.');const itemKind=['BARCODED','WEIGHED','NO_BARCODE'].includes(extra.item_kind)?extra.item_kind:null,barcodeType=['EAN8','UPC_A','EAN13','GTIN14','CODE128','INTERNAL'].includes(extra.barcode_type)?extra.barcode_type:null;return [...productUnitRows(units),{[CF_UNIT_META_FLAG]:true,unit_class:selected,decimal_precision:precision,...(itemKind?{item_kind:itemKind}:{}),...(barcodeType?{barcode_type:barcodeType}:{})}];}
```

## Earlier Extraction Observations (Initial Pass)

- The tab contains two separate item surfaces: the unified global/client catalog and a project-scoped product list with separate import and pagination controls.
- The global editor is a static form with three tabs (basic, alternate units, advanced); image upload/preview is in the basic panel, while client overrides use a separate form.
- Named category-modal CRUD and hard-delete page handlers are absent; categories use suggested values plus a custom-value field, and catalog items are deactivated/reactivated instead of deleted.
- The global catalog master stores identifiers, name, brand, category, base unit, unit metadata and image path; the UI explicitly excludes price and supplier fields from the global master.


---

## 7. JavaScript Functions (Items Only)

Source: `countflow-admin.html` on `main`; source blob SHA: `602ade4ad3bb44bf44b9788f79f27df2d6feb269`. Each source line below is reproduced verbatim and prefixed with its original line number. Inline form submit listeners are included because the file does not implement these save operations as standalone named functions.

### clearProjectViews() — source lines 868-868

```javascript
L0868 | function clearProjectViews(){state.products=[];state.productTotal=0;state.productQuery='';state.productScrollTop=0;state.members=[];state.locations=[];state.sessions=[];state.productPage=1;state.productImportRows=[];state.productImportRowCount=0;state.productImportMapping={};state.productImportMappingId=null;if($('productImportHistory'))$('productImportHistory').innerHTML='<div class="empty">اختر تكليفاً لعرض سجل الاستيراد.</div>';if($('productImportDetails'))$('productImportDetails').innerHTML='';['kProducts','kMembers','kSessions'].forEach(id=>$(id).textContent='0');['productTable','memberTable','locationTable','sessionTable','auditTable','recentSessions'].forEach(id=>$(id).innerHTML='<div class="empty">سجّل أو اختر تكليفاً لعرض البيانات.</div>');$('projectSummary').textContent='لا يوجد تكليف محدد.';}
```

### loadProjectData() — source lines 877-893

```javascript
L0877 | async function loadProjectData(){
L0878 |   if(!state.project){clearProjectViews();return;}
L0879 |   return withTableSkeletons([['memberTable',5,6],['roleTable',5,6],['locationTable',5,4],['sessionTable',5,6]],async()=>{
L0880 |    const pid=state.project.id;
L0881 |    const [members,locations,sessions]=await Promise.all([
L0882 |     db.from('count_members').select('id,user_id,display_name,username,role,role_id,status,last_seen_at,created_at').eq('project_id',pid).order('created_at',{ascending:false}).limit(500),
L0883 |     db.from('count_locations').select('*').eq('project_id',pid).order('sort_order').limit(2000),
L0884 |     db.from('count_sessions').select('id,project_id,name,status,started_at,closed_at,created_at,updated_at,sync_barrier_version,queue_barrier_action,queue_barrier_run_id,queue_barrier_requested_at').eq('project_id',pid).order('created_at',{ascending:false}).limit(200)
L0885 |    ]);
L0886 |    for(const [label,res] of [['الأعضاء',members],['المواقع',locations],['الجلسات',sessions]])if(res.error)throw new Error(label+': '+res.error.message);
L0887 |    state.products=[];state.productTotal=0;state.members=members.data||[];state.locations=locations.data||[];state.sessions=sessions.data||[];
L0888 |    state.productPage=1;state.productQuery=$('productSearch').value.trim();state.productScrollTop=0;
L0889 |    renderProject();
L0890 |    await Promise.all([loadProductsPage(1,state.productQuery),loadAudit(),loadProductImportHistory()]);
L0891 |    if(state.workflowSessionId&&state.sessions.some(x=>x.id===state.workflowSessionId))await loadSessionWorkflow(state.workflowSessionId);
L0892 |   });
L0893 |  }
```

### renderProductImportSessions() — source lines 895-901

```javascript
L0895 | function renderProductImportSessions(){
L0896 |   const select=$('productImportSession');if(!select)return;
L0897 |   const keep=select.value;
L0898 |   const eligible=(state.sessions||[]).filter(s=>['planned','active','paused','review'].includes(s.status));
L0899 |   select.innerHTML='<option value="">كتالوج فقط</option>'+eligible.map(s=>'<option value="'+s.id+'">'+esc(s.name)+' · '+esc(statusName(s.status))+'</option>').join('');
L0900 |   if(eligible.some(s=>s.id===keep))select.value=keep;
L0901 |  }
```

### renderProject() — source lines 902-906

```javascript
L0902 | function renderProject(){
L0903 |   const p=state.project;$('welcomeTitle').textContent=p.name;$('projectSummary').innerHTML='<b>'+esc(p.name)+'</b><p class="muted">الكود: '+esc(p.code)+'</p><p>الحالة: '+statusPill(p.status)+'</p><p class="hint">تم الإنشاء '+date(p.created_at)+'</p>';
L0904 |   $('kProducts').textContent=state.productTotal;$('kMembers').textContent=state.members.filter(x=>x.status==='active').length;$('kSessions').textContent=state.sessions.length;
L0905 |   $('productCount').textContent=state.productTotal+' صنف';renderProductImportSessions();renderProducts();renderMembers();renderRoles();renderLocations();renderSessions();renderRecent();
L0906 |  }
```

### loadProductsPage() — source lines 910-925

```javascript
L0910 | async function loadProductsPage(page=1,query=state.productQuery){
L0911 |   if(!state.project)return;
L0912 |   return withTableSkeletons([['productTable',6,6]],async()=>{
L0913 |    const pid=state.project.id,requestToken=++state.productImageToken,limit=100,q=String(query||'').trim().replace(/[(),]/g,' ').replace(/[%_]/g,' ').slice(0,100);
L0914 |    let request=db.from('count_products').select('*',{count:'exact'}).eq('project_id',pid);
L0915 |    if(q)request=request.or(['name','sku','barcode','category'].map(k=>k+'.ilike.%'+q+'%').join(','));
L0916 |    const {data,error,count}=await request.order('name',{ascending:true}).order('id',{ascending:true}).range((Math.max(1,page)-1)*limit,Math.max(1,page)*limit-1);
L0917 |    if(error)throw error;
L0918 |    if(state.project?.id!==pid||state.productImageToken!==requestToken)return;
L0919 |    state.productImageUrls.clear();
L0920 |    await loadProductImageUrls(data||[],pid,requestToken);
L0921 |    if(state.project?.id!==pid||state.productImageToken!==requestToken)return;
L0922 |    state.products=data||[];state.productTotal=count||0;state.productPage=Math.max(1,page);state.productQuery=query||'';state.productScrollTop=0;
L0923 |    renderProducts();
L0924 |   });
L0925 |  }
```

### isProjectProductImagePath() — source lines 927-931

```javascript
L0927 | function isProjectProductImagePath(reference,projectId){
L0928 |   const value=String(reference??''),prefix=String(projectId||'')+'/products/';
L0929 |   if(!projectId||!value.startsWith(prefix))return false;
L0930 |   return /^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$/.test(value.slice(prefix.length));
L0931 |  }
```

### safeExternalProductImageUrl() — source lines 932-940

```javascript
L0932 | function safeExternalProductImageUrl(reference){
L0933 |   const value=String(reference??'').trim();
L0934 |   try{
L0935 |    const url=new URL(value);
L0936 |    if(url.protocol!=='https:'||!url.hostname||url.username||url.password||/[\\\s]/.test(value)
L0937 |       ||/\/storage\/v1\/object\/sign\//i.test(url.pathname)||url.searchParams.has('token')||url.searchParams.has('expiresIn'))return '';
L0938 |    return url.href;
L0939 |   }catch(_){return ''}
L0940 |  }
```

### loadProductImageUrls() — source lines 941-951

```javascript
L0941 | async function loadProductImageUrls(rows,projectId,token){
L0942 |   const paths=[...new Set((rows||[]).map(p=>String(p.image_url||'').trim()).filter(path=>
L0943 |    isProjectProductImagePath(path,projectId)
L0944 |   ))];
L0945 | 
L0946 |   if(!paths.length)return;
L0947 |   const {data,error}=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L0948 |   if(error){console.warn('Product image signing failed',error);return;}
L0949 |   if(state.project?.id!==projectId||state.productImageToken!==token)return;
L0950 |   for(const item of data||[])if(item.path&&item.signedUrl)state.productImageUrls.set(projectId+'|'+item.path,item.signedUrl);
L0951 |  }
```

### productImageDisplayUrl() — source lines 952-959

```javascript
L0952 | function productImageDisplayUrl(product){
L0953 |   const reference=String(product?.image_url||'').trim();
L0954 |   const externalUrl=safeExternalProductImageUrl(reference);
L0955 |   if(externalUrl)return externalUrl;
L0956 |   const projectId=state.project?.id||'';
L0957 |   if(!isProjectProductImagePath(reference,projectId))return '';
L0958 |   return state.productImageUrls.get(projectId+'|'+reference)||'';
L0959 |  }
```

### renderProducts() — source lines 961-979

```javascript
L0961 | function renderProducts(){
L0962 |   const rows=state.products||[],pageSize=100,totalPages=Math.max(1,Math.ceil(state.productTotal/pageSize)),windowSize=30,rowHeight=76;
L0963 |   state.productPage=Math.min(Math.max(1,state.productPage),totalPages);
L0964 |   const first=Math.min(Math.max(0,Math.floor((state.productScrollTop||0)/rowHeight)),Math.max(0,rows.length-windowSize)),visible=rows.slice(first,first+windowSize);
L0965 |   const rowHtml=x=>{
L0966 |    const imageUrl=productImageDisplayUrl(x),hasImageReference=Boolean(String(x.image_url||'').trim()),image=imageUrl?'<a class="product-image-link" href="'+esc(imageUrl)+'" target="_blank" rel="noopener noreferrer" aria-label="فتح صورة '+esc(x.name||x.sku||'الصنف')+'"><img class="product-thumb" data-product-image="1" src="'+esc(imageUrl)+'" alt="'+esc(x.name||'صورة الصنف')+'" loading="lazy" decoding="async" referrerpolicy="no-referrer"></a>':'<span class="product-image-placeholder">'+(hasImageReference?'الصورة غير متاحة':'بدون صورة')+'</span>';
L0967 |    const units=productUnitRows(Array.isArray(x.units)?x.units:[]),unitSummary=units.length?units.length+' وحدات بديلة':'الوحدة الأساسية فقط';
L0968 |    return '<tr><td>'+image+'</td><td><b>'+esc(x.name||'اسم غير متوفر')+'</b><span class="sub">'+esc(x.category||'بدون تصنيف')+'</span></td><td>'+esc(x.sku||x.barcode||'—')+'<span class="sub">'+esc(x.sku&&x.barcode?x.barcode:'')+'</span></td><td>'+esc(x.base_unit)+'<span class="sub">'+esc(unitSummary)+'</span></td><td>'+statusPill(x.is_active?'نشط':'موقوف')+'</td><td><button class="soft" data-edit-product="'+x.id+'">تعديل</button> <button class="'+(x.is_active?'danger':'soft')+'" data-toggle-product="'+x.id+'">'+(x.is_active?'إيقاف':'تفعيل')+'</button></td></tr>';
L0969 |   };
L0970 |   const top=first*rowHeight,bottom=Math.max(0,(rows.length-first-visible.length)*rowHeight);
L0971 |   $('productCount').textContent=state.productTotal.toLocaleString('en-US')+' نتيجة · صفحة '+state.productPage+' من '+totalPages;
L0972 |   $('productTable').innerHTML=rows.length?'<div id="productVirtualScroller" style="max-height:520px;overflow:auto;position:relative"><table><thead><tr><th>الصورة</th><th>الصنف</th><th>كود الصنف / باركود</th><th>الوحدة والتحويلات</th><th>الحالة</th><th>إجراء</th></tr></thead><tbody>'+(top?'<tr aria-hidden="true"><td colspan="6" style="height:'+top+'px;padding:0;border:0"></td></tr>':'')+visible.map(rowHtml).join('')+(bottom?'<tr aria-hidden="true"><td colspan="6" style="height:'+bottom+'px;padding:0;border:0"></td></tr>':'')+'</tbody></table></div>':'<div class="empty">لا توجد نتائج مطابقة.</div>';
L0973 |   $('productTable').querySelectorAll('[data-product-image]').forEach(img=>img.addEventListener('error',()=>{const fallback=document.createElement('span');fallback.className='product-image-placeholder';fallback.textContent='الصورة غير متاحة';const link=img.closest('.product-image-link');(link||img).replaceWith(fallback);},{once:true}));
L0974 |   $('productPager').innerHTML=state.productTotal>pageSize?'<span class="hint">إجمالي '+state.productTotal.toLocaleString('en-US')+' صنف</span><button type="button" class="soft" data-product-page="'+Math.max(1,state.productPage-1)+'" '+(state.productPage===1?'disabled':'')+'>السابق</button><button type="button" class="soft" data-product-page="'+Math.min(totalPages,state.productPage+1)+'" '+(state.productPage===totalPages?'disabled':'')+'>التالي</button>':'';
L0975 |   const scroller=$('productVirtualScroller');if(scroller){scroller.scrollTop=state.productScrollTop||0;scroller.onscroll=()=>{state.productScrollTop=scroller.scrollTop;renderProducts();};}
L0976 |   $('productTable').querySelectorAll('[data-edit-product]').forEach(b=>b.onclick=()=>editProduct(b.dataset.editProduct));
L0977 |   $('productTable').querySelectorAll('[data-toggle-product]').forEach(b=>b.onclick=()=>toggleProduct(b.dataset.toggleProduct));
L0978 |   $('productPager').querySelectorAll('[data-product-page]').forEach(b=>b.onclick=()=>loadProductsPage(Number(b.dataset.productPage),state.productQuery).catch(e=>fail('تعذر تحميل صفحة الأصناف',e)));
L0979 |  }
```

### guessProductImportHeader() — source lines 1212-1215

```javascript
L1212 | function guessProductImportHeader(headers,key){
L1213 |   const field=productImportFields.find(x=>x.key===key);
L1214 |   return headers.find(h=>field.aliases.includes(String(h).trim().toLowerCase()))||'';
L1215 |  }
```

### zipRead16() — source lines 1216-1216

```javascript
L1216 | function zipRead16(view,offset){return view.getUint16(offset,true);}
```

### zipRead32() — source lines 1217-1217

```javascript
L1217 | function zipRead32(view,offset){return view.getUint32(offset,true);}
```

### openXlsxZip() — source lines 1218-1244

```javascript
L1218 | async function openXlsxZip(file){
L1219 |   if(!file||typeof file.slice!=='function'||!file.stream)throw new Error('المتصفح لا يدعم قراءة ملفات Excel المتدفقة.');
L1220 |   if(file.size>256*1024*1024)throw new Error('حجم ملف XLSX يتجاوز الحد الآمن 256MB. قسّم الملف إلى أجزاء أصغر.');
L1221 |   const tailSize=Math.min(file.size,65557),tail=new Uint8Array(await file.slice(file.size-tailSize).arrayBuffer()),tailView=new DataView(tail.buffer,tail.byteOffset,tail.byteLength);
L1222 |   let eocd=-1;for(let i=tail.length-22;i>=0;i--){if(zipRead32(tailView,i)===0x06054b50){eocd=i;break;}}
L1223 |   if(eocd<0)throw new Error('ملف XLSX غير صالح أو لا يحتوي على ZIP directory.');
L1224 |   if(zipRead16(tailView,eocd+4)!==0||zipRead16(tailView,eocd+6)!==0)throw new Error('ملفات Excel متعددة الأقراص غير مدعومة.');
L1225 |   const entries=zipRead16(tailView,eocd+10),entriesOnDisk=zipRead16(tailView,eocd+8),directorySize=zipRead32(tailView,eocd+12),directoryOffset=zipRead32(tailView,eocd+16),commentLength=zipRead16(tailView,eocd+20);
L1226 |   const eocdAbsolute=file.size-tailSize+eocd;
L1227 |   if(entries!==entriesOnDisk||entries===0xffff||directorySize===0xffffffff||directoryOffset===0xffffffff||eocd+22+commentLength!==tail.length)throw new Error('صيغة XLSX ZIP64 أو بنية أرشيف غير مدعومة.');
L1228 |   if(entries>10000||directorySize>32*1024*1024||directoryOffset+directorySize>eocdAbsolute)throw new Error('بيانات فهرس XLSX تتجاوز الحدود الآمنة.');
L1229 |   const directory=new Uint8Array(await file.slice(directoryOffset,directoryOffset+directorySize).arrayBuffer()),view=new DataView(directory.buffer,directory.byteOffset,directory.byteLength),map=new Map();let offset=0;
L1230 |   for(let i=0;i<entries;i++){
L1231 |    if(offset+46>directory.length||zipRead32(view,offset)!==0x02014b50)throw new Error('فهرس XLSX المركزي تالف.');
L1232 |    const flags=zipRead16(view,offset+8),method=zipRead16(view,offset+10),crc32=zipRead32(view,offset+16),compressedSize=zipRead32(view,offset+20),uncompressedSize=zipRead32(view,offset+24),nameLength=zipRead16(view,offset+28),extraLength=zipRead16(view,offset+30),comment=zipRead16(view,offset+32),disk=zipRead16(view,offset+34),localOffset=zipRead32(view,offset+42);
L1233 |    if(disk!==0||(flags&1)||(flags&0x40)||![0,8].includes(method)||compressedSize===0xffffffff||uncompressedSize===0xffffffff||localOffset===0xffffffff)throw new Error('ملف XLSX يحتوي على تشفير أو ضغط أو امتداد ZIP غير مدعوم.');
L1234 |    if(offset+46+nameLength+extraLength+comment>directory.length)throw new Error('بيانات اسم ملف داخل XLSX غير مكتملة.');
L1235 |    const name=new TextDecoder('utf-8').decode(directory.slice(offset+46,offset+46+nameLength)).replace(/\\/g,'/');
L1236 |    if(name.startsWith('/')||name.split('/').includes('..'))throw new Error('مسار داخلي غير صالح في ملف XLSX.');
L1237 |    if(map.has(name))throw new Error('أرشيف XLSX يحتوي على اسم عنصر مكرر.');
L1238 |    map.set(name,{name,flags,method,crc32,compressedSize,uncompressedSize,localOffset});
L1239 |    offset+=46+nameLength+extraLength+comment;
L1240 |   }
L1241 |   if(offset!==directory.length)throw new Error('حجم فهرس ZIP لا يطابق عدد عناصر XLSX.');
L1242 |   if(!map.has('xl/workbook.xml'))throw new Error('لم يتم العثور على xl/workbook.xml؛ الملف ليس XLSX صالحاً.');
L1243 |   return map;
L1244 |  }
```

### streamZipEntry() — source lines 1246-1269

```javascript
L1246 | async function streamZipEntry(file,entry,maxBytes,onChunk){
L1247 |   if(!entry)throw new Error('عنصر مطلوب غير موجود داخل ملف XLSX.');
L1248 |   if(entry.uncompressedSize>maxBytes)throw new Error('ورقة Excel أو جدول النصوص يتجاوز حد القراءة الآمن ('+Math.round(maxBytes/1024/1024)+'MB). قسّم الملف.');
L1249 |   const header=new DataView(await file.slice(entry.localOffset,entry.localOffset+30).arrayBuffer());
L1250 |   if(header.byteLength<30||zipRead32(header,0)!==0x04034b50)throw new Error('رأس عنصر XLSX المحلي غير صالح.');
L1251 |   const nameLength=zipRead16(header,26),extraLength=zipRead16(header,28),dataStart=entry.localOffset+30+nameLength+extraLength,dataEnd=dataStart+entry.compressedSize;
L1252 |   if(dataEnd>file.size)throw new Error('بيانات عنصر XLSX تتجاوز نهاية الملف.');
L1253 |   let stream=file.slice(dataStart,dataEnd).stream();
L1254 |   if(entry.method===8){
L1255 |    if(typeof DecompressionStream!=='function')throw new Error('هذا المتصفح لا يدعم فك ضغط XLSX المتدفق. استخدم متصفحاً حديثاً أو صدّر الملف CSV.');
L1256 |    try{stream=stream.pipeThrough(new DecompressionStream('deflate-raw'));}catch(e){throw new Error('تعذر تهيئة فك ضغط XLSX المتدفق: '+(e?.message||e));}
L1257 |   }
L1258 |   const reader=stream.getReader();let total=0,crc=0xffffffff;
L1259 |   try{
L1260 |    while(true){
L1261 |     const {value,done}=await reader.read();if(done)break;if(!value)continue;
L1262 |     total+=value.byteLength;if(total>maxBytes||total>entry.uncompressedSize){await reader.cancel();throw new Error('حجم المحتوى المفكوك في XLSX يتجاوز الحدود المعلنة.');}
L1263 |     for(let i=0;i<value.length;i++)crc=xlsxCrcTable[(crc^value[i])&255]^(crc>>>8);
L1264 |     await onChunk(value);
L1265 |    }
L1266 |   }catch(error){try{await reader.cancel(error);}catch(_){}throw error;}finally{reader.releaseLock();}
L1267 |   if(total!==entry.uncompressedSize)throw new Error('حجم عنصر XLSX بعد فك الضغط لا يطابق الفهرس.');
L1268 |   if(((crc^0xffffffff)>>>0)!==(entry.crc32>>>0))throw new Error('فشل التحقق من سلامة CRC لبيانات XLSX.');
L1269 |  }
```

### readXlsxEntryText() — source lines 1270-1274

```javascript
L1270 | async function readXlsxEntryText(file,entry,maxBytes){
L1271 |   const decoder=new TextDecoder('utf-8',{fatal:false});let text='';
L1272 |   await streamZipEntry(file,entry,maxBytes,chunk=>{text+=decoder.decode(chunk,{stream:true});if(text.length>maxBytes)throw new Error('ملف XML داخل XLSX أكبر من الحد الآمن.');});
L1273 |   text+=decoder.decode();return text;
L1274 |  }
```

### xmlAttr() — source lines 1275-1280

```javascript
L1275 | function xmlAttr(source,name){
L1276 |   const doubleQuoted=new RegExp('\\b'+name+'\\s*=\\s*"([^"]*)"','i').exec(source||'');
L1277 |   if(doubleQuoted)return doubleQuoted[1];
L1278 |   const singleQuoted=new RegExp("\\b"+name+"\\s*=\\s*'([^']*)'","i").exec(source||'');
L1279 |   return singleQuoted?singleQuoted[1]:'';
L1280 |  }
```

### xmlText() — source lines 1281-1281

```javascript
L1281 | function xmlText(value){return String(value??'').replace(/&#x([0-9a-f]+);/gi,(_,h)=>String.fromCodePoint(parseInt(h,16))).replace(/&#([0-9]+);/g,(_,n)=>String.fromCodePoint(parseInt(n,10))).replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&quot;/g,'"').replace(/&apos;/g,"'").replace(/&amp;/g,'&');}
```

### streamXmlRecords() — source lines 1282-1299

```javascript
L1282 | async function streamXmlRecords(file,entry,tag,maxBytes,maxRecordBytes,onRecord){
L1283 |   const decoder=new TextDecoder('utf-8',{fatal:false}),startRe=new RegExp('<'+tag+'\\b[^>]*>','i'),close='</'+tag+'>';let pending='';
L1284 |   const drain=async()=>{
L1285 |    while(true){
L1286 |     const start=pending.search(startRe);if(start<0){pending=pending.slice(-64);return;}
L1287 |     if(start>0)pending=pending.slice(start);
L1288 |     const openEnd=pending.indexOf('>');if(openEnd<0)return;
L1289 |     if(pending[openEnd-1]==='/'){pending=pending.slice(openEnd+1);continue;}
L1290 |     const closeAt=pending.indexOf(close,openEnd+1);if(closeAt<0)return;
L1291 |     const record=pending.slice(0,closeAt+close.length);pending=pending.slice(closeAt+close.length);
L1292 |     if(record.length>maxRecordBytes)throw new Error('صف Excel واحد يتجاوز حد الحجم الآمن.');
L1293 |     await onRecord(record);
L1294 |    }
L1295 |   };
L1296 |   await streamZipEntry(file,entry,maxBytes,async chunk=>{pending+=decoder.decode(chunk,{stream:true});await drain();if(pending.length>maxRecordBytes+128)throw new Error('سجل XML في XLSX أكبر من الحد الآمن.');});
L1297 |   pending+=decoder.decode();await drain();
L1298 |   if(pending.includes('<'+tag))throw new Error('انتهى ملف XLSX داخل سجل XML غير مكتمل.');
L1299 |  }
```

### parseXlsxSharedString() — source lines 1300-1300

```javascript
L1300 | function parseXlsxSharedString(record){let result='';for(const m of record.matchAll(/<t\b[^>]*>([\s\S]*?)<\/t>/g))result+=xmlText(m[1]);return result;}
```

### parseXlsxStyles() — source lines 1301-1307

```javascript
L1301 | function parseXlsxStyles(xml){
L1302 |   const custom=new Map(),formats=/<numFmts\b[^>]*>([\s\S]*?)<\/numFmts>/i.exec(xml||'');
L1303 |   for(const m of (formats?.[1]||'').matchAll(/<numFmt\b([^>]*)\/?>/gi))custom.set(Number(xmlAttr(m[1],'numFmtId')),xmlAttr(m[1],'formatCode'));
L1304 |   const block=/<cellXfs\b[^>]*>([\s\S]*?)<\/cellXfs>/i.exec(xml||''),result=[],builtin=new Set([14,15,16,17,18,19,20,21,22,27,28,29,30,31,32,33,34,35,36,45,46,47,50,51,52,53,54,55,56,57,58]);
L1305 |   for(const m of (block?.[1]||'').matchAll(/<xf\b([^>]*)\/?>/gi)){const id=Number(xmlAttr(m[1],'numFmtId')||0),fmt=String(custom.get(id)||'').replace(/"[^"]*"/g,'').replace(/\\./g,'').replace(/\[[^\]]*\]/g,'');result.push(builtin.has(id)||(/[ymdhs]/i.test(fmt)&&id>=164));}
L1306 |   return result;
L1307 |  }
```

### excelColumnIndex() — source lines 1308-1308

```javascript
L1308 | function excelColumnIndex(reference){const letters=/^[A-Z]+/i.exec(reference||'')?.[0]?.toUpperCase()||'';let n=0;for(const c of letters)n=n*26+c.charCodeAt(0)-64;return n?n-1:-1;}
```

### excelSerialDate() — source lines 1309-1309

```javascript
L1309 | function excelSerialDate(serial,date1904){const base=date1904?Date.UTC(1904,0,1):Date.UTC(1899,11,30),d=new Date(base+Number(serial)*86400000);return Number.isNaN(d.getTime())?'':(Number(serial)%1?d.toISOString():d.toISOString().slice(0,10));}
```

### xlsxCellValue() — source lines 1310-1320

```javascript
L1310 | function xlsxCellValue(cellXml,attrs,shared,styles,date1904){
L1311 |   const type=xmlAttr(attrs,'t'),style=Number(xmlAttr(attrs,'s')||0);
L1312 |   if(type==='inlineStr'){let text='';for(const m of cellXml.matchAll(/<t\b[^>]*>([\s\S]*?)<\/t>/g))text+=xmlText(m[1]);return text;}
L1313 |   const v=/<v\b[^>]*>([\s\S]*?)<\/v>/i.exec(cellXml)?.[1];if(v===undefined)return '';
L1314 |   const raw=xmlText(v);
L1315 |   if(type==='s'){const i=Number(raw);if(!Number.isInteger(i)||i<0||i>=shared.length)throw new Error('مرجع shared string غير صالح في XLSX.');return shared[i];}
L1316 |   if(type==='b')return raw==='1'?'TRUE':'FALSE';
L1317 |   if(type==='e'||type==='d')return raw;
L1318 |   if(styles[style]&&raw!==''&&Number.isFinite(Number(raw)))return excelSerialDate(raw,date1904);
L1319 |   return raw;
L1320 |  }
```

### makeUniqueXlsxHeaders() — source lines 1321-1323

```javascript
L1321 | function makeUniqueXlsxHeaders(values){
L1322 |   const used=new Set();return values.map((v,i)=>{const base=String(v??'').trim()||('Column '+(i+1));let name=base,n=2;while(used.has(name.toLowerCase()))name=base+' ('+(n++)+')';used.add(name.toLowerCase());return name;});
L1323 |  }
```

### streamXlsxProductRows() — source lines 1324-1354

```javascript
L1324 | async function streamXlsxProductRows(file,onRow){
L1325 |   const zip=await openXlsxZip(file),workbook=await readXlsxEntryText(file,zip.get('xl/workbook.xml'),4*1024*1024),rels=await readXlsxEntryText(file,zip.get('xl/_rels/workbook.xml.rels'),4*1024*1024);
L1326 |   const firstSheet=/<sheet\b([^>]*)\/?>/i.exec(workbook)?.[1];if(!firstSheet)throw new Error('لا توجد ورقة عمل داخل ملف XLSX.');
L1327 |   const rid=xmlAttr(firstSheet,'r:id');if(!rid)throw new Error('تعذر تحديد علاقة ورقة العمل الأولى.');
L1328 |   let target='';for(const m of rels.matchAll(/<Relationship\b([^>]*)\/?>/gi)){if(xmlAttr(m[1],'Id')===rid){if(/TargetMode\s*=\s*["']External/i.test(m[1]))throw new Error('رابط خارجي لورقة العمل غير مسموح.');target=xmlAttr(m[1],'Target');break;}}
L1329 |   if(!target)throw new Error('مسار ورقة العمل الأولى غير موجود في علاقات XLSX.');
L1330 |   const rawTarget=target.startsWith('/')?target.slice(1):'xl/'+target,parts=[];
L1331 |   for(const part of rawTarget.split('/')){if(part==='.'||!part)continue;if(part==='..'){if(!parts.length)throw new Error('مسار ورقة عمل غير آمن.');parts.pop();}else parts.push(part);}
L1332 |   const sheetPath=parts.join('/'),sheet=zip.get(sheetPath);if(!sheet)throw new Error('ملف XML الخاص بورقة العمل الأولى غير موجود: '+sheetPath);
L1333 |   let shared=[];const sharedEntry=zip.get('xl/sharedStrings.xml');
L1334 |   if(sharedEntry){let totalChars=0;await streamXmlRecords(file,sharedEntry,'si',64*1024*1024,1024*1024,record=>{const value=parseXlsxSharedString(record);totalChars+=value.length;if(shared.length>=300000||totalChars>48*1024*1024)throw new Error('جدول النصوص المشتركة في Excel يتجاوز الحد الآمن. قسّم الملف.');shared.push(value);});}
L1335 |   let styles=[];const stylesEntry=zip.get('xl/styles.xml');if(stylesEntry)styles=parseXlsxStyles(await readXlsxEntryText(file,stylesEntry,8*1024*1024));
L1336 |   const date1904=/\<workbookPr\b[^>]*date1904\s*=\s*["'](?:1|true)["']/i.test(workbook);
L1337 |   let headers=null,headerRowNumber=0,count=0;
L1338 |   await streamXmlRecords(file,sheet,'row',384*1024*1024,2*1024*1024,async record=>{
L1339 |    const rowAttrs=/<row\b([^>]*)>/i.exec(record)?.[1]||'',rowNumber=Number(xmlAttr(rowAttrs,'r'))||0,cells=new Map();let highest=-1;
L1340 |    for(const m of record.matchAll(/<c\b([^>]*)>([\s\S]*?)<\/c>|<c\b([^>]*)\/>/g)){
L1341 |     const attrs=m[1]||m[3]||'',body=m[2]||'',index=excelColumnIndex(xmlAttr(attrs,'r'));if(index<0)continue;
L1342 |     if(index>255)throw new Error('ورقة Excel تحتوي على أكثر من 256 عموداً في سجل واحد.');
L1343 |     cells.set(index,xlsxCellValue(body,attrs,shared,styles,date1904));if(index>highest)highest=index;
L1344 |    }
L1345 |    if(highest<0)return;
L1346 |    if(!headers){headers=makeUniqueXlsxHeaders(Array.from({length:highest+1},(_,i)=>cells.get(i)??''));headerRowNumber=rowNumber||1;return;}
L1347 |    const recordRow={};headers.forEach((h,i)=>recordRow[h]=cells.get(i)??'');
L1348 |    if(!headers.some(h=>String(recordRow[h]??'').trim()!==''))return;
L1349 |    Object.defineProperty(recordRow,'__countflowRowNumber',{value:rowNumber||headerRowNumber+count+1,enumerable:false});
L1350 |    count++;if(onRow)await onRow(recordRow);
L1351 |   });
L1352 |   if(!headers)throw new Error('لم يتم العثور على صف عناوين في ورقة Excel الأولى.');
L1353 |   return {headers,count};
L1354 |  }
```

### parseProductImportFile() — source lines 1355-1379

```javascript
L1355 | async function parseProductImportFile(file){
L1356 |   const ext=(file.name.split('.').pop()||'').toLowerCase();
L1357 |   if(ext==='xlsx'){
L1358 |    const sample=[],parsed=await streamXlsxProductRows(file,row=>{if(sample.length<20)sample.push(row);});
L1359 |    return {rows:null,sample,count:parsed.count,headers:parsed.headers,streaming:true};
L1360 |   }
L1361 |   if(ext==='xls'){
L1362 |    if(file.size>8*1024*1024)throw new Error('ملفات XLS الثنائية القديمة محدودة بـ8MB لتجنب استهلاك الذاكرة. احفظ الملف بصيغة XLSX ثم أعد المحاولة.');
L1363 |    if(!window.XLSX)throw new Error('مكتبة قراءة ملفات XLS القديمة غير متاحة.');
L1364 |    const book=XLSX.read(await file.arrayBuffer(),{type:'array',cellDates:false});
L1365 |    if(!book.SheetNames?.length)throw new Error('ملف XLS لا يحتوي على أوراق عمل.');
L1366 |    const rows=XLSX.utils.sheet_to_json(book.Sheets[book.SheetNames[0]],{defval:'',raw:false,blankrows:false});
L1367 |    return {rows,sample:rows.slice(0,20),count:rows.length,headers:Object.keys(rows[0]||{}),streaming:false,legacyBinary:true};
L1368 |   }
L1369 |   if(ext==='csv'){
L1370 |    if(!window.Papa)throw new Error('مكتبة قراءة CSV غير متاحة. أعد تحميل الصفحة ثم حاول مرة أخرى.');
L1371 |    return await new Promise((resolve,reject)=>{
L1372 |     const sample=[],headers=[];let count=0,parseErrors=0;
L1373 |     Papa.parse(file,{header:true,skipEmptyLines:'greedy',dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L1374 |      step:r=>{if(r.errors?.length){parseErrors+=r.errors.length;return;}const row=r.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;if(!headers.length)headers.push(...(r.meta?.fields||Object.keys(row)));count++;if(sample.length<20)sample.push(row);},
L1375 |      complete:()=>resolve({rows:null,sample,count,headers,streaming:true,parseErrors}),error:reject});
L1376 |    });
L1377 |   }
L1378 |   throw new Error('امتداد الملف غير مدعوم. استخدم XLSX أو CSV أو XLS صغيراً حتى 8MB.');
L1379 |  }
```

### hashFileInChunks() — source lines 1380-1388

```javascript
L1380 | async function hashFileInChunks(file){
L1381 |   let previous=new Uint8Array(32),offset=0;const chunkSize=1024*1024;
L1382 |   while(offset<file.size){
L1383 |    const part=new Uint8Array(await file.slice(offset,Math.min(file.size,offset+chunkSize)).arrayBuffer());
L1384 |    const input=new Uint8Array(previous.length+part.length);input.set(previous);input.set(part,previous.length);
L1385 |    previous=new Uint8Array(await crypto.subtle.digest('SHA-256',input));offset+=part.length;
L1386 |   }
L1387 |   return 'sha256-chain-v1:'+Array.from(previous,v=>v.toString(16).padStart(2,'0')).join('');
L1388 |  }
```

### globalCatalogImportValue() — source lines 1402-1405

```javascript
L1402 | function globalCatalogImportValue(row,key,mapping=state.globalCatalogImport.mapping){
L1403 |   const header=mapping?.[key];
L1404 |   return header&&Object.prototype.hasOwnProperty.call(row,header)?row[header]:'';
L1405 |  }
```

### renderGlobalCatalogImportMapping() — source lines 1406-1423

```javascript
L1406 | function renderGlobalCatalogImportMapping(){
L1407 |   const g=state.globalCatalogImport,host=$('globalCatalogImportMapping'),headers=g.headers||[];
L1408 |   if(!headers.length)throw new Error('لم يتم العثور على عناوين أعمدة في الملف.');
L1409 |   g.mapping=g.mapping||{};
L1410 |   for(const field of globalCatalogImportFields){
L1411 |    if(!Object.prototype.hasOwnProperty.call(g.mapping,field.key)){
L1412 |     const aliases=field.aliases.map(x=>String(x).trim().toLocaleLowerCase());
L1413 |     g.mapping[field.key]=headers.find(h=>aliases.includes(String(h).trim().toLocaleLowerCase()))||'';
L1414 |    }
L1415 |   }
L1416 |   host.classList.remove('hidden');
L1417 |   host.innerHTML='<div class="panel" style="box-shadow:none;margin:0;padding:12px"><b>مطابقة أعمدة الملف مع الدليل العالمي</b><p class="hint">اسم الصنف ووحدة الأساس إلزاميان. SKU والباركود اختياريان؛ عند غيابهما يُنشأ SKU داخلي ثابت من بصمة الملف ورقم الصف. لا ينشئ هذا المسار أرصدة أو حركات جرد أو قيوداً مالية.</p><div class="fields">'+globalCatalogImportFields.map(f=>'<div class="field"><label>'+esc(f.label)+'</label><select data-global-catalog-import-map="'+f.key+'"><option value="">— تجاهل الحقل —</option>'+headers.map(h=>'<option value="'+esc(h)+'" '+(g.mapping[f.key]===h?'selected':'')+'>'+esc(h)+'</option>').join('')+'</select></div>').join('')+'</div></div>';
L1418 |   host.querySelectorAll('[data-global-catalog-import-map]').forEach(select=>select.onchange=()=>{
L1419 |    g.mapping[select.dataset.globalCatalogImportMap]=select.value;
L1420 |    $('globalCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||!g.mapping.base_unit;
L1421 |   });
L1422 |   $('globalCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||!g.mapping.base_unit;
L1423 |  }
```

### renderGlobalCatalogImportPreview() — source lines 1424-1428

```javascript
L1424 | function renderGlobalCatalogImportPreview(){
L1425 |   const g=state.globalCatalogImport,headers=g.headers||[],rows=(g.sample||[]).slice(0,8);
L1426 |   const sample=rows.length?'<div class="tablewrap"><table><thead><tr>'+headers.slice(0,8).map(h=>'<th>'+esc(h)+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+headers.slice(0,8).map(h=>'<td>'+esc(String(r[h]??'').slice(0,80))+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>':'';
L1427 |   $('globalCatalogImportPreviewText').innerHTML='<b>معاينة الملف: '+Number(g.count||0).toLocaleString('en-US')+' صف</b><span class="sub"> أول ورقة / أول 8 صفوف للمعاينة · '+headers.length+' عمود</span>'+sample;
L1428 |  }
```

### resetGlobalCatalogImport() — source lines 1429-1443

```javascript
L1429 | function resetGlobalCatalogImport(){
L1430 |   const g=state.globalCatalogImport;
L1431 |   if(g?.busy)return notify('لا يمكن إلغاء الملف أثناء تنفيذ دفعة؛ انتظر اكتمال الاستدعاء الحالي.',true);
L1432 |   state.globalCatalogImport={file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',parseErrors:0,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}};
L1433 |   $('globalCatalogImportFile').value='';
L1434 |   $('globalCatalogImportMapping').classList.add('hidden');
L1435 |   $('globalCatalogImportMapping').innerHTML='';
L1436 |   $('globalCatalogImportPreviewText').textContent='';
L1437 |   $('globalCatalogImportProgress').textContent='لم يبدأ الاستيراد';
L1438 |   $('globalCatalogImportProgressFill').style.width='0%';
L1439 |   $('globalCatalogImportErrors').innerHTML='';
L1440 |   $('globalCatalogImportCommit').disabled=true;
L1441 |   $('globalCatalogImportPreview').disabled=false;
L1442 |   $('globalCatalogImportReset').disabled=false;
L1443 |  }
```

### previewGlobalCatalogImport() — source lines 1444-1474

```javascript
L1444 | async function previewGlobalCatalogImport(){
L1445 |   if(!state.platformOwner)return notify('استيراد الدليل العالمي متاح لمالك المنصة فقط.',true);
L1446 |   const file=$('globalCatalogImportFile').files?.[0];
L1447 |   if(!file)return notify('اختر ملف CSV أو XLSX أولاً.',true);
L1448 |   if(state.globalCatalogImport?.busy)return;
L1449 |   const previewButton=$('globalCatalogImportPreview'),commitButton=$('globalCatalogImportCommit'),resetButton=$('globalCatalogImportReset');
L1450 |   previewButton.disabled=true;commitButton.disabled=true;resetButton.disabled=true;
L1451 |   $('globalCatalogImportProgress').textContent='جار فحص بنية الملف وقراءة عينة من الصفوف…';
L1452 |   $('globalCatalogImportErrors').innerHTML='';
L1453 |   try{
L1454 |    const parsed=await parseProductImportFile(file);
L1455 |    if(!parsed.count)throw new Error('لا توجد صفوف بيانات قابلة للقراءة.');
L1456 |    if(parsed.count>90000)throw new Error('الحد الأقصى للدليل العالمي 90,000 صف في الملف الواحد.');
L1457 |    const ext=(file.name.split('.').pop()||'').toLowerCase();
L1458 |    if(!['csv','xlsx','xls'].includes(ext))throw new Error('امتداد الملف غير مدعوم. استخدم CSV أو XLSX.');
L1459 |    state.globalCatalogImport={file,count:parsed.count,headers:parsed.headers||Object.keys((parsed.sample||parsed.rows||[])[0]||{}),sample:parsed.sample||parsed.rows||[],mapping:{},busy:false,checksum:'',sourceFormat:ext==='csv'?'csv':ext==='xlsx'?'xlsx':'xls',parseErrors:Number(parsed.parseErrors||0),stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}};
L1460 |    renderGlobalCatalogImportMapping();
L1461 |    renderGlobalCatalogImportPreview();
L1462 |    $('globalCatalogImportProgress').textContent=(parsed.streaming?'تم فحص الملف دون تحميل جميع صفوفه إلى الذاكرة. ':'تمت قراءة الملف. ')+Number(parsed.count).toLocaleString('en-US')+' صف؛ راجع مطابقة الأعمدة قبل الاستيراد.';
L1463 |    if(parsed.parseErrors)$('globalCatalogImportProgress').textContent+=' أخطاء تحليل CSV المتجاوزة في المعاينة: '+parsed.parseErrors;
L1464 |   }catch(error){
L1465 |    state.globalCatalogImport={file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',parseErrors:0,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}};
L1466 |    $('globalCatalogImportPreviewText').textContent='';
L1467 |    $('globalCatalogImportMapping').classList.add('hidden');
L1468 |    $('globalCatalogImportProgress').textContent='تعذرت المعاينة: '+friendlyErrorMessage(error);
L1469 |    fail('تعذرت معاينة ملف الدليل العالمي',error);
L1470 |   }finally{
L1471 |    previewButton.disabled=false;resetButton.disabled=false;
L1472 |    commitButton.disabled=!state.globalCatalogImport.count||!state.globalCatalogImport.mapping.name||!state.globalCatalogImport.mapping.base_unit;
L1473 |   }
L1474 |  }
```

### normalizeGlobalCatalogImportRow() — source lines 1475-1519

```javascript
L1475 | function normalizeGlobalCatalogImportRow(row,index,sourceRowNumber=null,checksum='',mapping=state.globalCatalogImport.mapping,allowMissingBaseUnit=false){
L1476 |   const value=key=>String(globalCatalogImportValue(row,key,mapping)??'').trim();
L1477 |   const rowNumber=Number(sourceRowNumber||row.__countflowRowNumber||index+2);
L1478 |   const name=value('name'),baseUnit=value('base_unit');
L1479 |   if(!name)throw new Error('اسم الصنف مطلوب.');
L1480 |   if(name.length>240)throw new Error('اسم الصنف يتجاوز 240 حرفاً.');
L1481 |   if(!baseUnit&&!allowMissingBaseUnit)throw new Error('وحدة الأساس مطلوبة.');
L1482 |   if(baseUnit.length>40)throw new Error('اسم وحدة الأساس يتجاوز 40 حرفاً.');
L1483 |   let sku=value('sku')||null,barcode=value('barcode')||null;
L1484 |   if(sku&&sku.length>100)throw new Error('SKU يتجاوز 100 حرف.');
L1485 |   if(barcode&&barcode.length>120)throw new Error('الباركود يتجاوز 120 حرفاً.');
L1486 |   const unitClassRaw=value('unit_class'),unitClass=['count','mass','volume','length','area','other'].includes(unitClassRaw)?unitClassRaw:inferProductUnitClass(baseUnit);
L1487 |   const precisionRaw=value('decimal_precision'),decimalPrecision=precisionRaw===''?defaultProductUnitPrecision(unitClass):Number(precisionRaw);
L1488 |   let itemKind=value('item_kind').toUpperCase(),barcodeType=barcode?cfResolveBarcodeType(barcode,value('barcode_type')||'AUTO'):'INTERNAL';
L1489 |   const deterministic='CFI-'+String(checksum||'IMPORT').replace(/[^A-F0-9]/gi,'').slice(-12).toUpperCase().padStart(12,'0')+'-'+String(rowNumber).padStart(7,'0');
L1490 |   if(!sku)sku=deterministic;
L1491 |   if(!itemKind)itemKind=unitClass==='mass'?'WEIGHED':(barcode?'BARCODED':'NO_BARCODE');
L1492 |   if(!['BARCODED','WEIGHED','NO_BARCODE'].includes(itemKind))throw new Error('نوع الصنف غير مدعوم.');
L1493 |   if(itemKind==='WEIGHED'&&unitClass!=='mass'&&!allowMissingBaseUnit)throw new Error('الصنف الوزني يجب أن يستخدم فئة قياس الوزن.');
L1494 |   if(itemKind==='BARCODED'&&(!barcode||barcodeType==='INTERNAL')&&!allowMissingBaseUnit)throw new Error('الصنف المحدد كصنف بباركود يحتاج باركوداً خارجياً صالحاً.');
L1495 |   if(itemKind==='NO_BARCODE'&&barcode&&barcodeType!=='INTERNAL')throw new Error('الصنف بدون باركود لا يقبل رمزاً خارجياً.');
L1496 |   const parsedUnits=cfParseUnitRows(value('units'));
L1497 |   if(!Array.isArray(parsedUnits)||parsedUnits.length>50)throw new Error('عدد الوحدات البديلة يجب ألا يتجاوز 50 وحدة.');
L1498 |   const seenNames=new Set(),seenCodes=new Set();if(barcode)seenCodes.add(barcode.toLocaleLowerCase());
L1499 |   const units=parsedUnits.map(entry=>{
L1500 |    if(!entry||typeof entry!=='object'||Array.isArray(entry))throw new Error('صيغة إحدى الوحدات البديلة غير صحيحة.');
L1501 |    const unitName=String(entry.name??'').trim(),factor=Number(entry.factor_to_base??entry.conversion_factor??entry.factor);
L1502 |    if(!unitName||unitName.length>40)throw new Error('اسم الوحدة البديلة مطلوب ولا يتجاوز 40 حرفاً.');
L1503 |    const key=normalizeUnitName(unitName);
L1504 |    if(key===normalizeUnitName(baseUnit)||seenNames.has(key))throw new Error('الوحدة البديلة مكررة أو تطابق وحدة الأساس.');
L1505 |    if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل تحويل الوحدة البديلة غير صالح.');
L1506 |    const unit={name:unitName,factor_to_base:factor},unitBarcode=String(entry.barcode??'').trim();
L1507 |    if(unitBarcode){
L1508 |     if(unitBarcode.length>120)throw new Error('باركود الوحدة البديلة أطول من الحد المسموح.');
L1509 |     const codeKey=unitBarcode.toLocaleLowerCase();
L1510 |     if(seenCodes.has(codeKey))throw new Error('باركود الصنف أو إحدى وحداته مكرر.');
L1511 |     seenCodes.add(codeKey);unit.barcode=unitBarcode;unit.barcode_type=cfResolveBarcodeType(unitBarcode,entry.barcode_type||'AUTO');
L1512 |    }
L1513 |    seenNames.add(key);return unit;
L1514 |   });
L1515 |   const brand=value('brand'),category=value('category');
L1516 |   if(brand.length>120)throw new Error('اسم العلامة التجارية يتجاوز 120 حرفاً.');
L1517 |   if(category.length>120)throw new Error('اسم التصنيف يتجاوز 120 حرفاً.');
L1518 |   return {_row_number:rowNumber,canonical_sku:sku,barcode:barcode||null,name,brand:brand||null,category:category||null,base_unit:baseUnit,units:withProductUnitMeta(units,unitClass,decimalPrecision,{item_kind:itemKind,barcode_type:barcodeType})};
L1519 |  }
```

### renderGlobalCatalogImportErrors() — source lines 1520-1523

```javascript
L1520 | function renderGlobalCatalogImportErrors(){
L1521 |   const errors=state.globalCatalogImport?.stats?.errors||[];
L1522 |   $('globalCatalogImportErrors').innerHTML=errors.length?'<table><thead><tr><th>صف المصدر</th><th>SKU</th><th>الباركود</th><th>سبب الرفض</th></tr></thead><tbody>'+errors.map(e=>'<tr><td>'+Number(e.row_number||0)+'</td><td>'+esc(e.sku||'')+'</td><td>'+esc(e.barcode||'')+'</td><td>'+esc(e.error||'تعذر قبول الصف')+'</td></tr>').join('')+'</tbody></table>':'';
L1523 |  }
```

### catalogImportIdentityKeys() — source lines 1524-1531

```javascript
L1524 | function catalogImportIdentityKeys(row){
L1525 |  const keys=[],add=(kind,value)=>{const normalized=String(value||'').trim().toLocaleLowerCase();if(normalized)keys.push(kind+':'+normalized);};
L1526 |  add('sku',row?.canonical_sku);add('sku',row?.sku);add('client-sku',row?.client_sku);
L1527 |  add('barcode',row?.barcode);add('barcode',row?.client_barcode);add('client-sku',row?.client_sku);
L1528 |  for(const unit of Array.isArray(row?.units)?row.units:[])add('barcode',unit?.barcode);
L1529 |  for(const unit of [...(Array.isArray(row?.client_units)?row.client_units:[]),...(Array.isArray(row?.client_units_override)?row.client_units_override:[])])add('barcode',unit?.barcode);
L1530 |  return [...new Set(keys)];
L1531 | }
```

### reserveCatalogImportIdentities() — source lines 1532-1536

```javascript
L1532 | function reserveCatalogImportIdentities(row,seen){
L1533 |  const keys=catalogImportIdentityKeys(row);
L1534 |  if(keys.some(key=>seen.has(key)))return false;
L1535 |  keys.forEach(key=>seen.add(key));return true;
L1536 | }
```

### updateGlobalCatalogImportProgress() — source lines 1537-1542

```javascript
L1537 | function updateGlobalCatalogImportProgress(){
L1538 |   const g=state.globalCatalogImport,stats=g.stats||{},total=Math.max(0,Number(g.count||0)),processed=Math.min(total,Number(stats.processed||0)),percent=total?Math.min(100,Math.round(processed/total*100)):0;
L1539 |   $('globalCatalogImportProgressFill').style.width=percent+'%';
L1540 |   $('globalCatalogImportProgress').textContent='المعالجة '+processed.toLocaleString('en-US')+' / '+total.toLocaleString('en-US')+' · أضيف '+Number(stats.inserted||0).toLocaleString('en-US')+' · حُدث '+Number(stats.updated||0).toLocaleString('en-US')+' · مكرر متجاهل '+Number(stats.duplicates||0).toLocaleString('en-US')+' · رُفض '+Number(stats.rejected||0).toLocaleString('en-US');
L1541 |   renderGlobalCatalogImportErrors();
L1542 |  }
```

### commitGlobalCatalogChunk() — source lines 1543-1555

```javascript
L1543 | async function commitGlobalCatalogChunk(rows){
L1544 |   if(!rows.length)return;
L1545 |   const {data,error}=await db.rpc('count_upsert_catalog_products_chunk',{p_rows:rows});
L1546 |   if(error)throw error;
L1547 |   if(!data||typeof data!=='object')throw new Error('استجابة RPC لاستيراد الدليل غير صالحة.');
L1548 |   const stats=state.globalCatalogImport.stats;
L1549 |   stats.processed+=rows.length;stats.inserted+=Number(data.inserted||0);stats.updated+=Number(data.updated||0);stats.rejected+=Number(data.rejected||0);
L1550 |   for(const item of (Array.isArray(data.errors)?data.errors:[])){
L1551 |    if(stats.errors.length>=120)break;
L1552 |    stats.errors.push({row_number:item.row_number,sku:item.sku,barcode:item.barcode,error:item.error||'رفض الخادم الصف'});
L1553 |   }
L1554 |   updateGlobalCatalogImportProgress();
L1555 |  }
```

### commitGlobalCatalogImport() — source lines 1556-1637

```javascript
L1556 | async function commitGlobalCatalogImport(){
L1557 |   if(!state.platformOwner)return notify('استيراد الدليل العالمي متاح لمالك المنصة فقط.',true);
L1558 |   const g=state.globalCatalogImport,file=$('globalCatalogImportFile').files?.[0];
L1559 |   if(g.busy)return;
L1560 |   if(!g.file||!file||file!==g.file)return notify('الملف الحالي تغير؛ أعد معاينته قبل الاستيراد.',true);
L1561 |   if(!g.mapping?.name||!g.mapping?.base_unit)return notify('اربط عمود اسم الصنف ووحدة الأساس أولاً.',true);
L1562 |   if(g.count<1||g.count>90000)return notify('عدد الصفوف خارج الحد التشغيلي 1–90,000.',true);
L1563 |   g.busy=true;g.stats={processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]};
L1564 |   const controls=['globalCatalogImportPreview','globalCatalogImportCommit','globalCatalogImportReset'];
L1565 |   controls.forEach(id=>$(id).disabled=true);
L1566 |   $('globalCatalogImportFile').disabled=true;
L1567 |   $('globalCatalogImportProgress').textContent='جار حساب بصمة الملف وتجهيز الاستيراد…';
L1568 |   $('globalCatalogImportErrors').innerHTML='';
L1569 |   let pending=[],rowIndex=0,parseErrors=0;const seenIdentities=new Set();
L1570 |   const recordLocalError=(row,rowNumber,error)=>{
L1571 |    const stats=state.globalCatalogImport.stats;stats.processed++;stats.rejected++;
L1572 |    if(stats.errors.length<120)stats.errors.push({row_number:rowNumber,sku:String(globalCatalogImportValue(row,'sku')||''),barcode:String(globalCatalogImportValue(row,'barcode')||''),error:error?.message||String(error)});
L1573 |    updateGlobalCatalogImportProgress();
L1574 |   };
L1575 |   const acceptRow=(row,sourceRowNumber)=>{
L1576 |    try{
L1577 |     const normalized=normalizeGlobalCatalogImportRow(row,rowIndex,sourceRowNumber,g.checksum);
L1578 |     if(!reserveCatalogImportIdentities(normalized,seenIdentities)){
L1579 |      const stats=state.globalCatalogImport.stats;stats.processed++;stats.duplicates++;updateGlobalCatalogImportProgress();
L1580 |     }else pending.push(normalized);
L1581 |    }catch(error){recordLocalError(row,sourceRowNumber,error);}
L1582 |    rowIndex++;
L1583 |   };
L1584 |   const flush=async()=>{if(!pending.length)return;const rows=pending;pending=[];await commitGlobalCatalogChunk(rows);};
L1585 |   try{
L1586 |    g.checksum=await hashFileInChunks(file);
L1587 |    if(g.sourceFormat==='csv'){
L1588 |     await new Promise((resolve,reject)=>{
L1589 |      let chain=Promise.resolve(),sourceRowNumber=2,settled=false;
L1590 |      const failParse=error=>{if(settled)return;settled=true;reject(error);};
L1591 |      Papa.parse(file,{header:true,skipEmptyLines:'greedy',dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L1592 |       step:(result,parser)=>{
L1593 |        const rowNumber=sourceRowNumber++;
L1594 |        if(result.errors?.length){parseErrors+=result.errors.length;recordLocalError(result.data||{},rowNumber,new Error('تعذر تحليل صف CSV: '+result.errors.map(x=>x.message).join('، ')));return;}
L1595 |        const row=result.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;
L1596 |        acceptRow(row,rowNumber);
L1597 |        if(pending.length>=500){
L1598 |         parser.pause();const chunk=pending;pending=[];
L1599 |         chain=chain.then(()=>commitGlobalCatalogChunk(chunk)).then(()=>parser.resume()).catch(error=>{parser.abort();failParse(error);});
L1600 |        }
L1601 |       },
L1602 |       complete:async()=>{
L1603 |        if(settled)return;
L1604 |        try{await chain;await flush();if(!rowIndex&&!state.globalCatalogImport.stats.rejected)throw new Error('لم يتم العثور على صفوف بيانات قابلة للقراءة.');settled=true;resolve();}
L1605 |        catch(error){failParse(error);}
L1606 |       },error:failParse});
L1607 |     });
L1608 |    }else if(g.sourceFormat==='xlsx'){
L1609 |     const parsed=await streamXlsxProductRows(file,async row=>{
L1610 |      const rowNumber=Number(row.__countflowRowNumber||rowIndex+2);
L1611 |      acceptRow(row,rowNumber);
L1612 |      if(pending.length>=500)await flush();
L1613 |     });
L1614 |     if(parsed.count!==g.count)throw new Error('تغير عدد صفوف XLSX بعد المعاينة. أعد معاينة الملف قبل الاستيراد.');
L1615 |     await flush();
L1616 |    }else{
L1617 |     const parsed=await parseProductImportFile(file),rows=parsed.rows||[];
L1618 |     if(parsed.count!==g.count||!rows.length)throw new Error('تعذر إعادة قراءة ملف XLS؛ أعد المعاينة.');
L1619 |     for(let i=0;i<rows.length;i++){acceptRow(rows[i],i+2);if(pending.length>=500)await flush();}
L1620 |     await flush();
L1621 |    }
L1622 |    if(rowIndex>g.count)throw new Error('عدد الصفوف أثناء الاستيراد تجاوز العدد الذي تمت معاينته.');
L1623 |    const stats=g.stats;
L1624 |    $('globalCatalogImportProgressFill').style.width='100%';
L1625 |    $('globalCatalogImportProgress').textContent='اكتمل فحص الملف · صفوف '+rowIndex.toLocaleString('en-US')+' · أضيف '+stats.inserted.toLocaleString('en-US')+' · حُدث '+stats.updated.toLocaleString('en-US')+' · مكرر متجاهل '+Number(stats.duplicates||0).toLocaleString('en-US')+' · رُفض '+stats.rejected.toLocaleString('en-US')+(parseErrors?' · أخطاء تحليل '+parseErrors:'');
L1626 |    renderGlobalCatalogImportErrors();
L1627 |    notify('اكتمل استيراد الدليل العالمي. الأرصدة وحركات الجرد لم تتغير.');
L1628 |    try{await loadCatalog();}catch(refreshError){fail('اكتمل الاستيراد لكن تعذر تحديث عرض الدليل',refreshError);}
L1629 |   }catch(error){
L1630 |    $('globalCatalogImportProgress').textContent='توقف الاستيراد عند '+Number(g.stats.processed||0).toLocaleString('en-US')+' صف. الدفعات التي قُبلت محفوظة؛ أعد تشغيل الملف نفسه لاستكمال/تحديث السجلات بأمان. '+friendlyErrorMessage(error);
L1631 |    fail('تعذر استكمال استيراد الدليل العالمي',error);
L1632 |   }finally{
L1633 |    g.busy=false;$('globalCatalogImportFile').disabled=false;
L1634 |    controls.forEach(id=>$(id).disabled=false);
L1635 |    $('globalCatalogImportCommit').disabled=!g.count||!g.mapping?.name||!g.mapping?.base_unit;
L1636 |   }
L1637 |  }
```

### clientCatalogImportValue() — source lines 1657-1659

```javascript
L1657 | function clientCatalogImportValue(row,key,mapping=state.clientCatalogImport.mapping){
L1658 |  const header=mapping?.[key];return header&&Object.prototype.hasOwnProperty.call(row,header)?row[header]:'';
L1659 | }
```

### renderClientCatalogImportMapping() — source lines 1660-1677

```javascript
L1660 | function renderClientCatalogImportMapping(){
L1661 |  const g=state.clientCatalogImport,host=$('clientCatalogImportMapping'),headers=g.headers||[];
L1662 |  if(!headers.length)throw new Error('لم يتم العثور على عناوين أعمدة في ملف المؤسسة.');
L1663 |  g.mapping=g.mapping||{};
L1664 |  for(const field of clientCatalogImportFields){
L1665 |   if(!Object.prototype.hasOwnProperty.call(g.mapping,field.key)){
L1666 |    const aliases=field.aliases.map(x=>String(x).trim().toLocaleLowerCase());
L1667 |    g.mapping[field.key]=headers.find(h=>aliases.includes(String(h).trim().toLocaleLowerCase()))||'';
L1668 |   }
L1669 |  }
L1670 |  host.classList.remove('hidden');
L1671 |  host.innerHTML='<div class="panel" style="box-shadow:none;margin:0;padding:12px"><b>مطابقة أعمدة ملف المؤسسة</b><p class="hint">اسم الصنف ومعرّف SKU أو باركود مطلوب. وحدة الأساس مطلوبة فقط عند إنشاء صنف عالمي جديد؛ الصنف الموجود يمكن ربطه دون إعادة إدخال وحدة الأساس. الاختلافات الخاصة بالمؤسسة تحفظ كحقول محلية ولا تُستبدل البيانات العالمية.</p><div class="fields">'+clientCatalogImportFields.map(f=>'<div class="field"><label>'+esc(f.label)+'</label><select data-client-catalog-import-map="'+f.key+'"><option value="">— تجاهل الحقل —</option>'+headers.map(h=>'<option value="'+esc(h)+'" '+(g.mapping[f.key]===h?'selected':'')+'>'+esc(h)+'</option>').join('')+'</select></div>').join('')+'</div></div>';
L1672 |  host.querySelectorAll('[data-client-catalog-import-map]').forEach(select=>select.onchange=()=>{
L1673 |   g.mapping[select.dataset.clientCatalogImportMap]=select.value;
L1674 |   $('clientCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||(!g.mapping.sku&&!g.mapping.barcode&&!g.mapping.client_sku&&!g.mapping.client_barcode);
L1675 |  });
L1676 |  $('clientCatalogImportCommit').disabled=!!g.busy||!g.mapping.name||(!g.mapping.sku&&!g.mapping.barcode&&!g.mapping.client_sku&&!g.mapping.client_barcode);
L1677 | }
```

### renderClientCatalogImportPreview() — source lines 1678-1682

```javascript
L1678 | function renderClientCatalogImportPreview(){
L1679 |  const g=state.clientCatalogImport,headers=g.headers||[],rows=(g.sample||[]).slice(0,8);
L1680 |  const sample=rows.length?'<div class="tablewrap"><table><thead><tr>'+headers.slice(0,8).map(h=>'<th>'+esc(h)+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+headers.slice(0,8).map(h=>'<td>'+esc(String(r[h]??'').slice(0,80))+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>':'';
L1681 |  $('clientCatalogImportPreviewText').innerHTML='<b>معاينة الملف: '+Number(g.count||0).toLocaleString('en-US')+' صف</b><span class="sub"> أول 8 صفوف · '+headers.length+' عمود</span>'+sample;
L1682 | }
```

### renderClientCatalogImportErrors() — source lines 1683-1686

```javascript
L1683 | function renderClientCatalogImportErrors(){
L1684 |  const errors=state.clientCatalogImport?.stats?.errors||[];
L1685 |  $('clientCatalogImportErrors').innerHTML=errors.length?'<table><thead><tr><th>صف الملف</th><th>SKU</th><th>الباركود</th><th>سبب الرفض</th></tr></thead><tbody>'+errors.map(e=>'<tr><td>'+Number(e.row_number||0)+'</td><td>'+esc(e.sku||'')+'</td><td>'+esc(e.barcode||'')+'</td><td>'+esc(e.error||'تعذر قبول الصف')+'</td></tr>').join('')+'</tbody></table>':'';
L1686 | }
```

### updateClientCatalogImportProgress() — source lines 1687-1692

```javascript
L1687 | function updateClientCatalogImportProgress(){
L1688 |  const g=state.clientCatalogImport,stats=g.stats||{},total=Math.max(0,Number(g.count||0)),processed=Math.min(total,Number(stats.processed||0)),percent=total?Math.min(100,Math.round(processed/total*100)):0;
L1689 |  $('clientCatalogImportProgressFill').style.width=percent+'%';
L1690 |  $('clientCatalogImportProgress').textContent='المعالجة '+processed.toLocaleString('en-US')+' / '+total.toLocaleString('en-US')+' · أصناف عالمية جديدة '+Number(stats.catalogInserted||0).toLocaleString('en-US')+' · مطابقة مع الدليل '+Number(stats.catalogMatched||0).toLocaleString('en-US')+' · ربط جديد '+Number(stats.clientInserted||0).toLocaleString('en-US')+' · مواءمات محدثة '+Number(stats.clientUpdated||0).toLocaleString('en-US')+' · مكرر متجاهل '+Number(stats.duplicates||0).toLocaleString('en-US')+' · مرفوض '+Number(stats.rejected||0).toLocaleString('en-US');
L1691 |  renderClientCatalogImportErrors();
L1692 | }
```

### normalizeClientCatalogImportRow() — source lines 1693-1732

```javascript
L1693 | function normalizeClientCatalogImportRow(row,index,sourceRowNumber,checksum,mapping){
L1694 |  const value=key=>String(globalCatalogImportValue(row,key,mapping)??'').trim();
L1695 |  const source=normalizeGlobalCatalogImportRow(row,index,sourceRowNumber,checksum,mapping,true);
L1696 |  // Global-import normalizer generates a deterministic CFI SKU when its SKU column is blank.
L1697 |  // Client import must not mistake that internal fallback for an institution SKU when a
L1698 |  // matching global product is resolved by barcode or by an existing client identifier.
L1699 |  if(!value('sku'))source.canonical_sku=null;
L1700 |  if(!value('barcode'))source.barcode=null;
L1701 |  if(!source.base_unit&&value('units'))throw new Error('وحدة الأساس مطلوبة للتحقق من معاملات الوحدات البديلة.');
L1702 |  const localSku=value('client_sku')||null,localBarcode=value('client_barcode')||null;
L1703 |  if(!value('sku')&&!value('barcode')&&!localSku&&!localBarcode)throw new Error('لا يمكن منع تكرار هذا الصف دون SKU أو باركود عالمي أو محلي؛ أضف المعرّف قبل الاستيراد.');
L1704 |  const localName=value('client_name_override')||null,localCategory=value('client_category_override')||null;
L1705 |  const localBase=value('client_base_unit_override')||null,localUnitsText=value('client_units_override');
L1706 |  if(localSku&&localSku.length>100)throw new Error('SKU المؤسسة يتجاوز 100 حرف.');
L1707 |  if(localBarcode){if(localBarcode.length>120)throw new Error('باركود المؤسسة يتجاوز 120 حرفاً.');cfResolveBarcodeType(localBarcode,'AUTO');}
L1708 |  if(localName&&localName.length>240)throw new Error('اسم المؤسسة يتجاوز 240 حرفاً.');
L1709 |  if(localCategory&&localCategory.length>120)throw new Error('تصنيف المؤسسة يتجاوز 120 حرفاً.');
L1710 |  if(localBase&&localBase.length>40)throw new Error('وحدة الأساس المحلية تتجاوز 40 حرفاً.');
L1711 |  const output={...source,client_sku:localSku,client_barcode:localBarcode,client_name_override:localName,client_category_override:localCategory};
L1712 |  if(localBase)output.client_base_unit_override=localBase;
L1713 |  if(localUnitsText){
L1714 |   const rows=cfParseUnitRows(localUnitsText);
L1715 |   if(!Array.isArray(rows)||rows.length>50)throw new Error('عدد وحدات المؤسسة البديلة يجب ألا يتجاوز 50 وحدة.');
L1716 |   const base=localBase||source.base_unit,unitClass=inferProductUnitClass(base),meta=readProductUnitMeta(source.units,source.base_unit);
L1717 |   const seenNames=new Set(),seenCodes=new Set();if(localBarcode)seenCodes.add(localBarcode.toLocaleLowerCase());
L1718 |   const normalized=rows.map(entry=>{
L1719 |    if(!entry||typeof entry!=='object'||Array.isArray(entry))throw new Error('صيغة إحدى وحدات المؤسسة غير صحيحة.');
L1720 |    const name=String(entry.name??'').trim(),factor=Number(entry.factor_to_base??entry.conversion_factor??entry.factor);
L1721 |    if(!name||name.length>40)throw new Error('اسم وحدة المؤسسة مطلوب ولا يتجاوز 40 حرفاً.');
L1722 |    const key=normalizeUnitName(name);
L1723 |    if(key===normalizeUnitName(base)||seenNames.has(key))throw new Error('وحدة المؤسسة مكررة أو تطابق وحدة الأساس.');
L1724 |    if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل تحويل وحدة المؤسسة غير صالح.');
L1725 |    const unit={name,factor_to_base:factor},barcode=String(entry.barcode??'').trim();
L1726 |    if(barcode){if(barcode.length>120)throw new Error('باركود وحدة المؤسسة أطول من الحد.');const code=barcode.toLocaleLowerCase();if(seenCodes.has(code))throw new Error('باركود الصنف أو وحداته المحلية مكرر.');seenCodes.add(code);unit.barcode=barcode;unit.barcode_type=cfResolveBarcodeType(barcode,entry.barcode_type||'AUTO');}
L1727 |    seenNames.add(key);return unit;
L1728 |   });
L1729 |   output.client_units_override=withProductUnitMeta(normalized,unitClass,meta.decimal_precision??defaultProductUnitPrecision(unitClass),{item_kind:localBarcode?'BARCODED':meta.item_kind||'NO_BARCODE',barcode_type:localBarcode?cfResolveBarcodeType(localBarcode,'AUTO'):meta.barcode_type||'INTERNAL'});
L1730 |  }else if(localBase)output.client_units_override=[];
L1731 |  return output;
L1732 | }
```

### commitClientCatalogChunk() — source lines 1733-1751

```javascript
L1733 | async function commitClientCatalogChunk(rows,clientId){
L1734 |  if(!rows.length)return;
L1735 |  const {data,error}=await db.rpc('count_upsert_client_catalog_chunk',{p_client_id:clientId,p_rows:rows});
L1736 |  if(error)throw error;
L1737 |  if(!data||typeof data!=='object')throw new Error('استجابة ربط أصناف المؤسسة غير صالحة.');
L1738 |  const stats=state.clientCatalogImport.stats;
L1739 |  stats.processed+=rows.length;
L1740 |  stats.catalogInserted+=Number(data.catalog_inserted||0);
L1741 |  stats.catalogMatched+=Number(data.catalog_matched||0);
L1742 |  stats.clientInserted+=Number(data.client_inserted||0);
L1743 |  stats.clientUpdated+=Number(data.client_updated||0);
L1744 |  stats.duplicates+=Number(data.duplicates||0);
L1745 |  stats.rejected+=Number(data.rejected||0);
L1746 |  for(const item of Array.isArray(data.errors)?data.errors:[]){
L1747 |   if(stats.errors.length>=120)break;
L1748 |   stats.errors.push({row_number:item.row_number,sku:item.sku,barcode:item.barcode,error:item.error||'رفض الخادم الصف'});
L1749 |  }
L1750 |  updateClientCatalogImportProgress();
L1751 | }
```

### resetClientCatalogImport() — source lines 1752-1759

```javascript
L1752 | function resetClientCatalogImport(){
L1753 |  const g=state.clientCatalogImport;if(g?.busy)return notify('لا يمكن إلغاء الملف أثناء تنفيذ دفعة؛ انتظر اكتمال الاستدعاء الحالي.',true);
L1754 |  state.clientCatalogImport={file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}};
L1755 |  $('clientCatalogImportFile').value='';$('clientCatalogImportMapping').classList.add('hidden');$('clientCatalogImportMapping').innerHTML='';
L1756 |  $('clientCatalogImportPreviewText').textContent='';$('clientCatalogImportProgress').textContent='لم يبدأ الاستيراد';
L1757 |  $('clientCatalogImportProgressFill').style.width='0%';$('clientCatalogImportErrors').innerHTML='';$('clientCatalogImportSummary').innerHTML='';
L1758 |  $('clientCatalogImportPreview').disabled=false;$('clientCatalogImportCommit').disabled=true;$('clientCatalogImportReset').disabled=false;
L1759 | }
```

### previewClientCatalogImport() — source lines 1760-1784

```javascript
L1760 | async function previewClientCatalogImport(){
L1761 |  if(!state.platformOwner)return notify('استيراد أصناف المؤسسة متاح لمالك المنصة فقط.',true);
L1762 |  const client=state.clients.find(item=>item.id===state.catalogClientId&&item.status==='active');
L1763 |  if(!client)return notify('اختر مؤسسة نشطة أولاً من محدد المؤسسة أعلى دليل الأصناف.',true);
L1764 |  const file=$('clientCatalogImportFile').files?.[0];if(!file)return notify('اختر ملف أصناف المؤسسة أولاً.',true);
L1765 |  if(state.clientCatalogImport?.busy)return;
L1766 |  const preview=$('clientCatalogImportPreview'),commit=$('clientCatalogImportCommit'),reset=$('clientCatalogImportReset');
L1767 |  preview.disabled=true;commit.disabled=true;reset.disabled=true;
L1768 |  $('clientCatalogImportTarget').textContent='وجهة الاستيراد: '+client.name+' · '+client.code+'. لن تُنقل أصناف التكليف أو الأرصدة المرجعية.';
L1769 |  $('clientCatalogImportProgress').textContent='جار فحص الملف وقراءة عينة من الصفوف…';$('clientCatalogImportErrors').innerHTML='';
L1770 |  try{
L1771 |   const parsed=await parseProductImportFile(file),ext=(file.name.split('.').pop()||'').toLowerCase();
L1772 |   if(!parsed.count)throw new Error('لا توجد صفوف بيانات قابلة للقراءة.');
L1773 |   if(parsed.count>90000)throw new Error('الحد الأقصى لملف المؤسسة 90,000 صف.');
L1774 |   if(!['csv','xlsx'].includes(ext))throw new Error('يدعم الاستيراد CSV وXLSX فقط.');
L1775 |   state.clientCatalogImport={file,clientId:client.id,count:parsed.count,headers:parsed.headers||Object.keys((parsed.sample||parsed.rows||[])[0]||{}),sample:parsed.sample||parsed.rows||[],mapping:{},busy:false,checksum:'',sourceFormat:ext,stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}};
L1776 |   renderClientCatalogImportMapping();renderClientCatalogImportPreview();
L1777 |   $('clientCatalogImportProgress').textContent=(parsed.streaming?'تمت معاينة الملف بالقراءة المتدفقة. ':'تمت قراءة الملف. ')+parsed.count.toLocaleString('en-US')+' صف؛ راجع مطابقة الأعمدة قبل التنفيذ.';
L1778 |  }catch(error){
L1779 |   resetClientCatalogImport();$('clientCatalogImportProgress').textContent='تعذرت معاينة الملف: '+friendlyErrorMessage(error);fail('تعذرت معاينة ملف المؤسسة',error);
L1780 |  }finally{
L1781 |   preview.disabled=false;reset.disabled=false;
L1782 |   commit.disabled=!state.clientCatalogImport.count||!state.clientCatalogImport.mapping?.name||(!state.clientCatalogImport.mapping?.sku&&!state.clientCatalogImport.mapping?.barcode&&!state.clientCatalogImport.mapping?.client_sku&&!state.clientCatalogImport.mapping?.client_barcode);
L1783 |  }
L1784 | }
```

### commitClientCatalogImport() — source lines 1785-1855

```javascript
L1785 | async function commitClientCatalogImport(){
L1786 |  if(!state.platformOwner)return notify('استيراد أصناف المؤسسة متاح لمالك المنصة فقط.',true);
L1787 |  const g=state.clientCatalogImport,file=$('clientCatalogImportFile').files?.[0],client=state.clients.find(item=>item.id===state.catalogClientId&&item.status==='active');
L1788 |  if(g.busy)return;
L1789 |  if(!client||g.clientId!==client.id)return notify('تغيرت المؤسسة المحددة. أعد معاينة الملف على المؤسسة الجديدة.',true);
L1790 |  if(!g.file||!file||file!==g.file)return notify('الملف الحالي تغير؛ أعد معاينته قبل الاستيراد.',true);
L1791 |  if(!g.mapping?.name)return notify('اربط عمود اسم الصنف أولاً.',true);if(!g.mapping.sku&&!g.mapping.barcode&&!g.mapping.client_sku&&!g.mapping.client_barcode)return notify('اربط عمود SKU أو باركود عالمي أو محلي حتى يمكن منع التكرار.',true);
L1792 |  if(g.count<1||g.count>90000)return notify('عدد الصفوف خارج الحد التشغيلي 1–90,000.',true);
L1793 |  g.busy=true;g.stats={processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]};
L1794 |  const controls=['clientCatalogImportPreview','clientCatalogImportCommit','clientCatalogImportReset'];controls.forEach(id=>$(id).disabled=true);
L1795 |  $('clientCatalogImportFile').disabled=true;$('clientCatalogImportErrors').innerHTML='';
L1796 |  $('clientCatalogImportProgress').textContent='جار حساب بصمة الملف وتجهيز دفعات المؤسسة…';
L1797 |  let pending=[],rowIndex=0,parseErrors=0;const seenIdentities=new Set();
L1798 |  const recordError=(row,rowNumber,error)=>{
L1799 |   const stats=state.clientCatalogImport.stats;stats.processed++;stats.rejected++;
L1800 |   if(stats.errors.length<120)stats.errors.push({row_number:rowNumber,sku:String(globalCatalogImportValue(row,'sku',g.mapping)||''),barcode:String(globalCatalogImportValue(row,'barcode',g.mapping)||''),error:error?.message||String(error)});
L1801 |   updateClientCatalogImportProgress();
L1802 |  };
L1803 |  const acceptRow=(row,rowNumber)=>{
L1804 |   try{
L1805 |    const normalized=normalizeClientCatalogImportRow(row,rowIndex,rowNumber,g.checksum,g.mapping);
L1806 |    if(!reserveCatalogImportIdentities(normalized,seenIdentities)){
L1807 |     const stats=state.clientCatalogImport.stats;stats.processed++;stats.duplicates++;updateClientCatalogImportProgress();
L1808 |    }else pending.push(normalized);
L1809 |   }catch(error){recordError(row,rowNumber,error);}
L1810 |   rowIndex++;
L1811 |  };
L1812 |  const flush=async()=>{if(!pending.length)return;const chunk=pending;pending=[];await commitClientCatalogChunk(chunk,client.id);};
L1813 |  try{
L1814 |   g.checksum=await hashFileInChunks(file);
L1815 |   if(g.sourceFormat==='csv'){
L1816 |    await new Promise((resolve,reject)=>{
L1817 |     let chain=Promise.resolve(),sourceRow=2,settled=false;
L1818 |     const failParse=error=>{if(settled)return;settled=true;reject(error);};
L1819 |     Papa.parse(file,{header:true,skipEmptyLines:'greedy',dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L1820 |      step:(result,parser)=>{
L1821 |       const current=sourceRow++;
L1822 |       if(result.errors?.length){parseErrors+=result.errors.length;recordError(result.data||{},current,new Error('تعذر تحليل صف CSV: '+result.errors.map(x=>x.message).join('، ')));return;}
L1823 |       const row=result.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;
L1824 |       acceptRow(row,current);
L1825 |       if(pending.length>=500){parser.pause();const chunk=pending;pending=[];chain=chain.then(()=>commitClientCatalogChunk(chunk,client.id)).then(()=>parser.resume()).catch(error=>{parser.abort();failParse(error);});}
L1826 |      },
L1827 |      complete:async()=>{if(settled)return;try{await chain;await flush();if(!rowIndex&&!state.clientCatalogImport.stats.rejected)throw new Error('لم يتم العثور على صفوف بيانات قابلة للقراءة.');settled=true;resolve();}catch(error){failParse(error);}},
L1828 |      error:failParse
L1829 |     });
L1830 |    });
L1831 |   }else{
L1832 |    const parsed=await streamXlsxProductRows(file,async row=>{
L1833 |     const number=Number(row.__countflowRowNumber||rowIndex+2);acceptRow(row,number);if(pending.length>=500)await flush();
L1834 |    });
L1835 |    if(parsed.count!==g.count)throw new Error('تغير عدد صفوف XLSX بعد المعاينة؛ أعد معاينة الملف.');await flush();
L1836 |   }
L1837 |   if(rowIndex>g.count)throw new Error('عدد صفوف الاستيراد تجاوز العدد الذي تمت معاينته.');
L1838 |   const s=g.stats;
L1839 |   $('clientCatalogImportProgressFill').style.width='100%';
L1840 |   $('clientCatalogImportProgress').textContent='اكتمل الاستيراد بعد معالجة '+s.processed.toLocaleString('en-US')+' صف.';
L1841 |   $('clientCatalogImportSummary').innerHTML=[
L1842 |    ['أصناف عالمية جديدة',s.catalogInserted],['أصناف موجودة تم التعرف عليها',s.catalogMatched],
L1843 |    ['مواءمات مؤسسة جديدة',s.clientInserted],['مواءمات محدثة',s.clientUpdated],
L1844 |    ['صفوف مكررة تم تجاهلها',s.duplicates],['صفوف مرفوضة',s.rejected]
L1845 |   ].map(([label,value])=>'<span>'+label+'<b>'+Number(value||0).toLocaleString('en-US')+'</b></span>').join('');
L1846 |   renderClientCatalogImportErrors();notify('اكتمل استيراد وربط أصناف مؤسسة '+client.name+'. لم تُنشأ أرصدة أو حركات جرد.');
L1847 |   state.catalogPage=1;await loadCatalog();
L1848 |  }catch(error){
L1849 |   $('clientCatalogImportProgress').textContent='توقف الاستيراد عند '+Number(g.stats.processed||0).toLocaleString('en-US')+' صف. الدفعات الناجحة محفوظة، ويمكن إعادة تشغيل الملف نفسه بصورة آمنة. '+friendlyErrorMessage(error);
L1850 |   fail('تعذر استكمال استيراد أصناف المؤسسة',error);
L1851 |  }finally{
L1852 |   g.busy=false;$('clientCatalogImportFile').disabled=false;controls.forEach(id=>$(id).disabled=false);
L1853 |   $('clientCatalogImportCommit').disabled=!g.count||!g.mapping?.name||(!g.mapping?.sku&&!g.mapping?.barcode&&!g.mapping?.client_sku&&!g.mapping?.client_barcode);
L1854 |  }
L1855 | }
```

### resetProductImport() — source lines 1856-1861

```javascript
L1856 | function resetProductImport(){
L1857 |   state.productImportRows=[];state.productImportRowCount=0;state.productImportHeaders=[];state.productImportMapping={};state.productImportMappingId=null;state.productImportFileName='';
L1858 |   $('productImportFile').value='';$('productImportMapping').classList.add('hidden');$('productImportMapping').innerHTML='';
L1859 |   $('productImportPreview').textContent='';$('productImportResult').textContent='';$('productImportCommitBtn').disabled=true;
L1860 |   $('productImportDetails').innerHTML='';
L1861 |  }
```

### renderProductImportMapping() — source lines 1862-1872

```javascript
L1862 | async function renderProductImportMapping(){
L1863 |   const headers=Object.keys(state.productImportRows[0]||{});if(!headers.length)throw new Error('لم يتم العثور على عناوين أعمدة في الصف الأول.');
L1864 |   const {data:saved,error}=await db.from('count_import_mappings').select('id,name,column_mapping,is_default').eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat).eq('is_default',true).order('created_at',{ascending:false}).limit(1).maybeSingle();
L1865 |   if(error)throw error;
L1866 |   state.productImportMappingId=saved?.id||null;state.productImportMapping={};
L1867 |   for(const f of productImportFields){const candidate=saved?.column_mapping?.[f.key];state.productImportMapping[f.key]=headers.includes(candidate)?candidate:guessProductImportHeader(headers,f.key);}
L1868 |   $('productImportMapping').classList.remove('hidden');
L1869 |   $('productImportMapping').innerHTML='<div class="panel" style="box-shadow:none;margin:0;padding:12px"><b>مطابقة أعمدة الملف مع بيانات CountFlow</b><p class="hint">يجب ربط SKU أو الباركود والوحدة الأساسية. لا تُنشئ عمليات الاستيراد وحدات تحويل أو تكلفة غير موجودة في الملف.</p><div class="fields">'+productImportFields.map(f=>'<div class="field"><label>'+f.label+'</label><select data-product-import-map="'+f.key+'"><option value="">— تجاهل الحقل —</option>'+headers.map(h=>'<option value="'+esc(h)+'" '+(state.productImportMapping[f.key]===h?'selected':'')+'>'+esc(h)+'</option>').join('')+'</select></div>').join('')+'</div><div class="actions"><input id="productImportMappingName" placeholder="اسم تخطيط الأعمدة" value="'+esc(saved?.name||'')+'" style="min-width:180px;padding:9px;border:1px solid var(--line);border-radius:10px"><label class="hint"><input id="productImportMappingDefault" type="checkbox" '+(saved?.is_default?'checked':'')+'> جعله التخطيط الافتراضي لهذا النوع من الملفات</label><button type="button" id="saveProductImportMapping" class="soft">حفظ تخطيط الأعمدة</button></div></div>';
L1870 |   $('productImportMapping').querySelectorAll('[data-product-import-map]').forEach(s=>s.onchange=()=>{state.productImportMapping[s.dataset.productImportMap]=s.value;state.productImportMappingId=null;});
L1871 |   $('saveProductImportMapping').onclick=saveProductImportMapping;
L1872 |  }
```

### saveProductImportMapping() — source lines 1873-1888

```javascript
L1873 | async function saveProductImportMapping(){
L1874 |   if(!state.project)return notify('اختر تكليفاً أولاً.',true);
L1875 |   const mapping=state.productImportMapping;
L1876 |   if(!mapping.name)return notify('اربط عمود اسم الصنف.',true);
L1877 |   if(!mapping.base_unit)return notify('اربط عمود الوحدة الأساسية.',true);
L1878 |   const name=$('productImportMappingName').value.trim()||('تخطيط '+exportFormatLabel(state.productImportSourceFormat));
L1879 |   const makeDefault=$('productImportMappingDefault').checked;
L1880 |   try{
L1881 |    if(makeDefault){
L1882 |     const {error}=await db.from('count_import_mappings').update({is_default:false}).eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat);
L1883 |     if(error)throw error;
L1884 |    }
L1885 |    const {data,error}=await db.from('count_import_mappings').upsert({project_id:state.project.id,name,source_format:state.productImportSourceFormat,column_mapping:mapping,is_default:makeDefault,created_by:state.user.id},{onConflict:'project_id,name'}).select('id').single();
L1886 |    if(error)throw error;state.productImportMappingId=data.id;notify('تم حفظ تخطيط الأعمدة وإعادة استخدامه لهذا التكليف.');
L1887 |   }catch(err){fail('تعذر حفظ تخطيط الأعمدة',err);}
L1888 |  }
```

### productImportValue() — source lines 1889-1892

```javascript
L1889 | function productImportValue(row,key){
L1890 |   const header=state.productImportMapping[key];
L1891 |   return header&&Object.prototype.hasOwnProperty.call(row,header)?row[header]:'';
L1892 |  }
```

### normalizeProductImportRow() — source lines 1893-1906

```javascript
L1893 | function normalizeProductImportRow(row,index,sourceRowNumber=null){
L1894 |   const value=key=>String(productImportValue(row,key)??'').trim(),rowNumber=Number(sourceRowNumber||row.__countflowRowNumber||index+2);
L1895 |   let units=cfParseUnitRows(productImportValue(row,'units'));
L1896 |   const baseUnit=value('base_unit'),rawClass=value('unit_class'),rawPrecision=value('decimal_precision');
L1897 |   const unitClass=CF_UNIT_CLASSES.some(x=>x.value===rawClass)?rawClass:inferProductUnitClass(baseUnit),decimalPrecision=rawPrecision===''?defaultProductUnitPrecision(unitClass):Number(rawPrecision);
L1898 |   let barcode=value('barcode')||'',sku=value('sku')||'',itemKind=value('item_kind').toUpperCase(),requestedType=value('barcode_type')||'AUTO';
L1899 |   const deterministic='CFI-'+String(state.productImportChecksum||'IMPORT').replace(/[^A-F0-9]/gi,'').slice(-12).toUpperCase().padStart(12,'0')+'-'+String(rowNumber).padStart(7,'0');
L1900 |   if(!barcode){barcode=deterministic;if(!itemKind)itemKind=unitClass==='mass'?'WEIGHED':'NO_BARCODE';requestedType='INTERNAL';}
L1901 |   else{requestedType=cfResolveBarcodeType(barcode,requestedType);if(!itemKind)itemKind=unitClass==='mass'?'WEIGHED':'BARCODED';}
L1902 |   if(itemKind==='BARCODED'&&requestedType==='INTERNAL')throw new Error('الصنف المحدد كصنف بباركود يحتاج باركوداً خارجياً صالحاً.');
L1903 |   if(!sku)sku=deterministic;
L1904 |   units=withProductUnitMeta(units,unitClass,decimalPrecision,{item_kind:itemKind,barcode_type:requestedType});
L1905 |   return {_row_number:rowNumber,_source_row:row,sku,barcode,name:value('name')||null,category:value('category')||null,base_unit:baseUnit,units,expected_qty:value('expected_qty'),location_code:value('location_code'),image_url:value('image_url')||null,purchase_unit_cost:value('purchase_unit_cost')||null,currency_code:value('currency_code').toUpperCase()||null,purchase_unit:value('purchase_unit')||null,unit_factor_to_base:value('unit_factor_to_base')||null,cost_source_type:value('cost_source_type')||null,cost_source_reference:value('cost_source_reference')||null,cost_source_date:value('cost_source_date')||null};
L1906 |  }
```

### renderProductImportPreview() — source lines 1907-1912

```javascript
L1907 | function renderProductImportPreview(){
L1908 |   const headers=Object.keys(state.productImportRows[0]||{}),rows=state.productImportRows.slice(0,8);
L1909 |   const sample=rows.length?'<div class="tablewrap"><table><thead><tr>'+headers.slice(0,8).map(h=>'<th>'+esc(h)+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+headers.slice(0,8).map(h=>'<td>'+esc(String(r[h]??'').slice(0,80))+'</td>').join('')+'</tr>').join('')+'</tbody></table></div>':'';
L1910 |   $('productImportPreview').innerHTML='<b>معاينة الملف: '+state.productImportRowCount.toLocaleString('en-US')+' صف بيانات</b><span class="sub"> أول ورقة في الملف · عينة من '+rows.length+' صفوف · '+headers.length+' عمود</span>'+sample;
L1911 |   $('productImportCommitBtn').disabled=!state.productImportRows.length||!state.productImportMapping.name||!state.productImportMapping.base_unit;
L1912 |  }
```

### previewProductImport() — source lines 1913-1929

```javascript
L1913 | async function previewProductImport(){
L1914 |   const file=$('productImportFile').files[0];if(!file)return notify('اختر ملف Excel أو CSV أولاً.',true);
L1915 |   if(!state.project)return notify('اختر تكليفاً أولاً.',true);
L1916 |   const projectId=state.project.id;
L1917 |   $('productImportPreviewBtn').disabled=true;$('productImportCommitBtn').disabled=true;$('projectPicker').disabled=true;$('productImportFile').disabled=true;$('productImportSession').disabled=true;$('productImportResetBtn').disabled=true;$('productImportResult').textContent='جار قراءة الملف تدريجياً ومعاينة أول الصفوف…';
L1918 |   try{
L1919 |    const parsed=await parseProductImportFile(file);
L1920 |    if(!parsed.count)throw new Error('لا توجد صفوف بيانات قابلة للقراءة.');
L1921 |    if(parsed.count>90000)throw new Error('الحد التشغيلي المعتمد لهذه الدفعة هو 90,000 صف. قسّم الملف إلى دفعات أصغر');
L1922 |    state.productImportRows=parsed.rows||parsed.sample||[];state.productImportRowCount=parsed.count;state.productImportHeaders=parsed.headers||Object.keys(state.productImportRows[0]||{});state.productImportFileName=file.name;
L1923 |    const ext=(file.name.split('.').pop()||'').toLowerCase();state.productImportSourceFormat=ext==='xls'||ext==='xlsx'?'xlsx':'csv';
L1924 |    await renderProductImportMapping();renderProductImportPreview();
L1925 |    $('productImportResult').textContent=parsed.streaming?(state.productImportSourceFormat==='xlsx'?'تمت قراءة XLSX على مستوى سجلات XML مع التحقق من CRC دون تحميل ورقة العمل كاملة.':'تمت معاينة CSV باستخدام step دون الاحتفاظ بجميع الصفوف؛ سيُعاد قراءته أثناء الاعتماد على دفعات.'):'تمت قراءة ملف XLS القديم ضمن حد ذاكرة صارم؛ يوصى بتحويل الملفات الكبيرة إلى XLSX.';
L1926 |    if(parsed.parseErrors)$('productImportResult').textContent+=' · أخطاء تحليل CSV المتجاوزة: '+parsed.parseErrors;
L1927 |   }catch(err){state.productImportRows=[];state.productImportRowCount=0;$('productImportPreview').textContent='';$('productImportCommitBtn').disabled=true;fail('تعذر معاينة ملف الأصناف',err);}
L1928 |   finally{$('productImportPreviewBtn').disabled=false;$('projectPicker').disabled=false;$('productImportFile').disabled=false;$('productImportSession').disabled=false;$('productImportResetBtn').disabled=false;}
L1929 |  }
```

### commitImportBatchInChunks() — source lines 1930-1942

```javascript
L1930 | async function commitImportBatchInChunks(batchId,onProgress){
L1931 |   let result=null,attempt=0;
L1932 |   while(attempt++<10000){
L1933 |    const {data,error}=await db.rpc('count_commit_import_batch',{p_batch_id:batchId});
L1934 |    if(error){console.warn('CountFlow import commit chunk failed',error);throw new Error('تعذر اعتماد جزء من الاستيراد حالياً. بقيت الدفعة محفوظة ويمكن استئنافها بعد التحقق من الاتصال.');}
L1935 |    result=data||{};
L1936 |    if(result.status==='committed')return result;
L1937 |    if(result.status!=='committing'){console.warn('Unexpected CountFlow import commit status',result.status);throw new Error('تعذر استكمال اعتماد الاستيراد. أعد المحاولة أو راجع سجل الاستيراد.');}
L1938 |    if(!Number.isInteger(Number(result.remaining_rows))||Number(result.remaining_rows)<1)throw new Error('استجابة اعتماد الدفعة لا تتضمن عدد الصفوف المتبقية بصورة صحيحة.');
L1939 |    if(typeof onProgress==='function')onProgress(result);
L1940 |   }
L1941 |   throw new Error('تجاوز اعتماد الدفعة الحد الأقصى لعدد الأجزاء. بقيت الدفعة محفوظة ويمكن استئنافها.');
L1942 |  }
```

### resumeImportBatchFromHistory() — source lines 1943-1973

```javascript
L1943 | async function resumeImportBatchFromHistory(batchId,scope,button){
L1944 |   if(!batchId||!['product','operation'].includes(scope))return;
L1945 |   const original=button?.textContent||'استكمال الاعتماد';
L1946 |   if(button){button.disabled=true;button.textContent='جار استكمال الاعتماد…';}
L1947 |   try{
L1948 |    const committed=await commitImportBatchInChunks(batchId,progress=>{
L1949 |     if(button)button.textContent='متبقٍ '+Number(progress.remaining_rows||0).toLocaleString('ar-EG')+' صف';
L1950 |    });
L1951 |    if(committed?.status!=='committed')throw new Error('لم تكتمل دفعة الاستيراد بعد. يمكنك استئنافها من السجل.');
L1952 |    notify('اكتمل استكمال دفعة الاستيراد · مقبول '+Number(committed.accepted_rows||0)+' · مرفوض '+Number(committed.rejected_rows||0));
L1953 |    try{
L1954 |     if(scope==='product'){
L1955 |      await loadProjectData();
L1956 |     }else{
L1957 |      await loadOperationImportHistory();
L1958 |      await loadProjectData();
L1959 |      await loadOperationMetrics();
L1960 |     }
L1961 |    }catch(refreshError){
L1962 |     fail('اكتمل اعتماد الدفعة لكن تعذر تحديث العرض',refreshError);
L1963 |     if(scope==='product')await loadProductImportHistory();
L1964 |     else await loadOperationImportHistory();
L1965 |    }
L1966 |   }catch(error){
L1967 |    fail('تعذر استكمال دفعة الاستيراد',error);
L1968 |    if(scope==='product')await loadProductImportHistory();
L1969 |    else await loadOperationImportHistory();
L1970 |   }finally{
L1971 |    if(button&&button.isConnected){button.disabled=false;button.textContent=original;}
L1972 |   }
L1973 |  }
```

### commitProductImport() — source lines 1974-2039

```javascript
L1974 | async function commitProductImport(){
L1975 |   if(!state.project||!state.productImportRowCount)return notify('عاين الملف واختر تكليفاً قبل الاعتماد.',true);
L1976 |   if(!state.productImportMapping.name)return notify('اربط عمود اسم الصنف.',true);
L1977 |   if(!state.productImportMapping.base_unit)return notify('اربط عمود الوحدة الأساسية.',true);
L1978 |   const projectId=state.project.id,sessionId=$('productImportSession').value||null,session=sessionId?state.sessions.find(s=>s.id===sessionId):null;
L1979 |   if(sessionId&&!session)return notify('جلسة الربط لم تعد ضمن قائمة الجلسات المتاحة. حدّث البيانات.',true);
L1980 |   if(session&&!['planned','active','paused','review'].includes(session.status))return notify('لا يمكن ربط الاستيراد بهذه الجلسة بسبب حالتها الحالية.',true);
L1981 |   const file=$('productImportFile').files[0];if(!file)return notify('أعد اختيار ملف الاستيراد.',true);
L1982 |   const btn=$('productImportCommitBtn');btn.disabled=true;const oldText=btn.textContent;btn.textContent='جار تجهيز الدفعة…';$('projectPicker').disabled=true;$('productImportFile').disabled=true;$('productImportSession').disabled=true;$('productImportPreviewBtn').disabled=true;$('productImportResetBtn').disabled=true;
L1983 |   try{
L1984 |    const checksum=await hashFileInChunks(file);state.productImportChecksum=checksum;
L1985 |    const {data:batchId,error:createError}=await db.rpc('count_create_import_batch',{p_project_id:projectId,p_session_id:sessionId,p_source_name:file.name,p_source_format:state.productImportSourceFormat,p_source_checksum:checksum});
L1986 |    if(createError)throw createError;
L1987 |    const {error:mappingError}=await db.from('count_import_batches').update({mapping_id:state.productImportMappingId,metadata:{column_mapping:state.productImportMapping,headers:state.productImportHeaders,import_surface:'countflow-admin',checksum_algorithm:'sha256-chain-v1'}}).eq('id',batchId).eq('project_id',projectId);
L1988 |    if(mappingError)throw mappingError;
L1989 |    let stagedAccepted=0,stagedRejected=0,processed=0,parseErrors=0;
L1990 |    const stage=async(chunk,offset)=>{
L1991 |     if(!chunk.length)return;
L1992 |     const {data:staged,error}=await db.rpc('count_stage_import_rows',{p_batch_id:batchId,p_rows:chunk,p_row_offset:offset});
L1993 |     if(error){console.warn('CountFlow product import staging failed',error);throw new Error('تعذر فحص بيانات الملف بدءاً من الصف '+(offset+2)+'. راجع هذا الصف ثم أعد المحاولة.');}
L1994 |     stagedAccepted+=Number(staged?.accepted_rows||0);stagedRejected+=Number(staged?.rejected_rows||0);processed+=chunk.length;
L1995 |     $('productImportResult').textContent='فحص الأصناف · '+processed.toLocaleString('en-US')+' / '+state.productImportRowCount.toLocaleString('en-US')+' صف · مقبول '+stagedAccepted+' · مرفوض '+stagedRejected;
L1996 |    };
L1997 |    if(state.productImportSourceFormat==='csv'){
L1998 |     await new Promise((resolve,reject)=>{
L1999 |      let pending=[],rowIndex=0,sourceRowNumber=2,chain=Promise.resolve(),settled=false;
L2000 |      const failParse=err=>{if(settled)return;settled=true;reject(err);};
L2001 |      Papa.parse(file,{header:true,skipEmptyLines:false,dynamicTyping:false,transformHeader:x=>String(x||'').trim(),
L2002 |       step:(r,parser)=>{
L2003 |        const currentSourceRow=sourceRowNumber++;
L2004 |        if(r.errors?.length){parseErrors+=r.errors.length;return;}
L2005 |        const row=r.data||{};if(!Object.keys(row).some(k=>String(row[k]??'').trim()!==''))return;
L2006 |        pending.push(normalizeProductImportRow(row,rowIndex,currentSourceRow));rowIndex++;
L2007 |        if(pending.length>=1000){
L2008 |         parser.pause();const chunk=pending;pending=[];
L2009 |         chain=chain.then(()=>stage(chunk,rowIndex-chunk.length)).then(()=>parser.resume()).catch(err=>{parser.abort();failParse(err);});
L2010 |        }
L2011 |       },
L2012 |       complete:async()=>{
L2013 |        if(settled)return;
L2014 |        try{await chain;await stage(pending,rowIndex-pending.length);if(!rowIndex)throw new Error('لم يتم العثور على صفوف بيانات صالحة.');settled=true;resolve();}
L2015 |        catch(err){failParse(err);}
L2016 |       },error:failParse});
L2017 |     });
L2018 |    }else if(state.productImportSourceFormat==='xlsx'){
L2019 |     let pending=[],rowIndex=0;
L2020 |     const parsed=await streamXlsxProductRows(file,async row=>{
L2021 |      pending.push(normalizeProductImportRow(row,rowIndex));rowIndex++;
L2022 |      if(pending.length>=1000){const chunk=pending;pending=[];await stage(chunk,rowIndex-chunk.length);}
L2023 |     });
L2024 |     if(parsed.count!==state.productImportRowCount)throw new Error('تغير عدد صفوف ملف XLSX بعد المعاينة. أعد المعاينة قبل الاعتماد.');
L2025 |     await stage(pending,rowIndex-pending.length);
L2026 |    }else{
L2027 |     const rows=state.productImportRows||[];
L2028 |     for(let i=0;i<rows.length;i+=1000)await stage(rows.slice(i,i+1000).map((r,j)=>normalizeProductImportRow(r,i+j)),i);
L2029 |    }
L2030 |    const committed=await commitImportBatchInChunks(batchId,progress=>{$('productImportResult').textContent='اعتماد الدفعة · مقبول '+Number(progress.accepted_rows||0)+' · مرفوض '+Number(progress.rejected_rows||0)+' · متبقٍ '+Number(progress.remaining_rows||0);});
L2031 |    const successMessage='اكتمل الاستيراد · صفوف معالجة '+processed+' · مقبول '+Number(committed?.accepted_rows??stagedAccepted)+' · مرفوض '+Number(committed?.rejected_rows??stagedRejected)+' · أرصدة مرجعية '+Number(committed?.expected_balance_rows||0)+' · تم حفظ النتيجة في السجل'+(parseErrors?' · صفوف متجاوزة بسبب تنسيق غير صحيح '+parseErrors:'');
L2032 |    notify('اكتمل استيراد الأصناف من خلال مسار CountFlow الآمن.');
L2033 |    resetProductImport();$('productImportResult').textContent=successMessage;
L2034 |    try{if(state.project?.id===projectId)await loadProjectData();}catch(reloadError){fail('تم اعتماد الاستيراد لكن تعذر تحديث عرض الكتالوج',reloadError);await loadProductImportHistory();}
L2035 |   }catch(err){
L2036 |    $('productImportResult').textContent='لم يكتمل اعتماد الدفعة. بقي سجلها متاحاً للمراجعة؛ لم يتم تجاوز فحص الخادم. '+friendlyErrorMessage(err);
L2037 |    fail('فشل استيراد الأصناف',err);await loadProductImportHistory();
L2038 |   }finally{btn.disabled=!state.productImportRowCount;btn.textContent=oldText;$('projectPicker').disabled=false;$('productImportFile').disabled=false;$('productImportSession').disabled=false;$('productImportPreviewBtn').disabled=false;$('productImportResetBtn').disabled=false;}
L2039 |  }
```

### loadProductImportHistory() — source lines 2040-2051

```javascript
L2040 | async function loadProductImportHistory(){
L2041 |   $('productImportDetails').innerHTML='';
L2042 |   if(!state.project){$('productImportHistory').innerHTML='<div class="empty">اختر تكليفاً لعرض سجل الاستيراد.</div>';return;}
L2043 |   const {data,error}=await db.from('count_import_batches').select('id,source_name,source_format,row_count,accepted_count,rejected_count,status,error_report,created_at,session_id,metadata').eq('project_id',state.project.id).order('created_at',{ascending:false}).limit(20);
L2044 |   if(error){$('productImportHistory').textContent='تعذر تحميل سجل الاستيراد. حاول تحديث الصفحة.';return;}
L2045 |   $('productImportHistory').innerHTML='<b>سجل دفعات الاستيراد لهذا التكليف</b>'+(data||[]).map(b=>{
L2046 |    const canResume=b.status==='committing'&&b.metadata?.import_surface==='countflow-admin';
L2047 |    return '<div class="row" style="padding:8px 0;border-bottom:1px solid var(--line)"><div style="flex:1;min-width:180px"><b>'+esc(b.source_name)+'</b><span class="sub">'+date(b.created_at)+' · '+esc(exportFormatLabel(b.source_format))+' · '+esc(statusName(b.status))+' · إجمالي '+Number(b.row_count||0)+' · مقبول '+Number(b.accepted_count||0)+' · مرفوض '+Number(b.rejected_count||0)+' · أرصدة مرجعية '+Number(b.error_report?.expected_balance_rows||0)+' · تحذيرات '+Number(b.error_report?.warning_count||0)+'</span></div><div class="actions">'+(canResume?'<button type="button" class="primary" data-resume-product-import="'+b.id+'">استكمال الاعتماد</button>':'')+'<button type="button" class="soft" data-product-import-detail="'+b.id+'">تفاصيل النتائج</button></div></div>';
L2048 |   }).join('')||'<p class="hint">لا توجد دفعات استيراد سابقة لهذا التكليف.</p>';
L2049 |   $('productImportHistory').querySelectorAll('[data-product-import-detail]').forEach(b=>b.onclick=()=>showProductImportDetails(b.dataset.productImportDetail));
L2050 |   $('productImportHistory').querySelectorAll('[data-resume-product-import]').forEach(b=>b.onclick=()=>resumeImportBatchFromHistory(b.dataset.resumeProductImport,'product',b));
L2051 |  }
```

### importIssueLabel() — source lines 2052-2082

```javascript
L2052 | function importIssueLabel(code,kind='error'){
L2053 |   const errors={
L2054 |    INVALID_ROW_SHAPE:'تنسيق الصف غير مفهوم',
L2055 |    MISSING_PRODUCT_IDENTIFIER:'أدخل كود الصنف أو الباركود',
L2056 |    SKU_TOO_LONG:'كود الصنف أطول من الحد المسموح',
L2057 |    BARCODE_TOO_LONG:'الباركود أطول من الحد المسموح',
L2058 |    PRODUCT_NAME_TOO_LONG:'اسم الصنف أطول من الحد المسموح',
L2059 |    MISSING_BASE_UNIT:'وحدة القياس الأساسية مطلوبة',
L2060 |    BASE_UNIT_TOO_LONG:'اسم الوحدة الأساسية طويل',
L2061 |    CATEGORY_TOO_LONG:'اسم التصنيف أطول من الحد المسموح',
L2062 |    INVALID_IMAGE_REFERENCE:'رابط أو مرجع صورة الصنف غير صالح',
L2063 |    INVALID_EXPECTED_QUANTITY:'الرصيد المرجعي ليس رقماً صالحاً',
L2064 |    NEGATIVE_EXPECTED_QUANTITY:'الرصيد المرجعي لا يقبل قيمة سالبة',
L2065 |    SESSION_REQUIRED_FOR_EXPECTED_QTY:'اختر عملية جرد عند استيراد أرصدة مرجعية',
L2066 |    LOCATION_REQUIRED_FOR_EXPECTED_QUANTITY:'حدد موقع الرصيد المرجعي',
L2067 |    UNKNOWN_LOCATION_CODE:'كود الموقع غير موجود في هذا التكليف',
L2068 |    AMBIGUOUS_LOCATION_CODE:'كود الموقع يشير إلى أكثر من موقع',
L2069 |    DUPLICATE_PRODUCT_IDENTIFIER_AT_SAME_LOCATION:'الصنف مكرر للموقع نفسه داخل الملف',
L2070 |    PRODUCT_IDENTITY_MATCHES_MULTIPLE_PRODUCTS:'الكود أو الباركود يطابق أكثر من صنف'
L2071 |   };
L2072 |   const warnings={
L2073 |    INVALID_PURCHASE_UNIT_COST:'سعر وحدة الشراء غير صالح',
L2074 |    INVALID_CURRENCY_CODE:'رمز العملة غير صالح',
L2075 |    INVALID_UNIT_FACTOR:'معامل تحويل وحدة الشراء غير صالح',
L2076 |    INVALID_COST_SOURCE_DATE:'تاريخ مصدر التكلفة غير صالح',
L2077 |    COST_DATA_INCOMPLETE:'بيانات تكلفة الشراء غير مكتملة',
L2078 |    COST_REQUIRES_OPERATION_SCOPE:'بيانات التكلفة تتطلب ربط الملف بعملية جرد'
L2079 |   };
L2080 |   const labels=kind==='warning'?warnings:errors;
L2081 |   return labels[String(code||'').toUpperCase()]||'تحتاج بيانات هذا الصف إلى مراجعة';
L2082 |  }
```

### importIssueRowsHtml() — source lines 2083-2085

```javascript
L2083 | function importIssueRowsHtml(rows,key,kind){
L2084 |   return rows.map(r=>'<tr><td>'+Number(r.row_number||0)+'</td><td>'+esc(r.sku||'')+'</td><td>'+esc(r.barcode||'')+'</td><td>'+esc(r.product_name||'')+'</td><td>'+esc((r[key]||[]).map(code=>importIssueLabel(code,kind)).join('، '))+'</td></tr>').join('');
L2085 |  }
```

### loadMoreProductImportDetails() — source lines 2086-2103

```javascript
L2086 | async function loadMoreProductImportDetails(kind){
L2087 |   if(!importDetailBatchId||!['errors','warnings'].includes(kind))return;
L2088 |   const target=$(importDetailTargetId);if(!target)return;
L2089 |   const offset=importDetailOffsets[kind],key=kind==='errors'?'error_codes':'warning_codes';
L2090 |   let query=db.from('count_import_rows').select('row_number,sku,barcode,product_name,'+key,{count:'exact'})
L2091 |    .eq('batch_id',importDetailBatchId).order('row_number').range(offset,offset+IMPORT_DETAIL_PAGE_SIZE-1);
L2092 |   query=kind==='errors'?query.eq('row_status','rejected'):query.not('warning_codes','eq','{}');
L2093 |   const {data,error,count}=await query;
L2094 |   if(error){console.warn('Import detail page load failed',error);notify('تعذر تحميل بقية النتائج. حاول مرة أخرى.',true);return;}
L2095 |   const rows=data||[];
L2096 |   const body=$(importDetailTargetId+'-'+kind);
L2097 |   if(body&&rows.length)body.insertAdjacentHTML('beforeend',importIssueRowsHtml(rows,key,kind));
L2098 |   importDetailOffsets[kind]+=rows.length;
L2099 |   const counter=$(importDetailTargetId+'-'+kind+'-count');
L2100 |   if(counter)counter.textContent=importDetailOffsets[kind]+' من '+Number(importDetailTotals[kind]||count||0);
L2101 |   const button=$(importDetailTargetId+'-'+kind+'-more');
L2102 |   if(button)button.hidden=importDetailOffsets[kind]>=Number(importDetailTotals[kind]||count||0)||rows.length===0;
L2103 |  }
```

### showProductImportDetails() — source lines 2104-2121

```javascript
L2104 | async function showProductImportDetails(batchId,targetId='productImportDetails'){
L2105 |   importDetailBatchId=batchId;importDetailTargetId=targetId;importDetailOffsets={errors:0,warnings:0};importDetailTotals={errors:0,warnings:0};
L2106 |   const [rejected,warnings]=await Promise.all([
L2107 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,error_codes',{count:'exact'}).eq('batch_id',batchId).eq('row_status','rejected').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1),
L2108 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,warning_codes',{count:'exact'}).eq('batch_id',batchId).not('warning_codes','eq','{}').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1)
L2109 |   ]);
L2110 |   if(rejected.error||warnings.error)return fail('تعذر قراءة تفاصيل الاستيراد',rejected.error||warnings.error);
L2111 |   const errRows=rejected.data||[],warnRows=warnings.data||[];
L2112 |   importDetailOffsets.errors=errRows.length;importDetailOffsets.warnings=warnRows.length;
L2113 |   importDetailTotals.errors=Number(rejected.count||0);importDetailTotals.warnings=Number(warnings.count||0);
L2114 |   const table=(rows,key,title,kind,total)=>'<section class="panel"><div class="headrow"><h4>'+title+'</h4><span class="hint" id="'+targetId+'-'+kind+'-count">'+rows.length+' من '+total+'</span></div><div class="tablewrap"><table><thead><tr><th>الصف</th><th>كود الصنف</th><th>باركود</th><th>اسم الصنف</th><th>النتيجة</th></tr></thead><tbody id="'+targetId+'-'+kind+'">'+(rows.length?importIssueRowsHtml(rows,key,kind):'<tr><td colspan="5">لا توجد سجلات في هذه الفئة.</td></tr>')+'</tbody></table></div><button type="button" class="soft" id="'+targetId+'-'+kind+'-more" '+(rows.length>=total?'hidden':'')+'>عرض 500 نتيجة أخرى</button></section>';
L2115 |   const container=$(targetId);if(!container)return;
L2116 |   const closeId=targetId+'-close';
L2117 |   container.innerHTML='<div class="panel"><div class="headrow"><h3>تفاصيل نتائج الاستيراد</h3><button type="button" class="soft" id="'+closeId+'">إغلاق التفاصيل</button></div>'+table(errRows,'error_codes','الصفوف المرفوضة','errors',importDetailTotals.errors)+table(warnRows,'warning_codes','ملاحظات استكمال البيانات','warnings',importDetailTotals.warnings)+'</div>';
L2118 |   $(closeId).onclick=()=>{container.innerHTML='';importDetailBatchId=null;};
L2119 |   $(targetId+'-errors-more').onclick=()=>loadMoreProductImportDetails('errors');
L2120 |   $(targetId+'-warnings-more').onclick=()=>loadMoreProductImportDetails('warnings');
L2121 |  }
```

### normalizeUnitName() — source lines 2920-2923

```javascript
L2920 | function normalizeUnitName(value){
L2921 |  return String(value??'').normalize('NFKC').trim().toLocaleLowerCase()
L2922 |   .replace(/[ًٌٍَُِّْـ]/g,'').replace(/[.\s_-]+/g,' ');
L2923 | }
```

### inferProductUnitClass() — source lines 2924-2931

```javascript
L2924 | function inferProductUnitClass(unitName){
L2925 |  const normalized=normalizeUnitName(unitName),compact=normalized.replace(/\s+/g,'');
L2926 |  for(const cls of CF_UNIT_CLASSES){
L2927 |   if(cls.value==='other')continue;
L2928 |   if(cls.aliases.some(alias=>normalizeUnitName(alias)===normalized||normalizeUnitName(alias).replace(/\s+/g,'')===compact))return cls.value;
L2929 |  }
L2930 |  return 'other';
L2931 | }
```

### defaultProductUnitPrecision() — source lines 2932-2935

```javascript
L2932 | function defaultProductUnitPrecision(unitClass){
L2933 |  const entry=CF_UNIT_CLASSES.find(x=>x.value===unitClass);
L2934 |  return entry?entry.precision:3;
L2935 | }
```

### productUnitRows() — source lines 2936-2938

```javascript
L2936 | function productUnitRows(units){
L2937 |  return Array.isArray(units)?units.filter(row=>!(row&&typeof row==='object'&&row[CF_UNIT_META_FLAG]===true)):[];
L2938 | }
```

### cfGs1CheckDigit() — source lines 2939-2939

```javascript
L2939 | function cfGs1CheckDigit(payload){const code=String(payload||'');if(!/^[0-9]+$/.test(code))return null;let sum=0,weight=3;for(let i=code.length-1;i>=0;i--){sum+=Number(code[i])*weight;weight=weight===3?1:3;}return (10-(sum%10))%10;}
```

### cfIsValidGtin() — source lines 2940-2940

```javascript
L2940 | function cfIsValidGtin(code){const value=String(code||'');if(!/^[0-9]+$/.test(value)||![8,12,13,14].includes(value.length))return false;return Number(value.slice(-1))===cfGs1CheckDigit(value.slice(0,-1));}
```

### cfResolveBarcodeType() — source lines 2941-2941

```javascript
L2941 | function cfResolveBarcodeType(code,requested='AUTO'){const value=String(code??'').trim(),kind=String(requested||'AUTO').toUpperCase();if(!value)return null;if(value!==String(code)||/[\u0000-\u001f\u007f]/.test(value))throw new Error('الباركود يحتوي مسافات طرفية أو رموز تحكم غير مسموحة.');if(kind==='AUTO'||kind==='UNKNOWN'){if(/^[0-9]+$/.test(value)&&[8,12,13,14].includes(value.length)){if(!cfIsValidGtin(value))throw new Error('رقم GTIN غير صحيح: راجع الطول ورقم التحقق GS1.');return ({8:'EAN8',12:'UPC_A',13:'EAN13',14:'GTIN14'})[value.length];}if(/^CFI-[A-F0-9-]{8,48}$/.test(value))return 'INTERNAL';if(!/^[ -~]{1,48}$/.test(value))throw new Error('Code 128 يقبل 1 إلى 48 حرفاً قابلاً للطباعة.');return 'CODE128';}if(['EAN8','UPC_A','EAN13','GTIN14'].includes(kind)){const lengths={EAN8:8,UPC_A:12,EAN13:13,GTIN14:14};if(value.length!==lengths[kind]||!cfIsValidGtin(value))throw new Error('الباركود '+kind+' غير صحيح أو رقم التحقق GS1 غير مطابق.');return kind;}if(kind==='INTERNAL'){if(!/^CFI-[A-F0-9-]{8,48}$/.test(value))throw new Error('المعرف الداخلي يجب أن يبدأ بـ CFI-.');return 'INTERNAL';}if(kind==='CODE128'){if(!/^[ -~]{1,48}$/.test(value))throw new Error('قيمة Code 128 يجب أن تكون 1 إلى 48 حرفاً قابلاً للطباعة.');return 'CODE128';}throw new Error('نوع الباركود المحدد غير مدعوم.');}
```

### cfIsRestrictedCirculationBarcode() — source lines 2942-2942

```javascript
L2942 | function cfIsRestrictedCirculationBarcode(code){const value=String(code||'');return /^2[0-9]\d{11}$/.test(value)&&cfIsValidGtin(value);}
```

### cfGenerateInternalBarcode() — source lines 2943-2943

```javascript
L2943 | function cfGenerateInternalBarcode(){const digits=[];while(digits.length<10){const bytes=new Uint8Array(20);crypto.getRandomValues(bytes);for(const byte of bytes){if(byte<250&&digits.length<10)digits.push(String(byte%10));}}const payload='20'+digits.join('');return payload+String(cfGs1CheckDigit(payload));}
```

### cfParseUnitRows() — source lines 2944-2944

```javascript
L2944 | function cfParseUnitRows(value){if(Array.isArray(value))return value;const raw=String(value??'').trim();if(!raw)return [];try{const parsed=JSON.parse(raw);if(Array.isArray(parsed))return parsed;}catch(_){}return raw.split('|').map(part=>{const bits=part.trim().split(/[:=]/);if(bits.length<2)return null;const factor=Number(bits[1]);return bits[0].trim()&&Number.isFinite(factor)?{name:bits[0].trim(),factor_to_base:factor}:null;}).filter(Boolean);}
```

### readProductUnitMeta() — source lines 2945-2945

```javascript
L2945 | function readProductUnitMeta(units,baseUnit){const meta=Array.isArray(units)?units.find(row=>row&&typeof row==='object'&&row[CF_UNIT_META_FLAG]===true):null,allowed=CF_UNIT_CLASSES.map(x=>x.value),validClass=meta&&allowed.includes(meta.unit_class),unitClass=validClass?meta.unit_class:inferProductUnitClass(baseUnit),precision=Number(meta?.decimal_precision);return {unit_class:unitClass,decimal_precision:Number.isInteger(precision)&&precision>=0&&precision<=6?precision:defaultProductUnitPrecision(unitClass),item_kind:['BARCODED','WEIGHED','NO_BARCODE'].includes(meta?.item_kind)?meta.item_kind:(unitClass==='mass'?'WEIGHED':'BARCODED'),barcode_type:['EAN8','UPC_A','EAN13','GTIN14','CODE128','INTERNAL'].includes(meta?.barcode_type)?meta.barcode_type:'AUTO',inferred:!validClass};}
```

### withProductUnitMeta() — source lines 2946-2946

```javascript
L2946 | function withProductUnitMeta(units,unitClass,decimalPrecision,extra={}){const selected=CF_UNIT_CLASSES.some(x=>x.value===unitClass)?unitClass:'other',precision=Number(decimalPrecision);if(!Number.isInteger(precision)||precision<0||precision>6)throw new Error('دقة الكسور يجب أن تكون من صفر إلى 6 منازل عشرية.');const itemKind=['BARCODED','WEIGHED','NO_BARCODE'].includes(extra.item_kind)?extra.item_kind:null,barcodeType=['EAN8','UPC_A','EAN13','GTIN14','CODE128','INTERNAL'].includes(extra.barcode_type)?extra.barcode_type:null;return [...productUnitRows(units),{[CF_UNIT_META_FLAG]:true,unit_class:selected,decimal_precision:precision,...(itemKind?{item_kind:itemKind}:{}),...(barcodeType?{barcode_type:barcodeType}:{})}];}
```

### bindUnitPrecisionDefaults() — source lines 2947-2952

```javascript
L2947 | function bindUnitPrecisionDefaults(){
L2948 |  [['globalUnitClass','globalUnitPrecision'],['unitClass','unitPrecision'],['clientUnitClass','clientUnitPrecision']].forEach(([classId,precisionId])=>{
L2949 |   const cls=$(classId),precision=$(precisionId);if(!cls||!precision)return;
L2950 |   cls.addEventListener('change',()=>{precision.value=String(defaultProductUnitPrecision(cls.value));});
L2951 |  });
L2952 | }
```

### setUnitMetaFields() — source lines 2953-2953

```javascript
L2953 | function setUnitMetaFields(prefix,units,baseUnit){const meta=readProductUnitMeta(units,baseUnit),cls=$(prefix+'UnitClass'),precision=$(prefix+'UnitPrecision'),kind=$(prefix+'ItemKind'),barcodeType=$(prefix+'BarcodeType');if(cls)cls.value=meta.unit_class;if(precision)precision.value=String(meta.decimal_precision);if(kind)kind.value=meta.item_kind;if(barcodeType)barcodeType.value=meta.barcode_type;}
```

### getUnitMetaFields() — source lines 2954-2954

```javascript
L2954 | function getUnitMetaFields(prefix,units,extra={}){const cls=$(prefix+'UnitClass'),precision=$(prefix+'UnitPrecision'),kind=$(prefix+'ItemKind'),barcodeType=$(prefix+'BarcodeType');return withProductUnitMeta(units,cls?.value||'other',Number(precision?.value??3),{item_kind:kind?.value||extra.item_kind,barcode_type:barcodeType?.value||extra.barcode_type});}
```

### renderCatalogUnitEditor() — source lines 2956-2956

```javascript
L2956 | function renderCatalogUnitEditor(containerId,units=[]){const el=$(containerId);if(!el)return;const list=productUnitRows(units).map(u=>({name:String(u?.name||''),factor_to_base:String(u?.factor_to_base??u?.conversion_factor??u?.factor??''),barcode:String(u?.barcode||''),barcode_type:String(u?.barcode_type||'AUTO')}));el.innerHTML=(list.length?list:[{name:'',factor_to_base:'',barcode:'',barcode_type:'AUTO'}]).map(u=>'<div class="product-unit-row" data-catalog-unit-row><div class="field"><label>اسم الوحدة البديلة</label><input data-catalog-unit-name value="'+esc(u.name)+'" maxlength="40"></div><div class="field"><label>تعادل من وحدة الأساس</label><input data-catalog-unit-factor type="number" min="0.000001" step="0.000001" value="'+esc(u.factor_to_base)+'"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-catalog-unit-barcode value="'+esc(u.barcode)+'" maxlength="120" inputmode="text"></div><div class="field"><label>نوع الرمز</label><select data-catalog-unit-barcode-type><option value="AUTO" '+(u.barcode_type==='AUTO'?'selected':'')+'>تلقائي</option><option value="EAN8" '+(u.barcode_type==='EAN8'?'selected':'')+'>EAN-8</option><option value="UPC_A" '+(u.barcode_type==='UPC_A'?'selected':'')+'>UPC-A</option><option value="EAN13" '+(u.barcode_type==='EAN13'?'selected':'')+'>EAN-13</option><option value="GTIN14" '+(u.barcode_type==='GTIN14'?'selected':'')+'>GTIN-14</option><option value="CODE128" '+(u.barcode_type==='CODE128'?'selected':'')+'>Code 128</option></select></div><button type="button" class="danger" data-catalog-unit-remove>إزالة</button></div>').join('');el.querySelectorAll('[data-catalog-unit-remove]').forEach(b=>b.onclick=()=>{b.closest('[data-catalog-unit-row]')?.remove();if(!el.querySelector('[data-catalog-unit-row]'))renderCatalogUnitEditor(containerId,[]);});}
```

### readCatalogUnits() — source lines 2957-2957

```javascript
L2957 | function readCatalogUnits(containerId,baseUnit,primaryBarcode=null){const el=$(containerId);if(!el)throw new Error('محرر الوحدات غير متاح.');const out=[],seen=new Set(),codes=new Set(),base=String(baseUnit||'').trim().toLocaleLowerCase();if(primaryBarcode)codes.add(String(primaryBarcode).trim().toLowerCase());for(const row of el.querySelectorAll('[data-catalog-unit-row]')){const name=row.querySelector('[data-catalog-unit-name]').value.trim(),raw=row.querySelector('[data-catalog-unit-factor]').value.trim(),barcode=row.querySelector('[data-catalog-unit-barcode]')?.value.trim()||'',requested=row.querySelector('[data-catalog-unit-barcode-type]')?.value||'AUTO';if(!name&&!raw&&!barcode)continue;if(!name||!raw)throw new Error('أكمل اسم الوحدة البديلة ومعامل التحويل معاً.');const key=name.toLocaleLowerCase(),factor=Number(raw);if(key===base)throw new Error('الوحدة البديلة يجب أن تختلف عن وحدة الأساس.');if(seen.has(key))throw new Error('لا تكرر اسم الوحدة البديلة.');if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل التحويل يجب أن يكون رقماً موجباً وصالحاً.');const unit={name,factor_to_base:factor};if(barcode){const type=cfResolveBarcodeType(barcode,requested);if(codes.has(barcode.toLowerCase()))throw new Error('لا يمكن تكرار الباركود بين الصنف ووحداته أو داخل الوحدات.');codes.add(barcode.toLowerCase());unit.barcode=barcode;unit.barcode_type=type;}seen.add(key);out.push(unit);}return out;}
```

### getCatalogCategoryChoices() — source lines 2973-2984

```javascript
L2973 | function getCatalogCategoryChoices(){
L2974 |  const saved=[
L2975 |   ...(Array.isArray(state.catalogProducts)?state.catalogProducts.map(row=>row?.category):[]),
L2976 |   ...(Array.isArray(state.catalogClientRows)?state.catalogClientRows.map(row=>row?.category_override):[])
L2977 |  ];
L2978 |  const unique=new Map();
L2979 |  [...CF_PRODUCT_CATEGORY_SUGGESTIONS,...saved].forEach(raw=>{
L2980 |   const value=String(raw??'').trim();
L2981 |   if(value&&value.length<=120&&!unique.has(value.toLocaleLowerCase()))unique.set(value.toLocaleLowerCase(),value);
L2982 |  });
L2983 |  return [...unique.values()].sort((a,b)=>a.localeCompare(b,'ar'));
L2984 | }
```

### setCatalogCategoryPicker() — source lines 2985-2999

```javascript
L2985 | function setCatalogCategoryPicker(prefix,value=''){
L2986 |  const select=$(prefix+'CategoryChoice'),backing=$(prefix+'Category'),custom=$(prefix+'CategoryCustom');
L2987 |  if(!select||!backing||!custom)return;
L2988 |  const current=String(value??'').trim(),choices=getCatalogCategoryChoices();
L2989 |  const known=choices.find(item=>item.toLocaleLowerCase()===current.toLocaleLowerCase());
L2990 |  const legacy=current&&!known?current:'';
L2991 |  select.innerHTML='<option value="">بدون تصنيف</option>'
L2992 |   +choices.map(item=>'<option value="'+esc(item)+'">'+esc(item)+'</option>').join('')
L2993 |   +(legacy?'<option value="'+esc(legacy)+'" data-legacy="true">'+esc(legacy)+' — تصنيف محفوظ</option>':'')
L2994 |   +'<option value="__cf_add_category__">+ إضافة تصنيف جديد</option>';
L2995 |  select.value=known||legacy||'';
L2996 |  backing.value=current;
L2997 |  custom.value='';
L2998 |  custom.classList.add('hidden');
L2999 | }
```

### bindCatalogCategoryPickers() — source lines 3000-3014

```javascript
L3000 | function bindCatalogCategoryPickers(){
L3001 |  ['global','client'].forEach(prefix=>{
L3002 |   const select=$(prefix+'CategoryChoice'),backing=$(prefix+'Category'),custom=$(prefix+'CategoryCustom');
L3003 |   if(!select||!backing||!custom||select.dataset.bound==='true')return;
L3004 |   select.dataset.bound='true';
L3005 |   select.addEventListener('change',()=>{
L3006 |    if(select.value==='__cf_add_category__'){
L3007 |     custom.classList.remove('hidden');custom.value='';backing.value='';custom.focus();return;
L3008 |    }
L3009 |    custom.classList.add('hidden');custom.value='';backing.value=select.value||'';
L3010 |   });
L3011 |   custom.addEventListener('input',()=>{backing.value=custom.value.trim();});
L3012 |   custom.addEventListener('blur',()=>{custom.value=custom.value.trim();backing.value=custom.value;});
L3013 |  });
L3014 | }
```

### renderGlobalBarcodeStatus() — source lines 3015-3038

```javascript
L3015 | function renderGlobalBarcodeStatus(){
L3016 |  const input=$('globalBarcode'),status=$('globalBarcodeStatus'),hint=$('globalBarcodeHint'),copy=$('globalBarcodeCopy');
L3017 |  if(!input||!status)return;
L3018 |  const code=String(input.value||'').trim();
L3019 |  if(copy)copy.disabled=!code;
L3020 |  if(!code){status.dataset.state='empty';status.textContent='لم يُدخل باركود بعد.';if(hint)hint.textContent='يمكنك إدخال باركود المورد أو توليد نمط RCN-13 محلي يبدأ بـ 20 مع رقم تحقق. التوليد لا يعني تخصيص البادئة أو اعتمادها من GS1.';return;}
L3021 |  try{
L3022 |   const type=cfResolveBarcodeType(code,$('globalBarcodeType')?.value||'AUTO');
L3023 |   if(cfIsRestrictedCirculationBarcode(code)){
L3024 |    status.dataset.state='restricted';
L3025 |    status.textContent='نمط RCN-13 محلي مقيّد · رقم تحقق Mod-10 صحيح · ليس GTIN عالمياً.';
L3026 |    if(hint)hint.textContent='هذا تحقق شكلي فقط؛ لا يثبت تخصيص نطاق من GS1. استخدمه داخل بيئة مقيدة، وبعد اعتماد منظمة GS1 المحلية عند الحاجة.';
L3027 |   }else if(type==='INTERNAL'){
L3028 |    status.dataset.state='internal';status.textContent='معرف CountFlow داخلي CFI؛ ليس باركود EAN/UPC.';
L3029 |    if(hint)hint.textContent='يظل معرف CFI متاحاً للسجلات القديمة وللأصناف التي لا تحمل باركوداً خارجياً.';
L3030 |   }else{
L3031 |    status.dataset.state='valid';status.textContent='باركود '+type+' · الطول ورقم التحقق صحيحان.';
L3032 |    if(hint)hint.textContent='تم التحقق من صيغة الرمز ورقم التحقق قبل الحفظ؛ سيعيد الخادم التحقق عند الكتابة.';
L3033 |   }
L3034 |  }catch(error){
L3035 |   status.dataset.state='invalid';status.textContent='الرمز غير صالح: '+String(error?.message||error);
L3036 |   if(hint)hint.textContent='راجع عدد الأرقام ونوع الرمز ورقم التحقق، ثم أعد المحاولة.';
L3037 |  }
L3038 | }
```

### generateUniqueGlobalRestrictedBarcode() — source lines 3039-3053

```javascript
L3039 | async function generateUniqueGlobalRestrictedBarcode(){
L3040 |  for(let attempt=0;attempt<8;attempt++){
L3041 |   const candidate=cfGenerateInternalBarcode();
L3042 |   const [primary,alternate,aliases]=await Promise.all([
L3043 |    db.from('count_catalog_products').select('id').ilike('barcode',candidate).limit(1),
L3044 |    db.from('count_catalog_products').select('id').contains('units',[{barcode:candidate}]).limit(1),
L3045 |    db.from('count_catalog_product_identifiers').select('id').or('normalized_value.eq.'+candidate+',identifier_value.eq.'+candidate).limit(1)
L3046 |   ]);
L3047 |   if(primary.error)throw primary.error;
L3048 |   if(alternate.error)throw alternate.error;
L3049 |   if(aliases.error)throw aliases.error;
L3050 |   if(!(primary.data||[]).length&&!(alternate.data||[]).length&&!(aliases.data||[]).length)return candidate;
L3051 |  }
L3052 |  throw new Error('تعذر توليد رمز غير مستخدم بعد عدة محاولات؛ أعد المحاولة.');
L3053 | }
```

### handleGenerateGlobalBarcode() — source lines 3054-3067

```javascript
L3054 | async function handleGenerateGlobalBarcode(){
L3055 |  const button=$('globalGenerateBarcode');if(button.disabled)return;
L3056 |  button.disabled=true;
L3057 |  try{
L3058 |   const code=await generateUniqueGlobalRestrictedBarcode();
L3059 |   $('globalBarcode').value=code;
L3060 |   $('globalBarcodeType').value='EAN13';
L3061 |   $('globalItemKind').value=$('globalUnitClass').value==='mass'?'WEIGHED':'BARCODED';
L3062 |   renderGlobalBarcodeStatus();
L3063 |   $('globalBarcode').focus();$('globalBarcode').select();
L3064 |   notify('تم توليد نمط RCN-13 بالبادئة 20 ورقم تحقق صحيح؛ يلزم اعتماد GS1 المحلي للتداول المقيد الرسمي.');
L3065 |  }catch(error){fail('تعذر توليد الرمز المحلي',error);}
L3066 |  finally{button.disabled=false;}
L3067 | }
```

### copyGlobalBarcode() — source lines 3068-3079

```javascript
L3068 | async function copyGlobalBarcode(){
L3069 |  const code=String($('globalBarcode')?.value||'').trim();
L3070 |  if(!code)return notify('لا يوجد رمز لنسخه.',true);
L3071 |  try{
L3072 |   if(!navigator.clipboard?.writeText)throw new Error('CLIPBOARD_UNAVAILABLE');
L3073 |   await navigator.clipboard.writeText(code);
L3074 |   notify('تم نسخ الباركود.');
L3075 |  }catch(_){
L3076 |   $('globalBarcode').focus();$('globalBarcode').select();
L3077 |   notify('تم تحديد الرمز؛ انسخه باستخدام Ctrl+C أو أمر النسخ في جهازك.',true);
L3078 |  }
L3079 | }
```

### getGlobalBaseUnitValue() — source lines 3080-3085

```javascript
L3080 | function getGlobalBaseUnitValue(){
L3081 |  const select=$('globalBaseUnitChoice'),backing=$('globalBaseUnit');
L3082 |  const value=String(select?.value||'').trim();
L3083 |  if(backing)backing.value=value;
L3084 |  return value;
L3085 | }
```

### setGlobalBaseUnit() — source lines 3086-3097

```javascript
L3086 | function setGlobalBaseUnit(value='',preserveExisting=true){
L3087 |  const select=$('globalBaseUnitChoice'),backing=$('globalBaseUnit');
L3088 |  if(!select||!backing)return;
L3089 |  const current=String(value||'').trim(),unitClass=$('globalUnitClass')?.value||'other';
L3090 |  const choices=CF_BASE_UNIT_SUGGESTIONS[unitClass]||[];
L3091 |  const legacy=!!(preserveExisting&&current&&!choices.includes(current));
L3092 |  select.innerHTML='<option value="">اختر الوحدة الأساسية</option>'+choices.map(item=>'<option value="'+esc(item)+'">'+esc(item)+'</option>').join('')+(legacy?'<option value="'+esc(current)+'" data-legacy="true">'+esc(current)+' — وحدة محفوظة من سجل سابق</option>':'');
L3093 |  select.value=current&&(choices.includes(current)||legacy)?current:'';
L3094 |  backing.value=select.value;
L3095 |  const hint=$('globalBaseUnitHint');
L3096 |  if(hint)hint.textContent=unitClass==='mass'?'وحدات الكتلة المتاحة: كجم، جرام، ملجم، طن، رطل وغيرها من الوحدات المعتمدة.':unitClass==='count'?'وحدات العدد المتاحة: قطعة، علبة، كرتونة، عبوة وغيرها.':'اختر وحدة من القائمة المقيدة حسب نمط القياس؛ القيم القديمة تظهر للقراءة والتحرير فقط.';
L3097 | }
```

### setClientBaseUnit() — source lines 3098-3105

```javascript
L3098 | function setClientBaseUnit(value='',preserveExisting=true){
L3099 |  const select=$('clientProductUnit');if(!select)return;
L3100 |  const current=String(value||'').trim(),unitClass=$('clientUnitClass')?.value||'other';
L3101 |  const choices=CF_BASE_UNIT_SUGGESTIONS[unitClass]||[];
L3102 |  const legacy=!!(preserveExisting&&current&&!choices.includes(current));
L3103 |  select.innerHTML='<option value="">اختر الوحدة الأساسية</option>'+choices.map(item=>'<option value="'+esc(item)+'">'+esc(item)+'</option>').join('')+(legacy?'<option value="'+esc(current)+'" data-legacy="true">'+esc(current)+' — وحدة محفوظة</option>':'');
L3104 |  select.value=current&&(choices.includes(current)||legacy)?current:'';
L3105 | }
```

### bindGlobalBaseUnitSelector() — source lines 3106-3121

```javascript
L3106 | function bindGlobalBaseUnitSelector(){
L3107 |  const select=$('globalBaseUnitChoice'),unitClass=$('globalUnitClass'),clientUnitClass=$('clientUnitClass');
L3108 |  if(!select||select.dataset.bound==='true')return;
L3109 |  select.dataset.bound='true';
L3110 |  select.addEventListener('change',()=>getGlobalBaseUnitValue());
L3111 |  unitClass?.addEventListener('change',()=>{
L3112 |   const current=getGlobalBaseUnitValue(),dimension=inferProductUnitClass(current);
L3113 |   const keep=current&&(CF_BASE_UNIT_SUGGESTIONS[unitClass.value]||[]).includes(current);
L3114 |   setGlobalBaseUnit(keep?current:(unitClass.value==='mass'?'كجم':''),false);
L3115 |  });
L3116 |  clientUnitClass?.addEventListener('change',()=>{
L3117 |   const current=$('clientProductUnit')?.value||'';
L3118 |   const choices=CF_BASE_UNIT_SUGGESTIONS[clientUnitClass.value]||[];
L3119 |   setClientBaseUnit(choices.includes(current)?current:'',false);
L3120 |  });
L3121 | }
```

### switchGlobalProductTab() — source lines 3122-3130

```javascript
L3122 | function switchGlobalProductTab(tab='basic',focus=false){
L3123 |  const keys=['basic','units','advanced'],active=keys.includes(tab)?tab:'basic';
L3124 |  keys.forEach(key=>{
L3125 |   const panel=$('globalProductPanel-'+key),button=$('globalProductTab-'+key),selected=key===active;
L3126 |   panel?.classList.toggle('hidden',!selected);
L3127 |   if(button){button.setAttribute('aria-selected',String(selected));button.tabIndex=selected?0:-1;button.classList.toggle('active',selected);}
L3128 |  });
L3129 |  if(focus)$('globalProductTab-'+active)?.focus();
L3130 | }
```

### bindGlobalProductTabs() — source lines 3131-3152

```javascript
L3131 | function bindGlobalProductTabs(){
L3132 |  const host=$('globalProductEditorTabs');
L3133 |  if(!host||host.dataset.bound==='true')return;
L3134 |  host.dataset.bound='true';
L3135 |  host.addEventListener('click',event=>{
L3136 |   const button=event.target.closest('[data-global-product-tab]');
L3137 |   if(button)switchGlobalProductTab(button.dataset.globalProductTab);
L3138 |  });
L3139 |  host.addEventListener('keydown',event=>{
L3140 |   const button=event.target.closest('[data-global-product-tab]');
L3141 |   if(!button)return;
L3142 |   const keys=['basic','units','advanced'],index=keys.indexOf(button.dataset.globalProductTab);
L3143 |   if(index<0)return;
L3144 |   let next=index;
L3145 |   if(event.key==='ArrowLeft')next=(index+1)%keys.length;
L3146 |   else if(event.key==='ArrowRight')next=(index-1+keys.length)%keys.length;
L3147 |   else if(event.key==='Home')next=0;
L3148 |   else if(event.key==='End')next=keys.length-1;
L3149 |   else return;
L3150 |   event.preventDefault();switchGlobalProductTab(keys[next],true);
L3151 |  });
L3152 | }
```

### switchCatalogView() — source lines 3154-3169

```javascript
L3154 | function switchCatalogView(view){
L3155 |   const allowed=['global','project'];state.catalogView=allowed.includes(view)?view:'global';
L3156 |   $('catalogGlobalView').classList.toggle('hidden',state.catalogView!=='global');
L3157 |   $('catalogWorkspaceSelector').classList.remove('hidden');
L3158 |   $('projectProductsView').classList.toggle('hidden',state.catalogView!=='project');
L3159 |   $('projectProductScopeNotice').classList.toggle('hidden',!!state.project);
L3160 |   $('projectProductsContent').classList.toggle('hidden',!state.project);
L3161 |   $('catalogProductEditor').classList.add('hidden');
L3162 |   if($('catalogMode'))$('catalogMode').value=state.catalogView;
L3163 |   if(state.catalogView==='project'){
L3164 |    renderProductImportSessions();
L3165 |    if(state.project)loadProductsPage(1,$('productSearch')?.value.trim()||'').catch(e=>fail('تعذر تحميل أصناف ملف التكليف',e));
L3166 |   }else{
L3167 |    refreshClientCatalogPermission().then(()=>loadCatalog()).catch(e=>fail('تعذر تحميل دليل الأصناف الموحد',e));
L3168 |   }
L3169 |  }
```

### attachClientCatalogProductToProject() — source lines 3170-3196

```javascript
L3170 | async function attachClientCatalogProductToProject(clientProductId,button=null){
L3171 |  const project=state.project,clientId=state.catalogClientId;
L3172 |  if(!project?.id||!project.client_id)return notify('ملف التكليف الحالي غير مرتبط بمؤسسة؛ لا يمكن ربط أصناف دليل المؤسسة به.',true);
L3173 |  if(clientId!==project.client_id)return notify('اختر نفس المؤسسة المرتبطة بملف التكليف قبل الإضافة.',true);
L3174 |  if(!state.platformOwner&&!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة دليل المؤسسة.',true);
L3175 |  if((state.sessions||[]).some(item=>['active','paused','review'].includes(item.status)))return notify('قائمة الأصناف مقفلة أثناء جلسة جرد نشطة أو متوقفة أو قيد المراجعة. أتمم الجلسة أولاً.',true);
L3176 |  const mapping=(state.catalogClientRows||[]).find(item=>item.id===clientProductId&&item.is_active);
L3177 |  if(!mapping)return notify('مواءمة المؤسسة غير نشطة أو لم تعد متاحة. حدّث الدليل ثم أعد المحاولة.',true);
L3178 |  const product=(state.catalogProducts||[]).find(item=>item.id===mapping.catalog_product_id);
L3179 |  if(!product||!product.is_active)return notify('الصنف العالمي غير نشط أو لم يعد متاحاً.',true);
L3180 |  const projectId=project.id;
L3181 |  if(button)button.disabled=true;
L3182 |  try{
L3183 |   const {data,error}=await db.rpc('count_attach_catalog_product',{
L3184 |    p_project_id:projectId,p_client_product_id:clientProductId,p_expected_qty:null
L3185 |   });
L3186 |   if(error)throw error;
L3187 |   if(state.project?.id!==projectId)return;
L3188 |   await loadProductsPage(1,state.productQuery||'');
L3189 |   $('kProducts').textContent=String(state.productTotal||0);
L3190 |   notify(data?.already_linked
L3191 |    ?'هذا الصنف مرتبط بالفعل بملف التكليف؛ لم يُنشأ سجل مكرر.'
L3192 |    :'تم إضافة الصنف ونسخ وحدته الأساسية ووحداته البديلة وباركوداتها إلى أصناف التكليف. لم يُنشأ رصيد مرجعي أو حركة جرد.');
L3193 |  }catch(error){
L3194 |   fail('تعذر ربط صنف المؤسسة بملف التكليف',error);
L3195 |  }finally{if(button)button.disabled=false;}
L3196 | }
```

### updateCatalogImportActions() — source lines 3197-3202

```javascript
L3197 | function updateCatalogImportActions(){
L3198 |  const client=state.clients.find(item=>item.id===state.catalogClientId&&item.status==='active');
L3199 |  const allowed=!!(state.platformOwner&&client);
L3200 |  const button=$('catalogOpenClientImport');if(button){button.disabled=!allowed;button.title=allowed?'استيراد ملف أصناف إلى '+client.name:'اختر مؤسسة نشطة أولاً؛ استيراد المؤسسة متاح لمالك المنصة فقط.';}
L3201 |  const target=$('clientCatalogImportTarget');if(target)target.textContent=client?'وجهة الاستيراد: '+client.name+' · '+client.code+'. الأصناف المطابقة ستُربط دون تعديل بيانات الصنف العالمي؛ الناقص فقط سيُنشأ ثم يُربط.':'اختر مؤسسة نشطة من محدد المؤسسة أعلى الدليل.';
L3202 | }
```

### searchGlobalCatalogBeforeManualAdd() — source lines 3203-3228

```javascript
L3203 | async function searchGlobalCatalogBeforeManualAdd(){
L3204 |  if(!state.platformOwner)return notify('البحث في الدليل العالمي متاح لمالك المنصة فقط.',true);
L3205 |  const term=String($('globalCatalogLookupInput')?.value||'').trim();
L3206 |  const host=$('globalCatalogLookupResults');if(!term){host.textContent='اكتب باركوداً أو SKU أو اسماً للبحث.';return;}
L3207 |  if(term.length<2){host.textContent='أدخل حرفين على الأقل للبحث بالاسم.';return;}
L3208 |  const button=$('globalCatalogLookupButton');button.disabled=true;host.textContent='جار البحث في الدليل العالمي…';
L3209 |  try{
L3210 |   const projection='id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path';
L3211 |   const [barcode,sku,unit,name]=await Promise.all([
L3212 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('barcode',term).limit(5),
L3213 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('canonical_sku',term).limit(5),
L3214 |    db.from('count_catalog_products').select(projection).eq('is_active',true).contains('units',[{barcode:term}]).limit(5),
L3215 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('name','%'+term.replace(/[%_,]/g,' ').slice(0,80)+'%').order('name',{ascending:true}).limit(8)
L3216 |   ]);
L3217 |   for(const result of [barcode,sku,unit,name])if(result.error)throw result.error;
L3218 |   const products=new Map();for(const result of [barcode,sku,unit,name])for(const item of result.data||[])products.set(item.id,item);
L3219 |   const rows=[...products.values()].slice(0,12);
L3220 |   if(!rows.length){host.innerHTML='<div class="empty">لم يُعثر على تطابق. يمكنك إغلاق البحث ومتابعة إضافة صنف جديد.</div>';return;}
L3221 |   host.innerHTML='<div class="hint">تم العثور على '+rows.length+' نتيجة؛ اختر الصنف المطابق لفتح سجله الحالي وتجنب إنشاء نسخة أخرى.</div><div class="cf-catalog-lookup-results">'+rows.map(item=>'<div class="cf-catalog-lookup-result"><div><b>'+esc(item.name)+'</b><small>SKU: '+esc(item.canonical_sku||'—')+' · باركود: '+esc(item.barcode||'—')+' · وحدة الأساس: '+esc(item.base_unit||'—')+'</small></div><button type="button" class="soft" data-use-global-lookup="'+esc(item.id)+'">فتح الصنف</button></div>').join('')+'</div>';
L3222 |   host.querySelectorAll('[data-use-global-lookup]').forEach(choice=>choice.onclick=()=>{
L3223 |    const selected=rows.find(item=>item.id===choice.dataset.useGlobalLookup);
L3224 |    if(selected)openUnifiedCatalogItem(selected).catch(error=>fail('تعذر فتح الصنف المطابق',error));
L3225 |   });
L3226 |  }catch(error){host.textContent='تعذر البحث حالياً. '+friendlyErrorMessage(error);fail('تعذر البحث في الدليل العالمي',error);}
L3227 |  finally{button.disabled=false;}
L3228 | }
```

### bindCatalogImportActions() — source lines 3229-3238

```javascript
L3229 | function bindCatalogImportActions(){
L3230 |  const globalButton=$('catalogOpenGlobalImport'),clientButton=$('catalogOpenClientImport');
L3231 |  if(globalButton)globalButton.onclick=()=>{if(!state.platformOwner)return notify('استيراد الدليل العالمي متاح لمالك المنصة فقط.',true);const panel=$('globalCatalogImportTools');panel.open=true;panel.scrollIntoView({behavior:'smooth',block:'start'});$('globalCatalogImportFile').focus();};
L3232 |  if(clientButton)clientButton.onclick=()=>{updateCatalogImportActions();if(clientButton.disabled)return notify('اختر مؤسسة نشطة أولاً.',true);const panel=$('clientCatalogImportTools');panel.open=true;panel.scrollIntoView({behavior:'smooth',block:'start'});$('clientCatalogImportFile').focus();};
L3233 |  $('clientCatalogImportPreview').onclick=previewClientCatalogImport;
L3234 |  $('clientCatalogImportCommit').onclick=commitClientCatalogImport;
L3235 |  $('clientCatalogImportReset').onclick=resetClientCatalogImport;
L3236 |  $('globalCatalogLookupButton').onclick=searchGlobalCatalogBeforeManualAdd;
L3237 |  $('globalCatalogLookupInput').addEventListener('keydown',event=>{if(event.key==='Enter'){event.preventDefault();searchGlobalCatalogBeforeManualAdd();}});
L3238 | }
```

### openGlobalProductEditor() — source lines 3239-3256

```javascript
L3239 | function openGlobalProductEditor(product=null){
L3240 |  if(!state.platformOwner)return notify('لا تملك صلاحية تعديل بيانات الصنف الأساسية.',true);
L3241 |  const p=product||null;resetGlobalImagePreview();state.globalImageCleared=false;
L3242 |  $('globalProductForm').classList.remove('hidden');$('unifiedProductReadOnlySummary')?.classList.add('hidden');
L3243 |  $('globalProductForm').reset();$('globalProductId').value=p?.id||'';$('globalSku').value=p?.canonical_sku||'';$('globalBarcode').value=p?.barcode||'';$('globalName').value=p?.name||'';$('globalBrand').value=p?.brand||'';setCatalogCategoryPicker('global',p?.category||'');$('globalBaseUnit').value=p?.base_unit||'';$('globalImageFile').value='';
L3244 |  $('globalImageCurrent').textContent=p?.image_storage_path?'جار تجهيز معاينة الصورة…':'لا توجد صورة مرتبطة بهذا الصنف.';
L3245 |  renderCatalogUnitEditor('globalProductUnitsEditor',p?.units||[]);setUnitMetaFields('global',p?.units||[],$('globalBaseUnit').value);
L3246 |  if(!p){$('globalItemKind').value='BARCODED';$('globalBarcodeType').value='AUTO';$('globalUnitClass').value='other';$('globalUnitPrecision').value='3';}
L3247 |  $('globalCatalogLookupPanel')?.classList.toggle('hidden',!!p);
L3248 |  if($('globalCatalogLookupResults'))$('globalCatalogLookupResults').textContent='';
L3249 |  if($('globalCatalogLookupInput')&&!p)$('globalCatalogLookupInput').value='';
L3250 |  setGlobalBaseUnit(p?.base_unit||'',true);renderGlobalBarcodeStatus();
L3251 |  $('globalProductFormTitle').textContent=p?'تفاصيل الصنف وتعديل بياناته':'إضافة صنف جديد';$('globalProductSave').textContent=p?'حفظ بيانات الصنف':'إضافة الصنف';
L3252 |  $('catalogGlobalView').classList.add('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.add('hidden');$('catalogProductEditor').classList.remove('hidden');
L3253 |  $('clientCatalogEditorShell')?.classList.add('hidden');resetClientProductForm();
L3254 |  if(p?.image_storage_path)loadGlobalProductImagePreview(p).catch(error=>console.warn('Global image preview failed',error));
L3255 |  switchGlobalProductTab('basic');window.scrollTo({top:0,behavior:'smooth'});
L3256 | }
```

### closeGlobalProductEditor() — source lines 3257-3261

```javascript
L3257 | function closeGlobalProductEditor(){
L3258 |  $('catalogProductEditor').classList.add('hidden');$('catalogGlobalView').classList.remove('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.remove('hidden');
L3259 |  state.catalogView='global';if($('catalogMode'))$('catalogMode').value='global';
L3260 |  $('globalProductForm').classList.remove('hidden');$('globalProductForm').reset();setCatalogCategoryPicker('global','');$('globalProductId').value='';$('globalProductSave').textContent='إضافة الصنف';$('globalImageCurrent').textContent='';state.globalImageCleared=false;resetGlobalImagePreview();renderCatalogUnitEditor('globalProductUnitsEditor',[]);renderGlobalBarcodeStatus();resetClientProductForm();
L3261 | }
```

### openUnifiedCatalogItem() — source lines 3262-3298

```javascript
L3262 | async function openUnifiedCatalogItem(product){
L3263 |  if(!product)return;
L3264 |  const clientId=state.catalogClientId;
L3265 |  await refreshClientCatalogPermission();
L3266 |  if(state.platformOwner)openGlobalProductEditor(product);
L3267 |  else{
L3268 |   $('globalProductForm').classList.add('hidden');
L3269 |   $('catalogGlobalView').classList.add('hidden');$('projectProductsView').classList.add('hidden');$('catalogWorkspaceSelector').classList.add('hidden');
L3270 |   $('catalogProductEditor').classList.remove('hidden');
L3271 |   let summary=$('unifiedProductReadOnlySummary');
L3272 |   if(!summary){summary=document.createElement('div');summary.id='unifiedProductReadOnlySummary';summary.className='panel';$('catalogProductEditor').prepend(summary);}
L3273 |   summary.classList.remove('hidden');
L3274 |   summary.innerHTML='<h3>بيانات الصنف الأساسية — عرض فقط</h3><p><b>'+esc(product.name)+'</b></p><p class="hint">SKU: '+esc(product.canonical_sku||'—')+' · الباركود: '+esc(product.barcode||'—')+' · وحدة الأساس: '+esc(product.base_unit||'—')+'</p>';
L3275 |  }
L3276 |  if(!clientId){notify('اختر المؤسسة أولاً لعرض أو تعديل بياناتها المحلية.',true);return;}
L3277 |  if(!state.canManageClientCatalog){notify('حسابك يستطيع عرض الصنف، ولا يملك صلاحية تعديل بيانات المؤسسة.',true);return;}
L3278 |  const mapping=(state.catalogClientRows||[]).find(x=>x.catalog_product_id===product.id)||null;
L3279 |  $('clientProductForm').reset();
L3280 |  $('clientProductCatalog').innerHTML='<option value="'+esc(product.id)+'">'+esc(product.name)+'</option>';
L3281 |  $('clientProductCatalog').value=product.id;
L3282 |  $('clientProductSku').value=mapping?.client_sku||'';
L3283 |  $('clientProductBarcode').value=mapping?.client_barcode||'';
L3284 |  $('clientProductName').value=mapping?.name_override||'';
L3285 |  setCatalogCategoryPicker('client',mapping?.category_override||'');
L3286 |  $('clientProductImagePath').value=mapping?.image_storage_path_override||'';
L3287 |  const custom=!!(mapping?.base_unit_override||mapping?.units_override);
L3288 |  $('clientUnitsOverrideToggle').checked=custom;
L3289 |  $('clientUnitsOverrideFields').classList.toggle('hidden',!custom);
L3290 |  setUnitMetaFields('client',mapping?.units_override||product.units||[], mapping?.base_unit_override||product.base_unit||'');
L3291 |  setClientBaseUnit(mapping?.base_unit_override||product.base_unit||'',true);
L3292 |  renderCatalogUnitEditor('clientProductUnitsEditor',mapping?.units_override||[]);
L3293 |  $('clientProductFormTitle').textContent=mapping?'تعديل بيانات المؤسسة لهذا الصنف':'إضافة بيانات المؤسسة لهذا الصنف';
L3294 |  openClientCatalogEditor();
L3295 |  $('catalogProductEditor').classList.remove('hidden');
L3296 |  $('catalogGlobalView').classList.add('hidden');
L3297 |  window.scrollTo({top:0,behavior:'smooth'});
L3298 | }
```

### resetClientProductForm() — source lines 3299-3301

```javascript
L3299 | function resetClientProductForm(){
L3300 |  $('clientProductForm').reset();setCatalogCategoryPicker('client','');$('clientProductImagePath').value='';$('clientUnitClass').value='other';$('clientUnitPrecision').value='3';$('clientProductFormTitle').textContent='مواءمة صنف للمؤسسة';$('clientUnitsOverrideFields').classList.add('hidden');setClientBaseUnit('',false);renderCatalogUnitEditor('clientProductUnitsEditor',[]);$('clientCatalogEditorShell')?.classList.add('hidden');
L3301 | }
```

### openClientCatalogEditor() — source lines 3302-3305

```javascript
L3302 | function openClientCatalogEditor(){
L3303 |  if(!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة مواءمات المؤسسة.',true);
L3304 |  $('clientCatalogEditorShell').classList.remove('hidden');$('clientProductSku')?.focus();$('clientCatalogEditorShell').scrollIntoView({behavior:'smooth',block:'start'});
L3305 | }
```

### appendCatalogUnitRow() — source lines 3306-3306

```javascript
L3306 | function appendCatalogUnitRow(id){const el=$(id);if(!el)return;const row=document.createElement('div');row.className='product-unit-row';row.dataset.catalogUnitRow='';row.innerHTML='<div class="field"><label>اسم الوحدة البديلة</label><input data-catalog-unit-name maxlength="40"></div><div class="field"><label>كم تعادل من وحدة الأساس؟</label><input data-catalog-unit-factor type="number" min="0.000001" step="0.000001"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-catalog-unit-barcode maxlength="120"></div><div class="field"><label>نوع الرمز</label><select data-catalog-unit-barcode-type><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128</option></select></div><button type="button" class="danger" data-catalog-unit-remove>إزالة</button>';el.appendChild(row);row.querySelector('[data-catalog-unit-remove]').onclick=()=>{row.remove();if(!el.querySelector('[data-catalog-unit-row]'))renderCatalogUnitEditor(id,[]);};}
```

### refreshClientCatalogPermission() — source lines 3307-3313

```javascript
L3307 | function refreshClientCatalogPermission(){
L3308 |  const id=state.catalogClientId,shell=$('clientCatalogEditorShell'),panel=$('clientProductEditorPanel');
L3309 |  if(!id){state.canManageClientCatalog=false;panel?.classList.add('hidden');shell?.classList.add('hidden');return Promise.resolve(false);}
L3310 |  const apply=allowed=>{state.canManageClientCatalog=!!allowed;panel?.classList.toggle('hidden',!allowed);if(!allowed)shell?.classList.add('hidden');return state.canManageClientCatalog;};
L3311 |  if(state.platformOwner)return Promise.resolve(apply(true));
L3312 |  return db.rpc('count_has_client_permission',{p_client_id:id,p_permission_code:'catalog.manage'}).then(({data,error})=>apply(!error&&data===true));
L3313 | }
```

### renderProductUnitEditor() — source lines 3314-3322

```javascript
L3314 | function renderProductUnitEditor(units=[]){
L3315 |   const container=$('productUnitsEditor');if(!container)return;
L3316 |   const rows=productUnitRows(units).map(u=>({name:String(u?.name||''),factor_to_base:String(u?.factor_to_base??u?.conversion_factor??u?.factor??''),barcode:String(u?.barcode||''),barcode_type:String(u?.barcode_type||'AUTO')}));
L3317 |   container.innerHTML=(rows.length?rows:[{name:'',factor_to_base:'',barcode:'',barcode_type:'AUTO'}]).map((u,i)=>'<div class="product-unit-row" data-product-unit-row><div class="field"><label>اسم الوحدة البديلة</label><input data-unit-name value="'+esc(u.name)+'" maxlength="40" placeholder="مثال: كرتونة"></div><div class="field"><label>كم تعادل من الوحدة الأساسية؟</label><input data-unit-factor type="number" min="0.000001" step="0.000001" value="'+esc(u.factor_to_base)+'" placeholder="مثال: 12"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-unit-barcode value="'+esc(u.barcode)+'" maxlength="120"></div><div class="field"><label>نوع الرمز</label><select data-unit-barcode-type><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128</option></select></div><button type="button" class="danger" data-remove-product-unit aria-label="إزالة الوحدة">إزالة</button></div>').join('');
L3318 |   container.querySelectorAll('[data-remove-product-unit]').forEach(button=>button.onclick=()=>{
L3319 |    button.closest('[data-product-unit-row]')?.remove();
L3320 |    if(!container.querySelector('[data-product-unit-row]'))renderProductUnitEditor([]);
L3321 |   });
L3322 |  }
```

### readProductUnits() — source lines 3323-3336

```javascript
L3323 | function readProductUnits(baseUnit,primaryBarcode=null){
L3324 |   const rows=[...$('productUnitsEditor').querySelectorAll('[data-product-unit-row]')],units=[],seen=new Set(),codes=new Set(),base=String(baseUnit||'').trim().toLocaleLowerCase();if(primaryBarcode)codes.add(String(primaryBarcode).trim().toLowerCase());
L3325 |   for(const row of rows){
L3326 |    const name=row.querySelector('[data-unit-name]').value.trim(),raw=row.querySelector('[data-unit-factor]').value.trim(),barcode=row.querySelector('[data-unit-barcode]')?.value.trim()||'',requested=row.querySelector('[data-unit-barcode-type]')?.value||'AUTO';
L3327 |    if(!name&&!raw&&!barcode)continue;
L3328 |    if(!name||!raw)throw new Error('أكمل اسم الوحدة البديلة ومعامل التحويل معاً.');
L3329 |    const key=name.toLocaleLowerCase(),factor=Number(raw);
L3330 |    if(key===base)throw new Error('الوحدة البديلة يجب أن تختلف عن الوحدة الأساسية.');
L3331 |    if(seen.has(key))throw new Error('لا تكرر اسم الوحدة البديلة في الصنف نفسه.');
L3332 |    if(!Number.isFinite(factor)||factor<=0||factor>1000000000)throw new Error('معامل التحويل يجب أن يكون رقماً موجباً وصالحاً.');
L3333 |    const unit={name,factor_to_base:factor};if(barcode){const type=cfResolveBarcodeType(barcode,requested);if(codes.has(barcode.toLowerCase()))throw new Error('لا يمكن تكرار باركود الصنف أو وحداته.');codes.add(barcode.toLowerCase());unit.barcode=barcode;unit.barcode_type=type;}seen.add(key);units.push(unit);
L3334 |   }
L3335 |   return units;
L3336 |  }
```

### showProductImagePreview() — source lines 3337-3342

```javascript
L3337 | function showProductImagePreview(source,title,note=''){
L3338 |   const box=$('productImagePreview');if(!box)return;
L3339 |   if(!source){box.classList.add('hidden');$('productImagePreviewImg').removeAttribute('src');return;}
L3340 |   $('productImagePreviewImg').src=source;$('productImagePreviewTitle').textContent=title||'صورة الصنف';$('productImagePreviewNote').textContent=note||'تُحفظ الصورة داخل مساحة CountFlow الخاصة بهذا التكليف.';box.classList.remove('hidden');
L3341 |   $('clearProductImage').hidden=false;
L3342 |  }
```

### resetProductImagePreview() — source lines 3343-3346

```javascript
L3343 | function resetProductImagePreview(){
L3344 |   if(state.productImagePreviewObjectUrl){URL.revokeObjectURL(state.productImagePreviewObjectUrl);state.productImagePreviewObjectUrl=null;}
L3345 |   $('productImageFile').value='';$('imageUrl').value='';$('productImagePreview').classList.add('hidden');$('productImagePreviewImg').removeAttribute('src');$('clearProductImage').hidden=true;
L3346 |  }
```

### uploadProductImage() — source lines 3347-3356

```javascript
L3347 | async function uploadProductImage(file,projectId){
L3348 |   const extensions={'image/jpeg':'jpg','image/png':'png'};
L3349 |   const extension=extensions[file?.type];
L3350 |   if(!file||!extension)throw new Error('اختر صورة JPEG أو PNG؛ هذه الصيغ فقط مدعومة للتضمين في ملف Excel.');
L3351 |   if(file.size<=0||file.size>MAX_PRODUCT_IMAGE_BYTES)throw new Error('حجم الصورة يجب ألا يتجاوز 1MiB حتى يمكن تضمينها في ملف Excel.');
L3352 |   const path=projectId+'/products/'+crypto.randomUUID()+'.'+extension;
L3353 |   const {error}=await db.storage.from('counting-product-images').upload(path,file,{cacheControl:'3600',contentType:file.type,upsert:false});
L3354 |   if(error){console.warn('Product image upload failed',error);throw new Error('تعذر رفع الصورة. تحقق من اتصالك وصلاحية العضوية ثم أعد المحاولة.');}
L3355 |   return path;
L3356 |  }
```

### editProduct() — source lines 3357-3364

```javascript
L3357 | async function editProduct(id){
L3358 |  const p=state.products.find(x=>x.id===id);if(!p)return;
L3359 |  $('projectProductEditorPanel').classList.remove('hidden');$('projectProductWorkspace').classList.add('cf-catalog-editor-open');
L3360 |  resetProductImagePreview();$('productId').value=p.id;$('sku').value=p.sku;$('barcode').value=p.barcode||'';$('productName').value=p.name||'';$('category').value=p.category||'';$('baseUnit').value=p.base_unit;$('expectedQty').value=p.expected_qty??'';
L3361 |  state.editingProductImageRef=p.image_url||null;state.productImageCleared=false;$('imageUrl').value=safeExternalProductImageUrl(p.image_url);
L3362 |  const displayUrl=productImageDisplayUrl(p);if(displayUrl)showProductImagePreview(displayUrl,'الصورة الحالية للصنف','هذه الصورة محفوظة في مساحة CountFlow الخاصة. عند الاستبدال أو إزالة الربط يبقى الملف القديم في التخزين ولا يُحذف تلقائياً.');
L3363 |  renderProductUnitEditor(p.units||[]);setUnitMetaFields('unit',p.units||[],p.base_unit);$('productFormTitle').textContent='تعديل الصنف';$('projectProductEditorPanel').scrollIntoView({behavior:'smooth',block:'start'});
L3364 | }
```

### resetProductForm() — source lines 3365-3368

```javascript
L3365 | function resetProductForm(){
L3366 |  $('productForm').reset();$('productId').value='';$('baseUnit').value='وحدة';$('unitClass').value='count';$('unitPrecision').value='0';$('unitItemKind').value='BARCODED';$('unitBarcodeType').value='AUTO';$('productFormTitle').textContent='إضافة صنف';
L3367 |  state.editingProductImageRef=null;state.productImageCleared=false;resetProductImagePreview();renderProductUnitEditor([]);$('projectProductEditorPanel')?.classList.add('hidden');$('projectProductWorkspace')?.classList.remove('cf-catalog-editor-open');
L3368 | }
```

### toggleProduct() — source lines 3369-3373

```javascript
L3369 | async function toggleProduct(id){
L3370 |   const p=state.products.find(x=>x.id===id);if(!p)return;
L3371 |   const {error}=await db.from('count_products').update({is_active:!p.is_active,updated_at:new Date().toISOString()}).eq('id',id).eq('project_id',state.project.id);
L3372 |   if(error)return fail('تعذر تحديث حالة الصنف',error);notify(p.is_active?'تم إيقاف الصنف':'تم تفعيل الصنف');await loadProjectData();
L3373 |  }
```

### safeCatalogProductImagePath() — source lines 3709-3714

```javascript
L3709 | function safeCatalogProductImagePath(product){
L3710 |  const id=String(product?.id||''),path=String(product?.image_storage_path||'');
L3711 |  if(!id||!path.startsWith('catalog/products/'+id+'/'))return '';
L3712 |  const name=path.slice(('catalog/products/'+id+'/').length);
L3713 |  return /^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$/.test(name)?path:'';
L3714 | }
```

### loadCatalogImageUrls() — source lines 3715-3725

```javascript
L3715 | async function loadCatalogImageUrls(rows,requestToken){
L3716 |  const paths=[...new Set((rows||[]).filter(p=>p.is_active).map(safeCatalogProductImagePath).filter(Boolean))];
L3717 |  state.catalogImageUrls=new Map();
L3718 |  if(!paths.length||requestToken!==state.catalogRequestToken)return;
L3719 |  try{
L3720 |   const result=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L3721 |   if(result.error)throw result.error;
L3722 |   if(requestToken!==state.catalogRequestToken)return;
L3723 |   for(const item of result.data||[])if(item.path&&item.signedUrl)state.catalogImageUrls.set(item.path,item.signedUrl);
L3724 |  }catch(error){console.warn('Catalogue image preview URLs unavailable',error);}
L3725 | }
```

### catalogImageMarkup() — source lines 3726-3731

```javascript
L3726 | function catalogImageMarkup(product){
L3727 |  const path=safeCatalogProductImagePath(product),url=path?state.catalogImageUrls.get(path):'';
L3728 |  if(url)return '<button type="button" class="cf-catalog-image-button" data-preview-catalog-image="'+esc(product.id)+'" aria-label="معاينة صورة '+esc(product.name||'الصنف')+'"><img class="cf-catalog-thumb" src="'+esc(url)+'" alt="" loading="lazy"></button>';
L3729 |  const hint=product.image_storage_path?(product.is_active?'تعذر تحميل الصورة':'الصورة غير متاحة للصنف الموقوف'):'لا توجد صورة';
L3730 |  return '<span class="cf-catalog-image-empty" title="'+esc(hint)+'" aria-label="'+esc(hint)+'"><i class="fa-regular fa-image" aria-hidden="true"></i></span>';
L3731 | }
```

### openCatalogImage() — source lines 3732-3736

```javascript
L3732 | function openCatalogImage(product){
L3733 |  const path=safeCatalogProductImagePath(product),url=path?state.catalogImageUrls.get(path):'';
L3734 |  if(!url)return notify('صورة هذا الصنف غير متاحة للعرض حالياً.',true);
L3735 |  if(window.Swal?.fire)window.Swal.fire({title:product.name||'صورة الصنف',imageUrl:url,imageAlt:product.name||'صورة الصنف',imageWidth:720,showConfirmButton:false,showCloseButton:true,customClass:{popup:'cf-swal-popup'}});
L3736 | }
```

### resetGlobalImagePreview() — source lines 3737-3741

```javascript
L3737 | function resetGlobalImagePreview(){
L3738 |  state.catalogEditorImageToken=(state.catalogEditorImageToken||0)+1;
L3739 |  if(state.globalImagePreviewObjectUrl){URL.revokeObjectURL(state.globalImagePreviewObjectUrl);state.globalImagePreviewObjectUrl=null;}
L3740 |  $('globalImagePreview').classList.add('hidden');$('globalImagePreviewImg').removeAttribute('src');$('globalImageFile').value='';
L3741 | }
```

### showGlobalImagePreview() — source lines 3742-3745

```javascript
L3742 | function showGlobalImagePreview(url,title,note){
L3743 |  if(!url)return;
L3744 |  $('globalImagePreviewImg').src=url;$('globalImagePreviewTitle').textContent=title||'صورة الصنف';$('globalImagePreviewNote').textContent=note||'تُحفظ الصورة داخل مساحة CountFlow الخاصة.';$('globalImagePreview').classList.remove('hidden');
L3745 | }
```

### loadGlobalProductImagePreview() — source lines 3746-3758

```javascript
L3746 | async function loadGlobalProductImagePreview(product){
L3747 |  resetGlobalImagePreview();
L3748 |  const token=state.catalogEditorImageToken,path=safeCatalogProductImagePath(product);
L3749 |  if(!path){$('globalImageCurrent').textContent='لا توجد صورة مرتبطة بهذا الصنف.';return;}
L3750 |  $('globalImageCurrent').textContent='جار تحميل معاينة الصورة المحفوظة…';
L3751 |  try{
L3752 |   const result=await db.storage.from('counting-product-images').createSignedUrl(path,3600);
L3753 |   if(token!==state.catalogEditorImageToken)return;
L3754 |   if(result.error||!result.data?.signedUrl)throw result.error||new Error('Signed image URL unavailable');
L3755 |   $('globalImageCurrent').textContent='الصورة الحالية محفوظة في مساحة CountFlow الخاصة.';
L3756 |   showGlobalImagePreview(result.data.signedUrl,'الصورة الحالية للصنف','رابط عرض مؤقت؛ لا يُحفظ الرابط داخل سجل الصنف.');
L3757 |  }catch(error){if(token===state.catalogEditorImageToken)$('globalImageCurrent').textContent='تعذر عرض الصورة الحالية؛ سيظل سجل الصنف محفوظاً.';console.warn('Global catalogue image preview failed',error);}
L3758 | }
```

### downloadCatalogCsv() — source lines 3764-3770

```javascript
L3764 | function downloadCatalogCsv(filename,headers,rows){
L3765 |  const content='\uFEFF'+[headers,...rows].map(row=>row.map(csvCell).join(',')).join('\r\n');
L3766 |  const blob=new Blob([content],{type:'text/csv;charset=utf-8;'});
L3767 |  const url=URL.createObjectURL(blob),anchor=document.createElement('a');
L3768 |  anchor.href=url;anchor.download=filename;anchor.style.display='none';document.body.appendChild(anchor);anchor.click();anchor.remove();
L3769 |  setTimeout(()=>URL.revokeObjectURL(url),1500);
L3770 | }
```

### currentCatalogFilters() — source lines 3771-3773

```javascript
L3771 | function currentCatalogFilters(){
L3772 |  return {status:$('catalogStatusFilter')?.value||'active',category:$('catalogCategoryFilter')?.value.trim()||'',term:$('catalogSearch')?.value.trim().replace(/[%,()."'\\]/g,' ').replace(/\s+/g,' ').slice(0,90)||'',sort:['name','canonical_sku','barcode','category','base_unit'].includes(state.catalogSort)?state.catalogSort:'name',ascending:!!state.catalogSortAsc};
L3773 | }
```

### applyCatalogFilters() — source lines 3774-3779

```javascript
L3774 | function applyCatalogFilters(query,filters){
L3775 |  if(filters.status==='active')query=query.eq('is_active',true);else if(filters.status==='inactive')query=query.eq('is_active',false);
L3776 |  if(filters.category)query=query.ilike('category','%'+filters.category+'%');
L3777 |  if(filters.term)query=query.or(['name','canonical_sku','barcode','brand'].map(k=>k+'.ilike.%'+filters.term+'%').join(','));
L3778 |  return query;
L3779 | }
```

### applyUnifiedCatalogFilters() — source lines 3780-3799

```javascript
L3780 | async function applyUnifiedCatalogFilters(query,filters,clientId){
L3781 |  query=applyCatalogFilters(query,{...filters,term:''});
L3782 |  if(!filters.term)return {query};
L3783 |  const value=filters.term,conditions=['name','canonical_sku','barcode','brand'].map(k=>k+'.ilike.%'+value+'%');
L3784 |  if(clientId){
L3785 |   const ids=[];let offset=0,pageSize=500;
L3786 |   while(true){
L3787 |    const result=await db.from('count_client_products').select('catalog_product_id').eq('client_id',clientId)
L3788 |     .or(['client_sku','client_barcode','name_override','category_override'].map(k=>k+'.ilike.%'+value+'%').join(','))
L3789 |     .order('catalog_product_id',{ascending:true}).range(offset,offset+pageSize-1);
L3790 |    if(result.error)throw result.error;
L3791 |    const page=result.data||[];ids.push(...page.map(x=>x.catalog_product_id).filter(Boolean));
L3792 |    if(page.length<pageSize)break;offset+=pageSize;
L3793 |    if(ids.length>90000)throw new Error('تجاوز بحث المؤسسة 90,000 نتيجة؛ استخدم كلمة بحث أكثر تحديداً.');
L3794 |   }
L3795 |   const unique=[...new Set(ids)];
L3796 |   if(unique.length)conditions.push('id.in.('+unique.join(',')+')');
L3797 |  }
L3798 |  return {query:query.or(conditions.join(','))};
L3799 | }
```

### exportGlobalCatalogCsv() — source lines 3800-3823

```javascript
L3800 | async function exportGlobalCatalogCsv(){
L3801 |  if(!state.user)return notify('سجّل الدخول أولاً.',true);
L3802 |  const button=$('catalogExport');button.disabled=true;
L3803 |  try{
L3804 |   const f=currentCatalogFilters(),rows=[],clientRows=new Map(),pageSize=500,clientId=state.catalogClientId;let offset=0;
L3805 |   while(true){
L3806 |    let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path').order(f.sort,{ascending:f.ascending}).order('id',{ascending:true});
L3807 |    const filtered=await applyUnifiedCatalogFilters(q,f,clientId);q=filtered.query.range(offset,offset+pageSize-1);
L3808 |    const result=await q;if(result.error)throw result.error;
L3809 |    const page=result.data||[];
L3810 |    if(clientId&&page.length){
L3811 |     const local=await db.from('count_client_products').select('catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',clientId).in('catalog_product_id',page.map(p=>p.id));
L3812 |     if(local.error)throw local.error;
L3813 |     for(const item of local.data||[])clientRows.set(item.catalog_product_id,item);
L3814 |    }
L3815 |    rows.push(...page);if(page.length<pageSize)break;offset+=pageSize;
L3816 |    if(rows.length>90000)throw new Error('تجاوزت النتائج 90,000 سجل؛ ضيّق البحث أو صدّر على دفعات أصغر.');
L3817 |   }
L3818 |   downloadCatalogCsv('CountFlow-unified-catalog-'+new Date().toISOString().slice(0,10)+'.csv',
L3819 |    ['SKU الأساسي','باركود الصنف الأساسي','اسم الصنف الأساسي','العلامة التجارية','التصنيف الأساسي','وحدة الأساس','الوحدات والتحويلات الأساسية JSON','SKU المؤسسة','باركود المؤسسة','اسم المؤسسة','تصنيف المؤسسة','وحدة الأساس للمؤسسة','وحدات المؤسسة JSON','الحالة العامة','حالة المؤسسة','مسار الصورة الخاص','مسار صورة المؤسسة الخاص'],
L3820 |    rows.map(p=>{const local=clientRows.get(p.id);return [p.canonical_sku,p.barcode,p.name,p.brand,p.category,p.base_unit,p.units,local?.client_sku,local?.client_barcode,local?.name_override,local?.category_override,local?.base_unit_override,local?.units_override,p.is_active?'نشط':'موقوف',local?(local.is_active?'نشط':'موقوف'):'غير مواءم',p.image_storage_path,local?.image_storage_path_override];}));
L3821 |   notify('تم تصدير '+rows.length.toLocaleString('ar-EG')+' صنفاً مع حقول المؤسسة المختارة.');
L3822 |  }catch(error){fail('تعذر تصدير دليل الأصناف الموحد',error);}finally{button.disabled=false;}
L3823 | }
```

### exportProjectCatalogCsv() — source lines 3824-3839

```javascript
L3824 | async function exportProjectCatalogCsv(){
L3825 |  const project=state.project;if(!project)return notify('اختر ملف تكليف أولاً.',true);
L3826 |  const button=$('projectCatalogExport');button.disabled=true;
L3827 |  try{
L3828 |   const rows=[],pageSize=500;let offset=0;
L3829 |   while(true){
L3830 |    const result=await db.from('count_products').select('sku,barcode,name,category,base_unit,units,expected_qty,image_url,is_active').eq('project_id',project.id).order('name',{ascending:true}).order('id',{ascending:true}).range(offset,offset+pageSize-1);
L3831 |    if(result.error)throw result.error;const page=result.data||[];rows.push(...page);if(page.length<pageSize)break;offset+=pageSize;
L3832 |    if(rows.length>=200000)throw new Error('تجاوزت أصناف التكليف 200,000 سجل؛ يرجى تقسيم التصدير.');
L3833 |   }
L3834 |   downloadCatalogCsv('CountFlow-project-products-'+String(project.project_code||project.id).replace(/[^A-Za-z0-9_-]/g,'-')+'-'+new Date().toISOString().slice(0,10)+'.csv',
L3835 |    ['SKU','الباركود','اسم الصنف','التصنيف','وحدة الأساس','الوحدات JSON','الكمية المرجعية','مرجع الصورة','الحالة'],
L3836 |    rows.map(p=>[p.sku,p.barcode,p.name,p.category,p.base_unit,p.units,p.expected_qty,p.image_url,p.is_active?'نشط':'موقوف']));
L3837 |   notify('تم تصدير '+rows.length.toLocaleString('ar-EG')+' صنفاً من التكليف المحدد.');
L3838 |  }catch(error){fail('تعذر تصدير أصناف التكليف',error);}finally{button.disabled=false;}
L3839 | }
```

### loadCatalog() — source lines 3840-3877

```javascript
L3840 | async function loadCatalog(){
L3841 |  if(!state.user)return;
L3842 |  const requestToken=state.catalogRequestToken=(state.catalogRequestToken||0)+1;
L3843 |  const filters=currentCatalogFilters(),sort=filters.sort,table=$('catalogTable');
L3844 |  table?.setAttribute('aria-busy','true');
L3845 |  try{
L3846 |   let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path',{count:'exact'}).order(sort,{ascending:state.catalogSortAsc}).order('id',{ascending:true});
L3847 |   const filtered=await applyUnifiedCatalogFilters(q,filters,state.catalogClientId);
L3848 |   const size=50,page=Math.max(1,Number(state.catalogPage)||1);q=filtered.query.range((page-1)*size,page*size-1);
L3849 |   const x=await q;if(x.error)throw x.error;if(requestToken!==state.catalogRequestToken)return;
L3850 |   state.catalogProducts=x.data||[];state.catalogTotal=Number(x.count||0);
L3851 |   const scopedClient=state.catalogClientId,productIds=state.catalogProducts.map(p=>p.id);
L3852 |   state.catalogClientRows=[];
L3853 |   if(scopedClient&&productIds.length){
L3854 |    const local=await db.from('count_client_products').select('id,client_id,catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',scopedClient).in('catalog_product_id',productIds);
L3855 |    if(local.error)throw local.error;state.catalogClientRows=local.data||[];
L3856 |   }
L3857 |   await loadCatalogImageUrls(state.catalogProducts,requestToken);if(requestToken!==state.catalogRequestToken)return;
L3858 |   $('catalogResultCount').textContent=state.catalogTotal.toLocaleString('ar-EG')+' صنفاً في الدليل'+(scopedClient?' · مع بيانات المؤسسة المختارة':'');
L3859 |   const localByProduct=new Map((state.catalogClientRows||[]).map(r=>[r.catalog_product_id,r]));
L3860 |   table.innerHTML=state.catalogProducts.length?'<table class="cf-catalog-table"><thead><tr><th>الصورة</th><th>#</th><th><button class="cf-catalog-sort" data-sort-catalog="name" type="button">الصنف '+(sort==='name'?(state.catalogSortAsc?'↑':'↓'):'↕')+'</button></th><th><button class="cf-catalog-sort" data-sort-catalog="canonical_sku" type="button">SKU الأساسي '+(sort==='canonical_sku'?(state.catalogSortAsc?'↑':'↓'):'↕')+'</button></th><th>بيانات المؤسسة المختارة</th><th><button class="cf-catalog-sort" data-sort-catalog="barcode" type="button">الباركود الأساسي '+(sort==='barcode'?(state.catalogSortAsc?'↑':'↓'):'↕')+'</button></th><th><button class="cf-catalog-sort" data-sort-catalog="category" type="button">التصنيف</button></th><th><button class="cf-catalog-sort" data-sort-catalog="base_unit" type="button">وحدة الأساس</button></th><th>الوحدات البديلة</th><th>الحالة</th></tr></thead><tbody>'+state.catalogProducts.map((p,i)=>{const units=productUnitRows(Array.isArray(p.units)?p.units:[]),m=localByProduct.get(p.id),localMarkup=scopedClient?(m?'<b>'+esc(m.name_override||p.name)+'</b><span class="sub">SKU: '+esc(m.client_sku||'—')+' · باركود: '+esc(m.client_barcode||'—')+'</span>':'<span class="muted">لا توجد بيانات محلية</span>'):'<span class="muted">اختر مؤسسة لعرض الحقول المحلية</span>';const localEdit=state.canManageClientCatalog&&scopedClient?'<button class="soft" type="button" data-edit-client-map="'+esc(p.id)+'">'+(m?'بيانات المؤسسة':'إضافة بيانات المؤسسة')+'</button>':'';const attachScope=!!(state.project?.client_id&&state.project.client_id===scopedClient&&state.canManageClientCatalog&&m?.id&&m.is_active&&p.is_active),attachLocked=(state.sessions||[]).some(session=>['active','paused','review'].includes(session.status)),projectAttach=attachScope?'<button class="soft" type="button" data-attach-client-catalog-product="'+esc(m.id)+'" '+(attachLocked?'disabled title="مقفول أثناء جلسة الجرد"':'')+'>إضافة إلى التكليف المحدد</button>':'';const actions=(state.platformOwner?'<button class="soft" type="button" data-edit-catalog="'+esc(p.id)+'">فتح التفاصيل</button><button class="'+(p.is_active?'danger':'soft')+'" type="button" data-catalog-state="'+esc(p.id)+'">'+(p.is_active?'إيقاف':'تفعيل')+'</button>':'')+localEdit+projectAttach;return '<tr tabindex="0" data-open-catalog-item="'+esc(p.id)+'" aria-label="فتح تفاصيل '+esc(p.name)+'"><td>'+catalogImageMarkup(p)+'</td><td>'+((page-1)*size+i+1)+'</td><td><b>'+esc(p.name)+'</b><span class="sub">'+esc(p.brand||'صنف عام')+'</span></td><td>'+esc(p.canonical_sku||'—')+'</td><td>'+localMarkup+'</td><td><span dir="ltr">'+esc(p.barcode||'—')+'</span></td><td>'+esc(p.category||'—')+'</td><td>'+esc(p.base_unit||'—')+'</td><td>'+units.length+'</td><td>'+statusPill(p.is_active?'active':'paused')+'<div class="cf-inline-actions">'+actions+'</div></td></tr>';}).join('')+'</tbody></table>':'<div class="empty">لا توجد أصناف مطابقة للبحث والمرشحات الحالية.</div>';
L3861 |   table.querySelectorAll('[data-preview-catalog-image]').forEach(b=>b.onclick=e=>{e.stopPropagation();const p=state.catalogProducts.find(x=>x.id===b.dataset.previewCatalogImage);if(p)openCatalogImage(p);});
L3862 |   table.querySelectorAll('[data-sort-catalog]').forEach(b=>b.onclick=e=>{e.stopPropagation();const k=b.dataset.sortCatalog;if(state.catalogSort===k)state.catalogSortAsc=!state.catalogSortAsc;else{state.catalogSort=k;state.catalogSortAsc=true;}state.catalogPage=1;loadCatalog().catch(e=>fail('تعذر ترتيب الأصناف',e));});
L3863 |   table.querySelectorAll('[data-open-catalog-item]').forEach(row=>{const open=()=>{const p=state.catalogProducts.find(x=>x.id===row.dataset.openCatalogItem);if(p)openUnifiedCatalogItem(p).catch(e=>fail('تعذر فتح تفاصيل الصنف',e));};row.addEventListener('click',e=>{if(e.target.closest('button'))return;open();});row.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();open();}});});
L3864 |   table.querySelectorAll('[data-edit-catalog]').forEach(b=>b.onclick=e=>{e.stopPropagation();const p=state.catalogProducts.find(x=>x.id===b.dataset.editCatalog);if(p)openUnifiedCatalogItem(p).catch(err=>fail('تعذر فتح الصنف',err));});
L3865 |   table.querySelectorAll('[data-edit-client-map]').forEach(b=>b.onclick=e=>{e.stopPropagation();const p=state.catalogProducts.find(x=>x.id===b.dataset.editClientMap);if(p)openUnifiedCatalogItem(p).catch(err=>fail('تعذر فتح بيانات المؤسسة',err));});
L3866 |   table.querySelectorAll('[data-attach-client-catalog-product]').forEach(b=>b.onclick=e=>{e.stopPropagation();attachClientCatalogProductToProject(b.dataset.attachClientCatalogProduct,b);});
L3867 |   table.querySelectorAll('[data-catalog-state]').forEach(b=>b.onclick=e=>{e.stopPropagation();toggleCatalogProduct(b.dataset.catalogState);});
L3868 |   const pages=Math.max(1,Math.ceil(state.catalogTotal/size));$('catalogPagination').innerHTML='<span class="hint">عرض '+(state.catalogTotal?(page-1)*size+1:0)+'–'+Math.min(page*size,state.catalogTotal)+' من '+state.catalogTotal+' · الصفحة '+page+' / '+pages+'</span><div class="actions"><button id="catalogPrev" class="soft" type="button" '+(page<=1?'disabled':'')+'>السابق</button><button id="catalogNext" class="soft" type="button" '+(page>=pages?'disabled':'')+'>التالي</button></div>';$('catalogPrev').onclick=()=>{if(state.catalogPage>1){state.catalogPage--;loadCatalog().catch(e=>fail('تعذر تحميل الصفحة',e));}};$('catalogNext').onclick=()=>{if(state.catalogPage<pages){state.catalogPage++;loadCatalog().catch(e=>fail('تعذر تحميل الصفحة',e));}};
L3869 |  }catch(error){
L3870 |   if(requestToken===state.catalogRequestToken){
L3871 |    if(table)table.innerHTML='<div class="empty" role="alert">تعذر تحميل دليل الأصناف الآن. بقي تسجيل الدخول محفوظاً؛ تحقق من الاتصال أو الصلاحية ثم اضغط «تحديث» لإعادة المحاولة.</div>';
L3872 |    const count=$('catalogResultCount');if(count)count.textContent='تعذر تحديث نتائج الدليل';
L3873 |    const pagination=$('catalogPagination');if(pagination)pagination.innerHTML='';
L3874 |   }
L3875 |   throw error;
L3876 |  }finally{if(requestToken===state.catalogRequestToken)table?.removeAttribute('aria-busy');}
L3877 | }
```

### toggleCatalogProduct() — source lines 3878-3886

```javascript
L3878 | async function toggleCatalogProduct(id){
L3879 |   if(!state.platformOwner)return notify('تعديل الكتالوج العالمي للمالك فقط.',true);
L3880 |   const p=state.catalogProducts.find(x=>x.id===id);if(!p)return;
L3881 |   if(p.is_active&&!await confirmAction('سيتم إيقاف الصنف عن الاستخدام في عمليات الجرد الجديدة. ستظل بياناته وروابطه التاريخية محفوظة. هل تريد المتابعة؟',{title:'إيقاف صنف عالمي',confirmText:'إيقاف الصنف'}))return;
L3882 |   const {error}=await db.from('count_catalog_products').update({is_active:!p.is_active,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',id);
L3883 |   if(error)throw error;
L3884 |   notify(p.is_active?'تم إيقاف الصنف مع الاحتفاظ بسجله وروابطه.':'تمت إعادة تفعيل الصنف.');
L3885 |   await loadCatalog();
L3886 |  }
```

### resetGlobalProductForm() — source lines 3887-3890

```javascript
L3887 | function resetGlobalProductForm(){
L3888 |   $('globalProductForm').reset();$('globalProductId').value='';$('globalUnitClass').value='other';$('globalUnitPrecision').value='3';
L3889 |   $('globalProductFormTitle').textContent='إضافة صنف عالمي';$('globalProductSave').textContent='إضافة للكتالوج';
L3890 |  }
```

### bindUnitPrecisionDefaults() — source lines 3892-3897

```javascript
L3892 | function bindUnitPrecisionDefaults(){
L3893 |  [['globalUnitClass','globalUnitPrecision'],['unitClass','unitPrecision'],['clientUnitClass','clientUnitPrecision']].forEach(([classId,precisionId])=>{
L3894 |   const cls=$(classId),precision=$(precisionId);if(!cls||!precision)return;
L3895 |   cls.addEventListener('change',()=>{precision.value=defaultProductUnitPrecision(cls.value);});
L3896 |  });
L3897 | }
```

### scheduleCatalogReload() — source lines 3924-3924

```javascript
L3924 | function scheduleCatalogReload(){clearTimeout(state.catalogSearchTimer);state.catalogSearchTimer=setTimeout(()=>{state.catalogPage=1;loadCatalog().catch(e=>fail('تعذر تحديث نتائج البحث',e));},260);}
```

### Global item save/update logic (not a named saveItem function) — inline submit listener, source lines 3899-3918

```javascript
L3899 |  $('globalProductForm').addEventListener('submit',async e=>{
L3900 |   e.preventDefault();if(!state.platformOwner)return notify('إدارة الأصناف العالمية للمالك فقط.',true);const f=e.currentTarget;setBusy(f,true);
L3901 |   try{
L3902 |    const id=$('globalProductId').value||null,sku=$('globalSku').value.trim()||null,barcode=$('globalBarcode').value.trim()||null,base=getGlobalBaseUnitValue(),itemKind=$('globalItemKind').value,requestedType=$('globalBarcodeType').value,unitClass=$('globalUnitClass').value;
L3903 |    if(!base)throw new Error('وحدة الأساس مطلوبة.');
L3904 |    const inferredUnitClass=inferProductUnitClass(base);if(inferredUnitClass!=='other'&&inferredUnitClass!==unitClass)throw new Error('الوحدة الأساسية لا تتوافق مع نمط القياس المحدد؛ اختر وحدة مناسبة أو غيّر نمط القياس.');
L3905 |    if(itemKind==='BARCODED'&&!barcode)throw new Error('الصنف الذي يحمل باركوداً يحتاج رمزاً خارجياً؛ اختر بدون باركود لتوليد معرف داخلي.');
L3906 |    if(itemKind==='WEIGHED'&&$('globalUnitClass').value!=='mass')throw new Error('الصنف الوزني يحتاج فئة وحدة قياس من الوزن.');
L3907 |    const barcodeType=barcode?cfResolveBarcodeType(barcode,requestedType):'INTERNAL';
L3908 |    if(itemKind==='NO_BARCODE'&&barcode&&barcodeType!=='INTERNAL')throw new Error('الصنف بدون باركود لا يقبل GTIN أو Code 128 خارجي.');
L3909 |    const units=getUnitMetaFields('global',readCatalogUnits('globalProductUnitsEditor',base,barcode),{item_kind:itemKind,barcode_type:barcodeType}),file=$('globalImageFile').files[0]||null;
L3910 |    if(file&&(file.size<=0||file.size>5*1024*1024||!['image/jpeg','image/png','image/webp'].includes(file.type)))throw new Error('الصورة يجب ألا تتجاوز 5MB وأن تكون JPEG/PNG/WEBP.');
L3911 |    const row={canonical_sku:sku,barcode:barcode||null,name:$('globalName').value.trim(),brand:$('globalBrand').value.trim()||null,category:$('globalCategory').value.trim()||null,base_unit:base,units,updated_by:state.user.id,updated_at:new Date().toISOString()};if(state.globalImageCleared&&!file)row.image_storage_path=null;
L3912 |    if(!row.name)throw new Error('اسم الصنف مطلوب.');let pid=id;
L3913 |    if(id){const u=await db.from('count_catalog_products').update(row).eq('id',id);if(u.error)throw u.error;}
L3914 |    else{const x=await db.from('count_catalog_products').insert({...row,is_active:true,source_type:'curated',created_by:state.user.id}).select('id').single();if(x.error)throw x.error;pid=x.data.id;}
L3915 |    let warning='';if(file){const ext=file.type==='image/png'?'png':file.type==='image/webp'?'webp':'jpg',path='catalog/products/'+pid+'/'+Date.now()+'.'+ext,up=await db.storage.from('counting-product-images').upload(path,file,{contentType:file.type,upsert:false});if(up.error)warning=' تعذر رفع الصورة.';else{const u=await db.from('count_catalog_products').update({image_storage_path:path,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',pid);if(u.error)warning=' تعذر ربط الصورة.';}}
L3916 |    closeGlobalProductEditor();state.catalogPage=1;await loadCatalog();notify((id?'تم تحديث بيانات الصنف ووحداته وباركوداته.':'تمت إضافة الصنف إلى الدليل الموحد.')+(barcode?'':' · سيولد النظام معرفاً داخلياً تلقائياً.')+warning,!!warning);
L3917 |   }catch(err){fail('تعذر حفظ الصنف العالمي',err);}finally{setBusy(f,false);}
L3918 |  });
```

### Client-specific item override save logic — inline submit listener, source lines 3926-3931

```javascript
L3926 |  $('clientProductForm').addEventListener('submit',async e=>{
L3927 |   e.preventDefault();const client=state.catalogClientId||(state.platformOwner?null:state.clientId);if(!client)return notify('اختر المؤسسة أولاً.',true);if(!state.canManageClientCatalog)return notify('لا تملك صلاحية إدارة مواءمات المؤسسة.',true);const f=e.currentTarget;setBusy(f,true);
L3928 |   try{const cat=$('clientProductCatalog').value;if(!cat)throw new Error('اختر الصنف العالمي.');let base=null,units=null;if($('clientUnitsOverrideToggle').checked){base=$('clientProductUnit').value.trim();if(!base)throw new Error('أدخل وحدة الأساس للمؤسسة.');const clientBarcode=$('clientProductBarcode').value.trim()||null,itemKind=$('clientItemKind').value,barcodeType=clientBarcode?cfResolveBarcodeType(clientBarcode,$('clientBarcodeType').value):'INTERNAL';if(itemKind==='WEIGHED'&&$('clientUnitClass').value!=='mass')throw new Error('الصنف الوزني للمؤسسة يحتاج فئة وحدة قياس من الوزن.');if(clientBarcode&&itemKind==='BARCODED'&&barcodeType==='INTERNAL')throw new Error('أدخل باركوداً خارجياً صالحاً أو غيّر نوع الصنف.');if(itemKind==='NO_BARCODE'&&clientBarcode&&barcodeType!=='INTERNAL')throw new Error('صنف المؤسسة بدون باركود لا يقبل رمزاً خارجياً.');units=getUnitMetaFields('client',readCatalogUnits('clientProductUnitsEditor',base,clientBarcode),{item_kind:itemKind,barcode_type:barcodeType});}
L3929 |    const p={p_client_id:client,p_catalog_product_id:cat,p_client_sku:$('clientProductSku').value.trim()||null,p_client_barcode:$('clientProductBarcode').value.trim()||null,p_name_override:$('clientProductName').value.trim()||null,p_category_override:$('clientProductCategory').value.trim()||null,p_base_unit_override:base,p_units_override:units,p_image_storage_path_override:$('clientProductImagePath').value.trim()||null};const x=await db.rpc('count_upsert_client_product',p);if(x.error)throw x.error;resetClientProductForm();await loadCatalog();notify('تم حفظ بيانات المؤسسة وربطها بالصنف في الدليل الموحد.');
L3930 |   }catch(err){fail('تعذر حفظ مواءمة المؤسسة',err);}finally{setBusy(f,false);}
L3931 |  });
```

### Project-scoped item save/update logic — inline submit listener, source lines 3958-3987

```javascript
L3958 |  $('productForm').addEventListener('submit',async e=>{e.preventDefault();if(!state.project)return notify('سجّل تكليفاً أولاً',true);const f=e.currentTarget;setBusy(f,true);try{
L3959 |   const id=$('productId').value,sku=$('sku').value.trim()||null,barcode=$('barcode').value.trim()||null,name=$('productName').value.trim()||null,baseUnit=$('baseUnit').value.trim(),itemKind=$('unitItemKind').value,requestedBarcodeType=$('unitBarcodeType').value;
L3960 |   if(!baseUnit)throw new Error('وحدة القياس الأساسية مطلوبة قبل إتاحة الصنف للعد.');
L3961 |   if(itemKind==='BARCODED'&&!barcode)throw new Error('الصنف الذي يحمل باركوداً يحتاج رمزاً خارجياً؛ اختر بدون باركود لتوليد معرف داخلي.');
L3962 |   if(itemKind==='WEIGHED'&&$('unitClass').value!=='mass')throw new Error('الصنف الوزني يحتاج فئة وحدة قياس من الوزن.');
L3963 |   const barcodeType=barcode?cfResolveBarcodeType(barcode,requestedBarcodeType):'INTERNAL';
L3964 |   if(itemKind==='NO_BARCODE'&&barcode&&barcodeType!=='INTERNAL')throw new Error('الصنف بدون باركود لا يقبل رمزاً خارجياً.');
L3965 |   const units=getUnitMetaFields('unit',readProductUnits(baseUnit,barcode),{item_kind:itemKind,barcode_type:barcodeType}),file=$('productImageFile').files[0]||null;
L3966 |   let imageRef=file?null:($('imageUrl').value.trim()|| (state.productImageCleared?null:state.editingProductImageRef||null));
L3967 |   const externalImageInput=$('imageUrl').value.trim();
L3968 |   if(externalImageInput&&!file){
L3969 |    const externalImageUrl=safeExternalProductImageUrl(externalImageInput);
L3970 |    if(!externalImageUrl)throw new Error('رابط الصورة الخارجية غير صالح أو مؤقت؛ استخدم HTTPS دائماً أو ارفع الصورة إلى مساحة CountFlow الخاصة.');
L3971 |    imageRef=externalImageUrl;
L3972 |   }
L3973 | 
L3974 |   const projectId=state.project.id;
L3975 |   if(file)imageRef=await uploadProductImage(file,projectId);
L3976 |   const row={project_id:projectId,sku,barcode,name,category:$('category').value.trim()||null,base_unit:baseUnit,units,expected_qty:$('expectedQty').value===''?null:Number($('expectedQty').value),image_url:imageRef,updated_at:new Date().toISOString()};
L3977 |   const result=id?await db.from('count_products').update(row).eq('id',id).eq('project_id',projectId):await db.from('count_products').insert({...row,is_active:true});
L3978 |   if(result.error)throw result.error;
L3979 |   state.editingProductImageRef=imageRef;state.productImageCleared=false;
L3980 |   notify(id?'تم تحديث الصنف ووحداته وصورته.':'تمت إضافة الصنف ووحداته وصورته.');resetProductForm();await loadProjectData();
L3981 |  }catch(err){fail('تعذر حفظ الصنف',err);}finally{setBusy(f,false);}});
L3982 |  $('productCancel').onclick=resetProductForm;$('addProjectProduct').onclick=()=>{if(!state.project)return notify('اختر ملف تكليف أولاً.',true);resetProductForm();$('projectProductEditorPanel').classList.remove('hidden');$('projectProductWorkspace').classList.add('cf-catalog-editor-open');$('sku').focus();$('projectProductEditorPanel').scrollIntoView({behavior:'smooth',block:'start'});};$('projectProductEditorClose').onclick=resetProductForm;$('projectCatalogExport').onclick=exportProjectCatalogCsv;
L3983 |  $('addProductUnit').addEventListener('click',()=>{
L3984 |   const container=$('productUnitsEditor'),row=document.createElement('div');row.className='product-unit-row';row.dataset.productUnitRow='';
L3985 |   row.innerHTML='<div class="field"><label>اسم الوحدة البديلة</label><input data-unit-name maxlength="40" placeholder="مثال: كرتونة"></div><div class="field"><label>كم تعادل من الوحدة الأساسية؟</label><input data-unit-factor type="number" min="0.000001" step="0.000001" placeholder="مثال: 12"></div><div class="field"><label>باركود الوحدة (اختياري)</label><input data-unit-barcode maxlength="120"></div><div class="field"><label>نوع الرمز</label><select data-unit-barcode-type><option value="AUTO">تلقائي</option><option value="EAN8">EAN-8</option><option value="UPC_A">UPC-A</option><option value="EAN13">EAN-13</option><option value="GTIN14">GTIN-14</option><option value="CODE128">Code 128</option></select></div><button type="button" class="danger" data-remove-product-unit>إزالة</button>';
L3986 |   container.appendChild(row);row.querySelector('[data-remove-product-unit]').onclick=()=>{row.remove();if(!container.querySelector('[data-product-unit-row]'))renderProductUnitEditor([]);};row.querySelector('[data-unit-name]').focus();
L3987 |  });
```

### Requested names with no direct implementation in the file

- `openItemPage()` / `_openItemEditor()` — NOT FOUND by these names; equivalents: `openGlobalProductEditor()` and `openUnifiedCatalogItem()`.
- `saveItem()` / `_handleSaveFromPage()` — NOT FOUND by these names; save logic is in the inline submit listeners above.
- `_handleDeleteFromPage()` — NOT FOUND; the catalog exposes status toggle functions rather than a hard-delete action.
- `_switchItemTab()` — NOT FOUND by this name; equivalent: `switchGlobalProductTab()`.
- `_loadCategoriesIntoSelect()` and `_openCategoryModal()` / `_addCategory()` / `_editCategory()` / `_deleteCategory()` — NOT FOUND; category choice/custom-entry logic is in the extracted picker functions.
- `generateInternalBarcode()` — NOT FOUND by this name; equivalent: `cfGenerateInternalBarcode()`.

## 8. Database Calls (Items Only)

The code calls Supabase through the `db` client alias. These are all fixed-table item/catalog and item-import call sites, grouped by table or RPC. Original call expressions, selected columns, update/insert keys, filters and RPC argument objects are retained. A generic helper that accepts a dynamic table name is shown separately; it has no item-specific call site in this file.

### Table count_sessions

```javascript
L0884 |     db.from('count_sessions').select('id,project_id,name,status,started_at,closed_at,created_at,updated_at,sync_barrier_version,queue_barrier_action,queue_barrier_run_id,queue_barrier_requested_at').eq('project_id',pid).order('created_at',{ascending:false}).limit(200)
```

### Table count_products

```javascript
L0914 |    let request=db.from('count_products').select('*',{count:'exact'}).eq('project_id',pid);
L2685 |    db.from('count_products').select('id',{count:'exact',head:true}).eq('project_id',s.project_id).eq('is_active',true),
L2885 |     db.from('count_products').select('id',{count:'exact',head:true}).eq('project_id',p.id).eq('is_active',true),
L3371 |   const {error}=await db.from('count_products').update({is_active:!p.is_active,updated_at:new Date().toISOString()}).eq('id',id).eq('project_id',state.project.id);
L3830 |    const result=await db.from('count_products').select('sku,barcode,name,category,base_unit,units,expected_qty,image_url,is_active').eq('project_id',project.id).order('name',{ascending:true}).order('id',{ascending:true}).range(offset,offset+pageSize-1);
L3977 |   const result=id?await db.from('count_products').update(row).eq('id',id).eq('project_id',projectId):await db.from('count_products').insert({...row,is_active:true});
```

### RPC count_upsert_catalog_products_chunk

```javascript
L1545 |   const {data,error}=await db.rpc('count_upsert_catalog_products_chunk',{p_rows:rows});
```

### RPC count_upsert_client_catalog_chunk

```javascript
L1735 |  const {data,error}=await db.rpc('count_upsert_client_catalog_chunk',{p_client_id:clientId,p_rows:rows});
```

### Table count_import_mappings

```javascript
L1864 |   const {data:saved,error}=await db.from('count_import_mappings').select('id,name,column_mapping,is_default').eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat).eq('is_default',true).order('created_at',{ascending:false}).limit(1).maybeSingle();
L1882 |     const {error}=await db.from('count_import_mappings').update({is_default:false}).eq('project_id',state.project.id).eq('source_format',state.productImportSourceFormat);
L1885 |    const {data,error}=await db.from('count_import_mappings').upsert({project_id:state.project.id,name,source_format:state.productImportSourceFormat,column_mapping:mapping,is_default:makeDefault,created_by:state.user.id},{onConflict:'project_id,name'}).select('id').single();
```

### RPC count_commit_import_batch

```javascript
L1933 |    const {data,error}=await db.rpc('count_commit_import_batch',{p_batch_id:batchId});
```

### RPC count_create_import_batch

```javascript
L1985 |    const {data:batchId,error:createError}=await db.rpc('count_create_import_batch',{p_project_id:projectId,p_session_id:sessionId,p_source_name:file.name,p_source_format:state.productImportSourceFormat,p_source_checksum:checksum});
```

### Table count_import_batches

```javascript
L1987 |    const {error:mappingError}=await db.from('count_import_batches').update({mapping_id:state.productImportMappingId,metadata:{column_mapping:state.productImportMapping,headers:state.productImportHeaders,import_surface:'countflow-admin',checksum_algorithm:'sha256-chain-v1'}}).eq('id',batchId).eq('project_id',projectId);
L2043 |   const {data,error}=await db.from('count_import_batches').select('id,source_name,source_format,row_count,accepted_count,rejected_count,status,error_report,created_at,session_id,metadata').eq('project_id',state.project.id).order('created_at',{ascending:false}).limit(20);
```

L2696 |   const {data,error}=await db.from('count_import_batches').select('id,source_name,source_format,row_count,accepted_count,rejected_count,status,created_at,metadata').eq('session_id',s.id).order('created_at',{ascending:false}).limit(30);
### RPC count_stage_import_rows

```javascript
L1992 |     const {data:staged,error}=await db.rpc('count_stage_import_rows',{p_batch_id:batchId,p_rows:chunk,p_row_offset:offset});
```

### Table count_import_rows

```javascript
L2090 |   let query=db.from('count_import_rows').select('row_number,sku,barcode,product_name,'+key,{count:'exact'})
L2107 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,error_codes',{count:'exact'}).eq('batch_id',batchId).eq('row_status','rejected').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1),
L2108 |    db.from('count_import_rows').select('row_number,sku,barcode,product_name,warning_codes',{count:'exact'}).eq('batch_id',batchId).not('warning_codes','eq','{}').order('row_number').range(0,IMPORT_DETAIL_PAGE_SIZE-1)
```

### Table count_catalog_products

```javascript
L3043 |    db.from('count_catalog_products').select('id').ilike('barcode',candidate).limit(1),
L3044 |    db.from('count_catalog_products').select('id').contains('units',[{barcode:candidate}]).limit(1),
L3212 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('barcode',term).limit(5),
L3213 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('canonical_sku',term).limit(5),
L3214 |    db.from('count_catalog_products').select(projection).eq('is_active',true).contains('units',[{barcode:term}]).limit(5),
L3215 |    db.from('count_catalog_products').select(projection).eq('is_active',true).ilike('name','%'+term.replace(/[%_,]/g,' ').slice(0,80)+'%').order('name',{ascending:true}).limit(8)
L3806 |    let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path').order(f.sort,{ascending:f.ascending}).order('id',{ascending:true});
L3846 |   let q=db.from('count_catalog_products').select('id,canonical_sku,barcode,name,brand,category,base_unit,units,is_active,image_storage_path',{count:'exact'}).order(sort,{ascending:state.catalogSortAsc}).order('id',{ascending:true});
L3882 |   const {error}=await db.from('count_catalog_products').update({is_active:!p.is_active,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',id);
L3913 |    if(id){const u=await db.from('count_catalog_products').update(row).eq('id',id);if(u.error)throw u.error;}
L3914 |    else{const x=await db.from('count_catalog_products').insert({...row,is_active:true,source_type:'curated',created_by:state.user.id}).select('id').single();if(x.error)throw x.error;pid=x.data.id;}
L3915 |    let warning='';if(file){const ext=file.type==='image/png'?'png':file.type==='image/webp'?'webp':'jpg',path='catalog/products/'+pid+'/'+Date.now()+'.'+ext,up=await db.storage.from('counting-product-images').upload(path,file,{contentType:file.type,upsert:false});if(up.error)warning=' تعذر رفع الصورة.';else{const u=await db.from('count_catalog_products').update({image_storage_path:path,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',pid);if(u.error)warning=' تعذر ربط الصورة.';}}
```

### Table count_catalog_product_identifiers

```javascript
L3045 |    db.from('count_catalog_product_identifiers').select('id').or('normalized_value.eq.'+candidate+',identifier_value.eq.'+candidate).limit(1)
```

### RPC count_attach_catalog_product

```javascript
L3183 |   const {data,error}=await db.rpc('count_attach_catalog_product',{
```

### Table count_client_products

```javascript
L3787 |    const result=await db.from('count_client_products').select('catalog_product_id').eq('client_id',clientId)
L3811 |     const local=await db.from('count_client_products').select('catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',clientId).in('catalog_product_id',page.map(p=>p.id));
L3854 |    const local=await db.from('count_client_products').select('id,client_id,catalog_product_id,client_sku,client_barcode,name_override,category_override,base_unit_override,units_override,image_storage_path_override,is_active').eq('client_id',scopedClient).in('catalog_product_id',productIds);
```

### RPC count_has_client_permission

```javascript
L3312 |  return db.rpc('count_has_client_permission',{p_client_id:id,p_permission_code:'catalog.manage'}).then(({data,error})=>apply(!error&&data===true));
```

### RPC count_upsert_client_product

```javascript
L3929 |    const p={p_client_id:client,p_catalog_product_id:cat,p_client_sku:$('clientProductSku').value.trim()||null,p_client_barcode:$('clientProductBarcode').value.trim()||null,p_name_override:$('clientProductName').value.trim()||null,p_category_override:$('clientProductCategory').value.trim()||null,p_base_unit_override:base,p_units_override:units,p_image_storage_path_override:$('clientProductImagePath').value.trim()||null};const x=await db.rpc('count_upsert_client_product',p);if(x.error)throw x.error;resetClientProductForm();await loadCatalog();notify('تم حفظ بيانات المؤسسة وربطها بالصنف في الدليل الموحد.');
```

### Storage bucket `counting-product-images`

```javascript
L0947 |   const {data,error}=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L3353 |   const {error}=await db.storage.from('counting-product-images').upload(path,file,{cacheControl:'3600',contentType:file.type,upsert:false});
L3720 |   const result=await db.storage.from('counting-product-images').createSignedUrls(paths,3600);
L3752 |   const result=await db.storage.from('counting-product-images').createSignedUrl(path,3600);
L3915 |    let warning='';if(file){const ext=file.type==='image/png'?'png':file.type==='image/webp'?'webp':'jpg',path='catalog/products/'+pid+'/'+Date.now()+'.'+ext,up=await db.storage.from('counting-product-images').upload(path,file,{contentType:file.type,upsert:false});if(up.error)warning=' تعذر رفع الصورة.';else{const u=await db.from('count_catalog_products').update({image_storage_path:path,updated_by:state.user.id,updated_at:new Date().toISOString()}).eq('id',pid);if(u.error)warning=' تعذر ربط الصورة.';}}
```

### Generic `loadProjectRows(table,...)` helper — dynamic table parameter; no item-specific invocation exists in this file

```javascript
L0907 |  function loadProjectRows(table,columns,projectId,orderColumn,pageSize=500){
L0908 |   return (async()=>{const all=[];let offset=0;while(true){const {data,error}=await db.from(table).select(columns).eq('project_id',projectId).order(orderColumn,{ascending:true}).range(offset,offset+pageSize-1);if(error)throw error;const page=data||[];all.push(...page);if(all.length>200000)throw new Error('تجاوز عدد سجلات '+table+' الحد التشغيلي الآمن 200,000 صف.');if(page.length<pageSize)break;offset+=pageSize;}return all;})();
L0909 |  }
```

### Not an Items-tab call site

The same generic import-batch RPCs are also used in the operation-import workflow elsewhere in the file; those non-item call sites are intentionally not mixed into the Items-only list.

## 9. Data Structures

### Shared Admin state initializer

```javascript
L0784 | const state={user:null,platformOwner:false,clientId:null,clientRole:null,clients:[],clientDirectoryRows:[],clientDirectoryManagers:[],clientDirectoryPage:1,clientDirectoryPageSize:25,clientDirectoryTotal:0,clientSort:'created_at',clientSortAsc:false,clientSearchTimer:null,roles:[],permissions:[],roleMap:new Map(),rolePermissions:new Map(),catalogProducts:[],catalogPage:1,catalogTotal:0,catalogSort:'name',catalogSortAsc:true,catalogImageUrls:new Map(),catalogImageToken:0,catalogRequestToken:0,catalogEditorImageToken:0,catalogSearchTimer:null,globalImagePreviewObjectUrl:null,globalImageCleared:false,catalogClientId:null,catalogOptionProducts:[],catalogClientRows:[],catalogView:'global',canManageClientCatalog:false,overviewRows:[],overviewLoadedAt:null,overviewRequestToken:0,overviewError:null,overviewRealtimeStatus:'CONNECTING',platformKpis:{},teamRows:[],teamRosterRows:[],teamSelectedId:null,project:null,projects:[],products:[],members:[],locations:[],sessions:[],allMembers:[],allSessions:[],assignmentCounts:{},productImageUrls:new Map(),productImageToken:0,editingProductImageRef:null,productImageCleared:false,productImagePreviewObjectUrl:null,passwordResetMemberId:null,selectedSession:null,workflowSessionId:null,workflowData:null,operationImportRows:[],operationImportRowCount:0,operationImportFormat:'csv',globalCatalogImport:{file:null,count:0,headers:[],sample:[],mapping:{},busy:false,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}},clientCatalogImport:{file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}},productImportChecksum:'',productImportRows:[],productImportRowCount:0,productImportHeaders:[],productImportMapping:{},productImportMappingId:null,productImportSourceFormat:'csv',productImportFileName:'',productPage:1,productTotal:0,productQuery:'',productScrollTop:0,operationSort:'created_at',operationSortAsc:false,operationPage:1,globalChannel:null,globalRefreshTimer:null,globalPollTimer:null,busy:false};
```

### Image and import constants

```javascript
L0785 |  const IMPORT_DETAIL_PAGE_SIZE=500,MAX_PRODUCT_IMAGE_BYTES=1024*1024;let importDetailBatchId=null,importDetailTargetId='productImportDetails',importDetailOffsets={errors:0,warnings:0},importDetailTotals={errors:0,warnings:0};
```

### Project item import field schema

```javascript
L1192 | const productImportFields=[
L1193 |   {key:'sku',label:'كود الصنف SKU',aliases:['sku','code','item_code','product_code','كود الصنف','كود','رمز الصنف']},
L1194 |   {key:'barcode',label:'الباركود',aliases:['barcode','bar_code','ean','upc','باركود','الباركود']},
L1195 |   {key:'name',label:'اسم الصنف',aliases:['name','item_name','product_name','اسم الصنف','الصنف','الاسم']},
L1196 |   {key:'category',label:'الفئة / التصنيف',aliases:['category','group','الفئة','التصنيف']},
L1197 |   {key:'base_unit',label:'الوحدة الأساسية (مطلوبة للصنف الجديد)',aliases:['base_unit','unit','uom','الوحدة','وحدة القياس']},
L1198 |   {key:'units',label:'الوحدات والتحويلات',aliases:['units','unit_options','الوحدات']},
L1199 |   {key:'unit_class',label:'فئة وحدة القياس',aliases:['unit_class','measurement_class','فئة الوحدة','نوع القياس']},
L1200 |   {key:'decimal_precision',label:'دقة الكمية',aliases:['decimal_precision','quantity_precision','دقة الكمية','المنازل العشرية']},
L1201 |   {key:'expected_qty',label:'الكمية الدفترية المرجعية (تتطلب جلسة)',aliases:['expected_qty','expected_quantity','book_qty','الكمية الدفترية','الرصيد الدفتري']},
L1202 |   {key:'location_code',label:'كود الموقع (يتطلب جلسة)',aliases:['location_code','location','bin','shelf','الموقع','كود الموقع']},
L1203 |   {key:'image_url',label:'رابط الصورة HTTPS',aliases:['image_url','image','photo','رابط الصورة']},
L1204 |   {key:'purchase_unit_cost',label:'سعر شراء الوحدة (اختياري)',aliases:['purchase_unit_cost','purchase_price','unit_cost','price','سعر الشراء','سعر الشراء للوحدة']},
L1205 |   {key:'currency_code',label:'العملة',aliases:['currency_code','currency','العملة','عملة السعر']},
L1206 |   {key:'purchase_unit',label:'وحدة الشراء',aliases:['purchase_unit','purchase_uom','unit_of_purchase','وحدة الشراء','وحدة سعر الشراء']},
L1207 |   {key:'unit_factor_to_base',label:'معامل التحويل للوحدة الأساسية',aliases:['unit_factor_to_base','purchase_unit_factor_to_base','conversion_factor_to_base','معامل التحويل للوحدة الأساسية']},
L1208 |   {key:'cost_source_type',label:'نوع مصدر السعر',aliases:['cost_source_type','price_source','source_type','مصدر السعر']},
L1209 |   {key:'cost_source_reference',label:'مرجع مصدر السعر',aliases:['cost_source_reference','invoice_reference','price_reference','مرجع السعر']},
L1210 |   {key:'cost_source_date',label:'تاريخ السعر',aliases:['cost_source_date','price_date','تاريخ السعر']}
L1211 |  ];
```

### Global catalog import field schema

```javascript
L1389 | const globalCatalogImportFields=[
L1390 |   {key:'sku',label:'SKU / كود الصنف',aliases:['sku','code','item_code','product_code','canonical_sku','كود الصنف','كود','رمز الصنف']},
L1391 |   {key:'barcode',label:'الباركود الأساسي',aliases:['barcode','bar_code','ean','upc','gtin','باركود','الباركود']},
L1392 |   {key:'name',label:'اسم الصنف (مطلوب)',aliases:['name','item_name','product_name','اسم الصنف','الصنف','الاسم']},
L1393 |   {key:'brand',label:'العلامة التجارية',aliases:['brand','manufacturer','العلامة التجارية','الماركة']},
L1394 |   {key:'category',label:'التصنيف',aliases:['category','group','الفئة','التصنيف']},
L1395 |   {key:'base_unit',label:'وحدة الأساس (مطلوبة)',aliases:['base_unit','unit','uom','الواحدة','الوحدة','وحدة القياس']},
L1396 |   {key:'units',label:'الوحدات البديلة ومعاملاتها',aliases:['units','unit_options','الوحدات','وحدات التعبئة']},
L1397 |   {key:'unit_class',label:'نمط القياس',aliases:['unit_class','measurement_class','فئة الوحدة','نوع القياس']},
L1398 |   {key:'decimal_precision',label:'دقة الكمية',aliases:['decimal_precision','quantity_precision','دقة الكمية','المنازل العشرية']},
L1399 |   {key:'item_kind',label:'نوع الصنف',aliases:['item_kind','product_kind','نوع الصنف']},
L1400 |   {key:'barcode_type',label:'نوع الباركود',aliases:['barcode_type','symbology','نوع الباركود']}
L1401 |  ];
```

### Client catalog import field schema

```javascript
L1638 | const clientCatalogImportFields=[
L1639 |  {key:'sku',label:'SKU / الكود العالمي',aliases:['sku','code','item_code','product_code','canonical_sku','كود الصنف','كود','رمز الصنف']},
L1640 |  {key:'barcode',label:'الباركود العالمي الأساسي',aliases:['barcode','bar_code','ean','upc','gtin','باركود','الباركود']},
L1641 |  {key:'name',label:'اسم الصنف (مطلوب)',aliases:['name','item_name','product_name','اسم الصنف','الصنف','الاسم']},
L1642 |  {key:'brand',label:'العلامة التجارية',aliases:['brand','manufacturer','العلامة التجارية','الماركة']},
L1643 |  {key:'category',label:'التصنيف الأساسي',aliases:['category','group','الفئة','التصنيف']},
L1644 |  {key:'base_unit',label:'وحدة الأساس (مطلوبة لإنشاء صنف جديد)',aliases:['base_unit','unit','uom','الواحدة','الوحدة','وحدة القياس']},
L1645 |  {key:'units',label:'الوحدات البديلة ومعاملاتها',aliases:['units','unit_options','الوحدات','وحدات التعبئة']},
L1646 |  {key:'unit_class',label:'نمط القياس',aliases:['unit_class','measurement_class','فئة الوحدة','نمط القياس','نوع القياس']},
L1647 |  {key:'decimal_precision',label:'دقة الكمية',aliases:['decimal_precision','quantity_precision','دقة الكمية','المنازل العشرية']},
L1648 |  {key:'item_kind',label:'نوع الصنف',aliases:['item_kind','product_kind','نوع الصنف']},
L1649 |  {key:'barcode_type',label:'نوع الباركود العالمي',aliases:['barcode_type','symbology','نوع الباركود']},
L1650 |  {key:'client_sku',label:'SKU المؤسسة (اختياري)',aliases:['client_sku','tenant_sku','organization_sku','كود المؤسسة','sku المؤسسة']},
L1651 |  {key:'client_barcode',label:'باركود المؤسسة (اختياري)',aliases:['client_barcode','tenant_barcode','organization_barcode','باركود المؤسسة']},
L1652 |  {key:'client_name_override',label:'اسم المؤسسة (اختياري)',aliases:['client_name','client_name_override','tenant_name','اسم المؤسسة']},
L1653 |  {key:'client_category_override',label:'تصنيف المؤسسة (اختياري)',aliases:['client_category','client_category_override','tenant_category','تصنيف المؤسسة']},
L1654 |  {key:'client_base_unit_override',label:'وحدة الأساس للمؤسسة (اختياري)',aliases:['client_base_unit','client_base_unit_override','tenant_base_unit','وحدة المؤسسة']},
L1655 |  {key:'client_units_override',label:'وحدات المؤسسة ومعاملاتها (JSON اختياري)',aliases:['client_units','client_units_override','tenant_units','وحدات المؤسسة']}
L1656 | ];
```

### Unit measurement classes and aliases

```javascript
L2911 | const CF_UNIT_CLASSES=[
L2912 |  {value:'count',label:'عدد / قطعة',precision:0,aliases:['each','ea','pc','pcs','piece','pieces','unit','units','dozen','dz','box','boxes','carton','cartons','case','cases','pack','packet','عدد','قطعة','وحدة','حبة','علبة','كرتونة','كرتون','عبوة','باكيت','دستة']},
L2913 |  {value:'mass',label:'وزن / كتلة',precision:3,aliases:['kg','kgs','kilogram','kilograms','g','gm','gram','grams','mg','milligram','milligrams','oz','ounce','ounces','ton','tons','tonne','tonnes','lb','lbs','pound','pounds','كجم','كيلوجرام','كيلوغرام','كيلو جرام','كيلو','جم','جرام','غرام','مجم','ملجم','مليجرام','طن','أطنان','رطل']},
L2914 |  {value:'volume',label:'حجم / سعة',precision:3,aliases:['l','lt','liter','litre','liters','litres','ml','milliliter','millilitre','m3','cm3','لتر','مل','مليلتر','ملي لتر','متر مكعب','سم مكعب']},
L2915 |  {value:'length',label:'طول',precision:3,aliases:['m','meter','metre','meters','metres','cm','centimeter','centimetre','mm','millimeter','millimetre','km','inch','in','inches','ft','foot','feet','كيلومتر','متر','سم','سنتيمتر','مم','ملليمتر']},
L2916 |  {value:'area',label:'مساحة',precision:3,aliases:['m2','sqm','cm2','sqft','ft2','square meter','square metre','متر مربع','سم مربع','متر²','سم²']},
L2917 |  {value:'other',label:'وحدة خاصة / تعبئة',precision:3,aliases:[]}
L2918 | ];
```

### Unit metadata discriminator

```javascript
L2919 | const CF_UNIT_META_FLAG='__countflow_unit_meta';
```

### Base-unit suggestions by measurement class

```javascript
L2959 | const CF_BASE_UNIT_SUGGESTIONS={
L2960 |  count:['قطعة','حبة','عدد','وحدة','علبة','كرتونة','كرتون','عبوة','باكيت','دستة','each','ea','piece','pc','pcs','unit','dozen','dz'],
L2961 |  mass:['كجم','جرام','جم','ملجم','طن','kilogram','kg','gram','g','mg','oz','ounce','lb','رطل'],
L2962 |  volume:['لتر','مليلتر','ملليلتر','متر مكعب','liter','litre','l','ml'],
L2963 |  length:['متر','سم','مم','كيلومتر','بوصة','قدم','meter','metre','m','cm','mm','km','inch','in','ft'],
L2964 |  area:['متر مربع','سم مربع','m2','sqm','sqft','ft2'],
L2965 |  other:['وحدة','عبوة']
L2966 | };
```

### Product category suggestions

```javascript
L2967 | const CF_PRODUCT_CATEGORY_SUGGESTIONS=[
L2968 |  'مواد غذائية','أغذية جافة','مشروبات','ألبان وأجبان','مخبوزات','لحوم ودواجن',
L2969 |  'أسماك ومأكولات بحرية','خضروات وفاكهة','مجمدات','حلويات وتسالي','منظفات',
L2970 |  'عناية شخصية','ورقيات ومناديل','مستلزمات منزلية','أدوات ومعدات',
L2971 |  'ملابس ومنسوجات','إلكترونيات','قطع غيار','مواد خام','مواد تعبئة وتغليف','مستلزمات تشغيل'
L2972 | ];
```

### Item-related fields inside Admin state object (full original initializer line)

```javascript
L0784 |  const state={user:null,platformOwner:false,clientId:null,clientRole:null,clients:[],clientDirectoryRows:[],clientDirectoryManagers:[],clientDirectoryPage:1,clientDirectoryPageSize:25,clientDirectoryTotal:0,clientSort:'created_at',clientSortAsc:false,clientSearchTimer:null,roles:[],permissions:[],roleMap:new Map(),rolePermissions:new Map(),catalogProducts:[],catalogPage:1,catalogTotal:0,catalogSort:'name',catalogSortAsc:true,catalogImageUrls:new Map(),catalogImageToken:0,catalogRequestToken:0,catalogEditorImageToken:0,catalogSearchTimer:null,globalImagePreviewObjectUrl:null,globalImageCleared:false,catalogClientId:null,catalogOptionProducts:[],catalogClientRows:[],catalogView:'global',canManageClientCatalog:false,overviewRows:[],overviewLoadedAt:null,overviewRequestToken:0,overviewError:null,overviewRealtimeStatus:'CONNECTING',platformKpis:{},teamRows:[],teamRosterRows:[],teamSelectedId:null,project:null,projects:[],products:[],members:[],locations:[],sessions:[],allMembers:[],allSessions:[],assignmentCounts:{},productImageUrls:new Map(),productImageToken:0,editingProductImageRef:null,productImageCleared:false,productImagePreviewObjectUrl:null,passwordResetMemberId:null,selectedSession:null,workflowSessionId:null,workflowData:null,operationImportRows:[],operationImportRowCount:0,operationImportFormat:'csv',globalCatalogImport:{file:null,count:0,headers:[],sample:[],mapping:{},busy:false,stats:{processed:0,inserted:0,updated:0,duplicates:0,rejected:0,errors:[]}},clientCatalogImport:{file:null,count:0,headers:[],sample:[],mapping:{},busy:false,checksum:'',sourceFormat:'',stats:{processed:0,catalogInserted:0,catalogMatched:0,clientInserted:0,clientUpdated:0,duplicates:0,rejected:0,errors:[]}},productImportChecksum:'',productImportRows:[],productImportRowCount:0,productImportHeaders:[],productImportMapping:{},productImportMappingId:null,productImportSourceFormat:'csv',productImportFileName:'',productPage:1,productTotal:0,productQuery:'',productScrollTop:0,operationSort:'created_at',operationSortAsc:false,operationPage:1,globalChannel:null,globalRefreshTimer:null,globalPollTimer:null,busy:false};
```

### Global catalog item row object

```javascript
L3911 |    const row={canonical_sku:sku,barcode:barcode||null,name:$('globalName').value.trim(),brand:$('globalBrand').value.trim()||null,category:$('globalCategory').value.trim()||null,base_unit:base,units,updated_by:state.user.id,updated_at:new Date().toISOString()};if(state.globalImageCleared&&!file)row.image_storage_path=null;
```

### Client-specific catalog upsert payload

```javascript
L3929 |    const p={p_client_id:client,p_catalog_product_id:cat,p_client_sku:$('clientProductSku').value.trim()||null,p_client_barcode:$('clientProductBarcode').value.trim()||null,p_name_override:$('clientProductName').value.trim()||null,p_category_override:$('clientProductCategory').value.trim()||null,p_base_unit_override:base,p_units_override:units,p_image_storage_path_override:$('clientProductImagePath').value.trim()||null};const x=await db.rpc('count_upsert_client_product',p);if(x.error)throw x.error;resetClientProductForm();await loadCatalog();notify('تم حفظ بيانات المؤسسة وربطها بالصنف في الدليل الموحد.');
```

### Project-scoped product row object

```javascript
L3976 |   const row={project_id:projectId,sku,barcode,name,category:$('category').value.trim()||null,base_unit:baseUnit,units,expected_qty:$('expectedQty').value===''?null:Number($('expectedQty').value),image_url:imageRef,updated_at:new Date().toISOString()};
```

### Inline item save logic object shapes

The full handlers above are repeated here only where they define the item payload, to keep the source object shapes discoverable without replacing them with a paraphrase.

## 10. Observations

- **Different persistence model than the requested names imply:** the source contains no `count_products_master` or `count_product_units` references. Project items use `count_products`; the unified catalog uses `count_catalog_products`, with alternate units stored in its `units` field rather than a separately referenced `count_product_units` table.
- **The requested standalone CRUD/category functions are absent:** there is no `saveItem()`, `_handleSaveFromPage()`, `_handleDeleteFromPage()`, `_switchItemTab()`, `_loadCategoriesIntoSelect()`, or category-modal CRUD implementation. The actual save paths are three inline form-submit listeners; category selection is implemented through catalog picker/custom-value functions.
- **Barcode function naming differs:** `generateInternalBarcode()` is absent; the actual helper is `cfGenerateInternalBarcode()`. Global catalog barcode generation additionally uses `generateUniqueGlobalRestrictedBarcode()` and checks catalog identifiers before returning a value.
- **The database client is aliased:** item-related database calls use `db.from()`, `db.rpc()`, and `db.storage.from()`; there are no literal `supabase.from()` / `supabase.rpc()` call expressions in the extracted item paths. Import history also reads `count_import_batches` by session at source line 2696, in addition to the project-level history query.
