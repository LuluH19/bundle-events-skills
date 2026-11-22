---
name: bundle-transport-routing
description: Debug or change how Bundle Events picks and builds transport options (car, walking, bus, train, plane, multimodal). Use when a mode is missing, a duration looks wrong, or a flight should be banned.
---

# Bundle transport routing

Read docs/features/transport-routing.md, src/utils/algorithms/routing.ts and `computeOptions` in src/services/travel.ts.

Pin the case: departure and venue coordinates, date and time constraints (`arriveBy`, `leaveAfter`), and which option is missing or wrong.

Walk the decision in order:

1. Mode thresholds on straight-line distance: walking under 8 km, car always, bus over 10 km, train over 20 km, plane over 200 km and not banned. Compute the distance first. Many "missing mode" reports sit just under a threshold.
2. Short-haul ban: `isShortHaulFlightBanned` applies when both points are in metropolitan France and the best real main rail leg is within `SHORT_HAUL_RAIL_THRESHOLD_MIN`. Local modes (RER, Transilien, metro, tram) are excluded from that leg.
3. Segment sources and fallbacks: road via Mapbox then OSRM, rail via SNCF route geometry then OpenRailRouting then road at 200 km/h, bus via GTFS search then the estimate at 55 km/h. A suspicious duration usually means a fallback ran. Find which one.
4. Choice: `pickOption(options, preference)` keeps the current selection if it still exists.

Reproduce with a focused Vitest case near src/__tests__/segments.test.ts, timed-segments.test.ts, empty-segments.test.ts or bus-connection.test.ts, stubbing the network at the route boundary. `src/services/travel.integration.test.ts` covers the whole service. Report the step that produced the wrong result and update the doc's tables if thresholds change.
