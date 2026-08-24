# Résultat de la validation, tâche 2 de SES-002

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Retrouve le défaut `status` | **Réussi**, 36 à 38 instances par type |
| 2 | Limité à un type précis | **Réussi** |
| 3 | Aucun signal sous deux instances | **Réussi** |
| 4 | Un champ qui varie sort du rapport | **Réussi**, testé sur `chose` |
| 5 | Code de retour 1 ou 0 | **Réussi** |
| 6 | Type inconnu, code 0, sans erreur | **Réussi** |
| 7 | `type` jamais signalé | **Réussi** |
| 8 | Indépendant de `DCN-016` | **Réussi**, 0 occurrence des quatre champs dans le code |
| 9 | Aide atteignable | **Réussi** |
| 10 | Schéma du dépôt entier | **159 conformes, 8 non conformes** |
| 11 | Suite de tests | **Réussi, 219 assertions** |
| 12 | Journal `MET-003` | **Réussi** |

## Ce que le chantier a révélé au-delà de son objectif

**Sept défauts du même ordre que celui mesuré par `NON-035`**, non un seul. `status` en `draft` était le cas déjà connu ; `initiateur: agent` sur tous les plans, `etat: ouverte` sur toutes les issues, `statut-decision: propose` sur tous les ADR étaient inconnus jusqu'à ce contrôle.

**Ce n'est pas nécessairement une liste de bogues.** Certains sont peut-être justes : rien n'oblige un plan à avoir été initié par l'humain, et une issue fraîchement créée est normalement ouverte. Le contrôle signale une absence de variation, pas une erreur ; l'interprétation reste humaine.

## Ce que la tâche n'a pas résolu

**`PLN-007` reste à six septièmes non exécuté.** `DCN-016` est toujours suspendue. Aucune approbation, aucun refus, aucune modification n'a été demandée : la question reste entièrement entre les mains de l'humain.
