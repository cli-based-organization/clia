---
type: plan
id: PLN-008
title: "Chaîne de session par lien symbolique"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "execute"
statut-plan: execute
date: 2026-08-12
initiateur: agent
sert: [FNC-002]  # a livré la chaîne de session et clia ses switch
porte-sur: [RES-032, RES-034, lib/clia/session.sh]
---

# PLN-008 - Chaîne de session par lien symbolique

> Six chantiers, chacun à livrable unique, critère exécutable et limite déclarée. Total cinq heures sous une limite de six. Ce qui n'est pas SMART sort du plan et tient dans un seul `NON`, comme la tâche le demande.

## Statut

`propose`, et **exécuté dans la foulée** : la tâche 1 de `SES-002` est déclarée `[implémentation]`, et le plan sert à ordonner le travail, non à le différer.

## Intention

Inscrire dans le système la forme que l'humain a adoptée à la main : l'énoncé de session vit dans son répertoire de journal, et `workspace/session.md` est un lien symbolique vers lui.

**Cible mesurable.** `clia ses new` et `clia ses switch` déplacent le lien, et `clia ses ls` voit toutes les sessions du dépôt.

## Limite de temps

**Six heures**, réparties par chantier. Les durées sont des estimations déclarées comme telles : le dépôt n'a mesuré la durée d'aucun chantier, et `PDC-003` V-S3 exige une déclaration, non une justification.

## Chantiers

### Chantier A - Rétablir le critère de convergence

| Élément | Valeur |
|---|---|
| **Livrable** | `RES-034`, `session.template.md`, `session.cue` |
| **Critère de réussite** | Un énoncé neuf porte cinq rubriques dont `CRITÈRES DE CONVERGENCE` |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Contrôle exécutable.** `clia ses new` dans un dépôt jetable, puis `grep -c 'CRITÈRES DE CONVERGENCE'` sur l'énoncé produit retourne 1.

**Ce que le chantier répond.** `NON-037` Q1, par la demande B de la tâche.

### Chantier B - L'énoncé se nomme session.md

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/session.sh`, découverte et création |
| **Critère de réussite** | `clia ses ls` affiche toutes les sessions du dépôt, pas seulement l'ouverte |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Contrôle exécutable.** Sur ce dépôt, `clia ses ls` affiche `SES-002`. Sur un dépôt jetable à trois sessions, il en affiche trois.

**Ce que le chantier corrige.** Le module cherche `SES-<SEQ>.md`, nom que j'avais choisi seul hier. L'humain a écrit `session.md`, et sa forme fait foi : aucun énoncé n'est trouvé aujourd'hui.

### Chantier C - `ses new` repointe le lien

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/session.sh`, verbe `new` |
| **Critère de réussite** | Après `new`, `readlink workspace/session.md` désigne l'énoncé neuf |
| **Limite de temps** | 1 heure |
| **Dépend de** | B |

**Contrôle exécutable.** En dépôt jetable, `readlink` après `new` renvoie le chemin de l'énoncé créé.

**Un choix déclaré.** Le lien est posé **relatif**, alors que celui posé à la main est absolu. Un lien absolu casse au clone et au déplacement ; l'intention de `SES-002` est de rendre le système utilisable dans n'importe quel dépôt.

**Une précaution.** Le lien remplacé est le point d'entrée déclaré par `CLAUDE.md`. Le chantier refuse d'écraser un `workspace/session.md` qui serait un fichier ordinaire non vide : il l'aurait détruit.

