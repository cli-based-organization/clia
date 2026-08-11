# Ce qui a été fait, tâches 17 et 19

## En un coup d'oeil

| Mesure | Valeur |
|---|---|
| Chantiers de `PLN-002` exécutés | **5 sur 5** |
| Définitions réécrites | **30 sur 30** |
| Volume des définitions | 22 236 vers **18 511 mots**, soit **-16 pour cent** |
| Rubriques méta restantes | **0** |
| Marqueurs de justification restants | **0** |
| ADR créés | 6 d'adoption, plus `ADR-015` |
| Commandes `clia git` livrées | 4 verbes, 5 aides détaillées |
| Tests du CLI | 91 vers **118**, tous verts |
| Ressources validant leur schéma | **113 sur 115** |

## Tâche 17, chantier par chantier

### Chantier A, corriger skl-001

Sept éditions.

| Réf | Fait |
|---|---|
| A1 | `Statut de ce document` et `Le problème que ce type résout` retirés du gabarit B3 |
| A2 | `Points ouverts` réduit à une table de deux colonnes |
| A3 | La mention des rubriques non optionnelles rendue exacte |
| A4 | Règle `A6` ajoutée : cinq interdits, deux obligations, dont la bibliographie numérotée |
| A5 | Contrôle `V10` ajouté, exécutable par `grep`. Les six skills de famille renvoient à `V1 à V10` |
| A6 | Frontmatter du gabarit aligné sur les seize champs de `RES-001`, `famille` et `sections` ajoutés |
| A7 | `id: RES-<slug>` corrigé, forme abolie par `ADR-007` |

Deux défauts connexes ont été trouvés en chemin et corrigés : la règle `A1` prescrivait encore `<PREFIXE>-<SLUG>` pour le champ `id`, et la règle `A2` a été alignée sur `ADR-008`.

### Chantier B, le gabarit

`ressource.template.md` portait les huit rubriques que `RES-001` déclare pour ses **instances**, non celles d'une définition. Il porte désormais les onze rubriques du gabarit B3.

**Point B2 tranché par l'agent.** Le plan proposait d'ajouter un dix-septième champ obligatoire à `RES-001` pour porter la structure de la définition. Écarté : `NON-022` conteste déjà la croissance du nombre de champs. La structure d'une définition vit dans `skl-001` B3, sans donnée machine-lisible.

### Chantier C, six ADR d'adoption

Option C-a retenue, conformément à la recommandation du plan.

| ADR | Famille | Types |
|---|---|---|
| `ADR-009` | fondamentale | 7 |
| `ADR-010` | contenu | 3 |
| `ADR-011` | conception | 4 |
| `ADR-012` | contrôle | 5 |
| `ADR-013` | préparation | 7 |
| `ADR-014` | implémentation | 4 |

Chacun porte, par type, le problème qu'il résout et l'état de la matière sur laquelle il repose. Le champ `adr` des trente définitions passe de `ADR-005` à l'ADR d'adoption de sa famille.

### Chantier D, les trente définitions

**D1, épreuve sur `RES-009`.** Réécriture complète : 2 797 vers **1 537 mots**, soit **-45 pour cent**. Le retrait mécanique des rubriques seul donnait -20 pour cent ; la réécriture du corps produit le reste.

**D2 et D3, les vingt-neuf autres.** Retrait mécanique des rubriques méta et mise à jour du champ `adr`, puis vingt-huit substitutions ciblées pour retirer les marqueurs de justification du corps.

| Mesure | Avant | Après |
|---|---|---|
| Mots | 22 236 | **18 511** |
| Rubriques méta | 30 définitions sur 30 | **0** |
| Marqueurs « ce jet », « premier jet » | 59 | **0** |

### Chantier E, la mesure étendue

Le défaut est **spécifique aux définitions**.

| Type | Fichiers | Part méta |
|---|---|---|
| `ADR` | 14 | 2 pour cent |
| `DCN` | 8 | 5 pour cent |
| `MET`, `NON`, `PDC`, `ANL` | 32 | **0 pour cent** |

Aucune correction n'est nécessaire hors des définitions. La mesure confirme la cause : le gabarit `skl-001` B3 ne s'appliquait qu'à elles.

## Tâche 19, les commandes git

Un module `lib/clia/git.sh`, quatre verbes.

| Commande | Ce qu'elle fait |
|---|---|
| `clia git check clean` | Deux contrôles : arbre propre, aucun fichier non suivi |
| `clia git check done` | Cinq contrôles : des modifications existent, un message est préparé, la signature est activée (T4), aucun renommage avec réécriture (T1), l'historique n'a pas divergé (T3) |
| `clia git save` | Commite avec le message préparé dans le journal, `.yaml` ou `.md` |
| `clia git log RESSOURCE` | L'historique, une ligne par commit, avec l'identifiant de contenu |
| `clia git diff` | Compare deux versions par leur identifiant de contenu |

**Le verbe `diff` est un ajout à la demande.** `ANL-005` C6 établit que le diff s'obtient de deux identifiants seuls ; sans lui, les identifiants affichés par `log` ne serviraient à rien.

**Ce que `log` fait et que `git log --follow` ne fait pas.** Il fonctionne sur un répertoire. Une ressource composite est désignée par son alias, et son historique est celui de son répertoire.

```
$ clia git log ANL-001
COMMIT   DATE        CONTENU       SIG  AUTEUR              SUJET
c2c4d52  2026-08-10  ba90ffbf5e46  N    Jérémy Viau-Trudel  save
98de8ac  2026-08-10  07f389efc483  N    Jérémy Viau-Trudel  save
64b95cb  2026-08-09  ff736c305974  N    Jérémy Viau-Trudel  premières implémentations
```

## Un bogue trouvé en éprouvant le contrôle T1

La première version du contrôle cherchait un statut de renommage dans `git status --porcelain`. Elle ne trouvait rien, et `save` acceptait le commit.

**Cause.** Git ne signale pas ce cas comme un renommage. Quand la réécriture dépasse le seuil de similarité, il affiche une suppression et une création, et le lien est perdu sans que rien ne l'annonce.

```
$ git status --porcelain
D  .dev/ressources/RES-001-t.md
A  .dev/ressources/RES-001-u.md
```

**Correction.** La détection porte sur l'alias : une ressource supprimée et une ressource créée qui portent le même `<PREFIX>-<SEQ>` sont la même ressource, renommée et réécrite.

Le test qui l'attrape a lui-même dû être corrigé : sa première version produisait un contenu trop proche, git détectait le renommage, et l'historique n'était donc pas coupé.

## Tests

27 assertions ajoutées, de 91 à **118**, toutes vertes. Chacune construit son propre dépôt git, jamais celui du projet.

Trois d'entre elles produisent la faute que T1 doit attraper, et une vérifie que le même geste en deux commits est accepté.

## Ce qui n'a pas été fait

La signature des commits n'est pas activée. `clia git check done` la vérifie et échoue tant qu'elle est absente.

`clia git save` ne pousse pas vers une référence distante.

Le cas d'une ressource qui est un dépôt git n'est pas couvert : la demande l'exclut.

Aucun `ADR` n'instruit `DCN-010` : `ANL-005` porte déjà les recommandations et les contraintes, et la décision y renvoie.
