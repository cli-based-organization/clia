---
type: decision
id: DCN-008
title: "L identifiant interne est un alias, l identite est celle de l oeuvre"
version: 0.1.0
status: draft
maturity: conception
adoption: adopte
activated: true
domain-status: "en-vigueur"
instance: "human:jvtrudel"
date-de-decision: 2026-08-10
portee: systeme
effet: en-vigueur
attestation: interne
diffusion: public
---

# DCN-008 - L'identifiant interne est un alias, l'identité est celle de l'oeuvre

> Onze réponses de l'humain aux questions de `NON-001`. La principale corrige `ADR-007` D1 : `<PREFIX>-<SEQ>` est l'alias interne d'une ressource, non son identité.

## Objet

Enregistrer les réponses écrites par l'humain dans `NON-001` le 2026-08-10, afin qu'elles soient citables sans relire l'objection.

## La décision

Onze réponses, reprises de `NON-001`. Le texte est celui de l'humain.

| Réf | Question | Réponse |
|---|---|---|
| Q1 | L'identité est-elle le champ `id` ou le chemin ? | « non. voir FRG-001. » |
| Q2 | Que se passe-t-il si deux dépôts emploient le même `id` ? | « l'identité n'est pas `<PREFIXE>-<SLUG>` » |
| Q3 | `NON` ou `OBJ` pour l'objection ? | « utiliser NON comme préfix pour les objections » |
| Q4 | Le numéro de séquence doit-il rester dans le nom de fichier ? | « Le système d'identifiant interne n'a besoin que d'être relatif et auto-cohérent. `<PREFIX>-<SEQ>` est l'implémentation par défaut de l'id-interne/alias de l'identifiant. » |
| Q5 | Que devient un renvoi par numéro déjà écrit ? | « Pour les références externe, nous allons utiliser un identifiant plus "robuste". Mais les modifications internes de l'alias/identifiant doit modifier du même coup toutes les références » |
| Q6 | Un renommage de slug est-il un changement d'identité ? | « Le slug n'a rien à voir avec l'identifiant, il n'est là que pour aider les humains à se repérer. On peut changer le slug sans conséquense. » |
| Q7 | Qui attribue le numéro de séquence ? | « le cli clia avec `clia res new TYPE DESCRIPTION` » |
| Q8 | L'identité désigne-t-elle l'oeuvre ou la version ? | « l'oeuvre. La version est défini par le mécanisme de publication externe. À l'interne, les modifications sont traçables par l'historique. » |
| Q9 | Faut-il un identifiant intrinsèque ? | « l'identifiant intrinsèque est utile pour suivre l'historique et attester des modificaitons. (git) » |
| Q10 | Format d'un identifiant de dépôt ? | Forme proposée, déclarée non définitive. Voir ci-dessous |
| Q11 | L'ergonomie est-elle une exigence opposable ? | « L'ergonomie interne est une exigence non négociable. » Format par défaut décidé : `PREFIX-SEQ` |
| Q12 | Corriger un slug et changer de sujet sont-ils la même opération ? | « non. le slug n'a rien à voir avec l'identité. » |

### La réponse à Q1, développée par le fragment

Q1 renvoie à `FRG-001`, section « Système d'identité : autorité, alias et mécanisme de traçabilité ». Trois énoncés de l'humain y sont opérants.

> On distingue 2 régimes d'identification : interne ou relatif, externe.

> Pour le système, l'identification n'a pas besoin d'être exhaustif. Les contraintes sont plus légères et les « identifiants » peuvent même changer, tant que toutes les références internes sont adaptées de manières cohérentes.

> Aussi, nous adopterons un système hybride fondé sur 1. un système d'alias auto-cohérent facilement utilisable en interne, et 2. des identifiants complets.

`FRG-001` porte deux phrases interrompues, dont la seconde de cette dernière citation. Le fragment appartient à l'humain et n'est pas complété.

### La réponse à Q10, non définitive

L'humain la déclare comme telle : « C'est une question complexe pour laquelle je n'ai pas de solution définitive. Mais voici une tentative ».

```
clia://<author|personne qui partage>@<repo>/<origin>:<PREFIX>-<UUID>/<hash-version>
```

Avec `origin` désignant l'instance du dépôt, et la conséquence énoncée par l'humain : « chaque instance du repo doit avoir un identifiant (éphémère) ».

