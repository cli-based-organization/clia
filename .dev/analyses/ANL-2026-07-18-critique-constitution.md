# ANL-2026-07-18 - Analyse critique de CONSTITUTION.md : gouvernance vs orchestration

- **Date** : 2026-07-18
- **Périmètre** : le fichier `CONSTITUTION.md` (racine du dépôt), dans sa version courante (harness-files 0.4.0). Renvois croisés considérés : `CLAUDE.md`, `.dev/skills/skl-003`, `.dev/skills/skl-004`. Exclusions : contenu métier, `.git/`.
- **Référence** : `FND-2026-07-18-documents-harness-ia` (distinction gouvernance / orchestration de processus, séparation des préoccupations).

## Objet

Vérifier la problématique posée en tâche 12 : `CONSTITUTION.md` mêlerait deux types d'information de natures différentes, le **domaine de responsabilité et d'intervention des acteurs** (humain, automatismes/`clia`, agent IA) et le **processus et son orchestration**. Confronter le fichier à la référence de fondation, mesurer l'écart, et recommander un refactor. L'analyse recommande ; elle n'exécute aucun refactor (le recadrage de `CONSTITUTION.md` relève d'une tâche humaine distincte).

## Périmètre et méthode

Corpus : les sections de premier et second niveau de `CONSTITUTION.md`. Grille d'analyse, dérivée de la `FND` (section 4) : classer chaque section selon la couche à laquelle son contenu appartient.

- **G - Gouvernance** : acteurs, domaines de responsabilité et d'intervention, droits d'édition, interdits, principes non négociables, permissions.
- **O - Orchestration de processus** : phases, états, transitions, artefacts, points de contrôle et de reprise.
- **H - Hybride** : section portant les deux couches à la fois (signal direct de mélange).

Chaque section est localisée par son titre (stable) ; les constats citent des exemples concrets.

## Inventaire

Sections de `CONSTITUTION.md` (dans l'ordre du fichier) et classement :

1. « Principe » (modèle objection-sociocratique) : **H** (énonce un principe, mais décrit d'emblée le déroulé du processus : soumission, plan, objection, exécution).
2. « Cycle de vie d'un plan » (`proposé → objection → résolu → approuvé → exécuté`) : **O** (états et transitions).
3. « Objection raisonnée » (définition, conditions de levée) : **O** (règle de processus).
4. « Canaux d'objections (séparés) » (table origine → lieu de consignation) : **H** (attribue un lieu de processus selon l'acteur : responsabilité + orchestration).
5. « Règle absolue » (aucune exécution sous objection ouverte) : **O** (contrainte d'exécution).
6. « Breakpoint et exécution segmentée » : **H** (politique d'approbation = gouvernance ; mécanisme d'arrêt/reprise et de segments = orchestration).
7. « Classification des documents » (édition humaine uniquement / IA uniquement / co-édition) : **G** (droits d'édition par acteur).
8. « Interface de travail : fichiers, pas conversation » : **G/principe** (principe méthodologique transverse : source de vérité = fichiers).
9. « `clia` : gardien déterministe de l'intégrité » (ce que `clia` peut muter, ce que l'agent n'invoque jamais) : **G** (domaine d'intervention des acteurs).
10. « Git commit : responsabilité de l'humain » (interdits pour l'agent, exception documentaire) : **G** (responsabilité et interdits par acteur).

Bilan : 4 sections de gouvernance pure (7, 8, 9, 10), 3 d'orchestration pure (2, 3, 5), 3 hybrides (1, 4, 6). Aucune séparation structurelle entre les deux couches : elles sont **entrelacées** dans l'ordre du fichier (gouvernance en tête via le principe, puis orchestration au milieu, puis gouvernance en fin).

## Constats

**C1. Le mélange est réel et structurel, pas anecdotique.** La problématique est confirmée : 40 % des sections sont de la gouvernance pure, 30 % de l'orchestration pure, 30 % hybrides. Les deux natures cohabitent sans frontière : un lecteur cherchant « qui a le droit de modifier quoi » (gouvernance, section 7) doit traverser le cycle de vie du plan et la règle absolue (orchestration, sections 2 à 5).

**C2. Le nom « constitution » est en tension avec le contenu.** Selon la `FND` (section 3c), une « constitution » désigne dans le field la couche de **principes non négociables et de gouvernance**. Or `CONSTITUTION.md` consacre son centre (sections 2 à 6) à l'**orchestration** du travail (états d'un plan, objections, breakpoint). Le fichier déborde donc la portée attendue de son nom.

**C3. Les sections hybrides sont le symptôme le plus net.** « Canaux d'objections » (4) mêle une règle d'imputabilité (l'humain consigne dans `session.md`, l'agent dans le plan : gouvernance) et une mécanique de processus (où vivent les objections dans le flux). « Breakpoint » (6) mêle une politique d'approbation (gouvernance) et un mécanisme d'arrêt/reprise segmenté (orchestration) : la `FND` (section 4, point HITL) identifie précisément ce couple comme devant être distingué (politique « quelles actions exigent approbation » vs mécanisme « comment l'exécution s'arrête et reprend »).

