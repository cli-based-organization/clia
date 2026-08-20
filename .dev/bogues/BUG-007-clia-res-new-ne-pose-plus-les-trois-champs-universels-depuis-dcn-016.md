---
type: bogue
id: BUG-007
title: "clia res new ne pose plus les trois champs universels depuis DCN-016"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouvert"
regle: "Une ressource nouvellement créée est conforme à son schéma"
constate-le: 2026-08-13
etat: ouvert
---

# BUG-007 - clia res new ne pose plus les trois champs universels depuis DCN-016

> `DCN-016` rend `maturity`, `adoption` et `activated` obligatoires pour toute ressource depuis le 2026-08-13, 16:22. Aucune fonction de création ne les pose. Trouvé en préparant `PLN-017`, tâche 16.

## Journal

- 2026-08-13 : trouvé par l'agent en préparant le chantier C de `PLN-017`, tâche 16 de `SES-002`. Non corrigé dans cette tâche — hors de son périmètre, `MET-005` étape 6.

## L'écart

**Le comportement attendu.** Une ressource nouvellement créée satisfait le schéma commun que le dépôt applique à toute instance.

**Le comportement constaté**, mesuré en créant une instance d'essai :

```
maturity: incomplete value "conception" | "mature" | "fin-de-vie" | "obsolete"
adoption: incomplete value "propose" | "adopte" | "conteste" | "obsolete"
activated: incomplete value bool
```

**Trois instances du dépôt en portent la marque** : `DCN-019`, `DCN-020`, `ISU-013`, créées par l'humain après 16:29 — l'heure où le chantier D de `PLN-007` a posé les trois champs sur les 183 instances alors existantes, sans toucher au code qui en crée de nouvelles.

**Un second symptôme de la même cause, trouvé au même moment** : la dernière section déclarée par une définition disparaît de l'instance créée, faute d'une garde sur le dernier `read` d'une boucle qui lit un flux sans saut de ligne final. Même famille de piège que celui corrigé sur `clia res explain` à la tâche 14.

## La règle enfreinte

**Une ressource nouvellement créée est conforme à son schéma.**

Elle n'était écrite nulle part, et elle découle de `DCN-016` : un champ universel obligatoire l'est pour toute instance, y compris celles qui n'existaient pas encore quand la décision est entrée en vigueur.

## Comment le reproduire

1. `clia res new objection "essai"`.
2. Lire le frontmatter produit.
3. Constater l'absence de `maturity`, `adoption`, `activated`.

**Reproduit à l'instant**, sur une instance jetable, supprimée après la mesure.

## La cause

`clia_resource_new`, dans `lib/clia/resource.sh`, pose les champs listés par `champs-obligatoires` de la définition du type. **Aucune définition ne liste les trois champs universels** : ils sont portés par `commun.cue`, pas par les 37 `RES`, et `champs-obligatoires` n'a jamais été mis à jour pour les inclure — `DCN-016` les a rendus obligatoires au niveau du schéma commun, pas au niveau de chaque type.

**Le chantier D de `PLN-007`, exécuté au même moment, a posé les champs sur les instances existantes par un script séparé**, hors du chemin normal de création. Ce script a corrigé le passé sans corriger l'avenir.

## La correction

**Non appliquée.** Le travail en cours à sa découverte, `PLN-017`, ne touche pas `resource.sh` : le corriger ici mélangerait deux livrables sous une seule directive, contre `MET-005` étape 6.

Ce qu'elle demande :

| Geste | Où |
|---|---|
| Poser `maturity: conception`, `adoption: propose`, `activated: true` inconditionnellement, hors de la boucle sur `champs-obligatoires` | `clia_resource_new` |
| Garder la garde `\|\| [[ -n "$sec" ]]` sur toute boucle qui lit un flux de sections ou de champs sans saut de ligne final | `clia_resource_new`, et tout code qui reprendrait ce motif |
| Corriger `DCN-019`, `DCN-020`, `ISU-013` | Trois instances, mécaniquement |

## Relations

- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [ADR-018](../adr/ADR-018-la-documentation-d-un-type-est-fournie-par-le-cli.md)
