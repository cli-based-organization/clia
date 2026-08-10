# Démarche de validation, tâches 8 et 9

## Validation mécanique, nouvelle

1. `cue vet` sur les soixante schémas générés, pour vérifier qu'ils sont syntaxiquement valides et mutuellement cohérents.
2. Validation de chaque ressource du dépôt contre le schéma de son type, par extraction du frontmatter, conversion en JSON et `cue vet -d`.
3. Épreuve du générateur : régénération complète après chaque correction de définition, pour vérifier que la dérivation reste idempotente.
4. Épreuve de `clia res new` dans un dépôt d'essai, puis validation du fichier produit contre son schéma. C'est le test de bout en bout : l'outil doit produire ce que le schéma exige.

## Validation de forme

5. Contrôles V4, V5 et V8 de `skl-001-ressource` sur les trente définitions, les cinq ADR, les cinq DCN, les sept skills, les trois objections nouvelles et l'index.
6. Contrôle V2 sur les frontmatter : analysables, `type` et `id` présents.
7. Contrôle V6 : unicité des identifiants sur tout `.dev/`.

## Validation de non-régression

8. Suite de tests du CLI, soixante-sept assertions, après les trois corrections apportées à `clia res new` et à la résolution de type.
9. Vérification que `clia res ls` voit les trente types définis et affiche leur famille.

## Validation de cohérence du modèle

10. Chaque définition déclare une famille appartenant aux six de `ADR-005`.
11. Chaque définition déclare des `sections`, dont le gabarit est dérivé.
12. Chaque type de famille renvoie au skill de sa famille et non à un skill propre.
13. Les cinq arbitrages d'attribution de `ADR-005` D3 sont chacun signalés dans l'ADR et portés par `NON-017`.
14. `ANL-001` est mis en conformité avec `ADR-004` D3 : chacun de ses huit atomes est identifiable et déclare son appartenance.
