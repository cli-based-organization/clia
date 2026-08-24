---
type: bogue
id: BUG-004
title: "Un plan SMART n'est pas exécutable, et rien ne le signale"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouvert"
regle: "Un plan SMART, exécuté, produit les livrables qu'il planifie"
constate-le: 2026-08-13
etat: ouvert
---

# BUG-004 - Un plan SMART n'est pas exécutable, et rien ne le signale

> L'humain demande l'exécution de `PLN-007`. Cinq chantiers sur sept sont bloqués par une décision suspendue, et le plan le déclare dans ses propres objections. `clia focus` le proposait pourtant à l'exécution depuis quatre tâches.

## Journal

- 2026-08-13 : ouvert par l'agent, tâche 11 de `SES-002`, en tentant d'exécuter `PLN-007`.

## L'écart

**Le comportement attendu**, énoncé par l'humain à la tâche 8 :

> - un plan SMART signifie qu'on peut exécuter le plan et qu'il produira les livrables planifiés
> - sinon, c'est une ERREUR et il faut ouvrir un BUG

**Le comportement constaté** :

| Mesure | Valeur |
|---|---|
| Chantiers de `PLN-007` | 7 |
| Chantiers exécutables ce jour | **0** |
| Chantiers déjà satisfaits, sans que le plan le dise | 2 |
| Chantiers bloqués par une décision suspendue | 5 |
| Rang que `clia focus` donnait au plan | **`A EXECUTER`, 2ᵉ priorité du dépôt** |

## La règle enfreinte

**Un plan SMART, exécuté, produit les livrables qu'il planifie.**

C'est la même règle que `BUG-002`. **La cause est différente, et c'est ce qui justifie un bogue distinct.**

| | `BUG-002` | `BUG-004` |
|---|---|---|
| Cause | Le plan a été exécuté par la tâche qui l'a créé | Le plan n'a jamais été exécutable |
| Ce qui manquait | Une règle sur le type de la tâche | Un critère d'exécutabilité |
| Corrigé par | `MET-005` étape 1 | Rien à ce jour |

## Comment le reproduire

1. Écrire un plan dont chaque chantier déclare un livrable, un critère et une limite — il satisfait `PDC-003`.
2. Faire dépendre ce plan d'une décision dont `effet` vaut `suspendue`, ou d'une issue ouverte.
3. Lancer `clia focus`.
4. Constater que le plan est rangé en `A EXECUTER`.

**Reproduit sur `PLN-007`**, proposé à l'exécution du 2026-08-13 au moins, alors que `DCN-016` est suspendue depuis le 2026-08-11.

## La cause

**`PDC-003` mesure la forme d'un chantier, pas la disponibilité de ses préalables.**

Ses trois contrôles — livrable unique, critère exécutable, limite de temps — portent sur ce que le plan déclare. Aucun ne regarde ce dont il dépend.

**Le critère de `clia focus` hérite de ce trou.** Il compte les occurrences de `**Livrable**` et `**Critère de réussite**` dans le fichier. `PLN-007` en a sept de chaque : il est déclaré prêt.

**L'information manquante existe pourtant, écrite en clair.** `PLN-007` porte dans ses relations `derive-de DCN-016`, et `DCN-016` porte `effet: suspendue`. Le lien est déclaré, personne ne le suit.

**Un second signal existe aussi** : `MET-004` étape 6 pose déjà « ne pas implémenter un livrable dont le préalable est ouvert, même s'il est SMART ». La règle est écrite dans une méthodologie, et rien ne la rend mécanique — c'est le même défaut que `NON-005` décrit.

## La correction

**Appliquée le 2026-08-13, tâche 11** : `clia focus` ne propose plus à l'exécution un plan dont une décision dont il dérive porte `effet: suspendue`. Un tel plan est rangé à défricher, avec son préalable nommé.

```
A DEFRICHER
  PLN-007   Mise en oeuvre des quatre champs d'état (prealable suspendu : DCN-016)
```

**Ce que la correction détecte, exactement.** Toute mention d'un alias `DCN` dans le corps du plan, dont la décision porte `effet: suspendue`. Le lien n'a donc pas besoin d'être déclaré en relation — `PLN-007` cite `DCN-016` dans son frontmatter, dans ses relations et dans sa prose.

**C'est délibérément large.** Un faux positif range un plan à défricher avec son motif nommé, et l'humain le voit ; un faux négatif est ce que ce bogue constate. Aucun faux positif sur les quatorze plans du dépôt au 2026-08-13.

**Ce qu'elle ne détecte pas.** Trois formes du même défaut restent invisibles.

| Forme | Cas observé |
|---|---|
| Un plan bloqué par une issue ouverte | — |
| Un point d'arrêt écrit en prose | `PLN-007` chantier B : « le sort de `status` doit être tranché » |
| **Un plan partiellement exécuté dont le reste est hors d'atteinte** | `PLN-015` le 2026-08-13 : A a échoué, B est fait, C dépendait de A. Il reste `propose`, et `clia focus` le propose toujours à l'exécution |

**Le troisième cas a été constaté en validant la tâche 12**, une heure après la correction. Il montre que le défaut est plus large que le lien vers une décision suspendue : **c'est l'exécutabilité elle-même qui n'est modélisée nulle part**, ni dans `PDC-003`, ni dans le frontmatter du plan.

**Ce qui reste ouvert** : porter l'exécutabilité dans le régime SMART lui-même, plutôt que dans la seule commande qui le lit. Le bogue reste `ouvert` pour cette raison.

## Relations

- `reference` [BUG-002](BUG-002-un-plan-est-execute-par-la-tache-qui-le-cree.md)
- `porte-sur` [PLN-007](../plans/PLN-007-quatre-champs-d-etat.md)
- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
- `reference` [MET-004](../methodologies/MET-004-reevaluation-d-un-plan-par-le-regime-smart.md)
