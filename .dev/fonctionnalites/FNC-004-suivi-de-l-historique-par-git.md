---
type: fonctionnalite
id: FNC-004
title: "Suivi de l'historique par git"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "livree"
etat: livree
usage: clia git check|save|log|diff
---

# FNC-004 - Suivi de l'historique par git

> Vérifier qu'un commit ne coupe pas l'historique d'une ressource, et réserver le commit à l'humain.

## Ce qu'elle fait

`check` applique les contrôles de `ANL-005`, dont T1 : une ressource supprimée et recréée sous le même alias est un renommage accompagné d'une réécriture, et git ne le signale pas. `log` et `diff` suivent une ressource dans le temps.

## Comment s'en servir

```sh
clia git check clean       # l'arbre est-il propre ?
clia git check done        # les contrôles avant commit
clia git log NON-005       # l'historique d'une ressource
clia git diff NON-005      # ses changements
clia git save              # commiter — RÉSERVÉ À L'HUMAIN
```

## Ce qu'elle ne fait pas

`save` refuse de s'exécuter pour un agent, code 3 : `CONSTITUTION.md` C2.

Un hook `PreToolUse` complète la garde depuis le 2026-08-12 : `clia git save` seul ne couvrait pas `git commit` appelé directement, ce qui avait produit un commit non voulu le 2026-08-10.

## Ce qui la porte

`lib/clia/git.sh`, `.claude/hooks/refuser-git-en-ecriture.py`, `ANL-005`.

## Relations

- `reference` [ANL-005](../analyses/ANL-005-tracabilite-de-l-historique-des-ressources.md)
