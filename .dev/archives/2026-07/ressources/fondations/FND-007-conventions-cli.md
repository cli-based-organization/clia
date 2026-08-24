---
type: fondation
version: 0.1.0
title: "conventions-cli - Conventions et interfaces des CLI"
status: actif
date: 2026-07-10
---

# FND-007-conventions-cli - Conventions et interfaces des CLI

- **Objectif** : établir une base factuelle et sourcée sur les conventions d'interface des programmes en ligne de commande (arguments, options, sous-commandes, codes de sortie, stdout/stderr, aide, ergonomie), réutilisable pour définir une convention de CLI bash propre au dépôt.

## Note de rigueur

Fondation appuyée sur des sources primaires (standards POSIX de l'Open Group, GNU Coding Standards et GNU C Library) et sur une source secondaire de référence largement adoptée (Command Line Interface Guidelines, clig.dev). Les affirmations normatives (« doit », « convention ») sont rattachées à leur source. Sujet stable : les conventions POSIX et GNU évoluent lentement ; les recommandations ergonomiques modernes (clig.dev) sont plus mouvantes.

## Cadrage

Périmètre : conventions d'**interface** d'un programme CLI, indépendantes du langage d'implémentation. Dans le périmètre : syntaxe des arguments et options, sous-commandes, codes de sortie, flux standard, aide et version, variables d'environnement, ergonomie. Hors périmètre : détails d'implémentation propres à un langage (parsing library), packaging, distribution.

Définitions :
- **Argument / opérande** : jeton non-option passé au programme (souvent un chemin ou une valeur).
- **Option / flag** : jeton modifiant le comportement, commençant par `-` (court) ou `--` (long).
- **Sous-commande** : verbe sélectionnant un mode d'opération (`git commit`, `dev.sh gen`).

## Corps

### 1. Syntaxe des options (POSIX Utility Conventions)

Les conventions POSIX (Open Group, Base Specifications, chapitre 12 « Utility Conventions ») fixent notamment :
- une option commence par `-` suivi d'un caractère alphanumérique unique ;
- plusieurs options sans argument peuvent être groupées derrière un seul `-` (`-abc` équivaut à `-a -b -c`) ;
- une option peut exiger un argument ; l'argument peut être collé ou séparé par une espace ;
- le jeton `--` termine les options : tout ce qui suit est traité comme opérande, même si cela commence par `-` ;
- un `-` seul désigne conventionnellement l'entrée ou la sortie standard ;
- les opérandes suivent généralement les options.

La fonction `getopt()` (POSIX.1) assiste l'analyse conforme à ces règles.

### 2. Options longues (GNU)

Les GNU Coding Standards recommandent, en plus des options courtes POSIX, des **options longues** `--mot`. Avantages : lisibilité et cohérence inter-programmes. Certaines options longues sont attendues d'un programme à l'autre : `--help`, `--version`, `--verbose`, `--quiet`, `--output`. Une option longue peut être abrégée tant que l'abréviation reste non ambiguë (GNU C Library, « Argument Syntax »). GNU recommande d'offrir un équivalent long à chaque option courte.

### 3. Aide et version

- `--help` / `-h` : afficher un message d'usage et sortir avec le code 0.
- `--version` : afficher la version et sortir.
- Le message d'usage décrit la synopsis, les commandes, les options ; idéalement il tient à l'écran et pointe vers une aide détaillée.

### 4. Flux standard (stdout / stderr)

Convention POSIX et Unix : **stderr est réservé aux messages de diagnostic** (erreurs, avertissements, journal). **stdout porte la sortie utile** (les données, le résultat exploitable par un autre programme). Cette séparation permet la composition (`prog | autre`) sans polluer les données avec des diagnostics. clig.dev insiste : la sortie principale sur stdout, tout le reste sur stderr.

### 5. Codes de sortie

- `0` = succès ; toute valeur non nulle = échec (convention shell universelle).
- Plage utilisable 1 à 125 pour les erreurs applicatives ; `126` = commande trouvée mais non exécutable ; `127` = commande introuvable ; `128+N` = terminaison par le signal N (convention shell).
- La convention BSD `sysexits.h` propose des codes normalisés (`EX_USAGE=64` mauvais usage, `EX_DATAERR=65`, `EX_NOINPUT=66`, `EX_SOFTWARE=70`, etc.), utile mais non universelle.
- Recommandation : `0` succès, `1` erreur générique, `2` erreur d'usage (arguments invalides), codes spécifiques documentés au besoin.

### 6. Sous-commandes

Pour un outil multi-fonctions, le modèle `programme COMMANDE [options]` (à la git) structure l'interface : un verbe sélectionne l'opération, chaque sous-commande a ses propres options, et une aide par sous-commande est attendue. clig.dev recommande ce modèle dès que l'outil dépasse quelques actions.

### 7. Ergonomie moderne (clig.dev, « Command Line Interface Guidelines »)

Principes clés, dérivés de la philosophie Unix actualisée :
- **Conçu pour les humains d'abord**, tout en restant scriptable et composable.
- **Découvrabilité** : aide accessible, messages d'erreur qui suggèrent la correction, `--help` exhaustif.
- **Cohérence** : réutiliser les noms de flags standards (`--verbose`, `--output`, `--force`, `--dry-run`).
- **Robustesse et prévisibilité** : comportement déterministe, ne pas exiger d'entrée interactive en mode non-TTY (`--no-input`), permettre `--yes` pour confirmer.
- **Sortie** : respecter `NO_COLOR` (désactiver la couleur) et `FORCE_COLOR` ; ne pas colorer si la sortie n'est pas un terminal.
- **Configuration** : précédence flags > variables d'environnement > fichier de configuration > défauts.
- **Erreurs** : message clair, sur stderr, code de sortie non nul, pas de trace brute si évitable.

### 8. Robustesse d'implémentation (bash spécifiquement)

Bien que le langage soit hors périmètre strict, les conventions d'interface impliquent côté bash : `set -euo pipefail` pour échouer tôt, quoting systématique des variables, gestion explicite des erreurs et des codes de sortie, `trap` pour le nettoyage, résolution robuste du répertoire du script.

## Synthèse

Une CLI conforme aux conventions établies : accepte des options courtes POSIX et longues GNU, offre `--help` et `--version`, sépare strictement stdout (données) et stderr (diagnostics), retourne 0 en cas de succès et un code non nul documenté sinon, termine les options par `--`, structure les outils riches en sous-commandes, réutilise les noms de flags standards, et se comporte de façon prévisible en contexte scripté comme interactif. Ces règles maximisent la composabilité, la découvrabilité et la cohérence inter-outils.

## Limites

- Ne couvre pas le packaging, la distribution, ni les bibliothèques de parsing par langage.
- Les recommandations ergonomiques (section 7) reflètent l'état de l'art clig.dev à la date ci-dessus et peuvent évoluer.
- `sysexits.h` est une convention BSD non universellement suivie ; à adopter explicitement ou non.

## Sources

- Open Group, Base Specifications, chapitre 12 « Utility Conventions » : https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html
- GNU Coding Standards, « Command-Line Interfaces » : https://www.gnu.org/prep/standards/html_node/Command_002dLine-Interfaces.html
- GNU C Library, « Argument Syntax » : https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html
- Command Line Interface Guidelines (clig.dev) : https://clig.dev/
- cli-guidelines (dépôt source) : https://github.com/cli-guidelines/cli-guidelines
