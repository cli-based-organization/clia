# Ce qui a été fait, tâche 25 — premier versement

Écrit au moment de la production des trois définitions, avant la suite du travail. C'est le correctif C7 appliqué : le log de type `fait` s'écrit à mesure, non à la clôture.

## Les trois types

| Réf | Type | Cycle | Édition | Forme |
|---|---|---|---|---|
| `RES-032` | `LOG` | `point-fixe` | `ia` | fichier |
| `RES-033` | `TSK` | `travail` | `hybride` | **répertoire** |
| `RES-034` | `SES` | `travail` | `hybride` | **répertoire** |

**`LOG` est `point-fixe`.** Un log constate un moment ; le modifier serait falsifier. Il ne porte pas de champ `version`, et une correction produit un log nouveau qui déclare `derive-de`.

**`TSK` et `SES` sont des composites**, au sens de `ADR-004` D3. Le répertoire d'une tâche contient tous les logs de cette tâche et rien d'autre, ce qui est le correctif C2.

## Les sept types de log, et leur numéro fixe

Correctif C5. Le numéro est identique pour toutes les tâches et estime l'ordre de génération.

| `SEQ` | Type | Quand il s'écrit |
|---|---|---|
| 01 | `demande` | Avant tout travail |
| 02 | `analyse` | Avant de produire |
| 03 | `fait` | **Pendant**, à mesure |
| 04 | `validation` | Avant de valider |
| 05 | `resultat-validation` | Après les contrôles |
| 06 | `next` | À la clôture |
| 07 | `commit-message` | À la clôture |

## Le champ qui rend C7 vérifiable

`RES-032` porte un champ `ecrit-le`, horodaté à la minute. Il porte le moment de l'écriture, jamais celui de la clôture.

C'est ce qui permet de lire, sans outil, si les sept logs d'une tâche ont été écrits en bloc ou au fil de l'eau : sept horodatages identiques signalent une reconstruction.

**Ce que le champ ne garantit pas.** Rien ne prouve qu'un log a été écrit au moment qu'il déclare. L'horodatage est déclaratif.

## Le chemin, et ce qu'il donne à lire

Correctif D1.

```
.dev/logs/SES-001-ressources-et-concepts-de-base/
          TSK-025-systeme-de-journalisation/
              TSK-01-demande_2026-08-11-09-06_systeme-de-journalisation.md
```

Quatre informations sont lisibles sans ouvrir un fichier : la session, la tâche, le type de log, la date et l'heure.

L'ancien format en donnait une seule : le type. `demande-task-14.md` ne porte ni date, ni heure, ni session.

## Ce qui reste à faire dans cette tâche

Les artefacts dérivés des trois types, la `MET-003`, le correctif C8 sur les sept skills, et l'objection.
