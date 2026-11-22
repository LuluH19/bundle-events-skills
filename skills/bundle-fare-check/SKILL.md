---
name: bundle-fare-check
description: Reconcile a Bundle Events fare, hotel subtotal, or displayed trip total when amounts disagree across screens or journey legs.
---

Pin down one example with its travel dates, trip direction, selected legs, hotel stay, and the two amounts being compared. Read the app's AGENTS.md. Trace the displayed values back to their callers of src/services/prices.ts and src/utils/price-leg.ts, checking which functions actually participate in this case.

Know the price source chain in docs/features/transport-routing.md ("Prix des transports"): Travelpayouts or a km estimate for planes, for trains, Trainline first only when `TRAINLINE_LIVE_PRICES=true` (DataDome blocks server IPs), then SNCF open data fares, then the client's distance estimate when neither quotes, and FlixBus or an estimate for buses. `bookableSpans` (src/utils/algorithms/price.ts) prices the longest eligible segment per ticketed mode: on a mixed trip, `isLongDistanceTicket` drops feeder legs shorter than the configured minimum. Reconcile against the exact display under investigation: a round-trip booking button shows the outbound per-mode quote doubled (`linkPriceLabel` in src/components/views/BookView.tsx), while the trip total in src/utils/trip.ts adds the selected outbound and return prices separately. With an asymmetric return fare the two legitimately differ.

Build a small ledger with a row per selected component. Record the raw amount, units, quantity, source (provider or estimate), conversion or rounding point, and contribution to the total. Derive quantities from the inputs the product supports. Check whether a hotel quote already covers the stay and whether a return quote already includes the outbound leg. Keep a missing quote distinct from an explicit zero.

Recompute the example independently. Identify the earliest disagreement between quote, normalized amount, and rendered total. For a requested fix, exercise the same selection and the nearest contrasting case, such as switching a round trip to one way. Start with npm test -- src/__tests__/price.test.ts and check the consumer that showed the discrepancy. Report expected and observed totals with the line item responsible, or identify the missing evidence if they cannot be reconciled.
