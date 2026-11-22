---
name: bundle-hotels
description: Debug or change Bundle Events hotel search, fallback and automatic hotel choice. Use when hotels are missing, unpriced, far from the venue, or the wrong one is picked.
---

# Bundle hotels

Read docs/features/hotels.md, src/app/api/hotels/search/route.ts, src/adapters/hotels/ and `pickHotel` in src/utils/algorithms/recommend.ts.

Pin the case: venue coordinates, check-in and check-out dates, `preference`, and whether the trip is a same-day round trip (no hotel unless `hotelOptIn`).

1. Call `/api/hotels/search` on `npm run dev` with the same query and read `X-Data-Source` (`liteapi`, `liteapi-venue`, `overpass`, `none`) and `X-Cache`. This tells you which link of the chain answered.
2. LiteAPI: check dates are `YYYY-MM-DD`, the radius cap, and that `pricePerNight` uses the right number of nights. Rate conditions (refundable, free cancellation until, board) come from the cheapest rate.
3. Fallbacks: hotels already seen around the venue (no price), then Overpass (no price, "Prix indisponible"), then empty. Both adapters must throw on failure, not return `[]`.
4. Choice: `pickHotel` prefers priced hotels and nearby ones. Changing dates re-picks the hotel and resets "Réservé" states.

Reproduce in src/__tests__/hotels-fallback.test.ts or recommend.test.ts with sanitized payloads. Update docs/features/hotels.md if the chain or the pick rule changes.
