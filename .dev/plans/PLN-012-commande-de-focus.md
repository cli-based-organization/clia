---
type: plan
id: PLN-012
title: "Commande de focus"
status: draft
statut-plan: execute
date: 2026-08-13
initiateur: agent
sert: [FNC-007]  # livre clia focus
porte-sur: [lib/clia/focus.sh, bin/clia]
---

# PLN-012 - Commande de focus

> « Un humain a besoin de focus et d'une seule action claire à prendre pour pouvoir agir. » L'information existe, dispersée dans soixante et un fichiers. Ce qui manque n'est pas la donnée : c'est son agrégation.

## Statut

`execute`. Les deux chantiers ont été exécutés par la tâche 9 de `SES-002`, le 2026-08-13.

**Un écart déclaré** : le chantier A annonçait quatre catégories, l'implémentation en compte cinq. Les bogues ouverts sont des items ouverts, et le critère exigeait que chacun reçoive une catégorie.

**Le chantier A a d'abord échoué.** Réexécuté à la reprise de la tâche, son critère — *chaque* item ouvert reçoit une catégorie — a montré que trois items disparaissaient : `NON-013` sans champ `etat`, `BUG-001` et `BUG-003` dont le gabarit n'est pas rempli. Corrigé le 2026-08-13, cinq assertions ajoutées.

## Intention

Que le dépôt réponde à « que dois-je faire maintenant ? ».

**Cible mesurable.** `clia focus` affiche **une** action, et la commande qui l'exécute.

## Chantiers

### Chantier A - Le classement des choses en attente

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/focus.sh`, fonction de classement |
| **Critère de réussite** | Chaque item ouvert du dépôt reçoit exactement une catégorie et un destinataire |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Les quatre catégories, et à qui elles s'adressent.**

| Catégorie | Destinataire | Ce qui la remplit |
|---|---|---|
| À décider | l'humain | Objection sans réponse |
| À clore | l'agent | Objection répondue, non close |
| À exécuter | l'agent | Plan proposé et SMART |
| À défricher | les deux | Issue ouverte |

### Chantier B - La commande, et son unique recommandation

| Élément | Valeur |
|---|---|
| **Livrable** | `clia focus` |
| **Critère de réussite** | La sortie tient en dix lignes et nomme une seule action suivante |
| **Limite de temps** | 1 heure 30 |
| **Dépend de** | A |

**L'ordre de priorité.** Ce qui débloque le plus grand nombre d'autres items d'abord ; à égalité, le plus ancien.

**Ce que la commande ne fait pas.** Elle n'exécute rien. Elle nomme l'action et la commande qui la ferait.

## Objections de l'agent

**L'ordre de priorité est un jugement de l'agent.** « Ce qui débloque le plus » se calcule sur les relations déclarées, et celles-ci sont incomplètes.

**Une commande de plus n'est pas moins d'information.** Si l'humain doit encore lire les soixante et un fichiers pour agir, la commande n'aura servi à rien.

## Relations

- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
