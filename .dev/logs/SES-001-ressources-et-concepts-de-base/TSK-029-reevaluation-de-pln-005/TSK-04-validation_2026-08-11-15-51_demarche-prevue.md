# Démarche de validation, tâche 29

Écrite avant l'exécution des contrôles. `MET-003` étape 4.

## Validation de la procédure

1. Chaque livrable de `PLN-005` porte un verdict, et le verdict cite le contrôle de `PDC-003` qui échoue.
2. Chaque thématique nomme un manque, non un livrable bloqué.
3. Chaque livrable en échec est rattaché à une thématique et une seule.
4. Le nombre d'issues égale le nombre de thématiques.
5. Chaque `ISU` a exactement une `NON`.

## Validation des relations croisées

6. Chaque `ISU` déclare `objecte-a` vers sa `NON`.
7. Chaque `NON` déclare `repond-a` vers son `ISU`.
8. Chaque `ISU` référence `PLN-005` et les ressources impactées.
9. `PLN-005` référence les cinq issues.

## Validation de forme

10. Validation de schéma des cinq `ISU`, des cinq `NON` et de `MET-004`.
11. Vérification que les `ISU` suivent les sept sections de `RES-031`.
12. Vérification que les `NON` suivent les six sections de `RES-004`.
13. Vérification des liens relatifs.
14. Contrôle `V10` sur les documents modifiés.

## Validation de l'implémentation

15. Vérification que `skl-001` porte les règles A7 et A8, et que la numérotation ne collisionne pas.
16. Vérification que `RES-007` ne porte plus le seuil à trois conditions.
17. Vérification que `RES-001` porte la distinction des deux catégories.
18. Vérification qu'aucun livrable à préalable ouvert n'a été implémenté.
19. Validation de schéma du dépôt entier.
20. Suite de tests complète.

## Validation de portée

21. Vérification que `PLN-005` n'est pas réécrit : le type est `travail`, son statut évolue.
22. Vérification que `DCN-014`, créée par l'humain, n'est ni modifiée ni renseignée.

## Validation d'auto-application

23. Vérification que le journal suit `MET-003` : répertoire propre, horodatages distincts et croissants.
