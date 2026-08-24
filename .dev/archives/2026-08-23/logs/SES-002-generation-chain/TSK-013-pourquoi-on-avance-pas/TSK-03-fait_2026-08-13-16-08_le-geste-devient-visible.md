# Ce qui a été fait, tâche 13 de SES-002

`MET-003` étape 3.

## Le grief, et ce qu'il a fait apparaître

**`clia focus` ne lisait pas les décisions.** `DCN-016`, qui débloque cinq chantiers de `PLN-007`, n'était un item pour personne depuis le 2026-08-11 — la commande ne la mentionnait que comme motif d'un plan rangé à défricher.

Trois mesures, prises avant correction :

```
suites proposees sur treize taches       51, dont 26 pour l'humain
items en attente                         61
items pour l'humain affiches par focus    3
decisions suspendues visibles             0
```

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## `clia focus` désigne enfin le geste de l'humain — `FNC-007` étendue

**Ce qui a été livré.** Trois choses, qui ne valent qu'ensemble.

**Une décision suspendue est un item.** Nouvelle catégorie `A APPROUVER`, destinataire humain. `DCN-013` pose qu'un premier jet d'agent reste suspendu jusqu'à approbation manuelle : c'est une attente adressée à l'humain, et le système ne la comptait pas.

**Elle passe devant tout le reste.** C'est la seule catégorie où l'humain est le seul à pouvoir agir — `CONSTITUTION.md` C1. La laisser derrière un bogue que personne n'attend est ce qui a immobilisé `PLN-007` pendant deux jours.

**La commande répond à celui qui la lance.**

```sh
clia focus --humain   # ce que l'humain peut faire, et lui seul
clia focus --agent    # ce que l'agent peut faire
clia focus --tout     # le decompte par categorie
```

Ce que `clia focus` répond maintenant, sans argument :

```
a faire     A APPROUVER
qui         humain
quoi        DCN-016 - Quatre champs d etat pour toute ressource (bloque 1 plan(s))
cite par    12 document(s)
en attente  63 item(s) au total

clia res edit DCN-016   # poser effet: en-vigueur, ou reviser
```

**Ce que le filtre change concrètement** : 63 items au total, **22 pour l'humain**. Le défrichage vise les deux et reste dans les deux filtres.

**Ce qui ne marche pas encore.** Le décompte « bloque 1 plan(s) » compte les plans, non les chantiers : `DCN-016` en bloque cinq. Et un blocage écrit en prose, sans lien vers une décision, reste invisible.

## `MET-005` étape 6 — la directive rendue

**Ce qui a été livré.** Une tâche se termine sur un geste, pas sur un rapport. Quatre éléments obligatoires : le geste à l'impératif, la commande copiable telle quelle, ce qu'elle débloque, et qui.

**Et une règle de cohérence** : la directive rendue est celle que `clia focus` désigne. Si les deux divergent, **la commande a raison**, et l'agent corrige la commande — non son message.

**Comment s'en servir.** `clia res show MET-005`, étape 6. Trois contrôles ont été ajoutés à la rubrique de vérification de la méthodologie.

**Le motif.** Aux tâches 11 et 12, j'écrivais « statuer sur `DCN-016` » pendant que `clia focus` disait « corriger `BUG-001` ». Deux réponses à la même question ; un humain qui n'en exécute aucune.

## `skl-006` — un blocage se déclare avec ce qui le lève

**Ce qui a été livré.** Le skill qui porte l'écriture des plans exige désormais trois éléments à chaque blocage déclaré : **le geste, qui peut le faire, ce qu'il débloque.**

**Comment s'en servir.** Son contrôle est exécutable : après avoir écrit un plan qui déclare un blocage, lancer `clia focus --humain`. Le geste doit y apparaître. **S'il n'y est pas, c'est un bogue** — pas une prose à étoffer.

---

## Décidé en avançant

**Implémenter, et pas seulement écrire.** La tâche est un rapport de bogue, et l'humain demandait de réécrire les méthodes. Écrire la règle sans la rendre mécanique aurait reproduit le défaut même que l'analyse constate — une prescription que rien ne tient, ce que `NON-005` nomme.

**Ne créer aucune méthodologie nouvelle.** `MET-005` et `skl-006` existaient et suffisaient. La session cherche à retirer des items, pas à en ajouter.

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/bogues/BUG-005-...md` | Création |
| `.dev/analyses/ANL-013-...md` | Création |
| `lib/clia/focus.sh` | Catégorie `A APPROUVER`, priorité, filtre par destinataire |
| `tests/test_clia.sh` | **10 assertions**, 279 → 289 |
| `.dev/methodologies/MET-005-...md` | Étape 6, et trois contrôles |
| `.dev/skills/skl-006-.../SKILL.md` | Écrire un plan : ce qui bloque se déclare avec ce qui le lève |
