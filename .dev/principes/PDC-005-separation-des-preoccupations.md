---
type: principe
version: 0.1.0
title: "Séparation des préoccupations"
status: accepté
date: 2026-07-18
---

# PDC-005 - Séparation des préoccupations


## Énoncé

Chaque document et chaque composant traite un aspect cohérent et unique, sans mêler des préoccupations de natures différentes.

## Justification

La séparation des préoccupations (Dijkstra) est la condition de la quasi-décomposabilité qui rend un système complexe compréhensible, modifiable et évolutif (`FND-014-principes-de-conception-systemes-complexes`). Mêler des préoccupations (gouvernance et orchestration, spécification et implémentation) couple ce qui devrait être indépendant et érode l'intégrité conceptuelle.

## Portée

Tous les livrables et tous les fichiers de harnais. S'applique en particulier à la distinction gouvernance / orchestration, spécification / requis, méthode / domaine.

## Implications

- Interdit de mêler dans un même document des couches de natures différentes (ex. règles de gouvernance et mécanique de processus).
- Impose de scinder un document qui porte deux préoccupations distinctes.

## Critères de conformité

- Chaque document a une préoccupation unique identifiable.
- Aucun document ne mélange gouvernance et orchestration, ni spécification et implémentation, ni méthode et domaine.

## Tensions

- `CONSTITUTION.md` mêle actuellement gouvernance et orchestration (`ANL-008-critique-constitution`, `ANL-007-corpus-constitutions-gov-orchestration`) : écart avéré (voir bogue associé), refactor en attente de recadrage humain.

## Références

- `FND-014-principes-de-conception-systemes-complexes`, `FND-002-ingenierie-livrables-qualite`
- `ANL-010-principes-de-conception-du-repo` (P5), `ANL-008-critique-constitution`
