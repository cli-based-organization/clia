---
type: ressource
id: RES-harnais-operatoire
title: "Harnais opératoire"
version: 0.1.0
status: draft
prefixe: aucun
emplacement: "CLAUDE.md"
cycle-de-vie: vivant
edition: co-edition
famille: controle
champs-obligatoires: [type, version, title, status]
relations-admissibles: [harnais, ressource, decision, intention]
sections: [Prise en charge de la demande, Méthodologie, Directives]
skill: skl-005-ressource-de-controle
adr: ADR-regroupement-fonctionnel-des-ressources
statut: actif
---

# RES-014 - Harnais opératoire

> Le harnais opératoire est le fichier chargé à chaque session qui fixe le mode opératoire de l'agent IA. Il a autorité sur son comportement, et il est pour cette raison hors du modèle de ressources qu'il institue.

## Objet

Définit le type du fichier `CLAUDE.md`. Son nom est imposé par l'outil, non par ce dépôt : c'est ce que l'agent lit sans qu'on le lui demande.

## Statut de ce document

Premier jet du 2026-08-10. Le fichier existe et il est en défaut : `ANL-001` établit au défaut D8 qu'il prescrit un système qui n'existe pas, avec vingt-sept types annoncés dont vingt-et-un sans instance et quinze triplets de marque-places.

## Pourquoi un harnais n'est pas une ressource ordinaire

`ADR-001` D8 le place hors du modèle, et le motif est logique : un fichier qui a autorité sur le comportement de l'agent ne peut pas être soumis au modèle qu'il institue, sans boucle.

La conséquence pratique est qu'il échappe aux contrôles de `skl-001`. Cette définition existe pour lui rendre une forme sans le soumettre au modèle : elle décrit ce que le fichier doit porter, elle ne l'inscrit pas dans la couche type.

## Ce que le harnais opératoire porte

Trois choses, et rien d'autre. La manière de prendre en charge une demande. La méthodologie de travail en vigueur. Les directives de comportement.

Il ne porte ni la liste des types, qui vit dans les définitions, ni le processus de production, qui vit dans les skills, ni les décisions, qui vivent dans les ADR. Chacune de ces trois inclusions crée une source parallèle, et `ANL-001` mesure au défaut D2 que la duplication non tenue est le mode de défaillance dominant du corpus.

## Une exigence propre : le statut par section

Chaque section doit porter son état, en vigueur ou prévue. Un harnais qui décrit un état futur ne peut être ni obéi ni contesté utilement, et c'est le défaut mesuré du fichier actuel.

## Cycle de vie et édition

`vivant`, versionné, nom fixe à la racine. `co-edition` : l'humain propose des amendements, l'agent les applique et demande validation.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-015](RES-015-harnais-d-architecture.md)

## Points ouverts

| Question | Objection |
|---|---|
| La table des types doit-elle vivre ici ou dans l'index des définitions | `NON-002` Q6 |
| Comment un harnais déclare-t-il ce qui est en vigueur | `PLN-001` chantier A |
