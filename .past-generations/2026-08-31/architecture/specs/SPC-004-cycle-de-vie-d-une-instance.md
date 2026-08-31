# SPC-004 — Le cycle de vie d'une instance

**Répond à** `RQF-003`.
**Contrainte par** `RQN-001`, `RQN-002`, `RQN-004`.

## Objet

Fixer comment une instance naît, est vérifiée, change d'état et meurt.

C'est la capacité qui manque entièrement aujourd'hui, et dont l'absence explique
que six types sur dix ne portent aucune instance.

## S1 — Naissance

Une instance est créée à partir de la déclaration de son type. **Tout ce qui est
dérivable est dérivé, et rien de dérivable n'est saisi.**

| Élément | D'où il vient |
|---|---|
| L'emplacement | le motif déclaré par le type |
| Le numéro de séquence | le plus grand existant, plus un |
| Le nom lisible | le sujet fourni par le demandeur |
| La structure | le gabarit déclaré par le type |
| La version portée | la version courante de la définition |
| L'état initial | le premier état du cycle déclaré par le type |

Le demandeur fournit **le type et le sujet**. Rien d'autre.

**La création refuse** si l'emplacement est occupé, si le type n'est pas activé
dans ce dépôt, ou si le type promet ce qu'il ne tient pas — S5.

## S2 — Les états, et ce qui les fait changer

Un type déclare le cycle que portent ses instances. Trois cycles suffisent aux
besoins observés ; un type en déclare un.

| Cycle | États | Pour quoi |
|---|---|---|
| **point fixe** | `actif` → `périmé` | ce qui vaut à une date : une analyse, une fondation |
| **vivant** | `actif` → `remplacé` | ce qui est révisé et versionné : une définition, une spécification |
| **travail** | `ouvert` → `clos` \| `abandonné` | ce qui appelle une suite : une objection, un plan, une session |

**Un état ne change que parce qu'un verbe l'a changé.** Ni la lecture d'un
document, ni l'écriture d'une réponse à l'intérieur, ni le passage du temps ne
font changer un état.

C'est la règle centrale de cette spécification. Son absence a produit, en G2,
trente-et-un documents entièrement traités et toujours comptés comme ouverts.

**Le cycle « travail » distingue `clos` et `abandonné`**, et cette distinction
est exigée : une session aboutie et une session laissée en plan qui ne se
distinguent pas rendent tout décompte faux.

## S3 — Validation

Une instance est vérifiée **contre la déclaration de son type**, et sur ce que
cette déclaration dit seulement.

| Contrôle | Ce qu'il vérifie |
|---|---|
| Emplacement | l'instance est là où le type dit |
| Structure | les champs et les sections déclarés sont présents |
| État | la valeur portée appartient au cycle déclaré |
| Version | la version portée est connue de la définition |
| Relations | chaque renvoi vise un type admissible, et une cible qui existe |

Un contrôle qui n'a pas de fondement dans la déclaration n'existe pas. Un champ
déclaré sans contrôle possible est retiré de la déclaration (`SPC-002` S2).

**La validation ne modifie rien.** C'est un constat, au sens de `SPC-003` S1.

## S4 — Migration

Quand la définition d'un type change de version, ses instances peuvent avoir à
changer de forme. Ce que le type dit du passage vit **avec le type**, et amène
**une** instance d'une version à la suivante.

| Cas | Comportement |
|---|---|
| Le passage n'a rien changé à la forme | le marqueur de version avance seul |
| Le passage a changé la forme | la transformation déclarée s'applique |
| Le passage est demandé vers l'arrière | **refus** : rien ne dit comment défaire, et l'inventer déciderait du format à la place de son auteur |

Un retour en arrière du type laisse donc les instances telles quelles, et le dit.

## S5 — Le régime d'édition engage

Une déclaration qui dit qui écrit engage l'outil à le faire tenir.

| Régime déclaré | Ce que l'outil doit garantir |
|---|---|
| **humain** | l'outil pose le fichier et sa structure, et n'écrit jamais dans le corps |
| **agent** | la primitive de génération **existe**, sinon la création est refusée |
| **co-édition** | les zones écrites par l'outil sont délimitées et préservées à la régénération |

**Le régime « agent » est celui qui a échoué jusqu'ici** : quatre types le
déclarent aujourd'hui et aucune primitive n'existe. La règle est donc formulée
comme un refus, et non comme une intention : *un type qui déclare une génération
sans primitive ne peut pas créer d'instance*, et l'outil nomme ce qui manque au
type plutôt que de poser un fichier vide.

## S6 — Ce que l'outil ne fait pas

L'outil pose le fichier, le nom, le numéro, la structure et l'état. **Il n'écrit
pas ce qu'il y a à dire.**

La frontière passe exactement là, et elle est plus haute que dans un outil
d'infrastructure : créer une ressource documentaire n'est pas une opération
mécanique, c'est un travail de rédaction.

## Origine

`NON-001` Q1, Q2, Q4, sans réponse depuis le 2026-08-25. `ANL-001` M1, M2, M5,
D1, D2, D3 ; principes P2 et P4. Le constat de G2 sur l'absence de verbe de
clôture (`ANL-011`) motive S2. S5 est le correctif de `ANL-001` C8.
