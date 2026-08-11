---
type: fondation
id: FND-002
title: "Identifiants dans les systèmes décentralisés : revue de la littérature"
status: draft
date: 2026-08-10
sujet: "Conception d'un système d'identifiants pour ressources partageables et réutilisables en contexte décentralisé"
methodologie: "revue de la littérature, sept étapes, chaque affirmation référencée"
generated:
  by: claude-opus-5
  at: 2026-08-10
---

# FND-002 - Identifiants dans les systèmes décentralisés : revue de la littérature

> Revue de la littérature sur la conception de systèmes d'identifiants pour des ressources partageables et réutilisables, sans autorité centrale. La thèse centrale de ce document est qu'aucun identifiant unique ne peut satisfaire les trois exigences posées, et qu'un système d'identifiants viable est une **famille d'identifiants de natures distinctes**, articulés par des relations déclarées.

## Objet et méthode

Ce document répond à la demande de la tâche 7 de la session du 2026-08-09, qui impose une méthodologie de revue de la littérature en sept étapes, une référence après chaque affirmation, et la préférence des sources à haute crédibilité.

**Régime de citation.** Chaque affirmation empruntée porte une référence entre parenthèses, avec un lien vers la source. Les affirmations sans référence sont soit des définitions posées par ce document, soit des raisonnements propres, soit des faits établis par `ANL-001` sur le corpus local.

**Hiérarchie de crédibilité appliquée.** Sont préférées, dans l'ordre : les spécifications normatives (IETF, W3C, ISO), les documentations primaires de projets de référence, les articles de revues à comité de lecture, les encyclopédies collaboratives pour les seuls faits de datation, et enfin les billets techniques quand ils sont la seule source disponible. Chaque écart à cette hiérarchie est signalé à l'endroit où il se produit.

**Vérification des références.** Les trente-deux URL citées ont été interrogées le 2026-08-10. Vingt-huit répondent normalement. Deux, sur `softwareheritage.org`, ne sont pas vérifiables depuis le poste de rédaction pour un motif de chaîne de certificats locale, et répondent correctement sans vérification TLS : elles sont valides, l'obstacle est local. Une, chez un éditeur académique, refuse les requêtes automatisées et est doublée d'un miroir accessible. Aucune URL morte n'a été trouvée.

**Limite d'ensemble.** Aucune source consultée ne traite du cas précis de `clia`, un système documentaire mono-utilisateur destiné à devenir multi-dépôts. Les transpositions sont raisonnées et signalées comme telles, à l'étape 7 et dans la section des limites.

## Étape 1 - Questions de recherche

Huit questions se dégagent de l'intention posée par la demande. Elles sont formulées de manière à être réfutables.

| Question | Formulation |
|---|---|
| **QR1** | Un identifiant peut-il être simultanément lisible par un humain, globalement unique, et attribuable sans autorité centrale ? |
| **QR2** | Faut-il un identifiant unique par ressource, ou une famille d'identifiants de natures distinctes selon le contexte d'usage ? |
| **QR3** | Qu'identifie exactement un identifiant : un contenu, une oeuvre, une version, un fichier, un emplacement ? |
| **QR4** | Comment une ressource reste-t-elle citable alors qu'elle change ? |
| **QR5** | Comment éviter les collisions de noms dans un espace décentralisé, et quel est le coût de gouvernance de chaque réponse ? |
| **QR6** | Quel type d'identifiant permet l'édition collaborative sans coordination préalable ? |
| **QR7** | Comment une oeuvre dérivée, branche ou fork, se rattache-t-elle à son origine, et l'identifiant doit-il porter ce rattachement ? |
| **QR8** | Comment un identifiant traverse-t-il la frontière entre usage interne et usage externe ? |

## Étape 2 - Inventaire sémantique et ontologique

La littérature emploie des termes voisins avec des sens distincts, et la confusion entre eux est la cause d'une part des difficultés de conception. La table ci-dessous fixe le vocabulaire de ce document.

