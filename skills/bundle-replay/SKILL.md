---
name: bundle-replay
description: Use when reloading or sharing a Bundle Events UUID link loses a selection, restores stale state, or opens the wrong step.
---

# Bundle replay

Read AGENTS.md. Pin the UUID route, the starting step, the user action, and
the first field that changes unexpectedly. Compare three snapshots: the state
just before saving, the data returned when loading the UUID, and the selection
rendered after hydration. Use the catch-all page in src/app/[uuid]/[[...step]]
and src/services/bundles.ts to find the current read and write path.

Use e2e/home-flow.spec.ts for the network stubs and the saved bundle shape,
with a synthetic UUID. If the scenario edits a bundle, make the save stub keep
the submitted data and the load stub return it. A constant response hides a
broken save. For a sharing bug, open the link in a fresh browser context with
the same stubbed storage. For a reload bug, keep the same context.

Assert the visible step and the affected selection after the round trip. If
older bundles are involved, replay one with the historical field absent. If a
direction change is involved, check whether a stale return leg reappears after
choosing one way. Run the case with `npm run test:e2e -- <spec>` and report
the first snapshot that diverges and what the user sees.
