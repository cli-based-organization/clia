---
type: registre
id: REG-001
title: "Registre des décisions"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "saisie"
registre-de: décisions
tenue: saisie
---

# REG-001 - Registre des décisions

> Les treize décisions du dépôt, avec leur état. Le registre désigne ; il ne décide de rien, et il ne porte la teneur d'aucune décision.

## Objet

Rendre visible d'un seul regard l'ensemble des `DCN`, que `DCN-013` désigne comme l'autorité ultime en matière de décision.

`DCN-013` exige que l'ensemble des décisions soit auto-cohérent. Ce registre est ce qui rend cette exigence lisible ; il ne la vérifie pas.

## Portée

Toutes les instances de `.dev/decisions/`, au 2026-08-11.

Ne porte pas les décisions d'architecture, `ADR`, qui dérivent des décisions et ne les portent pas, depuis `ADR-017` D5.

## Items

| SEQ | RESSOURCE | DESCRIPTION | STATUS |
|---|---|---|---|
| 001 | DCN-001 | La ressource est un ensemble composable et atomique d'informations | en-vigueur |
| 002 | DCN-002 | Les ressources sont regroupées selon leur fonction | en-vigueur |
| 003 | DCN-003 | Adoption de la notion de ressource | proposee |
| 004 | DCN-004 | Adoption du processus de travail collaboratif | proposee |
| 005 | DCN-005 | Adoption de l'usage d'un CLI extensible | proposee |
| 006 | DCN-006 | La spécification du système est strictement distincte de son implémentation | en-vigueur |
| 007 | DCN-007 | L'identifiant interne d'une ressource est PREFIX-SEQ | en-vigueur |
| 008 | DCN-008 | L'identifiant interne est un alias, l'identité est celle de l'oeuvre | en-vigueur |
| 009 | DCN-009 | Les ressources sont rédigées dans un registre directif et factuel | en-vigueur |
| 010 | DCN-010 | clia opère le suivi de l'historique des ressources | en-vigueur |
| 011 | DCN-011 | Structure du système autour de la ressource | a-renseigner |
| 012 | DCN-012 | Frontière entre contexte, intention et faits | a-renseigner |
| 013 | DCN-013 | DCN est la source de vérité des décisions humaines | a-renseigner |

## Ce que le registre ne contient pas

**Il ne dit pas si une décision est approuvée.** `FCT-001` établit que les treize ont été rédigées par l'agent et qu'aucune n'est approuvée. Le statut repris ici est le champ `effet`, qui dit l'état déclaré, non l'approbation.

**Il ne porte pas les trois décisions dont le frontmatter est incomplet.** `DCN-011`, `DCN-012` et `DCN-013` portent des champs `À RENSEIGNER`. Leur statut vaut `a-renseigner` dans ce registre, ce qui n'est pas une valeur du champ `effet` : c'est un constat du registre.

**Il n'est pas dérivé.** Son champ `tenue` vaut `saisie`. Toute décision ajoutée, retirée ou changée d'état doit y être reportée à la main. C'est la quatrième obligation de propagation non outillée du dépôt.

**Il ne porte aucune décision d'architecture.** Les dix-sept `ADR` du dépôt dérivent des décisions depuis `ADR-017` D5. `NON-026` Q1 demande de les rendre non actifs, et la question est ouverte.

## Relations

- `reference` [RES-009](../ressources/RES-009-decision.md)
- `reference` [FCT-001](../faits/FCT-001-ressources-d-autorite-redigees-par-l-agent.md)
