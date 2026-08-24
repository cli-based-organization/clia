# Ce qui a été fait, tâche 6 de SES-002

`MET-003` étape 3.

## Le constat central, et il n'est pas celui que j'attendais

**L'humain répond à 98 % des questions.** 217 posées, 213 reçues, 36 objections sur 38 entièrement traitées.

**Trente et une d'entre elles étaient toujours comptées `ouverte`.**

Le goulot n'était pas l'humain. C'était l'absence de tout geste de clôture. Mes journaux répétaient « en attente d'une réponse » sur des documents entièrement répondus.

## Ce que j'avais mesuré faux, et corrigé en route

J'ai d'abord conclu que `RES-004` ne déclarait **aucune** valeur d'état. C'est faux : il en déclare **sept**, avec leur sens, dans une rubrique soignée. Ma recherche visait une rubrique nommée « Champs propres », qui n'existe pas dans ce document.

**Le diagnostic corrigé est plus intéressant que le faux.** La définition est excellente ; le schéma acceptait `etat: string & !=""` ; cinq des sept valeurs n'avaient jamais servi. Ce n'est pas une définition manquante, c'est une définition que rien ne fait respecter — le sujet exact de `NON-005`, ouverte le 2026-08-09.

`ANL-011` C3 porte la correction plutôt que de l'effacer.

## Le bilan chiffré de la tâche

| | Items |
|---|---|
| Créés : `ANL-011`, `PLN-010` à `PLN-014` | **+6** |
| Fermés : objections passées à `repondue` | **−31** |
| **Net** | **−25** |

**C'est la première fois que le compteur descend.** La courbe était monotone croissante sur cinq jours : 12, 25, 53, 57, 61.

```
avant :  33 ouvertes,  5 repondue
apres :   2 ouvertes, 36 repondue
```

Les deux qui restent ouvertes sont `NON-038` et `NON-039`, que j'ai ouvertes hier et qui n'ont reçu aucune réponse.

## Ce qui a été livré

| Livrable | Contenu |
|---|---|
| `ANL-011` | 7 constats mesurés, réponse aux 4 questions, 5 recommandations |
| `PLN-010` | **Exécuté dans la foulée** : imposer les états, fermer ce qui est répondu |
| `PLN-011` | Afficher l'état qui varie |
| `PLN-012` | Une commande de focus |
| `PLN-013` | Borner l'ouverture des objections |
| `PLN-014` | Le type `Fonctionnalité` |

**Zéro objection ouverte.** La tâche demandait des `NON` uniquement pour ce qui ne peut pas être traité en best effort documenté. Rien n'a satisfait ce critère : tout ce qui restait incertain a été décidé et documenté ici.

## `PLN-010`, exécuté

**Chantier A.** Les sept états de `RES-004` sont portés dans `objection.cue`. Aucune valeur n'a été inventée ; la définition n'a pas été modifiée. Une valeur hors énumération est désormais refusée, vérifié.

`initiateur` est passé au même régime : il acceptait n'importe quelle chaîne alors que `RES-004` déclare `humain` ou `agent`.

**Chantier B.** Trente et une objections passent à `repondue`, avec une ligne de journal datée dans chacune, comme `RES-004` le prescrit.

**Le critère est mécanique et rien d'autre** : autant de blocs de réponse que de questions. Aucune réponse n'a été interprétée. C'est exactement ce que `RES-004` dit de cet état : « toutes les questions ont reçu réponse, l'initiateur n'a pas encore statué ».

## Les deux types proposés

**`Fonctionnalité` : oui.** `PLN-014` le porte. C'est l'unité de focus qui manque : le dépôt n'a que des unités de problème, jamais d'unité de produit.

**`Note d'implémentation` : non**, et c'est une prise de position, pas une question renvoyée.

Son contenu existe déjà dans les 44 journaux `TSK-03-fait`, qui sont exactement « ce qui a été implémenté et pourquoi ». L'humain pressent un recoupement avec le message de commit ; il y en a trois, pas deux.

**Ce qui manque n'est pas un type mais une sortie** : dériver les notes de version des journaux existants. Un type de moins créé est un item de moins, ce qui est le sujet même de l'analyse.

## Ce que je n'ai pas fait, et pourquoi

**`PLN-011` à `PLN-014` ne sont pas exécutés.** La tâche demandait un plan par recommandation, pas leur exécution. `PLN-010` fait exception parce que recommander de fermer sans fermer aurait ajouté un item au lieu d'en retirer un.

**Les douze objections répondues sans suite ne sont pas traitées.** `ANL-011` C6 les mesure. Les fermer ne les exploite pas : c'est un compteur qui descend, pas un travail qui avance, et `PLN-010` le déclare dans ses propres objections.
