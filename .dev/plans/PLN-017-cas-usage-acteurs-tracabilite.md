---
type: plan
version: 0.1.0
title: "Cas d'usage, catalogue d'acteurs et fermeture de la traçabilité (mise en oeuvre d'ANL-014)"
status: objection
---

# PLN-017 - Cas d'usage, catalogue d'acteurs et fermeture de la traçabilité

## Intention

Mettre en oeuvre les sept recommandations d'`ANL-014-cas-usage-et-acteurs-de-clia` (tâche 34 de `.dev/session.md`). L'analyse établit que la chaîne de conception du dépôt est rigoureuse en son milieu (`ADR` vers `REQ` vers `SPEC` vers code) mais **amputée à ses deux extrémités** : rien en amont ne dit qui veut quoi et pourquoi, rien en aval ne démontre que le système le permet effectivement. Ces deux manques n'en font qu'un : sans usage nommé on ne sait pas quoi tester, et sans test rattaché l'usage nommé ne prouve rien. La conséquence mesurée est que le coeur fonctionnel du CLI (le cycle de vie des sessions) n'est couvert par aucun test.

Le but de ce plan est donc d'ajouter le **maillon manquant de la couche type** (la ressource `USE`), de nommer les **acteurs** qui en sont les sujets, et de **refermer la chaîne** aux deux bouts jusqu'au test exécutable.

## Contexte

- **Source de la demande** : tâche 34 de `.dev/session.md`, qui demande un plan d'implémentation pour les recommandations d'`ANL-014` (produite en tâche 33).
- **Recommandations à couvrir** : R1 (créer le type `USE`), R2 (gabarit « but utilisateur » de Cockburn, format court), R3 (catalogue d'acteurs et de parties prenantes), R4 (fermer la traçabilité aux deux extrémités), R5 (dériver les tests d'acceptation des `USE`, en commençant par le cycle de vie des sessions), R6 (constituer le catalogue initial depuis l'existant), R7 (expliciter que le plan réalise un ou plusieurs `USE`).
- **Ordre de travail imposé** (tâche 2 de `session.md`, `ADR-007`) : recherche et préconception, puis conception, puis méthodologie (harnais et skills), puis implémentation. Ce plan respecte cet ordre, segment par segment.
- **État du chantier voisin** : `PLN-016` (installation et cycle de vie, statut `résolu`) est en attente d'approbation humaine ; son segment 1 a déjà produit `ADR-010` (statut `Proposé`), et `.dev/session.md` porte un breakpoint de validation de cet ADR. `PLN-016` prévoit en 2.4 un harnais de test cumulatif qui recoupe R5 (voir objection 3).
- **État vérifié de la couche relations** (constaté le 2026-07-28) : `.dev/resource-types.yaml` déclare un vocabulaire de six relations, mais aucun frontmatter du dépôt ne porte de champ de relation, et les références croisées sont écrites en texte (backticks), donc non résolvables par un programme. La couche relations d'`ADR-004` est **déclarée mais non instanciée** (voir objection 2).
- **État vérifié de `src/lib/resource.sh`** (constaté le 2026-07-28) : le module code en dur la table de la version 0.1.0 d'`ADR-004`, abolie par la version 0.2.0 (voir objection 1).
- **Contraintes de gouvernance** : généricité du harnais et absence d'information de domaine (`ADR-005`, `PDC-003`) ; source de vérité documentaire unique (`PDC-006`) ; déterminisme de `clia` (`PDC-001`) ; automatiser ce qui n'exige pas de jugement (`PDC-002`) ; traçabilité et versionnage atomique (`PDC-009`) ; l'agent n'édite jamais les fichiers en édition humaine uniquement et n'opère aucune action git.
- **Hors périmètre explicite** : la correction de `doc/cli/` (constat C7 d'`ANL-014`, contenu étranger au dépôt) relève d'un rapport de bogue distinct (`skl-013`, `ADR-003`) et n'est pas traitée ici.

## Spécification du livrable

Le livrable **de la tâche 34** est le présent plan. Son exécution relèvera d'une ou plusieurs tâches ultérieures et produira :

- un **ADR** (`ADR-011`) définissant le type de ressource `USE`, sa place dans la chaîne de conception, son gabarit, ses règles d'altitude et le catalogue d'acteurs ;
- l'entrée `usage` dans `.dev/resource-types.yaml` et les relations typées associées ;
- un **skill** (`skl-016-cas-d-usage`) encadrant la production d'un `USE` ;
- l'amendement des harnais (`CLAUDE.md`, `ARCHITECTURE.md`) et des skills producteurs concernés ;
- un **catalogue initial de `USE`** dans `.dev/usages/`, dérivé de l'existant ;
- l'extension de `test/` en tests d'acceptation rattachés aux `USE` ;
- une capacité d'inspection de couverture dans `clia`.

## Plan proposé

### Segment 1 : Conception (R1, R2, R3, R7)

#### 1.1 ADR du type de ressource `USE`

Produire `ADR-011` (`skl-006`) actant :

- **le type** : un `USE` décrit un **but d'acteur atteint de bout en bout**, à la question *qui veut quoi et pourquoi* ; il ne se confond pas avec le `REQ` (*ce que le système doit garantir*) ni avec le `SPEC` (*comment l'interface se comporte*). Motiver le refus de la fusion dans `REQ` par `FND-015`, `FND-018` (section 10.6) et le contre-exemple relevé par `ANL-011` ;
- **sa place dans la chaîne** : `USE` en amont de `REQ`, correspondant au niveau des exigences de parties prenantes de la norme 29148, aujourd'hui absent ;
- **le gabarit** (R2), au format court par défaut : frontmatter (`type: usage`, `version`, `title`, `status`, `date`) ; en-tête (acteur principal, niveau, portée, parties prenantes et intérêts, préconditions, garantie de succès, garantie minimale) ; flux nominal numéroté ; flux alternatifs et d'échec avec issue et code de retour attendu ; critères d'acceptation directement scriptables ; traçabilité ;
- **les deux règles d'altitude** : titre en verbe à l'infinitif orienté but de l'acteur (« Ouvrir une session de travail », jamais « Commande `ses open` ») ; interdiction du niveau sous-fonction comme unité de fichier, pour prévenir l'anti-motif de décomposition fonctionnelle (constat C3) ;
- **le catalogue d'acteurs** (R3), à partir de la typologie proposée par `ANL-014` (A1 à A6, P1 à P4), avec la **règle de séparation** entre acteurs de méthode (génériques, propres au système d'augmentation) et acteurs de domaine (propres au dépôt hôte). Voir objection 5 ;
- **la relation plan vers usage** (R7) : un `PLN` déclare le ou les `USE` qu'il réalise, de sorte que le besoin cesse de se perdre à la clôture de session (constat C8) ;
- **les conséquences** sur `ARCHITECTURE.md`, dont la section « Acteurs et rôles » range `clia` parmi les acteurs alors qu'il est le système décrit (constat C2). Voir objection 6 ;
- **les non-décisions** reprises d'`ANL-014` : pas de user stories, pas de Gherkin ni de cadre BDD complet, pas de fusion dans `REQ`.

