---
type: bug
version: 0.1.0
title: "`src/lib/resource.sh` expose un modèle de ressources abrogé (écart à ADR-004 v0.2.0 et à PDC-006)"
status: diagnostiqué
date: 2026-07-29
---

# BUG-007 - `src/lib/resource.sh` expose un modèle de ressources abrogé (écart à ADR-004 v0.2.0 et à PDC-006)

- **Origine** : agent (constat porté en objection 1 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md), résolue par la tâche 35 de `.dev/session.md` : « ouvrir un BUG et continuer sans autre modification »)
- **Tâche liée** : [`LOG-2026-07-17-task-35.md`](../logs/ia-output/LOG-2026-07-17-task-35.md)

## Rapport

Symptôme : le module d'inspection des ressources code en dur la table des types dans le modèle de la version 0.1.0 d'[`ADR-004`](../adr/ADR-004-ressources-livrables.md), abrogé par la version 0.2.0. Les commandes du groupe `res` rapportent donc des données fausses.

Attendu : la couche type est décrite par [`.dev/resource-types.yaml`](../resource-types.yaml), source de vérité unique du modèle de ressources ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)) ; toutes les ressources livrables sont vivantes et portent leur version dans leur frontmatter ; les dix types déclarés sont connus de `clia`.

Observé (reproduit le 2026-07-29 sur `src/bin/clia`) :

| Invocation | Comportement observé | Écart |
|---|---|---|
| `clia res ls` | colonne `CYCLE` affichant `travail` (PLN), `pointfixe` (FND, ANL, SES) | cycles abolis par [`ADR-004`](../adr/ADR-004-ressources-livrables.md) v0.2.0 : toutes les ressources livrables sont vivantes |
| `clia res ls PDC` | `[ERR] type de ressource inconnu : PDC`, code de retour 2 | type déclaré dans la couche type et dans la table des livrables de [`CLAUDE.md`](../../CLAUDE.md), inconnu du module |
| `clia res ls FND` | colonne version vide (`-`) sur les 18 fondations | la version est extraite d'une date de nom de fichier disparue au renommage séquencé ; elle vit désormais dans le frontmatter |
| `clia res ls PLN` | colonne état contenant des phrases entières de texte d'objection | l'état est lu par un `grep` non ancré au lieu du champ `status` du frontmatter |
| `clia --version --long` | `[WARN] manifeste absent : .dev/ressources.yaml` | le manifeste central est aboli par [`ADR-004`](../adr/ADR-004-ressources-livrables.md) v0.2.0 |

Quatre des neuf types connus du module (PLN, FND, ANL, SES) sont mal rapportés, et un type déclaré (PDC) est inconnu. Contexte d'apparition : vérification de l'état du dépôt menée pour la production de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) (tâche 34).

## Diagnostic

Principes concernés :

- [`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md) (source de vérité documentaire unique) : le module porte une **copie codée en dur** de la table des types (`src/lib/resource.sh`, lignes 6 à 15) au lieu de lire [`.dev/resource-types.yaml`](../resource-types.yaml). Deux sources parallèles pour le même modèle, dont une désynchronisée.
- [`PDC-009`](../principes/PDC-009-tracabilite-et-versionnage-atomique.md) (traçabilité et versionnage atomique) : la version d'une ressource est déduite d'une convention de nommage abandonnée plutôt que lue là où elle vit, dans le frontmatter.

Cause immédiate : l'exécution de `PLN-014` (refonte du modèle de ressources) a modifié la couche conception (ADR, couche type, frontmatter, abolition du manifeste) sans réconcilier le module d'implémentation qui en dépend.

Cause systémique : l'ordre de travail du dépôt ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md) : conception, puis méthodologie, puis implémentation) autorise ce décalage, mais rien ne le **signale**. Une modification de la couche type ne produit aujourd'hui aucun signal vers le code qui la consomme, parce que ce code ne la consomme pas : il la duplique. Tant que la table reste codée en dur, tout écart futur se reproduira silencieusement. Même famille de cause que [`BUG-005`](BUG-005-source-verite-documentaire-non-implementee.md) (documentation de `clia` non générée depuis sa source unique) : la source de vérité existe, l'implémentation ne s'y branche pas.

## Solution appliquée

Correctif non appliqué. Il est explicitement **hors portée** de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) (résolution humaine de la tâche 35 : ouvrir le bogue et poursuivre sans autre modification), et relève de la phase d'implémentation.

Correctif prévu :

1. supprimer la table codée en dur de `src/lib/resource.sh` et lire les types depuis [`.dev/resource-types.yaml`](../resource-types.yaml) via `yq` (dépendance déjà admise) ;
2. lire `version` et `status` dans le frontmatter de chaque ressource, plus aucune déduction depuis le nom de fichier ;
3. supprimer la notion de cycle de vie (`vivant`, `pointfixe`, `travail`) de l'affichage et du code ;
4. supprimer la recherche de `.dev/ressources.yaml` dans `clia --version --long`.

Note de portée : ce correctif rend mécaniquement connus les types ajoutés ultérieurement à la couche type (dont `ACT` et `USE` prévus par [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md)), sans nouvelle modification du module.

## Vérification

Le bogue sera résolu quand, sur un dépôt équipé :

- `clia res ls` liste exactement les types déclarés dans [`.dev/resource-types.yaml`](../resource-types.yaml), sans colonne de cycle de vie ;
- `clia res ls <PREFIX>` réussit (code 0) pour chacun de ces types, `PDC` compris ;
- la colonne version reproduit, pour un échantillon de ressources de chaque type, la valeur du champ `version` de leur frontmatter ;
- la colonne état d'un `PLN` porte la seule valeur du champ `status`, sur une ligne ;
- `clia --version --long` n'émet aucun avertissement de manifeste absent.

## Historique

- 2026-07-29 v0.1.0 : rapport et diagnostic (écart constaté lors de la production de `PLN-017`, tâche 34 ; bogue ouvert sur résolution humaine de la tâche 35).
