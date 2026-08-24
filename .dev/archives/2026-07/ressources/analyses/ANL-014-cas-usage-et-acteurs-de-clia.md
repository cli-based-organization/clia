---
type: analyse
version: 0.1.0
title: "Cas d'usage et acteurs du système clia : typologie des parties prenantes, écarts et ressource USE"
date: 2026-07-28
---

# ANL-014 - Cas d'usage et acteurs du système `clia`

- **Périmètre** : le dépôt `clia` dans son intégralité à la date du 2026-07-28. Racine : `.`. Inclusions : harnais (`CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`, `INTENTION.md`, `.dev/skills/`), documents de conception (`.dev/adr/`, `.dev/specs/`, `.dev/requis/`, `.dev/principes/`), savoir et travail (`.dev/fondations/`, `.dev/analyses/`, `.dev/bugs/`, `.dev/plans/`), implémentation (`src/`), vérification (`test/`), documentation utilisateur (`doc/`), et couche type (`.dev/resource-types.yaml`). Exclusions : `.git/`, les traces (`.dev/logs/`, `.dev/sessions/`) sauf citation ponctuelle, et `.dev/session.md` (édition humaine, lu mais jamais évalué).
- **Référence** : `FND-018-cas-usage-besoins-utilisateurs` (formes de description du besoin, niveaux de but, traçabilité besoin vers test, anti-motifs). Compléments : `FND-015-requis-et-specification` (chaîne requis / spécification), `FND-002-ingenierie-livrables-qualite`, `FND-007-conventions-cli`.

## Objet

Établir, pour le système d'information `clia`, (1) la typologie des utilisateurs et des autres parties prenantes, (2) l'état réel de la description et de la vérification de ses cas d'utilisation, (3) les écarts au regard de `FND-018`, et (4) des recommandations pour la création d'une ressource livrable dédiée au cas d'usage (`USE`) et son insertion dans la chaîne de conception existante. L'analyse recommande ; elle n'exécute aucun changement et ne crée aucune ressource.

## Périmètre et méthode

Méthode en quatre passes.

1. **Inventaire de la chaîne de conception** : lecture des documents qui portent le besoin ou son raffinement (`INTENTION.md`, `ADR-*`, `REQ-*`, `SPEC-*`, `PDC-*`) et de la couche type (`.dev/resource-types.yaml`, table des livrables de `CLAUDE.md`).
2. **Détection lexicale** : recherche des marqueurs du champ (`cas d'usage`, `cas d'utilisation`, `use case`, `user story`, `persona`, `acteur`, `utilisateur final`, `stakeholder`, `partie prenante`, `scénario`) sur tout le corpus, hors `.git`.
3. **Inventaire de la vérification** : lecture de `test/`, de `src/` et de la source documentaire `src/clia.doc.yaml`, pour établir ce qui est effectivement exécuté et ce à quoi cela se rattache.
4. **Confrontation** à `FND-018` : application de la grille ci-dessous, mesure des écarts, formulation de recommandations priorisées.

**Grille d'analyse** (six dimensions, issues de `FND-018`) :

| Dimension | Question posée au corpus |
|---|---|
| D1. Acteurs | Existe-t-il une typologie explicite des acteurs et des parties prenantes ? |
| D2. Description d'usage | Existe-t-il une forme documentaire décrivant un but d'acteur de bout en bout ? |
| D3. Altitude | À quel niveau de but (résumé, but utilisateur, sous-fonction) se situe la description existante ? |
| D4. Flux d'échec | Les déroulés alternatifs et d'erreur sont-ils décrits ? |
| D5. Traçabilité | Peut-on relier un usage à une exigence, à une spécification, à un test ? |
| D6. Vérification | Les usages principaux sont-ils couverts par des tests exécutables ? |

## Inventaire

### Où le besoin apparaît aujourd'hui dans le corpus

