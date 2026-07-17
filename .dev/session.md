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

## 2. [Traitement des objections] PLN-010

Le plan est bon en général. Mais il dépasse le scope attendu. => en premier, on améliore uniquement le harnais.

TODO: réviser le plan au regard des réponses aux objections

### objection 1

Ne pas inclure dans ce plan l'amélioration de `clia`

### objection 2

En quoi est-ce grave que les clis ne soient pas conforme ?
Les documents de conceptions sont évolutifs afin d'améliorer les capadcités du système. C'est ce qui prime.

L'étape de réconciliation du cli se fait après, une fois qu'on a préciser comment le système doit se comporter.

Documenter cette idée et l'ordre séquentiel de travail:
- 0. Recherches préliminaires et préconception => FND, ANL
- 1. Conception => documents de conceptions
- 2. Méthodologie => (harness files including SKILLs)
- 3. Implémentation => cli

### objection 3

Nous ne concevons pas un système pour faire du code jetable.
Nous construisons un système d'ingénierie logiciel professionnel et robuste.
Ces spécifications et requis concernant la documentation font partie des fonctionnalités de coeur et il ne sont pas négociables.

## 3. Exécution du plan PLN-010

## 4. [Planification] Réconciliation du cli avec les spécifications

### Contexte pertinent

Les spécifications d'un cli concentionnel `clia` ont changé.

### TODO

Planifier la réconciliation du cli `clia` avec les nouvelles spécifications