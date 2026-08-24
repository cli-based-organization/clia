# Démarche de validation, tâche 18

## Validation de fidélité aux réponses de l'humain

1. Chacune des douze réponses est reportée dans `DCN-008` dans le texte de l'humain, sans reformulation.
2. Vérification que la réponse Q10, déclarée non définitive par son auteur, est enregistrée comme orientation et non comme décision.
3. Vérification que les blocs de réponse de `NON-001` ne sont pas modifiés : le type est en régime hybride avec propriété par bloc, et les réponses appartiennent à l'humain.
4. Vérification que `FRG-001` n'est pas modifié, y compris ses deux phrases interrompues.
5. Vérification que chaque décision de `ADR-008` renvoie à la réponse qui la fonde.

## Validation du périmètre de l'abrogation

6. Relecture des cinq décisions de `ADR-007`, une par une, pour établir laquelle tombe et laquelle subsiste.
7. Vérification que le motif écrit de `ADR-007` D2 dépend bien de D1, ce qui fonde son abrogation par conséquence.
8. Vérification que la relation employée vers `ADR-007` est `reference` et non `remplace`, trois de ses décisions restant en vigueur.
9. Vérification que `DCN-007` conserve `effet: en-vigueur`.

## Validation de propagation

10. Recherche dans le dépôt actif de toute affirmation portant la position abrogée, hors archives et journaux.
11. Correction de chaque occurrence dans un document qui commande le comportement de l'agent ou décrit l'état en vigueur.
12. Vérification que les documents point fixe qui rapportent l'état de leur jour ne sont pas réécrits.
13. Vérification qu'aucun fichier n'est renommé et qu'aucun renvoi n'est réécrit.

## Validation de forme

14. Validation de schéma des sept fichiers touchés, puis du dépôt entier.
15. Comparaison des sections présentes avec celles déclarées par la définition de chaque type.
16. Vérification des liens relatifs des documents créés et modifiés.
17. Contrôle V10 de `ANL-004` sur les quatre documents créés : aucune rubrique méta.
18. Vérification du bump de version de `RES-001`, majeur, conformément à ses propres règles de semver : changement incompatible du sens.

## Validation des mesures citées

19. Recalcul de la mesure de conformité de `PDC-002` : longueur des alias du dépôt, hors gabarits et archives.
20. Vérification que la forme la plus longue est bien l'atome de composite, et que son écart est déjà porté par une objection.

## Validation de l'outillage

21. Suite de tests complète du CLI.
22. Vérification que `clia res ls` affiche les quatre ressources créées, dans leur type respectif.
