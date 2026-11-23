---
name: bundle-council
description: Trigger this if the user says 'council'.
---

# Bundle council

Before an audit, address outstanding PR comments, fix known issues, and run
`npm run lint`, `npm run typecheck` and `npm test`. Give the council the
updated change. Do not defer known fixes until reviews return. If the user
wants to discard the implementation and explore new ideas, skip fixes to code
being replaced.

Bring in three delegates, usually for review or feedback. Use one strong model
from each of three different providers, at high reasoning effort. If the user
names council members, use those. Otherwise pick the newest flagship model of
each provider that the harness offers, and read the model list from the
subagent tool rather than typing a name from memory.

In T3 Code, use `orchestrator_capabilities` to resolve the models, then
`delegate_task` to start one delegate per model in parallel. In Cursor, start
each delegate with the `Task` tool in the same message, with `model` set
explicitly, `readonly: true`, `run_in_background: true` and the
`generalPurpose` subagent type. In Claude Code or Codex, use the harness's
subagent tool. If you cannot reach three providers, or a named member is
unavailable, report it instead of substituting.

Give each delegate a brief that stands alone: the goal in one sentence, the
base and head refs, pointers to AGENTS.md and the changed files, and the
probes `bundle-review` would pick for this diff. Keep their work read-only,
and ask for findings in impact order with file, line, triggering input and
observable consequence.

Do not wait idle. When a result arrives, check its findings against the code
at once and decide what to fix while the other delegates run. Do not edit
files while a delegate still reviews the same checkout. If the user marks a
delegate as non-blocking, do not wait for it, treat a late result as feedback,
and do not record its score.

For a code review, ask each delegate for a score out of 10. Count each full
review pass as one round. A fresh review after fixes starts a new round.

If the work ends in a pull request, put the results in the PR description
under "Notes for reviewers":

```markdown
## Council review

Rounds: 2

| Delegate | Round 1 | Round 2 |
| --- | --- | --- |
| Claude Opus | 7/10 | 9/10 |
| GPT Sol | 8/10 | 10/10 |
| Gemini Pro | 7/10 | 9/10 |
```

If a delegate gives no score, write `no score`. Do not invent one. If the PR
is open, edit the description. Do not post a comment for this. If there is no
PR, put the same results in the final reply only.

If you agree with their recommendations, make the changes and request a fresh
review after. Continue until all delegates are satisfied with the outcome. Do
not let repeated reviews result in scope creep. It is your job to fight to
keep scope limited.
