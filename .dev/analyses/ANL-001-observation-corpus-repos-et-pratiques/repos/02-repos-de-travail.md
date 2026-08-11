---
type: analyse
id: ANL-001-05
title: "Les dépôts de travail équipés du harnais"
version: 0.1.0
status: draft
date: 2026-08-09
sujet: "Les dépôts de travail métier équipés du harnais"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Les dépôts de travail équipés du harnais

> Cinquante-huit dépôts appliquent, ou devraient appliquer, le harnais à du travail réel : offres de service, présentations, candidatures, stratégie d'entreprise, fondation de partis politiques. Ce sont eux qui éprouvent la méthode, et eux qui révèlent ses défauts d'installation.

## Consultation et candidatures

### noumanity-consultation/commission-scolaire-de-la-capitale

4 commits, 2026-07-08 au 2026-07-10, 70 fichiers, harnais complet plus `setup.sh` et `version.yaml`, remote `commission-scolaire-de-la-capitale/...`.

Rédaction d'une offre de service. Dix-huit logs de sortie IA daté du 2026-07-09, un `.dev/ressources.yaml`, un `.dev/session.md` et un `.dev/session-x01.md` en planification. C'est le premier dépôt métier équipé de la lignée B, et le patron dont les deux suivants sont issus.

**Analyse critique.** Le dépôt est cohérent, mais son premier log documente un incident révélateur : l'agent avait écrasé `INTENTION.md` avec du contenu générique et la tâche 01 a servi à restaurer l'intention réelle et à étendre `CONSTITUTION.md` pour classer les droits d'édition en trois catégories. C'est l'origine empirique de la règle actuelle qui interdit à l'agent de toucher `INTENTION.md`. Une règle du harnais est donc née d'un dégât, et rien dans le corpus ne l'énonce comme telle : l'ADR qui aurait dû acter cette leçon n'existe pas.

### noumanity-consultation/desjardins-devsecops et noumanity-consultation/cofomo-infra-moderne

4 et 5 commits, 2026-07-08 au 2026-07-22, 70 et 78 fichiers.

Deux dépôts destinés à des offres pour Desjardins et Cofomo. Le second porte vingt-huit logs, ce qui indique un travail réel poursuivi jusqu'au 22 juillet.

**Analyse critique.** Les trois dépôts de consultation partagent le même `INTENTION.md` au bit près, `Rédaction offre pour la Commission scolaire de la Capitale-Nationale`, y compris dans les dépôts Desjardins et Cofomo. Ils partagent aussi les dix-huit mêmes logs, avec des empreintes md5 identiques : les traces d'un dépôt ont été copiées dans les deux autres. Le mécanisme d'installation était une copie de dépôt, et il a propagé non seulement le harnais mais l'histoire d'un autre travail.

La conséquence est directe et grave pour la conception de `clia` : le harnais n'offre aucun moyen de distinguer ses propres traces de celles d'un dépôt tiers, et le log qui documente l'écrasement de `INTENTION.md` a été recopié dans deux dépôts où `INTENTION.md` est justement resté générique. Le bogue est documenté trois fois et corrigé une seule.

C'est l'argument le plus fort en faveur d'une commande d'installation qui pose le harnais sans le contenu, et d'un fichier d'état d'installation, ce que le `resource-types.yaml` archivé de `clia` prévoyait sous le nom `.dev/installation.yaml` sans que ce soit implémenté.

### noumanity-consultation/jvtrudel-cv et archive/jvtrudel-cv

19 et 21 commits, 2026-03-18 au 2026-06-21, 174 et 165 fichiers, 92 fichiers YAML dans la version archivée, 108 fichiers non commités dans cette même version.

Système de production de CV adaptés à chaque offre, à partir de données de référence structurées en YAML validées par CUE. La version archivée se déclare expérimentale et précise que la racine sert à concevoir un système, non à ranger des CV. La version active utilise la méthode `ticket-driven-ai` et vise la préparation de campagnes de recherche de mandat.

**Analyse critique.** C'est le meilleur cas d'usage métier du corpus : un domaine où les données structurées, la validation et la génération de livrables ont un sens évident. Et c'est aussi l'échec de persistance le plus coûteux : 108 fichiers non commités dans la version archivée, une réécriture complète sous un autre groupe, et un `.cue` unique dans une version qui en compte quatre-vingt-douze en YAML. La leçon que ce dépôt établit, à savoir que le travail métier gagne à séparer les données de référence des livrables produits, n'est nulle part remontée dans la méthode.

