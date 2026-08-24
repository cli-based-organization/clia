# Ce qui a été fait, tâche 28

`MET-003` étape 3.

## Le type et son instance

| Livrable | Contenu |
|---|---|
| `RES-035` | Le type registre, préfixe `REG`, cycle `travail`, édition `hybride` |
| `registre.cue`, `registre.input.cue`, `registre.template.md` | Artefacts dérivés |
| `REG-001` | Registre des décisions, treize items |

**Un registre ne porte aucun contenu propre.** Ce qu'il dit d'une ressource est repris de cette ressource, jamais élaboré. C'est une vue.

**Le champ `tenue` décide de sa valeur.** `saisie` ou `derivee`. `REG-001` vaut `saisie`, faute de générateur, ce qui en fait la quatrième obligation de propagation non outillée du dépôt.

**La rubrique « Ce que le registre ne contient pas » est obligatoire.** Un registre lu comme exhaustif alors qu'il ne l'est pas est pire que pas de registre. Celle de `REG-001` déclare quatre choses, dont le fait qu'aucune des treize décisions n'est approuvée.

## Les commandes

`lib/clia/registre.sh`, trois verbes et quatre aides.

```
clia reg ls                    les registres : ID, REGISTRE-DE, TENUE, ITEMS, TITRE
clia reg ls REG-001            les items : SEQ, RESSOURCE, DESCRIPTION, STATUS
clia reg show REG-001 7        l'item, puis la ressource qu'il désigne
clia reg edit REG-001 7        ouvre la ressource désignée
```

Le registre se désigne par son alias ou par son numéro seul. Le numéro d'item s'écrit avec ou sans zéros de tête.

**`show` et `edit` portent sur la ressource, non sur l'item.** Un item est une ligne de tableau : l'éditer n'a pas d'intérêt. L'aide dit comment corriger une description : `clia res edit REG-001`.

**Le piège de la lecture du tableau, évité.** Un analyseur qui saute les deux premières lignes casse dès qu'une ligne vide s'intercale. Le filtre retenu reconnaît une ligne de données à son premier champ, un numéro sur exactement trois chiffres. Un test vérifie que le séparateur n'est pas pris pour un item.

## Un bogue découvert et corrigé

Le contrôle de schéma a signalé un fichier non conforme : `FRG-2026-08-11-methodologie-issues.md`, créé par l'humain.

**Cause.** `clia res new` attribuait un discriminant daté aux types `point-fixe`. `ADR-007` D4 abolit le nommage daté depuis le 2026-08-09 : « Tous les types se nomment `<PREFIX>-<SEQ>-<SLUG>.md`, quel que soit leur cycle de vie. »

Le bogue vivait depuis deux jours et a frappé un fichier de l'humain.

**Ce qui l'a laissé passer.** Un test le codifiait. `un type point-fixe est nomme par date` vérifiait l'ancien comportement et passait au vert. La migration de la tâche 13 avait corrigé les fichiers, pas le générateur ni son test.

**Correction.** Le discriminant est toujours un numéro de séquence. Le test est réécrit et porte désormais le motif de son changement, plus une assertion qui vérifie qu'aucun nommage daté ne subsiste.

`FRG-2026-08-11` n'est pas renommé : c'est un fichier de l'humain, et le renommer toucherait à ce qui lui appartient.

## Tests

De 125 à **144 assertions**, toutes vertes. Dix-huit portent sur les registres, une sur le nommage séquencé.

## Ce qui n'a pas été fait

Les trois autres registres demandés par `NON-004` Q4, dette, bogues et tâches à faire. La tâche 28 n'en demande qu'un ; ils restent au chantier D de `PLN-005`.

`REG-001` n'est pas dérivé. Aucun générateur n'existe.