| Emplacement | Forme du besoin | Statut | Observation |
|---|---|---|---|
| `INTENTION.md` | vision, une phrase de finalité | édition humaine, stable | dit **pourquoi** le système existe ; ne nomme aucun acteur ni aucun usage |
| `.dev/session.md`, bloc « Livrables attendus » | deux capacités attendues (« créer un nouveau repo git et l'initialiser », « update/rollback les resources clia ») | édition humaine, éphémère | formulation **par capacité utilisateur**, mais qui disparaît avec la session |
| `ARCHITECTURE.md`, « Acteurs et rôles » | trois rôles : humain, agent IA, `clia` | harnais, stable | la **seule** typologie d'acteurs du dépôt, orientée responsabilité, pas usage |
| `ARCHITECTURE.md`, « Flux principal » | quatre étapes du cycle de travail | harnais, stable | proche d'un cas d'utilisation de niveau résumé, mais sans acteur explicite par étape, sans précondition ni flux d'échec |
| `REQ-002-cli-clia` | 18 exigences fonctionnelles et non fonctionnelles, chacune avec une ligne « Vérification » | conception | exigences **système**, pas besoins d'acteur ; les vérifications sont des critères, non des tests exécutés |
| `SPEC-002-cli-clia` | tables d'invocation, effets, codes de retour ; section « Exemples » | conception | description de l'**interface** ; l'usage y est implicite |
| `SPEC-003-format-markdown-clia-session` | contrat de format | conception | vérifié par `clia ses check` |
| `src/clia.doc.yaml` | documentation atomique par commande | implémentation | orientée **commande**, jamais orientée **but** |
| `test/test_clia.sh` | 8 assertions | vérification | voir ci-dessous |
| `doc/cli/` | 2 fichiers | documentation utilisateur | **contenu étranger au dépôt** (voir constat C7) |

### Inventaire de la vérification

`test/test_clia.sh` (53 lignes, 8 assertions) couvre exactement deux choses :

- la commande `release` : `patch`, `minor`, `major`, effet de `--dry-run`, et deux cas d'erreur d'usage (argument manquant, argument invalide, code 2) ;
- la cohérence dispatch / documentation (`_doc_selfcheck`, rattachée à `REQ-001-F9`).

Ne sont couverts par **aucun** test : l'ensemble du groupe `ses` (`status`, `check`, `plan`, `open`, `close`, `new`), c'est-à-dire le cycle de vie des sessions, qui est la raison d'être déclarée de `clia` (`ARCHITECTURE.md`, `ADR-006`, `ADR-007`) ; l'ensemble du groupe `res` ; les options globales `--version`, `--config`, `--man`, `--debug` ; et le comportement de `setup.sh activate`.

### Détection lexicale

Sur l'ensemble du corpus (hors `.git`), les marqueurs du champ n'apparaissent que :

- dans `.dev/session.md` (la demande à l'origine de la présente analyse) ;
- dans des fondations importées, à titre de savoir général : `FND-002` (« les use cases prioritaires comme entrée », section rédigée pour un autre dépôt), `FND-009` (les scénarios comme vue du modèle 4+1), `FND-015` (les niveaux d'exigence métier / parties prenantes) ;
- dans `ANL-011`, qui relève que dans le dépôt `ticket-driven-ai` les use cases relèvent du REQ.

Aucune occurrence dans le harnais opérationnel, dans les skills, dans les ADR, dans les SPEC, dans les REQ ni dans le code. **Le vocabulaire du cas d'usage est absent du système lui-même** ; il n'existe que dans le savoir importé.

## Typologie des utilisateurs et des parties prenantes

La typologie ci-dessous applique la distinction de `FND-018` (section 4.1) entre acteur principal (celui dont le but déclenche l'interaction), acteur secondaire (sollicité par le système pour atteindre le but) et partie prenante hors scène (intérêt légitime sans interaction directe). Elle est **proposée** par la présente analyse : elle n'existe nulle part dans le dépôt.

### Acteurs primaires

| Acteur | Rôle | Buts principaux | Interface d'accès |
|---|---|---|---|
| **A1. Opérateur du dépôt** (l'humain qui travaille dans un dépôt déjà équipé) | dirige le travail, arbitre, opère l'irréversible | ouvrir et fermer une session ; soumettre un problème ; objecter à un plan ; inspecter l'état du système ; publier une version métier | `clia` (CLI), `.dev/session.md` (fichier), git |
| **A2. Agent IA** | produit les livrables porteurs de jugement | lire la demande et le harnais ; produire plan, fondation, analyse, ADR, code ; journaliser | lecture du dépôt, commandes d'inspection de `clia` en lecture seule |
| **A3. Installateur** (l'humain qui équipe un dépôt neuf ou existant) | met en place ou fait évoluer le système d'augmentation | installer `clia` dans un dépôt ; mettre à niveau les ressources ; revenir en arrière ; vérifier l'état d'installation | `setup.sh`, `clia setup` (en conception, `ADR-010`) |
| **A4. Mainteneur du système d'augmentation** | fait évoluer le harnais, `clia` et les documents de conception | ajouter un type de ressource ; modifier une convention ; corriger un bogue de conformité ; versionner une ressource | édition des ressources, `clia`, tests |

Note : A1, A3 et A4 sont aujourd'hui **la même personne**. Les distinguer reste nécessaire, parce que leurs buts, leurs préconditions et leurs modes d'échec diffèrent, et parce que la finalité déclarée du dépôt (fournir un cadre installable dans d'autres dépôts) implique qu'ils se sépareront.

### Acteurs secondaires

| Acteur | Rôle | Sollicité pour |
|---|---|---|
| **A5. Système de fichiers du dépôt** | support de l'état | lecture et écriture des sessions, des ressources, de `version.yaml` |
| **A6. Dépendances externes** (`yq`, `bash`, `git` opéré par l'humain) | services techniques | lecture de la source documentaire, exécution, versionnage |

### Parties prenantes hors scène

| Partie prenante | Intérêt |
|---|---|
| **P1. Destinataire des livrables métier** (client, lecteur du contenu produit dans le dépôt équipé) | la qualité et la traçabilité des livrables produits sous le régime du harnais |
| **P2. Collaborateur futur** (humain rejoignant un dépôt équipé) | comprendre le système sans son auteur ; découvrabilité et documentation |
| **P3. Éditeur du modèle d'agent** (contraintes de la plateforme d'agent) | compatibilité du harnais avec les conventions de l'outil d'agent |
| **P4. L'entreprise** (le studio qui finance) | réutilisabilité inter-dépôts, coût d'appropriation, différenciation |

Cette typologie fait apparaître un déséquilibre : le corpus documente abondamment les besoins de A4 (le mainteneur du système) et, dans une moindre mesure, de A2 (l'agent, via le harnais). Il ne documente **pas** les besoins de A1 (l'opérateur au quotidien) ni de A3 (l'installateur), qui sont pourtant les acteurs des deux livrables attendus de la session en cours.

## Constats

**C1. Aucune ressource ne décrit un usage.** La couche type (`.dev/resource-types.yaml`) déclare dix types livrables (`FND`, `ANL`, `ADR`, `PDC`, `SPEC`, `REQ`, `BUG`, `PLN`, `skl`, harnais). Aucun ne porte la description d'un but d'acteur. La chaîne de conception commence à l'exigence (`REQ`), c'est-à-dire, dans le vocabulaire de `FND-015` et de la norme 29148, au niveau **système** : le niveau des **exigences de parties prenantes** (StRS) est absent. Le besoin n'entre donc dans le système que par `.dev/session.md`, qui est une trace éphémère en édition humaine, non versionnée comme ressource et archivée sans index d'usages.

**C2. La typologie des acteurs est implicite et partielle.** `ARCHITECTURE.md` nomme trois rôles (humain, agent IA, `clia`), mais c'est une répartition de **responsabilités de gouvernance**, pas une typologie d'acteurs au sens du cas d'usage : `clia` y figure comme acteur alors qu'il est le **système** décrit ; l'installateur, le collaborateur futur et le destinataire des livrables n'y figurent pas. Conséquence directe : aucune exigence de `REQ-002` ne nomme le bénéficiaire de la capacité exigée.

**C3. Les exigences décrivent des commandes, pas des buts.** `REQ-002` est structuré par surface d'interface (généralités, ressources, sessions) et chaque exigence porte sur une invocation. Formulé selon `FND-018` (section 9, anti-motif « décomposition fonctionnelle déguisée »), le corpus décrit le système **par ses fonctions**, jamais **par les buts qu'il permet d'atteindre**. Un exemple mesurable : « ouvrir une session de travail » est un but de niveau utilisateur (au sens de Cockburn) qui traverse `ses status`, `ses plan`, `ses open` et `ses check` ; aucun document ne le décrit comme un parcours unique.

**C4. Les flux d'échec sont couverts en exigence, pas en parcours.** À l'inverse d'un manque, il faut relever un point fort : `REQ-002-NF4` et `SPEC-002` traitent explicitement l'échec sans effet de bord, et les codes de retour (0, 1, 2) sont spécifiés uniformément. La matière des flux alternatifs **existe**. Ce qui manque est leur rattachement à un parcours : on sait que `ses open` échoue en code 1 si une session est active, mais aucun document ne dit ce que l'acteur fait alors, ni quel est son parcours de récupération.

**C5. La traçabilité est unidirectionnelle et s'arrête avant le test.** `SPEC-002` porte une table « Traçabilité » (élément spécifié vers requis satisfait) : c'est une bonne pratique effective, conforme à `PDC-009`. Mais la chaîne s'arrête là. Il n'existe :
- aucun lien amont (aucune exigence ne se rattache à un usage ni à un acteur) ;
- aucun lien aval (aucun test ne référence l'exigence qu'il vérifie, à la seule exception du commentaire d'en-tête de `test/test_clia.sh` citant `REQ-001-F9`).

Mesuré par les deux indicateurs de `FND-018` (section 8.4) : **couverture avant** (chaque besoin conduit-il à au moins un test ?) inconnue faute de besoins formalisés ; **couverture arrière** (chaque test se rattache-t-il à un besoin ?) de 1 sur 8 assertions.

**C6. La vérification ne couvre pas le cœur fonctionnel.** Les 8 assertions de `test/test_clia.sh` couvrent `release`, commande périphérique, et laissent entièrement non testé le groupe `ses`, qui est la fonction déclarée du système. Or `FND-018` (section 8.5) relève que pour un CLI le test d'acceptation est le niveau **le moins coûteux** : le contrat observable (arguments, sortie standard, sortie d'erreur, code de retour, effets sur le système de fichiers) est directement scriptable, et le dépôt possède déjà le motif de bac à sable isolé (`mktemp -d`, copie de `src/`, `trap` de nettoyage) qui rend cette extension mécanique. L'écart n'est donc pas d'ordre technique mais d'ordre méthodologique : **rien ne dit quels parcours doivent être testés**, donc rien n'oriente l'écriture des tests.

**C7. La documentation utilisateur ne documente pas ce dépôt.** `doc/cli/README.md` et `doc/cli/format-contenu.md` décrivent un outil de **génération de PDF de présentation** (`scripts/dev.sh`, LuaLaTeX, Beamer, modèles de diapositive), vestige d'un dépôt d'origine. `doc/` est classé en co-édition par `CONSTITUTION.md` et référencé comme zone dans `.dev/resource-types.yaml`. Le seul endroit du dépôt destiné à l'utilisateur final décrit donc un système qui n'existe pas ici. C'est l'anti-motif « documentation périmée » de `FND-018` (section 9) sous sa forme la plus sévère, et une violation directe de `PDC-006` (source de vérité unique) et `PDC-007` (découvrabilité). Ce point relève d'un rapport de bogue (`skl-013`), hors périmètre de la présente analyse.

**C8. Le besoin exprimé se perd à la clôture de session.** Les deux livrables attendus de la session courante sont formulés comme des capacités d'acteur (« créer un nouveau repo git et l'initialiser », « update/rollback les ressources `clia` dans un repo existant »). Ils traversent ensuite cinq plans (`PLN-012`, `PLN-013`, `PLN-014`, `PLN-015`, `PLN-016`) et un ADR (`ADR-010`) qui les traduisent en décisions et en tâches, mais **aucun artefact durable ne conserve leur énoncé en tant qu'usages**. À la clôture de la session, l'énoncé part dans `.dev/sessions/SES-*` (trace immuable, non indexée par usage) et le système perd la trace de ce que l'utilisateur voulait faire. Le plan est éphémère par nature (il est consommé par son exécution) ; l'usage, lui, devrait survivre au plan.

**C9. Le contexte agent renforce le besoin, il ne l'atténue pas.** `FND-018` (section 7.3) relève que le retour du développement dirigé par la spécification rend les formes structurées plus critiques : l'agent ne participe pas à la conversation d'équipe qui donnait leur sens aux formes conversationnelles. Ce dépôt en est un cas limite : `PDC-004` pose que l'interface de travail est **des fichiers, pas la conversation**. Le principe qui fonde le dépôt est donc exactement celui qui rend la user story inadaptée et le cas d'utilisation écrit nécessaire. Le corpus applique ce principe à la gouvernance, aux décisions et aux plans, mais pas au besoin lui-même, qui reste le seul maillon confié à un fichier éphémère.

## Confrontation à la référence

Application de la grille (section « Périmètre et méthode ») au corpus, mesurée contre `FND-018`.

| Dimension | Attendu (FND-018) | Constaté | Écart |
|---|---|---|---|
| D1. Acteurs | catalogue explicite d'acteurs (rôles) et de parties prenantes | 3 rôles de gouvernance dans `ARCHITECTURE.md`, dont un est le système lui-même | **majeur** : pas de catalogue d'acteurs ; installateur et collaborateur absents |
| D2. Description d'usage | forme durable décrivant un but d'acteur de bout en bout | aucune ; l'usage vit dans `session.md` (éphémère) | **majeur** : maillon absent de la chaîne |
| D3. Altitude | unité de description au niveau « but utilisateur » | `ARCHITECTURE.md` au niveau résumé ; `REQ`/`SPEC` au niveau sous-fonction | **majeur** : le niveau de la mer, seul niveau utile, n'est couvert par rien |
| D4. Flux d'échec | déroulés alternatifs et d'erreur décrits par parcours | conditions d'échec spécifiées par commande (`REQ-002-NF4`, `SPEC-002`) | **mineur** : matière présente, non organisée en parcours |
| D5. Traçabilité | bidirectionnelle, du besoin au test | `SPEC` vers `REQ` seulement ; couverture arrière 1/8 | **majeur** : chaîne ouverte aux deux extrémités |
| D6. Vérification | un test d'acceptation par usage principal | 8 assertions, aucune sur le cycle de vie des sessions | **majeur** : le cœur fonctionnel n'est pas vérifié |

**Anti-motifs de `FND-018` (section 9) présents dans le corpus** : décomposition fonctionnelle déguisée (C3) ; documentation périmée, forme sévère (C7) ; traçabilité à sens unique (C5). **Anti-motifs absents** : chemin heureux seul (les cas d'erreur sont spécifiés, C4) ; gabarit rituel ; story orpheline (le dépôt n'emploie pas de user stories).

**Point de conformité notable** : le dépôt satisfait déjà, par d'autres voies, deux des huit bonnes pratiques de `FND-018` : la description au niveau de la boîte noire (`SPEC-002` décrit l'interface observable, jamais l'implémentation) et le détail en proportion inverse de l'éloignement (les plans détaillent le proche). L'écart est donc **localisé** : il porte sur l'amont de la chaîne (l'usage et l'acteur) et sur son aval (le test rattaché), pas sur son milieu, qui est solide.

## Synthèse et recommandations

### Ce qu'il faut retenir

Le système `clia` possède une chaîne de conception rigoureuse (`ADR` vers `REQ` vers `SPEC` vers code, avec table de traçabilité et versionnage atomique) mais **amputée à ses deux extrémités** : rien en amont ne dit qui veut quoi et pourquoi, rien en aval ne démontre que le système le permet effectivement. Ces deux manques sont le même manque : sans usage nommé, on ne sait pas quoi tester ; sans test rattaché, l'usage nommé ne prouve rien. Le diagnostic de l'humain (« il n'y a aucun mécanisme de description et de test explicite des cas d'usage principaux ») est confirmé et se précise : ce n'est pas une lacune documentaire, c'est un **maillon manquant de la couche type**, dont la conséquence mesurable est que le cœur fonctionnel du CLI (le cycle de vie des sessions) n'est couvert par aucun test.

### Recommandations priorisées

**R1 (priorité 1). Créer le type de ressource livrable `USE` (cas d'usage).**

Justification : c'est le maillon manquant identifié en C1 et D2. Un type nouveau se justifie plutôt qu'une extension de `REQ` parce que les deux répondent à des questions distinctes (`FND-015`, `FND-018` section 10.6) : le `USE` dit *qui veut quoi et pourquoi*, le `REQ` dit *ce que le système doit garantir*. Les fusionner reproduirait la confusion relevée dans `ticket-driven-ai` par `ANL-011`.

Production attendue (hors périmètre de la présente analyse, à planifier) :
- un **ADR** définissant le type, sa place dans la chaîne, sa relation aux autres ressources et le catalogue d'acteurs ;
- un **skill** `skl-<SEQ>-cas-d-usage` encadrant sa production (au sens de `skl-001`) ;
- l'entrée `use` dans `.dev/resource-types.yaml` (prefix `USE`, emplacement `.dev/usages`, nommage séquencé, édition `co`) et la ligne correspondante dans la table des livrables de `CLAUDE.md`, qui en est une vue (`PDC-006`) ;
- les relations typées nécessaires dans le vocabulaire de `resource-types.yaml` (voir R4).

**R2 (priorité 1). Adopter le gabarit « but utilisateur » de Cockburn, format court par défaut.**

Justification : D3 montre que le niveau utile n'est couvert par rien. Le format doit être assez léger pour ne pas devenir un coût (l'anti-motif reproché aux cas d'utilisation, `FND-018` section 6) et assez structuré pour être exploitable par un agent qui ne participe à aucune conversation (C9).

Structure proposée :

```
frontmatter : type: usage, version, title, date, status
- Acteur principal : <un rôle du catalogue>
- Niveau : <résumé | but utilisateur | sous-fonction>
- Portée : <le système considéré comme boîte noire>
- Parties prenantes et intérêts : <liste>
- Préconditions : <état requis avant>
- Garantie de succès : <état après en cas de succès>
- Garantie minimale : <ce qui est vrai même en cas d'échec>

## Flux nominal
1. ... (étapes numérotées, verbe à l'acteur ou au système)

## Flux alternatifs et d'échec
1a. <condition> : <déroulé, issue, code de retour attendu>

## Critères d'acceptation
- <Given / When / Then, ou forme équivalente directement scriptable>

## Traçabilité
- Exigences : REQ-... | Spécifications : SPEC-... | Tests : test/...
```

Deux règles d'usage à graver dans le skill : titre en **verbe à l'infinitif orienté but de l'acteur** (« Ouvrir une session de travail », jamais « Commande ses open ») ; et **interdiction du niveau sous-fonction** comme unité de fichier, pour prévenir l'anti-motif de décomposition fonctionnelle (C3).

**R3 (priorité 1). Établir un catalogue d'acteurs et de parties prenantes.**

Justification : C2 et D1. Sans acteurs nommés, les `USE` dériveront vers la fonction. La typologie de la présente analyse (A1 à A6, P1 à P4) fournit un point de départ. Deux décisions de conception à trancher dans l'ADR de R1 : (a) le catalogue vit-il dans l'ADR lui-même, dans `ARCHITECTURE.md` (qui porte déjà « Acteurs et rôles ») ou dans un `USE-000` d'index ? ; (b) corriger la confusion actuelle de `ARCHITECTURE.md`, qui range `clia` parmi les acteurs alors qu'il est le système décrit. Recommandation : catalogue dans l'ADR, `ARCHITECTURE.md` renvoyant vers lui plutôt que le dupliquant (`PDC-006`).

**R4 (priorité 2). Fermer la chaîne de traçabilité aux deux extrémités.**

Justification : C5, D5. Trois ajouts, chacun mécaniquement vérifiable :

- **amont** : chaque `REQ` déclare le ou les `USE` qu'il sert (relation `derive-de` ou nouvelle relation `sert`) ;
- **aval** : chaque `USE` déclare le ou les tests qui le démontrent, et réciproquement chaque test nomme le `USE` couvert ;
- **contrôle** : `clia` gagne la capacité de mesurer les deux couvertures de `FND-018` (section 8.4) : usage sans test, test sans usage. Une référence pendante étant déjà un bogue par `ADR-003`, ce contrôle est cohérent avec l'existant et relève de `PDC-001` (déterminisme) et `PDC-002` (automatiser ce qui n'exige pas de jugement).

**R5 (priorité 2). Dériver les tests d'acceptation des `USE`, en commençant par le cycle de vie des sessions.**

Justification : C6, D6. C'est la recommandation au rapport coût / bénéfice le plus élevé : le motif de bac à sable existe déjà dans `test/test_clia.sh`, le contrat observable d'un CLI est trivialement scriptable (`FND-018` section 8.5), et le cœur fonctionnel est aujourd'hui non vérifié. Ordre suggéré : (1) `USE` du parcours de session (`plan`, `open`, `check`, `status`, `close`, `new`, avec leurs échecs), (2) `USE` du parcours d'installation (`setup.sh`, puis `clia setup` quand il existera, voir `ADR-010`), (3) `USE` du parcours d'inspection (`res ls`, `--version`, `--config`, `--man`).

Sur l'outillage : `bats-core` et `shellspec` (`FND-018` section 8.5) sont les cadres établis, mais ajouter une dépendance externe se heurte à la sobriété actuelle du dépôt (`bash` et `yq`). Le script maison existant suffit à court terme ; la technique du fichier de référence (*golden file*) est en revanche directement applicable aux sorties d'aide (`clia -h`, `--man`), volumineuses et devant rester stables. Décision à trancher hors de cette analyse.

**R6 (priorité 3). Constituer le catalogue initial des `USE` à partir de l'existant, pas d'une page blanche.**

La matière est déjà là et n'attend qu'à être réorganisée par but : les deux livrables attendus de `.dev/session.md` (C8), le « Flux principal » d'`ARCHITECTURE.md`, les transitions d'`ADR-006`, les modes d'installation d'`ADR-010`, et les conditions d'échec déjà spécifiées dans `SPEC-002` (C4). Estimation : de six à dix `USE` de niveau « but utilisateur » couvrent la totalité du système actuel.

**R7 (priorité 3). Décider du sort des ressources éphémères au regard des `USE`.**

Le `PLN` reste éphémère (consommé par son exécution) et le `USE` devient durable. Il faut expliciter dans l'ADR de R1 que le plan **réalise** un ou plusieurs `USE` et le déclare, afin que le besoin cesse de se perdre à la clôture de session (C8). Cela n'ajoute aucune charge : c'est un champ de frontmatter dans le plan.

### Ce que la présente analyse ne recommande pas

- **Pas de user stories.** `FND-018` (sections 5 et 6) et `PDC-004` convergent : la user story est un jeton de conversation, et ce dépôt a fait le choix explicite de ne pas travailler par conversation. Le gabarit « en tant que ... je veux ... » appliqué ici produirait l'anti-motif du gabarit rituel.
- **Pas de Gherkin ni de cadre BDD complet** à ce stade. Le format Given/When/Then reste utile comme **notation des critères d'acceptation** dans le `USE`, sans imposer `cucumber` ni le vocabulaire BDD : le bénéfice de la documentation vivante s'obtient ici en rattachant le critère au test bash correspondant.
- **Pas de fusion `USE` dans `REQ`.** Voir R1.
- **Pas de correction de `doc/cli/`** dans le cadre de cette analyse : le constat C7 relève d'un rapport de bogue distinct (`skl-013`, `ADR-003`).

## Portée et péremption

- **Couverture** : intégralité du dépôt à la date du 2026-07-28, à l'exception des traces (`.dev/logs/`, `.dev/sessions/`) consultées ponctuellement et non évaluées, et de `.dev/session.md` (lu, non évalué, édition humaine).
- **Limites** : l'analyse porte sur les artefacts, pas sur les pratiques réelles non documentées ; la typologie d'acteurs est **proposée** et non validée par l'humain ; le chiffrage de la couverture arrière (1 sur 8) est mécanique et n'exprime pas la valeur des tests existants. La formulation exacte du gabarit `USE` (R2) est indicative et relève de l'ADR et du skill à produire.
- **Péremption** : les constats structurels (C1, C2, C3, C5, C9) restent valides tant que la couche type ne comporte pas de ressource d'usage. Les constats quantifiés (C6, D5, D6) se périment dès la première extension de `test/`. Le constat C7 se périme dès correction de `doc/`. `ADR-010` étant au statut proposé, la partie installation de R5 est à revalider après validation de cet ADR.
