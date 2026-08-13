---
type: methodologie
id: MET-001
title: "Conduite d'une recherche de fondation"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domaine: "production de savoir sourcé, en vue d'une décision"
---

# MET-001 - Conduite d'une recherche de fondation

> Comment produire une recherche de fondation qui tienne le niveau d'une revue de littérature universitaire. Ce document naît d'un échec constaté : `FND-002` a suivi une méthodologie explicite et n'est ni assez exhaustif, ni assez rigoureux dans ses citations.

## Objet

Cette méthodologie fixe le procédé, l'entrée requise et le résultat attendu d'une recherche de fondation.

Elle est demandée par la tâche 11 de la session du 2026-08-09, dont l'énoncé porte deux constats que ce document prend pour point de départ.

## Le constat qui fonde cette méthodologie

L'humain formule la critique en trois points, et les trois sont fondés.

**Le prompt de la tâche 7 est la version la plus aboutie.** Il impose sept étapes, une référence après chaque affirmation, la préférence des sources à haute crédibilité, et l'identification de tous les domaines dont l'ontologie recoupe les questions. Cette méthodologie le reprend intégralement, section « Le procédé ».

**`FND-002` n'est pas assez long ni exhaustif.** Deux cent soixante-sept lignes pour huit questions de recherche et quatorze domaines, soit environ trente lignes par question. Une revue de littérature universitaire y consacre plusieurs pages. Le document survole là où il devrait établir.

**Les citations ne sont pas au niveau attendu.** `FND-002` cite par lien markdown avec un libellé court, du type `([W3C, 2022] suivi du lien)`. Ce n'est pas une référence : il manque l'auteur exact, le titre complet, le lieu de publication, la pagination quand elle existe, l'identifiant pérenne quand il existe, et la date de consultation. Trente-deux sources pour huit questions est en outre insuffisant.

## Ce que la méthodologie retient de ANL-001

`ANL-001` documente cinquante-deux fondations dans le corpus et fournit trois enseignements qui contraignent le procédé.

**Le format long est le seul disponible, et il est trop lourd pour le besoin courant.** Onze dépôts de technotes sont morts, dont six sans aucun fichier versionné, parce que le seul contenant disponible était disproportionné. Cette méthodologie ne s'applique donc qu'aux fondations, et elle exige de vérifier d'abord qu'une fondation est bien ce qu'il faut.

**Les meilleures fondations du corpus sont celles qui citent.** `noumanity-research/global-innovation-index` rassemble vingt-et-un PDF de référence et cite les définitions de l'innovation de l'OCDE. C'est le seul cas du corpus où le matériel source est rassemblé et cité proprement.

**Le corpus ne documente aucun échec.** Ni `FND-001` ni `FND-002` n'ont trouvé de source analysant ce qui a échoué dans leur domaine. Cette lacune est systématique et le procédé lui consacre une étape.

## Entrée requise

Quatre éléments, sans lesquels la recherche ne doit pas commencer.

| Élément | Pourquoi il est requis |
|---|---|
| **La décision à éclairer** | Une fondation sans décision à rendre possible est un exercice. Si personne ne sait quelle décision elle prépare, il faut le demander avant d'écrire |
| **Le sujet, borné** | Ce sur quoi la recherche porte, et ce qu'elle exclut |
| **Les domaines de savoir suggérés** | Ceux que le demandeur a en tête, qui sont un point de départ et jamais la liste complète |
| **Le niveau de rigueur attendu** | Revue de littérature universitaire, ou synthèse documentaire. Les deux n'ont ni le même coût ni le même format de citation |

## Entrée optionnelle

| Élément | Ce qu'il apporte |
|---|---|
| Une thèse à éprouver | Oriente la recherche vers la réfutation plutôt que la confirmation |
| Des sources déjà repérées | Évite de refaire un travail de repérage |
| Une méthodologie imposée | Comme les sept étapes de la tâche 7. Elle prime sur celle-ci |
| Une longueur ou un délai | Détermine ce qu'il faut sacrifier, et le document doit dire ce qui l'a été |

## Le procédé

Dix étapes. Les sept premières reprennent la méthodologie de la tâche 7 ; les trois dernières corrigent les défauts constatés.

