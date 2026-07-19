# BUG-006 - Découvrabilité et uniformité non entièrement implémentées (écart à PDC-007)

- **Statut** : diagnostiqué
- **Version** : 0.1.0
- **Date de rapport** : 2026-07-18
- **Origine** : session.md tâche 21 (généré depuis `ANL-2026-07-18-principes-de-conception-du-repo`, P7)
- **Tâche liée** : `logs/ia-output/LOG-2026-07-17-task-21.md`

## Rapport

Symptôme : la découvrabilité et l'uniformité de l'aide de `clia` sont **spécifiées** (`REQ-001-F7/F8/F9`, `SPEC-002`) mais leur implémentation complète n'est pas achevée ; un bogue historique (le groupe `ses`/`session` absent de `clia -h`) a motivé la réconciliation (`PLN-011`), non entièrement exécutée.
Attendu (PDC-007) : toute commande/sous-commande est découvrable et documentée uniformément ; l'inventaire dispatché est identique à l'inventaire documenté.
Observé : conception correcte, implémentation partielle tant que `PLN-011` n'est pas exécuté.
Contexte : identifié par `ANL-2026-07-18-principes-de-conception-du-repo` (P7, partiel).

## Diagnostic

Principe concerné : `PDC-007` (« découvrabilité et uniformité »). Critères (partiellement) non satisfaits : `REQ-001-F7` (découvrabilité), `F8` (uniformité, source unique), `F9` (cohérence dispatch/documentation).
Cause immédiate : `PLN-011` non exécuté ; l'ancien `_usage` couplé aux numéros de ligne omettait des groupes.
Cause systémique : écart conception/implémentation (comme `BUG-005`, dont ce bogue partage la cause racine : la source documentaire unique non encore implémentée).

## Solution appliquée

Correctif non encore appliqué. Correctif prévu : exécuter `PLN-011` ; l'aide générée depuis `clia.doc.yaml` rend `clia -h` exhaustif (liste `res` et `ses`), uniforme aux trois niveaux, avec contrôle de cohérence dispatch/documentation.

## Vérification

Le bogue sera résolu quand : `clia -h` liste tous les groupes, `clia GROUPE -h` liste toutes les sous-commandes, le format est identique aux trois niveaux, et le contrôle de cohérence `REQ-001-F9` passe.

## Historique

- 2026-07-18 v0.1.0 : rapport et diagnostic (écart à PDC-007 identifié en tâche 21).
