---
name: bundle-design-system
description: Use for any visual change to Bundle Events, to match the 'Nuit de concert, billet rouge' design system.
---

# Bundle design system

Read docs/design/design-system.md and src/styles/theme.css before writing UI.
Find a sibling component in src/components/trip/ or src/components/views/ and
match it.

Use theme tokens, never raw hex in components. Night blue (`nuit`) is for text
and dark backgrounds. Red (`billet`) is only for the single primary action,
with `billet-600` on hover. Green (`ok`) marks "Réservé" and progress.
Transport modes keep their own colors (`train`, `bus`, `plane`, `car`),
distinct from the brand.

Bricolage Grotesque (`font-display`) is for headings only, Figtree for body
text, and JetBrains Mono (`font-mono`) for times and codes. Secondary text
must keep at least 4.5:1 contrast on white, so check any new color pair. UI
text is French and matches the existing wording, such as "Changer", "Réservé"
and "Voir mon voyage". The logo stays `public/favicon/favicon.svg`.

Verify in the browser on `npm run dev` at phone and desktop widths, and put
before and after screenshots in the PR. Update the design doc when you add a
token.
