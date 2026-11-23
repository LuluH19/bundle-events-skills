---
name: bundle-share-email
description: Use when a Bundle Events share email is not received, the shared link is wrong, or the share modal shows the wrong message.
---

# Bundle share email

Read docs/features/save-and-email.md, src/components/SaveBundleModal.tsx,
src/app/api/bundles/[uuid]/save/route.ts and src/lib/email.ts.

Call `POST /api/bundles/{uuid}/save` with `{ "email": ... }` on `npm run dev`
and read `{ ok, link, sent }`. `sent: false` with `ok: true` is expected when
Brevo is not configured: the email is stored and the stub logs instead.

If nothing arrives with `sent: true`, check that `EMAIL_FROM` is the verified
Brevo sender and is not quoted literally in Vercel, that the account has
transactional sending enabled, and the spam folder. Use /api/health/email to
test the configuration. For a wrong link, remember that `NEXT_PUBLIC_SITE_URL`
builds the email link while the modal builds its copy link from
`window.location.origin`, and they differ between preview and production.

`GET /api/bundles/{uuid}` must never return the email, since anyone with the
link can read it. Keep the email HTML table-based, with inline styles and hex
colors, for Gmail, Outlook and Apple Mail. Never send test emails to real
users. Use your own address.
