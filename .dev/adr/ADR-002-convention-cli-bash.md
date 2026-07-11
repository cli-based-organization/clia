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

### Nommage et découvrabilité

- **Décision** : entrypoint destiné au PATH sans extension (ex. `outil`), scripts internes suffixés `.sh` ; découvrabilité via `. activate` ajoutant `scripts/` (ou `bin/`) au PATH quand pertinent.

## Conséquences

**Positives**
- Cohérence et composabilité de tous les nouveaux CLI ; capitalisation sur les meilleures pratiques déjà présentes localement.
- Base claire pour un skill de codage (`skl-011`) et une spécification/requis vérifiables.

**Négatives / risques**
- Les scripts existants ne sont pas conformes ; la convention vaut pour le neuf et lors des refontes, pas de migration forcée.
- `set -euo pipefail` exige une discipline de codage (gestion des cas où un échec est attendu).

## Migration / porte de sortie

Convention de premier jet. Elle sera affinée par l'usage et par les premiers CLI produits avec `skl-011`. Un ADR ultérieur pourra l'amender (ex. adopter `sysexits.h`, ajuster le nommage). Les scripts existants seront alignés opportunément, pas en masse.

## Références

- `FND-2026-07-10-conventions-cli`
- `ANL-2026-07-10-etat-clis-existants`
- `REQ-001-convention-cli-bash` (requis)
- `SPEC-001-convention-cli-bash` (spécification)
- `skl-011-codage-cli-bash` (skill de codage)
