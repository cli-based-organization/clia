---
type: analyse
version: 0.1.0
title: "Livrables, spécifications et requis : ticket-driven-ai vs clia"
date: 2026-07-18
---

# ANL-011 - Livrables, spécifications et requis : ticket-driven-ai vs clia

- **Périmètre** : les ADR de `noumanity-dev/ticket-driven-ai` (`doc/adr/ADR-001..007`), comparés à la notion de livrable et aux définitions de spécification/requis de ce dépôt (`clia` : `ADR-004`, `SPEC-001`/`REQ-001`, `SPEC-002`/`REQ-002`, table des livrables de `CLAUDE.md`). Exclusions : contenu métier, `.git/`.
- **Référence** : `FND-015-requis-et-specification` (notions de requis et spécification) ; `FND-002-ingenierie-livrables-qualite` (rapatriée).

## Objet

Analyser de façon critique les ADR de `ticket-driven-ai`, les comparer aux besoins et à la notion de livrable de `clia`, et élucider pourquoi les « specs » et « reqs » des deux dépôts ne recouvrent pas les mêmes définitions. Confronter au savoir de la fondation et émettre des recommandations. L'analyse recommande ; elle n'exécute aucun changement (les ADR de `ticket-driven-ai` sont dans un autre dépôt, en lecture seule).

## Périmètre et méthode

Corpus : les 7 ADR de `ticket-driven-ai` et les ressources de conception de `clia` traitant du livrable, de la spécification et du requis. Grille : (1) inventaire et rôle de chaque ADR ; (2) axe d'abstraction de SPEC et de REQ dans chaque dépôt ; (3) notion de livrable (catalogue, cycle de vie, emplacement, versionnage) ; (4) confrontation à la `FND` pour situer chaque convention dans la littérature.

## Inventaire

**ADR de `ticket-driven-ai`** :
- `ADR-001-conventions-placement-fichiers` : trois zones — racine (harness-files permanents), `.dev/` (travail instable), `doc/` (livrables stables publiés). Propriété explicite humain / CLI (`tda`) / agent.
- `ADR-002-livrable-specification` **et** `ADR-005-livrable-specification` : créent le type **SPC** (Spécification). **Contenu verbatim identique** entre les deux.
- `ADR-003-livrable-requis-technique` **et** `ADR-006-livrable-requis-technique` : créent le type **REQ** (Requis technique). **Contenu verbatim identique** entre les deux.
- `ADR-004-livrable-deliverable-skill` **et** `ADR-007-livrable-deliverable-skill` : créent le type **SKILL de conception de livrable**. Paire redondante.

**Ressources de `clia`** :
- `ADR-004-ressources-livrables` : typologie des ressources par 6 axes ; cycle de vie point-fixe / vivant / travail ; versionnage semver par ensembles (`.dev/ressources.yaml`).
- `REQ-001` / `REQ-002` : **exigences** (fonctionnelles F, non-fonctionnelles NF) d'un CLI bash et de `clia`.
- `SPEC-001` / `SPEC-002` : **spécification d'interface** concrète satisfaisant ces requis (en-tête « Requis couverts : REQ-00x »), avec table de traçabilité SPEC → REQ.

## Constats

**C1. Inversion de l'axe d'abstraction entre SPEC et REQ.** Les deux dépôts emploient les deux mots à des niveaux **opposés** :
- `ticket-driven-ai` (ADR-002/005 et 003/006) : **SPC = le « quoi » abstrait**, agnostique au stack ; **REQ = le « comment, ici » concret** (stack, infra, performance, use cases). La SPC précède le REQ ; la SPC est en amont/abstraite, le REQ en aval/concret.
- `clia` (SPEC-001/REQ-001) : **REQ = le besoin abstrait** (exigences F/NF) ; **SPEC = l'interface concrète** qui satisfait le REQ (« Requis couverts »). Le REQ est en amont/abstrait, la SPEC en aval/concrète.
Autrement dit, ce que `ticket-driven-ai` appelle « spécification » (abstrait) correspond, sur l'axe d'abstraction, à ce que `clia` appelle « requis », et réciproquement. C'est la divergence signalée dans `session.md`.

