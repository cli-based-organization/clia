# Démarche de validation, tâche 4

## Contrôles appliqués

Les huit contrôles de `skl-001-ressource`, sur les quatre livrables de la tâche et sur les deux fichiers modifiés.

1. V1, fichier non vide.
2. V2, frontmatter analysable, `type` et `id` présents.
3. V4, aucun tiret cadratin ni demi-cadratin, hors frontmatter, blocs de code et code inline.
4. V5, aucun filet hors frontmatter, tous les liens relatifs résolvent, mêmes exclusions.
5. V6, unicité des `id` sur tout `.dev/`.
6. V7, cohérence entre `id` et nom de fichier.
7. V8, aucun marqueur de gabarit résiduel.

Le contrôle V3, champs obligatoires déclarés par le type, n'est applicable ni aux ADR, ni aux objections, ni au plan : aucun de ces trois types n'a de définition qui déclare ses champs obligatoires. Seul le type `ressource` en a une. C'est une lacune du modèle, pas du contrôle.

## Contrôles de cohérence propres à cette tâche

8. Les six axes de la demande sont couverts par une décision identifiée.
9. Les trois remarques de la demande sont intégrées à une décision identifiée.
10. Chaque décision de `ADR-002` porte un motif renvoyant à une mesure ou à un fait, et non à une préférence.
11. Chaque ambiguïté ou incohérence identifiée dans la demande est portée par une question d'objection.
12. Les liens croisés entre `ADR-002`, `NON-009`, `NON-010` et `PLN-001` résolvent dans les deux sens.
13. Contre-épreuve du contrôle V8 corrigé : vérifier qu'il détecte encore un vrai reste de gabarit après l'affinement du motif.
