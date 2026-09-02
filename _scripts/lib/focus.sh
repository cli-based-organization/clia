# shellcheck shell=bash
# _scripts/lib/focus.sh — ce sur quoi l'attention se porte.
#
# Implémente SES-001 tâche 16.
#
# Ce qu'est un focus
# ------------------
#
# Un répertoire, à la racine du dépôt, qui ne porte que des liens :
#
#   focus/SES-002-le-focus -> ../.dev/logs/SES-002-le-focus
#   focus/REQ-004.md       -> ../.dev/reqs/REQ-004.md
#
# Il dit ce qui compte pour le travail en cours. Un agent qui ouvre le dépôt
# n'a pas à deviner par où commencer : le harnais le renvoie au focus, et le
# focus le renvoie aux documents.
#
# Des liens, et non des copies. Un lien ne se périme pas : le document qu'il
# désigne reste le seul exemplaire, et l'éditer par le focus l'édite là où il
# vit. Une copie aurait fait deux vérités.
#
# Les liens sont relatifs, comme celui de la session : ils survivent au clone
# et au déplacement du dépôt.
#
# Hors de l'index de git
# ----------------------
#
# SES-001 tâche 16 le pose, et la raison tient : le focus est ce que quelqu'un
# regarde en ce moment, pas ce que le dépôt est. Deux personnes travaillant
# sur le même dépôt n'ont aucune raison de partager leur attention, et un
# focus versionné se serait battu avec lui-même à chaque branche.
#
# clia ajoute donc « /focus/ » au .gitignore, une fois, et le dit.
#
# Le harnais
# ----------
#
# Un focus non vide pose sa directive dans la zone gérée du harnais ; un focus
# vide l'en retire. La directive est donc une conséquence de l'état, non un
# geste de plus : le harnais ne peut pas annoncer un focus qui n'existe pas.

_CLIA_FOCUS_REL='focus'

_clia_fo_dir() { printf '%s/%s\n' "$1" "$_CLIA_FOCUS_REL"; }

# --------------------------------------------------------------------------
# Désigner une information
# --------------------------------------------------------------------------
#
# Trois formes, et clia les distingue sans rien deviner :
#
#   @chemin        relatif à la racine du dépôt — le « @ » est ce que
#                  l'énoncé de la tâche 16 emploie, et ce que les harnais
#                  emploient déjà pour désigner un fichier du dépôt ;
#   chemin         relatif au répertoire courant, ou absolu ;
#   PREFIXE-SEQ    une instance de ressource, cherchée dans le dépôt.
#
# L'ordre compte : un chemin qui existe est pris comme tel. Un alias n'est
# cherché que si rien de ce nom n'existe sur le disque, ce qui évite qu'un
# fichier nommé « SES-002 » soit confondu avec l'instance qu'il désigne.

_CLIA_FO_ALIAS='^[A-Z]{2,5}-[0-9]+$'

# Où les instances vivent — SES-001 tâche 18.
#
# Sous .dev/, et nulle part ailleurs. La recherche portait d'abord sur le
# dépôt entier, et un même alias s'y trouvait quatre fois : une fois pour
# l'instance réelle, et trois fois pour des copies qui n'en sont pas — deux
# générations archivées, et un worktree de travail. Un alias devenait ambigu
# là où il ne désignait qu'une chose.
#
# .dev/ est l'emplacement que ce dépôt tient : la carte peut y vivre, les
# sessions y vivent, les harnais générés aussi. Ce qui est ailleurs est une
# archive, un clone ou un livrable — pas une instance de ce dépôt-ci.
#
# Un document rangé hors de .dev/ reste désignable par son chemin. C'est
# l'alias qui est restreint, non le focus.
_CLIA_FO_INSTANCES_REL='.dev'

# _clia_fo_instances <dépôt> <alias> — les chemins qui portent cet alias.
#
# La recherche est celle du nom de fichier : une instance se nomme par son
# alias, éventuellement suivi d'un slug ou d'une extension. Aucune ressource
# n'a à déclarer où vivent ses instances — la règle de nommage suffit, et
# c'est elle que toutes les générations ont tenue.
_clia_fo_instances() {
  local depot="$1" alias="$2" racine="$1/$_CLIA_FO_INSTANCES_REL"
  [[ -d "$racine" ]] || return 0
  find "$racine" -mindepth 1 \
    \( -name "$alias" -o -name "$alias-*" -o -name "$alias.*" \) -print \
    2>/dev/null | sort
  return 0
}

