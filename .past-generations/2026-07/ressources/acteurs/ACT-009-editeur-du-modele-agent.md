---
type: acteur
version: 0.1.0
title: "Éditeur du modèle d'agent"
status: À réviser
date: 2026-07-29
categorie: partie-prenante
portee: methode
---

# ACT-009 - Éditeur du modèle d'agent

## Définition

L'organisation qui fournit le **modèle d'agent** et son environnement d'exécution, et qui en fixe les conventions : emplacement et forme des fichiers de harnais, mécanisme de compétences réutilisables, capacités et limites de l'outillage mis à disposition de l'agent.

Partie prenante **hors scène** : elle n'intervient dans aucun parcours, mais ses conventions contraignent la forme du harnais, et ses évolutions peuvent le périmer sans préavis.

## Responsabilité

Aucune vis-à-vis de ce dépôt. Ce rôle figure au catalogue parce qu'il est la source d'une **contrainte externe non négociable** : le harnais doit rester compatible avec la plateforme qui exécute l'agent.

## Buts poursuivis

Aucun dans le système.

## Intérêts

- La conformité du harnais aux conventions de la plateforme.
- L'usage des mécanismes prévus par la plateforme plutôt que de contournements maison.

## Préconditions d'accès

Aucune. Ce rôle n'accède pas au dépôt.

## Modes d'échec caractéristiques

- Les conventions de la plateforme **changent**, et le harnais qui s'y conformait cesse d'être pris en compte, sans erreur visible.
- Le harnais s'écarte des conventions et fonctionne par accident, jusqu'à ce qu'il cesse de fonctionner.
- Une capacité supposée disponible ne l'est pas dans l'environnement d'exécution réel.

Ces modes d'échec sont silencieux : ils ne produisent pas d'erreur mais une **dégradation non signalée** du comportement de l'agent, ce qui les rend particulièrement coûteux.

## Ce que ce rôle ne fait pas

- Il ne décide ni du contenu du harnais ni de la méthode de travail : il en contraint la forme.
- Il ne participe à aucune décision du dépôt.

## Relations

- **Rôles voisins** : [`ACT-002`](ACT-002-agent-ia.md) (exécuté sur sa plateforme), [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) (subit ses évolutions).
- **Contrainte portée sur** : la forme et l'emplacement des fichiers de harnais et des skills ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md)).
- **Source** : typologie P3 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
