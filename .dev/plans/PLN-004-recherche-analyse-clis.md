# PLN-004 - Recherche, analyse et outillage méthodologique des CLI

**Statut : exécuté**

## Changelog

- **v1 (tâche-9)** : première proposition. Sept sous-items : fondation sur les conventions de CLI, scan récursif de l'existant, analyse, skills spécification/requis/codage-cli-bash, ADR + spécification + requis d'une convention de CLI bash. L'analyse de l'existant y était classée à tort comme une recherche de fondation (FND-002).
- **v2 (tâche-10, objection humaine)** : correction. Une recherche de fondation est une recherche **théorique large fondée sur la littérature scientifique** ; l'analyse d'un corpus de documents sur un système de fichiers n'en est pas une. En conséquence : (1) FND-002 est supprimée et remplacée par un livrable d'un nouveau type **« analyse »** ; (2) création d'un skill spécialisé dans l'analyse d'un corpus de textes sur système de fichiers ; (3) le type de livrable « analyse » est défini dans un ADR ; (4) `skl-002` est précisé pour exclure explicitement ce cas et renvoyer vers le nouveau skill.
- **v3 (tâche-11, exécution)** : plan exécuté. Les dix livrables ont été produits et le harnais amendé (voir « Travail effectué »).

## Intention

Doter le dépôt d'une base méthodologique complète pour concevoir et coder des CLI (en particulier bash) : une recherche de fondation théorique sur les conventions de CLI, une analyse empirique de l'existant (scripts présents dans les dépôts locaux), puis un jeu d'outillage (skills, ADR, spécification, requis) pour produire des CLI cohérents. Tout est produit en **premier jet** : quand une information manque pour trancher, je choisis selon les meilleures pratiques et ne soulève une objection que si elle est bloquante.

## Contexte

Demande de la tâche 9 de `session.md`, révisée par l'objection de la tâche 10.

Distinction de types actée par l'humain (tâche 10) :
- **Recherche de fondation** (`FND`, `skl-002`) : recherche théorique large, fondée sur la littérature scientifique, sourcée, à péremption lente.
- **Analyse** (nouveau type) : examen d'un corpus de documents concret sur un système de fichiers, produisant un livrable descriptif et critique de cet existant. Type à définir dans un ADR, produit par un nouveau skill dédié.

Ces livrables introduisent de nouveaux types (analyse, spécification, requis) et de nouveaux skills, ce qui implique un amendement du harnais (`CLAUDE.md`). Le dépôt applique la méthode reproduite de la source (voir PLN-003) : format de plan et de skill de la source, vocabulaire de statut `proposé -> objection -> résolu -> approuvé -> exécuté`, règle des tirets cadratins.

## Spécification du livrable

Livrables prévus, avec emplacements proposés (décisions de premier jet) :

1. **ADR-001** - `.dev/adr/ADR-001-type-livrable-analyse.md` : décision définissant le type de livrable « analyse » (objet, emplacement `.dev/analyses/ANL-<SEQ>-<SLUG>.md`, propriétaire, critères). Prérequis des livrables d'analyse. Produit par `skl-006`.
2. **skl-012-analyse-corpus** - `.dev/skills/skl-012-analyse-corpus/SKILL.md` : skill spécialisé dans l'analyse d'un corpus de textes sur système de fichiers, produisant un livrable de type « analyse ». Produit par `skl-001`.
3. **FND-001** - `.dev/fondations/FND-001-conventions-cli.md` : recherche de fondation théorique et sourcée sur les conventions de CLI (arguments, options/flags, sous-commandes, codes de sortie, stdout/stderr, aide, POSIX/GNU, guides de référence reconnus). Produit par `skl-002`.
4. **ANL-001** - `.dev/analyses/ANL-001-etat-clis-existants.md` : inventaire et analyse des scripts bash / CLI trouvés récursivement sous `/home/jvtrudel/git/`, confrontés à FND-001 (écarts, bonnes pratiques observées, anti-patterns). Produit par `skl-012`.
5. **skl-009-specification** - `.dev/skills/skl-009-specification/SKILL.md` : skill de rédaction d'une spécification. Produit par `skl-001`.
6. **skl-010-requis** - `.dev/skills/skl-010-requis/SKILL.md` : skill de rédaction de requis. Produit par `skl-001`.
7. **skl-011-codage-cli-bash** - `.dev/skills/skl-011-codage-cli-bash/SKILL.md` : skill de codage de CLI bash à partir d'un ADR, d'une spécification et de requis. Produit par `skl-001`.
8. **ADR-002** - `.dev/adr/ADR-002-convention-cli-bash.md` : décision actant la convention de CLI bash. Produit par `skl-006`.
9. **SPEC-001** - `.dev/specs/SPEC-001-convention-cli-bash.md` et **REQ-001** - `.dev/requis/REQ-001-convention-cli-bash.md` : spécification et requis de la convention de CLI bash. Produits par `skl-009` et `skl-010`.
10. **Amendements du harnais** (`skl-004`) : enregistrer les nouveaux types (analyse `ANL-<SEQ>` dans `.dev/analyses/`, spécification `SPEC-<SEQ>` dans `.dev/specs/`, requis `REQ-<SEQ>` dans `.dev/requis/`) et les nouveaux skills dans `CLAUDE.md` ; préciser `skl-002` pour exclure l'analyse de corpus sur système de fichiers et renvoyer vers `skl-012`.

## Plan proposé

