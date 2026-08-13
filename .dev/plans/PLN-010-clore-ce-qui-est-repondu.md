---
type: plan
id: PLN-010
title: "Clore ce qui est répondu"
status: draft
statut-plan: execute
date: 2026-08-13
initiateur: agent
sert: []  # clôture d'objections et contrainte de schéma : documentaire
porte-sur: [RES-004, objection.cue, .dev/objections]
---

# PLN-010 - Clore ce qui est répondu

> Trente et une objections sont entièrement répondues et comptées ouvertes. `RES-004` déclare pourtant sept états, dont cinq n'ont jamais servi. La définition est excellente et rien ne la fait respecter. Deux chantiers, une heure trente, et le compteur descend de trente et un.

## Statut

`execute`. Les deux chantiers ont été exécutés dans la tâche 6 de `SES-002`, le 2026-08-13.

## Intention

Faire descendre le compteur d'items ouverts pour la première fois.

**Cible mesurable.** Le nombre d'objections portant `etat: ouverte` passe de 33 à 2.

## Chantiers

### Chantier A - Imposer les états que la définition déclare déjà

| Élément | Valeur |
|---|---|
| **Livrable** | `objection.cue` |
| **Critère de réussite** | Une valeur d'état hors des sept déclarées est refusée par la validation |
| **Limite de temps** | 45 minutes |
| **Dépend de** | rien |

**Ce que le chantier corrige.** `RES-004` déclare sept états avec leur sens ; `objection.cue` accepte `etat: string & !=""`. Le schéma n'impose rien de ce que la définition dit.

**Aucune valeur n'est inventée.** Les sept viennent de `RES-004` : `ouverte`, `partiellement-repondue`, `repondue`, `resolue`, `levee-par-decision`, `differee`, `caduque`. La définition n'est pas modifiée.

**Cinq de ces sept n'ont jamais servi**, alors qu'elles décrivent exactement des situations que le dépôt vit.

### Chantier B - Fermer ce qui est répondu

| Élément | Valeur |
|---|---|
| **Livrable** | Les objections entièrement répondues |
| **Critère de réussite** | Toute objection dont chaque question porte une réponse ne vaut plus `ouverte` |
| **Limite de temps** | 45 minutes |
| **Dépend de** | A |

**Contrôle exécutable.** Le décompte par état avant et après, et la validation de schéma du dépôt.

**Ce qui justifie que l'agent le fasse.** Le geste est réversible, il porte sur un champ, et il touche des documents dont l'agent est l'initiateur dans la plupart des cas. `PDC-005` prescrit de décider et d'avancer.

**Ce qui n'est pas fait.** Aucune réponse n'est interprétée. Une objection passe à `repondue` parce que ses questions ont des réponses, non parce que l'agent juge le sujet clos.

**C'est exactement ce que `RES-004` dit de cet état** : « Toutes les questions ont reçu réponse, l'initiateur n'a pas encore statué ». Le passage à `resolue` reste un geste de l'initiateur.

## Objections de l'agent

**Fermer n'est pas traiter.** Trente et une objections passent à `repondue` ; douze d'entre elles n'ont produit aucune suite visible, et ce plan ne le corrige pas.

**L'agent ferme des documents qu'il a lui-même ouverts**, sur la base de réponses qu'il n'a pas toujours exploitées. C'est un compteur qui descend, pas un travail qui avance.

## Relations

- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
