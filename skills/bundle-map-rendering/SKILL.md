---
name: bundle-map-rendering
description: Use when a Bundle Events map is blank, misses a route line, or frames the wrong area.
---

# Bundle map rendering

Read src/components/TravelMap.tsx, src/components/trip/TripMap.tsx and
src/lib/map-engine.ts.

`resolveEngine` uses Mapbox when a token exists and its style answers in time,
and MapLibre with the OpenFreeMap style otherwise. Reproduce with the engine
the user had, which you can tell from the `mapboxgl-` or `maplibregl-` CSS
classes.

Route segment tuples are `[lat, lng]`, and both map libraries want `[lng,
lat]`. Swap route tuples once where they enter the map, as
`bounds.extend([lng, lat])` does. Markers and hotels already build `[lng,
lat]` from named `lat` and `lng` fields, so do not swap those again.

Markers can be added at once, but sources and layers need the style loaded.
Drawing goes through `drawRef`, which runs on `map.on("load")` and when data
changes after `readyRef` is true. New layers must follow that path, or they
vanish on first paint. To replace a source, remove its layers first, then the
source. For a stable source such as `hotels`, call `setData` instead. The
cleanup calls `map.remove()` and resets the ready flags, so reset any new ref
there too, since every step change remounts BundleBuilder.

On the trip map, where TripMap passes `showHotels={false}`, the markers effect
uses `flyTo` for one location and `fitBounds` over the markers and every route
point for two or more. Check both the inline and the expanded map. The hotel
picker map in src/components/trip/HotelPicker.tsx turns `showHotels` on, skips
that branch, and frames the venue radius in a separate effect. Fix and verify
the map the user actually saw.

Verify in the browser on `npm run dev`: first load, switching outbound and
return, opening the expanded map, and a reload. For a Playwright test, reuse
the minimal valid style stub in e2e/home-flow.spec.ts, since an empty object
crashes mapbox-gl.
