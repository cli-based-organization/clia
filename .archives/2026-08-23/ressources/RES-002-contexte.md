---
type: ressource
id: RES-002
title: "Contexte"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: CTX
emplacement: ".dev/contextes/CTX-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: hybride
famille: fondamentale
champs-obligatoires: [type, id, title, version, status, portee]
relations-admissibles: [contexte, intention, fait, ontologie, concept, analyse]
sections: [Situation, Historique, Acteurs, Contraintes, Constats et mesures, Ce qui n'est pas su, Relations]
skill: skl-002-ressource-fondamentale
adr: ADR-009
statut: actif
---

# RES-002 - Contexte

> Un contexte est la mise en situation d'un travail : ce qui est en place, ce qui a été essayé, qui est concerné, quelles contraintes s'appliquent. Il répond à la question « où en sommes-nous, et dans quoi travaillons-nous ».

## Objet

Ce document définit le type `contexte`, deuxième des trois ingrédients de toute demande selon `CLAUDE.md` : l'intention dit le pourquoi, le contexte dit la situation, la spécification du livrable dit la forme attendue.

## Ce qu'est un contexte

Un contexte est une ressource vivante qui énonce l'état d'une situation à l'usage de quiconque doit y travailler sans l'avoir vécue.

Il porte quatre choses, et une cinquième qui le distingue des autres types.

| Il porte | Exemple |
|---|---|
| **La situation** | Ce qui est en place, ce qui fonctionne, ce qui est cassé |
| **L'historique** | Ce qui a été essayé, ce qui a été abandonné, et si possible pourquoi |
| **Les acteurs** | Qui est concerné, à quel titre, avec quel pouvoir de décision |
| **Les contraintes** | Ce qui n'est pas négociable, et d'où vient la contrainte |
| **Ce qui n'est pas su** | Les zones d'ignorance connues, nommées comme telles |

La cinquième rubrique est celle qui donne sa valeur au type. Un contexte qui ne dit pas ce qu'il ignore laisse croire qu'il est complet, et un agent le traitera comme tel.

## Test d'admission

Tout élément de situation n'est pas une ressource. Le test suivant départage.

Un élément entre dans un `CTX` s'il est **vrai au-delà de la demande en cours** et si **un agent qui ne l'a pas vécu doit le savoir pour travailler correctement**.

Il reste dans la session s'il est propre à la demande, ou s'il perd son sens une fois la demande satisfaite.

Exemples de départage, tirés du corpus.

| Élément | Où il va | Pourquoi |
|---|---|---|
| « Le système est en construction et les directives de `CLAUDE.md` ne sont pas toutes exécutables » | `CTX` | Vrai pour toutes les sessions à venir, et un agent qui l'ignore obéit à des directives inapplicables |
| « Le dépôt sort d'un refactor qui a archivé la quasi-totalité de son contenu » | `CTX` | Fait durable, indispensable à la lecture du dépôt |
| « Le meilleur travail conceptuel vit dans un dépôt de candidature sans remote » | `CTX` | Vrai jusqu'à correction, et détermine ce qu'il est prudent de faire |
| « Commence par la tâche 2 » | Session | Propre à la demande |
| « Ne pas implémenter le plan » | Session | Instruction, pas situation |

## Portée

Trois portées, déclarées par le champ `portee`. Un dépôt peut porter plusieurs contextes.

| Portée | Ce qu'elle couvre | Durée typique |
|---|---|---|
| `depot` | La situation générale du dépôt : son état, son histoire, ses acteurs | Des mois |
| `domaine` | Une situation métier que plusieurs travaux partagent : un client, un marché, une technologie | Des mois |
| `travail` | Une situation propre à un chantier en cours, plus longue qu'une session mais bornée | Des semaines |

## Péremption

Le contexte est le seul type dont la fausseté est silencieuse. Une intention périmée reste lisible comme intention ; un contexte périmé se lit comme vrai.

Le champ `peremption` est **facultatif**, à titre indicatif. `NON-003` Q6. Il prend une date, ou l'une des deux valeurs suivantes.

| Valeur | Sens |
|---|---|
| Une date | Au-delà, le contexte doit être relu avant usage |
| `a-la-prochaine-session` | Contexte de courte durée, à revalider à chaque ouverture |
| `sur-evenement: <description>` | Le contexte périme quand l'événement nommé survient |

Un contexte périmé n'est pas supprimé. Il passe en `status: deprecated` et conserve sa valeur d'historique, ce qui est précisément ce qui manque au corpus : `ANL-001` établit que quatre ruptures de cap majeures n'ont laissé aucune trace écrite.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire | Raison |
|---|---|---|
| Situation, Historique, Acteurs, Contraintes | Humain | Il détient ce que la machine ne peut pas constater : les intentions des tiers, l'histoire vécue, les contraintes tacites |
| Constats, Mesures | Agent | Il détient ce qu'il peut établir mécaniquement : état du dépôt, dénombrements, empreintes |
| Ce qui n'est pas su | Les deux | Chacun y inscrit ses propres angles morts |

Ce partage est le premier emploi réel du régime hybride dans `clia`, et rien ne le vérifie. Voir `NON-005`.

## Frontière avec les autres types

C'est la frontière la plus fragile du type. `NON-003` la porte dans son ensemble.

| Type voisin | Frontière proposée | Fragilité |
|---|---|---|
| Intention (`INT`) | Le contexte dit ce qui **est**, l'intention dit ce qui est **visé** | Nette en principe. En pratique, un historique d'intentions abandonnées appartient aux deux |
| Fait (`FCT`) | Un fait est un énoncé vérifiable, daté et sourcé ; un contexte est une mise en situation, qui interprète et qui peut se tromper | Nette. Un contexte **cite** des faits, il n'en tient pas lieu |
| Analyse (`ANL`) | Une analyse est un travail daté sur un existant, immuable ; un contexte est un état tenu à jour | Un contexte se nourrit d'analyses. `CTX` sans `ANL` derrière lui est une opinion |
| Session | Voir le test d'admission ci-dessus | La frontière est la seule qui soit outillée, par le fichier de session |

## L'affect

`CLAUDE.md` demande de comprendre « comment se sent l'humain ». L'affect **entre dans le contexte**. `NON-003` Q2.

Il se déduit de `workspace/session.md` et s'écrit explicitement, soit dans une ressource `CTX`, soit dans la rubrique de contexte de la ressource concernée.

Il suit le régime de fiabilité de ce type : une affirmation d'agent, non vérifiée, et lue comme telle.

## Degré de fiabilité

Un contexte porte des affirmations qu'un agent, humain ou IA, pose **sans vérification**. `NON-003` Q5.

C'est ce qui le distingue d'un fait.

| Type | Ce qu'il affirme | Régime |
|---|---|---|
| `CTX`, et toute rubrique de contexte | Une situation telle qu'elle est perçue | Affirmé sans vérification, lu comme tel |
| `FCT` | Un énoncé dont la véracité a été établie | Éprouvé par un processus rigoureux et normé |

Un contexte peut donc énoncer des mesures sans les consigner comme faits. Le degré de fiabilité se déduit du type, il n'a pas à être déclaré instance par instance.

## Structure attendue d'une instance

```
# CTX-<SEQ> - <Titre>

> Résumé en une phrase de la situation.

## Situation
## Historique
## Acteurs
## Contraintes
## Constats et mesures
## Ce qui n'est pas su

## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)

## Points ouverts

| Question | Objection |
|---|---|
| Frontière avec Intention et Faits ; où va l'affect | `NON-003` |
| Le contexte doit-il être lisible par la machine pour que `clia` s'en serve | `NON-006` |
| Rien ne vérifie la propriété par bloc du régime hybride | `NON-005` |
| Faut-il un type Acteur distinct, plutôt qu'une rubrique de contexte | `NON-003` |
