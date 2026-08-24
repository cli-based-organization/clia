---
type: acteur
version: 0.1.1
title: "Installateur"
status: À réviser
date: 2026-07-29
categorie: primaire
portee: methode
---

# ACT-003 - Installateur

## Définition

L'humain qui **rend l'outil d'augmentation disponible sur un poste**, puis qui **équipe un dépôt**, le **fait évoluer** vers une version plus récente, ou le **ramène** à une version antérieure. Son travail porte sur le système d'augmentation, jamais sur le contenu de domaine.

L'équipement du poste est la **précondition** de l'équipement d'un dépôt : l'outil n'étant pas distribué avec le contenu ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), décision D6), il faut l'avoir installé séparément pour pouvoir s'en servir.

C'est le rôle le moins documenté du corpus alors qu'il porte les deux capacités attendues de la session courante. Il se distingue de [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) : l'installateur **déploie** ce que le mainteneur **produit**.

## Responsabilité

Répond de l'**état d'équipement** d'un dépôt : ce qui y est installé, dans quelle version, et de la réversibilité de l'opération. Répond du fait que le contenu du dépôt hôte n'est pas altéré par une opération d'installation.

## Buts poursuivis

- Équiper un dépôt du système d'augmentation.
- Faire évoluer un dépôt déjà équipé vers une version plus récente.
- Ramener un dépôt équipé à son état antérieur.
- Savoir ce qui est installé et dans quel état.

## Intérêts

- Que l'opération soit **réversible** : pouvoir revenir en arrière est la condition d'oser avancer.
- Que l'opération soit **sans surprise** sur le contenu du dépôt hôte : elle ne touche que le système d'augmentation.
- Que l'état d'équipement soit **inspectable** sans lire le code.
- Que l'opération se comporte de la même façon sur un dépôt neuf et sur un dépôt déjà équipé, à ceci près qu'elle installe dans un cas et met à niveau dans l'autre.

## Préconditions d'accès

- Un dépôt cible accessible en écriture, neuf ou déjà équipé.
- Une source d'installation disponible localement.
- Les dépendances d'exécution présentes dans l'environnement ([`ACT-006`](ACT-006-dependances-externes.md)).

## Modes d'échec caractéristiques

- Le dépôt cible est **déjà équipé** alors qu'il croyait l'équiper, ou l'inverse.
- L'opération **échoue à mi-course** et laisse le dépôt dans un état intermédiaire, ni ancien ni nouveau.
- Le retour en arrière ne restitue pas l'état antérieur exact.
- Une ressource du dépôt hôte **modifiée localement** est écrasée par une mise à niveau.
- Une dépendance manque et la panne se manifeste tard, au milieu de l'opération plutôt qu'à son début.

## Ce que ce rôle ne fait pas

- Il ne conduit pas le travail quotidien dans le dépôt équipé ([`ACT-001`](ACT-001-operateur-du-depot.md)).
- Il ne fait pas évoluer le contenu du système d'augmentation ([`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md)) : il en déploie une version.
- Il ne produit ni ne modifie de livrable de domaine dans le dépôt hôte.

## Relations

- **Rôles voisins** : [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) (produit ce qu'il déploie), [`ACT-001`](ACT-001-operateur-du-depot.md) (bénéficie du dépôt équipé), [`ACT-006`](ACT-006-dependances-externes.md) (conditionne l'opération).
- **Utilise** : aucun `USE` n'existe encore. Les trois parcours d'installation dont ce rôle est l'acteur principal sont produits à l'étape 3.2 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) ; ils sont écrits indépendamment de l'outil qui les réalise ([`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md)).
- **Source** : typologie A3 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
