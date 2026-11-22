---
name: bundle-takeover
description: Finish a teammate's Bundle Events PR, branch or agent session while keeping their credit. Use when asked to take over, pick up or continue someone else's work.
---

# Bundle takeover

The goal is to finish what the teammate set out to do, not to defend their implementation or rewrite it to your taste.

## Understand the handoff

1. Read the PR description, every review thread, the linked issue, and any notes the teammate left in chat or in the PR. Treat them as context, not proof.
2. Check out the real head and compare it with `origin/dev`. Ask the teammate whether they have unpushed work before you start. With four devs, two people on one branch is the most common way to lose work.
3. Restate the original goal in one sentence, and list what is done, what is broken and what is missing.

## Continue the work

- Default: keep working on the same branch, adding your own commits on top. Do not rewrite or force-push someone else's commits unless they agree.
- If the branch is stale, rebase it on `origin/dev` only after telling the owner, or open a new branch from theirs and link the original PR.
- Fix only what is needed to reach the original goal. Note other ideas as follow-ups.
- Use the area skill that matches the change, such as `bundle-hotels`, `bundle-snapshot-field` or `bundle-api-cache`, and `bundle-docs-sync` before committing.

## Keep their credit

Keep the original commits and authors. If the PR will be squashed, add a `Co-authored-by: Name <email>` trailer for the teammate using the exact name and email from their own commits (`git log --format='%an <%ae>'`). Never guess an email. Mention them in the PR description.

## Finish

Run `npm run lint`, `npm run typecheck` and `npm test`, then check the changed flow in the browser or the Vercel preview. Update or file the PR with `bundle-file-pr`, then follow it with `bundle-babysit-pr`. Close or merge the original PR only when its owner or the user agrees.

Report what you inherited, what you changed, how you checked it, and anything still undecided.
