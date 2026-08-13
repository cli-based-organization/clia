---
type: objection
id: NON-003
title: "Frontière entre Contexte, Intention et Faits"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: informatif
etat: repondue
porte-sur: [RES-002, RES-003, RES-005]
---

# NON-003 - Frontière entre Contexte, Intention et Faits

> Les trois types sont définis pour la première fois dans ce jet, sans aucune instance dans le corpus pour les éprouver. Leurs frontières sont proposées par raisonnement, pas par expérience, et elles se recoupent en plusieurs points.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.
- 2026-08-10 : **les sept questions répondues par l'humain**. La réponse Q3 déborde la question posée et renverse le rôle de l'ADR.
- 2026-08-11 : traitement des réponses, tâche 22. Instruites par `ADR-017`, huit décisions. Le fait se distingue du contexte par le régime de véracité, l'affect entre dans le contexte, `INTENTION.md` devient un lien symbolique, et l'ADR devient une justification dérivée de `DCN` et de `FRG`. L'état passe à `repondue`, l'effet à `informatif`. Ce que les réponses laissent ouvert est porté par `NON-026`.

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

INTENTION.md est une INT-<XYZ>. Il serait logique que ce soit INT-001, mais ce n'est pas une obligation contrainte. Par défaut à l'initialisation de clia dans un projet, créer INT-001 et faire de INTENTION.md un symlink de INT-001

### Q2 - Où va l'état émotionnel de l'humain, que `CLAUDE.md` demande de prendre en compte ?

`RES-002` propose qu'il ne soit pas une ressource, au motif qu'une ressource est versionnée, partageable et opposable, et que l'affect n'a aucune de ces trois propriétés. La demande de `CLAUDE.md` deviendrait alors une qualité d'attention de l'agent en conversation, sans objet produit. Cette lecture est-elle acceptée, ou l'humain veut-il que cela laisse une trace ?

**Réponse.**

déduire de session.md et mettre explicitement dans CTX ou dans les rubriques CONTEXTE d'une ressource

### Q3 - L'historique des intentions abandonnées relève-t-il du contexte, de l'intention, ou d'un type de décision qui manque ?

Le corpus n'a tracé aucune de ses quatre ruptures de cap. `RES-003` propose qu'une révision majeure de l'intention ultime exige une trace écrite sous forme d'ADR. Mais un ADR décide d'une architecture, il ne décide pas d'un cap. Faut-il un type distinct pour la décision de direction ?

**Réponse.**

Il faut clarifier quelque chose avant de continuer: les décisions relèvent de DCN et non pas de ADR. L'ADR est une justification raisonnée générée à partir d'un ou plusieurs DCN et un ou plusieurs FRG. Nous expliquerons cela avec plus de détail, mais c'est vers ce résultat vers lequel le système clia converge.

Donc, c'est effectivement une bonne idée et une bonne pratique de justifier un changement d'intention ultime par un DCN et un FRG. Mais en pratique c'est lourd... et ça me parait difficile à faire adopter comme pratique.


### Q4 - Faut-il un type Acteur distinct, ou les acteurs sont-ils une rubrique du contexte ?

`RES-002` en fait une rubrique. `resource-types.yaml` en faisait un type, avec des champs propres (`categorie` valant primaire, secondaire ou partie prenante ; `portee` valant méthode ou domaine) et une relation `utilise` vers les cas d'usage. Le corpus n'a aucune instance des deux modélisations.

**Réponse.**

Ne pas faire ça pour l'instant. Nous y reviendrons plus tard.

### Q5 - Un contexte peut-il énoncer des mesures sans les consigner comme faits ?

`ANL-001` est une analyse qui énonce des dizaines de mesures sans produire aucun recueil `FCT`. Si c'est admissible, la frontière entre contexte, analyse et faits est de commodité et non de nature. Si ce n'est pas admissible, une bonne part du travail existant est non conforme.

**Réponse.**

oui. Un FCT est un fait dont le niveau de véracité a été établi/éprouvé par un processus rigoureux et normé. Ce qui est dans CTX ou toute rubrique CONTEXTE peut être affimé par un agent humain ou IA sans autre vérification. Le degré de fiabilité est à prendre comme tel également. 

### Q6 - Le champ `peremption` du contexte est-il exigible sans outil pour l'exploiter ?

`RES-002` le rend obligatoire, au motif qu'un contexte périmé se lit comme vrai. Mais personne ne relira les dates de péremption à la main. Le champ a-t-il un sens avant que `clia` puisse signaler un contexte périmé ?

**Réponse.**

permettre à titre indicatif. Mais ne pas rendre obligatoire.

### Q7 - Faut-il trois types, ou moins ?

La question de fond. Un seul type, portant à la fois la situation, le but et les constats, serait plus économique et moins juste. Trois types sont plus justes et coûtent trois fois plus. Y a-t-il une raison de conception, et non de goût, qui impose trois ?

**Réponse.**

Oui. C'est un choix de conception. Ils sont là au besoin. Mais rien n'oblige l'humain à les utiliser (sauf INT-001)

## Ce qui lèverait cette objection

**Levée le 2026-08-11.** Les sept questions portent une réponse de l'humain, instruite par `ADR-017`.

Cinq questions sont tranchées, une est reportée, Q4 sur le type Acteur, et une déborde son cadre : la réponse Q3 ne dit pas quel type manque pour une décision de cap, elle redéfinit le rôle de l'ADR.

L'effet passe de `conditionnel` à `informatif`. Ce que les réponses laissent ouvert, dont le sort des seize ADR écrits comme des actes de décision, est porté par `NON-026`.

## Relations

- `objecte-a` [RES-002](../ressources/RES-002-contexte.md)
- `objecte-a` [RES-003](../ressources/RES-003-intention.md)
- `objecte-a` [RES-005](../ressources/RES-005-fait.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/candidats-ressources-fondamentales.md)
- `reference` [NON-026](NON-026-consequences-de-l-adr-derive.md)
