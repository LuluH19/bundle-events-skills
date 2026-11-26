---
name: bundle-e2e-flow
description: Use when a Bundle Events bug or feature needs a deterministic Playwright test.
---

# Bundle e2e flow

Read e2e/home-flow.spec.ts and playwright.config.ts, and reuse their stubs:
the minimal valid Mapbox style (an empty object crashes mapbox-gl), the
geocoding and Search Box responses, `/api/hotels/search`, and the saved bundle
with a synthetic UUID.

Describe the flow as user actions with one visible outcome per step. Stub
every external boundary and every internal `/api/*` call the flow hits, so the
test runs offline and never spends provider quota. A test that reaches a real
provider is a bug. The existing spec still has this bug: its event search,
stations, flights, buses, prices and, with keys, trains reach the dev server.
Add a `**/api/**` catch-all before your stubs to see what escapes.

For save and load, make the save stub keep the submitted data and the load
stub return it. A constant response hides broken saves. Assert what the user
sees, such as the step, the selected hotel, totals and buttons, not internal
state.

Add the case to the existing spec or a sibling file in e2e/, and list it in
docs/contributing/conventions.md. Run `npm run test:e2e -- <spec>` three times
to rule out flakiness, and once with the fix reverted to confirm it fails.
