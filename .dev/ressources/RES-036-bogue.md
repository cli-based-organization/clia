---
type: ressource
id: RES-036
title: "Bogue"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
version: 0.1.0
prefixe: BUG
emplacement: ".dev/bogues/BUG-<SEQ>-<SLUG>.md"
cycle-de-vie: travail
edition: hybride
famille: preparation
champs-obligatoires: [type, id, title, status, regle, constate-le, etat]
relations-admissibles: [bogue, ressource, objection, issue, adr, decision, code]
sections: [Journal, L'écart, La règle enfreinte, Comment le reproduire, La cause, La correction, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-036 - Bogue

> Un bogue est un **écart entre un comportement attendu et un comportement constaté**, où l'attendu vient d'une règle écrite. Sans règle de référence, il n'y a pas de bogue : il y a une issue.

## Objet

Ce document définit le type `bogue`. Sa fonction est de rattacher un défaut constaté à la règle qu'il enfreint, pour que sa correction soit vérifiable.

## Ce qu'est un bogue

Une ressource de travail qui porte cinq choses.

| Elle porte | Rôle |
|---|---|
| **L'écart** | Ce qui est attendu, ce qui est constaté |
| **La règle enfreinte** | La décision, le principe ou la définition que l'attendu vient de |
| **La reproduction** | Comment constater l'écart, par une commande quand c'est possible |
| **La cause** | Ce qui produit l'écart, souvent distinct du symptôme |
| **La correction** | Ce qui a été fait, et le contrôle ajouté |

**La règle est ce qui fait le bogue.** Un comportement qui déplaît sans enfreindre aucune règle écrite n'est pas un bogue : c'est une issue, ou une objection contre la règle absente.

## Ce qu'un bogue n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **issue** | L'issue n'a aucune règle de référence. Elle porte un problème ouvert ; le bogue porte un écart mesurable |
| Un **comportement attendu** | Le `CMP` dit ce qui **doit** être. Le bogue dit ce qui **n'est pas** |
| Une **objection** | L'objection conteste une règle. Le bogue constate qu'une règle n'est pas tenue |
| Un **fait** | Le `FCT` porte un énoncé dont la véracité est établie. Le bogue porte un écart à corriger |

**La frontière avec l'objection mérite d'être tenue.** `NON-005` conteste depuis le 2026-08-09 l'accumulation de règles écrites et non tenues. Un bogue est le **cas particulier** d'une de ces règles, constaté sur un objet précis. L'objection porte le problème général ; le bogue porte l'occurrence.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `regle` | L'alias de la règle enfreinte | `ADR-007` D4, `PDC-001`, `RES-001` |
| `constate-le` | Date ISO | Quand l'écart a été constaté, jamais quand il a été introduit |
| `etat` | `ouvert`, `corrige`, `non-reproduit`, `accepte` | Où en est le traitement |

### Le champ etat

| Valeur | Ce qu'elle affirme |
|---|---|
| `ouvert` | L'écart est constaté et subsiste |
| `corrige` | L'écart ne se reproduit plus, et un contrôle le vérifie |
| `non-reproduit` | L'écart n'a pas pu être reproduit |
| `accepte` | L'écart subsiste et il est assumé. La règle ou le bogue doit alors dire pourquoi |

**`accepte` n'est pas `corrige`.** Un bogue accepté reste un écart : le déclarer évite qu'il soit redécouvert et retraité.

## Test d'admission

Un défaut mérite un bogue si les trois conditions sont réunies.

1. Une **règle écrite** est enfreinte, et elle est identifiable.
2. L'écart est **constatable**, idéalement par une commande.
3. L'écart **survivra à la session** en cours. Sinon, une correction immédiate et son journal suffisent.

La première condition est celle qui départage du reste. La troisième évite la prolifération : six des sept bogues constatés dans ce dépôt en trois jours ont été corrigés dans la tâche qui les a trouvés.

## Cycle de vie et versionnage

`travail`. Un bogue a une histoire, pas des versions. Il ne porte pas de champ `version`.

Un bogue `corrige` n'est pas supprimé. Son journal conserve la cause et la correction, ce qui est la seule protection contre la redécouverte.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| L'écart et la règle | Celui qui constate |
| La reproduction, la cause | Les deux |
| La correction | Celui qui corrige |
| L'état | Les deux |

L'agent peut ouvrir un bogue et le corriger. Il ne peut pas passer un bogue à `accepte` : accepter un écart est une décision, et `CONSTITUTION.md` C1 la réserve à l'humain.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `ISU` | Une règle de référence contre son absence |
| `CMP` | Ce qui doit être contre ce qui n'est pas |
| `NON` | Contester une règle contre constater qu'elle n'est pas tenue |
| `FCT` | Un énoncé établi contre un écart à corriger |

## Structure attendue d'une instance

```
# BUG-<SEQ> - <Titre>

> L'écart en une phrase.

## Journal
## L'écart
## La règle enfreinte
## Comment le reproduire
## La cause
## La correction

## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

| Valeur | Reprise de |
|---|---|
| `ouvert` | `etat` |
| `corrige` | `etat` |
| `non-reproduit` | `etat` |
| `accepte` | `etat` |

Ces valeurs sont **reprises du champ `etat`**, que `DCN-016` supprime. Elles ne sont pas nouvelles : le type les portait déjà.

## Relations
```

**La rubrique « La cause » est obligatoire, même vide.** Sur les sept bogues constatés dans ce dépôt, la cause diffère du symptôme dans cinq cas. Corriger un symptôme sans nommer sa cause laisse le bogue revenir sous une autre forme.

**La rubrique « La correction » dit si un contrôle existait.** Un bogue du 2026-08-11 était protégé par un test qui codifiait l'ancien comportement et passait au vert pendant deux jours. Un contrôle peut cacher un défaut au lieu de le détecter.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-031](RES-031-issue.md)
- `reference` [RES-024](RES-024-comportement-attendu.md)
- `reference` [RES-004](RES-004-objection.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un bogue sans règle écrite est-il une issue, ou une règle manquante | `NON-036` |
| Qui peut passer un bogue à `accepte` | `NON-036` |
| Le type doit-il migrer vers les quatre champs de `DCN-016` | `NON-036` |
