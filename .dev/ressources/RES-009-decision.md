---
type: ressource
id: RES-009
title: "Décision"
version: 0.1.0
status: draft
prefixe: DCN
emplacement: ".dev/decisions/DCN-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: hybride
famille: contenu
champs-obligatoires: [type, id, title, version, status, instance, date-de-decision, portee, effet]
relations-admissibles: [decision, ressource, adr, intention, objection, fragment]
sections: [Objet, La décision, Qui a décidé, Portée, Conséquences, Ce que la décision ne dit pas, Relations]
skill: skl-004-ressource-de-contenu
adr: ADR-005
statut: actif
---

# RES-009 - Décision

> Une décision encode une décision prise par une instance ayant autorité : un texte de loi, un règlement, une délibération de conseil, un arbitrage de l'humain sur le système. Elle enregistre ce qui a été décidé, par qui, et ce qui en découle. Elle ne décide rien elle-même.

## Objet

Ce document définit le type `decision`. Sa fonction est de rendre citable et opposable une décision qui a été prise ailleurs, afin que le travail puisse s'y référer sans la reformuler.

## Statut de ce document

Premier jet, produit le 2026-08-10 à la demande de la tâche 8. Le type est nouveau et n'a aucun antécédent dans le corpus : `ANL-001` n'a relevé aucun mécanisme d'enregistrement de décision externe dans les cent soixante-six dépôts observés.

## Le problème que ce type résout

Le corpus produit des ADR, qui actent des décisions **de conception prises dans le dépôt**. Il n'a aucun moyen d'enregistrer une décision **prise ailleurs** et qui contraint le travail.

Trois manques concrets, tirés de `ANL-001`.

Le dépôt `le-gros-quebec/fondation-d-un-parti-politique` rassemble vingt PDF officiels d'Élections Québec, c'est-à-dire des textes réglementaires qui contraignent tout le travail du dépôt. Ils sont conservés comme documents, non comme décisions citables.

Le dépôt `cryptosecops/noumanity+qguard` est un registre de documents légaux partagés avec un tiers. Ce sont des décisions au sens de ce type, et rien ne les modélise.

Les quatre ruptures de cap du corpus que `ANL-001` relève au défaut D3 sont des décisions de l'humain sur son propre système, jamais enregistrées. Un ADR aurait pu les porter, et aucun ne l'a fait, parce qu'un ADR décide d'une architecture alors que ces ruptures décidaient d'un cap.

## Ce qu'est une décision

Une ressource vivante qui porte cinq choses.

| Elle porte | Rôle |
|---|---|
| **La décision** | Ce qui a été décidé, en une formulation qui tient debout seule |
| **L'instance** | Qui a décidé, et à quel titre elle en avait le pouvoir |
| **La date** | Quand la décision a été prise, distincte de la date d'enregistrement |
| **La portée** | Sur quoi la décision s'applique, et sur quoi elle ne s'applique pas |
| **Les conséquences** | Ce qui change dans le travail du fait de cette décision |

## Ce qu'une décision n'est pas

C'est ici que le type se distingue de ses trois voisins, et la confusion serait coûteuse.

| Ce n'est pas | Différence |
|---|---|
| Un **ADR** | Un ADR décide, une DCN enregistre. Un ADR porte des alternatives écartées et des portes de sortie parce qu'il est l'acte de décider ; une DCN n'en porte pas, elle constate |
| Un **fait** | Un fait est un énoncé vérifiable. Une décision est un acte de volonté, qui peut être mauvais et rester en vigueur |
| Une **intention** | Une intention énonce un but poursuivi. Une décision énonce une contrainte acquise |
| Un **fragment** | Un fragment est du matériau textuel capté. Une décision est un acte dont on enregistre la teneur |

**Cas limite assumé.** L'humain qui tranche une objection sur le système prend une décision. Faut-il une DCN, ou la réponse écrite dans l'objection suffit-elle ? Ce jet propose : la réponse dans l'objection suffit tant qu'elle ne change pas une décision antérieure ; une DCN devient nécessaire dès qu'un cap est modifié. Voir les points ouverts.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `instance` | Texte libre | Qui a décidé. Suit la convention d'acteur : `human:<id>`, un nom d'organisation, ou un intitulé d'instance |
| `date-de-decision` | Date ISO | Quand la décision a été prise, jamais quand elle a été enregistrée |
| `portee` | `systeme`, `depot`, `domaine`, `externe` | Ce que la décision contraint |
| `effet` | `proposee`, `en-vigueur`, `suspendue`, `abrogee`, `remplacee` | État de la décision |

Le champ `effet` est ce qui rend le type vivant plutôt que point fixe : une décision ne change pas de teneur, mais elle change d'état. Une décision abrogée reste enregistrée.

**La valeur `proposee` est un ajout de la tâche 8, et elle mérite justification.** Une décision au sens strict est prise avant d'être enregistrée, et cette valeur semble donc contredire la définition. Elle est nécessaire pour un cas réel : un ADR au statut `propose` porte une décision formulée, argumentée, et non actée. La DCN correspondante peut exister et attendre l'acte, ce qui donne à l'humain un document à approuver plutôt qu'un ADR de deux cents lignes à lire. Le passage de `proposee` à `en-vigueur` appartient à l'humain seul.

## Cycle de vie

`vivant`, avec une nuance propre à ce type. La teneur d'une décision est immuable : la reformuler serait falsifier. Ce qui évolue est son `effet` et la liste de ses conséquences constatées.

Une décision qui en remplace une autre déclare `remplace` ; l'ancienne passe en `effet: remplacee` et n'est jamais supprimée.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| La décision, l'instance, la date | L'humain, ou l'agent citant une source externe vérifiable |
| Les conséquences constatées | Les deux, en append |
| L'effet | L'humain seul |

L'agent ne modifie jamais la teneur d'une décision enregistrée. Il peut en constater les conséquences.

## Structure attendue d'une instance

```
# DCN-<SEQ> - <Titre>

> La décision en une phrase.

## Objet
## La décision
## Qui a décidé
## Portée
## Conséquences
## Ce que la décision ne dit pas
## Relations
```

La rubrique « Ce que la décision ne dit pas » est obligatoire. Une décision enregistrée sans ses silences se lit comme plus large qu'elle n'est, et devient un argument d'autorité.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-003](RES-003-intention.md)
- `reference` [RES-005](RES-005-fait.md)
- `reference` [RES-008](RES-008-fragment.md)

## Points ouverts

| Question | Objection |
|---|---|
| Une réponse d'objection est-elle une décision au sens de ce type | `NON-015` |
| Qui vérifie qu'une décision enregistrée est fidèle à sa source | `NON-015` |
| Une décision externe doit-elle porter son texte, ou seulement son renvoi | `NON-015` |
