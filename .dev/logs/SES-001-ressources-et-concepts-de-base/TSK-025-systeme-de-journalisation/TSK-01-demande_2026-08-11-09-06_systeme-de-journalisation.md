# Demande interprétée, tâche 25

Écrit le 2026-08-11 à 09:06, avant tout autre travail. C'est le correctif D4 appliqué à la tâche qui le prescrit.

## Énoncé

Tâche 25, `[convergence comportement attendu]` : système de journalisation.

Quatre défauts constatés par l'humain, et huit correctifs proposés.

| Réf | Défaut |
|---|---|
| D1 | Un humain doit comprendre le contexte en inspectant les noms de fichiers et de répertoires |
| D2 | Le contenu doit être facilement cherchable |
| D3 | Le contexte, notamment les dates et heures d'exécution, doit être compréhensible |
| D4 | Les éléments du journal doivent être générés **au moment de leur réalisation** |

## Ce que les défauts constatent, et qui les a produits

Les quatre défauts portent sur le journal de cette session, produit par l'agent depuis le 2026-08-09.

**D4 est le plus grave, et il est vérifiable.** Les journaux des tâches 14 à 24 ont été écrits **à la fin** de chaque tâche, en une passe, y compris le fichier nommé `demande` qui prétend rendre compte de l'interprétation initiale. Un journal écrit après coup est une reconstruction.

**Les correctifs 2 et 3 constatent un autre écart.** Le journal porte `fait-task-17-19.md`, `fait-task-20-21.md`, `fait-task-23-24.md` : trois fichiers qui combinent les logs de plusieurs tâches, ce que le correctif 3 interdit.

## Les huit correctifs

| Réf | Correctif |
|---|---|
| C1 | Session, tâche et log sont des ressources : écrire `RES` pour `LOG`, `TSK` et `SES` |
| C2 | Chaque tâche a son répertoire, contenant tous et uniquement ses logs |
| C3 | On ne combine jamais les logs de plusieurs tâches |
| C4 | Nom de fichier : `TSK-<SEQ>-<TYPE_LOG>_<YYYY-MM-DD-HH-MM>_<SLUG>.md` |
| C5 | `SEQ` est le numéro du **type de log**, fixe pour toutes les tâches, estimant l'ordre de génération |
| C6 | Produire une `MET` de journalisation, ressource source interne à `RES` log |
| C7 | La méthode exige que l'info de log soit inscrite **au moment de son exécution** |
| C8 | Générer les skills en tenant compte de la `MET` de journalisation |

## Une ambiguïté dans C6

« produire une méthode MET de journalisation (ressource source) interne à RES log ».

Deux lectures.

**(a) La `MET` est un document séparé, déclaré comme ressource source dans `RES` log.** C'est le mécanisme que `NON-026` Q5 décrit : « dans la définition des ressources générées, on spécifie les ressources sources et la méthode MET de génération ».

**(b) La `MET` est écrite dans le fichier `RES` log.** C'est exactement le sujet de `ISU-001`, ouverte hier et non résolue.

**Lecture retenue : (a).** La seconde suppose un mécanisme d'imbrication qui n'existe pas. L'ambiguïté est signalée et portée par une objection.

## Ressources livrables

| Livrable | Nature |
|---|---|
| `RES-032` `LOG`, `RES-033` `TSK`, `RES-034` `SES` | Création, trois types |
| Artefacts dérivés | Création, gabarits et schémas |
| `MET-003` | Création, méthodologie de journalisation |
| Les sept skills | Modification, correctif C8 |
| Le journal de cette tâche | **Au nouveau format, écrit au fil de l'eau** |

## Ce que la tâche impose à sa propre exécution

C7 exige que l'information de log soit inscrite au moment de son exécution. Cette tâche est la première à devoir s'y conformer, et son journal est le premier au nouveau format.

C'est aussi le seul moyen d'éprouver le format avant de le prescrire.
