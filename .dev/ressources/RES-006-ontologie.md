---
type: ressource
id: RES-006
title: "Ontologie"
version: 0.1.0
status: draft
prefixe: ONT
emplacement: ".dev/ontologies/ONT-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: fondamentale
champs-obligatoires: [type, id, title, version, status, domaine]
relations-admissibles: [ontologie, concept, ressource]
sections: [Termes retenus, Termes écartés, Relations admissibles, Zones non couvertes, Relations]
skill: skl-002-ressource-fondamentale
adr: aucun
statut: actif
---

# RES-006 - Ontologie

> Une ontologie fixe le vocabulaire d'un domaine : les termes retenus, les termes écartés, et les relations admissibles entre les choses nommées. Elle dit quel mot pour quelle chose, et quels liens existent entre les choses.

## Objet

Ce document définit le type `ontologie`. Sa fonction est de rendre le vocabulaire opposable : quand un mot est fixé par une ontologie, employer un synonyme écarté devient un défaut signalable, et non une variation de style.

## Statut de ce document

Premier jet, sur un concept **amorcé** au sens de `ANL-001` : une instance dans le corpus (`ONT-001-ontologie-du-patrimoine` de `micrologic-clients`), une définition, un skill. Deux travaux antérieurs apportent la théorie : `disruptiva-dev/nty`, qui faisait de l'ontologie un objet de première classe manipulable par CLI, avec des notions de `phore`, d'assignation ontologique et de validateurs ; et `disruptiva-dev/comm-cli`, qui classait ses neuf ressources selon cinq natures (contextuelle, stratégique, tactique, opérationnelle, stylistique).

## Le problème que ce type résout

Le besoin est démontré par une mesure, non par un principe. `ANL-001` établit une dérive lexicale non contrôlée dans le corpus.

| La même chose s'appelle | Dans |
|---|---|
| `livrable` et `ressource` | Lignée A et lignée B |
| `completed` et `complet` | Cinquante-deux logs et deux logs du même dépôt |
| `améliorations`, `issues`, `tickets`, `needs`, `features` | Cinq dépôts pour un même objet |
| `session.md`, `.dev/session.md`, `workspace/session.md` | Trois emplacements pour le point d'entrée |
| `OBJ` et `NON` | Deux préfixes pour l'objection |

Aucun de ces écarts n'a été détecté au moment où il s'est produit. Ils ont été trouvés en comparant cent soixante-six dépôts, ce qu'aucun humain ne fait dans le cours du travail.

## Ce qu'est une ontologie

Une ontologie est une ressource vivante qui porte trois choses, dont la troisième est la moins évidente et la plus utile.

| Elle porte | Rôle |
|---|---|
| **Les termes retenus** | Un mot, sa définition en une phrase, et un exemple d'emploi correct |
| **Les termes écartés** | Les synonymes rejetés, avec la raison du rejet et le terme à employer à la place |
| **Les relations admissibles** | Les liens qui peuvent exister entre les choses nommées, et leur cardinalité |

Les termes écartés sont l'apport principal. Une ontologie qui n'énumère que ce qu'elle retient laisse le lecteur inventer des synonymes en toute bonne foi. Une ontologie qui déclare que `livrable` est écarté au profit de `ressource` rend l'écart détectable.

## Les deux emplois, et pourquoi ils sont un seul type

Le corpus emploie le mot ontologie de deux manières apparemment distinctes : fixer un lexique, et typer des relations. Ce jet les traite comme un seul type, parce que ce sont les deux faces d'une même opération : nommer les choses, et nommer les liens entre les choses. Séparer les deux produirait deux documents qui devraient se citer à chaque entrée.

## Articulation avec le modèle de ressources

C'est le point d'ingénierie de ce type, et il rend le modèle cohérent.

Chaque définition de type déclare un champ `relations-admissibles`. Ce champ n'est valide que si les relations qu'il nomme sont déclarées par une ontologie. Autrement dit : `RES` déclare quels liens un type peut porter, `ONT` déclare quels liens existent.

