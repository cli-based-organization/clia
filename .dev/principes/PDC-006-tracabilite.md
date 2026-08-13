---
type: principe-de-conception
id: PDC-006
title: "traçabilité"
version: 0.1.0
status: draft
portee: À RENSEIGNER
---

# PDC-006 - traçabilité

> Propriété du système clia. On doit pouvoir reconstituer après coup ce qui s'est produit, par qui et pourquoi.

## Objet

L'ensemble du système.

## Le principe

Un humain, une IA ou un automatisme doit pouvoir reconstituer facilement l'histoire du repo.

Incluant, mais non s'y limitant, 
- 1. ce qui s'est produit,
- 2. qui a fait quoi,
- 3. le résultat de chaque action,
- 4. pourquoi chaque action a été appliquée.

## Ce qu'il exclut

rien

## Comment le vérifier

Reconstituer l'historique et voir si il est possible de trouver ou de dériver l'information nécessaire.

## Conséquence d'une violation

- On ne comprend pas ce qui ce passe.
- On avance à l'aveugle en perdant la cohérence avec les intentions premières.