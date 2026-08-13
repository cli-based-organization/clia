---
type: fonctionnalite
id: FNC-007
title: "Focus sur une action à la fois"
version: 0.1.0
status: draft
etat: livree
usage: clia focus [--tout]
---

# FNC-007 - Focus sur une action à la fois

> Répond à « que dois-je faire maintenant ? » en nommant **une** action et la commande qui l'exécuterait.

## Ce qu'elle fait

Elle agrège tous les items ouverts du dépôt — objections, plans, issues, bogues — les range en cinq catégories avec leur destinataire, et désigne le plus prioritaire.

À l'intérieur d'une catégorie, l'item le plus cité ailleurs passe devant : le traiter libère le plus de travail.

## Comment s'en servir

```sh
clia focus          # une seule action, et la commande qui la ferait
clia focus --tout   # le décompte par catégorie, et les items de chacune
```

Exemple de sortie :

```
a faire     A CORRIGER
qui         agent
quoi        BUG-002 - Un plan est exécuté par la tâche qui le crée
cite par    2 document(s)
en attente  58 item(s) au total

clia res show BUG-002   # lire, puis corriger la cause
```

Les cinq catégories, dans l'ordre de priorité : `A CORRIGER` un bogue ouvert, `A EXECUTER` un plan proposé et SMART, `A DECIDER` une objection sans réponse, `A CLORE` une objection répondue, `A DEFRICHER` une issue ou un plan sans critère.

**Aucun item ouvert ne disparaît.** Seuls les états clos déclarés par le schéma retirent un item de la liste. Un item dont l'état est absent ou non renseigné est rangé à défricher, avec son défaut nommé :

```
A DEFRICHER
  NON-013   ce qu'est une ressource (etat absent)
  BUG-001   exécution de claude cli sans interruption (etat À RENSEIGNER)
```

## Ce qu'elle ne fait pas

**Elle n'exécute rien.** Elle nomme l'action et la commande ; le geste reste à faire.

L'ordre de priorité est un jugement de l'agent, inscrit dans le code. Le poids se calcule sur les renvois déclarés, et ceux-ci sont incomplets : `PLN-012` le déclare dans ses objections.

Elle ne dit pas *comment* traiter un item, seulement lequel prendre.

## Ce qui la porte

`lib/clia/focus.sh`. Livrée par `PLN-012`, dérivée de `ANL-011`.

## Relations

- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
- `reference` [FNC-001](FNC-001-gestion-des-ressources.md)
