---
type: skill
version: 0.1.0
name: skl-014-principe-de-conception
description: >-
  Produire ou faire évoluer un principe de conception (`.dev/principes/PDC-<SEQ>-<SLUG>.md`) :
  un document vivant énonçant un principe durable et transverse qui guide le design de haut
  niveau du système. À utiliser quand une règle de conception transcende une décision ponctuelle
  et doit s'appliquer à tout le système. Type défini dans `ADR-008`.
---

# Skill - Rédaction d'un principe de conception

> Un principe de conception (PDC) est un énoncé normatif durable et de haut niveau auquel **tout élément du système doit se conformer** pour préserver l'intégrité conceptuelle (voir `FND-014-principes-de-conception-systemes-complexes`). Il se distingue d'une décision (ADR, ponctuelle) et d'une exigence (REQ, propre à un système donné) : il est transverse et cadre les décisions et exigences elles-mêmes. Type défini dans `ADR-008`.

## Quand l'utiliser

Quand une règle de conception **transcende** un choix ponctuel et doit gouverner tout le système (ex. déterminisme, séparation des préoccupations, source de vérité unique). Utiliser aussi pour **faire évoluer** un PDC existant (préciser l'énoncé, les implications, les critères de conformité). Ne pas utiliser pour :
- une décision d'architecture ponctuelle (`skl-006-adr`) ;
- une exigence d'un système donné (`skl-010-requis`) ou une spécification d'interface (`skl-009-specification`) ;
- une règle de gouvernance des acteurs, qui relève de `CONSTITUTION.md` (`skl-004-harnais`), pas d'un principe de conception.

## Processus

1. Vérifier que la règle est bien un **principe** au sens d'`ADR-008` : durable, transverse, applicable à tout le système, distinct d'une décision ou d'une exigence. Sinon, orienter vers le skill approprié.
2. Créer ou rouvrir `.dev/principes/PDC-<SEQ>-<SLUG>.md` (séquence globale incrémentale).
3. Rédiger l'**énoncé** : une phrase normative, affirmative et vérifiable (« le système fait / ne fait jamais X »), sans jargon inutile.
4. Rédiger la **justification** (rationale) : pourquoi ce principe, quel risque il prévient, à quelle propriété de qualité il contribue.
5. Délimiter la **portée** : à quels éléments du système il s'applique (harnais, `clia`, documents de conception, livrables), et ses éventuelles exclusions.
6. Expliciter les **implications** : ce que le principe impose et interdit concrètement.
7. Définir des **critères de conformité** vérifiables : comment constater qu'un élément respecte (ou enfreint) le principe. Ces critères servent à qualifier un non-respect comme **bogue** (`ADR-003`, `skl-013`).
8. Recenser les **tensions** avec d'autres principes (aucun principe ne prime absolument sans arbitrage).
9. Fixer le **statut** (`proposé` / `accepté` / `déprécié` / `remplacé par PDC-XXX`) et la **version** dans le frontmatter ; incrémenter la version selon semver à chaque modification (`ADR-004`, `PDC-009`).

## Critères de qualité

- L'énoncé est une phrase normative unique, affirmative et vérifiable (pas un paragraphe, pas un vœu).
- Le principe est réellement transverse et durable (critère `ADR-008` / `FND` §3), pas une préférence locale ni une décision ponctuelle déguisée.
- La justification relie le principe à un risque évité ou à une propriété de qualité.
- La portée est explicite (ce qui est couvert, ce qui ne l'est pas).
- Les implications distinguent ce qui est imposé de ce qui est interdit.
- Les critères de conformité sont vérifiables et permettent de qualifier une violation comme bogue.
- Les tensions avec d'autres principes sont nommées, pas tues.
- Statut et version présents ; versionnage atomique effectué.
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/principes/PDC-<SEQ>-<SLUG>.md`

```markdown
---
type: principe
version: <X.Y.Z>
title: "<Titre du principe>"
status: <proposé|accepté|déprécié|remplacé par PDC-XXX>
date: <AAAA-MM-JJ>
---

# PDC-<SEQ> - <Titre du principe>

## Énoncé

<Une phrase normative, affirmative et vérifiable.>

## Justification

<Pourquoi ce principe ; quel risque il prévient ; à quelle propriété de qualité il contribue.>

## Portée

<À quels éléments du système il s'applique ; exclusions éventuelles.>

## Implications

<Ce que le principe impose ; ce qu'il interdit.>

## Critères de conformité

<Comment vérifier qu'un élément respecte le principe ; ce qui constitue une violation (donc un bogue, ADR-003).>

## Tensions

<Tensions avec d'autres principes ; arbitrages.>

## Références

<Fondations, ADR, autres PDC liés.>
```
