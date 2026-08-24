# Démarche de validation, tâche 14 de SES-002

`MET-003` étape 4. Écrite avant les contrôles de clôture.

**Réserve** : les trois critères des chantiers ont été exécutés **pendant** l'implémentation, chacun avant de passer au suivant. Les contrôles 2 à 4 les rejouent ; leur résultat n'est pas une découverte.

1. **Les trois livrables demandés existent** : un `ADR`, un `PLN`, la commande.
2. **Chantier A** : pour `decision`, la lecture retourne les cinq valeurs de `effet`, et aucune de `attestation` ni `diffusion`.
3. **Chantier B** : `explain DCN-016` et `explain RES-009` produisent la même sortie, portant les huit rubriques, et sortent en 0.
4. **Chantier C** : `explain --help` n'exige pas d'argument, et `clia res --help` liste le verbe.
5. **Le plan était SMART avant l'implémentation**, et la vérification précède le code.
6. **La commande répond au constat de départ** : la sortie porte les champs d'une `DCN`, leurs valeurs admises et son cycle de vie.
7. **`ADR-018` et `PLN-016` sont conformes à leur schéma**, liens compris.
8. **`PLN-016` est passé à `execute`** et déclare la tâche qui l'a exécuté.
9. **La suite de tests passe**, avec les assertions ajoutées.
10. **Le dépôt ne régresse pas** du fait de cette tâche.
11. **`clia res explain` fonctionne sur un type mal rempli** : il affiche `À RENSEIGNER` plutôt que de masquer.
12. **Le journal suit `MET-003`.**
