---
type: analyse
id: ANL-004
title: "Verbosité justificative des définitions de type : diagnostic, cause, correctif"
status: draft
date: 2026-08-10
sujet: "Pourquoi les trente définitions RES justifient au lieu de prescrire, et ce qui le corrige"
generated:
  by: claude-opus-5
  at: 2026-08-10
---

# ANL-004 - Verbosité justificative des définitions de type

> Un cinquième du texte des trente définitions `RES` est consacré à des sections qui justifient au lieu de prescrire. Le harnais prescrit ces sections. Il se contredit lui-même, et la contradiction est logée dans un seul document, `skl-001`.

## Objet

Diagnostiquer la verbosité justificative des définitions `RES`, en établir la cause, et énoncer le correctif.

Demandé par la tâche 15 de la session du 2026-08-09, classée `[bogue]`.

## Méthode

Trois mesures sur les trente définitions de `.dev/ressources/`, au 2026-08-10.

| Mesure | Ce qu'elle compte |
|---|---|
| M1 | Part des mots logés dans des sections méta-justificatives |
| M2 | Occurrences de marqueurs lexicaux de justification |
| M3 | Taux de reprise de chaque rubrique prescrite par `skl-001` B3 |

M1 découpe chaque fichier par titre de niveau 2 et somme les mots par rubrique. Sont classées méta-justificatives les rubriques qui portent sur le document ou sur la décision de l'écrire, non sur le type défini : `Statut de ce document`, `Points ouverts`, `Le problème que ce type résout`, `Ce que la fondation a changé`, `Coût de ce type, mesuré`, `Auto-application`.

M2 compte quatorze motifs. Le comptage est lexical, donc il sous-estime : une justification écrite sans marqueur n'est pas comptée.

M3 compare les titres présents aux douze rubriques du gabarit de `skl-001` B3.

Les trois mesures sont reproductibles par relecture des fichiers. Aucune n'est un jugement de style.

## Constats

### C1 - Un cinquième du texte ne décrit pas le type

| Mesure | Valeur |
|---|---|
| Mots dans le corps des trente définitions | 17 922 |
| Mots dans les rubriques méta-justificatives | **3 724** |
| Part | **20,8 pour cent** |

Cinq définitions dépassent 22 pour cent.

| Définition | Part méta |
|---|---|
| `RES-007`, Concept | 29,3 |
| `RES-006`, Ontologie | 25,0 |
| `RES-009`, Décision | 24,3 |
| `RES-008`, Fragment | 23,9 |
| `RES-003`, Intention | 22,5 |

`RES-009` a été produit le jour de ce diagnostic.

### C2 - Cent quarante-six marqueurs de justification

| Marqueur | Occurrences |
|---|---|
| « le corpus » | 39 |
| « premier jet », « deuxième jet » | 34 |
| « pourquoi » | 20 |
| « parce que » | 16 |
| « ce jet propose », « ce jet retient » | 9 |
| « assumé », « écarté », « retenu » | 8 |
| « justifie », « justification » | 10 |
| autres | 10 |
| **Total** | **146** |

Densité moyenne : 6,6 marqueurs pour mille mots.

### C3 - Le harnais est suivi là où il justifie, ignoré là où il prescrit

`skl-001` B3 fixe douze rubriques. Taux de reprise du titre exact :

| Rubrique prescrite | Nature | Reprise |
|---|---|---|
| Objet | descriptive | 30/30 |
| **Statut de ce document** | **méta** | **30/30** |
| **Points ouverts** | **méta** | **30/30** |
| Relations | descriptive | 30/30 |
| Ce qu'est \<le type\> | descriptive | 13/30 |
| Structure attendue d'une instance | descriptive | 12/30 |
| Régime d'édition | descriptive | 11/30 |
| Ce que \<le type\> n'est pas | descriptive | 8/30 |
| Le problème que ce type résout | méta | 6/30 |
| Test d'admission | descriptive | 3/30 |
| Cycle de vie et versionnage | descriptive | 1/30 |
| Frontière avec les types voisins | descriptive | 1/30 |

Deux rubriques méta sont reprises par les trente définitions, au titre près. Les rubriques descriptives sont reprises entre 1 et 13 fois sur 30, sous des titres variables.

`skl-001` B3 déclare `Frontière avec les types voisins` non optionnelle. Une définition sur trente la porte.

### C4 - Trois structures concurrentes pour un même document

| Source | Rubriques | Portée |
|---|---|---|
| `skl-001` B3 | 12 | La définition elle-même |
| `.dev/templates/ressource.template.md` | 8 | La définition elle-même |
| Champ `sections` de chaque définition | variable | **Les instances du type défini** |

Le champ `sections` d'une définition décrit les sections de ses instances. Le gabarit `ressource.template.md` porte les huit rubriques de `RES-001`, qui sont les sections que `RES-001` déclare pour ses instances.

Aucune donnée machine-lisible ne borne la structure d'une définition. Seul `skl-001` B3 la porte, en texte libre.

### C5 - La justification n'a pas de foyer

Le champ `adr` de chaque définition désigne la décision qui a adopté le type.

| Valeur du champ `adr` | Définitions |
|---|---|
| `ADR-005` | 23 |
| `aucun` | 6 |
| `ADR-001` | 1 |

