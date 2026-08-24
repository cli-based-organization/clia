---
type: objection
id: NON-030
title: "Trois familles dérivées, aucun générateur"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: bloquant
etat: repondue
porte-sur: [RES-018, RES-019, RES-010]
---

# NON-030 - Trois familles dérivées, aucun générateur

> Trois décisions du 2026-08-11 retirent l'autorité aux skills, aux ADR et aux analyses en les déclarant dérivés. Trente-deux documents sont dans cet état, et rien ne les dérive.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 29, avec `ISU-002`.
- 2026-08-11 : **reprend `NON-025` Q1 et Q2**, signalé au ménage de la tâche 30. `NON-025` portait la question pour les seuls skills ; celle-ci l'élargit aux trois familles dérivées.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Non pas les trois décisions, qui sont des réponses de l'humain. L'état qu'elles produisent.

**Trente-deux documents ne font plus autorité et continuent de commander.** Sept skills, dix-sept ADR, huit analyses. `skl-001` est le document que l'agent lit avant d'écrire toute ressource ; il est déclaré sans autorité depuis le 2026-08-11.

**Le mécanisme est spécifié à moitié.** `NON-026` Q5 décrit cinq étapes. Les étapes 4 et 5 existent, trente gabarits et soixante-deux schémas. Les étapes 1 à 3, la part non déterministe, n'existent pas.

**Deux des quatre sources nommées n'ont aucune instance.** `ADR-016` D3 nomme `RES`, `ADR`, `SPC` et `RQF`. Le dépôt compte zéro `SPC` et zéro `RQF`.

**Une part des skills ne se dérive de rien.** `skl-001` porte trois interdits typographiques, cinq interdits de registre et dix contrôles. Aucun n'est déductible d'une définition.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**L'écart se creuse à chaque tâche.** Les tâches 25 et 28 ont modifié les sept skills à la main. Chaque modification éloigne le document de ce qu'un générateur produirait.

**Un document sans autorité qui commande est le pire des deux états.** Il n'est ni contraignant en droit, ni révisable sans risque, puisque tout le dépôt s'y réfère.

**Le chantier G de `PLN-005` est bloqué par ce manque**, et il porte la troisième obligation de propagation du dépôt : une mise à jour du savoir doit atteindre les ressources générées à partir de lui.

## Questions

### Q1 - Que fait-on des trente-deux documents en attendant ?

Trois positions. Suspendre les trois décisions jusqu'à ce que le générateur existe. Déclarer que les documents actuels font autorité par exception, datée. Ou accepter l'écart en le nommant, ce qui est l'état actuel non déclaré.

**Réponse.**

### Q2 - Faut-il écrire la spécification avant l'outil ?

`ADR-006` sépare strictement la spécification de l'implémentation. Le type `SPC` n'a aucune instance : ce serait la première.

Écrire la `SPC` d'abord est cohérent avec la décision et retarde l'outil. L'écrire après contredit `ADR-006`.

**Réponse.**

### Q3 - Par quel type commencer ?

Le skill est le candidat le plus simple : structure régulière, sept instances qui servent de cas d'épreuve, et une définition qui porte déjà ses champs.

L'ADR est le plus utile : dix-sept documents, et la chaîne d'autorité du dépôt en dépend.

**Réponse.**

### Q4 - Comment nommer les deux mécanismes ?

`NON-026` Q5 le demande explicitement : « il faut trouver un nom pour les 2 mécanismes différents », la génération déterministe par gabarit et la génération non déterministe par IA.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1.

L'effet est `bloquant` : trente-deux documents sont dans un état indéterminé, et le dépôt entier s'y réfère.

## Relations

- `objecte-a` [RES-018](../ressources/RES-018-skill.md)
- `objecte-a` [RES-019](../ressources/RES-019-adr.md)
- `repond-a` [ISU-002](../issues/ISU-002-aucun-generateur-de-ressources-derivees.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
- `reference` [NON-025](NON-025-consequences-de-la-derivabilite-des-skills.md)
