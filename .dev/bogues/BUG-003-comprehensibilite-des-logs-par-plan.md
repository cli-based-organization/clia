---
type: bogue
id: BUG-003
title: "compréhensibilité des logs par plan"
status: draft
regle: À RENSEIGNER
constate-le: À RENSEIGNER
etat: À RENSEIGNER
---

# BUG-003 - compréhensibilité des logs par plan

> Un log ne devrait rapporter l'exécution que d'un seul PLN

## Journal

voir SES-002 TSK-009

## L'écart

Plusieurs plans ont été exécutés dans la même tâche ce qui rend difficile pour un humain de comprendre quel plan a fait quoi.

## La règle enfreinte

PDC-006

## Comment le reproduire

Lancer une tâche avec plusieurs PLN

## La cause

Les logs sont segmentés par tâches. 1 tâche == 1 répertoire de log.

## La correction

Restreindre l'exécution d'un seul plan par tâche.

Si il y a plus d'un plan demandé, refuser et échouer sur le champ (PDC-007)