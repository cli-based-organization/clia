# Ce qui a été fait, tâches 23 et 24

## En un coup d'oeil

| Mesure | Valeur |
|---|---|
| Type de ressource créé | `ISU`, **31e type** |
| Artefacts dérivés | 3, schéma, schéma d'entrée, gabarit |
| Principe produit | `PDC-003`, **déclaré non actif** |
| Analyse produite | `ANL-006`, 8 constats |
| Plan produit | `PLN-003`, 8 chantiers, 3 points d'arrêt |
| Objection ouverte | `NON-027`, conditionnelle, 5 questions |
| Tests du CLI | **124, tous verts** |
| Ressources validant leur schéma | **117 sur 122** |

## Tâche 23

### RES-031, le type Issue

Une issue documente une problématique dans le but de la résoudre. Elle est **non SMART**, et c'est sa propriété définitoire.

| Critère SMART | Une issue |
|---|---|
| Spécifique | pas nécessairement |
| Mesurable | non |
| Atteignable, Réaliste | inconnu |
| Temporel | aucune échéance |

Cette exclusion est ce qui rend son coût d'entrée minimal : un titre et une phrase. Un sujet dont on ne sait ni la forme, ni l'effort, ni l'échéance a un endroit où être écrit.

**Test d'admission à deux conditions.** La problématique survit à la session, et elle n'est pas assez nette pour être planifiée. La seconde évite la confusion avec le plan.

**Cycle `travail`**, sans champ `version` : une issue a une histoire, pas des versions.

Le type est reconnu par le CLI, et `clia res new issue` produit un gabarit conforme.

### PDC-003, SMART et extrême SMART

**Déclaré non actif.** `CONSTITUTION.md` C1 réserve la création d'un principe à l'humain. Le document est produit au régime que `DCN-013` fixe pour les décisions : un premier jet d'agent n'est pas actif tant qu'il n'a pas été approuvé. L'analogie n'est écrite nulle part, et `NON-027` Q1 la porte.

**Ce que le principe apporte au modèle d'origine.** L'objection N4 de `ANL-016`, archivée, reprochait à « extrême SMART » que deux de ses cinq critères ne contraignaient rien, et que le nom promettait plus que le contenu. Sa suggestion était de déclarer critère par critère lequel contraint. `PDC-003` le fait.

| Critère | Régime en 0.1.0 |
|---|---|
| Spécifique, Mesurable | contraints |
| Atteignable | contraint en extrême SMART, mesuré en SMART |
| Réaliste | mesuré, non bloquant |
| Temporel | contraint en extrême SMART, **sans objet** en SMART |

**Trois exigences propres à l'extrême** : livrable unique, critère de réussite exécutable, limite de temps contraignante et courte. Le modèle d'origine fixait douze heures.

**Le seuil de bascule.** Une planification qui ne satisfait pas S, M et T n'est pas produite : elle devient une `ISU`. C'est ce qui protège les deux régimes, le flou ayant un autre endroit où aller.

**Mesure qui rend le principe immédiatement contestable.** Les deux seuls plans du dépôt échouent aux trois contrôles. `PLN-002` porte huit livrables là où E1 en exige un. La mesure est écrite dans le principe, et `NON-027` Q3 demande ce qu'on en fait.

### Ce que le corpus avait décidé du contraire

`ANL-016` porte une objection **résolue** : « Extreme SMART ne devient **pas** un `PDC`. Il est porté par un `ADR` et décliné en `REQ` et `SPEC` selon nécessité. »

La tâche 23 revient sur cette résolution sans la nommer. `NON-027` Q2 le porte.

## Tâche 24

### ANL-006, huit constats

Le plus urgent est un conflit actif.

| Document | Ce qu'il dit de l'agent |
|---|---|
| `CONSTITUTION.md` C1 | « Un agent IA ne crée ni ne modifie une décision » |
| `DCN-013` | L'IA peut faire un premier jet, **suspendu** jusqu'à approbation |

`DCN-013` est l'autorité ultime par son propre énoncé. C1, écrit par l'agent à la tâche 20, lui est subordonné et doit être aligné.

**Ce que le conflit a déjà coûté.** Deux gabarits vides, `DCN-011` et `DCN-012`, laissés aux tâches 21 et 22. Sous `DCN-013`, l'agent aurait pu les rédiger en régime suspendu.

**Le mécanisme central est la distinction création / rédaction.**

| Geste | Qui |
|---|---|
| **Créer** le fichier | L'humain seul, acte conscient non délégable |
| **Rédiger** le contenu | Idéalement l'humain, possiblement l'agent, décision alors suspendue |
| **Approuver** | L'humain seul |
| **Modifier** le frontmatter d'état | Le cli |

**Les huit implications, par urgence.**

| Rang | Implication | Outil requis |
|---|---|---|
| 1 | C1 contredit `DCN-013` | aucun |
| 2 | `clia res new decision` doit refuser à un agent | garde, existe pour `git save` |
| 3 | Le motif d'inactivité manque au frontmatter | aucun |
| 4 | 11 ADR sur 17 n'ont aucune source | aucun |
| 5 | **248 renvois citent des décisions d'ADR** comme fondement | aucun |
| 6 | Les étapes 1 à 3 du mécanisme de génération manquent | générateur |
| 7 | Les critères de conformité d'un dépôt ne sont pas écrits | `clia setup init` |
| 8 | La forme en répertoire des définitions, 123 fichiers | migration |

**L'adaptation minimale est de trois changements** : aligner C1, poser la garde de création, ajouter la valeur `redigee-par-agent` au champ `effet`. Un fichier de harnais, un module, une définition. Aucun outil nouveau.

### PLN-003, huit chantiers

```
A ──> B
│
├──> C ──> [C4, humain ou cli]
│
└──> D (décision humaine, bloquante) ──> E

F, indépendant
G1 ──> G2 ──> G3 ──> G4
H, après clia validate
```

**Le chantier D est bloquant et sans bonne option.** Rendre les ADR non actifs invalide le fondement de 248 renvois dans 58 fichiers. Les trois options laissent le dépôt imparfait pendant un temps qu'aucune ne borne. La recommandation de l'agent est D-c, marquer à partir d'une date et traiter au fil de l'eau.

**Le chantier E est peut-être impossible.** Il suppose une table de correspondance entre chaque décision d'ADR et sa `DCN`. Onze ADR n'en ont aucune, et l'agent ne peut pas les créer.

## Trois mesures corrigées après vérification

| Affirmation initiale | Mesure |
|---|---|
| 5 ADR avec source | **6** |
| 32 gabarits | **30** |
| « environ 40 renvois » | **248**, dans 58 fichiers |

L'écart sur le dernier est d'un facteur six, et il change la lecture du chantier E.

## Ce qui n'a pas été fait

Aucun chantier de `PLN-003` n'est exécuté, y compris l'alignement de `CONSTITUTION.md` qui lèverait le conflit actif. La tâche 24 dit « proposer un plan ».

`PDC-003` n'est pas actif. `NON-027` Q1 demande si l'agent pouvait le produire.

Aucune `DCN` n'a été rédigée. `DCN-013`, écrite par l'humain, porte cinq champs `À RENSEIGNER`, dont son propre `effet`.
