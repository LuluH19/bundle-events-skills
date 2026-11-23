---
name: bundle-booking-links
description: Use when a Bundle Events 'Réserver' button opens the wrong Kayak, Trainline, FlixBus, Google Maps or Booking.com search.
---

# Bundle booking links

Read docs/features/booking-links.md, src/utils/booking.ts, and the proxies
src/app/api/booking/train/route.ts and src/app/api/booking/bus/route.ts.

Pin one trip: the mode of each leg, the departure and arrival names and
coordinates, the dates, and one way or round trip. Links are rebuilt from the
snapshot's names, coordinates and dates, so start from what the snapshot
actually holds.

For a plane, the nearest airport within 80 km gives the IATA codes for the
Kayak path, and without one the link falls back to Google Flights. For a
train, the proxy resolves the station to a Trainline URN on the server and
must send one adult passenger, or Trainline shows an error. For a return,
check `journeySearchType=return` and the inward date. For a bus, the proxy
resolves the city to a FlixBus UUID, with dates as `DD.MM.YYYY`. Car and
walking links appear only when the whole trip uses that mode. Hotels go to
Booking.com with split `checkin_year`, `checkin_month` and `checkin_monthday`
fields, `lang=fr` and EUR.

On a round trip, a mode present in both directions is booked once from the
outbound card, and the return card says it is included.

Reproduce by calling the function in a Vitest case, or by hitting the proxy
route on `npm run dev` and reading the `Location` header. Open the final URL
and confirm the provider shows the right stations and dates. Update
docs/features/booking-links.md when the behavior changes.
