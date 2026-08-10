---
type: objection
id: NON-frontiere-contexte-intention-faits
title: "Frontière entre Contexte, Intention et Faits"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-contexte, RES-intention, RES-fait]
---

# NON-003 - Frontière entre Contexte, Intention et Faits

> Les trois types sont définis pour la première fois dans ce jet, sans aucune instance dans le corpus pour les éprouver. Leurs frontières sont proposées par raisonnement, pas par expérience, et elles se recoupent en plusieurs points.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

Les frontières proposées entre `CTX`, `INT` et `FCT`, et le statut de deux objets particuliers : `INTENTION.md` et l'état émotionnel de l'humain.

`ANL-001` classe les trois types comme **latents** : le concept est actif dans la pratique, aucune instance typée n'existe. `CTX` et `FCT` n'ont zéro instance dans tout le corpus, `INT` en a une seule, `INT-001` de `intentional-doers-governance`.

Les définitions produites reposent donc sur une seule source d'expérience : la rubrique `# CONTEXTE` des fichiers de session, et les vingt `INTENTION.md` du corpus.

## Pourquoi cela ne peut pas rester implicite

Trois recoupements sont déjà visibles dans les définitions produites.

Un historique d'intentions abandonnées appartient au contexte par sa nature d'historique, et à l'intention par son objet. `ANL-001` établit au défaut D3 que le corpus n'a jamais tracé ses quatre ruptures de cap majeures : le type qui aurait dû les porter n'est pas identifié.

Un contexte s'appuie sur des faits, mais rien n'oblige à les distinguer. `RES-002` affirme qu'un contexte cite des faits sans en tenir lieu, et rien ne l'empêche : un contexte peut parfaitement énoncer des mesures sans les consigner, ce qui est exactement ce que fait `ANL-001`.

Les acteurs sont une rubrique du contexte dans `RES-002`, alors que `resource-types.yaml` de `clia` prévoyait un type Acteur (`ACT`) à part entière, avec un `ADR-011` et un `skl-016-acteur`. Deux modélisations concurrentes existent, aucune n'a d'instance.

## Questions

### Q1 - `INTENTION.md` est-il l'instance `INT-001`, ou reste-t-il hors du modèle de types ?

`RES-003` propose que `INTENTION.md` soit `INT-001`, avec un emplacement dérogatoire à la racine déclaré comme propriété du type. La conséquence est que `INTENTION.md` doit porter un frontmatter, ce qu'aucun `INTENTION.md` du corpus ne fait. La position concurrente le laisse hors du modèle, ce qui ne change rien mais laisse sans modèle le document le plus important du dépôt.

**Réponse.**

### Q2 - Où va l'état émotionnel de l'humain, que `CLAUDE.md` demande de prendre en compte ?

`RES-002` propose qu'il ne soit pas une ressource, au motif qu'une ressource est versionnée, partageable et opposable, et que l'affect n'a aucune de ces trois propriétés. La demande de `CLAUDE.md` deviendrait alors une qualité d'attention de l'agent en conversation, sans objet produit. Cette lecture est-elle acceptée, ou l'humain veut-il que cela laisse une trace ?

**Réponse.**

### Q3 - L'historique des intentions abandonnées relève-t-il du contexte, de l'intention, ou d'un type de décision qui manque ?

Le corpus n'a tracé aucune de ses quatre ruptures de cap. `RES-003` propose qu'une révision majeure de l'intention ultime exige une trace écrite sous forme d'ADR. Mais un ADR décide d'une architecture, il ne décide pas d'un cap. Faut-il un type distinct pour la décision de direction ?

**Réponse.**

### Q4 - Faut-il un type Acteur distinct, ou les acteurs sont-ils une rubrique du contexte ?

`RES-002` en fait une rubrique. `resource-types.yaml` en faisait un type, avec des champs propres (`categorie` valant primaire, secondaire ou partie prenante ; `portee` valant méthode ou domaine) et une relation `utilise` vers les cas d'usage. Le corpus n'a aucune instance des deux modélisations.

**Réponse.**

### Q5 - Un contexte peut-il énoncer des mesures sans les consigner comme faits ?

`ANL-001` est une analyse qui énonce des dizaines de mesures sans produire aucun recueil `FCT`. Si c'est admissible, la frontière entre contexte, analyse et faits est de commodité et non de nature. Si ce n'est pas admissible, une bonne part du travail existant est non conforme.

**Réponse.**

### Q6 - Le champ `peremption` du contexte est-il exigible sans outil pour l'exploiter ?

`RES-002` le rend obligatoire, au motif qu'un contexte périmé se lit comme vrai. Mais personne ne relira les dates de péremption à la main. Le champ a-t-il un sens avant que `clia` puisse signaler un contexte périmé ?

**Réponse.**

### Q7 - Faut-il trois types, ou moins ?

La question de fond. Un seul type, portant à la fois la situation, le but et les constats, serait plus économique et moins juste. Trois types sont plus justes et coûtent trois fois plus. Y a-t-il une raison de conception, et non de goût, qui impose trois ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1, Q2 et Q7. Les autres questions peuvent rester ouvertes sans empêcher l'usage des trois types.

L'effet est déclaré `conditionnel` : les trois définitions sont utilisables en l'état, et ce qui sera produit sur leur base est réputé provisoire jusqu'à résolution.

## Relations

- `objecte-a` [RES-002](../ressources/RES-002-contexte.md)
- `objecte-a` [RES-003](../ressources/RES-003-intention.md)
- `objecte-a` [RES-005](../ressources/RES-005-fait.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/candidats-ressources-fondamentales.md)
