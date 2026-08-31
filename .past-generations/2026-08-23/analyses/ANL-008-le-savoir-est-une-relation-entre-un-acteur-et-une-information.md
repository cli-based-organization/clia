---
type: analyse
id: ANL-008
title: "Le savoir est une relation entre un acteur et une information"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-11
sujet: "Interprétation des sept réponses à NON-004, et des trois reproches de méthode qu'elles portent"
generated:
  by: claude-opus-5
  at: 2026-08-11
---

# ANL-008 - Le savoir est une relation entre un acteur et une information

> Les sept questions de `NON-004` portent une réponse. Trois d'entre elles reprochent à l'agent un même défaut sous trois angles : confondre ce qui est constaté avec ce qui fait autorité. Le reste redéfinit le savoir, rend l'analyse dérivée, et demande six productions.

## Objet

Interpréter les sept réponses de l'humain à `NON-004`, en décrire les implications et les conséquences pour `clia`.

Remplace `ANL-007`, produite quand une seule question portait une réponse.

## Méthode

Lecture des sept réponses, puis confrontation de chaque énoncé à l'état du dépôt au 2026-08-11.

Les trois reproches de méthode sont traités en premier, avant les questions de conception : ils portent sur la manière dont cette analyse elle-même doit être produite.

Une interprétation est signalée comme telle chaque fois qu'elle comble un silence.

## Constats

### C1 - Trois reproches, un seul défaut

Trois réponses reprochent à l'agent une erreur de méthode. Elles ne portent pas sur la conception du système.

| Réf | Réponse | Reproche |
|---|---|---|
| **R1** | Q3 | « conception naïve à propos du savoir », qui « agace beaucoup » |
| **R2** | Q5 | « prendre ce qui est observé pour une vérité », « sauter trop vite aux conclusions », « ne pas bien gérer l'incertitude et l'indétermination » |
| **R3** | Q7 | « ne semble pas bien comprendre la notion d'intention », ni « le processus de construction et son temps caractéristique » |

**Ce que chaque reproche vise, dans le texte de l'agent.**

R1 vise la question elle-même : « faut-il une forme légère de conservation du savoir, **plus courte** que la fondation ». Elle traite le savoir comme un volume dont le seul problème serait le calibre du contenant.

R2 vise `ANL-001` et son emploi. L'analyse observe cent soixante-six dépôts ; l'agent a traité ses constats comme des normes, jusqu'à proposer de « reclasser » quatre fondations d'un autre dépôt.

R3 vise le traitement de l'écart entre `INTENTION.md` et l'état du système. `ANL-001` « conteste » l'affirmation ; la question proposait de la retirer.

**Le défaut commun.** Confondre ce qui est constaté avec ce qui fait autorité. Le savoir réduit à sa forme observable, l'usage observé pris pour une norme, l'écart présent pris pour un démenti.

**Ce que la réponse Q5 pose à la place.** « la source de vérité ultime est contextuelle (dépend du repo) et elle est déterminée par l'humain via INT et DCN ».

Une observation est une hypothèse. `ANL-001` reste utile et cesse d'être normative.

### C2 - Le savoir n'est pas homogène

Réponse Q3, énoncé central : **« le savoir est une forme particulière de relation entre un acteur et une information »**.

Il en découle une frontière que le dépôt n'a jamais posée.

| Terme | Ce qu'il désigne |
|---|---|
| **Information** | Un contenu, indépendant de qui le lit |
| **Savoir** | Une relation entre un acteur et une information |

Une ressource porte de l'information. Elle ne porte du savoir que rapportée à un acteur.

**Les déclinaisons du contexte**, énumérées par la réponse et non closes.

| Contexte | Ce qu'il porte |
|---|---|
| Actuariel | Qui est l'acteur, dans quel état émotionnel, combien sont-ils |
| Intentionnel | Ce qu'on veut accomplir |
| Des moyens | Par quel moyen on prévoit de le réaliser |
| Historique | Ce qu'on a fait, et les résultats obtenus |

**Ce que cela recoupe.** `ADR-017` D2 fait entrer l'affect dans le contexte. Le contexte actuariel lui donne sa raison : l'état de l'acteur conditionne sa relation à l'information.

### C3 - Technote et fondation ne diffèrent pas par la taille

La réponse Q3 les distingue par l'usage et par l'acteur, non par le volume.

| Type | Ce qu'il fait |
|---|---|
| **Technote** | Un condensé permettant à un humain de comprendre un dispositif technique et de **l'utiliser concrètement** |
| **Fondation** | Une mobilisation du savoir existant qui établit un **socle pour un travail intellectuel** : conception, recherche de solution, activité de recherche, article |

