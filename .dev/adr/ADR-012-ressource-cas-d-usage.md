---
type: adr
version: 0.1.0
title: "Ressource « cas d'usage » (`USE`)"
status: Proposé
date: 2026-07-29
---

# ADR-012 - Ressource « cas d'usage » (`USE`)

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : tâche 36 de `.dev/session.md` (exécution de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md), segment 1, étape 1.2), résolutions des objections 2 et 4 à la tâche 35, [`ANL-014-cas-usage-et-acteurs-de-clia`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md) (R1, R2, R7), [`FND-018-cas-usage-besoins-utilisateurs`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md), [`FND-015-requis-et-specification`](../fondations/FND-015-requis-et-specification.md)

## Contexte

La chaîne de conception du dépôt (`ADR` vers `REQ` vers `SPEC` vers code) est rigoureuse en son milieu mais commence à l'exigence, c'est-à-dire au niveau **système**. Le niveau des **exigences de parties prenantes** est absent : aucune ressource ne dit qui veut quoi et pourquoi ([`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats), constat C1).

Trois conséquences sont mesurées par l'analyse :

- le besoin n'entre dans le système que par `.dev/session.md`, fichier éphémère en édition humaine, archivé sans index d'usages ; à la clôture de session, l'énoncé du besoin est perdu alors que les décisions qu'il a produites subsistent (constat C8) ;
- les exigences décrivent des **commandes**, pas des **buts** : `REQ-002` est structuré par surface d'interface, et un but comme « ouvrir une session de travail » traverse quatre invocations sans qu'aucun document ne le décrive comme un parcours unique (constat C3) ;
- la matière des flux d'échec **existe** (codes de retour et conditions d'erreur spécifiés uniformément) mais n'est rattachée à aucun parcours : on sait qu'une invocation échoue, on ne sait pas ce que l'acteur fait ensuite (constat C4).

Le manque n'est donc pas documentaire, c'est un **maillon manquant de la couche type**. Le contexte agent l'aggrave plutôt qu'il ne l'atténue : le dépôt pose que l'interface de travail est des fichiers et non la conversation ([`PDC-004`](../principes/PDC-004-interface-fichiers-pas-conversation.md)), ce qui rend inadaptées les formes de besoin conçues comme jetons de conversation (constat C9).

## Décision (résumé)

> On crée un type de ressource livrable **cas d'usage**, préfixe **`USE`**, emplacement `.dev/usages/USE-<SEQ>-<SLUG>.md`. Un `USE` décrit **un but d'acteur atteint de bout en bout**, au format court du gabarit « but utilisateur », avec flux nominal, flux d'échec et critères d'acceptation en état observable. Il se place **en amont du `REQ`** dans la chaîne de conception. Il est **indépendant des outils** qui permettent d'atteindre le but : un `USE` ne nomme aucune commande, aucun script, aucun code de retour. Son acteur principal est un [`ACT`](ADR-011-ressource-acteur.md) de catégorie primaire. Un `PLN` déclare le ou les `USE` qu'il réalise. Ressource vivante et versionnée au sens d'[`ADR-004`](ADR-004-ressources-livrables.md), en co-édition, produite sous `skl-017-cas-d-usage`.

## Décisions détaillées

### Nature et distinction avec `REQ` et `SPEC`

- **Décision** : trois questions distinctes, trois types distincts.

| Type | Question | Sujet |
|---|---|---|
| `USE` | qui veut quoi, et pourquoi | un acteur |
| `REQ` | ce que le système doit garantir | le système |
| `SPEC` | comment l'interface se comporte | l'interface observable |

- **Justification** : [`FND-015`](../fondations/FND-015-requis-et-specification.md) et [`FND-018`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md) séparent le niveau des parties prenantes du niveau système. Le dépôt possède déjà les deux niveaux inférieurs ; seul le premier manque.
- *Alternative écartée* : **fusionner l'usage dans le `REQ`** (un champ « contexte d'usage » dans chaque exigence). Rejeté : les deux répondent à des questions différentes et se dénaturent mutuellement. Le contre-exemple est mesuré dans le dépôt voisin par [`ANL-011`](../analyses/ANL-011-specs-reqs-livrables-tda-vs-clia.md) ; la fusion y produit des exigences qui ne sont ni des buts ni des garanties. De plus, un but traverse plusieurs exigences : le loger dans l'une d'elles le fragmente.
- *Alternative écartée* : **user stories** (« en tant que ..., je veux ..., afin de ... »). Rejeté : la user story est un jeton de conversation dont le contenu vit dans la discussion qu'elle déclenche. Ce dépôt a fait le choix explicite inverse ([`PDC-004`](../principes/PDC-004-interface-fichiers-pas-conversation.md)) et l'agent ne participe à aucune conversation d'équipe. Le gabarit produirait ici l'anti-motif du gabarit rituel.
- *Alternative écartée* : **Gherkin et cadre BDD complet**. Rejeté à ce stade : le coût d'un cadre d'exécution excède le bénéfice pour un système dont le contrat observable est déjà simple. La notation « étant donné / quand / alors » reste utilisable comme forme de critère d'acceptation, sans le vocabulaire ni l'outillage BDD.

### Place dans la chaîne de conception

- **Décision** : `USE` se place **en amont de `REQ`**. La chaîne devient : `ACT` et `USE`, puis `REQ`, puis `SPEC`, puis implémentation.
- **Conséquence** : un `REQ` déclare le ou les `USE` qu'il satisfait, ce qui donne à la traçabilité une origine. Le rattachement des exigences existantes est exécuté au segment 4 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).

### Indépendance aux outils (règle structurante)

- **Décision** : un `USE` décrit le **but de l'acteur** et l'**état du monde** avant et après. Il nomme le système comme boîte noire. Il ne nomme **aucune commande, aucun script, aucun nom d'option, aucun code de retour**.
- **Justification** (résolution humaine, tâche 35, objection 4) : une ressource est indépendante des outils et des instruments qui la produisent, la manipulent ou l'exploitent. Deux conséquences pratiques en découlent :
  - un `USE` **survit au changement d'outil** : remplacer un script d'installation par une commande intégrée ne périme aucun cas d'usage, seulement les exigences et spécifications qui les servent ;
  - un `USE` **peut s'écrire avant que l'outil existe**, donc avant que la décision d'outillage soit prise. Le parcours d'installation est écrit sans dépendre d'[`ADR-010`](ADR-010-clia-setup-commandes-modes-installation.md), encore au statut proposé.
- **Test de conformité** : si le remplacement de l'outil oblige à réécrire le `USE`, le `USE` était mal écrit.

### Règles d'altitude

- **Décision, règle 1** : le titre est un **verbe à l'infinitif orienté but de l'acteur**. « Ouvrir une session de travail », jamais « Commande `ses open` ».
- **Décision, règle 2** : le niveau **sous-fonction est interdit comme unité de fichier**. Un `USE` est au niveau « but utilisateur » (le niveau de la mer, chez Cockburn) ; le niveau « résumé » sert de regroupement narratif, pas de fichier isolé.
- **Justification** : sans ces deux règles, le catalogue reproduit la surface de commandes du système sous un autre nom, ce qui est exactement l'anti-motif de la décomposition fonctionnelle déguisée déjà constaté ([C3](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)). Le niveau utile est aussi le seul que ni `ARCHITECTURE.md` (trop haut) ni `REQ`/`SPEC` (trop bas) ne couvrent (écart D3).

### Gabarit

- **Décision** : format court par défaut. Un `USE` bien formé comporte :

```markdown
---
type: usage
version: <X.Y.Z>
title: "<Verbe à l'infinitif orienté but>"
status: <proposé|accepté|déprécié|remplacé par USE-XXX>
date: <AAAA-MM-JJ>
acteur-principal: ACT-<SEQ>
niveau: but-utilisateur
---

# USE-<SEQ> - <Titre>

## En-tête
- **Portée** : <le système considéré comme boîte noire>
- **Parties prenantes et intérêts** : <rôles concernés sans participer au déroulé>
- **Préconditions** : <ce qui est vrai avant>
- **Garantie de succès** : <l'état du monde après, en cas de succès>
- **Garantie minimale** : <ce qui reste vrai même en cas d'échec>

## Flux nominal
1. <étapes numérotées ; sujet = l'acteur ou le système, jamais un outil>

## Flux alternatifs et d'échec
- **1a. <condition>** : <déroulé, issue observable pour l'acteur, parcours de récupération>

## Critères d'acceptation
- <état observable, vérifiable sans connaître l'implémentation>

## Relations
<Liens markdown : l'acteur qui utilise ce USE et pour quel but ; les REQ qui le satisfont ; les PLN qui le réalisent.>
```

- **Justification de la garantie minimale** : elle transcrit ce que le système garantit quand le but n'est pas atteint. Le dépôt spécifie déjà l'échec sans effet de bord ; le champ donne à cette propriété un porteur au niveau du parcours (constat [C4](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)).
- **Justification du parcours de récupération** : un flux d'échec qui s'arrête sur le constat de l'échec laisse l'acteur sans suite. C'est le manque précis relevé par l'analyse.

### Relation plan vers usage

- **Décision** : un `PLN` déclare le ou les `USE` qu'il **réalise**. La relation `realise` est ajoutée au vocabulaire de [`.dev/resource-types.yaml`](../resource-types.yaml).
- **Justification** : le plan est éphémère par nature, il est consommé par son exécution ; le `USE` est durable. Sans cette déclaration, le besoin continue de se perdre à la clôture de session (constat [C8](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)). La charge est nulle : c'est une ligne dans le plan.

### Relations et forme provisoire

- **Décision** : deux relations sont ajoutées au vocabulaire de [`.dev/resource-types.yaml`](../resource-types.yaml) en plus de `realise` :
  - **`utilise`** : un `ACT` utilise un `USE` pour atteindre un but (voir [`ADR-011`](ADR-011-ressource-acteur.md)) ;
  - **`satisfait`** : un `REQ` satisfait un `USE` d'un acteur.
- **Justification** : ces deux relations transcrivent littéralement les énoncés demandés à la tâche 34 (objection C). Aucun type `FONCTIONNALITÉ` n'est créé : ce que le système doit garantir est déjà porté par le `REQ`, qui joue ce rôle dans la chaîne.
- **Forme provisoire** (résolution humaine, tâche 35, objection 2) : les relations s'écrivent en **liens markdown dans une section `## Relations`** normalisée par les skills, et non en champs de frontmatter typés. Seul `acteur-principal` est en frontmatter, parce qu'il est une propriété d'identité du cas d'usage. **Dette nommée** : la couche de relations lisible par un programme, prévue par [`ADR-004`](ADR-004-ressources-livrables.md#références-croisées-et-relations) et déclarée dans la couche type, reste à instancier pour tout le corpus ; ce n'est pas fait ici, et la validation mécanique des références pendantes reste donc impossible.

### Nomenclature, cycle de vie, versionnage, droits d'édition

- **Décision** : `.dev/usages/USE-<SEQ>-<SLUG>.md`, séquence globale incrémentale, conforme au modèle unifié d'[`ADR-004`](ADR-004-ressources-livrables.md). Ressource **vivante**, versionnée en semver dans son frontmatter. Statuts : `proposé`, `accepté`, `déprécié`, `remplacé par USE-XXX`.
- **Droits d'édition** : **co-édition**. Le besoin appartient à l'humain, mais l'agent rédige et met en forme ; l'humain amende via `.dev/session.md`.

### Portée méthode et domaine

- **Décision** : comme pour les acteurs, un `USE` relève soit de la **méthode** (parcours du système d'augmentation lui-même, générique et transposable), soit du **domaine** (parcours métier du dépôt hôte). La portée est héritée de celle de l'acteur principal et n'est donc pas redéclarée.

### Skill de production

- **Décision** : la production d'un `USE` est encadrée par **`skl-017-cas-d-usage`**, produit au segment 2 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).

## Conséquences

**Positives**

- Le besoin gagne un porteur durable, versionné et adressable : il cesse de mourir avec la session qui l'a exprimé.
- La chaîne de conception acquiert son origine ; une exigence peut dire quel but elle sert et pour quel rôle.
- L'indépendance aux outils rend le catalogue stable sous les refontes d'outillage, et permet d'écrire les parcours avant que l'outil existe.
- Les flux d'échec, aujourd'hui spécifiés mais orphelins, trouvent un parcours auquel se rattacher.

**Négatives / risques**

- Un type de ressource de plus, et un risque de redondance perçue avec `REQ` tant que la distinction n'est pas intériorisée. La table des trois questions est le garde-fou.
- La règle d'indépendance aux outils est **coûteuse à respecter** : la tentation d'écrire le nom de la commande est forte, parce qu'elle est plus concrète. Le skill devra en faire un critère vérifiable, et le test de conformité ci-dessus sert d'arbitre.
- La forme provisoire des relations crée une **dette assumée** : les liens sont lisibles par un humain, non validables par un programme. Une référence pendante restera invisible jusqu'à l'instanciation de la couche relations.
- Les critères d'acceptation sont écrits sans qu'aucun test ne les exerce : les tests sont hors portée de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) par décision humaine. Le risque est celui de critères non falsifiables, qu'il faudra reprendre au moment de dériver les tests.

## Migration / porte de sortie

Premier jet. Le catalogue initial (six à dix `USE` de niveau but utilisateur, dérivés de l'existant) est produit au segment 3 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md), après le breakpoint 1. Le rattachement amont des exigences existantes relève du segment 4. Le volet aval (tests d'acceptation dérivés des `USE`, mesure des couvertures avant et arrière) est reporté à un plan ultérieur.

Conditions de révision : si l'usage montre que le format court ne suffit pas pour les parcours à forte variabilité, un format long sera ajouté par un ADR ultérieur, sans changer le type. Si la forme provisoire des relations devient un frein, l'instanciation de la couche relations d'[`ADR-004`](ADR-004-ressources-livrables.md#références-croisées-et-relations) la remplacera pour tout le corpus.

## Références

- [`PLN-017-cas-usage-acteurs-tracabilite`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) (plan d'exécution, segment 1)
- [`ADR-011-ressource-acteur`](ADR-011-ressource-acteur.md) (le sujet du cas d'usage)
- [`ANL-014-cas-usage-et-acteurs-de-clia`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md) (constats C1, C3, C4, C8, C9 ; recommandations R1, R2, R7)
- [`FND-018-cas-usage-besoins-utilisateurs`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md) (gabarit, niveaux d'altitude, anti-motifs)
- [`FND-015-requis-et-specification`](../fondations/FND-015-requis-et-specification.md) (niveaux d'exigence)
- [`ANL-011-specs-reqs-livrables-tda-vs-clia`](../analyses/ANL-011-specs-reqs-livrables-tda-vs-clia.md) (contre-exemple de la fusion dans `REQ`)
- [`ADR-004-ressources-livrables`](ADR-004-ressources-livrables.md) (modèle unifié, relations)
- [`PDC-004-interface-fichiers-pas-conversation`](../principes/PDC-004-interface-fichiers-pas-conversation.md) (pourquoi la forme écrite)
- [`.dev/resource-types.yaml`](../resource-types.yaml) (couche type)
