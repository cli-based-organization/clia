# FND-2026-07-18 - Principes de conception et design des systèmes complexes

- **Statut** : actif
- **Date** : 2026-07-18
- **Objectif** : établir une base factuelle et sourcée sur le design des systèmes complexes, sur la notion de **principe de conception**, et sur la **place** qu'un principe de conception occupe dans la maîtrise de la complexité. Sert de fondation à la définition d'un nouveau type de ressource « principe de conception » et à l'analyse des principes du dépôt.

## Note de rigueur

Fondation appuyée sur des sources primaires fondatrices (Herbert Simon, « The Architecture of Complexity », 1962 ; Fred Brooks, *The Mythical Man-Month*, sur l'intégrité conceptuelle ; David Parnas, sur le masquage d'information) et sur des références établies d'ingénierie (littérature sur la séparation des préoccupations, la modularité, le couplage/cohésion ; cadres d'architecture de type TOGAF pour la notion de principe directeur). Les concepts retenus (hiérarchie, quasi-décomposabilité, intégrité conceptuelle, séparation des préoccupations) sont **stables** ; les cadres outillés évoluent davantage. Recherche menée le 2026-07-18.

## Cadrage / Thèse

**Question** : qu'est-ce qu'un système complexe, qu'est-ce qu'un principe de conception, et quel rôle le principe joue-t-il dans la conception d'un système complexe ?

**Périmètre** : la nature des systèmes complexes, les grands principes de conception, et la fonction d'un principe comme instrument de gouvernance de la conception. Hors périmètre : les méthodes de modélisation détaillées et les principes propres à un paradigme (ex. SOLID pour l'orienté-objet) au-delà de leur mention.

**Définitions** :
- **Système complexe** : système composé d'un grand nombre de parties en interaction, dont le comportement global n'est pas trivialement déductible du comportement des parties (Simon).
- **Principe de conception** : énoncé normatif durable, de haut niveau, qui guide les décisions de design et auquel tout élément du système doit se conformer pour préserver la cohérence de l'ensemble.

## 1. La nature des systèmes complexes (Simon)

Herbert Simon, dans « The Architecture of Complexity » (1962), dégage deux propriétés communes aux systèmes complexes qui survivent et évoluent :

- **La hiérarchie** : un système complexe tend à prendre la forme d'une hiérarchie, composé de sous-systèmes interreliés, eux-mêmes composés de sous-systèmes, jusqu'à un niveau élémentaire d'analyse.
- **La quasi-décomposabilité (near-decomposability)** : dans un système hiérarchique, les interactions **à l'intérieur** d'un sous-système sont plus fortes et plus fréquentes que les interactions **entre** sous-systèmes. Cette propriété permet d'analyser et de concevoir chaque sous-système presque indépendamment.

Simon montre, par la **parabole des deux horlogers** (Tempus et Hora), que les systèmes organisés hiérarchiquement, en modules stables intermédiaires, se construisent et résistent aux perturbations **beaucoup plus efficacement** que les systèmes montés d'un seul tenant : le temps pour atteindre la complexité dépend du nombre d'états intermédiaires stables. La hiérarchie et la modularité ne sont donc pas des commodités esthétiques mais des **conditions de viabilité et d'évolutivité** d'un système complexe.

## 2. Les grands principes de conception

La maîtrise de la complexité s'appuie sur un petit ensemble de principes récurrents, cohérents avec les propriétés de Simon :

- **Séparation des préoccupations (Separation of Concerns, Dijkstra)** : décomposer un système en parties traitant chacune un aspect cohérent et unique, sans mêler des préoccupations de natures différentes. C'est l'application directe de la quasi-décomposabilité.
- **Modularité** : découper le système en modules autonomes, chacun exposant une interface petite et stable qui masque son fonctionnement interne.
- **Couplage faible et cohésion forte** : minimiser les dépendances entre modules (couplage) et maximiser l'unité de finalité au sein d'un module (cohésion). La séparation des préoccupations se traduit précisément par « réduire le couplage, augmenter la cohésion ».
- **Abstraction et masquage d'information (Parnas)** : exposer le quoi, cacher le comment ; un module cache ses décisions susceptibles de changer derrière une interface stable.
- **Principes économiques transverses** : **DRY** (ne pas dupliquer la connaissance), **KISS** (préférer le simple), **YAGNI** (ne pas concevoir pour des besoins hypothétiques), **moindre surprise** (le comportement doit être prévisible).

Ces principes ne sont pas indépendants : ils sont des facettes d'une même idée, rendre un système complexe **compréhensible, modifiable et évolutif** en le structurant en parties quasi-décomposables à interfaces stables.

## 3. Le principe de conception comme instrument de gouvernance de la conception

Au-delà des principes « classiques » de structuration du code, les cadres d'architecture (type TOGAF) formalisent la notion de **principe directeur** comme un artefact de gouvernance :

