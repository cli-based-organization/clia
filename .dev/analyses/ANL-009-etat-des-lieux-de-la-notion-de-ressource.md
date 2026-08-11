---
type: analyse
id: ANL-009
title: "État des lieux de la définition et de l'instrumentation des ressources"
status: draft
date: 2026-08-11
sujet: "Ce que le dépôt dit de la ressource, sur neuf axes, et ce qui reste à trancher"
generated:
  by: claude-opus-5
  at: 2026-08-11
---

# ANL-009 - État des lieux de la notion de ressource

> Cent trente-six documents sur cent cinquante traitent des ressources. Neuf axes couvrent ce qu'ils en disent. Trois axes sont réglés, deux le sont partiellement, quatre sont ouverts et trois d'entre eux bloquent.

## Objet

Faire l'état des lieux de la notion de ressource : ce que le dépôt en dit, sur quels axes, et ce qui reste à trancher.

Demandé par la tâche 30 de la session du 2026-08-09.

## Méthode

Trois mesures sur le dépôt au 2026-08-11, journaux et archives exclus.

| Mesure | Ce qu'elle compte |
|---|---|
| M1 | Les documents actifs qui mentionnent la ressource au moins trois fois |
| M2 | Leur répartition par type |
| M3 | L'état des trente-quatre objections : effet, état, questions répondues |

Les axes ne sont pas donnés a priori : ils sont tirés des problématiques que les documents abordent.

**Une observation n'est pas une norme.** `skl-001` A7. Ce que les documents disent est rapporté comme leur position, non comme un fait établi.

## Constats

### C1 - Presque tout le dépôt parle des ressources

| Mesure | Valeur |
|---|---|
| Documents actifs | 150 |
| Traitant des ressources | **136**, soit 91 pour cent |

| Type | Nombre |
|---|---|
| `ressource` | 36 |
| `objection` | 33 |
| `adr` | 17 |
| `analyse` | 13 |
| `decision` | 9 |
| autres | 28 |

**Le compte est le résultat.** L'inventaire brut n'apprend rien : la ressource est le socle, et tout en parle. Ce qui compte est l'angle.

### C2 - Neuf axes

| Axe | Question | État |
|---|---|---|
| **A1 Identité** | Qu'est-ce qui désigne une ressource | **réglé** |
| **A2 Forme** | Fichier, répertoire, dépôt, ou entrée | partiel |
| **A3 Cycle de vie** | Individuel ou collectif | **ouvert** |
| **A4 Autorité** | Qui crée, rédige, approuve | **ouvert, bloquant** |
| **A5 Dérivation** | Ce qui est source, ce qui est généré | **ouvert, bloquant** |
| **A6 Typage** | Combien de types, comment les regrouper | **réglé** |
| **A7 Validation** | Comment vérifier la conformité | **ouvert, bloquant** |
| **A8 Frontières** | Ce qui départage deux types voisins | partiel |
| **A9 Portée** | Ce qui vaut ici, ce qui se partage | **ouvert** |

### C3 - A1, l'identité, est réglé

Deux niveaux, fixés par `ADR-008` D1.

| Régime | Porteur | État |
|---|---|---|
| Interne | L'alias `<PREFIX>-<SEQ>` | fixé |
| Externe | Non fixé, `ADR-008` D7 | ouvert |

L'alias n'est **pas** l'identité : l'identité désigne l'oeuvre, `ADR-008` D5, et aucun champ ne la porte à l'interne.

`PDC-002` fixe l'ergonomie comme exigence opposable : lisible, huit caractères au plus, tapable. Mesure : 92 alias conformes sur 99.

**Ce qui reste.** Le régime externe, et ce qui porte l'identité de l'oeuvre. `NON-023` Q1.

### C4 - A6, le typage, est réglé

Trente-six définitions, six familles, un `ADR` d'adoption par famille depuis `ADR-015` D4.

