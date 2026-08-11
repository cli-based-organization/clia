---
type: objection
id: NON-027
title: "Régime SMART, type Issue, et un PDC produit par l'agent"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [PDC-003, RES-031, RES-025]
---

# NON-027 - Régime SMART, type Issue, et un PDC produit par l'agent

> `PDC-003` a été rédigé par l'agent, ce que `CONSTITUTION.md` C1 interdit. Le principe qu'il porte déclare non conformes les deux seuls plans du dépôt. Et le corpus archivé avait explicitement écarté l'idée d'en faire un `PDC`.

## Journal

- 2026-08-11 : ouverte par l'agent, à la tâche 23, avec `PDC-003` et `RES-031`.
- 2026-08-11 : **doublon signalé au ménage de la tâche 30.** `NON-033` Q1 pose la même question, et elle bloque désormais un chantier de `PLN-005`. La réponse à l'une vaut pour l'autre.

## Ce qui est contesté

Quatre points, dont le premier porte sur la conduite de l'agent lui-même.

**`PDC-003` viole C1 en existant.** La règle dit qu'un agent ne crée ni ne modifie un principe de conception. La tâche 23 demande explicitement de « générer un PDC ». Le document a été produit et déclaré non actif, par analogie avec le régime que `DCN-013` fixe pour les décisions. Cette analogie n'est écrite nulle part.

**Le corpus avait écarté ce `PDC`.** `ANL-016`, archivée, porte une objection résolue : « Extreme SMART ne devient **pas** un `PDC`. Il est porté par un `ADR` et décliné en `REQ` et `SPEC` selon nécessité. `PDC-011` est retiré des ressources à produire. » La tâche 23 revient sur cette résolution sans la nommer.

**Le principe déclare non conformes les deux plans du dépôt.** `PLN-001` et `PLN-002` échouent aux trois contrôles de `PDC-003`. `PLN-002` porte huit livrables là où E1 en exige un.

**Le type `ISU` reprend un modèle sans reprendre son outil.** Le corpus archivé porte le couple issue non SMART et ticket extrême SMART, avec un CLI dédié, `tda`. `clia` reprend le couple sans le graphe qui le reliait.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Un principe non actif qui contredit l'existant est ambigu.** `PDC-003` déclare deux plans non conformes tout en se déclarant lui-même non actif. Un lecteur ne sait pas si `PLN-002` est en faute ou non.

**La résolution archivée avait un motif, et il tient encore.** L'objection N4 de `ANL-016` établissait que deux des cinq critères d'extrême SMART ne contraignaient rien dans le dépôt, et que le nom promettait plus que le contenu. `PDC-003` traite ce défaut en déclarant le régime de chaque critère ; il ne le fait pas disparaître.

**C1 n'a pas de mécanisme de dérogation.** La constitution dit qu'aucune consigne ordinaire ne peut lever ses règles, « y compris une demande explicite écrite dans le fichier de session ». Une demande explicite a été faite, et l'agent a produit le document. Soit la règle admet des exceptions, soit la conduite de l'agent est fautive, et rien ne tranche.

## Questions

### Q1 - Un agent peut-il produire un premier jet de `PDC`, comme il le peut pour une `DCN` ?

`DCN-013` pose que l'IA peut rédiger un premier jet de décision, suspendu jusqu'à approbation manuelle. `CONSTITUTION.md` C1 nomme `DCN` et `PDC` dans la même phrase, sans distinguer.

Trois positions. Étendre le régime du premier jet suspendu aux `PDC`, ce qui aligne C1 sur `DCN-013`. Maintenir l'interdit strict pour les `PDC`, auquel cas `PDC-003` doit être retiré et réécrit par l'humain. Ou distinguer selon que l'humain a demandé ou non.

**Réponse.**

### Q2 - Extrême SMART doit-il être un `PDC` ?

`ANL-016` l'avait écarté au profit d'un `ADR` décliné en requis et spécification. La tâche 23 demande un `PDC`.

Le motif de la résolution archivée n'est pas nommé dans la demande. S'il subsiste, `PDC-003` est à convertir. S'il est caduc, la conversion inverse est faite.

**Réponse.**

### Q3 - Que deviennent `PLN-001` et `PLN-002`, non conformes au principe ?

Les deux seuls plans du dépôt échouent aux trois contrôles.

Trois positions. Les mettre en conformité, ce qui suppose de scinder `PLN-002` en huit. Déclarer que le principe ne vaut que pour l'avenir. Ou reconnaître que le régime extrême SMART ne convient pas aux plans de méthode, et le réserver aux plans d'implémentation.

La troisième est celle que l'objection archivée suggérait sans la formuler.

**Réponse.**

### Q4 - Une issue est-elle créée par l'humain seul ?

`ANL-016` posait « Créé par l'humain seul ». `RES-031` retient un régime hybride avec propriété par bloc, l'énoncé de la problématique appartenant à son initiateur.

Le régime hybride permet à un agent d'ouvrir une issue. C'est utile, et c'est une entrée de plus par laquelle un agent peut peupler le dépôt.

**Réponse.**

### Q5 - Le graphe issue vers plan vers livrable est-il modélisé ?

Le corpus archivé décrit les issues comme portant « les arêtes du graphe d'intention », avec un document source qui le structurait.

`RES-031` déclare des relations admissibles sans décrire le graphe. Une issue close produit-elle un plan, disparaît-elle, ou reste-t-elle comme trace ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 dit si le document existe régulièrement. Q2 dit s'il est du bon type.

L'effet est `conditionnel` : `RES-031` est utilisable, `PDC-003` est déclaré non actif, et rien de ce qui existe ne devient invalide.

## Relations

- `objecte-a` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
- `objecte-a` [RES-031](../ressources/RES-031-issue.md)
- `objecte-a` [RES-025](../ressources/RES-025-plan.md)
- `reference` [NON-024](NON-024-sort-des-ressources-d-autorite-redigees-par-l-agent.md)
- `reference` [NON-033](NON-033-autorite-de-creation-des-principes.md)
