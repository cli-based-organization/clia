---
type: analyse
id: ANL-010
title: "Source de vérité de l'implémentation : requis, spécifications et code dans clia"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-11
sujet: "Où placer la source de vérité des contraintes et choix techniques, quand le code est une ressource générée"
generated:
  by: claude-opus-5
  at: 2026-08-11
---

# ANL-010 - Source de vérité de l'implémentation

> La littérature suppose que celui qui spécifie et celui qui implémente sont deux parties. Dans `clia` ils sont la même, et le seul indice historique est négatif : quand le document et le code divergent, c'est le code qui gagne.

## Objet

Déterminer où placer la source de vérité pour la description de l'implémentation, des contraintes et des choix techniques dans `clia`, et quelle approche de documentation des requis et spécifications en découle.

Demandé par la tâche 31 de la session du 2026-08-09.

## Méthode

Confrontation de trois ensembles.

| Ensemble | Ce qu'il apporte |
|---|---|
| `FND-004` | Les régimes de publication et leur rapport à l'implémentation |
| `FND-015`, archivée | Les trois lectures du mot spécification, et la taxonomie des requis |
| L'état du dépôt | Ce que `clia` a décidé et ce qu'il pratique |

**Une observation n'est pas une norme.** `skl-001` A7. Ce que le dépôt pratique est rapporté comme un fait, non comme une règle.

## Constats

### C1 - Le dépôt a défini deux types et n'en a produit aucune instance

| Type | Définition | Instances |
|---|---|---|
| `SPC`, spécification | `RES-020` | **0** |
| `RQF`, requis fonctionnel | `RES-021` | **0** |
| `RQNF`, requis non fonctionnel | `RES-022` | **0** |

Trois décisions ou objections en réclament une sans qu'aucune n'existe.

| Origine | Ce qui est réclamé |
|---|---|
| `PLN-003` G1 | La `SPC` des critères de conformité d'un dépôt |
| `NON-030` Q2 | La `SPC` du générateur, avant l'outil |
| `ADR-016` D3 | `SPC` et `RQF` comme sources de dérivation d'un skill |

**Le dernier point est le plus embarrassant.** `ADR-016` D3 nomme quatre sources dont deux n'ont aucune instance : la décision est inapplicable par construction.

### C2 - Le dépôt a tranché la lecture sans le savoir

`FND-015` établit trois lectures du mot spécification, dont deux inversent la relation d'abstraction.

`ADR-006` pose la séparation stricte entre la spécification du système et son implémentation. `RES-020` définit la spécification comme décrivant « ce qu'un composant doit faire, indépendamment de son implémentation ».

**C'est la lecture C** de `FND-015` : la spécification décrit le quoi agnostique, et le requis porte les contraintes contextuelles.

`FND-015` établit que cette lecture est **minoritaire** : la majorité des références traite le requis comme le besoin en amont, et réserve « spécification » au document ou à la description d'interface plus concrète.

**Ce que `FND-015` recommande à qui adopte la lecture C.** Nommer explicitement son requis comme un document de contraintes d'implémentation, pour éviter la confusion.

`RES-021` et `RES-022` ne le font pas : ils parlent d'exigences vérifiables, sans dire qu'ils portent les contraintes de mise en oeuvre.

### C3 - La frontière machine n'est pas fixée

`FND-015` section 4 établit que l'opposition quoi contre comment est **relative** : elle ne départage qu'une fois la frontière machine posée.

`clia` a trois frontières possibles, et aucune n'est déclarée.

| Frontière | Ce qui est la machine | Ce qui est l'environnement |
|---|---|---|
| F1 | Le CLI `clia` | Les ressources du dépôt |
| F2 | Le système `clia` entier, harnais compris | L'humain et l'agent |
| F3 | Le dépôt équipé | Les autres dépôts |

**Chaque frontière change ce qui est un requis et ce qui est une spécification.** Sous F1, « une ressource porte un frontmatter » est un requis d'environnement. Sous F2, c'est une spécification d'interface.

