# Skills d'agent pour Bundle Events

Utilisez ces skills depuis votre copie locale de l'application Bundle Events. Chacun fonctionne seul, sauf `bundle-orchestrate`, qui en appelle d'autres.

| Skill | Exemple de demande |
| --- | --- |
| [bundle-fare-check](skills/bundle-fare-check/SKILL.md) | « Quand je passe en aller simple, le récapitulatif affiche encore un prix aller-retour. Corrige le total. » |
| [bundle-review](skills/bundle-review/SKILL.md) | « Relis cette branche et cherche les régressions à l'ouverture d'un ancien bundle partagé. » |
| [bundle-babysit-pr](skills/bundle-babysit-pr/SKILL.md) | « Babysit ma PR sur le repli des hôtels jusqu'à ce qu'elle soit prête. » |
| [bundle-orchestrate](skills/bundle-orchestrate/SKILL.md) | « Orchestrate cette issue jusqu'à une PR draft. » |
| [bundle-council](skills/bundle-council/SKILL.md) | « Council : relis cette branche avant que j'ouvre la PR. » |
| [bundle-api-cache](skills/bundle-api-cache/SKILL.md) | « Fais passer le nouvel appel SNCF par le cache partagé. » |
| [bundle-new-provider](skills/bundle-new-provider/SKILL.md) | « Ajoute Eventbrite comme source d'événements après OpenAgenda. » |
| [bundle-snapshot-field](skills/bundle-snapshot-field/SKILL.md) | « Enregistre le nombre de voyageurs dans le voyage sans casser les anciens liens. » ou « Mon hôtel reste sélectionné jusqu'à ce que je partage le bundle. » |
| [bundle-booking-links](skills/bundle-booking-links/SKILL.md) | « Le lien retour Trainline ouvre une recherche en aller simple. » |
| [bundle-transport-routing](skills/bundle-transport-routing/SKILL.md) | « Pourquoi n'y a-t-il pas de train entre Lyon et Grenoble ? » |
| [bundle-hotels](skills/bundle-hotels/SKILL.md) | « Tous les hôtels près de l'Accor Arena affichent “Prix indisponible”. » |
| [bundle-event-search](skills/bundle-event-search/SKILL.md) | « Le Zénith apparaît deux fois dans la recherche d'événements. » |
| [bundle-share-email](skills/bundle-share-email/SKILL.md) | « L'e-mail de partage n'arrive jamais en production. » |
| [bundle-env-check](skills/bundle-env-check/SKILL.md) | « Les événements marchent en local, mais Ticketmaster n'est jamais utilisé sur Vercel. » |
| [bundle-e2e-flow](skills/bundle-e2e-flow/SKILL.md) | « Ajoute un test Playwright pour le changement d'hôtel. » |
| [bundle-analytics-event](skills/bundle-analytics-event/SKILL.md) | « Suis les clics sur le nouveau bouton de réservation d'hôtel. » |
| [bundle-route-guard](skills/bundle-route-guard/SKILL.md) | « Ajoute un timeout et des contrôles d'entrée à /api/trains/search. » |
| [bundle-map-rendering](skills/bundle-map-rendering/SKILL.md) | « Le tracé du retour n'apparaît pas sur la carte. » |
| [bundle-trip-dates](skills/bundle-trip-dates/SKILL.md) | « Un retour le même jour cherche des trains avant mon arrivée. » |
| [bundle-supabase-migration](skills/bundle-supabase-migration/SKILL.md) | « Ajoute une colonne user_id à la table bundles. » |
| [bundle-release](skills/bundle-release/SKILL.md) | « Prépare la release de dev vers main. » |

## Revue par plusieurs modèles

`bundle-council` demande à plusieurs modèles de relire le changement en lecture seule. Vous vérifiez chaque constat dans le code, vous corrigez, puis vous demandez un nouveau tour jusqu'à ce qu'ils soient d'accord. Il utilise trois fournisseurs si votre agent peut les joindre. Avec un seul abonnement, par exemple Claude Code seul, il utilise différents modèles de ce fournisseur et le précise dans les résultats.