**C4. Rythmes de changement hétérogènes dans un même fichier.** Les sections d'orchestration bougent plus vite (le breakpoint vient d'être ajouté en tâche 11 ; le cycle de vie peut se raffiner), tandis que les sections de gouvernance (droits d'édition, rôle de `clia`, responsabilité git) sont stables. Les mêler force à rééditer, et donc à re-versionner, un document de principes stable à chaque raffinement de processus (anti-motif documenté, `FND` section 4).

**C5. Matériau de gouvernance déjà présent mais non consolidé.** Les éléments de responsabilité des trois acteurs (humain, `clia`, agent IA) existent, mais éparpillés dans trois sections (7, 9, 10) plus des mentions dans `CLAUDE.md` (« Gouvernance ») et dans plusieurs skills. Il n'existe pas de vue unifiée (type matrice de responsabilités) des domaines d'intervention par acteur, alors que la `FND` (section 4, point RACI) en montre l'intérêt.

**C6. Renvois croisés couplés à la structure actuelle.** `CLAUDE.md` et les skills renvoient à des sections nommées de `CONSTITUTION.md` (« Classification des documents », « Breakpoint et exécution segmentée », « Git commit »). Tout refactor devra maintenir ces renvois (`CLAUDE.md`, `skl-003`, `skl-004` au minimum), sous peine d'incohérence croisée (critère `skl-004`).

## Confrontation à la référence

Face à la `FND-2026-07-18` :

- **Écart principal** : la `FND` (sections 3 et 4) et trois corpus convergents (SDD/Spec Kit, politique/procédure et RACI, bonnes pratiques Claude Code) recommandent de **séparer** gouvernance et orchestration ; `CONSTITUTION.md` les **fusionne** dans un seul fichier sans frontière (C1). Écart : structurel, sur l'axe central de la fondation.
- **Écart de portée du nom** : le field réserve « constitution » à la gouvernance/principes (`FND` 3c) ; le fichier y loge l'orchestration (C2). Écart : nominal et de périmètre.
- **Écart de concision/séparation** : les bonnes pratiques Anthropic (`FND` section 3) prônent des fichiers courts, à préoccupation unique ; le fichier cumule quatre rôles (`FND` section 3 : contexte de responsabilité, règles, principes, processus). Écart : préoccupations non séparées.
- **Point conforme** : la séparation des **canaux** d'objections par acteur (humain dans `session.md`, agent dans le plan) est, elle, un bon réflexe de gouvernance ; le problème n'est pas la règle mais son entrelacement avec l'orchestration.

## Synthèse et recommandations

**Constat central** : la problématique est confirmée et mesurée. `CONSTITUTION.md` est un document à double couche (gouvernance + orchestration) sans séparation structurelle, ce qui contredit l'axe central de la fondation et la portée attendue du nom « constitution ».

Recommandations de refactor, par priorité (à trancher par l'humain, tâche « [Recadrage humain] CONSTITUTION.md ») :

1. **(Prioritaire) Scinder en deux documents de harnais à préoccupation unique** :
   - un document de **gouvernance et responsabilités des acteurs** : classification des documents / droits d'édition (7), rôle et domaine de `clia` (9), responsabilité git de l'humain (10), et la politique d'approbation (facette gouvernance du breakpoint). C'est le « qui, quoi, sous quelles contraintes ».
   - un document de **processus et orchestration** : principe objection-sociocratique (1), cycle de vie d'un plan (2), objection raisonnée (3), règle absolue (5), mécanisme de breakpoint et d'exécution segmentée (facette orchestration de 6), lieu de consignation des objections (facette processus de 4). C'est le « dans quel ordre, produisant quoi ».
2. **(Prioritaire) Aligner le nom sur la portée** : réserver `CONSTITUTION.md` à la couche gouvernance/principes (sens field), et sortir l'orchestration vers un document dédié (par exemple un `PROCESSUS.md` de harnais, ou une section clairement isolée). Décision de nommage à valider par l'humain.
3. **(Recommandé) Dissocier explicitement les sections hybrides** (C3) : pour « Canaux d'objections » et « Breakpoint », séparer la règle de gouvernance (imputabilité, quelles actions exigent approbation) du mécanisme de processus (où vivent les objections, comment l'exécution s'arrête et reprend), et placer chaque moitié dans le document correspondant, avec renvoi mutuel.
4. **(Recommandé) Consolider une matrice de responsabilités** des trois acteurs (humain, `clia`, agent IA) à partir du matériau existant dispersé (C5), sur le modèle RACI de la `FND` : une vue unique « qui peut/doit/ne peut pas » par type d'opération.
5. **(À ne pas oublier) Maintenir la cohérence des renvois croisés** (C6) après tout déplacement : mettre à jour `CLAUDE.md` et les skills renvoyant à `CONSTITUTION.md` (`skl-003`, `skl-004`), et re-versionner atomiquement les fichiers de harnais touchés (`ADR-004`).

Ces recommandations alimentent la tâche humaine de recadrage de `CONSTITUTION.md` ; elles ne préjugent pas de la décision de nommage ni du nombre exact de fichiers, qui reviennent à l'humain.

## Portée et péremption

Couverture : la totalité des sections de `CONSTITUTION.md` au 2026-07-18 (harness-files 0.4.0), plus le repérage des renvois croisés principaux. Limites : n'inventorie pas exhaustivement tous les renvois à `CONSTITUTION.md` dans le dépôt (une recherche `grep` dédiée serait à faire avant refactor) ; ne propose pas le contenu rédigé des documents cibles (c'est l'objet du refactor lui-même). Péremption : liée à l'évolution de `CONSTITUTION.md` ; toute réécriture (recadrage humain à venir) rend cet état des lieux caduc.
