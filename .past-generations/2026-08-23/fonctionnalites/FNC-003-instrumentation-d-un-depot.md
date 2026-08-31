---
type: fonctionnalite
id: FNC-003
title: "Instrumentation d'un dépôt"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "livree"
etat: livree
usage: clia setup check|init [PATH] [--dev]
---

# FNC-003 - Instrumentation d'un dépôt

> Faire sortir `clia` de son propre dépôt : diagnostiquer un dépôt tiers, puis l'équiper sans rien y écraser.

## Ce qu'elle fait

`check` rend un diagnostic sans rien écrire, contre les onze critères de `SPC-001`. `init` équipe le dépôt, le crée s'il n'existe pas, et garantit cinq choses : tout critère bloquant devient vrai, aucun emplacement occupé n'est écrasé, le dépôt source n'est pas modifié, ce qui est conservé est annoncé, et relancer ne dégrade rien.

## Comment s'en servir

```sh
clia setup check ~/git/mon-projet     # peut-on l'instrumenter ? est-il conforme ?
clia setup init ~/git/mon-projet      # équiper, en copiant les fichiers de harnais
clia setup init ~/git/mon-projet --dev # équiper, en liant vers le dépôt source
```

`--dev` pose des liens symboliques relatifs : une modification du dépôt `clia` est immédiatement visible dans le dépôt équipé.

## Ce qu'elle ne fait pas

**Elle ne met pas à jour.** `clia setup upgrade` n'existe pas : `ISU-012` recense les quatre livrables qui lui manquent, dont un mécanisme de migration.

Aucun dépôt réel n'a encore été instrumenté : tout a été éprouvé en dépôt jetable.

## Ce qui la porte

`lib/clia/setup.sh`, `SPC-001`. Livrée par `PLN-009`.

## Relations

- `reference` [SPC-001](../specs/SPC-001-conformite-d-un-depot-clia.md)
- `reference` [ISU-012](../issues/ISU-012-la-mise-a-jour-d-un-depot-instrumente-n-a-pas-d-objet.md)
