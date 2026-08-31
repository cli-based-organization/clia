# Ce qui a été fait, suite : les réponses arrivées en cours de tâche

`MET-003` étape 3, second log de fait. Le premier est antérieur aux réponses.

## Ce qui s'est passé

**`NON-037` ne portait aucune réponse quand j'ai commencé.** Je l'ai vérifié et consigné dans le log de demande et dans l'analyse : le fichier était inchangé.

**Les cinq réponses sont arrivées pendant l'implémentation.** Je les ai trouvées en relevant l'état git à la clôture, pas en les cherchant.

## Ce que chaque réponse a produit

| Q | Réponse | Effet |
|---|---|---|
| Q1 | « Rien ne disparait. On conserve. C'est la responsabilité de l'utilisateur. Ouvrir un `ISU` » | Rubrique déjà rétablie. **`ISU-010` ouverte** |
| Q2 | « Pas pour l'instant. Ouvrir un `ISU` » | **`ISU-011` ouverte** |
| Q3 | « oui, en anglais : todo, **opened** et closed » | **`open` devient `opened`** |
| Q4 | « Je ne comprends pas cet objection » | Précisée dans `NON-037` |
| Q5 | « Je ne comprends pas bien. `CLAUDE.md` doit être le plus stable possible » | Précisée dans `NON-037` |

## Q3 : la valeur que j'avais choisie était fausse

J'avais posé `open` le 2026-08-11, seul. La réponse dit **`opened`**.

| Ce qui a été repris | Volume |
|---|---|
| `lib/clia/session.sh` | 7 occurrences |
| `session.cue`, `session.input.cue` | 2 |
| `RES-034` | 2 |
| `tests/test_clia.sh` | 5 |
| L'instance `SES-002` | 1 |

**La migration de l'instance touche un document de régime humain.** `RES-034` réserve son contenu à l'humain et son état « à l'humain, ou au cli agissant pour lui ». Reprendre la valeur était mécanique et commandé par la réponse ; sans cela le dépôt devenait non conforme au schéma dans le même geste. C'est déclaré ici plutôt que passé sous silence.

## Q5 : le malentendu, et pourquoi il m'appartient

**L'objection a laissé entendre le contraire de ce qu'elle voulait dire.**

La réponse dit : « imposer de modifier `CLAUDE.md` semble innacceptable ». **Le lien symbolique est précisément ce qui évite de le modifier.**

`CLAUDE.md` déclare `workspace/session.md` comme seul point d'entrée. Sans lien, ce chemin désigne un fichier unique : changer de session voudrait dire écraser son contenu, ou changer le chemin, donc réécrire `CLAUDE.md`. Avec le lien, le chemin ne bouge jamais et seule sa cible change.

**`CLAUDE.md` n'a pas été touché, et n'a pas à l'être.**

Ma phrase « `CLAUDE.md` resterait valide sans changement » énonçait cela en une incise, au milieu d'une question qui semblait proposer un chantier. La formulation est en cause, pas la lecture.

## Q4 : la question était devenue caduque

Elle demandait par quel geste la session en cours recevrait un énoncé. **L'humain l'avait créé entre-temps.**

Il reste un écart plus petit, mesuré : l'énoncé de `SES-001` existe sans frontmatter.

## `NON-038` resserrée

Elle portait cinq points. **Trois ont été tranchés pendant la tâche.**

| Point | Sort |
|---|---|
| L'état `abandonnee` | `ISU-011` |
| La langue des états | Appliqué |
| Ce que `close` vérifie du critère | `ISU-010` |
| Un lien pointant une session non ouverte | **Reste ouvert** |
| Le frontmatter absent de `SES-001` | **Reste ouvert** |

## Livrables ajoutés

| Fichier | Nature |
|---|---|
| `ISU-010` | Création, à la demande de l'humain |
| `ISU-011` | Création, à la demande de l'humain |
| `NON-037` | Rubrique de précision, sans toucher aux blocs de réponse |
| `NON-038` | Resserrée de cinq à deux questions |
| `session.sh`, schémas, gabarit, `RES-034`, tests | `open` → `opened` |

## Une leçon de méthode

**J'ai vérifié une seule fois qu'il n'y avait pas de réponse, au début.** La tâche a duré assez longtemps pour que l'humain réponde entre-temps, et je ne l'ai su qu'à la clôture.

Relire les objections concernées **avant de clore**, et non seulement avant de commencer.
