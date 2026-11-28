---
name: bundle-tags
description: Trigger this if the user asks to tag, to create the missing tags, or to catch up versions for Bundle Events. Reviews the history from the current checkout back to the latest vX.Y.Z tag and creates every missing version tag.
---

# Bundle tags

Tags mark what reached production. This skill looks at the commits between the latest
version tag and the commit checked out now, finds every production release that has no
tag, and creates one annotated tag per release. It never moves, deletes or overwrites a
tag, and it publishes no GitHub release.

## 1. Read the history

- `git fetch origin --tags --prune`. Uncommitted changes cannot be tagged: list them in the
  report and go on with `HEAD`.
- `T` is `HEAD`. The base is the latest version tag reachable from it, the same rule the
  auto-release uses:
  `git tag --merged HEAD --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -1`.
- Also read the highest version tag overall (`git tag --sort=-v:refname`). New versions
  must be above it, even when it is not an ancestor: `v1.0.0` points at an old `dev`
  commit, not at a merge on `main`.
- Only tag commits that are on `origin/main`. A commit that exists only on a feature
  branch can still be rebased or squashed away.

## 2. Find the releases to tag

A release is a merge into `main`, usually « Merge pull request #N from LuluH19/dev »:

```sh
git log --first-parent --merges --reverse --format='%H %ad %s' --date=short <base>..origin/main
```

Keep the merges that contain the base tag (`git merge-base --is-ancestor <base> <sha>`;
this drops #117, which predates v1.0.0 but is not its ancestor), that are ancestors of `T`
(`git merge-base --is-ancestor <sha> HEAD`) and that have no tag yet
(`git tag --points-at <sha>`). For each one in order, read the commits it
brought, `git log --no-merges --format='%s%n%b' <previous>..<sha>`, and bump the version
from the previous one with the auto-release rules:

- `!` after the type or a `BREAKING CHANGE` footer: major;
- `feat`: minor;
- `fix`, `perf`, `refactor`, `revert`: patch;
- only `docs`, `chore`, `ci`, `test`, `style` or `build`: no tag for that merge.

Commits on `dev` (or `T`) that are not on `main` yet get **no** tag. The auto-release
workflow tags them on the next `dev` → `main` merge. A tag on a `dev` commit would break
that run: it would see the tag as its base, find nothing new, and publish neither the
release nor the Discord message. Tag it only if the user insists after hearing this.

When the user asks for « un tag par PR », as was done for v0.2 to v0.4, release points
are the PR merge commits on `dev` (`git log --first-parent --merges <base>..T`) instead,
with the same bump rules and the same ban on untagged work after the last `main` merge.

## 3. Create and push

- For each version, check it does not exist anywhere: `git tag -l vX.Y.Z` and
  `git ls-remote --tags origin vX.Y.Z` must both be empty. If it does, stop and report the
  clash; never reuse a version.
- Write the message in English, like the existing tags: a first line
  `vX.Y.Z : <short title>`, a blank line, then one bullet per user-facing change, drawn
  from the PR titles merged in that range (`GET /repos/LuluH19/bundle-events/pulls?state=closed&base=dev`,
  keeping those whose `merge_commit_sha` is in the range). Translate French titles; leave
  out dependency bumps, back-merges and CI.
- `git tag -a vX.Y.Z <sha> -F <message file>`, then show the plan: version, commit, date,
  PR merged, title. If the user asked to create the tags, push each one with
  `git push origin vX.Y.Z`. If they only asked to check, stop at the plan. Never
  `git push --tags` (it would push stray local tags) and never `--force`.

## 4. Report

List each tag created, with its commit and the PR it marks. List what was left untagged and
why: no shippable change, or not on `main` yet. Tags do not create GitHub releases, and
publishing a release notifies Discord, so offer draft releases through `bundle-release`
rather than publishing them. Older tags v0.4.2 to v0.7.0 have no release either.
