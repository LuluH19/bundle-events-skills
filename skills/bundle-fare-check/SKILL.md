---
name: bundle-fare-check
description: Use when a Bundle Events fare, hotel subtotal or trip total disagrees across screens or legs.
---

# Bundle fare check

Pin down one example with its travel dates, trip direction, selected legs,
hotel stay, and the two amounts being compared. Read AGENTS.md, then trace the
displayed values back through their callers of src/services/prices.ts and
src/utils/price-leg.ts, checking which functions actually take part in this
case.

Know the price chain in the "Prix des transports" section of
docs/features/transport-routing.md. Planes use Travelpayouts or a km estimate.
Trains try Trainline first only when `TRAINLINE_LIVE_PRICES=true`, since
DataDome blocks server IPs, then SNCF open data fares, then the client's
distance estimate when neither quotes. Buses use FlixBus or an estimate.
`bookableSpans` in src/utils/algorithms/price.ts prices the longest eligible
segment per ticketed mode, and on a mixed trip `isLongDistanceTicket` drops
feeder legs shorter than the configured minimum.

Reconcile against the exact display under investigation. A round-trip booking
button shows the outbound per-mode quote doubled (`linkPriceLabel` in
src/components/views/BookView.tsx), while the trip total in src/utils/trip.ts
adds the selected outbound and return prices separately. With an asymmetric
return fare, the two legitimately differ.

Build a small ledger with one row per selected component: raw amount, units,
quantity, source, conversion or rounding point, and contribution to the total.
Check whether a hotel quote already covers the stay and whether a return quote
already includes the outbound leg. Keep a missing quote distinct from an
explicit zero.

Recompute the example yourself and find the earliest disagreement between
quote, normalized amount and rendered total. For a fix, exercise the same
selection and the nearest contrasting case, such as switching a round trip to
one way. Start with `npm test -- src/__tests__/price.test.ts`. Report the
expected and observed totals with the line item responsible, or the missing
evidence if they cannot be reconciled.
