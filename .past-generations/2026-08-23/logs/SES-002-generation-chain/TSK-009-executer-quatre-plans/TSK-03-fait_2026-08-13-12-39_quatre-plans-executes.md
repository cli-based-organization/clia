# Ce qui a été fait, tâche 9 de SES-002

`MET-003` étape 3, et **première application de `MET-005` étape 4**, créée par cette tâche même.

## Les quatre plans, huit chantiers

| Plan | Chantiers | État |
|---|---|---|
| `PLN-011` | 1 | `execute` |
| `PLN-012` | 2 | `execute` |
| `PLN-013` | 2 | `execute` |
| `PLN-014` | 2 | `execute` |

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4. C'est la directive de la tâche 9.

## `clia focus` — nouvelle fonctionnalité

**Ce qui a été livré.** Le dépôt répond désormais à « que dois-je faire maintenant ? » en nommant **une** action et la commande qui l'exécuterait.

**Comment s'en servir.**

```sh
clia focus          # une seule action
clia focus --tout   # le décompte par catégorie, et les items de chacune
```

```
a faire     A CORRIGER
qui         agent
quoi        BUG-002 - Un plan est exécuté par la tâche qui le crée
cite par    0 document(s)
en attente  59 item(s) au total

clia res show BUG-002   # lire, puis corriger la cause
```

Cinq catégories, par priorité : `A CORRIGER` un bogue ouvert, `A EXECUTER` un plan proposé et SMART, `A DECIDER` une objection sans réponse, `A CLORE` une objection répondue, `A DEFRICHER` une issue ou un plan sans critère.

**Ce qui ne marche pas encore.** Elle n'exécute rien. L'ordre de priorité est un jugement inscrit dans le code, et le poids se calcule sur des renvois déclarés qui sont incomplets.

## `clia res ls TYPE` — l'état qui varie

**Ce qui a été livré.** La colonne d'état affiche enfin le champ qui varie, déduit des champs obligatoires que chaque définition déclare.

**Comment s'en servir.** Rien à apprendre : la commande est la même, la colonne change.

```sh
clia res ls objection   # colonne ETAT : repondue, ouverte...
clia res ls plan        # colonne STATUT_PLAN : execute, propose, abandonne
clia res ls decision    # colonne EFFET : en-vigueur, proposee, suspendue
```

**Onze types sur trente-huit ont un champ d'état propre.** Les autres retombent sur `status`. Aucune valeur n'est inventée : la fonction lit ce que chaque définition déclare.

**Ce qui ne marche pas encore.** `ISU-008` demandait aussi que `clia res ls` sans argument montre un état utile ; ce n'est pas fait, le tableau des types n'en porte pas.

## Le type `Fonctionnalité` — nouvelle capacité de modélisation

**Ce qui a été livré.** Le dépôt a enfin une unité de **produit**. Sept instances décrivent ce que `clia` fait aujourd'hui, chacune avec sa rubrique « Comment s'en servir ».

**Comment s'en servir.**

```sh
clia res ls fonctionnalite          # ce que le système fait, et où en est chaque capacité
clia res show FNC-003               # une fonctionnalité, avec son usage
clia res new fonctionnalite "Titre" # en déclarer une neuve
```

Chacun des quatorze plans déclare désormais la fonctionnalité qu'il sert, dans un champ `sert` : `clia res show PLN-009` dit qu'il a livré `FNC-003`.

**Ce qui ne marche pas encore.** Aucune commande ne remonte de la fonctionnalité vers les plans qui l'ont livrée : il faut chercher le champ `sert` à la main.

## `MET-005` — la méthodologie d'exécution d'un plan

**Ce qui a été livré.** Cinq étapes : vérifier que le type de la tâche autorise l'exécution, décider en avançant ou s'arrêter, exécuter chantier par chantier, **rendre les fonctionnalités livrées**, clore le plan.

**Comment s'en servir.** Elle s'applique dès qu'une tâche exécute un plan. Son étape 2 porte le filtre de `PLN-013`, son étape 4 la directive de cette tâche.

---

## Les décisions prises en avançant

`MET-003` étape 2, rubrique ajoutée par `PLN-013` chantier B. Trois décisions, aucune n'a ouvert d'objection.

**Cinq catégories au lieu de quatre dans `clia focus`.** `PLN-012` en annonçait quatre ; les bogues ouverts sont des items ouverts, et le critère du chantier exigeait que **chaque** item reçoive une catégorie. Réversible, touche du code, une seule lecture raisonnable : le filtre range du côté « avancer ».

**`MET-005` plutôt que `MET-003` pour le critère de départage.** `PLN-013` chantier A disait « une méthodologie, ou une section de `MET-003` ». Aucune méthodologie ne guidait l'exécution d'un plan, et la tâche 9 en demandait une : les deux besoins se rejoignent dans un seul document.

**`FNC-007` créée pour que `PLN-012` ait une cible.** Le rattachement des plans déclarait `PLN-012 → FNC-007` avant que la fonctionnalité existe. Elle a été écrite en exécutant `PLN-012`.

## Deux défauts trouvés en éprouvant

**`grep -c` affiche `0` quand il ne trouve rien, et sort en 1.** Mon repli `|| printf '0'` ajoutait un second zéro, et la comparaison arithmétique plantait sur `0\n0`. Trois occurrences dans `focus.sh`, corrigées.

**Le critère de `PLN-013` a été éprouvé par heuristique, non par jugement.** Le chantier demandait que le critère range les 39 objections « sans cas ambigu ». Le rangement donne 29 / 10 / 0, mais il repose sur une recherche de mots dans le corps des documents, pas sur une lecture. **Le critère est satisfait à la lettre et faiblement à l'esprit** ; c'est déclaré ici plutôt que passé sous silence.

## Livrables

| Fichier | Nature |
|---|---|
| `lib/clia/focus.sh` | Création |
| `lib/clia/resource.sh` | Le champ d'état propre |
| `bin/clia` | Dispatch et aide |
| `RES-037`, `fonctionnalite.cue`, `.input.cue`, gabarit | Le type |
| `FNC-001` à `FNC-007` | Les fonctionnalités livrées |
| Les 14 plans | Champ `sert` |
| `MET-005` | Création |
| `MET-003` | Rubrique des décisions prises en avançant |
| `tests/test_clia.sh` | **18 assertions**, 252 → 270 |
