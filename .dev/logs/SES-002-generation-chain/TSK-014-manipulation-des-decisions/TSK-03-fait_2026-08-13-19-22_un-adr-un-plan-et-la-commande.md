# Ce qui a été fait, tâche 14 de SES-002

`MET-003` étape 3.

## Trois livrables, dans l'ordre que la demande fixe

| Livrable | Ce qu'il porte |
|---|---|
| `ADR-018` | Cinq décisions : la documentation d'un type est fournie par le CLI, dérivée et jamais rédigée |
| `PLN-016` | Trois chantiers SMART, 3 h 30 déclarées |
| `clia res explain` | La commande, exécutée parce que le plan satisfaisait la condition |

## La condition a été vérifiée avant d'écrire une ligne de code

La demande dit : « **si** ce plan est SMART, implémenter la commande ».

```
chantiers                3
**Livrable**             3
**Critère de réussite**  3
**Limite de temps**      3
```

`PDC-003` est satisfait sur les trois contrôles. **C'est ce qui a autorisé l'implémentation dans la tâche qui a produit le plan** — un écart à `MET-005` étape 1, que l'humain pose explicitement et qui ne vaut que pour ce cas. `BUG-002` reste la règle ailleurs.

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## `clia res explain` — `FNC-001` étendue

**Ce qui a été livré.** Le dépôt explique ses propres types. Le constat qui a déclenché la tâche — « c'est difficile de comprendre comment fonctionne les métadata de décision DCN et son cycle de vie » — se règle en une commande.

**Comment s'en servir.**

```sh
clia res explain DCN-016     # depuis une instance
clia res explain RES-009     # depuis la définition — même sortie
clia res explain --help
```

```
Décision — decision

prefixe       DCN
emplacement   .dev/decisions/DCN-<SEQ>-<SLUG>.md
famille       contenu
cycle de vie  vivant
edition       humain
instances     20
skill         skl-004-ressource-de-contenu
adr           ADR-010
definition    .dev/ressources/RES-009-decision.md

CHAMPS OBLIGATOIRES
CHAMP             VALEURS ADMISES
type              decision
id                libre
...
effet             proposee, en-vigueur, suspendue, abrogee, remplacee
attestation       interne, source-primaire, source-rapportee, temoignage
diffusion         public, prive, confidentiel

domain-status : proposee, en-vigueur, suspendue, abrogee, remplacee
                reprises du champ effet, DCN-016
```

**Les deux formes donnent une sortie identique**, `ADR-018` D3 : celui qui bute sur une décision a `DCN-016` sous les yeux, non `RES-009`.

**Rien n'est rédigé.** Tout est dérivé du frontmatter de la définition et du schéma `cue` du type. Une documentation écrite à part se périme ; une dérivation ne le peut pas.

**Ce qui ne marche pas encore.** L'explication porte la **forme**, non le **sens** : elle dit que `effet` admet `suspendue`, pas ce que `suspendue` engage. `ADR-018` D5 le déclare, et la dernière ligne de la sortie renvoie à la définition.

Un type sans définition `RES` n'est pas explicable — il n'y a rien à dériver, et la commande le dit plutôt que d'inventer.

---

## Trois défauts trouvés en éprouvant

Aucun n'aurait été vu sans exécuter les critères.

**`paste -sd', '` alterne les deux caractères** au lieu de séparer par l'un : `effet` s'affichait `proposee,en-vigueur suspendue,abrogee remplacee`.

**Un champ sans énumération renvoyait un succès vide.** `id`, `title`, `version` s'affichaient sans valeur au lieu de `libre` — ce que `ADR-018` D4 interdit précisément.

**Le dernier champ de la liste disparaissait.** `diffusion`, dernier champ obligatoire de la décision, n'était pas lu : la liste ne se termine pas par un saut de ligne, et `read` échoue en lisant le dernier élément. Même famille de piège que le `grep -c` de la tâche 9 et le sous-shell de la tâche 12.

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/adr/ADR-018-...md` | Création |
| `.dev/plans/PLN-016-...md` | Création, puis `execute` |
| `lib/clia/resource.sh` | `explain`, lecture d'énumération `cue`, résolution instance → définition, aide |
| `tests/test_clia.sh` | **11 assertions**, 297 → 308 |
