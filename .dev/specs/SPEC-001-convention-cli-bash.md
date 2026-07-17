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

Cas d'erreur :
- sous-commande inconnue ou argument invalide : diagnostic sur stderr, sort 2.
- erreur applicative (dépendance manquante, opération échouée) : diagnostic sur stderr, sort 1 (ou code documenté).
- interruption : le `trap` nettoie les ressources temporaires et signale la terminaison anormale sur stderr.

## Interfaces

- **Shebang** : `#!/usr/bin/env bash`.
- **En-tête** : `set -euo pipefail`.
- **Options globales** : `--help`/`-h`, `--version` ; `--` termine les options.
- **Commandes et sous-commandes** : une **table de commandes déclarative** (tableau associatif `commande => description`, plus une liste d'ordre d'affichage) est l'**unique source de vérité** ; elle pilote à la fois le dispatch `case` et le rendu de l'aide. Un groupe possède sa propre table pour ses sous-commandes. Chaque commande, groupe et sous-commande accepte `-h`/`--help`.
- **Aide** : générée depuis les tables par une fonction de rendu unique (`_render_help`), jamais extraite par plage de numéros de ligne. Le format est identique aux trois niveaux (supérieur, groupe, sous-commande), garantissant l'uniformité (REQ-001-F8). Ajouter une entrée dans une table met à jour l'aide et le dispatch d'un seul geste.
- **Flux** : stdout = données ; stderr = diagnostics (helpers `_info`, `_warn`, `_err` écrivant sur stderr).
- **Codes de sortie** : `0` succès, `2` erreur d'usage, `1` erreur applicative (ou code documenté).

## Contraintes et garanties

- La racine est résolue via `BASH_SOURCE` et fonctionne quel que soit le répertoire d'appel.
- Toutes les expansions de variables sont quotées.
- L'aide et la version sont traitées avant toute logique métier.
- Le script est idempotent quant à la lecture (aucun effet de bord à l'import s'il est sourcé).
- Toute commande, tout groupe et toute sous-commande implémentés sont présents dans l'aide correspondante (découvrabilité, REQ-001-F7), car dispatch et aide dérivent de la même table.
- L'aide provient d'une source de vérité unique et d'un rendu unique ; elle ne peut pas dériver du comportement réel (uniformité, REQ-001-F8). Aucune extraction par plage de numéros de ligne.

## Exemples

Squelette de référence (structure minimale conforme). L'aide est **générée depuis des tables déclaratives** (source de vérité unique) : ajouter une entrée met à jour à la fois le dispatch et l'aide, sans plage de numéros de ligne à maintenir.

```bash
#!/usr/bin/env bash
# outil - <description courte>
set -euo pipefail

VERSION="0.1.0"
DESC="fait des choses utiles"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_info() { printf '%s\n' "$*" >&2; }
_warn() { printf '[WARN] %s\n' "$*" >&2; }
_err()  { printf '[ERR] %s\n' "$*" >&2; }
_cleanup() { :; }
trap '_cleanup' EXIT
trap '[ "$?" = "0" ] || _err "terminaison anormale"' EXIT

# Source de vérité unique du niveau supérieur : "commande => description".
# _*_ORDER fixe l'ordre d'affichage (les tableaux associatifs ne sont pas ordonnés).
_TOP_ORDER=(exemple grp)
declare -A _TOP_DESC=(
  [exemple]="fait quelque chose d'utile"
  [grp]="groupe de sous-commandes"
)

# _render_help USAGE ORDER_VAR DESC_VAR : rend une aide uniforme depuis une table.
# Utilisé à tous les niveaux (supérieur, groupe) : format identique partout.
_render_help() {
  printf '%s\n\nCommandes :\n' "$1"
  local -n _order="$2" _desc="$3"; local c
  for c in "${_order[@]}"; do printf '  %-16s %s\n' "$c" "${_desc[$c]}"; done
}

_help() { _render_help "$(printf 'outil - %s\n\nUsage : outil COMMANDE [options]' "$DESC")" _TOP_ORDER _TOP_DESC; }

cmd_exemple() {
  case "${1:-}" in
    -h|--help) printf 'Usage : outil exemple [options]\n  %s\n' "${_TOP_DESC[exemple]}"; return 0 ;;
  esac
  printf '%s\n' "resultat"   # données sur stdout
}

# Groupe : même patron, table propre => aide de groupe générée automatiquement.
_GRP_ORDER=(faire lister)
declare -A _GRP_DESC=(
  [faire]="exécute l'action"
  [lister]="liste les éléments"
)
cmd_grp() {
  case "${1:-}" in
    -h|--help|"") _render_help "Usage : outil grp SOUS-COMMANDE [options]" _GRP_ORDER _GRP_DESC; return 0 ;;
  esac
  local sub="$1"; shift
  [ -n "${_GRP_DESC[$sub]+x}" ] || { _err "sous-commande inconnue : $sub"; exit 2; }
  "cmd_grp_$sub" "$@"
}
cmd_grp_faire()  { printf 'fait\n'; }
cmd_grp_lister() { printf 'liste\n'; }

main() {
  case "${1:-}" in
    -h|--help|"") _help; exit 0 ;;
    --version)    printf '%s\n' "$VERSION"; exit 0 ;;
    *)
      local cmd="$1"; shift
      [ -n "${_TOP_DESC[$cmd]+x}" ] || { _err "commande inconnue : $cmd"; _help >&2; exit 2; }
      "cmd_$cmd" "$@"
      ;;
  esac
}

[ "$0" != "${BASH_SOURCE[0]}" ] || main "$@"
```

Propriétés garanties par ce patron : l'aide de niveau supérieur énumère toute la table `_TOP_*` ; l'aide de chaque groupe énumère sa table `_GRP_*` ; `_render_help` assure un format identique partout ; l'ajout d'une commande passe par la seule table, jamais par une plage de lignes.

## Traçabilité

| Élément spécifié | Requis satisfait |
|---|---|
| `--help`/`-h`, `_help` | REQ-001-F1 |
| `--version`, `VERSION` | REQ-001-F2 |
| dispatch `case` piloté par table | REQ-001-F3 |
| aide par sous-commande (`cmd_grp_*` avec `-h`) | REQ-001-F5 |
| branche par défaut -> exit 2 | REQ-001-F4 |
| `--` terminateur, options longues | REQ-001-F6 |
| tables `_TOP_*`/`_GRP_*` énumérées dans l'aide | REQ-001-F7 |
| `_render_help` unique, aucune plage de lignes | REQ-001-F8 |
| shebang + `set -euo pipefail` | REQ-001-NF1 |
| helpers `_info/_warn/_err` sur stderr | REQ-001-NF2 |
| quoting + `ROOT` via `BASH_SOURCE` | REQ-001-NF3 |
| codes 0/1/2 | REQ-001-NF4 |
| `trap _cleanup` | REQ-001-NF5 |
