---
name: bundle-deslop
description: Trigger this if the user says 'deslop', or before committing a Bundle Events change.
---

# Bundle deslop

Review the diff against the target branch and remove what a careful maintainer
would not have written. Touch only lines this change added, and do not change
behavior.

Remove comments. The team convention in docs/contributing/conventions.md
allows none, except functional directives such as `eslint-disable-next-line`
or `/* empty */` in a deliberately empty catch. Rename things instead.

Remove defensive checks, try/catch blocks and fallbacks for states the types
or the surrounding code already rule out. Keep validation at real boundaries,
such as provider responses and request input. Replace casts to `any` and type
assertions added to silence the compiler with a correct type.

Remove abstractions with one caller, unused parameters and exports, helpers
that duplicate something in `utils/`, debug logging, commented-out code, stray
files, and reformatting of unrelated lines. Match the file around the change
in naming, import order and error handling. Respect the layering in AGENTS.md:
payload mapping in `adapters/`, fetching in `services/`, pure logic in
`utils/`.

Then rerun `npm run lint`, `npm run typecheck` and `npm test`, and finish with
a one-line summary of what you removed.
