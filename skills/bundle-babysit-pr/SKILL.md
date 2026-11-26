---
name: bundle-babysit-pr
description: Trigger this if the user says 'babysit', or asks to watch or monitor a Bundle Events PR.
---

# Bundle babysit pr

Feature and fix PRs target `dev`. Releases go from `dev` into `main`, then
`main` is merged back into `dev`. A stacked PR targets another feature branch.
Read the base with `gh pr view <pr> --json baseRefName` before you act.

Use one watcher per PR and never write your own `sleep` loop. In Claude Code,
run `gh pr checks <pr> --watch --fail-fast` as one long background command. In
Cursor, run it in the terminal and read its result when it exits. It watches
checks only, so read the reviews and threads each time it exits. Restart it
after every push, and never post "still waiting" messages.

CI runs only on PRs into `main` or `dev`. A stacked PR shows Vercel checks
alone, which is not green. Run the checks locally and say so. When its parent
merges, GitHub does not retarget it, because merged branches are kept.
Retarget it to `dev`, update it with `bundle-modernize`, then push so CI runs.
GitHub also skips CI on a conflicting PR, so its old green checks mean
nothing.

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

Run `git fetch` and count `git rev-list --count <head>..origin/<base>`. GitHub
does not report BEHIND here, because `dev` requires no status check. If a
feature or fix PR is behind or has conflicts, first run `gh pr list --base
<branch>`, and stop if another PR stacks on it. Ask the owner if the branch is
not the user's. Record the PR's head SHA, rebase exactly that commit onto
`origin/<base>`, and rerun `npm run lint`, `npm run typecheck` and `npm test`.
Push with `--force-with-lease=<branch>:<recorded SHA>`, because the bare flag
can erase a teammate's commit after a fetch. Never rebase `dev` for a release
PR.

Merge only when the user asked for it. Otherwise report that the PR is ready,
with the head SHA, the check results and the preview link. Never merge a red,
conflicting or outdated PR, and never merge `dev` into `main` without the team's
release decision.
