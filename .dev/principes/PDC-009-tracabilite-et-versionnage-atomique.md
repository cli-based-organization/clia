# PDC-009 - Traçabilité et versionnage atomique

- **Statut** : accepté
- **Version** : 0.1.0
- **Date** : 2026-07-18

## Énoncé

Chaque ressource vivante est versionnée ; modifier un membre bumpe atomiquement, dans la même opération, la version du membre et celle de son ensemble.

## Justification

Le versionnage atomique garantit qu'à tout instant l'état des versions est cohérent et traçable : impossible d'avoir un membre modifié sans que son ensemble le reflète. C'est la condition d'une traçabilité fiable des ressources vivantes (`ADR-004`).

## Portée

Les ressources vivantes (ADR, SPEC, REQ, PDC, skills, harnais, BUG) et leurs ensembles, suivis dans `.dev/ressources.yaml`.

## Implications

- Impose de mettre à jour `.dev/ressources.yaml` à chaque modification d'une ressource vivante (membre + ensemble + manifeste).
- Interdit un bump de membre sans bump de son ensemble, et inversement.
- Impose que la version initiale soit `0.1.0` (phase de conception).

## Critères de conformité

- Toute modification d'un membre vivant s'accompagne du bump du membre et de son ensemble dans `.dev/ressources.yaml`.
- L'état du manifeste est cohérent (aucun membre modifié non reflété).

## Tensions

- Avec `PDC-002` : ce versionnage est aujourd'hui réalisé **manuellement par l'agent**, alors qu'il est spécifiable et vérifiable et devrait être automatisé par `clia` (respecté mais fragile ; voir `ANL-2026-07-18-usage-ia-projet`).

## Références

- `ADR-004-ressources-livrables`, `ADR-007-architecture-systeme-augmentation`
- `ANL-2026-07-18-principes-de-conception-du-repo` (P9)
