---
type: skill
version: 0.1.0
name: skl-010-requis
description: >-
  Produire un document de requis (`.dev/requis/REQ-<SEQ>-<SLUG>.md`) : les exigences vérifiables
  et priorisées d'un système ou d'un livrable, exprimant le besoin (le « quoi » attendu), distinct
  de la spécification qui décrit la solution. À utiliser quand une tâche demande de formaliser des
  exigences avant de concevoir ou coder.
---

# Skill - Rédaction de requis

> Un document de requis énonce les exigences d'un système : ce qu'il doit faire (fonctionnel) et les qualités qu'il doit présenter (non fonctionnel), chaque exigence étant vérifiable et priorisée. Le requis exprime le **besoin**, indépendamment de la solution ; la spécification (`skl-009`) décrit ensuite **comment** y répondre.

## Quand l'utiliser

Quand une tâche demande de fixer les exigences d'un système, d'un outil ou d'un livrable avant sa conception détaillée ou son codage. Ne pas utiliser pour décrire la solution retenue (voir `skl-009-specification`), pour acter une décision d'architecture (voir `skl-006-adr`), ni pour un plan d'intervention (voir `skl-003-plan-de-travail`).

## Processus

1. Identifier la source du besoin : intention, fondation, analyse, ou demande de `session.md`.
2. Distinguer les exigences **fonctionnelles** (ce que le système fait) des exigences **non fonctionnelles** (qualités : robustesse, performance, portabilité, ergonomie, sécurité).
3. Formuler chaque exigence de façon **atomique et vérifiable** : une phrase testable, sans ambiguïté (« le système DOIT ... »).
4. Attribuer un identifiant stable à chaque exigence (`REQ-<SEQ>-F<n>` fonctionnel, `REQ-<SEQ>-NF<n>` non fonctionnel).
5. Prioriser (ex. MUST / SHOULD / MAY, ou obligatoire / souhaitable / optionnel).
6. Noter, pour chaque exigence, un critère d'acceptation ou une méthode de vérification.
7. Signaler les exigences en tension ou en dépendance mutuelle.

## Critères de qualité

- Chaque exigence est atomique, vérifiable et non ambiguë (pas « rapide » mais « répond en moins de X »).
- Fonctionnel et non fonctionnel sont séparés.
- Chaque exigence porte un identifiant stable et une priorité.
- Chaque exigence a un critère d'acceptation ou une méthode de vérification.
- Le document exprime le besoin, pas la solution (aucun choix d'implémentation imposé sans justification).
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/requis/REQ-<SEQ>-<SLUG>.md`

```markdown
---
type: requis
version: <X.Y.Z>
title: "<Titre>"
date: <AAAA-MM-JJ>
---

# REQ-<SEQ> - <Titre>

- **Sources** : <intention/fondation/analyse ayant motivé ces requis>
- **Convention de priorité** : MUST | SHOULD | MAY

## Objet et périmètre

<Ce qui est exigé et de quoi, en une à trois phrases ; ce qui est hors périmètre.>

## Exigences fonctionnelles

- **REQ-<SEQ>-F1** (MUST) : <exigence testable>
  - Vérification : <critère d'acceptation>

## Exigences non fonctionnelles

- **REQ-<SEQ>-NF1** (SHOULD) : <exigence de qualité testable>
  - Vérification : <critère d'acceptation>

## Tensions et dépendances

<Exigences en conflit, arbitrages, dépendances entre exigences.>
```
