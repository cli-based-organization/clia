---
type: bug
version: 0.1.0
title: "CONSTITUTION.md mêle gouvernance et orchestration (écart à PDC-005)"
status: diagnostiqué
---

# BUG-004 - CONSTITUTION.md mêle gouvernance et orchestration (écart à PDC-005)

- **Date de rapport** : 2026-07-18
- **Origine** : session.md tâche 21 (généré depuis `ANL-010-principes-de-conception-du-repo`, P5)
- **Tâche liée** : `.dev/logs/ia-output/LOG-2026-07-17-task-21.md`

## Rapport

Symptôme : `CONSTITUTION.md` mêle deux couches de natures différentes : le **domaine de responsabilité des acteurs** (gouvernance : droits d'édition, rôle de `clia`, responsabilité git) et le **processus et son orchestration** (cycle de vie d'un plan, objection, règle absolue, breakpoint).
Attendu (PDC-005) : chaque document traite une préoccupation cohérente unique ; gouvernance et orchestration ne sont pas mêlées.
Observé : sur dix sections, environ 40 % de gouvernance pure, 30 % d'orchestration pure, 30 % hybrides, entrelacées sans frontière.
Contexte : diagnostiqué par `ANL-008-critique-constitution` et confirmé à l'échelle de l'écosystème par `ANL-007-corpus-constitutions-gov-orchestration` (mélange concentré dans la lignée `clia`).

## Diagnostic

Principe enfreint : `PDC-005` (« séparation des préoccupations »). Critère de conformité violé : « aucun document ne mélange gouvernance et orchestration ».
Cause immédiate : `CONSTITUTION.md` a accrété des sections d'orchestration (cycle, objection, breakpoint) au fil des sessions, en plus des sections de gouvernance.
Cause systémique : absence, jusqu'ici, d'un document de processus distinct ; le mot « constitution » a servi de fourre-tout, contrairement à son sens field (couche gouvernance/principes).

## Solution appliquée

Correctif non encore appliqué. Correctif prévu : scinder `CONSTITUTION.md` en un document de **gouvernance/responsabilités** et un document de **processus/orchestration** (recommandé par `ANL-008-critique-constitution`, exemplaire de séparation : `personal-journal`). Objet d'un recadrage humain à venir (« [Recadrage humain] CONSTITUTION.md, PROCESSUS.md et CLAUDE.md »). Nécessite la mise à jour des renvois croisés (`CLAUDE.md`, `skl-003`, `skl-004`) et un versionnage atomique.

## Vérification

Le bogue sera résolu quand la gouvernance et l'orchestration vivront dans des documents distincts à préoccupation unique, avec renvois croisés cohérents.

## Historique

- 2026-07-18 v0.1.0 : rapport et diagnostic (écart à PDC-005 identifié en tâche 21).