### 1. Vérifier qu'une fondation est le bon livrable

Quatre questions, dans cet ordre. Le contenu vient-il d'autrui, avec des sources ? Si non, c'est une analyse, un concept ou une ontologie. Le sujet a-t-il une littérature ? Si non, il faut le dire et produire autre chose. La décision à éclairer est-elle nommée ? Le format long est-il proportionné, ou une note suffirait-elle ?

L'étape existe parce que `ANL-001` mesure que le format long a tué onze dépôts de savoir.

### 2. Formuler les questions de recherche

Chaque question doit être **réfutable** : on doit pouvoir imaginer ce qui y répondrait par la négative. Une question dont toute réponse est acceptable n'oriente rien.

Deux à huit questions. Au-delà, la recherche traite plusieurs sujets et doit être scindée.

### 3. Établir l'inventaire sémantique et ontologique

Fixer le vocabulaire avant de chercher. Pour chaque terme : le sens retenu, la source qui le définit, les termes voisins dont il faut le distinguer.

C'est l'étape que `FND-002` a le mieux réussie : trois distinctions ontologiques y ont structuré les huit questions, et sans elle chaque question aurait été traitée isolément.

### 4. Identifier tous les domaines de savoir

Partir des domaines suggérés, puis chercher **systématiquement** ceux dont l'ontologie recoupe les questions. Trois voies de recherche, à employer les trois.

Les domaines adjacents par l'objet : qui d'autre étudie la même chose sous un autre nom.

Les domaines adjacents par la méthode : qui emploie les mêmes outils conceptuels.

Les domaines historiquement antérieurs : qui a posé la question avant que le domaine actuel n'existe. C'est la voie la plus productive et la plus négligée : `FND-002` a trouvé dans la bibliothéconomie de 1998 une réponse meilleure que tout ce que l'informatique a produit depuis.

Pour chaque domaine, dire ce qu'il apporte à quelle question. Un domaine listé sans apport identifié n'a pas sa place.

### 5. Identifier les axes d'analyse

Un axe est une dimension indépendante sur laquelle les positions se distribuent. L'ensemble des axes doit couvrir l'espace du sujet.

Nommer aussi les axes que la **littérature ne traite pas**. `FND-002` en a trouvé un, l'ergonomie de saisie, et c'est l'apport le plus utile du document au regard de la demande qui l'avait motivé.

### 6. Faire la revue historique

Par vagues plutôt que par dates isolées. Pour chaque vague : ce qu'elle résout, ce qu'elle sacrifie, et pourquoi elle n'a pas remplacé la précédente.

L'enseignement d'une chronologie n'est pas dans une source unique mais dans la superposition. Le dire explicitement.

### 7. Faire l'analyse critique

Quatre choses, et les quatre sont obligatoires.

L'état de la connaissance par question, avec un jugement de solidité.

Les controverses ouvertes, présentées comme telles, avec la réserve méthodologique qui s'applique à chacune.

Les limites de la littérature pour la question posée.

Et, ajout de cette méthodologie : **ce que la littérature ne documente pas**, en particulier les échecs. Aucune des deux fondations de ce dépôt n'a trouvé de source analysant les échecs de son domaine, et cette lacune est systématique.

### 8. Répondre aux questions

Une réponse par question, explicite, en tête de section. Une réponse qui commence par « cela dépend » doit dire de quoi.

Séparer strictement ce qui est établi par les sources de ce qui est interprété. `FND-002` l'a fait en isolant sa section d'interprétation et en le déclarant : c'est la bonne pratique.

### 9. Vérifier les références

Étape nouvelle, absente de la méthodologie de la tâche 7.

Interroger chaque URL, non seulement la collecter. Distinguer trois cas et les traiter différemment : l'URL morte, à remplacer ; l'URL bloquée par un obstacle local, à vérifier autrement ; l'URL refusant les requêtes automatisées, à doubler d'un miroir accessible.

Consigner l'état de vérification dans le document, avec sa date.

### 10. Mesurer la densité, et dire ce qui manque

Étape nouvelle, qui répond directement à la critique de la tâche 11.

Compter les sources par question de recherche. En dessous du seuil fixé plus bas, le dire dans les limites plutôt que de laisser croire à l'exhaustivité.

