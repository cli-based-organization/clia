# BUG-001 - Aucun log produit pour les tâches de production de plan

- **Statut** : résolu
- **Version** : 0.1.0
- **Date de rapport** : 2026-07-10
- **Origine** : session.md tâche 13
- **Tâche liée** : tâche 12 (production de PLN-005) ; log correctif : `logs/ia-output/2026-07-09_task-13.md`

## Rapport

**Attendu** : toute tâche exécutée par l'agent produit un log dans `logs/ia-output/<DATE>_task-<NN>.md`.

**Observé** : la tâche 12 (production de `PLN-005`) n'a produit aucun log. En vérifiant, le même manquement touche les tâches 9 et 10 (productions et révision de `PLN-004`) : aucun log n'existait pour `task-09`, `task-10`, `task-12`. Seules les tâches comportant une phase d'exécution de livrables (6, 7, 11) avaient été journalisées.

## Diagnostic

**Cause immédiate** : l'agent a interprété la « production ou révision d'un plan » comme n'étant pas une « tâche exécutée » au sens de l'obligation de journalisation, et a donc omis le log pour les tâches purement planificatrices (9, 10, 12).

**Cause racine (systémique)** : l'obligation de journalisation n'était énoncée que dans `skl-008` (« Chaque tâche exécutée par l'agent produit un fichier log »), formulation ambiguë où « exécutée » pouvait se lire comme excluant la seule production d'un plan. `CLAUDE.md` (mode opératoire) ne portait aucune règle saillante et non ambiguë imposant un log à **toute** tâche, planification comprise. La règle existait donc, mais enfouie et interprétable.

## Solution appliquée

1. **`CLAUDE.md`** : ajout d'une section « Journalisation obligatoire » énonçant sans ambiguïté que toute tâche traitée, y compris la seule production ou révision d'un plan, se termine par un log dans `logs/ia-output/`, sans exception. Enregistrement du type BUG et de `skl-013` dans la table des livrables et la nomenclature.
2. **`skl-008-log-ia-output`** : renforcement de la formulation (« TOUTE tâche, sans exception, y compris la seule production ou révision d'un plan »).
3. **`CONSTITUTION.md`** : rappel de l'obligation dans la section « Interface de travail : fichiers, pas conversation ».
4. **Rattrapage** : production rétroactive des logs manquants `task-09`, `task-10`, `task-12`.
5. **Infrastructure de gestion des bogues** : `ADR-003-gestion-des-bogues`, type BUG, `skl-013-rapport-de-bogue`, et ce présent BUG-001.

Fichiers modifiés ou créés : `CLAUDE.md`, `CONSTITUTION.md`, `.dev/skills/skl-008-log-ia-output/SKILL.md`, `.dev/adr/ADR-003-gestion-des-bogues.md`, `.dev/skills/skl-013-rapport-de-bogue/SKILL.md`, `.dev/bugs/BUG-001-aucun-log-produit.md`, `logs/ia-output/2026-07-09_task-09.md`, `2026-07-09_task-10.md`, `2026-07-09_task-12.md`, `2026-07-09_task-13.md`.

## Vérification

- Les logs `task-09`, `task-10`, `task-12` existent désormais dans `logs/ia-output/`.
- La tâche 13 elle-même produit son log (`task-13`), illustrant la règle corrigée.
- `CLAUDE.md` porte une règle explicite et non contournable ; `skl-008` ne laisse plus d'ambiguïté sur « tâche exécutée ».

## Historique

- 2026-07-10 v0.1.0 : rapport, diagnostic et solution consignés ; bogue résolu dans la même tâche (13).
