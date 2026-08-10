---
type: ressource
id: RES-article
title: "Article"
version: 0.1.0
status: draft
prefixe: ART
emplacement: "publications/ART-<DATE>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: ia
famille: implementation
champs-obligatoires: [type, id, title, status, date, auditoire, publication]
relations-admissibles: [article, rapport, fondation, concept, publication]
sections: [Objet, Corps, Références, Relations]
skill: skl-007-ressource-d-implementation
adr: ADR-regroupement-fonctionnel-des-ressources
statut: actif
---

# RES-028 - Article

> Un article est destiné à une publication identifiée, avec ses contraintes de forme et son auditoire. Le lieu de publication est ce qui le distingue d'un rapport.

## Objet

Définit le type `article`. Sa fonction est de rattacher au modèle un livrable dont la forme est imposée de l'extérieur.

## Statut de ce document

Premier jet du 2026-08-10. Aucune instance dans ce dépôt. Le corpus en compte un cas exemplaire : `jvtrudel/ecrits`, treize fichiers dont un article publié sur LinkedIn en novembre 2025, avec son lien de publication.

`ANL-001` relève que c'est le **seul dépôt de savoir du corpus qui fonctionne**, et qu'il fonctionne précisément parce qu'il est orienté publication : le livrable a un destinataire, une date et un lien.

## Ce que ce type enseigne au reste du modèle

C'est l'enseignement le plus utile de la famille implémentation. Onze dépôts de technotes du corpus sont morts, dont six sans aucun fichier versionné, et le seul qui vit est celui qui publie.

La conclusion, formulée par `ANL-001` : le savoir se conserve quand il est destiné à sortir. Un système qui veut mobiliser du savoir a donc intérêt à ce que ce savoir soit destiné à quelqu'un.

## Le champ publication

Obligatoire. Il porte le lieu de publication et, une fois publié, le lien. Un article sans destination est un fragment ou un concept, pas un article.

## Cycle de vie et édition

`point-fixe`, nommage daté. La forme est contrainte par le lieu de publication, ce qui peut imposer un format non markdown : `ADR-004` D1 le rend possible.

## Relations

- `reference` [RES-027](RES-027-rapport-de-recherche.md)
- `reference` [RES-007](RES-007-concept.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un article dans un format imposé non markdown reste-t-il conforme | `NON-006` Q1 |
