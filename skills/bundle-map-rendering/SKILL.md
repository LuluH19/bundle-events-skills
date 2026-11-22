---
name: bundle-map-rendering
description: Debug or change the Bundle Events trip map (Mapbox or MapLibre): markers, route lines, hotel layers and framing. Use when a route line is missing, the map is blank, or the framing is wrong.
---

# Bundle map rendering

Read src/components/TravelMap.tsx, src/components/trip/TripMap.tsx and src/lib/map-engine.ts.

- Engine: `resolveEngine` uses Mapbox when a token exists and its style answers in time, otherwise MapLibre with the OpenFreeMap style. Reproduce with the engine the user had. Check which one by its CSS classes (`mapboxgl-` or `maplibregl-`).
- Coordinates: route segment tuples are `[lat, lng]`, and both map libraries want `[lng, lat]`. Swap route tuples once where they enter the map, as `bounds.extend([lng, lat])` does. Markers and hotels already build `[lng, lat]` from named `lat`/`lng` fields, so do not swap those again.
- Timing: markers can be added at once, but sources and layers need the style loaded. Drawing goes through `drawRef` and runs on `map.on("load")` and when data changes after `readyRef` is true. New layers must follow that path, or they vanish on first paint. To replace a source, remove its layers first, then the source. For a stable source such as `hotels`, call `setData` instead of recreating it.
- Cleanup: the effect calls `map.remove()` and resets the ready flags. Keep new refs reset there too, since every step change remounts BundleBuilder.
- Framing: on the trip map (TripMap passes `showHotels={false}`), the markers effect uses `flyTo` for one location and `fitBounds` over the markers and every route point for two or more; check both the inline and expanded map. The hotel picker map (src/components/trip/HotelPicker.tsx, `showHotels` on) skips that and frames the venue radius in a separate effect. Fix and verify the map the user actually saw.

Verify in the browser on `npm run dev`: first load, switching outbound and return, opening the expanded map, and a reload. For a Playwright test, reuse the minimal valid style stub in e2e/home-flow.spec.ts, since an empty object crashes mapbox-gl.
