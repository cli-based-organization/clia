---
type: fondation
version: 0.1.0
title: "cas-usage-besoins-utilisateurs - Cas d'utilisation, user stories et méthodes de recueil du besoin dans le développement de systèmes d'information"
status: actif
date: 2026-07-28
---

# FND-018-cas-usage-besoins-utilisateurs - Cas d'utilisation, user stories et recueil du besoin

- **Objectif** : établir une base factuelle et sourcée sur les formes de description du besoin utilisateur (cas d'utilisation, user stories, job stories, exemples exécutables, requis en langage contraint), sur les méthodes de découverte et de priorisation qui les alimentent, et sur la place que leur donnent les méthodologies de développement logiciel, la gestion de projet informatique, la gestion de backlog et la gestion de produit. Complète `FND-015-requis-et-specification` (qui traite la distinction requis / spécification) en couvrant l'**amont** de cette chaîne : d'où vient le besoin et sous quelle forme il entre dans le système d'information.

## 1. Note de rigueur

Fondation appuyée sur les sources primaires de chaque technique lorsque celles-ci sont identifiables : Jacobson (1992) et Cockburn (2001) pour les cas d'utilisation, Jacobson et Spence (2011) pour Use-Case 2.0, Jeffries (2001) pour les 3C, Wake (2003) pour INVEST, Cohn (2004) pour les user stories, Adams et Klement (2013) pour les job stories, Adzic (2011, 2012) pour la spécification par l'exemple et l'impact mapping, Patton (2014) pour le story mapping, Mavin et al. (RE'09, 2009) pour EARS, et les normes ISO/IEC/IEEE 29148:2018 et ISO/IEC/IEEE 42010 pour le cadre normatif.

Trois précautions de lecture :

- **Le vocabulaire est contesté.** « Use case », « user story », « requirement », « feature », « scenario » n'ont pas de définition unique ; chaque école les emploie différemment. Les définitions retenues ici sont explicitement attribuées.
- **Les données d'efficacité comparée sont faibles.** Il n'existe pas de corpus empirique solide établissant la supériorité d'une notation sur une autre ; la littérature est majoritairement praticienne. Les jugements comparatifs de la section 6 sont signalés comme des appréciations.
- **La partie « outillage et IA » (section 8.6) est datée** et se périme vite (voir section 12).

## 2. Cadrage et thèse

**Question générale** : par quelles formes documentaires un besoin d'utilisateur entre-t-il dans un système d'information en construction, comment ces formes se distinguent-elles les unes des autres, comment sont-elles découvertes, priorisées, vérifiées, et quelle place leur donnent les méthodologies de développement ?

**Périmètre** :

