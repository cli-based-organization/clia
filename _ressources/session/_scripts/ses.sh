#!/usr/bin/env bash
# Description: Les sessions de travail — leur énoncé, et laquelle est en cours.
# Périmètre: dépôt
# Signature: ses open DESCRIPTION
# Signature: ses close
# Signature: ses ls
#
# La commande de la ressource « session ».
#
# Une session est un segment de travail borné par une intention. Elle est un
# répertoire : son énoncé, et la place où le journal de ses tâches se rangera.
#
#   .dev/logs/SES-<SEQ>-<slug>/
#       session.md            l'énoncé
#
#   workspace/session.md -> l'énoncé de la session en cours
#
# Ce que cette ressource reprend de la génération 2026-08-23, et pourquoi
# ------------------------------------------------------------------------
#
# La forme — un répertoire par session, un lien qui désigne celle en cours —
# est celle de cette génération-là. Trois choses la justifiaient, et elles
# tiennent toujours :
#
#   le répertoire donne une place au journal des tâches sans qu'aucune
#   convention de nommage n'ait à la trouver ;
#
#   le lien est un point d'entrée stable : un harnais IA peut désigner
#   workspace/session.md sans que rien ne bouge quand la session change ;
#
#   le lien est relatif, donc il survit au clone et au déplacement du dépôt.
#   Celui posé à la main le 2026-08-12 était absolu, et cassait aux trois.
#
# Ce qui n'est pas repris : les verbes status, switch et todo, et le compte
# des tâches. SES-001 tâche 10 nomme open et close ; ls s'y ajoute parce que
# fermer à l'aveugle n'est pas fermer. Le reste reviendra quand il sera
# demandé.
#
# Ouvrir une session est une décision
# -----------------------------------
#
# CONSTITUTION.md R2 : écrire une demande de travail appartient à l'humain.
# Un énoncé de session en est une. clia pose la structure — le répertoire, le
# frontmatter, les rubriques — et ne rédige rien de ce qu'elles contiennent.
#
# Cette commande ne distingue pas qui l'appelle : rien ici ne l'en empêche
# mécaniquement, et le déclarer vaut mieux que laisser croire à une barrière.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

RESSOURCE="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GABARITS="$RESSOURCE/gabarits"

LOGS_REL='.dev/logs'
LOGS="$DEPOT/$LOGS_REL"

VIVANT_REL='workspace/session.md'
VIVANT="$DEPOT/$VIVANT_REL"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-ses 1 "Manuel de l'utilisateur clia"
NOM
clia-ses - ouvrir, fermer et lister les sessions de travail

SYNOPSIS
clia ses open DESCRIPTION
clia ses close
clia ses ls

DESCRIPTION
Une session est un segment de travail borné par une intention. Ce
qui ne concourt pas à cette intention appartient à une autre
session : c'est ce qui rend une session finissable.

Une session est un répertoire, sous .dev/logs/. Il porte l'énoncé
— session.md — et donne une place au journal de ses tâches.

Le dépôt désigne la session en cours par un lien,
workspace/session.md. C'est un point d'entrée stable : un harnais
IA peut le nommer sans avoir à changer quand la session change. Le
lien est relatif, et survit donc au clone et au déplacement du
dépôt.

Ouvrir une session décide de ce sur quoi le dépôt travaille.
CONSTITUTION.md R2 place ce geste chez l'humain. clia pose la
structure — le répertoire, le frontmatter, les rubriques — et ne
rédige rien de ce qu'elles contiennent.

SOUS-COMMANDES
open DESCRIPTION
       Ouvre une session. Crée .dev/logs/SES-<SEQ>-<slug>/ et son
       énoncé, puis fait pointer workspace/session.md dessus.

       La session ouverte, s'il y en a une, est fermée d'abord :
       deux sessions ouvertes rendraient ambigu ce que le dépôt
       désigne comme travail en cours.

       Le numéro suit le plus grand déjà pris. Le slug vient de la
       description.

close
       Ferme la session en cours : son état passe à « close », et
       sa date de fermeture est inscrite.

       La réécriture est atomique : une interruption ne laisse pas
       d'énoncé tronqué.

