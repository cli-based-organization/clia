# Démarche de validation, tâche 5

## Contrôles de forme et de cohérence

1. V1, fichier non vide, sur les quatre livrables.
2. V2, frontmatter analysable, `type` et `id` présents.
3. V4 et V5, aucun tiret cadratin, aucun filet hors frontmatter, tous les liens relatifs résolvent, hors blocs de code et code inline.
4. V6, unicité des `id` sur tout `.dev/`.
5. V8, aucun marqueur de gabarit résiduel.
6. V3 non applicable : aucun des trois types produits n'a de définition déclarant ses champs obligatoires. C'est l'objet de `NON-011`.
7. V7 non applicable en l'état : la règle de nommage des types `point-fixe` est contredite par l'usage du dépôt, ce que `NON-011` Q2 porte.

## Contrôles propres à une recherche de fondation

8. Chaque fait daté avancé est rattaché à une source consultable, listée en fin de document.
9. Les sources sont accompagnées d'un jugement d'autorité : sources primaires, guides communautaires, billets d'analyse.
10. Toute affirmation reprise d'une source secondaire est signalée comme rapportée et non vérifiée.
11. La section d'interprétation est séparée de la section de recherche, et la séparation est déclarée.
12. Les limites de la recherche sont écrites, y compris ce que la littérature ne traite pas.

## Contrôles propres à l'analyse

13. La question posée reçoit une réponse explicite, non un survol.
14. Chaque critère d'évaluation est rattaché à un fait mesuré ou à une contrainte établie.
15. Les options écartées le sont avec leur motif.
16. La réponse porte un critère de renversement constatable.
17. Les objections que l'analyse soulève contre elle-même sont écrites.

## Contrôles propres à l'ADR

18. Chaque décision porte un motif renvoyant à `FND-001`, à `ANL-002` ou à un fait de `ANL-001`.
19. Les décisions qui reportent une question le déclarent, avec le lieu du report.
20. La chaîne de dérivation est tracée : l'ADR renvoie à l'analyse, l'analyse renvoie à la recherche et au corpus.
