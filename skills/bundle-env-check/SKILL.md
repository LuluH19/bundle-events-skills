---
name: bundle-env-check
description: Use when a Bundle Events feature works locally but not in a Vercel preview or production.
---

# Bundle env check

Read docs/getting-started/environment.md, .env.example and src/config/.

List the variables the code reads with `rg "process.env" src next.config.ts`
and compare them with .env.example and the docs table. Report variables used
but undocumented, and documented but unused.

For the failing feature, find the variable it depends on and its fallback when
absent. Without `TICKETMASTER_API_KEY`, events move to OpenAgenda. Without
`BREVO_API_KEY`, email is stubbed. `LITEAPI_KEY` falls back to the sandbox.
Without Supabase, the cache runs in memory only.

Browser code may read only `NEXT_PUBLIC_*` values and the PostHog
`POSTHOG_PROJECT_TOKEN` and `POSTHOG_HOST`, which next.config.ts inlines at
build time. `SUPABASE_SERVICE_ROLE_KEY` must stay server-only. On Vercel, watch
for quotes kept literally in values (src/lib/email.ts strips them from
`EMAIL_FROM`, other variables are read as is), preview and production with
different values, and variables added after the last deploy that need a
redeploy. An `API_DAILY_LIMIT_*` set too low makes routes answer from cache or
fallback only, so compare it with the `api_usage` counts.

Never print secret values. Report each variable as set, empty or missing.
