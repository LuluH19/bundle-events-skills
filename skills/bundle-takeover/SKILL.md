---
name: bundle-takeover
description: Trigger this if the user asks to take over, pick up or continue a teammate's Bundle Events PR, branch or agent session.
---

# Bundle takeover

Take responsibility for finishing what the teammate set out to do while
keeping their credit. Do not defend their implementation just because it
exists, and do not rewrite it to your taste.

Read the PR description, every review thread, the linked issue, and any notes
the teammate left. Treat them as context, not proof. Check out the real head
and compare it with `origin/dev`. Ask the teammate whether they have unpushed
work before you start, because two people on one branch is the easiest way to
lose work. Restate the original goal in one sentence, and list what is done,
what is broken and what is missing.

By default, keep working on the same branch and add your own commits on top.
Do not rewrite or force-push someone else's commits unless they agree. If the
branch is stale, rebase it on `origin/dev` only after telling the owner, or
open a new branch from theirs and link the original PR. Fix only what the
original goal needs, and note other ideas as follow-ups. Use the matching area
skill, such as `bundle-hotels`, `bundle-snapshot-field` or `bundle-api-cache`,
and `bundle-docs-sync` before committing.

Keep the original commits and authors. If the PR will be squashed, add a
`Co-authored-by: Name <email>` trailer using the exact name and email from
their commits (`git log --format='%an <%ae>'`). Never guess an email. Mention
them in the PR description.

Run `npm run lint`, `npm run typecheck` and `npm test`, then check the changed
flow in the browser or the Vercel preview. Update or file the PR with
`bundle-file-pr` and follow it with `bundle-babysit-pr`. Close or merge the
original PR only when its owner or the user agrees.

Report what you inherited, what you changed, how you checked it, and anything
still undecided.
