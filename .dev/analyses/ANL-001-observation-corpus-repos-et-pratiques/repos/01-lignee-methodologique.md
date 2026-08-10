---
type: analyse
id: ANL-01-lignee-methodologique
title: "Les dépôts porteurs du système d'augmentation"
version: 0.1.0
status: draft
date: 2026-08-09
sujet: "Les dépôts qui portent le système"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Les dépôts porteurs du système d'augmentation

> Vingt-deux dépôts construisent le système lui-même, plutôt que de l'utiliser. Ils forment quatre lignées qui se recoupent : la donnée comme ressource, l'outillage CLI, la discipline par tickets, la gouvernance par intention et objection.

## Vue chronologique

| Période | Dépôt moteur | Apport au système |
|---|---|---|
| 2025-07 à 2026-03 | `specruptiva` | La donnée typée et validée comme objet premier |
| 2026-03 à 2026-04 | `nty` | Ontologie et indexation, architecture hexagonale |
| 2026-03 à 2026-06 | `nou-methodologies-ia` | Naissance de la discipline ticket, skills, ADR |
| 2026-05 | `comm-cli` | Modèle de ressources, relations, cycle de vie |
| 2026-06 à 2026-07 | `ticket-driven-ai` | Consolidation canonique, CLI `tda`, harness-files |
| 2026-07 | `intentional-doers-governance` | Trois ingrédients, gouvernance objection-sociocratique |
| 2026-07 à 2026-08 | `clia` | Unification des deux lignées, couche type |
| 2026-08 | `micrologic-clients` | Couche type instanciée, ressource de type ressource, OKF |

## Lignée 1 : la donnée comme ressource

### la-isla-disruptiva/specruptiva

52 commits, 2025-07-09 au 2026-03-18, 29 fichiers, Go, remote `La-Isla-Disruptiva/specruptiva`.

Application Go en architecture hexagonale (`pkg/core/domain`, `pkg/core/port`, `adapters/{cli,cue,http,sqlite}`, `cmd/{api,cli,server,wasm}`) qui gère des données structurées validées par des schémas CUE, avec persistance SQLite et cible WASM. Le README la présente comme un moyen de reprendre le contrôle de ses données, de leur cycle de vie, de leur partage et de leur persistance.

C'est le premier point d'ancrage du corpus dans l'idée qu'un système doit manipuler des objets typés dont la forme est vérifiable mécaniquement. Le vocabulaire de `clia` (type, cycle de vie, validation) descend de là, mais sans le mécanisme : CUE validait, `clia` ne valide pas.

**Analyse critique.** Le dépôt est abandonné à mi-parcours : neuf mois d'activité pour vingt-neuf fichiers, un `data.db` commité, un `README` qui vend un produit que le code n'atteint pas. Les quatre points d'entrée (`api`, `cli`, `server`, `wasm`) pour un domaine aussi mince révèlent une exploration de surface architecturale plutôt qu'une construction. La leçon utile, elle, a été retenue et transposée. La leçon perdue est la validation mécanique : c'est précisément ce qui manque le plus au système actuel, et ce dépôt en avait la démonstration fonctionnelle.

### disruptiva-dev/nty

14 commits, 2026-03-27 au 2026-04-08, 47 fichiers, Go, sans remote, 8 fichiers non commités.

CLI Go en architecture hexagonale pour la gestion ontologique et l'indexation de données. Introduit la notion de `phore` (unité indexable) et d'assignation ontologique, avec validateurs. La structure du dépôt est parlante : `.dev/améliorations/{en-cours,todo}/` numérotés, `.impl/use-cases/` détaillés avant le code.

Premier endroit du corpus où l'ontologie devient une ressource de première classe, et non un commentaire. La ressource `ONT` de `clia` et de `micrologic-clients` vient de cette intuition.

**Analyse critique.** Douze jours d'existence. Le répertoire `.impl/` documente quatre cas d'usage pour un `internal/domain` qui en couvre à peine un. Le fichier `nty.db` et le binaire `nty` sont dans le dépôt. Le pattern `.dev/améliorations/en-cours` contre `todo` est un embryon de gestion du travail qui préfigure la question des issues que `clia` n'a toujours pas tranchée quinze mois plus tard : ce dépôt avait déjà répondu de la manière la plus simple possible, et la réponse a été oubliée plutôt que rejetée.

