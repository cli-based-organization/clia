---
type: ressource
id: RES-rapport-de-recherche
title: "Rapport de recherche"
version: 0.1.0
status: draft
prefixe: RPT
emplacement: "publications/RPT-<DATE>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: ia
famille: implementation
champs-obligatoires: [type, id, title, status, date, auditoire, diffusion]
relations-admissibles: [rapport, fondation, analyse, fait, publication]
sections: [Objet, Résultats, Méthode, Discussion, Sources, Relations]
skill: skl-007-ressource-d-implementation
adr: ADR-regroupement-fonctionnel-des-ressources
statut: actif
---

# RES-027 - Rapport de recherche

> Un rapport de recherche est destiné à sortir du dépôt. Il diffère d'une fondation ou d'une analyse par son auditoire : il est écrit pour quelqu'un qui n'a pas accès au dépôt.

## Objet

Définit le type `rapport`. Sa fonction est de porter vers l'extérieur ce que le travail interne a établi.

## Statut de ce document

Premier jet du 2026-08-10. Aucune instance dans ce dépôt.

## Ce qui distingue ce type de ses voisins internes

Une fondation et une analyse sont des instruments de travail : elles peuvent renvoyer à des ressources du dépôt, employer son vocabulaire, supposer son contexte.

Un rapport ne peut rien supposer. Il porte donc son propre contexte, et c'est la seule différence, mais elle change tout dans la rédaction.

`FND-002` fournit le cadre : la réutilisation par une autre personne exige une résolution indépendante de l'émetteur. Un rapport qui renvoie à `ANL-001` sans l'expliquer est inutilisable hors du dépôt.

## Le champ diffusion

Obligatoire, aux mêmes valeurs que pour les faits : `public`, `prive`, `confidentiel`. Un rapport agrège des faits, et il ne peut pas être plus ouvert que le moins ouvert des faits qu'il emploie.

Cette règle de composition est nouvelle et elle n'est pas outillée. `NON-007` Q2 porte la question générale de savoir qui garantit le respect du régime de diffusion.

## Cycle de vie et édition

`point-fixe`, nommage daté. Un rapport diffusé ne se réécrit pas : une nouvelle version est un nouveau rapport, qui déclare `remplace`.

## Relations

- `reference` [RES-011](RES-011-fondation.md)
- `reference` [RES-005](RES-005-fait.md)

## Points ouverts

| Question | Objection |
|---|---|
| La règle de composition de la diffusion est-elle vérifiable | `NON-007` Q2 |
