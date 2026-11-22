---
name: bundle-env-check
description: Diagnose Bundle Events environment variables locally or on Vercel: missing keys, wrong values, quotas and fallbacks triggered by config. Use when a feature works locally but not in preview or production.
---

# Bundle env check

Read docs/getting-started/environment.md, .env.example and src/config/.

1. List the variables the code reads with `rg "process.env" src next.config.ts` and compare with .env.example and the docs table. Report variables used but undocumented, and documented but unused.
2. For the failing feature, find the variable it depends on and its fallback when absent. Examples: no `TICKETMASTER_API_KEY` moves events to OpenAgenda, no `BREVO_API_KEY` stubs email, `LITEAPI_KEY` falls back to sandbox, no Supabase means memory-only cache.
3. Check client exposure. Only `NEXT_PUBLIC_*` values may be read in browser code, and `SUPABASE_SERVICE_ROLE_KEY` must stay server-only.
4. Vercel pitfalls: quotes kept literally in values (see `EMAIL_FROM`), preview and production with different values, and variables added after the last deploy that need a redeploy.
5. Quotas: an `API_DAILY_LIMIT_*` set too low makes routes answer from cache or fallback only. Compare with the `api_usage` counts.

Never print secret values. Report a variable as set, empty or missing.
