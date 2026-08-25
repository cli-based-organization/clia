# SES-001

## CONTEXTE

Nous entamons une nouvelle génération de clia. Voir dans @.dev/archives/* pour consulter les générations précédentes.

Nous redémarrons de zéro le développement en concervant ce qui fonctionne bien et en éliminant le reste.

## INTENTION

Fournir le plus rapidement possible un cli `clia` utilisable pour un usage dans une variété de projets réels.

## LIVRABLES attendus

- un système d'information clia utile pour une variété d'usages 
- un cli `clia` permettant d'instrumenter n'importe quel repo git
- des observations et recommandations pertinante pour la prochaine génération du SI clia

## Tâches

### 1. [implémentation] `clia harness-ia|skill|feature`

Reproduire les commandes `harness-ia`, `skill` et `feature` tel qu'implémentées dans le repo @../../llm-wiki/noumanity-wiki

### 2. [refactor] conventions d'usage des répertoires

Réorganiser le répertoire afin de respecter le requis @.dev/reqs/REQ-002-convention-repertoires.md

### 3. [implementation] crée les resssources 'ressource' et 'intention'

mettre dans les répertoires: @_ressources/ressource/ et @_ressources/intention/

Au besoin, consulter le repertoire @.archives pour mieux comprendre le système de ressource

### 4. [implementation] clia init

initialiser la commande `clia init` tel que décrite dans le cas d'usage USE-002

### 5. [implementation] ce que peuvent contenir les primitives de _ressources/<RESSOURCE> 

Le répertoire `@_ressources/` contient des répertoires de primitives de ressources et des répertoires de catégories qui, lui, contient des répertoires de ressources.

La ressource est l'entité première du système clia. Tout autre concept doit se rattacher à une ressource.

Aussi, les répertoires de ressource contiennent les primitives nécessaire à la régération des concepts suivants:

- [_]principes: Principes de conception associés à cette ressource
- [_]ontology: concepts et relations spécifiques à cette ressource
- [_]specs: spécifications de cette ressource
- [_]reqs: requis d'implémentation de cette ressource 
- [_]scripts: scripts d'instrumentation de cette ressource
- [_]skills: skills opérants sur cette ressource
- [_]features: fonctionnalités fournis pour/par cette ressource
- [_]methodes: méthodologies permettant d'opérer sur cette ressource

Le caractère underscore indique qu'il s'agit d'un répertoire de templates d'instrumentation.
C'est à dire que l'on met les primitives dans un répertoire et les templates associés dans un répertoire du même nom préfixé de "_"

Décrire correctement les spécifications de ceci dans @.dev/specs/... et les requis dans @.dev/reqs/...



### 6. [refactor] feature n'est pas une ressource, mais session oui

- 1. feature n'est pas une ressource. Refactorer @_ressources/features pour respecter les spécifications générés à la tâche précédente
- 2. session est une ressource: 
  - mettre @_ressources/feature/primitives/session.md dans => _resources/session/features/...
  - mettre @_templates/session/sesion.template.md dans => _ressources/session/_features/...

### 7. [implémentation] mettre en place la commande `clia res` tel que décrite par USE-003

## 8. [implémentation] mettre en place la commande `clia release ...` tel que décrite dans USE-004


## 9. [implémentation] permettre l'installation de ressource, skill et fonctionnalité tel que décrite dans USE-005

## 10. [implémentation] permettre l'ajout d'extensions tel que décrit dans USE-006

## 11. [implementation] conformité et migration des assets

