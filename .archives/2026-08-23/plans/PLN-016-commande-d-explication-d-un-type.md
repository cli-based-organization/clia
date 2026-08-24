---
type: plan
id: PLN-016
title: "Commande d'explication d'un type"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "execute"
statut-plan: execute
date: 2026-08-13
initiateur: agent
sert: [FNC-001]  # livre clia res explain
porte-sur: [ADR-018, lib/clia/resource.sh]
---

# PLN-016 - Commande d'explication d'un type

> `ADR-018` D1 : tout type déclaré est explicable par le CLI, sans ouvrir aucun fichier. Trois chantiers, dont le premier porte l'essentiel.

## Statut

`execute`. **Les trois chantiers ont été exécutés par la tâche 14 de `SES-002`, le 2026-08-13**, dans la tâche qui a produit le plan.

**C'est un écart à `MET-005` étape 1, autorisé explicitement.** La tâche 14 pose la condition en toutes lettres : « si ce plan est SMART, implémenter la commande ». La condition a été vérifiée avant d'écrire une ligne de code — 3 chantiers, 3 livrables, 3 critères, 3 limites — et `BUG-002` reste la règle pour tout autre cas.

**Trois défauts trouvés en éprouvant**, tous corrigés : `paste -sd', '` alternait les deux caractères au lieu de séparer par l'un ; un champ sans énumération renvoyait un succès vide au lieu d'échouer, et ne s'affichait pas `libre` ; le dernier champ de la liste disparaissait, faute de saut de ligne final.

## Intention

Qu'un humain qui bute sur un type obtienne sa forme complète en une commande.

**Cible mesurable.** `clia res explain DCN-016` répond à la question que l'humain n'a pas pu résoudre en ouvrant les fichiers : quels champs porte une décision, quelles valeurs ils admettent, quel est son cycle de vie.

## Chantiers

### Chantier A - Extraire les valeurs admises du schéma

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/resource.sh`, fonction de lecture d'une énumération `cue` |
| **Critère de réussite** | Pour le type `decision`, la fonction retourne exactement les cinq valeurs de `effet` — `proposee`, `en-vigueur`, `suspendue`, `abrogee`, `remplacee` — et aucune de `attestation` ni de `diffusion` |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Le critère nomme le piège**, mesuré à la tâche 11 : une lecture naïve du bloc déborde sur les champs suivants, parce que la déclaration `cue` s'étend sur plusieurs lignes quand elle est longue. La déclaration s'arrête à la première ligne qui ne se termine pas par `|`.

### Chantier B - Le verbe `explain`

| Élément | Valeur |
|---|---|
| **Livrable** | `clia res explain <ID>`, synonyme `help` |
| **Critère de réussite** | `clia res explain DCN-016` et `clia res explain RES-009` produisent la **même** sortie, qui porte les huit rubriques déclarées ci-dessous, et sort en 0 |
| **Limite de temps** | 2 heures |
| **Dépend de** | A |

**Les huit rubriques**, toutes dérivées, aucune rédigée :

| Rubrique | Source |
|---|---|
| Préfixe et emplacement | Frontmatter du `RES` |
| Famille et cycle de vie | Frontmatter du `RES` |
| Régime d'édition | Frontmatter du `RES` |
| Champs obligatoires, avec leurs valeurs admises | `RES` **et** schéma `cue` |
| Valeurs de `domain-status` | Schéma `cue` |
| Relations admissibles | Frontmatter du `RES` |
| Sections attendues | Frontmatter du `RES` |
| Nombre d'instances, et le chemin de la définition | Comptage, et `RES` |

**`ADR-018` D3** : l'argument peut être une instance ou la définition. C'est ce que le critère éprouve en exigeant deux entrées et une seule sortie.

**`ADR-018` D4** : un champ dont le schéma ne contraint rien s'affiche `libre`, jamais omis.

### Chantier C - L'aide, selon PDC-001

| Élément | Valeur |
|---|---|
| **Livrable** | L'aide du verbe, et sa mention dans l'aide de `clia res` |
| **Critère de réussite** | `clia res explain --help` affiche l'usage **sans** exiger d'argument, et `clia res --help` liste le verbe |
| **Limite de temps** | 30 minutes |
| **Dépend de** | B |

**C'est la règle que `PDC-001` a été écrit pour faire tenir** : l'aide est reconnue avant toute validation d'argument. Six verbes sur sept la violaient lors de la session du 2026-08-09.

## Livrables attendus

| Livrable | Chantier | Durée |
|---|---|---|
| Lecture d'une énumération `cue` | A | 1 h |
| `clia res explain` | B | 2 h |
| L'aide du verbe | C | 30 min |
| | **Total** | **3 h 30** |

## Ce qui est écarté

**Expliquer un type qui n'a pas de définition `RES`.** Sans définition, il n'y a rien à dériver. La commande le dira plutôt que d'inventer.

**Documenter le sens.** `ADR-018` D5 : l'explication porte la forme, la définition porte le sens.

## Objections de l'agent

**Le plan dérive d'un ADR que j'ai rédigé.** `CONSTITUTION.md` C1 le réserve à l'humain ; la demande de la tâche 14 l'autorise pour ce cas.

**La qualité de la sortie dépend de celle des définitions.** Sur les dix-huit instances non conformes du dépôt, l'explication affichera `À RENSEIGNER`. C'est le comportement voulu — `ADR-018` D4 — et il rendra visible une dette qui ne l'était pas.

## Relations

- `derive-de` [ADR-018](../adr/ADR-018-la-documentation-d-un-type-est-fournie-par-le-cli.md)
- `reference` [PDC-001](../principes/PDC-001-auto-decouvrabilite.md)