- Dans le sujet : les formes de description du besoin (cas d'utilisation, scénarios, user stories, job stories, exemples exécutables, requis en langage contraint) ; les méthodes de découverte et de cadrage (entretien, observation, personas, impact mapping, story mapping, event storming) ; la place du besoin dans les grandes méthodologies (cycle en V, processus unifié, XP, Scrum, Kanban, Lean, spec-driven) ; la gestion de backlog, de produit et de fonctionnalités ; la traçabilité besoin vers test.
- Hors sujet : la distinction requis / spécification et sa littérature normative (voir `FND-015`) ; les caractéristiques de qualité documentaire (voir `FND-002`) ; les vues et points de vue d'architecture (voir `FND-009`) ; les techniques d'estimation et de mesure de vélocité ; le marketing produit et la recherche de marché en amont du produit.

**Thèse** : les formes de description du besoin ne sont pas des variantes stylistiques interchangeables mais occupent des **positions distinctes sur trois axes** : (1) l'**unité décrite** (une interaction complète orientée but, ou un incrément de valeur négociable, ou un exemple vérifiable) ; (2) la **durée de vie visée** (artefact durable qui documente le système, ou jeton de conversation destiné à disparaître) ; (3) le **destinataire** (l'humain qui décide, l'équipe qui construit, la machine qui vérifie). Un système d'information mature n'en choisit pas une seule : il retient une forme **durable et orientée but** pour tenir la carte des usages du système, une forme **incrémentale** pour piloter le flux de travail, et une forme **exécutable** pour transformer le besoin en vérification automatique. Le défaut le plus coûteux n'est pas le choix de la notation, mais l'**absence de chaîne** entre le besoin et la vérification : un système dont les tests ne dérivent d'aucun cas d'usage explicite ne peut pas démontrer qu'il sert quelqu'un.

**Définitions de travail** (attributions en section 4) :

- **Cas d'utilisation (use case)** : la description de toutes les manières dont un **acteur** peut atteindre un **but** en interagissant avec un système, incluant le déroulé nominal et les déroulés alternatifs et d'échec.
- **Acteur** : un rôle joué par une personne, une organisation ou un autre système vis-à-vis du système étudié. Un acteur est un rôle, pas un individu.
- **Scénario** : un déroulé unique, du début à une issue donnée. Un cas d'utilisation est un faisceau de scénarios.
- **User story** : une formulation courte d'un besoin du point de vue d'un utilisateur, servant de promesse de conversation et d'unité de planification.
- **Critère d'acceptation** : condition vérifiable permettant de déclarer qu'un besoin est satisfait.
- **Partie prenante (stakeholder)** : toute partie ayant un intérêt légitime dans le système, qu'elle l'utilise ou non.

## 3. Bref historique : de la spécification exhaustive au besoin situé

Quatre déplacements successifs structurent le champ.

**3.1 L'ère de la spécification exhaustive (années 1970 et 1980).** Le besoin est capturé sous forme d'un document de spécification complet et signé avant construction (modèle en cascade, normalisé plus tard par IEEE 830 puis ISO/IEC/IEEE 29148). La forme dominante est la liste d'exigences numérotées « le système doit... ». Vertu : traçabilité et contractualisation. Défaut constaté par la pratique : une liste d'exigences ne dit pas **qui** veut quoi ni **pourquoi**, et se prête mal à la vérification de complétude fonctionnelle.

**3.2 L'invention du cas d'utilisation (1986 à 1992).** Ivar Jacobson introduit le concept d'*use case* chez Ericsson et le popularise dans *Object-Oriented Software Engineering* (1992). L'innovation est de **structurer le besoin par le but d'un acteur** plutôt que par la fonction du système. Le cas d'utilisation entre ensuite dans UML (1997) puis au cœur du Rational Unified Process, qui se définit comme « use-case driven ». Alistair Cockburn en donne la codification praticienne de référence dans *Writing Effective Use Cases* (2001) : niveaux de but, formats casual et fully dressed, structure de flux.

**3.3 Le tournant agile et la user story (1998 à 2004).** L'Extreme Programming remplace le document par la **carte** : Kent Beck introduit les *stories* comme unités de planification, Ron Jeffries formalise en 2001 les « 3C » (Card, Conversation, Confirmation) qui affirment que la carte n'est pas la spécification mais la **promesse d'une conversation**, Bill Wake propose en 2003 les critères INVEST, et Mike Cohn publie *User Stories Applied* (2004). Le déplacement est double : du document vers l'échange, et de la description exhaustive vers l'incrément livrable.

**3.4 La convergence et l'exemple exécutable (2006 à aujourd'hui).** Trois mouvements se rejoignent. (a) Le BDD (Dan North, 2006) et la spécification par l'exemple (Gojko Adzic, 2011) transforment les critères d'acceptation en **exemples automatisables** (Given/When/Then, Gherkin, Cucumber), produisant une *living documentation*. (b) Use-Case 2.0 (Jacobson et Spence, 2011) réconcilie explicitement cas d'utilisation et agilité en introduisant les *use-case slices*, tranches livrables d'un cas d'utilisation, permettant d'alimenter un backlog sans jeter la structure d'ensemble. (c) La découverte continue (impact mapping 2012, story mapping 2014, jobs-to-be-done) remonte en amont du backlog pour relier les livrables aux changements de comportement recherchés.

Enseignement de cet historique : chaque génération a résolu un défaut réel de la précédente (l'exhaustivité sans finalité, puis la finalité sans incrémentalité, puis l'incrémentalité sans vue d'ensemble ni vérification). Les formes ne se remplacent pas, elles se **superposent par couches**.

## 4. Panorama des formes de description du besoin

### 4.1 Le cas d'utilisation

**Structure canonique (Cockburn)**. Un cas d'utilisation pleinement rédigé (*fully dressed*) comporte : un **titre** verbal orienté but (« Retirer de l'argent »), l'**acteur principal** et son but, les **parties prenantes et leurs intérêts**, le **niveau de but**, la **portée** (quel système est la boîte noire), les **préconditions**, les **garanties minimales** et la **garantie de succès** (postconditions), le **scénario nominal** numéroté, les **extensions** (déroulés alternatifs et d'échec, numérotées en référence aux étapes du nominal), et éventuellement les variantes technologiques. Un cas d'utilisation *casual* réduit le corps à un ou deux paragraphes de prose.

**Niveaux de but**. Cockburn classe les cas d'utilisation par altitude, avec deux gradients (hauteur et couleur) :

| Niveau | Repère | Nature | Exemple générique |
|---|---|---|---|
| Très haut (résumé) | au-dessus du niveau de la mer, blanc | but stratégique couvrant plusieurs sessions | « Gérer le cycle de vie d'un dossier » |
| **But utilisateur** | **niveau de la mer, bleu** | **une session de travail, un utilisateur atteint un but en une fois** | « Ouvrir une session de travail » |
| Sous-fonction | sous le niveau de la mer, indigo | étape réutilisable, insuffisante seule | « S'authentifier » |

Le **niveau de la mer est l'altitude de référence** : c'est là que se situe l'unité utile de description. Un catalogue majoritairement composé de sous-fonctions signale une dérive vers la spécification fonctionnelle ; un catalogue majoritairement composé de résumés ne guide pas la construction.

**Boîte noire et notation du système**. Le cas d'utilisation décrit le système comme une **boîte noire** : il dit ce que le système fait de l'extérieur, jamais comment il le fait. Cette contrainte est ce qui le rend stable face aux changements d'implémentation.

