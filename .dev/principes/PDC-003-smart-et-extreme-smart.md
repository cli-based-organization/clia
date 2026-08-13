---
type: principe-de-conception
id: PDC-003
title: "SMART et extrême SMART"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
portee: systeme
---

# PDC-003 - SMART et extrême SMART

> Une ressource qui planifie du travail énonce ce qui est fait, comment on le mesure, et dans quel délai. Ce qui ne satisfait pas ces critères n'est pas une planification : c'est une issue.

> **Premier jet produit par l'agent, non actif.** `CONSTITUTION.md` C1 réserve la création d'un principe de conception à l'humain. Ce document est une **recommandation**, au régime que `DCN-013` fixe pour les décisions : il n'est pas actif tant que l'humain ne l'a pas approuvé. Voir `NON-027`.

## Objet

Fixer le régime SMART des ressources de planification du travail, et déclarer, critère par critère, lequel contraint, lequel est seulement mesuré, et lequel est sans objet.

## Le principe

### Ce à quoi il s'applique

| Type | Régime |
|---|---|
| `PLN`, plan de travail | **extrême SMART** |
| `CMP`, comportement attendu | **SMART** |
| `RQF`, `RQNF`, requis | **SMART** |
| `ISU`, issue | **exclu par construction**, `RES-031` |
| Tout autre type | hors portée |

### Les cinq critères, et ce que chacun contraint

C'est la partie qui manquait au modèle d'origine : un principe nommé « extrême SMART » dont deux des cinq critères ne contraignent rien promet plus que son contenu.

| Critère | Ce qu'il exige | Régime en 0.1.0 |
|---|---|---|
| **S**pécifique | Le livrable est nommé, et un lecteur qui ne connaît pas le sujet sait ce qui sera produit | **contraint** |
| **M**esurable | Un critère de réussite vérifiable sans jugement | **contraint** |
| **A**tteignable | L'effort tient dans la limite de temps du régime | **contraint** en extrême SMART, **mesuré** en SMART |
| **R**éaliste | Les dépendances sont disponibles ou nommées | **mesuré**, non bloquant |
| **T**emporel | Une limite de temps déclarée | **contraint** en extrême SMART, **sans objet** en SMART |

### Ce que l'extrême ajoute

Trois exigences, et la troisième est celle qui donne son nom au régime.

**E1. Le livrable est unique.** Un plan qui produit deux livrables est deux plans. Le modèle d'origine, `deeptech-ticket-driven`, en faisait la condition de la timebox.

**E2. Le critère de réussite est exécutable.** Une commande, un test, un contrôle nommé. Un critère qui demande de lire et juger n'est pas mesurable au sens de M.

**E3. La limite de temps est contraignante et courte.** Le modèle d'origine fixait douze heures. Une planification qui dépasse sa limite ne s'étend pas : elle se scinde, ou elle redevient une issue.

### Le seuil de bascule

Une ressource de planification qui ne satisfait pas S, M et T **n'est pas produite**. Elle devient une `ISU`, dont le coût d'entrée est un titre et une phrase.

C'est le mécanisme qui protège les deux régimes : la planification reste nette parce que le flou a un autre endroit où aller.

## Ce qu'il exclut

| Exclu | Motif |
|---|---|
| Un plan sans limite de temps | Viole T et E3. Le corpus en compte deux, `PLN-001` et `PLN-002` |
| Un plan à plusieurs livrables | Viole E1 |
| Un critère de réussite qui demande un jugement | Viole M et E2 |
| Une issue à laquelle on impose une échéance | `RES-031` : l'issue est non SMART par construction |
| Un principe SMART appliqué aux ressources de savoir | `ANL`, `FND`, `MET`, `CPT` ne planifient pas de travail |

**Ce qu'il n'exclut pas.** Qu'un plan se scinde. Une planification trop grosse produit deux planifications, pas une exception.

## Comment le vérifier

Trois contrôles. Le premier est exécutable, les deux autres demandent une lecture.

**V-S1. Le livrable est nommé.** Toute ressource au régime extrême SMART porte une rubrique de livrable non vide, et un seul livrable y figure.

**V-S2. Le critère de réussite est exécutable.** Il nomme une commande, un test ou un contrôle. Vérifiable par lecture, et par exécution du critère lui-même.

**V-S3. La limite de temps est déclarée.** Un champ ou une rubrique porte une durée. Son absence dans une ressource au régime extrême SMART est un défaut.

**Mesure du 2026-08-11.** Les deux plans du dépôt, `PLN-001` et `PLN-002`, échouent aux trois contrôles : aucun ne déclare de limite de temps, aucun ne porte un livrable unique, et leurs critères de réussite demandent une lecture. `PLN-002` porte huit livrables.

## Conséquence d'une violation

Une planification qui viole S, M ou T ne cadre pas le travail : elle le décrit. Le corpus mesure ce que cela produit. `ANL-001` relève des vagues de travail séparées de plusieurs mois, et une session qui constate qu'il y a beaucoup à faire, qu'il est impossible de tout faire, et qu'il manque un moyen de prioriser.

Le ticket extrême SMART répondait à cette tension par une limite de douze heures. Le contenant plus souple qui l'a remplacé a rouvert le problème.

Une violation est donc un bogue au sens de `RES-012` : elle se corrige, ou elle produit une objection qui expose l'arbitrage.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/observations-pratiques.md)
- `reference` [RES-031](../ressources/RES-031-issue.md)
- `reference` [RES-025](../ressources/RES-025-plan.md)
- `reference` [NON-027](../objections/NON-027-regime-smart-et-type-issue.md)
