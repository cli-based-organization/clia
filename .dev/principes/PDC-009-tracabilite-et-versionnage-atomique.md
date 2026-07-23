---
type: principe
version: 0.2.0
title: "Traçabilité et versionnage des ressources"
status: accepté
date: 2026-07-18
---

# PDC-009 - Traçabilité et versionnage des ressources

## Énoncé

Chaque ressource livrable vivante porte sa version dans son **frontmatter** ; toute modification incrémente cette version selon la règle semver.

## Justification

Le versionnage porté par le fichier lui-même rend l'état des versions **localement traçable et vérifiable**, sans dépendre d'un manifeste central : la version d'une ressource se lit là où vit la ressource. C'est la condition d'une traçabilité fiable et déterministe des ressources vivantes (`ADR-004`).

## Portée

Toutes les ressources livrables vivantes (FND, ANL, ADR, SPEC, REQ, PDC, skills, harnais, BUG, PLN). Les traces (logs, sessions) ne sont pas versionnées.

## Implications

- Chaque ressource vivante déclare `type` et `version` dans son frontmatter (voir `.dev/resource-types.yaml`).
- Une modification incrémente la version selon semver (MAJEUR = changement incompatible ; MINEUR = ajout rétrocompatible ; CORRECTIF = clarification).
- Version initiale `0.1.0` (phase de conception).
- Il n'y a **plus de manifeste central ni d'ensembles composites** (`ressources.yaml` est aboli, voir `ADR-004`).

## Critères de conformité

- Toute ressource vivante possède un frontmatter avec `type` et `version`.
- Toute modification d'une ressource s'accompagne d'un bump de sa version.

## Tensions

- Avec `PDC-002` : ce versionnage est aujourd'hui réalisé **manuellement par l'agent**, alors qu'il est spécifiable et vérifiable et devrait être automatisé par `clia` (respecté mais fragile ; voir `ANL-012-usage-ia-projet`).

## Références

- `ADR-004-ressources-livrables`, `PDC-002-ia-seulement-si-necessaire`
- `ANL-010-principes-de-conception-du-repo` (P9)
