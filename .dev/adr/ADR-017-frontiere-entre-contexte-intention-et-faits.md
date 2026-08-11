---
type: adr
id: ADR-017
title: "Frontière entre Contexte, Intention et Faits, et rôle dérivé de l'ADR"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-11
decideurs: ["human:jvtrudel (décideur)", "claude-opus-5 (rédaction)"]
sources:
  - "NON-003, réponses Q1 à Q7 du 2026-08-10"
  - ANL-001
  - "workspace/session.md, tâche 22"
definition-associee: RES-002
---

# ADR-017 - Frontière entre Contexte, Intention et Faits

> Instruit les sept réponses de l'humain à `NON-003`. Le fait se distingue du contexte par le régime de véracité, non par la nature de l'énoncé. `INTENTION.md` devient un lien symbolique. Et l'ADR cesse d'être l'acte de décider pour devenir une justification dérivée.

## Statut

`propose`.

Cet ADR est dans la situation que sa propre décision D5 décrit : il devrait dériver d'une `DCN` qui n'existe pas encore. Le gabarit `DCN-012` a été produit et laissé à l'humain, `CONSTITUTION.md` C1 réservant sa rédaction. La tension est déclarée plutôt que contournée, et `NON-026` la porte.

## Contexte

`NON-003`, ouverte le 2026-08-09, contestait les frontières entre `CTX`, `INT` et `FCT`, définies sans aucune instance pour les éprouver. `ANL-001` classe les trois types comme latents : zéro instance de `CTX` et de `FCT` dans tout le corpus, une seule de `INT`.

Les sept réponses de l'humain, du 2026-08-10, tranchent cinq questions, en reportent une, et en ouvrent une plus large que celle qui était posée.

## Décision en une phrase

Ce qui sépare un fait d'un contexte est le régime de véracité, non le contenu ; et ce qui sépare une décision de sa justification est l'acte, ce qui fait de l'ADR un document dérivé.

## Décisions détaillées

### D1 - Le fait se distingue du contexte par le régime de véracité

**Décision.** Un `FCT` porte un énoncé dont la véracité a été établie par un processus rigoureux et normé. Un `CTX`, et toute rubrique de contexte, porte une affirmation qu'un agent pose sans vérification.

**Citation de la réponse Q5.** « Un FCT est un fait dont le niveau de véracité a été établi/éprouvé par un processus rigoureux et normé. Ce qui est dans CTX ou toute rubrique CONTEXTE peut être affimé par un agent humain ou IA sans autre vérification. Le degré de fiabilité est à prendre comme tel également. »

**Ce que cela règle.** La question posée était : un contexte peut-il énoncer des mesures sans les consigner comme faits ? La réponse est oui, et elle déplace le critère. La frontière n'est pas entre deux natures d'énoncé mais entre deux régimes de confiance.

**Conséquence sur `RES-005`.** Le test d'admission passe de trois à quatre conditions, la première étant l'établissement de la véracité. Le processus qui l'établit doit être nommé dans le recueil.

**Conséquence sur `ANL-001`.** L'analyse énonce des dizaines de mesures sans produire aucun recueil `FCT`. Elle reste conforme : ses mesures sont des affirmations d'agent, lues comme telles.

### D2 - L'affect entre dans le contexte

**Décision.** L'état émotionnel de l'humain se déduit de `workspace/session.md` et s'écrit explicitement, dans une ressource `CTX` ou dans la rubrique de contexte de la ressource concernée.

**Citation de la réponse Q2.** « déduire de session.md et mettre explicitement dans CTX ou dans les rubriques CONTEXTE d'une ressource ».

**Ce qui est renversé.** `RES-002` posait que l'affect n'entre pas dans le contexte, au motif qu'une ressource est versionnée, partageable et opposable, et que l'état émotionnel n'a aucune de ces trois propriétés.

**Ce que D1 rend possible.** L'argument tombe parce que le contexte n'a pas à être opposable : il porte des affirmations non vérifiées, lues comme telles. Un affect consigné dans un contexte est une perception d'agent, non un dossier.

### D3 - `INTENTION.md` est un lien symbolique

**Décision.** L'intention ultime vit à l'emplacement conventionnel du type, `.dev/intentions/INT-<SEQ>-<SLUG>.md`. `INTENTION.md` à la racine est un lien symbolique vers elle.

**Citation de la réponse Q1.** « INTENTION.md est une INT-<XYZ>. Il serait logique que ce soit INT-001, mais ce n'est pas une obligation contrainte. Par défaut à l'initialisation de clia dans un projet, créer INT-001 et faire de INTENTION.md un symlink de INT-001. »

**Ce que cela retire.** L'exception. `RES-003` déclarait un emplacement dérogatoire pour une instance ; le type n'en a plus.

**Ce que cela conserve.** L'adresse fixe. `ANL-001` établit que les fichiers à nom fixe en racine sont ce que les agents lisent effectivement.

**Non implémenté.** Aucune commande ne pose ce lien. `setup.sh` n'a aucun verbe d'initialisation de dépôt.

### D4 - Trois types, aucun obligatoire sauf l'intention ultime

**Décision.** `CTX`, `INT` et `FCT` restent trois types distincts. Leur usage est facultatif, à l'exception de l'instance qui porte l'intention ultime.

