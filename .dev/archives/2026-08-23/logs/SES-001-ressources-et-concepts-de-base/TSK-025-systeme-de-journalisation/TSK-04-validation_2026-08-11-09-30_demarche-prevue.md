# Démarche de validation, tâche 25

Écrite **avant** l'exécution des contrôles, conformément à `MET-003` étape 4. Aucun résultat n'y figure : une démarche dont chaque étape porte son issue est une justification.

## Validation des trois définitions

1. Validation de schéma de `RES-032`, `RES-033`, `RES-034`.
2. Vérification que les trois suivent le gabarit `skl-001` B3, sans rubrique méta.
3. Vérification que `LOG` est `point-fixe` et ne porte pas de champ `version`.
4. Vérification que `TSK` et `SES` sont déclarés comme répertoires dans leur champ `emplacement`.
5. Vérification que les frontières entre les trois types sont écrites et ne se recoupent pas.

## Validation des artefacts

6. `cue vet` sur les trois schémas et les trois schémas d'entrée.
7. Vérification que `clia res ls` reconnaît les trois types et affiche leurs propriétés.
8. Vérification que le schéma de `LOG` contraint l'horodatage et la référence de tâche.

## Validation de MET-003

9. Vérification que les sept étapes portent chacune leur moment d'écriture.
10. Vérification que la méthodologie est déclarée comme ressource source dans `RES-032`.
11. Vérification que les modes d'échec citent des cas mesurés du journal existant, et non des cas imaginés.

## Validation du correctif C8

12. Vérification que les sept skills portent une rubrique de journalisation renvoyant à `MET-003`.

## Validation par auto-application

C'est le contrôle le plus important : la tâche 25 prescrit un format, et son propre journal doit le respecter.

13. Vérification que le journal de cette tâche est dans un répertoire propre, ne contenant que ses logs.
14. Vérification que les noms de fichiers suivent `TSK-<SEQ>-<TYPE>_<horodatage>_<slug>.md`.
15. **Vérification que les horodatages sont distincts et croissants**, ce qui est la trace d'une écriture au fil de l'eau.
16. Vérification qu'aucun log de cette tâche ne rapporte une autre tâche.

## Validation de portée

17. Vérification qu'aucun log de l'ancien format n'a été migré, renommé ou supprimé.
18. Vérification que la suite de tests reste verte, aucun code n'ayant été touché.
19. Validation de schéma du dépôt entier.