### Chantier D - Le verbe `switch`

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/session.sh`, verbe `switch` |
| **Critère de réussite** | `switch` change le lien et **aucun** champ `etat` |
| **Limite de temps** | 1 heure |
| **Dépend de** | B, C |

**Contrôle exécutable.** En dépôt jetable, relever les `etat` des trois sessions avant et après un `switch` : ils sont identiques.

**L'alias accepté.** `SES-001`, `001` et le slug, sans distinction de casse. C'est le mécanisme de `clia_registre_find`, repris plutôt que réinventé.

### Chantier E - `RES-032` documente la forme

| Élément | Valeur |
|---|---|
| **Livrable** | `RES-032` |
| **Critère de réussite** | `RES-032` déclare l'énoncé dans le répertoire de session et le lien depuis `workspace/` |
| **Limite de temps** | 45 minutes |
| **Dépend de** | rien |

**Contrôle exécutable.** `grep -c 'session.md' RES-032` retourne au moins 2, et le document nomme le lien symbolique.

**Pourquoi `RES-032` et non `RES-034`.** La demande C le nomme. Le répertoire de session est un répertoire de journal, et sa structure appartient au type `log`. `RES-034` est mis en cohérence, sans être le lieu de la déclaration.

### Chantier F - L'avertissement cesse de mentir

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/session.sh`, `clia_session_status` |
| **Critère de réussite** | `clia ses status` sur ce dépôt n'affiche plus « session non enregistree » |
| **Limite de temps** | 15 minutes |
| **Dépend de** | B |

**Ce que le chantier corrige.** L'avertissement s'affiche aujourd'hui alors que la session **est** enregistrée et que le lien pointe dessus.

## Ce qui est sorti du plan

Cinq points ne satisfont pas `PDC-003` et vivent dans un seul `NON`, comme la tâche le demande.

| Point écarté | Motif |
|---|---|
| L'état `abandonnee` | `NON-037` Q2 sans réponse : aucun critère de réussite ne peut être écrit |
| La langue des états | `NON-037` Q3 sans réponse |
| Un lien pointant une session `closed` | Conséquence de « ne fait que » ; ce qu'il faut alors afficher n'est pas décidé |
| Ce que `close` vérifie du critère de convergence | Le critère existe de nouveau ; rien ne dit s'il conditionne la clôture |
| L'énoncé absent de `SES-001` | Suppose de reprendre un document de régime humain, et deux répertoires de journal |

`MET-004` étape 6 : ne pas implémenter un livrable dont le préalable est ouvert, même s'il est SMART.

## Livrables attendus

| Chantier | Livrable | Durée |
|---|---|---|
| A | `RES-034`, gabarit, schéma | 1 h |
| B | `session.sh`, découverte | 1 h |
| C | `session.sh`, `new` | 1 h |
| D | `session.sh`, `switch` | 1 h |
| E | `RES-032` | 45 min |
| F | `session.sh`, `status` | 15 min |
| | **Total** | **5 h** |

Sous la limite de six heures.

## Ordre d'exécution

```
A, indépendant
E, indépendant

B ──> C ──> D
│
└──> F
```

## Objections de l'agent

**Ce plan est écrit après que la décision a été prise en acte.** L'humain a posé le lien à la main avant que le plan existe. Le plan inscrit une forme éprouvée, il ne l'évalue pas.

**Le chantier C touche le point d'entrée déclaré du système.** Un lien mal posé rend `workspace/session.md` illisible, et `CLAUDE.md` en fait le seul point d'entrée des demandes. La garde de refus d'écrasement est une précaution, non une garantie.

**Le chantier C revient sur la forme posée par l'humain**, du lien absolu au lien relatif. Le motif est déclaré ; le geste reste une correction de ce que l'humain a fait.

**Les six durées sont des estimations.** Le dépôt n'a mesuré la durée d'aucun chantier. C'est le même défaut que `PLN-007`, et il n'est pas corrigé.

**Quatre plans attendent depuis leur rédaction.** `PLN-001`, `PLN-003`, `PLN-005` et `PLN-007` portent `statut-plan: propose` sans être engagés ; `PLN-004` est abandonné. Deux seulement ont été exécutés sur huit avant celui-ci. Celui-ci l'est dans la foulée parce que la tâche est déclarée `[implémentation]`.

## Relations

- `derive-de` [NON-037](../objections/NON-037-frontiere-et-forme-de-la-session.md)
- `reference` [RES-032](../ressources/RES-032-log.md)
- `reference` [RES-034](../ressources/RES-034-session.md)
- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
