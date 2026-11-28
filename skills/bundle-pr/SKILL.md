---
name: bundle-pr
description: Trigger this if the user asks to open, create or send a PR for Bundle Events. Pushes the current branch, opens the PR with the repo's template filled from verified facts, and requests the review from Roland-HUON or LuluH19.
---

# Bundle PR

Opens the pull request for the branch you are on, in LuluH19/bundle-events (or
LuluH19/bundle-events-skills when run from the skills clone). Never merge it.

## 1. Check the branch

- Run `git fetch origin`. Refuse to open a PR from `dev` or `main`: create a branch first.
- Uncommitted changes are not in the PR. Commit them only when the user's request says so,
  with a Conventional Commits message; otherwise list them in your report.
- If the head branch already has an open PR, update that PR's body and reviewers instead
  of opening a second one.
- Pick the base. It is `dev`, unless the branch was cut from another open PR's branch:
  for each open PR head `B`, if `origin/B` is an ancestor of `HEAD` and not of `origin/dev`,
  the PR is stacked. Use the closest such `B` as base and write « À merger après #N » at
  the top of the description.
- Push with `git push -u origin HEAD`. Never force-push a branch someone else pushed to.

## 2. Verify, then fill the template

Read `.github/PULL_REQUEST_TEMPLATE.md` from the branch and keep every heading in order.
Tick a box only for what you checked in this run; leave the others unticked and say why
under « Notes for reviewers ». Headings stay in English; write the content in French, as
the team does.

- **Title**: `type: description`, English, imperative, no `(scope)`, under 72 characters,
  e.g. `feat: filter event ideas by category`. A `!` after the type only for a breaking change.
- **Description**: one sentence on the problem or the user feedback, then short bullets of
  what changed, with the main files in backticks. Describe behaviour, not every file.
- **User Stories / Issues**: issue numbers from the branch name (`US137`, `fix/178-…`) and
  from commit messages. Check each issue exists with the API. Use `Closes #N` only when
  the branch fully solves it, `Refs #N` otherwise. With no issue, write « Aucune ».
- **Type of change**: tick the Conventional Commit types found in
  `git log origin/<base>..HEAD --no-merges --format=%s`. Tick « Breaking change » only for a
  `!` or a `BREAKING CHANGE` footer.
- **Checklist**:
  - title: tick when it matches `^(feat|fix|refactor|style|perf|docs|test|ci|build|chore|revert)!?: .+`;
  - `npm run dev`: tick only if you opened the changed screens and saw no error in the
    console or the server log;
  - `npm run build`: run it. Also run `npx tsc --noEmit`, `npx eslint src` and
    `npx vitest run`, and report their results in the notes. If the build fails for a local
    reason, such as `node_modules` out of date with the lockfile, leave the box unticked
    and say that CI will check it;
  - architecture: tick when every new external call lives in `services/` (fetching),
    `adapters/` (mapping) and `config/` (endpoints, limits), with no `fetch(` in a component;
  - secrets: run the blue-team secret scan from `bundle-security` (gitleaks on the branch's
    history and the working tree) and tick only if it finds nothing. If it finds a key,
    stop: do not open the PR, and tell the user what was found without printing the value;
  - documentation: tick when `docs/` changes alongside behaviour, structure, API or env
    changes, or when the change needs none (say which).
- **Screenshots / Demo**: the API cannot attach images. For a UI change, say what you
  checked (screen, 375 px and 1280 px, keyboard) and ask the author to drop screenshots
  in. Otherwise write « N/A ».
- **Notes for reviewers**: stacking and merge order, environment variables or Supabase
  SQL to apply before merging (names only, never values), follow-ups, anything unticked.

The skills repo has no template: use Description and Notes for reviewers only.

## 3. Open the PR and request the review

Use `gh` when installed. Otherwise call the REST API with the stored Git credential, read
into a variable and never printed:
`TOK=$(printf 'protocol=https\nhost=github.com\n\n' | git credential fill | sed -n 's/^password=//p')`,
then `curl -H "Authorization: Bearer $TOK"`. Write the body to a JSON file with Node, so
quotes and accents survive, and post it to `POST /repos/{owner}/{repo}/pulls`.

The reviewers are the two maintainers, GitHub logins `Roland-HUON` and `LuluH19`. GitHub
refuses a review request to the PR's author, so:

| Author | Reviewer requested |
| --- | --- |
| `Roland-HUON` | `LuluH19` |
| `LuluH19` | `Roland-HUON` |
| anyone else | both; one approval is enough |

Send `POST /repos/{owner}/{repo}/pulls/{n}/requested_reviewers` with `{"reviewers": [...]}`
(or `gh pr edit {n} --add-reviewer`), and assign the author with
`POST /repos/{owner}/{repo}/issues/{n}/assignees`. Read the response: the login must be in
`requested_reviewers`. A 422 means the login is the author or not a collaborator; report
it rather than retrying with someone else.

## 4. Report

Give the PR link, the base (and merge order if stacked), the reviewer requested, the boxes
left unticked with the reason, and the commands run with their result. Hand the PR to
`bundle-babysit-pr` if the user wants it watched. Never merge, even when it is green.
