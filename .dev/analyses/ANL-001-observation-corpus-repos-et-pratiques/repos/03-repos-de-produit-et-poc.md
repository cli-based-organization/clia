---
type: analyse
title: "Les dépôts de produit, de prototype et de code"
version: 0.1.0
status: draft
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Les dépôts de produit, de prototype et de code

> Soixante-deux dépôts antérieurs ou parallèles au système d'augmentation. Aucun ne porte de harnais IA. Ils constituent l'histoire technique dont la méthode actuelle est issue, et ils expliquent pourquoi elle a la forme qu'elle a.

## Portée et calibrage

Ces dépôts ne participent pas à la construction du système. Ils sont décrits ici parce que la tâche demande la couverture de l'ensemble du corpus, et parce que trois de leurs traits ont façonné la méthode : la préférence marquée pour les CLI, l'architecture hexagonale répétée sans nécessité, et l'usage de CUE pour valider des données structurées.

Le traitement est condensé, une ligne de contenu et une ligne de lecture critique par dépôt. Le détail n'apporterait rien à la conception de `clia`.

## NationTech

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `nationtech/harmony` | 651 commits, 2024-08 à 2025-11, 558 fichiers, 306 en Rust. Outil de scaffolding de projet et de provisionnement d'infrastructure | Le plus gros dépôt du corpus, et le seul qui atteint la taille d'un vrai produit. Il montre que l'humain sait mener un développement long. Son abandon en novembre 2025 coïncide avec le creux d'activité du corpus et précède le pivot vers l'IA |
| `nationtech/websites` | 104 commits, 2023-03 à 2025-11, 254 fichiers, Rust et Leptos | Site en Rust compilé vers WASM. Choix technique exigeant pour un site vitrine, révélateur d'une préférence pour la maîtrise complète du stack plutôt que pour l'outil convenu |
| `johnride/nationtech-website` | 93 commits, 2023-03 à 2024-07, 154 fichiers, Rust et Leptos | Version antérieure du même site, sous un autre compte. Deux dépôts pour un site, aucun lien déclaré, celui qui fait foi n'est pas identifiable depuis le disque |
| `nationtech/web-site-content` | 4 commits, 2025-11, quatre fichiers `.ftl` | Séparation du contenu et du code par fichiers de traduction Fluent. Le remote pointe vers `jvtrudel/website-content`, en désaccord avec le groupe local |

## Orignal Bleu Finance

Treize dépôts, 2017 à 2025, autour de la finance et de la prévision de séries temporelles.

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `timeseries-predictor` | 258 commits, 2022-08 à 2024-02, Python, basé sur PatchTST | Travail sérieux et soutenu sur la prévision. Le seul dépôt du corpus qui s'appuie explicitement sur un article de recherche identifié |
| `fx-history-download` | 68 commits, 2017-05 à 2024-02, Python | Fork enrichi d'un outil tiers, avec renvoi au README original. Bonne pratique d'attribution, rare dans le corpus |
| `admin-frontend` | 39 commits, 2023-09 à 2023-10, Qwik, 84 fichiers dont 30 JPG | Trois semaines, un framework de plus, README resté celui du gabarit Qwik |
| `poc-analytic` | 33 commits, 2023-09 à 2023-10 | Analyse de logs nginx par chaîne de commandes unix. Illustration nette du réflexe CLI dès 2023 |
| `infra-automation` | 20 commits, 2023-10, playbooks jetporch | Choix d'un outil marginal plutôt qu'Ansible, jamais justifié par écrit |
| `poc-landing-page`, `-0`, `-2` | 8, 9 et 6 commits, 2023-09 à 2023-10, React, Vite, Qwik | Trois prototypes de la même page en trois piles différentes, en cinq semaines. Aucun ne conclut, aucune comparaison écrite |
| `poc-api` | 5 commits, 2023-09, Python, 13 fichiers | Prototype d'API abandonné après deux jours |
| `logs-persistence` | 4 commits, 2023-09 | Deux fichiers de configuration et un HTML. Sujet ouvert, jamais traité |
| `qr-generator` | 9 commits, 2023-09, deux fichiers | Une page HTML et un renvoi vers une librairie npm |
| `cli-combinerQrLogo` | 2 commits, 2023-09, Python | Utilitaire d'un jour. Nom en casse mixte, unique dans le corpus |
| `orignalbleu/webapp` | 9 commits, 2025-11 à 2025-12, HTML et CSS sans framework | Porte une chaîne conceptuelle intéressante, `Brand` puis `Topology` puis `Flavor` puis `Atoms`, qui est l'ancêtre de `ptyle` et une pensée par niveaux d'abstraction que la méthode actuelle reprend sans le savoir |

