---
name: bundle-release
description: Trigger this if the user asks to release, or to ship Bundle Events from dev to main.
---

# Bundle release

Releases go from `dev` into `main`, then `main` is merged back into `dev`.
Publishing a GitHub release triggers the Discord notification in
.github/workflows/discord-notify.yml.

First check there is something to ship with `git diff --stat origin/main
origin/dev`. An empty diff means no release, even if commit ranges show
merges.

Collect the changes from PR metadata, not commit ranges, which pick up branch
syncs and miss squash merges. Not every production merge gets a GitHub
release, so do not cut off at the last release date. List the PRs merged into
`dev` with `gh pr list --base dev --state merged --limit 100 --json
number,title,mergeCommit`, and keep only those whose merge commit is not in
production yet, where `git merge-base --is-ancestor <sha> origin/main` fails.
Drop back-merges from `main`, and group the rest by type from their
Conventional Commit titles.

Diff .env.example, docs/getting-started/environment.md, docs/database/ and
supabase/migrations/ between `origin/main` and `origin/dev`. Ask the devops
dev to confirm which tables and functions the docs require actually exist in
production, such as `api_cache`, `api_usage` and `increment_api_usage`. If one
is missing and its migration file is not committed, mark that item as a
blocker until a reviewed script exists. Print a checklist of Vercel production
variables to set and SQL to run in Supabase before the merge, and never print
secret values.

Open the release PR from `dev` to `main` with a Conventional Commits title
naming the release, and fill the template: the grouped change list under
Description, the closed issues, and only the checklist items you verified.
Past release PRs went out with an empty template. Commit Lint is skipped on
PRs into `main`, so check which jobs actually ran before calling the PR green.
After it merges, open the back-merge PR from `main` to `dev` so the branches
do not drift.

A release never creates a tag. After the merge, tag the release merge commit on
`main` with `bundle-tags`, which decides whether the change deserves a version.
Pushing that tag publishes the GitHub release through the Release workflow and
notifies Discord (see `bundle-auto-release`), so push it only when the user
asks. To curate the notes, edit the published release afterwards; never create
a release whose tag does not exist yet (`gh release create --verify-tag`).

Do not merge either PR without the user's go-ahead. Report the PR links, the
checklist and the draft notes.
