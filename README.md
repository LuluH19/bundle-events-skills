# Bundle Events agent skills

Use these skills from the Bundle Events application checkout. Each one works independently.

| Skill | Try saying |
| --- | --- |
| [bundle-provider-triage](skills/bundle-provider-triage/SKILL.md) | “A Paris venue appears in the provider response but disappears from search. Find where it gets dropped.” |
| [bundle-fare-check](skills/bundle-fare-check/SKILL.md) | “After I switch to one way, the recap still looks like a round-trip price. Reconcile the total.” |
| [bundle-replay](skills/bundle-replay/SKILL.md) | “My hotel is selected until I share the bundle. Reproduce what the recipient sees.” |
| [bundle-file-pr](skills/bundle-file-pr/SKILL.md) | “File this hotel fallback fix against dev and include the verification results.” |
| [bundle-review](skills/bundle-review/SKILL.md) | “Review this branch for regressions when someone opens an older shared bundle.” |
| [bundle-walkthrough](skills/bundle-walkthrough/SKILL.md) | “Where does the hotel display name come from?” |
| [bundle-regression-test](skills/bundle-regression-test/SKILL.md) | “Capture the missing return fare in a failing test.” |
| [bundle-fix-ci](skills/bundle-fix-ci/SKILL.md) | “Find the first failing command on this PR and fix it.” |
| [bundle-council](skills/bundle-council/SKILL.md) | “Council: review this branch before I file the PR.” |
| [bundle-deslop](skills/bundle-deslop/SKILL.md) | “Deslop this diff.” |
| [bundle-api-cache](skills/bundle-api-cache/SKILL.md) | “Put the new SNCF call behind the shared cache.” |
| [bundle-new-provider](skills/bundle-new-provider/SKILL.md) | “Add Eventbrite as an events source after OpenAgenda.” |
| [bundle-snapshot-field](skills/bundle-snapshot-field/SKILL.md) | “Store the number of travellers in the trip without breaking old links.” |
| [bundle-booking-links](skills/bundle-booking-links/SKILL.md) | “The Trainline return link opens a one-way search.” |
| [bundle-transport-routing](skills/bundle-transport-routing/SKILL.md) | “Why is there no train option from Lyon to Grenoble?” |
| [bundle-hotels](skills/bundle-hotels/SKILL.md) | “All hotels near the Accor Arena show “Prix indisponible”.” |
| [bundle-event-search](skills/bundle-event-search/SKILL.md) | “The Zénith appears twice in event search.” |
| [bundle-share-email](skills/bundle-share-email/SKILL.md) | “The share email never arrives in production.” |
| [bundle-url-steps](skills/bundle-url-steps/SKILL.md) | “Rename the reserver step without breaking shared links.” |
| [bundle-docs-sync](skills/bundle-docs-sync/SKILL.md) | “Update docs/ for this change.” |
| [bundle-env-check](skills/bundle-env-check/SKILL.md) | “Events work locally but Ticketmaster is never used on Vercel.” |
| [bundle-design-system](skills/bundle-design-system/SKILL.md) | “Style the new refund badge with the design system.” |
| [bundle-e2e-flow](skills/bundle-e2e-flow/SKILL.md) | “Add a Playwright test for changing the hotel.” |

## Multi-model review

`bundle-council` asks three models from three providers to review the change read-only. You check each finding against the code, fix, and ask for a fresh round until they agree. In Cursor it starts delegates with the `Task` tool and sets `model` per delegate, so it needs an account that offers models from at least three providers. If fewer are reachable it stops and says so.

## Install from Git

Clone once, then choose your agent. The installer links skills into your personal agent directory. Run it from a POSIX shell such as macOS Terminal, Linux, or Git Bash with symlink support.

```sh
git clone https://github.com/LuluH19/bundle-events-skills.git
cd bundle-events-skills
./install.sh claude   # or codex or cursor
```

To install only selected skills, pass their names:

```sh
./install.sh cursor bundle-review bundle-fix-ci
```

Keep the clone where it is. Run `git pull --ff-only` there to update installed skills, then open a new agent session in Bundle Events. Rerun the installer to pick up newly added skills. To uninstall a skill, remove its symbolic link from the directory printed by the installer.
