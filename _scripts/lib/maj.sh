# shellcheck shell=bash
# _scripts/lib/maj.sh — les versions disponibles, et comment aller de l'une à
# l'autre.
#
# Implémente SES-001 tâche 17.
#
# Ce que « disponible » veut dire
# -------------------------------
#
# Une version est disponible quand un commit la déclare. Il n'y a pas de
# registre ailleurs, ni d'étiquettes : SES-001 tâche 2 pose que la
# publication n'en met aucune, et la source de vérité d'une version est le
# commit. Les versions disponibles se lisent donc dans l'historique — celui
# du dépôt source de clia pour clia, celui d'une extension pour ses
# ressources.
#
# C'est aussi ce qui borne l'offre honnêtement : clia ne peut proposer que
# les versions dont il a l'historique sous la main. Une version publiée
# ailleurs et jamais tirée n'existe pas ici, et le dire vaut mieux que la
# promettre.
#
# Aller à une version
# -------------------
#
# En extrayant du commit qui la déclare le sous-arbre concerné. Rien n'est
# reconstruit : ce qui est posé est exactement ce que ce commit portait.

# --------------------------------------------------------------------------
# Comparer deux alias
# --------------------------------------------------------------------------
#
# Les trois nombres, dans l'ordre. Le tag de pré-publication n'est pas
# comparé : clia ne publie pas de pré-version, et ordonner « 1.0.0-beta »
# par rapport à « 1.0.0 » demanderait une règle que rien ici n'emploie.

