# Demande interprétée, tâche 16

## Énoncé

Tâche 16 de `workspace/session.md`, classée `[conception]`.

Trois questions, plus une consigne de sortie.

1. L'historique d'un fichier et celui d'un répertoire sont-ils conservables à partir des informations de git, prises à la racine du dépôt qui contient la ressource ?
2. Y a-t-il des contraintes à respecter pour suivre l'historique individuel de chaque ressource ?
3. Quelles autres options sont jouables pour avoir une chaîne des modifications et connaître le diff entre versions ?

> Terminer l'analyse avec des recommandations.

## Prémisses de la demande

L'énoncé pose trois prémisses.

| Prémisse | Traitement |
|---|---|
| Une ressource est un fichier, un répertoire, ou un dépôt git | Conforme à `ADR-004`, qui pose que l'implémentation est indifférente |
| Le cas du dépôt git est résolu par la signature de tous les commits | Retenu, et le constat C8 mesure que la signature est absente de ce dépôt |
| « git est un blockchain » | **Inexact sur le nom, exact sur le mécanisme.** Traité par le constat C9, qui établit les trois différences |

La troisième prémisse commande la portée des recommandations : ce que git atteste sans signature n'est pas ce que l'énoncé suppose.

## Intention

Établir si le mécanisme existe déjà, et à quelles conditions, avant d'en proposer un nouveau.

## Ressource livrable

| Livrable | Nature |
|---|---|
| `ANL-005` | Création. Analyse, avec recommandations |

## Ordre de travail

| Type de livrable | Type de travail | Skill |
|---|---|---|
| `ANL` | Création | `skl-003-ressource-de-conception` |

## Méthode retenue

Mesurer avant d'affirmer. Le sujet porte sur le comportement d'un outil : toute affirmation est vérifiable par exécution.

Onze expériences, sept sur un dépôt jetable, quatre sur ce dépôt.

## Portée

**Dans la portée.** Le comportement de git pour les trois formes d'implémentation, les contraintes d'écriture, les options d'ancrage.

**Hors portée.** L'implémentation des recommandations. La compatibilité OKF, donnée comme motif dans l'énoncé et non comme question.

## Contrainte de rédaction

Registre directif, conformément à la tâche 15. Références externes en bibliographie numérotée, avec leur état de vérification.
