---
type: ressource
id: RES-009
title: "Décision"
version: 0.2.0
status: draft
prefixe: DCN
emplacement: ".dev/decisions/DCN-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: hybride
famille: contenu
champs-obligatoires: [type, id, title, version, status, instance, date-de-decision, portee, effet, attestation, diffusion]
relations-admissibles: [decision, ressource, adr, intention, objection, fragment]
sections: [Objet, La décision, Motivation du changement, Qui a décidé, Portée, Conséquences, Ce que la décision ne dit pas, Relations]
skill: skl-004-ressource-de-contenu
adr: ADR-005
statut: actif
---

# RES-009 - Décision

> Une décision encode une décision prise par une instance ayant autorité : un texte de loi, un règlement, une délibération de conseil, un arbitrage de l'humain sur le système. Elle enregistre ce qui a été décidé, par qui, sur quelle foi, et ce qui en découle. Elle ne décide rien elle-même.

## Objet

Ce document définit le type `decision`. Sa fonction est de rendre citable et opposable une décision qui a été prise ailleurs, afin que le travail puisse s'y référer sans la reformuler.

## Statut de ce document

Deuxième jet, du 2026-08-10. Le premier jet, produit le même jour à la tâche 8, a été écrit sans aucun antécédent : `ANL-001` n'a relevé aucun mécanisme d'enregistrement de décision externe dans les cent soixante-six dépôts observés.

`FND-003`, produite à la tâche 14, comble ce manque par la littérature de sept domaines. Ce jet en tire sept conséquences, dont une renverse le mécanisme central du premier jet. La table de la section « Ce que la fondation a changé » les recense.

## Le problème que ce type résout

Le corpus produit des ADR, qui actent des décisions **de conception prises dans le dépôt**. Il n'a aucun moyen d'enregistrer une décision **prise ailleurs** et qui contraint le travail.

Trois manques concrets, tirés de `ANL-001`.

Le dépôt `le-gros-quebec/fondation-d-un-parti-politique` rassemble vingt PDF officiels d'Élections Québec, c'est-à-dire des textes réglementaires qui contraignent tout le travail du dépôt. Ils sont conservés comme documents, non comme décisions citables.

Le dépôt `cryptosecops/noumanity+qguard` est un registre de documents légaux partagés avec un tiers. Ce sont des décisions au sens de ce type, et rien ne les modélise.

Les quatre ruptures de cap du corpus que `ANL-001` relève au défaut D3 sont des décisions de l'humain sur son propre système, jamais enregistrées. Un ADR aurait pu les porter, et aucun ne l'a fait, parce qu'un ADR décide d'une architecture alors que ces ruptures décidaient d'un cap.

**Un quatrième manque, établi par `FND-003`.** Aucun des sept domaines de la littérature ne traite le cas d'une organisation qui enregistre une décision prise par une instance tierce pour s'y référer. Chacun documente ses propres décisions. Ce cas, qui est l'usage principal de ce type, n'a donc pas de modèle disponible : ce document en propose un.

## Ce qu'est une décision

Une ressource vivante qui porte six choses. La sixième est ajoutée par ce jet.

| Elle porte | Rôle |
|---|---|
| **La décision** | Ce qui a été décidé, en une formulation qui tient debout seule |
| **L'instance** | Qui a décidé, et à quel titre elle en avait le pouvoir |
| **La date** | Quand la décision a été prise, distincte de la date d'enregistrement |
| **La portée** | Sur quoi la décision s'applique, et sur quoi elle ne s'applique pas |
| **Les conséquences** | Ce qui change dans le travail du fait de cette décision |
| **L'attestation** | Sur quelle foi l'enregistrement est tenu pour fidèle |

Les cinq premières font consensus dans la littérature. La sixième vient de l'archivistique et est négligée partout ailleurs : la norme ISO 15489 exige d'un enregistrement qu'il soit authentique, fiable et intègre, et ces trois propriétés ne se présument pas, elles s'attestent (`FND-003`, QR2).

## Ce qu'une décision n'est pas

C'est ici que le type se distingue de ses voisins, et la confusion serait coûteuse.

