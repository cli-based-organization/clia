---
type: objection
id: NON-012
title: "Granularité de la ressource et décompte des instances"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-001, ADR-001, ADR-003]
---

# NON-012 - Granularité de la ressource et décompte des instances

> `RES-001` pose qu'une ressource est un fichier. Or ce dépôt contient une ressource faite de neuf fichiers, `ANL-001`, et `clia res ls` la compte donc neuf fois. Le modèle ne connaît pas le bundle, et l'implémentation le rend visible.

## Journal

- 2026-08-09 : ouverte par l'agent, à l'implémentation de `clia res ls`, qui a rendu l'écart mesurable.
- 2026-08-10 : trois questions ajoutées, Q8 à Q10, à partir de `FND-002`, qui fournit le cadre théorique manquant.

## Ce qui est contesté

`RES-001` définit une ressource comme un fichier markdown portant un frontmatter YAML typé. Cette définition est simple et elle est fausse pour une instance existante de ce dépôt.

`ANL-001-observation-corpus-repos-et-pratiques` est un **répertoire** de neuf fichiers, dont un `index.md` et quatre fichiers sous `repos/`. Huit de ces fichiers portent `type: analyse` dans leur frontmatter. L'emplacement en répertoire n'a pas été choisi par l'agent : la tâche 1 de la session du 2026-08-09 l'imposait en demandant de consigner les observations dans `@.dev/analyses/ANL-001-<SLUG>/*`.

La conséquence est mesurable depuis l'implémentation du CLI.

```
$ clia res ls
analyse    ?    ?    ?    aucune    9
```

Neuf instances comptées, deux ressources réelles : `ANL-001` et `ANL-002`. L'écart est de sept.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Le décompte est faux, et il ne peut pas être corrigé sans décider.** `clia` compte des fichiers parce que le modèle dit qu'une ressource est un fichier. Pour compter des ressources, il lui faudrait savoir reconnaître un bundle, donc une règle.

**Le bundle est un format éprouvé, pas un accident.** Le dépôt `micrologic-clients` l'emploie et son `ADR-001-compatibilite-okf` le formalise sous le nom de bundle avec un `index.md` en racine. `RES-001` de ce dépôt a repris l'essentiel de ce travail sans reprendre cette notion.

**Le format s'imposera de nouveau.** Une analyse de cent soixante-six dépôts ne tient pas dans un fichier lisible. Le besoin qui a produit le bundle à la tâche 1 se reproduira, et sans règle chaque occurrence sera un cas particulier.

## Questions

### Q1 - Une ressource peut-elle être un répertoire ?

Trois positions. Une ressource est un fichier, et `ANL-001` est neuf ressources, ce qui est absurde au regard de son contenu. Une ressource est un fichier ou un bundle, et il faut dire ce qui distingue les deux. Ou un bundle est une ressource unique dont les fichiers internes ne sont pas des ressources, ce qui suppose de retirer leur frontmatter typé aux huit fichiers de `ANL-001`.

**Réponse.**

### Q2 - Si le bundle existe, qu'est-ce qui le reconnaît ?

Candidats : la présence d'un `index.md`, comme dans le format adopté par `micrologic-clients` ; un champ de frontmatter déclarant le rôle du fichier dans le bundle ; ou une convention de nommage du répertoire. Le premier est le moins coûteux et le plus proche de l'état de l'art.

**Réponse.**

### Q3 - Les fichiers internes d'un bundle portent-ils un frontmatter typé ?

Aujourd'hui ils en portent un, identique à celui de l'`index.md`, ce qui les rend indistinguables de ressources autonomes. Si le bundle est une ressource unique, ses parties devraient soit ne rien porter, soit porter un type distinct, soit déclarer leur appartenance.

**Réponse.**

### Q4 - Que doit compter `clia res ls` ?

Trois réponses possibles, et elles ne s'excluent pas. Le nombre de ressources, qui est la mesure utile. Le nombre de fichiers, qui est la mesure disponible. Ou les deux, en deux colonnes.

