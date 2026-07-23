---
type: fondation
version: 0.1.0
title: "Requis et spécification : notions, distinctions et relation"
status: actif
date: 2026-07-18
---

# FND-015 - Requis et spécification : notions, distinctions et relation

- **Objectif** : établir une base factuelle et sourcée sur les notions de **requis** (requirement) et de **spécification** (specification) en génie logiciel et systèmes : leurs définitions, leurs sens multiples (souvent contradictoires selon les écoles), leur relation d'abstraction, et les critères de qualité associés. Sert de référence pour arbitrer les divergences terminologiques entre dépôts (voir l'analyse comparée `clia` vs `ticket-driven-ai`).

## Note de rigueur

Fondation appuyée sur des sources primaires normatives (ISO/IEC/IEEE 29148:2018, IEEE 830-1998) et académiques fondatrices (Zave & Jackson, « Four Dark Corners of Requirements Engineering » ; Michael Jackson, *Software Requirements & Specifications*), complétées par des sources secondaires de référence en ingénierie des systèmes (INCOSE/PPI, guides de pratique). Le vocabulaire du domaine est **notoirement instable** : plusieurs écoles emploient « spécification » et « requis » avec des sens différents, parfois inversés. La fondation restitue cette pluralité plutôt que d'imposer une définition unique. Recherche menée le 2026-07-18.

## Cadrage / Thèse

**Question** : que désignent exactement « requis » et « spécification », quelle est leur relation (lequel est plus abstrait ?), et pourquoi deux équipes rigoureuses peuvent-elles adopter des conventions opposées ?

**Périmètre** : les notions, leur relation et leurs critères de qualité. Hors périmètre : les techniques d'élicitation, la gestion des exigences (traçabilité outillée), et les formalismes de spécification (Z, TLA+) au-delà de leur principe.

**Définitions de travail** (précisées et nuancées dans le corps) :
- **Requis (requirement)** : une propriété ou capacité que quelque chose à concevoir doit posséder ou satisfaire.
- **Spécification (specification)** : un énoncé précis ; selon l'école, soit le **document** qui recense des requis, soit la **description au niveau de l'interface** de ce que la machine doit faire.

## 1. Un vocabulaire à sens multiples

Le point de départ le plus sûr est de reconnaître que « spécification » et « requis » n'ont **pas** de définition unique partagée. Trois lectures principales coexistent, et elles ne s'accordent pas sur laquelle des deux notions est la plus abstraite.

- **Lecture A - « spécification = document de requis » (conteneur).** Un requis est un énoncé de besoin ; l'écrire produit un « requis spécifié » ; une **spécification** est le *record* qui rassemble ces requis (INCOSE/PPI). Le SRS (Software Requirements Specification) est précisément « l'artefact qui contient l'ensemble des requis spécifiés ». Ici, spécification et requis ne sont pas à des niveaux d'abstraction différents : la spécification est le **contenant**, les requis le **contenu**.
- **Lecture B - « requis = quoi (problème), spécification = comment (interface/solution) ».** Usage courant en pratique : les requis présentent ce que le système doit faire (langage utilisateur, pour le client) ; les spécifications énoncent de façon précise et contraignante *comment* le système satisfera ces requis (langage système, pour le développeur). Ici, la **spécification est plus concrète** que le requis.
- **Lecture C - « spécification = quoi (comportement agnostique), requis = contexte concret ».** Usage rencontré dans certaines méthodologies (dont `ticket-driven-ai`) : la spécification décrit le « quoi » observable, agnostique au stack ; le « requis technique » traduit ce quoi en contraintes d'implémentation contextuelles (stack, performance). Ici, la spécification est **plus abstraite** que le requis, exactement l'inverse de la lecture B.

Ces trois lectures sont toutes défendables dans leur cadre, mais **B et C inversent** la relation d'abstraction entre les deux mots. C'est la source principale des malentendus inter-équipes.

## 2. La vue normative (ISO/IEC/IEEE 29148, IEEE 830) : la spécification comme document

Les normes de référence adoptent la **lecture A**.

- **IEEE 830-1998** puis **ISO/IEC/IEEE 29148:2018** définissent le **SRS** (Software Requirements Specification) comme le document rassemblant les exigences d'un logiciel. La « spécification » y est donc le **livrable documentaire** ; les « requis » en sont les énoncés constitutifs.
- 29148 définit l'ingénierie des exigences comme « une fonction interdisciplinaire qui médie entre le domaine de l'acquéreur et celui du fournisseur/développeur pour établir et maintenir les exigences à satisfaire » ; elle couvre découverte, élicitation, analyse, vérification, validation, documentation et gestion des exigences.
- La norme distingue par ailleurs plusieurs **niveaux** d'exigences (voir §5) et fournit les **attributs d'un bon requis** (nécessaire, non ambigu, singulier, vérifiable, etc.).

Dans cette vue, il n'y a pas d'inversion : « spécification » nomme l'artefact, « requis » nomme son contenu, et l'on parle indifféremment de *requirements specification* (le document des exigences) et, séparément, de *design specification* (le document de conception). La distinction d'abstraction se joue alors sur l'adjectif (*requirements* vs *design*), pas sur le mot *specification*.

