---
name: bundle-trip-dates
description: Change or debug how Bundle Events handles trip dates and times: the calendar, same-day trips, arrive-by and leave-after, and the train search times. Use for any date or time bug.
---

# Bundle trip dates

Read the calendar rules in docs/features/user-flow.md, src/components/DateRangePicker.tsx and src/utils/date.ts. Several PRs touched this area (#124, #164, #183), so check the current behavior before changing it.

1. Pin the case: departure date, return date, one way or round trip, the optional "arriver avant" and "partir après" times, and the current time. Most bugs depend on "today".
2. Follow the value: DateRangePicker gives `checkin`, `checkout`, `arriveBy` and `leaveAfter` to BundleBuilder. `outboundSearch` turns the outbound day into a search time: an "arriver avant" time searches by arrival, today without a time searches from now, another day from 08:00 for a date-only value (an older value with a time keeps its time). `returnSearch` starts from `leaveAfter`, else a minimum time passed by the caller (a same-day `arriveBy`), else 10:00, raises it to that minimum when lower, and moves a past time to now. `isSameDayTrip` decides the hotel. `stayNights` in src/utils/trip.ts gives the nights (tested in src/__tests__/trip.test.ts). `getDaysDiff` only splits a LiteAPI total into a nightly price.
3. Rules to keep: the picker blocks a past "arriver avant" today (a past "partir après" is allowed and moved to now by `returnSearch`). On a same-day trip, when both times are set, it requires "partir après" to be later than "arriver avant" (it compares the two inputs, not the actual train's arrival time), a same-day round trip has no hotel unless `hotelOptIn`, and changing dates re-picks the hotel and resets "Réservé" states.
4. Old trips: `checkin` and `checkout` are `YYYY-MM-DD` now, but an older value with a time is still accepted. Keep that working.
5. Test with a fixed `now` in src/__tests__/date.test.ts, which already passes `NOW` to these functions. Cover today, tomorrow, a same-day return and a legacy datetime value. Then check the times shown on "Ton voyage" and "Réserver" in the browser.

Update the calendar section of docs/features/user-flow.md when a rule changes.
