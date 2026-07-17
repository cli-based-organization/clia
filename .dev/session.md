---
start-at: 2026-07-17T07:53:06-04:00
---

# Intention

Fournir les fonctionnalités de base pour une installation dans un nouveau repo.


# Contexte

Actuellement, nous faisons beaucoup de tests, mais ceux-ci sont fragmentés et ne se cummulent pas.

Ce repo est le point focal du développement de l'outil IA de noumanity (studio DeepTech indépendant et auto-financé)

# Livrables attendus

Commandes CLI permettant de: 

- [ ] créer un nouveau repo git et l'initialiser
- [ ] update/rollback les resources clia dans un repo existant


# Tâches

## 1. [bogue UX cli] (diagnostique) Documentation des commandes clis

Le cli ne se comporte pas de la manière attendu.

Toutes les commandes ne sont pas documentés correctement. Notamment, la commande `clia session` n'apparait pas dans la documentation d'aide générale `clia -h`. Et elle n'est pas documenter correctement avec `clia ses -h`.

Analyser à la fois:
  - le cli
  - les fichiers harnais

Et dire:
  - quel est le problème,
  - comment le corriger, et
  - pourquoi il s'est produit (cause profonde) 

Livrable => plan pour amélioration du harnais 

Proposer un plan permettant de corriger le harnais afin qu'il converge vers le comportement attendu en matière de documentation:

  - tout cli produit pas les harnais sont auto-documentés et découvrable. 
  - auto-documenté => C'est à dire que le cli contient des commandes d'accès à la documentation
  - découvrable => toutes les commandes existantes apparaissent dans `clia -h` et toutes les sous-commandes apparaissent avec `clia COMMAND -h`
  - La documentation est uniforme partout, dans toutes les commandes et les sous-commandes.
  
Voici le procesuss d'amélioration attendu: 
- 1. adapter les documents de conception
- 2. adapter les harness files appropriés, incluant les SKILLs

