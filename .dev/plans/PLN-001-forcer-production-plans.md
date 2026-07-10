# PLN-001 - Modifier le harnais pour forcer la production de plans avant exécution

**Statut : exécuté**

## Changelog

- **v1 (tâche-3 à tâche-5)** : création et exécution sous Haiku. Le plan a installé une section « Flux de production des plans » dans `CLAUDE.md`, un frontmatter YAML de statut (`en cours|terminé|todo`) et une section « Processus des plans » dans `CONSTITUTION.md`.
- **v2 (tâche-6/tâche-7, migration de format)** : ce plan est migré au format canonique du dépôt source (statut inline, sans frontmatter YAML), tirets cadratins convertis. **Note importante :** l'appareillage installé par ce plan (frontmatter YAML de statut, section « Flux de production des plans ») a été **retiré** par PLN-003 pour aligner le dépôt sur la source `intentional-doers-governance`. Ce fichier reste comme trace historique du travail réalisé sous Haiku.

## Intention

Établir que l'agent IA **doit toujours** proposer un plan avant d'exécuter toute demande, conformément à la méthodologie objection-sociocratique. Les tâches 1 et 2 avaient été exécutées directement sans plan préalable, ce qui ne devait plus se reproduire.

## Contexte

La méthodologie du dépôt repose sur une gouvernance objection-sociocratique. Elle ne peut fonctionner que si **chaque** intervention de l'agent est proposée sous forme de plan avec :
- analyse de l'intention humaine ;
- identification des livrables ;
- proposition d'objections (risques, ambiguités, critiques constructives).

## Objections de l'agent IA

### [OBJECTION-1] Charge cognitive des plans pour les petites demandes

**Statut : LEVÉE.** L'objection visait à identifier qui risquait d'être confus : la réponse est l'expérience utilisateur humain. Dans un système de travail documentaire (fichiers, pas conversation), ce paradigme est accepté : l'humain apprend à lire les plans plutôt qu'à attendre un résumé conversationnel. Tous les plans restent obligatoires, même courts.

### [OBJECTION-2] Plans rétroactifs pour tâches 1 et 2

**Statut : LEVÉE.** Ignorer les tâches 1 et 2 : elles ont été exécutées avant la clarification de la méthodologie. La règle s'applique à partir de la tâche 3.

### [OBJECTION-3] Ambiguité sur le rôle du plan dans le harnais existant

**Statut : LEVÉE.** Convention de nomenclature clarifiée par l'humain à la tâche 5. Cette convention (frontmatter YAML, statuts `en cours/terminé/todo`) a ensuite été remplacée par le vocabulaire de la source à la tâche 7 (voir PLN-003).

## Travail effectué

1. Modification de `CLAUDE.md` : ajout d'une section « Flux de production des plans », nomenclature séquentielle, frontmatter YAML.
2. Modification de `CONSTITUTION.md` : ajout d'une section « Processus des plans ».
3. Logs produits pour les tâches 3, 4, 5.

Ces modifications ont ensuite été révisées par PLN-003 (tâche 7) pour s'aligner sur le dépôt source.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
