# Résultat de la validation, tâche 32

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma des trois documents créés | **conformes** |
| Liens relatifs | **0 cassé** |
| Schéma, dépôt entier | **150 conformes, 7 non conformes** |
| Tests du CLI | **144 réussis, 0 échoué** |
| Code et modèle modifiés | **aucun** |

Les sept non-conformités sont les gabarits en attente de l'humain, inchangées.

## La mesure, recalculée

| Mesure | À l'analyse | Après production |
|---|---|---|
| Instances | 154 | **157** |
| Portant `status: draft` | 154 | **157** |
| Portant une autre valeur | 0 | **0** |
| Avec champ d'état propre | 116 | 119 |
| Sans aucun champ d'état | 38 | 38 |

L'écart de trois est exactement ce que la tâche a produit : `ISU-008`, `ISU-009` et `NON-035`.

**Les trois nouvelles instances portent `status: draft` comme les autres**, et deux d'entre elles portent un champ `etat` utile que le CLI n'affichera pas. Le défaut se reproduit dans le document qui le signale.

## Ce que le recalcul confirme

Le champ `status` n'a toujours qu'une seule valeur, sur cent cinquante-sept instances désormais.

**Le taux est inchangé.** Trois quarts des instances portent un état utile et invisible ; un quart n'en a aucun.

## Les livrables

| Réf | Livrable | Pistes |
|---|---|---|
| L1 | `ISU-008`, le bogue | **6** |
| L2 | `ISU-009`, la révision du frontmatter | **6** |
| — | `NON-035`, quatre questions, effet **bloquant** | — |

Les douze pistes sont présentées comme telles : `RES-031` pose qu'une piste n'est pas une décision, et aucune n'est marquée retenue.

`NON-035` est croisée avec les deux issues dans les deux sens.

## Portée respectée

Contrôle 12. `lib/` et `.dev/schemas/commun.cue` sont inchangés. Aucune instance n'a été modifiée.

Le correctif de D1 est décrit comme piste P1 de `ISU-008` et déclaré immédiatement implémentable, sans être appliqué : la demande dit « ouvrir un bogue qui contient des pistes de solutions ».

## Ce que la validation n'établit pas

**Que P1 soit la bonne piste.** Elle corrige 119 instances sur 157 et laisse les 38 autres afficher `draft`. Les cinq autres pistes ne sont pas comparées entre elles.

**Que l'effet bloquant de `NON-035` soit justifié.** Il repose sur `RES-012`, qui pose que le non-respect d'un principe de conception est un bogue. `PDC-001` est violé, et `PDC-003` n'est pas actif : le raisonnement s'appuie sur un principe dont le régime est lui-même contesté par `NON-027` Q1.

**Que le défaut soit borné à `status`.** `ISU-009` relève huit champs d'état concurrents dont deux portent le même nom pour des choses différentes. Le modèle n'a pas été audité au-delà de ce que la tâche demandait.
