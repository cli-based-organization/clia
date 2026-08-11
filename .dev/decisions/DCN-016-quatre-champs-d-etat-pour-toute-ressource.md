---
type: decision
id: DCN-016
title: "Quatre champs d etat pour toute ressource"
version: 0.1.0
status: draft
instance: "human:jvtrudel"
date-de-decision: 2026-08-11
portee: systeme
effet: suspendue
attestation: interne
diffusion: public
---

# DCN-016 - Quatre champs d'état pour toute ressource

> **Premier jet produit par l'agent, non actif.** `DCN-013` pose qu'un premier jet d'IA reste suspendu jusqu'à approbation manuelle de l'humain. Le champ `effet` vaut `suspendue` pour cette raison.

## Objet

Enregistrer la décision de remplacer les champs d'état du modèle par quatre champs déclarés, demandée par les réponses à `NON-035`.

## La décision

Reprise de la réponse Q1 de `NON-035`, dans le texte de l'humain :

> Ce qu'il faut faire =>
> - avoir un champ représentant la maturité: conception, mature, fin-de-vie, obsolète
> - avoir un champ représentant l'adoption: proposé, adopté, contesté, obsolète
> - avoir un champ qui dit si on doit le considérer ou non: actif/inactif
> - et avoir un champ spécifique au cycle de vie métier => status-metier. les valeurs et le sens étant spécifié dans le RES correspondant

Et de la réponse Q3, qui en donne les noms :

> oui, refactorer toutes les ressources pour y ajouter:
> - maturity
> - adoption
> - activated: true | false
> - domain-status

### Les quatre champs

| Champ | Valeurs | Ce qu'il dit |
|---|---|---|
| `maturity` | `conception`, `mature`, `fin-de-vie`, `obsolete` | Où en est le document |
| `adoption` | `propose`, `adopte`, `conteste`, `obsolete` | Ce que le système en fait |
| `activated` | `true`, `false` | S'il faut le considérer |
| `domain-status` | Déclarées par le `RES` du type | Le cycle de vie métier |

### Ce qui est supprimé

Réponse Q4 : « oui, supprimer tous les autres cas de figure autres que celles qui ont été nommées dans ce NON. »

| Champ supprimé | Occurrences |
|---|---|
| `effet` | 49 |
| `etat` | 43 |
| `statut` | 36 |
| `statut-decision` | 17 |
| `statut-plan` | 6 |
| `exploitation` | 2 |
| `tenue` | 1 |
| **Total** | **154** |

Leurs valeurs sont reprises par `domain-status`, dont chaque `RES` déclare l'énumération.

### Le cas de `status`

Réponse Q2 : « Si OKF en a besoin, préserver. Sinon supprimer. »

**La condition n'est pas vérifiée.** Deux sources du corpus se contredisent, et la spécification OKF n'a pas été consultable.

| Source | Ce qu'elle dit |
|---|---|
| `RES-001` de `micrologic-clients`, lignes 39 et 99 | `status` vient d'OKF, `draft`, `stable`, `deprecated` « au sens d'OKF » |
| `ANL-006`, archivée | Les champs réservés OKF sont `type`, `title`, `description`, `tags`, `timestamp` |

`DCN-015`, créée le même jour, pose que l'implémentation doit être compatible OKF. Elle oriente vers la préservation sans lever la contradiction.

**Le sort de `status` reste donc ouvert**, et il est le seul point de cette décision qui le soit.

## Motivation du changement

Cette décision ne remplace aucune `DCN`. Elle corrige un défaut mesuré.

Ce que le modèle tenait pour acquis et qui ne l'est plus : qu'un champ d'état universel suffise. `NON-035` mesure que `status` vaut `draft` dans les cent cinquante-sept instances du dépôt, et qu'il est le seul état affiché par `clia res ls`.

Trois natures d'état étaient confondues sous un seul champ, et une quatrième, le cycle de vie métier, était portée par huit champs différents selon le type.

## Qui a décidé

`human:jvtrudel`, par les réponses Q1, Q3 et Q4 de `NON-035`.

**Rédaction par l'agent.** `DCN-013` l'autorise et pose que la décision reste suspendue jusqu'à approbation manuelle. `CONSTITUTION.md` C1 l'interdit ; le conflit entre les deux est ouvert depuis le 2026-08-11 et porté par `NON-033`.

Attestation `interne`. La trace est `NON-035`, questions Q1 à Q4.

## Portée

`systeme`. Les cent cinquante-sept instances du dépôt, et les trente-six définitions de type.

## Conséquences

| Conséquence | Volume |
|---|---|
| Quatre champs à poser sur chaque instance | **628 valeurs** |
| Champs d'état à supprimer | **154** |
| Définitions à réviser pour déclarer leurs valeurs de `domain-status` | 36 |
| Schémas à régénérer | 62 |

**Les valeurs ne sont pas déductibles.** Décider si une ressource est `mature` ou en `conception`, `adoptee` ou `contestee`, demande un jugement par instance.

**`adoption` constate ce que `NON-024` conteste.** `FCT-001` établit que les quatorze `DCN` et trois `PDC` du dépôt ont été rédigés par l'agent et qu'aucun n'est approuvé : leur `adoption` vaut `propose`.

**Aucun générateur n'existe** pour régénérer les soixante-deux schémas. `ISU-002` le porte.

## Ce que la décision ne dit pas

Le sort de `status`, faute d'avoir pu vérifier ce qu'OKF exige.

La langue des champs. Trois des quatre noms sont en anglais, `maturity`, `adoption`, `activated`, alors que le frontmatter existant est en français. La réponse Q1 nomme le quatrième `status-metier` et la réponse Q3 le nomme `domain-status`.

Qui pose les valeurs sur les cent cinquante-sept instances, alors que `adoption` relève d'une approbation humaine.

L'ordre entre cette décision et le générateur que `ISU-002` réclame.

## Relations

- `repond-a` [NON-035](../objections/NON-035-le-champ-status-ne-sert-a-rien.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [DCN-015](DCN-015-cette-implementation-doit-etre-compatible-okf.md)
