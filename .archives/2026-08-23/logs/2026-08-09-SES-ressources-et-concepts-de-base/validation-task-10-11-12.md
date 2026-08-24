# Démarche de validation, tâches 10, 11 et 12

## Validation de la tâche 12, par exécution

1. Relevé de l'étendue du défaut avant correction, sur les sept verbes et les deux drapeaux.
2. Vérification après correction que les neuf verbes répondent par leur usage propre.
3. Vérification du code de retour : une demande d'aide retourne 0, jamais 2.
4. Vérification que l'aide d'un verbe est propre à ce verbe et non l'aide générale.
5. Vérification que l'aide est reconnue avant la validation des arguments.
6. Vingt-quatre assertions de non-régression ajoutées à la suite de tests.
7. Suite complète relancée : 91 assertions.

## Validation du principe

8. `PDC-001` porte une rubrique « Comment le vérifier » avec trois contrôles, dont deux automatisés et un déclaré manuel et en échec.
9. Les quatre interdits qu'il énonce portent chacun le signe qui permet de les constater, conformément à `RES-012`.

## Validation de schéma

10. Les cinq livrables documentaires validés contre le schéma CUE de leur type : ADR, décision, objection, méthodologie, principe de conception.
11. Régénération des schémas après chaque modification de définition, pour vérifier l'idempotence de la dérivation.
12. Vérification que `clia res ls` n'affiche plus aucun type sans définition.

## Validation de forme

13. Contrôles V4, V5 et V8 de `skl-001-ressource` sur les cinq livrables documentaires.
14. Contrôle des liens relatifs, y compris les renvois vers les objections nouvellement créées.

## Validation de cohérence de la tâche 10

15. Chaque décision de `ADR-006` porte son motif et, pour celles qui sont révisables, ses conséquences.
16. Application du test de D4 à l'état actuel du dépôt, et consignation de son résultat, y compris défavorable.
17. Vérification que la contradiction entre `ADR-006` D2 et `ADR-001` D2 est déclarée et portée par une objection, non masquée.

## Validation de cohérence de la tâche 11

18. Chaque critique formulée par l'humain est reprise dans `MET-001` avec une mesure, non avec une reformulation.
19. Le tableau de résultat attendu compare le seuil à ce que `FND-002` a atteint, ligne par ligne.
20. Les modes d'échec observés dans ce dépôt sont distingués de ceux qui sont seulement possibles.
