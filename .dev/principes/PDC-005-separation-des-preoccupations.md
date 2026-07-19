# PDC-005 - Séparation des préoccupations

- **Statut** : accepté
- **Version** : 0.1.0
- **Date** : 2026-07-18

## Énoncé

Chaque document et chaque composant traite un aspect cohérent et unique, sans mêler des préoccupations de natures différentes.

## Justification

La séparation des préoccupations (Dijkstra) est la condition de la quasi-décomposabilité qui rend un système complexe compréhensible, modifiable et évolutif (`FND-2026-07-18-principes-de-conception-systemes-complexes`). Mêler des préoccupations (gouvernance et orchestration, spécification et implémentation) couple ce qui devrait être indépendant et érode l'intégrité conceptuelle.

## Portée

Tous les livrables et tous les fichiers de harnais. S'applique en particulier à la distinction gouvernance / orchestration, spécification / requis, méthode / domaine.

## Implications

- Interdit de mêler dans un même document des couches de natures différentes (ex. règles de gouvernance et mécanique de processus).
- Impose de scinder un document qui porte deux préoccupations distinctes.

## Critères de conformité

- Chaque document a une préoccupation unique identifiable.
- Aucun document ne mélange gouvernance et orchestration, ni spécification et implémentation, ni méthode et domaine.

## Tensions

- `CONSTITUTION.md` mêle actuellement gouvernance et orchestration (`ANL-2026-07-18-critique-constitution`, `ANL-2026-07-18-corpus-constitutions-gov-orchestration`) : écart avéré (voir bogue associé), refactor en attente de recadrage humain.

## Références

- `FND-2026-07-18-principes-de-conception-systemes-complexes`, `FND-2026-06-21-ingenierie-livrables-qualite`
- `ANL-2026-07-18-principes-de-conception-du-repo` (P5), `ANL-2026-07-18-critique-constitution`
