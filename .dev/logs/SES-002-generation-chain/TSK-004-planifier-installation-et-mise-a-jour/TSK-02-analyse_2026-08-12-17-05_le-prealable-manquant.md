# Analyse, tâche 4 de SES-002

`MET-003` étape 2.

## Ce que les expérimentations antérieures ont produit

Quatre dépôts de `$HOME/git` portent un `setup.sh` comparable. **Un seul est le précédent direct** : `ticket-driven-ai`, qui a déjà les deux niveaux que la demande décrit.

| Dépôt | Ce qu'il apporte |
|---|---|
| `ticket-driven-ai` | `setup.sh` installe le CLI ; `tda -C PATH install [--dev]` instrumente un dépôt |
| `linux-inspect` | Le vocabulaire « dev + éphémère + local », et la réflexivité du CLI |
| `micrologic-clients` | Un `check` de 508 lignes, orienté service |
| `cli-based-organisation_git-resource` | Un `init`, dépôt archivé |

### Ce que `tda` a tranché, et qui vaut d'être repris

**Deux niveaux d'installation, et non un.** Installer le CLI n'est pas instrumenter un dépôt. `setup.sh` fait le premier, `tda install` fait le second.

**Le mode développement est un régime de liaison, pas un régime de copie.**

| Mode | Ce que `tda install` fait des fichiers de harnais |
|---|---|
| `--dev` | Des **liens symboliques** vers le dépôt source |
| sans | Des **copies** |

C'est exactement la réponse aux exigences 4 et 5 de la demande : le code employé est celui du dépôt de développement, et le distant n'est pas modifié.

**Le contrôle précède l'installation.** `_tda_cmd_check` est appelé par `_tda_cmd_install` avant tout écrit, et il énumère les conflits plutôt que de les écraser.

**Les fichiers à installer sont une liste nommée.** `TDA_COPY_FILES`, `TDA_COPY_DIRS`, `TDA_DEV_DIRS`. Ce que `clia` n'a pas.

## Ce que `clia` a déjà, et qui a été mesuré

| Ce qui existe | État |
|---|---|
| `setup.sh` : `install`, `activate`, `deactivate`, `check`, `uninstall` | 263 lignes, fonctionnel |
| Le mode d'installation actuel | **Déjà dev, local et permanent**, sans que le mot soit écrit |
| La résolution du dépôt courant | **Fonctionne déjà** sur un dépôt git vierge |
| `clia setup` | **N'existe pas** : commande inconnue |

**Le drapeau `--dev` décrit ce que `setup.sh install` fait déjà.** Il pointe `CLIA_HOME` vers le dépôt de développement et n'y copie rien. Le chantier n'est pas de créer un mode, mais de le **nommer** et de rendre explicite ce qui est aujourd'hui implicite.

**Sur un dépôt git vierge, la résolution fonctionne et le contenu manque.**

```
depot courant                /tmp/vierge
repertoire de developpement  /tmp/vierge/.dev
--- res ls ---
clia: aucun type de ressource dans /tmp/vierge/.dev
```

L'exigence 2 de la demande est donc **à moitié satisfaite** : `clia` s'exécute partout, il n'a rien à lire nulle part.

## Le préalable qui commande tout

**Personne n'a écrit ce qu'est un dépôt `clia` conforme.**

`PLN-003` chantier G1 le dit déjà, depuis le 2026-08-11 : « **G1 avant tout le reste.** Sans les critères, `init` ne sait pas quoi produire et aucun contrôle ne sait quoi vérifier. C'est un livrable de spécification, type `SPC`, qui n'a aucune instance. »

**Trois des cinq commandes demandées en dépendent** : `init` ne sait pas quoi poser, et les deux `check` ne savent pas quoi vérifier.

**Le type `SPC` existe et n'a aucune instance.** `ANL-010` le mesure : `RES-020` est défini, zéro instance, et trois documents en réclament une.

C'est le premier chantier, et il rend les autres possibles.

## Ce que la demande laisse indéterminé

### Deux commandes portent le même nom

```sh
clia setup check [PATH]  # peut-on instrumenter ce repo sans l'impacter ?
clia setup check [PATH]  # ce repo est-il instrumenté et conforme ?
```

**Lecture retenue, et déclarée comme telle.** Un dépôt est soit instrumenté, soit non : les deux questions sont **deux cas d'un même diagnostic**, et une seule commande peut les couvrir en rapportant l'état constaté.

C'est une interprétation, pas une décision. Le point va au `NON`.

### La mise à jour suppose ce qui n'existe pas

`clia setup upgrade [VERSION]` demande de migrer un dépôt vers une version.

| Ce qu'il faudrait | État |
|---|---|
| Une version déclarée par le dépôt instrumenté | **N'existe pas** |
| Un mécanisme de migration entre deux versions | **N'existe pas** |
| Un inventaire de ce qui change d'une version à l'autre | **N'existe pas** |

**Aucun critère de réussite exécutable ne peut être écrit** pour un chantier dont l'objet n'est pas défini. `PDC-003` V-S2 l'interdit. Le point va au `NON` et à l'`ISU`.

**Ce n'est pas un détail** : le second critère de convergence de `SES-002` est « la mise à jour de clia et la migration des données est possible et facile ».

### Le mot « remote » n'a pas de sens dans clia

L'exigence 3 dit « remote == repo git local dans un répertoire au choix ». Le dépôt source est aujourd'hui désigné par `CLIA_HOME`, résolu depuis l'emplacement réel du binaire.

**Introduire un second mot pour la même chose est un coût.** Le point va au `NON`.

## Le découpage retenu

**Quatre chantiers SMART**, dans cet ordre imposé par la dépendance.

| Chantier | Livrable | Dépend de |
|---|---|---|
| A | La spécification de conformité | rien |
| B | `clia setup check [PATH]` | A |
| C | `clia setup init [PATH]` | A, B |
| D | `. setup.sh install --dev` | rien |

**Ce qui sort du plan** va dans un seul `ISU` et un seul `NON`, comme la demande le prescrit : la mise à jour, le double nommage de `check`, et le mot « remote ».

## Précaution

`init` écrit dans des dépôts tiers et peut en créer. **Tout est éprouvé en dépôt jetable**, et aucun dépôt réel de `$HOME/git` n'est touché.

`git init` n'est pas un des six verbes que `CONSTITUTION.md` C2 interdit, et la garde posée aujourd'hui ne le refuse pas : vérifié.
