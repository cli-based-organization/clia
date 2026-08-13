---
type: decision
id: DCN-002
title: "Les ressources sont regroupées selon leur fonction"
version: 0.1.0
status: draft
maturity: conception
adoption: adopte
activated: true
domain-status: "en-vigueur"
instance: "human:jvtrudel"
date-de-decision: 2026-08-09
portee: systeme
effet: en-vigueur
attestation: interne
diffusion: public
---

# DCN-002 - Les ressources sont regroupées selon leur fonction

> Décision de l'humain, prise le 2026-08-09 dans la tâche 8 de la session : les types de ressources sont regroupés en six familles définies par leur fonction.

## Objet

Enregistrer une décision de classement qui commande la structure du modèle de ressources, afin qu'elle soit citable indépendamment de l'ADR qui l'instruit.

## La décision

Reprise mot pour mot de la tâche 8 de `workspace/session.md` :

> Nous décidons ceci => les ressources sont regroupés en fonction de leur fonction :
> - fondamentale
> - de conception
> - de contrôle
> - de contenu (FRG, DCN, ...)
> - de préparation/planification
> - d'implémentation (COD, PRS, ...)

Six familles. Deux d'entre elles reçoivent des exemples dans l'énoncé, les quatre autres non.

## Motivation du changement

Sans objet, cette décision n'en remplace aucune.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt, dans la tâche 8 de la session ouverte le 2026-08-09. La formulation « Nous décidons ceci » est un acte, non une proposition soumise à l'agent.

## Portée

`systeme`. La décision porte sur l'organisation du modèle de ressources de `clia`, pour tous les types existants et à venir.

## Conséquences

| Conséquence | Où elle est instruite |
|---|---|
| Chaque définition de type déclare un champ `famille` obligatoire | `ADR-005` D2 |
| Les vingt-neuf types connus reçoivent une famille | `ADR-005` D3 |
| Le processus de production est attaché à la famille et non au type | `ADR-005` D4 |
| Le log et la session ne sont dans aucune famille, étant des traces | `ADR-005` D5 |
| La famille ne détermine pas l'emplacement des instances | `ADR-005` D6 |
| `clia res ls` doit afficher une colonne de plus | Implémentation à faire |

**Conséquence sur le volume de travail.** La décision `ADR-005` D4 est celle qui change l'ordre de grandeur : le nombre de processus à écrire passe de vingt-neuf à six. C'est une proposition de l'agent, distincte de la présente décision, et soumise à arbitrage par `NON-017`.

**Conséquence sur une objection ouverte.** `NON-002`, qui conteste le coût du modèle, reçoit une réponse partielle par ce même mécanisme.

## Ce que la décision ne dit pas

Elle ne dit pas quels types appartiennent à quelle famille, sauf pour quatre exemples : `FRG` et `DCN` en contenu, `COD` et `PRS` en implémentation. L'attribution des vingt-cinq autres est un travail de l'agent, et chaque arbitrage est signalé dans `ADR-005` D3.

Elle ne dit pas ce que la famille commande. `ADR-005` D4 propose qu'elle porte le processus de production ; rien dans l'énoncé ne l'impose.

Elle ne dit pas si un type peut appartenir à plusieurs familles.

Elle ne dit pas où ranger les traces, log et session, que les six familles n'accueillent pas.

Elle emploie le préfixe `COD` pour le code, là où `CLAUDE.md` emploie `CDE`. L'écart est signalé et non tranché.

## Relations

- `specifie` [ADR-005](../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [NON-002](../objections/NON-002-cout-du-modele.md)
