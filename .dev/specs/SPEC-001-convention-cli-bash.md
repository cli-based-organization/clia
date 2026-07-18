# SPEC-001 - Spécification d'un CLI bash conforme

- **Date** : 2026-07-10
- **Requis couverts** : `REQ-001-convention-cli-bash`
- **Décisions applicables** : `ADR-002-convention-cli-bash`

## Objet et périmètre

Décrit la forme concrète d'un CLI bash conforme à la convention du dépôt : structure du fichier, dispatch des commandes et options, gestion des flux et des codes de sortie, squelette réutilisable. Hors périmètre : la logique métier propre à chaque outil.

## Comportement

Cas nominaux :
- `outil` ou `outil --help` ou `outil -h` : imprime l'usage sur stdout, sort 0. L'aide **énumère toutes les commandes et tous les groupes** connus (découvrabilité, REQ-001-F7).
- `outil --version` : imprime la version sur stdout, sort 0.
- `outil COMMANDE [options]` : exécute la commande ; sa sortie utile va sur stdout, ses diagnostics sur stderr ; sort 0 en cas de succès.
- `outil COMMANDE -h` / `outil COMMANDE --help` : imprime l'aide du groupe, qui **énumère toutes ses sous-commandes** (REQ-001-F7), au même format que l'aide de niveau supérieur (REQ-001-F8).
- `outil COMMANDE SOUS-COMMANDE -h` : imprime l'aide propre à la sous-commande (REQ-001-F5).
- `outil --man` : imprime l'aide longue (format manpage), générée depuis la même source documentaire (REQ-001-F8).
- Grammaire générale : `outil [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]` (REQ-001-F10). Les options globales (`--version`, `--config`, `-h/--help`, `--man`, `--debug`, `--dry-run`) sont traitées avant le dispatch et s'appliquent à toute commande ; `--debug` émet des traces sur stderr, `--dry-run` affiche le plan d'exécution sans effet de bord.

Cas d'erreur :
- sous-commande inconnue ou argument invalide : diagnostic sur stderr, sort 2.
- erreur applicative (dépendance manquante, opération échouée) : diagnostic sur stderr, sort 1 (ou code documenté).
- interruption : le `trap` nettoie les ressources temporaires et signale la terminaison anormale sur stderr.

## Interfaces

