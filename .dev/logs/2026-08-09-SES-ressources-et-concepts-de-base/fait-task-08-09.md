# Ce qui a été fait, tâches 8 et 9

## Volumétrie

| Livrable | Nombre | Détail |
|---|---|---|
| Définitions de types | 30, dont 23 nouvelles | 2 736 lignes |
| Schémas CUE | 60 | 30 de frontmatter, 29 de données de gabarit, 1 commun |
| Gabarits markdown | 29 | Dérivés des définitions |
| Skills | 7 | `skl-001` plus six skills de famille |
| ADR | 5, dont 2 nouveaux | `ADR-004` nature composable, `ADR-005` regroupement fonctionnel |
| Décisions `DCN` | 5, type nouveau | 2 pour les décisions de l'humain, 3 pour les ADR antérieurs |
| Objections | 17, dont 3 nouvelles | 122 questions au total |

`cue vet` ne signale aucune erreur sur les soixante schémas. Les soixante-sept tests du CLI restent verts.

## Tâche 9 : la nature de la ressource

`DCN-001` enregistre la décision de l'humain, `ADR-004` l'instruit en sept décisions.

La ressource est désormais définie par ses **propriétés** et non par son support : identifiable et auto-cohérente. Le markdown reste le format par défaut, comme choix de mise en oeuvre. Une ressource est **composable** ; chaque composant est un **atome**, ressource de plein droit qui déclare `fait-partie-de`. La propriété holographique est retenue dans sa lecture faible : tout atome se lit seul.

Deux relations sont ajoutées au vocabulaire : `compose` et `fait-partie-de`. Le décompte compte les ressources, non les fichiers.

`RES-001` passe en version 0.3.0. `ANL-001` est mis en conformité : ses huit atomes reçoivent un identifiant, un sujet, une date et une relation d'appartenance.

**Ce que la décision débloque immédiatement.** Le type `code` devient possible. Avant `ADR-004` D1, le code ne pouvait pas être une ressource puisqu'une ressource était un fichier markdown à frontmatter. `RES-026` le définit et nomme ses trois substituts au frontmatter : le commentaire d'en-tête, les tests, le nom de fichier.

## Tâche 9 répond à une objection ouverte

`NON-012`, ouverte le 2026-08-09 sur la granularité, reçoit une réponse par le haut : sa question Q1 est tranchée, une ressource peut être un répertoire. La suggestion S9 de `ANL-003`, qui proposait le bundle comme cas particulier, est dépassée par une décision plus générale ; sa convention d'entrée par `index` est reprise.

## Tâche 8 : les deux types nouveaux

`RES-008-fragment`, préfixe `FRG` : une unité textuelle auto-cohérente, captée et conservée telle quelle. Sa règle absolue est que l'agent ne modifie jamais le texte capté, y compris pour en corriger la langue. Son champ `exploitation` rend visible ce qui dort, avec une valeur `sterile` qui doit rester employable sans gêne.

`RES-009-decision`, préfixe `DCN` : une décision prise par une instance ayant autorité, enregistrée pour être citable. Elle ne décide pas, elle constate. Sa distinction avec l'ADR est nette : un ADR décide et porte ses alternatives, une DCN enregistre.

## Tâche 8 : le regroupement en six familles

`DCN-002` enregistre la décision, `ADR-005` l'instruit en six décisions.

Six familles définies par leur fonction : fondamentale, conception, contrôle, contenu, préparation, implémentation. Chaque type déclare sa famille. Les traces, log et session, ne sont dans aucune, ce que `ADR-005` D5 constate sans trancher.

**La décision D4 est celle qui change l'ordre de grandeur.** Le processus de production est attaché à la famille et non au type : six skills au lieu de vingt-neuf. C'est une proposition de l'agent, non une décision de l'humain, et elle est portée par `NON-017` Q1 avec un effet bloquant.

Cinq arbitrages d'attribution sont signalés : l'entrevue en contenu plutôt qu'en implémentation, le plan en préparation bien qu'absent de `CLAUDE.md`, l'ADR en préparation bien que discutable, `CDE` retenu contre le `COD` de la demande, et les traces hors familles.

## Tâche 8 : les vingt-et-une définitions manquantes

