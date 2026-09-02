#!/usr/bin/env bash
# Description: Les sessions de travail — leur énoncé, et laquelle est en cours.
# Périmètre: dépôt
# Signature: ses open DESCRIPTION
# Signature: ses close
# Signature: ses ls
# Signature: ses check [SESSION]
# Signature: ses show task NUMERO
#
# La commande de la ressource « session ».
#
# Une session est un segment de travail borné par une intention. Elle est un
# fichier, et un seul :
#
#   .dev/sessions/SES-<SEQ>[-<SLUG>].md   l'énoncé
#   focus/SES-<SEQ>[-<SLUG>].md           celle qui est en cours
#
# Un fichier, et non un répertoire — SES-001 tâche 2
# --------------------------------------------------
#
# La génération précédente faisait d'une session un répertoire, pour donner
# une place au journal de ses tâches sans qu'aucune convention de nommage
# n'ait à la trouver. Le journal n'y a jamais été rangé, et le répertoire ne
# portait qu'un seul fichier : il coûtait un niveau d'arborescence, une
# ambiguïté sur ce que « la session » désigne, et rien en retour.
#
# Un énoncé est un texte. Il s'ouvre, se lit et se diffe comme un texte. Ce
# que le journal deviendra le dira quand il sera écrit ; d'ici là, une place
# vide n'est pas une place.
#
# Le focus, et non workspace — SES-001 tâche 2
# --------------------------------------------
#
# workspace/session.md était un lien, et il désignait la session en cours. Il
# faisait double emploi avec le focus, que clia pose depuis SES-001 tâche 16 :
# les deux disent « voilà ce qui compte en ce moment », et deux endroits qui
# disent la même chose finissent par se contredire.
#
# La session en cours va donc au focus, comme le reste de ce qui compte. Elle
# y va comme les autres informations : un lien relatif, un .gitignore qui
# tient le focus hors de l'historique, une directive posée dans le harnais.
#
# Ce que le lien ne fait plus : il ne décide plus de ce qui est en cours. Le
# focus n'est pas versionné — il est vide au sortir d'un clone — et une
# vérité qui disparaît au clone n'est pas une vérité. C'est l'énoncé qui se
# déclare « ouverte », et lui seul ; le focus le désigne, il ne le décide pas.
#
# Ouvrir une session est une décision
# -----------------------------------
#
# CONSTITUTION.md R2 : écrire une demande de travail appartient à l'humain.
# Un énoncé de session en est une. clia pose la structure — le fichier, le
# frontmatter, les rubriques — et ne rédige rien de ce qu'elles contiennent.
#
# Cette commande ne distingue pas qui l'appelle : rien ici ne l'en empêche
# mécaniquement, et le déclarer vaut mieux que laisser croire à une barrière.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/focus.sh"

DEPOT="${CLIA_WORK_DIR:-}"

RESSOURCE="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GABARITS="$RESSOURCE/gabarits"

SESSIONS_REL='.dev/sessions'
SESSIONS="$DEPOT/$SESSIONS_REL"

FOCUS_REL='focus'
FOCUS=$(_clia_fo_dir "$DEPOT")

# Ce qu'un énoncé doit porter. Les rubriques sont ici et dans le gabarit : le
# gabarit les pose, cette liste les exige, et le banc mesure que les deux
# disent la même chose.
_SES_RUBRIQUES=('CONTEXTE' 'INTENTION' 'LIVRABLES' 'CRITÈRES DE CONVERGENCE' 'Tâches')

_SES_NOM_FICHIER='^SES-[0-9]{3,}(-[a-z0-9-]+)?\.md$'
_SES_ID='^SES-[0-9]{3,}$'
_SES_ALIAS='^SES-[0-9]+$'
_SES_DATE='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
_SES_TITRE_TACHE='^### ([0-9]+)\.[[:space:]]+\[[^]]+\][[:space:]]+[^[:space:]]'

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-ses 1 "Manuel de l'utilisateur clia"
NOM
clia-ses - ouvrir, fermer, vérifier et lire les sessions de travail