### C4 - Le code est déclaré ressource, et son régime est ambigu

`ADR-014` D1 fait du code une ressource, du côté de l'implémentation. `ADR-006` sépare strictement la spécification de l'implémentation.

`NON-004` Q3 ajoute qu'une ressource peut être **hybride**, source et générée, et que le rôle dépend du contexte d'usage.

**Les deux régimes coexistent dans le dépôt aujourd'hui**, et la mesure le montre.

| Module | Comment il a été produit | Régime de fait |
|---|---|---|
| `lib/clia/git.sh` | Écrit à partir de `ANL-005`, dont les contraintes T1 à T6 | **généré**, au sens large |
| `lib/clia/registre.sh` | Écrit à partir de `RES-035` | **généré** |
| `lib/clia/resource.sh` | Écrit d'abord, aucune spécification ne le décrit | **source** |

**Aucun des trois ne déclare son régime.** Le rôle est contextuel selon `NON-004` Q3, et rien ne le porte.

### C5 - Ce que le code porte et qu'aucun document ne porte

Mesure sur les quatre modules du CLI.

| Ce que le code seul décide | Exemple |
|---|---|
| Le seuil de similarité employé | `clia_git_t1_suspects` détecte par l'alias, non par le statut de renommage |
| Les codes de retour | 3 pour un refus constitutionnel, 2 pour un usage, 1 pour un échec |
| Le format des noms produits | `<PREFIX>-<SEQ>-<SLUG>.md`, aligné sur `ADR-007` D4 après un bogue |
| Les motifs de recherche des messages de commit | Deux formats acceptés, décidé à la tâche 25 |

**Trois de ces quatre décisions ont été prises en écrivant le code**, et sont documentées dans des commentaires ou des journaux, non dans une ressource.

**La quatrième a produit un bogue.** Le format des noms a divergé de `ADR-007` D4 pendant deux jours, parce qu'aucun document ne reliait la décision au générateur, et qu'un test codifiait l'ancien comportement.

### C6 - L'indice historique est négatif et net

`FND-004` QR4 : la littérature ne traite pas le cas d'un auteur unique. Le seul indice disponible est le sort de XHTML 2.0 contre HTML 5.

| Spécification | Rapport à l'implémentation | Sort |
|---|---|---|
| XHTML 2.0 | Élaborée sans implémentation | **abandonnée** |
| HTML 5 | Documente le comportement réel des navigateurs | adoptée, puis reprise par le W3C |

**Quand le document et le code divergent, c'est le code qui gagne.** Et la spécification qui a raison est celle qui le décrit.

`FND-004` ajoute le principe de l'IETF : RFC 2026 exige des implémentations interopérables pour qu'un texte avance. Le code qui tourne fait partie du critère d'acceptation.

## Réponse à la question posée

### Où placer la source de vérité

**Cela dépend de ce qui est décidé, et il faut trois emplacements, non un.**

| Ce qui est décrit | Source de vérité | Motif |
|---|---|---|
| **Ce que le système doit faire** | La `SPC`, agnostique au stack | `ADR-006` sépare, et cette description survit à une réécriture du code |
| **Les contraintes de mise en oeuvre** | Le `RQF` ou le `RQNF` | `FND-015` : ce sont des requis au sens strict, contextuels |
| **Les choix techniques faits en implémentant** | **Le code, et un `ADR`** | Un choix pris en écrivant se documente là où il a été pris |

**Ce qui départage les deux premiers du troisième.** Un choix qui survivrait à une réécriture complète appartient à la spécification. Un choix qui disparaîtrait avec le code appartient au code.

Le seuil de similarité de `git.sh` disparaîtrait ; le fait que `clia` refuse de commiter pour un agent survivrait.

### Ce que le code ne doit pas être