ls
       Les sessions du dépôt, de la plus ancienne à la plus
       récente. La session en cours est marquée d'une flèche.

SORTIE
La sortie standard de « open » porte le chemin de l'énoncé créé.
Celle de « ls » porte une ligne d'en-tête et une ligne par session.

Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y a aucune session.

1
       Refus : aucune session en cours, emplacement occupé, ou
       workspace/session.md est un fichier que clia refuse
       d'écraser.

2
       Demande mal formée.

FICHIERS
.dev/logs/SES-<SEQ>-<slug>/session.md
       L'énoncé d'une session. Son frontmatter porte l'identifiant,
       le titre, l'état et les dates ; son corps est à rédiger.

workspace/session.md
       Un lien relatif vers l'énoncé de la session en cours.

_ressources/session/gabarits/session.md
       Le gabarit de l'énoncé. Les rubriques sont là, et non dans
       le code : ce qu'une session doit dire est un texte, et il
       s'édite comme un texte.

EXEMPLES
Ouvrir une session :

       $ clia ses open "le système d'extension"
       .dev/logs/SES-002-le-systeme-d-extension/session.md

Voir où en sont les sessions :

       $ clia ses ls
       ID       ETAT     OUVERTURE   TITRE
       SES-001  close    2026-08-31  première génération
    -> SES-002  ouverte  2026-09-02  mettre en place ...

VOIR AUSSI
clia(1), clia-res(1), clia-src(1)
EOF
}

# --------------------------------------------------------------------------
# Lire un énoncé
# --------------------------------------------------------------------------
#
# Le frontmatter est délimité par deux lignes « --- ». Un fichier qui n'en
# porte pas n'est pas un énoncé que ces commandes savent lire : elles le
# disent, plutôt que de lui prêter un état qu'il ne déclare pas.