#### 1.2 Couche type et relations

Ajouter à `.dev/resource-types.yaml` l'entrée `usage` (prefix `USE`, emplacement `.dev/usages`, nommage séquencé, skill `skl-016-cas-d-usage`, édition `co`) et les relations nécessaires à R4 (`sert` ou réemploi de `derive-de` pour l'amont, `demontre` pour l'aval usage vers test). Trancher ici, conformément à la décision prise en 1.1, la **forme d'écriture** des relations dans le frontmatter, afin de ne pas créer un mécanisme propre au `USE` en concurrence du mécanisme général (`PDC-006`). Voir objection 2.

**BREAKPOINT 1.** Arrêt après 1.1 et 1.2. L'humain valide le modèle (le type, le gabarit, le catalogue d'acteurs, la règle de séparation méthode/domaine et la forme des relations) avant toute production de masse. Ce qui suit crée un répertoire, un skill, une dizaine de fichiers et modifie les harnais : ces effets sont coûteux à défaire si le modèle change.

### Segment 2 : Méthodologie (R2, R7)

#### 2.1 Skill de production

Produire `skl-016-cas-d-usage` (`skl-001` comme méta-skill) : quand l'utiliser et quand ne pas l'utiliser, processus, critères de qualité, structure du livrable avec le gabarit décidé en 1.1. Graver les deux règles d'altitude et la liste des acteurs valides comme critère vérifiable. Skill générique, sans information de domaine (`ADR-005`, `PDC-003`).

#### 2.2 Amendement des harnais et des skills producteurs

