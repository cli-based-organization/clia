# Démarche de validation, tâche 10 de SES-002

`MET-003` étape 4. Écrite avant l'exécution des contrôles. Aucun résultat n'est connu.

**Réserve honnête** : la conformité au schéma des quatre documents a été vérifiée **en les produisant**, avant l'écriture de cette démarche. Elle est reprise ci-dessous en contrôle 6 et sera réexécutée, mais son résultat n'est pas une découverte.

## Les contrôles

1. **Les trois livrables demandés existent** : une `ANL` portant le diagnostic et les pistes, un `PLN` SMART, et les objections nécessaires.

2. **Le diagnostic est vérifiable, non affirmé.** Chaque chiffre de `ANL-012` C1 et C2 se recompte sur le corps de `BUG-001` : quinze interruptions, la répartition par motif, la répartition par remède.

3. **`PLN-015` satisfait `PDC-003`** : chaque chantier déclare un livrable, un critère de réussite exécutable, une limite de temps. Le total des durées est cohérent avec la somme déclarée.

4. **Les critères des trois chantiers sont réellement exécutables** : chacun se lit comme une commande à lancer et une sortie à constater, non comme un jugement à porter.

5. **`NON-040` est justifiée par le filtre**, et elle est seule. Vérifier que chaque question qu'elle porte tomberait bien du côté « s'arrêter » de `MET-005` étape 2, et qu'aucune autre incertitude de la tâche n'y a été versée par facilité.

6. **Les quatre documents sont conformes à leur schéma** : `ANL-012`, `NON-040`, `PLN-015`, et `BUG-001` dont trois champs ont été renseignés.

7. **Les liens relatifs pointent vers des fichiers qui existent**, dans les quatre documents.

8. **Le dépôt entier ne régresse pas** : le nombre d'instances non conformes ne dépasse pas les seize mesurées à la tâche 9.

9. **La suite de tests passe** : aucun code n'a été touché, elle doit rester à 275.

10. **`clia focus` prend en compte les trois documents neufs**, et `BUG-001` change de catégorie maintenant que son état est renseigné.

11. **La tâche n'a exécuté aucun plan.** `MET-005` étape 1 : une tâche de planification produit un plan et le laisse `propose`. C'est le premier cas d'application depuis que la règle est écrite, et `BUG-002` est né de sa transgression.

12. **Le journal suit `MET-003`** : `demande` avant toute exploration, `analyse` avant le premier livrable, horodatages distincts et croissants.