**C2. Confronté à la littérature (`FND`), `clia` est mieux aligné sur l'usage dominant ; `ticket-driven-ai` est cohérent mais minoritaire dans son nommage.** Selon la `FND` :
- La majorité des références (Zave & Jackson : requis dans l'environnement, spécification à l'interface machine, plus concrète ; usage courant : requis = besoin, spécification = comment/interface) traitent le **requis comme le besoin en amont** et la **spécification comme la description d'interface en aval**. C'est exactement la convention de `clia` (REQ besoin → SPEC interface).
- `ticket-driven-ai` retient la lecture minoritaire (spécification = quoi abstrait, requis = comment concret). Sa **séparation des préoccupations** (quoi agnostique vs comment contextuel) est saine et bien fondée (Dijkstra, `FND-002-ingenierie-livrables-qualite`), mais son **nommage** heurte l'usage : en ingénierie des exigences, un « requis » est un besoin (amont), tandis que le « comment/stack » relève de la **conception** ou des **contraintes d'implémentation**, pas d'un « requirement ». Le « requis technique » de `ticket-driven-ai` est, au sens de la `FND`, un document de **contraintes d'implémentation / de conception** étiqueté « requis ».

**C3. `clia` n'est pas parfaitement pur non plus.** `REQ-001` intègre le stack dans le besoin (bash, `set -euo pipefail` en NF1 : « le script commence par `#!/usr/bin/env bash` ») et `SPEC-001` est une **spec d'interface/conception** très concrète (structure, codes de sortie, `yq`). Au sens de la `FND` : (a) une contrainte de stack est un **requis-contrainte** légitime (§5), donc l'avoir dans REQ est défendable ; (b) `SPEC-001` relève de la *design/interface specification* (§6), pas du SRS-conteneur. `clia` mélange donc besoin et contrainte dans REQ, et sa SPEC est une spec de conception — cohérent avec Zave & Jackson, mais à assumer explicitement.

**C4. Défaut de duplication d'ADR dans `ticket-driven-ai`.** `ADR-002 ≡ ADR-005`, `ADR-003 ≡ ADR-006`, `ADR-004 ≡ ADR-007` : trois décisions enregistrées **deux fois** sous des numéros différents, au contenu identique. Cela contredit le principe « un ADR = une décision » (équivalent au critère `skl-006` de `clia`) et brouille la traçabilité (les ADR se référencent mutuellement de façon croisée, 005 renvoyant à 003, 006 renvoyant à 002). Défaut d'hygiène du catalogue d'ADR.

