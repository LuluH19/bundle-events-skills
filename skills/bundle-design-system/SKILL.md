---
name: bundle-design-system
description: Build or review Bundle Events UI against the "Nuit de concert, billet rouge" design system: tokens, fonts, transport colors and contrast. Use for any visual change.
---

# Bundle design system

Read docs/design/design-system.md and src/styles/theme.css before writing UI. Find a sibling component in src/components/trip/ or src/components/views/ and match it.

Rules:

- Use theme tokens, never raw hex in components. Night blue (`nuit`) for text and dark backgrounds. Red (`billet`) only for the single primary action, with `billet-600` on hover. Green (`ok`) for "Réservé" and progress.
- Transport modes keep their own colors (`train`, `bus`, `plane`, `car`), distinct from the brand.
- Fonts: Bricolage Grotesque (`font-display`) for headings only, Figtree for body text, JetBrains Mono (`font-mono`) for times and codes.
- Secondary text must keep at least 4.5:1 contrast on white. Check any new color pair.
- UI text is French. Match the existing wording ("Changer", "Réservé", "Voir mon voyage").
- The logo stays `public/favicon/favicon.svg`.

Verify in the browser on `npm run dev` at phone and desktop widths, and include before and after screenshots in the PR. Update the design doc when adding a token.
