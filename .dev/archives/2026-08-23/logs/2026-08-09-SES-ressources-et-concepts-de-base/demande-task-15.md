# Demande interprétée, tâche 15

## Énoncé

Tâche 15 de `workspace/session.md`, classée `[bogue]` :

> Les ressources RES devraient être décrites de manière directive et factuelle.
>
> Or, l'agent IA justifie sans cesse ses décisions comme s'il avait peur des reproches... À la limite, si des références externes sont nécessaires, les écrire sous la forme d'une bibliographie (liste numérotée de références externes). Mais NE PAS EXPLIQUER POURQUOI ON A PRIS UNE DÉCISION.
>
> Diagnostiquer ce problème. En trouver la cause et proposer un correctif.
>
> Faire un plan de remédiation incluant (sans s'y limiter) : 1. la correction des harnais pertinents, 2. la correction des ressources RES.

## Intention

Trois livrables sont demandés, dans cet ordre : un diagnostic, une cause, un correctif. Puis un plan de remédiation.

Le classement en `[bogue]` fixe le régime : ce n'est pas une question ouverte. La demande n'est pas contestée.

## Contexte

Le défaut visé est produit par l'agent et il est présent dans le travail livré le jour même : `RES-009` v0.2.0, produit à la tâche 14, consacre 24,3 pour cent de son texte à des sections méta-justificatives.

Trois documents portent la forme d'une définition de type : `skl-001` partie B, le gabarit `.dev/templates/ressource.template.md`, et le champ `sections` de chaque définition. Les trois divergent.

## Portée retenue

**Dans la portée.** Le type `ressource`, `RES`, ses trente instances, et les harnais qui commandent leur rédaction.

**Hors portée.** L'exécution de la remédiation. La demande dit « proposer un correctif » et « faire un plan », non l'appliquer.

**Signalé et non traité.** Le même défaut existe dans les autres familles. La mesure est portée par le diagnostic, la correction n'est pas demandée.

## Ressources livrables

| Livrable | Nature |
|---|---|
| `ANL-004` | Création. Diagnostic, mesures, causes, correctif |
| `PLN-002` | Création. Plan de remédiation, chantiers, ordre, coût |

## Ordre de travail

| Type de livrable | Type de travail | Skill |
|---|---|---|
| `ANL` | Création | `skl-003-ressource-de-conception` |
| `PLN` | Création | `skl-006-ressource-de-preparation` |

## Contrainte de rédaction appliquée à cette tâche

Les deux livrables sont rédigés dans le registre demandé : directif et factuel, sans justification des choix de l'agent.

Un diagnostic énonce des causes. Une cause de défaut est un fait mesuré, non la défense d'une décision de rédaction.

## Conformité de la demande

Conforme. La tâche est inscrite au fichier de session et son exécution est demandée explicitement.