**Diagramme UML**. Le diagramme de cas d'utilisation (acteurs, ellipses, relations `include`, `extend`, généralisation) est une **table des matières graphique**, pas la description elle-même. Cockburn insiste : la valeur est dans le texte des flux, pas dans le diagramme. La sur-utilisation d'`include`/`extend` est un anti-motif reconnu (décomposition fonctionnelle déguisée).

**Use-Case 2.0 (Jacobson et Spence, 2011)**. Réponse explicite à l'accusation de lourdeur. Deux notions clés : le **récit de cas d'utilisation** (*use-case narrative*) décrit les flux et se complète d'un **jeu de cas de test** ; la **tranche** (*use-case slice*) est une sélection d'un ou plusieurs flux d'un cas d'utilisation, avec ses cas de test, constituant un élément de backlog livrable indépendamment. Le cas d'utilisation reste la **carte durable** ; les tranches sont les **unités de flux**. C'est la réconciliation la plus aboutie entre structure et incrémentalité.

### 4.2 La user story et ses dérivés

**Le gabarit**. « En tant que `<rôle>`, je veux `<capacité>`, afin de `<bénéfice>` » (Cohn, 2004). Le troisième membre (le pourquoi) est le plus souvent omis en pratique et le plus souvent le seul qui compte.

**Les 3C (Jeffries, 2001)** : *Card* (la formulation courte, support tangible), *Conversation* (l'échange qui produit la compréhension partagée, cœur de la valeur), *Confirmation* (les critères d'acceptation qui closent la conversation). La thèse fondatrice est que **la carte n'est pas la spécification** : elle est un aide-mémoire pour une conversation. C'est aussi la source du principal reproche fait aux user stories : si la conversation n'est pas capturée, il ne reste rien.

**INVEST (Wake, 2003)** : une bonne story est *Independent*, *Negotiable*, *Valuable*, *Estimable*, *Small*, *Testable*. Ces critères sont des propriétés de **planification**, pas de description : ils optimisent le flux de travail, pas la compréhension du système.

**Job story (Adams et Klement, Intercom, 2013)**. Gabarit : « Quand `<situation>`, je veux `<motivation>`, afin de `<résultat attendu>` ». Issu du cadre *Jobs to Be Done* (Christensen). Le déplacement est de remplacer la **persona** (qui) par la **situation** (quand), au motif que le contexte déclencheur explique mieux le comportement que l'identité de l'utilisateur. Utile lorsque les utilisateurs sont peu segmentables ou lorsque la persona induit des suppositions non fondées.

**Épopée, feature, story, tâche**. La hiérarchie usuelle (épopée > feature > story > tâche) est une convention de **gestion de flux**, non une ontologie du besoin. Elle varie d'un cadre à l'autre (SAFe : épopée > capability > feature > story) et ne doit pas être confondue avec les niveaux de but de Cockburn, qui décrivent l'**altitude d'un but**, pas la taille d'un lot de travail.

### 4.3 Les exemples exécutables

**Given/When/Then et Gherkin**. Un scénario est exprimé en trois temps : `Given` (contexte initial), `When` (action), `Then` (résultat attendu). Le format s'est imposé comme notation dominante des critères d'acceptation ; Adzic rapporte qu'il recueillait 71 % des suffrages dans un sondage sur le format d'expression des exemples. Gherkin est le langage dédié qui rend ces scénarios exécutables via Cucumber (2008) et ses équivalents.

**Spécification par l'exemple (Adzic, 2011)**. Pratique consistant à dériver la spécification d'exemples concrets et illustratifs plutôt que de règles abstraites, puis à automatiser ces exemples pour qu'ils deviennent une **documentation vivante** : un document qui ne peut pas mentir, puisqu'il échoue quand le système diverge. C'est la réponse la plus directe au problème de péremption documentaire.

**ATDD / BDD**. L'*Acceptance Test-Driven Development* place l'écriture collaborative des tests d'acceptation **avant** l'implémentation, avec trois rôles au minimum (métier, développement, test) : c'est la pratique des « trois amigos ». Le BDD généralise en imposant un vocabulaire de comportement plutôt que de test.

**Limite reconnue**. Le format Given/When/Then dégénère facilement en script d'interface utilisateur (« Given je clique sur le bouton bleu ») : il décrit alors l'implémentation et perd toute stabilité. La discipline consiste à rester au niveau du comportement observable et du vocabulaire du domaine.

### 4.4 Le requis en langage contraint