**C5. Deux notions de livrable structurellement différentes.**
- `ticket-driven-ai` : catalogue de base (artefact-de-travail, adr, essai-de-fondation) **étendu par dépôt** (SPC/REQ/SKILL via `tda deliverable new`) ; cycle de vie par **promotion de zone** : `.dev/` (instable) → `doc/` (stable publié) ; primitives gérées par le CLI.
- `clia` : ressources classées par 6 axes, cycle de vie **point-fixe / vivant / travail**, **versionnage semver** par ensembles ; SPEC/REQ sont des ressources **vivantes séquencées versionnées** ; **pas de promotion de zone** (tout vit sous `.dev/`, la stabilité est portée par le statut et la version, pas par l'emplacement).
Conséquence : un livrable ne se transpose pas trivialement d'un modèle à l'autre (emplacement, cycle de vie et versionnage diffèrent). Les définitions de type importées de `ticket-driven-ai` doivent être **réinterprétées** dans le modèle de `clia`.

**C6. Ascendance commune, évolution divergente.** Les deux dépôts partagent la même fondation théorique (`FND-002-ingenierie-livrables-qualite`, rapatriée ici : ISO 29148/25010, Dijkstra) et pourtant aboutissent à des conventions SPEC/REQ inversées. La `FND-015-requis-et-specification` explique ce paradoxe : le vocabulaire du champ est surchargé (§7), et aucun des deux dépôts n'a **fixé explicitement la frontière machine** (§4), ce qui autorise les deux placements sous couvert du même argument « quoi vs comment ».

## Confrontation à la référence

- **Axe d'abstraction** : la convention de `clia` (requis = besoin amont, spécification = interface aval) coïncide avec la lecture dominante de la `FND` (Zave & Jackson + usage courant). La convention de `ticket-driven-ai` correspond à la lecture minoritaire (spécification = quoi abstrait), défendable mais source de confusion inter-équipes.
- **Nommage** : le point faible de `ticket-driven-ai` n'est pas sa séparation des préoccupations (excellente) mais l'emploi du mot « requis » pour le « comment/stack », que la `FND` rattache plutôt à la conception/contraintes d'implémentation.
- **Frontière machine** : aucun des deux dépôts ne l'explicite ; c'est la cause racine de la divergence (`FND` §4).
- **Livrable** : les deux modèles sont valides mais non interopérables tels quels ; la `FND-002-ingenierie-livrables-qualite` fournit l'ontologie commune (document / artefact / livrable ; cycle instable → stable) que `clia` réinterprète via son axe cycle-de-vie + versionnage.

## Synthèse et recommandations

**Constat central** : `clia` et `ticket-driven-ai` inversent l'axe d'abstraction de « spécification » et « requis ». La convention de `clia` est la mieux alignée sur la littérature dominante ; celle de `ticket-driven-ai` est cohérente mais nomme « requis » ce que le champ appelle plutôt conception/contraintes. La cause racine est l'absence de frontière machine explicite et la surcharge du vocabulaire.

Recommandations, par priorité (à l'intention de la réécriture d'`ADR-004` et du cadrage SPEC/REQ de `clia`) :

1. **(Prioritaire) Figer explicitement, dans un ADR de `clia`, la convention retenue** : REQ = **besoin/exigence** (fonctionnel, non-fonctionnel, contrainte ; amont) ; SPEC = **spécification d'interface/conception** satisfaisant le REQ (aval), au sens Zave & Jackson. Citer `FND-015-requis-et-specification` comme source. Cela verrouille la convention et prévient la re-divergence.
2. **(Prioritaire) Expliciter la frontière machine** dans chaque couple REQ/SPEC (`FND` §4) : préciser où s'arrête « ce que le système doit » (REQ) et où commence « ce que l'interface fait » (SPEC). Sans cela, la dérive quoi/comment reste possible.
3. **(Recommandé) Assumer les nuances de `clia`** (C3) : reconnaître que `REQ` peut porter des **requis-contraintes** de stack (bash) et que `SPEC` est une **spec de conception/interface**, pas un SRS-conteneur. Le documenter évite de croire à tort que `clia` sépare purement problème et solution.
4. **(Recommandé) Réconciliation inter-dépôts** : puisque savoir, skills et fondations circulent entre `clia` et `ticket-driven-ai` (FND rapatriées, skl-*), aligner l'écosystème sur **une** convention. La convention `clia` (mainstream) est le meilleur point de convergence ; `ticket-driven-ai` gagnerait à renommer son « requis technique » (comment/stack) en un type explicite de **contraintes d'implémentation / conception** et à qualifier sa SPC de **spécification d'exigences**. (Action dans un autre dépôt : recommandation, pas exécution.)
5. **(Signalé) Corriger la duplication d'ADR de `ticket-driven-ai`** (002/005, 003/006, 004/007) : déprécier les doublons pour rétablir « un ADR = une décision ». Hors périmètre d'action de `clia`.
6. **(À intégrer) Réinterpréter les définitions importées** dans le modèle de livrable de `clia` (cycle-de-vie + versionnage), sans importer la promotion de zone `.dev/ → doc/` de `ticket-driven-ai`.

## Portée et péremption

Couverture : les 7 ADR de `ticket-driven-ai` et les ressources SPEC/REQ/livrable de `clia` au 2026-07-18. Limites : l'analyse porte sur les **définitions et le nommage**, pas sur la qualité rédactionnelle de chaque spec/req individuelle ; les skills producteurs (`skl-005/006` de `ticket-driven-ai`, `skl-009/010` de `clia`) ne sont pas analysés ligne à ligne. Péremption : la réécriture d'`ADR-004` et un éventuel ADR de convention SPEC/REQ rendront cet état des lieux caduc ; toute évolution des ADR de `ticket-driven-ai` (dépôt tiers) aussi.
