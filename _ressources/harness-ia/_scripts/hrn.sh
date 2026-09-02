#!/usr/bin/env bash
# Description: Les harnais IA — leurs gabarits, leurs données, leurs livrables.
# Périmètre: dépôt
# Signature: hrn ls
# Signature: hrn new HARNAIS
# Signature: hrn gen [HARNAIS]
#
# Implémente SES-001 tâche 8.
#
# Cette commande n'est pas dans le noyau : elle est dans la ressource qui la
# justifie. Le point d'entrée trouve les commandes de _scripts/lib/cmd/ et
# celles que les ressources déposent sous _ressources/<nom>/_scripts/. Une
# ressource apporte donc ses automatismes avec elle, et le noyau n'a pas à
# savoir qu'elle existe.
#
# Ce qui vaut pour les commandes du noyau vaut ici : le nom du fichier est le
# nom de la commande, et les déclarations en tête font l'aide. Le noyau
# l'emporte en cas d'homonymie — une ressource ne peut pas masquer « version ».
#
# Le gabarit, le schéma, les données
# ----------------------------------
#
#   _ressources/harness-ia/gabarits/CLAUDE.md      le gabarit
#   _ressources/harness-ia/gabarits/CLAUDE.yaml    son schéma
#   .dev/harnais-ia/hrn.yaml                       les données du dépôt
#   .dev/harnais-ia/CLAUDE.md                      le livrable, généré
#
# Le gabarit porte le texte et ses trous ; le schéma déclare ce qui se
# configure ; les données disent ce que ce dépôt-ci veut. Le livrable est
# la fonction des trois, et rien d'autre : le régénérer deux fois rend deux
# fois le même fichier.
#
# C'est ce qui fait que le livrable ne s'édite pas. Ce qu'il y a à changer
# est dans hrn.yaml, et la régénération écrase le reste.
#
# La langue du gabarit
# --------------------
#
#   {{nom}}                      la valeur d'un champ
#   {{#section nom}} … {{/section}}   un bloc gardé ou retiré
#
# Deux formes, et pas une de plus. Une langue de gabarit qui sait boucler et
# tester finit par porter la logique du système, et cette logique doit se
# lire dans le code, pas dans un fichier de texte.
#
# Les marqueurs occupent une ligne entière et disparaissent au rendu. Un
# gabarit dont toutes les sections sont gardées rend donc exactement le texte
# qu'il porte, aux champs près — le banc le vérifie contre les primitives
# actuelles.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../../../_scripts/lib/commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

RESSOURCE="$CLIA_SOURCE_DIR/_ressources/harness-ia"
GABARITS="$RESSOURCE/gabarits"

# SES-001 tâche 8 nomme cet emplacement. Une instance de la ressource y vit :
# ses données, et les livrables qu'elles produisent.
INSTANCE_REL='.dev/harnais-ia'
INSTANCE="$DEPOT/$INSTANCE_REL"
DONNEES="$INSTANCE/hrn.yaml"
DONNEES_REL="$INSTANCE_REL/hrn.yaml"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-hrn 1 "Manuel de l'utilisateur clia"
NOM
clia-hrn - générer les harnais IA d'un dépôt à partir de leurs gabarits

SYNOPSIS
clia hrn ls
clia hrn new HARNAIS
clia hrn gen [HARNAIS]

DESCRIPTION
Un harnais IA dit aux agents et aux automatismes comment travailler
dans un dépôt. La ressource harness-ia en offre les gabarits ; ce
dépôt-ci en tient les données, et les livrables en découlent.

Trois fichiers, et une seule direction de dépendance :

Le gabarit porte le texte et ses trous. Il vit dans la ressource,
sous gabarits/, et vaut pour tous les dépôts.

Le schéma déclare ce qui se configure : les champs, dont la valeur
est substituée dans le texte, et les sections, que l'on garde ou que
l'on retire. Il vit à côté du gabarit.

Les données disent ce que ce dépôt-ci veut. Elles vivent dans
l'instance, sous .dev/harnais-ia/hrn.yaml, et ce sont elles qui
s'éditent.

