# Démarche de validation, tâche 28

Écrite avant l'exécution des contrôles. `MET-003` étape 4.

## Validation du type

1. Validation de schéma de `RES-035` et de `REG-001`.
2. `cue vet` sur `registre.cue` et `registre.input.cue`.
3. Vérification que `RES-035` suit le gabarit `skl-001` B3, sans rubrique méta.
4. Vérification que le type est reconnu par `clia res ls`.
5. Vérification que `REG-001` porte la rubrique obligatoire « Ce que le registre ne contient pas ».

## Validation des commandes

6. `clia reg ls` affiche le registre, son mode de tenue et son nombre d'items.
7. `clia reg ls REG-001` affiche les treize items avec leurs quatre colonnes.
8. Vérification que le séparateur du tableau n'est pas pris pour un item.
9. `clia reg show` affiche l'item puis la ressource désignée.
10. Le registre se résout par son alias et par son numéro seul.
11. Le numéro d'item se résout avec et sans zéros de tête.
12. Les quatre cas d'erreur retournent le bon code : registre inconnu, item inconnu, argument manquant, verbe inconnu.
13. Chaque verbe répond à `--help`.

## Validation du bogue corrigé

14. Vérification qu'un type `point-fixe` reçoit un numéro de séquence et non une date.
15. Vérification qu'aucun nommage daté ne subsiste dans le répertoire produit.
16. Vérification que le test qui codifiait l'ancien comportement porte le motif de son changement.

## Validation d'ensemble

17. Suite de tests complète.
18. Validation de schéma du dépôt entier.
19. Vérification des liens relatifs des documents produits.

## Validation d'auto-application

20. Vérification que le journal de cette tâche suit `MET-003` : répertoire propre, nommage, horodatages distincts et croissants.

## Validation de portée

21. Vérification qu'aucun des trois autres registres n'est créé.
22. Vérification que `FRG-2026-08-11`, fichier de l'humain, n'est ni renommé ni modifié.
