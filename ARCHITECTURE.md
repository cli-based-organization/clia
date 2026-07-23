---
type: harnais
version: 0.1.0
title: "ARCHITECTURE"
status: accepté
date: 2026-07-18
---

# ARCHITECTURE


> Carte de haut niveau du système d'augmentation par IA de ce dépôt. Court et stable : ne décrit que le durable, ne se synchronise pas ligne à ligne avec le code (voir `ADR-009`). Renvoie aux ADR (décisions) et aux PDC (invariants), sans les dupliquer.

## Problème résolu (vue d'oiseau)

Faire travailler un humain et un agent IA sur un dépôt de façon **gouvernée, tracée et reproductible**, en confiant à un composant **déterministe** (`clia`) tout ce qui est spécifiable et vérifiable, et à l'**agent IA** ce qui exige du jugement. L'interface de travail est **des fichiers markdown versionnés**, pas une conversation éphémère.

## Vue d'ensemble des composants

Le système d'augmentation se compose de **ressources livrables vivantes** (versionnées dans leur frontmatter, voir `ADR-004`) regroupées par fonction, et de **traces immuables** :

- **harness-files** (méthode) : `INTENTION.md` (pourquoi), `CONSTITUTION.md` (gouvernance/orchestration), `ARCHITECTURE.md` (structure, ce fichier), `CLAUDE.md` (mode opératoire), et les **skills** (`.dev/skills/skl-*`). Générique, sans information de domaine (`ADR-005`, `PDC-003`).
- **documents-de-conception** (conception) : `ADR-*` (décisions), `SPEC-*` (spécifications d'interface), `REQ-*` (exigences), `PDC-*` (principes de conception / invariants).
- **savoir et travail** : `FND-*` (fondations), `ANL-*` (analyses), `BUG-*` (bogues), `PLN-*` (plans). Vivants et versionnés comme les autres livrables.
- **clia** (automatisme déterministe) : un CLI bash 100 % déterministe (`src/`), gardien de l'intégrité (`ADR-007`, `PDC-001`).
- **traces immuables** (hors ressources livrables) : `.dev/logs/ia-output/LOG-*` (traces de tâches) et `.dev/sessions/SES-*` (sessions archivées).

Relation : les **harness-files** gouvernent le comportement de l'agent ; les **documents-de-conception** cadrent le système ; **clia** exécute les opérations déterministes ; **fondations et analyses** accumulent le savoir ; les **traces** documentent l'activité.

## Acteurs et rôles

- **Humain** : point d'entrée unique (`.dev/session.md`), objections, décisions, opérations irréversibles (git, transitions de session via `clia`). Voir `PDC-010`.
- **Agent IA** : produit les livrables porteurs de jugement (plans, fondations, analyses, ADR, principes, harnais) et les logs ; n'invoque jamais les commandes mutantes de session ni git. Voir `PDC-002`, `PDC-010`.
- **clia** : composant déterministe opéré par l'humain ; transitions d'état des sessions et inspection des ressources/versions. Voir `PDC-001`.

## Flux principal

1. L'humain soumet un problème via `.dev/session.md` (point d'entrée unique).
2. L'agent propose un **plan** (`PLN-*`) ; le cycle **objection-sociocratique** s'applique (aucune exécution sous objection ouverte ; breakpoints possibles). Voir `PDC-008`, `CONSTITUTION.md`.
3. Une fois approuvé, l'agent exécute et produit les livrables (fichiers) et un **log** par tâche (`.dev/logs/ia-output/`).
4. L'humain opère les transitions de session (`clia ses plan/open/close/new`) et le versionnage du domaine ; `clia` garantit l'intégrité.

## Cartographie du code (« où est la chose qui fait X ? »)

- Dispatch et options globales de `clia` : `src/bin/clia`.
- Transitions d'état des sessions : `src/lib/session.sh`.
- Inspection des ressources livrables : `src/lib/resource.sh`.
- Version (métier et ensembles) : `src/lib/version.sh`.
- Aide générée à la volée (documentation) : `src/lib/doc.sh` + source `src/clia.doc.yaml`.
- Utilitaires communs (helpers, flux, codes de sortie) : `src/lib/common.sh`.
- Couche type des ressources (schéma machine-lisible) : `.dev/resource-types.yaml` ; versions portées par le frontmatter de chaque ressource.
- Squelette de session : `.dev/templates/session.template.md`.

## Invariants et décisions

- **Invariants** (principes de conception) : `.dev/principes/PDC-001..010` (déterminisme, IA-si-nécessaire, séparation méthode/domaine, interface fichiers, séparation des préoccupations, source de vérité unique, découvrabilité/uniformité, gouvernance objection-sociocratique, versionnage atomique, autorité humaine sur l'irréversible).
- **Décisions structurantes** : `ADR-007` (les trois composants et le versionnage à deux domaines), `ADR-004` (typologie et versionnage des ressources), `ADR-005` (fonction et scope du harnais), `ADR-006` (gestion des sessions), `SPEC-002`/`REQ-002` (interface de `clia`).

## Hors périmètre

- L'architecture du **contenu métier** d'un dépôt hôte (générique ici : ce fichier décrit le système d'augmentation, pas un domaine).
- Le détail d'implémentation ligne à ligne de `clia` (voir le code et `SPEC-002`).
- Le *pourquoi* des décisions (voir les ADR) et la formulation des invariants (voir les PDC).

## Références

- `ADR-009-harnais-architecture-md` (ce type de harnais), `ADR-007-architecture-systeme-augmentation`, `ADR-004-ressources-livrables`, `ADR-005-fonction-scope-harnais`
- `FND-009-architecture-systemes-complexes`, `ANL-004-architecture-effective-du-repo`
- `.dev/principes/PDC-001..010`, `CONSTITUTION.md`, `INTENTION.md`, `CLAUDE.md`
