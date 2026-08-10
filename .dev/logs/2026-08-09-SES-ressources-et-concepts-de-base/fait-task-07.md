# Ce qui a été fait, tâche 7

## Livrables produits

| Fichier | Lignes | Contenu |
|---|---|---|
| `.dev/fondations/FND-002-identifiants-dans-les-systemes-decentralises.md` | 267 | Revue de littérature en 7 étapes, 31 sources, 8 questions, 14 domaines, 14 axes |
| `.dev/analyses/ANL-003-systeme-d-identifiants-de-clia.md` | 251 | Position de `clia` sur 14 axes, 10 suggestions ordonnées, 5 refus motivés |
| `.dev/objections/NON-014-choix-du-trilemme-de-nommage.md` | 112 | 7 questions, effet `bloquant` |

Trois objections existantes complétées : `NON-001` par 5 questions et 2 preuves empiriques, `NON-012` par 3 questions, `NON-006` par 2 questions. Le dépôt porte désormais 14 objections et 101 questions.

## FND-002, ce que la revue établit

Les sept étapes de la méthodologie imposée sont traitées et nommées : questions de recherche, inventaire sémantique et ontologique, domaines et cadres, axes d'analyse, revue historique, analyse critique, réponses.

**Huit questions de recherche** dérivées de l'intention posée, chacune recevant une réponse à l'étape 7.

**Quatorze domaines mobilisés**, dont les sept suggérés par la demande et sept ajoutés parce que leur ontologie recoupe les questions : théorie du nommage en systèmes distribués, bibliothéconomie, identifiants pérennes de la recherche, science ouverte et FAIR, citation de données et de logiciels, réplication et édition collaborative, espaces de noms de gestion de paquets, identifiants générés localement, provenance et versionnage.

**Quatorze axes d'analyse**, plus un identifié comme absent de la littérature : l'ergonomie de saisie.

**Cinq propositions**, chacune sourcée.

| Proposition | Contenu |
|---|---|
| 1 | Le trilemme de Zooko tient pour un petit système : lisible, unique globalement, sans autorité, il faut en abandonner un |
| 2 | Un système d'identifiants viable est une famille, et les familles qui marchent combinent un noyau intrinsèque et des qualificateurs extrinsèques |
| 3 | Un identifiant doit déclarer le niveau FRBR auquel il s'applique, faute de quoi oeuvre et version se confondent |
| 4 | La persistance est un engagement, pas une propriété technique, sauf pour l'identifiant intrinsèque |
| 5 | La traversée de la frontière interne vers externe se fait par extension du noyau, jamais par remplacement |

**Trois apports que je n'avais pas avant la recherche.** Le trilemme comme cadre exact de la première exigence de la demande. La complémentarité de l'intrinsèque et de l'extrinsèque, qui rend inutile la recherche de l'identifiant parfait. Et le mécanisme d'extension du noyau, attesté par deux systèmes qui ne l'avaient pas conçu pour cette question.

## Régime de citation

Trente-et-une sources distinctes, chacune liée. Hiérarchie de crédibilité déclarée en tête, et chaque écart signalé à l'endroit où il se produit.

Sources primaires : RFC 3986, RFC 9562, recommandations et communiqués du W3C sur les DID, documentation de Software Heritage, documents de l'IFLA et de la Bibliothèque du Congrès sur FRBR, déclarations de FORCE11, documentation de Kubernetes, dépôt Yjs.

Sources secondaires signalées comme telles : la description du CID, la pratique du semver dans les API, la synthèse comparative des espaces de noms, et surtout la réfutation présumée du trilemme de Zooko, qui repose sur une encyclopédie collaborative et fait l'objet d'une réserve méthodologique explicite.

Neuf recherches menées, quatre sources vérifiées par consultation directe. Deux de ces vérifications ont apporté ce que les résultats de recherche ne donnaient pas : la syntaxe exacte du SWHID avec ses cinq types d'objets et ses qualificateurs, et le statut réel de la conjecture de Zooko.

## ANL-003, la position de clia

| Verdict | Axes |
|---|---|
| **Juste** | Assignation, autorité, lisibilité, stabilité, résolvabilité, coût de gouvernance, longévité, ergonomie |
| **Indéterminé** | Traversée de frontière, dérivation, concurrence |
| **Faux** | Portée d'unicité, granularité, vérifiabilité |