**Lecture d'ensemble.** Treize dépôts, dont sept prototypes abandonnés en moins d'un mois. C'est la période où le mode de travail par exploration jetable s'installe. Le système actuel en garde la marque : la notion de dépôt jetable n'y est pas modélisée, alors qu'elle décrit la majorité de la pratique.

## La Isla Disruptiva

Seize dépôts, 2022 à 2025, exploration produit et web.

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `dile-ola` | 73 commits, 2025-08 à 2025-12, JavaScript, 40 PNG. Vidéoconférence ludique | Le produit le plus abouti du groupe. Le remote s'appelle `walk-and-talk`, le répertoire `dile-ola` : deux noms pour un produit, sans note de renommage |
| `ola-ws` | 33 commits, 2025-08 à 2025-12, Go. Serveur de signalisation websocket minimaliste | Composant net, bien délimité, réutilisable. Un des rares du corpus dont la portée est correctement bornée |
| `poc-cue-validated-yaml-editor` | 18 commits, 2025-10 à 2025-12, Go. Éditeur YAML validé par CUE | Ancêtre direct de la couche type de `clia`. Le README est resté au gabarit, avec ses `todo`, dans le dépôt qui portait la brique la plus stratégique du corpus |
| `ptyle` | 19 commits, 2023-11 à 2023-12, TypeScript. Générateur de CSS par topologie de style | La notion de topologie de style est une abstraction propre et originale, jamais reprise |
| `idiomas.lab` | 8 commits, 2024-01 à 2024-02. Expérimentations amont d'une application de langues | Le README énonce une règle rare et saine : tout le code ici sera jeté, ce qui ne dispense pas de le faire correctement. C'est la seule formulation explicite d'une éthique du prototype dans le corpus |
| `ai-explore-naive-text-to-speech` | 19 commits, 2025-09, PWA de synthèse vocale trilingue | Première exploration IA du corpus. Quatre jours, puis arrêt |
| `ola-mapas` | 8 commits, 2025-09. Cartographie, copiée d'une vidéo et d'un CodePen | Sources honnêtement citées dans le README |
| `canvas-exploration` | 3 commits, 2025-09. Jeu sur grille en canvas | Le README est une liste de cases à cocher non cochées. Dix fichiers non commités |
| `kata-clientside-stuctureddata-editor` | 29 commits, 2022-10. Kata sur l'édition de données structurées côté client | Le README est une réflexion de fond sur la donnée structurée comme condition du traitement mécanique. C'est la racine intellectuelle du corpus entier, écrite en 2022. Le nom du dépôt contient une faute de frappe jamais corrigée |
| `kata-p2p-web-app` | 7 commits, 2022-11. Kata sur le pair-à-pair web | Réflexion sur le biais client-serveur de HTTP. Deux jours |
| `explore-component-base-development` | 3 commits, 2022-10 | Comparaison annoncée de trois frameworks, jamais réalisée |
| `manual-de-identidad` | 6 commits, 2022-10, SVG et PDF | Manuel d'identité visuelle. Un des rares livrables du corpus réellement terminé |
| `moodboard` | 2 commits, 2025-12, un fichier `.excalidraw` | Un fichier de diagramme comme dépôt entier |
| `website` | 1 commit, 2025-11, un fichier | Coquille avec remote |
| `.github` | 7 commits, 2022-10. Profil d'organisation | Contient le manifeste de La Isla Disruptiva, en anglais : philosophie pratique pour entrepreneurs du numérique face au changement profond. C'est l'ancêtre du discours DeepTech actuel |
| `ai-ultimate-consulting-replacement` | 1 commit, 2025-11, un fichier | Un guide généré par IA pour remplacer les cabinets de conseil. Titre programmatique, contenu inexistant. À rapprocher de l'intention de `clia` : le remplacement du conseil par le savoir outillé est une idée récurrente jamais travaillée |

**Lecture d'ensemble.** Ce groupe contient les racines conceptuelles du système : la donnée structurée comme condition du traitement mécanique en 2022, la validation par CUE en 2025, la pensée par niveaux d'abstraction. Aucune de ces racines n'est citée dans les documents du système actuel, qui se présente comme neuf.

