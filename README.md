# Bundle Events agent skills

Use these skills from the Bundle Events application checkout. Each one works independently.

| Skill | Try saying |
| --- | --- |
| [bundle-fare-check](skills/bundle-fare-check/SKILL.md) | “After I switch to one way, the recap still looks like a round-trip price. Reconcile the total.” |
| [bundle-review](skills/bundle-review/SKILL.md) | “Review this branch for regressions when someone opens an older shared bundle.” |
| [bundle-babysit-pr](skills/bundle-babysit-pr/SKILL.md) | “Babysit my hotel fallback PR until it is ready.” |
| [bundle-orchestrate](skills/bundle-orchestrate/SKILL.md) | “Orchestrate this issue up to a draft PR.” |
| [bundle-council](skills/bundle-council/SKILL.md) | “Council: review this branch before I file the PR.” |
| [bundle-api-cache](skills/bundle-api-cache/SKILL.md) | “Put the new SNCF call behind the shared cache.” |
| [bundle-new-provider](skills/bundle-new-provider/SKILL.md) | “Add Eventbrite as an events source after OpenAgenda.” |
| [bundle-snapshot-field](skills/bundle-snapshot-field/SKILL.md) | “Store the number of travellers in the trip without breaking old links.” or “My hotel is selected until I share the bundle.” |
| [bundle-booking-links](skills/bundle-booking-links/SKILL.md) | “The Trainline return link opens a one-way search.” |
| [bundle-transport-routing](skills/bundle-transport-routing/SKILL.md) | “Why is there no train option from Lyon to Grenoble?” |
| [bundle-hotels](skills/bundle-hotels/SKILL.md) | “All hotels near the Accor Arena show “Prix indisponible”.” |
| [bundle-event-search](skills/bundle-event-search/SKILL.md) | “The Zénith appears twice in event search.” |
| [bundle-share-email](skills/bundle-share-email/SKILL.md) | “The share email never arrives in production.” |
| [bundle-env-check](skills/bundle-env-check/SKILL.md) | “Events work locally but Ticketmaster is never used on Vercel.” |
| [bundle-e2e-flow](skills/bundle-e2e-flow/SKILL.md) | “Add a Playwright test for changing the hotel.” |
| [bundle-analytics-event](skills/bundle-analytics-event/SKILL.md) | “Track clicks on the new hotel booking button.” |
| [bundle-route-guard](skills/bundle-route-guard/SKILL.md) | “Add a timeout and input checks to /api/trains/search.” |
| [bundle-map-rendering](skills/bundle-map-rendering/SKILL.md) | “The return route line is missing on the map.” |
| [bundle-trip-dates](skills/bundle-trip-dates/SKILL.md) | “A same-day return searches trains before my arrival.” |
| [bundle-supabase-migration](skills/bundle-supabase-migration/SKILL.md) | “Add a user_id column to bundles.” |
| [bundle-release](skills/bundle-release/SKILL.md) | “Prepare the release from dev to main.” |

## Multi-model review

`bundle-council` asks several models to review the change read-only. You check each finding against the code, fix, and ask for a fresh round until they agree. It uses three providers when your agent can reach them. With one subscription, such as Claude Code alone, it uses different models from that provider and says so in the results.

## Orchestration

`bundle-orchestrate` takes one feature through scope, frozen tests, code, checks, council review and a draft PR. It needs no particular agent: it uses the subagent tool yours has, plus Git and `gh`. Install it with `bundle-council`, `bundle-review`, `bundle-e2e-flow` and `bundle-babysit-pr`, which it calls. It allows two correction rounds, never merges, and keeps its progress in the Git directory so another session can resume it.

## Install from Git

Clone once, then choose your agent. The installer links skills into your personal agent directory. Run it from a POSIX shell such as macOS Terminal, Linux, or Git Bash with symlink support.

```sh
git clone https://github.com/LuluH19/bundle-events-skills.git
cd bundle-events-skills
./install.sh claude   # or codex or cursor
```

To install only selected skills, pass their names:

```sh
./install.sh cursor bundle-api-cache bundle-babysit-pr
```

Keep the clone where it is. Run `git pull --ff-only` there to update installed skills, then open a new agent session in Bundle Events. Rerun the installer to pick up newly added skills. To uninstall a skill, remove its symbolic link from the directory printed by the installer.

A pull that removes skills leaves broken links behind. Delete them with `find -L <directory> -maxdepth 1 -name 'bundle-*' -type l -exec rm -- {} +`, using the directory printed by the installer.

## Top 5

If you install only five skills, take these.

1. [bundle-snapshot-field](skills/bundle-snapshot-field/SKILL.md). Almost every feature changes what a trip stores, and a mistake breaks links people already shared. Old rows are never migrated, so this is the most expensive bug to ship.
2. [bundle-api-cache](skills/bundle-api-cache/SKILL.md). Most providers are paid or rate-limited, and the cache rules are easy to get wrong: a fetcher that returns `[]` instead of throwing silently disables the fallback.
3. [bundle-transport-routing](skills/bundle-transport-routing/SKILL.md). Routing is the core of the product and has the most hidden branches: distance thresholds, the short-haul flight ban, and a fallback for every segment type. It turns "why is this option missing?" into a short trace.
4. [bundle-route-guard](skills/bundle-route-guard/SKILL.md). Timeouts and input checks keep landing one PR at a time (#169, #198, #199, #201), and several provider calls still have no timeout. This skill does the whole checklist at once.
5. [bundle-babysit-pr](skills/bundle-babysit-pr/SKILL.md). Every dev opens PRs, whatever their agent. It knows the real CI jobs, the docs-only skip, the Vercel preview and the `dev` to `main` flow, and works in Cursor, Claude Code, Codex and T3 Code.
