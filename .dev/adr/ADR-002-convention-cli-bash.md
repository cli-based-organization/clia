# ADR-002 - Convention de CLI bash du dépôt

- **Statut** : Accepté
- **Date** : 2026-07-10
- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `FND-2026-07-10-conventions-cli`, `ANL-2026-07-10-etat-clis-existants`, `PLN-004`

## Contexte

Les dépôts locaux contiennent de nombreux scripts bash aux conventions hétérogènes (voir ANL-2026-07-10-etat-clis-existants) : robustesse inconstante, options longues rares, `--version` quasi absent, séparation stdout/stderr non systématique, codes de sortie minimalistes, deux styles de nommage. FND-2026-07-10-conventions-cli établit les conventions de référence (POSIX, GNU, clig.dev). Il faut acter une convention unique pour tout nouveau CLI bash du dépôt, capitalisant sur les deux meilleures références locales : le pattern `activate` + `scripts/dev.sh` et le `script.sh.template`.

## Décision (résumé)

> Tout CLI bash du dépôt suit une convention unique : shebang `#!/usr/bin/env bash`, en-tête de robustesse `set -euo pipefail`, résolution de racine robuste, `trap` de nettoyage, dispatch par sous-commandes pour les outils multi-fonctions, `--help/-h` et `--version` obligatoires, séparation stricte stdout (données) / stderr (diagnostics), codes de sortie normalisés (0 succès, 2 erreur d'usage, 1 ou codes documentés pour les erreurs applicatives), options longues GNU en plus des courtes POSIX. Les détails vérifiables sont dans `REQ-001` ; la forme concrète dans `SPEC-001`.

## Décisions détaillées

### Robustesse

- **Décision** : `#!/usr/bin/env bash`, `set -euo pipefail`, quoting systématique, `trap` sur EXIT/ERR pour nettoyage et signalement, résolution de racine via `BASH_SOURCE` avec repli.
- *Alternatives écartées* : `set -eu` sans `pipefail` (adopté par `script.sh.template`) : rejeté, laisse passer les échecs en milieu de pipe ; `#!/bin/bash` en dur : rejeté, moins portable que `env bash`.

### Interface

- **Décision** : sous-commandes `outil COMMANDE [options]` à la git pour tout outil multi-fonctions ; options courtes POSIX et longues GNU ; `--help/-h` et `--version` obligatoires ; `--` termine les options.
- *Alternatives écartées* : options positionnelles seules : rejeté, peu extensible et peu découvrable.

### Flux et codes de sortie

- **Décision** : stdout réservé aux données exploitables, stderr à tous les diagnostics (info, avertissements, erreurs). Codes : `0` succès, `2` erreur d'usage, `1` erreur générique, codes spécifiques documentés au besoin.
- *Alternatives écartées* : adoption complète de `sysexits.h` : écartée pour le premier jet (surcharge non justifiée) ; laissée comme extension possible.

### Nommage et découvrabilité (PATH)

- **Décision** : entrypoint destiné au PATH sans extension (ex. `outil`), scripts internes suffixés `.sh` ; découvrabilité via `. activate` ajoutant `scripts/` (ou `bin/`) au PATH quand pertinent.

### Auto-documentation et découvrabilité des commandes

- **Décision** : tout CLI produit par le harnais est **auto-documenté**, **découvrable** et **uniforme**, propriétés érigées en fonctionnalités de cœur non négociables :
  - *auto-documenté* : le CLI porte ses propres commandes d'accès à la documentation (`-h`/`--help` à chaque niveau) ;
  - *découvrable* : `outil -h` énumère toutes les commandes et tous les groupes ; `outil COMMANDE -h` énumère toutes les sous-commandes ; aucune commande implémentée n'est absente de l'aide ;
  - *uniforme* : le format d'aide est identique aux trois niveaux (supérieur, groupe, sous-commande) ;
  - *source de vérité unique* : une table de commandes déclarative pilote à la fois le dispatch et l'aide ; l'aide n'est jamais extraite par plage de numéros de ligne.
- *Alternatives écartées* : aide extraite de l'en-tête par plage de lignes (patron du premier jet, ex. `sed -n 'A,Bp'`) : rejetée, elle couple l'aide à des numéros de ligne et dérive dès qu'une commande est ajoutée ; aide par sous-commande laissée facultative (SHOULD) : rejetée, un CLI professionnel doit documenter chacune de ses opérations ; exemption pour outils triviaux : rejetée, ces propriétés ne sont pas négociables (voir `REQ-001-F5/F7/F8`, `SPEC-001`).

## Conséquences

**Positives**
- Cohérence et composabilité de tous les nouveaux CLI ; capitalisation sur les meilleures pratiques déjà présentes localement.
- Base claire pour un skill de codage (`skl-011`) et une spécification/requis vérifiables.

**Négatives / risques**
- Les scripts existants ne sont pas conformes ; la convention vaut pour le neuf et lors des refontes, pas de migration forcée.
- `set -euo pipefail` exige une discipline de codage (gestion des cas où un échec est attendu).
- Le durcissement des exigences de documentation (`REQ-001-F5` promu MUST, ajout de `REQ-001-F7/F8`) rend non conformes les CLI antérieurs, dont `clia`. C'est assumé : la conception évolue pour améliorer les capacités du système, et l'implémentation est réconciliée dans une phase ultérieure (voir l'ordre séquentiel de travail dans `ADR-007`). La non-conformité temporaire n'est pas un défaut mais l'état normal entre une décision de conception et sa réconciliation.

## Migration / porte de sortie

Convention de premier jet. Elle sera affinée par l'usage et par les premiers CLI produits avec `skl-011`. Un ADR ultérieur pourra l'amender (ex. adopter `sysexits.h`, ajuster le nommage). Les scripts existants seront alignés opportunément, pas en masse.

## Références

- `FND-2026-07-10-conventions-cli`
- `ANL-2026-07-10-etat-clis-existants`
- `REQ-001-convention-cli-bash` (requis)
- `SPEC-001-convention-cli-bash` (spécification)
- `skl-011-codage-cli-bash` (skill de codage)
