---
type: issue
id: ISU-011
title: "Une session abandonnée ne se distingue pas d'une session aboutie"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouverte"
initiateur: humain
etat: ouverte
ouverture: 2026-08-12
---

# ISU-011 - Une session abandonnée ne se distingue pas d'une session aboutie

> Le cycle est `todo => opened => closed`. Une session laissée en route porte la même valeur qu'une session qui a convergé.

## Journal

- 2026-08-12 : ouverte à la demande de l'humain, réponse Q2 de `NON-037` : « Pas pour l'instant. On implémentera plus tard. »

## La problématique

L'état `abandonnee` existait dans la première définition de `RES-034`. Il a disparu le 2026-08-11 avec la révision du cycle de vie.

**Ce que l'information vaut.** Une session close est une session dont on croit le travail abouti. Deux des quatre sessions archivées du dépôt n'ont pas de date de fin : elles n'ont jamais été closes, et rien ne dit si elles ont convergé ou si elles ont été laissées.

**La décision est prise de ne pas trancher maintenant.** Cette issue enregistre l'écart.

## Ce qu'il faudrait pour la fermer

Deux formes possibles.

| Forme | Coût |
|---|---|
| Un quatrième état, `abandoned` | Une valeur d'énumération, le schéma, la définition |
| Un champ portant le motif de la clôture | Un champ de plus, que `NON-022` conteste par principe |

**Le point à trancher avant.** `ISU-009` porte la révision du modèle de frontmatter, et `DCN-016` remplacerait `etat` par `domain-status`. Ajouter une valeur avant cette décision produirait un travail à refaire.

## Relations

- `derive-de` [NON-037](../objections/NON-037-frontiere-et-forme-de-la-session.md)
- `reference` [ISU-009](ISU-009-revision-du-modele-de-frontmatter.md)
- `reference` [RES-034](../ressources/RES-034-session.md)
