---
name: bundle-review
description: Use when asked to review a Bundle Events PR or branch.
---

# Bundle review

Resolve the PR's real base and head and review the merge-base diff. For a
local change, include the working-tree edits the user means. Read AGENTS.md
and the tests around the changed entry point. Follow the changed value from
its producer to at least one affected consumer before reporting a defect.

Pick probes from the diff. For a fare calculation, trace an asymmetric round
trip or a missing return price through the recap. For a persistence change,
load a previously saved UUID missing the new field. For an adapter change,
follow an empty or partial provider response through the fallback and the
rendering. For a workflow change, trace the event through the job conditions
and the reported check result.

Back each finding with a focused test, a small local example or a concrete
trace. Lead with findings in impact order, each with a file and line, the
triggering input, the visible consequence, and a targeted fix or regression
test. Keep open questions apart from confirmed findings. If the review is
clean, state what you reviewed and any important gap in verification.

Deliver the review in chat by default. Post comments or submit a GitHub review
only when the user asks. On a re-review, check the current head and the
existing threads so you do not repeat resolved feedback.
