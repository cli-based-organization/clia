---
type: decision
id: DCN-006
title: "La spécification du système est strictement distincte de son implémentation"
version: 0.1.0
status: draft
instance: "human:jvtrudel"
date-de-decision: 2026-08-09
portee: systeme
effet: en-vigueur
attestation: interne
diffusion: public
---

# DCN-006 - La spécification du système est strictement distincte de son implémentation

> Décision de l'humain, prise le 2026-08-09 dans la tâche 10 de la session : distinguer de manière stricte la spécification du système `clia` de son implémentation.

## Objet

Enregistrer une décision de nature, afin qu'elle soit citable indépendamment de l'ADR qui l'instruit.

## La décision

Reprise de la tâche 10 de `workspace/session.md`, dont l'énoncé tient dans son titre :

> Distinguer de manière stricte la spécification du système `clia` de son implémentation.

L'adverbe **strictement** est ce qui distingue cette décision d'un simple rangement. Il exige que la frontière soit vérifiable et qu'aucun artefact ne soit des deux côtés.

## Motivation du changement

Sans objet, cette décision n'en remplace aucune.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt, dans la tâche 10 de la session ouverte le 2026-08-09. La demande accompagnait l'instruction de produire une DCN en `draft` et un premier jet d'ADR.

## Portée

`systeme`. La décision porte sur l'organisation de tout le corpus `clia`, spécification et implémentation confondues jusqu'ici.

## Conséquences

| Conséquence | Où elle est instruite |
|---|---|
| Un critère de départage en une question : l'artefact reste-t-il vrai si l'on change de langage | `ADR-006` D1 |
| La spécification ne nomme aucune technologie | `ADR-006` D2 |
| Toute implémentation déclare ce qu'elle implémente | `ADR-006` D3 |
| La spécification doit survivre à la suppression de l'implémentation | `ADR-006` D4 |
| Une spécification manquante est une dette nommée, non tolérée en silence | `ADR-006` D5 |
| Les schémas et gabarits dérivés sont de l'implémentation | `ADR-006` D6 |
| Aucun fichier n'est déplacé : c'est une décision de nature, non de rangement | `ADR-006` D7 |

**La conséquence la plus mesurable.** La décision rend visible une dette qui l'était pas : `clia` compte 1 600 lignes de bash et quatre-vingt-onze tests, face à zéro spécification. Les types `SPC`, `RQF`, `RQNF`, `USE` et `CMP` sont définis et n'ont aucune instance.

**Le test que la décision rend exécutable.** Supprimer `bin/`, `lib/`, `tests/`, `.dev/schemas/` et `.dev/templates/` ne doit rien retirer à la compréhension du système. Appliqué aujourd'hui, le test échoue sur la grammaire du CLI, qui n'existe que dans le code.

## Ce que la décision ne dit pas

Elle ne dit pas où chaque corpus doit vivre. `ADR-006` D7 en tire qu'aucun déplacement n'est requis.

Elle ne dit pas de quel côté tombent les skills. `ADR-006` D1 les range en implémentation, avec une réserve explicite.

Elle ne dit pas ce qu'il faut faire des documents existants qui violent la règle d'agnosticisme, dont `ADR-001` D2 qui nomme deux formats de fichier.

Elle ne dit pas si l'absence de spécification interdit d'implémenter. `ADR-006` D5 se contente d'en faire une dette nommée, ce qui est plus faible qu'une interdiction.

Elle ne dit rien du risque symétrique, celui de spécifier sans jamais implémenter, dont le corpus offre un exemple mort avec `disruptiva-dev/comm-cli`.

## Relations

- `specifie` [ADR-006](../adr/ADR-006-separation-specification-implementation.md)
- `reference` [ANL-002](../analyses/ANL-002-localisation-du-cli-clia.md)