| Ce n'est pas | Différence |
|---|---|
| Un **ADR** | Un ADR décide, une DCN enregistre. Un ADR porte des alternatives écartées et des portes de sortie parce qu'il est l'acte de décider ; une DCN n'en porte pas, elle constate |
| Un **fait** | Un fait est un énoncé vérifiable. Une décision est un acte de volonté, qui peut être mauvais et rester en vigueur |
| Une **intention** | Une intention énonce un but poursuivi. Une décision énonce une contrainte acquise |
| Un **fragment** | Un fragment est du matériau textuel capté. Une décision est un acte dont on enregistre la teneur |
| Une **délibération** | Ajout de ce jet, développé ci-dessous |

### La décision n'est pas sa délibération

Cette frontière est ajoutée par ce jet et elle est la plus conséquente des cinq, parce qu'elle détermine ce qui est communicable.

Le droit administratif américain sépare juridiquement les deux : le privilège du processus délibératif protège ce qui est antérieur à la décision, tandis que la décision elle-même est publiable (`FND-003`, étape 3). Le champ du design rationale fait l'inverse et les confond délibérément. Les deux positions sont défendables et incompatibles.

**Ce type retient la séparation.** Une `DCN` porte le dispositif, non le chemin qui y a mené. Le chemin, lorsqu'il mérite d'être conservé, vit dans un ADR, dans une objection ou dans un fragment, qui ont chacun leur propre régime de diffusion.

La raison est pratique autant que juridique. Horner et Atwood établissent que le raisonnement capturé peut faire courir un risque à son auteur ou à l'organisation, et que ce facteur politique n'a aucune solution technique (`FND-003`, étape 7). Confondre décision et délibération dans un même document oblige à choisir un seul régime de diffusion pour les deux, et le régime le plus restrictif l'emporte toujours. La décision, qui devrait être opposable, devient alors aussi confidentielle que sa délibération.

**Cas limite assumé.** L'humain qui tranche une objection sur le système prend une décision. Faut-il une DCN, ou la réponse écrite dans l'objection suffit-elle ? Ce jet maintient la proposition du premier : la réponse dans l'objection suffit tant qu'elle ne change pas une décision antérieure ; une DCN devient nécessaire dès qu'un cap est modifié. Voir les points ouverts.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `instance` | Texte libre | Qui a décidé. Suit la convention d'acteur : `human:<id>`, un nom d'organisation, ou un intitulé d'instance |
| `date-de-decision` | Date ISO | Quand la décision a été prise, jamais quand elle a été enregistrée |
| `portee` | `systeme`, `depot`, `domaine`, `externe` | Ce que la décision contraint |
| `effet` | `proposee`, `en-vigueur`, `suspendue`, `abrogee`, `remplacee` | État de la décision |
| `attestation` | `interne`, `source-primaire`, `source-rapportee`, `temoignage` | Sur quelle foi l'enregistrement est tenu pour fidèle |
| `diffusion` | `public`, `prive`, `confidentiel` | Régime de communication de l'enregistrement |

### Le champ attestation

Ajouté par ce jet. Il répond à la question que la littérature archivistique pose et que les autres domaines ignorent : qu'est-ce qui garantit que l'enregistrement est fidèle à la décision (`FND-003`, QR4) ?

| Valeur | Ce qu'elle affirme | Ce qu'elle exige de la section « Qui a décidé » |
|---|---|---|
| `interne` | La décision a été prise dans ce dépôt, sa trace est le dépôt lui-même | Le renvoi vers la trace : session, objection, ADR, commit |
| `source-primaire` | Le texte de la décision a été consulté directement | Le renvoi vers le document, avec sa date de consultation |
| `source-rapportee` | La décision est connue par un intermédiaire | L'intermédiaire, nommé, et la mention explicite du caractère rapporté |
| `temoignage` | La décision est connue par ce qu'une personne en dit | Qui témoigne, et quand |

La hiérarchie est celle de `MET-001` pour les sources, et elle a la même fonction : un enregistrement `source-rapportee` reste citable, mais il ne peut jamais être présenté comme établi.

