---
name: bundle-security
description: Use before opening or reviewing any Bundle Events PR, when a secret or API key may be exposed, when adding or changing an API route, or to run a red-team exercise against our own running app. Covers the secret-leak gate, the server/client boundary, route handlers, Supabase and the red-team arsenal.
---

# Bundle security

Two jobs: a **blue-team gate** on every change, and **red-team exercises** against our
own running app. Both only ever target assets we own (see Scope). This complements
Claude Code's built-in `/security-review`; it adds project knowledge and the arsenal.

Read docs/getting-started/environment.md, src/lib/supabase/server.ts, src/lib/api-cache.ts
and src/__tests__/hotfix-security.test.ts first. The route handlers are the 16 files under
src/app/api/*/route.ts.

## Blue team — run on every branch and PR

**1. Secret leak (our most frequent miss).**
- No real secret in the diff or the repo. `.env*` is gitignored except `.env.example`, which
  holds only placeholders. Scan the working tree and the history, not just the diff:
  `npx --yes gitleaks@8 detect --no-banner` and `git log -p -- .env .env.local | grep -i key`.
- `NEXT_PUBLIC_*` ships to the browser, so it is only for values that are public by design:
  `NEXT_PUBLIC_MAPBOX_TOKEN` (must be URL-restricted in Mapbox), `NEXT_PUBLIC_SITE_URL`,
  `NEXT_PUBLIC_SUPABASE_URL`. A secret must never gain a `NEXT_PUBLIC_` prefix. The
  server-only secrets are `SUPABASE_SERVICE_ROLE_KEY`, `BREVO_API_KEY`, `SNCF_API_KEY`,
  `LITEAPI_KEY`, `TICKETMASTER_API_KEY`, `TRAVEL_PAYOUTS_API_KEY`, `POSTHOG_PROJECT_TOKEN`.
- If a secret is already committed, flag it in the PR and keep it out of the merge. We are
  prioritising speed for now, so do not force a rotation / history-clean pass here; note it as
  a follow-up to decide later.

**2. Server / client boundary.** Secrets are read only in server code. `src/lib/api-cache.ts`
and `src/lib/posthog-logs.ts` import `server-only`; `getSupabaseAdmin` (service role, which
bypasses Row Level Security) lives in src/lib/supabase/server.ts and must never reach a Client
Component or a `NEXT_PUBLIC_` path. A route must not echo an env var or a raw upstream error
back to the client.

**3. Route handlers.** For every new or changed route under src/app/api, check: inputs are
validated and bounded before use (guard `request.json()` in a try/catch and reject a bad
shape with 400, as src/app/api/bundles/route.ts does; validate ids with `isUuid`, coordinates
and dates as numbers/ISO); a timeout on every outbound `fetch` (see bundle-route-guard);
errors log server-side but return a generic message. The booking routes
(src/app/api/booking/{train,bus}/route.ts) build and `redirect()` to an external URL from
user input — keep the host fixed (Trainline, FlixBus, Google Maps), never redirect to an
arbitrary attacker-supplied URL (open redirect), and treat any server-side fetch of a
user-controlled URL as SSRF: no internal hosts, no `169.254.169.254`.

**4. XSS and output.** Names rendered in MapLibre popups go through `escapeHtml`
(src/utils/format.ts); keep it. No `dangerouslySetInnerHTML`. Images use `next/image` with a
real or empty `alt`.

**5. Access and data.** A bundle is readable by UUID by design (the share link). That is the
only authorization model today, so a route must not expose more than the shared snapshot, and
UUIDs must stay unguessable v4 (`isUuid`). When accounts land (US135), re-check that a user
only reads their own bundles and that Supabase RLS, not just route code, enforces it, since
the service role bypasses RLS.

**6. Dependencies.** CI runs `npm audit --audit-level=high`; keep the lockfile and the
Dependabot PRs moving. Adding a dependency is a security decision — justify it in the PR.

**Gap to close:** CI has no secret scanner. Proposing a `gitleaks` step in
.github/workflows/ci.yml is the highest-value fix for our recurring key-in-clear problem.

## Red team — exercise our own defence

The arsenal is ../../security/arsenal (Claude-BugHunter, see ../../security/ATTRIBUTION.md):
84 hunting skills under security/arsenal/skills, indexed by security/arsenal/skills/bug-bounty
and security/arsenal/README.md.

**Scope — do not skip.** Point the arsenal only at assets we own and may test: the app on
`npm run dev` at localhost, or a Vercel preview / Supabase project that is ours, with test
data. Never a third party, never production belonging to someone else. The upstream APIs we
call (Mapbox, SNCF, LiteAPI, Ticketmaster, Trainline, Brevo…) are third parties: attack our
endpoints that wrap them, never the providers. No real users' data in a test run.

Pick the arsenal skill that matches our stack and run its recipes against our target, then
fix and re-run:
- `hunt-source-leak` — source maps, `.env`, `.git`, `/_next/static` on a deployed preview.
- `hunt-nextjs` — `/_next/image` SSRF, middleware bypass, RSC/`__NEXT_DATA__` leakage.
- `hunt-ssrf` — our proxy and search routes that fetch or redirect from user input.
- `hunt-idor` — bundle UUID access and enumeration.
- `hunt-nodejs`, `hunt-xss`, `hunt-cors`, `hunt-open-redirect` — the booking redirects and
  JSON APIs. `hunt-oauth` / `hunt-session` once accounts exist.

## Fix, prove, keep improving

For each confirmed finding: fix it on a branch, add a regression test in the style of
src/__tests__/hotfix-security.test.ts (or a Playwright case via bundle-e2e-flow), update the
relevant docs/, and have it re-checked with bundle-review or bundle-council. When you meet a
new weakness class, add a line to the blue-team list above in the same PR, so the gate grows
with each attack we survive.
