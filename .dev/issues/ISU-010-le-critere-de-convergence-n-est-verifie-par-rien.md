---
type: issue
id: ISU-010
title: "Le critère de convergence n'est vérifié par rien"
status: draft
initiateur: humain
etat: ouverte
ouverture: 2026-08-12
---

# ISU-010 - Le critère de convergence n'est vérifié par rien

> La rubrique est obligatoire depuis aujourd'hui. Aucun geste ne la consulte, et `clia ses close` ferme une session sans la regarder.

## Journal

- 2026-08-12 : ouverte à la demande de l'humain, réponse Q1 de `NON-037` : « Rien ne disparait. On conserve l'information dans le ticket. C'est la responsabilité de l'utilisateur de faire le suivi. On implémentera plus tard. »

## La problématique

`ADR-002` fonde la segmentation du travail sur trois éléments : l'intention, le livrable et le critère de convergence. Le troisième avait perdu sa rubrique le 2026-08-11 ; il l'a retrouvée le lendemain.

**Aucun outil ne le lit.** `clia ses close` change un champ `etat` et n'ouvre pas l'énoncé.

**La responsabilité est déclarée humaine**, et c'est la réponse à `NON-037` Q1. Cette issue enregistre l'écart plutôt que de le corriger.

## Ce qui est mesuré

| Mesure | Valeur |
|---|---|
| Sessions du dépôt | 2 |
| Sessions dont le critère de convergence est écrit | **1** |
| Gestes qui consultent le critère | **0** |

`SES-001` n'a pas de rubrique de critère de convergence : son énoncé est antérieur au rétablissement.

## Ce qu'il faudrait pour la fermer

Trois régimes possibles pour `clia ses close`, et le choix n'est pas fait.

| Régime | Ce qu'il fait |
|---|---|
| Ignorer | Le comportement actuel |
| Avertir | Signale si la rubrique vaut encore `À rédiger`, sans refuser |
| Refuser | Bloque la clôture |

**Recommandation de l'agent : avertir.** Refuser bloquerait la clôture d'une session dont le critère n'a jamais été écrit, et il y en a une sur deux dans ce dépôt.

## Relations

- `derive-de` [NON-037](../objections/NON-037-frontiere-et-forme-de-la-session.md)
- `reference` [RES-034](../ressources/RES-034-session.md)