| Famille | Types définis |
|---|---|
| conception | Analyse, Fondation, Principe de conception, Méthodologie |
| contrôle | Harnais opératoire, d'architecture, constitutionnel, de gouvernance, Skill |
| préparation | ADR, Spécification, Requis fonctionnel, Requis non fonctionnel, Cas d'usage, Comportement attendu, Plan |
| implémentation | Code, Rapport de recherche, Article, Présentation |
| contenu | Entrevue |

Deux types sont déclarés `non-installe` : le harnais constitutionnel, dont ce dépôt n'a pas d'instance depuis le refactor, et le harnais de gouvernance, qui n'a jamais existé et dont `RES-017` interroge la nécessité.

## Tâche 8 : les trois artefacts dérivés

Les schémas CUE et les gabarits ne sont pas rédigés : ils sont **générés depuis les définitions**, à partir des champs `champs-obligatoires` et `sections` que chaque définition déclare.

C'est l'application directe de `ADR-003` D7, qui posait que la couche machine-lisible doit être dérivée et non écrite à la main, et qui signalait une circularité. Elle est levée : la dérivation est un script, pas une commande du CLI.

Trois conséquences.

Les soixante schémas sont cohérents par construction : un champ ajouté à une définition apparaît dans son schéma à la régénération.

Ils sont régénérables, donc jetables. Chaque fichier porte l'avertissement de ne pas l'éditer à la main.

Ils **valident réellement**. C'est la première validation de fond de ce dépôt.

## La validation trouve dix-sept non-conformités réelles

Éprouvés sur les soixante-neuf ressources du dépôt, les schémas ont trouvé dix-sept défauts, tous corrigés sauf un.

| Défaut | Nombre | Cause |
|---|---|---|
| `statut` lu comme un nombre octal | 5 | Bogue de mon générateur : `$13` produisait `0153`, que YAML lit comme octal 99 |
| Champ `date` absent | 8 | Les atomes de `ANL-001` n'en portaient pas |
| Champ `sujet` absent | 8 | Idem |
| Champ `id` absent | 8 | Les atomes n'étaient pas identifiables, ce que `ADR-004` D3 exige désormais |
| Champ `methodologie` absent | 1 | `FND-001`, antérieur à `RES-011` |
| `title` exigé pour un skill | 1 | La convention de l'outil impose `name`. Corrigé dans le schéma commun |
| Champ `effet` absent | 1 | `NON-013`, créé par `clia res new`. **Non corrigé** : fichier de l'humain |

Bilan : **68 ressources sur 69 valident leur schéma**.

## Le seul échec restant a révélé un bogue du CLI

`NON-013`, créé la veille par l'humain avec `clia res new`, ne porte pas les champs propres du type `objection`. Cause : la commande posait une liste fixe de cinq champs, sans lire la définition.

Corrigé. `clia res new` lit désormais `champs-obligatoires` et `sections` dans la définition du type, pose tous les champs déclarés, marque `À RENSEIGNER` ceux dont la valeur dépend du contenu, et écrit les sections annoncées.

Deux autres bogues du CLI ont été trouvés dans le même mouvement.

Le champ `type` était dérivé du **titre** de la définition et non de son identifiant : `Décision d'architecture` produisait `type: décision-d-architecture` au lieu de `adr`. Le titre est un libellé lisible, l'identifiant porte le slug canonique.

La résolution d'un type échouait sur les accents : `clia res ls decision` ne trouvait pas le type intitulé « Décision ». Une huitième colonne porte désormais le nom canonique, sans accent, qui est ce qu'un humain tape et ce que le frontmatter contient.

Le fichier de l'humain n'a pas été touché.

## Ce qui n'a pas été fait

Vingt-trois skills de type. Six skills de famille les remplacent, écart porté par `NON-017` Q1.

Aucune DCN pour les ADR-006 à ADR-014, qui n'existent pas.

Aucune modification de `CLAUDE.md`, dont la table des types est désormais doublement dépassée : elle annonce vingt-sept types là où trente sont définis, et sa désignation par triplet de numéros reste invalidée.

Aucune instance des types nouveaux, hors les cinq DCN produites.
