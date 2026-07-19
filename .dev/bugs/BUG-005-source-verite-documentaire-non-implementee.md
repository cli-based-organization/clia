# BUG-005 - Source de vérité documentaire unique non entièrement implémentée (écart à PDC-006)

- **Statut** : diagnostiqué
- **Version** : 0.1.0
- **Date de rapport** : 2026-07-18
- **Origine** : session.md tâche 21 (généré depuis `ANL-2026-07-18-principes-de-conception-du-repo`, P6)
- **Tâche liée** : `logs/ia-output/LOG-2026-07-17-task-21.md`

## Rapport

Symptôme : le mécanisme de source de vérité documentaire unique de `clia` (source YAML `clia.doc.yaml` + templates + génération à la volée) est **spécifié** (`REQ-001-F8`, `SPEC-001`) mais son implémentation complète (réconciliation de `clia`, `PLN-011`) n'est pas achevée.
Attendu (PDC-006) : la documentation provient d'une source unique générée à la volée ; aucune duplication non synchronisée.
Observé : la conception est correcte, mais l'écart entre la spécification et le code de `clia` subsiste tant que `PLN-011` n'est pas exécuté.
Contexte : identifié par `ANL-2026-07-18-principes-de-conception-du-repo` (P6, partiel).

## Diagnostic

Principe concerné : `PDC-006` (« source de vérité documentaire unique »). Critère de conformité (partiellement) non satisfait : « la documentation de `clia` provient d'une source unique, générée à la volée ».
Cause immédiate : `PLN-011` (réconciliation de `clia` avec la convention de documentation) n'est pas exécuté.
Cause systémique : écart entre la couche conception (spécifiée) et la couche implémentation (non réalisée), conforme à l'ordre séquentiel `ADR-007` mais laissant le principe non pleinement effectif.

## Solution appliquée

Correctif non encore appliqué. Correctif prévu : exécuter `PLN-011` (source YAML de `clia` + module de rendu + refonte du dispatch), ce qui rend le principe effectif et supprime toute documentation dupliquée/codée en dur.

## Vérification

Le bogue sera résolu quand : `clia -h` et `clia --man` seront générés depuis `clia.doc.yaml` via templates, sans plage de lignes ni duplication, et que le contrôle de cohérence dispatch/documentation passera.

## Historique

- 2026-07-18 v0.1.0 : rapport et diagnostic (écart à PDC-006 identifié en tâche 21).