## 3. La vue formelle (Zave & Jackson) : requis dans l'environnement, spécification à l'interface

L'école formelle de l'ingénierie des exigences (Pamela Zave et Michael Jackson, « Four Dark Corners of Requirements Engineering ») donne la distinction la plus rigoureuse, et elle correspond à la **lecture B**.

- Un **requis (requirement)** est une contrainte sur les phénomènes de l'**environnement** (le monde, le domaine d'application) que les parties prenantes veulent voir satisfaite. C'est le **problème**, exprimé dans le domaine.
- Une **spécification (specification)** est une description au **niveau de l'interface** entre la machine et l'environnement : ce que la machine fait à sa frontière. C'est un pas vers la **solution**.
- Les deux sont reliés par les **hypothèses de domaine** (domain assumptions) : la relation à garantir est `hypothèses de domaine ∧ spécification ⊨ requis`. Autrement dit, la spécification, jointe à ce que l'on sait du domaine, doit **impliquer** le requis.

Conséquence : chez Zave & Jackson, **le requis est plus abstrait (côté problème/environnement) et la spécification plus concrète (côté machine/interface)**. C'est l'inverse exact de la lecture C. Zave & Jackson notent eux-mêmes que cette distinction requis/spécification « n'est pas universellement acceptée » : ils la posent précisément parce que l'usage courant la brouille.

## 4. Le couple « quoi / comment » et sa relativité

L'opposition intuitive « les requis disent le *quoi*, la conception dit le *comment* » est utile mais **trompeuse si on la prend comme absolue**.

- Jackson montre que la frontière entre *quoi* et *comment* est **relative à la frontière de la machine** : « ce que fait le système » se situe dans le domaine d'application (le problème) ; « comment il le fait » se situe dans la machine (la solution). Déplacer la frontière machine déplace la ligne quoi/comment.
- Le *comment* de haut niveau devient le *quoi* du niveau inférieur : ce qu'un architecte voit comme une décision de conception (comment) est vécu par un développeur de sous-composant comme une exigence (quoi). La distinction est donc **contextuelle et récursive**, pas ontologique.
- Corollaire pratique : dire « une spécification décrit le quoi, un requis le comment » (ou l'inverse) n'a de sens que **relativement à une frontière machine fixée**. Sans cette frontière explicite, l'opposition quoi/comment ne tranche pas laquelle des deux notions est la plus abstraite.

Ce point explique pourquoi les lectures B et C peuvent **toutes deux** invoquer « quoi vs comment » tout en plaçant la spécification à des niveaux opposés : elles fixent implicitement la frontière machine à des endroits différents.

## 5. Taxonomie des requis

Indépendamment du débat sur le mot « spécification », la notion de requis est, elle, bien structurée.

- **Niveaux d'abstraction (29148, INCOSE)** : exigences **métier/parties prenantes** (business/stakeholder requirements, le besoin dans le langage de l'utilisateur) → exigences **système** (system requirements) → exigences **logicielles** (software requirements, plus proches de l'implémentable). Le même besoin se raffine du plus abstrait au plus concret **en restant appelé « requis »** à chaque niveau.
- **Fonctionnel vs non-fonctionnel** : un requis **fonctionnel** dit ce que le système fait ; un requis **non-fonctionnel** (aussi *quality attribute*, *cross-cutting concern*) contraint la manière dont il se comporte à travers ses fonctions (performance, sécurité, disponibilité, maintenabilité). La taxonomie de qualité de référence est ISO/IEC 25010 (SQuaRE). La distinction fonctionnel/non-fonctionnel est utile mais critiquée (Glinz, 2007) comme floue à la marge.
- **Requis vs contrainte** : une **contrainte** est un requis qui restreint les choix de solution (ex. « doit tourner sur Debian 12 », « doit utiliser le langage bash »). Les contraintes sont des requis à part entière, souvent d'origine contextuelle (organisation, existant, réglementation).
- **Attributs d'un bon requis (29148)** : nécessaire, approprié (au bon niveau d'abstraction), non ambigu, complet, singulier, vérifiable ; et pour un ensemble : cohérent, faisable, borné. Une exigence non vérifiable « n'est pas une exigence, c'est un vœu ».

## 6. Requirements specification vs design specification

La littérature d'ingénierie distingue nettement deux artefacts documentaires que le seul mot « spécification » tend à confondre :

