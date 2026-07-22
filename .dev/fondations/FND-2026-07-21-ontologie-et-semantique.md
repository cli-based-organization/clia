# FND-2026-07-21 - Ontologie et sémantique : définitions, spectre, pile technique et usages

- **Statut** : actif
- **Date** : 2026-07-21
- **Objectif** : établir une base factuelle et sourcée sur les notions d'**ontologie** et de **sémantique** au sens de l'ingénierie de la connaissance et de l'informatique : définitions et généalogie, spectre des ontologies (du léger au lourd), pile du web sémantique (RDF, OWL, SPARQL), distinctions avec la taxonomie et le graphe de connaissances, analyse critique (promesse et limites), et usages contemporains (ontologies légères, ancrage des agents IA). Sert de socle réutilisable à l'analyse des usages de ces notions dans un corpus de dépôts et à leur application éventuelle à `clia`. Complète `FND-2026-07-18-llm-wiki-okf-gestion-connaissance`, qui traite du pattern LLM Wiki et de l'Open Knowledge Format.

## Note de rigueur

Fondation appuyée sur des sources primaires de l'ingénierie ontologique (Gruber 1993, Studer et al. 1998, Guarino 1998), sur l'article fondateur du web sémantique (Berners-Lee, Hendler, Lassila 2001) et les standards du W3C (RDF, RDFS, OWL, SPARQL), ainsi que sur des sources secondaires de référence pour les distinctions praticiennes (comparatifs taxonomie / ontologie / graphe de connaissances) et pour l'usage récent des ontologies dans l'ancrage des modèles de langage. Les faits théoriques (définitions, spectre, pile) sont stables ; les affirmations sur l'usage des ontologies pour réduire l'hallucination des modèles sont plus récentes et périssables, et sont signalées comme telles. Recherche web menée le 2026-07-21 ; les faits déjà établis dans la FND OKF (12 juin 2026) ne sont pas ré-vérifiés ici. Les mobilisations du corpus interne des dépôts voisins (fondation ontologique de `comm-cli`, modèle de données de `jvtrudel-cv`) servent d'illustration d'application, pas d'autorité factuelle.

## Cadrage / Thèse

### Question

Qu'est-ce que la **sémantique** et qu'est-ce qu'une **ontologie** en informatique et en ingénierie de la connaissance ? Quel est leur outillage technique, comment se situent-elles par rapport aux notions voisines (taxonomie, graphe de connaissances, schéma de données), quelles sont leurs promesses et leurs limites, et sous quelles formes se retrouvent-elles dans les systèmes contemporains, notamment les systèmes à ressources et les harnais d'agents IA ?

### Périmètre

Dans le périmètre : les définitions et la généalogie de l'ontologie et de la sémantique ; le spectre léger vers lourd ; la pile du web sémantique ; les distinctions ontologie / taxonomie / graphe de connaissances ; l'analyse critique de la démarche ; les formes légères (ressources typées, frontmatter, liens) ; le rôle des ontologies dans l'ancrage des agents. Hors périmètre : les tutoriels d'implémentation d'un triplestore ou d'un raisonneur OWL, la linguistique formelle (sémantique dénotationnelle des langages de programmation, théorie du sens en logique), et le détail des algorithmes d'alignement d'ontologies.

### Définitions pivots

- **Sémantique** : ce qui relève du **sens** et de l'interprétation, par opposition à la **syntaxe** (la forme) et à la **structure** (l'agencement). Une donnée est *sémantiquement* traitée quand elle est non seulement stockée et bien formée, mais **typée**, **reliée** et **interprétable** selon ce qu'elle signifie. Attention à l'homonymie : le mot « sémantique » désigne aussi, dans d'autres contextes, la sémantique d'un langage de programmation ou d'un DSL, le *semantic versioning*, ou le HTML sémantique. Ces usages ne relèvent pas de la représentation des connaissances et constituent, pour une analyse d'usage ontologique, du bruit.
- **Ontologie** : suivant la définition la plus citée de la discipline, « une spécification explicite d'une conceptualisation » (Gruber, 1993) [1]. Une **conceptualisation** est une vue abstraite du monde que l'on souhaite représenter dans un but donné (objets, concepts, relations) ; « explicite » signifie que les types de concepts et les contraintes sur leur usage sont définis formellement. Studer, Benjamins et Fensel (1998) précisent la formule en « spécification formelle et explicite d'une conceptualisation partagée » [2], ajoutant deux exigences : *formelle* (lisible par la machine) et *partagée* (consensus d'une communauté, non idiosyncrasie d'un individu).

