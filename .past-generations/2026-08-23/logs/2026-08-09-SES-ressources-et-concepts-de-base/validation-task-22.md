# Démarche de validation, tâche 22

## Validation de fidélité

1. Chacune des huit décisions de `ADR-017` cite la réponse de l'humain qui la fonde, entre guillemets et dans son texte.
2. Vérification qu'aucun bloc de réponse de `NON-003` n'est modifié : le type est en régime hybride avec propriété par bloc.
3. Vérification que la réponse Q4, qui reporte le type Acteur, ne produit aucun document.
4. Vérification que la réponse Q3, qui déborde sa question, est traitée pour ce qu'elle dit et non pour ce qui était demandé.

## Validation des définitions modifiées

5. `RES-002` : `peremption` retiré des champs obligatoires, l'affect y entre, le régime de fiabilité est déclaré.
6. `RES-003` : l'emplacement dérogatoire est retiré du frontmatter, le lien symbolique est décrit.
7. `RES-005` : le test d'admission passe à quatre conditions, la première étant la véracité établie.
8. `RES-009` et `RES-019` : la frontière entre décision et justification est inversée dans les deux sens, sans contradiction résiduelle.
9. `RES-019` : `edition` passe à `ia`.
10. `contexte.cue` : `peremption` déclaré facultatif.
11. `skl-001` B1 : le tableau du critère de départage est aligné.

## Validation de cohérence

12. Recherche d'une affirmation résiduelle posant que l'ADR décide, dans les documents actifs.
13. Vérification que `ADR-017` déclare sa propre irrégularité au regard de D5, plutôt que de la taire.
14. Vérification que les conséquences rétroactives sont nommées, dont le cas de `FCT-001` au regard de D1.

## Validation de forme

15. Validation de schéma du dépôt entier.
16. Vérification des liens relatifs.
17. Contrôle `V10` sur les définitions.
18. Suite de tests complète.

## Validation de portée

19. Vérification qu'aucune `DCN` n'a été rédigée par l'agent, et que le gabarit `DCN-012` porte ses champs `À RENSEIGNER`.
20. Vérification qu'aucun ADR existant n'a été rattaché rétroactivement à une `DCN`.
21. Vérification que le lien symbolique n'a pas été posé, la tâche étant un traitement d'objections.