SYNOPSIS
clia ses open DESCRIPTION
clia ses close
clia ses ls
clia ses check [SESSION]
clia ses show task NUMERO

DESCRIPTION
Une session est un segment de travail borné par une intention. Ce
qui ne concourt pas à cette intention appartient à une autre
session : c'est ce qui rend une session finissable.

Une session est un fichier, et un seul :

       .dev/sessions/SES-<SEQ>[-<SLUG>].md

Le slug vient de la description donnée à l'ouverture. Il est
commode, et facultatif : SES-004.md est un énoncé valide.

La session en cours est celle dont l'énoncé se déclare « ouverte ».
C'est la seule source de vérité, et elle est versionnée. clia en
pose aussi un lien dans le focus du dépôt — voir clia-focus(1) —
pour que ce qui compte en ce moment se voie au même endroit que le
reste. Le focus désigne ; il ne décide pas.

Ouvrir une session décide de ce sur quoi le dépôt travaille.
CONSTITUTION.md R2 place ce geste chez l'humain, et place l'agent
IA en lecture seule sur les énoncés. clia pose la structure — le
fichier, le frontmatter, les rubriques — et ne rédige rien de ce
qu'elles contiennent.

SOUS-COMMANDES
open DESCRIPTION
       Ouvre une session. Crée .dev/sessions/SES-<SEQ>-<slug>.md,
       puis la met au focus.

       La session ouverte, s'il y en a une, est fermée d'abord :
       deux sessions ouvertes rendraient ambigu ce que le dépôt
       désigne comme travail en cours.

       Le numéro suit le plus grand déjà pris.

close
       Ferme la session en cours : son état passe à « close », sa
       date de fermeture est inscrite, et son lien quitte le focus.

       La réécriture est atomique : une interruption ne laisse pas
       d'énoncé tronqué.

ls
       Les sessions du dépôt, de la plus ancienne à la plus
       récente. La session en cours est marquée d'une flèche.

check [SESSION]
       Vérifie qu'un énoncé a la forme que les autres commandes
       savent lire : son emplacement, son nom, son frontmatter, ses
       rubriques, et la numérotation de ses tâches.

       Sans argument, la session en cours. Sinon un identifiant —
       SES-002 — ou un chemin.

       Chaque écart est nommé. Cette commande n'écrit rien : un
       constat qui réparerait serait un constat auquel on n'oserait
       pas se fier.

show task NUMERO
       Le prompt d'une tâche de la session en cours, tel qu'il est
       écrit : son titre, et tout ce qui le suit jusqu'à la tâche
       suivante.

       C'est par là qu'un agent prend une demande de travail, et
       non en lisant le fichier de bout en bout.

SORTIE
La sortie standard de « open » et de « check » porte le chemin de
l'énoncé. Celle de « ls » porte une ligne d'en-tête et une ligne par
session. Celle de « show task » porte le texte de la tâche.

Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y a aucune session.

1
       Refus : aucune session en cours, emplacement occupé, énoncé
       non conforme, ou tâche inconnue.

2
       Demande mal formée.

FICHIERS
.dev/sessions/SES-<SEQ>[-<SLUG>].md
       L'énoncé d'une session. Son frontmatter porte l'identifiant,
       le titre, l'état et les dates ; son corps est à rédiger.

focus/SES-<SEQ>[-<SLUG>].md
       Un lien relatif vers l'énoncé de la session en cours.

_ressources/session/gabarits/session.md
       Le gabarit de l'énoncé. Les rubriques sont là, et non dans
       le code : ce qu'une session doit dire est un texte, et il
       s'édite comme un texte.

EXEMPLES
Ouvrir une session :

       $ clia ses open "le système d'extension"
       .dev/sessions/SES-002-le-systeme-d-extension.md

