---
type: decision
id: DCN-018
title: "chaine d'abstraction: conceptuel, abstraite, spécifique"
version: 0.1.0
status: draft
instance: À RENSEIGNER
date-de-decision: 2026-08-13
portee: À RENSEIGNER
effet: À RENSEIGNER
attestation: À RENSEIGNER
diffusion: À RENSEIGNER
---

# DCN-018 - chaine d'abstraction: conceptuel, abstraite, spécifique

> Séparer rigoureusement les enjeux selon le niveau d'abstraction: conceptuel, abstrait et spécifique.

## Objet

S'applique à la chaine de conception à l'implémentation

## La décision

Il y a trois niveau d'abstraction:

- conceptuel => très haut niveau d'abstraction. Presque philosophique. Aucune référence à une application précise
- abstrait => Niveau d'abstraction intermédiaire. On situe l'application concrète. Mais on ne dit pas exactement comment résoudre le problème.
- 

## Motivation du changement

Cette séparation permet 2 choses importantes:

- 1. Avoir un focus sur le bon niveau de conception au moment ou l'humain travail
- 2. Permettre d'avoir des ressources sources (de vérité) pour chacun des niveaux d'abstraction.

## Qui a décidé

Le créateur de clia, Jérémy Viau-Trudel

## Portée

Les ONT et CPT appartiennent au niveau conceptuel, mais ils peuvent décrire des concepts de n'importe quel niveau d'abstraction.

Conséquence => on doit faire une distinction entre le niveau d'abstraction d'une ressource (elle-même) et le niveau d'abstraction de l'information quelle encapsule.

- toutes les ressources ont 1. un niveau d'abstraction intrinsèque et 2. un niveau d'abstraction associé à leur contenu informationnel
- la méthodologie de travail doit tenir compte des nivea d'abstraction. Et, notamment, prévoir la "montée" en abstraction jusqu'à la chose concrète qui est matérialisée dans le réel.

## Conséquences

- On doit toujours se demander à quel niveau d'abstraction appartient une ressource.

## Ce que la décision ne dit pas

- Quel est le niveau d'abstraction des ressources