### 1. ADR-001 - définir le type de livrable « analyse »
Acter, via `skl-006`, ce qu'est une « analyse » : examen d'un corpus concret de documents sur système de fichiers, produisant un livrable descriptif et critique (distinct d'une fondation théorique). Fixer l'emplacement `.dev/analyses/ANL-<SEQ>-<SLUG>.md`, le propriétaire (agent), et les critères de complétude.

### 2. skl-012-analyse-corpus (premier jet)
Skill encadrant l'analyse d'un corpus de textes sur système de fichiers : cadrage du périmètre (racine, filtres), collecte/inventaire, grille d'analyse, confrontation à une référence si fournie (ex. une fondation), synthèse des écarts et recommandations. Produit un livrable `ANL-<SEQ>`.

### 3. FND-001 - fondation théorique sur les conventions de CLI
Recherche sourcée (littérature et guides de référence) : interfaces (arguments positionnels, flags courts/longs, sous-commandes), conventions de sortie (codes de retour, stdout pour les données, stderr pour les diagnostics), ergonomie (`--help`, `--version`, messages d'erreur), standards (POSIX utility conventions, GNU long options). Datée et sourcée conformément à `skl-002`.

### 4. Recherche récursive des CLI existants
Balayer `/home/jvtrudel/git/` (résolution de `../..`) pour les scripts bash (`*.sh`, shebangs `#!/…/bash|sh`) et autres CLI (entrypoints, `bin/`, `scripts/`). Lecture seule, aucune modification hors de ce dépôt. Constitue l'entrée de l'analyse.

### 5. ANL-001 - analyse de l'existant au regard de FND-001
Via `skl-012` : inventaire structuré (dépôt, chemin, rôle), puis confrontation à FND-001 (conformité, écarts, bonnes pratiques, anti-patterns). Base empirique de la convention (étape 7).

### 6. skl-009-specification et skl-010-requis (premiers jets)
`skl-009` : production d'une spécification (le « quoi » d'un livrable technique : comportement, interfaces, contraintes). `skl-010` : production de requis (exigences vérifiables, priorisées ; fonctionnels vs non fonctionnels). Le requis exprime le besoin, la spécification décrit la solution.

### 7. Convention de CLI bash : ADR-002 + SPEC-001 + REQ-001
À partir de FND-001, ANL-001 et des nouveaux skills : ADR-002 (décision de convention et alternatives écartées), SPEC-001 (structure concrète d'un CLI bash conforme : flags standards, gestion des erreurs, aide, sortie), REQ-001 (exigences que tout CLI bash du dépôt doit respecter).

### 8. skl-011-codage-cli-bash (premier jet)
Skill de production du code d'un CLI bash à partir de l'ADR, de la spécification et des requis : processus, garde-fous (`set -euo pipefail`, quoting, gestion d'erreurs), critères de qualité, template de squelette.

### 9. Amendements du harnais
Enregistrer les nouveaux types (analyse, spécification, requis) et skills dans `CLAUDE.md` (table + nomenclature) ; préciser `skl-002` ; vérifier la cohérence croisée avec `CONSTITUTION.md`.

## Décisions de premier jet (meilleures pratiques, non bloquantes)

- **Type « analyse »** : préfixe `ANL`, emplacement `.dev/analyses/ANL-<SEQ>-<SLUG>.md`, suivant la nomenclature `.dev/<type>/<PREFIX>-<SEQ>-<SLUG>.md` en vigueur.
- **Numérotation** : skills `skl-009` à `skl-012` (on évite `skl-005`/`skl-007`, réservés dans la source à des livrables de présentation) ; ADR-001 pour le type analyse (prérequis), ADR-002 pour la convention CLI.
- **Ordre d'exécution** : définir le type analyse et son skill (étapes 1 à 2) avant de produire ANL-001 (étape 5) ; produire FND-001 avant ANL-001 puisque l'analyse s'y confronte.
- **`skl-002` conservé mais précisé** : ajout d'une exclusion explicite (analyse de corpus sur système de fichiers -> `skl-012`), sans réécrire son fond.
- **Périmètre du scan** : `/home/jvtrudel/git/` en lecture seule ; exclusion de `.git/`, `node_modules/`, artefacts de build.

## Objections de l'agent IA

Aucune objection bloquante (premier jet, tranché par les meilleures pratiques). L'objection humaine de la tâche 10 a été intégrée par la révision v2 ci-dessus. Point de vigilance non bloquant : la frontière exacte entre « spécification » et « requis » sera fixée par les premiers jets de `skl-009`/`skl-010` ; une définition arrêtée de l'humain primerait.

## Travail effectué

Exécuté à la tâche 11. Entrées : scan récursif de `/home/jvtrudel/git/` (lecture seule) et recherche documentaire (POSIX, GNU, clig.dev).

- `ADR-001-type-livrable-analyse.md` : type « analyse » (`ANL`) acté.
- `skl-012-analyse-corpus/SKILL.md` : skill d'analyse de corpus.
- `FND-001-conventions-cli.md` : fondation théorique sourcée sur les conventions de CLI.
- `ANL-001-etat-clis-existants.md` : analyse du corpus de CLI locaux, confrontée à FND-001.
- `skl-009-specification/SKILL.md` et `skl-010-requis/SKILL.md` : skills de spécification et de requis.
- `ADR-002-convention-cli-bash.md`, `REQ-001-convention-cli-bash.md`, `SPEC-001-convention-cli-bash.md` : convention de CLI bash (décision, requis, spécification avec squelette de référence).
- `skl-011-codage-cli-bash/SKILL.md` : skill de codage de CLI bash.
- `CLAUDE.md` amendé : types analyse/spécification/requis enregistrés (table + nomenclature), notes sur `skl-011` et la distinction fondation/analyse. `skl-002` précisé (exclusion de l'analyse de corpus).

Décisions de premier jet appliquées telles que documentées (numérotation `skl-009` à `skl-012`, `ADR-001` type analyse, `ADR-002` convention CLI, répertoires `.dev/analyses/`, `.dev/specs/`, `.dev/requis/`).

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