### disruptiva-dev/comm-cli

9 commits, 2026-05-01 au 2026-05-02, 22 fichiers, uniquement du markdown, sans remote, 11 fichiers non commités.

Aucun code. Un système de communication entièrement spécifié : `CONSTITUTION.md` de 230 lignes qui pose la centralité de la donnée et une hiérarchie stricte à trois niveaux, trois ADR numérotés `0001` à `0003` dont le premier porte sur le modèle de ressources, les relations et le cycle de vie, neuf spécifications de ressources préfixées `RS-` et classées par nature (`contextual`, `strategic`, `tactic`, `operational`, `stylistic`), trois essais de fondation dont une lecture bourdieusienne de l'audience, et sept fiches d'amélioration numérotées.

C'est le chaînon manquant entre `specruptiva` et `clia`. Le trio ressource, relation, cycle de vie que `RES-001` fixera en août 2026 est déjà décidé ici en mai, dans `doc/adr/0001`.

**Analyse critique.** Deux jours de travail pour un système complet sur le papier, jamais implémenté, jamais poussé. C'est le mode de défaillance le plus caractéristique du corpus : la conception va plus vite que la réalisation et la conception seule suffit à décharger la tension. Le `CONSTITUTION.md` utilise des filets `---` comme séparateurs de section et des apostrophes typographiques, ce que le harnais actuel interdit : preuve que les règles de forme sont postérieures et n'ont jamais été rétro-appliquées. La classification à cinq natures des ressources (`contextual`, `strategic`, `tactic`, `operational`, `stylistic`) est plus riche que tout ce que `clia` propose aujourd'hui et mérite d'être reprise dans la réflexion sur les ressources fondamentales.

### disruptiva-dev/cli-based-enterprise

Zéro commit, trois fichiers sur le disque, sans remote.

Un `README` de treize lignes qui pose une thèse : niveau zéro, toutes les données de l'entreprise doivent être accessibles en lecture via un CLI. Et une convention de répertoires : `dev/` pour l'input du développement augmenté par IA, `specs/` pour les fonctionnalités, `reqs/` pour les requis techniques et non fonctionnels, `clis/` pour les exécutables.

C'est le manifeste du groupe `cli-based-organization` tout entier, écrit avant lui. La séparation `dev` contre `specs` contre `reqs` est l'ancêtre direct des zones de `clia`.

**Analyse critique.** Jamais commité, donc daté seulement par le mtime du système de fichiers. Un manifeste de cette portée qui n'existe que sur un disque local est une perte de mémoire en attente. Trois répertoires sur quatre sont vides. La thèse elle-même n'a jamais été confrontée : aucun dépôt du corpus n'expose ses données par CLI en lecture, `clia` inclus, alors que `clia ls` en serait exactement l'instrument.

### la-isla-disruptiva/airu

Zéro commit, 17 fichiers sur le disque, sans remote.

Approche spec-driven pour le développement IA à grande échelle, implémentée par des gabarits, des spécifications markdown et des scripts bash, explicitement inspirée du Spec Kit de Microsoft. Statut déclaré expérimental.

Seul point du corpus où une approche externe est nommée comme source. Le reste du système est construit sans référence bibliographique explicite dans ses harnais, ce qui contraste avec les essais de fondation, qui, eux, citent.

**Analyse critique.** Jamais commité malgré dix-sept fichiers. C'est la seule tentative d'aligner la pratique locale sur un cadre publié et reconnu, et c'est celle qui a été abandonnée le plus vite. Le corpus réinvente ensuite, en douze mois, une bonne part de ce que le spec-driven propose déjà. Le coût de cette réinvention n'a jamais été évalué.

## Lignée 2 : l'outillage CLI

### disruptiva-dev/devops-cli

4 commits, 2026-06-05, 46 fichiers, `CLAUDE.md` et `.claude/`, sans remote.

CLI shell bash qui organise des scripts en `topics`, avec tests `bats` et journal. Vise l'amélioration de la productivité DevOps dans n'importe quel environnement.

### noumanity/devops-cli

28 commits, 2026-11-17 selon git, 17 fichiers, `.taskrc` et fichiers `.data`, sans remote.

