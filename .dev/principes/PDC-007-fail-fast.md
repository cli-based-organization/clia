---
type: principe-de-conception
id: PDC-007
title: "fail fast"
version: 0.1.0
status: draft
portee: À RENSEIGNER
---

# PDC-007 - fail fast

> On ne doit pas exécuter inutilement si la tâche est vouer à l'échec

## Objet

Tout processus, tâche ou programme. Que l'agent soit humain, IA ou un automatisme

## Le principe

Vérifier d'abord si on s'attend à ce l'exécution devrait terminer en succès.



## Ce qu'il exclut

rien

## Comment le vérifier

Toujours faire un dry-run ou inclure une étape d'analyse avant l'exécution. Conditionner l'exécution à la propabilité de succès.

## Conséquence d'une violation

On gaspille du temps et des ressources d'exécution inutillement.

Plus les problèmes sont identifiés tard, plus ça coûte cher.