Les trois positions fausses sont exactement celles qui empêchent la réutilisation hors du dépôt.

**Dix suggestions**, ordonnées par rapport entre effet et coût. Les cinq premières ne demandent aucun code et règlent trois questions ouvertes.

| Rang | Suggestion | Coût |
|---|---|---|
| 1 | S1, nommer les deux registres : adresse `<PREFIXE>-<SEQ>`, identité `<PREFIXE>-<SLUG>` | nul |
| 2 | S2, déclarer que l'`id` désigne une oeuvre au sens FRBR | une section |
| 3 | S7, séparer la correction de slug du changement d'identité | un champ facultatif |
| 4 | S8, écrire l'ergonomie comme exigence opposable | trois lignes |
| 5 | S9, traiter le bundle comme une ressource à index | huit modifications |
| 6 à 10 | S5 attribution du numéro, S6 dérivation par relation, S4 empreinte calculable, S3 portée de dépôt, S10 suspendre le reste | déjà fait, ou différé |

**Cinq refus motivés** : un identifiant décentralisé au sens du W3C, une chaîne de blocs pour le nommage, un UUID comme identité principale, un identifiant adressé par contenu comme identité principale, et l'encodage du type, de la version et de la filiation dans une seule chaîne.

## NON-014, le choix non fait

`clia` a retenu la lisibilité et l'absence d'autorité, donc abandonné l'unicité globale. Ce choix n'a jamais été écrit, et le corpus en paie déjà le prix : `ANL-001` mesure douze numéros de skill sur vingt portant plusieurs noms selon le dépôt.

L'objection est `bloquant` parce que les dix suggestions ne peuvent pas être arbitrées sans savoir quelle propriété le système accepte de perdre.

Sa question Q4 reprend `NON-004` Q7 sur l'`INTENTION.md` avec un argument nouveau : là où `NON-004` invoquait une mesure du corpus, `NON-014` invoque une contrainte théorique. La réutilisation par une autre personne exige une résolution indépendante de l'émetteur ; la réutilisation dans un autre projet exige une portée qui dépasse le projet. Aucune n'est disponible.

## Une prédiction vérifiée en moins de vingt-quatre heures

La question Q7 de `NON-001`, posée le 2026-08-09, annonçait que l'attribution du numéro par observation du répertoire produirait des collisions dès que deux travaux avanceraient en parallèle.

Le cas s'est produit pendant cette tâche. L'humain avait créé la veille, avec `clia res new`, une objection `NON-013-ce-qu-est-une-ressource.md`, non commitée. `clia` a attribué le même numéro à l'objection de l'agent.

| Constat | Détail |
|---|---|
| L'outil n'a pas échoué | `clia res new` a pris le maximum plus un, correctement |
| Le défaut est de conception | Le numéro s'obtient par observation d'un état, et un état observé deux fois donne deux résultats |
| La résolution a suivi le régime d'édition | L'objection de l'humain est conservée, il en est l'initiateur. Celle de l'agent est renumérotée en `NON-014` |
| L'incident renforce Q1 plus que Q7 | Une identité par slug n'aurait pas collisionné : les deux objections portent sur des sujets distincts |

Consigné comme deuxième preuve empirique dans le journal de `NON-001`. Aucune modification n'a été apportée au fichier de l'humain.

## Ce que la tâche confirme aussi

L'outil livré à la tâche 6 a été employé par l'humain le jour même, et le fichier qu'il a produit porte exactement le squelette que `clia res new` génère. C'est la première utilisation du CLI par quelqu'un d'autre que son auteur.

## Ce qui n'a pas été fait

Aucune décision, aucun ADR. La demande demande une recherche, une analyse et des objections.

Aucune modification de `RES-001` ni de `ADR-001`, que les cinq premières suggestions visent précisément. Les écrire maintenant aurait tranché à la place de l'humain.

Aucune modification du `NON-013` de l'humain, y compris pour le rédiger.

Cinq domaines identifiés comme pertinents et non explorés : l'identité auto-souveraine au-delà des DID, les identifiants auto-certifiants de type KERI, la gouvernance des méthodes DID, les identifiants de Wikidata, le droit des oeuvres dérivées. Ils sont nommés dans les limites de `FND-002`.
