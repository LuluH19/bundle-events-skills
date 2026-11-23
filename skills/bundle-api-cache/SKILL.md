---
name: bundle-api-cache
description: Use when routing a provider call through the shared API cache, or when X-Cache looks wrong.
---

# Bundle api cache

Read docs/architecture/api-cache.md, src/lib/api-cache.ts and
src/config/api-cache.ts first. The cache has three tiers: per-instance memory,
the Supabase `api_cache` table, then the provider `fetcher`. Identical
concurrent requests share one call.

Wrap the upstream call in `cached({ provider, key, ttlMs, staleMs, fetcher,
shouldStore })` inside the route handler, not in the client service. Build the
key as `<provider>:<normalized request>`. Round coordinates and normalize
dates the same way for every caller, and never put a key, token or email in
it.

Make the `fetcher` throw on failure. Returning `[]` silently disables the
stale fallback. Leave `shouldStore` at its default, which skips empty results,
unless an empty list is a real answer, as it is for events and venues.

Add the TTL and stale window to src/config/api-cache.ts and to the durations
table in the doc. For a new provider, add an `API_DAILY_LIMIT_<PROVIDER>` line
to .env.example and docs/getting-started/environment.md. Return the `X-Cache:
hit | miss | stale` header like the other routes.

When the cache misbehaves, repeated misses usually mean two callers build
different keys for the same request, so log both keys. A stale or empty answer
that never refreshes means the fetcher swallowed an error, the circuit breaker
is open after 3 failures for 60 seconds, or the daily quota in `api_usage` is
spent. A memory-only `[api-cache]` warning means Supabase is missing or the
`api_cache` and `api_usage` tables were never created. The migration file that
docs/database/schema.md names is not committed, so check the tables in
Supabase directly.

Verify with `npm test -- src/__tests__/api-cache.test.ts` and, for a route,
two identical requests against `npm run dev` that show `miss` then `hit`.