### Thèse

Une ontologie n'est pas d'abord une technologie (RDF, OWL) mais une **discipline de modélisation** : rendre explicites les *types* d'entités d'un domaine, leurs *attributs* et leurs *relations*, de façon qu'humains et machines partagent la même interprétation. Cette discipline se déploie sur un **spectre continu**, du plus léger (un simple vocabulaire contrôlé ou une taxonomie) au plus lourd (une théorie axiomatisée en logique de description). La valeur d'une ontologie ne croît pas mécaniquement avec sa formalité : elle croît avec l'**adéquation entre le niveau de formalisation et le besoin réel** de partage, de validation et d'inférence. Le web sémantique « lourd » a largement échoué à s'imposer à l'échelle du Web, mais ses *idées* (typage, liens, contrats de sens) reviennent avec force, sous forme **légère**, dans les systèmes à ressources et dans l'ancrage des agents IA.

## 4. Généalogie : de la philosophie à l'ingénierie de la connaissance

Le terme *ontologie* vient de la philosophie, où il désigne l'étude de l'être et des catégories de ce qui existe. L'informatique et l'intelligence artificielle l'ont réemprunté dans les années 1990 pour désigner un artefact d'ingénierie : un modèle explicite des concepts d'un domaine, destiné au partage et à la réutilisation de connaissances formalisées entre systèmes.

La définition de Gruber (1993), issue de « A Translation Approach to Portable Ontology Specifications » (Knowledge Acquisition 5(2):199-220), est le point d'ancrage de la discipline : une ontologie est « une spécification explicite d'une conceptualisation », c'est-à-dire la spécification d'un vocabulaire de représentation (définitions de classes, de relations, de fonctions) pour un domaine de discours partagé [1]. Cet article est parmi les plus cités de son champ [1]. Guarino (1998), dans « Formal Ontology in Information Systems », affine la notion en la reliant à la logique et à la théorie des modèles, et distingue l'ontologie (le modèle) de la base de connaissances (les faits) [3]. Studer et al. (1998) consolident la définition opératoire en insistant sur les caractères *formel* et *partagé* [2].

L'enjeu originel est donc l'**interopérabilité sémantique** : permettre à des systèmes hétérogènes d'échanger non seulement des données, mais leur *sens*, en s'accordant sur un contrat conceptuel explicite.

## 5. Le spectre des ontologies : du léger au lourd

L'ontologie n'est pas binaire. Lassila et McGuinness (2001) ont proposé une **échelle continue**, souvent appelée *ontology spectrum*, allant des formes très légères et informelles aux formes lourdes riches en axiomes [4][5] :

- **Glossaire / vocabulaire contrôlé** : une liste de termes avec définitions en langage naturel. Sémantique pour l'humain, pas pour la machine.
- **Taxonomie** : une hiérarchie de concepts reliés par une relation de subsomption (« est-un » / généralisation-spécialisation). Structure d'arbre ou de treillis.
- **Thésaurus** : une taxonomie enrichie de relations d'association et de synonymie.
- **Ontologie légère** (*lightweight*) : concepts, hiérarchie de concepts et hiérarchie de relations, propriétés, sans axiomes formels contraignant l'interprétation [6][7].
- **Ontologie lourde** (*heavyweight*) : une ontologie légère enrichie d'**axiomes** et de **contraintes** (cardinalités, disjonctions, restrictions, règles) qui fixent rigoureusement la sémantique des concepts et des relations, autorisant l'inférence automatique [5][6].

Point saillant pour la conception de systèmes : une taxonomie et un ensemble de relations typées constituent déjà une ontologie légère. Beaucoup de systèmes « ontologiques » utiles ne dépassent jamais ce niveau, et n'en ont pas besoin. Le passage au lourd (axiomes, raisonneur) se justifie seulement quand l'**inférence automatique** ou la **validation logique forte** apporte une valeur qui excède son coût.

## 6. La pile du web sémantique

Berners-Lee, Hendler et Lassila (2001), dans « The Semantic Web » (Scientific American), ont proposé de transformer le Web centré-document en un **graphe de faits lisibles par la machine**, où les données sont typées, reliées et interrogeables selon leur sémantique [8]. Le W3C a standardisé une pile de technologies pour cela [9] :

