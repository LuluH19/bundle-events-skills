---
name: bundle-transport-routing
description: Use when a Bundle Events transport mode is missing, a duration looks wrong, or a flight should be banned.
---

# Bundle transport routing

Read docs/features/transport-routing.md, src/utils/algorithms/routing.ts and
`computeOptions` in src/services/travel.ts. Pin the case: departure and venue
coordinates, the date and time constraints (`arriveBy`, `leaveAfter`), and
which option is missing or wrong.

Compute the straight-line distance first, because many "missing mode" reports
sit just under a threshold. Walking needs under 8 km, the car is always
offered, buses need over 10 km, trains over 20 km, and planes over 200 km when
not banned. `isShortHaulFlightBanned` applies when both points are in
metropolitan France and the best real main rail leg is under
`SHORT_HAUL_RAIL_THRESHOLD_MIN` (150 minutes), with local modes such as RER,
Transilien, metro and tram excluded from that leg.

A suspicious duration usually means a fallback ran, so find which one. Roads
use Mapbox, then OSRM. Rail uses the SNCF route geometry, then
OpenRailRouting, then the road at 200 km/h. Buses use the GTFS timetable, then
an estimate at 55 km/h.

The bus timetable search only runs at 15 km or more. Below that, the bus leg
is a plain road segment. Above it, the 55 km/h estimate means
`fetchBusConnection` in routing.ts got nothing. First check the
`/api/buses/search` response, since a non-OK status, a network error or bad
JSON all fall back. If it returned `connection: null`, check the stops and
links `findBusConnection` in src/utils/algorithms/bus-connection.ts found in
src/utils/constants/bus-network.json. The client sends no date, so no weekday
filter applies, and nothing checks dates against the GTFS window. Refresh with
`npm run gtfs:sync` only when its `validTo` has passed, because the timetables
then go stale silently.

The option setters in BundleBuilder keep the selected id when it still exists
in the new options. Otherwise `pickOption(options, preference)` ranks them
from scratch. Trace selection bugs in those setters.

Reproduce with a focused Vitest case near src/__tests__/segments.test.ts,
timed-segments.test.ts, empty-segments.test.ts or bus-connection.test.ts,
stubbing the network at the route boundary.
src/__tests__/travel.integration.test.ts covers the whole service. Report the
step that produced the wrong result, and update the doc's tables if a
threshold changes.
