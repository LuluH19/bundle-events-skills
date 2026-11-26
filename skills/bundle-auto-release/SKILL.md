---
name: bundle-auto-release
description: Use to set up, run, debug or reason about the automatic Bundle Events release that fires on every push to main. For a hand-curated or major release with pre-merge blocker checks, use bundle-release instead.
---

# Bundle auto release

A push to `main` (i.e. a `dev` → `main` merge) cuts a GitHub release on its own, via
.github/workflows/release.yml and .github/scripts/plan-release.mjs in the app repo. The
workflow:

- finds the latest `vX.Y.Z` tag that is an ancestor of `main`, and reads the commits since;
- bumps the version from Conventional Commit types in that range — a `!` or `BREAKING CHANGE`
  is major, `feat` is minor, `fix`/`perf`/`refactor`/`revert` is patch; if only
  docs/chore/ci/test/style landed, it makes **no** release;
- writes grouped English notes (✨ Features, 🐛 Fixes, ⚡ Performance, 🔧 Internal, ⏪ Reverts)
  — English is the release norm — tags `main`'s HEAD and publishes the release. Each bullet is
  a commit title verbatim, so a non-English commit title stays in its own language.

Publishing fires the Discord ping in .github/workflows/discord-notify.yml (`release:
published`). That downstream workflow only runs when the release is created by a **PAT**, not
the default `GITHUB_TOKEN`: so for the Discord notification, set a repo secret `RELEASE_PAT`
(a fine-grained token with `contents: write`). Without it the release is still created, just
silently.

Opt a push out with `[skip release]` in the merge commit message. When this workflow first
lands on `main`, it releases the whole backlog since the last tag in one version — skip that
first merge if you would rather cut it by hand.

## This does not replace the pre-merge gate

Auto-release only tags and announces what already merged; it cannot judge whether the code is
safe to ship. The pre-merge blockers stay human, in the `dev` → `main` release PR: check that
the Supabase migrations and tables the docs require exist in production, and that the Vercel
production variables are set. `bundle-release` still owns that curated path — use it for a
major or risky release, and let auto-release handle routine ones. The two coexist: a manual
release tags the merge commit itself, so the auto run on that push sees the tag already on
HEAD and makes nothing.

## Debug

Open the run under the repo's Actions → Release. The "Compute next version and notes" step
prints the chosen version, the range and the commit count; a missing release usually means
only non-shippable types were in range, or the version tag already existed. To redo a release,
delete the tag and the GitHub release, then re-run the job or push an empty commit to `main`.
A wrong version almost always traces back to a commit whose title is not Conventional Commits —
`git log <lastTag>..HEAD --no-merges --pretty=%s` shows what the script parsed.