### noumanity-consultation/LGS

4 commits, 2026-07-10, 38 fichiers dont neuf `.gitkeep`, harnais complet, `CONSTITUTION.md` de 106 lignes propre à ce dépôt.

Gestion de la relation avec LGS et des demandes d'offres de poste. Quatorze fichiers non commités.

**Analyse critique.** Neuf `.gitkeep` pour des répertoires de ressources vides : le harnais installe une arborescence complète avant qu'il y ait quoi que ce soit à y mettre. Cette pratique donne l'illusion d'un dépôt structuré et rend illisible ce qui est réellement produit. Un `CONSTITUTION.md` propre à ce dépôt, différent des quatorze autres du corpus, montre que l'adaptation locale du harnais se fait par édition directe, sans trace de ce qui a été changé ni pourquoi.

### noumanity-consultation/micrologic-clients

Traité dans `01-lignee-methodologique.md` : bien que classé en consultation, ce dépôt porte la théorie des ressources du système.

### noumanity-consultation/vortex-solution, noumanity-talents/guillaume_viau-trudel

Zéro commit. Un fichier pour le premier, vingt-cinq pour le second.

**Analyse critique.** Vingt-cinq fichiers de travail sur un dossier de talent, sans un seul commit et sans remote. Le dépôt existe comme répertoire, pas comme dépôt.

## Sécurité cryptographique post-quantique

### cryptosecops/stratégie

15 commits, 2026-06-18 au 2026-06-24, 81 fichiers dont 64 markdown et six PDF, harnais propre à ce dépôt, treize fichiers non commités.

Espace de travail stratégique pour monter une startup de services de sécurité cryptographique post-quantique. L'`INTENTION.md` est un des mieux écrits du corpus : il pose la menace quantique comme prise de conscience de la fragilité du paradigme actuel et en dérive deux voies d'opportunité.

**Analyse critique.** Le dépôt le plus dense en contenu métier réel du groupe. Son `CLAUDE.md` de 79 lignes et son `CONSTITUTION.md` de 31 lignes ne correspondent à aucune autre empreinte du corpus : c'est une variante isolée, ni ancêtre ni descendante, et personne ne pourra dire ce qu'elle apportait. Six semaines après le dernier commit, treize fichiers restent non commités dans un dépôt qui porte une stratégie d'entreprise.

### cryptosecops/communications, conf-hackfest-2026, pqc-domain, veille

7, 2, 4 et 0 commits. Entre 11 et 15 fichiers chacun. Tous quatre portent le même harnais de la lignée A, empreinte `fb9cb1fe` pour `CLAUDE.md` et `b84bf708` pour `CONSTITUTION.md`, et le même `README.md` renvoyant à `ticket-driven-ai`.

**Analyse critique.** Quatre dépôts créés le même jour, du même moule, dont un jamais commité et deux à moins de cinq commits. Le `README.md` de chacun renvoie à un dépôt GitHub `noumanity-dev/ticket-driven-ai` dont la méthode a été abandonnée deux semaines plus tard. Ces quatre dépôts pointent donc vers une méthode morte, et rien ne les mettra à jour. C'est le coût de la duplication du harnais rendu visible.

### cryptosecops/noumanity+qguard

6 commits, 2026-06-11 au 2026-06-19, 35 fichiers dont deux PDF et deux `.docx`, pas de harnais, seulement `.claude/`.

Registre des documents légaux et confidentiels partagés entre Groupe Innovation Numanity et QGuard.

**Analyse critique.** Un registre de documents légaux sans harnais, sans remote, et avec un `.claude/settings.local.json` : l'agent y travaille sans aucune règle. C'est exactement le type de dépôt où des règles d'édition et de confidentialité seraient nécessaires, et c'est celui qui n'en a pas.

### cryptosecops/presentation-marie-eve-cyr

1 commit, 2026-07-01, aucun fichier.

**Analyse critique.** Un dépôt nommé d'après une personne, vide. À supprimer ou à documenter.

## Stratégie et opérations d'entreprise

### noumanity-ops/noumanity-planification-stratégique

Zéro commit, 42 fichiers sur le disque, harnais complet incluant `ARCHITECTURE.md`, sans remote.

Documentation de la stratégie du Studio DeepTech noumanity, présenté comme le premier studio DeepTech de Québec et le seul autofinancé au Canada.

