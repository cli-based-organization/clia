# Démarche de validation, tâche 13 de SES-002

`MET-003` étape 4. Écrite avant l'exécution des contrôles.

1. **Les trois livrables demandés existent** : un `BUG`, une `ANL`, et les méthodes réécrites.

2. **Les chiffres de l'analyse se recomptent** : 51 suites sur treize tâches, 26 pour l'humain, et le nombre d'items destinés à l'humain que la commande affichait avant correction.

3. **`clia focus` désigne le geste de l'humain** et non un travail d'agent.

4. **La commande affichée est copiable telle quelle** et porte sur la bonne ressource.

5. **`clia focus --humain` réduit réellement la file** : le nombre d'items doit être inférieur au total.

6. **Le défrichage reste dans les deux filtres**, puisqu'il vise les deux.

7. **`--agent` masque ce qui attend l'humain**, et réciproquement.

8. **La suite de tests passe**, et compte les assertions ajoutées.

9. **`MET-005` porte le format de la directive**, ses quatre éléments, et la règle de cohérence.

10. **`skl-006` porte le contrôle exécutable** : un blocage écrit selon la règle apparaît dans `clia focus --humain`.

11. **Le contrôle de `skl-006` fonctionne sur le cas réel** : `PLN-007` déclare un blocage, et son geste apparaît bien dans la file de l'humain.

12. **`BUG-005` et `ANL-013` sont conformes à leur schéma**, liens compris.

13. **Le dépôt ne régresse pas.**

14. **Cette tâche applique à elle-même l'étape 6 qu'elle vient d'écrire** : ce qui est rendu à l'humain commence par une directive unique, et elle est celle que `clia focus` désigne.

15. **Le journal suit `MET-003`.**