- Un principe y est un **énoncé durable et normatif** qui guide les décisions de conception et d'architecture dans le temps, indépendamment d'une implémentation particulière.
- La forme canonique d'un principe comporte trois éléments : un **énoncé** (la règle), une **justification/rationale** (pourquoi), et des **implications** (ce que le principe impose ou interdit concrètement).
- La fonction d'un principe est de **contraindre l'espace des décisions** : il ne dit pas comment construire chaque élément, mais borne ce qui est acceptable, garantissant que des décisions prises à des moments et par des personnes différents restent cohérentes entre elles.

Un principe se distingue ainsi d'une **décision** (un ADR tranche un choix ponctuel) et d'une **exigence** (un requis prescrit une propriété d'un système donné) : le principe est **transverse et durable**, il s'applique à **tout** élément du système et sert de critère pour juger la cohérence des décisions et des exigences elles-mêmes.

## 4. Intégrité conceptuelle : pourquoi tout élément doit respecter les principes

Fred Brooks (*The Mythical Man-Month*) pose l'**intégrité conceptuelle** comme la considération **la plus importante** dans la conception d'un système : mieux vaut un système qui reflète **un seul ensemble d'idées cohérent**, quitte à omettre des améliorations, qu'un système bourré de bonnes idées mais indépendantes et non coordonnées. L'intégrité conceptuelle est la cohérence et la prévisibilité de l'ensemble, issues d'une **vision unificatrice** portée par le design.

Conséquence directe pour un système gouverné par des principes : la valeur d'un principe **dépend de son respect universel**. Un principe que certains éléments enfreignent cesse d'être un principe et devient un vœu ; l'intégrité conceptuelle se dégrade, et le système redevient un assemblage d'idées disparates. C'est pourquoi un **écart à un principe est un défaut** au sens fort : il n'affaiblit pas seulement l'élément fautif, il érode la cohérence de tout l'édifice. Traiter le non-respect d'un principe comme un **bogue** est la traduction opérationnelle de l'exigence d'intégrité conceptuelle.

## Synthèse

Un système complexe viable est hiérarchique et quasi-décomposable (Simon) : il se structure en modules à interfaces stables, faiblement couplés et fortement cohésifs. Les principes de conception (séparation des préoccupations, modularité, couplage/cohésion, abstraction, DRY/KISS/YAGNI, moindre surprise) sont les instruments de cette structuration. Au-dessus d'eux, la notion de **principe directeur** (énoncé + justification + implications) joue un rôle de **gouvernance** : elle contraint durablement l'espace des décisions pour préserver l'**intégrité conceptuelle** (Brooks), c'est-à-dire la cohérence d'ensemble. Parce que cette cohérence dépend du respect universel des principes, un écart à un principe n'est pas une variation locale acceptable mais un **défaut** qui érode le tout, ce qui justifie de le traiter comme un bogue.

## Limites

- « Système complexe » a des acceptions variées (sciences de la complexité, ingénierie des systèmes) ; la fondation retient l'angle ingénierie/design.
- Les principes cités sont largement consensuels mais leur application concrète reste contextuelle et parfois en tension (ex. DRY vs découplage) ; aucun principe ne prime absolument sans arbitrage.
- Les principes propres à un paradigme (SOLID, orienté-objet) ne sont mentionnés que pour mémoire.
- Le rôle de l'intégrité conceptuelle est bien étayé conceptuellement mais difficile à mesurer quantitativement.

## Sources

- H. A. Simon, « The Architecture of Complexity », *Proceedings of the American Philosophical Society* (1962) : https://faculty.sites.iastate.edu/tesfatsi/archive/tesfatsi/ArchitectureOfComplexity.HSimon1962.pdf
- SFI Press, « The Architect of Complexity » (édition commentée de Simon 1962) : https://www.sfipress.org/21-simon-1962
- F. P. Brooks, *The Mythical Man-Month* (1975/1995) — intégrité conceptuelle ; synthèse : https://kb.feval.ca/engineering/design/conceptual-integrity.html
- I. Exman, « Conceptual Integrity of Software Systems: Architecture, Abstraction and Algebra » : https://arxiv.org/pdf/1811.04315
- Séparation des préoccupations (Dijkstra ; synthèse) : https://effectivesoftwaredesign.com/2012/02/05/separation-of-concerns/ ; https://www.geeksforgeeks.org/software-engineering/separation-of-concerns-soc/
- Modularité, abstraction, cohésion, couplage (D. Farley) : https://gotopia.tech/articles/256/engineering-into-software-development-dave-farley
- Software Design Principles (Kempner Institute Computing Handbook) : https://handbook.eng.kempnerinstitute.harvard.edu/s2_swe_for_research/software_design_principles.html
- D. Parnas, « On the Criteria To Be Used in Decomposing Systems into Modules » (1972) — masquage d'information (référence).