## Infrastructure

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `noumanity-infra/platform` | 48 commits, 2023-11 à 2025-09, 25 fichiers YAML. Cluster k8s léger et peu coûteux | Déclaré expérimental et maintenu deux ans, ce qui est contradictoire. Le remote pointe vers `datalyse/platform`, encore un désaccord entre groupe local et distant |
| `noumanity/infra` | 19 commits, 2023-11 à 2024-02, 39 fichiers | Même intention, même texte de README, dépôt distinct. Doublon non résolu |
| `noumanity-infra/template-k83` | 14 commits, 2024-02 à 2024-04. Gabarits k8s installables par CLI | Le principe énoncé, utiliser les technos nativement, est la même exigence de non-intrusivité que `linux-inspect` reformulera deux ans plus tard sans le savoir |

## Noumanity, divers

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `noumanity/imagen` | 17 commits, 2022-02 à 2022-06, 66 fichiers dont 27 PNG. Image de marque | Porte un `INTENTION.md`, en 2022. C'est la première occurrence du fichier d'intention dans le corpus, quatre ans avant qu'il devienne la pierre angulaire de la méthode |
| `noumanity/e-wtfpl` | 11 commits, 2023-06 à 2024-02, six markdown. Licence dérivée de la WTFPL | Travail juridique original et terminé. Aucun dépôt du corpus ne déclare l'utiliser, `clia` compris, qui n'a pas de licence |
| `noumanity/information-entreprise-noumanity` | 2 commits, 2024-03, un fichier | Coquille |

## Prototypes disruptiva-dev

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `disks-management` | 2 commits, 2026-05, 37 fichiers dont 19 en Rust. Observation et gestion de disques | Porte un `ARCHITECTURE.md`, un `CONSTITUTION.md` vide de zéro octet, et un fichier `.ssh` dans le dépôt. Le `CONSTITUTION.md` vide est le cas limite de l'installation par copie : le fichier est posé, jamais rempli, et le harnais n'a aucun moyen de le signaler |
| `poc-formulaire-offline-first` | 2 commits, 2026-05, 25 fichiers dont 23 markdown | Porte `INTENTION.md`, `ARCHITECTURE.md`, `CONSTITUTION.md` mais pas de `CLAUDE.md`. L'`INTENTION.md` est en YAML avec `kind: Intention`, comme `nou-scripts-ia-support` : deuxième trace de l'intention machine-lisible abandonnée |
| `deliverable-cli` | Zéro commit, zéro fichier | Le nom désigne le concept central de la méthode, le livrable, et le dépôt est vide. À supprimer ou à devenir le lieu de la question |
| `os-iso-management` | Zéro commit, zéro fichier | Coquille |

## Laboratoires Rust et Go

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `jvtrudel-copilot/leptos-fluent` | 522 commits, 2024-02 à 2025-11, 197 fichiers, remote `mondeja/leptos-fluent` | Clone d'un projet tiers, contribution externe. Seul dépôt du corpus où l'humain travaille dans le code de quelqu'un d'autre, et de loin celui qui a le plus de commits par mois |
| `jvtrudel-copilot/rust_macro` | 2 commits, 2025-11 | Exercice sur les macros Rust, README clair et honnête sur son caractère volontairement non conventionnel |
| `jvtrudel-copilot/rust-tokio-sdterr` | Zéro commit, 256 fichiers sur le disque | Exercice sur la capture de `stdout` et `stderr` avec Tokio, jamais commité, cible de compilation incluse |
| `jvtrudel-copilot/rust-tokio` | Zéro commit, 262 fichiers | Même chose, sans README |
| `jvtrudel-copilot/rust-keypair` | Zéro commit, 591 fichiers | Génération de paire de clés Ed25519. Le plus gros dépôt non commité du corpus, presque uniquement du répertoire `target` |
| `jvtrudel-copilot/rust-scp` | 2 commits, 2025-11, quatre fichiers | Squelette |
| `jvtrudel-copilot/git-multi-remote` | Zéro commit, trois fichiers | Le sujet, gérer plusieurs remotes, est exactement le problème que révèle ce corpus, avec ses noms de remote en désaccord avec les répertoires. Non traité |
| `jvtrudel-adhoc/rust-generated-quantum-toolkit` | 28 commits, 2026-03, 97 fichiers dont 61 en Rust, remote `noumanity/quantum-intelligence-toolkit` | Simulateur quantique de réseaux de neurones en architecture hexagonale, déclaré expérimental et destiné à se familiariser avec la génération de code par IA. Trois jours pour soixante-et-un fichiers Rust : c'est la mesure de ce que la génération assistée permet, et le dépôt le dit lui-même |
| `jvtrudel-adhoc/nou` | 11 commits, 2024-11, Go, 19 fichiers, répertoires `noucue`, `object`, `definition` | Première tentative d'un CLI d'objets typés validés par CUE. L'idée du système actuel existait donc en novembre 2024 |
| `jvtrudel-adhoc/nou2` | 1 commit, 2024-12, zéro fichier suivi, huit sur le disque | Deuxième tentative, abandonnée immédiatement |
| `jvtrudel-adhoc/go-socket` | 3 commits, 2025-05, Go | Exercice de deux jours |
| `esafwan/go_sqlite` | 2 commits, 2023-12, Go, six fichiers | Exemple tiers d'API REST avec SQLite, conservé comme référence |

