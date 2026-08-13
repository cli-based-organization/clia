---
type: fonctionnalite
id: FNC-006
title: "Configuration de l'utilisateur"
version: 0.1.0
status: draft
etat: livree
usage: clia config ls|set|edit|path
---

# FNC-006 - Configuration de l'utilisateur

> Régler `clia` par utilisateur, hors du dépôt, pour qu'un dépôt équipé reste identique d'un poste à l'autre.

## Ce qu'elle fait

La configuration vit à l'emplacement prescrit par la convention XDG. Elle est lue ligne à ligne, jamais exécutée : un fichier de configuration ne doit pas pouvoir exécuter du code.

Trois origines, de la plus forte à la plus faible : l'environnement, le fichier, le défaut. `ls` affiche l'origine effective de chaque variable.

## Comment s'en servir

```sh
clia config ls              # variables, valeurs, origines
clia config set EDITOR nvim # assigner ; le préfixe CLIA_ est facultatif
clia config edit            # ouvrir le fichier
clia config path            # afficher son chemin
```

## Ce qu'elle ne fait pas

Elle ne valide pas les valeurs. Une clé inconnue est enregistrée et signalée, mais aucune commande ne la lira.

## Ce qui la porte

`lib/clia/config.sh`, `lib/clia/core.sh`.

## Relations

- `reference` [FNC-001](FNC-001-gestion-des-ressources.md)
