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


## 8. [conception] Étendre les entrée possibles provenant d'humain

Dès le départ, on a voulu restreindre les moyens par lesquels l'humain fournit de l'information au système.

En contraignt à un fichier markdown (ticket.md, issue.md, task.md, session.md), on vient répondre à plusieurs besoins, notamment: 1. entrée conventionnée, 2. journalisation des prompts, etc.

Cependant, cet unique mécanisme est contraignant. Il est rataché à un certain mécanisme de traitement qui peut être inadapté dans le cas d'usages variés.

Aussi, nous avont déjà étendu le système afin de permettre une plus grande variété de cas d'usage:

- répertoire `source-material`. inspiré de notebook LM permet de prendre en input n'importe quel fichier produit à l'extérieur de clia. Donc, ça peut inclure aussi du texte écrit par l'humain qui pilote son système d'informaiton.
- NON. les objections
- ENT. les entrevues

Il y en a peut être d'autres que je n'ai pas en mémoire? Vérifier et les prendre en considération.

Nous ajoutons un autre mécanisme => FRG, le Fragment. Il s'agit de ressource textelle auto-cohérente d'intérêt à partir de laquelle d'autres ressources seront générées. 

Également, nous ajoutons la ressource DCN => décision. Qui est une ressource qui encode une décision : texte de loi, règlement, décision d'un CA on de n'importe quelle autre instance.

Écrire les RES "FRG" et "DCN".

Écrire une DCN pour les ADR-001 à ADR-014

Nous décidons ceci => les ressources sont regroupés en fonction de leur fonction: 
- fondamentale
- de conception
- de contrôle
- de contenu (FRG, DCN, ...)
- de préparation/planification
- d'implémentation (COD, PRS, ...)


Écrire une DCN qui signale cette décision et en explique les conséquenses. Et écrire une ADR qui explique la décision architecturale.

Décrire les ressources (RES) FRG et DCN.

Décrire l'ensemble des ressources (RES) mentionnés dans le fichier CLAUDE.md et qui ne sont pas encore décrites.

Pour toute ressource, fournir les éléments suivants:

- un skill qui guide les agents IA dans la création, modification et dans la validation de la ressource,
- un fichier cuelang permettant de valider la validité du frontmatter yaml,
- un template permettant de générer la ressource dans son format markdown,
- un fichier cuelang permettant de valider le contenu yaml à passer un template

Pour toute ressource qui n'est pas explicitement approuvée par un humain, mettre le status 'draft'.



## 9. [conception] propriété holographique et composable/atomique des ressources

Une ressource est définit comme un ensemble identifiable et auto-cohérent d'informations.
L'implémentation spécifique n'est pas importante. Une ressource peut être un fichier, un répertoire contenant plusieurs fichiers, un répertoire git ou tout autre 

Écrire une DCN et un ADR pour cette décision.


Décision: Un ressource est est composable/atomique. C'est à dirre qu'on peut construire une ressource à partir d'un assemblage d'autres ressource et que chaque "composant" d'une ressource est un atome (une petite ressource qui fait partie d'une autre ressource).

Mettre â aussi dans la DCN et l'ADR 


## 10. [décision] distinguer de manière stricte la spécification du système clia de son implémentation

DCN en draft et premier jet de ADR


## 11. [méthodologie] Recherche

Consulter ANL-001 pour définir la meilleur méthodologie de recherche de fondation.

La version la plus aboutie du prompt pour une FDN est celui de la tâche 7. Quoique le poduit FND-002 n'est pas assez long et exhaustif et que les citations ne sont pas au niveau attendue d'une recherche universitaire.

Produire un document MET qui décrit comment procéder pour faire une recherche de fondation, quel est l'input requis/optionnel et quel est le résultat attendu.


## 12. [implémentation] améliore l' auto-documentation de clia


le cli clia devrait être utilisable par n'importe qui et les fonctionnalités découvrables.

Or, actuellement, toutes les fonctions ne sont pas découvrables:

```sh
$ clia res new -h
clia: description manquante
```

corriger ce bug.

Et mettre dans les principes fondamentaux l' "auto-découvrabilité" du système.

## 13. [bogue] identifiants relatif des ressources

À l'interne d'un repo clia, toutes les ressources doivent être référençables (alias) par: <PREFIX>-<SEQ>.

