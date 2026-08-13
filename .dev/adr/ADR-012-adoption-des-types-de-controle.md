---
type: adr
id: ADR-012
title: "Adoption des cinq types de la famille contrôle"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-decision: propose
date: 2026-08-10
decideurs: ["claude-opus-5 (rédaction)", "human:jvtrudel (à approuver)"]
sources:
  - ANL-001
  - PLN-002
definition-associee: RES-014
---

# ADR-012 - Adoption des cinq types de la famille contrôle

> Acte l'adoption des quatre harnais et du skill, les cinq types qui commandent le comportement de l'agent. Deux d'entre eux sont adoptés au statut `non-installe`.

## Statut

`propose`. Les cinq types sont définis depuis le 2026-08-10 ; leur adoption n'avait jamais été actée.

Créé par le chantier C de `PLN-002`.

## Contexte

Cette famille est la seule dont les instances ne sont pas des ressources ordinaires : ce sont les fichiers qui commandent l'agent. `ADR-001` D8 les place hors du modèle de nommage, et leur définition ne dit pas comment les produire mais ce qu'ils doivent contenir.

| Type | Fichier | État dans ce dépôt |
|---|---|---|
| Harnais opératoire | `CLAUDE.md` | Existe, **en défaut** |
| Harnais d'architecture | `ARCHITECTURE.md` | Existe, réduit à un titre et une liste de répertoires |
| Harnais constitutionnel | `CONSTITUTION.md` | **`non-installe`**, archivé le 2026-08-08 |
| Harnais de gouvernance | `GOUVERNANCE.md` | **`non-installe`**, n'a jamais existé ici |
| Skill | `.dev/skills/skl-<SEQ>-<nom>/SKILL.md` | 7 instances |

## Décision en une phrase

Cinq types de contrôle sont adoptés, dont deux au statut `non-installe`, et le statut d'un type est déclaré dans sa définition plutôt que déduit de l'existence de son fichier.

## Décisions détaillées

### D1 - Harnais opératoire, `CLAUDE.md`

**Problème résolu.** Fixer le point d'entrée du comportement de l'agent.

**État constaté.** Le fichier existe et il est en défaut. `ANL-001` établit au défaut D8 qu'il prescrit un système qui n'existe pas : vingt-sept types annoncés dont vingt-et-un sans instance, et quinze triplets de marque-places.

L'écart s'est creusé depuis : trente types sont définis et le fichier en annonce vingt-sept, et il documente deux commandes qui n'existent pas.

**Chantier ouvert.** `PLN-001` chantier A, en attente depuis le 2026-08-09.

### D2 - Harnais d'architecture, `ARCHITECTURE.md`

**Problème résolu.** Décrire la structure du dépôt, les répertoires conventionnels et les zones.

**État constaté.** Réduit à un titre et à une liste de répertoires. La meilleure référence disponible dans le corpus est celle de `personal-journal`, seul dépôt à porter les quatre fichiers de harnais avec un `ARCHITECTURE.md` renseigné.

### D3 - Harnais constitutionnel, `CONSTITUTION.md`

**Décision.** Type adopté, statut `non-installe`.

**État constaté.** Le fichier a été archivé le 2026-08-08 par le refactor, et son contenu a été repris par `ADR-002`.

**Motif du statut.** Un type peut être défini sans être installé dans un dépôt donné. Le déclarer évite qu'un contrôle traite son absence comme un défaut.

### D4 - Harnais de gouvernance, `GOUVERNANCE.md`

**Décision.** Type adopté, statut `non-installe`.

**État constaté.** Le fichier n'existe pas et n'a jamais existé dans ce dépôt.

### D5 - Skill, `skl`

**Problème résolu.** Encadrer la production d'un type de ressource, sans redire ce que la définition porte ni pourquoi le type existe.

**Assise.** Sept instances dans ce dépôt : un skill de méta-type et six skills de famille.

**Ce que l'histoire du premier skill établit.** `skl-001` a été corrigé deux fois par son propre usage, à la tâche 3 sur l'exclusion des blocs de code et à la tâche 4 sur la distinction entre mention et emploi d'un marqueur. Un skill se corrige en l'appliquant, pas en le relisant.

**Défaut corrigé le 2026-08-10.** `ANL-004` mesure que `skl-001` B3 prescrivait deux rubriques justificatives dans le gabarit de toute définition, reprises par 30 définitions sur 30, en contradiction avec sa propre règle B1. La règle A6 et le contrôle V10 corrigent ce défaut.

## Conséquences

Les cinq définitions retirent leur rubrique `Statut de ce document` : son contenu est ici.

Le champ `adr` des cinq définitions passe de `ADR-005` à `ADR-012`.

**Ce que la décision assume.** Deux types sur cinq sont adoptés sans instance et sans perspective d'en avoir une dans ce dépôt. C'est un pari sur l'équipement d'autres dépôts, que `NON-002` conteste.

## Objections ouvertes

`NON-002`, bloquante, sur le coût du modèle.

`NON-005`, bloquante, sur les règles écrites et non tenues. Le contrôle manuel des harnais de `PDC-001` échoue sur `CLAUDE.md`.

`NON-017`, bloquante, sur la frontière entre skill et méthodologie.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `specifie` [RES-014](../ressources/RES-014-harnais-operatoire.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