**Analyse critique.** Le document stratégique de l'entreprise, quarante-deux fichiers, zéro commit, zéro remote. Une panne de disque effacerait la stratégie. Son `CLAUDE.md` partage l'empreinte `98aba990` avec `etude-marché-conformité` et `horizon-ia/app-itinerance`, ce qui identifie une troisième génération de harnais dont aucun dépôt de méthode ne conserve la trace.

### noumanity-ops/etude-marché-conformité

Zéro commit, 31 fichiers, harnais complet dont `ARCHITECTURE.md`.

Son `INTENTION.md` est celui de `clia` recopié mot pour mot : `Travail DeepTech Augmenté par IA`, suivi du texte sur le cadre de collaboration entre humain, automatismes et agent IA.

**Analyse critique.** L'`INTENTION.md` du système d'augmentation a été copié comme intention d'un dépôt d'étude de marché. C'est la confusion des niveaux poussée à son terme : le dépôt qui étudie un marché déclare pour raison d'être de fournir un cadre de collaboration IA. Preuve que l'installation par copie ne distingue pas ce qui est générique de ce qui est propre au dépôt source, et que `INTENTION.md`, déclaré en édition humaine exclusive, échappe de fait à tout contrôle.

### noumanity-ops/noumanity-quantum-roadmap

2 commits, 2026-07-24, 113 fichiers dont 32 `.tex` et 11 PDF, harnais lignée B, douze fichiers non commités.

Gestion de la feuille de route quantique de noumanity, avec chaîne de production LaTeX.

**Analyse critique.** Chaîne LaTeX complète, dix ou onze PDF produits, deux commits. Les PDF générés sont commités aux côtés des sources, sans qu'un `.gitignore` tranche la question. Cette même ambiguïté se répète dans `linux-and-quantum-computers` et `event-xminds` : le corpus n'a jamais décidé si un livrable produit mécaniquement est une ressource à versionner. C'est une question directement pertinente pour la définition de la ressource `PUB` observée dans `micrologic-clients`, laquelle n'a précisément aucun skill.

### noumanity-ops/noumanity-communication-stratégique, pdg-augmenté, noumanity-linkedin, technotes

2, 1, 0 et 0 commits. Le premier porte 21 fichiers, les trois autres sont vides ou quasi vides. `pdg-augmenté` porte le harnais complet de la lignée A pour zéro fichier de contenu.

**Analyse critique.** Un dépôt nommé `pdg-augmenté`, entièrement équipé et entièrement vide, est l'emblème du mode de défaillance du corpus : l'installation du cadre est confondue avec le début du travail. `noumanity-linkedin` existe en deux exemplaires, l'un vide sous `noumanity-ops`, l'autre avec 19 commits sous `archive/`, ce qui indique une migration de groupe inachevée.

## Formation et conférences

### noumanity-formation/linux-and-quantum-computers

14 commits, 2026-07-06 au 2026-07-17, 92 fichiers dont 18 `.tex` et 10 PDF, harnais lignée B avec `README.md`.

Livrable annoncé : une conférence intitulée « La place de Linux dans les ordinateurs quantiques ».

**Analyse critique.** Un des rares dépôts du corpus avec un livrable unique, daté, et livré. L'`INTENTION.md` tient en une phrase et suffit, ce qui contredit utilement la tendance du corpus à produire de longs documents d'intention. À retenir comme contre-exemple : quand le livrable est net, l'intention peut être courte.

### noumanity-formation/linux-pqc

48 commits, 2026-06-12 au 2026-07-08, 37 fichiers, seulement `README.md` et `.claude/`, remote sous `noumanity-formation`.

Présentation préparée pour les Rencontres Linux du Québec du 17 juin 2026, avec sept fichiers CSV de données.

**Analyse critique.** Quarante-huit commits, le rythme le plus soutenu des dépôts métiers, et aucun harnais. Le dépôt le plus régulièrement travaillé du groupe est celui qui n'applique pas la méthode. C'est une donnée contrariante qu'il faut nommer : la corrélation entre présence du harnais et volume de travail effectif est, sur ce corpus, faible voire négative.

### noumanity-formation/INTENTION, noumanity-formation/tmp

Zéro commit, zéro fichier. À supprimer.

## Communication et événements

### noumanity-communication/event-xminds-console-juillet-2026

4 commits, 2026-07-29, 181 fichiers dont 48 PNG, 32 `.tex`, 23 JPG et 11 PDF, harnais lignée B complet.

