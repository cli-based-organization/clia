---
type: objection
id: NON-004
title: "Frontière entre Ontologie, Concept, Fondation et Analyse"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: informatif
etat: repondue
porte-sur: [RES-006, RES-007]
---

# NON-004 - Frontière entre Ontologie, Concept, Fondation et Analyse

> Quatre types portent du savoir et se recoupent. Le concept n'a aucune matière dans le corpus, l'ontologie du système n'existe pas alors que les définitions en dépendent, et la fondation est un format trop lourd pour le besoin observé.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.
- 2026-08-10 : **Q1 répondue par l'humain.** Le concept a deux formes selon son usage attendu, et une demande explicite en découle : documenter un `ISU` sur la définition d'une ressource dans un document ressource.
- 2026-08-11 : traitement partiel, une seule réponse connue. Interprétée par `ANL-007`, ajustement ordonné par `PLN-004`, et `ISU-001` ouverte comme demandé.
- 2026-08-11 : **les six questions restantes répondues par l'humain.** Trois d'entre elles portent un reproche de méthode à l'agent. Traitement complet, tâche 27 : `ANL-008` remplace `ANL-007`, `PLN-005` remplace `PLN-004`. L'état passe à `repondue`, l'effet à `informatif`.

## Ce qui est contesté

La répartition du savoir entre quatre types, et deux manques immédiats.

`RES-006` et `RES-007` proposent un départage en une question, d'où vient le contenu : d'autrui avec sources pour la fondation, d'un existant observé pour l'analyse, d'un accord sur les mots pour l'ontologie, de l'élaboration propre pour le concept. Ce critère est net sur le papier ; il n'a jamais été appliqué.

Le premier manque est une contradiction interne du jet : les sept définitions emploient des relations (`derive-de`, `remplace`, `reference`, `objecte-a`, `repond-a`, `specifie`) que rien ne définit. Le vocabulaire provisoire est écrit dans `RES-001`, ce qui en fait une source parallèle, exactement le défaut que le modèle prétend éviter. L'ontologie du système est nécessaire et absente.

Le second manque est de calibrage. `ANL-001` établit au défaut D6 que le savoir accumulé n'est pas mobilisable : onze dépôts de technotes dont six sans aucun fichier versionné, trois dépôts de notes IA vides dans trois groupes. La seule ressource de savoir outillée est la fondation, format long, exhaustif et sourcé. Le besoin observé est de conserver des notes de deux lignes, et le seul outil disponible en demande dix pages.

## Pourquoi cela ne peut pas rester implicite

Le corpus a perdu sept concepts en douze mois : topologie de style, phore, pilier de communication, distillation, extreme-smart, réflexivité, objection sociocratique. Trois d'entre eux sont des notions dont le système actuel dépend sans les avoir écrites.

En parallèle, il a produit cinquante-deux fondations et vingt-huit analyses. Le savoir n'est pas absent : il est mal réparti, et la forme légère manque.

L'`INTENTION.md` de `clia` affirme fournir nativement des capacités de mobilisation et d'utilisation du savoir. `ANL-001` conteste cette affirmation. Cette objection est le lieu où la conception doit y répondre, ou l'intention doit être révisée.

## Questions

### Q1 - Le concept est-il un type distinct, ou une entrée d'ontologie développée ?

`RES-007` le distingue par la forme : entrée de lexique contre document d'une à trois pages. La position concurrente est qu'une ontologie admette des entrées longues, ce qui économise un type. `ANL-001` note que le concept est le type sans aucune matière et le plus susceptible de proliférer.

**Réponse.**

L'ontologie est un ensemble de concepts et leurs relations.

Il faut comprendre ce qu'est clia: un système de manipulation avancé d'information.
L'usage d'aucune ressource n'est obligatoire. Ils sont utilisables au besoin.

Donc, CPT peut être utiliser pour des concepts importants qui seront utilisés et réutilisés à plusieurs endroits. Si ce n'est pas le cas, un CPT peut être définit dans un fichier ONT.

Conséquence => nous avons besoin de pouvoir définir une ressource dans un document ressource. Comment implémenter ce feature? documenter un ISU à propos de cette question

### Q2 - Où vit le vocabulaire de relations, en attendant `ONT-001` ?

Il est aujourd'hui dans `RES-001`, ce qui est une source parallèle assumée par défaut. Trois positions : produire `ONT-001` immédiatement ; laisser le vocabulaire dans `RES-001` et le déclarer comme provisoire daté ; renoncer aux relations typées jusqu'à ce qu'un outil les exploite.

**Réponse.**

