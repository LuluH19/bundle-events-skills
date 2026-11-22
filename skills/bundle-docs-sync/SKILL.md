---
name: bundle-docs-sync
description: Update the French docs/ folder and AGENTS.md in the same change as a Bundle Events behavior, API, env or structure change. Use before committing or when asked to sync docs.
---

# Bundle docs sync

The team convention says docs are part of "done". Read docs/README.md for the index.

1. List what the diff changes: routes, query parameters, response fields, headers, env variables, cache durations, thresholds, snapshot fields, fallback order, UI flow, tests.
2. Map each one to its page: docs/api/ for routes and providers, docs/architecture/ for cache, routing and persistence, docs/database/schema.md for stored shapes, docs/features/ for hotels, booking links, sharing, routing and the user flow, docs/getting-started/environment.md and .env.example for env variables, docs/contributing/conventions.md for test lists and conventions, docs/design/design-system.md for tokens.
3. Edit those pages in French, matching their tone and table formats. Describe current behavior, not the history of the change, except for a ticket reference like the existing "(#148)".
4. Fix stale statements you touch. docs/architecture/overview.md already notes that AGENTS.md lists a src/hooks/ folder that does not exist.
5. Check every path and symbol you mention exists with `rg`, and that relative links resolve.

Commit docs with the code they describe, not in a later PR.
