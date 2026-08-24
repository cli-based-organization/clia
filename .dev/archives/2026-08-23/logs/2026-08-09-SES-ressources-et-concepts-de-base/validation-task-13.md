# Démarche de validation, tâche 13

## Validation de la migration

1. Aucun fichier au nommage daté ne subsiste hors des archives.
2. Aucune prescription `<PREFIX>-<DATE>` ne subsiste dans les définitions ni dans les skills.
3. Aucun identifiant à slug ne subsiste dans un frontmatter.
4. La table de correspondance est dérivée mécaniquement du nom de fichier, non saisie.
5. Le remplacement traite les identifiants du plus long au plus court, pour qu'un identifiant court ne soit pas remplacé à l'intérieur d'un plus long.
6. Le remplacement emploie une frontière de mot, pour ne pas atteindre un identifiant dont un autre serait le préfixe.

## Validation de schéma

7. `cue vet` sur les soixante schémas régénérés.
8. Validation de chaque ressource du dépôt contre le schéma de son type.
9. Vérification que le schéma `#Id` accepte les deux formes retenues, `<PREFIX>-<SEQ>` et `<PREFIX>-<SEQ>-<NN>`, et rejette la forme à slug.

## Validation du code

10. Analyse syntaxique des modules modifiés.
11. Suite de tests complète, 91 assertions.
12. Vérification que `clia res ls` résout les trente types et n'affiche aucun type sans définition.
13. Vérification que la dérivation du nom canonique fonctionne depuis le nom de fichier et non depuis l'`id`.

## Validation de forme

14. Contrôles V4, V5 et V8 de `skl-001-ressource` sur les trois livrables et sur l'index.
15. Vérification des liens relatifs, y compris ceux qui pointent vers les fichiers renommés.

## Validation de cohérence de la décision

16. `ADR-007` déclare explicitement ce qu'il abroge, et `ADR-001` D3 est nommé.
17. Chaque décision qui va contre une position antérieure de l'agent explique pourquoi cette position était fausse, plutôt que de l'écarter.
18. Les ajouts de l'agent à la demande, notamment l'interdiction de renuméroter, sont signalés comme tels.
19. Les réponses aux questions de `NON-001` et `NON-011` sont consignées dans les objections elles-mêmes, avec leur date et leur source.
20. Les fichiers de l'humain non conformes ne sont pas complétés, et leur non-conformité est déclarée comme un signalement.
