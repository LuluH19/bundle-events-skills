---
name: bundle-event-search
description: Debug or change Bundle Events event and venue search, ranking, deduplication and the "Des idées de sortie" ideas. Use when an event or venue is missing, duplicated or badly ranked.
---

# Bundle event search

Read the events section of docs/api/internal-routes.md, src/app/api/events/search/route.ts, src/services/event-search.ts, src/adapters/events/ and src/utils/algorithms/venue-dedupe.ts.

Pin the query: the `q` text or the `cities=` list, the expected event or venue, and what the user saw.

1. Call `/api/events/search` on `npm run dev` with the same parameters and read `eventSource` and `X-Cache`. Events come from Ticketmaster, then OpenAgenda, then Open Data IDF. Venues come from Mapbox POI and Nominatim. Without `TICKETMASTER_API_KEY` the search starts at OpenAgenda.
2. City queries put that city's concerts, festivals, shows and matches first. Ideas filter on `eventsConfig.ideaKeywords`, alternate city by city and stop at `eventsConfig.ideasLimit`, without venues.
3. Missing venue: check city filtering (`isInCity`) and coordinate order. Duplicates: check the dedupe rules on name and coordinates.
4. Event and venue lists are cached even when empty (6 h and 7 days). An empty cached answer after an outage will persist until it expires. Check the fetcher threw instead of returning `[]`.

Reproduce in src/__tests__/venue-city.test.ts or providers.test.ts with sanitized payloads. Update the route doc when ranking or sources change.
