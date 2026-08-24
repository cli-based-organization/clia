# Demande interprétée, tâche 32

Écrit le 2026-08-11 à 18:29, avant toute exploration. `MET-003` étape 1.

## Énoncé

Tâche 32, `[bogue]` : le statut n'est pas très utile.

> USE : un utilisateur demande à voir la liste des instances d'une ressource.
>
> Comportement attendu : on affiche 1. alias, pour pouvoir s'y référer facilement ; 2. description, pour savoir de quoi cette ressource s'occupe ; 3. un état, pour savoir ce qu'il reste à faire.
>
> Situation actuelle : tout est en draft.
>
> Conséquence : on ne connaît pas l'état de la ressource, ni l'état du système par rapport à cette ressource. Donc on ne sait pas ce qu'il faut faire sans ouvrir et inspecter tous les fichiers : cela n'est pas acceptable.
>
> TODO : ouvrir un bogue qui contient des pistes de solutions.
>
> TODO : ouvrir un ISU portant sur la révision du modèle de frontmatter.

## Deux livrables demandés

| Réf | Livrable | Ce qu'il porte |
|---|---|---|
| L1 | Un bogue, avec des pistes de solutions | Le statut affiché qui n'apprend rien |
| L2 | Un `ISU` | La révision du modèle de frontmatter |

## Un type qui n'existe pas

« Ouvrir un **bogue** » suppose un type que le dépôt n'a pas.

| Ce qui existe | Ce qui n'existe pas |
|---|---|
| `ISU`, issue, pour une problématique à résoudre | Un type `BOG` |
| `REG-002`, registre de bogues, **prévu** par `PLN-005` chantier D | Le registre lui-même |

**Lecture retenue.** Le bogue est une `ISU`, dont `RES-031` porte une rubrique « Pistes » qui correspond exactement à « des pistes de solutions ».

L'humain distingue les deux livrables ; ils seront deux issues distinctes. La question de savoir si un bogue mérite un type propre est signalée.

## Ce que je pressens du défaut, à vérifier

Le champ `status` de `commun.cue` vaut `draft`, `stable` ou `deprecated`. C'est un état de **maturité du document**.

Ce que la demande réclame est un état qui dise **ce qu'il reste à faire**, donc un état de **travail**.

Plusieurs types portent déjà un champ d'état propre : `etat` pour l'objection et l'issue, `statut-plan` pour le plan, `effet` pour la décision, `statut` pour la définition de type.

**Hypothèse à vérifier :** le dépôt porte deux familles de champs d'état, l'une universelle et inutile, l'autre propre au type et utile, et `clia res ls` affiche la première.

## Ce que je vérifierai

Combien d'instances portent `status: draft`, et combien de types portent un champ d'état propre non affiché.

## Ce que je ne ferai pas

**Corriger.** La demande dit « ouvrir un bogue qui contient des pistes de solutions ». Les pistes sont le livrable, non le correctif.

Si un correctif s'avère immédiatement implémentable, il sera signalé comme tel sans être appliqué.
