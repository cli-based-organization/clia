---
type: adr
id: ADR-010
title: "Adoption des trois types de la famille contenu"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-10
decideurs: ["claude-opus-5 (rédaction)", "human:jvtrudel (à approuver)"]
sources:
  - ANL-001
  - FND-003
  - "workspace/session.md, tâche 8 du 2026-08-09"
  - PLN-002
definition-associee: RES-008
---

# ADR-010 - Adoption des trois types de la famille contenu

> Acte l'adoption de Fragment, Décision et Entrevue, les trois types par lesquels de la matière produite ailleurs entre dans le système.

## Statut

`propose`. Les trois types sont en usage depuis le 2026-08-10 ; leur adoption n'avait jamais été actée.

Créé par le chantier C de `PLN-002`.

## Contexte

Le système restreignait l'entrée d'information à un fichier markdown de session. La contrainte répondait à un besoin réel, l'entrée conventionnée et la journalisation des demandes, et elle rattachait toute entrée à un mécanisme de traitement unique.

`ANL-001` mesure le coût de cette contrainte : onze dépôts de technotes morts, dont six sans aucun fichier versionné, parce que le seul contenant disponible était disproportionné pour le besoin.

La tâche 8 de la session du 2026-08-09 demande d'étendre les entrées possibles. Trois types en résultent.

| Type | État dans le corpus |
|---|---|
| Fragment | Antécédent partiel : le répertoire `source-material`, dans dix dépôts observés, dont un `SRCM-001` conservé verbatim |
| Décision | **Aucun antécédent.** `ANL-001` ne relève aucun mécanisme d'enregistrement de décision externe dans cent soixante-six dépôts |
| Entrevue | Défini dans `micrologic-clients`, **jamais éprouvé** : sa définition n'a aucune instance |

## Décision en une phrase

Trois voies d'entrée sont adoptées, dont le mouvement commun est la captation : recueillir sans retoucher, puis annoter à côté.

## Décisions détaillées

### D1 - Fragment, `FRG`

**Problème résolu.** Abaisser le seuil d'entrée. Une matière textuelle auto-cohérente mérite d'entrer dans le système avant qu'on sache quoi en faire, et sans qu'il faille lui trouver un type définitif.

**Assise.** Le répertoire `source-material` en est l'antécédent partiel : il accueille du matériel externe, non ce que l'humain écrit lui-même.

**Ce que le type a produit.** `FRG-001`, capté par l'humain le 2026-08-10, a fourni la prémisse qui a renversé `ADR-001` D3 puis fondé `ADR-008`. Le type a démontré sa valeur en un jour.

### D2 - Décision, `DCN`

**Problème résolu.** Le corpus produit des `ADR`, qui actent des décisions de conception prises **dans** le dépôt. Il n'a aucun moyen d'enregistrer une décision prise **ailleurs** et qui contraint le travail.

Trois manques concrets, tirés de `ANL-001`. Vingt PDF réglementaires d'Élections Québec conservés comme documents et non comme décisions citables, dans `fondation-d-un-parti-politique`. Un registre de documents légaux partagés avec un tiers, dans `noumanity+qguard`, que rien ne modélise. Et les quatre ruptures de cap du corpus, décisions de l'humain sur son propre système, jamais enregistrées.

**Assise.** Aucune. Le type a été écrit sans antécédent, ce qui en fait le seul du dépôt défini sans matériau d'observation.

**Correction apportée par la littérature.** `FND-003`, produite à la tâche 14, comble ce manque par sept domaines. Elle établit que le mécanisme de changement du premier jet ne tient pas : un champ de statut n'est jamais mis à jour. Le droit fournit l'alternative, un acte motivé. `RES-009` v0.2.0 la transpose en trois règles.

**Coût assumé, et mesuré.** L'adoption des enregistrements de décision échoue par la charge documentaire, non par le format (Rösch et al., 2026). Le type est passé de neuf à onze champs obligatoires, soit une croissance de 22 pour cent, pour ajouter l'attestation d'authenticité et le régime de diffusion. `NON-022` conteste cet arbitrage avec ses chiffres.

### D3 - Entrevue, `ENT`

**Problème résolu.** Faire entrer une parole recueillie sans la reformuler.

**Assise.** Une définition dans `micrologic-clients`, avec un régime hybride, et zéro instance. `ANL-001` relève que le type n'y a jamais été éprouvé.

## Conséquences

Les trois définitions retirent leurs rubriques méta : leur contenu est ici.

Le champ `adr` des trois définitions passe de `ADR-005` à `ADR-010`.

**Le piège commun aux trois types.** Améliorer ce qu'on capte. C'est le réflexe d'un agent rédacteur, et il détruit la valeur de la famille. La règle est absolue et vit dans `skl-004` : l'agent n'édite jamais le bloc de matière.

## Objections ouvertes

`NON-015`, sur les mécanismes d'entrée et la frontière entre eux.

`NON-022`, sur la charge du type Décision et la tenue de son champ `effet`.

`NON-023`, sur le remplacement partiel d'une décision, lacune constatée à la première application réelle de `MET-002`.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `derive-de` [FND-003](../fondations/FND-003-decisions-institutionnelles-tracables.md)
- `specifie` [RES-009](../ressources/RES-009-decision.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
