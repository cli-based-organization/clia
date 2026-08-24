---
type: analyse
id: ANL-001-01
title: "Analyse critique transversale du système"
version: 0.1.0
status: draft
date: 2026-08-09
sujet: "Défauts transverses du système, mesurés"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Analyse critique transversale du système

> Les défauts qui ne se voient pas dépôt par dépôt, mais seulement en regardant les cent soixante-six ensemble. Chacun est appuyé sur une mesure et non sur une impression.

## D1. Le numéro de séquence ne porte aucune identité

**Mesure.** Douze numéros de skill sur vingt portent plusieurs noms différents selon le dépôt.

| Numéro | Noms distincts observés |
|---|---|
| `skl-001` | `artefact-de-travail`, `skill-writer` |
| `skl-002` | `adr`, `recherche-de-fondation` |
| `skl-003` | `essai-de-fondation`, `plan-de-travail` |
| `skl-004` | `analyse-strategique`, `deliverable-skill-writer`, `harnais`, `programmation-et-design`, `redaction-courriel` |
| `skl-006` | `adr`, `deliverable-requirement-writer`, `harness-file-governance`, `plan-strategique` |
| `skl-008` | `analyse`, `analyser-candidature`, `harness-file-behavior`, `log-ia-output` |

Le même défaut atteint les ADR : `ticket-driven-ai` porte sept ADR dont trois paires de doublons de titre, `ADR-002` et `ADR-005`, `ADR-003` et `ADR-006`, `ADR-004` et `ADR-007`.

**Portée.** Le `CLAUDE.md` actuel de `clia` désigne chaque type de ressource par un triplet de numéros, `ADR-001, RES-001, skl-001`. Cette désignation n'est valide qu'à l'intérieur d'un dépôt et à un instant donné. Dès qu'un deuxième dépôt est équipé, ou qu'un type est renuméroté, les renvois se brisent silencieusement. `RES-001` de `micrologic-clients` documente lui-même le coût constaté : renommer le dossier de candidature de `RES` à `DOS` a demandé six corrections manuelles.

**Ce que cela met en cause.** Le renoncement à l'invariant d'identité stable, assumé par `RES-001` au motif que le volume du dépôt le permet, est un calcul juste pour un dépôt et faux pour un système destiné à équiper des dizaines de dépôts. Un identifiant stable indépendant du chemin et de la séquence est une condition de possibilité du système, pas un raffinement.

## D2. Rien ne propage, rien ne valide

**Mesure.** Trente-trois `CLAUDE.md` dans le corpus, dix-huit contenus distincts. Trente-deux `CONSTITUTION.md`, quinze contenus distincts, dont un de zéro octet dans `disruptiva-dev/disks-management`. Trois dépôts de consultation partagent le même `INTENTION.md` au bit près, désignant un client qui n'est pas le leur. Deux dépôts métiers portent comme `INTENTION.md` celui du système d'augmentation lui-même.

**Portée.** Le harnais s'installe par copie de dépôt. La copie emporte tout : le harnais, l'intention du dépôt source, et ses traces. Les dix-huit logs de `commission-scolaire-de-la-capitale` existent à l'identique, empreinte md5 comprise, dans `desjardins-devsecops` et `cofomo-infra-moderne`. Parmi eux, le log qui documente l'écrasement de `INTENTION.md` par du contenu générique a été copié dans les deux dépôts où `INTENTION.md` est justement resté générique.

**Ce que cela met en cause.** Deux mécanismes manquent, et le `resource-types.yaml` archivé de `clia` les avait tous deux nommés sans les implémenter. Le premier est un fichier d'état d'installation, prévu sous le nom `.dev/installation.yaml`, portant la version du système posée et une empreinte, qui permettrait de reconnaître un dépôt équipé et de le mettre à jour. Le second est une validation mécanique, qui manque partout : `RES-001` l'inscrit noir sur blanc dans ses lacunes, rien n'empêche un `type` mal orthographié, un champ absent ou une relation vers un type inexistant.

Le corpus a pourtant eu la validation mécanique entre les mains, à trois reprises : CUE dans `specruptiva`, dans `poc-cue-validated-yaml-editor` et dans `jvtrudel-cv`. Elle a été perdue chaque fois, sans décision écrite.

