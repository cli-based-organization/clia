---
type: analyse
title: "Les dépôts de savoir, d'apprentissage et les dormants"
version: 0.1.0
status: draft
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Les dépôts de savoir, d'apprentissage et les dormants

> Vingt-quatre dépôts consacrés à la conservation de connaissances ou à l'apprentissage. Ils intéressent directement `clia`, qui revendique des capacités de mobilisation et d'utilisation du savoir : ce sont eux qui montrent comment l'humain accumule effectivement du savoir, et pourquoi le résultat est fragile.

## Les technotes

Onze dépôts nommés `technote` ou `technotes`, répartis dans trois groupes.

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `jvtrudel/technotes.nvim` | Zéro commit, un fichier sur le disque. Notions pour être productif avec Neovim | Le contenu utile, une table de raccourcis, existe et n'est pas versionné |
| `jvtrudel/technotes.secrets` | 1 commit, 2025-11, zéro fichier suivi. Doctrine de gestion des secrets, voûte principale et voûtes secondaires | La doctrine est bonne et tient en trois lignes. Elle est perdue si le disque tombe |
| `jvtrudel/technotes.ai` | 1 commit, 2025-11, zéro fichier suivi. Notes sur le format prompt et les CLI | Le dépôt qui aurait dû accumuler le savoir sur l'IA est vide, au moment même où l'humain construit un système d'IA |
| `jvtrudel/technotes.cryptography` | 3 commits, 2025-11, un fichier. Commandes GPG | Deux commandes utiles, un dépôt entier |
| `jvtrudel/technotes.network-reflection` | 2 commits, 2025-11, un fichier. Usage de nmap, avec renvoi au livre officiel | Bonne pratique de citation, contenu minimal |
| `jvtrudel/technotes.hardware` | Zéro commit, un fichier. Un lien vers un site de benchmarks CPU | Un lien comme dépôt |
| `la-isla-disruptiva/technotes-git` | 5 commits, 2024-02, quatre markdown. Usage de git, dont la fusion de plusieurs dépôts | Contient exactement la procédure qui permettrait de consolider les onze technotes en un seul dépôt |
| `la-isla-disruptiva/technote-ai` | 1 commit, 2025-09, zéro fichier | Deuxième dépôt de notes IA, vide lui aussi |
| `noumanity-ops/technotes` | Zéro commit, zéro fichier | Troisième tentative de dépôt de technotes, dans un troisième groupe |
| `la-isla-disruptiva/architecture` | 5 commits, 2024-01, six fichiers dont un `.drawio`. Architectures système, infra et applicative expérimentées | Le seul dépôt de savoir avec un schéma. Aucun lien avec l'`ARCHITECTURE.md` du harnais actuel, qui traite du même objet |
| `jvtrudel/ecrits` | 3 commits, 2025-11 à 2025-12, 13 fichiers. Articles publiés, dont un sur LinkedIn en novembre 2025 intitulé « J'embarque pas dans le hype de l'AI, mais... » | Le seul dépôt du corpus dont les livrables sont publiés et référencés vers leur publication. C'est le modèle pratique de la ressource `PUB` que `micrologic-clients` a définie sans skill |

**Lecture d'ensemble des technotes.** Onze dépôts, six sans aucun fichier versionné, trois groupes différents, aucun index, aucun lien entre eux. Le savoir technique de l'humain est réparti en éclats dont la moitié n'est pas versionnée. C'est le constat le plus important de ce fichier pour la conception de `clia` : le système revendique des capacités de mobilisation du savoir alors que la pratique actuelle de conservation du savoir est la moins outillée de tout le corpus.

Le mode de défaillance est identifiable. Un dépôt par sujet, créé au moment où le sujet se présente, avec un seuil d'entrée trop élevé pour la taille du contenu. Deux commandes GPG ne justifient pas un dépôt, mais elles justifient une note. Le corpus n'a pas de forme pour une note isolée, il n'a que la forme du dépôt.

La création du groupe `knowledge` et du dépôt vide `collecte-de-connaissance` le 2026-08-08, la veille de cette session, indique que l'humain a identifié le problème sans encore lui donner de forme.

## Apprentissage et bacs à sable

