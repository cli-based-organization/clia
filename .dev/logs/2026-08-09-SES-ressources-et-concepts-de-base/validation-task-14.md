# Démarche de validation, tâche 14

## Validation de schéma

1. Extraction du frontmatter de chaque `.md` de `.dev`, hors archives, gabarits et journaux, puis `cue vet` contre le schéma de son type.
2. Vérification que les six schémas et gabarits touchés restent analysables : `decision.cue`, `decision.input.cue`, `decision.template.md`, et les trois nouveaux types d'instance produits.
3. Validation ciblée des treize livrables de la tâche, séparément du dépôt entier, pour que leur conformité ne soit pas masquée par un total.
4. Vérification que le nom de la définition CUE d'un type composé est bien formé : `#RES_principe_de_conception` et non le nom à tirets, ce qui a d'abord produit un faux positif dans l'outil de validation lui-même.

## Validation de forme

5. Comparaison, pour chaque instance, entre les sections déclarées par la définition de son type et les sections effectivement présentes dans le fichier.
6. Vérification des liens relatifs des quatorze fichiers touchés, résolution sur le disque.
7. Vérification que les sept `DCN` portent la section « Motivation du changement » à la position déclarée par `RES-009`, soit après « La décision ».
8. Vérification que la migration n'a modifié aucune teneur : seuls deux champs et une section ont été insérés, ce qu'un `git diff` restreint aux `DCN` confirme.

## Validation du code et de l'outillage

9. Suite de tests complète du CLI.
10. Vérification que `clia res ls decision`, `clia res ls methodologie` et `clia res ls objection` affichent les ressources créées ou migrées.
11. Épreuve de `clia res new decision` dans une **copie** du dépôt, pour vérifier que le gabarit produit les deux nouveaux champs et la nouvelle section sans écrire dans le dépôt réel.
12. Vérification qu'aucun numéro n'a été consommé dans le dépôt réel par cette épreuve, `ADR-007` D2 interdisant la réattribution d'un numéro libéré.

## Validation de cohérence de fond

13. Vérification que chacun des sept apports de `FND-003` est traité dans `RES-009` ou dans `MET-002`, et que la table de correspondance est explicite.
14. Vérification que chaque affirmation nouvelle de `RES-009` et de `MET-002` renvoie à sa source dans `FND-003`, et non à une préférence de rédaction.
15. Vérification que les corrections apportées à `FND-003` ne touchent aucune affirmation sourcée, mais seulement la cohérence du document avec ses propres mesures.
16. Vérification que `MET-002` porte, pour chaque étape, soit un contrôle, soit la déclaration explicite qu'aucun contrôle n'existe.
17. Vérification que l'objection dirigée contre le livrable de la tâche, `NON-022`, porte des chiffres vérifiables et non un doute rhétorique.
18. Vérification que la position contraire est écrite dans les objections qui en ont une, `NON-021` portant une section « Ce qui plaide contre l'objection ».
19. Vérification qu'aucune question de `NON-019`, qui appartiennent à l'humain, n'a reçu de réponse de l'agent.
20. Vérification que les fichiers non conformes créés par l'humain, `FRG-001` et `NON-013`, n'ont pas été complétés.
