---
name: bundle-event-search
description: Use when a Bundle Events event or venue is missing, duplicated or badly ranked, including in 'Des idées de sortie'.
---

# Bundle event search

Read the events section of docs/api/internal-routes.md,
src/app/api/events/search/route.ts, src/services/event-search.ts,
src/adapters/events/ and src/utils/algorithms/venue-dedupe.ts.

Pin the query: the `q` text or the `cities=` list, the expected event or
venue, and what the user saw. Call `/api/events/search` on `npm run dev` with
the same parameters and read `eventSource` and `X-Cache`. Events come from
Ticketmaster, then OpenAgenda, then Open Data IDF. Venues come from Mapbox POI
and Nominatim. Without `TICKETMASTER_API_KEY` the search starts at OpenAgenda.

City queries put that city's concerts, festivals, shows and matches first.
Ideas filter on `eventsConfig.ideaKeywords`, alternate city by city, stop at
`eventsConfig.ideasLimit`, and include no venues. For a missing venue, check
city filtering with `isInCity` and the coordinate order. For duplicates, check
the dedupe rules on name and coordinates.

Event and venue lists are cached even when empty, for 6 hours and 7 days. An
empty answer cached during an outage persists until it expires, so check that
the fetcher threw instead of returning `[]`.

Reproduce in src/__tests__/venue-city.test.ts or providers.test.ts with
sanitized payloads. Update the route doc when ranking or sources change.