## D3. Les ruptures de cap ne sont jamais actées

**Mesure.** Le corpus contient quatre-vingt-neuf ADR. Aucun ne porte sur les quatre abandons structurants suivants.

| Abandon | Date | Trace écrite |
|---|---|---|
| La validation par schéma CUE | courant 2026 | aucune |
| L'intention machine-lisible (`kind: Intention`) | avril 2026 | aucune |
| La méthode `ticket-driven-ai` et le CLI `tda`, au profit de `clia` | juillet 2026 | aucune |
| Le principe zéro trace dans le projet cible, au profit de `.dev/` posé partout | juin 2026 | aucune |

**Portée.** Les ADR du corpus portent massivement sur des questions internes de forme : placement de fichiers, nommage, catalogue des livrables, compatibilité de format. Les décisions de direction, celles qui expliqueraient pourquoi le système a la forme qu'il a, ne sont pas documentées. Un lecteur du corpus, humain ou agent, ne peut pas reconstituer le raisonnement qui a mené de `tda` à `clia`, et ne peut donc pas éviter de refaire le chemin inverse.

**Ce que cela met en cause.** Soit la ressource ADR n'est pas au bon niveau, soit il manque un type pour la décision de direction. La deuxième hypothèse est plus probable : un ADR décide d'une architecture, il ne décide pas d'un cap. Le corpus a produit un type Analyse critique et un type Objection, mais rien pour la décision stratégique tracée.

## D4. Le système consacre une part croissante de son énergie à se décrire

**Mesure.** Dans `nou-methodologies-ia`, cinq skills sur douze portent sur la production des fichiers de harnais eux-mêmes. Dans `clia`, le `CLAUDE.md` actuel annonce vingt-sept types de ressources, chacun devant recevoir un ADR, une définition de ressource et un skill, soit quatre-vingt-un documents. Sur les 585 instances de ressources typées du corpus, 99 sont des logs et 172 des tâches de ticket, c'est-à-dire des traces d'exécution, tandis que les livrables métiers proprement dits sont minoritaires.

Le rapport le plus parlant est dans `jvtrudel-adhoc/edit-google-doc-from-markdown` : cinquante-sept fichiers markdown pour dix fichiers Rust, avec un `CLAUDE.md` de 282 lignes, dans un dépôt déclaré jetable.

**Portée.** L'énergie consacrée à décrire le système croît plus vite que le travail que le système permet d'accomplir. Le harnais actuel de `clia` prescrit sept fichiers de journalisation par requête, `demande.md`, `commit-message.yaml`, `analyse.md`, `fait.md`, `validation.md`, `resultat-validation.md`, `next.yaml`, pour une tâche dont la durée médiane observée est de trente minutes.

**Ce que cela met en cause.** Le coût par ressource doit devenir un critère de conception explicite. La question à poser pour chaque type n'est pas « est-il utile ? » mais « son coût de production et de maintien est-il inférieur à ce qu'il fait gagner ? ». Le corpus fournit d'ailleurs le contre-exemple qui tranche : `noumanity-formation/linux-pqc`, quarante-huit commits, le rythme le plus soutenu des dépôts métiers, et aucun harnais.

## D5. Le meilleur travail conceptuel est le moins protégé

**Mesure.** `RES-001-ressource.md`, le document le plus rigoureux du corpus, vit dans `noumanity-consultation/micrologic-clients`, dépôt de deux commits, sans remote, avec treize fichiers non commités, et dont l'`INTENTION.md` est une offre d'emploi. Le manifeste de `cli-based-enterprise`, qui fonde le groupe `cli-based-organization`, n'a jamais été commité. Le CLI Go de `nou-scripts-ia-support`, avec son générateur d'ADR et son intention machine-lisible, n'a jamais été commité. Le document de stratégie de l'entreprise, quarante-deux fichiers, n'a jamais été commité.

**Portée.** Quatre-vingt-quatorze dépôts sur cent soixante-six sans remote, quarante-cinq sans aucun commit. La théorie du système, sa stratégie d'entreprise et son manifeste fondateur reposent sur un seul disque.

