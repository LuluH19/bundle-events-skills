---
name: bundle-e2e-flow
description: Write or extend a deterministic Playwright test for a Bundle Events user flow with all external calls stubbed. Use when a bug or feature needs browser-level coverage.
---

# Bundle e2e flow

Read e2e/home-flow.spec.ts and playwright.config.ts. Reuse their stubs: the minimal valid Mapbox style (an empty object crashes mapbox-gl), the geocoding and Search Box responses, `/api/hotels/search`, and the saved bundle with a synthetic UUID.

1. Describe the flow as user actions and one visible outcome per step.
2. Stub every external boundary and every internal `/api/*` call the flow hits, so the test runs offline and never spends provider quota. A test that reaches a real provider is a bug.
3. For save and load, make the save stub keep the submitted data and the load stub return it. A constant response hides broken saves.
4. Assert what the user sees (step, selected hotel, totals, buttons), not internal state.
5. Add the case to the existing spec or a sibling file in e2e/, and add it to the test list in docs/contributing/conventions.md.

Run `npm run test:e2e -- <spec>` three times to rule out flakiness, and once with the fix reverted to confirm it fails.
