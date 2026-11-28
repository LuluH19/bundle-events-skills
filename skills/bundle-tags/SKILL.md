---
name: bundle-tags
description: Trigger this if the user asks to tag, to create the missing tags, or to catch up versions for Bundle Events. Reviews the history from the current checkout back to the latest vX.Y.Z tag and tags only the releases that bring a user-visible milestone, never a merge just because it landed on main.
---

# Bundle tags

A tag marks a version of the product that a user could tell apart from the previous one.
This skill looks at the commits between the latest version tag and the commit checked out
now, finds what reached production since, and creates a tag only where it marks a real,
user-visible milestone. A merge into `main` is not a reason to tag by itself. The skill
never moves, deletes or overwrites a tag. Nothing else creates a tag: the Release workflow publishes, on
every push to `main`, the release of the latest tag on `main`, so a tag placed now is
released at the next merge into `main`.

## 1. Read the history

- `git fetch origin --tags --prune`. Uncommitted changes cannot be tagged: list them in the
  report and go on with `HEAD`.
- `T` is `HEAD`. The base is the latest version tag reachable from it:
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
(`git tag --points-at <sha>`). For each one in order, read the commits and PR titles it
brought, `git log --no-merges --format='%s%n%b' <previous>..<sha>`. These merges are
candidates, not tags.

### Is it worth a tag?

Read what changed, not the commit types. A commit typed `feat` can be a test, a doc or an
env file (`feat(tests): …`, `feat(docs): …`), and a `fix: typescript` changes nothing for
a user. Keep only the user-facing changes: a new screen or option, a change in results,
prices, routes, hotels or booking links, a bug a user could hit, a visible speed-up, a
security fix. Leave out tests, docs, CI, dependency bumps without an advisory, refactors,
analytics and logging, config, and back-merges.

- A candidate with no user-facing change gets no tag. Its commits roll into the next one.
- Merges a few days apart that ship one story (the follow-ups of a feature, a hotfix the
  day after) get **one** tag, on the last merge of the group. Tag an earlier merge on its
  own only if it stayed in production long enough to matter: about a week, or it was
  demoed or announced.
- A security fix or a fix for a broken production flow gets its own patch tag, even alone.
- You must be able to name the tag in a few English words that a user would understand,
  e.g. « Trip prices, day trips and real bus timetables ». If the title would be « misc
  fixes » or « update », there is no tag.

Then bump from the previous version, counting only the changes you kept: breaking for
users (a shared link or saved trip that stops working, a removed feature) is major, a new
user-facing feature is minor, user-facing fixes and speed-ups alone are patch.

Commits on `dev` (or `T`) that are not on `main` yet get **no** tag: they are not in
production. Tag them once they are merged into `main`.

Do not tag one PR at a time, as was done for v0.2 to v0.4, unless the user asks for it;
even then, a PR that changes nothing for a user gets no tag.

## 3. Create and push

- For each version, check it does not exist anywhere: `git tag -l vX.Y.Z` and
  `git ls-remote --tags origin vX.Y.Z` must both be empty. If it does, stop and report the
  clash; never reuse a version.
- Write the message in English, like the existing tags: a first line
  `vX.Y.Z : <short title>`, a blank line, then one bullet per user-facing change kept
  above, written for a user rather than copied from a commit, drawn from the PR titles
  merged in that range (`GET /repos/LuluH19/bundle-events/pulls?state=closed&base=dev`,
  keeping those whose `merge_commit_sha` is in the range). Translate French titles; leave
  out dependency bumps, back-merges and CI.
- `git tag -a vX.Y.Z <sha> -F <message file>`, then show the plan: version, commit, date,
  PR merged, title. Only the newest tag gets a release at the next merge into `main`;
  older catch-up tags get none unless one is published by hand. If the user asked to
  create the tags, push each one, oldest first, with
  `git push origin vX.Y.Z`. If they only asked to check, stop at the plan. Never
  `git push --tags` (it would push stray local tags) and never `--force`.

## 4. Report

List each tag created, with its commit, the PRs it covers and the changes that justify it.
List each candidate left untagged and why: nothing a user would notice, grouped into a
later tag, or not on `main` yet. Say that the newest tag will be released at the next push to
`main`.
Older tags v0.4.2 to v0.7.0 have no release.
