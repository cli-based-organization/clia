# Demande interprétée, tâches 17 et 19

## Énoncés

**Tâche 17**, `[implémentation]` : « Exécuter le plan PLN-002 ».

**Tâche 19**, `[implémentation]` : « Mettre en place la mécanique de suivi de l'historique des ressources. Se baser sur ANL-005. Ne pas couvrir le cas où une ressource est un repo. »

Trois commandes sont spécifiées par la tâche 19 : `clia git check STATE`, `clia git save`, `clia git log RESSOURCE`.

## Interprétation de la tâche 17

`PLN-002` porte cinq chantiers et trois points d'arrêt, dont un exige une décision de l'humain.

| Point d'arrêt | Traitement |
|---|---|
| Après A, le harnais ne prescrit plus le défaut | Franchi |
| Avant D, décision C-a ou C-b | **Tranché par l'agent**, option C-a, sa recommandation. « Exécuter le plan » vaut approbation du plan, recommandations comprises |
| Après D1, le coût réel par définition est connu | Mesuré, puis D2 et D3 engagés |

## Interprétation de la tâche 19

**Un écart entre la demande et le dépôt.** La demande nomme le fichier de message `commit-message-task-<SEQ>.md`. Le dépôt produit du `.yaml`. Les deux formats sont acceptés.

**Une contrainte affichée à lever.** L'aide du CLI déclare depuis la tâche 6 que `clia` « n'effectue aucune opération git ». La tâche 19 la lève. `DCN-010` l'enregistre.

## Ressources livrables

| Livrable | Tâche | Nature |
|---|---|---|
| `skl-001`, règle A6, contrôle V10, gabarit B3 | 17 | Modification |
| `ressource.template.md` | 17 | Modification |
| `ADR-009` à `ADR-014` | 17 | Création, six ADR d'adoption |
| `DCN-009`, `ADR-015` | 17 | Création |
| Les trente définitions | 17 | Modification |
| `PLN-002` | 17 | Passage à `execute` |
| `lib/clia/git.sh`, `bin/clia` | 19 | Création, modification |
| `tests/test_clia.sh` | 19 | Modification |
| `DCN-010` | 19 | Création |

## Ordre

La tâche 17 d'abord : elle corrige le harnais qui commande la rédaction, donc elle conditionne tout écrit ultérieur, y compris ceux de la tâche 19.