Le livrable est la fonction des trois. Il ne s'édite pas : la
régénération l'écrase. Ce qu'il y a à changer est dans les données.

SOUS-COMMANDES
ls
       Les harnais que la ressource offre, et où en est ce dépôt
       pour chacun : absent, à jour, ou à régénérer.

       « à régénérer » dit que le livrable ne correspond plus à ses
       données — il a été édité, ou le gabarit a avancé.

new HARNAIS
       Pose les données de ce harnais dans l'instance, aux valeurs
       par défaut du schéma, puis génère son livrable.

       Chaque champ et chaque section y est écrit avec sa
       description en commentaire : ce qui se configure se lit dans
       le fichier qui se configure.

       Un harnais déjà posé n'est pas retouché. Ses données
       appartiennent au dépôt, et les écraser serait perdre ce que
       quelqu'un a décidé.

gen [HARNAIS]
       Régénère un livrable depuis ses données, ou tous ceux que
       l'instance porte si aucun harnais n'est nommé.

       Une donnée que le schéma ne déclare pas est signalée et
       ignorée ; une section que le schéma a ajoutée depuis prend sa
       valeur par défaut.

LA LANGUE DES GABARITS
{{nom}}
       La valeur du champ « nom », telle que les données ou le
       schéma la donnent.

{{#section nom}} ... {{/section}}
       Un bloc gardé si la section vaut « oui », retiré sinon. Les
       deux marqueurs occupent une ligne entière, et disparaissent
       au rendu.

SORTIE
La sortie standard de « new » et de « gen » ne porte que le chemin
des livrables écrits, un par ligne. Celle de « ls » porte une ligne
d'en-tête et une ligne par harnais.

Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite.

1
       Refus : harnais inconnu, déjà posé, ou instance absente.

2
       Demande mal formée.

FICHIERS
_ressources/harness-ia/gabarits/<HARNAIS>.md
       Le gabarit : le texte, et ses trous.

_ressources/harness-ia/gabarits/<HARNAIS>.yaml
       Son schéma : les champs et les sections qui se configurent,
       leurs valeurs par défaut, et ce que chacun commande.

.dev/harnais-ia/hrn.yaml
       Les données de ce dépôt. C'est le fichier qui s'édite.

.dev/harnais-ia/<HARNAIS>.md
       Le livrable, généré. Il ne s'édite pas.

EXEMPLES
Voir ce qui est offert, et où en est le dépôt :

       $ clia hrn ls
       HARNAIS       LIVRABLE          ETAT     SECTIONS
       CLAUDE        CLAUDE.md         à jour   6/6

Poser un harnais :

       $ clia hrn new CONSTITUTION
       .dev/harnais-ia/CONSTITUTION.md

Retirer une section, puis régénérer :

       $ $EDITOR .dev/harnais-ia/hrn.yaml
       $ clia hrn gen CONSTITUTION

VOIR AUSSI
clia(1), clia-res(1), clia-init(1), clia-check(1)
FIN
}

# --------------------------------------------------------------------------
# Ce que la ressource offre
# --------------------------------------------------------------------------
#
# Un gabarit est offert parce qu'il porte son schéma, et pour aucune autre
# raison. Un gabarit sans schéma ne déclare pas ce qui se configure : le
# rendre disponible obligerait à deviner, et clia ne devine pas.

# « nom<TAB>gabarit<TAB>schéma », triés par nom.
offerts() {
  local g nom
  for g in "$GABARITS"/*.md; do
    [[ -f "$g" ]] || continue
    nom=$(basename "$g" .md)
    [[ -f "$GABARITS/$nom.yaml" ]] || continue
    printf '%s\t%s\t%s\n' "$nom" "$g" "$GABARITS/$nom.yaml"
  done | sort
  return 0
}

schema_de() {
  local nom g s
  while IFS=$'\t' read -r nom g s; do
    [[ "$nom" == "$1" ]] && { printf '%s\n' "$s"; return 0; }
  done < <(offerts)
  return 1
}

gabarit_de() {
  local nom g s
  while IFS=$'\t' read -r nom g s; do
    [[ "$nom" == "$1" ]] && { printf '%s\n' "$g"; return 0; }
  done < <(offerts)
  return 1
}

resoudre() {
  local demande="$1"
  if schema_de "$demande" >/dev/null; then
    printf '%s\n' "$demande"
    return 0
  fi
  _clia_msg "harnais inconnu : $demande"
  _clia_detail "ceux que la ressource offre : clia hrn ls"
  return 1
}

# --------------------------------------------------------------------------
# Lire un schéma
# --------------------------------------------------------------------------
#
# Le format est celui que ce dépôt écrit et relit, et l'analyseur en épouse
# la forme exacte plutôt que le YAML entier : une dépendance à un analyseur
# YAML pour lire quatre lignes coûterait plus qu'elle ne rend.

# entrees <schéma> <champs|sections> — « nom<TAB>défaut<TAB>description ».
entrees() {
  awk -v cible="$2" '
    function valeur(l,   s) {
      s = l
      sub(/^[^:]*:[[:space:]]*/, "", s)
      sub(/[[:space:]]+$/, "", s)
      if (substr(s, 1, 1) == "\"" && substr(s, length(s), 1) == "\"")
        s = substr(s, 2, length(s) - 2)
      return s
    }
    function vider() {
      if (nom != "") printf "%s\t%s\t%s\n", nom, defaut, desc
      nom = ""; defaut = ""; desc = ""
    }
    /^[^[:space:]#]/ {
      vider()
      bloc = ""
      if ($0 ~ /^champs:/)   bloc = "champs"
      if ($0 ~ /^sections:/) bloc = "sections"
      next
    }
    bloc != cible      { next }
    /^  - nom:/         { vider(); nom = valeur($0); next }
    /^    defaut:/      { defaut = valeur($0); next }
    /^    description:/ { desc = valeur($0); next }
    END { vider() }
  ' "$1"
}

