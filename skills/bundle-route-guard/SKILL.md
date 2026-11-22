---
name: bundle-route-guard
description: Harden a Bundle Events API route: upstream timeouts, input validation, error responses and abuse limits. Use when adding or touching a route under src/app/api, or after a provider hung or a route was abused.
---

# Bundle route guard

Read the route, its config in src/config/, and docs/api/internal-routes.md.

1. Timeouts: every server-side `fetch` to a provider takes `signal: AbortSignal.timeout(<config>.timeoutMs)`, with the value in the provider's config file, as the adapters already do. On `origin/dev` several calls still have none, for example in src/lib/trainline.ts, src/lib/flixbus.ts, src/lib/sncf-stations.ts, src/app/api/flights/search/route.ts, src/app/api/trains/search/route.ts and src/app/api/trains/route-geometry/route.ts. Fix the one you touch.
2. Failure path: a timeout or HTTP error must throw inside the `cached()` fetcher so the stale fallback runs and nothing empty is stored. A route that cannot answer returns a clear status, as trains search does with `503 { degraded: true }`, and the client service must treat that as an outage, not as zero results.
3. Input: validate every query and body field (type, range, length, coordinates in bounds) against the formats that route already accepts. Dates differ per route: price routes accept both `YYYY-MM-DD` and `YYYY-MM-DDTHH:mm`, and the client sends a local date-time to trains search, so read the caller in src/services/ and docs/api/internal-routes.md before restricting a format and return 400 before any provider call. Dynamic UUIDs go through `isUuid` from src/utils/uuid.ts and return 404 when malformed. Cap radius and limit values the way hotel search caps its radius.
4. Abuse: for write routes, limit body size and request rate. If the helpers from PR #199 (`rate-limit.ts`, request body limit, `bundle-validation.ts`) are merged, reuse them. Otherwise do not write a second version, and flag it in the PR.
5. Errors: return a generic message (`{ error: "Database error" }`) and log details server-side. Never return provider error bodies, keys or a bundle's email.

Add a focused test that fails without the fix: a hung fetch that must time out and not be cached, or an invalid input that must return 400 without calling the provider. Include a valid request in the format the app really sends, so the guard does not reject real traffic. Update docs/api/internal-routes.md with new statuses and limits.