Préparation des assets pour la fiesta X-Minds Latina, un événement sur la neurodivergence et les esprits singuliers.

**Analyse critique.** Le dépôt le plus lourd en assets binaires du groupe communication, sans `.gitignore` visible pour séparer les sources des rendus. Le harnais de la lignée B, conçu pour la production de documents markdown typés, n'apporte rien à un travail d'assets visuels : ni les types de ressources, ni la journalisation obligatoire, ni les règles de markdown strict n'ont de prise sur un PNG. C'est une limite de portée du système qui n'est écrite nulle part.

### noumanity-communication : bootstrap-site-recherche-obstak, catalogue-startup, cloud-ia-souverain, creation-image-de-marque, noumanity-bureau-de-rédaction, noumanity-correspondance-affaire, pilier-communication-noumanity

Entre zéro et quatre commits, entre zéro et trois fichiers. Aucun harnais. Deux d'entre eux contiennent un `.log` et un `.md`, vestiges d'une commande d'initialisation.

**Analyse critique.** Sept dépôts de communication dont aucun ne contient de travail. La notion de pilier de communication, qui est le cœur conceptuel de `comm-cli`, a son dépôt dédié, `pilier-communication-noumanity`, avec trois fichiers. Le concept est spécifié dans un dépôt de code jamais implémenté et absent du dépôt qui porte son nom.

## Politique

### parti-horizon/fondation

8 commits, 2026-06-22 au 2026-06-23, 22 fichiers, harnais lignée A complet.

Analyse de la conjoncture socio-économico-politique du Québec à l'été-automne 2026 en vue de la fondation d'un parti politique.

**Analyse critique.** Un des rares dépôts où le harnais de la lignée A sert un travail d'analyse, et non d'ingénierie. L'exercice est concluant sur deux jours, puis s'arrête. Les dépôts frères `analyse-des-partis` et `scripts` sont à zéro commit.

### ontpe/dossier-president

2 commits, 2026-07-06, 9 fichiers, harnais lignée B avec un `session.md` à la racine et non sous `.dev/`.

Son `INTENTION.md` est celui de `intentional-doers-governance` recopié : le framework des trois ingrédients.

**Analyse critique.** Deuxième cas d'`INTENTION.md` du système copié comme intention d'un dépôt métier, après `etude-marché-conformité`. Le `session.md` à la racine, au lieu de `.dev/session.md`, montre que l'emplacement du point d'entrée a varié d'un dépôt à l'autre sans convention arrêtée. La question est toujours ouverte dans `clia`, dont le `CLAUDE.md` désigne `workspace/session.md` alors que l'historique utilise `.dev/session.md`.

### le-gros-quebec/fondation-d-un-parti-politique et le-gros-quebec.github.io

4 commits chacun, 23 et 1 fichiers, 20 PDF officiels d'Élections Québec, pas de harnais.

**Analyse critique.** Travail documentaire réel, ressources officielles rassemblées et synthétisées en markdown, sans aucun harnais. Le corpus contient donc trois tentatives de fondation de parti politique dans trois groupes distincts, `le-gros-quebec`, `parti-horizon` et `ontpe`, sans lien déclaré entre elles.

## Autres travaux équipés

### horizon-ia/app-itinerance

1 commit, 2026-07-22, aucun fichier suivi mais harnais complet sur le disque, `INTENTION.md` d'une ligne : fournir une app IA qui améliore la vie des personnes en situation d'itinérance.

**Analyse critique.** Intention forte, une ligne, zéro fichier suivi. Le harnais est installé, le travail n'a pas commencé. À conserver tel quel : c'est un cas honnête de dépôt en attente, contrairement à ceux qui accumulent des `.gitkeep`.

### noumanity-used-program/aws-finops-analysis

20 commits, 2026-05-18 au 2026-05-19, 75 fichiers dont 34 en Rust, `CLAUDE.md` de 34 lignes et `ARCHITECTURE.md`, sans remote.

CLI Rust d'aide à la rédaction de rapports FinOps. Le dépôt de données associé, `clients-data/vortex-finops`, porte 53 commits et 37 fichiers CSV.

**Analyse critique.** Le seul cas du corpus où un outil, ses données et ses livrables sont séparés en dépôts distincts et où les trois ont vécu. Le dépôt de données a plus de commits que le dépôt de code, avec des messages de commit descriptifs et cohérents (`finops: ingestion coûts services us-east-1`) : quand le travail est mécanique et répétitif, l'humain soigne son historique. C'est une observation à confronter aux 133 commits nommés `save` du reste du corpus.