Voir où en sont les sessions :

       $ clia ses ls
       ID       ETAT     OUVERTURE   TITRE
       SES-001  close    2026-08-31  première génération
    -> SES-002  ouverte  2026-09-02  mettre en place ...

Prendre une tâche :

       $ clia ses check && clia ses show task 3

VOIR AUSSI
clia(1), clia-focus(1), clia-res(1), clia-src(1)
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
  [[ -d "$SESSIONS" ]] || return 0
  find "$SESSIONS" -mindepth 1 -maxdepth 1 -type f -name 'SES-*.md' 2>/dev/null | sort
  return 0
}

# L'énoncé de la session en cours : celui qui se déclare ouvert.
#
# Le focus n'est pas consulté. Il n'est pas versionné, il est vide au sortir
# d'un clone, et n'importe qui peut y poser ou en retirer un lien : ce qu'il
# porte désigne, il ne décide pas. L'état est dans l'énoncé, où il se commite
# et où il se relit.
#
# Le plus grand numéro l'emporte s'il y en a plusieurs. Ouvrir ferme la
# précédente, donc le cas ne se produit pas quand clia a tout fait ; il se
# produit quand une main est passée, et « ls » le montre.
en_cours() {
  local f retenue=''
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    [[ "$(champ "$f" etat 2>/dev/null)" == 'ouverte' ]] || continue
    retenue="$f"
  done < <(enonces)
  [[ -n "$retenue" ]] || return 1
  printf '%s\n' "$retenue"
  return 0
}

relatif() { printf '%s\n' "${1#"$DEPOT"/}"; }

