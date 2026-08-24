---
type: decision
id: DCN-009
title: "Les ressources sont redigees dans un registre directif et factuel"
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

# DCN-009 - Les ressources sont rédigées dans un registre directif et factuel

> Décision de l'humain, tâches 15 et 17 de la session : une ressource énonce ce qui est, et n'explique pas pourquoi la décision a été prise. Le pourquoi va dans l'ADR, sous forme de bibliographie numérotée pour les références externes.

## Objet

Enregistrer la décision qui commande la réécriture des trente définitions et la correction de `skl-001`.

## La décision

Reprise de la tâche 15 de `workspace/session.md`, classée `[bogue]` :

> Les ressources RES devraient être décrites de manière directive et factuelle.
>
> Or, l'agent IA justifie sans cesse ses décisions comme s'il avait peur des reproches... À la limite, si des références externes sont nécessaires, les écrire sous la forme d'une bibliographie (liste numérotée de références externes). Mais NE PAS EXPLIQUER POURQUOI ON A PRIS UNE DÉCISION.

L'exécution est demandée par la tâche 17 : « Exécuter le plan PLN-002 ».

Le classement en `[bogue]` est significatif : ce n'était pas une question ouverte mais un défaut à corriger.

## Motivation du changement

Sans objet, cette décision n'en remplace aucune.

Elle corrige un défaut du harnais que `ANL-004` mesure : `skl-001` B3 prescrivait deux rubriques justificatives dans le gabarit de toute définition, en contradiction avec sa propre règle B1.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt.

Attestation `interne`. La trace est la tâche 15 de `workspace/session.md`, qui énonce la règle, et la tâche 17, qui en commande l'exécution.

## Portée

`systeme`. La règle s'applique à toute ressource, non aux seules définitions.

Les `ADR` en sont exclus par destination : `skl-001` B1 leur assigne le pourquoi.

## Conséquences

| Conséquence | Où elle est instruite |
|---|---|
| Le gabarit d'une définition perd ses deux rubriques méta | `ADR-015` D1 |
| La règle de registre `A6` est ajoutée au harnais | `ADR-015` D2 |
| Le contrôle `V10` est ajouté | `ADR-015` D3 |
| Six `ADR` d'adoption accueillent la justification retirée | `ADR-015` D4 |
| Les trente définitions sont réécrites | `ADR-015` D5 |

**Exécution du 2026-08-10.** Les trente définitions passent de 22 236 à 18 511 mots, soit une réduction de 16 pour cent. Zéro rubrique méta subsiste, zéro marqueur de justification. Le champ `adr` des trente définitions pointe désormais vers l'`ADR` d'adoption de leur famille et non plus vers `ADR-005`.

## Ce que la décision ne dit pas

Elle ne dit pas ce qu'est une justification dans une rubrique descriptive. `V10` détecte les rubriques nommées, non les phrases.

Elle ne fixe aucun seuil de longueur.

Elle ne dit pas si les `ADR` d'adoption doivent être approuvés ou peuvent rester `propose`.

## Relations

- `specifie` [ADR-015](../adr/ADR-015-registre-directif-et-gabarit-des-definitions.md)
- `derive-de` [ANL-004](../analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
