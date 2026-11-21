import { test, expect } from "@playwright/test";

const supervisorEmail = process.env.COUNTFLOW_SUPERVISOR_EMAIL || "";
const supervisorPassword = process.env.COUNTFLOW_SUPERVISOR_PASSWORD || "";
const counterEmail = process.env.COUNTFLOW_COUNTER_EMAIL || "";
const counterPassword = process.env.COUNTFLOW_COUNTER_PASSWORD || "";
const baseUrl = process.env.COUNTFLOW_BASE_URL || "";

function requireEnv(...values: string[]) {
  if (values.some(value => !value)) test.skip(true, "CountFlow E2E environment is not configured.");
}

test.describe("CountFlow supervisor", () => {
  test("authenticates and exposes project controls and logout", async ({ page }) => {
    requireEnv(baseUrl, supervisorEmail, supervisorPassword);
    await page.goto("/Countflow-supervisor.html");
    await page.locator("#email").fill(supervisorEmail);
    await page.locator("#password").fill(supervisorPassword);
    await page.locator("#loginBtn").click();

    await expect(page.locator("#login")).toBeHidden({ timeout: 20000 });
    await expect(page.locator("#logout")).toBeVisible();
    await expect(page.locator("#app")).toBeVisible();
    await expect(page.locator("#tab-live")).toBeVisible();
  });
});

test.describe("CountFlow counter", () => {
  test("authenticates and loads the field-counting workspace", async ({ page }) => {
    requireEnv(baseUrl, counterEmail, counterPassword);
    await page.goto("/countflow.html");
    await page.locator("#email").fill(counterEmail);
    await page.locator("#password").fill(counterPassword);
    await page.locator("#loginBtn").click();

    await expect(page.locator("#login")).toBeHidden({ timeout: 20000 });
    await expect(page.locator("#logoutBtn")).toBeVisible();
    await expect(page.locator("#tab-count")).toBeVisible();
    await expect(page.locator("#barcode")).toBeVisible();
    await expect(page.locator("#location")).toBeVisible();
    await expect(page.locator("#quantity")).toBeVisible();
  });

  test("location barcode selection and repeated same-product scan increment quantity without saving", async ({ page }) => {
    const locationCode = process.env.COUNTFLOW_TEST_LOCATION_CODE || "";
    const productBarcode = process.env.COUNTFLOW_TEST_PRODUCT_BARCODE || "";
    requireEnv(baseUrl, counterEmail, counterPassword, locationCode, productBarcode);

    await page.goto("/countflow.html");
    await page.locator("#email").fill(counterEmail);
    await page.locator("#password").fill(counterPassword);
    await page.locator("#loginBtn").click();
    await expect(page.locator("#login")).toBeHidden({ timeout: 20000 });

    await page.locator("#barcode").fill(locationCode);
    await page.locator("#barcode").press("Enter");
    await expect(page.locator("#location")).not.toHaveValue("");

    await page.locator("#barcode").fill(productBarcode);
    await page.locator("#barcode").press("Enter");
    await expect(page.locator("#quantity")).toHaveValue("1");
    await page.locator("#barcode").fill(productBarcode);
    await page.locator("#barcode").press("Enter");
    await expect(page.locator("#quantity")).toHaveValue("2");

    // Deliberately do not click Save: this test is read-only against CountFlow data.
  });
});


test("production login shell deployment matches the source commit under test", async ({ request }) => {
  const expected = process.env.COUNTFLOW_EXPECTED_COMMIT || "";
  test.skip(!expected, "Source commit parity is checked only in CI.");
  const origin = baseUrl || "https://rawaea-app-countflow.pages.dev";
  await expect.poll(async () => {
    try {
      const response = await request.get(origin + "/build-info.json", { timeout: 10000 });
      if (!response.ok()) return "";
      const info = await response.json();
      return String(info.commit || "");
    } catch {
      return "";
    }
  }, {
    timeout: 360000,
    intervals: [3000, 5000, 10000, 15000],
    message: "Cloudflare Pages Production must publish the exact Git commit under test",
  }).toBe(expected);
});

test("production login shells render in RTL on mobile without authenticated sessions", async ({ browser }) => {
  const origin = baseUrl || "https://rawaea-app-countflow.pages.dev";
  const apps = [
    { path: "/countflow-admin.html", login: "#loginView" },
    { path: "/Countflow-supervisor.html", login: "#login" },
    { path: "/countflow.html", login: "#login" },
  ];
  for (const app of apps) {
    const context = await browser.newContext({ viewport: { width: 390, height: 844 } });
    const page = await context.newPage();
    await page.goto(origin + app.path, { waitUntil: "domcontentloaded" });
    await expect(page.locator(app.login)).toBeVisible({ timeout: 20000 });
    await expect(page.locator("#email")).toBeVisible();
    await expect(page.locator("#password")).toBeVisible();
    await expect(page.locator("#loginBtn")).toBeVisible();
    await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
    const formBounds = await page.locator(app.login).boundingBox();
    expect(formBounds?.width || 0).toBeGreaterThan(280);
    expect(formBounds?.left ?? formBounds?.x ?? -1).toBeGreaterThanOrEqual(0);
    expect((formBounds?.x ?? -1) + (formBounds?.width ?? 0)).toBeLessThanOrEqual(390);
    await context.close();
  }
});

test("production login shell renders without an authenticated session", async ({ page }) => {
  const origin = baseUrl || "https://rawaea-app-countflow.pages.dev";
  await page.goto(origin + "/countflow-admin.html");
  await expect(page.locator("#loginView")).toBeVisible({ timeout: 20000 });
  await expect(page.locator("#email")).toHaveValue("owner@rawaea.com");
  await expect(page.locator("#password")).toBeVisible();
  await expect(page.locator("#loginForm button[type=submit]")).toContainText("دخول آمن");
});
