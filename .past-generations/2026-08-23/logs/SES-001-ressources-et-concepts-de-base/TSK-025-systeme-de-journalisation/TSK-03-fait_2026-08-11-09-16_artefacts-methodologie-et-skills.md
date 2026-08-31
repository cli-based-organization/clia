# Ce qui a été fait, tâche 25 — deuxième versement

Écrit après la production des artefacts, de la méthodologie et de la correction des skills. Deuxième versement du log `fait`, conformément à `MET-003` étape 3.

## MET-003, la méthodologie de journalisation

Correctif C6. Elle est déclarée ressource source de `RES-032`, qui porte une rubrique « Ressources sources et méthode de génération », conformément à `NON-026` Q5.

**Sept étapes, une par type de log**, et chacune porte son **moment d'écriture**. C'est ce que la méthodologie ajoute à la pratique antérieure : le procédé existait, le moment n'était pas fixé.

**L'étape 3 change le plus.** Le log `fait` n'est plus écrit une fois à la fin : il est **versé** à mesure. Ce document est le deuxième versement de cette tâche.

**Deux règles absolues.** Un log ne rapporte qu'une tâche. Un log ne se réécrit pas.

**Six modes d'échec**, dont quatre mesurés sur le journal de cette session : sept logs écrits en bloc sur onze tâches, trois fichiers combinant plusieurs tâches, une démarche de validation écrite après les contrôles, et un nommage sans date.

## Les artefacts dérivés

| Type | Schéma | Schéma d'entrée | Gabarit |
|---|---|---|---|
| `LOG` | `log.cue` | `log.input.cue` | `log.template.md` |
| `TSK` | `tache.cue` | `tache.input.cue` | `tache.template.md` |
| `SES` | `session.cue` | `session.input.cue` | `session.template.md` |

Les trois schémas passent `cue vet`. Les trois types sont reconnus par `clia res ls`.

**Le schéma de `LOG` contraint l'horodatage** au format `YYYY-MM-DD HH:MM`, et le champ `tache` à la forme `TSK-<SEQ>`. Un log qui ne déclare pas sa tâche ne valide pas.

## Correctif C8, les sept skills

Chacun porte désormais une rubrique `Journalisation` renvoyant à `MET-003`, avec la table des sept moments d'écriture.

**Ce que C8 suppose et qui n'existe pas.** Un générateur. `ADR-016` D3 pose que les skills sont dérivables de `RES`, `ADR`, `SPC` et `RQF` ; rien ne les dérive. Les sept ont donc été corrigés à la main, ce que la décision déclare provisoire.

## Ce que cette tâche a produit sur elle-même

Le journal de cette tâche est au nouveau format et a été écrit au fil de l'eau.

| Log | Horodatage | Écrit |
|---|---|---|
| `TSK-01-demande` | 09:06 | avant toute exploration |
| `TSK-02-analyse` | 09:07 | avant le premier livrable |
| `TSK-03-fait`, premier versement | 09:13 | après les trois définitions |
| `TSK-03-fait`, deuxième versement | ce fichier | après les artefacts et les skills |

Quatre horodatages distincts et croissants. C'est le contrôle que `MET-003` prescrit, et il passe.

## Ce qui reste

L'objection, la validation, et les logs de clôture.
