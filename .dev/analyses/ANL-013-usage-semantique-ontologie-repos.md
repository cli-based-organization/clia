---
type: analyse
version: 0.1.0
title: "Usages de la sémantique et de l'ontologie dans le corpus de dépôts, et positionnement de clia"
date: 2026-07-21
---

# ANL-013 - Usages de la sémantique et de l'ontologie dans le corpus de dépôts, et positionnement de clia

- **Périmètre** : les 154 dépôts git présents sous `/home/jvtrudel/git/` (racine `@../../` depuis `clia`), scannés récursivement pour les usages des notions de **sémantique** et d'**ontologie**. Filtres d'exclusion : `.git/`, `node_modules/`, fichiers `*.lock` et `*.min.*` (dépendances vendored et bruit de build). Confrontation finale : le dépôt `clia` lui-même.
- **Référence** : `FND-016-ontologie-et-semantique` (définitions, spectre, distinctions taxonomie/ontologie/graphe, formes légères, ancrage des agents). Complément : `FND-012-llm-wiki-okf-gestion-connaissance` et `ANL-006-clia-et-open-knowledge-format`.

## Objet

Recenser, pour chaque dépôt du corpus, si et comment les notions de sémantique et d'ontologie sont utilisées ; classer les dépôts qui en font usage en catégories d'usage ; puis analyser `clia` au regard du savoir mobilisé (FND) et des catégories identifiées, et formuler des recommandations sur les principes sémantique/ontologie à retenir et sur l'amélioration ou l'extension de ces notions dans `clia`. L'analyse recommande ; elle n'exécute aucun changement.

## Périmètre et méthode

Méthode en trois passes. (1) Inventaire des unités : `find` des répertoires `.git` (154 dépôts). (2) Détection par `rg` (ripgrep) sur deux régimes de termes : un régime **fort signal** (ontologie sous toutes ses flexions, RDF, OWL, SPARQL, JSON-LD, schema.org, triplestore, knowledge graph / graphe de connaissances, web sémantique, Open Knowledge Format) et un régime **large** (« sémantique / semantic ») qui capture beaucoup de bruit. (3) Lecture ciblée du contexte des correspondances à fort signal pour qualifier l'usage réel et écarter le bruit.

Grille de qualification de chaque dépôt (issue de la FND) :

