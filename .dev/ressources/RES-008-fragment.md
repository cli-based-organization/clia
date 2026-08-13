---
type: ressource
id: RES-008
title: "Fragment"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: FRG
emplacement: ".dev/fragments/FRG-<SEQ>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: hybride
famille: contenu
champs-obligatoires: [type, id, title, status, origine, date-de-captation, exploitation]
relations-admissibles: [fragment, decision, fait, concept, analyse, fondation, intention]
sections: [Objet, Le fragment, Origine, Ce qui en a été tiré, Ce qui reste à en tirer, Relations]
skill: skl-004-ressource-de-contenu
adr: ADR-010
statut: actif
---

# RES-008 - Fragment

> Un fragment est une unité textuelle auto-cohérente, captée et conservée telle quelle, à partir de laquelle d'autres ressources seront produites. Il n'est pas un brouillon : il est une matière première, dont la valeur tient à ce qu'elle n'a pas été retouchée.

## Objet

Ce document définit le type `fragment`. Sa fonction est d'élargir les moyens par lesquels l'humain fournit de l'information au système, sans passer par le point d'entrée de session et sans le mécanisme de traitement que celui-ci impose.

## Ce qu'est un fragment

Trois propriétés le définissent, et la troisième est celle qui le distingue de tout le reste.

**Auto-cohérent.** Il se lit seul. Un fragment qui n'a de sens que dans son contexte d'origine est un extrait, pas un fragment.

**Capté, non rédigé.** Sa valeur vient de ce qu'il n'a pas été retouché. C'est ce qui le rend citable comme matière.

**Destiné à être exploité.** Un fragment existe pour que d'autres ressources en soient tirées. Un fragment dont rien ne sort après un temps long est soit mal capté, soit sans intérêt, et son champ `exploitation` le dit.

## Ce qu'un fragment n'est pas

| Ce n'est pas | Différence |
|---|---|
| Du **matériel source** | Le matériel source est importé d'ailleurs et conservé dans son format d'origine, hors du modèle de ressources. Un fragment est une ressource typée, en markdown, avec un frontmatter |
| Un **brouillon** | Un brouillon est une version antérieure de quelque chose. Un fragment n'est la version de rien |
| Un **concept** | Un concept élabore une idée. Un fragment la capte sans l'élaborer |
| Un **fait** | Un fait est vérifiable et sourcé. Un fragment peut être une intuition, une formulation heureuse, une objection non instruite |
| Une **note dans une session** | Ce qui est écrit dans une session disparaît de la vue à sa clôture. C'est précisément le manque que ce type comble |

## Test d'admission

Un texte mérite d'être capté comme fragment s'il satisfait les trois conditions.

1. Il se lit **seul**, sans son contexte d'origine.
2. Il porte quelque chose qu'on **ne veut pas perdre**, et qui n'a pas encore sa place ailleurs.
3. On **ne sait pas encore** quelle ressource en sortira. Si on le sait, il faut produire cette ressource et non un fragment.

La troisième condition est celle qui évite que le fragment devienne un dépotoir : c'est un état d'attente, non un contenant par défaut.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `origine` | Texte libre | D'où vient le texte : une conversation, une lecture, une réunion, une pensée. Suit la convention d'acteur quand une personne est en cause |
| `date-de-captation` | Date ISO | Quand le texte a été capté |
| `exploitation` | `non-exploite`, `partiellement-exploite`, `exploite`, `sterile` | Ce qui en a été tiré |

Le champ `exploitation` est l'apport du type. Il rend visible ce qui dort. La valeur `sterile` est nécessaire et doit rester employable sans gêne : un fragment dont rien ne sort a servi à écarter une piste, ce qui est un résultat.

## Cycle de vie

`point-fixe`, nommage séquencé comme tous les types. Un fragment ne se révise pas : sa valeur tient à sa forme captée. Une reformulation produit une autre ressource, qui déclare `derive-de` vers le fragment.

Ce qui évolue est le champ `exploitation` et la liste de ce qui en a été tiré. C'est le même écart que celui déjà relevé pour les autres types point fixe, et il est porté par `NON-011` Q2 et `NON-012` Q5.

## Régime d'édition

`hybride`, avec propriété par bloc, et le partage est ici particulièrement net.

| Bloc | Propriétaire | Raison |
|---|---|---|
| Le texte du fragment | L'humain, ou celui qui capte | Retoucher un fragment détruit ce qui en fait la valeur |
| L'origine et la date | Celui qui capte | |
| Ce qui en a été tiré | L'agent, en append | Il est le mieux placé pour constater qu'une ressource dérive d'un fragment |
| L'exploitation | Les deux | |

**Règle absolue de ce type.** L'agent ne modifie jamais le texte d'un fragment, y compris pour en corriger la langue ou la forme. Un fragment mal écrit reste tel quel.

## Structure attendue d'une instance

```
# FRG-<SEQ> - <Titre>

> Ce que le fragment porte, en une phrase.

## Le fragment

<le texte capté, tel quel>

## Origine
## Ce qui en a été tiré
## Ce qui reste à en tirer

## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

| Valeur | Reprise de |
|---|---|
| `non-exploite` | `exploitation` |
| `partiellement-exploite` | `exploitation` |
| `exploite` | `exploitation` |
| `sterile` | `exploitation` |

Ces valeurs sont **reprises du champ `exploitation`**, que `DCN-016` supprime. Elles ne sont pas nouvelles : le type les portait déjà.

## Relations
```

La rubrique « Le fragment » contient le texte capté et rien d'autre. Tout commentaire va dans les rubriques suivantes.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-007](RES-007-concept.md)
- `reference` [RES-009](RES-009-decision.md)

## Points ouverts

| Question | Objection |
|---|---|
| Le fragment remplace-t-il `source-material`, ou coexiste-t-il avec lui | `NON-015` |
| Un fragment non exploité au bout d'un temps donné doit-il être signalé | `NON-015` |
| Un fragment peut-il être non textuel | `NON-006` Q1 |
| Le nommage daté d'un type dont un champ évolue est-il tenable | `NON-011` Q2 |