# L'énoncé désigné par un argument : un identifiant SES-<SEQ>, un chemin, ou
# rien — et rien désigne la session en cours.
designe() {
  local demande="${1:-}" f candidats nb

  if [[ -z "$demande" ]]; then
    if ! f=$(en_cours) || [[ -z "$f" ]]; then
      _clia_msg "aucune session en cours"
      _clia_detail "celles du dépôt : clia ses ls"
      _clia_detail "pour en ouvrir une : clia ses open DESCRIPTION"
      return 1
    fi
    printf '%s\n' "$f"
    return 0
  fi

  if [[ "$demande" =~ $_SES_ALIAS ]]; then
    candidats=$(enonces | grep -E "/$demande(-[^/]*)?\.md\$" || true)
    nb=$(printf '%s' "$candidats" | grep -c '' || true)
    if (( nb == 0 )); then
      _clia_msg "aucun énoncé ne porte l'identifiant $demande"
      _clia_detail "ceux du dépôt : clia ses ls"
      return 1
    fi
    if (( nb > 1 )); then
      _clia_msg "identifiant ambigu : $demande"
      _clia_detail "plus d'un énoncé le porte :"
      printf '%s\n' "$candidats" | sed "s#^$DEPOT/#      #" >&2
      _clia_detail "désignez-le par son chemin"
      return 1
    fi
    printf '%s\n' "$candidats"
    return 0
  fi

  case "$demande" in
    @*) f="$DEPOT/${demande#@}" ;;
    /*) f="$demande" ;;
    *)  f="$PWD/$demande" ;;
  esac
  if [[ ! -f "$f" ]]; then
    _clia_msg "rien de ce nom dans ce dépôt : $demande"
    _clia_detail "un identifiant SES-<SEQ>, un chemin, ou @chemin depuis la racine"
    return 1
  fi
  printf '%s\n' "$f"
  return 0
}

# --------------------------------------------------------------------------
# Le focus
# --------------------------------------------------------------------------
#
# La session en cours y est désignée comme le reste de ce qui compte : un lien
# relatif, sous le nom du fichier. Poser ce lien fait ce que « clia focus on »
# fait — le .gitignore, la directive du harnais — parce que le focus doit
# rester le même quel que soit qui l'a rempli.

accorder_harnais() {
  local avant="$1"
  if _clia_fo_harnais_accorder "$DEPOT"; then
    if [[ "$avant" == 'vide' ]]; then
      _clia_detail "la directive du focus est posée dans CLAUDE.md"
    else
      _clia_detail "la directive du focus est ôtée de CLAUDE.md"
    fi
  fi
  return 0
}

# Met un énoncé au focus. Un refus n'annule pas l'ouverture : le focus
# désigne, et une session existe et est ouverte même si personne ne la
# désigne.
focaliser() {
  local enonce="$1" nom lien avant cible
  nom=$(basename "$enonce")
  lien="$FOCUS/$nom"

  if [[ -e "$lien" && ! -L "$lien" ]]; then
    _clia_msg "$FOCUS_REL/$nom est un fichier, non un lien"
    _clia_detail "clia refuse de l'écraser : il porte peut-être le seul exemplaire"
    _clia_detail "la session est ouverte ; elle n'est pas au focus"
    return 1
  fi

  avant='plein'
  _clia_fo_vide "$DEPOT" && avant='vide'

  mkdir -p "$FOCUS"
  if _clia_fo_ignorer "$DEPOT"; then
    _clia_msg "/focus/ ajouté au .gitignore"
    _clia_detail "le focus est ce que quelqu'un regarde, non ce que le dépôt est"
  fi

  cible=$(realpath --relative-to="$FOCUS" "$enonce" 2>/dev/null) || cible="$enonce"
  ln -sfn "$cible" "$lien"

  _clia_msg "au focus : $FOCUS_REL/$nom -> $cible"
  accorder_harnais "$avant"
  return 0
}

# Retire du focus le lien qui désigne cet énoncé, et lui seul. Ce que
# quelqu'un y a mis d'autre lui appartient.
defocaliser() {
  local enonce="$1" nom lien
  nom=$(basename "$enonce")
  lien="$FOCUS/$nom"
  [[ -L "$lien" ]] || return 0
  [[ "$(readlink -f "$lien" 2>/dev/null)" == "$(readlink -f "$enonce" 2>/dev/null)" ]] || return 0
  rm -f "$lien"
  _clia_msg "hors du focus : $FOCUS_REL/$nom"
  accorder_harnais 'plein'
  return 0
}

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------

lister() {
  local f courant='' lignes='' marque ouvertes=0

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
    [[ "$(champ "$f" etat 2>/dev/null)" == 'ouverte' ]] && ouvertes=$((ouvertes + 1))
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

  if (( ouvertes > 1 )); then
    _clia_msg "$ouvertes sessions se déclarent ouvertes"
    _clia_detail "clia prend la dernière pour session en cours"
    _clia_detail "l'état est dans l'énoncé : c'est là qu'il se corrige"
  fi
  return 0
}

# --------------------------------------------------------------------------
# open
# --------------------------------------------------------------------------

# Le slug d'une description. Les accents sont translittérés quand iconv le
# sait ; sinon la description passe telle quelle et seuls les caractères
# retenus subsistent — un slug amputé vaut mieux qu'un nom de fichier que le
# système de fichiers rendrait illisible.
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
  max=$(find "$SESSIONS" -mindepth 1 -maxdepth 1 -type f -name 'SES-*.md' 2>/dev/null \
        | sed -E 's#.*/SES-([0-9]+).*#\1#' | grep -E '^[0-9]+$' \
        | sort -n | tail -1)
  printf '%03d\n' $(( 10#${max:-0} + 1 ))
}

ouvrir() {
  local description="$*" s seq enonce val

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

  mkdir -p "$SESSIONS"
  seq=$(sequence_suivante)
  enonce="$SESSIONS/SES-$seq-$s.md"

  if [[ -e "$enonce" ]]; then
    _clia_msg "l'emplacement est déjà occupé : $(relatif "$enonce")"
    _clia_detail "rien n'a été créé"
    return 1
  fi

  # La session en cours est fermée d'abord : deux sessions ouvertes rendraient
  # ambigu ce que le dépôt désigne comme travail en cours. C'est fait avant
  # toute écriture, pour qu'un refus de fermeture n'ouvre rien.
  local ancienne
  if ancienne=$(en_cours 2>/dev/null) && [[ -n "$ancienne" ]]; then
    fermer_fichier "$ancienne" || return 1
    defocaliser "$ancienne"
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

  printf '%s\n' "$rendu" > "$enonce"

  focaliser "$enonce" || true

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

  fermer_fichier "$courant" || return 1
  defocaliser "$courant"
  return 0
}

# --------------------------------------------------------------------------
# check
# --------------------------------------------------------------------------
#
# SES-001 tâche 1 : le format d'un énoncé se vérifie avant qu'on travaille
# dessus, et un énoncé non conforme interrompt l'exécution.
#
# Ce que cette commande vérifie est exactement ce que les autres commandes
# lisent : l'emplacement, le nom, les champs du frontmatter, les rubriques, et
# la numérotation des tâches. Rien de plus. Vérifier ce que personne ne lit
# ferait échouer un énoncé que le système sait pourtant traiter.
#
# Elle n'écrit rien. Un constat qui réparerait serait un constat auquel on
# n'oserait pas se fier.

_SES_ECARTS_F=''
ecart() { printf '%s\n' "$*" >> "$_SES_ECARTS_F"; }

# Les titres de tâche d'un énoncé, dans l'ordre du fichier.
taches_de() {
  awk '
    /^## / { dans = ($0 ~ /^## Tâches[[:space:]]*$/); next }
    dans && /^### / { print }
  ' "$1"
}

verifier_fichier() {
  local f="$1" base id etat val ligne attendu=1 numero

  base=$(basename "$f")

  [[ "$(dirname "$f")" == "$SESSIONS" ]] \
    || ecart "l'énoncé n'est pas sous $SESSIONS_REL/ : $(relatif "$(dirname "$f")")"
  [[ "$base" =~ $_SES_NOM_FICHIER ]] \
    || ecart "le nom ne suit pas SES-<SEQ>[-<SLUG>].md : $base"

  if ! head -1 "$f" | grep -q '^---[[:space:]]*$'; then
    ecart "le fichier ne commence pas par un frontmatter « --- »"
  fi

  val=$(champ "$f" type 2>/dev/null || printf '')
  [[ "$val" == 'session' ]] \
    || ecart "le champ « type » ne vaut pas « session » : ${val:-absent}"

  id=$(champ "$f" id 2>/dev/null || printf '')
  if [[ ! "$id" =~ $_SES_ID ]]; then
    ecart "le champ « id » ne suit pas SES-<SEQ> : ${id:-absent}"
  elif [[ "$base" != "$id.md" && "$base" != "$id-"* ]]; then
    ecart "le champ « id » et le nom du fichier ne s'accordent pas : $id / $base"
  fi

  val=$(champ "$f" titre 2>/dev/null || printf '')
  [[ -n "$val" ]] || ecart "le champ « titre » est absent ou vide"

  etat=$(champ "$f" etat 2>/dev/null || printf '')
  case "$etat" in
    ouverte|close) ;;
    '') ecart "le champ « etat » est absent" ;;
    *)  ecart "le champ « etat » ne vaut ni « ouverte » ni « close » : $etat" ;;
  esac

  val=$(champ "$f" ouverture 2>/dev/null || printf '')
  [[ "$val" =~ $_SES_DATE ]] \
    || ecart "le champ « ouverture » n'est pas une date AAAA-MM-JJ : ${val:-absent}"

  if [[ "$etat" == 'close' ]]; then
    val=$(champ "$f" fermeture 2>/dev/null || printf '')
    [[ "$val" =~ $_SES_DATE ]] \
      || ecart "une session close porte une date « fermeture » : ${val:-absente}"
  fi

  for val in "${_SES_RUBRIQUES[@]}"; do
    grep -q "^## $val\$" "$f" || ecart "la rubrique « $val » manque"
  done

  # Les tâches sont numérotées de 1 en 1. Un numéro qui saute rend « show task
  # 3 » ambigu : le lecteur compte, et clia lit le titre — les deux ne
  # tombent alors pas sur la même tâche.
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    if [[ ! "$ligne" =~ $_SES_TITRE_TACHE ]]; then
      ecart "un titre de tâche ne suit pas « ### <n>. [type] Titre » : $ligne"
      continue
    fi
    numero=$(( 10#${BASH_REMATCH[1]} ))
    (( numero == attendu )) || ecart "la tâche $numero devrait porter le numéro $attendu"
    attendu=$(( numero + 1 ))
  done < <(taches_de "$f")

  return 0
}

verifier() {
  local f nb ligne

  f=$(designe "${1:-}") || return 1

  _SES_ECARTS_F=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$_SES_ECARTS_F'" RETURN

  verifier_fichier "$f"
  nb=$(grep -c '' "$_SES_ECARTS_F" || true)

  if (( nb == 0 )); then
    printf '%s\n' "$(relatif "$f")"
    _clia_msg "conforme : $(relatif "$f")"
    return 0
  fi

  _clia_msg "$(relatif "$f") n'est pas conforme : $nb écart(s)"
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] && _clia_detail "$ligne"
  done < "$_SES_ECARTS_F"
  _clia_detail "ce qu'un énoncé doit porter : clia ses --man"
  _clia_detail "l'énoncé appartient à l'humain : clia ne le corrige pas"
  return 1
}

