---
type: acteur
version: 0.1.0
title: "Système de fichiers du dépôt"
status: proposé
date: 2026-07-29
categorie: secondaire
portee: methode
---

# ACT-005 - Système de fichiers du dépôt

## Définition

Le **support d'état** du système d'augmentation. Toute la mémoire du système y vit : ressources, traces, état de session, version du domaine. C'est un acteur **secondaire** : il est sollicité pendant chaque parcours, il n'a aucun but propre, mais il peut faire échouer n'importe quel parcours.

Le système d'augmentation ayant choisi les fichiers comme interface de travail ([`PDC-004`](../principes/PDC-004-interface-fichiers-pas-conversation.md)), ce rôle n'est pas un détail technique : c'est le seul dépositaire de l'état.

## Responsabilité

Rend durables les écritures et restitue à la lecture ce qui a été écrit. Aucune autre garantie ne lui est demandée.

## Buts poursuivis

Aucun. Un acteur secondaire répond à des sollicitations, il ne poursuit rien.

## Intérêts

Aucun en propre. Ses **contraintes** sont en revanche à respecter par les parcours : droits d'accès, espace disponible, sensibilité à la casse, comportement des liens et des chemins.

## Préconditions d'accès

- Le dépôt existe et est accessible en lecture.
- Les zones que le parcours doit écrire sont accessibles en écriture.

## Modes d'échec caractéristiques

- **Écriture refusée** : droits insuffisants, dépôt monté en lecture seule.
- **Écriture partielle** : interruption en cours d'opération laissant un fichier tronqué ou un ensemble incohérent.
- **État absent ou inattendu** : le fichier d'état attendu n'existe pas, ou en existe deux là où un seul est admis.
- **Divergence d'environnement** : comportement différent selon la casse, l'encodage ou la résolution des chemins.

Ces modes d'échec sont la raison d'être de la garantie minimale exigée de chaque cas d'usage ([`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md)) : ce qui reste vrai quand l'écriture échoue.

## Ce que ce rôle ne fait pas

- Il ne valide rien : la conformité de ce qui est écrit relève du système, pas du support.
- Il n'arbitre aucun conflit ; il n'a pas de notion de version.

## Relations

- **Rôles voisins** : [`ACT-006`](ACT-006-dependances-externes.md) (autre acteur secondaire, conditionne l'exécution plutôt que l'état).
- **Sollicité par** : tous les parcours, sans exception.
- **Source** : typologie A5 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
