---
name: bundle-new-provider
description: Add a new external API to Bundle Events end to end, from config to adapter, route, cache, tests and docs. Use when integrating a new events, hotel, transport or pricing source.
---

# Bundle new provider

Read AGENTS.md, docs/architecture/overview.md and docs/api/external-apis.md. Copy the shape of the closest sibling: src/adapters/events/ for events and venues, src/adapters/hotels/ for hotels, src/adapters/prices/ for fares.

1. Config: add `src/config/<provider>.ts` with base URL and env lookup, and export it from src/config/index.ts. Secrets stay server-side. Only `NEXT_PUBLIC_*` values may reach the browser.
2. Adapter: map the raw payload to the internal types in src/types. Parse defensively at this boundary only. Throw on transport or HTTP failure so the fallback chain and the cache can react.
3. Route: call the adapter from a handler under src/app/api/. Validate query parameters and return 400 for bad input. Wrap the call with the shared cache (see bundle-api-cache).
4. Fallback: decide where the provider sits in the existing chain (for example Ticketmaster, OpenAgenda, Open Data IDF for events) and test that a failure moves to the next source.
5. Client: the component calls a function in src/services/, which fetches the internal route. Components never call the provider directly.
6. Tests: add sanitized payloads covering a normal, empty and partial response to src/__tests__/providers.test.ts or a sibling, plus a fallback case.
7. Docs and env: update docs/api/external-apis.md, docs/api/internal-routes.md, docs/getting-started/environment.md, .env.example and the API list in AGENTS.md.

Run `npm run lint`, `npm run typecheck` and `npm test`. Never commit a real key or a payload containing one.
