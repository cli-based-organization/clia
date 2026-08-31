# Démarche de validation, tâche 27

Écrite avant l'exécution des contrôles. `MET-003` étape 4.

## Validation de fidélité aux réponses

1. Chacun des neuf constats de `ANL-008` cite la réponse qui le fonde, dans le texte de l'humain.
2. Vérification qu'aucun bloc de réponse de `NON-004` n'est modifié : régime hybride, propriété par bloc.
3. Vérification que les trois reproches sont rapportés à ce qu'ils visent dans le texte de l'agent, et non paraphrasés.
4. Vérification que chaque demande de production est attribuée à sa réponse source.

## Validation du remplacement

5. Vérification que `ANL-007` n'est pas réécrite : le type `ANL` est `point-fixe`.
6. Vérification que `ANL-008` déclare `remplace` et `derive-de` vers `ANL-007`.
7. Vérification que `PLN-004` passe à `abandonne` sans que ses chantiers soient réécrits, et déclare `est-remplacee-par`.
8. Vérification que `PLN-005` déclare `remplace` vers `PLN-004`.

## Validation de l'état de l'objection

9. Vérification que les sept questions portent une réponse.
10. Vérification que `NON-004` passe à `repondue` et que son effet passe à `informatif`.
11. Vérification que la section « Ce qui lèverait cette objection » dit ce que Q2 et Q3 ont répondu.

## Validation de forme

12. Validation de schéma des deux documents produits et des deux modifiés.
13. Vérification des liens relatifs.
14. Contrôle `V10` : aucune rubrique méta.
15. Validation de schéma du dépôt entier.
16. Suite de tests complète.

## Validation d'auto-application

17. Vérification que le journal de cette tâche suit `MET-003` : répertoire propre, nommage, horodatages distincts et croissants.
18. Vérification qu'aucun log de cette tâche ne rapporte une autre tâche.

## Validation de portée

19. Vérification qu'aucun chantier de `PLN-005` n'est exécuté.
20. Vérification qu'aucune des six productions demandées n'est produite.
21. Vérification qu'aucun `PDC` n'est créé, `CONSTITUTION.md` C1 le réservant à l'humain.
