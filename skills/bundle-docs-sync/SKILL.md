---
name: bundle-docs-sync
description: Use before committing a Bundle Events change to behavior, an API, an env variable or the structure, or when asked to sync docs.
---

# Bundle docs sync

The team convention says docs are part of "done". Read docs/README.md for the
index.

List what the diff changes: routes, query parameters, response fields,
headers, env variables, cache durations, thresholds, snapshot fields, fallback
order, the UI flow and tests. Then map each item to its page. Routes and
providers live in docs/api/. Cache, routing and persistence live in
docs/architecture/. Stored shapes live in docs/database/schema.md. Hotels,
booking links, sharing, routing and the user flow live in docs/features/. Env
variables live in docs/getting-started/environment.md and .env.example. Test
lists and conventions live in docs/contributing/conventions.md, and tokens in
docs/design/design-system.md.

Edit those pages in French, matching their tone and table formats. Describe
the current behavior, not the history of the change, except for a ticket
reference like the existing "(#148)". Fix stale statements you touch, such as
the src/hooks/ folder that AGENTS.md lists but that does not exist.

Check that every path and symbol you mention exists with `rg`, and that
relative links resolve. Commit the docs with the code they describe, not in a
later PR.
