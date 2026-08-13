---
type: issue
id: ISU-012
title: "La mise à jour d'un dépôt instrumenté n'a pas d'objet"
status: draft
initiateur: agent
etat: ouverte
ouverture: 2026-08-12
---

# ISU-012 - La mise à jour d'un dépôt instrumenté n'a pas d'objet

> `clia setup upgrade [VERSION]` a été demandé et n'a pas pu entrer dans `PLN-009` : trois choses lui manquent, et sans elles aucun critère de réussite ne peut être écrit.

## Journal

- 2026-08-12 : ouverte par l'agent, tâche 4 de `SES-002`, à la demande de l'humain : « Créer un ISU + NON pour tout ce qui n'est pas SMART ».

## La problématique

La demande énonce :

```sh
clia setup upgrade [VERSION]  # met à jour ce repo en compatibilité avec la version latest ou VERSION
```

**Trois choses manquent, et chacune suffit à bloquer.**

| Ce qu'il faudrait | État |
|---|---|
| Une version déclarée par le dépôt instrumenté | **N'existe pas** |
| Un mécanisme de migration entre deux versions | **N'existe pas** |
| Un inventaire de ce qui change d'une version à l'autre | **N'existe pas** |

**Sans le premier, `upgrade` ne sait pas d'où il part.** `CLIA_VERSION` vaut `0.1.0` dans `bin/clia` : c'est la version du CLI, pas celle d'un dépôt instrumenté. Rien, dans un dépôt cible, ne dit sous quelle version il a été instrumenté.

**Sans le deuxième, il ne sait pas quoi faire.** Migrer suppose de savoir transformer l'état ancien en état neuf, fichier par fichier.

**Sans le troisième, il ne sait pas où s'arrêter.** Aucun document ne dit ce qui a changé entre deux versions de `clia`.

## Pourquoi cela compte plus qu'il n'y paraît

**C'est le second critère de convergence de `SES-002`** : « La mise à jour de `clia` et la migration des données est 1. possible et 2. facile. »

`PLN-009` livre quatre chantiers sur cinq commandes demandées. **Celle qui manque est celle qui porte un critère de convergence de la session.**

## Ce qui est mesuré

| Mesure | Valeur |
|---|---|
| Version déclarée par `bin/clia` | `0.1.0` |
| Dépôts instrumentés déclarant une version | **0** |
| Documents décrivant un changement entre deux versions | **0** |
| Mécanismes de migration dans le dépôt | **0** |

**Le dépôt a déjà migré des données trois fois** sans mécanisme : le passage de l'identifiant à slug à l'identifiant à séquence, le renommage du répertoire de session, et la conversion de `open` en `opened`. Les trois ont été faits à la main, par l'agent ou par l'humain, sans trace réutilisable.

## Ce qu'il faudrait pour la fermer

Quatre livrables, dans cet ordre.

| Réf | Livrable |
|---|---|
| L1 | Un fichier de version dans le dépôt instrumenté, posé par `clia setup init` |
| L2 | Un inventaire de ce qui constitue une version instrumentée |
| L3 | Un format de migration, et l'endroit où les migrations vivent |
| L4 | `clia setup upgrade`, qui applique les migrations entre deux versions |

**L1 est faisable dès maintenant** et peut s'ajouter au chantier C de `PLN-009` : poser un fichier de version coûte peu et évite d'avoir à le rétro-ajouter.

**L3 est le vrai travail.** Une migration transforme des fichiers de l'utilisateur, elle doit être réversible ou vérifiable, et `ANL-005` T1 rappelle qu'un renommage accompagné d'une réécriture coupe l'historique git sans que rien ne le signale.

## Relations

- `derive-de` [PLN-009](../plans/PLN-009-commandes-d-installation-et-d-instrumentation.md)
- `reference` [NON-039](../objections/NON-039-ce-que-les-commandes-d-installation-laissent-ouvert.md)
- `reference` [ANL-005](../analyses/ANL-005-tracabilite-de-l-historique-des-ressources.md)
