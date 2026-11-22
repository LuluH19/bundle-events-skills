---
name: bundle-booking-links
description: Build, change or debug Bundle Events booking deep links to Kayak, Trainline, FlixBus, Google Maps and Booking.com. Use when a "Réserver" button opens the wrong search.
---

# Bundle booking links

Read docs/features/booking-links.md, src/utils/booking.ts, and the proxies src/app/api/booking/train/route.ts and src/app/api/booking/bus/route.ts.

Pin one trip: mode per leg, departure and arrival names and coordinates, dates, and one way or round trip. Links are rebuilt from the snapshot (names, coordinates, dates), so start from what the snapshot actually holds.

Check per mode:

- Plane: nearest airport within 80 km gives the IATA codes for the Kayak path. Without one, the fallback is Google Flights.
- Train: the proxy resolves the station to a Trainline URN server-side and must send one adult passenger or Trainline errors. For a return, check `journeySearchType=return` and the inward date.
- Bus: the proxy resolves the city to a FlixBus UUID. Dates are `DD.MM.YYYY`.
- Car and walking: only when the whole trip uses that mode.
- Hotel: Booking.com with split `checkin_year/month/monthday` fields, `lang=fr`, EUR.
- Round trip: a mode present in both directions is booked once from the outbound card and the return card says it is included.

Reproduce by calling the function in a Vitest case or hitting the proxy route on `npm run dev` and reading the `Location` header. Open the final URL and confirm the provider shows the right stations and dates. Update docs/features/booking-links.md when behavior changes.
