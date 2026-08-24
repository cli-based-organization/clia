# Démarche de validation, tâche 11 de SES-002

`MET-003` étape 4. Écrite avant l'exécution des contrôles.

1. **Le blocage est réel, non supposé** : `DCN-016` porte bien `effet: suspendue`, et `ISU-009`, le point d'arrêt du chantier B, est bien `ouverte`.

2. **Les deux chantiers déclarés satisfaits le sont** : `clia res check` signale des champs constants (G), et `clia res ls objection` affiche plus d'une valeur (F).

3. **`PLN-007` n'est pas passé à `execute`.**

4. **La correction fonctionne sur le cas réel** : `PLN-007` est rangé à défricher, avec `DCN-016` nommé.

5. **La correction ne sur-déclenche pas** : aucun autre plan du dépôt ne change de catégorie.

6. **Une décision en vigueur ne bloque rien** : le cas symétrique est éprouvé par le banc de tests.

7. **La suite de tests passe**, et compte les assertions ajoutées.

8. **`BUG-004` est conforme à son schéma**, et ses liens relatifs pointent vers des fichiers existants.

9. **`BUG-004` se distingue de `BUG-002`** : la comparaison des causes est explicite dans le document.

10. **Le dépôt ne régresse pas** : le nombre d'instances non conformes n'augmente pas du fait de cette tâche.

11. **Le journal suit `MET-003`** : `demande` avant exploration, `analyse` avant le premier livrable, horodatages croissants.

12. **La tâche ne se déclare pas réussie.** Le journal de fait nomme l'échec d'exécution en premier, avant ce qui a été livré.
