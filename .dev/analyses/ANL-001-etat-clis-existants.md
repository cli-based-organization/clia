---
type: analyse
version: 0.1.0
title: "etat-clis-existants - État des CLI et scripts bash existants"
date: 2026-07-10
---

# ANL-001-etat-clis-existants - État des CLI et scripts bash existants

- **Périmètre** : arborescence `/home/jvtrudel/git/` (résolution de `../..` depuis ce dépôt), fichiers `*.sh` et entrypoints CLI sans extension. Exclusions : `.git/`, `node_modules/`, environnements virtuels (`ansible/.venv`, `.venv/lib/python*/site-packages`), exemples de dépendances tierces (leptos, cbomkit testdata).
- **Référence** : `FND-007-conventions-cli`.

## Objet

Dresser l'état des lieux des scripts bash et CLI présents dans les dépôts locaux, en dégager les patterns récurrents et les incohérences, et mesurer les écarts par rapport aux conventions établies dans FND-007-conventions-cli, afin d'alimenter la convention de CLI bash du dépôt (ADR-002, SPEC-001, REQ-001).

## Périmètre et méthode

Balayage récursif des `*.sh` et des entrypoints exécutables. Séparation du corpus **first-party** (scripts intentionnels des projets de l'auteur/organisation) du **bruit** (scripts vendored de dépendances). Grille d'analyse à six dimensions, dérivée de FND-007-conventions-cli :
1. structure et robustesse (`set` flags, résolution de chemin, `trap`) ;
2. gestion des arguments et options ;
3. aide et version ;
4. usage des flux (stdout/stderr) ;
5. codes de sortie ;
6. conventions de nommage et découvrabilité (sous-commandes, extension `.sh`).

## Inventaire

Corpus first-party représentatif (hors bruit) :

- **Famille « presentation »** (pattern `activate` + `scripts/dev.sh`) : ce dépôt (`commission-scolaire-de-la-capitale`), `noumanity-formation/intentional-doers-governance`, `noumanity-formation/linux-pqc`, `archive/noumanity-linkedin`. CLI riche à sous-commandes.
- **`jvtrudel/script-template`** : `script.sh.template`, `scripts/init-script-template`, `scripts/setup`. Gabarit de script réutilisable.
- **CLI applicatives disruptiva** : `disruptiva-dev/nty`, `disruptiva-dev/disks-management` (diskm), `disruptiva-dev/devops-cli`, `disruptiva-dev/comm-cli`, `disruptiva-dev/deliverable-cli`.
- **Famille « cli-based-organization »** : `linux-inspect` (`bash/find-repos.sh`, `setup.sh`), `linux-cli-interface`, `raar`, `cli-doc-generation` ; `archive/cli-based-organisation_git-resource` (`lib/commands/*.sh`).
- **Scripts utilitaires divers** : `jvtrudel-copilot/git-multi-remote/*.sh`, `jvtrudel/ephemeral-vault/scripts/ephemeral-vault.sh`, `jvtrudel-exportech/jido/scripts/*.sh`, `nationtech/harmony/*.sh`.
- **Pattern `setup.sh` / `activate.sh`** : présent dans de nombreux dépôts (`nty`, `devops-cli`, `personal-journal`, `ticket-driven-ai`, `aws-finops-analysis`, etc.), généralement pour initialiser un environnement local.

Bruit exclu (volumineux) : `noumanity-infra/platform/ansible/.venv/**` (collections ansible), `orignal-bleu-finance/*/.venv/**` (site-packages Python), `alienware/leptos-rs/**` (exemples), `noumanity-formation/linux-pqc/workdir/cbomkit-theia/testdata/**` (fixtures).

## Constats

### 1. Structure et robustesse : hétérogène

- **Bonne pratique** : `scripts/dev.sh` (famille presentation) emploie `set -euo pipefail`, une résolution de racine robuste via `BASH_SOURCE` avec repli (`ROOT="${PRESENTATION_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"`), et une variable d'environnement d'ancrage posée par `. activate`.
- **Variante plus faible** : `jvtrudel/script-template/script.sh.template` emploie `set -eu` (sans `pipefail`), mais ajoute un `trap` sur EXIT signalant une terminaison anormale et un mode debug `-d` (`set -x`), absents ailleurs.
- **Écart** : beaucoup de petits `setup.sh` / `activate.sh` n'ont ni `set -euo pipefail` ni gestion d'erreur explicite.

### 2. Arguments et options : dispatch par `case`, peu d'options longues

- Le dispatch de sous-commandes se fait par `case "${1:-}" in ... esac`, aussi bien dans `dev.sh` (`gen`, `clean`, `model`, `diapo`, `qrcode`) que dans le template (`-h|--help|""` puis commandes).
- Les options longues GNU sont peu présentes hors `--help`. `dev.sh` accepte quelques flags (`--verbatim`, `--dev`, `--prod`, `--logo`, `--ratio`) mais l'analyse d'options groupées POSIX (`-abc`) et le terminateur `--` ne sont généralement pas gérés.

### 3. Aide et version : aide oui, version non

- **Bonne pratique** : `dev.sh` et `script.sh.template` fournissent `-h|--help`. Le template suit un format man-page (`NAME`, `SYNOPSYS`, `GLOBAL_OPTIONS`) ; `dev.sh` utilise un bloc d'usage en commentaire/heredoc listant chaque sous-commande.
- **Écart** : `--version` est quasi absent du corpus. Les formats d'aide divergent (man-style vs usage-commentaire).

### 4. Flux stdout/stderr : conscience partielle

- **Bonne pratique** : `activate` envoie les avertissements sur stderr (`echo "[WARN] ... " >&2`) et réserve stdout aux messages `[OK]`. Le template redirige son message de terminaison anormale sur stderr (`>&2 echo`).
- **Écart** : la séparation stricte « données sur stdout, diagnostics sur stderr » n'est pas systématique ; plusieurs scripts mélangent journal et sortie sur stdout.

### 5. Codes de sortie : minimalistes

- Le template sort `1` sur commande inconnue et `0` sur aide. `dev.sh` s'appuie sur `set -e` pour propager les échecs.
- **Écart** : pas de codes normalisés (usage vs erreur applicative) ; `2` pour erreur d'usage n'est pas employé ; `sysexits.h` n'est pas utilisé.

### 6. Nommage et découvrabilité : deux styles

- **Deux conventions coexistent** : scripts suffixés `.sh` (`dev.sh`, `setup.sh`, `find-repos.sh`) et entrypoints sans extension destinés au PATH (`init-script-template`, `nty`, `raar`). Le premier style expose l'implémentation ; le second imite une commande système.
- Le pattern `. activate` ajoutant `scripts/` au PATH est une bonne pratique de découvrabilité récurrente dans la famille presentation.
- Observation transverse : plusieurs dépôts (`cli-based-organization/*`, `noumanity-dev/cli-convention`, `linux-inspect`) partagent une structure de gouvernance (`CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md`, `skills/`) proche de ce dépôt, signe d'une famille de conventions méthodologiques en cours de convergence. Le dépôt `noumanity-dev/cli-convention` est dédié au sujet mais ne contient encore que le harnais, pas de convention rédigée.

## Confrontation à la référence (FND-007-conventions-cli)

| Dimension FND-007-conventions-cli | Meilleur exemple local | Écart dominant |
|---|---|---|
| Options POSIX (groupage, `--`) | partiel (`dev.sh`) | groupage et `--` non gérés |
| Options longues GNU | `--help`, quelques flags | rares hors help |
| `--help` / `--version` | help présent | version quasi absente ; formats divergents |
| stdout/stderr | `activate`, template | séparation non systématique |
| Codes de sortie | template (`0`/`1`) | pas de code d'usage `2`, rien de normalisé |
| Sous-commandes | `dev.sh` (git-like) | bon modèle, à généraliser |
| Robustesse bash | `dev.sh` (`set -euo pipefail`) | inconstant sur les petits scripts |

## Synthèse et recommandations

Le corpus contient deux références locales de qualité à capitaliser : le pattern **`activate` + `scripts/dev.sh`** (sous-commandes, `set -euo pipefail`, ancrage par variable d'environnement, stderr pour les diagnostics) et le **`script.sh.template`** (aide man-page, `trap`, mode debug). Les écarts récurrents à corriger par la convention :

1. **Uniformiser l'en-tête de robustesse** : `set -euo pipefail`, résolution de racine robuste, `trap` de nettoyage (priorité haute).
2. **Standardiser l'aide** : format unique, `--help/-h` et `--version` obligatoires (priorité haute).
3. **Imposer la séparation stdout (données) / stderr (diagnostics)** (priorité haute).
4. **Normaliser les codes de sortie** : `0` succès, `2` erreur d'usage, `1` (ou codes documentés) erreur applicative (priorité moyenne).
5. **Adopter le modèle sous-commandes** pour tout outil multi-fonctions, avec aide par sous-commande (priorité moyenne).
6. **Trancher la convention de nommage** : entrypoint sans extension exposé via PATH, `.sh` pour les scripts internes (priorité moyenne).

Ces recommandations constituent l'entrée directe d'ADR-002, SPEC-001 et REQ-001.

## Portée et péremption

Analyse de premier jet : couverture représentative, non exhaustive (le corpus first-party n'a pas été lu ligne à ligne ; échantillonnage des cas les plus significatifs). Les chemins et patterns reflètent l'état du système de fichiers au 2026-07-10 ; le corpus évolue, une revalidation est nécessaire si la convention doit s'appuyer sur des chiffres précis de couverture.
