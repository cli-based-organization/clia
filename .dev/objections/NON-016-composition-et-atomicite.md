---
type: objection
id: NON-016
title: "Composition, atomicité et propriété holographique"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-001, ADR-004]
---

# NON-016 - Composition, atomicité et propriété holographique

> `ADR-004` acte que la ressource est composable et que chaque composant est un atome auto-cohérent. Trois points de cette décision sont indéterminés, et le mot « holographique » du titre de la tâche 9 n'est pas défini par son corps.

## Journal

- 2026-08-10 : ouverte par l'agent, aux tâches 8 et 9 de la session du 2026-08-09.

## Ce qui est contesté

Quatre choses.

**Le mot « holographique ».** Le titre de la tâche 9 le nomme, son corps ne le définit pas. `ADR-004` D4 retient la lecture faible : chaque atome est auto-cohérent, donc lisible seul. Une lecture forte serait possible, où chaque atome porterait l'information du tout, à la manière d'un hologramme optique. Elle imposerait une redondance dont l'intérêt n'est pas établi.

**La granularité minimale.** Rien ne dit à partir de quand un découpage en atomes cesse d'être utile. Un composite de deux cents atomes d'une ligne satisfait la définition et n'a aucun sens.

**Le décompte.** `ADR-004` D6 pose que l'on compte les ressources et non les fichiers. `clia res ls` compte encore des fichiers, donc son décompte est faux d'une manière désormais connue.

**Les ressources sans frontmatter.** `ADR-004` D1 rend le code modélisable, et `RES-026` le définit. Un objet sans frontmatter échappe à toute la validation de schéma mise en place le 2026-08-10.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Une propriété nommée et non définie sera interprétée différemment à chaque usage.** C'est le mode de défaillance que `ANL-001` mesure sur le vocabulaire, avec jusqu'à cinq mots pour un même objet.

**Le décompte faux a une conséquence pratique.** `NON-011` Q4 propose qu'une définition de type devienne exigible à la deuxième instance. Cette règle a besoin d'un décompte juste.

**La validation ne couvre pas ce qu'elle prétend couvrir.** Soixante-huit ressources sur soixante-neuf valident leur schéma. Le code, lui, n'a pas de schéma et n'en aura pas : sa validation est ailleurs, dans ses tests. Le modèle a donc deux régimes de validation et ne le dit pas.

## Questions

### Q1 - La propriété holographique est-elle la lecture faible ou la lecture forte ?

Faible : chaque atome est auto-cohérent. Forte : chaque atome porte l'information du tout. `ADR-004` D4 retient la faible et le signale.

**Réponse.**

### Q2 - Quelle est la granularité minimale utile d'un atome ?

Candidats : une taille minimale, un critère de sens (un atome porte une idée complète), ou aucun critère et le jugement au cas par cas.

**Réponse.**

### Q3 - Comment un composite est-il reconnu mécaniquement ?

`ADR-004` D5 retient la convention d'un fichier d'entrée nommé `index`. Est-ce suffisant, ou faut-il un champ de frontmatter déclarant le rôle ?

**Réponse.**

### Q4 - Que devient un atome dont le composite est supprimé ?

Il est auto-cohérent, donc il survit comme ressource autonome. Sa relation `fait-partie-de` devient pendante, ce qui est un défaut au sens de `RES-001`.

**Réponse.**

### Q5 - Une ressource sans frontmatter est-elle validable par le modèle ?

Le code est une ressource depuis `ADR-004` D1 et n'a pas de frontmatter. `RES-026` propose trois substituts : le commentaire d'en-tête, les tests, le nom de fichier. Faut-il l'écrire comme régime de validation distinct ?

**Réponse.**

### Q6 - L'index des définitions est-il une ressource ou une vue ?

`.dev/ressources/index.md` porte `type: ressource` par commodité et n'est pas une définition de type. Il a fallu lui ajouter les champs du type pour qu'il valide, ce qui est un contournement.

**Réponse.**

### Q7 - Quand `clia res ls` comptera-t-il des ressources ?

Le décompte est faux depuis `ADR-004` D6, et la correction relève de l'outillage. Faut-il l'afficher comme provisoire d'ici là ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2. La première fixe le sens d'un mot qui figure dans le titre d'une décision actée, la seconde borne une propriété sans laquelle la composition peut proliférer.

## Relations

- `objecte-a` [ADR-004](../adr/ADR-004-nature-composable-de-la-ressource.md)
- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [NON-012](NON-012-granularite-de-la-ressource.md)
- `reference` [RES-026](../ressources/RES-026-code.md)
