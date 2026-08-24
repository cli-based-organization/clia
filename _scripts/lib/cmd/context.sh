#!/usr/bin/env bash
# Description: D'où vient le code employé, et sur quel dépôt il travaille.
# Périmètre: dépôt
#
# La différence entre les deux modes d'installation est invisible tant
# qu'aucune commande ne l'expose. Celle-ci l'expose, et sert de point de
# contrôle à l'humain comme au banc de tests.

set -uo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

case "${1:-}" in
  -h|--help|help)
    cat <<'EOF'
Usage : clia context

Rapporte le contexte d'exécution : la version, le mode d'installation, le
chemin de l'exécutable, le dépôt d'où vient le code, et le dépôt sur lequel
la commande travaille.
EOF
    exit 0 ;;
  '') ;;
  *)
    _clia_msg "context ne prend pas d'argument : $1"
    exit 2 ;;
esac

printf 'version         %s\n' "$_CLIA_VERSION"
printf 'mode            %s\n' "$(_clia_mode_constate)"
printf 'exécutable      %s\n' "${CLIA_EXECUTABLE:-inconnu}"
printf 'dépôt source    %s\n' "$CLIA_SOURCE_DIR"
printf 'dépôt courant   %s\n' "$CLIA_WORK_DIR"