livrable_de() {
  local nom
  nom=$(_clia_champ_yaml "$1" livrable || printf '')
  printf '%s\n' "${nom:-}"
}

# --------------------------------------------------------------------------
# Lire les données de l'instance
# --------------------------------------------------------------------------

# donnees <harnais> <champs|sections> — « nom<TAB>valeur ».
donnees() {
  [[ -f "$DONNEES" ]] || return 0
  awk -v harnais="$1" -v cible="$2" '
    function valeur(l,   s) {
      s = l
      sub(/^[^:]*:[[:space:]]*/, "", s)
      sub(/[[:space:]]+$/, "", s)
      if (substr(s, 1, 1) == "\"" && substr(s, length(s), 1) == "\"")
        s = substr(s, 2, length(s) - 2)
      return s
    }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    /^[A-Za-z][A-Za-z0-9_-]*:[[:space:]]*$/ {
      courant = $0; sub(/:.*$/, "", courant); bloc = ""; next
    }
    /^  champs:[[:space:]]*$/   { bloc = "champs";   next }
    /^  sections:[[:space:]]*$/ { bloc = "sections"; next }
    courant == harnais && bloc == cible && /^    [A-Za-z]/ {
      n = $0
      sub(/^[[:space:]]+/, "", n)
      sub(/:.*$/, "", n)
      printf "%s\t%s\n", n, valeur($0)
    }
  ' "$DONNEES"
}

pose() {
  [[ -f "$DONNEES" ]] || return 1
  grep -qE "^$1:[[:space:]]*$" "$DONNEES"
}

# Les harnais que l'instance porte, dans l'ordre du fichier.
instancies() {
  [[ -f "$DONNEES" ]] || return 0
  sed -nE 's/^([A-Za-z][A-Za-z0-9_-]*):[[:space:]]*$/\1/p' "$DONNEES"
  return 0
}