## Format de citation

C'est le point sur lequel `FND-002` échoue le plus nettement. Le format ci-dessous est exigé pour une revue de littérature universitaire.

**Dans le texte**, une citation courte suffit : auteur ou organisme, année, et le renvoi vers la bibliographie.

**En bibliographie**, une référence complète, dont les éléments dépendent de la nature de la source.

| Nature | Éléments requis |
|---|---|
| Spécification normative | Organisme, numéro, titre complet, année, URL, date de consultation |
| Article de revue | Auteurs, titre, revue, volume, numéro, pages, année, DOI |
| Ouvrage | Auteurs, titre, éditeur, lieu, année, ISBN, pages citées |
| Documentation de projet | Projet, titre de la page, version, URL, date de consultation |
| Billet ou source secondaire | Auteur, titre, site, date de publication, URL, date de consultation, **et la mention explicite du caractère secondaire** |

Trois exigences supplémentaires.

**La hiérarchie de crédibilité est déclarée en tête**, et chaque écart est signalé à l'endroit où il se produit. `FND-002` le fait, et c'est ce qu'il fait de mieux.

**Une affirmation reprise d'une source secondaire est signalée comme rapportée**, jamais présentée comme établie.

**La date de consultation est obligatoire** pour toute source en ligne. `FND-002` l'a consignée globalement ; elle doit l'être par source.

## Résultat attendu

| Critère | Seuil pour une revue universitaire | Ce que `FND-002` a atteint |
|---|---|---|
| Sources distinctes | Au moins dix par question de recherche | 32 pour 8 questions, soit **4 par question** |
| Sources primaires | La moitié au moins | environ la moitié, non compté |
| Longueur | Deux à quatre pages par question | environ 30 lignes par question |
| Références complètes | Toutes | aucune : liens courts seulement |
| Date de consultation par source | Toutes | globale, non par source |
| Domaines identifiés | Tous ceux qui recoupent, avec leur apport | 14, avec apport |
| Axes d'analyse | Tous, plus ceux absents de la littérature | 14, plus 1 absent |
| Réponse par question | Explicite | oui |
| Limites écrites | Y compris ce que la littérature ignore | oui |
| État de vérification des URL | Consigné et daté | oui |

Le tableau dit ce qui manque : la densité et le format de citation. Le reste du procédé de la tâche 7 tient.

## Ce qui peut échouer

Six modes d'échec, dont quatre ont été observés dans ce dépôt.

**Survoler au lieu d'établir.** Signe : moins de cinq sources par question. Observé sur `FND-002`.

**Citer sans référencer.** Signe : des liens sans auteur ni date de consultation. Observé sur `FND-002`.

**Confirmer une thèse plutôt que la chercher.** Signe : aucune controverse dans le corps, aucune source contredisant la conclusion.

**Prendre une source secondaire pour une source primaire.** Signe : une affirmation quantitative attribuée à un tiers sans avoir consulté l'original. Observé sur `FND-002`, où le gain de contexte des agents est rapporté et signalé comme tel, ce qui est la bonne conduite mais reste une faiblesse.

**Spécifier sans jamais décider.** Signe : la fondation ne mentionne aucune décision à éclairer. Le corpus en offre un cas mort, `disruptiva-dev/comm-cli`.

**Produire un format long pour un besoin court.** Signe : la fondation aurait tenu en une note. Observé onze fois dans le corpus, où le seuil d'entrée trop haut a tué des dépôts de savoir entiers.

## Éprouvé sur

| Cas | Résultat |
|---|---|
| `FND-001`, usage des CLI | Procédé partiel, sans les sept étapes. Sourçage acceptable, densité faible |
| `FND-002`, identifiants décentralisés | Procédé complet en sept étapes. **Densité et citations insuffisantes**, ce que la tâche 11 constate |

Cette méthodologie n'a jamais été éprouvée telle quelle. Elle est dérivée d'un échec, non d'une réussite, et sa validité reste à établir sur la prochaine fondation.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `reference` [RES-011](../ressources/RES-011-fondation.md)
- `reference` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `reference` [skl-003-ressource-de-conception](../skills/skl-003-ressource-de-conception/SKILL.md)