- **RDF (Resource Description Framework)** : le modèle de données de base. Toute connaissance s'exprime en **triplets** (sujet, prédicat, objet), qui forment un graphe orienté étiqueté. Chaque ressource est identifiée par un IRI.
- **RDFS (RDF Schema)** : un premier niveau de vocabulaire (classes, sous-classes, propriétés, domaines et portées).
- **OWL (Web Ontology Language)** : le standard de fait pour les ontologies logiques, fondé sur les logiques de description, permettant d'exprimer des axiomes riches et d'inférer des faits implicites [9].
- **SPARQL** : le langage de requête et le protocole d'accès aux graphes RDF, souvent exposés via un *endpoint* [9].
- **JSON-LD, schema.org** : des sérialisations et vocabulaires pragmatiques qui ont porté l'adoption réelle (données structurées pour moteurs de recherche), plus légers que la pile OWL complète.

Cette pile incarne l'ontologie *lourde* et *formelle*. Elle offre l'inférence et l'interopérabilité maximales, au prix d'une complexité d'ingénierie élevée.

## 7. Ontologie, taxonomie et graphe de connaissances

Trois notions souvent confondues, qu'il faut distinguer [10][11][12] :

- La **taxonomie** classe : elle organise des concepts en hiérarchie (« est-un »). C'est le squelette.
- L'**ontologie** définit le sens : elle décrit les *types* d'entités, leurs *attributs* et l'ensemble de leurs *relations* (pas seulement la subsomption), avec éventuellement des contraintes. Elle est *centrée modèle* et *pilotée par les définitions* : elle répond à « qu'est-ce que cela veut dire ».
- Le **graphe de connaissances** (*knowledge graph*) peuple : c'est ce que l'on obtient en appliquant une ontologie (le modèle) à des **données d'instance** (les faits). Il est *centré données* et *piloté par les instances* : il répond à « qu'est-ce qui se passe » [10][11].

Formule synthétique retenue : l'ontologie est le *schéma sémantique généralisé* ; le graphe de connaissances est ce schéma **appliqué** aux instances [11][12]. Un même vocabulaire distingue ainsi la couche *concept / type* (ontologie) de la couche *fait / instance* (graphe). Cette séparation couche-type / couche-instance est le motif de conception le plus transférable de tout le domaine.

## 8. Analyse critique : promesse et limites

La démarche ontologique porte une promesse réelle et des limites documentées.

**Promesses.** Trois bénéfices reviennent dans la littérature et chez les praticiens qui construisent des systèmes gouvernables : le **déterminisme** (mêmes données, mêmes résultats, garanti par un contrat formel), la **validation** (les incohérences deviennent détectables formellement avant production : une instance mal typée ou une relation pendante est une erreur), et l'**interopérabilité** (un modèle explicite est consommable par des agents hétérogènes, humains, scripts et modèles de langage, pourvu que chacun respecte le contrat). Ces trois bénéfices sont exactement ceux invoqués par les systèmes à ressources orientés multi-acteurs.

**Limites.** La vision « lourde » du web sémantique à l'échelle du Web a largement échoué : dès 2006, ses promoteurs reconnaissaient que l'idée « restait largement irréalisée » [8]. Les causes documentées : coût de construction et de maintenance des ontologies formelles, difficulté du consensus (le « partagé » de la définition est le plus dur à obtenir), fragilité et lourdeur des raisonneurs à grande échelle, et faible incitation des producteurs de données à annoter richement. L'anti-pattern central est la **sur-ingénierie** : investir dans l'axiomatisation lourde là où une ontologie légère (types plus relations) suffirait. Le succès réel s'est produit *par le bas*, via les formes légères et pragmatiques (schema.org, JSON-LD, frontmatter typé), non par la pile complète.

**Conséquence de conception.** Le bon niveau d'ontologie est le plus léger qui satisfait le besoin de partage, de validation et d'inférence. On monte en formalisation seulement quand un besoin concret (inférence automatique, validation forte, interopérabilité inter-agents) le justifie.

## 9. Ontologies légères, ressources typées et systèmes de fichiers