Version antérieure de la même idée, avec deux principes énoncés : agnosticisme technologique et zéro trace dans le projet cible.

**Analyse critique des deux.** Deux dépôts homonymes portant la même intention, l'un ignorant l'autre, aucun des deux publié, aucun des deux archivé. Le principe zéro trace dans le projet du second est directement contredit par la pratique ultérieure : `clia` pose `.dev/` dans chaque dépôt équipé. Ce renversement n'est acté nulle part, alors qu'il est structurant. Le format `.taskrc` et les fichiers `.data` du premier montrent qu'un état machine séparé du markdown avait été essayé puis abandonné sans bilan écrit.

### cli-based-organization/linux-inspect

7 commits, 2026-06-20 au 2026-06-21, 22 fichiers, harnais complet, remote `cli-based-organization/linux-inspect`.

Outils bash d'inspection de systèmes Linux, une seule commande livrée (`find-repos`). Son `INTENTION.md` est le document le plus abouti du corpus sur la philosophie d'installation d'un CLI : quatre principes directeurs nommés (universalité, adaptabilité, non-intrusivité, réflexivité) et une doctrine d'accès à trois régimes, oneliner éphémère, mode développement à chargement direct, installation permanente explicite.

C'est la source du `setup.sh` de `clia` et de son mode dev. La réflexivité, entendue comme la capacité de l'outil à exposer sa propre version et ses commandes, est un principe que `clia` applique sans l'avoir nommé.

**Analyse critique.** Deux jours d'activité pour une seule commande utile, et cette commande est justement celle qui aurait servi à produire la présente analyse. Le décalage entre l'ampleur du document d'intention, quatre principes et une doctrine d'installation, et le livrable, un script de recherche de dépôts, est frappant. Les quatre principes n'ont jamais été promus au rang de principes de conception du système, alors qu'ils sont plus opérationnels que la plupart des `PDC` de `clia`.

### archive/cli-based-organisation_git-resource

7 commits, 2026-06-21, 23 fichiers, harnais complet plus `skills/` et `.tda/state-registry`, sans remote.

CLI qui traite un dépôt git comme une ressource cohérente et instrumentable : fusion écrasée, sauvegarde, vérification d'état. Porte trace du CLI `tda` par son `.tda/state-registry` et l'organisation en `.dev/tickets/TKT-001-.../` avec huit tâches numérotées.

**Analyse critique.** Archivé après une seule journée de travail, mais c'est l'un des rares dépôts du corpus où un ticket complet a été mené de la tâche 01 à la tâche 08 puis clos. Le sujet, traiter git comme une ressource, reste ouvert et pertinent : le harnais actuel de `clia` interdit à l'agent toute opération git, ce qui referme la question plutôt que de la résoudre. Ce dépôt tentait l'inverse et personne n'a écrit pourquoi la première approche a été préférée.

### cli-based-organization/INTENTION, linux-cli-interface, raar

Trois dépôts à zéro commit. `INTENTION` et `raar` sont vides, `linux-cli-interface` contient un seul script, `docker-reinstall.sh`. Tous trois ont un remote configuré sous `cli-based-organization`.

**Analyse critique.** Des remotes créés pour des dépôts sans contenu. Le nom `INTENTION` répété à trois endroits du corpus (`cli-based-organization/INTENTION`, `noumanity-dev/INTENTION`, `noumanity-formation/INTENTION`), toujours vide, suggère une intention de dépôt partagé d'intentions, jamais réalisée. Ces coquilles polluent l'inventaire et devraient être supprimées ou remplies.

## Lignée 3 : la discipline par tickets

### noumanity-ai-assisted-development-toolkit/nou-methodologies-ia

51 commits, 2026-03-14 au 2026-06-14, 220 fichiers, remote `noumanity/nou-ai-methodology`, 27 fichiers non commités.

Le laboratoire. Tout vit sous `experimentations/deeptech-ticket-driven/` : trois ADR (méthodologie des tickets, extreme-smart, catalogue des livrables), douze issues `ISU-001` à `ISU-012`, des tickets `TKT-001` avec tâches numérotées, dix skills `skl-001` à `skl-012` dont cinq consacrés aux fichiers de harnais eux-mêmes (`harness-file`, `-governance`, `-skills`, `-behavior`, `-intention`), trois spécifications, un fichier `allowed-deliverable`, un `.deeptech/status-registry`, tests `bats`.

