---
name: bundle-release
description: Prepare a Bundle Events release from dev to main, the merge back into dev, and the GitHub release notes. Use when cutting a release or shipping dev to production.
---

# Bundle release

Releases go from `dev` into `main` (production on Vercel), then `main` is merged back into `dev`. Publishing a GitHub release triggers the Discord notification in .github/workflows/discord-notify.yml.

1. Collect the changes: list PRs merged into `dev` since the last `main` merge (`git log origin/main..origin/dev --merges --oneline`) and the latest tag (`git tag --sort=-creatordate | head -1`). Group them by type from their Conventional Commit titles.
2. Production readiness: diff `.env.example`, docs/getting-started/environment.md and docs/database/ between `origin/main` and `origin/dev`. Print a checklist of Vercel production variables to set and SQL to run in Supabase before the merge. Ask the devops dev to confirm each item. Never print secret values.
3. Open the release PR from `dev` to `main` with a Conventional Commit title naming the release and the template filled in: the grouped change list under Description, the closed issues, and the checklist ticked only for what was verified. Past release PRs went out with an empty template. Commit Lint is skipped on PRs into `main`, but the PR title check still runs.
4. After it merges, open the back-merge PR from `main` to `dev` so the branches do not drift.
5. Draft the GitHub release: the next tag after the latest one, a title, and notes in French for the team (they are posted to Discord, truncated at 1500 characters). Publish only when the user asks, because publishing notifies Discord.

Do not merge either PR without the user's go-ahead. Report the PR links, the checklist and the draft notes.