Pour les ressources RES, éliminer toute référence à <PREFIX>-<DATE> et <PREFIX>-<SLUG>

Corriger les noms de fichier et les références.


## 14. [recherche de fondation] Décisions institutionelles traçables

Faire une recherche de fondation (en utilisant MET-001) portant sur la documentation des décisions.

L'objectif de cette rechserche est de mieux comprendre les pratiques de documentation des décisions et de suivi des changements décision dans différents dommaines et différents contextes.

Afin d'enrichir la ressource DCN introduit à la tâche 8 et, surtout, nos méthodologies de travail avec cette ressource.

## 15. [bogue] La rédaction des ressources (RES) est trop verbeuse et se justifie trop

Les ressources RES devraient être décrites de manière diractive et factuelle.

Or, l'agent IA justifie sans cesse ses décisions comme s'il avait peur des reproches...
À la limite, si des références externes sont nécessaires, les écrires sous la forme d'une bibliographie (liste numérotée de références externe). Mais NE PAS EXPLIQUER POURQUOI ON A PRIS UNE DÉCISION.

Diagnostiquer ce problème. En trouver la cause et proposer un correctif. 

Faire un plan de rémédiation incluant (sans s'y limiter):
- 1. la correction des harnais pertinents
- 2. la correction des ressources RES

## 16. [conception] traçabilité de l'historique des ressources

Dans une implémentation sur système de fichier (nécessaire pour être compatible à OKF), une ressource est soit:
- un fichier,
- un répertoire contenant des fichiers et répertoires, ou bien
- un repo git

Le cas limite où la ressource est un repo git, il suffit de signer tout les commits pour avoir une traçabilité complète de l'histoire de la ressources.

Ceci est possible parce que: 
- 1. git est un blockchain
- 2. pour toute la chaine des modification il est possible d'avoir le diff de toutes les modifications


Est-ce possible de conserver l'historique
- 1. d'un fichier et
- 2. d'un répertoire contenant des fichiers et des sous-répertoires

à partir des infos de git (à la racine du repo qui contient la ressource).

Y a-t-il des contraintes à respecter pour s'assurer qu'on pourra suivre l'historique individuelle de chaque ressources

faire une analyse (ANL) du sujet. Quelles seraient les autres options jouables pour avoir un blockchain de la suite des modifications et de connaitre le diff entre chaques nouvelles versions.

Terminer l'analyse avec des recommandations.

## 17. [implémentation] Exécuter le plan PLN-002

## 18. [traitement des objections] prendre en compte des réponses à NON-001

## 19. [implémentation] Mettre en place la mécanique de suivie de l'historique des ressources

se baser sur ANL-005. Ne pas couvrir le cas où une ressource est un repo

D'abord, fournir un script de vérification de l'état du repo:

```sh
clia git check STATE  # vérifie que l'état du repo est conforme. STATE = clean | done
clia git save  # commit les modifications en utilisant le fichier log: commit-message-task-<SEQ>.md
clia git log RESSOURCE  # affiche l'historique de la ressource
```

## 20. [bogue] seul les humains peuvent prendre des décisions

Interdire (CONSTITUTION.md) aux agents IA de créer ou de modifier une décision.

Les agents IA peuvent faire des recommentations, mais c'est uniquement les humains qui peuvent prendre des décisions.

le cli clia génère un template. L'humain l'édite. L'historique est suivie par git grâce à clia git save.

Interdire aux agents IA d'utiliser la commande `clia git save`

Également valide pour les principes de conception... seul les humains peuvent créer des ressources PDC

## 21. [traitement des objections] prendre en compte des réponses à NON-002

## 22. [traitement des objections] prendre en compte des réponses à NON-003

## 23. [conception] générer une ressources de type issue (ISU)

générer un PDC "SMART et extrême SMART" applicable aux ressources de planification du travail.

issue permet de stocker des information documentant une problématique dans le but de la résoudre. Il est non smart 

## 24. [planification] refactor de mise en conformité avec DCN-013

Prendre acte de la décision DCN-013 et des réponses données en NON-026

En faire une analyse qui en donne une interprétation du point de vue de l'agent IA et qui en déduit les implications pour le système clia.

Faire des propositions pour adapter minimalement clia afin de la mettre en conformité avec DCN-013.

Proposer un plan de mise en conformité.

## 25. [convergence comportement attendu] système de journalisation

Défauts:

- **D1.** Un humain doit être capable de comprendre le contexte permettant de se repérer en inspectant les noms de fichiers et de répertoires des journaux.
- **D2.** Le contenu doit être facilement cherchable par un humain
- **D3.** Le contexte (notamment les dates/heures d'exécution) doit être facilement compréhensible par un humain
- **D4.** Les éléments du journal doit être généré au moment de sa réalisation


conséquence => les skills métier doivent être générés en tenant compte de la MET de journalisation


Correctifs proposés:


- Session, tâche et log sont des ressources => écrire RES pour LOG, TSK et SES
- chaque tâche a son propre répertoire contenant (tous et uniquement) les logs de cette tâche
- on ne combine jamais les logs de plusieurs tâches
- le nom de fichier est: TSK-<SEQ>-<TYPE_LOG>_<YYYY-MM-DD-HH-MM>_<SLUG>.md
- le numéro SEQ est le numéro du type d'information de log. L'association numéro séquentiel + type de log est fixe (le même) pour toutes les taches et le numéro est une estimation de l'ordre de génération de chaque type d'info dans les logs
- produire une méthode MET de journalisation (ressource source) interne à RES log
- dans la méthode, exiger que l'info de log soit inscrite dans le fichier au moment de son exécution
- générer les skills en prenant en compte la méthode MET de journalisation


## 26. [bogue] toujours relire la tâche avant de l'exécuter

### Incident

l'agent IA a exécuté la tâche 25 avec l'information qu'il avait en mémoire, sans tenir compte des modifications apportées à session.md

### conséquence

La mauvaise tâche a été exécuté et, possiblement, avec des instructions incomplète

### interprétation de l'humain

Les fichieres SES sont écrits par des humains. Par conséquent, ils ne sont pas fiable et sont susseptible d'être modifiés à tout moment. Il faut toujours les relire et réévaluer les fichiers SES AVANT l'exécution d'une tâche

### TODO

Écrire une ressource USE décrivant le comportement attendu qui était attendu de la par de l'agent dans ce cas de figure

Écrire un BUG qui rapporte l'incident. Ce bug doit inclure (entre autre choses): 1. la description de l'incident et des conséquence, 2. le diagnostique (pourquoi l'agent a agit ainsi) et 3. des suggestions de mesures à prendre pour régler le problème.

Écrire un plan pour une prochaine ronde de résolution de BUG et y planifier la résolution de ce BUG.

## 27. [traitement des objections] prendre en compte les réponses à NON-004

Faire une analyse ANL qui interprète les réponses à NON-004 et en décrit les implications et conséquences.

Proposer un plan d'ajustement de clia pour tenir compte des réponses de NON-004.

## 28. [implémenttion] Registres et outillage

Les registres sont une catégorie de ressource qui permet de contenir une liste de ressources.

Créer, si elle n'existe pas déjà, un registre des décisions.


Et ajouter une classe de commandes pour instrumenter les registres:

```sh
clia registre|reg CMD [OPTIONS...] [ARGS...]

clia reg ls   # donner la liste des registres
clia reg ls REG_TYPE-<SEQ>  # donner la liste des items d'un registre => SEQ RESSOURCE_ALIAS  description  status

clia reg show|edit REG_TYPE-<SEQ> SEQ 

```

## 29. [implémentation] PLN-005

Réévaluer PLN-005 au regard de PDC-003

Partir de la liste des livrables identifier.

Si il y a des problématiques non-smart, ouvrir un issue pour chaque thématique de problème.

Pour chaque issue ouvert, décrire la problématique dans l'issue. Pour chaque ISU, ouvrir des objection dans une ressource NON. et établir une relation entre ISU et NON.

Également, établir une relation enre ISU et les livrables bloqués ou impactés.

L'humain peut apporter des informations à un ISU en lui écrivant des FRG à l'intérique de ISU. Ou bien en y liant un FRG ou n"importe quelle autre ressource

À chaque nouvel informaiton, on peut réévaluer l'implémentabilité ou le caractère smart des livrables cibles.


TODO: écrire cette procédure dans une nouvelle MET.

Une fois que tous les ISU et les objections émises ont été créés, implémenter ce qui peut être implémenter de PLN-005






## x. [conception] Amélioration de la notion de ressource

La notion de ressource est le socle sur lequel repose le système clia.

### traitement des objections émises par l'agent IA

Prendre en compte les objections 
