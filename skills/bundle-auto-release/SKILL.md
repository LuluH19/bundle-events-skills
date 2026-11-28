---
name: bundle-auto-release
description: Use to set up, run, debug or reason about the automatic Bundle Events release that is published when a version tag is pushed. For a hand-curated or major release with pre-merge blocker checks, use bundle-release instead.
---

# Bundle auto release

The release follows the tag, never the other way round: no workflow creates a tag. Pushing
a `vX.Y.Z` tag that points at a commit on `main` publishes its GitHub release, through
.github/workflows/release.yml and .github/scripts/plan-release.mjs in the app repo. The
workflow:

- exits without a release if the tag is not `vX.Y.Z` or is not on `main`;
- finds the previous version tag that is an ancestor of this one;
- takes the title from the first line of the annotated tag (`v1.1.0 : Trip prices, day
  trips and real bus timetables`), or the tag name for a lightweight tag;
- writes the notes: the tag's message first, then the `feat`, `fix` and `perf` commit
  titles since the previous tag (✨ Features, 🐛 Fixes, ⚡ Performance), leaving out the
  scopes tests, docs, deps, ci, env and analytics, and a compare link. English is the
  release norm, so write the tag message in English; a French commit title stays French;
- publishes with `gh release create --verify-tag`, which fails rather than create a tag,
  and does nothing if the release already exists.

Choosing what deserves a tag is `bundle-tags`' job: only versions a user could notice.

Publishing fires the Discord ping in .github/workflows/discord-notify.yml (`release:
published`). That downstream workflow only runs when the release is created by a **PAT**, not
the default `GITHUB_TOKEN`: so for the Discord notification, set a repo secret `RELEASE_PAT`
(a fine-grained token with `contents: write`). Without it the release is still published,
just silently. Pushing several tags at once posts one message per tag.

## This does not replace the pre-merge gate

The workflow only announces what is already tagged on `main`; it cannot judge whether the
code is safe to ship. The pre-merge blockers stay human, in the `dev` → `main` release PR:
check that the Supabase migrations and tables the docs require exist in production, and
that the Vercel production variables are set. `bundle-release` still owns that curated
path. If it drafts a release by hand, publishing that draft creates the tag on GitHub and
the workflow then sees the release already exists and does nothing.

## Debug

Open the run under the repo's Actions → Release. The "Write notes" step prints the tag, its
title and the previous tag. No release usually means the tag is not on `main`, is not
`vX.Y.Z`, or the release already existed. To redo one, delete the GitHub release (keep the
tag) and re-run the job. Odd notes trace back to commit titles that are not Conventional
Commits: `git log <previous>..<tag> --no-merges --pretty=%s` shows what the script parsed.
