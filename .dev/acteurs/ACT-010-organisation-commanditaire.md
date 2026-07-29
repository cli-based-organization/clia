---
type: acteur
version: 0.1.0
title: "Organisation commanditaire"
status: proposé
date: 2026-07-29
categorie: partie-prenante
portee: methode
---

# ACT-010 - Organisation commanditaire

## Définition

L'organisation qui **finance et porte** le système d'augmentation, et qui attend de lui un retour : réutilisabilité d'un dépôt à l'autre, coût d'appropriation maîtrisé, différenciation de sa façon de travailler.

Partie prenante **hors scène** : elle n'opère rien, mais ses intérêts arbitrent les décisions de conception structurantes, à commencer par l'exigence de généricité du harnais.

## Responsabilité

Aucune opération. Ce rôle figure au catalogue parce qu'il porte les **critères de valeur du système lui-même**, distincts de la valeur des livrables produits ([`ACT-007`](ACT-007-destinataire-des-livrables.md)).

## Buts poursuivis

Aucun parcours. Ses attentes s'expriment comme critères, pas comme buts opérationnels.

## Intérêts

- La **réutilisabilité inter-dépôts** : ce qui est construit une fois doit servir ailleurs sans réécriture. C'est l'intérêt qui fonde l'exigence de généricité du harnais ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)).
- Le **coût d'appropriation** : le temps entre l'arrivée dans un dépôt équipé et la première contribution utile.
- La **différenciation** : que la façon de travailler constitue un avantage propre, pas une reproduction de pratiques courantes.
- La **soutenabilité** : que le système reste maintenable par une équipe réduite.

## Préconditions d'accès

Aucune. Ce rôle n'accède pas au dépôt.

## Modes d'échec caractéristiques

- Le système devient **spécifique** au dépôt qui l'a vu naître et cesse d'être transposable, ce qui annule le retour attendu ([`BUG-003`](../bugs/BUG-003-frontiere-methode-domaine-sous-tension.md)).
- Le coût de maintien du système excède le gain qu'il procure.
- Le système accumule des mécanismes que personne n'utilise, chacun ajoutant du coût sans valeur.
- La complexité rend l'appropriation par un nouvel arrivant plus coûteuse que le travail non augmenté ([`ACT-008`](ACT-008-collaborateur-futur.md)).

## Ce que ce rôle ne fait pas

- Il n'arbitre aucune décision technique : il en fixe les critères de valeur.
- Il ne se confond pas avec le destinataire des livrables de domaine ([`ACT-007`](ACT-007-destinataire-des-livrables.md)) : l'un attend du contenu, l'autre attend un système qui produise du contenu.

## Relations

- **Rôles voisins** : [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) (sert ses critères), [`ACT-008`](ACT-008-collaborateur-futur.md) (mesure le coût d'appropriation), [`ACT-007`](ACT-007-destinataire-des-livrables.md).
- **Intérêt servi par** : la généricité du harnais ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md)) et la séparation méthode / domaine ([`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)).
- **Source** : typologie P4 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