- **Sémantique utilisée ?** au sens représentation des connaissances (typage, sens, relations), en écartant les homonymes non pertinents (semantic versioning, HTML sémantique, sémantique d'un langage / DSL, *semantic merge*, dépendance npm `http-cache-semantics`, types MIME `rdf`/`owl` dans du vendored).
- **Ontologie utilisée ?** présence d'un modèle explicite de types et de relations, nommé ou non.
- **Nature de l'usage** : moteur, architecture de ressources, couche de modèle de données, regroupement de specs, sémantique structurelle implicite, mention exploratoire, ou bruit.

Le bruit a été explicitement écarté : `nationtech/harmony` (sémantique d'un DSL de déploiement), `alienware/leptos-rs` (Rust semantics, vendored), `jvtrudel-adhoc/autohot2000` (dépendance `http-cache-semantics`), `disruptiva-dev/personal-journal` (*semantic merge* de synchronisation), `la-isla-disruptiva/dile-ola` (types MIME dans `node_modules`), et la longue traîne des dépôts à correspondance unique « semantic » non ontologique.

## Inventaire

Dépôts retenus comme faisant un **usage effectif** de sémantique/ontologie au sens de la représentation des connaissances (par volume de correspondances fort signal décroissant) :

| Dépôt | Sémantique | Ontologie | Nature de l'usage |
|---|---|---|---|
| `disruptiva-dev/nty` | oui | oui, de première classe | Moteur ontologique générique (CLI Go) : classes d'ontologie, relations typées, instances de données typées |
| `disruptiva-dev/comm-cli` | oui | oui, nommée et fondée | Architecture de ressources ontologique, AI-native (piliers de communication) |
| `noumanity-talents/jvtrudel-cv` | oui | oui, couche de modèle | Ontologie comme couche d'un modèle de données de domaine (candidatures) |
| `noumanity-consultation/LGS` | oui | oui, importée | Ontologie partagée d'un pipeline de domaine (même famille que jvtrudel-cv) |
| `la-isla-disruptiva/specruptiva` | oui | oui, regroupement | Ontologie comme regroupement nommé de spécifications de types CUE |
| `la-isla-disruptiva/kata-clientside-stuctureddata-editor` | oui (exploratoire) | mentionnée | Mention aspirationnelle (sujet d'exploration d'un kata) |
| `noumanity-dev/ticket-driven-ai` et forks consultation | implicite | implicite | Sémantique structurelle : ressources typées + frontmatter, sans vocabulaire ontologique |
| `cli-based-organization/clia` (ce dépôt) | implicite | implicite | Sémantique structurelle : typologie de ressources livrables, sans le mot « ontologie » |

Bruit écarté (échantillon) : `nationtech/harmony`, `alienware/leptos-rs`, `jvtrudel-adhoc/autohot2000`, `disruptiva-dev/personal-journal`, `dile-ola` (voir méthode). La grande majorité des 154 dépôts ne fait **aucun** usage de ces notions au sens retenu.

## Constats

### Classification en catégories d'usage

L'examen fait ressortir **cinq catégories d'usage effectif**, plus une catégorie de bruit.

**Catégorie A. Moteur ontologique générique (première classe).** L'ontologie est le produit lui-même : un outil agnostique au domaine qui gère des classes, des relations et des instances. Représentant : `disruptiva-dev/nty` (« système CLI pour la gestion ontologique et l'indexation de données », architecture hexagonale). Modèles de domaine `OntologyClass`, `Specification`, `Phor` (l'instance de donnée) ; commandes `nty ont new/list/show/inclusion/composition/remove-relation/delete/delete-hierarchy` et `nty phore` (CRUD des instances) ; persistance SQLite/JSON. On y trouve les deux ingrédients canoniques de la FND : une couche **type** (classes et relations typées : inclusion, composition) et une couche **instance** (les phores typés contre l'ontologie).

**Catégorie B. Architecture de ressources ontologique, AI-native.** L'ontologie est le modèle de ressources qui gouverne tout le système, et l'IA en est un client gouverné. Représentant : `disruptiva-dev/comm-cli`, décrit comme un « CLI ontologique ». Sa fondation (`doc/foundation/communicaiton-pilars.md`, section 6) cite explicitement Gruber (1993) et Berners-Lee (2001), et justifie l'approche par trois avantages identiques à ceux de la FND : déterminisme, validation, interopérabilité. Le modèle sépare des ressources stratégiques (`Organization`, `CommunicationPillar`, `Campaign`, `CommunicationAction`) et stylistiques (`VoiceProfile`, `StyleVariant`, `ChannelProfile`), avec héritage hiérarchique. Point remarquable : le CLI résout un « contexte effectif » (le graphe de ressources résolu) qui est le **seul point d'entrée de l'IA**, laquelle consomme un modèle validé et ne mute pas les sources. C'est le motif d'ancrage de la FND, section 10.

**Catégorie C. Ontologie comme couche d'un modèle de données de domaine.** L'ontologie est une couche distincte (la sémantique partagée et persistante : concepts et vocabulaire), séparée de la couche instance (les faits). Représentants : `noumanity-talents/jvtrudel-cv` et son parent de domaine `noumanity-consultation/LGS`. Le modèle de `jvtrudel-cv` (`FND-001-primitives-de-candidature.md`) définit quatre couches (Ontologie / Patrimoine / Ciblage / Artefacts) et pose que la couche **Ontologie** porte « la sémantique partagée et persistante » (Technologie, CatégorieDeTechnologie, Expertise). Le modèle est un **graphe typé, pas un arbre** : des noeuds dotés d'un `id` stable, des relations exprimées comme des références à ces `id`, un même concept pouvant exister à plusieurs granularités. La FND-001 note explicitement que l'intégrité référentielle « n'est pas garantie par YAML et doit être validée par un outil » : constat directement transférable à `clia`. `LGS` réutilise cette « ontologie partagée » comme référence d'outillage d'un pipeline (extraire/analyser offre et candidature).

**Catégorie D. Ontologie comme regroupement de spécifications de types.** L'ontologie est un regroupement nommé de plusieurs spécifications de types partageant un domaine. Représentant : `la-isla-disruptiva/specruptiva`, gestionnaire de spécifications CUE, où une annotation `ontology: human` regroupe des specs (`Person`, `Boy`, `Girl`) et où le CLI offre `specruptiva ontology list/show/new/edit/delete`. Usage plus léger et plus structurel que sémantique : l'ontologie y est surtout un espace de noms de types.

**Catégorie E. Sémantique structurelle implicite (sans le vocabulaire).** Des ressources typées, un frontmatter de métadonnées et des références croisées produisent de facto une ontologie légère, mais le système ne se nomme jamais « ontologique » et n'explicite pas son modèle de types. Représentants : la famille *ticket-driven / resource-driven* (`noumanity-dev/ticket-driven-ai`, ses forks de consultation) et `clia` lui-même (voir section suivante). C'est l'ontologie légère de la FND (section 9), au niveau taxonomie plus relations, non reconnue comme telle.

**Catégorie bruit.** Emplois du mot « sémantique / semantic » hors représentation des connaissances : versioning sémantique, HTML sémantique, sémantique d'un DSL, *semantic merge*, dépendances et vendored. À écarter systématiquement de toute analyse d'usage ontologique.

### Constat transverse

Le corpus se répartit très inégalement : sur 154 dépôts, une poignée seulement fait un usage substantiel, et ces usages se concentrent dans la famille des **CLI à ressources** (nty, comm-cli, specruptiva, la lignée ticket-driven/resource-driven) et des **modèles de données de domaine** (jvtrudel-cv, LGS). Deux régularités fortes ressortent : (1) partout où l'ontologie est explicite et utile, on retrouve la séparation **couche-type / couche-instance** de la FND ; (2) les usages les plus aboutis (nty, comm-cli) formalisent des **relations typées** entre ressources, là où les usages implicites (clia, ticket-driven) laissent les relations à l'état de références textuelles non validées.

## Confrontation à la référence : positionnement de clia

Fait de départ, vérifié par recherche dans le dépôt : `clia` n'emploie **jamais** le vocabulaire « ontologie » ni « sémantique » au sens de la représentation des connaissances. Les seules correspondances sont mécaniques (« frontmatter » dans la règle markdown-strict et dans le parsing de session). `clia` relève donc de la **catégorie E** (sémantique structurelle implicite).

Pourtant, au regard de la FND, `clia` possède déjà une **ontologie légère de facto** :

- **Une couche type.** `ADR-004` et la table des livrables de `CLAUDE.md` définissent une typologie de ressources (`FND`, `ANL`, `ADR`, `SPEC`, `REQ`, `skl`, `BUG`, `PLN`, `LOG`, `PDC`, session, publications), classée selon six axes (cycle de vie, droits d'édition, fonction, appartenance au harnais, nommage, producteur). Chaque type a des attributs (version, date, statut) et un skill de production associé. C'est une taxonomie de concepts assortie de contraintes : une ontologie légère au sens de Gruber, non nommée.
- **Une couche instance.** Chaque document concret (un `ADR-007`, une `FND` datée) est une instance typée de sa classe.
- **Des relations.** Les documents se référencent (« voir `ADR-005` », « `PDC-006` », « conforme à `SPEC-001` »), et les skills se lient aux types. Il existe donc un graphe de ressources.

Les **écarts** avec le savoir mobilisé, par rapport aux catégories A à D, sont nets :

1. **L'ontologie est tacite, dispersée et en prose.** Le modèle de types vit éclaté entre `ADR-004`, la table de `CLAUDE.md`, les ADR définissant chaque ressource et les skills. Il n'existe pas de source unique et lisible par la machine décrivant les types de ressources et leurs relations. `ressources.yaml` porte le versionnage, pas le schéma de types. À l'opposé, `comm-cli` (B) et `nty` (A) exposent un modèle explicite ; `jvtrudel-cv` (C) nomme sa couche Ontologie. Écart avec `PDC-006` (source de vérité documentaire unique).
2. **Les relations ne sont pas typées ni validées.** Les références croisées sont du texte libre. Il n'existe aucun vocabulaire explicite de relations (par exemple : *specifie*, *derive-de*, *remplace*, *reference*, *produit-par-skill*, *viole* pour un bogue vs un principe), et aucune vérification d'intégrité référentielle : une référence pendante (`voir ADR-042` inexistant) passe inaperçue. Or `nty` et `comm-cli` typent leurs relations, et la FND-001 de `jvtrudel-cv` avertissait déjà que l'intégrité référentielle « doit être validée par un outil ». Écart avec `PDC-001` (déterminisme) et `PDC-009` (traçabilité).
3. **Le typage des instances n'est pas uniforme ni machine-vérifiable.** Seuls les fichiers de session portent un frontmatter. Les autres ressources ne déclarent pas leur `type` en métadonnée : leur classe se déduit du préfixe de nom et du répertoire. C'est exactement l'écart déjà relevé par `ANL-006-clia-et-open-knowledge-format` face à l'OKF, et l'objet de la tâche 24 (« Adoption des conventions clefs de l'OKF »).

Positivement, `clia` est **conceptuellement le plus proche de `comm-cli` (catégorie B)** : même famille (CLI déterministe plus ressources plus gouvernance plus IA-native), mêmes trois justifications (déterminisme, validation, interopérabilité, qui recoupent `PDC-001`, `PDC-004`, `PDC-002`). La différence n'est pas de nature mais de **maturité de formalisation** : `comm-cli` a nommé, fondé et rendu explicite son ontologie ; `clia` ne l'a pas encore fait. `clia` est aussi plus riche que l'OKF sur la sémantique (typologie, skills-spécifications, versionnage), constat déjà posé par l'ANL OKF.

## Synthèse et recommandations

**Ce qu'il faut retenir.** Les usages effectifs de l'ontologie dans le corpus se rangent en cinq catégories, dominées par les CLI à ressources et les modèles de données de domaine. `clia` fait déjà, sans le dire, de l'ontologie légère (catégorie E), et se rapproche le plus de l'architecture ontologique AI-native de `comm-cli` (catégorie B). Ses trois écarts sont : ontologie tacite et dispersée, relations non typées ni validées, typage d'instance non uniforme. Aucun de ces écarts n'appelle une ontologie lourde (RDF/OWL/raisonneur) : la FND montre que le besoin (validation, découvrabilité, ancrage de l'agent) est couvert par une ontologie **légère**, et que la sur-ingénierie est l'anti-pattern à éviter.

**Recommandations sur les principes à retenir** (par ordre de priorité). Elles sont proposées à l'humain ; leur adoption relève d'un ADR ou d'un `PDC`, pas de cette analyse.

1. **Reconnaître explicitement la typologie de ressources de `clia` comme une ontologie légère** (couche type / couche instance), et poser comme principe la **séparation type / instance**. Cela nomme ce qui existe déjà et cadre les évolutions futures. Priorité haute.
2. **Poser la relation typée et à intégrité référentielle validée comme principe.** Les références entre ressources doivent appartenir à un vocabulaire de relations explicite et être vérifiables par `clia` (une référence pendante est un bogue au sens de `ADR-003`). Aligne sémantique structurelle et déterminisme (`PDC-001`, `PDC-009`). Priorité haute.
3. **Rester délibérément léger.** Inscrire comme principe le refus de l'ontologie lourde (pas de RDF/OWL, pas de triplestore, pas de raisonneur) tant que l'inférence automatique n'apporte pas une valeur excédant son coût. Cohérent avec l'adoption *sélective* déjà recommandée face à l'OKF et avec l'anti-pattern de sur-ingénierie de la FND. Priorité haute.
4. **Traiter le modèle de ressources comme le contrat qui ancre l'agent (AI-native).** Sur le modèle du « contexte résolu » de `comm-cli`, envisager que `clia` puisse résoudre et exposer le sous-graphe de ressources pertinent pour une tâche, comme contexte structuré pour l'agent. Sert `PDC-002` (IA seulement si nécessaire) et la notion de focus. Priorité moyenne.

**Recommandations sur l'amélioration / extension** (actionnables, non exécutées ici).

1. **Une source de vérité unique et lisible par la machine pour la couche type.** Étendre `ressources.yaml` (ou introduire un schéma dédié) pour décrire les types de ressources, leurs attributs et les relations autorisées, et faire de la table de `CLAUDE.md` une vue générée, non une source parallèle (respect de `PDC-006`). Priorité haute.
2. **Frontmatter `type` uniforme sur toutes les ressources.** Converger avec l'OKF et rendre le typage d'instance machine-vérifiable. Cette extension est déjà cadrée par la tâche 24 ; la présente analyse la renforce et lui donne son fondement ontologique. Priorité haute.
3. **Un petit vocabulaire de relations et la validation d'intégrité référentielle par `clia`.** Définir un ensemble minimal de types de relations (par exemple *specifie*, *derive-de*, *remplace*, *reference*, *produit-par*, *viole*), formaliser les références croisées comme des liens, et ajouter une commande d'inspection (`clia`) qui détecte les références pendantes et les incohérences de type. Priorité moyenne.
4. **Ne pas importer les ontologies de domaine des autres dépôts.** Les ontologies de `jvtrudel-cv`, `LGS`, `comm-cli` sont **métier** ; les rapatrier violerait la généricité du harnais (`ADR-005`). Elles sont mobilisées ici comme savoir illustratif, pas comme ressources à copier. Ce qui est transférable est le **motif** (type/instance, relations typées, validation), pas le contenu.

Ces recommandations convergent avec le chantier déjà prévu de **réécriture d'`ADR-004`** et avec la **tâche 24** (adoption des conventions OKF) : l'ontologie légère explicite est le cadre conceptuel qui unifie ces deux évolutions.

## Portée et péremption

Couverture : les 154 dépôts sous `/home/jvtrudel/git/` au 2026-07-21, détectés par correspondance de termes puis qualifiés par lecture ciblée du contexte. Limite de méthode : la détection par mots-clés peut manquer un usage ontologique qui n'emploierait aucun des termes cherchés (ontologie purement implicite sans vocabulaire), et peut sur-signaler du bruit écarté manuellement ; la qualification fine a porté sur les dépôts à fort signal, non sur chacun des 154. Le corpus évolue : de nouveaux dépôts ou refactors peuvent modifier le tableau. Le positionnement de `clia` reflète son état au 2026-07-21 (avant tâche 24 et avant réécriture d'`ADR-004`) ; il deviendra caduc dès que le typage par frontmatter ou une couche type explicite sera adopté.