**Ce que cela met en cause.** Le harnais interdit à l'agent toute mention d'opération git. Cette règle, conjuguée à la pratique observée, produit exactement l'effet inverse de son intention : elle protège la responsabilité de l'humain sur le versionnage et laisse son travail non protégé. Une commande `clia` qui rapporte l'état de versionnage d'un dépôt équipé, sans rien modifier, ne violerait aucun principe et corrigerait le risque le plus concret du corpus.

## D6. Le système a un angle mort sur le savoir, qu'il revendique pourtant

**Mesure.** Onze dépôts de technotes, dont six sans aucun fichier versionné. Trois dépôts de notes IA vides, dans trois groupes différents. Un dépôt `abai-deeptech-notebook` de neuf fichiers dont trois `.gitkeep`. Un seul dépôt de savoir fonctionnel, `jvtrudel/ecrits`, et il fonctionne parce qu'il est orienté publication.

**Portée.** L'`INTENTION.md` de `clia` affirme que le cadre est adapté au DeepTech parce qu'il fournit nativement des capacités de mobilisation et d'utilisation du savoir. Rien dans le corpus ne soutient cette affirmation. La seule ressource de savoir outillée, l'essai de fondation `FND`, est un format long, exhaustif et sourcé, et il y en a cinquante-deux instances pour cent soixante-six dépôts. Aucun mécanisme d'indexation, de recherche ou de réutilisation transverse n'existe. Le savoir accumulé n'est pas mobilisable, il est archivé.

**Ce que cela met en cause.** Il s'agit d'une objection à porter à l'`INTENTION.md` de `clia` : la spécificité DeepTech revendiquée n'est adossée à aucun travail, et rien ne distingue aujourd'hui une capacité de mobilisation du savoir d'une gestion documentaire soignée. Il manque en outre une forme légère : entre le commentaire perdu dans une conversation et l'essai de fondation, il n'y a rien, alors que la pratique observée produit surtout des notes de deux lignes.

## D7. La méthode n'a de prise que sur le markdown

**Mesure.** `event-xminds-console-juillet-2026` porte 181 fichiers dont 48 PNG, 23 JPG, 32 `.tex` et 11 PDF, avec un harnais complet. `noumanity-quantum-roadmap` porte 32 `.tex` et 11 PDF. `noumanity+qguard` gère des documents légaux en PDF et `.docx` sans aucun harnais. `ReLaQx/bbq-relaqx-juillet-2026` porte des assets vidéo et image avec seulement un `.claude/`.

**Portée.** Les types de ressources, la journalisation, les règles de markdown strict, le frontmatter YAML : rien de tout cela n'a de prise sur un PNG, un PDF généré ou un contrat en `.docx`. Trois dépôts du corpus commitent leurs PDF générés aux côtés des sources sans qu'aucune règle ne tranche.

**Ce que cela met en cause.** Deux manques distincts. D'abord, la portée du système n'est pas déclarée : aucun document ne dit que la méthode s'applique aux ressources textuelles et pas aux assets. Ensuite, la question du livrable produit mécaniquement n'est pas tranchée : `micrologic-clients` a défini un type Publication qui n'a précisément aucun skill, et c'est le seul endroit du corpus où la question est même posée.

## D8. Le harnais actuel de `clia` prescrit un système qui n'existe pas

**Mesure.** Le `CLAUDE.md` actif décrit vingt-sept types de ressources, sept commandes CLI, un mécanisme d'extensions, un espace actif documentaire et une journalisation obligatoire à sept fichiers. Le dépôt contient, hors archives, quatre fichiers et aucun exécutable. Sur les vingt-sept triplets `ADR, RES, skl` annoncés, quinze portent des marque-places de la forme `ADR-0` ou `ADR-00`. Aucune des ressources annoncées n'existe.

Deux directives sont matériellement inexécutables au moment de cette analyse : le point d'entrée est déclaré à `workspace/session.md` alors que l'historique du dépôt utilise `.dev/session.md`, et les deux fichiers coexistent désormais sur le disque avec des contenus différents ; le répertoire de journalisation `.dev/logs/` n'existait pas avant cette session.

**Portée.** Le fichier de harnais est, par construction, celui qui a autorité sur le comportement de l'agent. Lorsqu'il décrit un état futur, l'agent ne peut ni obéir ni objecter utilement, et chaque session commence par une négociation sur ce qui est applicable. C'est ce qui s'est produit à l'ouverture de la présente session.

