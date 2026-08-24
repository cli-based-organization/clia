# Démarche de validation, tâche 12 de SES-002

`MET-003` étape 4. Écrite avant l'exécution des contrôles.

**Réserve** : les contrôles 1 et 2 portent sur des mesures déjà faites pendant l'exécution du chantier A. Ils vérifient que le journal les rapporte fidèlement, non qu'elles ont eu lieu.

1. **Le journal rapporte les quatre passages tels qu'ils se sont produits**, y compris le premier essai invalidé par l'héritage des variables de session.

2. **La trace du hook établit qu'il a été appelé** dans les deux passages où il était branché — sans quoi « sa décision n'est pas suivie » serait indistinct de « il ne tourne pas ».

3. **Le critère du chantier B est satisfait à la lettre** : six cas repris, chacun avec la forme fautive et la forme correcte.

4. **Les six cas correspondent aux interruptions réelles de `BUG-001`**, et non à des exemples inventés.

5. **`PLN-015` n'est pas passé à `execute`.**

6. **Le sort de chaque chantier est déclaré** dans le plan, y compris l'échec de A et la chute de C.

7. **Les corrections portées à `ANL-012` sont signalées dans le document**, non faites en silence.

8. **`MET-005`, `ANL-012` et `PLN-015` restent conformes à leur schéma.**

9. **La suite de tests passe** : aucun code du CLI n'a été touché par cette tâche, elle doit rester à 279.

10. **Le dépôt ne régresse pas** : le nombre d'instances non conformes n'augmente pas.

11. **`clia focus` n'est pas affecté** : `PLN-015` doit sortir de `A EXECUTER` puisqu'il est partiellement exécuté et reste `propose` — vérifier ce qu'il devient réellement, sans préjuger.

12. **Le journal suit `MET-003`** : deux versements de `fait` distincts et croissants, `analyse` avant le premier livrable.

13. **La tâche ne se déclare pas réussie sur un chantier échoué.** Le premier versement ouvre sur l'échec du chantier A.
