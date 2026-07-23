---
type: principe
version: 0.1.0
title: "Découvrabilité et uniformité"
status: accepté
date: 2026-07-18
---

# PDC-007 - Découvrabilité et uniformité


## Énoncé

Toute commande et toute sous-commande d'un CLI produit par le harnais est découvrable et documentée de façon uniforme ; l'inventaire réellement dispatché est identique à l'inventaire documenté.

## Justification

Un système professionnel et robuste ne cache aucune de ses capacités et les présente de façon cohérente. La découvrabilité rend l'outil utilisable sans connaissance préalable ; l'uniformité rend l'aide prévisible ; la cohérence dispatch/documentation empêche la dérive entre ce que l'outil fait et ce qu'il dit faire.

## Portée

L'interface de `clia` et de tout CLI produit par le harnais (`REQ-001`).

## Implications

- Impose que `outil -h` liste toutes les commandes/groupes et que `outil GROUPE -h` liste toutes ses sous-commandes.
- Impose un format d'aide identique aux trois niveaux (supérieur, groupe, sous-commande).
- Impose un contrôle de cohérence : toute commande dispatchée est documentée, et réciproquement.
- Interdit qu'une commande implémentée soit absente de l'aide.

## Critères de conformité

- Pour chaque commande/sous-commande implémentée, elle apparaît dans l'aide du niveau qui la contient (`REQ-001-F7`).
- L'aide courte et longue sont générées depuis la même source, au même format (`REQ-001-F8`).
- Le contrôle de cohérence dispatch/documentation passe (`REQ-001-F9`).

## Tensions

- Un bogue historique (le groupe `ses` absent de `clia -h`) a motivé la réconciliation (`PLN-011`), non entièrement exécutée : écart partiel entre le principe et l'implémentation (voir bogue associé).

## Références

- `REQ-001-convention-cli-bash` (F7/F8/F9), `SPEC-001-convention-cli-bash`, `SPEC-002-cli-clia`
- `ANL-010-principes-de-conception-du-repo` (P7)
