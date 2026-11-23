---
name: bundle-new-provider
description: Use when integrating a new events, hotel, transport or pricing API into Bundle Events.
---

# Bundle new provider

Read AGENTS.md, docs/architecture/overview.md and docs/api/external-apis.md.
Copy the shape of the closest sibling: src/adapters/events/ for events and
venues, src/adapters/hotels/ for hotels, src/adapters/prices/ for fares.

Add `src/config/<provider>.ts` with the base URL, the env lookup and a
`timeoutMs`, and export it from src/config/index.ts. Secrets stay on the
server, and only `NEXT_PUBLIC_*` values may reach the browser.

Write the adapter to map the raw payload to the internal types in src/types.
Parse defensively at this boundary only. Throw on a transport or HTTP failure,
so the fallback chain and the cache can react.

Call the adapter from a route handler under src/app/api/, validate the query
and return 400 for bad input, and wrap the call with the shared cache from
`bundle-api-cache`. Decide where the provider sits in the existing chain, such
as Ticketmaster, OpenAgenda, then Open Data IDF for events, and test that a
failure moves to the next source. Components call a function in src/services/,
which fetches the internal route. They never call the provider directly.

Add sanitized payloads covering a normal, an empty and a partial response to
src/__tests__/providers.test.ts or a sibling, plus a fallback case. Update
docs/api/external-apis.md, docs/api/internal-routes.md,
docs/getting-started/environment.md, .env.example and the API list in
AGENTS.md.

Run `npm run lint`, `npm run typecheck` and `npm test`. Never commit a real
key or a payload containing one.
