---
name: bundle-share-email
description: Debug or change Bundle Events trip sharing: the share modal, the save route and the Brevo email. Use when an email is not received, the link is wrong, or the modal shows the wrong message.
---

# Bundle share email

Read docs/features/save-and-email.md, src/components/SaveBundleModal.tsx, src/app/api/bundles/[uuid]/save/route.ts and src/lib/email.ts.

1. Call `POST /api/bundles/{uuid}/save` with `{ "email": ... }` on `npm run dev` and read `{ ok, link, sent }`. `sent:false` with `ok:true` is expected when Brevo is not configured: the email is stored and the stub logs instead.
2. Not received with `sent:true`: check `EMAIL_FROM` is the verified Brevo sender and is not quoted literally in Vercel, the account has transactional sending enabled, and the spam folder. Use /api/health/email to test the configuration.
3. Wrong link: `NEXT_PUBLIC_SITE_URL` builds the email link, and the modal builds its copy link from `window.location.origin`. They differ between preview and production.
4. Privacy: `GET /api/bundles/{uuid}` must never return the email, since anyone with the link can read it.
5. Template changes: keep the email HTML table-based with inline styles and hex colors for Gmail, Outlook and Apple Mail.

Never send test emails to real users. Use your own address.
