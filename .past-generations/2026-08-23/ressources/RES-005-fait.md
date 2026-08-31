---
type: ressource
id: RES-005
title: "Faits"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: FCT
emplacement: ".dev/faits/FCT-<SEQ>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: hybride
famille: fondamentale
champs-obligatoires: [type, id, title, status, sujet, date-de-constat, diffusion]
relations-admissibles: [fait, contexte, analyse, ontologie, concept]
sections: [Portée et date d'arrêt, Faits, Faits contestés, Ce qui n'a pas pu être établi, Relations]
skill: skl-002-ressource-fondamentale
adr: ADR-009
statut: actif
---

# RES-005 - Faits

> Un fait est un énoncé vérifiable, daté et attribué à une source, dont la fonction est de servir de preuve. Une ressource `FCT` est un recueil de faits portant sur un même sujet, chacun atomique et identifié.

## Objet

Ce document définit le type `faits`. Sa fonction dans le système est de séparer nettement ce qui est établi de ce qui est affirmé, afin que les affirmations puissent être soutenues et contestées.

## Ce qu'est un fait

Un fait est un énoncé qui porte quatre propriétés. Si l'une manque, ce n'est pas un fait au sens de ce type.

| Propriété | Ce qu'elle exige |
|---|---|
| **Vérifiable** | Il existe un moyen nommé de le contrôler, indépendant de la parole de celui qui l'énonce |
| **Daté** | Il porte la date de son constat, non celle de sa rédaction |
| **Attribué** | Sa source est nommée, selon la convention d'acteur : `human:<id>` pour une personne, `<producteur>/<version>` pour un agent, `process:<id>` pour un traitement |
| **Atomique** | Il énonce une seule chose, contestable séparément |

## Ce qu'un fait n'est pas

C'est la partie utile de la définition, parce que la confusion est facile et coûteuse.

| Ce n'est pas | Différence |
|---|---|
| Une **affirmation** | Une affirmation prétend ; un fait se vérifie. « Le système est mûr » est une affirmation. « Vingt-et-un des vingt-sept types annoncés n'ont aucune instance » est un fait |
| Une **opinion** | Une opinion appartient à qui la porte et n'est pas contestable par vérification |
| Une **interprétation** | « Le harnais se propage par copie » interprète ; « trois `INTENTION.md` de dépôts différents ont la même empreinte md5 » constate |
| Une **mesure non datée** | Une mesure sans date de constat est inutilisable : le corpus change |
| Un **log** | Un log trace ce que l'agent a fait ; un fait établit ce qui est |

## Granularité : le recueil

Un fichier par fait serait ingérable, et c'est probablement ce qui a empêché le type d'exister : le corpus produit des centaines de constats et n'a créé qu'un répertoire vide.

L'unité de fichier est le **recueil**, l'unité de sens le **fait**.

Une ressource `FCT` porte un sujet, déclaré par son champ `sujet`, et contient les faits établis sur ce sujet. Chaque fait y est numéroté `F<NN>`, ce qui donne à chacun une adresse citable de la forme `FCT-001#F03`.

| Niveau | Unité | Identifiant |
|---|---|---|
| Fichier | Le recueil, un sujet | `FCT-<SEQ>` |
| Entrée | Le fait, atomique | `F<NN>` dans le recueil |

Un recueil est `point-fixe` : il est arrêté à sa date. Constater de nouveaux faits sur le même sujet produit un nouveau recueil, qui déclare `derive-de` vers le précédent. C'est ce qui permet de voir évoluer un sujet sans réécrire l'histoire.

## Test d'admission

Un constat mérite d'entrer dans un recueil s'il satisfait les quatre conditions.

1. Sa véracité a été **établie par un processus rigoureux et normé**. `NON-003` Q5.
2. Il est **vérifiable** au sens ci-dessus.
3. Il **soutient ou conteste** au moins une affirmation qui compte.
4. Il **risque d'être perdu ou contesté** s'il n'est pas consigné.