- **Shebang** : `#!/usr/bin/env bash`.
- **En-tête** : `set -euo pipefail`.
- **Options globales** : `--help`/`-h`, `--man`, `--version`, et les options globales standard `--debug`, `--dry-run` ; `--` termine les options. Traitées avant le dispatch selon la grammaire `outil [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]` (REQ-001-F10).
- **Source de vérité documentaire** : un fichier YAML compagnon (`<outil>.doc.yaml`) à documentation **atomique** est l'**unique source** de la documentation : une entrée par commande et sous-commande (nom, description courte, description longue, usage, options). C'est la seule source à éditer pour documenter une commande.
- **Aide générée à la volée** : l'aide courte (`-h`, à tous les niveaux) et l'aide longue (`--man`) sont produites au runtime depuis la source YAML via deux templates (rendu bash paramétré), jamais extraites par plage de numéros de ligne. Le format est identique aux trois niveaux (supérieur, groupe, sous-commande), garantissant l'uniformité (REQ-001-F8). Le lecteur YAML est `yq` (implémentation mikefarah), déclaré comme dépendance et vérifié au runtime.
- **Cohérence dispatch / documentation** : le dispatch valide chaque commande contre la source YAML (une commande n'est dispatchée que si elle est documentée) ; un auto-test vérifie réciproquement que toute commande documentée possède un handler (REQ-001-F9).
- **Flux** : stdout = données ; stderr = diagnostics (helpers `_info`, `_warn`, `_err` écrivant sur stderr).
- **Codes de sortie** : `0` succès, `2` erreur d'usage, `1` erreur applicative (ou code documenté).

## Contraintes et garanties

- La racine est résolue via `BASH_SOURCE` et fonctionne quel que soit le répertoire d'appel.
- Toutes les expansions de variables sont quotées.
- L'aide et la version sont traitées avant toute logique métier.
- Le script est idempotent quant à la lecture (aucun effet de bord à l'import s'il est sourcé).
- Toute commande, tout groupe et toute sous-commande implémentés sont présents dans l'aide correspondante (découvrabilité, REQ-001-F7), car le dispatch valide contre la source documentaire et un auto-test couvre la réciproque (cohérence, REQ-001-F9).
- L'aide provient d'une source de vérité documentaire unique (YAML) et de templates de rendu uniques ; le format est identique aux trois niveaux (uniformité, REQ-001-F8). Aucune extraction par plage de numéros de ligne. Le lecteur YAML `yq` est vérifié au runtime (dépendance déclarée).

## Exemples

Le mécanisme de référence repose sur **deux ingrédients** : une source de vérité documentaire YAML et des templates de rendu bash. L'aide est générée à la volée ; documenter une commande ne demande que d'éditer le YAML.

Source YAML compagnon (`outil.doc.yaml`), documentation atomique :

```yaml
tool: outil
short: fait des choses utiles
long: outil réalise les opérations X et Y de façon déterministe.
global_options:
  - { flag: "-h, --help", short: "affiche l'aide courte" }
  - { flag: "--man",       short: "affiche l'aide longue" }
  - { flag: "--version",   short: "affiche la version" }
  - { flag: "--debug",     short: "informations de débogage" }
  - { flag: "--dry-run",   short: "affiche le plan d'exécution sans effet" }
commands:
  - name: exemple
    short: "fait quelque chose d'utile"
    usage: "outil exemple [options]"
    long: "Description longue de la commande exemple."
  - name: grp
    short: "groupe de sous-commandes"
    usage: "outil grp SOUS-COMMANDE [options]"
    subcommands:
      - { name: faire,  short: "exécute l'action", usage: "outil grp faire [options]" }
      - { name: lister, short: "liste les éléments", usage: "outil grp lister" }
```

Templates de rendu et dispatch (extrait de référence ; `yq` = mikefarah) :

```bash
#!/usr/bin/env bash
# outil - fait des choses utiles
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOC="$ROOT/outil.doc.yaml"
DRY_RUN=0; DEBUG=0

_err()  { printf '[ERR] %s\n' "$*" >&2; }
_die()  { _err "$1"; exit "${2:-1}"; }
_dbg()  { [ "$DEBUG" = 1 ] && printf '[DBG] %s\n' "$*" >&2 || true; }
_require_yq() { command -v yq >/dev/null || _die "dépendance manquante : yq (mikefarah)" 1; }

# Template « liste » : rend "  nom  description" depuis des paires nom<TAB>desc.
_render_list() { local n d; while IFS=$'\t' read -r n d; do printf '  %-16s %s\n' "$n" "$d"; done; }

_help() {  # template court, niveau supérieur
  _require_yq
  printf '%s - %s\n\nUsage : %s [OPTIONS_GLOBALES] COMMANDE [OPTIONS]\n\n' \
    "$(yq -r '.tool' "$DOC")" "$(yq -r '.short' "$DOC")" "$(yq -r '.tool' "$DOC")"
  printf 'Options globales :\n'; yq -r '.global_options[] | .flag + "\t" + .short' "$DOC" | _render_list
  printf '\nCommandes :\n';       yq -r '.commands[] | .name + "\t" + .short' "$DOC" | _render_list
}
_help_group() {  # template court, niveau groupe
  _require_yq
  printf 'Usage : %s\n\nCommandes :\n' "$(yq -r ".commands[]|select(.name==\"$1\").usage" "$DOC")"
  yq -r ".commands[]|select(.name==\"$1\").subcommands[] | .name + \"\t\" + .short" "$DOC" | _render_list
}
_man() {  # template long depuis la même source
  _require_yq
  printf 'NOM\n    %s - %s\n\nDESCRIPTION\n    %s\n' \
    "$(yq -r '.tool' "$DOC")" "$(yq -r '.short' "$DOC")" "$(yq -r '.long' "$DOC")"
}
_doc_commands() { yq -r '.commands[].name' "$DOC"; }  # inventaire documenté (cohérence)

main() {
  # 1) options globales avant le dispatch (grammaire GLOBAL_OPTIONS COMMAND OPTIONS)
  while [ $# -gt 0 ]; do case "$1" in
    -h|--help|"") _help; exit 0 ;;
    --man)        _man;  exit 0 ;;
    --debug)      DEBUG=1; shift ;;
    --dry-run)    DRY_RUN=1; shift ;;
    --) shift; break ;;
    -*) _die "option inconnue : $1" 2 ;;
    *) break ;;
  esac; done
  [ $# -gt 0 ] || { _help; exit 0; }
  # 2) dispatch validé contre la source (cohérence : dispatché => documenté)
  local cmd="$1"; shift
  _doc_commands | grep -qx "$cmd" || { _err "commande inconnue : $cmd"; _help >&2; exit 2; }
  "cmd_$cmd" "$@"
}
[ "$0" != "${BASH_SOURCE[0]}" ] || main "$@"
```

Propriétés garanties : `_help`/`_help_group`/`_man` énumèrent la source YAML (découvrabilité, uniformité) ; documenter une commande n'exige que d'éditer le YAML ; le dispatch ne sert une commande que si elle est documentée (cohérence, REQ-001-F9), la réciproque étant couverte par un auto-test comparant `_doc_commands` aux fonctions `cmd_*` définies.

## Traçabilité

| Élément spécifié | Requis satisfait |
|---|---|
| `--help`/`-h`, `_help` | REQ-001-F1 |
| `--version`, `VERSION` | REQ-001-F2 |
| dispatch `case` piloté par table | REQ-001-F3 |
| aide par sous-commande (rendu depuis `.subcommands[]`) | REQ-001-F5 |
| branche par défaut -> exit 2 | REQ-001-F4 |
| `--` terminateur, options longues | REQ-001-F6 |
| source YAML énumérée par `_help`/`_help_group`/`_man` | REQ-001-F7 |
| source YAML + templates uniques, aucune plage de lignes | REQ-001-F8 |
| dispatch validé contre `_doc_commands` + auto-test | REQ-001-F9 |
| options globales avant dispatch (`--debug`, `--dry-run`) | REQ-001-F10 |
| shebang + `set -euo pipefail` | REQ-001-NF1 |
| helpers `_info/_warn/_err` sur stderr | REQ-001-NF2 |
| quoting + `ROOT` via `BASH_SOURCE` | REQ-001-NF3 |
| codes 0/1/2 | REQ-001-NF4 |
| `trap _cleanup` | REQ-001-NF5 |
