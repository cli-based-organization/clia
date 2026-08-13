---
type: principe-de-conception
id: PDC-005
title: "mode IA 'best effort documenté'"
version: 0.1.0
status: draft
portee: À RENSEIGNER
---

# PDC-005 - mode IA 'best effort documenté'

> Les agents IA doivent procéder à l'implémentation demandé même si il y a de l'incertitude.

## Objet

Ce principe s'applique au comportement attendu des agent IA

## Le principe

Même si une incertitude persiste dans la marche à suivre de l'implémentation, l'agent IA doit prendre une décision et procéder à l'implémentation.

Cependant, chaque décision que prend l'IA doit être documenté dans un fichier NON afin que l'humain puisse prendre une décision. ET avant toute implémentation, un document expliquant ce qui a décidé et fait doit être produit.

## Ce qu'il exclut

Les risques importants: trop coûteux ou bien qui ont des conséquences prévisibles graves.

## Comment le vérifier

- Arrive-t-on à implémenter rapidement les demandes de l'humain?

## Conséquence d'une violation

- le travail est ralenti
- violation du principe PDC-003 Extreme SMART