La contestation sur la prolifération est **close** par `ADR-016` D5 : le nombre de types suit le nombre de natures de contenu à manipuler.

Un type se crée sous le besoin, `ADR-016` D4, et l'usage d'aucun type n'est obligatoire, sauf l'intention ultime.

### C5 - A4, l'autorité, est ouvert et bloque

Trois documents se contredisent.

| Document | Ce qu'il dit de l'agent |
|---|---|
| `CONSTITUTION.md` C1 | Ne crée ni ne modifie une `DCN` ni un `PDC` |
| `DCN-013` | Peut rédiger un premier jet, suspendu jusqu'à approbation |
| Pratique observée | Deux gabarits vides aux tâches 21 et 22, un `PDC` complet à la tâche 23 |

`DCN-013` est l'autorité ultime par son propre énoncé, donc C1 lui est subordonné. Le conflit est ouvert depuis le 2026-08-11 et il a produit trois conduites différentes en trois tâches.

**Ce que cela laisse.** Quatorze `DCN` et trois `PDC` rédigés par l'agent, dont aucun n'est approuvé. `FCT-001` l'établit, `NON-024` le conteste.

### C6 - A5, la dérivation, est ouvert et bloque le plus

Trois décisions du 2026-08-11 déclarent des types dérivés.

| Décision | Type | Documents concernés |
|---|---|---|
| `ADR-016` D3 | Skill | 7 |
| `ADR-017` D5 | ADR | 17 |
| `NON-004` Q5 | Analyse | 9 |

**Trente-trois documents ne font plus autorité en droit et continuent de commander en pratique.** `skl-001`, que l'agent lit avant d'écrire toute ressource, est dans ce cas.

Le mécanisme est spécifié en cinq étapes par `NON-026` Q5. Deux existent, les gabarits et les schémas. Trois manquent, et ce sont celles qui demandent une interprétation.

Deux des quatre sources nommées, `SPC` et `RQF`, ont zéro instance.

### C7 - A7, la validation, est ouvert et réclamé depuis huit jours

`skl-001` porte dix contrôles, `V1` à `V10`, tous exécutables à la main et aucun outillé.

Les contrôles réclamés se sont accumulés.

| Origine | Contrôle |
|---|---|
| `skl-001` | `V1` à `V10` |
| `MET-002` étape 6 | Dérivation du champ `effet` |
| `PDC-002` | Jeu de caractères et longueur des alias |
| `RES-035` | Cohérence des registres |
| `MET-004` | Croisement des relations `ISU` et `NON` |
| `MET-003` | Horodatages distincts d'un journal |

**La chaîne de validation tourne dans un script jeté**, réécrit à chaque session.

### C8 - Quatre obligations de propagation, aucune outillée

C'est le défaut qui traverse plusieurs axes.

| Obligation | Origine |
|---|---|
| Un changement d'alias met à jour toutes les références | `ADR-008` D3 |
| Une décision remplacée est marquée par dérivation | `RES-009` R3 |
| Une mise à jour du savoir atteint les ressources générées | `NON-004` Q3 |
| Un registre `saisie` suit les ressources qu'il liste | `RES-035` |

Aucune n'a de contrôle. `NON-005` conteste cette accumulation depuis le 2026-08-09.

### C9 - L'état des objections

| Effet | Nombre |
|---|---|
| bloquant | **8** |
| conditionnel | 19 |
| informatif | 6 |
| frontmatter invalide | 1 |

Quatre objections sont répondues : `NON-001` à `NON-004`. Ce sont les quatre premières du dépôt, et les seules à avoir reçu une réponse complète.

**Trois défauts d'état.**

| Objection | Défaut |
|---|---|
| `NON-026` | Cinq questions, cinq réponses, et reste `ouverte` |
| `NON-025` et `NON-030` | Même question : les skills sont dérivables et rien ne les dérive |
| `NON-027` Q1 et `NON-033` Q1 | Même question : un agent peut-il rédiger un `PDC` |

