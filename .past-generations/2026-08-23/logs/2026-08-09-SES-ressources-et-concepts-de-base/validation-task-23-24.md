# Démarche de validation, tâches 23 et 24

## Validation du type ISU

1. Validation de schéma de `RES-031` et des deux fichiers cuelang produits.
2. Vérification que `clia res ls` reconnaît le type et affiche ses propriétés.
3. Épreuve de `clia res new issue`, contrôle du frontmatter et des sections produites.
4. Suppression de l'instance d'essai, pour ne pas consommer le numéro 001.
5. Vérification que `RES-031` suit le gabarit `skl-001` B3, onze rubriques, aucune rubrique méta.
6. Vérification que le type n'a pas de champ `version`, son cycle étant `travail`.

## Validation de PDC-003

7. Vérification que le document déclare son propre régime non actif, en tête.
8. Vérification que chaque critère porte son régime, contraint, mesuré ou sans objet.
9. Vérification de la mesure sur `PLN-001` et `PLN-002`, par lecture des deux plans.
10. Vérification que la résolution archivée contraire, `ANL-016`, est citée et non passée sous silence.

## Validation de ANL-006

11. Recomptage de chaque mesure citée : ADR du dépôt, ADR avec source, gabarits, schémas, instances `DCN`, renvois de la forme `ADR-<SEQ> D<n>`.
12. Vérification que chaque citation de `DCN-013` et de `NON-026` est exacte, par lecture des sources.
13. Vérification que chaque interprétation de l'agent est signalée comme telle.
14. Vérification que les limites déclarent ce que les sources ne disent pas, dont la réponse Q3 inachevée.

## Validation de PLN-003

15. Vérification que chaque chantier porte son coût, ses dépendances et son point d'arrêt.
16. Vérification que le chantier bloquant est nommé comme tel et attribué à l'humain.
17. Vérification que la rubrique d'objections porte le conflit d'intérêt : le plan élargit ce que l'agent peut faire, et c'est l'agent qui le propose.

## Validation d'ensemble

18. Validation de schéma du dépôt entier.
19. Vérification des liens relatifs des cinq documents produits.
20. Contrôle `V10` sur `RES-031`.
21. Suite de tests complète.

## Validation de portée

22. Vérification qu'aucun chantier de `PLN-003` n'est exécuté.
23. Vérification qu'aucune `DCN` n'a été rédigée par l'agent.
24. Vérification qu'aucun plan existant n'a été mis en conformité avec `PDC-003`.
