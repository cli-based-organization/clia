---
type: principe
version: 0.1.0
title: "Séparation méthode / domaine et généricité du harnais"
status: accepté
date: 2026-07-18
---

# PDC-003 - Séparation méthode / domaine et généricité du harnais


## Énoncé

Le harnais (fichiers de harnais et `clia`) est générique et réutilisable inter-dépôts : il ne contient aucune information de domaine métier.

## Justification

Le système d'augmentation doit être transposable d'un dépôt à l'autre (`ADR-005`). Mêler de la connaissance de domaine au harnais le couplerait à un projet et détruirait sa réutilisabilité, en plus de brouiller la frontière entre la méthode (comment on travaille) et le domaine (sur quoi on travaille).

## Portée

Les fichiers de harnais (`CLAUDE.md`, `CONSTITUTION.md`, skills) et `clia`. Ne s'applique pas au contenu de domaine du dépôt hôte (légitimement spécifique), ni aux ressources de savoir explicitement importées et signalées comme telles.

## Implications

- Interdit toute donnée de domaine (nom de client, sujet métier) dans les fichiers de harnais et `clia`.
- Impose de signaler comme « savoir importé » toute ressource de contenu spécifique rapatriée, pour ne pas la confondre avec une ressource générique de harnais.

## Critères de conformité

- Aucun fichier de harnais ni `clia` ne contient d'information de domaine métier.
- Les ressources de savoir spécifiques importées portent une mention de provenance et de non-généricité.

## Tensions

- Avec l'importation de savoir : des fondations de contenu business ont été rapatriées (tâches 15-17) ; elles sont hors harnais mais mettent la frontière sous tension si traitées comme génériques (voir bogue associé).

## Références

- `ADR-005-fonction-scope-harnais`
- `ANL-010-principes-de-conception-du-repo` (P3)