Aucun domaine consulté ne garantit la fidélité par un mécanisme technique. Tous emploient une procédure, approbation formelle, signature, triade d'authenticité (`FND-003`, QR4). Ce champ ne garantit donc rien à lui seul : il rend explicite ce sur quoi le lecteur s'appuie.

### Le champ diffusion

Ajouté par ce jet, avec les mêmes valeurs et le même sens que dans `RES-005`.

Une décision peut être plus sensible qu'un fait : elle nomme une instance, elle porte souvent un enjeu, et elle engage. `RES-005` déclare le champ obligatoire au motif qu'un système qui consigne des faits sans déclarer leur régime de diffusion fabrique une fuite en attente. L'argument vaut a fortiori ici, et `FND-003` le fonde dans la littérature par le facteur politique de Horner et Atwood et par le privilège du processus délibératif.

Pour une décision interne à ce dépôt, la valeur est `public` par défaut, et ce défaut est un choix, non une absence.

### Le champ effet, et ce qu'il ne fait plus

Le champ subsiste, avec ses cinq valeurs, mais son rôle est réduit par ce jet. Le mécanisme de changement ne repose plus sur lui : voir la section suivante.

**La valeur `proposee` est un ajout de la tâche 8, et elle mérite justification.** Une décision au sens strict est prise avant d'être enregistrée, et cette valeur semble donc contredire la définition. Elle est nécessaire pour un cas réel : un ADR au statut `propose` porte une décision formulée, argumentée, et non actée. La DCN correspondante peut exister et attendre l'acte, ce qui donne à l'humain un document à approuver plutôt qu'un ADR de deux cents lignes à lire. Le passage de `proposee` à `en-vigueur` appartient à l'humain seul.

## Le changement d'une décision est un acte, non un état

C'est la modification la plus importante de ce jet, et elle renverse le mécanisme du premier.

### Ce que le premier jet posait, et pourquoi cela ne tient pas

Le premier jet posait qu'une décision qui en remplace une autre déclare `remplace`, et que l'ancienne passe en `effet: remplacee`. Le changement était donc un changement d'état, tenu à la main.

`FND-003` établit que ce mécanisme échoue, et par deux voies indépendantes.

**Par la littérature.** Dans un fichier markdown, « remplacé » signifie que quelqu'un se souvient de mettre à jour le champ de statut, ce que personne ne fait (Konishi, 2026, source secondaire signalée comme telle). L'affirmation est corroborée par l'étude d'adoption de Rösch et al., qui mesure qu'environ la moitié des dépôts observés s'arrêtent à cinq enregistrements.

**Par ce corpus.** `ANL-001` mesure ce que devient une information tenue à la main : `completed` dans cinquante-deux logs et `complet` dans deux du même dépôt. Le dépôt n'a donc pas besoin de croire la source secondaire, il a déjà la mesure.

### Ce que le droit fournit à la place

Le droit du précédent est le seul domaine où écarter une décision antérieure exige une justification écrite, la *special justification* du *stare decisis* (`FND-003`, QR3). Partout ailleurs, le changement est un champ de statut, et ce champ n'est pas tenu.

La leçon transposable, telle que `FND-003` la formule : **un état se met à jour ou s'oublie ; un acte laisse une trace même s'il est incomplet.**

### La règle retenue

Trois énoncés, et le troisième est ce qui rend les deux premiers vérifiables.

**R1. Un revirement produit une nouvelle `DCN`.** On ne renverse pas une décision en éditant celle qui existe. On en enregistre une nouvelle, qui déclare `remplace` vers l'ancienne.

**R2. La nouvelle `DCN` motive le changement.** La section « Motivation du changement » est obligatoire et porte ce que la décision antérieure tenait pour acquis et qui ne l'est plus. Une nouvelle décision qui ne dit pas pourquoi l'ancienne ne tient plus est un revirement subi, non un revirement décidé.

**R3. Le champ `effet: remplacee` est dérivable, donc vérifiable.** Une décision est remplacée si et seulement si une autre déclare `remplace` vers elle. Le champ n'est plus une information à tenir mais le report d'un fait lisible dans le dépôt, et un contrôle peut comparer les deux.

