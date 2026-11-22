---
name: bundle-api-cache
description: Route a Bundle Events provider call through the shared API cache, or debug a hit, miss or stale answer. Use when adding a cached call, tuning a TTL, or when X-Cache looks wrong.
---

# Bundle api cache

Read docs/architecture/api-cache.md, src/lib/api-cache.ts and src/config/api-cache.ts first. The cache has three tiers: per-instance memory, the Supabase `api_cache` table, then the provider `fetcher`. Identical concurrent requests share one call.

## Adding or changing a cached call

1. Wrap the upstream call in `cached({ provider, key, ttlMs, staleMs, fetcher, shouldStore? })` inside the route handler, not in the client service.
2. Build the key as `<provider>:<normalized request>`. Round coordinates and normalize dates the same way for every caller, and never put a key, token or email in it.
3. Make the `fetcher` throw on failure. Returning `[]` silently disables the stale fallback.
4. Leave `shouldStore` at its default (empty results are not stored) unless an empty list is a real answer, as for events and venues.
5. Add the TTL and stale window to src/config/api-cache.ts and the durations table in the doc. If the provider is new, add an `API_DAILY_LIMIT_<PROVIDER>` line to .env.example and docs/getting-started/environment.md.
6. Return the `X-Cache: hit | miss | stale` header like the other routes.

## Debugging

- Repeated misses: two callers build different keys for the same request. Log both keys.
- A stale or empty answer that never refreshes: check whether the fetcher swallowed an error, whether the circuit breaker is open (3 failures, 60 s), or whether the daily quota is spent in `api_usage`.
- Memory-only warnings `[api-cache]`: Supabase is missing or the migration in supabase/migrations was never run.

Verify with `npm test -- src/__tests__/api-cache.test.ts` and, for a route, two identical requests against `npm run dev` that show `miss` then `hit`.
