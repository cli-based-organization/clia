# shellcheck shell=bash
# _scripts/lib/commun.sh — ce que le point d'entrée et les commandes partagent.
#
# Ce fichier ne fait aucune action : il déclare des emplacements et des
# fonctions de lecture. Le sourcer ne modifie ni le shell, ni le disque.
#
# Tout ce qui est déclaré ici porte le préfixe _clia_, pour qu'un shell
# interactif qui l'aurait sourcé puisse tout retirer d'un coup. Un shell ne
# doit rien garder de clia qu'il n'ait demandé.
#
# Il est volontairement court. La génération précédente y avait accumulé 756
# lignes ; ce qui suit est ce dont la première commande a besoin, et rien de
# plus. Il grandira quand une commande le demandera, pas avant.

# --------------------------------------------------------------------------
# Sortie
# --------------------------------------------------------------------------
#
# Tout passe par l'erreur standard, sauf ce qu'un programme viendrait lire.
# Un message dit ce qui s'est produit, puis ce que le lecteur peut faire
# ensuite : un constat sans suite oblige à deviner.

_clia_msg()    { printf '%s: %s\n' "${_CLIA_NOM:-clia}" "$*" >&2; }
_clia_detail() { printf '%*s  %s\n' "${#_CLIA_NOM}" '' "$*" >&2; }

# --------------------------------------------------------------------------
# Le dépôt
# --------------------------------------------------------------------------

# Racine du dépôt git contenant un répertoire. Échoue s'il n'y en a pas.
_clia_depot_git() {
  git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null
}

# --------------------------------------------------------------------------
# La carte du dépôt
# --------------------------------------------------------------------------
#
# La carte est le fichier qui déclare ce que le dépôt est. SES-001 tâche 1 en
# nomme trois emplacements possibles sans trancher entre eux : les trois sont
# donc cherchés, dans l'ordre ci-dessous, et le premier trouvé l'emporte.
#
# Cet ordre est une convention de lecture, pas une décision. Fixer
# l'emplacement de la carte appartient à l'humain ; tant qu'il ne l'a pas
# fait, chercher aux trois endroits vaut mieux que d'en supposer un.
#
# Les chemins sont relatifs à la racine du dépôt, parce que c'est sous cette
# forme que git les lit dans un commit passé — voir _clia_version_au_commit.

_CLIA_CARTE_EMPLACEMENTS=('clia.yaml' '.clia.yaml' '.dev/clia.yaml')

# Le chemin, relatif à la racine, de la carte du dépôt de travail. Rien si
# aucun des trois emplacements n'est occupé.
_clia_carte_relative() {
  local depot="$1" emplacement
  for emplacement in "${_CLIA_CARTE_EMPLACEMENTS[@]}"; do
    if [[ -f "$depot/$emplacement" ]]; then
      printf '%s\n' "$emplacement"
      return 0
    fi
  done
  return 1
}

# Le chemin absolu de la carte, ou rien.
_clia_carte() {
  local depot="$1" relative
  relative=$(_clia_carte_relative "$depot") || return 1
  printf '%s/%s\n' "$depot" "$relative"
}

# --------------------------------------------------------------------------
# Lecture d'un champ de la carte
# --------------------------------------------------------------------------
#
# La carte est du YAML, et clia le lit sans dépendre d'un analyseur YAML : la
# portabilité vaut ici plus que la généralité, et les champs lus sont des
# scalaires de premier niveau.
#
# Le motif exige la colonne zéro. C'est ce qui distingue le champ « version »
# du dépôt des champs « version » imbriqués sous « use: », qui sont indentés
# et désignent la version d'une ressource, non celle du dépôt.

# _clia_champ_yaml <fichier> <champ> — la valeur, ou rien.
_clia_champ_yaml() {
  local fichier="$1" champ="$2" ligne
  [[ -f "$fichier" ]] || return 1
  ligne=$(grep -m1 -E "^${champ}:[[:space:]]" "$fichier" 2>/dev/null) || return 1
  printf '%s\n' "$(_clia_valeur_yaml "${ligne#*:}")"
}

# La valeur d'un champ, débarrassée de ses espaces, de ses guillemets et d'un
# commentaire de fin de ligne.
_clia_valeur_yaml() {
  local brut="$1"
  brut="${brut%%#*}"
  brut="$(printf '%s' "$brut" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
  brut="${brut%\"}"; brut="${brut#\"}"
  brut="${brut%\'}"; brut="${brut#\'}"
  printf '%s\n' "$brut"
}
