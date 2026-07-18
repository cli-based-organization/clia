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

## 5. [traitement des objections] Refactor du cli

TODO: réévaluer le plan au regard des réponses suivantes.

### objection 1

La résilience par rapport à l'environnement d'exécution n'est pas un requis. 
Optimiser pour un OS Debian 12

### objection 2

Conserver les requis demandés:
  - doc short et long
  - uniformité
  - documente toutes les commandes

Ça n'est pas un problème difficile. Voici comment il faut faire:
- avoir une source de vérité documentaire avec documentation "atomique" au format yaml
- fournir un template de documentation pour le format court et pour le format long
- Générer la doc à la volée à partir de ces 2 ingrédients

### objection 3

L'appel de `clia OPTIONS` seul est une commande d'information système avec OPTIONS : 
- --version => donne l'informaiton sur la version
- --config => donne l'information sur la config
- --help => information sur les commandes (format court)
- --man => information sur les commandes (format long)

Dans le cas où il y a une commande, l'interface est la suivante:

`clia [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]`

Ici, `GLOBAL_OPTIONS` sont des options qui doivent s'appliquer à toutes les `COMMAND|GROUP` et `OPTIONS` s'appliquent seulement pour la commande ou le groupe spécifique.

TODO: pour vraiment 'activer' les options globales, ajouter aux documents de conception les 2 options globales suivantes:
- --debug => affiche information de déboguage
- --dry-run => affiche uniquement le plan d'exécution de la commande + options

## 6. [traitement des objections] 

### objection 1

Intégrer explicitement à REQ-001

### objection 2

ajouter yq aux dépendances

### objection 3

Mécanisme générique pour la production de tous clis

## 7. [exécution du plan] PLN-011

## 8. [Planification] Produire PLN-012

Proposer un plan permettant de produire le plus rapidement les livrables attendus

## 9. [conception] Plan pour la conception de la commande `clia setup`


Le script `setup.sh` prend en charge toutes les opérations de gestion du script.

Consultez `@../../noumanity-dev/ticket-driven-ai/setup.sh` pour s'inspirer cet exemple

Voici la séquence
- Écrire un adr d'écrivant setup (init, upgrade et downgrade)
- Écrire les reqs pour setup
- Écrire les specs pour setup
- adapter le core clia
  - ajouter la capacité d'extension à scripts externes
  - ajouter un ADR sur les ressources livrables (incluant ce que c'est, cycle de vie, versionage, source de vérité, format variable, template et validation)
  - faire une analyse (ANL) pour définir si on a besoin de reqs et specs pour les ressources livrables
  - ajouter une ressource livable qui décrit une interface cli (ADR + SKILL + adapter les harness files)

Ne pas inclure l'implémentation dans le plan


## 10. [Résolution des objections] pour PLN-013

Mettre à jour PLN-013 au regard des précisions ci-bas

### Objection 1

Le plan PLN-013 sera exécuté en premier.
Il prend en charge complètement la phase de conception et fait autorité sur ce sujet sur PLN-012

### Objection 2

Intégrer tout les éléments des ressources livrables à ADR-004

### objection 3 

Effectuer l'analyse puis arrêter l'implémentation pour laisser à l'humain consulté l'analyse et prendre action en conséquence. (breakpoint)

TODO: les documents de conception + harness-files pour introduire la notion de "breakpoint".


### TODO: on se garde la résolution des objections 4 et 5 après le breakpoint


## 11. [exécution] Exécute PLN-013 jusqu'au breakpoint

## x. [Résolution des objections] Première passe PLN-012

Mettre à jour PLN-012 au regard des précisions ci-bas

### Objection 1

Nous étendons les modes d'installation supporté

TODO:

- ajouter un ADR décrivant les commandes d'installations 