Cette forme est enregistrée comme orientation, non comme décision. `NON-023` porte ce qu'elle laisse ouvert.

## Motivation du changement

Cette décision ne remplace aucune `DCN`. Elle en **corrige une partie**.

`DCN-007`, du 2026-08-09, enregistre que l'identifiant interne d'une ressource est `<PREFIX>-<SEQ>`. Sa formulation et l'`ADR-007` qui l'instruit font de cette forme l'**identité**.

Ce que cette position tenait pour acquis et qui ne l'est plus : qu'un identifiant interne stable soit la même chose qu'une identité. `FRG-001` sépare les deux et pose un régime interne, où l'identifiant peut changer, et un régime externe, où il doit être complet. `<PREFIX>-<SEQ>` appartient au premier.

**Ce qui est corrigé** : `ADR-007` D1, l'identité, et `ADR-007` D2, l'interdiction de renuméroter, que Q5 remplace par une obligation de propagation.

**Ce qui subsiste** : `ADR-007` D3, D4 et D5, ainsi que la forme `<PREFIX>-<SEQ>` elle-même, confirmée par Q11 comme format par défaut.

`DCN-007` conserve donc `effet: en-vigueur`. Le remplacement partiel d'une décision n'est modélisé ni par `RES-009` ni par `MET-002`, qui ne connaissent que le remplacement entier. `NON-023` porte cette lacune, constatée à la première application réelle du mécanisme écrit à la tâche 14.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt.

Attestation `interne`. La trace est double : les réponses écrites dans `.dev/objections/NON-001-identite-et-nommage.md`, sections Q1 à Q12, et le fragment `FRG-001` capté par l'humain le 2026-08-10.

## Portée

`systeme`.

Les réponses Q1 à Q9, Q11 et Q12 sont en vigueur. La réponse Q10 est une orientation déclarée non définitive par son auteur.

## Conséquences

| Conséquence | Où elle est instruite |
|---|---|
| Deux régimes d'identification, interne et externe | `ADR-008` D1 |
| `<PREFIX>-<SEQ>` est l'alias interne par défaut, non l'identité | `ADR-008` D2, abroge `ADR-007` D1 |
| Renuméroter est permis si toutes les références sont propagées | `ADR-008` D3, abroge `ADR-007` D2 |
| Le slug est libre et sans effet sur l'identité | `ADR-008` D4 |
| L'identité désigne l'oeuvre ; la version relève de la publication externe | `ADR-008` D5 |
| L'identifiant intrinsèque est fourni par git | `ADR-008` D6, raccorde `ANL-005` |
| L'ergonomie interne est une exigence non négociable | `PDC-002` |

**Aucun fichier n'est renommé.** Q11 fixe `PREFIX-SEQ` comme format par défaut. La correction porte sur le statut de cette forme, non sur sa valeur.

**Deux objections reçoivent une réponse.** `NON-001` passe de `partiellement-repondue` à `repondue`, ses douze questions portant une réponse. `NON-019` Q2, qui demandait comment vérifier l'interdiction de renuméroter, change d'objet : l'interdiction est levée, la propagation la remplace.

## Ce que la décision ne dit pas

Elle ne fixe pas l'identifiant externe. Q10 est déclarée non définitive par son auteur.

Elle ne dit pas ce qui porte l'identité de l'oeuvre à l'interne, si l'alias ne la porte pas. Q8 dit que l'identité désigne l'oeuvre ; aucune réponse ne dit par quoi elle est représentée dans le dépôt.

Elle ne dit pas comment la propagation d'un changement d'alias est vérifiée. Q5 en fait une obligation, rien ne l'outille.

Elle ne dit pas si le champ `id` du frontmatter subsiste, question ouverte par `NON-019` Q1 et inchangée.

Elle ne dit pas ce qu'est un identifiant d'instance de dépôt, ni ce que « éphémère » signifie pour lui.

## Relations

- `specifie` [ADR-008](../adr/ADR-008-regime-d-identification-a-deux-niveaux.md)
- `derive-de` [FRG-001](../fragments/FRG-001-conception-des-ressources-et-de-son-identite.md)
- `repond-a` [NON-001](../objections/NON-001-identite-et-nommage.md)
- `reference` [DCN-007](DCN-007-identifiant-relatif-par-sequence.md)