**Lecture d'ensemble.** Quatre dépôts non commités totalisant 1 100 fichiers, presque tous des artefacts de compilation. L'absence de `.gitignore` avant le premier commit est un défaut mécanique répété. Surtout : `nou` en novembre 2024 est la première formulation du système actuel, objets typés validés par schéma manipulés par CLI. Le corpus a mis vingt mois à revenir à cette idée, et le dépôt `nou` n'est cité dans aucun document de la méthode.

## Travaux externes et anciens

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `terrencetao/E-sante-ISM-SPUM` | 16 commits, 2026-05, 142 fichiers, Python et TypeScript. PWA d'enrôlement biométrique hors ligne pour dossiers de santé en zone à faible connectivité | Collaboration externe réelle, en anglais, sans harnais. Le seul dépôt du corpus dont l'objet a une portée humanitaire directe, et il n'applique pas la méthode |
| `jvtrudel-exportech/jido` | 49 commits, 2016-03, 67 fichiers dont 33 SVG | Le plus ancien du corpus, cinq jours de travail en 2016. Conservé sans note |
| `julouso/monster-truck` | 15 commits, 2017 à 2024, 16 fichiers | Projet ludique de longue traîne |
| `datalyse/cli-photomanager` | 6 commits, 2025-04 à 2025-05, Go. Stockage, classement et étiquetage de documents | Encore un CLI d'organisation de ressources par métadonnées. Quatrième formulation de la même idée dans le corpus, après `nou`, `nty` et `specruptiva` |
| `jvtrudel-github/vitrine-web` | 5 commits, 2022-01 à 2026-02, trois fichiers | Page vitrine. Le dépôt le plus étalé dans le temps, quatre ans pour cinq commits |
| `dev-data/personal-journal-dev-data` | 1 commit, 2026-05, 44 fichiers dont 29 markdown et 15 logs | Dépôt de données du journal personnel. Neuf fichiers non commités. Séparation code contre données bien pensée, sans harnais ni remote |
| `archive/noumanity_proposition-borealis` | Zéro commit, 16 fichiers sur le disque | Une proposition commerciale archivée sans jamais avoir été versionnée. Archiver ce qui n'a pas de commit est une perte silencieuse |

## Ce que ces dépôts enseignent

Quatre idées du système actuel existaient déjà, formulées et parfois implémentées, avant que la méthode ne les nomme : la donnée structurée comme condition du traitement mécanique (`kata-clientside`, 2022), le fichier d'intention (`imagen`, 2022), l'objet typé validé par schéma et manipulé par CLI (`nou`, 2024), l'éditeur de données validé par CUE (`poc-cue-validated-yaml-editor`, 2025). Aucune n'est citée dans les documents de la méthode.

Le corpus démontre une capacité de développement long, avec `harmony` et ses 651 commits, et une pratique dominante d'exploration courte, avec une trentaine de dépôts de moins d'une semaine. La méthode actuelle ne modélise que le second régime, à travers la session et le ticket, et n'a rien à dire du premier.

Le réflexe CLI est constant depuis 2023, avant toute théorie. Le nom du groupe `cli-based-organization` formalise une pratique de trois ans, il ne l'invente pas.