# _clia_m_comparer <a> <b> — imprime -1, 0 ou 1. Échoue si l'un n'est pas
# sémantique.
_clia_m_comparer() {
  local a="$1" b="$2" i x y
  _clia_v_est_semantique "$a" || return 1
  _clia_v_est_semantique "$b" || return 1
  a="${a#v}"; a="${a%%-*}"
  b="${b#v}"; b="${b%%-*}"
  for i in 1 2 3; do
    x=$(printf '%s' "$a" | cut -d. -f"$i")
    y=$(printf '%s' "$b" | cut -d. -f"$i")
    if (( 10#$x < 10#$y )); then printf '%s\n' '-1'; return 0; fi
    if (( 10#$x > 10#$y )); then printf '%s\n' '1';  return 0; fi
  done
  printf '%s\n' '0'
  return 0
}

# --------------------------------------------------------------------------
# Les versions qu'un historique porte
# --------------------------------------------------------------------------

# _clia_m_versions <racine> <chemin de la définition> — « version<TAB>commit »,
# de la plus ancienne à la plus récente, une seule ligne par version.
#
# Le commit retenu pour une version est celui qui l'a introduite : c'est là
# que se trouve l'état publié sous ce numéro. Les commits suivants qui la
# portent encore sont du travail sur cette version, non cette version.
_clia_m_versions() {
  local racine="$1" def="$2" commit alias precedent=''
  [[ -d "$racine/.git" ]] || [[ -f "$racine/.git" ]] || return 0
  while IFS= read -r commit; do
    [[ -n "$commit" ]] || continue
    alias=$(_clia_v_alias_au_commit "$racine" "$commit" "$def") || continue
    [[ -n "$alias" && "$alias" != "$precedent" ]] || { precedent="$alias"; continue; }
    printf '%s\t%s\n' "$alias" "$commit"
    precedent="$alias"
    # « --follow » : la disposition des ressources a changé, et sans lui
    # l'historique d'une définition s'arrêterait à son déplacement.
    #
    # L'ordre est retourné par tac, et non par « --reverse ». Les deux
    # options ne se combinent pas : « git log --follow --reverse » ne rend
    # qu'un seul commit, et l'historique d'une ressource paraissait alors
    # s'arrêter à sa première version. Constaté le 2026-09-03 sur git 2.39.
  done < <(git -C "$racine" log --follow --format=%H -- "$def" 2>/dev/null | tac)
  return 0
}

# _clia_m_derniere <racine> <def> — la version la plus récemment déclarée.
#
# C'est celle que porte le fichier au dernier commit qui l'a touché, donc
# celle qu'il porte à HEAD. La lire là coûte un « git show » ; la déduire du
# parcours complet en coûte un par commit, et rend la même chose.
#
# Le parcours reste, pour le cas où le fichier n'est pas à HEAD : déplacé,
# retiré, ou jamais commité à cet emplacement. Il rend alors ce que
# l'historique déclare encore, ou rien.
_clia_m_derniere() {
  local v c derniere=''
  if derniere=$(_clia_v_alias_au_commit "$1" HEAD "$2" 2>/dev/null) \
     && [[ -n "$derniere" ]]; then
    printf '%s\n' "$derniere"
    return 0
  fi
  derniere=''
  while IFS=$'\t' read -r v c; do
    [[ -n "$v" ]] && derniere="$v"
  done < <(_clia_m_versions "$1" "$2")
  [[ -n "$derniere" ]] || return 1
  printf '%s\n' "$derniere"
}

# _clia_m_commit_de <racine> <def> <version> — le commit qui l'a introduite.
_clia_m_commit_de() {
  local cible="$3" v c
  while IFS=$'\t' read -r v c; do
    [[ "$v" == "$cible" ]] && { printf '%s\n' "$c"; return 0; }
  done < <(_clia_m_versions "$1" "$2")
  return 1
}

# --------------------------------------------------------------------------
# Extraire un sous-arbre à un commit
# --------------------------------------------------------------------------

# _clia_m_extraire <racine> <commit> <sous-chemin> <destination>
#
# Le sous-arbre est extrait dans un temporaire avant d'être posé : une
# extraction qui échoue à mi-chemin ne doit pas laisser la destination à
# moitié remplacée.
_clia_m_extraire() {
  local racine="$1" commit="$2" chemin="$3" dest="$4" tmp
  tmp=$(mktemp -d) || return 1
  if ! git -C "$racine" archive "$commit" -- "$chemin" 2>/dev/null | tar -x -C "$tmp" 2>/dev/null; then
    rm -rf "$tmp"
    return 1
  fi
  if [[ ! -e "$tmp/$chemin" ]]; then
    rm -rf "$tmp"
    return 1
  fi
  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"
  mv "$tmp/$chemin" "$dest"
  rm -rf "$tmp"
  return 0
}

# _clia_m_fichier_au_commit <racine> <commit> <chemin> — son contenu.
_clia_m_fichier_au_commit() {
  git -C "$1" show "$2:$3" 2>/dev/null
}

# --------------------------------------------------------------------------
# Les migrations d'instances
# --------------------------------------------------------------------------
#
# SES-001 tâche 17 : toute ressource porte un verbe « migrate », et chaque
# nouvelle version doit fournir son script de migration.
#
#   <instance>/livrables/migrations/<de>-<vers>.sh
#
# Un script par saut, et non un par couple de versions éloignées : aller de
# 0.1.0 à 0.4.0 enchaîne les sauts que l'historique déclare. C'est ce qui
# permet d'en ajouter un sans réécrire les précédents.
#
# Ils se lisent dans l'extension, non dans la copie du dépôt : le script d'un
# saut arrive avec la version qui l'introduit, et la copie est par définition
# à la version qu'on quitte. Voir _clia_mj_migrations_de.
#
# Le verbe est tenu par le point d'entrée, pour toutes les ressources : ce
# qu'une ressource écrit est le script, pas le mécanisme qui l'appelle.

# _clia_m_sauts <racine> <def> <de> <vers> — les versions traversées, dans
# l'ordre du parcours. Le sens est déduit de la comparaison.
_clia_m_sauts() {
  local racine="$1" def="$2" de="$3" vers="$4" sens v c liste=() i
  sens=$(_clia_m_comparer "$de" "$vers") || return 1
  [[ "$sens" == '0' ]] && return 0

  while IFS=$'\t' read -r v c; do
    [[ -n "$v" ]] && liste+=("$v")
  done < <(_clia_m_versions "$racine" "$def")

  if [[ "$sens" == '-1' ]]; then
    for v in "${liste[@]}"; do
      [[ "$(_clia_m_comparer "$v" "$de")"   == '1' ]] || continue
      [[ "$(_clia_m_comparer "$v" "$vers")" == '1' ]] && continue
      printf '%s\n' "$v"
    done
  else
    for (( i = ${#liste[@]} - 1; i >= 0; i-- )); do
      v="${liste[i]}"
      [[ "$(_clia_m_comparer "$v" "$de")"   == '-1' ]] || continue
      [[ "$(_clia_m_comparer "$v" "$vers")" == '-1' ]] && continue
      printf '%s\n' "$v"
    done
  fi
  return 0
}

# _clia_m_script_migration <dir> <de> <vers> — le script du saut, ou rien.
_clia_m_script_migration() {
  local f="$1/$2-$3.sh"
  [[ -f "$f" ]] && printf '%s\n' "$f"
}
