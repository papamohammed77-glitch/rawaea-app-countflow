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
