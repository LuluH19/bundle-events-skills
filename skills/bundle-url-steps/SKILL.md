---
name: bundle-url-steps
description: Change Bundle Events routes, steps or URL segments while keeping every shared link working. Use when adding a step, renaming a segment like voyage or reserver, or debugging a 404 on a shared link.
---

# Bundle url steps

Read docs/architecture/routing-and-urls.md, src/types/step.ts, src/app/[uuid]/[[...step]]/page.tsx and src/utils/uuid.ts.

Rules:

- One client component, BundleBuilder, renders every page with a `step` prop. `/` is home, `/{uuid}` is home for an existing trip, `/{uuid}/voyage` is trip and `/{uuid}/reserver` is book.
- Shared links live forever. A renamed or removed segment gets a 307 redirect to its replacement, as `hotels`, `routes-outbound`, `routes-return` and `bundle` already do. Never turn an old segment into a 404.
- A malformed UUID returns `notFound()`. A valid but unknown UUID must offer a new search, not crash.
- `params` is awaited (Next 16). Check node_modules/next/dist/docs/ before using a routing API, as AGENTS.md requires.
- `go(step)` writes the trip cache and saves in the background before `router.push`. A new step must follow the same path.

Verify each old and new segment on `npm run dev` with a real UUID: status code, final URL and rendered step. Update the steps table and redirect list in the doc.
