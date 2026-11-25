# Arsenal de sécurité — origine et licence

`security/arsenal/` est une copie **non modifiée** de **Claude-BugHunter**, un cadre
de test de sécurité offensive pour Claude.

- Source : https://github.com/elementalsouls/Claude-BugHunter
- Commit repris : `6a2153d9932adf41fa4d7f5dee626047c5005a83` (25/11/2026)
- Auteur : Sachin Sharma (voir `security/arsenal/docs/credits.md`)
- Licence du code : MIT (`security/arsenal/LICENSE`)
- Licence du contenu et des skills : CC BY 4.0 (`security/arsenal/LICENSE-CONTENT`)

Les deux licences autorisent la redistribution avec attribution ; ce fichier et les
fichiers de licence conservés dans `security/arsenal/` la fournissent.

## Ce qu'on a retiré de la copie

Rien du contenu. Seuls des visuels promotionnels sans rapport ont été exclus :
`assets/banner.png`, `assets/sponsors/` et `assets/star-history-*`. Les schémas
d'architecture (`docs/assets/`, `assets/*.svg`) sont conservés.

## Comment on s'en sert

L'arsenal est de la documentation de référence (skills, commandes, recettes), pas une
dépendance installée. Le skill d'équipe [`bundle-security`](../skills/bundle-security/SKILL.md)
s'appuie dessus pour deux usages, toujours **sur nos propres actifs uniquement**
(voir les règles de périmètre dans ce skill) :

- **Blue team** : la revue défensive de nos PR (fuites de secrets, routes, Supabase…).
- **Red team** : des exercices d'attaque contre notre app lancée en local ou un preview
  Vercel à nous, pour éprouver la défense.

`install.sh` ne lie que les skills `bundle-*` dans le dossier de l'agent : l'arsenal
n'est volontairement pas installé comme 84 skills personnels. On pointe l'agent vers
`security/arsenal/skills/<nom>/SKILL.md` au besoin, ou on installe Claude-BugHunter
comme plugin séparé en suivant son `security/arsenal/INSTALL.md`.

## Mettre à jour la copie

```sh
git clone https://github.com/elementalsouls/Claude-BugHunter.git /tmp/cbh
rsync -a --delete --exclude='.git' --exclude='assets/banner.png' \
  --exclude='assets/sponsors' --exclude='assets/star-history-*' \
  /tmp/cbh/ security/arsenal/
```

Puis noter ici le nouveau commit repris. Ne pas éditer les fichiers de
`security/arsenal/` à la main : garder la copie fidèle pour pouvoir la resynchroniser.