`ADR-005` décide le regroupement des types en familles. Il ne décide l'adoption d'aucun type.

**Vingt-neuf types sur trente n'ont aucun ADR qui décide leur adoption.**

### C6 - Le harnais se contredit à quatorze lignes d'intervalle

`skl-001` B1, ligne 122 :

> Ce qu'est le type → la définition, `RES`. **Pourquoi il a été adopté → la décision, `ADR`.** Comment on le produit → le processus, `skl`.

`skl-001` B3, ligne 168, gabarit de la définition :

> `## Le problème que ce type résout`

Et ligne 167 :

> `## Statut de ce document`

B1 interdit le pourquoi dans la définition. B3 le prescrit sous deux rubriques. Les deux règles sont dans le même document, séparées par quarante-cinq lignes.

### C7 - Aucune règle de registre

`skl-001` A3 « Écriture » porte cinq règles.

| Règle | Nature |
|---|---|
| Pas de filet horizontal | typographie |
| Pas de retour à la ligne manuel | typographie |
| Pas de tiret cadratin | typographie |
| Relisible sans mémoire de session | fond |
| Ce qui n'est pas su est écrit comme tel | fond |

Aucune règle ne porte sur le registre, la longueur, ni la distinction entre prescrire et justifier.

La cinquième règle produit la rubrique `Points ouverts` dans les trente définitions.

## Réponse à la question posée

### La cause

**Le harnais prescrit ce qu'il reproche.** Trois mécanismes, par ordre de force.

**Cause 1, directe.** `skl-001` B3 prescrit deux rubriques méta-justificatives dans le gabarit de toute définition. Elles sont reprises par 30 définitions sur 30. C3 le mesure.

**Cause 2, structurelle.** La justification n'a pas d'autre foyer. B1 l'assigne à l'`ADR`. Vingt-neuf types sur trente n'ont pas d'`ADR`. C5 le mesure.

**Cause 3, permissive.** Aucune règle de registre n'existe. C7 le mesure. La contradiction interne de C6 n'est arbitrée par rien.

L'agent applique B3 et A3. Le défaut est dans le harnais, non dans son exécution.

### Le correctif

Cinq changements. Les trois premiers suppriment la cause, les deux derniers empêchent la récidive.

**F1. Retirer les deux rubriques méta du gabarit de `skl-001` B3.** `Statut de ce document` et `Le problème que ce type résout` disparaissent. `Points ouverts` devient une table à deux colonnes, question et objection, sans prose.

**F2. Aligner le gabarit B3 sur B1.** Onze rubriques restantes, toutes descriptives. Une définition dit ce qu'est le type, ce qu'il n'est pas, ses champs, son cycle de vie, son régime d'édition, la structure de ses instances. Elle ne dit pas pourquoi il existe.

**F3. Ouvrir le foyer de la justification.** Deux options, à trancher par l'humain.

| Option | Portée | Coût |
|---|---|---|
| Un `ADR` par famille, six au total | Les six familles de `ADR-005` | 6 documents |
| Un `ADR` unique d'adoption des types | Les trente types | 1 document |

Sans F3, la justification retirée des définitions n'a nulle part où aller et reviendra.

**F4. Ajouter une règle de registre à `skl-001` A3.**

> **Directif et factuel.** Une ressource énonce ce qui est, non pourquoi on l'a décidé. Interdits : la défense d'un choix de rédaction, la comparaison avec une version antérieure du document, le récit de sa production. Les références externes, quand elles sont nécessaires, prennent la forme d'une bibliographie numérotée en fin de document.

**F5. Ajouter un contrôle V10 mesurable.**

> **V10 - Aucune rubrique méta.** Le document ne porte aucune rubrique de la liste noire : `Statut de ce document`, `Le problème que ce type résout`, `Ce que la fondation a changé`, `Auto-application`, et toute rubrique dont le sujet est le document lui-même.

Le contrôle est exécutable par un `grep` sur les titres de niveau 2.

### Ce que le correctif ne supprime pas

`Points ouverts` reste, sous forme de table. Une lacune n'est pas une justification. `skl-001` A3 l'exige et `RES-004` en dépend.

`Relations` reste.

Les mesures citées dans une définition restent quand elles décrivent le type. Elles disparaissent quand elles défendent un choix de rédaction.

## Limites

**M2 sous-estime.** Le comptage est lexical. Une justification écrite sans marqueur n'est pas comptée. Le nombre réel est supérieur à 146.

**M1 dépend d'un classement.** Six rubriques sont classées méta. Le classement est déclaré en Méthode et vérifiable, mais il n'est pas mécanique.

**La portée est limitée aux définitions `RES`.** Les autres familles ne sont pas mesurées. Le repérage informel indique le même défaut dans les `ADR`, les `MET` et les `NON`. Aucune mesure n'est produite.

**Le coût de F3 n'est pas chiffré.** Le volume de justification à déplacer vers les `ADR` n'est pas mesuré, et il dépend de l'option retenue.

**Aucun cas d'épreuve.** Le correctif n'a été appliqué à aucune définition. `PLN-002` porte l'épreuve sur `RES-009` comme premier chantier.

## Relations

- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [RES-009](../ressources/RES-009-decision.md)
- `reference` [ADR-005](../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
- `reference` [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md)
