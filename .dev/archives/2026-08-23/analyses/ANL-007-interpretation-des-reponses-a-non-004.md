---
type: analyse
id: ANL-007
title: "Interprétation des réponses à NON-004 : le savoir et ses frontières"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-11
sujet: "Ce que la réponse Q1 de NON-004 change, et ce que six questions sans réponse laissent en suspens"
generated:
  by: claude-opus-5
  at: 2026-08-11
---

# ANL-007 - Interprétation des réponses à NON-004

> Une question sur sept porte une réponse. Elle est riche et ouvre un chantier technique. Les six autres sont vides, dont les deux que l'objection désigne comme celles qui la lèveraient.

## Objet

Interpréter les réponses de l'humain à `NON-004`, en décrire les implications et les conséquences pour `clia`.

Demandé par la tâche 25 de la session du 2026-08-09.

## Méthode

Relevé de l'état de chaque question, puis interprétation de ce qui est répondu et inventaire de ce qui ne l'est pas.

Une interprétation est signalée comme telle chaque fois qu'elle comble un silence.

L'analyse porte sur ce qui est écrit au 2026-08-11. Une réponse ajoutée après cette date la périme.

## Constats

### C1 - Une réponse sur sept

| Question | Sujet | État |
|---|---|---|
| **Q1** | Le concept est-il un type distinct | **répondue** |
| Q2 | Où vit le vocabulaire de relations en attendant `ONT-001` | vide |
| Q3 | Faut-il une forme légère de conservation du savoir | vide |
| Q4 | Que faire des sept concepts orphelins du corpus | vide |
| Q5 | La frontière fondation contre analyse est-elle tenue | vide |
| Q6 | Le seuil d'admission des concepts est-il applicable | vide |
| Q7 | L'affirmation de `INTENTION.md` est-elle maintenue | vide |

**Ce que l'objection déclarait.** « Une réponse à Q2 et Q3. Q2 résorbe une contradiction interne du jet, Q3 répond au manque fonctionnel le plus mesuré du corpus. »

Les deux sont vides. `NON-004` **n'est pas levée** par les réponses reçues.

### C2 - Ce que la réponse Q1 pose

Quatre énoncés, dont le dernier est une demande explicite.

| Énoncé | Portée |
|---|---|
| « L'ontologie est un ensemble de concepts et leurs relations » | Définit `ONT` par son contenu, non par son emploi |
| « L'usage d'aucune ressource n'est obligatoire. Ils sont utilisables au besoin » | Confirme `ADR-017` D4, et l'étend aux trente-et-un types |
| Un `CPT` sert aux concepts réutilisés à plusieurs endroits ; sinon il vit dans un fichier `ONT` | Le concept a **deux formes**, selon son usage attendu |
| « nous avons besoin de pouvoir définir une ressource dans un document ressource » | Ouvre un chantier technique, avec un `ISU` demandé |

### C3 - Le concept n'est plus départagé par la forme, mais par l'usage

`RES-007` distingue le concept de l'entrée d'ontologie par la **forme** : une entrée de lexique contre un document d'une à trois pages.

La réponse Q1 déplace le critère sur l'**usage attendu** : un concept réutilisé à plusieurs endroits mérite un fichier, les autres vivent dans l'ontologie.

**Ce que le déplacement règle.** Le problème d'amorçage que Q6 pose sans recevoir de réponse. `RES-007` exige qu'un concept soit déjà employé dans deux ressources, ce qu'un concept nouveau ne peut pas être. Le critère d'usage **attendu** est prospectif : il se juge à l'écriture.

**Ce qu'il ne règle pas.** Le seuil reste subjectif. Rien ne dit ce qui distingue un concept qu'on prévoit de réutiliser d'un concept qu'on espère réutiliser.

**Interprétation.** Le déplacement rend le seuil d'admission de `RES-007` caduc dans sa première condition, sans que la réponse le dise. Q6 reste formellement ouverte, et la réponse Q1 y répond de fait.

### C4 - Le besoin technique, et son précédent

« nous avons besoin de pouvoir définir une ressource dans un document ressource ».

Le dépôt possède un précédent qui fonctionne et une limite qui l'empêche de servir.

| Mécanisme | Ce qu'il fait | Sa limite |
|---|---|---|
| Recueil de faits, `RES-005` | Chaque fait numéroté `F<NN>`, adressé `FCT-001#F03`. Dix faits en usage dans `FCT-001` | Un fait n'a ni frontmatter, ni type déclaré, ni cycle de vie. C'est une entrée, pas une ressource |
| Atome de composite, `ADR-004` D3 | Chaque atome est une ressource de plein droit, dans son fichier | L'atome **reste un fichier**, ce dont le besoin veut se passer |

**Trois obstacles**, détaillés dans `ISU-001` : l'adresse, la validation par un schéma qui suppose un frontmatter unique, et la promotion d'une ressource imbriquée vers un fichier propre sans casser les renvois.

**Ce qui rend l'obstacle réel et non théorique.** L'outillage couple l'identité au fichier en trois endroits : `clia res ls` compte des fichiers, `clia res show` résout vers un chemin, `clia res new` crée un fichier.

### C5 - L'usage facultatif est confirmé et étendu

« L'usage d'aucune ressource n'est obligatoire. Ils sont utilisables au besoin. »

`ADR-017` D4 le posait pour `CTX`, `INT` et `FCT`, avec une exception : l'intention ultime. La réponse Q1 l'étend aux trente-et-un types sans reprendre l'exception.

**Interprétation.** L'exception subsiste. `ADR-017` D4 est une décision instruite, et la réponse Q1 énonce un principe général sans viser cette décision. Le silence n'abroge pas.