# --------------------------------------------------------------------------
# Ce qui vaut, une fois le schéma et les données confrontés
# --------------------------------------------------------------------------
#
# Le schéma donne la liste et les défauts ; les données passent devant. Une
# donnée hors schéma est signalée plutôt que tue : elle a été écrite par
# quelqu'un qui attendait un effet, et n'en obtient aucun.

# valeurs <harnais> <schéma> — « champ|section<TAB>nom<TAB>valeur ».
valeurs() {
  local harnais="$1" schema="$2" type nom valeur defaut desc inconnus
  local -A donne
  for type in champs sections; do
    donne=()
    while IFS=$'\t' read -r nom valeur; do
      [[ -n "$nom" ]] && donne["$nom"]="$valeur"
    done < <(donnees "$harnais" "$type")

    while IFS=$'\t' read -r nom defaut desc; do
      [[ -n "$nom" ]] || continue
      if [[ -n "${donne[$nom]+x}" ]]; then
        printf '%s\t%s\t%s\n' "${type%s}" "$nom" "${donne[$nom]}"
        unset "donne[$nom]"
      else
        printf '%s\t%s\t%s\n' "${type%s}" "$nom" "$defaut"
      fi
    done < <(entrees "$schema" "$type")

    inconnus=$(printf '%s\n' "${!donne[@]}" | grep -v '^$' | sort | tr '\n' ' ' || true)
    [[ -n "$inconnus" ]] && {
      _clia_msg "$harnais : le schéma ne déclare pas ${inconnus% }"
      _clia_detail "ces ${type} sont ignorés ; le schéma : ${schema#"$CLIA_SOURCE_DIR"/}"
    }
  done
  return 0
}

# --------------------------------------------------------------------------
# Le rendu
# --------------------------------------------------------------------------

