# Résultat de la validation, tâche 13 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les trois livrables demandés existent | **Réussi** : `BUG-005`, `ANL-013`, `MET-005` et `skl-006` réécrits |
| 2 | Les chiffres de l'analyse se recomptent | **Réussi** : 51 suites, dont 26 pour l'humain |
| 3 | `clia focus` désigne le geste de l'humain | **Réussi** : `A APPROUVER`, `DCN-016`, `qui: humain` |
| 4 | La commande affichée est copiable telle quelle | **Réussi** : `clia res edit DCN-016` |
| 5 | `--humain` réduit la file | **Réussi** : 63 au total, **22 pour l'humain**, 59 pour l'agent |
| 6 | Le défrichage reste dans les deux filtres | **Réussi**, présent des deux côtés |
| 7 | Chaque filtre masque l'autre | **Réussi**, éprouvé par le banc |
| 8 | La suite de tests | **Réussi, 289 assertions**, 279 → 289 |
| 9 | `MET-005` porte le format et la règle de cohérence | **Réussi**, étape 6 |
| 10 | `skl-006` porte le contrôle exécutable | **Réussi** |
| 11 | Le contrôle de `skl-006` fonctionne sur le cas réel | **Réussi** : `DCN-016` apparaît dans `clia focus --tout --humain` |
| 12 | `BUG-005` et `ANL-013` conformes | **Réussi**, 2 sur 2 |
| 13 | Le dépôt ne régresse pas | **Réussi** : 166 conformes, **17 non conformes, inchangé** |
| 14 | La tâche s'applique l'étape 6 à elle-même | **Réussi** : voir ce qui est rendu |
| 15 | Le journal suit `MET-003` | **Réussi** : 15:43, 15:48, 16:08, 16:10, croissants |

## Ce qui a changé pour l'humain, en un chiffre

```
avant :  3 items pour l'humain visibles,  0 decision suspendue
apres : 22 items pour l'humain,           1 decision suspendue, en tete
```

**Le geste qui débloque `PLN-007` est passé d'invisible à premier.**

## Les deux filtres ne s'additionnent pas, et c'est voulu

22 pour l'humain, 59 pour l'agent, 63 au total. **Les 18 items à défricher sont dans les deux** : ils s'adressent aux deux, et les masquer d'un côté ferait disparaître du travail réel.

## Ce que la correction ne fait pas

**Le compteur ne descend pas — il monte de deux.** `A APPROUVER` ajoute un item, `BUG-005` en ajoute un autre. **C'est le troisième constat de ce genre en cinq tâches**, et il est le même à chaque fois : rendre visible ce qui était caché fait monter le nombre. Ce que la tâche améliore est la capacité à choisir, pas la quantité.

**Le décompte « bloque 1 plan(s) » sous-estime.** `DCN-016` bloque cinq chantiers, répartis dans un seul plan. Compter les chantiers demanderait de les lire ; compter les plans est ce que le code sait faire aujourd'hui.

**Un blocage écrit en prose reste invisible.** `skl-006` l'interdit désormais pour les plans neufs ; les plans existants n'ont pas été repris.

## Ce que la validation ne peut pas établir

**Que la directive soit la bonne.** Les contrôles établissent qu'il y en a une, qu'elle est unique, exécutable, et cohérente avec `clia focus`. Ils n'établissent pas que `DCN-016` soit le meilleur geste — c'est un jugement du code, et l'usage le dira.

**Que le bogue soit corrigé.** `BUG-005` reste `ouvert`. Sa mesure est simple et appartient à l'humain : **la prochaine tâche se termine-t-elle sur un geste qu'il exécute sans demander de précision ?**
