---
type: fonctionnalite
id: FNC-005
title: "Consultation des registres"
version: 0.1.0
status: draft
etat: livree
usage: clia reg ls|show
---

# FNC-005 - Consultation des registres

> Lire un registre et suivre ses renvois vers les ressources qu'il désigne.

## Ce qu'elle fait

Un registre est une vue : il liste des ressources avec leur description et leur statut, sans porter de contenu propre. `show` affiche l'item puis la ressource désignée.

## Comment s'en servir

```sh
clia reg ls              # les registres du dépôt
clia reg ls REG-001      # les items d'un registre
clia reg ls 1            # le numéro seul suffit
clia reg show REG-001 3  # l'item 3, puis la ressource qu'il désigne
```

## Ce qu'elle ne fait pas

Elle ne tient pas les registres à jour : `NON-029` porte la question du mode de tenue.

Un seul registre existe dans ce dépôt.

## Ce qui la porte

`lib/clia/registre.sh`, `RES-035`. Livrée par la tâche 28 de `SES-001`.

## Relations

- `reference` [RES-035](../ressources/RES-035-registre.md)
