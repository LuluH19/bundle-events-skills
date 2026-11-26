---
name: bundle-trip-dates
description: "Use for any Bundle Events date or time bug: the calendar, same-day trips, arrive-by and leave-after, or train search times."
---

# Bundle trip dates

Read the calendar rules in docs/features/user-flow.md,
src/components/DateRangePicker.tsx and src/utils/date.ts. Several PRs touched
this area (#124, #164, #183), so check the current behavior before changing
it.

Pin the case: departure date, return date, one way or round trip, the optional
"arriver avant" and "partir après" times, and the current time. Most bugs
depend on "today".

DateRangePicker gives `checkin`, `checkout`, `arriveBy` and `leaveAfter` to
BundleBuilder. `outboundSearch` turns the outbound day into a search time. An
"arriver avant" time searches by arrival, today without a time searches from
now, and another day starts at 08:00 for a date-only value, while an older
value with a time keeps its time. `returnSearch` starts from `leaveAfter`,
else a minimum time passed by the caller (a same-day `arriveBy`), else 10:00.
It raises the time to that minimum when lower, and moves a past time to now.

`isSameDayTrip` decides the hotel. `stayNights` in src/utils/trip.ts gives the
nights and is tested in src/__tests__/trip.test.ts. `getDaysDiff` only splits
a LiteAPI total into a nightly price.

Keep these rules. The picker blocks a past "arriver avant" today, while a past
"partir après" is allowed and moved to now by `returnSearch`. On a same-day
trip, when both times are set, "partir après" must be later than "arriver
avant". The picker compares the two inputs, not the actual train's arrival
time. A same-day round trip has no hotel unless `hotelOptIn` is set, and
changing dates re-picks the hotel and resets the "Réservé" states. Dates are
`YYYY-MM-DD` now, but an older value with a time is still accepted.

Test with a fixed `now` in src/__tests__/date.test.ts, which already passes
`NOW` to these functions. Cover today, tomorrow, a same-day return and a
legacy datetime value. Then check the times shown on "Ton voyage" and
"Réserver" in the browser, and update the calendar section of
docs/features/user-flow.md when a rule changes.
