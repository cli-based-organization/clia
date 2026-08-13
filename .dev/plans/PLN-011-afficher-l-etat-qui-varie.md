---
type: plan
id: PLN-011
title: "Afficher l'état qui varie"
status: draft
statut-plan: execute
date: 2026-08-13
initiateur: agent
sert: [FNC-001]  # a livré l'affichage de l'état dans clia res ls
porte-sur: [lib/clia/resource.sh, ISU-008]
---

# PLN-011 - Afficher l'état qui varie

> `clia res ls` affiche `status`, qui vaut `draft` dans les 163 instances du dépôt. Il n'affiche jamais le champ qui varie. C'est `ISU-008`, ouverte à la demande de l'humain le 2026-08-11, redemandée le 2026-08-13.

## Statut

`execute`. Le chantier A a été exécuté par la tâche 9 de `SES-002`, le 2026-08-13.

## Intention

Que l'humain voie l'état réel d'une liste de ressources.

**Cible mesurable.** `clia res ls objection` affiche des valeurs différentes d'une ligne à l'autre.

## Chantiers

### Chantier A - Afficher le champ d'état propre au type

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/resource.sh`, verbe `ls TYPE` |
| **Critère de réussite** | `clia res ls objection` affiche au moins deux valeurs distinctes dans sa colonne d'état |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Ce que le chantier lit.** Le champ d'état propre déclaré par la définition du type : `etat` pour l'objection et l'issue, `statut-plan` pour le plan, `effet` pour la décision. À défaut, `status`.

**Ce qu'il ne fait pas.** Il n'attend pas `DCN-016` ni les quatre champs d'état. `PLN-007` chantier F y était lié et bloqué depuis deux jours ; celui-ci ne l'est pas.

**Le contrôle qui existe déjà.** `clia res check` signale un champ obligatoire constant : il servira à vérifier que la colonne affichée n'est pas constante.

## Objections de l'agent

**Ce chantier double `PLN-007` chantier F**, qui porte le même livrable et attend une décision suspendue. Deux plans pour un livrable est un défaut ; l'alternative était d'attendre encore.

## Relations

- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
- `reference` [ISU-008](../issues/ISU-008-le-statut-affiche-n-apprend-rien.md)