R3 applique à ce type ce que `ADR-003` D7 prescrit déjà en général : la couche machine-lisible est dérivée, jamais écrite. La règle n'introduit donc aucun principe nouveau, elle corrige une exception.

**Ce contrôle n'existe pas encore.** Il est spécifié ici et n'est outillé nulle part, ce qui en fait la cinquième règle écrite et non tenue de cette session. `NON-005` conteste cette accumulation, et `MET-002` porte le contrôle en toutes lettres pour qu'il soit implémentable sans relire ce document.

### Ce qui n'est pas modifié

La teneur d'une décision reste immuable, et l'ancienne n'est jamais supprimée. Nygard prescrivait déjà de garder l'ancienne en la marquant, au motif qu'il reste pertinent de savoir qu'elle **a été** la décision (`FND-003`, étape 6). Ce jet ne change que la manière dont la marque est produite.

## Cycle de vie

`vivant`, avec une nuance propre à ce type. La teneur d'une décision est immuable : la reformuler serait falsifier. Ce qui évolue est la liste de ses conséquences constatées, et son `effet` lorsqu'il change pour une raison autre qu'un remplacement.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| La décision, l'instance, la date, l'attestation | L'humain, ou l'agent citant une source externe vérifiable |
| Les conséquences constatées | Les deux, en append |
| L'effet, sauf `remplacee` qui est dérivé | L'humain seul |
| La diffusion | L'humain seul |

L'agent ne modifie jamais la teneur d'une décision enregistrée. Il peut en constater les conséquences.

Le régime de diffusion appartient à l'humain pour la raison que `FND-003` établit : le risque qu'un enregistrement fait courir à son auteur ou à l'organisation est un fait organisationnel, qu'aucun format ne résout et qu'un agent n'est pas en position d'évaluer.

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

Deux rubriques sont obligatoires et méritent leur justification.

**« Ce que la décision ne dit pas ».** Une décision enregistrée sans ses silences se lit comme plus large qu'elle n'est, et devient un argument d'autorité.

**« Motivation du changement ».** Elle porte `Sans objet, cette décision n'en remplace aucune` lorsque c'est le cas, et cette ligne est exigée plutôt que l'omission de la section. Une section absente ne se distingue pas d'un oubli ; une ligne explicite se relit. C'est le même dispositif que la rubrique précédente, et pour la même raison.

## Coût de ce type, mesuré

`FND-003` établit que l'adoption des enregistrements de décision échoue par la charge documentaire et non par le format : les équipes privilégient des structures simples et faciles à maintenir (Rösch et al., 2026). Le nombre de champs obligatoires est donc un risque d'abandon, non un gage de rigueur.

| Version | Champs obligatoires | Sections |
|---|---|---|
| v0.1.0, tâche 8 | 9 | 7 |
| v0.2.0, ce jet | **11** | **8** |

Ce jet alourdit le type de deux champs et d'une section, en connaissance de cette mesure. Les deux champs sont énumérés, donc leur saisie coûte un mot, et les deux ont un défaut évident pour une décision interne. Cela ne suffit pas à écarter le risque : `NON-022` le porte avec ces chiffres.

## Ce que la fondation a changé

Les sept apports de `FND-003`, et leur traitement.

| Apport | Traitement dans ce jet |
|---|---|
| Séparer la décision de sa délibération | Section « La décision n'est pas sa délibération » |
| Le changement est un acte, non un état | Règles R1 à R3, et la section obligatoire « Motivation du changement » |
| L'authenticité doit être attestée | Champ `attestation`, à quatre valeurs |
| La capture doit être un produit dérivé | Renvoyé à `MET-002` : c'est un procédé, non un critère de validité |
| Le facteur politique n'a pas de solution technique | Champ `diffusion`, et propriété humaine de ce champ |
| Le consensus est l'absence d'objection non traitée | Renvoyé à `MET-002`, règle de clôture |
| L'adoption échoue par la charge | Section « Coût de ce type », et `NON-022` |

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
