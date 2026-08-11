---
type: adr
id: ADR-015
title: "Registre directif et gabarit des définitions"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-10
decideurs: ["human:jvtrudel (décideur)", "claude-opus-5 (rédaction)"]
sources:
  - ANL-004
  - PLN-002
  - DCN-009
  - "workspace/session.md, tâches 15 et 17"
definition-associee: RES-001
---

# ADR-015 - Registre directif et gabarit des définitions

> Instruit `DCN-009`. Le gabarit d'une définition perd ses deux rubriques justificatives, une règle de registre et un contrôle sont ajoutés au harnais, et six `ADR` d'adoption accueillent la justification retirée.

## Statut

`propose`. Les cinq décisions sont exécutées depuis le 2026-08-10.

## Contexte

`ANL-004` établit la cause du défaut par trois mesures sur les trente définitions.

| Mesure | Valeur |
|---|---|
| Part du texte en rubrique méta-justificative | **20,8 pour cent**, 3 724 mots sur 17 922 |
| Marqueurs lexicaux de justification | 146 |
| Reprise des deux rubriques méta du gabarit `skl-001` B3 | **30 définitions sur 30** |
| Reprise des rubriques descriptives du même gabarit | 1 à 13 sur 30 |

Le harnais était suivi là où il justifiait et reformulé là où il prescrivait. L'agent appliquait le gabarit ; le défaut y était prescrit.

`skl-001` portait la contradiction dans un seul document : B1 ligne 122 assigne le pourquoi à l'`ADR`, B3 ligne 168 prescrit `## Le problème que ce type résout` dans la définition.

Deuxième cause : le foyer désigné par B1 n'existait pas. Vingt-neuf types sur trente n'avaient aucun `ADR` d'adoption, et vingt-trois pointaient vers `ADR-005`, qui décide le regroupement en familles.

## Décision en une phrase

Une définition dit ce qu'est un type ; l'`ADR` d'adoption de sa famille dit pourquoi il existe ; le journal de la tâche dit comment il a été produit.

## Décisions détaillées

### D1 - Le gabarit d'une définition perd ses rubriques méta

**Décision.** `skl-001` B3 prescrit onze rubriques, toutes descriptives.

```
## Objet
## Ce qu'est <le type>
## Ce que <le type> n'est pas
## Champs propres
## Test d'admission
## Cycle de vie et versionnage
## Régime d'édition
## Frontière avec les types voisins
## Structure attendue d'une instance
## Relations
## Points ouverts
```

**Ce qui est retiré.** `Statut de ce document` et `Le problème que ce type résout`.

**Ce qui est conservé.** `Points ouverts`, réduit à une table de deux colonnes, question et objection. Une lacune n'est pas une justification, et `RES-004` en dépend.

**Trois corrections connexes au même gabarit.** Le frontmatter montrait quatorze champs là où `RES-001` en déclare seize ; `famille` et `sections` sont ajoutés. Il prescrivait `id: RES-<slug>`, forme abolie par `ADR-007` le 2026-08-09. Et la mention déclarant non optionnelles trois rubriques est conservée mais rendue exacte.

### D2 - La règle de registre A6

**Décision.** `skl-001` porte une règle `A6`, cinq interdits et deux obligations.

Interdits : défendre un choix de rédaction, comparer avec une version antérieure du document, raconter la production, justifier une propriété du type, rapporter un débat non tranché dans le corps.

Obligations : les références externes prennent la forme d'une bibliographie numérotée ; une mesure citée décrit le type, jamais la décision de l'écrire.

**Motif.** `ANL-004` C7 mesure que `skl-001` A3 portait cinq règles d'écriture, trois de typographie et deux de fond, et aucune de registre. La contradiction entre B1 et B3 n'était arbitrée par rien.

### D3 - Le contrôle V10

**Décision.** Un dixième contrôle est ajouté à la section Validation, exécutable par `grep` sur les titres de niveau 2. Les six skills de famille renvoient désormais à `V1 à V10`.

**Limite déclarée.** Le contrôle est une liste noire. Il détecte les rubriques nommées, non une justification logée dans une rubrique descriptive, qui était le cas de la majorité des 146 marqueurs mesurés.

### D4 - Six ADR d'adoption, un par famille

**Décision.** Six `ADR` sont créés, `ADR-009` à `ADR-014`, un par famille de `ADR-005`. Chacun porte, pour chaque type de sa famille, le problème qu'il résout et l'état de la matière sur laquelle il repose.

**Alternative écartée.** Un `ADR` unique pour les trente types. Écartée : un document de trente adoptions ne serait relu par personne, et le découpage par famille existait déjà.

**Conséquence sur le champ `adr`.** Les trente définitions le font passer de `ADR-005` à l'`ADR` d'adoption de leur famille. Le champ était faux depuis le 2026-08-10 : `ADR-005` décide le regroupement, non l'adoption.

### D5 - Les trente définitions sont réécrites

**Décision.** Les rubriques méta sont retirées, leur contenu déplacé dans l'`ADR` d'adoption, et les marqueurs de justification retirés du corps.

**Résultat mesuré.**

| Mesure | Avant | Après |
|---|---|---|
| Mots dans les trente définitions | 22 236 | **18 511**, soit **-16 pour cent** |
| Rubriques méta | 30 définitions sur 30 | **0** |
| Marqueurs « ce jet », « premier jet » | 59 | **0** |
| `RES-009`, la plus atteinte | 2 797 mots | **1 537**, soit **-45 pour cent** |

`RES-009` a été réécrite entièrement, les vingt-neuf autres par retrait des rubriques puis correction ciblée des marqueurs.

## Conséquences

**Le défaut est spécifique aux définitions.** Mesure du 2026-08-10 sur les autres types, chantier E de `PLN-002`.

| Type | Fichiers | Part méta |
|---|---|---|
| `ADR` | 14 | 2 pour cent |
| `DCN` | 8 | 5 pour cent |
| `MET`, `NON`, `PDC`, `ANL` | 32 | **0 pour cent** |

Aucune correction n'est nécessaire hors des définitions, ce qui confirme que la cause était le gabarit `skl-001` B3, qui ne s'appliquait qu'à elles.

**Ce que le dépôt gagne.** Trois documents distincts au lieu d'un : la définition dit ce qui est, l'`ADR` dit pourquoi, le journal dit comment.

**Ce que le dépôt perd.** La date de production et le numéro de tâche de chaque définition ne sont plus dans la définition. Ils sont dans l'`ADR` d'adoption de sa famille, sous une forme agrégée et moins précise.

## Objections ouvertes

`NON-002`, bloquante, sur le coût du modèle : cette décision ajoute six documents.

`NON-005`, bloquante, sur les règles écrites et non tenues. `V10` est écrit et exécutable à la main ; il n'est pas outillé.

## Relations

- `derive-de` [DCN-009](../decisions/DCN-009-registre-directif-des-definitions.md)
- `derive-de` [ANL-004](../analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md)
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
