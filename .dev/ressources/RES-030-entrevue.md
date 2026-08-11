---
type: ressource
id: RES-030
title: "Entrevue"
version: 0.1.0
status: draft
prefixe: ENT
emplacement: ".dev/entrevues/ENT-<SEQ>-<SLUG>.md"
cycle-de-vie: travail
edition: hybride
famille: contenu
champs-obligatoires: [type, id, title, status, date, interlocuteur, objet-de-l-entrevue]
relations-admissibles: [entrevue, fragment, fait, decision, patrimoine]
sections: [Objet, Cadre, Échange, Ce qui en ressort, Relations]
skill: skl-004-ressource-de-contenu
adr: ADR-010
statut: actif
---

# RES-030 - Entrevue

> Une entrevue est un dialogue conduit pour faire entrer dans le système ce que l'humain sait et n'a pas écrit. C'est le seul type conçu pour produire de la matière par questionnement.

## Objet

Définit le type `entrevue`. Sa fonction est d'extraire un savoir qui n'existe que dans la tête de quelqu'un.

## Pourquoi ce type appartient à la famille contenu

`ADR-005` D3 le range en contenu et non en implémentation, où `CLAUDE.md` le plaçait. Le motif est donné par la tâche 8 elle-même, qui cite l'entrevue parmi les mécanismes d'entrée existants, aux côtés du matériel source et des objections.

Une entrevue apporte de la matière. Elle ne réalise rien.

## Le régime hybride, et son partage

C'est le type où la propriété par bloc est la plus nette.

| Bloc | Propriétaire |
|---|---|
| Les questions | Celui qui conduit l'entrevue, souvent l'agent |
| Les réponses | L'interlocuteur, et personne d'autre |
| Ce qui en ressort | L'agent, en append |

**Règle absolue.** L'agent ne reformule jamais une réponse. Il peut en tirer un fait, un fragment ou un concept, qui déclarent `derive-de` vers l'entrevue.

## Ce qu'une entrevue n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **fragment** | Le fragment est capté sans dialogue. L'entrevue produit par questionnement |
| Un **fait** | L'entrevue est le lieu où des faits sont recueillis, non le lieu où ils sont établis |
| Une **session** | La session porte une demande de travail. L'entrevue porte un échange de savoir |

## Cycle de vie et édition

`travail`, journalisée en tête. Une entrevue peut se poursuivre en plusieurs temps.

## Relations

- `reference` [RES-008](RES-008-fragment.md)
- `reference` [RES-005](RES-005-fait.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un type jamais éprouvé doit-il être installé | `NON-002` Q3 |
| Comment garantir qu'une réponse n'est pas reformulée | `NON-005` Q7 |
