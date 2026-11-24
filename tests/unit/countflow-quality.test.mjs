import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import vm from "node:vm";
import { deflateRawSync } from "node:zlib";
import { fileURLToPath } from "node:url";
import path from "node:path";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../..");
const read = (p) => fs.readFileSync(path.join(root, p), "utf8");

function inlineScripts(html) {
  const scripts = [];
  let cursor = 0;
  const lower = html.toLowerCase();
  while (cursor < html.length) {
    const start = lower.indexOf("<script", cursor);
    if (start < 0) break;
    const openEnd = html.indexOf(">", start);
    if (openEnd < 0) break;
    const closeStart = lower.indexOf("</script>", openEnd + 1);
    if (closeStart < 0) break;
    const source = html.slice(openEnd + 1, closeStart);
    if (source.trim()) scripts.push(source);
    cursor = closeStart + 9;
  }
  return scripts;
}

function crc32(bytes) {
  let crc = 0xffffffff;
  for (const byte of bytes) {
    crc ^= byte;
    for (let bit = 0; bit < 8; bit++) {
      crc = (crc & 1) ? (0xedb88320 ^ (crc >>> 1)) : (crc >>> 1);
    }
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function zipArchive(entries, corruptEntry = null) {
  const localParts = [];
  const directoryParts = [];
  let localOffset = 0;
  for (const [name, content] of entries) {
    const fileName = Buffer.from(name, "utf8");
    const data = Buffer.from(content, "utf8");
    const compressed = deflateRawSync(data, { level: 6 });
    const checksum = (crc32(data) ^ (name === corruptEntry ? 1 : 0)) >>> 0;
    const local = Buffer.alloc(30);
    local.writeUInt32LE(0x04034b50, 0);
    local.writeUInt16LE(20, 4);
    local.writeUInt16LE(0, 6);
    local.writeUInt16LE(8, 8);
    local.writeUInt32LE(checksum, 14);
    local.writeUInt32LE(compressed.length, 18);
    local.writeUInt32LE(data.length, 22);
    local.writeUInt16LE(fileName.length, 26);
    local.writeUInt16LE(0, 28);
    localParts.push(local, fileName, compressed);

    const central = Buffer.alloc(46);
    central.writeUInt32LE(0x02014b50, 0);
    central.writeUInt16LE(20, 4);
    central.writeUInt16LE(20, 6);
    central.writeUInt16LE(0, 8);
    central.writeUInt16LE(8, 10);
    central.writeUInt32LE(checksum, 16);
    central.writeUInt32LE(compressed.length, 20);
    central.writeUInt32LE(data.length, 24);
    central.writeUInt16LE(fileName.length, 28);
    central.writeUInt16LE(0, 30);
    central.writeUInt16LE(0, 32);
    central.writeUInt16LE(0, 34);
    central.writeUInt32LE(0, 38);
    central.writeUInt32LE(localOffset, 42);
    directoryParts.push(central, fileName);
    localOffset += local.length + fileName.length + compressed.length;
  }
  const directory = Buffer.concat(directoryParts);
  const eocd = Buffer.alloc(22);
  eocd.writeUInt32LE(0x06054b50, 0);
  eocd.writeUInt16LE(entries.length, 8);
  eocd.writeUInt16LE(entries.length, 10);
  eocd.writeUInt32LE(directory.length, 12);
  eocd.writeUInt32LE(localOffset, 16);
  return Buffer.concat([...localParts, directory, eocd]);
}

function makeXlsx(rowCount, { corruptSheetCrc = false, traversalEntry = false } = {}) {
  const shared = ["SKU", "Name", "Category", "Price", "Count Date", "General"];
  const sharedXml = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="6" uniqueCount="6">' +
    shared.map((v) => '<si><t>' + v + '</t></si>').join("") + '</sst>';
  const workbook = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" ' +
    'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">' +
    '<workbookPr date1904="0"/><sheets><sheet name="Products" sheetId="1" r:id="rId1"/></sheets></workbook>';
  const rels = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' +
    '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>' +
    '</Relationships>';
  const styles = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">' +
    '<numFmts count="1"><numFmt numFmtId="164" formatCode="yyyy-mm-dd"/></numFmts>' +
    '<cellXfs count="2"><xf numFmtId="0"/><xf numFmtId="164"/></cellXfs></styleSheet>';
  let sheet = '<?xml version="1.0" encoding="UTF-8"?>' +
    '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>' +
    '<row r="1">' +
    '<c r="A1" t="s"><v>0</v></c><c r="B1" t="s"><v>1</v></c>' +
    '<c r="C1" t="s"><v>2</v></c><c r="D1" t="s"><v>3</v></c><c r="E1" t="s"><v>4</v></c></row>';
  for (let i = 1; i <= rowCount; i++) {
    const row = i + 1;
    sheet += '<row r="' + row + '">' +
      '<c r="A' + row + '" t="inlineStr"><is><t>SKU-' + String(i).padStart(6, "0") + '</t></is></c>' +
      '<c r="B' + row + '" t="inlineStr"><is><t>Product ' + i + '</t></is></c>' +
      (i % 7 ? '<c r="C' + row + '" t="s"><v>5</v></c>' : '') +
      (i % 11 ? '<c r="D' + row + '"><v>' + (i / 10) + '</v></c>' : '') +
      '<c r="E' + row + '" s="1"><v>46000</v></c></row>';
  }
  sheet += '</sheetData></worksheet>';
  const entries = [
    ["[Content_Types].xml", '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"/>'],
    ["xl/workbook.xml", workbook],
    ["xl/_rels/workbook.xml.rels", rels],
    ["xl/sharedStrings.xml", sharedXml],
    ["xl/styles.xml", styles],
    ["xl/worksheets/sheet1.xml", sheet],
  ];
  if (traversalEntry) entries.push(["../outside.xml", "<x/>"]);
  return zipArchive(entries, corruptSheetCrc ? "xl/worksheets/sheet1.xml" : null);
}

function getXlsxReader() {
  const html = read("countflow-admin.html");
  const scripts = inlineScripts(html);
  const script = scripts.find((s) => s.includes("function zipRead16") && s.includes("async function streamXlsxProductRows"));
  assert.ok(script, "CountFlow XLSX streaming implementation must exist in the admin app");
  const start = script.indexOf("function zipRead16");
  const end = script.indexOf("async function parseProductImportFile(file)", start);
  assert.ok(start >= 0 && end > start, "Could not isolate the XLSX streaming helpers");
  const source = script.slice(start, end) + "\n globalThis.__countflowStreamXlsx = streamXlsxProductRows;";
  const context = vm.createContext({
    Blob, DataView, DecompressionStream, Map, Set, TextDecoder, Uint8Array,
    Date, Number, String, RegExp, Error, Math, Object,
  });
  vm.runInContext(source, context, { timeout: 10000 });
  return context.__countflowStreamXlsx;
}

test("all operational application scripts pass JavaScript syntax checks", () => {
  for (const file of ["countflow-admin.html", "Countflow-supervisor.html", "countflow.html"]) {
    const scripts = inlineScripts(read(file));
    assert.ok(scripts.length, file + " must contain its application script");
    for (const [index, source] of scripts.entries()) {
      try {
        new vm.Script(source, { filename: file + "#script" + index });
      } catch (error) {
        assert.fail(file + " script " + index + " syntax error: " + String(error?.stack || error));
      }
    }
  }
  for (const file of ["countflow-core.js", "countflow-sw.js"]) {
    assert.doesNotThrow(() => new vm.Script(read(file), { filename: file }));
  }
});

test("XLSX reader streams a 90,000-row sheet with shared strings, inline values and dates", async () => {
  const parse = getXlsxReader();
  const file = new Blob([makeXlsx(90000)]);
  let count = 0;
  let first;
  let seventh;
  let eleventh;
  let last;
  const result = await parse(file, (row) => {
    count++;
    if (count === 1) first = row;
    if (count === 7) seventh = row;
    if (count === 11) eleventh = row;
    if (count === 90000) last = row;
  });
  assert.equal(count, 90000);
  assert.deepEqual(Array.from(result.headers), ["SKU", "Name", "Category", "Price", "Count Date"]);
  assert.equal(first.SKU, "SKU-000001");
  assert.equal(first.Name, "Product 1");
  assert.equal(first.Category, "General");
  assert.equal(first.Price, "0.1");
  assert.equal(first["Count Date"], "2025-12-09");
  assert.equal(first.__countflowRowNumber, 2);
  assert.equal(Object.keys(first).includes("__countflowRowNumber"), false);
  assert.equal(seventh.Category, "");
  assert.equal(eleventh.Price, "");
  assert.equal(last.SKU, "SKU-090000");
  assert.equal(last.__countflowRowNumber, 90001);
});

test("XLSX reader rejects a corrupted worksheet CRC", async () => {
  const parse = getXlsxReader();
  const file = new Blob([makeXlsx(120, { corruptSheetCrc: true })]);
  await assert.rejects(() => parse(file, () => {}), /CRC/);
});

test("XLSX reader rejects unsafe ZIP entry paths", async () => {
  const parse = getXlsxReader();
  const file = new Blob([makeXlsx(2, { traversalEntry: true })]);
  await assert.rejects(() => parse(file, () => {}), /مسار داخلي غير صالح/);
});


test("CSV and XLSX import retain source row numbers during skipped rows", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /function normalizeProductImportRow\(row,index,sourceRowNumber=null\)/);
  assert.match(admin, /sourceRowNumber\|\|row\.__countflowRowNumber\|\|index\+2/);
  assert.match(admin, /const currentSourceRow=sourceRowNumber\+\+/);
  assert.match(admin, /skipEmptyLines:false/);
  assert.match(admin, /streamXlsxProductRows\(file,async row=>/);
  assert.match(admin, /pending\.push\(normalizeProductImportRow\(row,rowIndex\)\)/);
});

test("Counter cannot save after membership, device or session approval is lost", () => {
  const counter = read("countflow.html");
  assert.match(counter, /deviceReady=false/);
  assert.match(counter, /session\.status!=='active'\|\|member\?\.status!=='active'\|\|!deviceReady/);
  assert.match(counter, /finally\{\$\('saveBtn'\)\.disabled=session\?\.status!=='active'\|\|member\?\.status!=='active'\|\|!deviceReady\}/);
  assert.match(counter, /touchPresence\(document\.hidden\?'idle':'online'\);if\(ok\)await queueCount\(\)/);
  assert.match(counter, /async function reportDeviceQueue\(\)/);
  assert.match(counter, /count_report_device_queue/);
});

test("Owner Master has workflow controls while Supervisor remains monitor and assignment only", () => {
  const admin = read("countflow-admin.html");
  const supervisor = read("Countflow-supervisor.html");
  assert.match(admin, /sessionWorkflowPanel/);
  assert.match(admin, /count_transition_session/);
  assert.match(admin, /count_reconcile_session/);
  assert.match(admin, /count_approve_reconciliation/);
  assert.match(admin, /count_generate_recount_tasks/);
  assert.match(admin, /count_set_alert_status/);
  assert.match(admin, /count_waive_device_queue/);
  assert.match(supervisor, /data-tab="live"/);
  assert.match(supervisor, /data-tab="team"/);
  assert.doesNotMatch(supervisor, /count_create_import_batch|count_commit_import_batch|count_set_alert_status|count_transition_session|count_approve_reconciliation/);
});

test("operation imports share bounded CSV/XLSX streaming and server-side 1,000-row batches", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("function operationValue(row,aliases)");
  const end = admin.indexOf("async function loadOperationExportHistory()", start);
  assert.ok(start >= 0 && end > start, "Operation import block must exist");
  const operationImport = admin.slice(start, end);
  assert.match(operationImport, /async function streamOperationImportChunks\(file,onChunk\)/);
  assert.match(operationImport, /streamXlsxProductRows\(file,async row=>/);
  assert.match(operationImport, /Papa\.parse\(file,\{header:true,skipEmptyLines:false/);
  assert.match(operationImport, /pending\.length>=1000/);
  assert.match(operationImport, /streamOperationImportChunks\(file,stage\)/);
  assert.match(operationImport, /count_stage_import_rows/);
  assert.match(operationImport, /parsed\.count!==state\.operationImportRowCount/);
  assert.doesNotMatch(operationImport, /FileReader|arrayBuffer\(\)|complete:\s*r\s*=>\s*resolve\(r\.data/);
});

test("operation import preserves per-row partial failure semantics for optional and malformed values", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("function normalizeOperationImportRow(row,rowNumber)");
  const end = admin.indexOf("async function streamOperationImportChunks", start);
  assert.ok(start >= 0 && end > start);
  const normalizer = admin.slice(start, end);
  assert.match(normalizer, /catch\(_\)\{units=\[\];\}/);
  assert.match(normalizer, /if\(!Array\.isArray\(units\)\)units=\[\]/);
  assert.match(normalizer, /category:value\(\['category','group','الفئة','التصنيف'\]\)\|\|null/);
  assert.match(normalizer, /base_unit:value\(\['base_unit','unit','uom','الوحدة','وحدة القياس'\]\)\|\|null/);
  assert.match(normalizer, /sku:value\(\['sku','item_code','code','كود الصنف'\]\)\|\|null/);
  assert.match(normalizer, /barcode:value\(\['barcode','bar_code','ean','upc','باركود'\]\)\|\|null/);
});

test("operation import row rejections retain original CSV source row numbers", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("async function streamOperationImportChunks(file,onChunk)");
  const end = admin.indexOf("$('operationImportFile').addEventListener('change',()=>{", start);
  assert.ok(start >= 0 && end > start);
  const csvStream = admin.slice(start, end);
  assert.match(csvStream, /sourceRowNumber=2/);
  assert.match(csvStream, /skipEmptyLines:false/);
  assert.match(csvStream, /const currentSourceRow=sourceRowNumber\+\+/);
  assert.match(csvStream, /pending\.push\(\{row,rowNumber:currentSourceRow\}\)/);
});


test("Supervisor uses server-authoritative polling when Broadcast delivery is unavailable", () => {
  const supervisor = read("Countflow-supervisor.html");
  assert.match(supervisor, /setInterval\(\(\)=>\{if\(project&&!document\.hidden\)refreshCockpitAuthoritatively\(\)/);
  assert.match(supervisor, /document\.addEventListener\('visibilitychange',\(\)=>\{if\(!document\.hidden&&project\)refreshCockpitAuthoritatively\(\)\}\)/);
  assert.match(supervisor, /async function refreshCockpitAuthoritatively\(\)/);
  assert.match(supervisor, /مزامنة دورية/);
  assert.doesNotMatch(supervisor, /liveBadge\)\.textContent=s==='SUBSCRIBED'\?'مباشر'/);
  assert.match(supervisor, /limit\(500\)/);
  assert.match(supervisor, /limit\(2000\)/);
});

test("device queue barrier digest includes canonical count payload, not identifiers alone", () => {
  const counter = read("countflow.html");
  const start = counter.indexOf("async function reportDeviceQueue()");
  const end = counter.indexOf("async function queueCount()", start);
  assert.ok(start >= 0 && end > start);
  const reporter = counter.slice(start, end);
  for (const key of ["client_event_id", "project_id", "session_id", "member_id", "device_id", "product_id", "location_id", "recount_task_id", "quantity", "unit", "scan_code", "note"]) {
    assert.ok(reporter.includes(key), "queue digest must include " + key);
  }
  assert.ok(reporter.includes(".sort((a,b)=>a.client_event_id.localeCompare(b.client_event_id))"));
  assert.ok(reporter.includes("JSON.stringify(canonicalQueue)"));
  assert.ok(reporter.includes("count_report_device_queue"));
  assert.ok(reporter.includes("p_pending_count:rows.length,p_queue_digest:digest"));
  assert.ok(!reporter.includes("eventIds.join"));
});

test("admin UI hides raw database errors and serialized audit payloads", () => {
  const admin = read("countflow-admin.html");
  for (const label of [
    "تعذر تحميل سجل الاستيراد. حاول تحديث الصفحة.",
    "تعذر تحميل إعدادات البريد المرتبطة بالتراخيص.",
    "تعذر تحميل سجل التصدير. حاول تحديث الصفحة.",
    "تعذر تحميل نتائج التسوية. حاول تحديث الصفحة.",
    "تعذر تحميل سجل الأحداث. حاول تحديث الصفحة."
  ]) assert.ok(admin.includes(label));
  assert.match(admin, /function friendlyErrorMessage\(error\)/);
  const auditStart = admin.indexOf("async function loadAudit()");
  const auditEnd = admin.indexOf("async function editProduct", auditStart);
  assert.ok(auditStart >= 0 && auditEnd > auditStart);
  const audit = admin.slice(auditStart, auditEnd);
  assert.doesNotMatch(audit, /JSON\.stringify\(x\.details/);
  assert.doesNotMatch(audit, /esc\(x\.actor_id/);
  assert.match(audit, /auditDetailsSummary\(x\.details\)/);
});



test("export preflight counts rows and enforces memory before loading large relations", () => {
  const source = read("functions/counting-export-session/index.ts");
  const countRows = source.indexOf("async function countRows(");
  const clientPreflight = source.indexOf("const [lineCount,locationCount,costCount,entryCount,projectProductCount]");
  const clientBulkReads = source.indexOf("const [lines,locations,costs,countEntries]");
  const fullPreflight = source.indexOf("const [runs,imports,entryCount,productCount,locationCount,memberCount,alertCount,recountCount]");
  const fullBulkReads = source.indexOf("const [entries,products,locations,members,alerts,recounts]");
  assert.ok(countRows >= 0 && clientPreflight > countRows && clientBulkReads > clientPreflight);
  assert.ok(fullPreflight > clientBulkReads && fullBulkReads > fullPreflight);
  assert.match(source.slice(clientPreflight, clientBulkReads), /countRows\(admin,/);
  assert.match(source.slice(clientPreflight, clientBulkReads), /EXPORT_MEMORY_BUDGET_EXCEEDED:client_balance_preflight/);
  assert.match(source.slice(fullPreflight, fullBulkReads), /countRows\(admin,/);
  assert.match(source.slice(fullPreflight, fullBulkReads), /EXPORT_COMBINED_ROW_LIMIT:250000/);
  assert.match(source.slice(fullPreflight, fullBulkReads), /EXPORT_MEMORY_BUDGET_EXCEEDED:full_preflight/);
});

test("Client Balance product images are streamed with a strict per-image byte ceiling", () => {
  const source = read("functions/counting-export-session/index.ts");
  const start = source.indexOf("const imageByProduct=new Map");
  const end = source.indexOf("const clientRows:any[][]", start);
  assert.ok(start >= 0 && end > start, "Client Balance image stage must exist");
  const imageStage = source.slice(start, end);
  assert.match(source, /async function readResponseBounded\(response: Response, maxBytes: number\)/);
  assert.match(imageStage, /createSignedUrl\(reference,60\)/);
  assert.match(imageStage, /const imagePrefix=session\.project_id\+"\/products\/"/);
  assert.match(imageStage, /const imageFilename=reference\.startsWith\(imagePrefix\)\?reference\.slice\(imagePrefix\.length\):""/);
  assert.doesNotMatch(imageStage, /reference\.startsWith\(session\.project_id\+"\/"\)/);
  assert.match(imageStage, /fetch\(signedData\.signedUrl,\{redirect:"error"\}\)/);
  assert.match(imageStage, /content-length/);
  assert.match(imageStage, /readResponseBounded\(imageResponse,1024\*1024\)/);
  assert.doesNotMatch(imageStage, /storage\.from\("counting-product-images"\)\.download\(reference\)/);
  assert.match(imageStage, /MAX_CLIENT_BALANCE_IMAGE_BYTES/);
  assert.match(imageStage, /embeddedImages\.length>=500/);
});

test("Counter evidence upload failure branch remains valid and reports a safe warning", () => {
  const counter = read("countflow.html");
  assert.match(counter, /if\(uploadError\)\{console\.warn\('Counter evidence upload failed',uploadError\);evidenceWarning='تم تسجيل العد، لكن تعذر إرفاق الصورة حالياً\.';\}else\{/);
  assert.doesNotMatch(counter, /if\(uploadError\)console\.warn\([^;]+;evidenceWarning=[^;]+;else\{/);
});

test("all three operational pages keep technical implementation details out of user-facing copy", () => {
  const visible = html => html
    .replace(/<script[\s\S]*?<\/script>/gi, " ")
    .replace(/<style[\s\S]*?<\/style>/gi, " ")
    .replace(/<!--[\s\S]*?-->/g, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;|&#160;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/\s+/g, " ")
    .trim();
  const admin = visible(read("countflow-admin.html"));
  const supervisor = visible(read("Countflow-supervisor.html"));
  const counter = visible(read("countflow.html"));
  for (const [name, text] of [["Admin", admin], ["Supervisor", supervisor], ["Counter", counter]]) {
    assert.doesNotMatch(text, /project_id|RLS|Realtime|Edge Function|service_role|Supabase Auth|PostgREST|UUID|JWT|SHA-256|IndexedDB|OOXML/i, name + " must not expose internal terminology");
  }
  assert.doesNotMatch(admin, />\s*supervisor\s*</i);
  assert.doesNotMatch(admin, />\s*counter\s*</i);
  assert.doesNotMatch(admin, />\s*auditor\s*</i);
  assert.doesNotMatch(supervisor, /JSON\.stringify/i);
  assert.doesNotMatch(counter, /JSON\.stringify/i);
});

test("Counter UI translates role and hides device queue identifiers from the member", () => {
  const counter = read("countflow.html");
  assert.match(counter, /function roleLabel\(role\)/);
  assert.match(counter, /member\.display_name\+'\s*·\s*'\+roleLabel\(member\.role\)/);
  assert.match(counter, /'حالة المزامنة: '\+Number\(data\?\.pending_queue_count\|\|0\)\+' عملية بانتظار الإرسال'/);
  assert.doesNotMatch(counter, /esc\(x\.session_id/);
  assert.doesNotMatch(counter, /esc\(x\.product_id/);
  assert.match(counter, /friendlyErrorMessage\(x\.sync_error\)/);
});

test("operation importer does not throw when a staging RPC succeeds and keeps completion text valid", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /if\(error\)\{console\.warn\('Operation import staging failed',error\);throw new Error\(/);
  assert.doesNotMatch(admin, /if\(error\)console\.warn\('Operation import staging failed',error\);throw new Error/);
  assert.match(admin, /تم حفظ النتيجة في السجل'\+\(parseErrors\?/);
  assert.doesNotMatch(admin, /تم حفظ النتيجة في السجل\+\(parseErrors\?/);
});


test("import rejection reasons are human-readable and every failed/warning row is pageable in both import surfaces", () => {
  const admin = read("countflow-admin.html");
  const serverCodes = [
    "INVALID_ROW_SHAPE",
    "MISSING_PRODUCT_IDENTIFIER",
    "PRODUCT_IDENTITY_MATCHES_MULTIPLE_PRODUCTS",
    "MISSING_BASE_UNIT",
    "INVALID_IMAGE_REFERENCE",
    "INVALID_EXPECTED_QUANTITY",
    "NEGATIVE_EXPECTED_QUANTITY",
    "SESSION_REQUIRED_FOR_EXPECTED_QTY",
    "LOCATION_REQUIRED_FOR_EXPECTED_QUANTITY",
    "UNKNOWN_LOCATION_CODE",
    "AMBIGUOUS_LOCATION_CODE",
    "DUPLICATE_PRODUCT_IDENTIFIER_AT_SAME_LOCATION",
    "INVALID_PURCHASE_UNIT_COST",
    "INVALID_CURRENCY_CODE",
    "INVALID_UNIT_FACTOR",
    "INVALID_COST_SOURCE_DATE",
    "COST_DATA_INCOMPLETE",
    "COST_REQUIRES_OPERATION_SCOPE"
  ];
  assert.match(admin, /function importIssueLabel\(code,kind='error'\)/);
  for (const code of serverCodes) assert.ok(admin.includes(code + ":"), "Missing Arabic label mapping for " + code);
  assert.match(admin, /function importIssueRowsHtml\(rows,key,kind\)/);
  assert.match(admin, /count:'exact'/);
  assert.match(admin, /range\(offset,offset\+IMPORT_DETAIL_PAGE_SIZE-1\)/);
  assert.match(admin, /عرض 500 نتيجة أخرى/);
  assert.match(admin, /showProductImportDetails\(b\.dataset\.productImportDetail\)/);
  assert.match(admin, /data-operation-import-detail/);
  assert.match(admin, /showProductImportDetails\(b\.dataset\.operationImportDetail,'operationImportDetails'\)/);
  assert.match(admin, /لا توجد سجلات في هذه الفئة/);
});


test("large import commit resumes in bounded server chunks for both catalog and operation import", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /committing:'قيد الاعتماد'/);
  const start = admin.indexOf("async function commitImportBatchInChunks(batchId,onProgress)");
  const end = admin.indexOf("async function commitProductImport()", start);
  assert.ok(start >= 0 && end > start);
  const helper = admin.slice(start, end);
  assert.match(helper, /while\(attempt\+\+<10000\)/);
  assert.match(helper, /status==='committed'/);
  assert.match(helper, /status!=='committing'/);
  assert.match(helper, /onProgress\(result\)/);
  assert.match(admin, /Number\(progress\.remaining_rows\|\|0\)/);
  assert.equal((admin.match(/commitImportBatchInChunks\(batchId,/g) || []).length, 4);
  assert.match(admin, /data-resume-product-import/);
  assert.match(admin, /data-resume-operation-import/);
  assert.ok(admin.includes('async function resumeImportBatchFromHistory(batchId,scope,button)'));
  assert.ok(admin.includes('loadProductImportHistory()'));
  assert.ok(admin.includes('loadOperationImportHistory()'));
  const withoutHelper = admin.slice(0, start) + admin.slice(end);
  assert.doesNotMatch(withoutHelper, /db\.rpc\('count_commit_import_batch',\{p_batch_id:batchId\}\)/);
});

test("session workflow device acknowledgement row uses a parse-safe template literal", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("const deviceHtml=presence.length?");
  const end = admin.indexOf("const generateControls=", start);
  assert.ok(start >= 0 && end > start);
  const deviceHtml = admin.slice(start, end);
  assert.match(deviceHtml, /return \`<tr><td>\$\{esc\(workflowMemberName\(p\.member_id\)\)\}/);
  assert.match(deviceHtml, /\$\{esc\(devicePlatformLabel\(d\.platform\)\)\}/);
  assert.match(deviceHtml, /\$\{Number\(p\.pending_queue_count\|\|0\)\}/);
  assert.match(deviceHtml, /\$\{action\}\$\{waived\?/);
});

test("resumable import SQL migration bounds each commit transaction and finalizes only after remaining rows reach zero", () => {
  const sql = read("database/migrations/20261121214000_countflow_import_commit_chunked_batches.sql");
  assert.match(sql, /LIMIT 1000/);
  assert.ok(sql.includes("IF v_batch.status NOT IN (''preview'',''committing'') THEN"));
  assert.match(sql, /row_status=''staged''/);
  assert.match(sql, /remaining_rows/);
  assert.match(sql, /IF v_remaining>0 THEN/);
  assert.match(sql, /v_initial_status=''committing'' THEN ''committing'' ELSE ''failed'' END/);
  assert.match(sql, /COMMENT ON FUNCTION counting_private\.count_commit_import_batch_impl/);
});


test("large import progress and errors do not expose internal batch identifiers or raw RPC messages", () => {
  const admin = read("countflow-admin.html");
  const commitStart = admin.indexOf("async function commitImportBatchInChunks(batchId,onProgress)");
  const commitEnd = admin.indexOf("async function resumeImportBatchFromHistory", commitStart);
  const commitHelper = admin.slice(commitStart, commitEnd);
  assert.match(commitHelper, /console\.warn\('CountFlow import commit chunk failed',error\)/);
  assert.match(commitHelper, /تعذر اعتماد جزء من الاستيراد حالياً/);
  assert.doesNotMatch(commitHelper, /error\.message/);
  assert.doesNotMatch(commitHelper, /String\(result\.status/);

  const stageStart = admin.indexOf("const stage=async(chunk,offset)=>");
  const stageEnd = admin.indexOf("if(state.productImportSourceFormat==='csv')", stageStart);
  const catalogStage = admin.slice(stageStart, stageEnd);
  assert.match(catalogStage, /console\.warn\('CountFlow product import staging failed',error\)/);
  assert.match(catalogStage, /تعذر فحص بيانات الملف بدءاً من الصف/);
  assert.doesNotMatch(catalogStage, /error\.message/);
  assert.doesNotMatch(catalogStage, /فحص الدفعة '\+batchId/);

  assert.match(admin, /metadata\?\.import_surface==='countflow-admin'/);
  assert.match(admin, /data-resume-product-import/);
  assert.match(admin, /data-resume-operation-import/);
  assert.match(admin, /تعذر استكمال اعتماد الاستيراد/);
});

test("an import already committed is not reported as failed when only a follow-up view refresh fails", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("async function resumeImportBatchFromHistory");
  const end = admin.indexOf("async function commitProductImport()", start);
  const resume = admin.slice(start, end);
  assert.match(resume, /committed\?\.status!=='committed'/);
  assert.match(resume, /اكتمل استكمال دفعة الاستيراد/);
  assert.match(resume, /catch\(refreshError\)/);
  assert.match(resume, /اكتمل اعتماد الدفعة لكن تعذر تحديث العرض/);
  assert.ok(resume.indexOf("اكتمل استكمال دفعة الاستيراد") < resume.indexOf("catch(refreshError)"));
});

test("Admin dynamic metadata, import history and team roles use Arabic operator labels", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /function locationTypeName\(s\)/);
  assert.match(admin, /esc\(locationTypeName\(x\.location_type\)\)/);
  assert.match(admin, /statusName\(s\.status\)/);
  assert.match(admin, /roleName\(m\.role\)/);
  assert.match(admin, /exportFormatLabel\(b\.source_format\)/);
  assert.match(admin, /committing:'قيد الاعتماد'/);
  assert.match(admin, /'نشط':'نشط','موقوف':'موقوف'/);
  assert.doesNotMatch(admin, /esc\(x\.location_type\)|esc\(m\.role\)|state\.project\.code\+' · '\+s\.status/);
});


test("Client Balance decimal arithmetic preserves purchase-unit to base-unit value", () => {
  const source = read("functions/counting-export-session/index.ts");
  const start = source.indexOf("function decimalToScaled(");
  const end = source.indexOf("function excelColumn(", start);
  assert.ok(start >= 0 && end > start, "Client Balance decimal helpers must exist");
  const helpers = source.slice(start, end)
    .replace(/value: unknown/g, "value")
    .replace(/scale: number/g, "scale")
    .replace(/numerator: bigint/g, "numerator")
    .replace(/denominator: bigint/g, "denominator")
    .replace(/value: bigint/g, "value")
    .replaceAll(": bigint | null", "")
    .replace(/: bigint/g, "")
    .replace(/: number/g, "");
  const { decimalToScaled, roundDivide, scaledToNumber } =
    new Function(helpers + "; return {decimalToScaled,roundDivide,scaledToNumber};")();

  const purchasePrice = decimalToScaled("120.00", 6);
  const unitsPerBox = decimalToScaled("12", 6);
  assert.equal(purchasePrice, 120000000n);
  assert.equal(unitsPerBox, 12000000n);

  const baseUnitCost = roundDivide(purchasePrice * 1000000n, unitsPerBox);
  assert.equal(baseUnitCost, 10000000n);
  assert.equal(scaledToNumber(baseUnitCost, 6), 10);

  const completeBaseQuantity = decimalToScaled("25.5", 4);
  const finalValue = roundDivide(completeBaseQuantity * baseUnitCost, 10000n);
  assert.equal(finalValue, 255000000n);
  assert.equal(scaledToNumber(finalValue, 6), 255);

  assert.equal(decimalToScaled("1.2345678", 6), 1234568n);
  assert.equal(decimalToScaled("-1.2345678", 6), -1234568n);
  assert.equal(decimalToScaled("", 6), null);
  assert.equal(decimalToScaled(null, 6), null);
  assert.equal(roundDivide(-5n, 2n), -3n);
  assert.throws(() => decimalToScaled("1e3", 6), /INVALID_DECIMAL_VALUE/);
  assert.throws(() => roundDivide(100n, 0n), /INVALID_DECIMAL_DENOMINATOR/);
});

test("Client Balance workbook image anchors and right-to-left layout reference the exact product row", () => {
  const source = read("functions/counting-export-session/index.ts");
  assert.match(source, /rightToLeft="1"/);
  assert.match(source, /imageRows\?:Set<number>/);
  assert.match(source, /options\.imageRows\?\.has\(ri\+1\)/);
  assert.match(source, /id=i\+1,fromRow=im\.row-1,toRow=im\.row/);
  assert.ok(source.includes("<xdr:col>0</xdr:col>"));
  assert.ok(source.includes("<xdr:col>1</xdr:col>"));
  assert.match(source, /<a:blip r:embed="rId/);
  assert.match(source, /imageByProduct\.set\(product\.id,\{status:"مضمنة داخل Excel"/);
  assert.match(source, /images_embedded:embeddedCount/);
  assert.match(source, /images_not_embedded:notEmbeddedCount/);
});


test("Admin bootstrap isolates the confirmed platform owner from scoped client administrators", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /function isPlatformOwner\(user\)/);
  assert.match(admin, /toLowerCase\(\)==='owner@rawaea\.com'&&Boolean\(user\?\.email_confirmed_at\)/);
  const start = admin.indexOf("async function bootstrap()");
  const end = admin.indexOf("\n }", start);
  assert.ok(start >= 0 && end > start);
  const bootstrap = admin.slice(start, end);
  assert.match(bootstrap, /db\.auth\.getUser\(\)/);
  assert.match(bootstrap, /state\.platformOwner=isPlatformOwner\(state\.user\)/);
  assert.match(bootstrap, /if\(state\.platformOwner\)/);
  assert.match(bootstrap, /from\('count_client_members'\)/);
  assert.match(bootstrap, /count_roles\(role_key,scope\)/);
  assert.match(bootstrap, /count_has_client_permission/);
  assert.match(bootstrap, /client\.read/);
  assert.match(bootstrap, /db\.auth\.signOut\(\)/);
  assert.doesNotMatch(bootstrap, /platform\.license\.manage/);
});

test("Admin operations keep the institution name and engagement code visible", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("function renderGlobalOperations()");
  const end = admin.indexOf("function stopGlobalRealtime()", start);
  assert.ok(start >= 0 && end > start);
  const render = admin.slice(start, end);
  assert.match(render, /\['client','الجهة المتعاقدة'\]/);
  assert.match(render, /\['code','رقم التكليف'\]/);
  assert.match(render, /p\.name\|\|'—'/);
  assert.match(render, /p\.code\|\|'—'/);
  assert.match(admin, /state\.project\.name\+' · '\+state\.project\.code/);
});

test("Admin private product images use project-scoped storage, signed reads and Excel-compatible bounded upload", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /createSignedUrls\(paths,3600\)/);
  assert.match(admin, /storage\.from\('counting-product-images'\)\.upload\(path,file/);
  assert.match(admin, /projectId\+'\/products\/'\+crypto\.randomUUID\(\)/);
  assert.match(admin, /MAX_PRODUCT_IMAGE_BYTES=1024\*1024/);
  assert.match(admin, /file\.size>MAX_PRODUCT_IMAGE_BYTES/);
  assert.match(admin, /'image\/jpeg':'jpg','image\/png':'png'/);
  assert.doesNotMatch(admin, /'image\/webp':'webp'/);
  assert.match(admin, /function isProjectProductImagePath\(reference,projectId\)/);
  assert.match(admin, /function safeExternalProductImageUrl\(reference\)/);
  assert.match(admin, /function productImageDisplayUrl\(product\)/);
  assert.match(admin, /isProjectProductImagePath\(path,projectId\)/);
  assert.match(admin, /class="product-image-link" href=/);
  assert.match(admin, /target="_blank" rel="noopener noreferrer"/);
  assert.match(admin, /class="product-thumb"/);
  assert.match(admin, /data-product-image/);
  assert.match(admin, /hasImageReference\?'الصورة غير متاحة':'بدون صورة'/);
  assert.match(admin, /productImagePreview/);
  assert.match(admin, /image_url:imageRef/);
  assert.match(admin, /requestToken=\+\+state\.productImageToken/);
  assert.match(admin, /state\.productImageUrls\.clear\(\)/);
  assert.doesNotMatch(admin, /createPublicUrl\(/);
});

test("Admin can reuse an existing confirmed Auth account without requesting or changing its password", () => {
  const admin = read("countflow-admin.html");
  const passwordField = admin.slice(admin.indexOf('id="memberPassword"') - 100, admin.indexOf('id="memberPassword"') + 180);
  assert.match(passwordField, /minlength="10"/);
  assert.doesNotMatch(passwordField, /required/);
  assert.match(admin, /data\.account_reused\?/);
  assert.match(admin, /دون تغيير كلمة مروره/);
  assert.match(admin, /error\.context\?\.clone\?\.\(\)\.json\(\)/);
  const provision = read("functions/counting-provision-member/index.ts");
  assert.match(provision, /if \(password.length < 10\) throw new Error\("PASSWORD_REQUIRED_FOR_NEW_ACCOUNT"\)/);
  assert.match(provision, /existing_password_changed: false/);
  assert.match(provision, /if \(!authUser.email_confirmed_at\)/);
});

test("Admin product UoM editor validates and persists conversion factors", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /function renderProductUnitEditor\(units=\[\]\)/);
  assert.match(admin, /function readProductUnits\(baseUnit\)/);
  assert.match(admin, /factor_to_base:factor/);
  assert.match(admin, /factor<=0\|\|factor>1000000000/);
  assert.match(admin, /const units=readProductUnits\(baseUnit\)/);
  assert.match(admin, /base_unit:baseUnit,units,expected_qty:/);
  assert.doesNotMatch(admin, /insert\(\{\.\.\.row,units:\[\],is_active:true\}\)/);
});

test("Admin user management exposes audited password reset without self-reset", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /data-member-reset-password/);
  assert.match(admin, /action:'reset_password'/);
  assert.match(admin, /new_password:password/);
  assert.match(admin, /password\.length<10/);
  assert.match(admin, /password!==confirmation/);
  assert.match(admin, /member\.user_id===state\.user\?\.id/);
  assert.match(admin, /audit_warning/);
});


test("confirmed platform owner can read CountFlow Admin data independently of project membership", () => {
  const sql = read("database/migrations/20261121220000_countflow_platform_owner_read_and_image_storage_access.sql");
  const policies = ["count_projects_read","count_products_read","count_sessions_read","count_locations_read","count_members_read","count_assignments_read","count_audit_read","count_alerts_read","count_anomaly_rules_read","count_devices_read","count_entries_read","count_entry_images_read","count_expected_read","count_exports_read","count_import_read","count_import_mappings_read","count_import_rows_read","count_presence_read","count_recon_lines_read","count_recon_runs_read","count_recount_tasks_read","count_session_product_costs_read"];
  for (const policy of policies) {
    const start = sql.indexOf("ALTER POLICY " + policy + " ON public.");
    assert.ok(start >= 0, "Missing owner-aware read policy " + policy);
    const end = sql.indexOf(";", start);
    assert.ok(sql.slice(start, end + 1).includes("counting_private.is_platform_owner()"));
  }
  for (const policy of ["count_image_read", "count_image_upload", "count_image_update"]) {
    const start = sql.indexOf("ALTER POLICY " + policy + " ON storage.objects");
    assert.ok(start >= 0, "Missing private image Storage owner path " + policy);
    const end = sql.indexOf(";", start);
    const statement = sql.slice(start, end + 1);
    assert.ok(statement.includes("counting_private.is_platform_owner()"));
    assert.ok(statement.includes("counting-product-images"));
  }
  assert.ok(sql.includes("m.role='supervisor'"));
  assert.ok(sql.includes("m.status='active'"));
  assert.ok(sql.includes("m.status IN ('active','paused')"));
  const storageFix = read("database/migrations/20261121210000_countflow_storage_owner_path_qualifier_fix.sql");
  assert.equal(storageFix.split("storage.foldername(objects.name)").length - 1, 8);
  assert.equal(storageFix.includes("storage.foldername(p.name)"), false);

  for (const forbidden of ["CREATE POLICY","DROP POLICY","INSERT INTO public.","UPDATE public.","DELETE FROM public.","TRUNCATE","TO anon","storage.buckets"]) {
    assert.equal(sql.includes(forbidden), false, "Forbidden policy/data-scope change: " + forbidden);
  }
});


test("Counter gamification reads server-derived points, progress and achievements only", () => {
  const counter = read("countflow.html");
  const migration = read("database/migrations/20261123173951_countflow_gamification_snapshot_v1.sql");
  for (const id of [
    "gamificationPoints","gamificationProgressFill","gamificationProgressText",
    "gamificationLeaderboard","gamificationBadges","gamificationMemberProgressFill"
  ]) {
    assert.ok(counter.includes('id="' + id + '"'), "Missing gamification UI element: " + id);
  }
  assert.match(counter, /data-tab="achievements"/);
  assert.match(counter, /sb\.rpc\('count_get_gamification_snapshot'/);
  assert.match(counter, /async function refreshGamification\(options=\{\}\)/);
  assert.match(counter, /await refreshGamification\(\{quiet:true\}\)/);
  assert.match(counter, /setInterval\(\(\)=>\{if\(!document\.hidden\)refreshGamification\(\{quiet:true\}\)\},20000\)/);
  assert.match(counter, /if\(!navigator\.onLine\)\{\$\('gamificationStatus'\)/);
  assert.doesNotMatch(counter, /function updateGamification\(/);
  assert.doesNotMatch(counter, /currentPoints\s*\+=\s*10/);
  assert.doesNotMatch(migration, /ALTER TABLE\s+(?:public\.)?count_members\s+ADD COLUMN\s+(?:IF NOT EXISTS\s+)?points/i);
});

test("Gamification scoring is server-authoritative, idempotent and Counter-only", () => {
  const migration = read("database/migrations/20261123173951_countflow_gamification_snapshot_v1.sql");
  assert.match(migration, /counting_private\.count_gamification_snapshot/);
  assert.match(migration, /SECURITY DEFINER\s+SET search_path TO ''/);
  assert.match(migration, /public\.count_get_gamification_snapshot[\s\S]*?SECURITY INVOKER/);
  assert.match(migration, /auth\.uid\(\)/);
  assert.match(migration, /m\.role = 'counter'/);
  assert.match(migration, /m\.status = 'active'/);
  assert.match(migration, /SELECT DISTINCT e\.member_id, e\.product_id, e\.location_id/);
  assert.match(migration, /e\.recount_task_id IS NULL/);
  assert.match(migration, /e\.count_round = 1/);
  assert.match(migration, /e\.revision = 1/);
  assert.match(migration, /public\.count_expected_balances/);
  assert.match(migration, /public\.count_assignments/);
  assert.match(migration, /REVOKE ALL ON FUNCTION counting_private\.count_gamification_snapshot\(uuid\) FROM PUBLIC/);
  assert.match(migration, /REVOKE ALL ON FUNCTION public\.count_get_gamification_snapshot\(uuid\) FROM anon/);
  assert.match(migration, /GRANT EXECUTE ON FUNCTION public\.count_get_gamification_snapshot\(uuid\) TO authenticated/);
  assert.doesNotMatch(migration, /GRANT EXECUTE ON FUNCTION public\.count_get_gamification_snapshot\(uuid\) TO anon/);
});


test("Gamification snapshot rejects counters who are not assigned to an explicitly assigned session", () => {
  const guard = read("database/migrations/20261123174943_countflow_gamification_session_assignment_guard_v1.sql");
  assert.match(guard, /counting_private\.assert_gamification_session_participation/);
  assert.match(guard, /m\.user_id = v_user_id/);
  assert.match(guard, /m\.role = 'counter'/);
  assert.match(guard, /m\.status = 'active'/);
  assert.match(guard, /SELECT EXISTS \([\s\S]*?FROM public\.count_assignments a[\s\S]*?a\.session_id = p_session_id/);
  assert.match(guard, /v_has_assignments AND NOT EXISTS \([\s\S]*?a\.member_id = v_member_id[\s\S]*?a\.status IN \('assigned','active'\)/);
  assert.match(guard, /COUNTER_NOT_ASSIGNED_TO_SESSION/);
  assert.match(guard, /PERFORM counting_private\.assert_gamification_session_participation\(p_session_id\)/);
  assert.match(guard, /public\.count_get_gamification_snapshot[\s\S]*?SECURITY INVOKER/);
  assert.match(guard, /REVOKE ALL ON FUNCTION counting_private\.assert_gamification_session_participation\(uuid\) FROM anon/);
  assert.match(guard, /GRANT EXECUTE ON FUNCTION counting_private\.assert_gamification_session_participation\(uuid\) TO authenticated/);
});
test("Product image reference helpers allow only stable HTTPS URLs or a single same-project products object", () => {
  const admin = read("countflow-admin.html");
  const start = admin.indexOf("function isProjectProductImagePath(reference,projectId)");
  const urlStart = admin.indexOf("function safeExternalProductImageUrl(reference)", start);
  const loadStart = admin.indexOf("async function loadProductImageUrls", urlStart);
  assert.ok(start >= 0 && urlStart > start && loadStart > urlStart);
  const isPath = vm.runInNewContext("(" + admin.slice(start,urlStart).trim() + ")");
  const externalUrl = vm.runInNewContext("(" + admin.slice(urlStart,loadStart).trim() + ")", { URL });
  const projectId = "10ade334-e211-4a32-a0bd-41f7bf41eb1d";
  assert.equal(isPath(projectId + "/products/550e8400-e29b-41d4-a716-446655440000.png", projectId), true);
  assert.equal(isPath(projectId + "/products/nested/image.png", projectId), false);
  assert.equal(isPath(projectId + "/evidence/image.png", projectId), false);
  assert.equal(isPath("00000000-0000-0000-0000-000000000000/products/image.png", projectId), false);
  assert.equal(isPath(projectId + "/products/../image.png", projectId), false);
  assert.equal(isPath(projectId + "/products/%2e%2e.png", projectId), false);
  assert.equal(externalUrl("https://cdn.example.com/products/item.png"), "https://cdn.example.com/products/item.png");
  assert.equal(externalUrl("http://cdn.example.com/products/item.png"), "");
  assert.equal(externalUrl("https://user:password@cdn.example.com/item.png"), "");
  assert.equal(externalUrl("https://project.supabase.co/storage/v1/object/sign/counting-product-images/path.png?token=temporary"), "");
});

test("Counter resolves product images through one scoped helper for both scan and recount with a safe fallback", () => {
  const counter = read("countflow.html");
  assert.match(counter, /async function resolveProductImageUrl\(reference,projectId\)/);
  assert.match(counter, /async function showProductImage\(reference,productId,projectId\)/);
  assert.match(counter, /await showProductImage\(product\.image_url,product\.id,project\.id\)/);
  assert.match(counter, /await showProductImage\(item\.image_url,item\.id,project\.id\)/);
  assert.match(counter, /image\.onerror=\(\)=>\{image\.onerror=null;image\.src=PRODUCT_IMAGE_FALLBACK\}/);
  assert.match(counter, /project\?\.id!==projectId\|\|product\?\.id!==productId/);
  assert.equal((counter.match(/createSignedUrl\(reference,3600\)/g) || []).length, 1);
  assert.doesNotMatch(counter, /storage\.from\('counting-product-images'\)\.createSignedUrl\(item\.image_url/);
});

test("Database image hardening keeps private Storage and rejects cross-project, missing and unsupported references", () => {
  const migration = read("database/migrations/20261123182553_countflow_product_image_reference_hardening_v1.sql");
  const ephemeral = read("database/migrations/20261123182644_countflow_reject_ephemeral_product_image_urls_v1.sql");
  assert.match(migration, /CREATE OR REPLACE FUNCTION counting_private\.is_valid_product_image_reference/);
  assert.match(migration, /cardinality\(storage\.foldername\(name\)\)=2/);
  assert.match(migration, /\(storage\.foldername\(name\)\)\[2\]='products'/);
  assert.match(migration, /CREATE TRIGGER count_products_product_image_reference_guard/);
  assert.match(migration, /is_valid_product_image_reference\(v_batch\.project_id,v_image_url,false\)/);
  assert.match(migration, /is_valid_product_image_reference\(v_batch\.project_id,v_image_url,true\)/);
  assert.match(migration, /metadata->>'mimetype'/);
  assert.match(migration, /BETWEEN 1 AND 1048576/);
  assert.match(ephemeral, /storage\/v1\/object\/sign/);
  assert.doesNotMatch(migration, /UPDATE\s+storage\.objects/i);
  assert.doesNotMatch(migration, /ALTER\s+TABLE\s+public\.count_products\s+ADD\s+COLUMN\s+image_url/i);
});

test("Admin UI uses grouped accessible navigation, icons, SweetAlert2 and sticky table headers", () => {
  const admin = read("countflow-admin.html");
  const navTabs = [...admin.matchAll(/data-tab="([^"]+)"/g)].map((match) => match[1]);
  assert.equal(navTabs.length, 12);
  assert.equal(new Set(navTabs).size, 12);
  assert.match(admin, /class="nav-group"/);
  assert.match(admin, /class="nav-group-title"/);
  assert.match(admin, /data-icon="gauge-high"/);
  assert.match(admin, /font-awesome\/7\.3\.1\/css\/all\.min\.css/);
  assert.match(admin, /sweetalert2@11\.26\.25\/dist\/sweetalert2\.all\.min\.js/);
  assert.match(admin, /confirmButtonColor:'#dc2626'/);
  assert.match(admin, /async function confirmAction\(/);
  assert.match(admin, /async function promptReason\(/);
  assert.match(admin, /inputValidator:value=>String\(value\|\|''\)\.trim\(\)\.length<10/);
  assert.doesNotMatch(admin, /\b(?:window\.)?confirm\s*\(/);
  assert.doesNotMatch(admin, /\b(?:window\.)?prompt\s*\(/);
  assert.match(admin, /\.tablewrap thead th\{position:sticky;top:0/);
  assert.match(admin, /#memberTable thead th,#roleTable thead th/);
  assert.match(admin, /#operationsTable thead th,#auditTable thead th/);
  assert.match(admin, /#productVirtualScroller thead th/);
  assert.match(admin, /async function withTableSkeletons\(/);
  for (const target of ["projectList", "memberTable", "roleTable", "locationTable", "sessionTable", "productTable", "operationsTable", "auditTable"]) {
    assert.ok(admin.includes("['" + target + "'"), "Missing skeleton loading target: " + target);
  }
  assert.match(admin, /new MutationObserver\(/);
  assert.match(admin, /button\.prepend\(icon\)/);
});

test("Client-balance XLSX excludes products without a complete counted result at every reconciliation location", () => {
  const exporter = read("functions/counting-export-session/index.ts");
  const helperStart = exporter.indexOf("function hasCompleteClientCountResult(");
  const helperEnd = exporter.indexOf("\n}", helperStart) + 2;
  assert.ok(helperStart >= 0 && helperEnd > helperStart, "Missing complete-count predicate");
  const hasCompleteClientCountResult = vm.runInNewContext("(" + exporter.slice(helperStart, helperEnd).trim() + ")");
  assert.equal(hasCompleteClientCountResult([]), false, "A catalogue product without reconciliation lines is not a counted result");
  assert.equal(hasCompleteClientCountResult([{ counted_quantity: null, result_status: "not_counted" }]), false);
  assert.equal(hasCompleteClientCountResult([{ counted_quantity: undefined, result_status: "not_counted" }]), false);
  assert.equal(hasCompleteClientCountResult([{ counted_quantity: 4, result_status: "counted" }, { counted_quantity: null, result_status: "not_counted" }]), false);
  assert.equal(hasCompleteClientCountResult([{ counted_quantity: 4, result_status: "counted" }, { counted_quantity: 2, result_status: "variance" }]), true);
  assert.equal(hasCompleteClientCountResult([{ counted_quantity: 0, result_status: "matched" }]), true, "An explicitly counted zero must be retained");

  const branchStart = exporter.indexOf('if (scope === "client_balance") {');
  const branchEnd = exporter.indexOf("    // Count the large relations", branchStart);
  const branch = exporter.slice(branchStart, branchEnd);
  assert.match(branch, /const clientProducts=products\.filter\(\(product:any\)=>hasCompleteClientCountResult\(/);
  assert.match(branch, /clientProductIds\.has\(row\.product_id\)/);
  assert.ok(branch.includes("const clientCountEntries=countEntries.filter((entry:any)=>clientProductIds.has(entry.product_id))"), "Count events must be scoped to delivered products");
  assert.match(branch, /count_events:clientCountEntries\.length/);
  assert.ok(branch.includes("committedImportRows.filter((item:any)=>clientProductIds.has(item.product_id))"), "Import exception details must be scoped to delivered products");
  assert.match(branch, /for\(const product of clientProducts\)/);
  assert.match(branch, /row_count:clientProducts\.length/);
  assert.match(branch, /incomplete_products_excluded:excludedUncountedProductCount/);
  assert.doesNotMatch(branch, /for\(const product of products\)\{/);
});

test("Supervisor live rows open a paginated, filtered, read-only count detail view with realtime refresh", () => {
  const supervisor = read("Countflow-supervisor.html");
  assert.ok(supervisor.includes('id="entryDetailModal"'), "Missing accessible count detail dialog");
  assert.ok(supervisor.includes('role="dialog" aria-modal="true"'), "Detail view must be announced as a modal dialog");
  assert.ok(supervisor.includes('data-entry-product="'), "Live count rows must expose a product drilldown target");
  assert.match(supervisor, /async function openEntryDetails\(productId,productName\)/);
  assert.match(supervisor, /async function loadEntryDetailPage\(quiet=false\)/);
  assert.ok(supervisor.includes(".eq('session_id',sessionId).eq('product_id',productId)"), "Detail query must stay inside the selected session and product");
  assert.ok(supervisor.includes(".range(from,from+entryDetailState.pageSize-1)"), "Detail results must be paginated");
  assert.ok(supervisor.includes("entryDetailLocation"), "Location filter is required");
  assert.ok(supervisor.includes("entryDetailMember"), "Team-member filter is required");
  assert.ok(supervisor.includes("count_entry_images"), "Count evidence metadata must be included");
  assert.ok(supervisor.includes("createSignedUrls(paths,3600)"), "Evidence links must use temporary signed URLs");
  assert.ok(supervisor.includes("row?.product_id===entryDetailState.productId"), "Realtime events for the open product must refresh the detail table");
  assert.ok(supervisor.includes("entryDetailNext"), "Detail pagination must expose a next-page control");

  assert.ok(supervisor.includes("requestToken!==entryDetailState.requestToken"), "Newer filter results must supersede stale responses");
  assert.ok(supervisor.includes("entryDetailSearchTimer=setTimeout"), "Detail search must debounce input");
  assert.match(supervisor, /font-awesome\/7\.3\.1\/css\/all\.min\.css/);
  assert.match(supervisor, /sweetalert2@11\.26\.25\/dist\/sweetalert2\.all\.min\.js/);
  assert.match(supervisor, /async function confirmSupervisorAction\(/);
  assert.ok(supervisor.includes("confirmButtonColor:'#dc2626'"), "Supervisor confirmations must be red and explicit");
  assert.doesNotMatch(supervisor, /confirm\(/, "Read-only drilldown must not trigger native mutation confirmations");
});

test("Admin exposes a modal operation creator, stable catalogue and distinct engagement/session/operation scopes", () => {
  const admin = read("countflow-admin.html");
  const navTabs = [...admin.matchAll(/data-tab="([^"]+)"/g)].map((match) => match[1]);
  assert.ok(navTabs.includes("projects") && navTabs.includes("sessions") && navTabs.includes("operations"));
  assert.ok(navTabs.includes("clients") && navTabs.includes("catalog"));
  assert.ok(admin.includes('id="newOperationButton"'), "Missing dedicated create-operation action");
  assert.match(admin, /newOperationButton'\)\.onclick=\(\)=>\{activateTab\('operations'\);openOperationCreateModal\(\);\}/);
  assert.match(admin, /id="operationCreateModal"/);
  assert.match(admin, /id="sessionTeam"[^>]*multiple/);
  assert.ok(admin.includes("كتالوج أصناف الجهة / التكليف"), "The client/engagement catalogue must persist across sessions");
  assert.ok(admin.includes("لا تُحذف أصنافه عند إغلاق أي جلسة جرد"), "Catalogue persistence rule must be explicit");
  assert.ok(admin.includes("ملف التكليف المحدد"), "Sessions must be scoped to the selected engagement");
  assert.ok(admin.includes("سجل عمليات الجرد — جميع ملفات التكليف"), "Operations register must cover all visible engagements");
});

test("Control requires an active auditor membership and is strictly read-only", () => {
  const control = read("countflow-control.html");
  assert.match(control, /eq\('role','auditor'\)\.eq\('status','active'\)/);
  assert.match(control, /async function acceptUser\(user\)/);
  assert.ok(control.includes("countflow:project:"+ "'+project.id"), "Control must subscribe only to its authorized project topic");
  assert.ok(control.includes("countflow:session:"+ "'+id"), "Control must subscribe to the selected session topic");
  assert.ok(control.includes("config:{private:true}"), "Control realtime channels must be private");
  assert.ok(control.includes("count_control_reconciliation_runs"), "Control must read the safe reconciliation run projection");
  assert.ok(control.includes("count_control_reconciliation_lines"), "Control must read paginated reconciliation detail");
  assert.ok(control.includes("from('counting-evidence').createSignedUrls(paths,3600)"), "Evidence must use expiring private signed URLs");
  assert.ok(control.includes("from('counting-product-images').createSignedUrls(productPaths,3600)"), "Product images must use private signed URLs");
  assert.match(control, /\.range\(from,from\+state\.pageSize-1\)/);
  assert.doesNotMatch(control, /\.from\([^)]*\)\.(?:insert|update|upsert|delete)\(/, "Control must not write to CountFlow tables");
  assert.doesNotMatch(control, /count_audit_log|count_exports|count_platform_settings/, "Control must not read owner administration or license data");
});

test("Control portal, Pages build, and Service Worker include the separate reviewer app", () => {
  const portal = read("index.html");
  const build = read("scripts/build-pages.sh");
  const sw = read("countflow-sw.js");
  assert.ok(portal.includes('href="./countflow-admin.html"'));
  assert.ok(portal.includes('href="./Countflow-supervisor.html"'));
  assert.ok(portal.includes('href="./countflow.html"'));
  assert.ok(portal.includes('href="./countflow-control.html"'));
  assert.ok(build.includes('"$SCRIPT_DIR/countflow-control.html"'), "Pages build must publish Control");
  assert.ok(build.includes("Countflow-supervisor.html countflow-control.html countflow-core.js"));
  assert.ok(sw.includes("'./countflow-control.html'"), "Service Worker shell must precache Control");
  assert.ok(sw.includes("countflow-sw-20261124-1"), "Service Worker cache must be versioned");
});

test("Control reconciliation views omit owner identity and are gated by active project authorization", () => {
  const migration = read("database/migrations/20261124182600_countflow_control_safe_reconciliation_views_and_owner_realtime_redaction_v1.sql");
  const runsView = migration.slice(migration.indexOf("CREATE OR REPLACE VIEW public.count_control_reconciliation_runs"), migration.indexOf("CREATE OR REPLACE VIEW public.count_control_reconciliation_lines"));
  const linesView = migration.slice(migration.indexOf("CREATE OR REPLACE VIEW public.count_control_reconciliation_lines"), migration.indexOf("REVOKE ALL ON public.count_control_reconciliation_runs"));
  assert.match(runsView, /counting_private\.is_auditor\(project_id\)/);
  assert.match(linesView, /counting_private\.is_auditor\(project_id\)/);
  assert.doesNotMatch(runsView, /created_by|approved_by/);
  assert.doesNotMatch(linesView, /created_by|approved_by/);
  assert.ok(migration.includes("v_session_new.created_by:=NULL"));
  assert.ok(migration.includes("v_run_new.approved_by:=NULL"));
  assert.ok(migration.includes("v_run_new.metadata:='{}'::jsonb"));
  assert.ok(migration.includes("v_alert_new.acknowledged_by:=NULL"));
  assert.ok(migration.includes("v_recount_new.reviewed_by:=NULL"));
});

test("Auditor evidence storage remains private and grants read only to registered project evidence", () => {
  const migration = read("database/migrations/20261124182400_countflow_auditor_evidence_read_v1.sql");
  assert.ok(migration.includes("bucket_id = 'counting-evidence'"));
  assert.ok(migration.includes("counting_private.is_platform_owner()"));
  assert.ok(migration.includes("counting_private.is_auditor"));
  assert.ok(migration.includes("FROM public.count_entry_images"));
  assert.ok(migration.includes("NOT counting_private.is_platform_owner_actor(i.uploaded_by)"));
  assert.doesNotMatch(migration, /CREATE POLICY|FOR INSERT|FOR UPDATE|FOR DELETE/);
});

test("Control team monitor reads realtime presence, device status, current location and pending sync queue", () => {
  const control = read("countflow-control.html");
  assert.ok(control.includes("from('count_presence')"), "Live presence must be read from the session scope");
  assert.ok(control.includes("from('count_devices')"), "Registered device state must be read from the project scope");
  assert.ok(control.includes("pending_queue_count"), "Pending offline queue count must be visible");
  assert.ok(control.includes("current_location_id"), "Current field location must be visible");
  assert.ok(control.includes("device_label,platform,app_version,status,last_seen_at"), "Device model and version must be displayed");
  assert.ok(control.includes("Promise.all([refreshMonitor(true),loadAlerts(),loadSessionTeam()])"), "Realtime refresh must refresh all live Control panels");
  assert.ok(control.includes("document.hidden&&state.session"), "Background tabs must not run unnecessary polling");
});

test("authenticated clients cannot select platform-owner identity columns from projects or sessions", () => {
  const migration = read("database/migrations/20261124184000_countflow_hide_owner_actor_columns_from_clients_v1.sql");
  assert.match(migration, /REVOKE SELECT ON TABLE public\.count_projects FROM PUBLIC, anon, authenticated/);
  assert.match(migration, /GRANT SELECT \(id,name,code,status,created_at,updated_at\)[\s\S]*ON TABLE public\.count_projects TO authenticated/);
  assert.match(migration, /REVOKE SELECT ON TABLE public\.count_sessions FROM PUBLIC, anon, authenticated/);
  assert.match(migration, /id,project_id,name,status,started_at,closed_at,created_at,updated_at,[\s\S]*sync_barrier_version,queue_barrier_action,queue_barrier_run_id,queue_barrier_requested_at/);
  assert.match(migration, /ON TABLE public\.count_sessions TO authenticated/);
  assert.doesNotMatch(migration, /GRANT SELECT ON TABLE public\.count_projects TO authenticated/);
  assert.doesNotMatch(migration, /GRANT SELECT ON TABLE public\.count_sessions TO authenticated/);

  const admin = read("countflow-admin.html");
  const counter = read("countflow.html");
  const supervisor = read("Countflow-supervisor.html");
  const control = read("countflow-control.html");
  assert.ok(admin.includes("count_projects').select('id,client_id,name,code,status,created_at,updated_at')"));
  assert.doesNotMatch(admin, /count_projects'\)\.select\([^)]*created_by/);
  assert.ok(admin.includes("count_sessions').select('id,project_id,name,status,started_at,closed_at,created_at,updated_at"));
  assert.ok(counter.includes("count_projects').select('id,name,code,status,created_at,updated_at')"));
  assert.ok(counter.includes("count_sessions').select('id,project_id,name,status,started_at,closed_at,created_at,updated_at"));
  assert.ok(supervisor.includes("fetchAllRows('count_projects','id,name,code,status,created_at,updated_at'"));
  assert.ok(control.includes("count_projects').select('id,name,code,status,created_at'"));
  assert.doesNotMatch([admin,counter,supervisor,control].join("\\n"), /count_projects'\)\.select\('\*'\)|count_sessions'\)\.select\('\*'\)/);
});

test("Supervisor lists only active supervisor project scopes and deletes one assignment row by ID", () => {
  const supervisor = read("Countflow-supervisor.html");
  assert.ok(supervisor.includes("supervisorMemberships=supervisors"), "Active supervisor memberships must be retained as the authorization scope");
  assert.ok(supervisor.includes(".filter(x=>x.role==='supervisor'&&x.status==='active').map(x=>x.project_id)"), "Only active supervisor project IDs may be loaded");
  assert.ok(supervisor.includes("fetchAllRows('count_projects','id,name,code,status,created_at,updated_at',[{op:'in',key:'id',value:allowedProjectIds}])"), "Project visibility in the UI must match supervisor memberships");
  assert.ok(supervisor.includes("data-remove-assignment=\"'+x.id+'\""), "The action must carry one assignment primary key");
  assert.ok(supervisor.includes(".delete().eq('id',b.dataset.removeAssignment).eq('session_id',session.id)"), "The delete must target one assignment row and stay session-scoped");
  assert.doesNotMatch(supervisor, /\.delete\(\)\.eq\('session_id',session\.id\)\.eq\('member_id',b\.dataset\.removeAssignment\)/, "Do not delete all assignment rows for the same member in a session");
});

test("other owner actor columns remain inaccessible while operational columns stay readable", () => {
  const migration = read("database/migrations/20261124184500_countflow_hide_owner_actor_audit_columns_v1.sql");
  const restricted = [
    ["count_presence", "queue_resolved_by"],
    ["count_devices", "revoked_by"],
    ["count_recount_tasks", "created_by"],
    ["count_recount_tasks", "reviewed_by"],
    ["count_reconciliation_runs", "created_by"],
    ["count_reconciliation_runs", "approved_by"],
    ["count_reconciliation_runs", "metadata"]
  ];
  for (const [table, column] of restricted) {
    assert.ok(migration.includes("REVOKE SELECT ON TABLE public." + table + " FROM PUBLIC, anon, authenticated"));
    assert.match(migration, new RegExp("GRANT SELECT \\([\\s\\S]*?\\) ON TABLE public\\." + table + " TO authenticated"));
    assert.ok(!new RegExp("GRANT SELECT \\([^)]*\\b" + column + "\\b[^)]*\\) ON TABLE public\\." + table).test(migration), "Restricted owner column must not be granted: " + table + "." + column);
  }
});


test("Admin operation creation is a dedicated modal with project scope and team assignment", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /id="operationCreateModal"/);
  assert.match(admin, /id="sessionProject"/);
  assert.match(admin, /id="sessionTeam"[^>]*multiple/);
  assert.match(admin, /async function openOperationCreateModal\(\)/);
  assert.match(admin, /newOperationButton'\)\.onclick=\(\)=>\{activateTab\('operations'\);openOperationCreateModal\(\);\}/);
  assert.match(admin, /from\('count_assignments'\)\.upsert\(assignmentRows,\{onConflict:'session_id,member_id,location_id'\}\)/);
  assert.match(admin, /branch_location_id:\$\('sessionBranch'\)\.value\|\|null/);
  assert.doesNotMatch(admin, /newOperationButton'\)\.onclick=\(\)=>\{[\s\S]{0,300}sessionForm'\)\.scrollIntoView/);
  assert.equal((admin.match(/id="sessionForm"/g) || []).length, 1);
  assert.equal((admin.match(/id="sessionTable"/g) || []).length, 1);
});

test("Admin overview uses live operation analytics and user-visible filters, without sample KPI data", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /from\('count_operation_overview'\)/);
  assert.match(admin, /async function loadAdminOverview\(\)/);
  assert.match(admin, /function renderAdminOverview\(\)/);
  for (const id of ["overviewProjectFilter", "overviewStatusFilter", "overviewFrom", "overviewTo", "overviewTotalOperations", "overviewEntryEvents", "overviewCoverage", "overviewStatusChart", "overviewPerformanceChart"]) {
    assert.ok(admin.includes('id="' + id + '"'), "Missing overview element: " + id);
  }
  assert.match(admin, /loadAdminOverview\(\)\.catch/);
});

test("Global catalogue keeps stable products and exposes owner-only edit and deactivate rather than delete", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /id="globalProductId"/);
  assert.match(admin, /data-edit-catalog=/);
  assert.match(admin, /data-catalog-state=/);
  assert.match(admin, /async function toggleCatalogProduct\(id\)/);
  assert.match(admin, /is_active:!p\.is_active/);
  assert.match(admin, /ستظل بياناته وروابطه التاريخية محفوظة/);
  assert.doesNotMatch(admin, /from\('count_catalog_products'\)\.delete/);
});

test("Admin roles and memberships have search, usage metrics, system-role read-only and scope filters", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /id="systemRoleList"/);
  assert.match(admin, /id="customRoleSearch"/);
  assert.match(admin, /const roleClientId=state\.platformOwner\?state\.roleClientId:state\.clientId/);
  assert.match(admin, /eq\(\x27client_id\x27,roleClientId\)/);
  assert.match(admin, /payload=\{client_id:\(state\.platformOwner\?state\.roleClientId:state\.clientId\)/);
  assert.match(admin, /data-clone-custom-role=/);
  assert.match(admin, /نظامي — للقراءة فقط/);
  assert.match(admin, /لا يمكن حذف الدور لأنه مرتبط بعضوية واحدة أو أكثر/);
  for (const id of ["memberTotalCount", "memberActiveCount", "memberPausedCount", "memberProjectFilter", "memberStatusFilter"]) {
    assert.ok(admin.includes('id="' + id + '"'), "Missing membership management element: " + id);
  }
});

test("Platform owner-only client administration, licensing and audit remain hidden as complete navigation surfaces", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /<section id="tab-clients" class="section" data-owner-only>/);
  assert.match(admin, /<section id="tab-license" class="section" data-owner-only>/);
  assert.match(admin, /<div class="nav-group" data-owner-only>/);
  assert.match(admin, /data-tab="license"[^>]*data-owner-only/);
  assert.match(admin, /قائمة البريد أدناه مخصصة للإشعارات فقط/);
});

test("Admin keeps operation register, per-file sessions, project catalog and global catalogue as distinct scopes", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /سجل عمليات الجرد — جميع ملفات التكليف/);
  assert.match(admin, /جلسات الجرد داخل ملف التكليف المحدد/);
  assert.match(admin, /قاعدة الأصناف العالمية/);
  assert.match(admin, /كتالوج أصناف الجهة \/ التكليف/);
  assert.match(admin, /id="sideToggle"/);
});

test("Admin script declarations remain syntactically unique after UI refactors", () => {
  const admin = read("countflow-admin.html");
  assert.doesNotMatch(admin, /function\s+([A-Za-z_$][\w$]*)\s*\([^)]*\)\s*function\s+\1/);
  assert.doesNotMatch(admin, /async\s+function\s+([A-Za-z_$][\w$]*)\s*\([^)]*\)\s*async\s+function\s+\1/);
});

test("Admin member role reassignment requires the database team-management permission and protects the last supervisor", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /rpc\('count_can_manage_project_members'/);
  assert.match(admin, /state\.memberManageProjects=new Set\(permissionChecks\.filter/);
  assert.match(admin, /data-save-member-role=/);
  assert.match(admin, /async function saveMemberRole\(memberId\)/);
  assert.match(admin, /state\.memberManageProjects\?\.has\(member\.project_id\)/);
  assert.match(admin, /count_members'\)\.update\(\{role:role\.role_key,role_id:role\.id\}\)/);
  assert.match(admin, /لا يمكن تغيير دور آخر مشرف نشط/);
  assert.match(admin, /لا يمكن تغيير دور حسابك الحالي/);
});

test("Platform owner custom-role scope is explicitly selected and client administrators remain client-bound", () => {
  const admin = read("countflow-admin.html");
  assert.match(admin, /id="roleClientScope"/);
  assert.match(admin, /state\.platformOwner\?state\.roleClientId:state\.clientId/);
  assert.match(admin, /roleClientScope'\)\.addEventListener\('change'/);
  assert.match(admin, /roleClientScope'\)\.value=x\.data\.id/);
  assert.match(admin, /r\.client_id===\(state\.roleClientId\|\|state\.clientId\)/);
});
