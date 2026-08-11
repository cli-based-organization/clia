---
type: methodologie
id: MET-004
title: "Réévaluation d'un plan par le régime SMART"
version: 0.1.0
status: draft
domaine: "séparation de ce qui est planifiable de ce qui ne l'est pas encore"
---

# MET-004 - Réévaluation d'un plan par le régime SMART

> Comment séparer, dans un plan, ce qui est assez net pour être fait de ce qui ne l'est pas. Ce qui ne l'est pas sort du plan et devient une issue, avec son objection et ses relations. Le plan retrouve un contenu implémentable.

## Objet

Cette méthodologie fixe le procédé de réévaluation d'un plan au regard de `PDC-003`.

Elle est demandée par un `TODO` de la tâche 29 : « écrire cette procédure dans une nouvelle MET ».

## Quand l'employer

**À employer** quand un plan porte des chantiers qu'on ne sait pas exécuter, et qu'on ne sait pas dire pourquoi.

**À employer aussi** avant d'engager un plan écrit il y a longtemps : ce qui était planifiable a pu cesser de l'être, et l'inverse.

**À ne pas employer** sur un plan dont tous les chantiers sont nets. La procédure coûte une issue et une objection par thématique ; elle ne se justifie que s'il y a du flou à évacuer.

## Le principe qui la fonde

`PDC-003` pose un seuil de bascule : « une planification qui ne satisfait pas S, M et T n'est pas produite. Elle devient une `ISU`. »

`RES-031` pose qu'une issue est non-SMART par construction : ni livrable, ni échéance, ni critère mesurable.

Les deux se tiennent. **Le flou a un endroit où aller**, et c'est ce qui permet au plan de rester net.

Sans cet endroit, un chantier non implémentable reste dans le plan et le fait échouer entier.

## Le procédé

Six étapes.

### 1. Partir de la liste des livrables

Pas des chantiers, des **livrables**. Un chantier peut porter plusieurs livrables, et c'est souvent là que le défaut se cache.

Un plan qui n'a pas de rubrique de livrables ne peut pas être réévalué : la produire est l'étape zéro.

*Contrôle :* chaque livrable est nommé et attribué à un chantier.

### 2. Confronter chaque livrable aux trois contrôles

`PDC-003` en donne trois, et ils s'appliquent un par un.

| Contrôle | Question |
|---|---|
| V-S1 | Le livrable est-il unique et nommé ? |
| V-S2 | Le critère de réussite est-il exécutable ? |
| V-S3 | Une limite de temps est-elle déclarée ? |

Le résultat tient dans une table, un livrable par ligne.

**Un échec sur V-S3 seul ne disqualifie pas.** L'absence de limite de temps est un défaut du plan entier, non du livrable. Elle se corrige en une ligne.

**Un échec sur V-S1 se corrige souvent par scission.** Un chantier à trois livrables devient trois chantiers.

**Un échec sur V-S2 est le seul qui révèle un vrai blocage.** Un critère de réussite qu'on ne sait pas énoncer signale qu'on ne sait pas ce qu'on cherche.

*Contrôle :* la table porte un verdict par livrable, et le verdict cite le contrôle qui échoue.

### 3. Regrouper les échecs par thématique

**C'est l'étape qui demande du jugement**, et elle est ce qui distingue cette méthodologie d'une simple liste de défauts.

Les échecs ne sont pas indépendants. Un même manque bloque souvent plusieurs livrables : un outil absent, un vocabulaire non fixé, une règle qui interdit.

Une thématique est un **manque**, pas un livrable. « Le générateur n'existe pas » est une thématique ; « le chantier G est bloqué » n'en est pas une.

*Contrôle :* chaque thématique nomme un manque, et chaque livrable en échec est rattaché à une thématique et une seule.

### 4. Ouvrir une issue par thématique

Une `ISU` par thématique, jamais une par livrable.

Elle porte les rubriques de `RES-031` : la problématique, ce qui la rend difficile, ce qui a été tenté, les pistes, ce qui la clôturerait.

**La rubrique « Ce qui a été tenté » est celle qui évite la répétition.** Une thématique rouverte sans mémoire des tentatives fait recommencer le même travail.

