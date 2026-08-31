# shellcheck shell=bash
# _scripts/lib/commun.sh — ce que setup.sh et le CLI partagent.
#
# Ce fichier est sourcé par les deux, et par rien d'autre. Il ne fait aucune
# action : il déclare la version, les emplacements, et les fonctions de
# lecture. Le fait de le sourcer ne modifie ni le shell, ni le disque.
#
# Tout ce qui est déclaré ici porte le préfixe _clia_, pour que setup.sh
# puisse retirer l'ensemble du shell de l'utilisateur après usage — voir la
# section « nettoyage » de setup.sh. Un shell interactif ne doit rien garder
# de clia qu'il n'ait demandé.

_CLIA_VERSION='0.1.0'

# --------------------------------------------------------------------------
# Emplacements
# --------------------------------------------------------------------------
#
# CLIA_BIN_DIR et XDG_CONFIG_HOME permettent de déplacer l'installation sans
# toucher au code : le banc de tests s'en sert pour installer dans un HOME
# jetable plutôt que dans celui de l'utilisateur.

_clia_bin_dir() {
  printf '%s\n' "${CLIA_BIN_DIR:-$HOME/.local/bin}"
}

_clia_lien() {
  printf '%s/clia\n' "$(_clia_bin_dir)"
}

_clia_config_dir() {
  printf '%s/clia\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

_clia_config_fichier() {
  printf '%s/install.conf\n' "$(_clia_config_dir)"
}

# --------------------------------------------------------------------------
# Le fichier d'installation
# --------------------------------------------------------------------------
#
# Format clé=valeur, une paire par ligne. Il est lu par extraction et jamais
# par sourcing : un fichier de configuration ne doit pas pouvoir exécuter du
# code. Le mode --activate n'écrit pas ce fichier ; il est éphémère par
# définition, et laisser une trace sur le disque le rendrait durable.

_clia_config_valeur() {
  local cle="$1" fichier
  fichier=$(_clia_config_fichier)
  [[ -f "$fichier" ]] || return 1
  local ligne
  ligne=$(grep -m1 "^${cle}=" "$fichier" 2>/dev/null) || return 1
  printf '%s\n' "${ligne#*=}"
}

_clia_config_existe() {
  [[ -f "$(_clia_config_fichier)" ]]
}

# --------------------------------------------------------------------------
# Résolution de chemins
# --------------------------------------------------------------------------

# Répertoire réel d'un fichier, les liens symboliques suivis jusqu'au bout.
# bin/clia est atteint par un lien en mode --dev : sans cette résolution, il
# chercherait ses modules dans ~/.local/bin.
_clia_dir_reel() {
  local src="$1" dir
  while [[ -L "$src" ]]; do
    dir=$(cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)
    src=$(readlink "$src")
    [[ "$src" != /* ]] && src="$dir/$src"
  done
  (cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)
}

# Racine du dépôt git contenant un répertoire. Échoue s'il n'y en a pas.
_clia_depot_git() {
  git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null
}

# --------------------------------------------------------------------------
# Sortie
# --------------------------------------------------------------------------
#
# Tout passe par l'erreur standard sauf ce qu'un programme viendrait lire.
# PDC-004 : un message nomme ce qui s'est produit, puis ce que l'humain peut
# faire ensuite. Un message qui constate sans indiquer la suite oblige le
# lecteur à deviner.

_clia_msg()    { printf '%s: %s\n' "${_CLIA_NOM:-clia}" "$*" >&2; }
_clia_detail() { printf '%*s  %s\n' "${#_CLIA_NOM}" '' "$*" >&2; }

# --------------------------------------------------------------------------
# Les ressources
# --------------------------------------------------------------------------
#
# Ce que clia sait installer vit dans son dépôt source, et ce qu'il installe
# va dans le dépôt de travail. noumanity-wiki, d'où ces commandes sont
# reprises, confondait les deux : son CLI n'instrumentait que son propre
# dépôt. clia instrumente n'importe quel dépôt git, ce qui oblige à nommer
# les deux côtés séparément.
#
# REQ-002 range chaque ressource sous _ressources/<nom>/, avec ses scripts,
# ses primitives, ses templates et ses schémas. Ces trois fonctions sont le
# seul endroit qui connaît cette disposition.

_clia_ressource_dir() { printf '%s/_ressources/%s\n' "${CLIA_SOURCE_DIR:-}" "$1"; }

# Les fichiers d'un concept rattaché, pour toutes les ressources d'un dépôt.
# SPC-001 S6 : il n'y a pas de catalogue central, un concept vit sous la
# ressource dont il relève. Deux motifs, parce qu'une ressource peut vivre
# sous une catégorie.
#
# Sortie : « nom<TAB>ressource<TAB>fichier », triée par nom.
_clia_concept_partout() {
  local depot="$1" concept="$2" f nom ressource
  local base="$depot/_ressources"
  for f in "$base"/*/"$concept"/*.md "$base"/*/*/"$concept"/*.md; do
    [[ -f "$f" ]] || continue
    nom=$(basename "$f" .md)
    # Le nom qualifié de la ressource : ce qui suit _ressources/ jusqu'au
    # répertoire du concept.
    ressource="${f#"$base"/}"
    ressource="${ressource%/"$concept"/*}"
    printf '%s\t%s\t%s\n' "$nom" "$ressource" "$f"
  done | sort -t"$(printf '\t')" -k1,1
  return 0
}

# Le fichier qui porte un concept nommé dans un dépôt, ou rien.
_clia_concept_fichier() {
  _clia_concept_partout "$1" "$2" \
    | awk -F'\t' -v n="$3" '$1 == n && !trouve { print $3; trouve = 1 }'
}

# --------------------------------------------------------------------------
# Les remotes
# --------------------------------------------------------------------------
#
# Un remote est un dépôt d'où le dépôt courant peut reprendre des ressources,
# des skills et des fonctionnalités. USE-005.
#
# Il n'y en a qu'un aujourd'hui, le dépôt source de clia. USE-006 en ajoutera
# d'autres, déclarés comme extensions et identifiés par leur namespace : c'est
# pour cela que cette fonction rend une liste et que les commandes filtrent
# par namespace plutôt que de tenir le dépôt source pour acquis.
#
# Sortie : « namespace<TAB>chemin ».
_clia_remotes() {
  local ns nom chemin
  # Un dépôt n'est pas son propre remote : dans le dépôt source de clia, il
  # n'y a donc rien à reprendre, tout y est déjà.
  if [[ "$CLIA_SOURCE_DIR" != "${CLIA_WORK_DIR:-}" ]]; then
    ns=$(_clia_carte_champ "$CLIA_SOURCE_DIR" namespace 2>/dev/null || printf '')
    printf '%s\t%s\n' "${ns:-—}" "$CLIA_SOURCE_DIR"
  fi
  # Les extensions déclarées par le dépôt, et effectivement clonées. Une
  # extension déclarée mais absente du cache n'est pas un remote : il n'y a
  # rien à y lire. USE-006 le nomme « not installed ».
  # L'URI n'est pas lue ici : ce qui compte est le namespace, qui nomme le
  # cache. L'URI ne sert qu'à rétablir un clone manquant.
  while IFS=$'\t' read -r nom _; do
    [[ -n "$nom" ]] || continue
    chemin=$(_clia_extension_cache "$nom")
    [[ -d "$chemin" ]] && printf '%s\t%s\n' "$nom" "$chemin"
  done < <(_clia_extensions_declarees)
  return 0
}

# --------------------------------------------------------------------------
# Les extensions
# --------------------------------------------------------------------------
#
# Une extension est un dépôt clia dont le dépôt courant reprend des
# ressources. USE-006.
#
# Deux choses, et deux endroits :
#
#   la déclaration  .dev/extensions.yaml du dépôt, versionnée. Elle dit d'où
#                   vient l'extension, et elle suit le dépôt quand il est
#                   cloné ailleurs.
#   le clone        un cache de la machine, hors du dépôt. C'est un artefact
#                   local : le versionner reviendrait à vendre le dépôt d'un
#                   autre avec le sien.
#
# De là vient le statut que USE-006 demande : déclarée et clonée, ou déclarée
# seulement.

_clia_extensions_cache_dir() {
  printf '%s/clia/extensions\n' "${XDG_CACHE_HOME:-$HOME/.cache}"
}

_clia_extension_cache() {
  printf '%s/%s\n' "$(_clia_extensions_cache_dir)" "$1"
}

# Les extensions que porte un ancien .dev/extensions.yaml, s'il existe.
# Sortie : « namespace<TAB>uri ». Lue à part parce que clia check --fix la
# fond dans l'inventaire : il lui faut l'ancien fichier seul, non le cumul.
_clia_extensions_ancien_fichier() {
  local ancien="$1"
  [[ -f "$ancien" ]] || return 0
  awk '
    /^[[:space:]]*-[[:space:]]*namespace:[[:space:]]*/ {
      sub(/^[[:space:]]*-[[:space:]]*namespace:[[:space:]]*/, "")
      gsub(/"/, ""); ns = $0; next
    }
    /^[[:space:]]+uri:[[:space:]]*/ {
      sub(/^[[:space:]]+uri:[[:space:]]*/, "")
      gsub(/"/, "")
      if (ns != "") { print ns "\t" $0; ns = "" }
    }
  ' "$ancien"
  return 0
}

# Sortie : « namespace<TAB>uri », dans l'ordre de déclaration.
#
# Les extensions sont des entrées de l'inventaire de .dev/clia.yaml. Un
# .dev/extensions.yaml reste lu s'il existe : les dépôts instrumentés avant
# que la configuration ne soit unifiée en portent un, et les priver de leurs
# extensions pour cela serait les punir d'avoir été instrumentés tôt.
# clia check le signale, et clia check --fix le fond dans l'inventaire.
# shellcheck disable=SC2120  # le dépôt est facultatif, et vaut celui de travail
_clia_extensions_declarees() {
  local depot="${1:-${CLIA_WORK_DIR:-$PWD}}"
  _clia_installe "$depot" extension | awk -F'\t' 'NF { print $2 "\t" $5 }'
  _clia_extensions_ancien_fichier "$depot/.dev/extensions.yaml"
  return 0
}

# Les remotes qui répondent à un namespace, ou tous s'il est vide. Rend un
# code non nul, sans rien écrire, quand le namespace demandé n'existe pas.
_clia_remotes_filtres() {
  local demande="${1:-}" lignes
  lignes=$(_clia_remotes)
  [[ -n "$demande" ]] || { printf '%s' "${lignes:+$lignes$'\n'}"; return 0; }
  lignes=$(printf '%s' "$lignes" | awk -F'\t' -v n="$demande" '$1 == n')
  [[ -n "$lignes" ]] || return 1
  printf '%s\n' "$lignes"
}
_clia_primitives()    { printf '%s/_ressources/%s/primitives\n' "${CLIA_SOURCE_DIR:-}" "$1"; }
_clia_templates()     { printf '%s/_ressources/%s/templates\n'  "${CLIA_SOURCE_DIR:-}" "$1"; }
_clia_definition()    { printf '%s/_ressources/%s/schemas/%s.yaml\n' "${CLIA_SOURCE_DIR:-}" "$1" "$1"; }

# Un champ de la définition d'un type. Extraction à plat : les champs lus par
# le CLI sont des chaînes simples en tête de ligne, jamais des listes ni des
# blocs. Ce n'est pas un analyseur YAML, et ça n'a pas à en devenir un — le
# jour où un champ structuré devra être lu, c'est cette fonction qu'il faudra
# remplacer, et elle seule.
_clia_champ_de_fichier() {
  local fichier="$1" champ="$2" ligne
  [[ -f "$fichier" ]] || return 1
  ligne=$(grep -m1 -E "^${champ}:[[:space:]]" "$fichier" 2>/dev/null) || return 1
  ligne="${ligne#*:}"
  # Retire les espaces de tête, puis les guillemets s'il y en a.
  ligne="${ligne#"${ligne%%[![:space:]]*}"}"
  ligne="${ligne%\"}"
  ligne="${ligne#\"}"
  printf '%s\n' "$ligne"
}

# Un champ de la définition d'un type du dépôt source. Une définition d'un
# autre dépôt se lit avec _clia_champ_de_fichier, à qui on donne son chemin.
_clia_def_champ() {
  _clia_champ_de_fichier "$(_clia_definition "$1")" "$2"
}

# Le gabarit d'instance déclaré par un type, résolu en chemin complet.
_clia_gabarit_de() {
  local nom="$1" relatif
  relatif=$(_clia_def_champ "$nom" gabarit) || return 1
  [[ -n "$relatif" ]] || return 1
  printf '%s/%s\n' "$(_clia_ressource_dir "$nom")" "$relatif"
}

# --------------------------------------------------------------------------
# La carte d'identité d'un dépôt
# --------------------------------------------------------------------------
#
# USE-003 : le namespace est celui du dépôt, un seul, dérivé du couple
# publisher et nom de dépôt. Une catégorie sous _ressources/ n'en est pas un.
# L'unicité et le contrôle des namespaces sont reportés ; leur déclaration ne
# pouvait pas l'être, faute de quoi rien ne dit d'où vient une ressource.

_clia_carte() { printf '%s/.dev/clia.yaml\n' "${1:-$PWD}"; }

_clia_carte_champ() {
  _clia_champ_de_fichier "$(_clia_carte "$1")" "$2"
}

# --------------------------------------------------------------------------
# Les ressources d'un dépôt
# --------------------------------------------------------------------------
#
# Un dépôt porte ses ressources dans son propre _ressources/. Le dépôt source
# de clia est le remote : ce qu'il offre et qu'un dépôt n'a pas encore est
# disponible, non activé.
#
# Sortie : « nom<TAB>répertoire », triée par nom. Le nom est qualifié de sa
# catégorie quand il y en a une.

_clia_ressources_de() {
  # Deux déclarations, et non une : les arguments de « local » sont développés
  # avant qu'il ne s'exécute, donc $depot n'existerait pas encore pour $base.
  local depot="${1:-$PWD}" d nom
  local base="$depot/_ressources"
  [[ -d "$base" ]] || return 0
  for d in "$base"/*/ "$base"/*/*/; do
    [[ -d "$d" ]] || continue
    d="${d%/}"
    nom="${d#"$base"/}"
    [[ -f "$d/schemas/$(basename "$d").yaml" ]] && printf '%s\t%s\n' "$nom" "$d"
  done | sort -t"$(printf '\t')" -k1,1
  return 0
}

# Les fichiers d'instance d'un type dans un dépôt, d'après l'emplacement que
# sa définition déclare. Les segments <...> du motif deviennent des jokers :
# ils désignent ce qui varie d'une instance à l'autre.
#
# find -path est employé plutôt qu'un glob du shell parce que son « * »
# traverse les séparateurs : un même motif trouve donc les ressources rangées
# dans une catégorie comme celles qui n'en ont pas.
_clia_instances_liste() {
  local depot="$1" emplacement="$2" motif
  [[ -n "$emplacement" ]] || return 0
  motif=$(printf '%s' "$emplacement" | sed -E 's/<[^>]*>/*/g')
  find "$depot" -path "$depot/$motif" -type f 2>/dev/null | sort
  return 0
}

_clia_instances() {
  _clia_instances_liste "$1" "$2" | grep -c . || true
}

# Un champ du frontmatter d'une instance. Le frontmatter est le bloc entre les
# deux premiers « --- » ; au-delà commence le corps, où une ligne « version: »
# serait du texte et non une déclaration.
_clia_frontmatter_champ() {
  local fichier="$1" champ="$2"
  [[ -f "$fichier" ]] || return 1
  awk -v c="$champ" '
    NR == 1 && $0 == "---" { dedans = 1; next }
    dedans && $0 == "---"  { exit }
    dedans && index($0, c ":") == 1 {
      val = substr($0, length(c) + 2)
      sub(/^[[:space:]]+/, "", val)
      gsub(/"/, "", val)
      print val
      exit
    }
  ' "$fichier"
  return 0
}

# --------------------------------------------------------------------------
# Les versions d'une ressource
# --------------------------------------------------------------------------
#
# USE-007 : une ressource porte son propre numéro de version, déclaré par sa
# définition. Ce que le dépôt en a installé est une copie, et l'inventaire dit
# à quelle version elle a été prise.
#
# D'où viennent « les versions disponibles » : de l'historique git du dépôt
# qui offre la ressource. Aucun registre n'est tenu à côté — c'est le même
# choix que pour les versions du dépôt lui-même (clia release), et pour la
# même raison : un registre parallèle finit par mentir.

# Compare deux versions. Écrit -1, 0 ou 1 selon que la première est
# antérieure, égale ou postérieure à la seconde. Un composant absent vaut 0,
# ce qui fait de 1.2 l'égal de 1.2.0.
_clia_semver_cmp() {
  local a="$1" b="$2" i x y
  local -a ca cb
  IFS='.' read -r -a ca <<<"${a%%[-+]*}"
  IFS='.' read -r -a cb <<<"${b%%[-+]*}"
  for i in 0 1 2; do
    x="${ca[$i]:-0}"; y="${cb[$i]:-0}"
    [[ "$x" =~ ^[0-9]+$ ]] || x=0
    [[ "$y" =~ ^[0-9]+$ ]] || y=0
    if (( x < y )); then printf -- '-1\n'; return 0; fi
    if (( x > y )); then printf '1\n'; return 0; fi
  done
  printf '0\n'
  return 0
}

# Le remote qui offre une ressource, et où elle s'y trouve. Un namespace donné
# restreint la recherche à lui seul.
# Sortie : « namespace<TAB>dépôt<TAB>répertoire ».
_clia_offre_ressource() {
  local nom="$1" namespace="${2:-}" ns chemin n d
  while IFS=$'\t' read -r ns chemin; do
    [[ -n "$chemin" ]] || continue
    [[ -n "$namespace" && "$ns" != "$namespace" ]] && continue
    while IFS=$'\t' read -r n d; do
      if [[ "$n" == "$nom" ]]; then
        printf '%s\t%s\t%s\n' "$ns" "$chemin" "$d"
        return 0
      fi
    done < <(_clia_ressources_de "$chemin")
  done < <(_clia_remotes)
  return 1
}

# Les versions qu'un dépôt a données à une ressource, de la plus récente à la
# plus ancienne. Sortie : « version<TAB>commit<TAB>date ».
#
# Le répertoire de travail du dépôt vient en tête, sous le commit « travail »,
# quand sa version n'est pas celle de HEAD : c'est ce que ce dépôt offre
# aujourd'hui, et c'est ce que clia res activate copie. L'historique donne le
# reste, un commit par version — le plus récent qui la déclare, pour que la
# reprise emporte les retouches faites à version constante.
_clia_versions_ressource() {
  local depot="$1" nom="$2"
  local rel="_ressources/$nom"
  local def
  def="_ressources/$nom/schemas/$(basename "$nom").yaml"
  local travail tete commit v vus=$'\n'

  travail=$(_clia_champ_de_fichier "$depot/$def" version 2>/dev/null || printf '')
  tete=$(git -C "$depot" show "HEAD:$def" 2>/dev/null \
         | grep -m1 -E '^version:[[:space:]]' \
         | sed -E 's/^version:[[:space:]]*//; s/^"//; s/"$//' || printf '')

  if [[ -n "$travail" && "$travail" != "$tete" ]]; then
    printf '%s\ttravail\t—\n' "$travail"
    vus+="$travail"$'\n'
  fi

  while IFS= read -r commit; do
    [[ -n "$commit" ]] || continue
    v=$(git -C "$depot" show "$commit:$def" 2>/dev/null \
        | grep -m1 -E '^version:[[:space:]]' \
        | sed -E 's/^version:[[:space:]]*//; s/^"//; s/"$//' || printf '')
    [[ -n "$v" ]] || continue
    [[ "$vus" == *$'\n'"$v"$'\n'* ]] && continue
    vus+="$v"$'\n'
    printf '%s\t%s\t%s\n' "$v" \
      "$(git -C "$depot" rev-parse --short "$commit")" \
      "$(git -C "$depot" show -s --format=%cs "$commit")"
  done < <(git -C "$depot" log --format=%H -- "$rel" 2>/dev/null || true)
  return 0
}

# La version qu'une ressource portait à un commit d'un dépôt, ou rien.
_clia_version_ressource_au_commit() {
  local depot="$1" nom="$2" commit="$3"
  git -C "$depot" show "$commit:_ressources/$nom/schemas/$(basename "$nom").yaml" 2>/dev/null \
    | grep -m1 -E '^version:[[:space:]]' \
    | sed -E 's/^version:[[:space:]]*//; s/^"//; s/"$//' || true
  return 0
}

# La version qu'un dépôt se déclarait à un commit, ou rien. La source de
# vérité est celle de clia release : le champ version de .dev/clia.yaml, non
# un tag, qu'un effacement ferait disparaître.
_clia_version_depot_au_commit() {
  git -C "$1" show "$2:.dev/clia.yaml" 2>/dev/null \
    | grep -m1 -E '^version:[[:space:]]' \
    | sed -E 's/^version:[[:space:]]*//; s/^"//; s/"$//' || true
  return 0
}

# Le commit où un dépôt s'est déclaré à telle version — le plus récent s'il y
# en a plusieurs.
_clia_commit_de_version() {
  local depot="$1" version="$2" commit
  while IFS= read -r commit; do
    [[ -n "$commit" ]] || continue
    if [[ "$(_clia_version_depot_au_commit "$depot" "$commit")" == "$version" ]]; then
      printf '%s\n' "$commit"
      return 0
    fi
  done < <(git -C "$depot" log --format=%H -- .dev/clia.yaml 2>/dev/null || true)
  return 1
}

# Les versions qu'un dépôt s'est déclarées, de la plus récente à la plus
# ancienne, une fois chacune. Sert à nommer les possibles quand une version
# demandée n'en est pas une.
_clia_versions_de_depot() {
  local depot="$1" commit v vues=$'\n'
  while IFS= read -r commit; do
    [[ -n "$commit" ]] || continue
    v=$(_clia_version_depot_au_commit "$depot" "$commit")
    [[ -n "$v" ]] || continue
    [[ "$vues" == *$'\n'"$v"$'\n'* ]] && continue
    vues+="$v"$'\n'
    printf '%s\n' "$v"
  done < <(git -C "$depot" log --format=%H -- .dev/clia.yaml 2>/dev/null || true)
  return 0
}

# Les ressources d'un dépôt qui sont en retard sur leur provenance.
# Sortie : « nom<TAB>installée<TAB>offerte<TAB>namespace ».
#
# Deux ressources sont hors de la question, et non « à jour » : celle qui est
# née dans le dépôt, qui n'a personne à interroger, et celle dont l'inventaire
# est muet, qui ne désigne aucune provenance. clia check les voit ailleurs.
_clia_ressources_en_retard() {
  local depot="$1" locale nom dir entree ns installee ligne odir offerte
  locale=$(_clia_carte_champ "$depot" namespace 2>/dev/null || printf '')
  while IFS=$'\t' read -r nom dir; do
    [[ -n "$nom" ]] || continue
    entree=$(_clia_installe_entree "$depot" ressource "$nom")
    [[ -n "$entree" ]] || continue
    ns=$(printf '%s' "$entree" | awk -F'\t' '{print $2}')
    installee=$(printf '%s' "$entree" | awk -F'\t' '{print $4}')
    [[ -n "$ns" && "$ns" != '—' ]] || continue
    [[ -n "$locale" && "$ns" == "$locale" ]] && continue
    [[ -n "$installee" && "$installee" != '—' ]] || continue
    ligne=$(_clia_offre_ressource "$nom" "$ns") || continue
    odir=$(printf '%s' "$ligne" | awk -F'\t' '{print $3}')
    offerte=$(_clia_champ_de_fichier "$odir/schemas/$(basename "$nom").yaml" version 2>/dev/null || printf '')
    [[ -n "$offerte" ]] || continue
    [[ "$(_clia_semver_cmp "$installee" "$offerte")" == '-1' ]] \
      && printf '%s\t%s\t%s\t%s\n' "$nom" "$installee" "$offerte" "$ns"
  done < <(_clia_ressources_de "$depot")
  return 0
}

# --------------------------------------------------------------------------
# Le périmètre d'exécution
# --------------------------------------------------------------------------
#
# Le mode d'installation ne décide pas seulement de la durée de vie de la
# commande : il décide de ce sur quoi elle a le droit de travailler.
#
#   activate  le dépôt source, et lui seul
#   dev       le dépôt git courant, quel qu'il soit
#   direct    idem, la commande ayant été appelée par son chemin
#
# La garde est appliquée une fois, par le dispatcher, pour toute commande
# déclarant « Périmètre: dépôt ».

# Le périmètre autorise-t-il d'agir sur ce chemin ? La cible peut ne pas
# exister encore : clia init crée le dépôt qu'il instrumente, et il doit être
# refusé avant de créer quoi que ce soit, non après.
_clia_perimetre_permet() {
  local cible="$1"
  [[ "$(_clia_mode_constate)" == 'activate' ]] || return 0

  if [[ "$cible" != "${CLIA_HOME:-}" ]]; then
    _clia_msg "hors périmètre : l'activation ne permet que le dépôt source"
    _clia_detail "demandé      : $cible"
    _clia_detail "dépôt source : ${CLIA_HOME:-inconnu}"
    _clia_detail "pour travailler sur tout dépôt : . setup.sh install --dev"
    return 1
  fi
  return 0
}

_clia_depot_de_travail() {
  local depot
  depot=$(_clia_depot_git "$PWD") || {
    _clia_msg "le répertoire courant n'est pas dans un dépôt git"
    _clia_detail "clia travaille sur un dépôt ; placez-vous dans un dépôt git"
    return 1
  }

  _clia_perimetre_permet "$depot" || return 1
  printf '%s\n' "$depot"
}

# --------------------------------------------------------------------------
# Le mode d'installation constaté
# --------------------------------------------------------------------------
#
# Trois modes, et l'ordre compte : l'activation d'une session l'emporte sur
# l'installation persistante, parce qu'elle est plus proche de l'utilisateur.
#
#   activate  variables du shell courant, exécution restreinte au dépôt source
#   dev       lien dans le répertoire des exécutables, exécution dans le dépôt courant
#   direct    aucune installation, le fichier a été appelé par son chemin
_clia_mode_constate() {
  if [[ -n "${CLIA_MODE:-}" ]]; then
    printf '%s\n' "$CLIA_MODE"
  elif [[ "$(_clia_config_valeur mode 2>/dev/null)" == 'dev' ]]; then
    printf 'dev\n'
  else
    printf 'direct\n'
  fi
}

# --------------------------------------------------------------------------
# L'inventaire de ce qui est installé
# --------------------------------------------------------------------------
#
# Un dépôt clia porte un fichier de configuration, .dev/clia.yaml, et un seul.
# Il dit ce qu'est le dépôt — namespace, version, maturité, génération — et ce
# qui y a été installé, avec la provenance et la version de chaque chose.
#
# Pourquoi un inventaire alors que le disque porte déjà les ressources : parce
# que le disque ne dit pas d'où elles viennent. Une ressource reprise d'une
# extension est, sur le disque, indiscernable d'une ressource écrite sur
# place. L'inventaire garde ce que la copie perd.
#
# Une seule liste, et un champ « type » par entrée, plutôt qu'une liste par
# nature : ajouter une nature ne change alors ni le format ni le code qui le
# lit. PDC-006.
#
# Sortie : « type<TAB>namespace<TAB>nom<TAB>version<TAB>uri ».
_clia_installe() {
  local depot="${1:-${CLIA_WORK_DIR:-$PWD}}" filtre="${2:-}" fichier
  fichier=$(_clia_carte "$depot")
  [[ -f "$fichier" ]] || return 0
  awk -v filtre="$filtre" '
    function emettre() {
      if (t != "" && (filtre == "" || filtre == t))
        printf "%s\t%s\t%s\t%s\t%s\n", t, ns, nom, v, uri
    }
    /^installe:[[:space:]]*$/ { dedans = 1; next }
    dedans && /^[^[:space:]#-]/ { emettre(); t = ""; dedans = 0 }
    !dedans { next }
    /^[[:space:]]*-[[:space:]]/ {
      emettre()
      t = ns = nom = v = uri = ""
      sub(/^[[:space:]]*-[[:space:]]*/, "")
    }
    {
      ligne = $0
      sub(/^[[:space:]]+/, "", ligne)
      sub(/[[:space:]]+$/, "", ligne)
      if (ligne == "" || ligne ~ /^#/) next
      cle = ligne; sub(/:.*$/, "", cle)
      val = ligne; sub(/^[^:]*:[[:space:]]*/, "", val)
      gsub(/"/, "", val)
      if (cle == "type") t = val
      else if (cle == "namespace") ns = val
      else if (cle == "nom") nom = val
      else if (cle == "version") v = val
      else if (cle == "uri") uri = val
    }
    END { emettre() }
  ' "$fichier"
  return 0
}

# Une entrée de l'inventaire, ou rien.
_clia_installe_entree() {
  _clia_installe "$1" "$2" | awk -F'\t' -v n="$3" '$3 == n && !vu { print; vu = 1 }'
}

_clia_ecrire_entree() {
  local f="$1"
  {
    printf '  - type: %s\n' "$2"
    printf '    namespace: %s\n' "$3"
    printf '    nom: %s\n' "$4"
    printf '    version: %s\n' "$5"
    [[ -n "$6" ]] && printf '    uri: %s\n' "$6"
  } >> "$f"
  return 0
}

# Le fichier de configuration privé de sa section installe, et prêt à la
# recevoir de nouveau. Les lignes vides de queue partiraient avec la section :
# la substitution les rétablit.
_clia_entete_seule() {
  local fichier="$1" tmp entete
  tmp=$(mktemp)
  entete=$(awk '
    /^installe:[[:space:]]*$/ { dedans = 1; next }
    dedans && /^[^[:space:]#-]/ { dedans = 0 }
    !dedans { print }
  ' "$fichier")
  printf '%s\n\ninstalle:\n' "$entete" > "$tmp"
  printf '%s\n' "$tmp"
}

# Inscrire une entrée, ou remplacer celle qui porte le même type et le même
# nom. Le fichier est réécrit en entier : c'est le seul moyen de remplacer une
# entrée sans tenir d'index, et un fichier de configuration est court.
_clia_enregistrer() {
  local depot="$1" type="$2" ns="$3" nom="$4" version="$5" uri="${6:-}"
  local fichier tmp
  fichier=$(_clia_carte "$depot")
  [[ -f "$fichier" ]] || return 1
  tmp=$(_clia_entete_seule "$fichier")

  local t n2 nom2 v2 u2 ecrite=0
  while IFS=$'\t' read -r t n2 nom2 v2 u2; do
    [[ -n "$t" ]] || continue
    if [[ "$t" == "$type" && "$nom2" == "$nom" ]]; then
      _clia_ecrire_entree "$tmp" "$type" "$ns" "$nom" "$version" "$uri"
      ecrite=1
    else
      _clia_ecrire_entree "$tmp" "$t" "$n2" "$nom2" "$v2" "$u2"
    fi
  done < <(_clia_installe "$depot")

  (( ecrite == 0 )) && _clia_ecrire_entree "$tmp" "$type" "$ns" "$nom" "$version" "$uri"

  mv "$tmp" "$fichier"
  return 0
}

# Retirer une entrée de l'inventaire. Le pendant de _clia_enregistrer : une
# désinstallation qui laisse son entrée fait mentir l'inventaire, et clia check
# signale alors comme une dérive ce qui est un retrait délibéré.
_clia_oublier() {
  local depot="$1" type="$2" nom="$3"
  local fichier tmp
  fichier=$(_clia_carte "$depot")
  [[ -f "$fichier" ]] || return 0
  [[ -n "$(_clia_installe_entree "$depot" "$type" "$nom")" ]] || return 0
  tmp=$(_clia_entete_seule "$fichier")

  local t n2 nom2 v2 u2
  while IFS=$'\t' read -r t n2 nom2 v2 u2; do
    [[ -n "$t" ]] || continue
    [[ "$t" == "$type" && "$nom2" == "$nom" ]] && continue
    _clia_ecrire_entree "$tmp" "$t" "$n2" "$nom2" "$v2" "$u2"
  done < <(_clia_installe "$depot")

  mv "$tmp" "$fichier"
  return 0
}

# --------------------------------------------------------------------------
# La provenance d'un fichier repris
# --------------------------------------------------------------------------
#
# Un skill ou une fonctionnalité installés sont des copies : le fichier posé
# ne dit plus d'où il vient. C'est au moment de la copie que la provenance se
# lit, et l'inventaire la garde.
#
# La version inscrite est celle du dépôt d'origine, non celle du fichier : un
# skill n'a pas de version propre, il est livré par un dépôt qui en a une. Le
# jour où une ressource se versionnera d'elle-même — la note de la tâche 12
# l'envisage, par un hash de ses fichiers — c'est ici que cette version-là se
# lira, et ici seulement.
#
# Sortie : « namespace<TAB>version ».
_clia_provenance_de() {
  local f="$1" depot='' ns chemin
  if [[ "$f" == "${CLIA_WORK_DIR:-}"/* ]]; then
    depot="$CLIA_WORK_DIR"
  else
    while IFS=$'\t' read -r ns chemin; do
      [[ -n "$chemin" ]] || continue
      [[ "$f" == "$chemin"/* ]] && { depot="$chemin"; break; }
    done < <(_clia_remotes)
  fi
  [[ -n "$depot" ]] || { printf '—\t—\n'; return 0; }

  local v
  v=$(_clia_carte_champ "$depot" version 2>/dev/null || printf '')
  printf '%s\t%s\n' \
    "$(_clia_carte_champ "$depot" namespace 2>/dev/null || printf '—')" \
    "${v:-—}"
}
