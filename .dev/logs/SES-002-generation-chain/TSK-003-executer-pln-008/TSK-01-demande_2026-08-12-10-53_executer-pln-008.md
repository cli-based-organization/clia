# Demande interprétée, tâche 3 de SES-002

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande

« Exécuter le plan `PLN-008` ».

## Ce que je constate

`PLN-008` a déjà été exécuté dans son intégralité pendant la tâche 1 : les six chantiers A à F sont faits, journalisés et validés dans `TSK-001-ajuster-clia-ses`. Le corps du plan le déclare : « exécuté dans la foulée ».

**Un défaut.** Le champ `statut-plan` du frontmatter est resté à `propose`, alors que le corps du document affirme l'exécution. C'est exactement le genre d'écart que `BUG` a été créé pour nommer.

## Ce que je fais

Vérifier que les six critères de réussite déclarés par le plan sont satisfaits, corriger le champ `statut-plan`, et documenter la clôture. Rien de neuf à implémenter.