**Deux objections dont l'objet a changé sans que leur question tombe.** `NON-014`, le trilemme de nommage, écrite avant que `ADR-008` tranche l'identité. `NON-011`, les types employés sans définition, écrite quand sept types existaient.

## Réponse à la question posée

### La synthèse de la notion de ressource

Ce que le dépôt établit, au 2026-08-11.

**Une ressource est un ensemble identifiable et auto-cohérent d'informations.** Son implémentation est indifférente : fichier, répertoire, dépôt. `ADR-004`.

**Elle est composable.** Chaque composant est un atome, ressource de plein droit. `ADR-004` D3.

**Elle porte un alias interne, non une identité.** L'identité désigne l'oeuvre et n'a pas de porteur. `ADR-008`.

**Elle n'est qu'un réceptacle matérialisé d'une idée**, et son cycle de vie est collectif. `NON-004` Q4. Le modèle ne sait pas représenter ce cycle.

**Elle porte de l'information, non du savoir.** Le savoir est une relation entre un acteur et une information. `NON-004` Q3.

**Elle est source ou générée selon le contexte d'usage**, et jamais les deux à la fois pour une tâche donnée. `NON-004` Q3.

**Les six derniers énoncés datent tous du 2026-08-11.** La notion a plus changé en trois jours qu'en un an de corpus.

### Ce qui est implémentable, et le livrable visé

| Réf | Ce qui est fait | Livrable | Axe |
|---|---|---|---|
| I1 | Marquer `NON-026` répondue | `NON-026` | A5 |
| I2 | Croiser les doublons `NON-025` et `NON-030` | les deux | A5 |
| I3 | Croiser les doublons `NON-027` Q1 et `NON-033` Q1 | les deux | A4 |
| I4 | Noter dans `NON-014` et `NON-011` ce que les décisions ont changé | les deux | A1, A6 |
| I5 | Déclarer la limite de temps absente dans les cinq plans | 5 plans | A7 |

Cinq interventions, toutes sur des documents existants, aucune ne demandant d'outil.

`PLN-006` les porte.

### Ce qui n'est pas implémentable

Quatre axes ouverts, et trois ont déjà leur issue depuis la tâche 29.

| Axe | Issue existante |
|---|---|
| A5 Dérivation | `ISU-002`, `NON-030` bloquante |
| A3 Cycle de vie | `ISU-003` |
| A8 Frontières | `ISU-004` |
| A4 Autorité | `ISU-005`, `NON-033` bloquante |

**Deux axes n'ont pas d'issue.**

| Axe | Ce qui manque |
|---|---|
| **A7 Validation** | Aucune issue ne porte l'absence d'outil, alors que six sources réclament des contrôles |
| **A9 Portée** | `NON-006` porte la question depuis le 2026-08-09 sans issue |

`ISU-007` les porte, avec les objections bloquantes en relation.

## Limites

**Le seuil de trois mentions est arbitraire.** M1 compte les documents qui mentionnent la ressource au moins trois fois. Un document qui en parle une fois de façon décisive n'est pas compté.

**Les neuf axes sont une construction de l'agent.** Ils sont tirés des problématiques observées, et un autre découpage est possible. Trois axes se recouvrent partiellement : A2 et A8 sur la forme des atomes, A5 et A7 sur ce qu'un outil devrait faire.

**L'état des objections est mesuré par la présence d'un texte sous « Réponse ».** Une réponse vide de sens compterait comme une réponse.

**Aucun coût n'est chiffré.** Ni celui des cinq interventions, ni celui des axes ouverts.

**Cette analyse est écrite à la main.** `NON-004` Q5 pose que l'analyse est une ressource générée à partir de fondations et d'une question. Aucun générateur n'existe.

## Relations

- `derive-de` [ANL-008](ANL-008-le-savoir-est-une-relation-entre-un-acteur-et-une-information.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [FCT-001](../faits/FCT-001-ressources-d-autorite-redigees-par-l-agent.md)