**Ce que cela met en cause.** Le harnais a besoin d'un moyen de distinguer ce qui est en vigueur de ce qui est prévu. La solution la moins coûteuse existe déjà dans le vocabulaire du corpus : le champ `status` du frontmatter, avec les valeurs `draft`, `stable` et `deprecated`, et la mention de statut `actif` que le `CLAUDE.md` de `clia` emploie déjà pour les harnais sans l'appliquer à ses propres sections. Une table de types dont chaque ligne porte un statut réglerait le problème sans rien retirer de l'ambition.

## D9. Deux échelles de travail, une seule modélisée

**Mesure.** Les quatre sessions archivées de `clia` couvrent respectivement 21 tâches en 37 heures, 4 tâches en 6,5 jours, 44 tâches en 14 jours et 4 tâches en 2,7 jours. Vingt-deux pour cent des tâches journalisées sont déclarées partielles. La durée médiane d'une tâche est de trente minutes.

**Portée.** La session est un contenant unique pour deux réalités : la demande de trente minutes et le chantier de deux semaines à quarante-quatre tâches. Le second n'a aucune structure interne. La lignée A avait tranché avec deux types, l'issue non-smart pour la création et le ticket extreme-smart pour l'ingénierie, borné à un livrable et douze heures. `clia` a remplacé ces deux types par un seul, plus souple, et la souplesse a rouvert le problème. La session du 2026-07-31 le constate elle-même dans sa tâche 2.

**Ce que cela met en cause.** La question des issues, ouverte depuis juillet, reste la principale lacune fonctionnelle du système. Le corpus contient trois réponses déjà éprouvées et non comparées : les répertoires `en-cours` et `todo` de `nty`, les fiches d'amélioration numérotées de `comm-cli`, et le couple issue non-smart plus ticket extreme-smart de `ticket-driven-ai`. Une analyse comparative de ces trois réponses coûterait peu et manque.

## D10. Les traces sont mal datées

**Mesure.** Quarante-cinq logs de `clia` portent le nom `LOG-2026-07-17-task-NN` alors que la session correspondante s'est étendue du 17 au 31 juillet. Le champ du frontmatter s'appelle `session-date`, ce qui est exact, mais le nom de fichier suggère une date de production. Deux logs déclarent `status: complet` là où cinquante-deux déclarent `status: completed`.

**Portée.** Le `resource-types.yaml` classe les logs comme traces immuables au nommage horodaté. Le nommage n'est pas horodaté en fait : il porte la date d'ouverture de session. La chronologie réelle des tâches n'est récupérable que par le numéro de tâche, et seulement au sein d'une même session. La règle d'immuabilité, par ailleurs, est déclarée puis transgressée, et `RES-001` le reconnaît explicitement dans ses lacunes.

**Ce que cela met en cause.** Une règle écrite et non tenue est pire que son absence, comme `RES-001` le formule lui-même. Trois positions sont tenables : appliquer l'immuabilité, l'abandonner, ou la remplacer par un versionnage. La position actuelle, la déclarer et la transgresser, n'en est pas une.

## Ce qui fonctionne, et qu'il faut préserver

L'analyse critique serait fausse si elle ne relevait pas ce qui tient.

Le vocabulaire a convergé et il est juste. Intention, contexte, ressource, type, cycle de vie, objection, skill, harnais : ce noyau a survécu à trois réécritures et à cinq groupes de dépôts. C'est un actif rare.

Le point d'entrée unique est une bonne décision. Il répond exactement à la contrainte de reprise après un creux de plusieurs mois, qui est la contrainte dominante du régime de travail observé.

La gouvernance par objection est appliquée réellement, pas seulement documentée. Les objections sont numérotées, tracées, réévaluées, et elles ont donné lieu à des changements de conception effectifs.

`RES-001-ressource.md` est du travail de première qualité : il énonce sept invariants, en retient quatre, écarte trois avec justification, pose un critère de départage sous forme de test pratique, et se termine par cinq lacunes assumées dont l'aveu qu'une de ses règles n'est pas tenue. C'est le modèle à suivre pour toutes les ressources fondamentales que la présente session veut définir, et c'est aussi le document qu'il faut rapatrier de toute urgence hors d'un dépôt de candidature.

## Relations

- `fait-partie-de` [ANL-001](index.md)