| Dépôt | Contenu | Lecture critique |
|---|---|---|
| `jvtrudel-adhoc/shelp` | 5 commits, 2024-10 à 2025-05, quatre fichiers. Gestion de ses scripts et configurations de terminal | Cinquième formulation dans le corpus de l'idée d'organiser ses outils par CLI, après `nou`, `nty`, `devops-cli` et `cli-photomanager` |
| `jvtrudel-adhoc/time-tracker` | 3 commits, 2025-03 à 2025-04, cinq fichiers. Suivi du temps par activité et statistiques | La notion de timebox, centrale au ticket extreme-smart, avait ici son instrument. Non relié |
| `jvtrudel-adhoc/documents-comptables` | 5 commits, 2024-09 à 2024-10, deux fichiers. Système comptable en bash sur des CSV à point-virgule | Le CSV comme format de données choisi pour sa manipulabilité en shell. Cohérent avec tout le reste de la pratique |
| `jvtrudel-adhoc/vanilla-web-dev` | 3 commits, 2025-02, quatre fichiers dont un répertoire `.dev` | Première occurrence du répertoire `.dev` dans le corpus, en février 2025, avant qu'il devienne la zone de travail du harnais |
| `jvtrudel-adhoc/appII` | 2 commits, 2025-04, un fichier. « First your tried. Then its time to build something useful » | Une phrase comme dépôt. Elle résume la tension du corpus mieux que la plupart des documents d'intention |
| `jvtrudel-adhoc/alpine-k8s` | 1 commit, 2024-10, zéro fichier suivi. Commandes docker et k8s dans le README | Le contenu est entièrement dans le README, ce qui est la bonne échelle pour ce type de note |
| `jvtrudel-adhoc/autohot2000` | Zéro commit, 969 fichiers sur le disque | Le plus gros dépôt non commité du corpus. Contenu non identifiable depuis les métadonnées, aucun README |
| `jvtrudel-adhoc/demo-cobol` | Zéro commit, deux fichiers | Curiosité, sans suite |
| `jvtrudel-adhoc/github-go` | Zéro commit, zéro fichier | Coquille |
| `jvtrudel-apprentissage/ameliore-communication` | Zéro commit, deux fichiers | Le seul dépôt du corpus consacré à l'amélioration d'une compétence non technique, et il est vide. Le groupe `jvtrudel-apprentissage` ne contient que lui |
| `jvtrudel/script-template` | 2 commits, 2025-11, quatre fichiers dont un `.template`. Gabarit de script avec commande `init-script` | Ancêtre direct des templates du harnais et de `setup.sh` |
| `jvtrudel/ephemeral-vault` | 1 commit, 2025-11, zéro fichier suivi. Conception d'une injection de secrets à durée de vie courte | Conception saine, une section, non versionnée. Complète `technotes.secrets` sans lien déclaré |
| `jvtrudel/ftl-duplex.nvim` | Zéro commit, deux fichiers. Squelette de plugin Neovim avec API de traduction | Prolonge `leptos-fluent`, sans lien déclaré |
| `noumanity-dev/INTENTION` | Zéro commit, zéro fichier, remote configuré | Troisième dépôt nommé `INTENTION` et vide, avec un remote créé. L'intention d'un dépôt commun d'intentions, jamais réalisée, trois fois |

## Ce que ces dépôts enseignent

Le savoir accumulé est réel mais il n'est ni indexé, ni relié, ni protégé. Six dépôts de notes sur onze ne contiennent aucun fichier versionné. Trois dépôts de notes IA sont vides, dans trois groupes différents, pendant que l'humain construit un système d'IA.

Le seuil d'entrée est mal calibré. La seule forme disponible pour conserver une connaissance est le dépôt git, ce qui est disproportionné pour deux commandes GPG. Il manque une forme légère, et la ressource `FND` du harnais actuel, l'essai de fondation exhaustif et sourcé, est encore plus lourde que le dépôt : elle ne couvre pas ce besoin, elle l'aggrave.

Les répétitions sont nombreuses et non détectées. L'idée d'organiser ses outils par CLI apparaît cinq fois. Le dépôt `INTENTION` vide apparaît trois fois. Le dépôt de notes IA vide apparaît trois fois. Rien dans la pratique actuelle ne permet à l'humain de constater qu'il recommence.

Le seul dépôt de savoir qui fonctionne est `jvtrudel/ecrits`, et il fonctionne parce qu'il est orienté publication : le livrable a un destinataire, une date et un lien. C'est la piste la plus solide que ce fichier offre pour la conception : le savoir se conserve quand il est destiné à sortir.
