# Démarche de validation, tâche 3

## Principe

Les livrables de la tâche 3 sont validés par les contrôles que le skill lui-même définit. C'est le seul test d'auto-application disponible en l'absence d'outil, et c'est aussi la première mise à l'épreuve de ces contrôles.

## Contrôles appliqués

1. V1, fichier non vide, sur les dix fichiers de `.dev/adr/`, `.dev/skills/` et `.dev/ressources/`.
2. V2, frontmatter analysable par un parseur YAML, avec `type` et `id` présents.
3. V3, champs obligatoires déclarés par `RES-001` présents dans chaque définition de type.
4. V4, aucun tiret cadratin ni demi-cadratin hors frontmatter, blocs de code et code inline.
5. V5, aucun filet hors frontmatter, et tous les liens relatifs résolvent, mêmes exclusions.
6. V6, unicité des `id` sur tout `.dev/`.
7. V7, cohérence entre `id` et nom de fichier.
8. V8, aucun marqueur de gabarit résiduel, mêmes exclusions.

## Contrôles de cohérence propres à cette tâche

9. `ADR-001` ne recopie pas le contenu de `RES-001` : vérification du critère de départage sur les passages qui traitent du cycle de vie et du régime d'édition, présents dans les deux documents mais sous des angles distincts.
10. Chaque décision de `ADR-001` porte un motif renvoyant à un fait de `ANL-001`, et non à une préférence.
11. Les liens croisés entre `RES-001`, `ADR-001` et `skl-001` résolvent dans les trois sens.
12. Les champs `skill` et `adr` de `RES-001` correspondent aux fichiers effectivement produits.