C'est ici que naissent les concepts durables : le ticket extreme-smart, l'issue non-smart, le livrable comme point focal, le skill comme spécification vivante d'un type de livrable, et l'idée que le harnais lui-même est un livrable typé encadré par un skill.

**Analyse critique.** Le dépôt le plus fécond du corpus, et le plus mal rangé : tout le travail réel est enfoui trois niveaux sous `experimentations/`, ce qui rend le contenu invisible depuis la racine. Trois mois d'activité intense se terminent sans clôture explicite ; vingt-sept fichiers restent non commités depuis juin. Le remote porte un nom (`nou-ai-methodology`) qui ne correspond ni au répertoire local, ni au groupe, ce qui casse la traçabilité. Le fait que cinq skills sur douze portent sur la production du harnais lui-même est le premier signe d'un système qui consacre une part importante de son énergie à se décrire.

### noumanity-ai-assisted-development-toolkit/nou-scripts-ia-support

Zéro commit, 30 fichiers sur le disque, `INTENTION.md`, `ARCHITECTURE.md`, `CONSTITUTION.md`, `README.md`, sans remote.

CLI Go avec sous-commandes `adr`, `ia init`, `implementation`, `testit`, un `internal/resource/resource.go`, un `.nou.yaml`, et un `doc/` à huit répertoires prêts à recevoir (`adr`, `foundation`, `ideas`, `implementations`, `improvements`, `prompts`, `spec`, `technote`). L'`INTENTION.md` est écrit en YAML dans un fichier `.md`, avec `apiVersion: ia.noumanity.com/v1alpha1` et `kind: Intention`.

**Analyse critique.** Le seul endroit du corpus où l'intention est modélisée comme un objet Kubernetes versionné par API. Cette piste, une intention machine-lisible avec schéma versionné, est abandonnée sans trace de décision, alors qu'elle répond directement au problème que `clia` rencontre aujourd'hui : comment un outil peut-il lire l'intention d'un dépôt. Trente fichiers, dont un CLI Go fonctionnel avec un générateur d'ADR, jamais commités : un an de travail de conception y est exposé à une seule commande `rm` malheureuse.

### noumanity-dev/ticket-driven-ai

28 commits, 2026-06-21 au 2026-07-04, 72 fichiers, harnais complet, remote `noumanity-dev/ticket-driven-ai`.

La version canonique de la lignée. `INTENTION.md` structuré en cinq sections qui énonce deux principes fondateurs, l'intention comme moteur de la productivité et la distillation comme principe d'organisation, et deux régimes de travail, l'issue non-smart pour la création et le ticket extreme-smart pour l'ingénierie, borné à un livrable et douze heures. `CONSTITUTION.md` réduit à deux règles seulement, C1 l'agent ne modifie jamais un `ticket.md`, C2 les harness-files sont la vérité permanente. Trois zones, racine pour le permanent, `.dev/` pour l'instable, `doc/` pour le stable. CLI `tda` avec `init`, `upgrade`, `ticket open/close`, `issue`, `save`, `release`, `deliverable`, et une extension optionnelle d'outils de conception (SPC, REQ, skills de livrable). Deux fichiers `BRAINDUMP.md` à la racine.

**Analyse critique.** C'est le point le plus solide que le corpus ait atteint, et il a été délaissé cinq semaines plus tard pour repartir sur `clia`. Aucun document du corpus n'explique ce choix : ni ADR, ni analyse, ni note dans `clia`. Un `CONSTITUTION.md` de deux règles est un modèle de sobriété que `clia` a immédiatement perdu, sa constitution archivée pesant 114 lignes. Les sept ADR de `doc/adr/` comportent des doublons manifestes, `ADR-002` et `ADR-005` portant le même titre, `ADR-003` et `ADR-006` de même, `ADR-004` et `ADR-007` de même : la numérotation séquentielle a dérapé sans que rien ne le détecte. Les deux `BRAINDUMP.md` à la racine contredisent la doctrine des trois zones dans le dépôt qui l'institue.

### noumanity-dev/cli-convention