- **Requirements specification** (spécification d'exigences, ex. SRS) : recense **les besoins** à satisfaire (le problème). Répond à « que doit-on obtenir ? ».
- **Design specification** (spécification de conception) : décrit **la solution** retenue (architecture, interfaces internes, algorithmes). Répond à « comment est-ce construit ? ».

La spécification de Zave & Jackson (§3), placée à l'interface machine/environnement, est un objet **intermédiaire** : plus concret qu'un requis d'environnement, plus abstrait qu'une conception interne. Beaucoup de « spécifications d'interface » (API, CLI, protocole) relèvent de cet entre-deux : elles ne sont ni le pur besoin ni la pure implémentation.

## 7. Pourquoi deux équipes rigoureuses divergent

La synthèse des sections précédentes explique le désaccord structurel :

- Le mot **spécification** est surchargé : conteneur documentaire (A), description d'interface plus concrète que le requis (B, Zave & Jackson), ou description abstraite du « quoi » agnostique (C).
- Le mot **requis** est plus stable (un besoin/propriété exigée) mais son **niveau** varie (métier → système → logiciel → contrainte), ce qui permet à une équipe d'appeler « requis » un énoncé très concret (contrainte de stack) sans se tromper au sens strict.
- Résultat : une équipe adossée à Zave & Jackson ou à l'usage courant (B) placera la **spécification en aval** (plus concrète, à l'interface) et le **requis en amont** (le besoin) ; une équipe raisonnant « spec = quoi agnostique / requis = comment contextuel » (C) placera la **spécification en amont** et le **requis en aval**. Les deux sont internement cohérentes ; elles sont **mutuellement contradictoires** sur l'axe d'abstraction.

Le champ ne tranche pas universellement en faveur de l'une. Toutefois, **la majorité des références** (normes via l'adjectif ; Zave & Jackson ; usage courant « req = besoin / spec = interface/solution ») traite le **requis comme le besoin (amont)** et réserve « spécification » soit au document, soit à la description d'interface plus concrète. La lecture C (spécification plus abstraite que le requis) est **minoritaire** et demande, pour éviter la confusion, de nommer explicitement son « requis » comme un document de **contraintes d'implémentation / de conception**.

## Synthèse

« Requis » et « spécification » ne forment pas un couple à définition figée. Trois lectures coexistent : la spécification comme **document** de requis (normes) ; la spécification comme **description d'interface** plus concrète que le requis, relié par des hypothèses de domaine (Zave & Jackson, usage courant) ; la spécification comme **description abstraite du quoi**, le requis portant alors le « comment » contextuel (méthodologies orientées séparation des préoccupations). L'opposition quoi/comment ne départage ces lectures qu'une fois la **frontière machine** fixée, car elle est relative et récursive. La notion de requis, elle, est stable et structurée : niveaux (métier → système → logiciel), fonctionnel/non-fonctionnel, contraintes, et attributs de qualité (29148). Recommandation transverse pour tout système documentaire : **choisir explicitement une lecture, fixer la frontière machine, et nommer sans ambiguïté l'artefact concret** (interface, conception, ou contraintes d'implémentation) plutôt que de laisser « spécification » et « requis » désigner tacitement des niveaux d'abstraction opposés d'un dépôt à l'autre.

## Limites

- Le champ terminologique évolue et reste contesté ; cette fondation cartographie les positions dominantes sans prétendre à un consensus qui n'existe pas.
- Les formalismes de spécification (Z, TLA+, Alloy) ne sont abordés que par leur principe (spécification à l'interface), pas dans leur technique.
- La distinction fonctionnel/non-fonctionnel, retenue comme opérationnelle, est critiquée dans la littérature récente (Glinz).
- Les normes citées (29148:2018, 830-1998, 25010:2011) sont les versions connues au 2026-07-18 ; une révision pourrait ajuster certains attributs.

## Sources

- ISO/IEC/IEEE 29148:2018, *Systems and software engineering — Life cycle processes — Requirements engineering* : https://www.iso.org/standard/72089.html ; https://standards.ieee.org/standard/29148-2018.html
- IEEE Std 830-1998, *Recommended Practice for Software Requirements Specifications* : https://ieeexplore.ieee.org/document/720574
- PPI (Project Performance International), « What is the difference between requirements and specifications? » : https://www.ppi-int.com/resources/systems-engineering-faq/what-is-the-difference-between-requirements-and-specifications/
- reqi.io, « Requirement vs. Specification: What is the difference? » : https://reqi.io/articles/requirement-vs-specification-what-is-the-difference
- ArgonDigital, « Defining Requirements and Specifications » : https://argondigital.com/blog/product-management/requirements-vs-specifications-create-a-shared-vocabulary/
- P. Zave & M. Jackson, « Four Dark Corners of Requirements Engineering », ACM TOSEM (1997) — requis/environnement vs spécification/interface, hypothèses de domaine.
- M. Jackson, *Software Requirements & Specifications* (1995) — relativité de la frontière quoi/comment ; https://wstomv.win.tue.nl/quotes/software-requirements-specifications.html
- « What are requirements? » (chapitre pédagogique, Univ. Toronto, d'après van Lamsweerde/Jackson) : https://www.cs.toronto.edu/~sme/CSC340F/readings/FoRE-chapter02-v7.pdf
- ISO/IEC 25010:2011, SQuaRE — attributs de qualité non-fonctionnels (référence).
- M. Glinz (2007), « On Non-Functional Requirements », IEEE RE Conference — critique de la distinction fonctionnel/non-fonctionnel.