### jvtrudel-adhoc/edit-google-doc-from-markdown

30 commits, 2026-03-12 au 2026-03-14, 73 fichiers dont 57 markdown et 10 en Rust, `CLAUDE.md` de 282 lignes, le plus long du corpus.

Outil CLI Rust de synchronisation entre un fichier markdown et un Google Doc, déclaré expérimental et généré par IA à des fins pédagogiques.

**Analyse critique.** Le `CLAUDE.md` le plus long du corpus, 282 lignes, dans un dépôt déclaré jetable. Cinquante-sept fichiers markdown pour dix fichiers Rust : le rapport documentation sur code est de près de six pour un. C'est la dérive documentaire à son maximum, et elle est survenue dès mars 2026, avant que la méthode ne se formalise. Le besoin adressé, faire le pont entre un travail versionné en markdown et des collaborateurs sur Google Docs, est réel et non résolu ailleurs dans le corpus.

### noumanity-deals/noumanity-redaction-ententes et achat-epicerie-scott

2 et 0 commits, 79 et 13 fichiers, aucun harnais.

Rédaction d'ententes et dossier d'achat d'épicerie. Le second a un frère archivé, `archive/les-epiceries-de-quartier-scott`, 4 commits et 38 markdown.

**Analyse critique.** Cinquante-trois markdown de rédaction d'ententes juridiques sans harnais, huit fichiers non commités. Comme pour le registre légal de `noumanity+qguard`, les dépôts à contenu juridique sont ceux qui bénéficieraient le plus de règles d'édition explicites et ceux qui en ont le moins.

### Autres, sans travail effectif

`noumanity-dev/exploracion-sobre-decentralizado-post-quantum-vpn` (2 commits, un seul fichier `INTENTION.md` sur la cryptographie de transport pair-à-pair), `noumanity-projet-collaboration/poc-uni-nano-cameroun` (0 commit, 19 fichiers), `noumanity-recherche-action/comptes-de-banque-et-credit` (0 commit, 3 fichiers), `noumanity-research/quantum-review` et `demande-financement-concours-exploration-2026` (0 commit), `noumanity-research/global-innovation-index` (2 commits, 21 PDF de référence sur l'innovation), `monteroy+noumanity/coentreprise` (0 commit, vide), `marketing/marketing-pro-bono` (0 commit, 3 fichiers), `ReLaQx/bbq-relaqx-juillet-2026` (1 commit, 9 fichiers d'assets, seulement `.claude/`), `knowledge/collecte-de-connaissance` (0 commit, vide).

**Analyse critique groupée.** Dix dépôts créés pour un travail qui n'a pas eu lieu. Le cas de `knowledge/collecte-de-connaissance` mérite d'être relevé : un dépôt vide, créé le 2026-08-08, la veille de la présente session, dans un groupe nouvellement créé nommé `knowledge`. C'est le signe que la question de la collecte du savoir est active dans l'esprit de l'humain au moment de cette session, et qu'elle n'a pas encore de forme. `noumanity-research/global-innovation-index`, à l'inverse, montre le seul cas de matériel source externe rassemblé et cité proprement, avec les définitions de l'innovation de l'OCDE.

## Ce que les dépôts de travail enseignent

Le harnais s'installe par copie, et la copie emporte tout : intentions d'autres dépôts, traces d'autres sessions, harnais de générations antérieures. Trois `INTENTION.md` identiques pour trois clients différents, et deux `INTENTION.md` du système utilisés comme intentions métier, sont des défauts de mécanisme et non d'attention.

Le harnais n'a pas de prise sur les travaux non textuels. Assets visuels, PDF générés, fichiers légaux binaires : la méthode n'y apporte rien et ne le dit pas.

Les dépôts qui portent le plus de valeur métier sont souvent les moins protégés. La stratégie d'entreprise, la stratégie post-quantique et le dossier de talent sont à zéro commit ou sans remote.

La présence du harnais ne prédit pas le volume de travail. Le dépôt le plus régulièrement travaillé du corpus métier, `linux-pqc` avec 48 commits, n'a pas de harnais. Les deux dépôts entièrement équipés et entièrement vides, `pdg-augmenté` et `app-itinerance`, en ont un complet.

## Relations

- `fait-partie-de` [ANL-001](../index.md)
