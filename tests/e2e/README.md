# CountFlow browser E2E

The suite is non-destructive by default. The public production-login-shell smoke opens the deployed master login without authenticating and checks the owner login UI. The authenticated Supervisor and Counter workspaces require existing CountFlow test accounts. The scan test increments the draft quantity but deliberately never clicks Save, so it does not create a count entry.

## Run from repository root

```bash
npm --prefix tests/e2e install
npx --prefix tests/e2e playwright install chromium
npm --prefix tests/e2e run test:e2e
```

Set these environment variables before running:

- `COUNTFLOW_BASE_URL`: deployed standalone CountFlow origin, without a trailing slash.
- `COUNTFLOW_SUPERVISOR_EMAIL`, `COUNTFLOW_SUPERVISOR_PASSWORD`: active CountFlow supervisor account.
- `COUNTFLOW_COUNTER_EMAIL`, `COUNTFLOW_COUNTER_PASSWORD`: active CountFlow counter account.
- Optional scan test: `COUNTFLOW_TEST_LOCATION_CODE` and `COUNTFLOW_TEST_PRODUCT_BARCODE`. The counter must be assigned to that location and the product must belong to its project.

The canonical app paths are `/Countflow-supervisor.html` and `/countflow.html`. The standalone repository no longer uses `/companies/company-2/Counting/Counter*.html`.

GitHub Actions run 44941845028 passed the public production-login-shell test against https://rawaea-app-countflow.pages.dev (1 passed). The authenticated supervisor/counter tests were discovered but remain unexecuted because there are no confirmed project members, assigned test location/product, or approved CI credentials. Do not put passwords in source control; use environment variables or CI secrets.