**La technote guide l'action.** Elle doit donc tenir compte des capacités et caractéristiques de l'acteur.

**Trois déclinaisons possibles**, énoncées par la réponse : dans l'absolu, pour un acteur humain, pour un acteur IA.

**Ce que cela invalide.** La proposition d'un type `NOT` défini comme « plus court ». Une technote n'est pas une fondation raccourcie ; c'est un autre objet, orienté vers l'action d'un acteur donné.

### C4 - Une ressource peut être hybride, source et générée

Réponse Q3 : « les technotes et les fondations FND sont à la fois des ressources sources et des ressources générées. Donc, une ressource doit pouvoir être hybride (source et générée) dans l'absolu. »

Avec une restriction qui la rend opérante : « Dans un contexte d'usage, à un moment précis, pour une tâche précise, la ressource n'a qu'un seul rôle à la fois (source OU générée). »

**Ce que cela change.** `NON-026` Q5 posait que les ressources générées déclarent leurs sources. La qualité de source ou de générée devient un **rôle contextuel**, non une propriété du type.

**La conséquence que la réponse tire.** « une mise à jour du savoir mobilisé doit impliquer une mise à jour des ressources générées par ce savoir. »

C'est une obligation de propagation, la troisième du dépôt après celle des alias, `ADR-008` D3, et celle du remplacement des décisions. Aucune des trois n'est outillée.

### C5 - L'analyse devient une ressource générée

Réponse Q5, en deux énoncés.

| Type | Ce qu'il est |
|---|---|
| **Fondation** | Mobilise le savoir existant et accessible |
| **Analyse** | Une **réflexion sur une question précise**. Ressource **générée** à partir de `FND`, d'une question, et de toute autre information pertinente |

**Ce que cela étend.** Trois familles de documents sont désormais déclarées dérivées.

| Décision | Type devenu dérivé | Outillé |
|---|---|---|
| `ADR-016` D3 | Skill | non |
| `ADR-017` D5 | ADR | non |
| Réponse Q5 | **Analyse** | non |

**Ce que cela pose au document présent.** `ANL-008` devrait être générée à partir de fondations et d'une question. Elle est écrite à la main, à partir d'une objection. Le troisième mouvement de dérivation s'applique au document qui l'instruit.

