---
name: bundle-snapshot-field
description: Use for any change to what a Bundle Events trip stores in its BundleSnapshot, when reloading or sharing a UUID link loses a selection or opens the wrong step, when a shared link returns a 404, or when adding or renaming a step such as voyage or reserver.
---

# Bundle snapshot field

`BundleSnapshot` is the only persisted object, stored as JSONB in the
`bundles.data` column. Every shared link points at one, and old rows are never
migrated. Read docs/architecture/state-and-persistence.md and
docs/database/schema.md first.

`Location`, `RouteOption`, `HotelMapItem` and `BookedState` are stored inside
the snapshot (src/types/bundle.ts), so changing one of those types changes old
links too.

Make the new field optional in the type and define what its absence means, as
`preference` (absent means `"fast"`) and `hotelOptIn` do. Never rename or
retype a stored key in place. Add the new key and keep reading the old one. If
the server validates snapshot fields, as PR #199 does with
`validateBundleData` in src/utils/bundle-validation.ts, allow the new key
there too, or POST and PATCH reject it with a 400.

Write the field in `buildSnapshot()` in src/components/BundleBuilder.tsx and
read it during hydration with the default for old rows. An action that selects
something and calls `router.push` in the same click must save the value
explicitly first, because each step change remounts BundleBuilder. Check that
the trip cache in src/utils/trip-cache.ts carries the field from home to
voyage.

Do not store anything that can be rebuilt live or that is sensitive. IATA
codes, SNCF IDs and schedules are deliberately not persisted.

Test with a snapshot that lacks the field, such as `SAVED_BUNDLE` in
e2e/home-flow.spec.ts, and one that has it, covering a reload and opening the
link in a fresh context. Update the snapshot table in
docs/architecture/state-and-persistence.md and the `data` shape in
docs/database/schema.md.

## A reload or share loses a selection

Pin the UUID route, the starting step, the user action and the first field
that changes unexpectedly. Compare three snapshots: the state just before
saving, the data returned when loading the UUID, and the selection rendered
after hydration. The read and write path is in src/app/[uuid]/[[...step]] and
src/services/bundles.ts.

Reuse the stubs in e2e/home-flow.spec.ts with a synthetic UUID. Make the save
stub keep the submitted data and the load stub return it, because a constant
response hides a broken save. Open a shared link in a fresh browser context,
and reproduce a reload in the same context. After switching to one way, check
that a stale return leg does not reappear. Assert the visible step and the
affected selection after the round trip. Run the case with `npm run test:e2e
-- <spec>` and report the first snapshot that diverges.

## Steps and shared URLs

Read docs/architecture/routing-and-urls.md, src/types/step.ts,
src/app/[uuid]/[[...step]]/page.tsx and src/utils/uuid.ts. One client
component, BundleBuilder, renders every page with a `step` prop. `/` is home,
`/{uuid}` is home for an existing trip, `/{uuid}/voyage` is the trip and
`/{uuid}/reserver` is booking.

Shared links live forever. A renamed or removed segment gets a 307 redirect to
its replacement, like the ones the doc lists. Never turn an old segment into a
404. A malformed UUID returns `notFound()`, and a valid but unknown UUID must
offer a new search rather than crash.

`params` is awaited in Next 16. Check node_modules/next/dist/docs/ before
using a routing API, as AGENTS.md requires. `go(step)` writes the trip cache
and saves in the background before `router.push`, and a new step must follow
the same path. Verify each old and new segment on `npm run dev` with a real
UUID: the status code, the final URL and the rendered step. Update the steps
table and the redirect list in the doc.
