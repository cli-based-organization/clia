# Résultat de la validation, tâche 28

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma, `RES-035` et `REG-001` | **conformes** |
| `cue vet` sur les deux schémas | **passe** |
| Rubriques méta, `V10` | **0** |
| Rubrique obligatoire de `REG-001` | **présente** |
| Tests du CLI | **144 réussis, 0 échoué** |
| Schéma, dépôt entier | **131 conformes, 6 non conformes** |
| Liens relatifs | **0 cassé** |
| Registres créés | **1**, celui demandé |
| `FRG-2026-08-11` modifié | **non**, non suivi et intact |

## Les six non-conformités de schéma

Cinq sont connues et inchangées : `DCN-011`, `DCN-012`, `DCN-013`, `FRG-001`, `NON-013`.

**La sixième est nouvelle et elle a révélé un bogue.** `FRG-2026-08-11-methodologie-issues.md`, créé par l'humain, porte un identifiant daté que `ADR-007` D4 abolit depuis le 2026-08-09.

Le fichier n'est ni renommé ni modifié : il appartient à son initiateur.

## Le bogue, et ce qui l'avait laissé passer

`clia res new` attribuait un discriminant daté aux types `point-fixe`. La décision qui l'abolit date du 2026-08-09 ; le générateur ne l'avait pas suivie.

**Un test codifiait l'ancien comportement.** `un type point-fixe est nomme par date` vérifiait la forme abolie et passait au vert. La migration de la tâche 13 avait corrigé les fichiers du dépôt, pas le générateur ni son test.

C'est la troisième trace de cette migration restée en place, après les deux régressions corrigées à la tâche 21.

**Correction vérifiée.** Le test réécrit porte le motif de son changement, et une assertion vérifie qu'aucun nommage daté ne subsiste dans le répertoire produit.

## Les commandes, contrôles 6 à 13

Dix-huit assertions couvrent les registres.

| Vérification | Résultat |
|---|---|
| `reg ls` affiche identifiant, tenue, nombre d'items | conforme |
| `reg ls REG-001` affiche les quatre colonnes | conforme |
| Le séparateur du tableau n'est pas pris pour un item | **vérifié explicitement** |
| `reg show` affiche l'item puis la ressource | conforme |
| Résolution par alias et par numéro seul | conforme |
| Numéro d'item avec et sans zéros de tête | conforme |
| Quatre cas d'erreur, codes 1 et 2 | conforme |
| Trois aides détaillées | conforme |

## L'auto-application du format de journal

Répertoire propre, cinq logs, horodatages distincts et croissants.

## Portée respectée

Un seul registre créé, celui que la demande réclame. Les trois autres, demandés par `NON-004` Q4, restent au chantier D de `PLN-005`.

`FRG-2026-08-11` reste non suivi et intact.

## Ce que la validation n'établit pas

**Que `REG-001` reste juste.** Son champ `tenue` vaut `saisie`. Rien ne vérifie qu'une décision ajoutée y soit reportée, et c'est la quatrième obligation de propagation sans contrôle du dépôt.

**Que le type unique soit le bon choix.** L'énoncé parlait d'une « catégorie » et écrivait `REG_TYPE-<SEQ>`. L'implémentation retient un type unique, ce qui est une interprétation. `NON-029` Q1 la porte, et elle engage les trois registres à venir.

**Qu'un item ne soit pas une ressource.** `RES-035` pose qu'un item est une entrée, sur le modèle du recueil de faits. Si `ISU-001` tranchait autrement, `REG-001` compterait pour quatorze ressources et non pour une.