Il suit que l'**ontologie du système lui-même** est nécessaire, et qu'elle n'existe pas. C'est la lacune la plus immédiate de ce jet : les sept définitions produites le 2026-08-09 déclarent des relations (`derive-de`, `remplace`, `reference`, `objecte-a`, `repond-a`, `specifie`) que rien ne définit. Le vocabulaire provisoire est écrit dans `RES-001`, ce qui en fait une source parallèle, exactement le défaut que le modèle prétend éviter.

## Portées

| Portée | Ce qu'elle couvre | Instance attendue |
|---|---|---|
| Système | Le vocabulaire de `clia` lui-même : ressource, type, cycle de vie, relation, objection | `ONT-001`, à produire |
| Domaine | Le vocabulaire d'un métier : patrimoine, communication, cryptographie post-quantique | Une par domaine, dans le dépôt concerné |

Une ontologie de domaine peut déclarer `derive-de` vers l'ontologie du système, dont elle hérite les relations.

## Frontière avec le concept

C'est la frontière la plus disputée du modèle, et `NON-004` la porte dans son ensemble. La proposition de ce jet est la suivante.

| Type | Ce qu'il fait | Forme | Longueur typique |
|---|---|---|---|
| `ONT` | Fixe le mot **dans un système de mots** : ce terme, pas cet autre, en relation avec ceux-là | Une entrée dans un tableau | Trois à six lignes |
| `CPT` | Élabore **l'idée** : d'où elle vient, ce qu'elle explique, ce qu'elle exclut, à quoi elle sert | Un document | Une à trois pages |

Test pratique : si ce qu'on veut écrire tient dans une entrée de lexique, c'est de l'ontologie. Si l'écrire demande de raconter d'où vient l'idée et ce qu'elle permet de voir, c'est un concept.

Corollaire, qui limite la prolifération : tout concept a une entrée d'ontologie, mais toute entrée d'ontologie n'a pas de concept.

## Régime d'édition

`co-edition`, et c'est un écart assumé par rapport à `micrologic-clients`, qui déclare `ia`.

La raison est pratique. Un lexique produit par l'agent seul ne sera pas tenu par l'humain, qui n'y a pas consenti. Un lexique produit par l'humain seul ne bénéficiera pas de ce que l'agent détecte, et le corpus montre que les collisions lexicales sont précisément ce que l'humain ne voit pas et que la comparaison mécanique révèle.

Le vocabulaire est un accord. Il se co-édite.

## Validation

`nty` avait une ontologie exécutable, avec validateurs. C'est la seule occurrence du corpus où le vocabulaire était vérifié mécaniquement, et elle a été abandonnée en douze jours sans trace de décision.

Ce jet ne réintroduit pas la validation, faute d'outil. Il note que l'ontologie est le type dont la validation serait la moins coûteuse et la plus rentable : détecter l'emploi d'un terme écarté est une recherche textuelle. Voir `NON-005`.

## Structure attendue d'une instance

```
# ONT-<SEQ> - <Domaine>

> Le domaine dont ce document fixe le vocabulaire.

## Termes retenus
| Terme | Définition en une phrase | Exemple d'emploi |
## Termes écartés
| Terme écarté | Employer à la place | Raison du rejet |
## Relations admissibles
| Relation | Source | Cible | Cardinalité |
## Zones non couvertes
## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `specifie` [RES-007](RES-007-concept.md)

## Points ouverts

| Question | Objection |
|---|---|
| Frontière avec Concept, Fondation et Analyse | `NON-004` |
| Le vocabulaire de relations vit provisoirement dans `RES-001` : source parallèle à résorber | `NON-004` |
| Faut-il rendre l'ontologie validable mécaniquement, et à quel coût | `NON-005` |
| Une ontologie de système partagée entre dépôts, ou une par dépôt | `NON-006` |
