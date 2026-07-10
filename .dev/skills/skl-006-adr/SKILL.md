---
name: skl-006-adr
description: >-
  Produire un Architecture Decision Record (`.dev/adr/ADR-<SEQ>-<SLUG>.md`) documentant une
  décision d'architecture ou de stack technique actée. À utiliser quand une décision technique
  structurante doit être tracée durablement, distincte d'une simple étape de plan.
---

# Skill - Rédaction d'un ADR

> Un ADR (Architecture Decision Record) documente une décision technique actée : le choix retenu, les alternatives écartées et pourquoi, les conséquences assumées. Il rend une décision traçable et révisable, indépendamment du plan qui a pu la motiver.

## Quand l'utiliser

Quand une décision d'architecture ou de stack technique significative doit être documentée : choix d'un langage/outil/framework, arbitrage entre alternatives, convention structurante pour un sous-système. Ne pas utiliser pour une intervention ponctuelle sans dimension décisionnelle durable (voir `skl-003-plan-de-travail`) ni pour une synthèse de recherche sans décision actée (voir `skl-002-recherche-de-fondation`). Un ADR peut s'appuyer sur un plan ou une fondation antérieurs, mais acte une décision, il ne les remplace pas.

## Processus

1. Identifier la décision à documenter : quelle question d'architecture/stack est tranchée, dans quel contexte, par qui, à quelle date.
2. Lister les alternatives considérées et les critères qui ont guidé le choix.
3. Énoncer la décision retenue de façon synthétique en tête de document (résumé actionnable, avant le détail).
4. Détailler la décision par sous-thème si elle est composite (ex. rendu, prétraitement, build, dépendances).
5. Lister les conséquences **positives et négatives** (compromis assumés, pas seulement les bénéfices).
6. Documenter une condition de révision ou une porte de sortie si la décision n'est pas figée définitivement.
7. Référencer les livrables sources ayant motivé la décision (plans, fondations, tickets).

## Critères de qualité

- Statut, date, décideurs présents en en-tête.
- Au moins une alternative écartée est mentionnée avec la raison de l'écartement, pas seulement la décision retenue.
- Les conséquences négatives/risques sont explicites, pas seulement les bénéfices.
- Un ADR documente une décision (ou un ensemble de décisions fortement couplées) ; pas un fourre-tout de plusieurs décisions indépendantes.
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/adr/ADR-<SEQ>-<SLUG>.md`

```markdown
# ADR-<SEQ> - <Titre de la décision>

- **Statut** : <Proposé|Accepté|Déprécié|Remplacé par ADR-XXX>
- **Date** : <AAAA-MM-JJ>
- **Décideurs** : <Nom(s)>
- **Sources** : <plans/fondations/tickets ayant motivé la décision>

## Contexte

<Le problème ou la question qui force la décision ; les contraintes directrices.>

## Décision (résumé)

> <Résumé actionnable de la décision retenue, en une ou deux phrases.>

## Décisions détaillées

### <Sous-thème 1>
- **Décision** : <choix retenu>
- *Alternatives écartées* : <liste + raison>

## Conséquences

**Positives**
- <bénéfice 1>

**Négatives / risques**
- <compromis assumé 1>

## Migration / porte de sortie

<Conditions sous lesquelles cette décision serait révisée ; alternative de repli documentée si pertinent.>

## Références

- <liens vers plans, fondations, tickets>
```
