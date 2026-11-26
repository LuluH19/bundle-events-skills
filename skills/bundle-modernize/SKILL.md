---
name: bundle-modernize
description: Use when asked to rebase, update, revive or modernize a Bundle Events PR or branch, or before starting an issue a teammate may already be fixing.
---

# Bundle modernize

Update the idea, not just the branch. A clean rebase does not prove the PR
still belongs in the product. Never rebase or force-push `dev` or `main`. For a
release PR, use `bundle-release`.

Find duplicate work first, apart from the PR you were given. Search open PRs,
then remote branches by issue number and by topic with `git ls-remote --heads
origin`, because teammates often push a branch without opening a PR. Issue
#178 ended up with `fix/cheapest-hotel` and `fix/178-cheap-hotel`, two
different fixes. If someone else is already on it, stop and tell the user who
and where. If the user only asked whether an issue is taken, answer and stop
here.

Record the PR's base, its head SHA, its author and its goal in one sentence.
Read the base with `gh pr view <pr> --json baseRefName`. It is usually `dev`,
but a stacked PR targets another feature branch. Run `git fetch` and read what
landed on the base since the merge base. Run `gh pr list --base <branch>` too.
If another PR stacks on this one, a rebase orphans it, so stop and tell the
user before rewriting anything.

GitHub's "mergeable" compares a PR with its base only, not with the other open
PRs. List the files each open PR touches with `gh pr view <n> --json files`.
HomeView.tsx, BundleBuilder.tsx, event-search.ts and src/config/events.ts are
the usual collisions. Say which PR should land first.

Old green checks are not current. #161 was green without any unit or E2E job,
because those joined CI in #203. GitHub also skips CI on a conflicting PR, so
its last checks stay on display. After a rebase onto `dev`, wait for today's
CI. A stacked PR gets no CI, so run the checks locally and say so.

Give one verdict before pushing:

- **MODERNIZE.** The goal and the shape still hold. Rebase.
- **REWORK.** The goal holds, but the code it changes was replaced. The old
  hotels, routes and bundle screens became TripView and BookView, so a PR that
  edits them is a rework. Describe the smallest rewrite and stop.
- **CLOSE.** The base already does it, or another PR does it better. Cite the
  PR or commit and stop. Never close it without permission.

For MODERNIZE, ask the branch owner about unpushed work before rewriting a
branch that is not the user's. Rebase in a separate worktree created at the
recorded head, never from a local branch that may be behind it. When a stacked
PR's parent was rewritten or squash-merged, use `git rebase --onto <new base>
<old base>` so the parent's old commits are not replayed. Resolve each
conflict toward the PR's goal and the base's newer rules. Two rules outrank
both sides: a saved bundle that lacks a field must still load, and an old URL
segment must still redirect (`bundle-snapshot-field`). Regenerate
package-lock.json with npm 11 instead of merging it by hand, as
docs/getting-started/installation.md requires.

Compare before and after with `git range-diff`. Run `npm run lint`, `npm run
typecheck` and `npm test`, then check the changed flow with `bundle-try-app`.
Push with `--force-with-lease=<branch>:<recorded head>`. If the lease fails,
fetch and look again. Keep the original authors, and never guess an email for
a `Co-authored-by` trailer.

Report the verdict first, then the conflicts that mattered, the checks with
their results, and what you could not verify. Do not merge.
