# Ce qui a été fait, tâche 3

## Livrables produits

| Fichier | Lignes | Contenu |
|---|---|---|
| `.dev/adr/ADR-001-adoption-de-la-notion-de-ressource.md` | 204 | Neuf décisions numérotées D1 à D9, avec motifs mesurés, alternatives écartées et portes de sortie |
| `.dev/skills/skl-001-ressource/SKILL.md` | 366 | Cinq règles communes en partie A, quatre étapes de production en partie B, neuf contrôles de validation |

## ADR-001, les neuf décisions

| Décision | Objet | Alternative écartée |
|---|---|---|
| D1 | La ressource est l'unité du travail | Le régime conversationnel augmenté de résumés |
| D2 | La forme est le markdown à frontmatter YAML | Base de données, YAML pur, schéma exécutable |
| D3 | L'identité est le champ `id`, pas le numéro ni le chemin | L'identité par chemin, position de `micrologic-clients` |
| D4 | Trois classes de cycle de vie | Une règle uniforme de versionnage |
| D5 | Quatre régimes d'édition | Deux régimes, `humain` et `ia` |
| D6 | Trois documents par type, complétés type par type | Le triplet exigé simultanément |
| D7 | Le méta-type s'applique à lui-même | Aucune |
| D8 | Ce qui n'est pas une ressource | Aucune |
| D9 | Validation humaine outillée par des contrôles textuels | La validation par schéma exécutable, reportée |

Le statut de décision est `propose` et non `accepte` : trois objections bloquantes portent sur D3, D6 et D9.

Cinq décisions portent une porte de sortie explicite, qui dit à quelles conditions elles seraient révisées. D9 est la première trace écrite de l'abandon de la validation par schéma, que le corpus avait perdue trois fois sans décision.

## skl-001-ressource, la structure

Partie A, cinq règles communes à toute ressource, quel que soit son type : frontmatter, identité et nommage, écriture, relations, et ce qui déclenche une objection plutôt qu'une ressource. Les skills des autres types y renverront au lieu de les recopier.

Partie B, quatre sections sur la production d'une définition de type : le critère de départage à appliquer avant d'écrire, une procédure en neuf étapes, un gabarit, et les rubriques non optionnelles.

Neuf contrôles de validation, tous exécutables sans outil et tous testés sur les livrables réels des tâches 2 et 3.

| Contrôle | Ce qu'il vérifie | Dégât qu'il prévient, mesuré dans le corpus |
|---|---|---|
| V1 | Fichier non vide | Un `CONSTITUTION.md` de zéro octet, jamais détecté |
| V2 | Frontmatter analysable, `type` et `id` présents | |
| V3 | Champs obligatoires déclarés par le type | `completed` dans 52 logs, `complet` dans 2 du même dépôt |
| V4 | Aucun tiret cadratin ni demi-cadratin | |
| V5 | Aucun filet hors frontmatter, tous les liens résolvent | |
| V6 | `id` unique dans le dépôt | Trois paires d'ADR à titre identique dans un dépôt |
| V7 | `id` cohérent avec le nom de fichier | |
| V8 | Aucun marqueur de gabarit résiduel | `INTENTION.md` restés aux crochets, README au gabarit |
| V9 | Contenu propre à ce dépôt, par empreinte | Trois `INTENTION.md` identiques désignant le mauvais client, 18 logs recopiés |

## Le skill a corrigé un défaut de ses propres contrôles

Les contrôles V4 et V5 de la première version signalaient le skill lui-même comme non conforme, en trouvant les tirets cadratins dans leurs propres commandes et les filets du gabarit de la partie B.

Le défaut était réel : un contrôle textuel qui ne distingue pas une mention d'un emploi est inutilisable sur un document de méthode. Les trois contrôles textuels excluent désormais le frontmatter, les blocs de code et le code inline. La règle d'exclusion est énoncée en tête de la section de validation, avec l'incident qui l'a fondée.

## Mises à jour rendues nécessaires

| Fichier | Modification |
|---|---|
| `.dev/ressources/RES-001-ressource.md` | Version 0.1.0 vers 0.2.0. Champs `skill` et `adr` renseignés. Objet, auto-application et relations corrigés |
| `.dev/ressources/index.md` | Ligne `RES-001` complétée. Section de statut et section sur ce qui n'est pas produit rectifiées |

## Question tranchée de fait

La tâche 3, en demandant l'ADR et le skill d'un seul type, répond par la négative à `NON-002` Q1 : le triplet n'est pas exigible simultanément pour tous les types. Cette lecture est inscrite dans `ADR-001` D6, avec sa porte de sortie. La question reste formellement ouverte faute de réponse écrite de l'humain.

## Ce qui n'a pas été fait

Aucun script exécutable. La tâche demande un document de directives.

Les six autres ADR et skills. `ADR-001` D6 déclare qu'ils ne sont pas exigibles d'avance.

`CLAUDE.md` non touché, bien que sa table des types duplique l'index et que sa désignation par triplet de numéros soit invalidée par D3.
