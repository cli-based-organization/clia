---
type: decision
id: DCN-019
title: "à la validation, chaque ressource modifiée incrémente sa version"
version: 0.1.0
status: draft
instance: À RENSEIGNER
date-de-decision: 2026-08-13
portee: À RENSEIGNER
effet: en-vigueur
attestation: À RENSEIGNER
diffusion: À RENSEIGNER
---

# DCN-019 - à la validation, chaque ressource modifiée incrémente sa version

> Chaque ressource à sa propre version (atomique). Lors de la validation de la modification, on incrémente le numéro de version"

## Objet

Les modifications et le versionnage atomique des ressources

## La décision

Chaque ressource a une version qui lui est propre. La version est incrémenté lorsque l'humain approuve la modification

## Motivation du changement

Les ressurces ont un champ version, mais il n'est jamais incrémenté

## Qui a décidé

Le créateur, Jérémy Viau-Trudel

## Portée

toutes les ressources

## Conséquences

On doit définir les mécanismes de validation et d'incrément de version

## Ce que la décision ne dit pas

Quels sont les mécanismes et leur implantation.