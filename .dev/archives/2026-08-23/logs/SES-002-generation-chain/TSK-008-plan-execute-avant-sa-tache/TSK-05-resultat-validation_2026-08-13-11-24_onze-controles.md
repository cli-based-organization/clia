# Résultat de la validation, tâche 8 de SES-002

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les trois choses demandées sont livrées | **Réussi** |
| 2 | Diagnostic fondé sur des mesures | **Réussi**, 3 plans, 8 tâches, décompte des livrables |
| 3 | Les trois champs propres renseignés | **Réussi** |
| 4 | Les sept rubriques de `RES-036` | **Réussi**, 7 sur 7 |
| 5 | La règle enfreinte est nommée et son origine dite | **Réussi**, non écrite avant la tâche 8, dérivée de `PDC-003` |
| 6 | La cause diffère du symptôme | **Réussi** |
| 7 | La correction dit ce qu'elle ne règle pas | **Réussi** |
| 8 | `BUG-002` conforme, liens valides | **Réussi** |
| 9 | Aucun plan exécuté par cette tâche | **Réussi**, `.dev/plans/` intact |
| 10 | Schéma du dépôt entier | **171 conformes, 10 non conformes** |
| 11 | Journal `MET-003` | **Réussi** |

## Le contrôle 9, et pourquoi il figure ici

**C'est le contrôle qui vérifie que je ne refais pas l'erreur en la
documentant.** La tentation était réelle : la tâche 7 n'ayant rien produit,
exécuter `PLN-011` ou `PLN-012` aurait « rattrapé ». Ce serait exactement le
comportement que `BUG-002` décrit.

`.dev/plans/` est inchangé.

## Le contrôle 5, et ce qu'il révèle

**La règle enfreinte n'était écrite nulle part** avant que l'humain l'énonce
dans la tâche 8. Elle découle de `PDC-003`, sans y figurer.

C'est une circonstance, pas une excuse : `RES-036` pose qu'un bogue est un
écart à une règle **écrite**, et celle-ci ne l'était pas. Le bogue est ouvert
quand même, parce que la règle est déductible du principe et que l'humain
l'a formulée.

## Ce que la validation ne couvre pas

**Rien ne garantit que les trois règles seront tenues.** Elles sont de
conduite, sans mécanisme. `BUG-002` porte `etat: ouvert` pour cette raison :
il ne se referme pas parce qu'on a écrit la correction, mais quand elle
tiendra.

**Le contrôle qui les rendrait mécaniques n'existe pas.** Il faudrait qu'un
plan déclare la tâche qui l'a exécuté, et qu'une tâche déclare ses livrables
attendus. Aucun des deux champs n'existe.
