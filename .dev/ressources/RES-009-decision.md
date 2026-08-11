---
type: ressource
id: RES-009
title: "Décision"
version: 0.3.0
status: draft
prefixe: DCN
emplacement: ".dev/decisions/DCN-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: humain
famille: contenu
champs-obligatoires: [type, id, title, version, status, instance, date-de-decision, portee, effet, attestation, diffusion]
relations-admissibles: [decision, ressource, adr, intention, objection, fragment]
sections: [Objet, La décision, Motivation du changement, Qui a décidé, Portée, Conséquences, Ce que la décision ne dit pas, Relations]
skill: skl-004-ressource-de-contenu
adr: ADR-010
statut: actif
---

# RES-009 - Décision

> Une décision encode une décision prise par une instance ayant autorité : un texte de loi, un règlement, une délibération de conseil, un arbitrage de l'humain sur le système. Elle enregistre ce qui a été décidé, par qui, sur quelle foi, et ce qui en découle. Elle ne décide rien elle-même.

## Objet

Ce document définit le type `decision`. Sa fonction est de rendre citable et opposable une décision prise ailleurs, afin que le travail puisse s'y référer sans la reformuler.

## Ce qu'est une décision

Une ressource vivante qui porte six choses.

| Elle porte | Rôle |
|---|---|
| **La décision** | Ce qui a été décidé, en une formulation qui tient debout seule |
| **L'instance** | Qui a décidé, et à quel titre elle en avait le pouvoir |
| **La date** | Quand la décision a été prise, distincte de la date d'enregistrement |
| **La portée** | Sur quoi la décision s'applique, et sur quoi elle ne s'applique pas |
| **Les conséquences** | Ce qui change dans le travail du fait de cette décision |
| **L'attestation** | Sur quelle foi l'enregistrement est tenu pour fidèle |

## Ce qu'une décision n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **ADR** | La `DCN` porte l'acte, l'ADR en dérive la justification. `NON-003` Q3. Un ADR porte les alternatives écartées et les portes de sortie ; une `DCN` n'en porte pas, elle constate |
| Un **fait** | Un fait est un énoncé vérifiable. Une décision est un acte de volonté, qui peut être mauvais et rester en vigueur |
| Une **intention** | Une intention énonce un but poursuivi. Une décision énonce une contrainte acquise |
| Un **fragment** | Un fragment est du matériau textuel capté. Une décision est un acte dont on enregistre la teneur |
| Une **délibération** | Le dispositif, non le chemin qui y a mené |

### La décision n'est pas sa délibération

Une `DCN` porte le dispositif. Le chemin qui y a mené vit dans un ADR, dans une objection ou dans un fragment, qui ont chacun leur propre régime de diffusion.

Un document unique force un régime de diffusion unique, et le plus restrictif l'emporte. Une décision, qui doit être opposable, deviendrait alors aussi confidentielle que ce qui l'a précédée [1] [2].

**Cas limite.** La réponse écrite dans une objection suffit tant qu'elle ne change pas une décision antérieure. Une `DCN` devient nécessaire dès qu'un cap est modifié. Voir les points ouverts.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `instance` | Texte libre | Qui a décidé. Suit la convention d'acteur : `human:<id>`, un nom d'organisation, ou un intitulé d'instance |
| `date-de-decision` | Date ISO | Quand la décision a été prise, jamais quand elle a été enregistrée |
| `portee` | `systeme`, `depot`, `domaine`, `externe` | Ce que la décision contraint |
| `effet` | `proposee`, `en-vigueur`, `suspendue`, `abrogee`, `remplacee` | État de la décision |
| `attestation` | `interne`, `source-primaire`, `source-rapportee`, `temoignage` | Sur quelle foi l'enregistrement est tenu pour fidèle |
| `diffusion` | `public`, `prive`, `confidentiel` | Régime de communication de l'enregistrement |

### attestation

| Valeur | Ce qu'elle affirme | Ce qu'elle exige de la section « Qui a décidé » |
|---|---|---|
| `interne` | La décision a été prise dans ce dépôt, sa trace est le dépôt lui-même | Le renvoi vers la trace : session, objection, ADR, commit |
| `source-primaire` | Le texte de la décision a été consulté directement | Le renvoi vers le document, avec sa date de consultation |
| `source-rapportee` | La décision est connue par un intermédiaire | L'intermédiaire, nommé, et la mention explicite du caractère rapporté |
| `temoignage` | La décision est connue par ce qu'une personne en dit | Qui témoigne, et quand |

La hiérarchie est celle de `MET-001` pour les sources. Un enregistrement `source-rapportee` reste citable et n'est jamais présenté comme établi.

Ce champ ne garantit rien à lui seul : il rend explicite ce sur quoi le lecteur s'appuie [3].

### diffusion

Mêmes valeurs et même sens que dans `RES-005`.

Pour une décision interne à ce dépôt, la valeur est `public` par défaut.

### effet

Cinq valeurs. La valeur `remplacee` est **dérivée** et non saisie : voir R3.

