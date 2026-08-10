---
type: analyse
id: ANL-observation-corpus-repos-et-pratiques
title: "Observation du corpus de dépôts et des pratiques de travail"
version: 0.1.0
status: draft
date: 2026-08-09
sujet: "Méthode, portée et index de l analyse du corpus"
generated:
  by: claude-opus-5
  at: 2026-08-09
portee: "166 dépôts git sous $HOME/git, relevé du 2026-08-09"
---

# ANL-001 - Observation du corpus de dépôts et des pratiques de travail

> Analyse du corpus complet des dépôts git de l'humain, en vue de comprendre le système d'augmentation IA construit depuis un an et la manière dont l'humain travaille. Matière première pour le premier jet des ressources fondamentales de `clia`.

## Objet

La tâche 1 de la session du 2026-08-09 demande de consulter l'ensemble des dépôts sous `$HOME/git`, d'en comprendre le système développé depuis un an et, plus généralement, d'observer comment l'humain travaille. Cette analyse consigne les observations.

Ce que cette analyse est : un relevé factuel du corpus, une description de chaque dépôt, une analyse critique de chaque dépôt, et une lecture transversale des pratiques.

Ce que cette analyse n'est pas : ni un plan, ni une décision. Elle ne produit aucune ressource fondamentale. Le fichier `candidats-ressources-fondamentales.md` recense ce que le corpus offre déjà comme matière, sans trancher.

## Méthode

Le relevé est mécanique et reproductible. Pour chacun des 166 dépôts détectés (recherche de répertoires `.git` jusqu'à trois niveaux sous `$HOME/git`) ont été collectés : nombre de commits toutes branches, dates du premier et du dernier commit, fichiers suivis, fichiers présents sur le disque, entrées non commitées, remote `origin`, présence de fichiers de harnais IA à la racine, cinq extensions dominantes. Ces données brutes vivent dans `inventaire.yaml`.

Sur cette base, une vingtaine de dépôts porteurs de la méthodologie ont été lus en profondeur : harnais complets, `INTENTION.md`, ADR, définitions de types de ressources, sessions archivées, skills, logs de sortie. Les autres dépôts ont été caractérisés par leur `INTENTION.md` ou `README.md`, leur arborescence et leurs métadonnées.

La profondeur du traitement est calibrée sur l'apport à la conception de `clia`. Les 22 dépôts qui portent le système et les 58 dépôts de travail métier reçoivent une description et une analyse critique individuelles développées. Les 62 dépôts de produit et les 24 dépôts de savoir reçoivent une description et une lecture critique individuelles, en forme condensée : le détail n'y apporterait rien. Les 166 dépôts sont couverts, aucun n'est omis.

Trois mesures supplémentaires ont été prises parce qu'elles révèlent des propriétés que la lecture individuelle ne montre pas : empreintes md5 croisées des 33 `CLAUDE.md` et des 32 `CONSTITUTION.md` du corpus (mesure de la divergence des harnais copiés), dénombrement des instances de ressources par préfixe sur tout le corpus, et table des noms distincts portés par chaque numéro de skill (mesure de la collision de numérotation).

## Limites du relevé

L'observation porte sur l'état du disque au 2026-08-09 et sur l'historique git. Elle ne voit pas les échanges conversationnels avec les agents, qui sont pourtant le lieu principal de la décision dans cette pratique. Elle ne voit pas non plus le travail contenu dans les dépôts distants dont la copie locale est en retard, ni les dépôts hors de `$HOME/git`.

Les quatre dépôts sous `archive/` sont traités comme les autres : ils portent une part de la genèse.

## Index du bundle

| Fichier | Contenu |
|---|---|
| `inventaire.yaml` | Données brutes des 166 dépôts, non interprétées |
| `repos/01-lignee-methodologique.md` | Les 22 dépôts qui portent le système. Description et analyse critique détaillées |
| `repos/02-repos-de-travail.md` | Les 58 dépôts de travail métier. Description et analyse critique détaillées |
| `repos/03-repos-de-produit-et-poc.md` | Les 62 dépôts de code, produits et prototypes. Traitement condensé |
| `repos/04-repos-de-savoir-et-dormants.md` | Les 24 dépôts de notes, d'apprentissage et de démarrages sans suite. Traitement condensé |
| `observations-pratiques.md` | Comment l'humain travaille. Rythme, style, dynamique avec l'agent |
| `analyse-critique.md` | Lecture critique transversale du système |
| `candidats-ressources-fondamentales.md` | Ce que le corpus offre pour le premier jet des ressources fondamentales |

## Chiffres du corpus

| Mesure | Valeur |
|---|---|
| Dépôts git | 166 |
| Dépôts jamais commités | 45 |
| Dépôts à un ou deux commits | 36 |
| Dépôts avec remote `origin` | 72, soit 43 pour cent |
| Dépôts avec du travail non commité | 61 |
| `CLAUDE.md` distincts dans le corpus | 33 fichiers, 18 contenus différents |
| `CONSTITUTION.md` distincts | 32 fichiers, 15 contenus différents |
| Instances de ressources typées, tous préfixes | 585 |
| Numéros de skill portant plusieurs noms distincts | 12 sur 20 |

## Constat d'ensemble

Le corpus n'est pas une collection de projets. C'est un banc d'essai. Depuis juillet 2025, l'humain a construit, éprouvé et réécrit trois fois un système d'augmentation du travail par IA, en le testant sur du travail réel plutôt que sur des exemples : offres de service, présentations de conférence, candidatures, stratégie d'entreprise, fondation de parti politique. Le système actuel, `clia`, est la troisième formalisation d'une même intuition, et la première à se donner une couche de types explicite.

Le système fonctionne. Sa faiblesse n'est pas conceptuelle, elle est mécanique : rien ne propage, rien ne valide, et l'identité des ressources repose sur des numéros séquentiels qui collisionnent d'un dépôt à l'autre. Le détail est dans `analyse-critique.md`.
