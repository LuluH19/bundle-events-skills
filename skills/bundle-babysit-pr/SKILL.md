---
name: bundle-babysit-pr
description: Watch a Bundle Events pull request through CI, the Vercel preview and teammate reviews, and fix what is real until it is ready to merge. Use when asked to babysit, watch or monitor a PR.
---

# Bundle babysit PR

Feature and fix PRs target `dev`. Releases go `dev` into `main`, then `main` is merged back into `dev`. Know which kind of PR you are watching before acting.

## Wait without polling by hand

Use one watcher per PR and never write your own `sleep` loop.

- T3 Code: handle the current checks and comments, call `watch_pull_request`, and end the turn. Call `unwatch_pull_request` before you hand back.
- Claude Code: run `gh pr checks <pr> --watch --fail-fast` with the Monitor tool, or as one long background command.
- Cursor and Codex: run `gh pr checks <pr> --watch --fail-fast` as one long terminal command and read its result when it exits.

Restart the watcher after every push. Do not post "still waiting" messages.

## What to look at

- CI (`.github/workflows/ci.yml`): Commit Lint, PR title, ESLint, TypeScript Check, NPM Audit, Build, Dev server boot, Secret Scan and PR Summary. CI does not run Vitest, so run `npm test` locally before calling the PR ready. For a red job, use `bundle-fix-ci` to find the first failing command. Compare the run's SHA with the PR head first.
- The `github-actions[bot]` summary comment: it must match the real job results. A skipped job is not a pass.
- The `vercel[bot]` preview: open it and click through the flow the PR changes, from search to "Ton voyage" to "Réserver". A green build does not prove the page works.
- Teammate reviews: answer every thread. Fix real findings, and reply with a short reason when you decline one. Verify each claim against the code before changing anything.

Only act on checks and comments newer than the latest push.

## Keep the PR small

Review rounds tend to add small fixes until the PR has grown. Fix real bugs in the intended case. List extra ideas as follow-ups in the PR description instead of adding them.

## Base branch and merging

Run `git fetch` and check whether `dev` moved under the PR. If the PR is BEHIND or has conflicts, rebase on `origin/dev`, rerun `npm run lint`, `npm run typecheck` and `npm test`, push, and wait for green again.

Merge only when the user asked for it. Otherwise report that the PR is ready, with the head SHA, check results and preview link. Never merge a red, BEHIND or conflicting PR, and never merge `dev` into `main` without the team's release decision.