# _clia_fo_cible <dépôt> <désignation> — le chemin absolu visé, ou un refus.
_clia_fo_cible() {
  local depot="$1" demande="$2" chemin candidats nb

  case "$demande" in
    @*) chemin="$depot/${demande#@}" ;;
    /*) chemin="$demande" ;;
    *)  chemin="$PWD/$demande" ;;
  esac

  if [[ -e "$chemin" ]]; then
    (cd -P "$(dirname "$chemin")" >/dev/null 2>&1 && printf '%s/%s\n' "$(pwd)" "$(basename "$chemin")")
    return 0
  fi

  if [[ ! "$demande" =~ $_CLIA_FO_ALIAS ]]; then
    _clia_msg "rien de ce nom dans ce dépôt : $demande"
    _clia_detail "un chemin, ou @chemin depuis la racine, ou un alias PREFIXE-SEQ"
    return 1
  fi

  candidats=$(_clia_fo_instances "$depot" "$demande")
  if [[ -z "$candidats" ]]; then
    _clia_msg "aucune instance ne porte l'alias $demande"
    _clia_detail "clia cherche sous $_CLIA_FO_INSTANCES_REL/ un fichier ou un répertoire"
    _clia_detail "nommé $demande, $demande-… ou $demande.…"
    _clia_detail "ce qui est rangé ailleurs se désigne par son chemin"
    return 1
  fi

  nb=$(printf '%s\n' "$candidats" | grep -c '')
  if (( nb > 1 )); then
    _clia_msg "alias ambigu : $demande"
    _clia_detail "plus d'une information le porte, sous $_CLIA_FO_INSTANCES_REL/ :"
    printf '%s\n' "$candidats" | sed "s#^$depot/#      #" >&2
    _clia_detail "désignez-la par son chemin"
    return 1
  fi

  printf '%s\n' "$candidats"
  return 0
}

# --------------------------------------------------------------------------
# Le contenu du focus
# --------------------------------------------------------------------------

# _clia_fo_liens <dépôt> — « nom<SEP>cible relative au dépôt<SEP>état »,
# triés par nom. L'état est constaté : un lien dont la cible a disparu le dit.
_clia_fo_liens() {
  local depot="$1" dir l nom cible etat
  dir=$(_clia_fo_dir "$depot")
  [[ -d "$dir" ]] || return 0
  for l in "$dir"/*; do
    [[ -e "$l" || -L "$l" ]] || continue
    nom=$(basename "$l")
    if [[ -L "$l" ]]; then
      cible=$(readlink -f "$l" 2>/dev/null) || cible=''
      if [[ -n "$cible" && -e "$cible" ]]; then etat='—'; else etat='cible absente'; fi
      [[ -n "$cible" ]] || cible=$(readlink "$l")
    else
      cible="$l"
      etat='pas un lien'
    fi
    printf '%s%s%s%s%s\n' "$nom" "$_CLIA_SEP" "${cible#"$depot"/}" "$_CLIA_SEP" "$etat"
    # L'ordre est celui des octets, et non celui de la locale : une sortie qui
    # change selon LANG ne serait pas vérifiable, et le banc la mesure.
  done | LC_ALL=C sort -t"$_CLIA_SEP" -k1,1
  return 0
}

_clia_fo_vide() { [[ -z "$(_clia_fo_liens "$1")" ]]; }

# --------------------------------------------------------------------------
# Le .gitignore
# --------------------------------------------------------------------------
#
# Ajouté une fois, jamais réécrit : le fichier appartient à qui l'a écrit, et
# clia n'y met qu'une ligne, précédée de sa raison.

_clia_fo_ignorer() {
  local depot="$1" f="$1/.gitignore"
  if [[ -f "$f" ]] && grep -qE '^/?focus/?$' "$f"; then
    return 1
  fi
  { [[ -s "$f" ]] && printf '\n'
    printf '# Le focus de clia : des liens, propres à qui travaille ici.\n'
    printf '/focus/\n'
  } >> "$f"
  return 0
}

# --------------------------------------------------------------------------
# La directive du harnais
# --------------------------------------------------------------------------
#
# Elle est posée quand le focus cesse d'être vide, et retirée quand il le
# redevient. Le harnais ne peut donc pas annoncer un focus qui n'existe pas —
# et c'est la seule garantie qui compte ici, puisque personne ne relit un
# harnais pour vérifier qu'il dit vrai.

_clia_fo_directive() {
  cat <<'EOF'
## Le focus

Ce dépôt porte un focus : le répertoire `focus/` désigne les documents qui
comptent pour le travail en cours. Par défaut, ne prenez en compte qu'eux.

Ce qui est hors du focus n'est pas interdit — il est hors de la question
posée. Si le travail demande d'en sortir, dites-le plutôt que de le faire en
silence.

```sh
clia focus ls               ce que le focus porte
```
EOF
}

# _clia_fo_harnais_accorder <dépôt> — met la directive en accord avec l'état
# du focus. Rend 0 si quelque chose a changé, 1 sinon.
_clia_fo_harnais_accorder() {
  local depot="$1" harnais bloc
  harnais="$depot/CLAUDE.md"
  [[ -f "$harnais" ]] || return 1

  if _clia_fo_vide "$depot"; then
    _clia_t_pose "$harnais" attention focus || return 1
    _clia_t_retirer "$harnais" attention focus
    return 0
  fi

  _clia_t_pose "$harnais" attention focus && return 1

  bloc=$(mktemp)
  { _clia_t_borne_debut attention focus
    _clia_fo_directive
    _clia_t_borne_fin attention focus
  } > "$bloc"
  _clia_t_zone_assurer "$harnais" focus || true
  _clia_t_inserer "$harnais" focus "$bloc"
  rm -f "$bloc"
  return 0
}