Nous devons rappeller ce que le système clia est et faire la distinction entre les ressources propre au repo clia et les ressources des repos qui utilisent clia.

Dans la pure tradition des projets informatiques fondateurs, clia utilise clia.

Aussi, le système clia est décrit par des ressources. Et ce tant pour ses fondements théoriques, sa conception, que pour son implémentation.

Commençons par créer une ontologie ONT-001 définisant les concepts fondamentaux de clia et leurs relations. 

Au besoin, plus tard nous les extraierons

Aussi, il serait probablement "logique" de créer une ressource RES de type "relation". Quoique il faudrait au préalable définir la frontière entre concept et relation. La relation est probablement un type de concepte avec un ensemble de propriétés particulières?...



### Q3 - Faut-il une forme légère de conservation du savoir, plus courte que la fondation ?

Le besoin est mesuré : six dépôts de technotes sans fichier versionné, parce que le seuil d'entrée est disproportionné pour deux commandes GPG. Candidats : une note (`NOT`), une entrée d'ontologie enrichie, ou un recueil par domaine sur le modèle du recueil de faits de `RES-005`. Ou bien : aucune, et le savoir léger reste hors du modèle.

**Réponse.**

Il y a ici méprise de la par de l'agent. L'agent revient souvent avec cette conception naive à propos du savoir et cela m'agace beaucoup...

Le savoir n'est pas homogène. Il est même quantum-like... Donc, c'est un objet très complexe pour lequel il n'existe pas une seule manière de le stocker et de le traiter.

Quand vient le temps de stocker, mobiliser, transformer, etc. le savoir, il est impératif de prendre en compte le contexte et ses différentes déclinaisons:
- le contexte "actuariel": qui il est l'acteur? Et dans quel état émotionnel se trouve-t-il au moment d'agir sur le savoir? Y a-t-il un ou plusieurs acteurs?
- le contexte intentionnel: que veut-on accomplir?
- le contexte des moyen: par quel moyen prévoit-on réaliser cette intention?
- le contexte historique: qu'a-t-on fait dans le passé et quels ont été les résultats?
- etc.
- etc.

conséquence => il faudrait bien définir la frontière entre information et savoir. le savoir est une forme particulière de relation entre un acteur et une information.


Les technotes et les recherches de fondation sont effectivement toutes 2 des "condensés de savoir". Mais ils ont des objectifs et des usages totalement différents:

- la technote (tel qu'on la retrouve dans les repos historique) est un condensé de savoir permettant à un humain de comprendre un dispositif technique et de l'utiliser concrètement.
- la recherche de fondation est une mobilisation des savoir existant sur un sujet qui établit un socle de connaissance nécessaire à un travail intellectuel. Par exemple, le désign/conception d'un système, la recherche d'une solution/recette, la conduite d'une activité de recherche ou la rédaction d'un article scientifique.

conséquence => les technotes et les fondations FND sont à la fois des ressources sources et des ressources générés. Donc, une ressource doit pouvoir être hybride (source et générée) dans l'absolut. Le contexte d'usage détermine de quelle manière elle s'incarne en pratique (source ou générée). Dans un contexte d'usage, à un moment précis, pour une tâche précise, la ressource n'a qu'un seul rôle à la fois (source OU généré)

conséquence => une mise à jour du savoir mobilisée doit impliquer une mise à jour des ressources générés par ce savoir

Aussi, la technote étant conçu pour guider l'action, la technote doit prendre en compte les capacités et caractéristiques intrinsèques à l'acteur.

Conséquence => il y a possiblement minimalement 3 déclinaisons de technotes : 1. dans l'absolu (ou simultannément pour tous les acteurs possibles !), 2. pour un acteur humain et 3. pour un acteur IA


### Q4 - Que faire des sept concepts orphelins du corpus ?

Trois sont critiques parce que le système en dépend : `extreme-smart`, `distillation`, `objection sociocratique`. Faut-il les écrire dans cette session, les inscrire à un registre de dette, ou les laisser où ils sont ?

**Réponse.**

Le registre de dette est une bonne idée!  Créer une ressources "registre" puis une instance "registre de dette". Également, "registre de bogues" et "registre de tâches à faire prochainement"

PDC-003 traite déjà de 'extreme-smart'.

Proposer un PDC qui traite de la 'distillation'. La distillation est également le moteur du cycle de vie des ressources informationnelles. 

conséquence => la ressource informationnelle n'est qu'un réceptacle matérialisé et outillable d'une idée. 

conséquence => le cycle de vie des ressources informationnelles n'est pas individuel, il est collectif. Les idées sont en constantes évolutions et en constantes relations les unes par rapport aux autres. Les idées sont polymorphes (selon le contexte) ou, dit autrement quantum-like. Leur nature peut changer suite à un changement de contexte.

conséquence => la notion de "espace actif" est plus importante qu'il n'y parait... c'est l'incarnation d'une contextualité informationnelle dans un espace informationnel plus large.


### Q5 - La frontière fondation contre analyse est-elle tenue en pratique ?

`ADR-001` de `clia` la tranche : l'analyse porte sur un existant matériel, la fondation sur la littérature. Or `micrologic-clients` porte quatre fondations dont deux, sur la journalisation des faits privés et sur la persuasion, sont des élaborations propres autant que des recherches. Selon le critère de `RES-007`, ce sont des concepts. Faut-il reclasser, ou admettre que le critère est indicatif ?

**Réponse.**

Cette question reflète une tendance de l'agent IA qui m'agace beaucoup: prendre ce qui est observé pour une vérité.

Il est bien d'observer ce qui a été fait dans les autres repos. Mais cela ne fait pas de ces observations des vérités factuelles. L'agent IA a tendance à sauter trop vite aux conclusion et à ne pas bien gérer l'incertitude et l'indétermination. Certe, il faut poser des hypothèses pour comprendre le réel et agir. Mais la source de vérité ultime est contextuelle (dépend du repo) et elle est déterminé par l'humain via INT et DCN.

**La fondation mobilise le savoir existant et accessible.**

**L'analyse est une réflexion sur une question précise.** C'est une ressource générée à partir de FND, d'une question (besoin d'un autre type dédié?) et tout autre information pertinente.