Zéro commit, 7 fichiers sur le disque, harnais complet plus trois skills, sans remote.

Dépôt initialisé par `tda init` et jamais rempli : `INTENTION.md` encore aux crochets du gabarit, `README.md` renvoyant à la méthodologie, trois skills copiés. Le nom annonce l'intention d'établir une convention de CLI, jamais écrite.

**Analyse critique.** Utile comme témoin : il montre exactement ce que `tda init` posait dans un dépôt neuf, et donc l'empreinte d'installation de la lignée A. Utile aussi comme symptôme : le sujet, une convention de CLI transverse, est un besoin réel du groupe `cli-based-organization`, où chaque CLI (`clia`, `tda`, `devops`, `nty`, `git-resource`) a réinventé sa propre grammaire d'options.

## Lignée 4 : gouvernance par intention et objection

### noumanity-formation/intentional-doers-governance

7 commits, 2026-07-06 au 2026-07-07, 62 fichiers, harnais complet, remote `noumanity-formation/intentional-dooers-governance`.

Le pivot. Dépôt monté pour préparer une conférence, qui devient le prototype de la lignée B. `INTENTION.md` énonce `INT-001`, la règle des trois ingrédients : intention, contexte, spécification du livrable. `CONSTITUTION.md` institue la gouvernance objection-sociocratique. Sept plans `PLN-001` à `PLN-007`, deux fondations dont une sur la viabilité du modèle BDFL de Linux, sept skills dont `skl-004-harnais`, une session archivée, un `source-material/SRCM-001` conservé verbatim, et une chaîne de génération de PDF de présentation en Lua.

Tout le vocabulaire actuel de `clia` naît ici : trois ingrédients, plan de travail, recherche de fondation, harnais comme livrable, objection comme mécanisme de gouvernance, point d'entrée unique par `session.md`.

**Analyse critique.** Le dépôt le plus influent du corpus est un dépôt de formation, produit en deux jours pour une conférence. La méthode a donc été conçue pour être enseignée avant d'avoir été éprouvée sur du travail long, ce qui explique sa qualité d'exposition et sa lourdeur à l'usage. Le remote contient une faute de frappe, `intentional-dooers-governance`, jamais corrigée. La gouvernance objection-sociocratique est posée sans essai de fondation dédié : `PLN-007` prévoit un rapport de recherche sur la thèse de l'objection sociocratique, ce qui signifie que le mécanisme central de la méthode a été adopté avant d'être fondé.

### noumanity-dev/resource-driven-ai

Zéro commit, deux fichiers, sans remote.

Un `INTENTION.md` d'une phrase : concevoir un système de travail augmenté par IA où le livrable est le point focal du travail. Et le gabarit d'`INTENTION.md` vide.

**Analyse critique.** Deux fichiers qui portent le pivot conceptuel le plus important du corpus, du ticket vers la ressource, et qui ne sont pas commités. La phrase est exacte et suffisante ; elle n'a jamais été développée ici, et le travail est parti ailleurs, dans `clia`. Ce dépôt devrait soit devenir le lieu de la théorie de la ressource, soit être supprimé au profit d'une section de `clia` : son existence en l'état crée un troisième candidat au titre de dépôt de référence de la méthode, après `ticket-driven-ai` et `clia`.

### cli-based-organization/clia

21 commits, 2026-07-08 au 2026-08-08, 223 fichiers dont 207 markdown, harnais `CLAUDE.md`, `INTENTION.md`, `ARCHITECTURE.md`, remote `cli-based-organization/clia`.

Le système actuel, et le dépôt depuis lequel cette analyse est produite. Son état au 2026-08-09 est celui d'une reconstruction en cours : le commit `2373ec7` du 2026-08-08, intitulé `drastic refactor: archive almost everything`, a déplacé la quasi-totalité du contenu sous `.dev/archives/`. Ne restent actifs que quatre fichiers, `CLAUDE.md`, `INTENTION.md`, `ARCHITECTURE.md` et `.dev/session.md`, ce dernier réduit à son gabarit vide.

