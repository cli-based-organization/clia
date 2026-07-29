---
type: acteur
version: 0.1.0
title: "Dépendances externes"
status: proposé
date: 2026-07-29
categorie: secondaire
portee: methode
---

# ACT-006 - Dépendances externes

## Définition

Les **services techniques fournis par l'environnement** dont le système d'augmentation a besoin pour fonctionner : interpréteur de commandes, lecteur de données structurées, gestionnaire de versions opéré par l'humain. Acteur **secondaire** : sollicité pendant les parcours, sans but propre, mais capable de les faire échouer avant même leur premier pas.

Le système revendique une **sobriété** de dépendances : peu, explicites, et vérifiables. Ce rôle existe pour que cette sobriété soit une propriété déclarée plutôt qu'une habitude.

## Responsabilité

Fournit l'exécution, la lecture des sources structurées et le versionnage du contenu. Leur présence et leur version conditionnent le comportement du système.

## Buts poursuivis

Aucun. Acteur secondaire.

## Intérêts

Aucun en propre. La **contrainte** portée par ce rôle est que toute dépendance soit nommée quelque part, et que son absence produise un échec explicite plutôt qu'un comportement dégradé.

## Préconditions d'accès

- Les dépendances requises sont installées et accessibles dans l'environnement d'exécution.
- Leur version est compatible avec ce que le système suppose.

## Modes d'échec caractéristiques

- **Dépendance absente** : le parcours échoue ; le mode d'échec attendu est un message qui nomme ce qui manque, en début de parcours plutôt qu'en son milieu.
- **Version incompatible** : la dépendance est présente mais se comporte autrement que supposé, ce qui produit une panne plus difficile à diagnostiquer qu'une absence.
- **Environnement divergent** : le système est développé sur un environnement et exécuté sur un autre, où les mêmes commandes ne se comportent pas identiquement.

## Ce que ce rôle ne fait pas

- Il ne garantit rien sur l'état du dépôt ([`ACT-005`](ACT-005-systeme-de-fichiers.md)).
- Le gestionnaire de versions, en particulier, **n'est jamais opéré par l'agent** : il est actionné par l'humain seul ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)).

## Relations

- **Rôles voisins** : [`ACT-005`](ACT-005-systeme-de-fichiers.md) (support d'état), [`ACT-003`](ACT-003-installateur.md) (premier exposé à leur absence).
- **Sollicité par** : les parcours d'installation et d'inspection en premier lieu.
- **Source** : typologie A6 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
