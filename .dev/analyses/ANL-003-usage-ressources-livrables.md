---
type: analyse
version: 0.1.0
title: "Usage des ressources livrables et axes d'analyse"
date: 2026-07-10
---

# ANL-003 - Usage des ressources livrables et axes d'analyse

- **Périmètre** : ressources livrables gérées dans ce dépôt (`.dev/`, harnais racine, `logs/`). Exclusions : contenu métier, `.git/`.
- **Référence** : typologie par cycle de vie (tâche 12) ; objections des tâches 14 et 15.

## Objet

Inventorier les types de ressources livrables réellement en usage et identifier les axes d'analyse pertinents, pour alimenter `ADR-004-ressources-livrables` et `ADR-005-fonction-scope-harnais`.

## Périmètre et méthode

Recensement des types de ressources présents et classement selon plusieurs axes candidats. Grille : type, emplacement, producteur, droits d'édition, cycle de vie, fonction, appartenance au harnais, nommage.

## Inventaire

| Type | Emplacement | Producteur | Droits d'édition | Cycle de vie | Fonction | Harnais ? | Nommage |
|---|---|---|---|---|---|---|---|
| CLAUDE.md | racine | agent/co | co-édition | vivant | mode opératoire | oui | fixe |
| CONSTITUTION.md | racine | agent/co | co-édition | vivant | gouvernance | oui | fixe |
| INTENTION.md | racine | humain | humain-only | vivant | intention (domaine) | non | fixe |
| skl-* | `.dev/skills/` | agent | co-édition | vivant | apparatus méthodo. | oui | séquencé |
| PLN-* | `.dev/plans/` | agent | IA-only | travail | intervention | non | séquencé |
| ADR-* | `.dev/adr/` | agent | IA-only | vivant | conception | non | séquencé |
| SPEC-* | `.dev/specs/` | agent | IA-only | vivant | conception | non | séquencé |
| REQ-* | `.dev/requis/` | agent | IA-only | vivant | conception | non | séquencé |
| BUG-* | `.dev/bugs/` | agent | IA-only | vivant | suivi de bogue | non | séquencé |
| FND-* | `.dev/fondations/` | agent | IA-only | point fixe | recherche | non | daté |
| ANL-* | `.dev/analyses/` | agent | IA-only | point fixe | analyse | non | daté |
| logs | `.dev/logs/ia-output/` | agent | IA-only | point fixe | trace-audit | non | daté |
| session.md | `.dev/` | humain | humain-only | travail | demande (domaine) | non | fixe |
| sessions/* | `.dev/sessions/` | humain | humain-only | point fixe | archive (domaine) | non | daté |
| publications/* | `publications/` (à venir) | agent | IA-only | point fixe | diffusion | non | daté |

## Constats

- **Le harnais est restreint** : seuls `CLAUDE.md`, `CONSTITUTION.md` et les `skl-*` sont génériques et réutilisables (harnais). `INTENTION.md`, `session.md` et `sessions/*` sont propres au repo (domaine), donc hors harnais.
- **Trois régimes de nommage** coexistent : noms fixes (harnais racine, `session.md`), séquencés (vivant et travail : ADR, SPEC, REQ, BUG, PLN, skl), datés (point fixe : FND, ANL, logs, sessions, publications).
- **Le cycle de vie ne suffit pas** à classer : deux ressources vivantes (skl et ADR) diffèrent par leur appartenance au harnais et leur fonction. Plusieurs axes sont nécessaires.
- **Écart repéré** : l'exemple de `skl-008` (ressource de harnais) contient une mention de domaine (« Commission scolaire de la Capitale-Nationale »), ce qui viole le principe de généricité du harnais (tâche 15, obj. 8).

## Confrontation à la référence

La typologie par cycle de vie (tâche 12) est confirmée mais insuffisante seule. Les objections 14 et 15 imposent d'ajouter au moins les axes « droits d'édition », « fonction » et « appartenance au harnais ».

## Synthèse et recommandations

Axes d'analyse à retenir dans `ADR-004` (priorité haute) :
1. **Cycle de vie** : point fixe / vivant / travail.
2. **Droits d'édition (permissions et rôles)** : humain-only / IA-only / co-édition.
3. **Fonction / finalité** : gouvernance, conception, recherche, analyse, trace-audit, suivi de bogue, intention, diffusion.
4. **Appartenance au harnais** : harnais (générique, réutilisable) vs propre au repo (domaine).
5. **Nommage** : fixe / séquencé / daté.
6. **Producteur** : humain / agent / co-production.

Corollaire pour `ADR-005` : le harnais se limite à `CLAUDE.md`, `CONSTITUTION.md`, `skl-*` et doit être purgé de toute information de domaine (corriger `skl-008`).

## Portée et péremption

Analyse de l'état au 2026-07-10. À revalider si de nouveaux types de ressources apparaissent (ex. `publications/*`).