L'état archivé documente l'ampleur de ce qui a été construit en un mois : un `CLAUDE.md` de 153 lignes avec table de douze types de livrables, un `resource-types.yaml` de 200 lignes qui est la première couche type explicite et machine-lisible du corpus, seize skills, treize ADR, des principes de conception `PDC`, un `setup.sh`, des tests `bats`, quarante-quatre logs de sortie IA pour la seule journée du 2026-07-17, et quatre sessions archivées.

Le `CLAUDE.md` actif est un document de transition : il énumère vingt-sept types de ressources répartis en cinq familles (fondamentales, conception, contrôle, préparation, implémentation), chacune annotée d'un triplet `ADR-XXX, RES-XXX, skl-XXX`. La plupart de ces triplets sont des marque-places, `ADR-0` ou `ADR-00`, et seuls les douze premiers portent un numéro plausible. Aucune des ressources annoncées n'existe encore dans le dépôt.

**Analyse critique.** Le `CLAUDE.md` actif prescrit un système qui n'existe pas. Il décrit vingt-sept types de ressources, sept commandes CLI, un mécanisme d'extensions, un espace actif documentaire et une journalisation obligatoire, dans un dépôt qui contient quatre fichiers et aucun exécutable. C'est un harnais-plan et non un harnais-mode-opératoire, ce qui contredit sa propre première ligne. Deux directives sont matériellement inexécutables : le point d'entrée est déclaré à `@workspace/session.md` alors que le fichier historique est `.dev/session.md` et que les deux coexistent désormais sur le disque, et le répertoire de journalisation `.dev/logs/` n'existait pas avant cette session.

La triple annotation `ADR-XXX, RES-XXX, skl-XXX` par type est une décision structurante prise dans un fichier de harnais, sans ADR. Elle impose un coût de trois documents par type ; vingt-sept types signifient quatre-vingt-un documents à produire et à maintenir. Aucune analyse de ce coût n'existe. Le refactor drastique a par ailleurs emporté le `setup.sh` et les tests sous `archives/`, laissant le dépôt sans aucun moyen d'être installé ni vérifié, alors que son `INTENTION.md` promet un cadre de collaboration entre humain, automatismes et agent.

Le point fort reste le `resource-types.yaml` archivé, qui est le meilleur travail de modélisation du corpus, et dont l'en-tête déclare lui-même sa dette : la couche relations machine-lisible n'a jamais été instanciée, donc aucune validation de référence pendante n'est possible.

### noumanity-consultation/micrologic-clients

2 commits, 2026-08-08, 110 fichiers, harnais `CLAUDE.md` et `CONSTITUTION.md`, sans remote, 13 fichiers non commités.

Bien que classé sous consultation, ce dépôt est le plus avancé du corpus sur les ressources fondamentales, et doit être lu comme un dépôt de méthode. Il porte `.dev/ressources/`, un répertoire de quatorze définitions de types, `RES-001` à `RES-014`, dont `RES-001-ressource.md` se prend lui-même pour objet et fixe la forme de toutes les définitions. Il porte aussi quatre objections `OBJ`, une ontologie `ONT-001`, trois méthodologies `MET`, six rapports de bogue, quatre essais de fondation, neuf analyses, et un `ADR-001-compatibilite-okf` qui aligne le dépôt sur le format Open Knowledge Format.

`RES-001` est le document le plus rigoureux du corpus. Il énumère les sept invariants de la notion de ressource dégagés par un essai de fondation, en retient quatre, en écarte trois explicitement, et justifie chaque écart. Il distingue trois sens du mot ressource et les tient séparés. Il fixe trois classes de cycle de vie, point fixe, vivant, travail, et quatre régimes d'édition, humain, ia, hybride, co-édition. Il pose un critère de départage entre définition, ADR et skill sous forme de test pratique. Il se termine par une section `Lacunes` de cinq points, dont l'aveu que la règle d'immuabilité des ressources point fixe est écrite et transgressée.

**Analyse critique.** Le travail conceptuel que la session en cours de `clia` cherche à produire existe déjà ici, à un niveau de maturité que `clia` n'a jamais atteint. Le problème est de localisation : ce travail vit dans un dépôt dont l'`INTENTION.md` est une offre d'emploi d'administrateur système. Un dépôt de candidature porte la théorie des ressources du système entier, avec deux commits et treize fichiers non commités, sans remote. C'est le risque le plus concret que révèle cette observation.