| Terme | Sens retenu | Source ou précision |
|---|---|---|
| **Identité** | Le fait, pour une chose, d'être la même à travers ses états | Notion, non technique |
| **Identifiant** | Une chaîne qui désigne une chose. Une chose peut en avoir plusieurs | RFC 3986 emploie « identifier » en ce sens ([IETF, 2005](https://www.rfc-editor.org/rfc/rfc3986.html)) |
| **Nom** | Identifiant destiné à rester unique et persistant, indépendamment de la disponibilité de la chose | RFC 3986 rattache cette propriété à l'usage des URN ([IETF, 2005](https://datatracker.ietf.org/doc/html/rfc3986)) |
| **Localisateur** | Identifiant qui fournit en outre un moyen d'accès, en décrivant l'emplacement de la chose | Définition explicite de l'URL dans RFC 3986 ([IETF, 2005](https://www.rfc-editor.org/rfc/rfc3986.html)) |
| **Résolution** | Opération qui, d'un identifiant, obtient la chose ou ses métadonnées | Formalisée pour les DID par une spécification dédiée ([W3C](https://www.w3.org/TR/did-resolution/)) |
| **Autorité de nommage** | Entité qui alloue les identifiants dans un espace donné | RFC 3986 note que la persistance dépend du soin de l'autorité, non du schéma ([IETF, 2005](https://datatracker.ietf.org/doc/html/rfc3986)) |
| **Espace de noms** | Périmètre dans lequel un identifiant est unique | |
| **Opacité** | Propriété d'un identifiant qui ne porte aucune information exploitable sur la chose | |
| **Intrinsèque** | Identifiant calculable depuis la chose elle-même, sans tiers | Formulation de Software Heritage ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)) |
| **Extrinsèque** | Identifiant attribué par une autorité, non calculable depuis la chose | Même source, par contraste |
| **Fixité** | Information permettant de vérifier que le contenu récupéré est celui qui a été cité | Terme du glossaire de la déclaration de citation des données ([FORCE11](https://force11.org/info/data-citation-principles-glossary/)) |
| **Granularité** | Niveau de découpage auquel un identifiant s'applique | Traitée comme dépendante du cas d'usage ([FORCE11](https://force11.org/info/joint-declaration-of-data-citation-principles-final/)) |
| **Provenance** | Chaîne de garde et de traitements subie par le contenu | Même source |
| **Dérivation** | Relation entre une chose et celle dont elle procède | Modélisée par PROV-O et PAV ([Data Science Journal, 2021](https://datascience.codata.org/articles/10.5334/dsj-2021-012)) |

**Trois distinctions ontologiques structurantes**, qui commandent toute la suite.

La première oppose le **nom** au **localisateur**. RFC 3986 précise qu'un identifiant d'un schéma donné peut avoir les caractéristiques d'un nom, d'un localisateur, ou des deux, et que cela dépend de la persistance et du soin de l'autorité qui l'attribue plutôt que d'une qualité du schéma ([IETF, 2005](https://datatracker.ietf.org/doc/html/rfc3986)). Autrement dit : la persistance n'est pas une propriété technique, c'est un engagement.

La deuxième oppose l'**intrinsèque** à l'**extrinsèque**. Un identifiant intrinsèque se calcule depuis l'objet, sans dépendre d'un tiers ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)). Un identifiant extrinsèque, comme un DOI, identifie plutôt un enregistrement de métadonnées ou un projet ([Software Heritage, 2020](https://www.softwareheritage.org/2020/07/09/intrinsic-vs-extrinsic-identifiers/)).

La troisième oppose l'**oeuvre** à ses réalisations. Le modèle FRBR de l'IFLA distingue quatre entités du premier groupe : oeuvre, expression, manifestation, exemplaire ([IFLA, cité par LoC](https://www.loc.gov/catdir/cpso/frbreng.pdf)). Cette distinction, née de la bibliothéconomie, est le meilleur outil disponible pour répondre à QR3.

## Étape 3 - Domaines de savoir mobilisés

La demande en suggère sept. La revue en identifie sept autres dont l'ontologie recoupe les questions posées. Les quatorze sont listés avec ce que chacun apporte.

### Domaines suggérés par l'humain

| Domaine | Apport aux questions de recherche |
|---|---|
| **Systèmes décentralisés et identité numérique** | Les DID sont des URI associant un sujet à un document résoluble, sans agence émettrice centrale ([W3C, 2022](https://www.w3.org/press-releases/2022/did-rec/)). Quatre piliers : décentralisé, persistant, vérifiable cryptographiquement, résoluble ([W3C](https://www.w3.org/TR/did-1.1/)). Répond à QR1 et QR5 |
| **Systèmes d'identifiants du réseau** | RFC 3986 fixe la syntaxe générique des URI et la distinction URI, URL, URN ([IETF, 2005](https://www.rfc-editor.org/info/rfc3986/)). Répond à QR3 et QR7 |
| **Spécifications publiques de protocoles décentralisés** | Le CID d'IPFS est auto-descriptif : préfixe multicodec, multihash, préfixe multibase, ce qui permet de l'interpréter sans contexte externe ([Chainscore Labs](https://chainscorelabs.com/glossary/nft-technologies-and-metadata/nft-metadata-optimization/ipfs-cid-content-identifier)). Source secondaire, signalée comme telle. Répond à QR3 et QR8 |
| **`apiVersion` des manifestes Kubernetes** | La forme est `<groupe>/<version>`, et le triplet groupe, version, sorte forme le GroupVersionKind ([Kubebuilder](https://book.kubebuilder.io/cronjob-tutorial/gvks)). Les niveaux de maturité `v1alpha1`, `v1beta1`, `v1` encodent la stabilité dans l'identifiant lui-même ([Kubernetes](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definition-versioning/)). Répond à QR4 et QR8 |
| **git** | Les identifiants d'objets de git sont des hachés de contenu organisés en graphe de Merkle. Software Heritage note que ses identifiants de contenus, répertoires, révisions et publications sont compatibles avec la manière dont git calcule les siens ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)). Répond à QR3, QR6, QR7 |
| **semver** | Fournit un identifiant de version porteur de sens : incompatible, ajout rétrocompatible, correctif. La spécification pose que le numéro encode l'incompatibilité, l'ajout rétrocompatible et le correctif ([Semantic Versioning 2.0.0](https://semver.org/lang/fr/)). Répond à QR4 |
| **Versions d'OS, amont et aval** | Le modèle amont-aval est celui d'un identifiant qui traverse des frontières de responsabilité : une même version amont porte des identifiants avals distincts. Aucune source normative n'a été trouvée pour ce modèle ; il est traité par analogie. Répond à QR7 et QR8 |

### Domaines que la revue ajoute

| Domaine | Pourquoi il recoupe les questions |
|---|---|
| **Théorie du nommage en systèmes distribués** | Le triangle de Zooko énonce le trilemme même que pose QR1 : lisible, sûr, décentralisé, deux sur trois ([Wikipédia](https://en.wikipedia.org/wiki/Zooko%27s_triangle)). Les systèmes de petnames prétendent atteindre les trois en distinguant les registres de noms ([Wikipédia](https://en.wikipedia.org/wiki/Petname)) |
| **Sciences de l'information et bibliothéconomie** | FRBR et le modèle WEMI répondent directement à QR3 ([IFLA](https://www.ifla.org/files/assets/cataloguing/isbd/OtherDocumentation/resource-wemi.pdf)) |
| **Identifiants pérennes de la recherche** | DOI, Handle, ARK. L'ARK a une syntaxe explicite où l'autorité de résolution est un préfixe **changeable**, ce qui sépare le nom de son résolveur ([Philipson, 2019](https://datasciencehub.net/system/files/ds-paper-597.html), [notice de l'éditeur](https://journals.sagepub.com/doi/10.3233/DS-190024)). Répond à QR8 |
| **Science ouverte et principes FAIR** | Les principes FAIR font des identifiants pérennes le fondement de la trouvabilité, avec un accent sur l'actionnabilité machine ([The Turing Way](https://book.the-turing-way.org/reproducible-research/rdm/rdm-fair/)). Le R de FAIR est exactement la question de la réutilisabilité posée par la demande ([FORCE11](https://force11.org/info/guiding-principles-for-findable-accessible-interoperable-and-re-usable-data-publishing-version-b1-0/)) |
| **Citation de données et de logiciels** | La déclaration conjointe de FORCE11 exige que la citation permette de vérifier que la tranche temporelle, la version ou la portion récupérée est bien celle qui a été citée ([FORCE11](https://force11.org/info/joint-declaration-of-data-citation-principles-final/)). Le SWHID est désormais la norme internationale ISO/IEC 18670 ([Software Heritage, 2025](https://www.softwareheritage.org/2025/06/13/software-hash-identifier-swhid-tutorial/)). Répond à QR4 |
| **Réplication et édition collaborative** | Dans Yjs, tout élément inséré reçoit un identifiant formé d'une paire identifiant de client et horloge, soit une estampille de Lamport ([Yjs INTERNALS](https://github.com/yjs/yjs/blob/main/INTERNALS.md)). Automerge résout les conflits de manière déterministe à partir d'estampilles de Lamport et d'identifiants d'acteurs ([Automerge docs](https://posit-dev.github.io/automerge-r/articles/crdt-concepts.html)). Répond à QR6 |
| **Gestion de paquets et espaces de noms** | Trois stratégies attestées : Maven Central emploie le nom de domaine inversé, déléguant la gouvernance du nommage au DNS ; npm fait coexister un espace plat et un espace à portées ; les modules Go emploient l'URL du dépôt comme nom, sans étape d'enregistrement ([Nesbitt, 2026](https://nesbitt.io/2026/02/14/package-management-namespaces.html)). Répond à QR5 |
| **Identifiants générés localement** | RFC 9562 définit les UUID comme des identifiants de 128 bits garantissant l'unicité dans l'espace et le temps, et recommande la version 7, lexicographiquement triable ([IETF, 2024](https://www.rfc-editor.org/info/rfc9562/)). Répond à QR5 et QR6 |
| **Provenance et versionnage** | Le travail sur le versionnage des données mobilise PROV-O et l'ontologie PAV pour modéliser la provenance du versionnage ([Data Science Journal, 2021](https://datascience.codata.org/articles/10.5334/dsj-2021-012)). Répond à QR7 |

## Étape 4 - Axes d'analyse

Quatorze axes couvrent l'espace de conception. Ils sont indépendants : un système d'identifiants se décrit par sa position sur chacun.

| Axe | Question qu'il pose | Positions attestées |
|---|---|---|
| **A1 Assignation** | L'identifiant se calcule-t-il ou s'attribue-t-il ? | Intrinsèque (git, CID, SWHID) contre extrinsèque (DOI, ISBN) |
| **A2 Autorité** | Qui alloue ? | Centralisée (DOI), fédérée (DNS, Handle), déléguée (reverse-DNS de Maven), décentralisée (DID), aucune (UUID, hachés) |
| **A3 Lisibilité** | L'humain peut-il le lire, le retenir, le dicter ? | Mnémonique contre opaque |
| **A4 Portée d'unicité** | Où l'identifiant est-il unique ? | Local, dépôt, organisation, global |
| **A5 Granularité** | À quoi s'applique-t-il ? | Oeuvre, expression, manifestation, exemplaire (FRBR) ; ou fragment, sous-ensemble (citation profonde) |
| **A6 Stabilité** | Que devient-il quand la chose change ? | Immuable, mutable, versionné |
| **A7 Résolvabilité** | Peut-on en obtenir la chose ? | Nom pur, nom résoluble, localisateur |
| **A8 Vérifiabilité** | Peut-on prouver l'intégrité de ce qu'on a obtenu ? | Fixité incluse, fixité séparée, aucune |
| **A9 Coût de gouvernance** | Que coûte l'allocation, la révocation, l'arbitrage ? | Registre payant, registre gratuit, aucun registre |
| **A10 Traversée de frontière** | L'identifiant interne survit-il à l'exposition externe ? | Identique, préfixé, traduit, remplacé |
| **A11 Dérivation** | La filiation est-elle lisible dans l'identifiant ou déclarée à côté ? | Dans l'identifiant, dans une relation, nulle part |
| **A12 Concurrence** | Deux acteurs peuvent-ils créer sans se coordonner ? | Oui sans risque, oui avec collision possible, non |
| **A13 Longévité** | Que reste-t-il si l'émetteur disparaît ? | Vérifiable sans lui, inerte, perdu |
| **A14 Ergonomie** | Combien coûte-t-il de le taper, de le citer, de le comparer à l'oeil ? | Court, long, illisible |

**Un axe absent de la littérature consultée.** Aucune source ne traite explicitement de A14, l'ergonomie de saisie, alors que c'est la première exigence de la demande. La littérature de conception d'identifiants raisonne pour des machines et pour des institutions, non pour une personne qui tape au clavier. Cette lacune est reprise à l'étape 6.

## Étape 5 - Revue historique

La chronologie fait apparaître trois vagues, et la troisième n'est pas achevée.

### Première vague : la localisation, 1983 à 1998

Le DNS établit le modèle dominant : un nom lisible, unique globalement, résolu par une hiérarchie d'autorités. Le web hérite de ce modèle avec l'URL, dont RFC 3986 rappellera qu'elle identifie **et** localise ([IETF, 2005](https://www.rfc-editor.org/rfc/rfc3986.html)).

La faiblesse apparaît vite : un localisateur cesse de fonctionner quand la chose bouge. La réponse de la première vague est normative et non technique. Berners-Lee formule le principe des URI durables, ensuite formalisé par des recommandations du W3C sur les URI pour le web sémantique ([arXiv, 2024](https://arxiv.org/pdf/2407.09237)).

La bibliothéconomie apporte, au même moment, la distinction que le web n'a pas faite. FRBR, recommandation de l'IFLA de 1998, sépare l'oeuvre, l'expression, la manifestation et l'exemplaire ([LoC](https://www.loc.gov/catdir/cpso/frbreng.pdf)). Un web qui n'identifie que des manifestations ne peut pas citer une oeuvre.

### Deuxième vague : la persistance instituée, 1994 à 2016

Le Handle System, le DOI et l'ARK répondent au problème de la localisation par une indirection : le nom est stable, le résolveur peut changer. La syntaxe de l'ARK rend cette séparation explicite en faisant de l'autorité de résolution un préfixe changeable ([Philipson, 2019](https://datasciencehub.net/system/files/ds-paper-597.html), [notice de l'éditeur](https://journals.sagepub.com/doi/10.3233/DS-190024)).

Cette vague est celle de l'engagement institutionnel plutôt que de la technique. RFC 3986 l'énonce sans détour : la persistance dépend du soin de l'autorité de nommage, non du schéma ([IETF, 2005](https://datatracker.ietf.org/doc/html/rfc3986)).

Deux formalisations closent la vague. La déclaration conjointe de FORCE11 sur la citation des données, qui exige la vérifiabilité de la version citée ([FORCE11](https://force11.org/info/joint-declaration-of-data-citation-principles-final/)). Et les principes FAIR, publiés en 2016 dans *Scientific Data*, qui font des identifiants pérennes le socle de la trouvabilité et insistent sur l'actionnabilité machine ([The Turing Way](https://book.the-turing-way.org/reproducible-research/rdm/rdm-fair/)).

### Troisième vague : l'auto-certification, 2001 à aujourd'hui

En 2001, Zooko Wilcox-O'Hearn énonce le trilemme qui structure encore le champ : lisible par un humain, sûr, décentralisé, et pas les trois à la fois ([Wikipédia](https://en.wikipedia.org/wiki/Zooko%27s_triangle)).

La réponse technique est l'adressage par contenu, qui abandonne délibérément la lisibilité. git en fait le fondement d'un système de versions distribué. IPFS généralise avec le CID auto-descriptif ([Chainscore Labs](https://chainscorelabs.com/glossary/nft-technologies-and-metadata/nft-metadata-optimization/ipfs-cid-content-identifier)). Software Heritage l'applique à l'archivage du code, et son identifiant devient la norme ISO/IEC 18670 ([Software Heritage, 2025](https://www.softwareheritage.org/2025/06/13/software-hash-identifier-swhid-tutorial/)).

La réponse institutionnelle est le DID, recommandation du W3C en 2022, qui pose quatre propriétés : aucune agence émettrice, persistance sans opérateur, preuve cryptographique du contrôle, résolvabilité des métadonnées ([W3C, 2022](https://www.w3.org/press-releases/2022/did-rec/)).

Deux évolutions récentes complètent la vague. RFC 9562, en 2024, refonde les UUID et recommande une version triable lexicographiquement ([IETF, 2024](https://www.rfc-editor.org/info/rfc9562/)). Et les types de données répliquées font entrer l'identifiant dans le contenu lui-même : chaque insertion dans un document Yjs reçoit une paire client et horloge ([Yjs](https://github.com/yjs/yjs/blob/main/INTERNALS.md)).

### Ce que la chronologie montre

Trois enseignements, qui ne sont pas dans une source unique mais dans leur superposition.

**Chaque vague résout le problème de la précédente en sacrifiant une propriété.** La deuxième vague gagne la persistance en perdant l'auto-suffisance : un DOI sans résolveur est inerte. La troisième gagne l'auto-suffisance en perdant la lisibilité : un haché ne se dicte pas.

**Aucune vague n'a remplacé la précédente.** Les quatre familles coexistent aujourd'hui dans les mêmes chaînes de travail. Software Heritage le formule en présentant intrinsèque et extrinsèque comme complémentaires plutôt que concurrents ([Software Heritage, 2020](https://www.softwareheritage.org/2020/07/09/intrinsic-vs-extrinsic-identifiers/)).

**La distinction la plus ancienne est la moins appliquée.** FRBR date de 1998 et répond à QR3 mieux que tout ce qui a suivi ; les systèmes techniques continuent de confondre l'oeuvre et le fichier.

## Étape 6 - Analyse critique

### État de la connaissance, par question

| Question | État | Solidité |
|---|---|---|
| QR1, trilemme | Théorisé, et contesté | Élevée pour le trilemme, faible pour sa réfutation |
| QR2, famille d'identifiants | Pratiqué, peu théorisé | Moyenne |
| QR3, granularité | Bien théorisé par FRBR, mal appliqué | Élevée |
| QR4, citabilité malgré le changement | Bien traité par la citation de données | Élevée |
| QR5, collisions et gouvernance | Trois stratégies attestées et comparées | Élevée |
| QR6, édition collaborative | Résolu techniquement | Élevée |
| QR7, dérivation | Modélisé par PROV, peu outillé | Moyenne |
| QR8, frontière interne et externe | **Angle mort** | Faible |

### Quatre controverses ouvertes

**Le trilemme de Zooko est-il réfuté ?** L'article de référence affirme que la conjecture a été contestée, plusieurs systèmes fondés sur des chaînes de blocs étant présentés comme atteignant les trois propriétés, dans les limites de la tolérance aux fautes byzantines ([Wikipédia](https://en.wikipedia.org/wiki/Zooko%27s_triangle)).

Cette affirmation appelle une réserve méthodologique forte, et c'est l'écart de crédibilité le plus important de cette revue : la source est une encyclopédie collaborative, non un article évalué, et la réfutation d'une conjecture de conception est un jugement, non un fait. Deux objections de fond subsistent. La condition « dans les limites de la tolérance aux fautes byzantines » n'est pas gratuite : elle suppose un consensus coûteux, donc une infrastructure. Et l'unicité obtenue est celle d'un registre partagé, ce qui déplace l'autorité sans la supprimer.

Pour un système comme `clia`, la position prudente est de traiter le trilemme comme valide : la seule manière connue de le contourner exige une chaîne de blocs, ce qui est hors de proportion.

**La persistance est-elle une propriété technique ou un engagement ?** RFC 3986 tranche pour l'engagement ([IETF, 2005](https://datatracker.ietf.org/doc/html/rfc3986)). Le champ des identifiants pérennes vit de cette ambiguïté : on vend des identifiants persistants, alors que la persistance vient de l'institution qui les résout. Le seul contre-exemple sérieux est l'identifiant intrinsèque, vérifiable sans son émetteur ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)).

**L'opacité est-elle un progrès ou une régression ?** L'adressage par contenu résout l'intégrité et la décentralisation, et supprime la lisibilité. La littérature bibliothéconomique documente l'inverse : des implémentations remplacent les URI opaques par des libellés lisibles pour la présentation ([Code4Lib Journal](https://journal.code4lib.org/articles/6424)). Personne n'a résolu la tension ; les systèmes qui s'en sortent la contournent en portant les deux.

**Les principes FAIR sont-ils opérationnalisables ?** La littérature d'application les traduit en attributs techniques ([ARDC](https://ardc.edu.au/resource-hub/making-data-fair/)), mais leur formulation reste au niveau du principe et l'évaluation de conformité fait l'objet d'instruments spécifiques ([arXiv, 2023](https://arxiv.org/pdf/2301.10236)). Le R de réutilisabilité est le moins outillé des quatre, alors que c'est celui que la demande interroge.

### Quatre limites de la littérature, pour la question posée

**L'ergonomie humaine n'est pas traitée.** L'axe A14 n'a pas de littérature. Les identifiants sont conçus pour des machines, résolus par des infrastructures, cités par des institutions. Personne n'étudie le coût de taper un identifiant à la main, ni celui de le reconnaître à l'oeil dans une liste. C'est la lacune la plus gênante ici, parce que la première exigence de la demande est la facilité d'usage.

**La frontière interne et externe est un angle mort.** La littérature suppose que l'identifiant naît public. Les seuls éléments transposables sont indirects : l'ARK sépare le nom de son résolveur ([Philipson, 2019](https://datasciencehub.net/system/files/ds-paper-597.html), [notice de l'éditeur](https://journals.sagepub.com/doi/10.3233/DS-190024)), et le SWHID sépare un coeur intrinsèque de qualificateurs contextuels extrinsèques qui portent l'origine, la visite, l'ancre et le chemin ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)). Le second est le plus proche d'une réponse à QR8, et il n'a pas été conçu pour cela.

**Le petit système n'est pas étudié.** Toute la littérature porte sur des systèmes à grande échelle. Les stratégies de gouvernance décrites, registre payant, délégation au DNS, consensus distribué, sont toutes disproportionnées pour un système à un ou quelques acteurs. La seule stratégie transposable est celle des modules Go : l'URL du dépôt sert de nom, sans étape d'enregistrement ([Nesbitt, 2026](https://nesbitt.io/2026/02/14/package-management-namespaces.html)). Cette source est un billet technique, mais elle est la meilleure synthèse comparative trouvée.

**L'identifiant d'une chose qui se réécrit n'est pas résolu.** L'adressage par contenu identifie parfaitement une version et ne sait pas nommer ce qui persiste à travers les versions. Le champ du versionnage des données pose que la granularité doit être déterminée par le cas d'usage, ce qui est une manière élégante de dire que la question n'a pas de réponse générale ([FORCE11](https://force11.org/info/joint-declaration-of-data-citation-principles-final/)).

## Étape 7 - Réponses aux questions et aux thèses posées

### Réponse aux huit questions de recherche

**QR1. Non, sauf à payer un consensus distribué.** Le trilemme de Zooko tient dans les conditions d'un petit système ([Wikipédia](https://en.wikipedia.org/wiki/Zooko%27s_triangle)). Il faut donc choisir deux propriétés et compenser la troisième par un mécanisme distinct.

**QR2. Une famille, et c'est la réponse centrale de cette revue.** Les systèmes qui fonctionnent en portent plusieurs. Le SWHID le montre en un seul identifiant : un coeur intrinsèque, plus des qualificateurs extrinsèques contextuels ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)). Software Heritage conclut à la complémentarité de l'intrinsèque et de l'extrinsèque ([Software Heritage, 2020](https://www.softwareheritage.org/2020/07/09/intrinsic-vs-extrinsic-identifiers/)). Chercher l'identifiant unique et parfait est l'erreur de conception que la littérature invite à ne pas commettre.

**QR3. Il faut choisir un niveau, et le déclarer.** FRBR donne quatre niveaux ([IFLA](https://www.ifla.org/files/assets/cataloguing/isbd/OtherDocumentation/resource-wemi.pdf)). Un identifiant qui ne dit pas à quel niveau il s'applique produit exactement la confusion que la bibliothéconomie a mis un siècle à démêler.

**QR4. Par la séparation du nom et de la fixité.** La citation doit permettre de vérifier que ce qui est récupéré est ce qui a été cité, ce qui suppose de porter une information de fixité **à côté** du nom ([FORCE11](https://force11.org/info/joint-declaration-of-data-citation-principles-final/)). Un nom stable désigne l'oeuvre ; une empreinte atteste la version.

**QR5. Trois stratégies, de coûts très différents.** Déléguer à un espace de noms existant, comme le nom de domaine inversé de Maven ; employer l'emplacement comme nom, comme les modules Go, sans enregistrement ; ou faire coexister un espace plat et un espace à portées, comme npm ([Nesbitt, 2026](https://nesbitt.io/2026/02/14/package-management-namespaces.html)). Pour un petit système, la deuxième est la seule dont le coût de gouvernance soit nul.

**QR6. Par un identifiant local plus une horloge logique.** La paire identifiant de client et horloge de Yjs ([Yjs](https://github.com/yjs/yjs/blob/main/INTERNALS.md)), ou les estampilles de Lamport avec identifiants d'acteurs d'Automerge ([Automerge](https://posit-dev.github.io/automerge-r/articles/crdt-concepts.html)), permettent la création simultanée sans coordination. À défaut, un UUID de version 7, triable lexicographiquement, offre la même propriété d'unicité sans coordination ([IETF, 2024](https://www.rfc-editor.org/info/rfc9562/)).

**QR7. Par une relation déclarée, non par l'identifiant.** Le versionnage des données mobilise PROV-O et PAV pour modéliser la provenance ([Data Science Journal, 2021](https://datascience.codata.org/articles/10.5334/dsj-2021-012)). Encoder la filiation dans l'identifiant produit des identifiants qui s'allongent à chaque dérivation ; la déclarer à côté la rend interrogeable.

**QR8. La littérature ne répond pas, et deux mécanismes sont transposables.** L'indirection de l'ARK, où l'autorité de résolution est un préfixe changeable ([Philipson, 2019](https://datasciencehub.net/system/files/ds-paper-597.html), [notice de l'éditeur](https://journals.sagepub.com/doi/10.3233/DS-190024)). Et la structure du SWHID, où un coeur stable reçoit des qualificateurs contextuels ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)). Dans les deux cas : **le noyau ne change pas, le contexte s'ajoute**. C'est la seule forme connue de traversée de frontière qui ne casse pas les renvois déjà écrits.

### Réponse aux trois exigences de l'intention

**Facilité d'usage.** Aucune littérature ne la traite, et elle est incompatible avec l'unicité globale par le trilemme. La conclusion transposable est qu'il faut deux registres : un identifiant court et lisible pour l'usage quotidien, un identifiant long et sûr pour l'exposition. Les systèmes de petnames formalisent exactement ce partage, en distinguant les noms locaux des noms globaux ([Wikipédia](https://en.wikipedia.org/wiki/Petname)).

**Distinction interne et externe.** Elle se réalise par extension et non par substitution : un identifiant interne devient externe en recevant un préfixe ou des qualificateurs, jamais en étant remplacé. C'est le mécanisme du SWHID et celui du GroupVersionKind de Kubernetes, où le groupe qualifie la sorte ([Kubebuilder](https://book.kubebuilder.io/cronjob-tutorial/gvks)).

**Ressource partageable et réutilisable.** Le R de FAIR exige que la description soit traitable par machine et que la chose soit citable ([FORCE11](https://force11.org/info/guiding-principles-for-findable-accessible-interoperable-and-re-usable-data-publishing-version-b1-0/)). Traduit en exigences d'identifiant : le type doit être lisible dans l'identifiant, la version doit être distinguable de l'oeuvre, et la fixité doit être disponible.

### Réponse aux quatre modalités de réutilisation

| Modalité | Ce que la littérature impose | Mécanisme |
|---|---|---|
| **Dans un autre projet** | Une portée d'unicité qui dépasse le projet | Espace de noms, délégué ou dérivé de l'emplacement ([Nesbitt, 2026](https://nesbitt.io/2026/02/14/package-management-namespaces.html)) |
| **Par une autre personne** | Une résolution qui ne dépend pas de l'émetteur | Identifiant intrinsèque, vérifiable sans tiers ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html)) |
| **En édition collaborative** | La création sans coordination | Identifiant local plus horloge logique ([Yjs](https://github.com/yjs/yjs/blob/main/INTERNALS.md)) |
| **En oeuvre dérivée** | Une filiation interrogeable, et une identité propre à la dérivée | Relation de dérivation déclarée ([Data Science Journal, 2021](https://datascience.codata.org/articles/10.5334/dsj-2021-012)) |

**Une conséquence forte pour le fork.** Une oeuvre dérivée doit recevoir une **identité propre** et déclarer sa filiation. Elle ne doit pas hériter de l'identifiant de son origine : ce serait confondre deux oeuvres au sens de FRBR. C'est la position que git tient implicitement, un fork ayant ses propres identifiants de commits tout en partageant les objets antérieurs au point de divergence.

## Ce que cette revue établit, en cinq propositions

1. Le trilemme de Zooko tient pour un petit système : lisible, unique globalement, sans autorité, il faut en abandonner un ([Wikipédia](https://en.wikipedia.org/wiki/Zooko%27s_triangle)).
2. Un système d'identifiants viable est une famille, non un identifiant unique, et les familles qui fonctionnent combinent un noyau intrinsèque et des qualificateurs extrinsèques ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html), [Software Heritage, 2020](https://www.softwareheritage.org/2020/07/09/intrinsic-vs-extrinsic-identifiers/)).
3. Un identifiant doit déclarer le niveau auquel il s'applique, faute de quoi oeuvre et version se confondent ([IFLA](https://www.ifla.org/files/assets/cataloguing/isbd/OtherDocumentation/resource-wemi.pdf)).
4. La persistance est un engagement, pas une propriété technique, sauf pour l'identifiant intrinsèque ([IETF, 2005](https://datatracker.ietf.org/doc/html/rfc3986)).
5. La traversée de la frontière interne vers externe se fait par extension du noyau, jamais par remplacement ([SWH docs](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html), [Kubebuilder](https://book.kubebuilder.io/cronjob-tutorial/gvks)).

## Limites de cette revue

**Aucune source sur le cas visé.** La littérature ignore le système documentaire de petite échelle destiné à croître. Toutes les transpositions de l'étape 7 sont raisonnées.

**Crédibilité inégale, et signalée à chaque endroit.** Les spécifications IETF et W3C et la documentation de Software Heritage sont des sources primaires. FRBR est cité par un document de la Bibliothèque du Congrès. En revanche, la réfutation du trilemme de Zooko, la synthèse comparative des espaces de noms, la description du CID et la pratique du semver dans les API reposent sur des sources secondaires ou des billets, faute de mieux. La proposition 1 est la plus exposée : elle repose sur une conjecture énoncée sur une liste de diffusion en 2001 et jamais démontrée formellement.

**Aucune recherche d'échec.** La revue documente ce qui marche. Elle n'a trouvé aucune source analysant les systèmes d'identifiants qui ont échoué, ni pourquoi. C'est la même lacune que celle relevée par `FND-001`, et elle est symétrique de celle que `ANL-001` constate dans le corpus local.

**L'ergonomie reste sans littérature.** L'axe A14 est identifié et non documenté. C'est la lacune la plus gênante au regard de la première exigence de la demande.

**Domaines non explorés faute de temps.** L'identité auto-souveraine au-delà des DID, les identifiants auto-certifiants de type KERI, la gouvernance des méthodes DID, les identifiants de Wikidata, et le droit des oeuvres dérivées. Les quatre premiers recoupent QR1 et QR5, le dernier recoupe QR7.

## Relations

- `reference` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `reference` [FND-001](FND-001-usage-des-cli-et-leur-renouveau.md)
- `specifie` [ANL-003](../analyses/ANL-003-systeme-d-identifiants-de-clia.md)