### Q6 - Le seuil d'admission des concepts à trois conditions est-il applicable ?

`RES-007` exige qu'un concept soit employé dans deux ressources, qu'il ne se réduise pas à une entrée d'ontologie, et qu'il change une décision. La première condition crée un problème d'amorçage : un concept nouveau n'a aucun emploi attesté au moment où on l'écrit.

**Réponse.**

non. C'est l'humain qui crée le concept qui détermine si il est pertinent ou non.

Le seul critère est sa compatibilité avec clia ou avec le système où clia est utilisé

### Q7 - L'affirmation de `INTENTION.md` sur la mobilisation du savoir est-elle maintenue ?

`ANL-001` établit que rien dans le corpus ne la soutient. Trois positions : la maintenir et produire le mécanisme qui la justifie ; la reformuler comme une intention à atteindre plutôt qu'une propriété acquise ; la retirer. `INTENTION.md` est en édition humaine exclusive : seule l'humain peut trancher.

**Réponse.**

L'agent IA ne semble pas bien comprendre la notion d'intention. Également, l'agent IA ne semble pas bien comprendre le processus de construction et, en particulier, son temps caractéristique.

L'intention est ce à quoi veut parvenir l'acteur. 

Le système clia est en cours de conception et d'implémentation. Il y a nécessairement un écart entre l'intention et l'implémentation. La réalisation d'un système de cette complexité à la frontière de la connaissance et du savoir faire demande un temps non nul...


Sur le fond, oui. clia est un système de gestion informationnelle. Les capacités de mobilisation du savoir et de manipulation de l'information en forme le socle. Et c'est, surtout, ce qui le différencie de la majorité des autres méthodes de travail augmenté par IA.

## Ce qui lèverait cette objection

Une réponse à Q2 et Q3. Q2 résorbe une contradiction interne du jet, Q3 répond au manque fonctionnel le plus mesuré du corpus.

Q7 est de la responsabilité exclusive de l'humain et ne bloque rien, mais elle reste ouverte tant qu'elle n'a pas reçu de réponse.

**Levée le 2026-08-11.** Les sept questions portent une réponse.

Q2 et Q3, que cette objection désignait comme décisives, sont répondues. Q2 demande de produire `ONT-001` ; Q3 écarte la prémisse de la question et redéfinit le savoir comme une relation entre un acteur et une information.

Trois réponses portent un reproche de méthode plutôt qu'une décision de conception. `ANL-008` C1 les traite, et `PLN-005` chantier A en tire deux règles.

L'effet passe de `conditionnel` à `informatif`. Les neuf chantiers d'ajustement sont ordonnés par `PLN-005`.

## Relations

- `objecte-a` [RES-006](../ressources/RES-006-ontologie.md)
- `objecte-a` [RES-007](../ressources/RES-007-concept.md)
- `objecte-a` [INTENTION.md](../../INTENTION.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
- `reference` [ANL-008](../analyses/ANL-008-le-savoir-est-une-relation-entre-un-acteur-et-une-information.md)
