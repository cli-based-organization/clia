---
type: decision
id: DCN-013
title: "DCN est la source de vérité des décisions humaines"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
instance: À RENSEIGNER
date-de-decision: 2026-08-11
portee: À RENSEIGNER
effet: en-vigueur
attestation: À RENSEIGNER
diffusion: À RENSEIGNER
---

# DCN-013 - DCN est la source de vérité des décisions humaines

> Les documents DCN sont la référence absolue en matière de décision.

## Objet

## La décision

- DCN est l'autorité ultime en matière de décision
- seul l'humain peuvent rédiger des DCN

## Motivation du changement

Une source de vérité des décisions est nécessaire 

## Qui a décidé

Jérémy Viau-Trudel, créateur de clia

## Portée

S'applique à tout repo clia

## Conséquences

- l'ensemble des DCN doit être auto-cohérent
- tout autre document qui traite de décision est subordonnée aux DCN
- toute conception ou implémentation doit respecter les DCN

### permissions

- le cli clia peut générer les DCN, en analyser le contenu et le frontmatter pour vérification de la validité, ainsi que modifier les valeurs du frontmatter pour tenir répercuter l'évolution de l'état de la ressource
- seul l'humain peut créer une nouvelle DCN (en utilisant `clia res new DCN "DESCRIPTION"`) 
- une peu faire un premier jet de DCN. Mais ce premier jet n'est pas actif tant qu'il n'a pas été approuvé par l'humain


conséquence => on a besoin d'un champ dans le frontmatter qui détermine si la décision est active ou non et si non, pourquoi elle est inactive (proposée par l'IA, obsolète, abrogé, ...)

## Ce que la décision ne dit pas

- comment l'IA identifie et rapporte les décisions implicites de l'humain
- comment les décisions de l'IA sont documentées