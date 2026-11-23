---
name: bundle-provider-triage
description: Use when Bundle Events search results for events, venues, hotels or transport are missing or degraded.
---

# Bundle provider triage

Start with one failing query. Capture the search category, the coordinates or
place, the local dates, and what the traveller actually saw. Read AGENTS.md
and find the internal route in docs/api/internal-routes.md and the upstream
service in docs/api/external-apis.md.

Trace that request from the route handler through its service and adapter.
Compare three boundaries for the same input: the provider payload, the
normalized candidates, and the final filtered or merged result. A successful
HTTP response can still contain zero usable candidates. For a missing venue,
check city filtering and coordinate order. For an intermittent empty list,
check the cache key and whether a past failure filled it. Follow the fallback
order in the current code.

Replay with a small sanitized fixture at the first boundary that differs.
Exercise a valid result and the reported failure, such as an empty payload, a
missing field, a timeout or missing credentials. Keep unrelated providers
deterministic, and use the suites under src/__tests__, such as
venue-city.test.ts or hotels-fallback.test.ts, with `npm test -- <path>`.

Report the first boundary that lost the result, the fallback the traveller
received, and the evidence for each. Keep fixture evidence apart from what you
observed on the live provider.
