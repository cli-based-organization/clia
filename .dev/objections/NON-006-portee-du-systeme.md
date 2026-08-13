---
type: objection
id: NON-006
title: "Portée du système et travail multi-dépôts"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [RES-001, RES-002, RES-003, RES-006, RES-007]
---

# NON-006 - Portée du système et travail multi-dépôts

> Le modèle définit des ressources markdown dans un dépôt, alors que le travail observé est multi-dépôts et largement non textuel. Aucun document ne déclare la portée du système, ni ce qui en est exclu.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.
- 2026-08-10 : deux questions ajoutées, Q8 et Q9, à partir de `FND-002` et `ANL-003`, qui apportent des mécanismes attestés là où Q5 n'avait que le constat.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Deux silences du modèle.

Le premier porte sur la nature des objets. `RES-001` définit la ressource comme un fichier markdown à frontmatter YAML, et écarte les assets binaires et les PDF générés en renvoyant à cette objection. Aucun document ne dit que la méthode s'applique aux ressources textuelles et pas au reste.

Le second porte sur le nombre de dépôts. Les sept définitions parlent d'un dépôt au singulier. Or `clia` a pour objet d'équiper plusieurs dépôts, et le travail observé traverse les dépôts en permanence.

## Pourquoi cela ne peut pas rester implicite

Sur la nature des objets, `ANL-001` mesure au défaut D7 que la méthode n'a de prise que sur le markdown. `event-xminds-console-juillet-2026` porte 181 fichiers dont 48 PNG, 23 JPG, 32 sources LaTeX et 11 PDF, avec un harnais complet dont aucune règle ne s'applique à ce contenu. `noumanity+qguard` gère des documents légaux en PDF et `.docx` sans harnais. Trois dépôts commitent leurs PDF générés aux côtés des sources sans qu'aucune règle ne tranche.

Sur le multi-dépôts, les mesures sont plus dérangeantes. `ANL-001` établit que le harnais s'installe par copie de dépôt, et que la copie emporte tout : trois `INTENTION.md` identiques désignant le mauvais client, dix-huit logs recopiés d'un dépôt à l'autre avec les mêmes empreintes, deux dépôts métiers portant l'intention du système lui-même. Le `resource-types.yaml` archivé de `clia` avait prévu un fichier d'état d'installation, `.dev/installation.yaml`, qui n'a jamais été produit.

La pratique de l'humain est explicitement multi-dépôts. Les tâches de session renvoient à d'autres dépôts par chemin relatif avec la notation `@`, et la tâche 1 de la présente session demande de consulter cent soixante-six dépôts. Un modèle mono-dépôt décrit mal ce travail.

## Questions

### Q1 - La portée du modèle est-elle déclarée comme textuelle, et où est-ce écrit ?

Trois positions. Déclarer que le modèle couvre les ressources textuelles et que le reste est hors portée, ce qui est honnête et limite l'ambition. Étendre le modèle aux assets par un type dédié, avec métadonnées en fichier annexe. Ne rien déclarer, et laisser chaque dépôt improviser, ce qui est l'état actuel.

**Réponse.**

### Q2 - Un livrable produit mécaniquement est-il une ressource ?

Un PDF compilé depuis des sources LaTeX, un CV généré depuis des données YAML, une présentation rendue depuis du markdown. `micrologic-clients` a défini un type Publication (`PUB`) qui n'a précisément aucun skill, et c'est le seul endroit du corpus où la question est posée. Faut-il versionner le produit, ou seulement la source et la recette ?

**Réponse.**

### Q3 - Comment un dépôt équipé est-il reconnu, et comment est-il mis à jour ?

Sans fichier d'état d'installation, le harnais se propage par copie et emporte les traces d'autres dépôts. `.dev/installation.yaml` était prévu par `resource-types.yaml`, avec version, révision source, date, mode de pose et empreintes. Faut-il le produire maintenant, ou est-ce une question d'outillage à reporter ?