La première condition est ce qui sépare un fait d'un contexte. Une affirmation qu'un agent, humain ou IA, pose sans vérification appartient à `CTX` ou à une rubrique de contexte, quelle que soit sa justesse apparente. Le processus qui établit la véracité doit être nommé dans le recueil.

La troisième condition est celle qui évite la prolifération. Une mesure qu'on peut reproduire en une commande à tout moment n'a pas besoin d'être consignée comme fait ; il suffit de consigner la commande. Une mesure prise sur un état qui a disparu, en revanche, doit l'être.

## Diffusion

Le champ `diffusion` est obligatoire, et il est propre à ce type. Il vient directement du travail sur les faits privés.

| Valeur | Sens |
|---|---|
| `public` | Peut être cité hors du dépôt, sans restriction |
| `prive` | Reste dans le dépôt. Ne peut pas être cité dans un livrable destiné à un tiers |
| `confidentiel` | Concerne un tiers identifiable. Ne peut être cité qu'avec son accord, et la contrainte est nommée |

Le corpus donne la raison d'être de ce champ. Deux dépôts gèrent des documents légaux et des ententes, et aucun des deux ne porte de harnais ni de règle d'édition. Un système qui consigne des faits sans déclarer leur régime de diffusion fabrique une fuite en attente.

## Fait consigné ou champ de provenance

La question est de savoir si un fait doit être une ressource, ou s'il suffit que chaque document déclare ses sources dans son frontmatter.

Les deux coexistent, avec un critère de départage.

Un énoncé reste un **champ de provenance** du document qui l'emploie s'il ne sert qu'à ce document.

Il devient un **fait consigné** dès qu'il est employé par plus d'un document, ou qu'il est susceptible d'être contesté indépendamment du document qui le cite.

Le critère est le même que celui qui gouverne la mise en facteur d'un contenu : on ne consigne que ce qui est réutilisé. La question reste discutable et est portée par `NON-007`.

## Le fait et la preuve ne sont pas la même chose

Distinction reprise de `FND-2026-08-08-persuasion-preuve-et-auditoires`, et importante pour la conception.

Un fait est neutre. Ce qui fait **preuve** dépend de l'auditoire : un même fait convaincra un ingénieur et laissera indifférent un acheteur. Il suit qu'une ressource `FCT` porte le mode de vérification d'un fait, et **jamais** sa force persuasive.

La force persuasive relève du livrable qui emploie le fait, et de la méthodologie qui gouverne ce livrable. Mélanger les deux produit des recueils de faits orientés, c'est-à-dire des plaidoiries qui se présentent comme des constats.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire | Raison |
|---|---|---|
| Faits mesurables mécaniquement | Agent | Il peut les établir et les reproduire |
| Faits attestés par expérience ou par témoignage | Humain | L'agent ne peut ni les constater ni les vérifier |
| Mode de vérification | L'auteur du fait | Celui qui affirme dit comment on contrôle |
| Contestations | Les deux, en append | Un fait contesté n'est pas effacé, il est annoté |

## Structure attendue d'une instance

```
# FCT-<SEQ> - <Sujet>

> Ce sur quoi porte ce recueil, et l'état auquel il est arrêté.

## Portée et date d'arrêt
## Faits
### F01 - <énoncé en une phrase>
- Constaté le : <date>
- Source : <acteur>
- Vérification : <comment contrôler>
- Diffusion : <public | prive | confidentiel>
### F02 - ...
## Faits contestés
## Ce qui n'a pas pu être établi

## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations
```

La rubrique « Ce qui n'a pas pu être établi » est obligatoire dans l'esprit de ce type : un recueil qui ne dit pas ce qu'il n'a pas réussi à vérifier se lit comme exhaustif.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-002](RES-002-contexte.md)

## Points ouverts

| Question | Objection |
|---|---|
| Fait consigné ou champ de provenance ; critère de mise en facteur | `NON-007` |
| Régime des faits privés et confidentiels ; qui garantit la contrainte | `NON-007` |
| Un recueil `point-fixe` est-il tenable, alors que la règle d'immuabilité n'est tenue nulle part | `NON-005` |
| Le coût de consignation est-il compatible avec le volume de constats produit | `NON-002` |