- `CLAUDE.md` : ligne `USE` dans la table des livrables (qui est une **vue** de `.dev/resource-types.yaml`, `PDC-006`), et mention du maillon dans la chaîne de conception.
- `ARCHITECTURE.md` : renvoi vers le catalogue d'acteurs de `ADR-011` plutôt que duplication, et correction de la modélisation relevée au constat C2.
- `skl-003-plan-de-travail` : champ de frontmatter déclarant le ou les `USE` réalisés (R7).
- `skl-010-requis` : chaque `REQ` déclare le ou les `USE` qu'il sert (R4, amont).
- `skl-009-specification` : rappel que la table de traçabilité existante se prolonge désormais vers l'amont.

### Segment 3 : Catalogue initial (R6)

#### 3.1 Constituer les `USE` depuis l'existant

Six à dix `USE` de niveau « but utilisateur » suffisent à couvrir le système actuel. La matière existe déjà et n'attend qu'à être réorganisée par but : le « Flux principal » d'`ARCHITECTURE.md`, les transitions d'`ADR-006`, les conditions d'échec déjà spécifiées dans `SPEC-002` et `REQ-002-NF4`, et les deux capacités attendues énoncées dans `.dev/session.md`. Ordre de production, par valeur décroissante :

1. **parcours de session** (acteur A1) : ouvrir une session de travail, clore une session de travail, inspecter l'état courant ;
2. **parcours de gouvernance** (acteurs A1 et A2) : soumettre un problème et obtenir un plan, objecter à un plan, reprendre après un breakpoint ;
3. **parcours d'inspection** (acteurs A1 et A4) : inspecter les ressources et leurs versions, publier une version métier ;
4. **parcours d'installation** (acteur A3) : **exclu de ce segment**, voir objection 4.

Chaque `USE` produit porte ses flux d'échec et ses critères d'acceptation, sans quoi le segment 4 n'a pas de matière.

**BREAKPOINT 2.** Arrêt après 3.1. L'humain valide le catalogue avant que les tests et les liens de traçabilité ne s'y accrochent : un `USE` mal découpé propage son défaut dans les tests qui en dérivent.

### Segment 4 : Traçabilité et vérification (R4, R5)

#### 4.0 Prérequis : réconcilier `src/lib/resource.sh` avec `ADR-004` v0.2.0

Étape ajoutée par ce plan, non prévue par `ANL-014`, rendue nécessaire par l'objection 1. Le module d'inspection des ressources est resté sur le modèle aboli ; toute capacité de mesure ajoutée par-dessus hériterait de ses erreurs.

#### 4.1 Rattachement amont et aval

Renseigner les relations décidées en 1.2 : chaque `REQ` déclare le ou les `USE` qu'il sert ; chaque `USE` déclare les tests qui le démontrent ; chaque test nomme le `USE` couvert.

#### 4.2 Tests d'acceptation dérivés des `USE`

Étendre `test/` en commençant par le cycle de vie des sessions, aujourd'hui couvert par zéro assertion alors qu'il est la fonction déclarée du système. Le motif de bac à sable isolé existe déjà dans `test/test_clia.sh` (`mktemp -d`, copie de `src/`, `trap` de nettoyage) et le contrat observable d'un CLI (arguments, sortie standard, sortie d'erreur, code de retour, effets sur le système de fichiers) est directement scriptable. Chaque critère d'acceptation d'un `USE` devient une assertion nommée par ce `USE`.

Sur l'outillage : ne pas ajouter `bats-core` ni `shellspec` à ce stade (la sobriété actuelle du dépôt se limite à `bash` et `yq`) ; le script maison suffit. Appliquer en revanche la technique du fichier de référence aux sorties d'aide (`clia -h`, `--man`), volumineuses et devant rester stables.

#### 4.3 Mesure de couverture dans `clia`

Ajouter une commande d'inspection déterministe et en lecture seule mesurant les deux indicateurs de `FND-018` : usage sans test (couverture avant) et test sans usage (couverture arrière). Cohérent avec `PDC-001` et `PDC-002` ; une référence pendante étant déjà un bogue par `ADR-003`, le contrôle prolonge l'existant. Documenter la commande dans `src/clia.doc.yaml` pour satisfaire la cohérence dispatch/documentation (`REQ-001-F9`).

## Objections de l'agent IA

