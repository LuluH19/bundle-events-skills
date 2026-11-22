---
name: bundle-analytics-event
description: Add, change or debug a PostHog event in Bundle Events without breaking the dashboards. Use when tracking a new click or step, or when an event is missing in PostHog.
---

# Bundle analytics event

Read docs/features/analytics.md first. It lists every event per screen (event, file, properties) and the dashboards that use them.

## Adding or changing an event

1. Check whether an existing event already covers the action. If it does, add a property to that event instead of creating a new name: the dashboard funnels listen for exact names such as `transport_booking_opened`, and a parallel event splits the data.
2. Name it like the others: snake_case `<object>_<past verb>`, such as `hotel_selected` or `transport_booking_opened`. Reuse existing property names and values from the doc tables (`direction`, `transport_mode`, `provider`, `source`). Keep each event's own vocabulary: `transport_booking_opened` uses `booking_type` (`round_trip`, `one_way`), `hotel_booking_opened` only `provider`, and search events use the boolean `round_trip`.
3. Call `posthog.capture` once, in the handler where the action happens. Most events live in src/components/BundleBuilder.tsx, and booking events in src/components/views/BookView.tsx. Do not fire from an effect that reruns on hydration, or the funnel counts twice.
4. Never send an email, a street address, coordinates or free text the user typed. Send booleans, enums and rounded amounts, as `estimated_total_eur` does. Put derived values in src/utils/analytics.ts with a test in src/utils/analytics.test.ts, like `venueProvider`.
5. Do not add `posthog.identify`. There are no user accounts yet.
6. Add the row to the right table in docs/features/analytics.md. If you rename or remove an event, say which dashboard insight uses it in the PR, because the funnels in that doc break silently.

## Debugging a missing event

- The browser sends to `/ingest`, rewritten in next.config.ts to `POSTHOG_HOST`. Without `POSTHOG_PROJECT_TOKEN` or `POSTHOG_HOST`, PostHog is not initialized and every capture is ignored.
- The PostHog variables are inlined at build time in next.config.ts, so restart `npm run dev` after changing them in `.env.local`.
- The `/ingest` request body is compressed, so the network tab only tells you whether the request returned 200. To read the event, open the page with `?__posthog_debug=true` and watch the browser console while you perform the action once, or check the project's live events in PostHog.
- Every dashboard insight excludes `localhost` and local IPs (`$host` filter), so an event sent from `npm run dev` never shows in insights. That is expected, not a bug.
- Server-side logs from src/lib/posthog-logs.ts are OpenTelemetry logs, not events. They will not appear in insights.
