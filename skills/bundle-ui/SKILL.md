---
name: bundle-ui
description: Use when adding or changing a Bundle Events screen, component, panel, button or wording, or when Lighthouse accessibility drops or a Playwright role selector stops matching.
---

# Bundle ui

Read docs/design/design-system.md, src/styles/theme.css, src/components/ui.tsx
and src/components/Sheet.tsx before writing markup. The screens are
src/components/views/HomeView.tsx, TripView.tsx and BookView.tsx, with the
trip pieces in src/components/trip/.

The UI is designed with the ui-ux-pro-max skill and the 21st.dev Magic MCP.
Use them for ideas and a first draft, then bring the result into this
project's charter. This skill wins wherever they disagree:

- ui-ux-pro-max proposes a style, a palette and font pairings. Keep its
  layout, hierarchy and UX checks, but drop its palette and fonts: the
  charter « Nuit de concert, billet rouge » and the three fonts below are
  fixed. Do not let it write a new design-system file next to
  docs/design/design-system.md.
- 21st.dev components usually arrive with shadcn/ui, Radix, lucide-react,
  framer-motion, `cn()` from clsx and tailwind-merge, `@/components/ui/*`
  paths and English text. None of these are in package.json. Rewrite the
  component onto ui.tsx, `Sheet` and `Dropdown`, the theme tokens and plain
  template-string classes, with CSS animations in globals.css. Adding a
  dependency is a separate decision to raise in the PR, because CI reports
  client bundle size on every PR and `npm audit` blocks on high advisories.
- Replace every colour from a generated component (`zinc-*`, `neutral-*`,
  `primary`, `muted-foreground`, `dark:` variants, gradients) with a token.
  The app has a single light theme; do not add `dark:` classes.
- Translate the copy into French with the tone below, and put the files in
  src/components/, not in a new components/ui/ folder.

Reuse before you build. Icons, `MODE_ICON`, `Eyebrow`, `Chip` and `Button`
(`primary`, `dark`, `ghost`) live in ui.tsx. Any panel, drawer or modal is a
`Sheet`: a bottom sheet on mobile, a side drawer or centred modal from `md:`.
A list picker is `Dropdown`, which already does `listbox`, `option` and the
arrow keys. Add a new icon to ui.tsx with the same `IconProps` signature, not
inline in a view.

Colours come from the `@theme` tokens only, never a hex in a class or a
`style`. The red `billet` / `ember` is reserved for the single main action of
a screen: a second red button competes with it, so use `dark` or `ghost`.
`ok` means booked or done. Transport colours come from `MODE_COLOR` in
src/utils/constants/transport.ts and always sit next to an icon and a label.
TravelMap.tsx and LogoLoader.tsx hold literal hex values on purpose, because
MapLibre paint properties and the logo SVG cannot read CSS variables; keep
them in step with theme.css when a token changes.

Titles use `font-display`, times and codes `font-mono`, the rest Figtree.
Page content sits in `mx-auto max-w-6xl px-4 md:px-8`; full-width
backgrounds carry the colour and the inner container carries the margin.
New animations go in globals.css and must stop under the existing
`prefers-reduced-motion` block.

Write copy the way the design doc says: tutoiement, short sentences, the
traveller's words ("hôtel", "trajet", "voyage", never "bundle" or "segment"),
and buttons that say where they go, such as « Réserver sur Trainline ↗ ». A
link that opens another site gets `target="_blank"`, `rel="noopener
noreferrer"` and `IconExternal`.

Accessibility is part of done, and Lighthouse warns below 0.9:

- An icon-only button has a French `aria-label`, as the `Sheet` close button
  has « Fermer ». A clickable element is a `<button>` or a link, not a `div`
  with `onClick`.
- Secondary text uses `slate-500` or `slate-400` on white, which pass 4.5:1.
  Lighter greys, `opacity-*` on text, and white on anything lighter than
  `billet` fail contrast.
- Images go through `next/image` with a real `alt`, or `alt=""` when they are
  decorative. The QR code in SaveBundleModal.tsx is the one allowed `<img>`.
- Keep the `:focus-visible` outline: never `outline-none` without a
  replacement.
- `Sheet` focuses its close button on open but neither traps focus nor
  returns it to the opener on close. If your change depends on that, fix it in
  Sheet.tsx once for every panel rather than in your component.

Accessible names are also the test API. e2e/home-flow.spec.ts finds elements
with `getByRole` and their French names, such as « Mois suivant » and « Voir
mon voyage ». Renaming a button or swapping a `<button>` for a `<div>` breaks
those tests; grep e2e/ for the old name and update the spec in the same
change. A new interactive element should be reachable the same way, so a
future test needs no `data-testid`.

Check the change on `npm run dev` at 375 px wide and at 1280 px, with the
keyboard only (Tab, Enter, Échap in a sheet). For a score, run `npm run build`
then `npx --yes @lhci/cli@0.16.0 collect && npx --yes @lhci/cli@0.16.0
assert`, which reads lighthouserc.json. It only audits `/`, so check the
trip and booking screens by hand with the Lighthouse panel in Chrome DevTools
on a saved bundle URL.

Update docs/design/design-system.md when you add a token, a primitive, a
component pattern or a copy rule, in the same change.