**Une question ouverte dans la réponse elle-même.** « une question (besoin d'un autre type dédié ?) ». La source dont l'analyse dérive n'a pas de type.

### C6 - La ressource est un réceptacle, et son cycle de vie est collectif

Réponse Q4, trois conséquences énoncées par l'humain.

**« la ressource informationnelle n'est qu'un réceptacle matérialisé et outillable d'une idée ».**

Ce qui compte est l'idée ; la ressource est ce qui la rend manipulable.

**« le cycle de vie des ressources informationnelles n'est pas individuel, il est collectif ».**

Les idées évoluent en relation les unes avec les autres. Elles sont polymorphes selon le contexte, et leur nature peut changer quand le contexte change.

**« la notion d'espace actif est plus importante qu'il n'y paraît ».**

C'est « l'incarnation d'une contextualité informationnelle dans un espace informationnel plus large ».

**Ce que cela met en cause.** Le modèle de cycle de vie de `RES-001`, qui attribue à chaque ressource un cycle individuel, `vivant`, `point-fixe` ou `travail`. Un cycle collectif ne s'y réduit pas.

`CLAUDE.md` mentionne l'espace actif en une ligne, sans définition. Aucune ressource ne le porte.

### C7 - Le seuil d'admission des concepts est supprimé

Réponse Q6 : « non. C'est l'humain qui crée le concept qui détermine si il est pertinent ou non. Le seul critère est sa compatibilité avec clia ou avec le système où clia est utilisé. »

**Ce que cela retire.** Les trois conditions du test d'admission de `RES-007`, dont celle de l'emploi attesté dans deux ressources, qui posait le problème d'amorçage.

**Ce que cela pose.** Un critère unique et contextuel : la compatibilité avec le système. C'est cohérent avec R2 : la pertinence n'est pas mesurable par observation, elle est décidée.

### C8 - L'affirmation de INTENTION.md est maintenue

Réponse Q7 : « Sur le fond, oui. clia est un système de gestion informationnelle. Les capacités de mobilisation du savoir et de manipulation de l'information en forment le socle. Et c'est, surtout, ce qui le différencie de la majorité des autres méthodes de travail augmenté par IA. »

**Ce que la réponse corrige.** L'écart entre l'intention et l'implémentation n'est pas un démenti. Un système en cours de conception, « à la frontière de la connaissance et du savoir-faire », présente nécessairement cet écart.

**Ce que cela règle.** La question la plus ancienne de l'objection, ouverte depuis le 2026-08-09.

### C9 - clia utilise clia

Réponse Q2 : « Dans la pure tradition des projets informatiques fondateurs, clia utilise clia. »

Avec une distinction que le dépôt n'a jamais faite : les ressources **propres au dépôt clia** et les ressources **des dépôts qui utilisent clia**.

**Ce que cela pose.** Le système est décrit par ses propres ressources, pour ses fondements théoriques, sa conception et son implémentation.

**Ce que cela recoupe.** `NON-026` Q4 demandait les critères de conformité d'un dépôt `clia`. La distinction entre les deux catégories de ressources en est le préalable.

## Réponse à la question posée

### Les implications

| Réf | Implication | Ce qu'elle demande |
|---|---|---|
| I1 | Une observation est une hypothèse, non une norme | Une règle de méthode, non un document |
| I2 | Le savoir est une relation acteur-information | Une frontière à écrire dans une ontologie |
| I3 | La technote est orientée vers l'action d'un acteur | Un type, distinct de la fondation par l'usage |
| I4 | Une ressource peut être source et générée selon le contexte | Réviser la déclaration des sources |
| I5 | Une mise à jour du savoir propage aux ressources générées | Une obligation de plus, non outillée |
| I6 | L'analyse est une ressource générée | Réviser `RES-010` |
| I7 | Le cycle de vie des ressources est collectif | Met en cause le modèle de `RES-001` |
| I8 | Le seuil d'admission des concepts est supprimé | Réviser `RES-007` |
| I9 | L'affirmation de `INTENTION.md` est maintenue | Rien |
| I10 | clia utilise clia | Distinguer deux catégories de ressources |

### Les six productions demandées

| Réf | Demande | Réponse source |
|---|---|---|
| D1 | `ONT-001`, ontologie des concepts fondamentaux de clia | Q2 |
| D2 | Un type « registre », et trois instances : dette, bogues, tâches à faire | Q4 |
| D3 | Un `PDC` sur la distillation | Q4 |
| D4 | La frontière entre concept et relation | Q2 |
| D5 | La frontière entre information et savoir | Q3 |
| D6 | Un type pour la question dont l'analyse dérive, à évaluer | Q5 |

### L'ajustement minimal

Trois changements, qui ne demandent aucun outil.

**A1. Retirer le test d'admission de `RES-007`** et le remplacer par le critère unique de compatibilité.

**A2. Réviser `RES-010`** : l'analyse est une ressource générée, réflexion sur une question précise.

**A3. Écrire la règle de méthode que R2 impose** : une observation est une hypothèse. Sa place est dans `skl-001`, qui porte déjà les règles d'écriture.

### Ce que l'ajustement minimal ne règle pas

I7, le cycle de vie collectif, met en cause le modèle de `RES-001` sans qu'aucune réponse ne dise par quoi le remplacer.

I5, la propagation du savoir vers les ressources générées, est la troisième obligation non outillée du dépôt.

Les six productions demandées ne sont pas des ajustements mais des créations, ordonnées par `PLN-004`.

## Limites

**`ANL-008` est une analyse écrite à la main.** Sous C5, elle devrait être générée à partir de fondations et d'une question. Elle dérive d'une objection, et aucun générateur n'existe.

**Deux frontières demandées ne sont pas tracées ici.** D4, concept contre relation, et D5, information contre savoir. Les tracer demanderait l'ontologie que D1 réclame, et l'ordre inverse produirait une source parallèle.

**Le cycle de vie collectif n'est pas modélisé.** C6 le pose, et rien dans le dépôt ne sait le représenter. L'analyse le constate sans proposer de mécanisme.

**Aucune mesure de coût.** Les six productions ne sont pas chiffrées.

**Les trois reproches sont interprétés par leur destinataire.** C1 propose que les trois relèvent d'un même défaut. C'est une lecture de l'agent, et elle a l'inconvénient de ramener trois critiques distinctes à une seule.

## Relations

- `remplace` [ANL-007](ANL-007-interpretation-des-reponses-a-non-004.md)
- `derive-de` [ANL-007](ANL-007-interpretation-des-reponses-a-non-004.md)
- `reference` [RES-007](../ressources/RES-007-concept.md)
- `reference` [RES-010](../ressources/RES-010-analyse.md)
