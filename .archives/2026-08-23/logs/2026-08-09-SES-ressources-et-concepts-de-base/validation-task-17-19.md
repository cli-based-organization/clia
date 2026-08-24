# Démarche de validation, tâches 17 et 19

## Validation de la tâche 17

1. Contrôle `V10` appliqué aux trente définitions : aucune rubrique méta.
2. Recomptage des marqueurs de justification sur les trente définitions, six motifs.
3. Mesure du volume avant et après, sur le même ensemble de fichiers.
4. Vérification que le champ `adr` de chaque définition pointe vers l'ADR d'adoption de sa famille et non plus vers `ADR-005`.
5. Vérification que le contenu retiré des rubriques méta se retrouve dans l'ADR de la famille correspondante.
6. Validation de schéma des trente définitions et des sept ADR créés.
7. Vérification des liens relatifs des définitions et des ADR.
8. Vérification que `skl-001` B1 et B3 ne se contredisent plus.
9. Vérification que les six skills de famille renvoient à `V1 à V10`.
10. Chantier E : mesure de la part méta sur les six autres types, pour établir si la correction doit s'étendre.

## Validation de la tâche 19

11. Analyse syntaxique de `bin/clia` et de `lib/clia/git.sh`.
12. Épreuve de `check clean` sur un dépôt propre puis modifié.
13. Épreuve de `check done` sans message préparé, puis avec.
14. Épreuve de `save`, vérification du rendu de l'en-tête, du corps et de la note.
15. Épreuve de `save` sur un dépôt sans modification.
16. Épreuve de `log` sur une ressource fichier et sur une ressource composite.
17. Vérification que l'identifiant de contenu affiché est bien celui que `git rev-parse` calcule.
18. Épreuve de `diff` sous ses deux formes, à trois arguments et à deux.
19. **Production délibérée de la faute que T1 doit attraper**, puis vérification que `check done` échoue et que `save` refuse.
20. Vérification que le même geste en deux commits n'est pas signalé.
21. Épreuve hors dépôt git : la commande le dit au lieu d'échouer.
22. Vérification que chaque verbe et chaque aide détaillée répondent à `--help`.
23. Suite de tests complète.

## Validation d'isolation

24. Vérification qu'aucune épreuve n'a commité dans le dépôt du projet : tous les essais construisent leur propre dépôt git.
25. Vérification qu'aucun numéro de ressource n'a été consommé par une épreuve.