1. **`src/lib/resource.sh` n'est plus conforme au modèle qu'il est censé exposer.** Constat vérifié : le module code en dur la table d'`ADR-004` v0.1.0, avec les cycles `pointfixe` et `travail` **abolis** par la v0.2.0 ; `PDC` et `skl` y sont inconnus (`clia res ls PDC` retourne « type de ressource inconnu ») ; la version des `FND`/`ANL` est extraite d'une date de nom de fichier qui n'existe plus depuis le renommage séquencé (colonne vide) ; l'état des `PLN` est lu par un `grep` qui capture du texte d'objection ; et `clia --version --long` cherche encore `.dev/ressources.yaml`, aboli. Si ce plan est exécuté tel quel, la mesure de couverture de 4.3 s'ajoute à un module qui rapporte des données fausses sur quatre des neuf types qu'il connaît, et le contrôle de traçabilité hérite de cette fausseté sans que rien ne le signale. Suggestion : ouvrir un `BUG-007` pour cet écart, et conserver l'étape 4.0 comme prérequis bloquant du segment 4.

2. **La couche relations d'`ADR-004` est déclarée mais non instanciée.** `.dev/resource-types.yaml` déclare six relations (`specifie`, `derive-de`, `remplace`, `reference`, `produit-par`, `viole`), mais aucun frontmatter du dépôt ne porte de champ de relation, et les références croisées sont écrites en texte non résolvable. R4 suppose pourtant une traçabilité lisible par un programme. Si ce plan est exécuté tel quel, on invente un mécanisme de relations pour le seul `USE` alors que le mécanisme général reste à instancier : deux mécanismes concurrents pour la même fonction, en violation directe de `PDC-006`. Suggestion : trancher explicitement en 1.1 et 1.2 entre (a) `USE` inaugure la couche relations pour tout le corpus, ce qui élargit le plan, et (b) `USE` adopte une forme provisoire assumée, avec une dette nommée. L'agent ne tranche pas seul.

3. **Collision avec le segment 2.4 de `PLN-016`.** `PLN-016` prévoit un « harnais de test cumulatif en bac à sable » couvrant `init`, `upgrade` et `downgrade` ; R5 prévoit des tests d'acceptation dérivés des `USE`, dont le parcours d'installation. Si les deux plans s'exécutent sans arbitrage, le dépôt se retrouve avec deux harnais de test d'origine et de forme différentes pour le même parcours, ce que le contexte de session dénonce précisément (« nous faisons beaucoup de tests, mais ceux-ci sont fragmentés et ne se cumulent pas »). Suggestion : décider que `PLN-017` fixe la **forme** (tout test dérive d'un `USE` et le nomme) et que `PLN-016` fournit le **contenu** du parcours d'installation dans cette forme.

4. **Le `USE` du parcours d'installation dépend d'un ADR non validé.** `ADR-010` est au statut « Proposé », porte une question de conception explicitement non tranchée (qui exécute le `git init` que suppose le livrable « créer un nouveau repo », puisque `clia setup` ne fait pas de git), et `.dev/session.md` porte un breakpoint de validation de cet ADR dont l'énoncé d'objection est inachevé. Si ce plan est exécuté tel quel, on grave un parcours d'acteur qui changera avec la décision, et les tests qui en dérivent seront à réécrire. Suggestion : exclure ce `USE` du segment 3 (déjà fait au point 3.1) et le produire après validation d'`ADR-010`.

5. **Tension de généricité sur le catalogue d'acteurs.** `ARCHITECTURE.md` est un fichier de harnais, tenu par `ADR-005` et `PDC-003` à ne porter aucune information de domaine, et il porte déjà une section « Acteurs et rôles ». Les acteurs A1 à A4 d'`ANL-014` (opérateur, agent, installateur, mainteneur) sont des rôles du **système d'augmentation**, donc génériques et réutilisables ; mais dans un dépôt hôte équipé, les `USE` porteront des acteurs **de domaine**. Si ce plan est exécuté sans expliciter cette distinction, `skl-016` produira des `USE` de méthode et des `USE` de domaine dans le même répertoire sans règle de séparation, et le harnais cessera d'être transposable, ce qui est exactement le risque déjà consigné par `BUG-003`. Suggestion : graver la séparation en 1.1 (catalogue de méthode générique fourni par le harnais, catalogue de domaine propre au dépôt hôte).

6. **La correction d'`ARCHITECTURE.md` doit être qualifiée avant d'être faite.** `ARCHITECTURE.md` range `clia` parmi les acteurs alors qu'il est le système décrit (constat C2). Si ce plan est exécuté tel quel, le segment 2 modifie un harnais au statut accepté sans qu'aucune décision tracée ne motive le changement, ce qui affaiblit la traçabilité que ce même plan cherche à renforcer (`PDC-009`). Suggestion : rattacher explicitement la correction aux conséquences d'`ADR-011` plutôt que de la traiter comme une retouche éditoriale ; l'ouverture d'un `BUG-*` distinct reste possible si l'humain préfère qualifier l'écart comme tel.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
