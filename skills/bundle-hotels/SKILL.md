---
name: bundle-hotels
description: Use when Bundle Events hotels are missing, unpriced, far from the venue, or the wrong one is picked.
---

# Bundle hotels

Read docs/features/hotels.md, src/app/api/hotels/search/route.ts,
src/adapters/hotels/ and `pickHotel` in src/utils/algorithms/recommend.ts.

Pin the case: venue coordinates, check-in and check-out dates, `preference`,
and whether the trip is a same-day round trip, which has no hotel unless
`hotelOptIn` is set.

Call `/api/hotels/search` on `npm run dev` with the same query and read
`X-Data-Source` (`liteapi`, `liteapi-venue`, `overpass` or `none`) and
`X-Cache`. That tells you which link of the chain answered.

For LiteAPI, check that dates are `YYYY-MM-DD`, the radius cap, and that
`pricePerNight` uses the right number of nights. Rate conditions, such as
refundable, free cancellation and board, come from the cheapest rate. The
fallbacks are hotels already seen around the venue without a price, then
Overpass without a price ("Prix indisponible"), then an empty list. Both
adapters must throw on failure rather than return `[]`.

`pickHotel` prefers priced hotels and nearby ones. Changing dates re-picks the
hotel and resets the "Réservé" states.

Reproduce in src/__tests__/hotels-fallback.test.ts or recommend.test.ts with
sanitized payloads. Update docs/features/hotels.md if the chain or the pick
rule changes.
