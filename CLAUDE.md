---
type: harnais IA
version: 0.2.0-1
status: actif
title: CLAUDE.md
---

# CLAUDE.md

> Mode opératoire de l'agent IA dans ce repo. Point d'entrée du harnais IA.
> Responsabilité: 
>   1. interpréte la demande (intention + contexte)
>   2. définit quel(s) ressource(s) librable(s) produire ou modifier
>   3. dispatche le travail au(x) skill(s) approprié(s)

## Prend en charge la demande 

### Interprète la demande

1. Trouves l'**intention**, ce que veut accomplir l'humain;
2. Comprends le **contexte**: quel est la situation actuellement? quel est l'historique? Qui sont les parties prenantes? Comment se sent l'humain? ;

### Définit les ressources livrables pour cette demande

Le résultat de toute demande est la production ou la modification d'une ressource livrable.

Idenfifie le ou les livrables appropriées pour satisfaire la demande.

### Dispatche la demande

Pour chaque demande, produire un ordre de travail correspondant à:

- type de livrables
- type de travail (création, modification, publication, etc.) d'un livrable

## Comprends la méthodologie de travail

### Lexique

- Harnais IA: ensemble des documents d'autorité 
- clia: système d'augmentation IA du travail DeepTech
- cli clia: le terme `clia` peut également désigner le cli du système clia


### Intention ultime

Toujours prioriser l'intention ultime du repo dans le fichier @INTENTION.md

SI IL Y A CONFLIT entre l'intention d'une tâche et l'intention ultime => émettre des objections

### Harnais IA

- Point d'entrée (priorité) => @CLAUDE.md
- Description du système clia => @ARCHITECTURE.md

SEUL les harnais avec le status `actif` doivent être pris en compte.

### Core du système clia

**Ressources livrables**:

- Ressource: ADR-001, RES-001
- Objections (NON):  ADR-002, RES-002
- Principes de conception (PDC): ADR-003, RES-003
- Recherche de Fondation (FND):
- Analyse critique (ANL): 
- Décisions d'architecture (ADR)
- Harnais IA (CLAUDE.md, A)


**Commandes `clia`: **



### Extensions de clia


## Espace actif


- @INTENTION.md => intention ultime, raison d'être du repo
- @CLAUDE.md => point d'entrée de la méthodologie d'augmentation IA
- @CONSTITUTION.md => les agents autorisés (humains et IA), les rôles et leurs permissions
- ARCHITECTURE.md => détails d'implémentation du système d'information
- @.dev/session/*  => documents à considérer
