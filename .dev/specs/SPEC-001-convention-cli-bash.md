# SPEC-001 - Spécification d'un CLI bash conforme

- **Date** : 2026-07-10
- **Requis couverts** : `REQ-001-convention-cli-bash`
- **Décisions applicables** : `ADR-002-convention-cli-bash`

## Objet et périmètre

Décrit la forme concrète d'un CLI bash conforme à la convention du dépôt : structure du fichier, dispatch des commandes et options, gestion des flux et des codes de sortie, squelette réutilisable. Hors périmètre : la logique métier propre à chaque outil.

## Comportement

Cas nominaux :
- `outil` ou `outil --help` ou `outil -h` : imprime l'usage sur stdout, sort 0.
- `outil --version` : imprime la version sur stdout, sort 0.
- `outil COMMANDE [options]` : exécute la sous-commande ; sa sortie utile va sur stdout, ses diagnostics sur stderr ; sort 0 en cas de succès.

Cas d'erreur :
- sous-commande inconnue ou argument invalide : diagnostic sur stderr, sort 2.
- erreur applicative (dépendance manquante, opération échouée) : diagnostic sur stderr, sort 1 (ou code documenté).
- interruption : le `trap` nettoie les ressources temporaires et signale la terminaison anormale sur stderr.

## Interfaces

- **Shebang** : `#!/usr/bin/env bash`.
- **En-tête** : `set -euo pipefail`.
- **Options globales** : `--help`/`-h`, `--version` ; `--` termine les options.
- **Sous-commandes** : dispatch par `case` sur le premier opérande ; chaque sous-commande accepte `--help`.
- **Flux** : stdout = données ; stderr = diagnostics (helpers `_info`, `_warn`, `_err` écrivant sur stderr).
- **Codes de sortie** : `0` succès, `2` erreur d'usage, `1` erreur applicative (ou code documenté).

## Contraintes et garanties

- La racine est résolue via `BASH_SOURCE` et fonctionne quel que soit le répertoire d'appel.
- Toutes les expansions de variables sont quotées.
- L'aide et la version sont traitées avant toute logique métier.
- Le script est idempotent quant à la lecture (aucun effet de bord à l'import s'il est sourcé).

## Exemples

Squelette de référence (structure minimale conforme) :

```bash
#!/usr/bin/env bash
# outil - <description courte>
#
# Usage :
#   outil COMMANDE [options]
#   outil --help | -h        affiche cette aide
#   outil --version          affiche la version
set -euo pipefail

VERSION="0.1.0"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_info() { printf '%s\n' "$*" >&2; }
_warn() { printf '[WARN] %s\n' "$*" >&2; }
_err()  { printf '[ERR] %s\n' "$*" >&2; }
_cleanup() { :; }
trap '_cleanup' EXIT
trap '[ "$?" = "0" ] || _err "terminaison anormale"' EXIT

_usage() {
  sed -n '2,6p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

cmd_exemple() {
  # sortie utile sur stdout
  printf '%s\n' "resultat"
}

main() {
  case "${1:-}" in
    -h|--help|"") _usage; exit 0 ;;
    --version)    printf '%s\n' "$VERSION"; exit 0 ;;
    exemple)      shift; cmd_exemple "$@" ;;
    *)            _err "commande inconnue : ${1}"; _usage >&2; exit 2 ;;
  esac
}

[ "$0" != "${BASH_SOURCE[0]}" ] || main "$@"
```

## Traçabilité

| Élément spécifié | Requis satisfait |
|---|---|
| `--help`/`-h`, `_usage` | REQ-001-F1 |
| `--version`, `VERSION` | REQ-001-F2 |
| dispatch `case` sous-commandes | REQ-001-F3, REQ-001-F5 |
| branche `*)` -> exit 2 | REQ-001-F4 |
| `--` terminateur, options longues | REQ-001-F6 |
| shebang + `set -euo pipefail` | REQ-001-NF1 |
| helpers `_info/_warn/_err` sur stderr | REQ-001-NF2 |
| quoting + `ROOT` via `BASH_SOURCE` | REQ-001-NF3 |
| codes 0/1/2 | REQ-001-NF4 |
| `trap _cleanup` | REQ-001-NF5 |
