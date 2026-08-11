---
type: ressource
id: RES-015
title: "Harnais d'architecture"
version: 0.1.0
status: draft
prefixe: aucun
emplacement: "ARCHITECTURE.md"
cycle-de-vie: vivant
edition: co-edition
famille: controle
champs-obligatoires: [type, version, title, status]
relations-admissibles: [harnais, ressource, adr]
sections: [Composants, Acteurs, Flux, Cartographie]
skill: skl-005-ressource-de-controle
adr: ADR-012
statut: actif
---

# RES-015 - Harnais d'architecture

> Le harnais d'architecture donne la carte de haut niveau du système : ses composants, ses acteurs, ses flux, l'emplacement de son code. Court et stable, il consolide sans décider.

## Objet

Définit le type du fichier `ARCHITECTURE.md`. Il complète la triade du pourquoi, du comment et de la gouvernance par la **structure**.

## Ce qu'il porte, et ce qu'il ne porte pas

Il porte les composants et leurs frontières, les acteurs et leurs rôles, les flux entre eux, et la cartographie du code.

Il ne décide pas : les décisions restent aux ADR. Il ne recopie pas les invariants : ceux-ci restent aux principes. Il ne liste pas les types : ceux-ci restent aux définitions.

## Défaut constaté

Le fichier prévoit `src/` et `tests/` et ne mentionne ni `bin/` ni `lib/`, que l'implémentation de la tâche 6 emploie parce que ce sont les emplacements conventionnels du bash exécutable et sourcé. L'écart est signalé et non corrigé, le fichier étant co-édité.

## Cycle de vie et édition

`vivant`, nom fixe à la racine, `co-edition`.

## Relations

- `reference` [RES-014](RES-014-harnais-operatoire.md)

## Points ouverts

| Question | Objection |
|---|---|
| Les emplacements du code doivent-ils y être corrigés | `NON-017` |
