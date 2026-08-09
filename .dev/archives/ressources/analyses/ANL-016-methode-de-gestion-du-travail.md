---
type: analyse
version: 0.2.0
title: "Méthode de gestion du travail : ressources et mécaniques manquantes (préparation d'un ADR)"
date: 2026-08-02
---

# ANL-016 - Méthode de gestion du travail dans le dépôt

- **Périmètre** : le dépôt au 2026-08-02, examiné sous l'angle de **la mémoire et de l'ordonnancement du travail restant** : `.dev/bugs/`, `.dev/plans/`, `.dev/adr/`, `.dev/specs/`, `.dev/requis/`, `.dev/principes/`, `.dev/acteurs/`, `.dev/usages/`, `.dev/skills/`, `.dev/resource-types.yaml`, `.dev/session.md`, `.dev/session-x01.md`, `.dev/session-x02.md`, `.dev/sessions/`, `.dev/logs/ia-output/`, `CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`. Corpus externe consulté en lecture seule : `../../noumanity-dev/ticket-driven-ai` et `../../noumanity-ai-assisted-development-toolkit/nou-methodologies-ia/experimentations/deeptech-ticket-driven`. Exclus : `.git/`, `src/`, `test/`, `doc/` (le code n'est pas l'objet de cette analyse).
- **Référence** : [`FND-019-systemes-de-suivi-du-travail`](../fondations/FND-019-systemes-de-suivi-du-travail.md), produite le même jour, dont les constats servent de grille de mesure.

## Changelog

