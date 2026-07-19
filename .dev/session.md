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


## 12. [recherche et analyse]

### Problématique

Le documents CONSTITUTION.md semble mélanger 2 types d'information de nature différentes:

- domaine de responsabilité/intervention des acteurs (humain ou automatismes (cli) ou agent IA)
- le processus et son orchestration

### Recherche de fondation

Mobiliser le savoir disponible en matière de documents harness IA dans la litératture en faisant 

Se demander quelles sont les grandes classes de méthodologie de travail avec IA. 

Passer en revue les principaux outils/framework IA

Faire une liste de tous les documents harness connus et dire leur rôle.

Terminer en faisant une analyse critique des harness de 1. gouvernance et 2. orchestration de processus.


### Analyse

Au regard de la recherche de fondation, faire une analyse critique du fichier CONSTITUTION.md

Et faire des recommendation de refactor de ce fichier

## 13. [recherche et analyse] Pour quoi utiliser l'IA

Mobiliser le savoir accessible concernant les capacités des modèles.

Identifier clairement ce que peuvent faire les modèles (en particulier haiku, sonnet et opus).

Identifier les capacités spécifiques des IA par rapport aux méthodes pré-IA. Que peut faire un modèle que ne peut pas faire un programme sans IA.

Identifier les capacités de l'IA qui l'on rendu si productive et autant indispensable

Produire une Recherche de fondation sur ces sujets.

Puis, faire une analyse critique du projet actuel par rapport à l'usage qui est fait de l'IA. Nous avons le principe suivant: n'utiliser l'IA que lorsque c'est absolument nécessaire. Le reste => automatiser. Et permettre à l'humain d'exécuter à la demande ou d'inspecter n'importe quel étape d'un processus.

Produire un document d'analyse ANL

## 14. [analyse documentaire]

Consulter tout les documents CONSTITUTION.md trouvés à partir de @../..

Faire une analyse de leur contenu sur l'axe gov vs orchestration vs hybide

## 15. [analyse documentaire]

Consulter tout les documents .dev/fondations/*.md trouvés à partir de @../..

Identifier ceux qui traitent des harness files et les rapatrier dans les FND de ce projet-ci.

## 16. [analyse documentaire]

Consulter tout les documents .dev/fondations/*.md trouvés à partir de @../..

Identifier ceux qui traitent de l'intention, de la gouvernance et constitution et les rapatrier dans les FND de ce projet-ci.

Et rapatrier également le FND: FND-002-ingenierie-livrables-qualite.md 

## 17. [importation savoir]

Rapatrier les 2 documents écartés
  - FND-002-intention-affaire-et-succes-entrepreneurial
  - FND-005-prise-de-decision-et-influence

Puis faire une analyse critique des ADR de @../../noumanity-dev/ticket-driven-ia
Et comparer avec les besoins et la notion de livrable dans ce repo.
Également, les specs et les reqs de ticket-driven-ia ne semblent pas être les même définitions que ce qui est dans ce repo ici.

Faire une recherche de fondation exhaustive à propos des notions de requis et de spécification.

Puis inclure une analyse critique et des recommendations au regard de ce savoir dans le document d'analyse. Et émettre des recommendations.

## 18. [recherche de fondation + analyse]

Qu'est-ce qu'un MCP et comment en mettre en place dans l'environnement Claude et avec des clis?
Produire une recherche exhaustive.

Avec ce savoir mobilisé, faire une analyse critique de l'intérêt de leur utilisation dans `clia`?

## 19. [conception] Ajout d'une nouvelle ressource => principe de conception

Créer un nouveau type de ressource => principe de conception

Le principe de conception guide à haut niveau le design du système. Ainsi, tout élément du système doit respecter ces principes et être cohérent avec eux.

TODO: analyse le repo ici et identifier les principes de conceptions. Les expliquer, dire quel en est la portée et les conséquences. Dire également si l'implémentation actuelle respecte les principes. Inclure dans l'analyse un tableau récapitulatif.

TODO: Produire une recherche de fondation sur le design de systèmes complexe, sur les principe de conception et sur la place que joue le principe de conception dans le design de systèmes complexes.

TODO: Produire un ADR définissant la ressource "principe de conception"

TODO: produire un SKILL (et ajuster les harness) encadrant la production d'un principe de conception

TODO: adapter les bogues pour dire explicitement que le non respect d'un principe de conception est un bogue.

20. [conception] 

Faire une recherche de fondation sur les LLM wiki et sur google Open Knowledge Format.

Utiliser également le source-material poe.com/post-rag-llm-wiki.md

Et plus généralement, mobiliser le savoir portant sur la gestion et l'utilisaiton de la connaissance, les systèmes sémantiques et ontologiques.

Puis faire une analyse critique de clia, notamment en lien avec les ressources livrables documentaires. Dire si c'est une bonne idée d'utiliser le OKF de google et quel impact cela aurait sur clia (modification nécessaire).
Et terminer avec des recommendations.

## x. [Recadrage humain] CONSTITUTION.md, PROCESSUS.md et CLAUDE.md

Suivre les recommendations des analyses précédentes afin de séparer les responsabilités:





## x. [Recadrage humain]

Ressources livrables

Nous allons réécrice l'ADR-004




## x. [Résolution des objections] Première passe PLN-012

Mettre à jour PLN-012 au regard des précisions ci-bas

### Objection 1

Nous étendons les modes d'installation supporté

TODO:

- ajouter un ADR décrivant les commandes d'installations 