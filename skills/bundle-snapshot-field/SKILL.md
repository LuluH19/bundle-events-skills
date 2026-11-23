---
name: bundle-snapshot-field
description: Use for any change to what a Bundle Events trip stores in its BundleSnapshot.
---

# Bundle snapshot field

`BundleSnapshot` is the only persisted object, stored as JSONB in the
`bundles.data` column. Every shared link points at one, and old rows are never
migrated. Read docs/architecture/state-and-persistence.md and
docs/database/schema.md first.

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
