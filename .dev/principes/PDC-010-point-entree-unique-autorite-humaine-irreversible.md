# PDC-010 - Point d'entrée humain unique et autorité humaine sur l'irréversible

- **Statut** : accepté
- **Version** : 0.1.0
- **Date** : 2026-07-18

## Énoncé

L'humain n'a qu'un seul point d'entrée (`.dev/session.md`) ; les opérations irréversibles (git, transitions de session) restent l'apanage de l'humain, ou de `clia` opéré par l'humain.

## Justification

Un point d'entrée unique évite la dispersion des demandes et clarifie la responsabilité. Réserver l'irréversible à l'humain place le contrôle des actions non récupérables au bon endroit (human-in-the-loop), conformément à la répartition des rôles (`ADR-007`) et à la bonne pratique de gouvernance des agents.

## Portée

La gouvernance des acteurs (humain / `clia` / agent IA) et les opérations à effet irréversible.

## Implications

- Impose que toute demande humaine passe par `session.md`.
- Interdit à l'agent IA toute action git et toute invocation des commandes mutantes de session (`clia ses plan/open/close/new`).
- Impose que `clia`, pour muter des fichiers en édition humaine uniquement, soit opéré par l'humain.

## Critères de conformité

- L'agent n'exécute jamais de commande git ni de mutation de session.
- Les demandes humaines sont consignées dans `session.md`, point d'entrée unique.

## Tensions

- Avec l'automatisation (`PDC-002`) : certaines opérations déterministes non irréversibles peuvent être automatisées par `clia` sans violer ce principe ; la frontière est l'irréversibilité et l'autorité, pas le déterminisme.

## Références

- `CONSTITUTION.md` (« clia : gardien déterministe », « Git commit : responsabilité de l'humain »), `ADR-006-gestion-des-sessions`, `ADR-007-architecture-systeme-augmentation`
- `ANL-2026-07-18-principes-de-conception-du-repo` (P10)
