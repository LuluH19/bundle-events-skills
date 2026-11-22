---
name: bundle-snapshot-field
description: Add, rename or remove a field of the persisted BundleSnapshot without breaking saved and shared trips. Use for any change to what a Bundle Events trip stores.
---

# Bundle snapshot field

`BundleSnapshot` is the only persisted object, stored as JSONB in the `bundles.data` column. Every shared link points at one, and old rows are never migrated. Read docs/architecture/state-and-persistence.md and docs/database/schema.md first.

1. Make the new field optional in the type and define what its absence means, as `preference` (absent means `"fast"`) and `hotelOptIn` do. Never rename or retype a stored key in place. Add the new key and keep reading the old one.
2. Write it in `buildSnapshot()` in src/components/BundleBuilder.tsx and read it during hydration with the default for old rows.
3. Persist before navigating. An action that selects something and calls `router.push` in the same click must save the value explicitly first, because each step change remounts BundleBuilder.
4. Check the trip cache in src/utils/trip-cache.ts carries the field between home and voyage, so it does not vanish until the next Supabase load.
5. Do not store anything that can be rebuilt live or that is sensitive. IATA codes, SNCF IDs and schedules are deliberately not persisted.
6. Test with a snapshot that lacks the field, such as `SAVED_BUNDLE` in e2e/home-flow.spec.ts, and one that has it. Cover reload and opening the link in a fresh context.
7. Update the snapshot table in docs/architecture/state-and-persistence.md and the `data` shape in docs/database/schema.md.