La question dépasse le décompte : elle détermine ce que `clia res show ANL-001` doit afficher, un fichier ou un bundle entier.

**Réponse.**

### Q5 - Un bundle est-il compatible avec le cycle de vie point-fixe ?

`RES-001` classe l'analyse comme `point-fixe`, donc immuable et datée. Un bundle de neuf fichiers dont plusieurs ont été révisés après leur production ne l'est pas. Le cas de `ANL-001` est documenté : ses compteurs ont été corrigés après validation, à la tâche 1.

Cette question recoupe `NON-011` Q2 sur le nommage et `NON-005` Q2 sur l'immuabilité. Les trois pointent le même endroit : le cycle `point-fixe` ne décrit aucun des documents auxquels il est appliqué.

**Réponse.**

### Q6 - Le décompte doit-il exclure autre chose que les archives ?

L'implémentation exclut `.dev/archives/` par défaut, via `CLIA_EXCLUDE_DIRS`, parce que quatorze ADR archivés étaient comptés parmi les trois ADR actifs. La question reste ouverte pour les gabarits, le matériel source, et les fichiers de journal, dont `ADR-001` D8 dit qu'ils ne sont pas des ressources sans que rien ne le vérifie.

**Réponse.**

### Q7 - Le décompte doit-il servir à quelque chose de plus qu'informer ?

Un décompte de type est aussi le moyen de détecter un type employé une seule fois, donc candidat à la suppression, et un type dont le nombre d'instances dépasse ce que la définition prévoyait. `NON-011` Q4 propose qu'une définition devienne exigible à la deuxième instance : cette règle a besoin d'un décompte juste pour être appliquée.

**Réponse.**

### Q8 - Le modèle FRBR est-il le bon cadre pour trancher Q1 ?

Ajoutée le 2026-08-10. `FND-002` établit que le modèle FRBR de l'IFLA, qui distingue oeuvre, expression, manifestation et exemplaire, est le meilleur outil disponible pour décider ce qu'un identifiant identifie, et qu'il date de 1998 tout en restant peu appliqué par les systèmes techniques.

Appliqué à `ANL-001` : le bundle est une **oeuvre**, l'`index.md` en est l'entrée, et les huit fichiers internes sont des parties de cette oeuvre et non des oeuvres distinctes. C'est la lecture que la suggestion S9 de `ANL-003` retient.

**Réponse.**

### Q9 - Les fichiers internes d'un bundle doivent-ils perdre leur frontmatter typé ?

Ajoutée le 2026-08-10, et elle précise Q3 en la rendant décidable. Si Q8 est tranchée par FRBR, la conséquence est mécanique : huit fichiers de `ANL-001` cessent de porter `type: analyse`. Le décompte devient juste sans que `clia` ait besoin de reconnaître un bundle.

Le coût est de huit modifications, et il rend l'index du bundle seul responsable de son identité.

**Réponse.**

### Q10 - Une citation peut-elle viser une partie d'un bundle ?

Ajoutée le 2026-08-10. `FND-002` relève que le champ de la citation des données emploie la notion de citation profonde pour désigner la référence à un sous-ensemble, et que la granularité doit être déterminée par le cas d'usage.

Les documents de cette session citent déjà des parties de `ANL-001`, sous la forme `ANL-001, D4` ou `ANL-001, observations-pratiques.md`. Cette pratique existe donc sans convention. Faut-il la formaliser, par exemple sur le modèle des qualificateurs du SWHID, où un chemin s'ajoute au noyau ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2. Elles suffisent à rendre le décompte juste et à fixer ce que `clia res show` doit afficher.

L'effet est `conditionnel` : `clia res ls` reste utilisable, son décompte est faux pour les types dont une instance est un bundle, et il ne l'est aujourd'hui que pour un seul type, `analyse`.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `objecte-a` [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md)
- `reference` [NON-011](NON-011-types-employes-sans-definition.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
- `derive-de` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `derive-de` [ANL-003](../analyses/ANL-003-systeme-d-identifiants-de-clia.md)
