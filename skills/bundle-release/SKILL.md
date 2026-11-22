---
name: bundle-release
description: Prepare a Bundle Events release from dev to main, the merge back into dev, and the GitHub release notes. Use when cutting a release or shipping dev to production.
---

# Bundle release

Releases go from `dev` into `main` (production on Vercel), then `main` is merged back into `dev`. Publishing a GitHub release triggers the Discord notification in .github/workflows/discord-notify.yml.

1. Check there is something to ship: `git diff --stat origin/main origin/dev`. An empty diff means no release, even if commit ranges show merges.
2. Collect the changes from PR metadata, not commit ranges, which also pick up branch syncs and miss squash merges. Take the date of the latest published release (`gh release list --limit 1`), then `gh pr list --base dev --state merged --search "merged:>YYYY-MM-DD" --json number,title`. Drop back-merges from `main`. Group the rest by type from their Conventional Commit titles.
3. Production readiness: diff `.env.example`, docs/getting-started/environment.md, docs/database/ and supabase/migrations/ between `origin/main` and `origin/dev`. Also list SQL the docs require that may never have been applied in production, such as the api_cache tables. Print a checklist of Vercel production variables to set and SQL to run in Supabase before the merge. Ask the devops dev to confirm each item. Never print secret values.
4. Open the release PR from `dev` to `main` with a Conventional Commit title naming the release and the template filled in: the grouped change list under Description, the closed issues, and the checklist ticked only for what was verified. Past release PRs went out with an empty template. Commit Lint is skipped on PRs into `main`. Check which jobs actually ran on the PR before calling it green.
5. After it merges, open the back-merge PR from `main` to `dev` so the branches do not drift.
6. Draft the GitHub release: pick the next version from the published releases (`gh release list`), check the tag does not exist yet, and pin it to the release merge commit on `main` with `--target <sha>`, not to `dev` (v1.0.0 points at an older `dev` commit). Add a title and notes in French for the team (they are posted to Discord, truncated at 1500 characters). Publish only when the user asks, because publishing notifies Discord.

Do not merge either PR without the user's go-ahead. Report the PR links, the checklist and the draft notes.
