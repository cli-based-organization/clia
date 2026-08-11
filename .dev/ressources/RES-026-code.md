---
type: ressource
id: RES-026
title: "Code"
version: 0.1.0
status: draft
prefixe: CDE
emplacement: "lib/, bin/, tests/"
cycle-de-vie: vivant
edition: ia
famille: implementation
champs-obligatoires: ["aucun, le code ne porte pas de frontmatter"]
relations-admissibles: [code, specification, requis, comportement, bug]
sections: ["aucune, la structure du code suit son langage"]
skill: skl-007-ressource-d-implementation
adr: ADR-005
statut: actif
---

# RES-026 - Code

> Le code est la seule ressource de ce dépôt qui ne porte pas de frontmatter et qui ne se lit pas comme un document. Il est une ressource parce qu'il est identifiable, auto-cohérent et typé, au sens que `ADR-004` D1 donne à ces mots.

## Objet

Définit le type `code`. Sa fonction est de rattacher au modèle de ressources un objet qui échappe à toutes les conventions de forme des autres types.

## Statut de ce document

Premier jet du 2026-08-10. Le type est instancié depuis la tâche 6 : `bin/clia`, trois modules sous `lib/clia/`, et `tests/test_clia.sh`, soit 1 596 lignes de bash.

## Ce qui rend ce type possible

`ADR-004` D1 pose qu'une ressource est définie par ses propriétés et non par son support. Avant cette décision, le code ne pouvait pas être une ressource : `ADR-001` D2 définissait la ressource comme un fichier markdown à frontmatter.

C'est le premier bénéfice concret de la décision de la tâche 9.

## Ce que le code porte au lieu d'un frontmatter

Trois substituts, qui remplissent les mêmes fonctions.

Le **commentaire d'en-tête** de chaque fichier remplace le frontmatter : il dit ce que le fichier fait et quelles décisions il applique. Les trois modules de `clia` renvoient nommément aux décisions de `ADR-003` qu'ils mettent en oeuvre.

Les **tests** remplacent les contrôles de validation. Ils sont exécutables, ce qu'aucun contrôle de ressource documentaire n'est encore.

Le **nom du fichier** remplace l'identité par slug, avec la convention du langage.

## Ce qu'un code n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **spécification** | La spécification dit quoi sans technologie. Le code est la technologie |
| Un **comportement attendu** | Le comportement est l'exigence, le test est sa vérification, le code est ce qui est vérifié |

## Régime propre : la validation est exécutable

C'est la seule famille où la validation ne dépend pas d'un contrôle textuel. Les soixante-six assertions de `tests/test_clia.sh` valident le code, et elles ont trouvé trois bogues que la relecture n'avait pas vus.

`ANL-001` mesure au défaut D2 que rien ne valide dans ce système. Le code est la seule exception.

## Cycle de vie et édition

`vivant`, versionné par le versionnage de l'outil et non par un semver de frontmatter. `ia`.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-024](RES-024-comportement-attendu.md)
- `derive-de` [ADR-004](../adr/ADR-004-nature-composable-de-la-ressource.md)

## Points ouverts

| Question | Objection |
|---|---|
| Une ressource sans frontmatter est-elle validable par le modèle | `NON-016` |
| Le code relève-t-il du versionnage de l'outil ou du frontmatter | `NON-016` |
