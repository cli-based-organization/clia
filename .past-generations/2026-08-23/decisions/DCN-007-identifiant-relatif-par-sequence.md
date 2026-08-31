---
type: decision
id: DCN-007
title: "L identifiant interne d une ressource est PREFIX-SEQ"
version: 0.1.0
status: draft
maturity: conception
adoption: adopte
activated: true
domain-status: "en-vigueur"
instance: "human:jvtrudel"
date-de-decision: 2026-08-09
portee: systeme
effet: en-vigueur
attestation: interne
diffusion: public
---

# DCN-007 - L'identifiant interne d'une ressource est `<PREFIX>-<SEQ>`

> Décision de l'humain, prise dans la tâche 13 de la session : à l'interne d'un dépôt `clia`, toutes les ressources sont référençables par `<PREFIX>-<SEQ>`, et les formes `<PREFIX>-<DATE>` et `<PREFIX>-<SLUG>` sont éliminées.

## Objet

Enregistrer une décision qui renverse une décision antérieure de l'agent, afin que le renversement soit tracé et non subi.

## La décision

Reprise de la tâche 13 de `workspace/session.md`, classée `[bogue]` :

> À l'interne d'un repo clia, toutes les ressources doivent être référençables (alias) par : `<PREFIX>-<SEQ>`.
>
> Pour les ressources RES, éliminer toute référence à `<PREFIX>-<DATE>` et `<PREFIX>-<SLUG>`.
>
> Corriger les noms de fichier et les références.

Le classement en `[bogue]` est significatif : pour l'humain, ce n'était pas une question ouverte mais un défaut à corriger.

## Motivation du changement

Cette décision ne remplace aucune `DCN`, et elle renverse une position antérieure de l'agent, `ADR-001` D3, qui posait que l'identité d'une ressource est `<PREFIXE>-<SLUG>`.

Ce que cette position tenait pour acquis et qui ne l'est plus : que le numéro de séquence se renumérote. Le fondement était mesuré, `ANL-001` relevant douze numéros de skill sur vingt portant plusieurs noms selon le dépôt. Le renversement ne conteste pas la mesure : il pose que la renumérotation est interdite, ce qui rend le numéro stable et donc apte à porter l'identité.

Section ajoutée le 2026-08-10 par la migration vers `RES-009` v0.2.0, qui rend cette rubrique obligatoire.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt.

La décision est adossée à un fragment que l'humain a capté le 2026-08-10, `FRG-001`, dont une phrase porte la prémisse : « Ce qui persiste par-delà des modifications est l'identité. » Le numéro persiste, le slug suit un titre révisable.

## Portée

`systeme`, et **relative au dépôt**. `RES-001` ne désigne la même ressource que dans un dépôt donné.

## Conséquences

| Conséquence | Où elle est instruite |
|---|---|
| L'identité est `<PREFIX>-<SEQ>` ; `ADR-001` D3 est abrogé | `ADR-007` D1 |
| Renuméroter est interdit : c'est un changement d'identité | `ADR-007` D2 |
| Le slug porte le libellé et, pour une définition, le nom canonique du type | `ADR-007` D3 |
| Le nommage daté est aboli ; le cycle de vie ne commande plus que le versionnage | `ADR-007` D4 |
| L'identifiant est relatif au dépôt, sans prétention d'unicité globale | `ADR-007` D5 |

**Migration effectuée le 2026-08-10.** Quatre-vingt-trois identifiants convertis dans quatre-vingt-trois fichiers. Un fichier renommé, `FRG-2026-08-10-...` devenant `FRG-001-...`. Le schéma d'identité, le générateur d'artefacts et le mécanisme de dérivation du nom canonique dans `clia` sont alignés. Quatre-vingt-deux ressources sur quatre-vingt-quatre valident leur schéma.

**Deux objections reçoivent une réponse.** `NON-001` Q1, bloquante depuis le 2026-08-09, sur l'identité par slug ou par chemin : la réponse est ni l'un ni l'autre, c'est la séquence. Et `NON-011` Q2, sur le nommage daté ou séquencé des types point fixe : la réponse est séquencé pour tous.

## Ce que la décision ne dit pas

Elle ne dit pas si le champ `id` doit subsister, alors qu'il devient déductible du nom de fichier.

Elle ne dit pas comment l'interdiction de renuméroter est vérifiée.

Elle ne dit pas comment un renvoi inter-dépôts se fait, l'identifiant étant relatif. La suggestion S3 de `ANL-003`, qui propose une identité étendue par extension du noyau, reste applicable.

Elle ne supprime pas l'ambiguïté de `clia res show 002` quand deux types portent un rang 002. Elle la rend acceptable, un identifiant complet portant toujours son préfixe.

## Relations

- `specifie` [ADR-007](../adr/ADR-007-identifiant-relatif-par-sequence.md)
- `derive-de` [FRG-001](../fragments/FRG-001-conception-des-ressources-et-de-son-identite.md)
- `repond-a` [NON-001](../objections/NON-001-identite-et-nommage.md)
