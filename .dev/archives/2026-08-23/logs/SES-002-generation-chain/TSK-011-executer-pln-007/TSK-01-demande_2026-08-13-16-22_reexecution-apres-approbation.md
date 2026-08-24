# La demande, tâche 11 de SES-002 — réexécution

`MET-003` étape 1. Second passage de la même tâche. `derive-de` `TSK-01-demande_2026-08-13-13-53_executer-pln-007.md`.

## L'énoncé

> réExécuter la tâche 11 et 12

## Ce qui a changé depuis le premier passage

**`DCN-016` porte `effet: en-vigueur`.** L'humain a fait le geste que `clia focus` désignait, entre 16:17 et 16:22.

C'est exactement le déblocage que le premier passage attendait. La tâche 11 avait produit zéro chantier sur sept pour cette seule raison.

## Ce que cela rend exécutable, et ce que je vérifie avant

Le premier passage a établi que F et G étaient déjà satisfaits, et que A à E attendaient l'approbation.

**Je ne présume pas que les cinq soient maintenant exécutables.** Deux points restent à vérifier avant de toucher quoi que ce soit :

| À vérifier | Pourquoi |
|---|---|
| Le point d'arrêt avant le chantier B | Le plan l'énonce : « le sort de `status` doit être tranché ». `ISU-009` est-elle toujours ouverte ? |
| Ce que le chantier E casserait | Il supprime `etat`, `effet` et `statut-plan`. `clia focus` et `clia res ls` les lisent |

**Le second point n'est écrit nulle part dans le plan.** Il est né du travail des tâches 9 à 13, postérieur à l'écriture de `PLN-007` le 2026-08-11.

## Ce que je surveille

**Ne pas exécuter en bloc parce que le blocage principal est levé.** Un chantier peut rester bloqué pour une raison propre, et le plan a été écrit avant que le CLI existe sous sa forme actuelle.

**`MET-005` étape 6, écrite il y a quinze minutes** : la tâche se terminera sur une directive unique, cohérente avec `clia focus`. C'est sa première application.
