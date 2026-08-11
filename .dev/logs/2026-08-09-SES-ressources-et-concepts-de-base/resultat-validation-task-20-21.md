# Résultat de la validation, tâches 20 et 21

## Bilan

| Contrôle | Résultat |
|---|---|
| `CONSTITUTION.md` porte les trois interdits demandés | **oui**, C1 et C2 |
| Types passés en `edition: humain` | `RES-009`, `RES-012` |
| Garde C2, refus en environnement d'agent | **code 3**, six tests |
| Lecture git permise à l'agent | `log` et `check`, vérifiés |
| Instances `DCN` ou `PDC` modifiées par l'agent | **0** |
| `HEAD` égale la référence distante | **oui** |
| Schéma, dépôt entier | **110 conformes, 3 non conformes** |
| Liens relatifs | **0 cassé**, hors exemples de gabarit |
| `V10` sur les définitions | **0 en faute** |
| Tests du CLI | **124 réussis, 0 échoué** |

## Les trois non-conformités de schéma

Les trois sont des gabarits en attente de leur initiateur, et aucune n'est corrigible par l'agent.

| Fichier | Champs à renseigner | Qui doit le faire |
|---|---|---|
| `DCN-011` | `instance`, `portee`, `effet`, `attestation`, `diffusion` | L'humain, par C1 |
| `FRG-001` | `exploitation` | L'humain, son initiateur |
| `NON-013` | `effet`, `etat`, `initiateur` | L'humain, son initiateur |

`DCN-011` est le premier cas où la non-conformité est **produite volontairement** : C1 interdit à l'agent de renseigner ces champs.

## La garde C2, éprouvée

Contrôles 6 à 10. Six tests, tous dans un dépôt jetable.

| Épreuve | Attendu | Obtenu |
|---|---|---|
| `save` avec marqueur d'agent | refus, code 3 | conforme |
| `save` avec `CLIA_ACTOR=agent` | refus, code 3 | conforme |
| `log` avec marqueur d'agent | permis | conforme |
| `check` avec marqueur d'agent | permis | conforme |
| `save --help` | déclare la réserve à l'humain | conforme |

La suite de tests a dû être ajustée : elle tourne souvent dans un environnement d'agent, où la garde refusait les tests du fonctionnement nominal de `save`. Ceux-là posent désormais `CLIA_ACTOR=human` dans leur dépôt jetable, et les tests de la garde posent explicitement l'inverse.

## Le relevé de l'existant

Contrôles 11 à 14.

| Fait | Valeur |
|---|---|
| `DCN` du dépôt | 10, plus le gabarit `DCN-011` |
| `DCN` portant `effet: en-vigueur` | **7** |
| `DCN` portant `effet: proposee` | 3 |
| `PDC` du dépôt | 2 |
| Instances rédigées par l'agent | **12 sur 12** |
| Instances approuvées | **0** |

La citation de la constitution archivée est exacte et vérifiée par lecture du fichier : l'interdit git y figurait dans des termes plus larges que ceux de la tâche 20.

Aucune des douze instances n'a été modifiée. Le seul fichier apparaissant dans `.dev/decisions` et `.dev/principes` est le gabarit `DCN-011`, non suivi.

## Le commit accidentel

Contrôle 14. `HEAD` égale `origin/main` à `e47eedd`. Le commit `923880a` n'existe plus dans la branche.

Les huit fichiers qu'il contenait sont revenus en attente, intacts. Aucun historique publié n'a été réécrit : le commit n'avait pas été poussé.

Le fait est consigné en `FCT-001` F09, avec sa cause et son traitement.

## Le bogue corrigé

Contrôles 15 à 17.

```
avant                                        après
type: 009                                    type: decision
id: DCN-structure-du-systeme-autour-...      id: DCN-011
```

La dérivation du nom canonique fonctionne pour un type à nom composé : `RES-012-principe-de-conception` donne `principe-de-conception`.

Deux tests attendaient encore la forme `id: CHO-<slug>`, abolie par `ADR-007` le 2026-08-09. Ils ont été alignés sur `ADR-008` D2, avec le motif écrit dans le test.

Le numéro 011 n'a pas été consommé deux fois : le premier gabarit a été supprimé avant régénération.

## La tâche 21

Contrôles 18 à 22.

Chacune des huit décisions de `ADR-016` cite la réponse de l'humain qui la fonde, entre guillemets et dans son texte.

`RES-003` retire `critere-de-trahison` de ses champs obligatoires ; `intention.cue` le déclare facultatif par `?`.

`RES-018` passe en `edition: ia`.

`NON-002` passe à `repondue`, effet `informatif`. Ses blocs de réponse ne sont pas touchés : seuls le frontmatter, le journal, la section « Ce qui lèverait cette objection » et les relations sont modifiés.

**Aucune `DCN` n'a été rédigée par l'agent.** Le gabarit `DCN-011` porte ses cinq champs `À RENSEIGNER`.

## Ce que la validation n'établit pas

**La garde C2 n'est pas une barrière.** Elle refuse `clia git save` ; elle n'empêche pas un agent d'appeler `git commit`. La constitution le déclare, et F09 en fournit la démonstration involontaire.

**`ADR-016` D3 est instruite et inapplicable.** Aucun générateur ne dérive un skill, et deux des quatre sources nommées, `SPC` et `RQF`, ont zéro instance. `NON-025` porte les quatre questions.

**Le sort des douze instances existantes n'est pas décidé.** `NON-024` est `bloquante` : huit `ADR` du dépôt dérivent de `DCN` dont l'approbation n'est pas établie.

**`CLAUDE.md` n'est pas aligné sur D2**, qui pose que sa table des types cesse d'être une source. Le chantier appartient à `PLN-001`, en attente depuis le 2026-08-09.
