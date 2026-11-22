---
name: bundle-deslop
description: Strip AI-generated noise from a Bundle Events diff before committing. Use before commit or when asked to deslop.
---

# Bundle deslop

Review the diff against the target branch and remove what a careful maintainer would not have written. Touch only lines this change added.

Remove:

- Comments that restate the code, narrate the edit, or mention the task. Keep comments that explain a non-obvious reason.
- Defensive checks, try/catch and fallbacks for states the types or the surrounding code already rule out. Keep validation at real boundaries, such as provider responses and request input.
- Casts to `any` and type assertions added to silence the compiler. Fix the type instead.
- Abstractions with one caller, unused parameters and exports, and helpers that duplicate something in `utils/`.
- Debug logging, commented-out code, stray files, and reformatting of lines unrelated to the change.
- Inconsistent style against the file around it: naming, import order, how the neighbouring code handles errors.

Respect the layering in AGENTS.md: external payload mapping in `adapters/`, fetching in `services/`, pure logic in `utils/`.

Then rerun `npm run lint`, `npm run typecheck` and `npm test`. Finish with a one-line summary of what was removed. Do not change behavior.
