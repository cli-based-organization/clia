---
type: issue
id: ISU-003
title: "Le cycle de vie collectif des ressources n'est pas modélisable"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouverte"
initiateur: agent
etat: ouverte
ouverture: 2026-08-11
---

# ISU-003 - Le cycle de vie collectif n'est pas modélisable

> `NON-004` Q4 pose que le cycle de vie des ressources est collectif, non individuel. `RES-001` attribue à chaque ressource un cycle individuel. Aucune réponse ne dit par quoi le remplacer.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 29, comme thématique T2 de la réévaluation de `PLN-005`.
- 2026-08-11 : **`DCN-014` créée par l'humain**, intitulée « cycle de vie des ressources ». Le gabarit est vide. C'est un signal, non une information : la décision s'annonce et n'est pas écrite. `MET-004` prévoit que la réévaluation se rejoue à chaque apport ; il n'y a rien à rejouer tant que le contenu manque.

## La problématique

La réponse Q4 de `NON-004` énonce trois conséquences, et le dépôt ne sait représenter aucune des trois.

**« la ressource informationnelle n'est qu'un réceptacle matérialisé et outillable d'une idée ».** Le modèle traite la ressource comme l'objet ; l'idée n'a aucune existence dans le système.

**« le cycle de vie des ressources informationnelles n'est pas individuel, il est collectif ».** `RES-001` déclare trois cycles, `vivant`, `point-fixe` et `travail`, attribués un par un.

**« la notion d'espace actif est plus importante qu'il n'y paraît ».** `CLAUDE.md` la mentionne en une ligne, sans définition. Aucune ressource ne la porte.

## Ce qui la rend difficile

**Aucune réponse ne propose de remplacement.** La réponse constate que le modèle est faux ; elle ne dit pas quel modèle est juste.

**Les idées sont déclarées polymorphes.** « Leur nature peut changer suite à un changement de contexte. » Un type déclaré dans un frontmatter est fixe par construction.

**Le modèle actuel fonctionne.** Cent trente-sept ressources portent un cycle individuel, et rien ne casse. Le remplacer sans nécessité coûterait plus que le défaut qu'il corrige.

**L'espace actif touche au harnais.** `CLAUDE.md` en fait un sous-ensemble de documents à prendre en considération. Le définir change ce que l'agent lit, donc ce qu'il produit.

## Ce qui a été tenté

**Rien dans ce dépôt.**

Le corpus offre un antécédent partiel : `disruptiva-dev/nty` faisait de l'ontologie un objet de première classe manipulable par CLI, avec des notions de `phore` et d'assignation ontologique. Le dépôt est dormant et le mécanisme n'a jamais été éprouvé.

## Pistes

**P1. Ne rien changer, et le déclarer.** Le cycle individuel reste, et `RES-001` note qu'il ne représente pas le cycle collectif. Le moins coûteux, et le problème demeure.

**P2. Modéliser l'idée comme une ressource.** Un type porterait l'idée, et les ressources en seraient des matérialisations. Cohérent avec « réceptacle », et cela ajoute un niveau au modèle entier.

**P3. Faire du cycle une propriété de l'espace actif, non de la ressource.** Une même ressource aurait un cycle différent selon l'espace où elle est lue. Cohérent avec le polymorphisme, et sans mécanisme connu.

**P4. Commencer par l'espace actif seul.** Le définir, l'outiller, et voir si le cycle collectif s'en déduit.

## Ce qui la clôturerait

Une décision sur ce que devient le cycle individuel de `RES-001`.

La question de l'espace actif peut rester ouverte : elle est plus large que ce cycle.

## Relations

- `objecte-a` [NON-031](../objections/NON-031-cycle-de-vie-collectif.md)
- `reference` [PLN-005](../plans/PLN-005-ajustement-au-savoir-relationnel.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [DCN-014](../decisions/DCN-014-cycle-de-vie-des-ressources.md)
