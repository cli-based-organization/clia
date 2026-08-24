# Ce qui a été fait, tâche 15 de SES-002

`MET-003` étape 3.

## Deux livrables

| Livrable | Ce qu'il porte |
|---|---|
| `BUG-006` | Les défauts, mesurés sur `clia-repos` |
| `PLN-017` | Quatre chantiers SMART, 9 heures déclarées |

**Pas d'analyse séparée.** Le diagnostic tient dans les rubriques « L'écart » et « La cause » du bogue. La session cherche à faire descendre le nombre d'items ; un troisième document aurait dit la même chose une troisième fois.

## Ce que la mesure a ajouté au constat

Les deux défauts que l'humain rapporte sont confirmés. **Un troisième apparaît, du même genre.**

| Constat | Mesure |
|---|---|
| Pas de `CONSTITUTION.md` | Confirmé. Ni `ARCHITECTURE.md` |
| `INTENTION.md` porte l'intention de `clia` | Confirmé : **`diff` vide** |
| **`CLAUDE.md` aussi** | **`diff` vide** — non relevé par l'humain, même cause |
| Ni l'un ni l'autre n'est un lien | Fichiers réels, dates du 2026-08-09 préservées |

## La cause, en une ligne

`clia_setup_poser` fait `cp -p "$source" "$cible"`, et `clia_setup_fichiers_harnais` ne déclare que deux fichiers.

**Le mécanisme ne distingue pas un harnais d'un contenu.** `CLAUDE.md` décrit un mode opératoire : le copier se défend. `INTENTION.md` porte ce qu'un dépôt veut accomplir : aucun dépôt ne partage l'intention d'un autre.

**Le régime lié aggraverait le cas.** En `--dev`, la fonction pose un lien vers le dépôt source : le dépôt neuf pointerait sur l'intention de `clia`, et la modifier modifierait `clia`.

## Le plan, et ce qu'il refuse de promettre

Quatre chantiers, tous SMART — 4 livrables, 4 critères exécutables, 4 limites.

| Chantier | Critère, en un mot |
|---|---|
| A. `harnais.yaml` et les gabarits | Les quatre harnais déclarés, `ARCHITECTURE.md` optionnel |
| B. Générer au lieu de copier | **`diff` non vide** contre les fichiers du dépôt source |
| C. L'intention devient une ressource | `INTENTION.md` est un lien relatif vers `.dev/intentions/INT-001-*.md`, cible vide |
| D. Migrer un dépôt existant | Le contenu préexistant est intact après déplacement |

**Le critère du chantier B est écrit à l'envers de l'habitude** : il exige une **différence**. C'est la mesure directe du bogue, dont le constat est un `diff` vide.

**La génération des skills est sortie du plan.** L'humain les nomme dans sa liste. `ADR-016` D3 pose qu'ils sont dérivables de `RES`, `ADR`, `SPC` et `RQF`, et **aucun générateur n'existe** — `ISU-002` et `NON-025` le portent depuis le 2026-08-11. Aucun critère exécutable ne peut être écrit tant que la règle de dérivation n'est pas établie.

**Ce que le chantier C donne au passage** : la première instance du type `intention`, défini par `RES-003` depuis le 2026-08-09 et jamais instancié.

## Ce que la tâche n'a pas fait

**Elle n'a exécuté aucun chantier.** `[plan de rémédiation]`, rangé avec `[planification]` : `MET-005` étape 1. `PLN-017` reste `propose`, et son exécution appartient à une tâche que l'humain déclenche.

**Aucune fonctionnalité livrée**, donc `MET-005` étape 4 ne s'applique pas. `FNC-003` sera touchée par la tâche qui exécutera le plan.

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/bogues/BUG-006-...md` | Création |
| `.dev/plans/PLN-017-...md` | Création |