champ() {
  local fichier="$1" champ="$2"
  [[ -f "$fichier" ]] || return 1
  awk -v champ="$champ" '
    NR == 1 && $0 !~ /^---[[:space:]]*$/ { exit 1 }
    NR == 1 { next }
    /^---[[:space:]]*$/ { exit }
    {
      i = index($0, ":")
      if (i == 0) next
      cle = substr($0, 1, i - 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", cle)
      if (cle != champ) next
      val = substr($0, i + 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", val)
      gsub(/^"|"$/, "", val)
      print val
      exit
    }
  ' "$fichier"
}

# Les énoncés du dépôt, un chemin par ligne, dans l'ordre des numéros.
enonces() {
  [[ -d "$LOGS" ]] || return 0
  find "$LOGS" -mindepth 2 -maxdepth 2 -type f -name 'session.md' 2>/dev/null | sort
  return 0
}

# L'énoncé de la session en cours, par ordre d'autorité décroissant :
# le lien d'abord — c'est lui que le dépôt désigne — puis, à défaut de lien,
# le premier énoncé qui se déclare ouvert.
en_cours() {
  local cible f
  if [[ -L "$VIVANT" ]]; then
    cible=$(readlink -f "$VIVANT" 2>/dev/null) || cible=''
    if [[ -n "$cible" && -f "$cible" ]]; then
      printf '%s\n' "$cible"
      return 0
    fi
    _clia_msg "$VIVANT_REL ne pointe sur rien"
    _clia_detail "clia ses open en ouvrira une nouvelle, et le repointera"
    return 1
  fi

  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    [[ "$(champ "$f" etat 2>/dev/null)" == 'ouverte' ]] || continue
    printf '%s\n' "$f"
    return 0
  done < <(enonces)
  return 1
}

relatif() { printf '%s\n' "${1#"$DEPOT"/}"; }

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------

lister() {
  local f courant='' lignes='' marque

  if [[ -z "$(enonces)" ]]; then
    _clia_msg "ce dépôt ne porte aucune session"
    _clia_detail "pour en ouvrir une : clia ses open DESCRIPTION"
    return 0
  fi

  courant=$(en_cours 2>/dev/null) || courant=''

  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    marque='  '
    [[ -n "$courant" && "$f" == "$courant" ]] && marque='->'
    lignes+=$(printf '%s\t%s\t%s\t%s\t%s' \
      "$marque" \
      "$(champ "$f" id 2>/dev/null || printf '—')" \
      "$(champ "$f" etat 2>/dev/null || printf '—')" \
      "$(champ "$f" ouverture 2>/dev/null || printf '—')" \
      "$(champ "$f" titre 2>/dev/null || printf '—')")$'\n'
  done < <(enonces)

  { printf '\tID\tETAT\tOUVERTURE\tTITRE\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  return 0
}

# --------------------------------------------------------------------------
# open
# --------------------------------------------------------------------------

# Le slug d'une description. Les accents sont translittérés quand iconv le
# sait ; sinon la description passe telle quelle et seuls les caractères
# retenus subsistent — un slug amputé vaut mieux qu'un nom de répertoire que
# le système de fichiers rendrait illisible.
slug() {
  local texte="$*" s
  s=$(printf '%s' "$texte" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null) || s="$texte"
  printf '%s\n' "$(printf '%s' "$s" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -e "s/['\`]/ /g" \
          -e 's/[^a-z0-9]\+/-/g' \
          -e 's/-\{2,\}/-/g' \
          -e 's/^-\+//' -e 's/-\+$//' \
    | cut -c1-60)"
}

sequence_suivante() {
  local max
  max=$(find "$LOGS" -mindepth 1 -maxdepth 1 -type d -name 'SES-*' 2>/dev/null \
        | sed -E 's#.*/SES-([0-9]{3}).*#\1#' | grep -E '^[0-9]{3}$' \
        | sort -n | tail -1)
  printf '%03d\n' $(( 10#${max:-0} + 1 ))
}

# Pose workspace/session.md en lien relatif vers un énoncé.
#
# Le lien est le point d'entrée qu'un harnais IA peut déclarer. clia refuse
# d'écraser un fichier ordinaire non vide qui l'occuperait : il porte
# peut-être le seul exemplaire de ce qu'il contient.
poser_lien() {
  local cible="$1" dir rel
  dir=$(dirname "$VIVANT")

  if [[ -e "$VIVANT" && ! -L "$VIVANT" ]]; then
    if [[ -s "$VIVANT" ]]; then
      _clia_msg "$VIVANT_REL est un fichier, non un lien"
      _clia_detail "clia refuse de l'écraser : il porte peut-être le seul exemplaire"
      _clia_detail "déplacez-le sous $LOGS_REL/SES-<SEQ>-<slug>/session.md, puis reprenez"
      return 1
    fi
    rm -f "$VIVANT"
  fi

  mkdir -p "$dir"
  rel=$(realpath --relative-to="$dir" "$cible" 2>/dev/null) || rel="$cible"
  ln -sfn "$rel" "$VIVANT"
  _clia_msg "$VIVANT_REL -> $rel"
  return 0
}

ouvrir() {
  local description="$*" s seq dir enonce val

  [[ -n "$description" ]] || {
    _clia_msg "open attend une description"
    _clia_detail "l'usage : clia ses open DESCRIPTION"
    return 2
  }

  s=$(slug "$description")
  [[ -n "$s" ]] || {
    _clia_msg "la description ne produit aucun slug : $description"
    _clia_detail "il faut au moins une lettre ou un chiffre"
    return 2
  }

  mkdir -p "$LOGS"
  seq=$(sequence_suivante)
  dir="$LOGS/SES-$seq-$s"
  enonce="$dir/session.md"

  if [[ -e "$dir" ]]; then
    _clia_msg "l'emplacement est déjà occupé : $(relatif "$dir")"
    _clia_detail "rien n'a été créé"
    return 1
  fi

  # La session en cours est fermée d'abord : deux sessions ouvertes rendraient
  # ambigu ce que le dépôt désigne comme travail en cours. C'est fait avant
  # toute écriture, pour qu'un refus de fermeture n'ouvre rien.
  #
  # Une session déjà fermée est laissée telle quelle. Le lien la désigne
  # encore — il désigne la dernière session, close ou non — et la refermer
  # écraserait sa date de fermeture par celle du jour.
  local ancienne
  if ancienne=$(en_cours 2>/dev/null) && [[ -n "$ancienne" ]]; then
    if [[ "$(champ "$ancienne" etat 2>/dev/null)" == 'ouverte' ]]; then
      fermer_fichier "$ancienne" || return 1
    fi
  fi

  val=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$val'" RETURN
  { printf 'id\tSES-%s\n'    "$seq"
    printf 'titre\t%s\n'     "${description//\"/\'}"
    printf 'ouverture\t%s\n' "$(date +%Y-%m-%d)"
  } > "$val"

  local rendu
  rendu=$(_clia_rendre "$GABARITS/session.md" "$val") || {
    _clia_msg "rien n'a été créé"
    return 1
  }

  mkdir -p "$dir"
  printf '%s\n' "$rendu" > "$enonce"

  poser_lien "$enonce" || return 1

  printf '%s\n' "$(relatif "$enonce")"
  _clia_msg "ouverte : SES-$seq"
  _clia_detail "clia ne rédige pas l'énoncé : les rubriques sont à remplir"
  _clia_detail "rien n'est commité"
  return 0
}

# --------------------------------------------------------------------------
# close
# --------------------------------------------------------------------------

# Passe un énoncé à l'état « close » et inscrit sa date de fermeture. La
# réécriture est atomique : une interruption ne laisse pas d'énoncé tronqué.
fermer_fichier() {
  local fichier="$1" tmp
  [[ -f "$fichier" ]] || { _clia_msg "énoncé introuvable : $fichier"; return 1; }

  if [[ -z "$(champ "$fichier" etat 2>/dev/null)" ]]; then
    _clia_msg "sans frontmatter, il n'y a rien à fermer : $(relatif "$fichier")"
    _clia_detail "un énoncé porte son état entre deux lignes « --- », en tête"
    return 1
  fi

  tmp=$(mktemp "$fichier.XXXXXX")
  awk -v jour="$(date +%Y-%m-%d)" '
    NR == 1 { print; next }
    !corps && /^---[[:space:]]*$/ {
      if (!vu_fermeture) printf "fermeture: %s\n", jour
      corps = 1; print; next
    }
    !corps && /^etat:/       { print "etat: close"; next }
    !corps && /^fermeture:/  { vu_fermeture = 1; printf "fermeture: %s\n", jour; next }
    { print }
  ' "$fichier" > "$tmp"
  chmod --reference="$fichier" "$tmp" 2>/dev/null || true
  mv -f "$tmp" "$fichier"

  _clia_msg "fermée : $(relatif "$fichier")"
  return 0
}

fermer() {
  local courant
  if ! courant=$(en_cours) || [[ -z "$courant" ]]; then
    _clia_msg "aucune session en cours"
    _clia_detail "celles du dépôt : clia ses ls"
    return 1
  fi

  # Le lien désigne la dernière session, close ou non. Refermer une session
  # close écraserait sa date de fermeture par celle du jour, et personne ne
  # verrait que la date a changé.
  if [[ "$(champ "$courant" etat 2>/dev/null)" == 'close' ]]; then
    _clia_msg "la session en cours est déjà fermée : $(relatif "$courant")"
    _clia_detail "pour en ouvrir une autre : clia ses open DESCRIPTION"
    return 1
  fi

  fermer_fichier "$courant"
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

VERBE="${1:-}"
[[ $# -gt 0 ]] && shift

case "$VERBE" in
  '')
    _clia_msg "clia ses attend un verbe"
    _clia_detail "l'usage : clia ses --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  open)
    (( $# >= 1 )) || {
      _clia_msg "open attend une description"
      _clia_detail "l'usage : clia ses open DESCRIPTION"
      exit 2
    }
    ouvrir "$@" ;;

  close)
    (( $# == 0 )) || { _clia_msg "close ne prend pas d'argument : $*"; exit 2; }
    fermer ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia ses --help"
    exit 2 ;;
esac
