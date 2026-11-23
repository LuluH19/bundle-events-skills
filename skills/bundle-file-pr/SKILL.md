---
name: bundle-file-pr
description: Trigger this if the user asks to file, open or draft a Bundle Events PR.
---

# Bundle file pr

Read the contribution docs and .github/PULL_REQUEST_TEMPLATE.md. Feature and
fix branches target `dev` unless the user asks for another base. Inspect the
merge-base diff, the commits and the working tree separately, so the
description matches what the remote head will contain. Check for an existing
PR with the same head and base before creating one.

Use a Conventional Commits title that names the outcome. Fill the template in
place and keep the checklist wording CI relies on. Describe the
traveller-facing change or the engineering problem, link a real issue when
there is one, and point reviewers to the part that needs judgment. For a
visual change, include before and after screenshots. Tick only the checklist
items you verified.

Run `npm run lint`, `npm run typecheck` and `npm test` first, plus a focused
browser or build check when the change depends on it. Name any failure or
missing prerequisite precisely.

For a draft, return the title and body. For a filing, push the branch and
create or update the PR, keeping existing reviewer and author notes. Return
the PR link, the base and the verification results.