Le regain contemporain de l'ontologie passe par des formes légères adossées à des fichiers plutôt qu'à des triplestores. Le pattern dominant : un **répertoire de documents** (souvent markdown), chacun portant un **frontmatter** de métadonnées dont un champ *type* qui rattache le document à une classe, et des **liens** entre documents qui matérialisent les relations. L'ensemble forme un graphe typé, léger, versionnable et lisible par l'humain comme par la machine. L'Open Knowledge Format (OKF, voir `FND-2026-07-18-llm-wiki-okf-gestion-connaissance`) standardise précisément ce pattern : markdown plus frontmatter YAML, champ `type` requis, liens formant un graphe, en visant l'interopérabilité *structurelle* et en laissant la sémantique riche (ontologies RDF/OWL) aux conventions.

Ce pattern se retrouve dans une famille de CLI à ressources : la connaissance et le travail sont modélisés comme des **ressources typées** (des *kinds*, des *classes*), reliées par des **relations** (composition, inclusion, référence), avec une **validation** déterministe assurée par l'outil et non par la discipline des opérateurs. La « ressource » y joue le rôle d'instance, et la *typologie des ressources* joue le rôle d'ontologie légère. Selon les systèmes, l'ontologie est nommée et de première classe (une commande dédiée gère des classes et des relations), ou implicite et tacite (une typologie de documents documentée mais non formalisée comme ontologie).

## 10. Ontologie et IA générative : l'ancrage du contexte

Un usage récent et en forte croissance relie l'ontologie aux modèles de langage. Un modèle de langage n'a pas de mémoire organisationnelle et peut être **localement cohérent mais globalement incohérent** avec le cadre d'un domaine. Fournir au modèle un **contexte structuré et validé** (un modèle de ressources résolu, plutôt qu'un prompt libre) réduit cette dérive. Cette idée prolonge le *retrieval-augmented generation* en imposant une gouvernance structurelle au contexte lui-même.

La littérature récente (à traiter comme récente et périssable) rapporte que l'ancrage des sorties d'un modèle dans une connaissance structurée réduit sensiblement l'hallucination : des graphes de connaissances adossés à une ontologie validée (RDF/OWL) sont présentés comme améliorant fortement l'exactitude sur des tâches de question-réponse spécialisées, et l'ancrage plus l'abstention sont décrits comme retirant la plus grande part des erreurs pour l'effort le plus faible [13][14]. Une ontologie, dans ce cadre, fournit à l'agent un **contrat de sens** : un vocabulaire de types et de relations qui borne ses interprétations et rend ses productions vérifiables.

Ce point rejoint le motif *AI-native* : concevoir un système non pour *utiliser* l'IA de façon ad hoc, mais pour que l'IA soit un **client gouverné d'un modèle de ressources** explicite, dont l'ontologie (même légère) est le contrat.

## 11. Synthèse : ce qu'il faut retenir

- Une **ontologie** est la spécification explicite, formelle et partagée d'une conceptualisation : les *types* d'un domaine, leurs *attributs* et leurs *relations* (Gruber 1993 ; Studer et al. 1998). La **sémantique**, c'est le sens ainsi rendu explicite, par-delà la syntaxe et la structure.
- L'ontologie vit sur un **spectre continu** : glossaire, taxonomie, thésaurus, ontologie légère (types plus relations), ontologie lourde (axiomes plus raisonnement). La valeur suit l'adéquation au besoin, pas la formalité brute.
- La **pile du web sémantique** (RDF, RDFS, OWL, SPARQL) incarne le pôle lourd. Elle offre inférence et interopérabilité maximales, mais son adoption à l'échelle du Web a échoué par coût et complexité ; le succès réel est venu des formes légères (schema.org, JSON-LD, frontmatter typé).
- Distinction structurante : la **taxonomie** classe, l'**ontologie** définit le sens, le **graphe de connaissances** applique l'ontologie aux instances. La séparation couche-type / couche-instance est le motif le plus transférable.
- Les bénéfices praticiens de l'approche ontologique (déterminisme, validation, interopérabilité) sont précisément ceux recherchés par les systèmes à ressources multi-acteurs et par les harnais d'agents IA.
- Forme contemporaine dominante : le **répertoire de documents markdown à frontmatter typé et liens**, ontologie légère lisible par l'humain et la machine. L'ontologie y sert de **contrat de sens** pour ancrer les agents et réduire l'incohérence globale.

## 12. Limites

