---
name: bundle-try-app
description: Use to prove a Bundle Events change works in the running app, or to reproduce a bug a traveller sees.
---

# Bundle try app

Use the app the way a traveller does and keep the evidence. Passing unit tests
and a green build do not show that the page works. To add a permanent test,
use `bundle-e2e-flow`.

Decide about storage before you open anything. `POST /api/bundles` inserts a
real row in the Supabase project that `.env` names, and fails without the
Supabase keys. Opening a saved link also writes: the page sends a PATCH 600 ms
after it loads. Never open a traveller's UUID against a shared project.

If that project is safe to write to, use the browser your harness has against
`npm run dev` on port 3000. Otherwise write a throwaway spec in e2e/ that keeps
the submitted `data` from POST and PATCH and returns it on GET. Run it with
`npm run test:e2e -- <spec>` and delete it before committing. If Playwright
reports a missing executable, run `npx playwright install chromium`.

Playwright starts its own server on port 3100 and locally reuses whatever
already listens there, so check that it serves your branch. Next allows one dev
server per checkout, so it fails while `npm run dev` runs. Work in a separate
worktree or ask first, and never kill a server you did not start.

The stubs in e2e/home-flow.spec.ts are incomplete. Event search, stations,
flights, buses, prices and, with keys, trains still reach the dev server,
which calls real providers. In a throwaway spec, register a `**/api/**`
catch-all that answers 503 first, then the specific stubs, since the last
matching route wins. Stub `/api/events/search` with `{ eventSource: null,
venues: [...] }`, or no venue can be picked. The browser also calls other
hosts directly, such as data.geopf.fr and router.project-osrm.org, so list the
hosts your run reached.

Read the current spec for the handles before you copy these: the placeholders
"Adresse, gare ou ville" and "Salle, stade, festival…", the buttons "Quand ?",
"Valider les dates" and "Voir mon voyage", then `/{uuid}/voyage` and
`/{uuid}/reserver`.

Cover what the change can touch: round trip, one way and same day. Then check
what breaks most often here:

- Reload the page. Wait more than 600 ms after the last change, which is the
  save delay.
- Open the link in a fresh browser context, as the recipient does. It inherits
  no stub, so register the same ones there with `context.route`, sharing one
  store.
- Delay `POST /api/bundles` by 8 seconds. #159 lost the hotel only while the
  bundle was being created.

With real providers, read `X-Data-Source` on hotels and prices and `X-Cache` on
cached routes, so a fallback does not pass for a success. Each call spends
quota. Send an email only when the user asks, to the address they give, and
never complete a booking.

For a bug, reproduce it before you change code, then run the same steps after
the fix. Report the steps, a screenshot of the action and of the result, the
saved data when it matters, and every case you did not run.