**Les pistes ne sont pas des décisions.** Elles sont notées pour ne pas être redécouvertes, et aucune n'est retenue à ce stade.

*Contrôle :* le nombre d'issues égale le nombre de thématiques.

### 5. Ouvrir une objection par issue, et croiser les relations

Chaque `ISU` reçoit une `NON`. L'issue décrit le problème ; l'objection pose les questions qui le trancheraient.

| Ressource | Relation | Cible |
|---|---|---|
| `ISU` | `objecte-a` | la `NON` |
| `NON` | `repond-a` | l'`ISU` |
| `ISU` | `reference` | le plan et les livrables impactés |

**L'effet de l'objection se décide par ce qu'elle bloque.** Une thématique qui empêche un livrable d'exister porte un effet `bloquant`. Une thématique qui laisse un défaut de forme porte `informatif`.

*Contrôle :* chaque `ISU` a exactement une `NON`, et les deux se citent.

### 6. Implémenter ce qui reste

Une fois les thématiques sorties du plan, ce qui reste est implémentable ou dépend d'un préalable nommé.

**Ne pas implémenter ce qui dépend d'une décision humaine non prise**, même si le livrable est SMART. Un livrable net dont le préalable est ouvert reste bloqué, et le confondre avec un livrable libre est le défaut que cette méthodologie corrige.

*Contrôle :* chaque livrable implémenté a ses trois contrôles au vert et aucun préalable ouvert.

## L'apport d'information

La demande de la tâche 29 en décrit le mécanisme : « L'humain peut apporter des informations à un ISU en lui écrivant des FRG à l'intérieur de ISU. Ou bien en y liant un FRG ou n'importe quelle autre ressource. »

**Deux voies, et une seule fonctionne aujourd'hui.**

| Voie | État |
|---|---|
| Lier une ressource par une relation | fonctionne |
| Écrire un `FRG` **à l'intérieur** de l'`ISU` | `ISU-001`, non implémenté |

**À chaque apport, la réévaluation se rejoue** sur les livrables que l'issue bloque. Un apport qui lève une thématique rend implémentables les livrables qui en dépendaient, et l'issue passe à `close`.

C'est ce qui fait de cette procédure un cycle et non une passe unique.

## Ce qui peut échouer

Six modes d'échec.

**Ouvrir une issue par livrable.** Signe : autant d'issues que de chantiers en échec. Les issues perdent leur fonction de regroupement, et le plan est recopié sous un autre nom.

**Nommer une thématique par le livrable qu'elle bloque.** Signe : une issue intitulée « le chantier G est bloqué ». Une thématique nomme un manque.

**Confondre un défaut de forme et un blocage.** Signe : une issue ouverte pour une absence de limite de temps. V-S3 se corrige en une ligne.

**Implémenter un livrable SMART dont le préalable est ouvert.** Signe : un chantier fait alors qu'une objection bloquante le concerne. C'est le défaut le plus coûteux, parce qu'il produit du travail à refaire.

**Réécrire le plan.** Le type `PLN` est `travail` : son statut évolue, son contenu reste. La réévaluation s'ajoute.

**Ne pas rejouer la réévaluation après un apport.** L'issue reste ouverte alors que sa thématique est levée, et les livrables restent bloqués sans raison.

## Éprouvé sur

| Cas | Résultat |
|---|---|
| `PLN-005`, tâche 29 | **Première application.** Neuf chantiers, douze livrables, cinq thématiques, cinq issues, cinq objections, trois livrables implémentés |

**Ce que l'épreuve établit.** Les douze livrables se sont répartis nettement : trois implémentables, trois SMART mais à préalable ouvert, et six rattachés à cinq thématiques.

L'étape 3, le regroupement, est celle qui a demandé le plus de jugement : deux thématiques auraient pu être fusionnées, l'absence de générateur et l'absence de frontières conceptuelles ayant en commun qu'un préalable manque.

**Ce qu'elle n'établit pas.** Le cycle. Aucun apport d'information n'a eu lieu, donc la réévaluation n'a jamais été rejouée.

## Relations

- `derive-de` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
- `specifie` [RES-031](../ressources/RES-031-issue.md)
- `reference` [RES-025](../ressources/RES-025-plan.md)
- `reference` [MET-003](MET-003-journalisation-du-travail.md)