Cette fondation couvre les notions et leur outillage, pas l'ingénierie détaillée (méthodologies de construction d'ontologie comme METHONTOLOGY ou NeOn, alignement et fusion d'ontologies, choix d'un raisonneur). Les affirmations sur la réduction d'hallucination par ancrage ontologique sont issues de travaux récents et de sources praticiennes, à considérer comme directionnelles et périssables : les chiffres cités relèvent de contextes spécifiques (question-réponse clinique) et ne se généralisent pas mécaniquement. La frontière entre « ontologie légère » et « simple schéma de données » est en partie conventionnelle. Les définitions philosophiques de l'ontologie sont volontairement laissées de côté au profit de l'acception informatique. Péremption : le socle théorique (définitions, spectre, pile) est stable ; la partie sur l'ancrage des agents IA évolue vite.

## 13. Sources

Sources web vérifiées le 2026-07-21, sauf mention contraire.

- [1] Gruber, T. R. (1993). *A Translation Approach to Portable Ontology Specifications*. Knowledge Acquisition, 5(2), 199-220. Définition « an explicit specification of a conceptualization ». Voir aussi <https://tomgruber.org/publications/> et la synthèse <https://www.linkedin.com/pulse/ontologyan-explicit-specification-muhammad-hassim>.
- [2] Studer, R., Benjamins, V. R., Fensel, D. (1998). *Knowledge Engineering: Principles and Methods*. Data & Knowledge Engineering, 25(1-2), 161-197. Définition « formal, explicit specification of a shared conceptualization ».
- [3] Guarino, N. (1998). *Formal Ontology in Information Systems*. Proceedings of FOIS'98, IOS Press.
- [4] Lassila, O., McGuinness, D. (2001). *The Role of Frame-Based Representation on the Semantic Web*. Spectre des ontologies. Diagramme et synthèse : <https://www.researchgate.net/figure/Lightweight-vs-heavyweight-ontologies-and-their-relationship-with-Lassila-and-McGuinness_fig1_49911232>.
- [5] *Heavyweight Ontology Engineering*. Springer. <https://link.springer.com/chapter/10.1007/11915034_18>.
- [6] *Lightweight ontology*. Wikipedia. <https://en.wikipedia.org/wiki/Lightweight_ontology>.
- [7] *Lightweight Ontologies*. Springer Encyclopedia entry. <https://link.springer.com/content/pdf/10.1007/978-1-4899-7993-3_1314-2.pdf>.
- [8] Berners-Lee, T., Hendler, J., Lassila, O. (2001). *The Semantic Web*. Scientific American. Contexte historique et constat d'échec partiel (« largely unrealised ») : <https://taylorandfrancis.com/knowledge/Engineering_and_technology/Computer_science/Semantic_Web_Stack/> ; <https://arxiv.org/pdf/2503.20793>.
- [9] W3C. Standards RDF, RDFS, OWL, SPARQL. Synthèse de la pile : <https://taylorandfrancis.com/knowledge/Engineering_and_technology/Computer_science/Semantic_Web_Stack/>.
- [10] *Knowledge Graph vs Ontology*. PuppyGraph. <https://www.puppygraph.com/blog/knowledge-graph-vs-ontology>.
- [11] *What's the Difference Between an Ontology and a Knowledge Graph?* Enterprise Knowledge. <https://enterprise-knowledge.com/whats-the-difference-between-an-ontology-and-a-knowledge-graph/>.
- [12] *Taxonomy vs. ontology vs. knowledge graph: What's the difference?* Neo4j. <https://neo4j.com/blog/knowledge-graph/taxonomy-vs-ontology-vs-knowledge-graph/>.
- [13] *Ontology in AI: Components, Standards & Agent Applications*. Atlan. <https://atlan.com/know/what-is-ontology-in-ai/>.
- [14] *Ontology-grounded knowledge graphs for mitigating hallucinations in LLMs for clinical question answering*. ScienceDirect. <https://www.sciencedirect.com/science/article/abs/pii/S1532046426000171>.
- Corpus interne mobilisé à titre illustratif (application) : `FND-2026-07-18-llm-wiki-okf-gestion-connaissance` (OKF, Google, 12 juin 2026) ; fondation ontologique de `comm-cli` (`doc/foundation/communicaiton-pilars.md`, citant Gruber 1993 et Berners-Lee 2001) ; modèle de données à couches de `jvtrudel-cv` (`FND-001-primitives-de-candidature.md`).
