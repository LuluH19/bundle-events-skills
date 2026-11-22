# Bundle Events agent skills

Use these skills from the Bundle Events application checkout. Each one works independently.

| Skill | Try saying |
| --- | --- |
| [bundle-provider-triage](skills/bundle-provider-triage/SKILL.md) | “A Paris venue appears in the provider response but disappears from search. Find where it gets dropped.” |
| [bundle-fare-check](skills/bundle-fare-check/SKILL.md) | “After I switch to one way, the recap still looks like a round-trip price. Reconcile the total.” |
| [bundle-replay](skills/bundle-replay/SKILL.md) | “My hotel is selected until I share the bundle. Reproduce what the recipient sees.” |
| [bundle-file-pr](skills/bundle-file-pr/SKILL.md) | “File this hotel fallback fix against dev and include the verification results.” |
| [bundle-review](skills/bundle-review/SKILL.md) | “Review this branch for regressions when someone opens an older shared bundle.” |
| [bundle-improve-ci](skills/bundle-improve-ci/SKILL.md) | “Make sure a failing Vitest test fails the PR checks and appears in the CI summary.” |
| [bundle-walkthrough](skills/bundle-walkthrough/SKILL.md) | “Where does the hotel display name come from?” |
| [bundle-change-impact](skills/bundle-change-impact/SKILL.md) | “What would renaming this saved-trip field break?” |
| [bundle-regression-test](skills/bundle-regression-test/SKILL.md) | “Capture the missing return fare in a failing test.” |
| [bundle-fix-ci](skills/bundle-fix-ci/SKILL.md) | “Find the first failing command on this PR and fix it.” |

These four workflows draw on [pstack](https://github.com/michael-denyer/pstack-claude).

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