Sur le fond, `RES-001` assume ses écarts de manière exemplaire, mais deux d'entre eux méritent contestation. Renoncer à l'identité stable (invariant I1) au motif que le volume du dépôt le permet est un calcul valable pour un dépôt et faux pour un système destiné à équiper cent soixante dépôts : le coût du renommage y devient prohibitif, et le dépôt lui-même en donne l'illustration avec le passage de `RES` à `DOS` qui a demandé six corrections manuelles. Renoncer à l'interface uniforme (I5) au motif qu'elle supposerait un moteur est une pétition de principe dans un système qui se nomme `clia` et dont l'objet est précisément d'être ce moteur.

### noumanity-dev/abai-deeptech-notebook

2 commits, 2026-06-24, 9 fichiers, `CLAUDE.md` de deux lignes et `INTENTION.md`, sans remote, 8 fichiers non commités.

Méthodologie de recherche DeepTech assistée par IA, à l'état de squelette : trois `.gitkeep`, un `.yaml`, quatre markdown.

**Analyse critique.** Le mot DeepTech est le mot-clé de l'`INTENTION.md` de `clia`, qui affirme fournir nativement des capacités de mobilisation et d'utilisation du savoir. Ce dépôt est le seul endroit du corpus qui prend le DeepTech comme objet méthodologique propre, et il est vide. La spécificité DeepTech revendiquée par `clia` n'est donc adossée à aucun travail : rien dans le corpus ne distingue une capacité de mobilisation du savoir d'une gestion documentaire soignée. C'est une objection à porter à l'`INTENTION.md` de `clia`.

### disruptiva-dev/personal-journal

5 commits, 2026-05-20 au 2026-05-21, 79 fichiers, 43 fichiers Go, harnais le plus complet du corpus avec `CLAUDE.md`, `INTENTION.md`, `ARCHITECTURE.md`, `CONSTITUTION.md`, `README.md`, sans remote.

Système de prise de notes quotidiennes et de collecte de données personnelles, en Go, avec validation CUE, PWA (`webmanifest`), et un dépôt de données séparé, `dev-data/personal-journal-dev-data`, qui contient 29 markdown et 15 logs.

**Analyse critique.** Deux jours de travail, quarante-trois fichiers Go, cinq fichiers de harnais : c'est la démonstration la plus nette de la vélocité que le système procure, et de son absence d'effet sur la persévérance. La séparation entre le dépôt de code et le dépôt de données personnelles est une bonne décision, non documentée, et le dépôt de données n'a qu'un commit sans harnais. Ce dépôt est aussi le seul du corpus à porter simultanément les quatre fichiers de harnais et un `ARCHITECTURE.md` renseigné, ce qui en fait la meilleure référence disponible pour l'`ARCHITECTURE.md` de `clia`, resté à six lignes et un titre.

## Ce que la lignée enseigne

Quatre lectures se dégagent de ces vingt-deux dépôts.

La convergence est réelle. Le vocabulaire s'est stabilisé sur un noyau restreint : intention, contexte, ressource ou livrable, type, cycle de vie, objection, skill, harnais. Ce noyau a survécu à trois réécritures et à cinq groupes de dépôts différents, ce qui est un signe de justesse.

Les décisions de rupture ne sont jamais actées. Trois abandons majeurs, `tda` pour `clia`, l'intention machine-lisible pour l'intention en prose, la validation CUE pour l'absence de validation, ne sont documentés nulle part. Le corpus produit abondamment des ADR sur les questions internes de forme et aucun sur les changements de cap.

Le système consacre une part croissante de son énergie à se décrire. Cinq skills sur douze portaient déjà sur le harnais dans `nou-methodologies-ia`. `clia` prévoit aujourd'hui trois documents par type de ressource pour vingt-sept types. Le rapport entre l'outillage produit et le travail métier accompli se dégrade.

Le meilleur travail est le moins protégé. `RES-001` vit dans un dépôt de candidature sans remote. Le CLI Go de `nou-scripts-ia-support` et le manifeste de `cli-based-enterprise` ne sont pas commités. Quatre-vingt-quatorze dépôts sur cent soixante-six n'ont aucun remote.

## Relations

- `fait-partie-de` [ANL-001](../index.md)
