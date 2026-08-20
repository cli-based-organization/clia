# Ce qui a été fait, tâche 16 de SES-002

`MET-003` étape 3.

## Les quatre chantiers, exécutés et éprouvés sur des dépôts jetables

| Chantier | État | Preuve |
|---|---|---|
| A. `harnais.yaml` et les gabarits | **Exécuté** | 4 harnais déclarés, `ARCHITECTURE.md` optionnel, `CONSTITUTION.md` obligatoire — vérifié par script |
| B. Générer au lieu de copier | **Exécuté, critère corrigé** | Voir plus bas |
| C. L'intention devient une ressource | **Exécuté** | `INTENTION.md` lien relatif, `INT-001` conforme au schéma, six sections présentes |
| D. Migrer un dépôt existant | **Exécuté** | Contenu migré identique mot pour mot, testé sur trois cas |

**`PLN-017` passe à `execute`.**

## L'écart trouvé en exécutant, et la correction du critère B

`PLN-017` chantier B exigeait un `diff` **non vide** entre les harnais générés et ceux du dépôt source. J'ai lu `CONSTITUTION.md` et `CLAUDE.md` avant d'écrire le code : **aucun des deux ne porte de contenu propre au projet `clia`**. Tous deux décrivent le système, applicable tel quel à n'importe quel dépôt instrumenté.

**Le vrai défaut de `BUG-006` n'est pas « identique à la source », c'est « dépend de la source ».** Un `diff` non vide aurait forcé une différence artificielle là où l'identité est correcte — le défaut que le critère de `PLN-013` a déjà illustré à la tâche 9 : satisfaire la lettre en trahissant l'esprit.

**Le critère corrigé** : la sortie dépend du gabarit dans `.dev/templates/harnais/`, jamais du fichier racine du dépôt source. Deux essais symétriques le prouvent, tous deux au banc de tests désormais :

```
modifier $source/CLAUDE.md   -> la sortie ne change pas
modifier le gabarit          -> la sortie change
```

**En régime lié (`--dev`)**, la conséquence se voit directement : `CLAUDE.md` du dépôt cible pointe vers `.dev/templates/harnais/CLAUDE.md.tmpl`, jamais vers `CLAUDE.md` du dépôt source. C'est ce qui aurait aggravé `BUG-006` pour `INTENTION.md` si rien n'avait changé — le lien pointerait sur l'intention même de `clia`.

**Le gabarit d'`INTENTION.md` n'est pas un fichier statique.** Un second écart, décidé avant d'écrire du code : dupliquer les champs et sections de `RES-003` dans un gabarit séparé créerait un second endroit à tenir synchronisé. `INTENTION.md` est dérivé de `RES-003` directement — `ADR-018` D2, même principe que `clia res explain`.

## Un incident pendant l'écriture des tests, corrigé avant qu'il ne laisse de trace

Éprouver le découplage exigeait de modifier temporairement `CLAUDE.md` du dépôt `clia` lui-même, puis de le restaurer. **Le premier jet du test l'a restauré avec un octet de différence** : `$(cat fichier)` perd le saut de ligne final, et `printf '%s\n'` ne le reproduit pas fidèlement. `git status` l'a montré immédiatement après le premier lancement du banc.

**Corrigé avant de committer quoi que ce soit** : sauvegarde et restauration par `cp -p`, jamais par une variable shell. Une assertion vérifie maintenant que le fichier racine du dépôt `clia` ressort identique, par `diff`, à la fin du test.

## Un bogue trouvé en préparant le chantier C, non corrigé ici

**`clia_resource_new` ne pose plus `maturity`, `adoption`, `activated` depuis que `DCN-016` est en vigueur.** Mesuré : une instance créée à l'instant échoue `cue vet`. Trois instances du dépôt en portent la marque, créées après que le chantier D de `PLN-007` a corrigé le passé sans corriger le chemin de création.

`BUG-007` le documente. **Non corrigé ici** : `resource.sh` n'est touché par aucun chantier de `PLN-017`, et le corriger aurait mélangé deux livrables sous une seule directive — `MET-005` étape 6. Ma génération de `INT-001` pose les trois champs directement, sans dépendre de cette correction.

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## `clia setup init` ne fait plus fuir l'intention d'un dépôt vers l'autre — `FNC-003` étendue

**Ce qui a été livré.** `clia setup init` pose désormais quatre harnais générés, et une intention propre à chaque dépôt.

**Comment s'en servir.** Rien à apprendre : la commande est la même.

```sh
clia setup init CIBLE          # CLAUDE.md, CONSTITUTION.md, ARCHITECTURE.md, une intention vide
clia setup init CIBLE --dev    # les trois premiers en lien vers le gabarit, l'intention reste locale
```

**Ce que `CIBLE/INTENTION.md` devient** : un lien relatif vers `.dev/intentions/INT-001-intention.md`, un gabarit vide dérivé de `RES-003` — aucune phrase de l'intention de `clia`.

**Un dépôt qui portait déjà un `INTENTION.md` écrit à la main** le voit déplacé vers `.dev/intentions/INT-001-*.md` et remplacé par un lien, **son contenu intact, mot pour mot** — vérifié par comparaison avant/après.

**Ce qui ne marche pas encore.** `clia setup check` ne vérifie toujours pas la présence de `CONSTITUTION.md` : ce critère appartient à `SPC-001`, hors du périmètre des quatre chantiers. Un dépôt migré peut porter une intention sans frontmatter valide, si le fichier d'origine n'en avait pas — le contenu n'est jamais réécrit pour l'ajouter.

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/harnais.yaml` | Création |
| `.dev/templates/harnais/*.tmpl` | Création, trois gabarits |
| `.dev/bogues/BUG-007-...md` | Création |
| `lib/clia/setup.sh` | Génération, intention par ressource, migration |
| `tests/test_clia.sh` | **14 assertions**, 308 → 322 |
| `.dev/plans/PLN-017-...md` | `execute`, critère B corrigé et déclaré |
