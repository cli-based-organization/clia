---
type: principe
version: 0.1.0
title: "Gouvernance objection-sociocratique"
status: accepté
date: 2026-07-18
---

# PDC-008 - Gouvernance objection-sociocratique


## Énoncé

L'agent propose une intervention sous forme de plan et ne peut l'exécuter tant qu'une objection raisonnée (humaine ou agent) reste ouverte.

## Justification

Ce mode de gouvernance garantit que rien n'est exécuté sans que les risques concrets aient été soulevés et traités, tout en laissant l'agent proposer activement (il n'exécute pas une demande à la lettre s'il y voit un risque). Il place le contrôle au bon endroit sans bloquer l'initiative.

## Portée

Tout le cycle de travail entre l'humain et l'agent (proposition, objection, exécution).

## Implications

- Impose la production d'un plan avant toute exécution d'une intervention.
- Impose à l'agent de soulever ses propres objections dans le plan.
- Interdit toute exécution d'un segment de plan tant qu'une objection le concernant reste ouverte (l'approbation partielle et les breakpoints nuancent, pas suppriment, cette règle).

## Critères de conformité

- Toute intervention non triviale est précédée d'un plan.
- Aucun segment n'est exécuté sous objection ouverte (`CONSTITUTION.md`, « Règle absolue » et « Breakpoint et exécution segmentée »).

## Tensions

- Avec la rapidité : le cycle ajoute des étapes ; le breakpoint et l'exécution segmentée atténuent ce coût.

## Références

- `CONSTITUTION.md` (« Principe », « Règle absolue », « Breakpoint et exécution segmentée »)
- `ANL-010-principes-de-conception-du-repo` (P8)
