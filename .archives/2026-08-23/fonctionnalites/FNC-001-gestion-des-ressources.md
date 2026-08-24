---
type: fonctionnalite
id: FNC-001
title: "Gestion des ressources"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "livree"
etat: livree
usage: clia res ls|new|show|edit|check
---

# FNC-001 - Gestion des ressources

> Créer, lister et consulter les ressources typées du dépôt, sans jamais en rédiger le contenu.

## Ce qu'elle fait

Elle attribue les numéros de séquence, pose les champs que chaque définition déclare obligatoires, et écrit les rubriques annoncées. Elle liste les types connus avec leur nombre d'instances, et les instances d'un type avec leur état.

`ADR-003` D5 fixe sa frontière : `clia` garantit la forme, l'agent et l'humain rédigent le fond.

## Comment s'en servir

```sh
clia res ls                      # les types connus, et leurs instances
clia res ls objection            # les instances d'un type, avec leur etat
clia res new objection "Titre"   # créer, numéro attribué
clia res show NON-005            # afficher
clia res check                   # signaler un champ obligatoire constant
```

Le type se désigne par son nom, son préfixe ou son pluriel, sans distinction de casse : `objection`, `NON`, `objections`.

## Ce qu'elle ne fait pas

Elle ne valide pas le contenu : `ISU-007` réclame un outil de validation qui n'existe pas.

Elle ne ferme rien. `clia res check` signale, il ne corrige pas.

## Ce qui la porte

`lib/clia/resource.sh`. Livrée par `PLN-006`, étendue par `PLN-007` chantier G et `PLN-011`.

## Relations

- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [ISU-007](../issues/ISU-007-validation-et-portee-des-ressources.md)
