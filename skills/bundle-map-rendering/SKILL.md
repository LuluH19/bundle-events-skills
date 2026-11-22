---
name: bundle-map-rendering
description: Debug or change the Bundle Events trip map (Mapbox or MapLibre): markers, route lines, hotel layers and framing. Use when a route line is missing, the map is blank, or the framing is wrong.
---

# Bundle map rendering

Read src/components/TravelMap.tsx, src/components/trip/TripMap.tsx and src/lib/map-engine.ts.

- Engine: `resolveEngine` uses Mapbox when a token exists and its style answers in time, otherwise MapLibre with the OpenFreeMap style. Reproduce with the engine the user had. Check which one by its CSS classes (`mapboxgl-` or `maplibregl-`).
- Coordinates: route segments store `[lat, lng]`, and both map libraries want `[lng, lat]`. Every new source, marker or bounds call must swap them, as the existing `bounds.extend([lng, lat])` does. A line drawn in the sea near Somalia is a swapped pair.
- Timing: markers can be added at once, but sources and layers need the style loaded. Drawing goes through `drawRef` and runs on `map.on("load")` and when data changes after `readyRef` is true. New layers must follow that path, or they vanish on first paint. Remove a source and its layers before adding them again with the same id.
- Cleanup: the effect calls `map.remove()` and resets the ready flags. Keep new refs reset there too, since every step change remounts BundleBuilder.
- Framing: `fitBounds` includes departure, venue, hotel and every segment point. Check a route whose path goes beyond its endpoints, and both the inline and expanded map.

Verify in the browser on `npm run dev`: first load, switching outbound and return, opening the expanded map, and a reload. For a Playwright test, reuse the minimal valid style stub in e2e/home-flow.spec.ts, since an empty object crashes mapbox-gl.
