---
type: session
datetime: 2026-08-09-07-26 
---


# CONTEXTE

Depuis 1 an, nous sommes en train de développer une méthodologie. Le travaille est presqu'abouti, mais il reste à clarifier 1. quelques idées, 2. la dynamique UX et 3. à mettre le tout au propre pour produire une première version publique.

# INTENTION

Dans cette session, nous allons définir les ressources et concepts de base.

Une prochaine session sera dédié à l'outillage (cli `clia`)


# CRITÈRE DE CONVERGENCE

Le concept de ressource (RES) est bien défini, utilisable et instrumenté.

# Tâches

## 1. [analyse] Comprendre le travail de développement de clia

Consulter l'ensemble des repos à partir de $HOME/git/* pour comprendre le système qui a été développé depuis 1 an et, plus généralement, pour voir comment travaille l'humain.

Consigner les informaitons à propos de tes observations dans des fichiers markdown ou yaml dans le réprtoire suivant: @.dev/analyses/ANL-001-<SLUG>/*

Les informations consigné doit inclure (sans s'y limiter):
- un résumé/description de ce que contient chaque repo (git)
- une analyse critique de chaque repo

## 2. [conception] premier jet ressources fondamentales

À partir de ce qui a été constaté dans ANL-001, produire un premier jet de description des ressources fondamentales (RES-<SEQ>):

- Ressource: ADR-001, RES-001, skl-001
- Contexte (CTX): ADR-002, RES-002, skl-002
- Intention (INT): ADR-003, RES-003, skl-003
- Objection (NON): ADR-004, RES-004, skl-004
- Faits (FCT): ADR-005, RES-005, skl-005
- Ontologie (ONT): ADR-006, RES-006, skl-006
- Concept (CPT): ADR-007, RES-007, skl-007

Puis, émettre une série d'objections. Produire un fichier NON-xyz par thématique et contenant plusieurs questions sur un même sujet.

## 3. [conception] définition d'une ressource

- Écrire un premier jet documentant l'adoption de la notion de ressource => ADR
- Écrire un premier document contenant les directives d'écriture et de validation d'une ressource => skl/SKILL

## 4. [conception] Adoption du processus de travail

- Écrire un premier jet d'ADR pour définir le mécanisme de travail collaboratif du système d'informaiton: Humain+IA+cli

=> 

  - analyse de la demande
  - journalisation
  - centré sur production de livrable-ressources bien définis
  - encadrement de IA pas un ensemble conventionné de harnais
  - Émission d'Objection par agent IA et agent humain
  - segmentation des sessions de travail autour d'un objectif précis définit par intention + livrable + critère de convergence 
  
  
  Remarques:

  - les ressources créés par 
  - toute ambiguité et incohérence ou déviation par rapport à l'objectif ultime est signalé au moment de l'identification par une objection (NON)
  - le critère de convergence n'a pas à être défini dès le démarrage de la session
  - la journalisation est obligatoire.

  TODO: faire un plan pour la réécriture du point d'entré (@CLAUDE.md) et pour l'écriture d'un skill d'analyse de la demande:
  - contormité/validité de la demande,
  - interprétation de la demande,
  - rédaction du log,
  - rédaction de la demande interprétée
  - validation de la demande interprétée

## 5. [conception] Adoption de l'usage d'un cli exensible => clia

Faire une recherche de fondation (FND) concernant l'usage des clis et son renouveau à l'ère du cloud computing et du contrôle/manipulation de resources.

Faire une analyse (ANL) en tenant compte de ANL-001 et du FND précédement rédigé
Répondre à la question suivante: clia (le cli) doit-il appartenir à ce repo ou doit-il être développé dans un repo indépendant?


Écrire un premier jet d'ADR à propos de l'usage de clia.

## 6. [implémentation] clia resource CMD ...



CMD = "resource" or "res" or "r"

Implémenter une commande pour gérer les ressources:

```sh
# active le cli clia
. setup.sh activate

clia resource|res|r ls  # affiche la liste des ressources connues
clia res ls RESOURCE # affiche les instance de RESOURCE =>  id(<PREFIX>-<SEQ>) DESCRIPTION STATUS
clia res new RESOURCE DESCRIPTION # génère une nouvelle ressource de type RESOURCE avec SLUG dérivé de DESCRIPTION
clia res show ID # affiche à l'écran la ressource de l'ID = <PREFIX>-<SEQ>
clia res edit ID  # ouvrir la ressource ID avec l'éditeur de texte CLIA_EDITOR
```

et

```sh
clia configuration|config|c ls  # affiche la liste des configurations
clia config set KEY VALUE # assigne la variable d'environnement CLIA_KEY|KEY avec la valeur VALUE
clia config edit # ouvre le fichier de configuraiton des variables d'environnement pour édition
```

Implémenter immédiatement un premier jet de clia et setup.sh en bash en prenant les meilleurs décisions selon les meilleurs pratiques et les conventions des systèmes linux

## 7. [conception] identifiants dans les systèmes décentralisées

### Recherche de fondation

MÉTHODOLOGIE Produire une recherche scientifique de type revue de la littérature. Chaque affirmation doit être supportée par un URL valide. Insérer les référence dans le texte après chaque affirmation, comme dans un vrai article scientifique. Préférer les sources d'information à haute crédibilité.

Utiliser le processus d'analyse suivant: 
- 1. faire la liste des questions de recherches pertinentes,
- 2. Faire un inventaire sémantique et ontologique en lien avec ces questions de recherche,
- 3. mobiliser les cadres théorique et méthodologique de pour chaque question de recherche. en plus des domaines de savoir mobilisés suggérés par l'humain, identifier tous les dommaines de recherche qui traite de ces questions de recherche ou dont l'ontologie recoupe les ontologies d'intérêt.
- 4. identifier TOUS les axes d'analyses pertinents
- 5. faire une revue de la littérature historique,
- 6. faire une analyse critique de ces champs de recherche, de leur état de la connaissance actuelle et des limites,
- 7. répondre aux questions et thèse présentés par l'humain au regard du savoir mobilisé.



SAVOIR à mobiliser: système décentralisé (blockchains, identité numérique, etherium, hyperledger, etc.), système d'identifiants (URL, URI, IP v4, IP v6), spécifications public des protocoles décentralisées, apiVersion des manifestes kubernetes, git, semver, versions de OS dans sytème de upstream/downstream

CONTEXTE:
clia est un système d'information centré sur les données, permettant une interaction entre humain et IA et automatismes.

INTENTION:
Faire une recherche de fond et produire un document de référence qui explique les enjeux à prendre en compter dans la conception d'un système d'identifiant permettant 
1. être facile d'utilisation,
2. qui distingue les contextes utilisation interne vs utilisation externe
3. qui est basé sur la notion de ressource partageable et réutilisable

Notamment, comment faire pour q'une ressource soit réutilisable
- 1. dans un autre projet
- 2. par d'autre personne,
- 3. pour une édition collaborative,
- 4. qui permette de faire des oeuvres dérivés (branches, forks)

### Analyse

Au regard de ANL-001 et du savoir mobilisé dans la précédente FND, faire une analyse et émettre des suggestions pour la conception du système d'identifiant des ressources clia

### Objections

Compléter les objections existantes avec de nouvelles questions et émettre de nouvelles objections au besoin.
