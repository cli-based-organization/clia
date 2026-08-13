---
type: objection
id: NON-021
title: "Le processus de travail ne prévoit aucune recherche préalable à une décision"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [ADR-002, ADR-007, MET-001]
---

# NON-021 - Le processus de travail ne prévoit aucune recherche préalable à une décision

> `ADR-007` a été écrit le 2026-08-09 et décide deux règles d'identité. Michael Nygard prescrit les deux, dans les mêmes termes, dans un billet de novembre 2011. `FND-003` l'a découvert le lendemain, en cherchant autre chose. Rien dans le processus de travail n'aurait permis de le savoir avant de décider.

## Journal

- 2026-08-10 : ouverte par l'agent, à la tâche 14, après lecture de la source primaire du champ des ADR.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est constaté

Deux décisions du dépôt reproduisent des prescriptions publiées quinze ans plus tôt.

| Décision du dépôt | Prescription de Nygard, 2011 |
|---|---|
| `ADR-007` D1 et D2 : l'identité est la séquence, un numéro n'est jamais réattribué | « Les ADR seront numérotés séquentiellement et de façon monotone. Les numéros ne seront pas réemployés » |
| `RES-009` : la décision remplacée est conservée et marquée | « Si une décision est renversée, nous garderons l'ancienne, mais la marquerons comme remplacée. Il reste pertinent de savoir qu'elle a été la décision, mais qu'elle ne l'est plus » |

Aucune des deux ne cite Nygard, pour une raison simple : ni `ADR-007` ni `RES-009` n'ont été précédés d'une recherche.

`FND-003` en tire deux lectures qui ne s'excluent pas. La convergence indépendante est un indice de solidité : deux raisonnements séparés par quinze ans aboutissent à la même règle. Et elle établit qu'un travail considérable a reproduit un billet de blog de 2011.

## Ce qui est contesté

Non pas les décisions, qui sont bonnes et que la convergence conforte. Le **processus** qui les a produites.

`ADR-002` définit le mécanisme de travail collaboratif : analyse de la demande, journalisation, production de livrables définis, encadrement par harnais, émission d'objections, segmentation en sessions. Aucune étape n'exige de vérifier si la question posée a déjà une réponse publiée.

Le dépôt possède pourtant le type qui sert à cela, `FND`, et la méthodologie qui le produit, `MET-001`. Rien ne dit quand les employer avant de décider.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Le défaut reproché est exactement celui qui a été commis.** `FND-003` établit que le champ des ADR a réinventé une version simplifiée du design rationale sans citer aucune de ses sources, et le formule comme sa trouvaille principale. Le même document constate que ce dépôt vient de faire la même chose à l'égard des ADR. Une critique qu'on adresse à autrui et qu'on ne s'applique pas est sans valeur.

**Le coût de la découverte tardive est asymétrique.** Ici, la découverte a conforté la décision, et le coût est nul. Si la source avait établi que la règle mène à une impasse connue, le coût aurait été une décision appliquée à quatre-vingt-trois fichiers, plus la migration de retour.

**Le dépôt ne saura pas combien de fois cela se produit.** Deux cas ont été trouvés par hasard, en cherchant un autre sujet. Rien n'indique qu'il n'y en ait que deux, et rien ne permet de les compter.

## Ce qui plaide contre l'objection

Il faut le dire, sinon l'objection est un plaidoyer.

Une recherche préalable systématique coûterait, selon la mesure de `FND-003`, une tâche entière par décision. Le dépôt a produit sept ADR en deux jours ; sept fondations préalables auraient consommé la session complète sans qu'aucune décision ne soit prise.

Le coût d'une recherche préalable est certain. Le bénéfice est probabiliste : il ne se réalise que lorsqu'une littérature existe et qu'elle contredit l'intuition. C'est précisément l'arbitrage coût-bénéfice que Horner et Atwood identifient comme l'obstacle central à toute capture de raisonnement.

## Questions

### Q1 - À partir de quel seuil une décision exige-t-elle une recherche préalable ?

Une règle binaire est trop coûteuse. Un seuil est donc nécessaire, et trois candidats se présentent.

Par la portée : toute décision de `portee: systeme` exige une recherche, les autres non. `ADR-007` l'aurait déclenchée.

Par le coût du renversement : toute décision qui, une fois appliquée, coûterait cher à défaire. `ADR-007` a touché quatre-vingt-trois fichiers.

Par l'antériorité présumée : toute décision portant sur un problème dont on peut raisonnablement penser qu'il a déjà été traité ailleurs. Le plus juste, et le moins vérifiable.

**Réponse.**

### Q2 - Une recherche préalable doit-elle être une FND complète ?

`MET-001` produit un format lourd, dont `FND-003` mesure le coût à une tâche. Un repérage court, qui vérifie l'existence d'une littérature et de sa source fondatrice sans la traiter, coûterait bien moins.

Faut-il un format léger de repérage préalable, distinct de la fondation ? `ANL-001` établit que l'absence de format léger a tué onze dépôts de savoir dans le corpus, et `MET-001` reprend ce constat à son étape 1. Le même défaut se reproduirait ici.

**Réponse.**

### Q3 - Où cette exigence est-elle inscrite ?

Trois emplacements possibles, et ils n'ont pas la même force. Dans `ADR-002`, qui définit le processus de travail. Dans `MET-001`, qui ne parle aujourd'hui que de la conduite d'une recherche déjà décidée. Dans `CLAUDE.md`, qui est le point d'entrée et que le chantier A de `PLN-001` doit de toute façon réécrire.

**Réponse.**

### Q4 - Faut-il compléter les décisions déjà prises par leur antériorité ?

`ADR-007` et `RES-009` ont maintenant une source antérieure connue. Faut-il l'y consigner, ou considérer que `FND-003` le fait déjà et suffit ?

La première position a un mérite : une décision qui cite l'antériorité qu'elle ignorait au moment de décider est plus honnête qu'une décision silencieuse. Elle a un coût : elle rouvre des documents arrêtés, ce que `RES-009` R1 déconseille.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 fixe quand chercher, Q2 fixe à quel coût. Sans les deux, l'exigence est soit inapplicable, soit ruineuse.

L'effet est `conditionnel` : aucune décision prise n'est invalidée, et les deux cas connus sont confortés par leur antériorité plutôt que contredits. Ce qui est en cause est la probabilité que le prochain cas se passe moins bien.

## Relations

- `objecte-a` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)
- `objecte-a` [ADR-007](../adr/ADR-007-identifiant-relatif-par-sequence.md)
- `objecte-a` [MET-001](../methodologies/MET-001-recherche-de-fondation.md)
- `reference` [FND-003](../fondations/FND-003-decisions-institutionnelles-tracables.md)
- `reference` [PLN-001](../plans/PLN-001-point-d-entree-et-analyse-de-la-demande.md)
