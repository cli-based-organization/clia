---
type: objection
id: NON-002
title: "Coût du modèle et prolifération des types"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [RES-001, RES-007, RES-000]
---

# NON-002 - Coût du modèle et prolifération des types

> `CLAUDE.md` annonce vingt-sept types de ressources, chacun devant recevoir un ADR, une définition et un skill. Cela fait quatre-vingt-un documents de méthode à produire et à maintenir, et rien n'établit que ce coût soit soutenable.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

La structure de coût du modèle, à trois niveaux.

Le triplet par type : chaque type demande une définition, un ADR et un skill. Sept types font vingt-et-un documents ; vingt-sept types en font quatre-vingt-un.

Le nombre de types : vingt-sept, dont vingt-et-un n'ont aucune instance dans `clia`.

Le coût par instance : les définitions produites le 2026-08-09 exigent quatorze champs de frontmatter pour une définition de type, huit pour une objection, sept pour un contexte, plus des rubriques obligatoires.

## Pourquoi cela ne peut pas rester implicite

`ANL-001` établit au défaut D4 que le système consacre une part croissante de son énergie à se décrire, avec trois mesures.

Dans `nou-methodologies-ia`, cinq skills sur douze portaient déjà sur la production des fichiers de harnais eux-mêmes.

Sur les 585 instances de ressources typées du corpus, 99 sont des logs et 172 des tâches de ticket : les traces d'exécution dominent les livrables.

Le harnais actuel de `clia` prescrit sept fichiers de journalisation par requête pour des tâches dont la durée médiane observée est de trente minutes.

Le contre-exemple est le plus embarrassant : le dépôt le plus régulièrement travaillé du corpus métier, `noumanity-formation/linux-pqc` avec quarante-huit commits, ne porte aucun harnais.

L'objection n'est pas que le modèle soit inutile. Elle est qu'aucun document du corpus n'a jamais posé la question du coût, et qu'un système conçu pour augmenter la capacité de travail doit pouvoir démontrer qu'il n'en consomme pas plus qu'il n'en libère.

## Questions

### Q1 - Le triplet définition, décision, processus est-il exigible pour tous les types, ou seulement pour certains ?

Une position intermédiaire existe : la définition est obligatoire, le skill n'est produit que lorsque le type a été instancié au moins deux fois, l'ADR n'est produit que lorsqu'une décision a effectivement été disputée. Le triplet complet devient alors un état d'aboutissement, non un prérequis.

**Réponse.**

Le triplet n'était d'une tentative... l'évolution récente pointe vers une situation bien pire!

Il faut rappeller ici l'objectif: concevoir un système de collaboration entre agents humains, IA et automatismes (cli). 

La notion de type n'est pas le bon concept. Ce qui est structurant, c'est => ressource (RES) ou non-RES.

Tout le système est structuré autour de la manipulation conforme des ressources.

Les ressources sont définies pas un fichiers RES. chaque nouvelle ressource est un "type de ressource".

Les skills encadrent la manipulation spécialisée des ressources. Si un traitement générique est possible, on peut se contenter d'un skill commun à une catégorie de ressource. En fait, les skills sont des ressources générés ils ne font pas autorité et sont entièrement dérivables de RES, ADR, SPC et REQ


un paquet de scripts et de fichiers cuelang (ou autre pour la validation) peuvent être nécessaires pour manipuler une ressource adéquatement.


Questions ouvertes... est-ce que les logs sont des ressources? J'aurais tendance à dire oui. Mais je n'en suis pas certain.


### Q2 - Quel est le seuil au-delà duquel un type ne se justifie pas ?

Aucun critère n'existe aujourd'hui. Candidats : le type a au moins deux instances prévues dans les six mois ; sa production est plus rapide que ce qu'elle fait gagner ; son absence a causé un dégât identifiable. Faut-il un test d'admission pour les types, comme `RES-007` en propose un pour les concepts ?

**Réponse.**

le type n'est pas le bon concept. C'est un type de ressource.

Un nouveau type de ressource est créer lorsque le besoin s'en fait ressentir.

### Q3 - Faut-il vingt-sept types, ou faut-il commencer par sept et n'ajouter que sous pression d'un besoin constaté ?

`ANL-001` établit que dix-sept préfixes seulement ont des instances dans tout le corpus, et que six types définis dans `micrologic-clients` n'ont jamais été éprouvés. La liste de vingt-sept types de `CLAUDE.md` est-elle un objectif, un inventaire de pistes, ou une prescription ?

**Réponse.**

Faire les types de ressource demandé et ne pas contester. clia est un système de gestion de ressource de différent types. Les types vont évoluer... mais il y aura toujours autant de types nécessaire pour y encoder les contenus informationnels dont nous avons besoin de manipuler.

### Q4 - Le nombre de champs de frontmatter obligatoires est-il tenable sans outil ?

Quatorze champs pour une définition de type, saisis à la main, sans validation. `ANL-001` mesure que la seule règle de statut a déjà dérivé, avec `completed` dans cinquante-deux logs et `complet` dans deux autres. Faut-il réduire les champs obligatoires au strict minimum jusqu'à ce que `clia` puisse les vérifier ?

**Réponse.**

C'est un travail qui reste à faire... les types frontmatter ne sont pas tout à fait satisfaisant. Nous y viendrons plus tard.

Mais oui, ce sera la responsabilité de clia de les vérifier et de les manipuler.

### Q5 - Qui paie le coût de la journalisation à sept fichiers par requête ?

Le harnais actuel prescrit `demande.md`, `commit-message.yaml`, `analyse.md`, `fait.md`, `validation.md`, `resultat-validation.md`, `next.yaml`. Pour une tâche de trente minutes, cette journalisation peut représenter une part majoritaire du travail produit. Est-elle exigible pour toute tâche, ou seulement au-delà d'un seuil ?

**Réponse.**

La traçabilité et la lisibilité des agents IA est une caractéristique centrale du système. À terme ce coût génère une ressource plus importante que ce qu'elle coute.

### Q6 - La table des types doit-elle vivre dans `CLAUDE.md` ou dans `.dev/ressources/index.md` ?

Les deux portent aujourd'hui la même information. `ANL-001` établit que la duplication non tenue est le mode de défaillance dominant du corpus : trente-trois `CLAUDE.md` pour dix-huit contenus, trois `INTENTION.md` identiques désignant le mauvais client. Une des deux tables doit devenir une vue déclarée de l'autre. Laquelle est la source ?

**Réponse.**

La source de vérité des ressources sont les fichiers RES. Dans le harnais IA, seul un skill d'interprétation des demandes devrait expliquer comment identifier la RES livrable.



### Q7 - Les critères de satisfaction et de trahison de `RES-003` sont-ils exigibles ?

`RES-003` les rend obligatoires. Ils sont ce qui rend l'objection instruisible, et ils sont difficiles à écrire : formuler un critère de trahison demande de nommer son propre échec. Le risque est qu'ils soient renseignés pour la forme, ce qui serait pire que leur absence.

**Réponse.**


Le critère de trahison est intéressant. à garder dans le template de génération de RES-003. Mais ce n'est pas obligatoire.

## Ce qui lèverait cette objection

Une décision explicite sur Q1, Q2 et Q6. Ces trois réponses fixent la structure de coût et rendent les suivantes secondaires.

Cette objection est déclarée `bloquant` non pour empêcher le travail, mais parce qu'elle conditionne la portée de la session : produire vingt et un documents supplémentaires avant d'avoir répondu à Q1 serait engager un coût que rien ne justifie.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-007](../ressources/RES-007-concept.md)
- `objecte-a` [index](../ressources/index.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