**Citation de la réponse Q7.** « Oui. C'est un choix de conception. Ils sont là au besoin. Mais rien n'oblige l'humain à les utiliser (sauf INT-001). »

**Ce que cela écarte.** La fusion en un type unique, plus économique et moins juste, que la question proposait.

### D5 - L'ADR est une justification dérivée, non l'acte de décider

**Décision.** L'acte de décider appartient à `DCN`. L'ADR est une justification raisonnée, générée à partir d'une ou plusieurs `DCN` et d'un ou plusieurs `FRG`.

**Citation de la réponse Q3.** « les décisions relèvent de DCN et non pas de ADR. L'ADR est une justification raisonnée générée à partir d'un ou plusieurs DCN et un ou plusieurs FRG. Nous expliquerons cela avec plus de détail, mais c'est vers ce résultat vers lequel le système clia converge. »

**C'est la décision la plus lourde des sept.** Elle ne répondait pas à la question posée, qui portait sur le type manquant pour une décision de cap. Elle en déplace le cadre.

**Ce qu'elle change dans `RES-019`.** Le régime d'édition passe de `co-edition` à `ia` : un document généré n'est pas co-édité. L'humain corrige la source, non le dérivé.

**Ce qu'elle change dans `RES-009`.** La frontière est inversée. `RES-009` posait « un ADR décide, une DCN enregistre » ; il pose désormais que la `DCN` porte l'acte et que l'ADR en dérive.

**Cohérence avec `ADR-016` D3.** Le même mouvement s'applique aux skills : ce qui se dérive n'a pas d'autorité propre. Deux des trois familles de documents de méthode du dépôt sont désormais déclarées dérivées.

**Non outillé, et le compte est lourd.** Seize ADR existent, tous écrits à la main comme des actes de décision, et aucun générateur ne dérive un ADR de ses sources. `NON-026` le porte.

### D6 - Justifier un changement de cap par une `DCN` et un `FRG` est une bonne pratique, non une obligation

**Décision.** Une révision majeure de l'intention ultime devrait produire une `DCN` et un `FRG`. Rien ne l'exige.

**Citation de la réponse Q3.** « c'est effectivement une bonne idée et une bonne pratique de justifier un changement d'intention ultime par un DCN et un FRG. Mais en pratique c'est lourd... et ça me parait difficile à faire adopter comme pratique. »

**Ce que cela laisse.** Le défaut D3 de `ANL-001` non corrigé : le corpus n'a tracé aucune de ses quatre ruptures de cap, et rien n'oblige à tracer la prochaine.

C'est un arbitrage assumé entre la rigueur et l'adoption, et l'humain le déclare comme tel.

### D7 - Deux champs deviennent facultatifs

**Décision.** `peremption` sort des champs obligatoires de `RES-002`. Il subsiste à titre indicatif.

**Citation de la réponse Q6.** « permettre à titre indicatif. Mais ne pas rendre obligatoire. »

**Motif retenu.** Celui que la question posait : personne ne relit les dates de péremption à la main, et un champ obligatoire que rien n'exploite dérive.

### D8 - Le type Acteur est reporté

**Décision.** Les acteurs restent une rubrique du contexte. Aucun type `ACT` n'est créé.

**Citation de la réponse Q4.** « Ne pas faire ça pour l'instant. Nous y reviendrons plus tard. »

## Conséquences

| Document | Effet |
|---|---|
| `RES-002` | L'affect y entre, `peremption` devient facultatif, le régime de fiabilité est déclaré |
| `RES-003` | `INTENTION.md` devient un lien symbolique, l'emplacement dérogatoire disparaît |
| `RES-005` | Test d'admission à quatre conditions, la première étant la véracité établie |
| `RES-009` | Frontière avec l'ADR inversée |
| `RES-019` | L'ADR devient dérivé, `edition: ia` |
| `contexte.cue` | `peremption` déclaré facultatif |
| `skl-001` B1 | Le pourquoi appartient à l'ADR, dérivé de la `DCN` |
| `NON-003` | Passe à `repondue`, effet `conditionnel` vers `informatif` |

**Ce que la décision assume.** D5 est prise et inapplicable : seize ADR existent, écrits comme des actes, et rien ne les dérive. Le dépôt compte désormais deux décisions de dérivation non outillées, celle-ci et `ADR-016` D3.

**Ce que la décision ne dit pas.** Ce que deviennent les seize ADR existants. Ni si un `ADR` peut subsister sans `DCN` source.

## Objections ouvertes

`NON-026`, ouverte avec cette décision : cinq questions sur ce que D5 et D3 laissent indéterminé.

`NON-024`, bloquante, sur le sort des ressources d'autorité rédigées par l'agent. D5 l'élargit : si l'ADR dérive d'une `DCN` que seul l'humain écrit, l'autorité des seize ADR existants dépend de `DCN` non approuvées.

`NON-005`, bloquante. D5 ajoute une règle non tenue.

## Relations

- `repond-a` [NON-003](../objections/NON-003-frontiere-contexte-intention-faits.md)
- `specifie` [RES-002](../ressources/RES-002-contexte.md)
- `specifie` [RES-019](../ressources/RES-019-adr.md)
- `reference` [ADR-016](ADR-016-le-systeme-est-structure-par-la-ressource.md)
