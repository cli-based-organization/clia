---
type: principe
version: 0.1.0
title: "Déterminisme de clia"
status: accepté
date: 2026-07-18
---

# PDC-001 - Déterminisme de clia


## Énoncé

`clia` est 100 % déterministe : mêmes entrées, mêmes sorties, sans aucune heuristique ni improvisation.

## Justification

`clia` est le **gardien de l'intégrité** du système d'information (`CONSTITUTION.md`, `ADR-007`). Une opération non déterministe sur les transitions d'état des sessions ou l'inspection des ressources introduirait un risque d'incohérence irrécupérable. Le déterminisme garantit reproductibilité, vérifiabilité et confiance ; il est ce qui distingue `clia` de l'agent IA (variable par nature).

## Portée

Tout le code de `clia` (`src/bin/clia`, `src/lib/*`, `setup.sh`). Exclut l'agent IA, qui n'est pas déterministe et opère sur d'autres tâches (voir `PDC-002`).

## Implications

- Interdit toute heuristique, tout aléa non contrôlé, toute dépendance à un état implicite dans `clia`.
- Impose que toute variabilité légitime (horodatage courant) soit explicite et documentée.
- Impose que deux exécutions identiques produisent des sorties identiques (hors horodatage courant).

## Critères de conformité

- Deux exécutions identiques de `clia` produisent des sorties identiques (`REQ-002-NF1`).
- Aucune branche du code ne dépend d'une heuristique ou d'un tirage aléatoire.
- Toute source de variabilité est explicitée (ex. `start-at`/`end-at` calculés depuis l'heure courante).

## Tensions

- Avec `PDC-002` (répartition IA/automatisation) : le déterminisme borne ce que `clia` peut faire ; les tâches exigeant du jugement restent à l'agent, pas à `clia`.

## Références

- `ADR-007-architecture-systeme-augmentation`, `REQ-002-cli-clia` (NF1), `CONSTITUTION.md`
- `FND-014-principes-de-conception-systemes-complexes`, `ANL-010-principes-de-conception-du-repo` (P1)
