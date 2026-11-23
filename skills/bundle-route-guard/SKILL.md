---
name: bundle-route-guard
description: Use when adding or touching a Bundle Events API route, or after a provider hung or a route was abused.
---

# Bundle route guard

Read the route, its config in src/config/, and docs/api/internal-routes.md.

Every server-side `fetch` to a provider takes `signal:
AbortSignal.timeout(<config>.timeoutMs)`, with the value in that provider's
config file, as the adapters already do. Several calls still have none, for
example in src/lib/trainline.ts, src/lib/flixbus.ts, src/lib/sncf-stations.ts,
src/app/api/flights/search/route.ts, src/app/api/trains/search/route.ts and
src/app/api/trains/route-geometry/route.ts. Fix the one you touch.

A timeout or HTTP error must throw inside the `cached()` fetcher, so the stale
fallback runs and nothing empty is stored. A route that cannot answer returns
a clear status, as trains search does with `503 { degraded: true }`, and the
client service must treat that as an outage, not as zero results.

Validate every query and body field against the formats that route already
accepts, and return 400 before any provider call. Dates differ per route:
price routes accept both `YYYY-MM-DD` and `YYYY-MM-DDTHH:mm`, and the client
sends a local date-time to trains search, so read the caller in src/services/
before restricting a format. Dynamic UUIDs go through `isUuid` from
src/utils/uuid.ts and return 404 when malformed. Cap radius and limit values
the way hotel search caps its radius.

Limit body size and request rate on write routes. If the helpers from PR #199
are merged (`rate-limit.ts`, the request body limit and
`bundle-validation.ts`), reuse them. Otherwise do not write a second version,
and flag it in the PR. Return a generic error such as `{ error: "Database
error" }` and log the details on the server. Never return provider error
bodies, keys or a bundle's email.

Add a focused test that fails without the fix, such as a hung fetch that must
time out and not be cached, or an invalid input that must return 400 without
calling the provider. Include a valid request in the format the app really
sends, so the guard does not reject real traffic. Update
docs/api/internal-routes.md with new statuses and limits.