La valeur `proposee` couvre le cas d'un ADR au statut `propose`, qui porte une décision formulée et non actée. Le passage de `proposee` à `en-vigueur` appartient à l'humain seul.

## Test d'admission

Une décision mérite d'être enregistrée si les trois conditions sont réunies.

1. Un acte a eu lieu. Une orientation, un consensus mou ou une préférence exprimée n'en sont pas.
2. L'instance avait le pouvoir de décider. Sinon, l'enregistrement fabrique une autorité qui n'existe pas.
3. La décision contraint le travail du dépôt.

## Le changement d'une décision est un acte, non un état

Trois règles. La troisième rend les deux premières vérifiables.

**R1.** Un revirement produit une nouvelle `DCN`, qui déclare `remplace` vers l'ancienne. On ne renverse pas une décision en éditant celle qui existe.

**R2.** La nouvelle `DCN` motive le changement. La section « Motivation du changement » porte ce que la décision antérieure tenait pour acquis et qui ne l'est plus.

**R3.** Le champ `effet: remplacee` est dérivable : une décision est remplacée si et seulement si une autre déclare `remplace` vers elle. Le champ est le report d'un fait lisible dans le dépôt, et un contrôle peut comparer les deux.

R3 applique ce que `ADR-003` D7 prescrit en général : la couche machine-lisible est dérivée, jamais écrite.

**Le contrôle de R3 n'est outillé nulle part.** Il est spécifié dans `MET-002` étape 6. `NON-005` et `NON-022` Q3 le portent.

**Ce que les trois règles ne changent pas.** La teneur d'une décision est immuable, et une décision remplacée n'est jamais supprimée [4].

**Ce que les trois règles ne couvrent pas.** Le remplacement partiel. `NON-023` Q5.

## Cycle de vie et versionnage

`vivant`. La teneur d'une décision est immuable : la reformuler serait falsifier.

Ce qui évolue est la liste des conséquences constatées, et le champ `effet` lorsqu'il change pour une raison autre qu'un remplacement.

## Régime d'édition

`humain`. `CONSTITUTION.md` C1 : seuls les humains décident.

| Geste | Qui |
|---|---|
| Produire le gabarit, `clia res new decision` | L'agent ou l'humain |
| Renseigner la décision, l'instance, la date, l'attestation | L'humain seul |
| Poser `portee`, `effet`, `diffusion` | L'humain seul |
| Modifier une instance existante | L'humain seul |
| Recommander une décision | L'agent, dans une analyse, un plan ou une objection |

Un agent qui constate une conséquence la porte dans une objection ou dans le journal de sa tâche, jamais dans la `DCN`.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `ADR` | L'acte de décider contre sa justification, qui en dérive |
| `FCT` | Un énoncé vérifiable contre un acte de volonté |
| `INT` | Un but poursuivi contre une contrainte acquise |
| `FRG` | Du matériau capté contre un acte dont on enregistre la teneur |
| `NON` | Une question posée contre une question tranchée |

## Structure attendue d'une instance

```
# DCN-<SEQ> - <Titre>

> La décision en une phrase.

## Objet
## La décision
## Motivation du changement
## Qui a décidé
## Portée
## Conséquences
## Ce que la décision ne dit pas
## Relations
```

Deux rubriques sont obligatoires.

**« Ce que la décision ne dit pas ».** Une décision enregistrée sans ses silences se lit comme plus large qu'elle n'est.

**« Motivation du changement ».** Elle porte `Sans objet, cette décision n'en remplace aucune` lorsque c'est le cas. Une section absente ne se distingue pas d'un oubli ; une ligne explicite se relit.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-003](RES-003-intention.md)
- `reference` [RES-005](RES-005-fait.md)
- `reference` [RES-008](RES-008-fragment.md)
- `derive-de` [FND-003](../fondations/FND-003-decisions-institutionnelles-tracables.md)
- `reference` [MET-002](../methodologies/MET-002-enregistrement-et-suivi-d-une-decision.md)

## Points ouverts

| Question | Objection |
|---|---|
| Une réponse d'objection est-elle une décision au sens de ce type | `NON-015` |
| Qui vérifie qu'une décision enregistrée est fidèle à sa source | `NON-015` |
| Une décision externe doit-elle porter son texte, ou seulement son renvoi | `NON-015` |
| Onze champs obligatoires sont-ils tenables | `NON-022` |
| Qui met `effet` à jour tant que la dérivation n'est pas outillée | `NON-022` |
| Comment se déclare le remplacement partiel d'une décision | `NON-023` |

## Sources

1. **American Constitution Society**. *Check Your Deliberative Process Privilege*, 2023. Note d'étudiant, statut secondaire. Citée par `FND-003`, entrée 27.
2. **Horner, J. et Atwood, M. E.** *Design Rationale: The Rationale and the Barriers*, 2006. Citée par `FND-003`, entrée 5.
3. **CASRAI**. *ISO 15489: Records Management Concepts and Principles*. Triade authenticité, fiabilité, intégrité. Citée par `FND-003`, entrée 9.
4. **Nygard, M.** *Documenting Architecture Decisions*, 15 novembre 2011. Citée par `FND-003`, entrée 6.