**EARS (Mavin et al., Rolls-Royce, RE'09, 2009)**. Réponse à l'ambiguïté du langage naturel sans passer au formalisme mathématique. Structure générale : `WHILE <précondition>, WHEN <déclencheur>, the <système> SHALL <réponse>`. Cinq motifs :

| Motif | Forme | Usage |
|---|---|---|
| Ubiquitous | `The <système> shall <réponse>` | propriété toujours vraie |
| Event-driven | `When <déclencheur>, the <système> shall <réponse>` | réaction à un événement |
| State-driven | `While <état>, the <système> shall <réponse>` | comportement conditionné par un état |
| Optional feature | `Where <fonction incluse>, the <système> shall <réponse>` | comportement d'une variante |
| Unwanted behaviour | `If <condition indésirable>, then the <système> shall <réponse>` | erreurs, pannes, cas dégradés |

EARS est complémentaire, non concurrent, des cas d'utilisation : un cas d'utilisation décrit **un parcours**, un requis EARS décrit **une obligation ponctuelle**. Le motif *unwanted behaviour* est particulièrement utile pour rendre systématique la description des cas d'erreur, souvent négligés.

**Le cadre normatif (ISO/IEC/IEEE 29148:2018)**. La norme définit l'ingénierie des exigences comme la fonction interdisciplinaire qui découvre, élicite, développe, analyse, vérifie, valide, communique, documente et gère les exigences. Elle structure les processus en analyse métier, définition des besoins et exigences des parties prenantes, définition des exigences système et logicielles, et gestion des exigences. Elle prévoit trois documents : **StRS** (Stakeholder Requirements Specification, le besoin dans le langage des parties prenantes), **SyRS** (System Requirements Specification) et **SRS** (Software Requirements Specification). Le point important pour le présent sujet : la norme reconnaît explicitement les **gabarits de cas d'utilisation** comme pratique recommandée pour capturer le contexte des exigences fonctionnelles, et elle situe le besoin des parties prenantes **en amont** des exigences système. Le raffinement du besoin abstrait vers l'exigence implémentable est traité en détail dans `FND-015`.

### 4.5 Les méthodes de découverte et de cadrage

Ces méthodes ne produisent pas la description finale du besoin ; elles **alimentent** les formes ci-dessus.

- **Entretien, observation contextuelle, atelier**. Techniques d'élicitation de base. L'observation (*contextual inquiry*) corrige le biais déclaratif de l'entretien : ce que les gens disent faire diffère de ce qu'ils font.
- **Persona**. Archétype d'utilisateur documenté (objectifs, contexte, contraintes, compétences). Utile pour donner un nom aux acteurs ; risqué lorsqu'elle est fondée sur des suppositions plutôt que sur des données (d'où l'alternative job story, section 4.2).
- **Impact mapping (Adzic, 2012)**. Carte mentale à quatre niveaux : **Pourquoi** (l'objectif mesurable), **Qui** (les acteurs qui peuvent influer sur cet objectif), **Comment** (les changements de comportement recherchés chez ces acteurs, les *impacts*), **Quoi** (les livrables qui pourraient produire ces impacts). Sa vertu principale est de rendre explicite que **le livrable est une hypothèse** au service d'un impact, et non une fin. Adzic attribue l'invention de la technique à Ingrid Domingues et ses collègues.
- **Story mapping (Patton, 2014)**. Carte à deux dimensions : l'axe horizontal (la *backbone*) est le récit du parcours utilisateur, activité par activité, dans l'ordre chronologique ; l'axe vertical, sous chaque activité, empile les fonctionnalités possibles par ordre de nécessité décroissante. Une **tranche horizontale** définit une version ; la plus fine, le *walking skeleton*, est le plus petit parcours de bout en bout qui permet réellement à un utilisateur d'accomplir le parcours. Le story mapping répond directement au défaut du backlog plat : une liste ordonnée perd la structure du parcours.
- **Event storming (Brandolini)**. Atelier de découverte du domaine par les événements métier, à l'interface du recueil du besoin et de la conception pilotée par le domaine.

## 5. Comparaison structurée

| Forme | Unité décrite | Auteur / destinataire | Durée de vie visée | Vérifiabilité directe | Force principale | Faiblesse principale |
|---|---|---|---|---|---|---|
| Cas d'utilisation (Cockburn) | un but d'acteur, tous ses déroulés | analyste / équipe et parties prenantes | durable (documente le système) | indirecte (via cas de test) | complétude des cas d'erreur, vue d'ensemble | lourd si appliqué uniformément |
| Use-case slice (UC 2.0) | un ou plusieurs flux d'un cas d'utilisation | équipe / équipe | durable (rattachée au cas) | oui (tests attachés) | concilie structure et flux | notoriété faible, outillage rare |
| User story | un incrément de valeur négociable | équipe / équipe | éphémère (jeton de conversation) | via critères d'acceptation | flux de travail, négociabilité | ne documente pas le système ; perte de la vue d'ensemble |
| Job story | une situation déclenchante et son issue | produit / équipe | éphémère | via critères d'acceptation | évite les suppositions sur l'identité | pas de structure de parcours |
| Scénario Gherkin | un exemple concret vérifiable | trois amigos / machine et humains | durable tant qu'exécuté | **directe** | documentation vivante non périssable | dérive vers le script d'interface |
| Requis EARS | une obligation ponctuelle | ingénierie / vérification | durable | oui | absence d'ambiguïté, cas dégradés | ne raconte aucun parcours |
| Impact map | une hypothèse de livrable au service d'un impact | produit et direction / décision | jusqu'à validation de l'hypothèse | non (l'impact se mesure) | relie livrable et finalité | pas une description de comportement |
| Story map | la structure d'un parcours complet | équipe entière / planification | durable (structure) | non | découpage en versions cohérentes | outil d'atelier, se dégrade en liste |

Lecture recommandée de ce tableau : les colonnes « durée de vie » et « vérifiabilité » séparent le champ en deux familles. La famille **durable et vérifiable** (cas d'utilisation avec tests, scénarios exécutables, requis EARS) constitue la mémoire du système. La famille **éphémère** (user stories, job stories) constitue son flux de travail. Confondre les deux, c'est soit alourdir le flux, soit perdre la mémoire.

## 6. Le débat cas d'utilisation contre user story

Débat structurant du champ depuis vingt ans. Les positions, en restant factuel :

**Ce que reprochent les tenants des user stories aux cas d'utilisation** : coût de rédaction élevé, tendance à figer le besoin avant conversation, illusion de complétude, documents peu lus, incompatibilité avec un découpage incrémental fin.

**Ce que reprochent les tenants des cas d'utilisation aux user stories** : perte de la vue d'ensemble (« le backlog plat »), abandon systématique des flux alternatifs et des cas d'erreur (une story décrit le chemin heureux), disparition de la trace lorsque la conversation n'est pas capturée, et confusion entre unité de planification et unité de compréhension.

**Point de convergence factuel** : les deux camps s'accordent sur trois points. (a) L'unité utile de description est le **but d'un acteur**, pas la fonction du système. (b) La description n'est complète qu'avec ses **critères d'acceptation vérifiables**. (c) La conversation vaut plus que le document, mais un système durable a besoin d'une trace. Use-Case 2.0 est la tentative explicite de tenir les trois simultanément.

**Appréciation** (signalée comme telle) : pour un système dont les utilisateurs sont peu nombreux et dont la valeur tient à la fiabilité de comportements précis (outils, infrastructures, CLI, systèmes internes), la famille cas d'utilisation est mieux adaptée, parce que la valeur y réside précisément dans les flux alternatifs et les cas d'erreur que la user story omet par construction. Pour un produit de masse en découverte de marché, la famille story et job story est mieux adaptée, parce que l'incertitude porte sur le besoin lui-même et non sur son exécution.

## 7. Place du besoin dans les méthodologies de développement

| Méthodologie | Forme dominante du besoin | Moment de la capture | Statut du document |
|---|---|---|---|
| Cascade, cycle en V | exigences numérotées (SRS) | intégralement en amont, contractualisé | contractuel, gelé, base de la recette |
| Processus unifié (RUP) | cas d'utilisation | itératif, dirigé par les cas d'utilisation | durable, pilote l'architecture et les tests |
| Extreme Programming | story sur carte + test d'acceptation | juste à temps, conversation | éphémère ; le test est la trace |
| Scrum | élément de backlog (souvent user story) | continu, affinage du backlog | le backlog produit est l'unique source ordonnée |
| Kanban | élément de travail, flux tiré | continu | secondaire ; la valeur est dans le flux |
| Lean / découverte continue | hypothèse mesurable | continu, avec expérimentation | l'hypothèse remplace la certitude |
| SAFe et cadres à l'échelle | hiérarchie épopée / capability / feature / story | par cadence de planification | formalisé, avec critères d'acceptation par niveau |
| BDD / spécification par l'exemple | exemples exécutables | avant implémentation, collaboratif | documentation vivante, exécutée en continu |
| Spec-driven development (avec agents IA) | spécification structurée en amont | avant génération de code | source dont dérive l'implémentation |

Trois observations transverses.

**7.1 Le cycle en V n'a pas disparu, il s'est déplacé.** Sa contribution durable est la **symétrie besoin / vérification** : à chaque niveau de description correspond un niveau de test (exigences système contre tests système, spécification contre tests d'intégration, conception contre tests unitaires). Cette symétrie reste valable quelle que soit la méthodologie ; l'agilité en change la granularité et la fréquence, pas le principe.

**7.2 Scrum ne prescrit aucune forme de besoin.** Le Guide Scrum (édition 2020) parle d'« éléments du Backlog Produit » et non de user stories ; il n'impose ni gabarit ni notation. L'assimilation « Scrum implique user stories » est une convention de pratique, pas une prescription. Il définit en revanche l'**engagement** de chaque artefact (l'objectif produit pour le backlog produit, l'objectif de sprint pour le backlog de sprint, la **définition de terminé** pour l'incrément).

**7.3 Le développement dirigé par la spécification revient avec les agents IA.** Depuis 2025, une génération d'outillage (dont `spec-kit` de GitHub, structurant le travail en phases *specify*, *plan*, *tasks*, *implement*, compatible avec plusieurs agents de codage) remet la spécification écrite au centre, non plus comme contrat avec un client mais comme **entrée de génération**. Le renversement conceptuel affiché est que le code sert la spécification, la spécification n'étant plus un guide d'implémentation mais la source dont l'implémentation dérive. Cette évolution donne une raison nouvelle et pratique de soigner la description du besoin : ce qui n'est pas écrit ne peut pas être généré, ni vérifié, ni régénéré après refonte. Elle réactive aussi l'intérêt des formes **structurées et vérifiables** (cas d'utilisation avec flux nominal et alternatifs, requis EARS, scénarios exécutables) sur les formes conversationnelles, puisque l'agent ne participe pas à la conversation d'équipe qui donnait leur sens aux cartes.

## 8. Gestion de backlog, de produit et de fonctionnalités

**8.1 Backlog.** Le backlog est une **liste ordonnée** (pas seulement priorisée) de tout ce qui pourrait être fait. Ses propriétés de qualité usuelles sont résumées par l'acronyme DEEP : *Detailed appropriately* (détaillé en proportion inverse de son éloignement), *Estimated*, *Emergent*, *Prioritized*. L'**affinage** (*refinement*) est l'activité continue de découpage, clarification et estimation. Deux garde-fous conventionnels encadrent le flux : la **définition de prêt** (conditions pour entrer en réalisation) et la **définition de terminé** (conditions pour être livrable).

**8.2 Priorisation.** Aucune méthode ne fait autorité ; les plus employées :

| Méthode | Principe | Adapté à |
|---|---|---|
| MoSCoW | Must / Should / Could / Won't have | négociation de périmètre à date fixe |
| Kano | classe les fonctions en basiques, proportionnelles, attractives | arbitrage satisfaction contre effort |
| RICE | Reach x Impact x Confidence / Effort | comparaison quantifiée de candidats |
| WSJF (SAFe) | coût du retard divisé par la taille du lot | maximisation du débit économique |
| Coût du retard | valeur perdue par unité de temps d'attente | décision de séquencement |

Point commun : toutes exigent que l'élément priorisé porte une **valeur attribuable à quelqu'un**. Un backlog d'éléments techniques sans bénéficiaire identifié est impriorisable, ce qui est un argument fonctionnel (et non esthétique) en faveur d'une description du besoin par acteur et par but.

**8.3 Gestion de produit et cycle de vie de la fonctionnalité.** La pratique contemporaine remplace la feuille de route par fonctionnalités datées par une **feuille de route par résultats** (*outcome-based roadmap*), pour la même raison que l'impact mapping : la fonctionnalité est une hypothèse. Le cycle de vie d'une fonctionnalité comprend typiquement : découverte, cadrage (le besoin décrit), construction, livraison progressive (déploiement partiel, bascule par drapeau), mesure d'adoption, puis **retrait**. Le retrait est l'étape systématiquement absente des méthodes de recueil du besoin : très peu de gabarits prévoient la fin de vie d'une fonctionnalité, alors qu'une description de besoin devrait dire à quelle condition elle cesse d'être valide.

**8.4 Traçabilité.** La chaîne de traçabilité canonique relie : partie prenante, besoin, exigence, spécification, élément de conception, code, test, preuve. La norme 29148 en fait une exigence de gestion des exigences. Deux mesures dérivées sont couramment employées : la **couverture avant** (chaque besoin conduit-il à au moins un test ?) et la **couverture arrière** (chaque test se rattache-t-il à un besoin ?). Un test sans besoin rattaché signale soit un besoin implicite non documenté, soit un test sans valeur ; un besoin sans test signale une capacité non vérifiée.

**8.5 Tests d'acceptation et niveau d'exécution.** La pyramide des tests place les tests d'acceptation de bout en bout au sommet (peu nombreux, lents, fidèles à l'usage réel). Pour les systèmes en ligne de commande, ce niveau est particulièrement peu coûteux : le contrat observable est trivialement scriptable (arguments, sortie standard, sortie d'erreur, code de retour, effets sur le système de fichiers). L'outillage établi comprend `bats-core` (cadre de test conforme TAP pour Bash, utilisable pour tester n'importe quel programme Unix) et `shellspec` (cadre BDD pour shells POSIX, avec couverture, simulacres et exécution parallèle). La technique de l'**approbation** (*golden file* : comparer la sortie complète à une sortie de référence versionnée) est adaptée à la vérification des sorties d'aide et de documentation, qui sont volumineuses et doivent rester stables.

**8.6 Outillage documentaire.** Trois familles : les gestionnaires d'exigences (traçabilité formelle, matrices, baselines) ; les gestionnaires de backlog (flux, itérations) ; et le **besoin versionné avec le code** (fichiers texte dans le dépôt, dits *docs as code*). La troisième famille est la seule qui garantisse que la description du besoin et l'implémentation évoluent dans le même commit, donc la seule qui rende la divergence détectable mécaniquement. C'est aussi la seule directement exploitable par un agent lisant le dépôt.

## 9. Bonnes pratiques et anti-motifs

**Bonnes pratiques établies** :

1. Nommer les cas par un **verbe à l'infinitif orienté but** de l'acteur, jamais par une fonction technique.
2. Tenir un **catalogue d'acteurs** distinct du catalogue de cas ; un acteur est un rôle, plusieurs personnes peuvent le jouer et une personne peut jouer plusieurs rôles.
3. Décrire systématiquement les **flux alternatifs et d'échec** ; c'est là que se trouve l'essentiel de la valeur d'une description, et c'est ce que les gabarits courts omettent.
4. Attacher à chaque description ses **critères d'acceptation vérifiables**, de préférence exécutables.
5. Maintenir la **traçabilité bidirectionnelle** besoin vers test.
6. **Détailler en proportion inverse de l'éloignement** : rédaction complète pour ce qui est imminent, titre seul pour le reste.
7. Écrire le besoin **au niveau de la boîte noire** : ce qui est observable de l'extérieur, jamais l'implémentation.
8. Faire relire la description par quelqu'un qui **joue l'acteur**, pas seulement par l'équipe de construction.

**Anti-motifs récurrents** :

| Anti-motif | Description | Conséquence |
|---|---|---|
| Décomposition fonctionnelle déguisée | des cas d'utilisation qui décrivent des fonctions internes (« Valider le champ ») | catalogue illisible, couplé à l'implémentation |
| Chemin heureux seul | aucun flux d'erreur décrit | les défauts apparaissent en production |
| Backlog plat | liste ordonnée sans structure de parcours | impossible de savoir si un parcours est complet |
| Story orpheline | pas de bénéficiaire ni de pourquoi | impriorisable, souvent inutile |
| Gabarit rituel | le format « en tant que » appliqué à des tâches techniques | bruit, perte de crédibilité du format |
| Documentation périmée | description non exécutée, divergente du système | pire que pas de documentation (elle induit en erreur) |
| Critères d'interface | Given/When/Then décrivant des clics | tests fragiles, description non stable |
| Traçabilité à sens unique | des tests sans besoin rattaché | impossible de mesurer la couverture fonctionnelle |
| Cas d'utilisation gelé | catalogue rédigé une fois, jamais révisé | retour au défaut de la cascade |

## 10. Application transposable

Points directement réutilisables par un système d'information qui veut se doter d'une description explicite de ses usages :

1. **Une ressource de description d'usage doit être durable et versionnée**, distincte du flux de travail (le plan, le ticket, la tâche) qui, lui, est éphémère. Confondre les deux est le défaut le plus répandu.
2. **L'unité pertinente est le but d'un acteur au niveau de la mer** ; c'est le seul niveau qui soit à la fois complet du point de vue de l'utilisateur et suffisamment fin pour être vérifié.
3. **Un catalogue d'acteurs est un prérequis** : sans typologie explicite des acteurs et des parties prenantes, la description des usages n'a pas d'ancrage et dérive vers la fonction.
4. **La description doit contenir ses cas d'échec** ; pour un outil, c'est même l'essentiel de sa valeur documentaire.
5. **Le lien vers la vérification doit être matérialisé**, idéalement en rendant les critères exécutables ; à défaut, par une référence explicite du cas vers son ou ses tests.
6. **La description du besoin se place en amont de l'exigence** (StRS avant SyRS dans le vocabulaire de la norme), et non en concurrence avec elle : le cas d'usage dit *qui veut quoi et pourquoi*, l'exigence dit *ce que le système doit garantir*, la spécification dit *comment cela se présente à l'interface*.
7. **Pour un système en ligne de commande, le test d'acceptation est peu coûteux** : le contrat observable (arguments, sorties, code de retour, effets sur les fichiers) est directement scriptable, ce qui rend réaliste l'objectif d'un test d'acceptation par cas d'usage.

## 11. Synthèse

- Le champ s'est construit par **couches successives** répondant chacune au défaut de la précédente : exigences exhaustives, puis cas d'utilisation orientés but, puis user stories orientées flux, puis exemples exécutables et découverte continue. Ces couches se **complètent** plus qu'elles ne se remplacent.
- Trois axes discriminent les formes : **unité décrite**, **durée de vie**, **destinataire**. Le choix raisonné consiste à retenir une forme durable orientée but (la mémoire des usages), une forme incrémentale (le flux de travail) et une forme exécutable (la vérification), et à ne pas leur demander le travail des autres.
- Le **cas d'utilisation de niveau « but utilisateur »**, avec acteur, préconditions, garanties, flux nominal et flux alternatifs, reste la forme la plus complète pour documenter durablement ce qu'un système fait pour quelqu'un. Use-Case 2.0 en fournit la version compatible avec un flux incrémental (les tranches).
- La **user story n'est pas une description**, c'est une promesse de conversation et une unité de planification. L'employer comme documentation durable produit systématiquement la perte des flux d'erreur et de la vue d'ensemble.
- La **traçabilité besoin vers test** est le critère de maturité décisif : un système qui ne peut pas dire quel test démontre quel usage ne peut pas démontrer qu'il sert quelqu'un.
- Le retour du **développement dirigé par la spécification** avec les agents IA renforce l'intérêt des formes structurées et vérifiables : l'agent ne participe pas à la conversation qui donnait leur sens aux formes conversationnelles, il ne lit que ce qui est écrit.

## 12. Limites

- **Non couvert** : les techniques d'estimation et de dimensionnement (points de story, points de cas d'utilisation) ; la modélisation formelle du besoin (méthodes B, TLA+, Alloy) ; la conception pilotée par le domaine au-delà de la mention d'event storming ; l'accessibilité et la conception centrée utilisateur au sens des normes ergonomiques (ISO 9241) ; la gestion de portefeuille et la gouvernance multi-équipes.
- **Faiblesse de la base empirique** : l'essentiel de la littérature du champ est praticienne. Les comparaisons d'efficacité entre notations relèvent de l'expérience rapportée, pas de l'étude contrôlée. Les jugements comparatifs de ce document sont signalés comme des appréciations.
- **Péremption différenciée** : les sections 3, 4, 5, 6 et 9 portent sur des acquis stables (dix à trente ans) et vieillissent lentement. La section 7.3 et la section 8.6 portent sur un outillage en mouvement rapide et sont à revalider dans les douze mois. Les données chiffrées d'adoption d'outils citées dans les sources sont datées de mi-2026.

## 13. Sources

**Cas d'utilisation**

- Jacobson, I. et al., *Object-Oriented Software Engineering: A Use Case Driven Approach*, Addison-Wesley, 1992 (introduction du concept).
- Cockburn, A., *Writing Effective Use Cases*, Addison-Wesley, 2001. Brouillon de l'auteur disponible : https://kurzy.kpi.fei.tuke.sk/zsi/resources/CockburnBookDraft.pdf ; https://www.informit.com/store/writing-effective-use-cases-9780201702255
- Jacobson, I., Spence, I., Bittner, K., *Use-Case 2.0: The Guide to Succeeding with Use Cases*, Ivar Jacobson International, 2011. https://www.ivarjacobson.com/publications/white-papers/use-case-20-e-book ; https://www.ivarjacobson.com/files/use-case_2.0_the_hub.pdf
- Jacobson, I., Spence, I., Kerr, B., « Use-Case 2.0 », *ACM Queue* / *Communications of the ACM*, 2016. https://queue.acm.org/detail.cfm?id=2912151

**User stories et dérivés**

- Jeffries, R., « Essential XP: Card, Conversation, Confirmation », 2001 (les 3C).
- Wake, B., « INVEST in Good Stories, and SMART Tasks », XP123, 2003. https://xp123.com/invest-in-good-stories-and-smart-tasks/
- Cohn, M., *User Stories Applied*, Addison-Wesley, 2004. Voir aussi https://www.mountaingoatsoftware.com/blog/job-stories-offer-a-viable-alternative-to-user-stories
- Klement, A., Adams, P., « Designing features using job stories », Intercom, 2013. https://www.intercom.com/blog/using-job-stories-design-features-ui-ux/ ; https://www.intercom.com/blog/accidentally-invented-job-stories/
- « INVEST (mnemonic) », Wikipedia. https://en.wikipedia.org/wiki/INVEST_(mnemonic)

**Exemples exécutables**

- Adzic, G., *Specification by Example: How Successful Teams Deliver the Right Software*, Manning, 2011.
- Cucumber, « Gherkin Rules ». https://cucumber.io/blog/bdd/gherkin-rules/
- Synthèse sur la spécification par l'exemple : https://grokipedia.com/page/Specification_by_example

**Requis en langage contraint et normes**

- Mavin, A., Wilkinson, P., Harwood, A., Novak, M., « Easy Approach to Requirements Syntax (EARS) », IEEE RE'09, 2009. https://alistairmavin.com/ears/ ; https://ccy05327.github.io/SDD/08-PDF/Easy%20Approach%20to%20Requirements%20Syntax%20(EARS).pdf
- « Easy Approach to Requirements Syntax », Wikipedia. https://en.wikipedia.org/wiki/Easy_Approach_to_Requirements_Syntax
- ISO/IEC/IEEE 29148:2018, *Systems and software engineering - Life cycle processes - Requirements engineering*. https://standards.iteh.ai/catalog/standards/iso/8cf2bc2b-8b5e-4907-a82a-d1c5676c9e85/iso-iec-ieee-29148-2018 ; gabarits StRS/SyRS/SRS : https://www.reqview.com/doc/iso-iec-ieee-29148-templates/

**Découverte et cadrage**

- Adzic, G., *Impact Mapping: Making a Big Impact with Software Products and Projects*, Provoking Thoughts, 2012. https://www.impactmapping.org/book.html ; https://gojko.net/books/impact-mapping/
- Patton, J., *User Story Mapping: Discover the Whole Story, Build the Right Product*, O'Reilly, 2014. https://www.avion.io/what-is-user-story-mapping/

**Méthodologies, backlog et outillage**

- Schwaber, K., Sutherland, J., *The Scrum Guide*, édition 2020 (éléments de backlog, engagements, définition de terminé).
- GitHub, « Spec-driven development with AI: Get started with a new open source toolkit », GitHub Blog, 2025. https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/ ; https://developer.microsoft.com/blog/spec-driven-development-spec-kit/
- `bats-core`, cadre de test conforme TAP pour Bash. https://github.com/bats-core/bats-core ; https://bats-core.readthedocs.io/
- `shellspec`, cadre BDD pour shells POSIX. https://github.com/shellspec/shellspec ; https://shellspec.info/comparison.html

**Ressources internes connexes**

- `FND-015-requis-et-specification` : distinction requis / spécification, taxonomie et niveaux d'abstraction.
- `FND-002-ingenierie-livrables-qualite` : caractéristiques de qualité documentaire, ontologie des livrables.
- `FND-009-architecture-systemes-complexes` : modèle 4+1 (les scénarios comme vue reliant les autres), ISO/IEC/IEEE 42010 (parties prenantes et préoccupations).
- `FND-007-conventions-cli` : conventions d'interface en ligne de commande.