# rendre <gabarit> <fichier de valeurs> — le livrable, sur la sortie standard.
rendre() {
  awk -v fval="$2" '
    function substituer(ligne,   out, p, reste, fin, nom) {
      out = ""
      while ((p = index(ligne, "{{")) > 0) {
        out = out substr(ligne, 1, p - 1)
        reste = substr(ligne, p + 2)
        fin = index(reste, "}}")
        if (fin == 0) { out = out "{{"; ligne = reste; continue }
        nom = substr(reste, 1, fin - 1)
        if (nom in champ) {
          out = out champ[nom]
        } else {
          if (!(nom in manquant)) { manquant[nom] = 1; nb_manquant++ }
          out = out "{{" nom "}}"
        }
        ligne = substr(reste, fin + 2)
      }
      return out ligne
    }
    BEGIN {
      while ((getline l < fval) > 0) {
        n = split(l, p, "\t")
        if (n < 2) continue
        if (p[1] == "champ")        champ[p[2]] = p[3]
        else if (p[1] == "section") section[p[2]] = p[3]
      }
      close(fval)
      actif = 1
      ouvert = ""
      erreur = ""
      nb_manquant = 0
    }
    /^\{\{#section [a-z0-9-]+\}\}$/ {
      nom = $0
      sub(/^\{\{#section /, "", nom)
      sub(/\}\}$/, "", nom)
      if (ouvert != "") { erreur = "section imbriquée : " nom; exit 1 }
      if (!(nom in section)) { erreur = "section absente du schéma : " nom; exit 1 }
      ouvert = nom
      actif = (section[nom] == "oui")
      next
    }
    $0 == "{{/section}}" {
      if (ouvert == "") { erreur = "fin de section sans début"; exit 1 }
      ouvert = ""
      actif = 1
      next
    }
    actif { print substituer($0) }
    END {
      if (erreur == "" && ouvert != "") erreur = "section non refermée : " ouvert
      if (erreur == "" && nb_manquant > 0) {
        erreur = "champ absent du schéma :"
        for (m in manquant) erreur = erreur " " m
      }
      if (erreur != "") {
        print "clia: gabarit — " erreur > "/dev/stderr"
        exit 1
      }
    }
  ' "$1"
}

# generer <harnais> — écrit le livrable, et imprime son chemin relatif.
generer() {
  local harnais="$1" schema gabarit livrable cible val
  schema=$(schema_de "$harnais")
  gabarit=$(gabarit_de "$harnais")
  livrable=$(livrable_de "$schema")
  if [[ -z "$livrable" ]]; then
    _clia_msg "$harnais : son schéma ne déclare pas de livrable"
    _clia_detail "déclarez « livrable: <fichier> » dans ${schema#"$CLIA_SOURCE_DIR"/}"
    return 1
  fi

  val=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$val'" RETURN
  valeurs "$harnais" "$schema" > "$val"

  cible="$INSTANCE/$livrable"
  mkdir -p "$(dirname "$cible")"
  rendre "$gabarit" "$val" > "$cible.nouveau" || {
    rm -f "$cible.nouveau"
    _clia_msg "$harnais n'a pas pu être rendu : rien n'a été écrit"
    return 1
  }
  mv "$cible.nouveau" "$cible"
  printf '%s/%s\n' "$INSTANCE_REL" "$livrable"
  return 0
}

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------
#
# L'état d'un harnais se constate, il ne se croit pas : le livrable est
# comparé à ce que ses données rendraient aujourd'hui. C'est le seul moyen de
# dire « à jour » sans le supposer.

etat_de() {
  local harnais="$1" schema livrable cible val rendu
  pose "$harnais" || { printf 'absent\n'; return 0; }

  schema=$(schema_de "$harnais")
  livrable=$(livrable_de "$schema")
  cible="$INSTANCE/$livrable"
  [[ -f "$cible" ]] || { printf 'à régénérer\n'; return 0; }

  val=$(mktemp)
  rendu=$(mktemp)
  valeurs "$harnais" "$schema" > "$val" 2>/dev/null
  if rendre "$(gabarit_de "$harnais")" "$val" > "$rendu" 2>/dev/null \
     && cmp -s "$rendu" "$cible"; then
    printf 'à jour\n'
  else
    printf 'à régénérer\n'
  fi
  rm -f "$val" "$rendu"
  return 0
}

lister() {
  local nom g s livrable actives total type n v lignes=''

  if [[ -z "$(offerts)" ]]; then
    _clia_msg "la ressource harness-ia n'offre aucun gabarit"
    _clia_detail "l'installation de clia est-elle complète ?"
    return 1
  fi

  while IFS=$'\t' read -r nom g s; do
    [[ -n "$nom" ]] || continue
    livrable=$(livrable_de "$s")
    actives=0
    total=0
    while IFS=$'\t' read -r type _ v; do
      [[ "$type" == 'section' ]] || continue
      total=$((total + 1))
      [[ "$v" == 'oui' ]] && actives=$((actives + 1))
    done < <(valeurs "$nom" "$s" 2>/dev/null)
    lignes+=$(printf '%s\t%s\t%s\t%s/%s' \
      "$nom" "${livrable:-—}" "$(etat_de "$nom")" "$actives" "$total")$'\n'
  done < <(offerts)

  { printf 'HARNAIS\tLIVRABLE\tETAT\tSECTIONS\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  _clia_msg "instance : $INSTANCE_REL"
  [[ -f "$DONNEES" ]] || _clia_detail "elle n'existe pas encore ; clia hrn new HARNAIS la pose"
  return 0
}

# --------------------------------------------------------------------------
# new
# --------------------------------------------------------------------------

entete_donnees() {
  cat <<'FIN'
# Les harnais IA de ce dépôt.
#
# Ce fichier est la primitive : c'est lui qui s'édite. Les fichiers qui
# l'accompagnent en sont générés, et la régénération les écrase — ce qu'il y
# a à changer est ici.
#
# Une section vaut « oui » ou « non » : la garder, ou la retirer. Un champ
# vaut ce que son texte doit dire.
#
#   clia hrn ls        ce qui est offert, et où en est ce dépôt
#   clia hrn gen       régénérer les livrables
FIN
}

# Une valeur qui porterait un guillemet double ne pourrait plus être relue
# telle qu'elle a été écrite. Le cas ne se présente pas dans les schémas
# actuels ; s'il se présentait, mieux vaut refuser que rendre un fichier que
# rien ne peut relire.
valeur_ecrivable() {
  [[ "$1" != *'"'* ]]
}

bloc_donnees() {
  local harnais="$1" schema="$2" type nom defaut desc
  printf '\n%s:\n' "$harnais"
  for type in champs sections; do
    printf '  %s:\n' "$type"
    while IFS=$'\t' read -r nom defaut desc; do
      [[ -n "$nom" ]] || continue
      valeur_ecrivable "$defaut" || return 1
      [[ -n "$desc" ]] && printf '    # %s\n' "$desc"
      if [[ "$defaut" == *'#'* || "$defaut" == *':'* ]]; then
        printf '    %s: "%s"\n' "$nom" "$defaut"
      else
        printf '    %s: %s\n' "$nom" "$defaut"
      fi
    done < <(entrees "$schema" "$type")
  done
  return 0
}

poser() {
  local harnais="$1" schema
  schema=$(schema_de "$harnais")

  if pose "$harnais"; then
    _clia_msg "$harnais est déjà posé dans $DONNEES_REL"
    _clia_detail "ses données appartiennent au dépôt : elles ne sont pas écrasées"
    _clia_detail "pour régénérer son livrable : clia hrn gen $harnais"
    return 1
  fi

  mkdir -p "$INSTANCE"
  if [[ ! -f "$DONNEES" ]]; then
    entete_donnees > "$DONNEES"
    _clia_msg "instance posée : $INSTANCE_REL"
  fi

  if ! bloc_donnees "$harnais" "$schema" >> "$DONNEES"; then
    _clia_msg "$harnais : une valeur par défaut porte un guillemet double"
    _clia_detail "corrigez ${schema#"$CLIA_SOURCE_DIR"/}, puis recommencez"
    return 1
  fi

  _clia_msg "$harnais : données posées dans $DONNEES_REL"
  generer "$harnais" || return 1
  _clia_detail "le livrable est généré : éditez $DONNEES_REL, puis clia hrn gen"
  _clia_detail "rien n'est commité"
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
    _clia_msg "clia hrn attend un verbe"
    _clia_detail "l'usage : clia hrn --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  new)
    (( $# == 1 )) || {
      _clia_msg "new attend un harnais, et un seul"
      _clia_detail "l'usage : clia hrn new HARNAIS"
      exit 2
    }
    HARNAIS=$(resoudre "$1") || exit 1
    poser "$HARNAIS" || exit 1 ;;

  gen)
    (( $# <= 1 )) || {
      _clia_msg "gen n'attend qu'un harnais : $*"
      _clia_detail "l'usage : clia hrn gen [HARNAIS]"
      exit 2
    }
    if (( $# == 1 )); then
      HARNAIS=$(resoudre "$1") || exit 1
      if ! pose "$HARNAIS"; then
        _clia_msg "$HARNAIS n'est pas posé dans ce dépôt"
        _clia_detail "pour le poser : clia hrn new $HARNAIS"
        exit 1
      fi
      generer "$HARNAIS" || exit 1
    else
      NB=0
      while read -r HARNAIS; do
        [[ -n "$HARNAIS" ]] || continue
        if ! schema_de "$HARNAIS" >/dev/null; then
          _clia_msg "$HARNAIS est posé dans $DONNEES_REL, et la ressource ne l'offre pas"
          _clia_detail "ses données sont laissées telles quelles, et rien n'est généré"
          continue
        fi
        generer "$HARNAIS" || exit 1
        NB=$((NB + 1))
      done < <(instancies)
      if (( NB == 0 )); then
        _clia_msg "ce dépôt ne porte aucun harnais"
        _clia_detail "pour en poser un : clia hrn new HARNAIS"
        _clia_detail "ceux qui sont offerts : clia hrn ls"
        exit 1
      fi
      _clia_msg "$NB harnais régénéré(s)"
    fi ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia hrn --help"
    exit 2 ;;
esac