- **Révision 1 (2026-08-02, tâche 3)** : incorporation des réponses humaines aux cinq objections de la révision initiale. Cinq changements de fond :
  - **objection 1 résolue** (recommandation de l'agent suivie) : l'esquisse de plan est réordonnée, les étapes 3 à 5 sont explicitement conditionnées à la résolution de [`BUG-009`](../bugs/BUG-009-contexte-repertoire-ignore-par-clia.md) et [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) ;
  - **objection 2 résolue** : l'humain tranche en faveur de la production d'une **ressource « ressource »**. La question n'est donc plus reportée : le méta-type entre dans le périmètre, et l'`ADR` cesse de porter les définitions de types ;
  - **objection 3 résolue** : « Extreme SMART » ne devient **pas** un `PDC`. Il est porté par un `ADR` et décliné en `REQ` et `SPEC` selon nécessité. `PDC-011` est retiré des ressources à produire ;
  - **objection 4 résolue** : l'horodatage est acté (sessions horodatées, datation des tâches par l'historique git, commandes `clia session elapsed` et `clia session task elapsed <N>`), **sans limite de temps** pour l'instant ;
  - **objection 5 résolue par la négative** : la capture bon marché **par l'agent** est refusée par principe. Un agent ne crée aucune entrée de travail ; il ne peut que **suggérer**, dans une analyse ou dans une objection, et l'humain valide toute intention et tout élément de travail. Le constat C8 est requalifié en conséquence, et la dimension D6 cesse d'être un écart.
  - Quatre **objections nouvelles** naissent de ces réponses et sont ouvertes (voir « Objections de l'agent IA »).
  - **Objection humaine ouverte, non traitée ici** : la tâche 4 de `.dev/session.md` porte « adopter une ressource comportement attendu », qui renverse la recommandation de la section correspondante. Cette section est conservée en l'état et **signalée comme contredite** ; sa révision relève de la tâche 4, dont l'énoncé n'est pas clos.

## Objet

Établir si le dépôt dispose d'une méthode de gestion du travail suffisante, et préparer la matière d'un ADR qui la définirait. L'analyse répond aux questions posées par la tâche 2 de `.dev/session.md` : quelles ressources manquent, lesquelles doivent être adaptées, les mécaniques actuelles suffisent-elles, faut-il une ressource « comportement attendu », et que vaut le système de graphe d'intention esquissé dans les deux dépôts antérieurs.

Sa conclusion tient en une phrase : **le dépôt sait produire du travail et sait le tracer, mais il n'a aucun endroit où le travail restant existe en tant qu'objet**, si bien que la mémoire de ce qui reste à faire est répartie sur six supports hétérogènes dont aucun n'est interrogeable, ordonnable, ni purgeable.

## Périmètre et méthode

**Grille d'analyse**, dérivée de [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) :

| Dimension | Question posée au corpus | Origine |
|---|---|---|
| D1 Localisation | Où vit l'information « ceci reste à faire » ? | `FND-019` section 3 |
| D2 Coût d'entrée | Que coûte l'enregistrement d'une chose à faire ? | `FND-019` sections 4.3 et 5.3 |
| D3 Interrogabilité | Peut-on obtenir mécaniquement la liste de ce qui reste ? | `FND-019` sections 5.4 et 6.3 |
| D4 Relation | Le blocage entre deux travaux est-il représentable ? | `FND-019` sections 7.1 à 7.3 |
| D5 Sortie du stock | Qu'est-ce qui fait sortir un élément autrement qu'en le faisant ? | `FND-019` sections 7.4 et 10.2 |
| D6 Capture sans engagement | Peut-on retenir une idée sans s'engager à la traiter ? | `FND-019` section 9.1 |
| D7 Attendu énonçable | Un écart de comportement est-il rattachable à un attendu écrit ? | `FND-019` sections 2.3 et 8 |
| D8 Focalisation | Le système impose-t-il un en-cours limité ? | `FND-019` sections 7.2 et 9.2 |

**Méthode** : recensement exhaustif des porteurs d'information de travail restant dans le périmètre, par lecture des statuts en frontmatter et par recherche des formulations de report (« dette nommée », « hors portée », « reste à faire », « non implémenté », « à instancier ») ; puis application de la grille.

## Inventaire

### 1. Les six supports du travail restant

**Support 1 : `.dev/bugs/`, statut en frontmatter.** Neuf `BUG`, dont **sept au statut `diagnostiqué`** et deux `résolu`. Les sept diagnostiqués sont : [`BUG-002`](../bugs/BUG-002-agent-porte-mecaniques-deterministes.md) (écart à `PDC-002`), [`BUG-003`](../bugs/BUG-003-frontiere-methode-domaine-sous-tension.md) (`PDC-003`), [`BUG-004`](../bugs/BUG-004-constitution-mele-gouvernance-orchestration.md) (`PDC-005`), [`BUG-005`](../bugs/BUG-005-source-verite-documentaire-non-implementee.md) (`PDC-006`), [`BUG-006`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md) (`PDC-007`), [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) (`ADR-004` et `PDC-006`), [`BUG-009`](../bugs/BUG-009-contexte-repertoire-ignore-par-clia.md) (contexte-répertoire). C'est le seul support **normalisé** du corpus : un type, un emplacement, un statut en frontmatter, un skill.

**Support 2 : `.dev/plans/`, statut en frontmatter.** Vingt `PLN`. Quinze `exécuté`, un `proposé` ([`PLN-020`](../plans/PLN-020-double-racine-contexte-repertoire.md), quatre objections ouvertes), un `approuvé` non terminé ([`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md)), et trois portant une **phrase** en guise de statut :

- `PLN-008` : `remplacé par PLN-018 et PLN-019` ;
- `PLN-013` : `remplacé par PLN-016 (Phase A acquise)` ;
- `PLN-016` : `partiellement exécuté ; portée réduite par PLN-018 et PLN-019`.

Reste à faire, porté par ces plans : pour `PLN-017`, le segment 2 en entier (les skills `skl-016-acteur` et `skl-017-cas-d-usage`, l'amendement de `CLAUDE.md` et des skills producteurs), les trois quarts de l'étape 3.2 (parcours de session, de gouvernance et d'inspection), l'étape 3.3 et le segment 4 ; pour `PLN-020`, la totalité, sous quatre objections ; pour `PLN-016`, un reliquat non délimité.

**Support 3 : prose de report dans les documents de conception.** Dix occurrences réparties sur six fichiers ([`ADR-006`](../adr/ADR-006-gestion-des-sessions.md), [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), [`ADR-011`](../adr/ADR-011-ressource-acteur.md), [`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md), [`SPEC-002`](../specs/SPEC-002-cli-clia.md), [`REQ-001`](../requis/REQ-001-convention-cli-bash.md)). Contenus identifiés :

| Report | Porteur | Nature |
|---|---|---|
| Couche de relations lisible par un programme à instancier pour tout le corpus | `ADR-011`, `ADR-012`, `resource-types.yaml` | dette nommée |
| Réconciliation de la section « Acteurs et rôles » d'`ARCHITECTURE.md` | `ADR-011` | écart connu à `PDC-006`, **non tracé par un `BUG`** |
| `upgrade` et `downgrade` réservées, non implémentées | `SPEC-002` | fonctionnalité annoncée absente |
| Régularisation de l'état « équipé sans marque » | `ADR-010` D9 | cul-de-sac reconnu |
| Contrôle de cohérence dispatch contre documentation | `REQ-001` | vérification exigée, non fournie |
| Tests d'acceptation dérivés des `USE` (R5 et volet aval de R4) | `PLN-017`, `ADR-012` | portée retirée par décision humaine |
| Empreinte d'installation écrite sans lecteur | `ADR-013` | fonctionnalité sans consommateur |

**Support 4 : `.dev/session-x02.md`, session en planification.** Sept sujets, en **édition humaine uniquement** : notion de harnais et ressource harnais-documentaire ; harnais `STACK.md` ; remplacement de bash par rust avec moteur cuelang ; objection « ADR contre ressources ontologiques » et ajout d'une ressource « ressource » ; abolition de la distinction ressource vivante contre point fixe ; ajout de trois principes fondamentaux (contextualité, focus, interne/externe) ; réécriture d'`ADR-004`. Un `session-x01.md` existe également, **vide**.

**Support 5 : `.dev/session.md`, session active.** Quatre objectifs de session non couverts par les tâches (définir les fonctionnalités de coeur et étendues, inspecter et corriger tous les ADR, comportement correct de `clia` dans les principaux cas d'usage, extensibilité démontrée), plus la tâche `xy` en préparation et la tâche `x` de traitement des objections de `PLN-020`.

**Support 6 : `.dev/logs/ia-output/`, traces immuables.** Quarante-six logs. Leurs sections « Objections de l'agent », « Limitation » et « Notes » contiennent du travail restant qui n'a pas d'autre porteur. Exemple vérifié : `LOG-2026-07-17-task-37.md` consigne que les dix `ACT` ont été produits avant `skl-016-acteur` et suggère de « vérifier les dix `ACT` contre le skill obtenu » ; cette action n'existe nulle part ailleurs. Le log étant **immuable**, cette information ne peut jamais être marquée comme faite.

### 2. Récapitulatif chiffré

| Support | Éléments ouverts | Statut normalisé | Interrogeable | Éditable par l'agent |
|---|---|---|---|---|
| `.dev/bugs/` | 7 | oui | partiellement (voir `BUG-007`) | oui (co-édition) |
| `.dev/plans/` | 3 | non (3 statuts hors vocabulaire) | non | oui (édition IA) |
| Prose de report | 10 sur 6 fichiers | non | non | oui |
| `session-x02.md` | 7 | non | non | **non** |
| `session.md` | 6 | non | non | **non** |
| Logs | non dénombrable | non | non | **non** (immuables) |

**Au moins trente-trois éléments de travail identifiés et ouverts**, sans ordre total, sans relation, sans propriétaire de la question « que fait-on ensuite ? ».

### 3. Ce que le corpus externe apporte

Deux dépôts antérieurs portent le modèle dont la tâche demande l'examen.

- `deeptech-ticket-driven` : `ADR-001` (méthodologie de tickets), `ADR-002` (ancrage Extreme SMART), `ADR-003` (catalogue de livrables), `FND-001` (productivité et tâches SMART), `SPC-001` et `SPC-003` (specs déduites des commandes `ticket` et `issue`), et surtout `issues/ISU-010-gestion-des-issues/issue.md`, qui est le document source du graphe d'intention.
- `ticket-driven-ai` : `INTENTION.md` et `README.md`, qui consolident le modèle en deux régimes (issue NOT-SMART, ticket Extreme SMART) et le CLI `tda`.

Le modèle qui en ressort, et que la tâche `xy` de `session.md` reprend : deux régimes de travail, une relation orientée « X débloque Y » entre issues, un graphe orienté non disjoint, une priorité unique, et une règle d'obsolescence (« si X débloque Y, la résolution de Y rend X obsolète »).

## Constats

**C1. Le travail restant n'existe pas comme objet ; il existe comme effet de bord de six supports.** Aucun de ces six supports n'a pour fonction de porter le travail restant : le `BUG` porte un défaut, le `PLN` porte une proposition d'intervention, l'`ADR` porte une décision, la session porte une demande, le log porte une trace. Le travail restant est ce qui **déborde** de chacun. C'est la cause directe de la problématique énoncée dans `session.md` (« beaucoup de choses à faire, impossible de tout faire en même temps ») : le problème n'est pas le volume, c'est qu'aucun endroit ne le représente.

**C2. Le champ `status` des plans est sorti de son vocabulaire.** [`CONSTITUTION.md`](../../CONSTITUTION.md) définit cinq valeurs (`proposé`, `objection`, `résolu`, `approuvé`, `exécuté`). Le corpus en porte trois de plus, toutes rédigées en phrase libre, dont deux qui expriment un **remplacement** et une un **achèvement partiel**. Ni l'un ni l'autre n'est prévu par le cycle de vie. Conséquence mesurable : `clia res ls PLN` ne peut pas classer ces trois plans, et aucune requête ne peut répondre à « quels plans restent à terminer ».

**C3. Le plan a été chargé du suivi d'avancement, rôle pour lequel il n'est pas conçu.** [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) porte cinq entrées de changelog qui sont, de fait, un journal d'exécution : quel segment est fait, quel écart a été consenti, où se trouve le breakpoint. C'est le seul endroit du dépôt où l'avancement réel est écrit. Un plan est une **proposition**, et le voir devenir le registre d'avancement est le symptôme d'un porteur manquant, pas un défaut de rédaction.

**C4. Aucune relation de blocage n'est représentable, alors que les blocages sont connus et écrits.** [`PLN-020`](../plans/PLN-020-double-racine-contexte-repertoire.md), objection 3, énonce que `BUG-009` doit être traité avant `BUG-007`, faute de quoi les deux remédiations se réécriront l'une l'autre. Cette information, qui est un arc du graphe de travail, vit dans un paragraphe de prose à l'intérieur d'un document dont ce n'est pas l'objet. Le vocabulaire de relations de [`.dev/resource-types.yaml`](../resource-types.yaml) comporte neuf relations et **aucune n'exprime le blocage**. C'est la confirmation locale du constat 4 de [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) : ce qui manque en premier à une liste plate n'est ni la sévérité ni la priorité, c'est la dépendance.

**C5. Le dépôt produit des ressources sans leur skill, et la couche type pointe vers des skills inexistants.** Dix `ACT` et cinq `USE` existent ; `skl-016-acteur` et `skl-017-cas-d-usage` n'existent pas, alors que `.dev/resource-types.yaml` les déclare aux lignes 61 et 69, et que `ADR-011` et `ADR-012` les désignent comme autorité de production. Ce sont **deux références pendantes**, qu'`ADR-003` qualifie de bogue et que rien ne détecte, la couche relations restant une dette (C6).

**C6. `CLAUDE.md` est déclaré « vue » de la couche type et a divergé de sa source.** La table des livrables de `CLAUDE.md` ne comporte ni `ACT` ni `USE`, alors que `.dev/resource-types.yaml` v0.3.0 les déclare depuis le 2026-07-29 et que quinze instances existent. `PLN-017` prévoyait cette mise à jour au segment 2, non exécuté. C'est un écart concret et vérifiable à [`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md), **non tracé par un `BUG`**, comme l'est aussi la section « Acteurs et rôles » d'`ARCHITECTURE.md`.

**C7. Le stock se périme, et il n'existe aucun moyen de le savoir.** `.dev/session-x02.md` porte deux sujets qui paraissent déjà satisfaits : « abolir la distinction ressource vivante contre point fixe » et « nous allons réécrire `ADR-004` ». Or `ADR-004` est en v0.2.0, daté du 2026-07-21, et sa décision détaillée énonce que « la distinction point fixe / vivant / travail est **abolie** ». Rien dans le système ne permet d'établir si ces deux entrées sont périmées ou si elles visent autre chose : elles sont dans un fichier en édition humaine uniquement, sans date d'écriture par sujet, sans statut, et sans lien vers la ressource concernée. C'est exactement le pourrissement décrit en [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 10.2, observé ici sur un stock de sept éléments seulement.

**C8. Les suggestions de l'agent n'ont pas de canal de remontée, et meurent dans des traces immuables.** *(Constat requalifié à la révision 1.)* Les trois supports où le travail futur s'énonce naturellement (les deux fichiers de session et les logs) sont soit en édition humaine uniquement, soit immuables. La révision initiale y voyait une asymétrie de gouvernance non intentionnelle ; la réponse humaine à l'objection 5 établit que **c'en est une, mais qu'elle est intentionnelle et doit le rester** : un agent ne crée aucune entrée de travail, il ne peut que suggérer, et l'humain valide toute intention et tout élément de travail. Cette règle est cohérente avec [`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md) et n'est pas remise en cause.

Le défaut résiduel est donc plus étroit, et il subsiste entièrement : **une suggestion émise par l'agent n'a aucun chemin vers l'humain autre que la lecture intégrale d'un log**. Une observation du type « les dix `ACT` devront être revérifiés contre `skl-016` quand il existera » a été écrite dans `LOG-2026-07-17-task-37.md`, qui est immuable ; elle y est inerte, sans destinataire, sans date d'échéance et sans moyen d'être marquée traitée. Le manque n'est donc pas un droit de capture pour l'agent, c'est un **canal de suggestion adressé** : un endroit où l'agent dépose, où l'humain arbitre, et dont le contenu ne se perd pas à la clôture de la tâche.

**C9. La focalisation est le point fort du dispositif, et il est théoriquement bien fondé.** L'invariant d'`ADR-006` (une seule session active, tous espaces confondus) est un en-cours limité à un au sens du Kanban, et il rejoint l'argument de la contrainte unique de la théorie des contraintes ([`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) sections 7.2 et 9.2). Ce mécanisme fonctionne et ne doit pas être touché. Ce qu'il ne fait pas, c'est dire **quoi** mettre dans la session suivante.

**C10. Le coût d'entrée d'une chose à faire est élevé et croissant avec sa nature.** Enregistrer un défaut coûte un `BUG` complet (rapport, diagnostic, vérification). Enregistrer une amélioration coûte une tâche de session, donc une intervention humaine dans un fichier que l'agent ne peut pas toucher. Enregistrer une intention coûte un `PLN`, donc un cycle d'objections. Il n'existe **aucun enregistrement bon marché**. Rapporté à la doctrine du champ rare ([`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 4.3), le dépôt fonctionne au point opposé de l'optimum : tout enregistrement est cher, donc la sous-déclaration est structurelle, et c'est ce qui explique que dix reports aient été écrits en prose dans des documents de conception plutôt que déclarés quelque part.

## Confrontation à la référence

Application de la grille de la section « Périmètre et méthode ».

| Dimension | État constaté | Écart |
|---|---|---|
| D1 Localisation | six supports, aucun dédié | **fort** |
| D2 Coût d'entrée | aucun enregistrement bon marché (C10) | **fort** |
| D3 Interrogabilité | `clia res ls` ne lit pas les statuts correctement (`BUG-007`), trois statuts hors vocabulaire (C2) | **fort** |
| D4 Relation | aucune relation de blocage dans le vocabulaire ; blocages connus écrits en prose (C4) | **fort** |
| D5 Sortie du stock | aucun mécanisme ; péremption observée (C7) | **fort** |
| D6 Capture sans engagement | réservée à l'humain **par décision** (`session-x<YZ>`) ; l'agent suggère sans créer (C8) | **conforme par décision**, écart résiduel sur la remontée |
| D7 Attendu énonçable | partiel : `PDC` fournit des critères de conformité, `USE` des critères d'acceptation ; `SPEC` et `REQ` existent ; aucune obligation de rattachement dans le `BUG` | **modéré** |
| D8 Focalisation | invariant de session active unique (C9) | **conforme** |

*(Ligne D6 révisée à la révision 1.)* Six dimensions sur huit sont en écart, cinq d'entre elles fortement. D6 n'est plus comptée comme un écart de conception : la réponse humaine à l'objection 5 en fait une **règle de gouvernance assumée**, et le manque se réduit au canal de remontée des suggestions décrit en C8. Les deux dimensions conformes sont celles que le dépôt a explicitement conçues.

## Discussion : le graphe d'intention

La tâche demande de discuter le système proposé dans les deux dépôts antérieurs. Voici son évaluation, confrontée à [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 7.

### Ce qui est solide

1. **La relation « X débloque Y » est le bon primitif.** Elle est orientée, non commutative, et vérifiable. C'est ce que GitHub a fini par réintroduire après quinze ans (`FND-019` section 5.4), ce que l'arbre des prérequis de la théorie des contraintes formalise (section 7.2), et ce qui permet le seul calcul utile sans estimation : l'ensemble des travaux exécutables maintenant est celui des noeuds sans prédécesseur non résolu (section 7.3). Le choix est confirmé par trois traditions indépendantes.
2. **L'intention comme racine du graphe est fondée.** Faire de `INTENTION.md` l'« issue primordial » revient à poser un but racine dont tout le reste dérive. C'est exactement l'invariant du GORE (`FND-019` section 7.1) : tout noeud se justifie par un chemin remontant vers un but racine, et la navigation « pourquoi ? » remonte ce chemin. Le modèle est donc mieux fondé qu'il ne le sait lui-même.
3. **La priorité unique est justifiée deux fois** : par la focalité de l'attention humaine (l'argument donné par `ISU-010`) et, indépendamment, par la contrainte unique de la théorie des contraintes et par la loi de Little (`FND-019` sections 7.2 et 9.2). L'argument tient sans l'hypothèse psychologique.
4. **La règle d'obsolescence est une contribution réelle.** Aucun outil du marché ne dérive l'obsolescence d'un moyen depuis l'atteinte de sa fin (`FND-019` section 7.4). C'est le seul mécanisme principiel connu qui fasse sortir un élément du stock sans le faire, et c'est donc la réponse directe au constat C7.

### Ce qui est faux ou incomplet en l'état

1. **La règle d'obsolescence n'est valide que sur une partie des arêtes, et le modèle ne distingue pas ces parties.** `ISU-010` pose : « si X débloque Y, la résolution de Y rend obsolète X ». Cette proposition est vraie quand X est **un moyen parmi plusieurs** d'atteindre Y, c'est-à-dire sur une arête de raffinement **OU** au sens de KAOS ; elle est fausse quand X est une **composante nécessaire** de Y, c'est-à-dire sur une arête **ET**, car Y ne peut alors pas être atteint sans X. Le modèle n'ayant qu'un seul type d'arête, il applique une règle valide sur les arêtes OU à des arêtes ET, ce qui autorise à déclarer obsolète un travail encore nécessaire. **Correctif : typer l'arête (nécessaire ou alternative) et conditionner l'obsolescence au type.** C'est l'apport le plus directement utilisable du GORE.
2. **La question « lequel est parent ? » est mal posée.** `ISU-010` la laisse ouverte en question technique 1. Elle n'a pas de réponse parce qu'elle n'a pas lieu d'être : dans un graphe orienté à arêtes typées, il n'y a ni parent ni enfant, il y a une **direction de relation**. Introduire une hiérarchie parent-enfant en plus de la dépendance produirait deux structures concurrentes sur le même graphe, ce qui est exactement l'erreur que GitHub commet aujourd'hui en proposant à la fois les sous-issues et les dépendances.
3. **La « vitesse de mouvement du graphe » n'est pas une métrique.** `ISU-010` la présente comme une intuition, et elle le reste : rien ne définit ce qui bouge, ni par rapport à quoi. Sa parente légitime est le débit au sens de la loi de Little (éléments fermés par unité de temps), qui est mesurable dès lors que les fermetures sont datées. À retenir sous cette forme, et à ne pas conserver sous la forme intuitive.
4. **La relation d'ordre de l'importance est vide, et elle peut le rester.** La section correspondante d'`ISU-010` est un titre sans contenu, et `ADR-002` du dépôt externe délègue explicitement la quantification. Le graphe rend cette question largement caduque : le blocage est un fait vérifiable, la priorité est une opinion (`FND-019` section 7.3). Une fois le chemin vers la racine connu, l'ordre utile est calculé, pas déclaré. **Recommandation : ne pas définir de métrique d'importance ; s'en tenir à la désignation humaine d'un but courant, et calculer le reste.**
5. **Le graphe n'a pas de mécanisme d'entrée bon marché.** Le modèle externe décrit la structure mais pas la capture : un noeud naît d'un blocage constaté, ce qui suppose qu'on travaillait déjà. Il n'a pas de réceptacle pour l'idée retenue sans être engagée (la liste « un jour peut-être » de GTD, `FND-019` section 9.1). Sans cela, la structure reste inaccessible au cas le plus fréquent : « je pense que ceci devra être fait, je ne sais pas encore pourquoi ni quand ».

### Verdict

Le graphe d'intention est un modèle **mieux fondé théoriquement que son énoncé actuel ne le montre**, et il répond directement à quatre des six écarts forts (D1, D3, D4, D5). Il est adoptable, à trois conditions : typer les arêtes, abandonner la question parent-enfant, et lui adjoindre un mécanisme de capture. Il ne répond pas à D2 ni à D6, qui relèvent du coût d'entrée et non de la structure.

## Question posée : faut-il une ressource « comportement attendu » ?

> **Objection humaine ouverte.** La tâche 4 de `.dev/session.md` porte « adopter une ressource comportement attendu », qui **contredit la recommandation de cette section**. L'énoncé de cette tâche n'étant pas clos (son objection 2 est vide), la section est conservée en l'état à la révision 1 et sa reprise relève de la tâche 4. Elle doit donc être lue comme l'argumentaire auquel l'humain objecte, pas comme une conclusion en vigueur.

**Recommandation : non, pas comme type autonome.** Quatre arguments.

1. **La littérature ne connaît pas cette ressource.** La tradition normative place l'attendu dans l'exigence, la tradition BDD dans le test exécutable, et le rapport de défaut en porte une instance locale. Aucune école établie ne défend une troisième ressource autonome ([`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 8). Ce n'est pas une interdiction, c'est un signal de prudence.
2. **Le dépôt a déjà trois porteurs de l'attendu**, et deux d'entre eux sont sous-exploités : [`SPEC-002`](../specs/SPEC-002-cli-clia.md) décrit le comportement observable de `clia` ; les `USE` portent des critères d'acceptation en état observable ([`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md)) ; les `PDC` portent des critères de conformité qui définissent, par construction, ce qu'est un respect ([`skl-014`](../skills/skl-014-principe-de-conception/SKILL.md) étape 7). Ajouter un quatrième porteur aggraverait `PDC-006` au lieu de le servir.
3. **Le vrai manque n'est pas un porteur, c'est une obligation de rattachement.** Sur les neuf `BUG` du dépôt, ceux qui nomment une clause violée sont ceux qui portent sur un `PDC`, parce qu'`ADR-003` l'exige explicitement pour ce cas. Rien n'oblige un `BUG` de comportement à nommer l'énoncé d'attendu qu'il enfreint. `BUG-009` le fait spontanément et bien (il cite `ADR-010` D4, D6, D9 et la contradiction `REQ-002-NF2` contre `REQ-002-F15`), mais par qualité de rédaction, pas par règle.
4. **Le seul cas non couvert est réel mais borné** : un comportement attendu de l'agent IA ou du processus, qui n'est ni un but d'acteur, ni une interface de `clia`, ni un invariant transverse. Exemple concret : « une tâche produit un log ». Cet énoncé vit aujourd'hui dans `CLAUDE.md`, et son non-respect a produit `BUG-001`. Le harnais est donc déjà, de fait, le porteur de l'attendu comportemental du processus.

**Décision proposée pour l'ADR** : pas de type « comportement attendu ». À la place, rendre obligatoire dans `skl-013-rapport-de-bogue` la déclaration de la **source de l'attendu** (un lien vers la clause de `PDC`, `SPEC`, `REQ`, `USE` ou harnais violée), avec un cas d'échec explicite : si aucune source n'existe, ce n'est pas un bogue mais une demande d'évolution, et le rapport doit d'abord produire ou amender l'énoncé d'attendu. C'est la propriété auto-vérifiante du triplet de Spolsky ([`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 4.2), transposée à la nomenclature du dépôt.

## Les issues de GitHub comme progrès de simplification

Le traitement complet est en [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 5 et n'est pas répété. Trois points seulement, dans leur portée pour ce dépôt.

1. **Ce que GitHub a supprimé est exactement ce que ce dépôt a accumulé** : champs obligatoires, flux d'états riches, rituels d'entrée. Un `BUG` du dépôt exige rapport, diagnostic, inventaire de composants et critères de vérification ; c'est justifié pour un défaut avéré, et prohibitif pour « il faudrait vérifier ceci ». La leçon n'est pas d'appauvrir le `BUG` mais de **ne pas faire du `BUG` le seul enregistrement disponible**.
2. **L'étiquette libre remplace les champs typés en déplaçant le classement du rapporteur vers le mainteneur**, c'est-à-dire vers celui qui a intérêt à classer. Transposé ici : le porteur de l'enregistrement doit accepter un contenu quasi vide à la création, quitte à ce qu'il soit enrichi ensuite. Un enregistrement dont le seul contenu obligatoire est un titre et une phrase est un enregistrement qui sera créé.
3. **La contrepartie est documentée et le dépôt doit l'éviter** : le modèle GitHub a mis quinze ans à réintroduire la relation de blocage, et les projets qui en avaient besoin l'ont pendant ce temps simulée par des conventions d'étiquettes non vérifiées. Ce dépôt sait déjà qu'il lui faut la relation (C4). Il doit donc **partir avec elle**, et non la reconstruire plus tard : c'est le seul point où il est avantageux de ne pas imiter GitHub.

## Ressources manquantes, ressources à adapter

*(Section révisée à la révision 1 : `PDC-011` retiré, méta-type « ressource » ajouté, volet horodatage ajouté.)*

### À produire

| Ressource | Rôle | Justification |
|---|---|---|
| **`ISU`** (issue) | Sujet de travail ouvert, non-SMART, sans livrable propre, coût d'entrée minimal (un titre, une phrase). Porte les arêtes du graphe. Créé par l'humain seul. | C1, C4, C10 ; tâche `xy` de `session.md` |
| **`INT`** (intention) | Ce que veut un humain ou un groupe. Racine ou racines du graphe. Créée par l'humain seul. | Tâche `xy` ; `FND-019` section 7.1 (but racine) |
| **Méta-type « ressource »** | Décrit un type de ressource : son préfixe, son emplacement, son gabarit, ses droits d'édition, son skill. Une instance par type. Sépare la **décision** d'avoir un type (qui reste dans un `ADR`) de la **description** de ce type. | Résolution humaine de l'objection 2 ; objection humaine de `session-x02.md` ; voir objection N1 |
| **`ADR`** Méthode de gestion du travail | Acte le modèle : deux régimes, graphe à arêtes typées, obsolescence, rattachement de l'attendu, droits de création réservés à l'humain. | Objet de la tâche `xy` |
| **`ADR` + `REQ` + `SPEC`** Extreme SMART | Le principe est porté par une décision et décliné en exigences et spécification vérifiables, **et non par un `PDC`**. Sans limite de temps contraignante en 0.1.0. | Résolution humaine des objections 3 et 4 ; voir objection N4 |
| **`skl-018-issue`**, **`skl-019-intention`**, **skill du méta-type** | Encadrement de production. | `ADR-004` : tout type a un skill |
| **`skl-016-acteur`**, **`skl-017-cas-d-usage`** | Déjà décidés, déjà référencés, inexistants. | C5 (références pendantes) |
| **Trois `BUG`** | Écarts non tracés : divergence `CLAUDE.md` contre couche type ; section « Acteurs et rôles » d'`ARCHITECTURE.md` ; références pendantes vers `skl-016` et `skl-017`. | C5, C6 ; `ADR-003` (un écart à un `PDC` est un bogue) |

Ressource **retirée** par rapport à la révision initiale : `PDC-011` Extreme SMART (résolution humaine de l'objection 3).

### À adapter

| Ressource | Adaptation | Justification |
|---|---|---|
| [`.dev/resource-types.yaml`](../resource-types.yaml) | Entrées `issue`, `intention` et méta-type ; relations `bloque`, `raffine-necessaire`, `raffine-alternative`, `rend-obsolete` ; articulation avec le méta-type (voir objection N1) | C4 ; typage des arêtes |
| [`ADR-004`](../adr/ADR-004-ressources-livrables.md) | Intégrer les nouveaux types ; statuer sur le statut normalisé comme métadonnée obligatoire ; articuler avec le méta-type | C2 ; objection 2 résolue |
| [`ADR-003`](../adr/ADR-003-gestion-des-bogues.md) | Frontière `BUG` contre `ISU` ; obligation de déclarer la source de l'attendu ; **droits de création** du `BUG` au regard de la règle « l'agent suggère, l'humain valide » (voir objection N2) | C10 ; résolution de l'objection 5 |
| [`ADR-006`](../adr/ADR-006-gestion-des-sessions.md) | Datation des tâches et temps écoulé : `start-at` existe déjà, la datation par tâche est dérivée de l'historique git (voir objection N3) | Résolution humaine de l'objection 4 |
| [`SPEC-002`](../specs/SPEC-002-cli-clia.md) et [`REQ-002`](../requis/REQ-002-cli-clia.md) | Ajouter `clia session elapsed` et `clia session task elapsed <N>` au groupe `ses` (`session` en est déjà l'alias, `REQ-002-F6`) ; définir la source de temps et le comportement hors dépôt git | Résolution humaine de l'objection 4 |
| [`CONSTITUTION.md`](../../CONSTITUTION.md) | Vocabulaire de statut fermé pour les plans, incluant `remplacé` et `partiellement exécuté` ; inscrire la règle « l'agent ne crée aucune entrée de travail, il suggère » | C2 ; résolution de l'objection 5 |
| [`CLAUDE.md`](../../CLAUDE.md) | Resynchroniser la table des livrables avec la couche type (`ACT`, `USE`, puis `ISU`, `INT`, méta-type) | C6 |
| [`skl-003-plan-de-travail`](../skills/skl-003-plan-de-travail/SKILL.md) | Un plan déclare l'`ISU` qu'il fait avancer ; le suivi d'avancement sort du changelog | C3 |
| [`skl-013-rapport-de-bogue`](../skills/skl-013-rapport-de-bogue/SKILL.md) | Déclaration obligatoire de la source de l'attendu ; rattachement à un `ISU` | Section « comportement attendu » |
| [`skl-008-log-ia-output`](../skills/skl-008-log-ia-output/SKILL.md) | Section **« Suggestions »** normalisée et distincte des notes : ce que l'agent propose de retenir comme `ISU` ou `BUG`, à charge pour l'humain de l'instancier ou de l'écarter | C8 requalifié ; résolution de l'objection 5 |
| [`skl-012-analyse-corpus`](../skills/skl-012-analyse-corpus/SKILL.md) | Même section « Suggestions », l'analyse étant l'un des deux canaux autorisés | Résolution de l'objection 5 |
| `src/lib/resource.sh` | Lecture des statuts, déjà tracée par [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) ; à étendre à l'interrogation du graphe | C2, D3 |

## Les mécaniques actuelles sont-elles suffisantes ?

**Non, et le manque est précisément localisable.** Le dépôt possède trois mécaniques et il lui en manque trois.

**Ce qui existe et fonctionne** :

1. **La focalisation** : session active unique (C9). À conserver sans modification.
2. **La décision** : cycle objection-sociocratique, breakpoints, approbation partielle. Mécanique de **décision**, complète pour ce qu'elle fait.
3. **La trace** : log obligatoire par tâche, sessions archivées. Mécanique de **mémoire du passé**, complète.

**Ce qui manque** *(révisé à la révision 1)* :

1. **La capture bon marché, pour l'humain, et la remontée des suggestions, pour l'agent.** La réponse humaine à l'objection 5 sépare les deux besoins, qui étaient confondus dans la révision initiale. Pour l'**humain** : aucun enregistrement bon marché n'existe (C10), et c'est le manque le plus urgent. Pour l'**agent** : la création est interdite par principe, et ce qui manque est un canal de suggestion adressé, dont le contenu ne se perde pas à la clôture de la tâche (C8 requalifié). Le second est un problème de format de livrable, pas de droits.
2. **La structure.** Aucune relation de blocage ni de raffinement, donc aucun calcul possible de ce qui est exécutable, ni de ce qui est devenu inutile (C4, C7).
3. **L'interrogation.** `clia` ne sait pas répondre à « que reste-t-il ? » ni à « quoi ensuite ? ». C'est le coût résiduel du modèle fichier, identifié comme tel dans [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md) section 6.3 : le vrai prix du tracker en fichiers est l'écriture de son outil de lecture. S'y ajoute désormais la mesure du temps écoulé (`clia session elapsed`), qui est une interrogation et non une contrainte.

**Point important : la mécanique de gouvernance ne doit pas être chargée de ces trois manques.** Le cycle objection-sociocratique est un mécanisme de décision ; lui adjoindre la capture reviendrait à exiger un plan et un cycle d'objections pour retenir une idée, ce qui reproduirait le coût d'entrée prohibitif de C10. Les deux mécaniques doivent rester séparées : l'humain capture sans décider, et décide au moment d'engager. La règle « l'agent suggère, l'humain valide » n'entre pas en conflit avec cette séparation : elle dit **qui** capture, pas **à quel coût**.

## Esquisse de plan

Esquisse, non normative, produite dans cette analyse et non dans un fichier `PLN`, conformément à la demande. *(Réordonnée à la révision 1 : la résolution de l'objection 1 suit la recommandation de l'agent, ce qui coupe l'esquisse en deux blocs séparés par une condition de reprise, et non par un simple breakpoint.)*

### Bloc A : décider et formaliser (session courante)

**Étape 1 : décider.** Produire l'`ADR` de méthode de gestion du travail. Contenu minimal : les deux régimes (`ISU` ouvert, unité de travail Extreme SMART) ; la définition d'`INT` et son articulation à `INTENTION.md` ; le graphe orienté à arêtes typées (nécessaire contre alternative) et la règle d'obsolescence conditionnée au type ; la frontière `BUG` contre `ISU` ; la règle de création (l'humain seul crée une entrée de travail, l'agent suggère dans une analyse ou une objection) ; l'obligation de rattachement de l'attendu, **sous réserve de l'objection humaine de la tâche 4**. Cette étape ne produit aucune instance de type nouveau.

**Étape 2 : formaliser les types.** Produire le **méta-type « ressource »** et son skill, puis décrire par son moyen les types `ISU` et `INT` ; l'`ADR` porte la décision d'avoir ces types, le méta-type en porte la description (résolution de l'objection 2). Entrées correspondantes dans `.dev/resource-types.yaml` et relations `bloque`, `raffine-necessaire`, `raffine-alternative`, `rend-obsolete` (voir objection N1 sur l'articulation des deux). Produire l'`ADR`, le `REQ` et la `SPEC` d'Extreme SMART, sans limite de temps contraignante (résolutions des objections 3 et 4). Amender `ADR-004`, `ADR-003`, `ADR-006` et `CONSTITUTION.md`.

**BREAKPOINT 1.** Le modèle est décidé et décrit, rien n'est migré ni outillé. L'humain valide avant que le reste ne s'y accroche.

### Bloc B : mettre en oeuvre (après `BUG-009` et `BUG-007`)

Le bloc B est **conditionné à la résolution de [`BUG-009`](../bugs/BUG-009-contexte-repertoire-ignore-par-clia.md) et de [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md)** (résolution humaine de l'objection 1). Motif : `BUG-009` fait opérer `clia` sur l'arbre de l'outil quel que soit le répertoire d'appel, et `BUG-007` fausse la lecture des ressources ; toute mécanique bâtie avant leur correction serait à refaire, et toute commande d'interrogation lirait le mauvais dépôt.

**Étape 3 : méthodologie.** `skl-018-issue`, `skl-019-intention` ; amendements de `skl-003`, `skl-013`, `skl-008` et `skl-012` (section « Suggestions ») ; resynchronisation de `CLAUDE.md`. Rattrapage de la dette de `PLN-017` segment 2 (`skl-016`, `skl-017`) au passage, puisqu'elle porte sur la même table.

**Étape 4 : constituer le graphe initial.** Instancier l'inventaire de la section « Inventaire » : les trois plans inachevés, les dix reports en prose, les sept sujets de `session-x02`, les quatre objectifs de la session courante ; les sept `BUG` diagnostiqués sont **rattachés**, non convertis. Déclarer les arêtes connues, à commencer par celle que `PLN-020` objection 3 énonce déjà (`BUG-009` bloque `BUG-007`). Marquer obsolètes les entrées de `session-x02` que `ADR-004` v0.2.0 a satisfaites, après confirmation humaine. **Cette étape crée des entrées de travail : elle est opérée par l'humain, l'agent se limitant à proposer la liste et les arêtes** (résolution de l'objection 5).

**BREAKPOINT 2.** Le graphe existe et est lisible. L'humain arbitre la racine et le chemin courant avant qu'un outil ne s'appuie dessus.

**Étape 5 : interrogation.** Étendre `clia` : lister les `ISU`, afficher le graphe, calculer l'ensemble exécutable (noeuds sans prédécesseur non résolu) et les noeuds obsolètes ; ajouter `clia session elapsed` et `clia session task elapsed <N>` (résolution de l'objection 4, voir objection N3 sur la source de temps).

## Objections de l'agent IA

### Objections résolues (révision 1)

Les cinq objections de la révision initiale ont reçu une réponse humaine à la tâche 3 de `.dev/session.md`. Aucune n'est ouverte.

| Objection | Objet | Résolution |
|---|---|---|
| 1 | Ordonnancement contre la version 0.1.0 | **Recommandation de l'agent suivie** : bloc A maintenant, bloc B après `BUG-009` et `BUG-007`. |
| 2 | Frontière `ADR` contre définition de ressource | **Tranchée** : produire le méta-type « ressource ». L'`ADR` décide, le méta-type décrit. |
| 3 | « Extreme SMART » comme `PDC` | **Tranchée** : pas de `PDC`. Un `ADR`, un `REQ` et une `SPEC` selon nécessité. |
| 4 | Timebox intransposable | **Tranchée** : horodatage des sessions, datation des tâches par l'historique git, `clia session elapsed` et `clia session task elapsed <N>` ; **pas de limite de temps** pour l'instant. |
| 5 | Enflure par la capture bon marché | **Tranchée par la négative** : l'agent ne crée aucune entrée de travail. Il suggère, dans une analyse ou une objection ; l'humain valide toute intention et tout élément de travail. |

### Objections nouvelles, ouvertes

Ces quatre objections naissent des résolutions ci-dessus et n'existaient pas à la révision initiale.

**Objection N1 (deux descriptions concurrentes du même type).** Le méta-type « ressource » décrira, en markdown vivant et versionné, ce que [`.dev/resource-types.yaml`](../resource-types.yaml) décrit déjà en YAML lisible par un programme (préfixe, emplacement, nommage, skill, droits d'édition). Si l'étape 2 est exécutée sans trancher la préséance, le dépôt se dote de **deux sources de vérité sur la même chose**, c'est-à-dire exactement le défaut constaté en C6 sur `CLAUDE.md`, et il le crée volontairement. Le risque est certain, pas hypothétique : la divergence a déjà eu lieu une fois entre `resource-types.yaml` et sa vue. Trois issues possibles, à trancher par l'humain : (a) le méta-type fait autorité et `resource-types.yaml` en est **dérivé** mécaniquement ; (b) le YAML fait autorité et l'instance de méta-type en est une vue rédigée ; (c) le YAML est **aboli** et remplacé par le frontmatter des instances de méta-type, `clia` lisant ces fichiers. L'agent ne peut pas choisir : la décision engage la couche machine-lisible dont dépend `clia`.

**Objection N2 (le droit de créer un `BUG` est contredit).** La règle « un agent n'a pas le droit de créer des entrées de travail » entre en conflit direct avec l'état du dépôt : `BUG` est en co-édition ([`ADR-003`](../adr/ADR-003-gestion-des-bogues.md), [`.dev/resource-types.yaml`](../resource-types.yaml)), `skl-013` est un skill de production destiné à l'agent, et [`BUG-009`](../bugs/BUG-009-contexte-repertoire-ignore-par-clia.md) a été créé par l'agent à la tâche 1 de **cette session**. Si la règle est gravée telle quelle, neuf `BUG` existants deviennent rétroactivement irréguliers et `skl-013` perd son destinataire. Deux lectures sont possibles et elles ne produisent pas le même système : (a) **stricte**, l'agent ne crée aucun fichier `BUG` ni `ISU`, et `skl-013` devient un skill de rédaction de section de suggestion ; (b) **de statut**, l'agent rédige le fichier mais celui-ci naît dans un état non validé, et seule la validation humaine le fait exister comme entrée de travail. L'agent recommande (b), qui préserve l'acquis et place le contrôle au bon endroit, mais la question relève de la constitution.

**Objection N3 (la datation des tâches par l'historique git n'est pas fiable).** `clia session task elapsed <N>` suppose que la date d'apparition d'une tâche dans `session.md` soit lisible dans l'historique. Trois failles concrètes. D'abord, la date git est celle du **commit**, pas celle de l'écriture : les commits observés dans ce dépôt sont des « save » manuels et groupés, si bien que la valeur retournée sous-estimerait le temps écoulé d'un montant inconnu. Ensuite, la commande n'a **aucune source de temps** dans un dépôt équipé non versionné, cas que [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) n'exclut pas, ni dans un clone superficiel. Enfin, un rebase ou un amend réécrit les dates, donc la mesure n'est pas reproductible, ce qui heurte [`PDC-001`](../principes/PDC-001-determinisme-de-clia.md) : mêmes fichiers, résultats différents selon l'historique. **Suggestion : soit la commande annonce explicitement qu'elle mesure « depuis le premier commit contenant la tâche » et échoue proprement hors dépôt git, soit la date de création d'une tâche est écrite dans `session.md` au moment de l'ajout, ce qui la rend indépendante de git.** La seconde voie touche un fichier en édition humaine uniquement et relève donc de l'humain.

**Objection N4 (« Extreme SMART » sans son critère le plus discriminant).** La résolution de l'objection 3 retire le `PDC` et celle de l'objection 4 retire la limite de temps. Le T de SMART n'est donc plus contraignant, et le A (assignable) est déjà sans objet dans un dépôt à opérateur unique. Si l'`ADR` est produit tel quel, le dépôt adopte un principe nommé « Extreme SMART » dont deux des cinq critères ne contraignent rien, et dont le nom promet plus que le contenu : un lecteur externe attendra la timebox, qui est le trait le plus visible du modèle d'origine (`ADR-002` du dépôt `deeptech-ticket-driven`, critère T, 12 heures). Le risque n'est pas technique mais documentaire, et il porte sur une version destinée à être présentable publiquement. **Suggestion : que l'`ADR` énonce explicitement, critère par critère, lequel est contraint, lequel est seulement mesuré, et lequel est sans objet en 0.1.0 ; et qu'il justifie le maintien du nom, ou en change.**

## Synthèse et recommandations

*(Points 4, 5 et 6 révisés à la révision 1.)*

1. **Le diagnostic.** Le dépôt n'a pas de problème de volume de travail, il a un problème de **représentation** du travail : trente-trois éléments ouverts répartis sur six supports, sans relation, sans statut normalisé, sans mécanisme de sortie et sans interrogation.
2. **Deux types manquent, et ils sont bien choisis.** `ISU` (sujet ouvert, coût d'entrée minimal) et `INT` (intention, racine du graphe) répondent à quatre des écarts forts. La proposition de la tâche `xy` est validée par l'analyse.
3. **Le graphe d'intention est adoptable, avec un correctif de fond** : typer les arêtes en nécessaire contre alternative, sans quoi la règle d'obsolescence autorise à déclarer obsolète un travail encore nécessaire. Abandonner par ailleurs la question parent-enfant et la métrique de vitesse du graphe, et ne pas définir de métrique d'importance.
4. **Un troisième type est décidé : le méta-type « ressource »**, qui sépare la décision d'avoir un type (l'`ADR`) de la description de ce type. Sa production est conditionnée par l'objection N1 : sans arbitrage de préséance avec `.dev/resource-types.yaml`, il crée volontairement le défaut constaté en C6.
5. **Sur le comportement attendu, la question est rouverte.** L'analyse recommandait de ne pas créer de type autonome ; l'humain objecte et veut l'adopter (tâche 4 de `.dev/session.md`). La section correspondante est conservée comme argumentaire, non comme conclusion. Ce qui reste acquis quelle que soit l'issue : l'**obligation**, pour un `BUG`, de nommer la clause d'attendu qu'il enfreint, avec le cas d'échec explicite (pas d'attendu écrit, pas de bogue).
6. **Les droits de création sont réservés à l'humain**, et c'est une règle de gouvernance, pas un défaut. L'agent suggère dans une analyse ou une objection. La conséquence à trancher est le sort du `BUG`, aujourd'hui en co-édition et produit par l'agent (objection N2). Le cycle objection-sociocratique décide et ne doit pas capturer : confondre les deux reproduirait le coût d'entrée prohibitif qui est la cause de C10.
7. **Priorité arbitrée** : bloc A (décider, formaliser) maintenant ; bloc B (méthodologie, graphe initial, outillage) après `BUG-009` et `BUG-007`, dont dépend toute interrogation par `clia`.
8. **Trois écarts constatés méritent un `BUG` indépendamment de cette analyse** : la divergence de `CLAUDE.md` avec la couche type, la section « Acteurs et rôles » d'`ARCHITECTURE.md`, et les deux références pendantes vers `skl-016` et `skl-017`. Les trois sont des écarts à `PDC-006` ou à `ADR-004`, donc des bogues au sens d'`ADR-003`. Leur ouverture relève de l'humain (voir objection N2).

## Portée et péremption

- **Couverture** : exhaustive sur les statuts en frontmatter (`.dev/bugs/`, `.dev/plans/`) et sur les formulations de report recherchées dans `.dev/adr/`, `.dev/specs/`, `.dev/requis/`, `.dev/principes/`, `.dev/acteurs/`, `.dev/usages/`. **Non exhaustive** sur les logs : quarante-six fichiers dont les sections « Notes » et « Limitation » n'ont pas été dépouillées une à une, le décompte de trente-trois éléments est donc un **minorant**.
- **Limites** : l'analyse ne juge pas le code (`src/`, `test/`), qui est hors périmètre. Les statuts sont lus tels que déclarés, sans vérification que l'état déclaré corresponde à l'état réel ; `PLN-016` (« partiellement exécuté ») n'a pas été audité pour délimiter son reliquat. La lecture des deux dépôts externes porte sur leur état au 2026-08-02 et ne présume pas de leur évolution.
- **Incertitude signalée** : la péremption supposée de deux entrées de `session-x02.md` (constat C7) est établie par comparaison de contenu avec `ADR-004` v0.2.0, pas par une date d'écriture par sujet, qui n'existe pas. Elle demande une confirmation humaine avant toute action.
- **Péremption** : l'inventaire est daté du 2026-08-02 et se périme à chaque tâche exécutée. Les constats structurels (C1 à C4, C8 à C10) restent valides tant que le modèle de ressources n'est pas amendé. La confrontation à la référence se revalide en même temps que [`FND-019`](../fondations/FND-019-systemes-de-suivi-du-travail.md).
- **État des décisions à la révision 1** : les cinq objections initiales sont résolues et leurs résolutions sont intégrées. Quatre objections nouvelles (N1 à N4) sont **ouvertes** et bloquent l'exécution de l'esquisse selon la règle absolue de [`CONSTITUTION.md`](../../CONSTITUTION.md). Une objection humaine est ouverte sur la section « comportement attendu » (tâche 4 de `.dev/session.md`), dont l'énoncé n'est pas clos.
