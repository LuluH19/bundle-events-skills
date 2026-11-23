---
name: bundle-analytics-event
description: Use when adding, changing or debugging a PostHog event in Bundle Events.
---

# Bundle analytics event

Read docs/features/analytics.md first. It lists every event per screen, with
the file that sends it and its properties, and the dashboards that read them.

Before adding an event, check whether an existing one already covers the
action. If it does, add a property to that event instead of creating a new
name. The dashboard funnels listen for exact names such as
`transport_booking_opened`, and a parallel event splits the data.

Name a new event like the others, in snake_case as `<object>_<past verb>`, for
example `hotel_selected`. Reuse the property names and values from the doc
tables, such as `direction`, `transport_mode`, `provider` and `source`. Keep
each event's own vocabulary: `transport_booking_opened` uses `booking_type`
(`round_trip` or `one_way`), `hotel_booking_opened` sends only `provider`, and
search events use the boolean `round_trip`.

Call `posthog.capture` once, in the handler where the action happens. Most
events live in src/components/BundleBuilder.tsx, and booking events in
src/components/views/BookView.tsx. Do not fire from an effect that reruns on
hydration, or the funnel counts the action twice.

Never send an email, a street address, coordinates or free text the user
typed. Send booleans, enums and rounded amounts, as `estimated_total_eur`
does. Put derived values in src/utils/analytics.ts with a test in
src/utils/analytics.test.ts, like `venueProvider`. Do not add
`posthog.identify`, because there are no user accounts yet.

Add the row to the right table in docs/features/analytics.md. If you rename or
remove an event, say in the PR which dashboard insight uses it, because those
funnels break silently.

To debug a missing event, remember that the browser sends to `/ingest`, which
next.config.ts rewrites to `POSTHOG_HOST`. Without `POSTHOG_PROJECT_TOKEN` or
`POSTHOG_HOST`, PostHog is not initialized and every capture is ignored. Those
variables are inlined at build time, so restart `npm run dev` after changing
them in `.env.local`.

The `/ingest` request body is compressed, so the network tab only shows
whether the request returned 200. To read the event itself, open the page with
`?__posthog_debug=true` and watch the browser console while you perform the
action once, or check the project's live events in PostHog.

Every dashboard insight excludes `localhost` and local IPs with a `$host`
filter, so an event sent from `npm run dev` never shows in insights. That is
expected. Server-side logs from src/lib/posthog-logs.ts are OpenTelemetry
logs, not events, and never appear in insights either.