# --------------------------------------------------------------------------
# show task
# --------------------------------------------------------------------------
#
# Le prompt d'une tâche, tel qu'il est écrit. clia ne le reformule pas : ce
# que la tâche demande appartient à qui l'a écrite, et un automatisme qui
# résumerait une demande de travail en changerait la portée.

montrer_tache() {
  local numero="$1" f bloc

  [[ "$numero" =~ ^[0-9]+$ ]] || {
    _clia_msg "le numéro de tâche n'est pas un nombre : $numero"
    _clia_detail "l'usage : clia ses show task NUMERO"
    return 2
  }

  f=$(designe '') || return 1

  if ! grep -q '^## Tâches$' "$f"; then
    _clia_msg "l'énoncé ne porte pas de rubrique « Tâches » : $(relatif "$f")"
    _clia_detail "vérifiez sa forme : clia ses check"
    return 1
  fi

  bloc=$(awk -v n="$numero" '
    /^## / { if (pris) exit; dans = ($0 ~ /^## Tâches[[:space:]]*$/); next }
    !dans { next }
    /^### / { if (pris) exit; pris = ($0 ~ "^### " n "\\.") }
    pris { print }
  ' "$f")

  if [[ -z "$bloc" ]]; then
    _clia_msg "$(champ "$f" id) ne porte pas de tâche $numero"
    _clia_detail "l'énoncé : $(relatif "$f")"
    return 1
  fi

  printf '%s\n' "$bloc"
  return 0
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

  check)
    (( $# <= 1 )) || { _clia_msg "check prend au plus une session : $*"; exit 2; }
    verifier "${1:-}" ;;

  show)
    (( $# >= 1 )) || {
      _clia_msg "show attend un sujet"
      _clia_detail "l'usage : clia ses show task NUMERO"
      exit 2
    }
    SUJET="$1"; shift
    case "$SUJET" in
      task)
        (( $# == 1 )) || {
          _clia_msg "task attend un numéro, et un seul"
          _clia_detail "l'usage : clia ses show task NUMERO"
          exit 2
        }
        montrer_tache "$1" ;;
      *)
        _clia_msg "sujet inconnu : $SUJET"
        _clia_detail "l'usage : clia ses show task NUMERO"
        exit 2 ;;
    esac ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia ses --help"
    exit 2 ;;
esac
