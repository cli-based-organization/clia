---
start-at: 2026-07-31T15:46:08-04:00
---

# Intention

Nettoyer et refactorer pour la version 0.1.0

- Définir fonctionnalités de coeur et fonctionalités étendues
- Inspecter et corriger tous les ADR
- S'assurer d'un comportement correcte de clia dans les principaux cas d'usage
- Extensibilité démontrée


# Contexte

Depuis 1 an, nous étudions l'usage de l'IA avec harness. Nous avons convergé vers une méthodologie.

Actuellement, nous pouvons l'utiliser minimalement dans n'importe quel repo, cependant nous n'avons pas une version stable.

La présente session de travail cherche à stabiliser une version 0.1.0 qui soit présentable publiquement

# Tâches

## 1. [bogue] Identifier le contexte-répertoire de clia

Nous avions demandé de reproduire le comportement du cli tda. Mais une fonctionnalité est manquante. => prendre en compte le contexte-répertoire du cli.

La configuration (repo-root, dev-dir, logs-dir, session-dir, session-file, template, ressources, version-file) doivent être déterminés à l'exécution et tenir compte du répertoire où clia est lancé.

Comportement problématique => actuellement, peut importe le répertoire de lancement de clia, le repo de référence est ~/cli-based-organisation/clia. 

Comportement attendu => lorsque l'exécution de clia a lieu dans un repo clia-valide: 
- seul le cli-root et les templates pointe vers cli-based-organization/clia
- le reste devrait pointer vers le repo clia-valide

Ouvrir un bogue.
Expliquer pourquoi ça a été implémenté comme ça. Dire quels composants du code est impacté/responsable. Et proposer un plan de rémédiation.

Ne pas implémenter le plan


## 2. [conception] issues

Actuellement, clia n'a pas de système de tracking d'issue ou de ticket. Seul la ressource BUG existe.

Nous avons longuement réfléchi à ce sujet qui est important dans la conception de clia. L'aboutissement le plus intéressant est la distinction entre tâche smart et non-smart (voir dans les repos @../../noumanity-dev/ticket-driven-ai et @../../noumanity-ai-assisted-development-toolkit/nou-methodologies-ia/experimentations/deeptech-ticket-driven). Et la notion de "Extreme Smart"

todo => ajouter "Extreme smart" aux principes de conception

La ressource "ticket" ou "task" a été remplacée par la notion de session qui est beaucoup moins contraignante.

Problématique => Cependant, actuellement, nous nous retrouvons avec beaucoup de choses à faire et il est impossible, même avec l'IA, de tout faire en même temps. Aussi, nous avons toujours le besoin de 1. garder en mémoire ce que nous pensons qui doit être fait et 2. prioriser le travail.

Produire une recherche de fondation (FND) à propos des systèmes, frameworks et méthodes de gestion du travail en développement logiciel. Et, en particulier, à propos des systèmes de gestion des informations, par exemple: bug trackers, isues de GitHub, etc.

Prendre connaissance du travail qui reste à faire dans ce repo. Prendre en compte la tâche en préparation xy. Produire une analyse (ANL) à propos d'un ADR qui définit la méthode de gestion de travail. Quel ressources sont manquantes et doivent être produitent? Quels ressources doivent être adaptées? Est-ce que les processus et mécaniques de travail actuels sont suffisant? ou bien doit-on en prévoir de nouvelles ou adapter celles qui sont déjà en place? Esquisser un plan (dans l'analyse et NON PAS dans un fichier PLN). Émettre des objections. Doit-on ajouter une ressource "comportement attendu"? Dire en quoi les issues de GitHub ont été un progrès de simplification des bug tracker qui a grandement aidé à l'adoption de la plateforme Github. Discuter du système de graph d'intention proposé dans @../../noumanity-dev/ticket-driven-ai et @../../noumanity-ai-assisted-development-toolkit/nou-methodologies-ia/experimentations/deeptech-ticket-driven .


## xy. [conception] ADR à propos de la gestion du travail

Cette tâche prépare le contenu à mettre dans l'ADR gestion du travail 

Définir la notion de Extreme Smart

Nous adoptons seulement 2 types de ressources permettant de renseigner des choses à faire:

- les bogues: BUG
- les issues: ISU

BUG décrit des comportements du système qui ne sont pas conforme au comportement attendu.

ISU décrit une amélioration à faire de manière plus ou moins SMART

Définir la ressource intention (INT) qui décrit ce que veut faire un humain ou un groupe d'humain.





## x. [traitement des objections] PLN-020

### objection 1



### objection 2

### objection 3

### objection 4
