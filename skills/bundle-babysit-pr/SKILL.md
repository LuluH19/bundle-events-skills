---
name: bundle-babysit-pr
description: Trigger this if the user says 'babysit', or asks to watch or monitor a Bundle Events PR.
---

# Bundle babysit pr

Feature and fix PRs target `dev`. Releases go from `dev` into `main`, then
`main` is merged back into `dev`. Know which kind of PR you are watching
before you act.

Use one watcher per PR and never write your own `sleep` loop. In T3 Code,
handle the current checks and comments, call `watch_pull_request`, and end the
turn. Call `unwatch_pull_request` before you hand back. In Claude Code, run
`gh pr checks <pr> --watch --fail-fast` with the Monitor tool or as one long
background command. In Cursor and Codex, run the same command in the terminal
and read its result when it exits. Restart the watcher after every push, and
never post "still waiting" messages.

CI runs Detect changes, Commit Lint, PR title, ESLint, TypeScript Check, Unit
tests (Vitest), NPM Audit, Build, E2E tests (Playwright), Dev server boot and
Secret Scan, then the `CI OK` gate. `CI OK` passes when each of its blocking
dependencies succeeded or was skipped. Detect changes runs a docs-only check,
and a docs-only PR skips the code jobs on purpose, so on a code PR check that
the jobs your change needs actually ran. Lighthouse is informational. For a
red job, compare the run's SHA with the PR head, follow the job dependencies
back to the first failing command in the Actions log, and rerun that command
locally with the workflow's Node version.

The `github-actions[bot]` summary comment must match the real job results. A
skipped job is not a pass, except on a docs-only change. If the comment is
missing, check the PR Summary job, which sits outside the `CI OK` gate.

Open the `vercel[bot]` preview and click through the flow the PR changes, from
search to "Ton voyage" to "Réserver". A green build does not prove the page
works.

Answer every teammate review thread. Verify each claim against the code before
changing anything, fix real findings, and reply with a short reason when you
decline one. Only act on checks and comments newer than the latest push.

Review rounds tend to grow a PR one small fix at a time. Fix real bugs in the
intended case, and list other ideas as follow-ups in the PR description.

Run `git fetch` and check whether `dev` moved under the PR. If the PR is
BEHIND or has conflicts, rebase on `origin/dev`, rerun `npm run lint`, `npm
run typecheck` and `npm test`, push, and wait for green again.

Merge only when the user asked for it. Otherwise report that the PR is ready,
with the head SHA, the check results and the preview link. Never merge a red,
BEHIND or conflicting PR, and never merge `dev` into `main` without the team's
release decision.
