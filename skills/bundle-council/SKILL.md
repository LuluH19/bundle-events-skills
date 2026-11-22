---
name: bundle-council
description: Get independent review of a Bundle Events change from three models of different providers and loop until they agree. Use when the user says "council".
---

# Bundle council

Settle known issues first. Address open PR comments, fix defects you already know about, and run `npm run lint`, `npm run typecheck` and `npm test`. Give the council the updated change, not a draft you expect to fix later. If the user wants to throw the implementation away, skip fixes to code being replaced.

## Seat the council

Use three delegates, each a strong model from a different provider, at high reasoning effort. If the user names members, use them. Otherwise take the newest flagship model of each provider that the harness offers. Read the model list from the subagent tool itself. Do not type a model name from memory.

- Cursor: start each delegate with the `Task` tool, one call per model, all in the same message. Set `model` explicitly, `readonly: true`, `run_in_background: true`, and the `generalPurpose` subagent type.
- Claude Code or Codex: use the harness's subagent tool, one call per model, in parallel.
- If you cannot reach three providers, or a named member is unavailable, say so and ask. Do not substitute silently and do not count one provider twice.

## Brief

Every brief stands alone. Give each delegate:

- The goal of the change in one sentence and the base and head refs to diff.
- A pointer to AGENTS.md and the changed files, not their pasted contents.
- The probes `bundle-review` would run for this diff: asymmetric or missing return fares, a saved bundle UUID without the new field, an empty or partial provider response, a workflow job that is skipped or cancelled.
- Read-only rules. They report, they do not edit.
- A request for findings in impact order, each with file, line, triggering input and observable consequence, followed by a score out of 10 for the change.

## Run the round

Do not wait idle. When a result arrives, check each finding against the code at once, then decide what to fix while the others run. Do not edit files while a delegate is still reviewing the same checkout. If the user marks a delegate non-blocking, do not wait for it. Treat its late result as feedback and record no score.

A full review pass is one round. After you apply fixes, request a fresh review with the original brief plus what changed. That starts a new round. Stop when every delegate is satisfied or has only findings you can show are wrong. Keep scope fixed. Repeated reviews attract scope creep, and holding the line is your job. Defer a good idea outside the change to a follow-up note.

## Report

Summarise useful findings, disagreements, and what you fixed or declined with the reason. If the work ends in a PR, add this to the description under `Notes for reviewers`, and edit the description in place. Do not post a comment for it.

```markdown
## Council review

Rounds: 2

| Delegate | Round 1 | Round 2 |
| --- | --- | --- |
| <model> | 7/10 | 9/10 |
```

Write `no score` when a delegate gives none. Never invent one. With no PR, put the same table in the final reply.