## Orchestration

`bundle-orchestrate` mène une fonctionnalité du cadrage à la PR draft : tests gelés, code, contrôles, revue par le council. Il ne dépend d'aucun agent en particulier : il utilise l'outil de sous-agents du vôtre, ainsi que Git et `gh`. Installez-le avec `bundle-council`, `bundle-review`, `bundle-e2e-flow` et `bundle-babysit-pr`, qu'il appelle. Il autorise deux tours de correction, ne merge jamais de lui-même et garde son avancement dans le dossier Git, pour qu'une autre session puisse reprendre.

## Installation depuis Git

Clonez le dépôt une fois, puis choisissez votre agent. L'installeur crée des liens vers les skills dans votre dossier d'agent personnel. Lancez-le depuis un shell POSIX : Terminal macOS, Linux ou Git Bash. Sous Windows, il crée des jonctions, qui ne demandent pas de droits administrateur.

```sh
git clone https://github.com/LuluH19/bundle-events-skills.git
cd bundle-events-skills
./install.sh claude   # ou codex ou cursor
```

| Agent | Dossier des skills |
| --- | --- |
| `claude` | `~/.claude/skills` |
| `codex` | `~/.agents/skills` |
| `cursor` | `~/.cursor/skills` |

Pour n'installer que certains skills, donnez leurs noms :

```sh
./install.sh cursor bundle-api-cache bundle-babysit-pr
```

Laissez le clone à sa place. Lancez-y `git pull --ff-only` pour mettre à jour les skills installés, puis ouvrez une nouvelle session d'agent dans Bundle Events. Relancez l'installeur pour récupérer les nouveaux skills. Pour désinstaller un skill, supprimez son lien avec `rm <dossier>/<skill>`, en utilisant le dossier affiché par l'installeur.

Si l'installeur affiche `Already occupied`, un autre fichier ou dossier porte déjà ce nom et rien n'a été installé. Sous Windows, il s'agit souvent d'une ancienne copie : déplacez-la ou supprimez-la, puis relancez l'installeur. Une copie identique au clone est remplacée automatiquement par un lien.

Un pull qui retire des skills laisse des liens cassés. Supprimez-les avec `find -L <dossier> -maxdepth 1 -name 'bundle-*' -type l -exec rm -- {} +`, en utilisant le dossier affiché par l'installeur.

## Top 5

Si vous n'installez que cinq skills, prenez ceux-ci.

1. [bundle-snapshot-field](skills/bundle-snapshot-field/SKILL.md). Presque chaque fonctionnalité change ce qu'un voyage enregistre, et une erreur casse des liens déjà partagés. Les anciennes lignes ne sont jamais migrées : c'est donc le bug le plus coûteux à livrer.
2. [bundle-api-cache](skills/bundle-api-cache/SKILL.md). La plupart des fournisseurs sont payants ou limités en nombre d'appels, et les règles du cache sont faciles à mal appliquer : une fonction d'appel qui renvoie `[]` au lieu de lever une erreur désactive le repli sans prévenir.
3. [bundle-transport-routing](skills/bundle-transport-routing/SKILL.md). Le calcul d'itinéraire est le cœur du produit et cache le plus de cas particuliers : seuils de distance, interdiction des vols courts et repli pour chaque type de segment. Ce skill transforme « pourquoi cette option manque-t-elle ? » en une courte recherche.
4. [bundle-route-guard](skills/bundle-route-guard/SKILL.md). Les timeouts et les contrôles d'entrée arrivent une PR à la fois (#169, #198, #199, #201), et plusieurs appels aux fournisseurs n'ont toujours pas de timeout. Ce skill traite toute la liste d'un coup.
5. [bundle-babysit-pr](skills/bundle-babysit-pr/SKILL.md). Tous les devs ouvrent des PR, quel que soit leur agent. Ce skill connaît les vrais jobs de CI, le cas des PR de documentation seule, la preview Vercel et le passage de `dev` à `main`. Il fonctionne dans Cursor, Claude Code, Codex et T3 Code.