**Ce que cela confirme sur `NON-002`.** La contestation sur la prolifération des types était déjà close par `ADR-016` D5 : le nombre de types suit le nombre de natures de contenu. Un type non employé ne coûte que sa définition.

### C6 - Ce que six questions sans réponse laissent en place

| Question | Ce qui reste en l'état | Coût mesuré |
|---|---|---|
| Q2 | Le vocabulaire de relations vit dans `RES-001`, source parallèle assumée | 9 relations, citées par 31 définitions |
| Q3 | Aucune forme légère de savoir | 11 dépôts de technotes morts, 6 sans aucun fichier versionné |
| Q4 | 7 concepts orphelins, dont 3 dont le système dépend | `extreme-smart`, `distillation`, `objection sociocratique` |
| Q5 | La frontière fondation contre analyse reste indicative | 4 fondations du corpus reclassables |
| Q6 | Le seuil d'admission des concepts garde sa condition d'amorçage | 0 instance `CPT` |
| Q7 | `INTENTION.md` affirme une propriété que `ANL-001` conteste | 1 affirmation |

**Q2 est la plus gênante.** L'objection la qualifie de contradiction interne : les définitions emploient des relations que rien ne définit, et le vocabulaire provisoire vit dans `RES-001`, ce qui est exactement le défaut de source parallèle que le modèle prétend éviter.

**Q3 est celle qui a le coût mesuré le plus élevé.** Six dépôts de technotes sans aucun fichier versionné, parce que le seul contenant disponible demandait dix pages pour deux commandes.

**Q7 appartient à l'humain seul.** `INTENTION.md` est en édition humaine exclusive, et la question porte sur une affirmation que le corpus ne soutient pas.

### C7 - Trois concepts orphelins sont désormais employés par le dépôt

Q4 est sans réponse, et l'état a changé depuis l'ouverture de l'objection.

| Concept orphelin | Emploi dans le dépôt au 2026-08-11 |
|---|---|
| `extreme-smart` | **Employé**, `PDC-003` en fait un régime nommé |
| `objection sociocratique` | Employé, le dispositif d'objection repose dessus |
| `distillation` | Non employé |

`RES-007` exige qu'un concept soit employé dans au moins deux ressources. `extreme-smart` satisfait désormais cette condition : douze documents actifs l'emploient, dont `PDC-003` qui en fait un régime nommé et `NON-027` qui en conteste le type.

**Interprétation.** Le premier `CPT` du dépôt a maintenant sa matière, sans qu'aucune réponse ne l'ait décidé.

## Réponse à la question posée

### Les implications de ce qui est répondu

| Réf | Implication | Ce qu'elle demande |
|---|---|---|
| I1 | Le concept a deux formes, fichier ou entrée d'ontologie | Réécrire la frontière de `RES-007` et de `RES-006` |
| I2 | Le critère est l'usage attendu, non la forme | Retirer la condition d'amorçage du seuil de `RES-007` |
| I3 | Une ressource doit pouvoir être définie dans une autre | Un mécanisme d'adresse, de validation et de promotion |
| I4 | L'usage d'aucun type n'est obligatoire | Rien : déjà acquis par `ADR-016` D5 et `ADR-017` D4 |

### Les conséquences de ce qui ne l'est pas

**`NON-004` reste ouverte.** Ses deux questions décisives sont vides. L'objection ne peut pas être levée, et son effet `conditionnel` demeure.

**Une contradiction interne subsiste**, celle que Q2 nomme : neuf relations employées par trente-et-une définitions, définies dans `RES-001` par défaut, alors qu'elles relèvent de l'ontologie.

**Le manque le plus mesuré du corpus n'est pas traité.** Q3 porte sur la forme légère de savoir, et son absence a tué onze dépôts.

### L'ajustement minimal

Trois changements, dont deux dérivent directement de la réponse Q1.

**A1. Réécrire la frontière concept contre ontologie** dans `RES-006` et `RES-007`, sur le critère de l'usage attendu.

**A2. Retirer la condition d'amorçage** du seuil d'admission de `RES-007`.

**A3. Ouvrir l'issue technique.** Fait : `ISU-001`.

Ces trois changements portent sur deux définitions et une issue. Ils ne demandent aucun outil.

### Ce que l'ajustement minimal ne règle pas

Les six questions vides. Aucune ne peut être traitée par l'agent : Q7 appartient à l'humain par le régime d'édition de `INTENTION.md`, et Q2 à Q6 demandent des arbitrages de conception.

## Limites

**Six questions sur sept sont sans réponse.** L'analyse porte donc sur un septième de la matière attendue, et la tâche demandait d'interpréter « les réponses ».

**Une interprétation comble un silence.** C5 pose que l'exception de `ADR-017` D4 subsiste malgré l'énoncé général de Q1. Le silence n'abroge pas, mais rien ne le confirme.

**C7 est un constat d'opportunité.** Que `extreme-smart` satisfasse désormais le seuil d'admission est un effet de bord des tâches 23 et 24, non une réponse à Q4.

**Aucune mesure du coût.** Le mécanisme de ressource imbriquée n'est pas chiffré : `ISU-001` liste quatre pistes sans en évaluer aucune.

**La date compte.** Une réponse ajoutée à `NON-004` après le 2026-08-11 périme cette analyse.

## Relations

- `derive-de` [ANL-001](ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
- `reference` [RES-006](../ressources/RES-006-ontologie.md)
- `reference` [RES-007](../ressources/RES-007-concept.md)
- `reference` [RES-005](../ressources/RES-005-fait.md)