**Réponse.**

### Q4 - Une ontologie, un concept, une définition de type sont-ils partagés entre dépôts, ou dupliqués ?

Ce sont les trois types dont le contenu est générique par nature. Les dupliquer reproduit exactement le défaut mesuré, avec dix-huit variantes de `CLAUDE.md`. Les partager suppose un mécanisme qui n'existe pas : sous-module, dépôt de référence, installation par `clia`. La question est-elle tranchable maintenant, ou dépend-elle de l'outillage ?

**Réponse.**

### Q5 - Comment se fait un renvoi d'une ressource d'un dépôt vers une ressource d'un autre ?

La pratique actuelle emploie des chemins relatifs, qui cassent dès que la disposition des dépôts change. `ANL-001` mesure par ailleurs que quatre-vingt-quatorze dépôts sur cent soixante-six n'ont aucun remote, donc aucune adresse stable. Un renvoi inter-dépôts a-t-il un sens dans ces conditions ?

**Réponse.**

### Q6 - L'intention doit-elle être lisible par la machine, et sous quelle forme ?

`CLAUDE.md` demande à l'agent d'objecter en cas de conflit avec l'intention ultime. Le corpus a essayé la forme machine-lisible dans deux dépôts, avec `apiVersion` et `kind: Intention`, et l'a abandonnée en avril 2026 sans trace. La question est rouverte parce que le besoin est resté.

**Réponse.**

### Q7 - Le modèle doit-il couvrir les données, distinctes du code et des livrables ?

Le corpus contient trois dépôts de données séparés de leur outil : `clients-data/vortex-finops` avec 37 CSV, `dev-data/personal-journal-dev-data`, et les 92 fichiers YAML de `archive/jvtrudel-cv`. Cette séparation est une bonne décision, non documentée, et aucun type ne la reconnaît.

**Réponse.**

### Q8 - Un renvoi inter-dépôts doit-il être une extension du renvoi local ?

Ajoutée le 2026-08-10, et elle apporte à Q5 le mécanisme qui lui manquait. `FND-002` établit que la traversée de la frontière interne vers externe se fait par extension du noyau et jamais par remplacement, mécanisme attesté par le SWHID, dont le coeur intrinsèque reçoit des qualificateurs contextuels, et par le GroupVersionKind de Kubernetes, où le groupe qualifie la sorte.

La suggestion S3 de `ANL-003` en tire une forme : `<origine>:<PREFIXE>-<SLUG>`, l'identité locale demeurant inchangée à l'intérieur du dépôt. Un renvoi déjà écrit ne casse pas.

**Réponse.**

### Q9 - Faut-il décider maintenant, ou attendre le deuxième dépôt ?

Ajoutée le 2026-08-10. La suggestion S10 de `ANL-003` propose de suspendre toute décision sur l'espace de noms global jusqu'à ce qu'un deuxième dépôt consomme `clia`, en reprenant le critère que `ANL-002` a retenu pour la localisation du CLI.

`FND-002` appuie ce report : toutes les stratégies de gouvernance documentées, registre payant, délégation au DNS, consensus distribué, sont disproportionnées pour un système à un acteur.

Le risque du report est nommé : décider plus tard coûte plus cher si des renvois inter-dépôts ont été écrits entre-temps. S3 est conçue pour que ce risque soit nul.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2. Ces deux réponses bornent le modèle, ce qui est un préalable à toute prétention de version publique.

Q3, Q4 et Q5 relèvent probablement de la session d'outillage annoncée par la session en cours. Elles sont posées ici pour ne pas être reperdues, ce qui est la fonction que `RES-004` assigne à une objection informative.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-003](../ressources/RES-003-intention.md)
- `objecte-a` [RES-006](../ressources/RES-006-ontologie.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
- `reference` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `reference` [ANL-003](../analyses/ANL-003-systeme-d-identifiants-de-clia.md)
