# Interprétation de la demande, tâche 3

## Demande

Tâche 3 de `workspace/session.md`, intitulée `[conception] définition d'une ressource` :

1. écrire un premier jet documentant l'adoption de la notion de ressource, sous forme d'ADR ;
2. écrire un premier document contenant les directives d'écriture et de validation d'une ressource, sous forme de skill.

## Intention

Compléter le triplet du type `ressource` : la définition existe depuis la tâche 2, il manquait la décision qui l'acte et le processus qui la produit.

## Ce que la demande tranche implicitement

La tâche 2 avait laissé ouverte la question portée par `NON-002` Q1 : le triplet définition, décision, processus est-il exigible pour tous les types simultanément ? En demandant l'ADR et le skill pour un seul type, la tâche 3 répond de fait par la négative et valide la progression type par type.

Cette lecture a été inscrite dans `ADR-001` comme décision D6, et l'index des ressources en porte la conséquence. La question reste formellement ouverte dans `NON-002` Q1, faute de réponse écrite de l'humain.

## Portée retenue

`ADR-001` porte sur la notion de ressource, pas sur les sept types. Les décisions D1 à D9 concernent la ressource comme unité du travail, sa forme, son identité, son cycle de vie, son régime d'édition, son triplet documentaire, son auto-application, ses exclusions et sa validation.

`skl-001-ressource` couvre deux niveaux, parce que `RES-001` est le méta-type et que dupliquer les règles communes dans sept skills reproduirait le défaut mesuré par `ANL-001` au titre de la propagation. Partie A : les règles valables pour toute ressource, quel que soit son type. Partie B : la production d'une définition de type.

## Directives inexécutables constatées et traitement retenu

| Directive de `CLAUDE.md` | État | Traitement |
|---|---|---|
| Un skill encadre la production d'un ADR (`skl-006-adr` dans le corpus) | N'existe pas dans `clia` | Format dérivé de `ADR-008` du dépôt `micrologic-clients`, avec les puces d'en-tête déplacées dans le frontmatter, comme le prescrivait le `CLAUDE.md` archivé |
| Un skill encadre la production d'un skill (`skl-001-skill-writer` dans le corpus) | N'existe pas dans `clia` | Convention de frontmatter reprise des skills du corpus (`type`, `name`, `description`), augmentée de `id` conformément à `ADR-001` D3 |
| La validation des ressources est assurée par `clia` | Aucun exécutable dans le dépôt | `ADR-001` D9 déclare la validation humaine et outillée par des contrôles textuels, et `skl-001` les fournit. Position déclarée temporaire |
| Journalisation par répertoire `<DATE>-SES-<SLUG>` | Le harnais ne dit pas comment journaliser trois tâches d'une même session | Fichiers suffixés `-task-03`, comme pour la tâche 2 |

## Effets de bord assumés

Trois fichiers produits par la tâche 2 ont été modifiés, parce que la tâche 3 rend faux ce qu'ils déclaraient.

`RES-001-ressource.md` passe en version 0.2.0 : ses champs `skill` et `adr` valaient `aucun` et sont désormais renseignés. Sa section d'auto-application et son objet ont été corrigés en conséquence, et sa section de relations complétée.

`.dev/ressources/index.md` reflète le triplet complet de `RES-001` et rectifie sa section sur ce qui n'est pas produit.

Aucun autre fichier n'a été touché. `CLAUDE.md` reste intact.