**Le code ne doit pas être la source de vérité de ce que le système fait**, sous peine que la spécification devienne un commentaire.

**Il l'est déjà pour trois choses**, C5 le mesure, et l'une d'elles a produit un bogue de deux jours.

### La frontière machine, à fixer

`FND-015` le recommande, et `clia` ne l'a pas fait. La proposition retenue est **F2** : la machine est le système `clia` entier, harnais compris ; l'environnement est l'humain et l'agent.

**Trois raisons.** C'est la frontière que `ADR-006` suppose implicitement en séparant le système de son implémentation. C'est celle qui rend les harnais spécifiables, alors que F1 les met hors de portée. Et c'est celle qui correspond à la décision à éclairer : les contraintes techniques sont internes à la machine.

**Ce qu'elle implique.** « Une ressource porte un frontmatter » devient une **spécification d'interface** entre le système et ses agents, non un requis d'environnement.

### La lecture à déclarer

`clia` pratique la lecture C sans l'avoir déclarée. `FND-015` établit qu'elle est minoritaire et qu'elle demande une précaution : nommer explicitement le requis comme document de contraintes d'implémentation.

**Trois ajustements suivent.**

| Réf | Ajustement | Cible |
|---|---|---|
| A1 | Déclarer la lecture retenue et la frontière machine | `RES-020` |
| A2 | Nommer `RQF` et `RQNF` comme documents de contraintes de mise en oeuvre | `RES-021`, `RES-022` |
| A3 | Déclarer, pour chaque module de code, s'il est source ou généré et de quoi | `RES-026` |

### Ce que la co-évolution impose

`FND-004` établit que le régime le plus efficace n'est pas celui où la spécification précède le code, mais celui où les deux co-évoluent, la maturité de la spécification se mesurant au code existant.

**Ce que cela donne pour `clia`.**

| Geste | Ce qu'il produit |
|---|---|
| Écrire une `SPC` avant un module neuf | Le cas de `git.sh`, écrit à partir de `ANL-005` |
| Écrire une `SPC` **descriptive** d'un module existant | Le cas de `resource.sh`, qui n'en a aucune |
| Vérifier que le code satisfait la `SPC` | N'existe pas |

**Le troisième geste est ce qui manque.** Sans lui, la divergence n'est pas détectable, et c'est exactement ce qui a produit le bogue de nommage.

### L'ordre recommandé

**Écrire d'abord la `SPC` descriptive de ce qui existe**, non la `SPC` prescriptive de ce qui manque.

`resource.sh` porte quatre décisions techniques non documentées et a produit deux bogues en trois jours. Le décrire coûte une lecture ; le spécifier avant de le réécrire coûterait une réécriture.

C'est aussi ce que l'histoire suggère : HTML 5 a gagné en décrivant.

## Limites

**QR4 de `FND-004` n'a pas de réponse dans la littérature.** Le cas d'un auteur unique qui spécifie et implémente n'est traité nulle part. La réponse donnée ici est construite sur un indice tiré d'un cas, non sur un résultat établi.

**La frontière machine F2 est une proposition de l'agent.** Trois frontières sont possibles, aucune n'est déclarée dans le dépôt, et le choix appartient à l'humain.

**Les trois emplacements de la source de vérité ne sont pas éprouvés.** Aucune `SPC` n'existe : la répartition proposée n'a jamais été appliquée.

**Le critère de départage est approximatif.** « Ce qui survivrait à une réécriture » est un test de pensée, non un contrôle. Deux personnes peuvent en juger différemment.

**Cette analyse est écrite à la main.** `NON-004` Q5 pose que l'analyse est une ressource générée à partir de fondations et d'une question. Aucun générateur n'existe.

## Relations

- `derive-de` [FND-004](../fondations/FND-004-publication-des-specifications.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
- `reference` [RES-026](../ressources/RES-026-code.md)
- `reference` [ANL-009](ANL-009-etat-des-lieux-de-la-notion-de-ressource.md)
