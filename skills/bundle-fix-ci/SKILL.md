---
name: bundle-fix-ci
description: Use when a specific Bundle Events PR check or GitHub Actions run fails.
---

# Bundle fix ci

Identify the failed run, commit, job and event, and compare its SHA with the
current branch before editing. Read the Actions logs. Follow job dependencies
back from a skipped job or a red PR summary to the first failing command. A
Discord webhook failure and a Next.js build failure have different owners.

Reproduce with the workflow's Node version, the lockfile and the exact command
when possible. Use the log to tell an application failure from a workflow
logic error or a runner or service outage. For a fork-only failure, check
which permissions and secrets that event receives. Keep the check's purpose
while repairing it.

Run the failing command after the change. When asked to update the PR, push
the fix and check the new run against its SHA. Retry an unchanged run only
when the evidence points to a transient problem. Finish with the causal log
line, the fix, and which hosted checks are still unverified.
