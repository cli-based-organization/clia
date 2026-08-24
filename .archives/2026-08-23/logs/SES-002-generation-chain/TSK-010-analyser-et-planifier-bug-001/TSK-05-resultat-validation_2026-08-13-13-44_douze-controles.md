# Résultat de la validation, tâche 10 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les trois livrables demandés existent | **Réussi** : `ANL-012`, `PLN-015`, `NON-040` |
| 2 | Le diagnostic se recompte sur `BUG-001` | **Réussi après une erreur de mesure** — voir plus bas |
| 3 | `PLN-015` satisfait `PDC-003` | **Réussi** : 3 livrables, 3 critères, 3 limites, 3 dépendances, pour 3 chantiers |
| 4 | Les critères sont exécutables | **Réussi** : chacun nomme une commande à lancer et une sortie à constater |
| 5 | `NON-040` est justifiée par le filtre, et seule | **Réussi**, avec une réserve — voir plus bas |
| 6 | Les quatre documents conformes à leur schéma | **Réussi**, 4 sur 4 |
| 7 | Les liens relatifs pointent vers des fichiers existants | **Réussi**, aucun lien cassé |
| 8 | Le dépôt ne régresse pas | **Réussi** : 163 conformes, 17 non conformes — voir plus bas |
| 9 | La suite de tests | **Réussi, 275 assertions**, aucun code touché |
| 10 | `clia focus` prend en compte les documents neufs | **Réussi** : `BUG-001` passe à `A CORRIGER`, `NON-040` à `A DECIDER`, `PLN-015` à `A EXECUTER` |
| 11 | La tâche n'a exécuté aucun plan | **Réussi** : `PLN-015` reste `propose` |
| 12 | Le journal suit `MET-003` | **Réussi sauf un point** — voir plus bas |

## Le contrôle 2, et l'erreur de mesure qu'il a produite

Le premier décompte a donné **4 occurrences** du motif `shell syntax` là où `ANL-012` en annonce 8. J'ai failli corriger l'analyse.

**C'est le décompte qui était faux.** Trois captures d'écran de `BUG-001` portent le motif tronqué — `Contains shell syntax (strinanalyzed` — parce qu'elles ont été copiées depuis un terminal qui repliait les lignes. Le relevé exhaustif des quinze lignes de motif confirme la répartition annoncée :

```
shell syntax (dont 3 tronquées) :  8
simple_expansion                :  4
expansion                       :  2
règle du dépôt                  :  1
                                  --
                                   15
```

**Ce que l'incident enseigne** : un contrôle par recherche de motif sur un document collé depuis un terminal mesure la mise en forme autant que le fond. Même défaut que le critère de `PLN-013` éprouvé par `grep` à la tâche 9.

## Le contrôle 5, et sa réserve

`NON-040` est la seule objection de la tâche, et ses cinq questions tombent bien du côté « s'arrêter ».

**Ce que le contrôle ne peut pas établir** : qu'aucune incertitude n'y a été versée par facilité. C'est moi qui ai à la fois écrit l'objection et jugé qu'elle était justifiée. Le conflit est le même que celui relevé dans `PLN-013`, et il ne se lève pas par un contrôle de plus.

**Ce qui plaide en sens inverse** : `ANL-012` a tranché seule le diagnostic, le classement des quinze interruptions, l'écart de trois pistes sur quatre et le choix de la dernière. Une seule objection pour une tâche entière d'analyse.

## Le contrôle 8, et deux fichiers qui ne sont pas de moi

```
avant la tâche :  159 conformes,  16 non conformes
après          :  163 conformes,  17 non conformes
```

**Les quatre conformes de plus sont les livrables de la tâche**, `BUG-001` compris, qui passe de non conforme à conforme puisque ses trois champs sont renseignés.

**Le non conforme de plus n'est pas de moi.** `PDC-006` et `PDC-007` ont été créés à 13:36 et 13:40, pendant la tâche, par l'humain — ce que `CONSTITUTION.md` C1 prescrit. `PDC-006` porte un champ `portee: À RENSEIGNER`, `PDC-007` est un squelette. Ils sont hors du périmètre de cette validation ; ils sont signalés parce qu'ils déplacent le chiffre.

Solde propre à la tâche : **+4 conformes, −1 non conforme**.

## Le contrôle 12, et l'écart déclaré

`demande` à 13:29 avant toute exploration, `analyse` à 13:31 avant le premier livrable, horodatages distincts et croissants.

**Un écart** : le versement de `fait` est daté 13:42, après la démarche de validation de 13:40, alors que les livrables étaient sortis avant. `MET-003` veut le fait versé à mesure. Le log le déclare lui-même plutôt que de se dater à rebours.

## Ce que la validation ne couvre pas

**Aucune interruption n'a été rejouée.** Le classement des quinze par remède repose sur la lecture des lignes de commande, pas sur une reproduction. C'est la limite que `ANL-012` déclare, et que le chantier A du plan lève.

**Le mécanisme d'autorisation par hook n'est pas vérifié.** C'est délibéré : il fait l'objet du premier chantier, avec son critère. Si la mesure échoue, `PLN-015` tombe et la piste B redevient la seule.

**`PLN-015` n'atteint pas `DCN-017`.** Sa cible est une réduction mesurable des interruptions, pas leur disparition. Le bogue restera ouvert à la fin de son exécution, et le plan le déclare.
