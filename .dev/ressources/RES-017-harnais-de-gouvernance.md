---
type: ressource
id: RES-017
title: "Harnais de gouvernance"
version: 0.1.0
status: draft
prefixe: aucun
emplacement: "GOUVERNANCE.md"
cycle-de-vie: vivant
edition: co-edition
famille: controle
champs-obligatoires: [type, version, title, status]
relations-admissibles: [harnais, ressource, objection, decision]
sections: [Cycle de décision, Objection, Arbitrage, Rôles]
skill: skl-005-ressource-de-controle
adr: ADR-005
statut: non-installe
---

# RES-017 - Harnais de gouvernance

> Le harnais de gouvernance décrit le cycle par lequel une demande devient un livrable approuvé : qui propose, qui objecte, qui arbitre, et à quel moment.

## Objet

Définit le type du fichier `GOUVERNANCE.md`, annoncé par `CLAUDE.md` et jamais produit.

## Statut de ce document

Premier jet du 2026-08-10, type déclaré `non-installe`. Le fichier n'existe pas et n'a jamais existé dans ce dépôt.

## La question que ce type pose

Son contenu recoupe celui du harnais constitutionnel et celui de `ADR-002`. Trois documents porteraient alors le même objet, ce qui est exactement le défaut de source parallèle que `ANL-001` mesure au défaut D2.

Ce jet ne tranche pas et rend la question visible : soit la gouvernance vit dans la constitution, soit la constitution se réduit aux règles impératives et la gouvernance prend le cycle. La deuxième répartition est la plus claire et elle demande de produire deux fichiers là où le corpus n'en tenait qu'un.

## Ce qu'il porterait

Le cycle de décision et ses états. Le mécanisme d'objection, son effet et sa levée. L'arbitrage en cas de désaccord persistant. Les rôles des trois agents.

Ce dernier point est aujourd'hui dans `ADR-002` D1, et il y est bien.

## Cycle de vie et édition

`vivant`, nom fixe à la racine, `co-edition`.

## Relations

- `reference` [RES-016](RES-016-harnais-constitutionnel.md)
- `reference` [RES-004](RES-004-objection.md)

## Points ouverts

| Question | Objection |
|---|---|
| Ce type doit-il exister, ou son objet appartient-il à la constitution | `NON-017` |
| Qui arbitre lorsque l'agent maintient une objection que l'humain lève | `NON-010` Q7 |
