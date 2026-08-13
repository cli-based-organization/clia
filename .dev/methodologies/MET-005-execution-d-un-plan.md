---
type: methodologie
id: MET-005
title: "Exécution d'un plan"
version: 0.1.0
status: draft
domaine: "conduite de l'exécution d'un plan, de son autorisation à sa clôture"
---

# MET-005 - Exécution d'un plan

> Quand un plan s'exécute, ce qu'il faut rendre à la fin, et quand décider en avançant plutôt que d'ouvrir une objection.

## Objet

Cette méthodologie fixe le procédé d'exécution d'un plan.

Elle est demandée par la tâche 9 de `SES-002` : « Après chaque exécution de plan, dire les fonctionnalités qui ont été implémentés et comment l'utiliser. Mettre cette directive dans la méthodologie qui guide l'exécution des plans. »

Aucune méthodologie ne couvrait ce procédé : `MET-003` porte la journalisation, `MET-004` la réévaluation d'un plan par le régime SMART.

## Quand l'employer

Dès qu'une tâche exécute un ou plusieurs plans.

## Étape 1 - Vérifier que la tâche autorise l'exécution

**Le type déclaré de la tâche commande.**

| Type | Ce que la tâche produit | Peut-elle exécuter un plan ? |
|---|---|---|
| `[analyse]` | Une analyse | **Non** |
| `[planification]` | Un plan | **Non** |
| `[conception]` | Une définition, une spécification | **Non** |
| `[implémentation]` | Du code, des ressources | **Oui** |
| `[bogue]` | Un diagnostic, un correctif | Oui, si le correctif l'exige |

**Un plan produit par une tâche reste `propose`.** Son exécution appartient à une tâche ultérieure, que l'humain déclenche.

**Le motif est mesuré.** `BUG-002` : deux plans sur trois ont été exécutés dans la tâche qui les a créés, et les tâches d'exécution ultérieures ont produit zéro livrable. Le plan est l'objet qui permet à l'humain de décider **qui exécute et quand** ; l'exécuter d'avance supprime ce point de décision.

## Étape 2 - Décider en avançant, ou s'arrêter

Une incertitude rencontrée en exécutant se tranche par ce filtre. `PDC-005` pose le principe ; ce tableau le rend applicable.

| L'agent décide et avance quand | L'agent s'arrête et ouvre une objection quand |
|---|---|
| La décision est réversible | Le geste est irréversible ou coûteux à défaire |
| Elle touche du code ou un document d'agent | Elle touche un document en régime d'édition humaine |
| Une lecture raisonnable existe | Deux lectures mènent à des travaux incompatibles |
| Se tromper coûte une correction | Se tromper coûte une migration |

**Les quatre lignes se lisent ensemble.** Une seule colonne de droite qui s'applique suffit à arrêter.

**Une décision prise en avançant n'est pas une décision tue.** Elle est consignée dans le journal de la tâche, rubrique « ce qui a été décidé en avançant » du log d'analyse ou du log de fait. Elle change de lieu, pas de statut.

## Étape 3 - Exécuter chantier par chantier

Dans l'ordre que le plan déclare. Chaque chantier a un critère de réussite exécutable : **il est exécuté, pas supposé**.

**Un écart au plan décidé en l'exécutant se déclare.** Le plan a été écrit avant de connaître le terrain ; le corriger est normal, le corriger en silence ne l'est pas.

## Étape 4 - Rendre les fonctionnalités livrées

**C'est la directive de la tâche 9, et elle porte sur ce qui est rendu à l'humain, non sur ce qui est produit.**

À la fin de l'exécution, le journal de fait déclare, pour chaque fonctionnalité touchée :

| Élément | Ce qu'il porte |
|---|---|
| **Ce qui a été livré** | La capacité neuve, en une phrase |
| **Comment s'en servir** | La commande, avec un exemple qui s'exécute |
| **Ce qui ne marche pas encore** | Les limites connues, et les items ouverts qui la touchent |

**Le même contenu alimente la ressource `FNC` correspondante.** Une fonctionnalité neuve reçoit une instance ; une fonctionnalité étendue voit sa rubrique « Comment s'en servir » mise à jour.

**Le motif.** Un plan exécuté laissait jusqu'ici un journal de fait et un message de commit, dont aucun ne dit comment se servir de ce qui vient d'être livré. L'humain devait lire le code ou l'aide pour le découvrir.

## Étape 5 - Clore le plan

`statut-plan` passe à `execute`, et la section « Statut » du corps dit quelle tâche l'a exécuté, à quelle date.

**Un plan partiellement exécuté ne passe pas à `execute`.** Il reste `propose`, et le journal dit quels chantiers ont été faits et lesquels ne l'ont pas été.

## Ce qui n'est pas fait, et comment le dire

**Une exécution qui ne produit aucun livrable est un échec, et se déclare comme tel.**

L'agent ne clôt pas la tâche en la déclarant réussie : il nomme l'anomalie, en cherche la cause, et propose l'action utile. `clia focus` la désigne.

C'est le second défaut relevé par `BUG-002`, et le plus grave des deux : présenter une tâche vide comme un succès empêche l'humain de voir qu'il y a un problème.

## Éprouvé sur

| Cas | Résultat |
|---|---|
| Les 39 objections du dépôt, rangées une à une par le filtre de l'étape 2 | **26 devaient s'arrêter, 12 pouvaient avancer, 1 n'est pas une objection.** Douze sur trente-neuf n'avaient pas lieu d'être ouvertes |
| `NON-035` et `NON-036`, rangées du côté « avancer » | **Vérifié après coup** : traitées en avançant, `PLN-011` et le type `Bogue`, sans qu'aucune décision coûte de retour en arrière |
| `NON-013` | **Le filtre ne le range pas**, et c'est juste : un brouillon vide ne porte aucune incertitude à trancher |

**Ce que l'épreuve établit.** Le filtre départage, et il départage dans le sens qui réduit les objections : près d'un tiers des cas passés.

**Ce qu'elle n'établit pas.** Sa tenue sur des cas neufs. Le rangement porte sur trente-neuf objections déjà écrites, par celui-là même qui les a ouvertes.

## Comment vérifier que la méthodologie est suivie

| Contrôle | Ce qu'il regarde |
|---|---|
| Le type de la tâche autorisait-il l'exécution | L'énoncé de la tâche |
| Chaque critère de réussite a-t-il été exécuté | Le log de résultat de validation |
| Les fonctionnalités livrées sont-elles décrites avec leur usage | Le log de fait |
| Le plan déclare-t-il la tâche qui l'a exécuté | La section « Statut » du plan |

## Relations

- `derive-de` [BUG-002](../bogues/BUG-002-un-plan-est-execute-par-la-tache-qui-le-cree.md)
- `derive-de` [PLN-013](../plans/PLN-013-borner-l-ouverture-des-objections.md)
- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
- `reference` [PDC-005](../principes/PDC-005-mode-ia-best-effort-documente.md)
- `reference` [MET-003](MET-003-journalisation-du-travail.md)
- `reference` [MET-004](MET-004-reevaluation-d-un-plan-par-le-regime-smart.md)
