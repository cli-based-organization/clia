# shellcheck shell=bash
# _scripts/lib/maj.sh — le corps commun de clia upgrade, downgrade et migrate.
#
# Implémente la seconde moitié de .dev/usages/USE-007.
#
# Ce que ces commandes mettent à jour, c'est le **dépôt courant** : ce qui y
# est installé, repris de l'installation de clia et des dépôts d'extension.
# Elles ne déplacent pas clia lui-même — l'installation appartient à setup.sh,
# et un dépôt ne réécrit pas le code qui l'instrumente.
#
# Elles n'ont pas de garde propre : chaque geste est délégué à la commande qui
# le porte déjà — clia res upgrade, clia extension upgrade, clia skill install.
# Le refus d'écraser une copie modifiée, la reprise à la bonne version,
# l'inscription à l'inventaire vivent donc à un seul endroit. Ce fichier
# ordonne et rapporte, il ne réimplémente rien.
#
# Trois commandes et un seul corps : elles ne diffèrent que par le sens du
# déplacement et par leurs défauts. Trois fichiers séparés dans lib/cmd/, en
# revanche, parce qu'un alias du dispatcher répond sous plusieurs noms sans
# savoir lequel a été employé — et ici, le nom employé est la demande.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

SENS="${_CLIA_SENS:-upgrade}"

RES="$CLIA_SOURCE_DIR/_ressources/ressource/scripts/res.sh"
EXT="$CLIA_SOURCE_DIR/_scripts/lib/cmd/extension.sh"
SKILL="$CLIA_SOURCE_DIR/_ressources/skill/scripts/skill.sh"
FEATURE="$CLIA_SOURCE_DIR/_scripts/lib/cmd/feature.sh"

NAMESPACE_LOCAL=$(_clia_carte_champ "$CLIA_WORK_DIR" namespace 2>/dev/null || printf '')

# --------------------------------------------------------------------------

aide() {
  case "$SENS" in
    migrate)
      cat <<'EOF'
Usage : clia migrate [RESSOURCE] [--to X.Y.Z]

Amène les instances du dépôt à la version de leur type. Sans argument, toutes
les ressources installées ; avec un nom, celle-là seule.

Une instance déclare sa version dans son frontmatter. Le passage d'une
version à l'autre est décrit par _ressources/RESSOURCE/scripts/migrations/
X.Y.Z.sh, un script par version, qui reçoit une instance en argument. Une
version sans script n'a pas changé le format : le marqueur suffit.

  --to X.Y.Z   migrer vers cette version plutôt que vers celle du type

Pour une instance et une seule : clia res migrate RESSOURCE INSTANCE

Codes de retour :
  0  la demande est satisfaite
  1  au moins une migration a échoué
  2  demande mal formée
EOF
      ;;
    downgrade)
      cat <<'EOF'
Usage : clia downgrade [NAMESPACE] [X.Y.Z] [--force]

Ramène en arrière ce que le dépôt a repris d'ailleurs. Sans argument, chaque
ressource installée recule d'une version. Les clones d'extension ne sont pas
touchés : reculer ne demande rien de neuf.

  NAMESPACE   ne traiter que ce qui vient de cette provenance
  X.Y.Z       la version de la PROVENANCE, non celle d'une ressource : le
              dépôt reprend ses ressources telles qu'elles étaient quand ce
              dépôt-là se déclarait en X.Y.Z. Exige un namespace quand le
              dépôt a plusieurs provenances.
  --force     reprendre même une ressource modifiée sur place, en l'écrasant

Une ressource née dans ce dépôt n'a pas de provenance : elle n'est pas
touchée. Le harnais IA non plus — son corps appartient au dépôt, et seul
clia harness-ia init --force le régénère.

Codes de retour :
  0  la demande est satisfaite, même s'il n'y avait rien à faire
  1  au moins un geste a échoué
  2  demande mal formée
EOF
      ;;
    *)
      cat <<'EOF'
Usage : clia upgrade [NAMESPACE] [X.Y.Z] [--migrate] [--force]

Met à jour ce que le dépôt a repris d'ailleurs, à partir de l'installation de
clia et des dépôts d'extension. Dans l'ordre :

  1  les clones d'extension sont remis à jour
  2  chaque ressource installée est reprise à la version offerte
  3  les skills et fonctionnalités des ressources reprises sont reposés
  4  le harnais est signalé s'il est en retard, jamais réécrit

  NAMESPACE   ne traiter que ce qui vient de cette provenance
  X.Y.Z       la version de la PROVENANCE, non celle d'une ressource : le
              dépôt reprend ses ressources telles qu'elles étaient quand ce
              dépôt-là se déclarait en X.Y.Z. Exige un namespace quand le
              dépôt a plusieurs provenances.
  --migrate   enchaîner la migration des instances de ce qui a été repris
  --force     reprendre même une ressource modifiée sur place, en l'écrasant

Une ressource née dans ce dépôt n'a pas de provenance : elle n'est pas
touchée. Le harnais IA non plus — son corps appartient au dépôt, et seul
clia harness-ia init --force le régénère.

Ce que le dépôt a d'en retard, sans rien reprendre : clia check

Codes de retour :
  0  la demande est satisfaite, même s'il n'y avait rien à faire
  1  au moins un geste a échoué
  2  demande mal formée
EOF
      ;;
  esac
}

# --------------------------------------------------------------------------
# La demande
# --------------------------------------------------------------------------

NAMESPACE=''
VERSION=''
RESSOURCE=''
MIGRER=0
FORCE=0
attend_to=0

for arg in "$@"; do
  if (( attend_to == 1 )); then VERSION="$arg"; attend_to=0; continue; fi
  case "$arg" in
    -h|--help|help) aide; exit 0 ;;
    --migrate)
      if [[ "$SENS" != 'upgrade' ]]; then
        _clia_msg "--migrate n'a de sens qu'avec upgrade"
        exit 2
      fi
      MIGRER=1 ;;
    --force)
      if [[ "$SENS" == 'migrate' ]]; then
        _clia_msg "option inconnue pour migrate : --force"
        exit 2
      fi
      FORCE=1 ;;
    --to)
      if [[ "$SENS" != 'migrate' ]]; then
        _clia_msg "--to n'a de sens qu'avec migrate"
        _clia_detail "pour $SENS, la version se donne sans option : clia $SENS X.Y.Z"
        exit 2
      fi
      attend_to=1 ;;
    --to=*)
      if [[ "$SENS" != 'migrate' ]]; then
        _clia_msg "--to n'a de sens qu'avec migrate"
        exit 2
      fi
      VERSION="${arg#--to=}" ;;
    -*)
      _clia_msg "option inconnue pour $SENS : $arg"
      _clia_detail "l'aide : clia $SENS --help"
      exit 2 ;;
    *)
      if [[ "$SENS" == 'migrate' ]]; then
        if [[ -z "$RESSOURCE" ]]; then RESSOURCE="$arg"
        else _clia_msg "migrate ne prend qu'une ressource : $*"; exit 2; fi
      # Un namespace est un couple « publisher/nom » ; une suite de chiffres et
      # de points n'en est jamais un. Les deux arguments facultatifs se
      # distinguent donc sans avoir à être ordonnés — et « 0.9 », pris pour une
      # version, se fait dire qu'il en est une mal formée plutôt que d'être
      # cherché parmi les provenances.
      elif [[ "$arg" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
        if [[ -z "$VERSION" ]]; then VERSION="$arg"
        else _clia_msg "deux versions demandées : $*"; exit 2; fi
      else
        if [[ -z "$NAMESPACE" ]]; then NAMESPACE="$arg"
        else _clia_msg "deux namespaces demandés : $*"; exit 2; fi
      fi ;;
  esac
done

if (( attend_to == 1 )); then
  _clia_msg "--to attend une version X.Y.Z"
  exit 2
fi
if [[ -n "$VERSION" && ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  _clia_msg "version invalide : $VERSION"
  _clia_detail "attendu X.Y.Z, trois nombres séparés par des points"
  exit 2
fi

# --------------------------------------------------------------------------
# Le rapport
# --------------------------------------------------------------------------

GESTES=''
FAITS=0
ECHECS=0

geste()   { GESTES+="$1"$'\t'"$2"$'\n'; }
fait()    { geste "$1" "$2"; FAITS=$((FAITS + 1)); }
echoue()  { geste 'échec' "$1"; ECHECS=$((ECHECS + 1)); }

rendre() {
  printf 'dépôt      %s\n' "$CLIA_WORK_DIR"
  printf 'namespace  %s\n' "${NAMESPACE_LOCAL:-—}"
  printf '\n'
  # Aligné par column et non par printf : un « é » tient sur deux octets, et
  # %-9s compte les octets. Les marques accentuées décaleraient la colonne.
  if [[ -n "$GESTES" ]]; then
    printf '%s' "$GESTES" | column -t -s"$(printf '\t')"
    printf '\n'
  fi
}

# --------------------------------------------------------------------------
# Ce que le dépôt tient d'ailleurs
# --------------------------------------------------------------------------

# Les namespaces dont le dépôt a repris quelque chose, une fois chacun. Une
# ressource née ici n'en est pas : elle n'a pas de provenance à interroger.
provenances() {
  local type ns nom vus=$'\n'
  while IFS=$'\t' read -r type ns nom _ _; do
    [[ "$type" == 'ressource' || "$type" == 'extension' ]] || continue
    [[ -n "$ns" && "$ns" != '—' ]] || continue
    [[ -n "$NAMESPACE_LOCAL" && "$ns" == "$NAMESPACE_LOCAL" ]] && continue
    [[ "$vus" == *$'\n'"$ns"$'\n'* ]] && continue
    vus+="$ns"$'\n'
    printf '%s\n' "$ns"
  done < <(_clia_installe "$CLIA_WORK_DIR")
  return 0
}

# Les ressources installées qui viennent d'ailleurs, filtrées par namespace.
# Sortie : « nom<TAB>namespace<TAB>version installée ».
ressources_reprises() {
  local type ns nom v
  while IFS=$'\t' read -r type ns nom v _; do
    [[ "$type" == 'ressource' ]] || continue
    [[ -n "$ns" && "$ns" != '—' ]] || continue
    [[ -n "$NAMESPACE_LOCAL" && "$ns" == "$NAMESPACE_LOCAL" ]] && continue
    [[ -n "$NAMESPACE" && "$ns" != "$NAMESPACE" ]] && continue
    [[ -d "$CLIA_WORK_DIR/_ressources/$nom" ]] || continue
    printf '%s\t%s\t%s\n' "$nom" "$ns" "$v"
  done < <(_clia_installe "$CLIA_WORK_DIR")
  return 0
}

version_installee() {
  _clia_installe_entree "$CLIA_WORK_DIR" ressource "$1" | awk -F'\t' '{print $4}'
}

# Le dépôt d'où vient un namespace, ou rien.
depot_de() {
  _clia_remotes_filtres "$1" 2>/dev/null | head -1 | awk -F'\t' '{print $2}'
}

# La version qu'une ressource portait quand sa provenance se déclarait en
# VERSION. Rend 1, sans rien écrire, quand la provenance n'avait pas encore
# cette ressource à ce moment-là. Que la provenance ait connu cette version
# est vérifié une fois pour toutes avant d'en arriver ici.
version_a_la_version() {
  local nom="$1" ns="$2" ligne depot commit v
  ligne=$(_clia_offre_ressource "$nom" "$ns") || return 1
  depot=$(printf '%s' "$ligne" | awk -F'\t' '{print $2}')
  commit=$(_clia_commit_de_version "$depot" "$VERSION") || return 1
  v=$(_clia_version_ressource_au_commit "$depot" "$nom" "$commit")
  [[ -n "$v" ]] || return 1
  printf '%s\n' "$v"
}

# --------------------------------------------------------------------------
# Les gestes
# --------------------------------------------------------------------------

# 1. Les clones d'extension. Seul upgrade les touche : reculer ne demande
# rien de neuf, et tirer le dépôt d'origine pour ensuite reculer serait un
# geste qui se contredit.
majorer_extensions() {
  local ns uri avant apres cache
  while IFS=$'\t' read -r ns uri; do
    [[ -n "$ns" ]] || continue
    [[ -n "$NAMESPACE" && "$ns" != "$NAMESPACE" ]] && continue
    cache=$(_clia_extension_cache "$ns")
    if [[ ! -d "$cache" ]]; then
      echoue "extension $ns : déclarée, non clonée — clia extension add ${uri:-<uri>}"
      continue
    fi
    avant=$(_clia_carte_champ "$cache" version 2>/dev/null || printf '—')
    if bash "$EXT" upgrade "$ns" >/dev/null 2>&1; then
      apres=$(_clia_carte_champ "$cache" version 2>/dev/null || printf '—')
      if [[ "$avant" == "$apres" ]]; then
        geste 'à jour' "extension $ns, en $apres"
      else
        fait 'repris' "extension $ns : $avant -> $apres"
      fi
    else
      echoue "extension $ns : le clone n'a pas pu être mis à jour"
    fi
  done < <(_clia_extensions_declarees "$CLIA_WORK_DIR")
  return 0
}

# 2. Les ressources. REPRISES garde celles qui ont bougé : ce sont elles dont
# les skills, les fonctionnalités et les instances ont à suivre.
REPRISES=''

majorer_ressources() {
  local nom ns installee cible avant apres sortie
  local -a options
  while IFS=$'\t' read -r nom ns installee; do
    [[ -n "$nom" ]] || continue

    cible=''
    if [[ -n "$VERSION" ]]; then
      if ! cible=$(version_a_la_version "$nom" "$ns"); then
        geste 'sauté' "ressource $nom : $ns n'avait pas cette ressource en $VERSION"
        continue
      fi
      if [[ "$cible" == "$installee" ]]; then
        geste 'à jour' "ressource $nom, déjà en $cible"
        continue
      fi
      # Le sens demandé et le sens réel doivent concorder : la version d'un
      # dépôt ne dit pas à elle seule si ses ressources avancent ou reculent.
      local comparaison
      comparaison=$(_clia_semver_cmp "$cible" "${installee:-0}")
      if [[ "$SENS" == 'upgrade' && "$comparaison" == '-1' ]]; then
        geste 'sauté' "ressource $nom : $cible est antérieure à $installee — clia downgrade"
        continue
      fi
      if [[ "$SENS" == 'downgrade' && "$comparaison" == '1' ]]; then
        geste 'sauté' "ressource $nom : $cible est postérieure à $installee — clia upgrade"
        continue
      fi
    fi

    options=("$SENS" "$nom")
    [[ -n "$cible" ]] && options+=("$cible")
    (( FORCE == 1 )) && options+=(--force)

    avant=$(version_installee "$nom")
    if sortie=$(bash "$RES" "${options[@]}" 2>&1); then
      apres=$(version_installee "$nom")
      if [[ "$avant" == "$apres" ]]; then
        geste 'à jour' "ressource $nom, en $apres"
      else
        fait 'repris' "ressource $nom : $avant -> $apres"
        REPRISES+="$nom"$'\n'
      fi
    elif printf '%s' "$sortie" | grep -q 'modifiée dans ce dépôt'; then
      geste 'sauté' "ressource $nom : modifiée ici — clia $SENS --force l'écraserait"
    elif printf '%s' "$sortie" | grep -q "aucune version.*antérieure"; then
      geste 'à jour' "ressource $nom : aucune version antérieure à $avant"
    else
      echoue "ressource $nom : clia res $SENS $nom dira pourquoi"
    fi
  done < <(ressources_reprises)
  return 0
}

# 3. Ce qui a été posé hors du répertoire de la ressource. Le fichier d'un
# skill et la section d'une fonctionnalité sont des copies : elles ne suivent
# pas la ressource, il faut les reposer.
a_ete_reprise() {
  [[ "$REPRISES" == *$'\n'"$1"$'\n'* || "$REPRISES" == "$1"$'\n'* ]]
}

reposer_extensions_du_harnais() {
  [[ -n "$REPRISES" ]] || return 0

  local type nom ressource fichier
  while IFS=$'\t' read -r type _ nom _ _; do
    [[ "$type" == 'skill' ]] || continue
    [[ -f "$CLIA_WORK_DIR/.claude/skills/$nom/SKILL.md" ]] || continue
    fichier=$(_clia_concept_fichier "$CLIA_WORK_DIR" skills "$nom")
    [[ -n "$fichier" ]] || continue
    ressource="${fichier#"$CLIA_WORK_DIR"/_ressources/}"
    ressource="${ressource%/skills/*}"
    a_ete_reprise "$ressource" || continue
    if bash "$SKILL" install "$nom" >/dev/null 2>&1; then
      fait 'reposé' "skill $nom, de la ressource $ressource"
    else
      echoue "skill $nom : la repose a échoué"
    fi
  done < <(_clia_installe "$CLIA_WORK_DIR")

  while IFS=$'\t' read -r type _ nom _ _; do
    [[ "$type" == 'feature' ]] || continue
    fichier=$(_clia_concept_fichier "$CLIA_WORK_DIR" features "$nom")
    [[ -n "$fichier" ]] || continue
    ressource="${fichier#"$CLIA_WORK_DIR"/_ressources/}"
    ressource="${ressource%/features/*}"
    a_ete_reprise "$ressource" || continue
    # Retirer puis reposer : c'est le seul moyen de remplacer une section, et
    # la zone gérée du harnais est faite pour être réécrite. La source est
    # vérifiée juste au-dessus — on ne retire pas ce qu'on ne saurait remettre.
    if bash "$FEATURE" uninstall "$nom" >/dev/null 2>&1 \
       && bash "$FEATURE" install "$nom" >/dev/null 2>&1; then
      fait 'reposé' "fonctionnalité $nom, de la ressource $ressource"
    else
      echoue "fonctionnalité $nom : la repose a échoué — clia feature install $nom"
    fi
  done < <(_clia_installe "$CLIA_WORK_DIR")
  return 0
}

# 4. Le harnais. Signalé, jamais réécrit : hors de ses deux zones gérées, son
# corps appartient au dépôt. Le régénérer est une décision, et elle a sa
# commande. PDC-002.
signaler_harnais() {
  local attendue posee
  attendue=$(_clia_def_champ harness-ia version 2>/dev/null || printf '')
  posee=$(_clia_installe_entree "$CLIA_WORK_DIR" harness harness-ia | awk -F'\t' '{print $4}')
  [[ -f "$CLIA_WORK_DIR/CLAUDE.md" ]] || return 0
  [[ -n "$attendue" && -n "$posee" ]] || return 0
  [[ "$posee" == "$attendue" ]] && return 0
  geste 'signalé' "harnais en $posee, clia en offre $attendue — clia harness-ia init --force"
  return 0
}

# 5. Les instances. Déléguée à res migrate, qui sait ce qu'un passage de
# version demande à une instance.
#
# Le second argument dit si la ressource a été nommée par l'humain. Nommée,
# une ressource sans instance mérite qu'on le dise — c'est la réponse à sa
# demande. Balayée parmi les autres, elle ne mérite qu'un silence : un dépôt
# porte une dizaine de ressources et deux ont des instances.
migrer_une() {
  local nom="$1" nommee="${2:-0}" sortie bilan
  local -a options=(migrate "$nom" --all)
  [[ -n "$VERSION" && "$SENS" == 'migrate' ]] && options+=(--to "$VERSION")

  if ! sortie=$(bash "$RES" "${options[@]}" 2>&1); then
    echoue "instances de $nom : clia res migrate $nom --all dira pourquoi"
    return 0
  fi
  if printf '%s' "$sortie" | grep -q 'aucune instance'; then
    (( nommee == 1 )) && geste 'à jour' "instances de $nom : aucune"
    return 0
  fi

  # Le bilan de res migrate, ou rien s'il ne l'a pas rendu : grep sort en 1
  # quand il ne trouve pas, et sous « set -e » une affectation qui échoue
  # arrêterait la commande sans rien rapporter.
  bilan=$(printf '%s' "$sortie" | grep -o '[0-9]* migrée(s).*' | tail -1 || printf '')
  if printf '%s' "$bilan" | grep -q '^0 migrée(s), 0 marquée(s)'; then
    geste 'à jour' "instances de $nom : $bilan"
  else
    fait 'migré' "instances de $nom : ${bilan:-migrées}"
  fi
  return 0
}

# --------------------------------------------------------------------------
# Le déroulé
# --------------------------------------------------------------------------

if [[ ! -f "$(_clia_carte "$CLIA_WORK_DIR")" ]]; then
  _clia_msg "ce dépôt ne porte pas .dev/clia.yaml"
  _clia_detail "rien ne dit ce qui y est installé, ni d'où cela vient"
  _clia_detail "pour le poser : clia check --fix"
  exit 1
fi

# Une version demandée nomme celle d'une provenance. Avec plusieurs
# provenances, la même X.Y.Z en désignerait plusieurs à la fois : le namespace
# est alors exigé plutôt que choisi au hasard.
if [[ -n "$VERSION" && "$SENS" != 'migrate' && -z "$NAMESPACE" ]]; then
  N_PROV=$(provenances | grep -c . || true)
  if (( N_PROV == 0 )); then
    _clia_msg "$VERSION est la version d'une provenance, et ce dépôt n'en a aucune"
    _clia_detail "tout ce qu'il porte est né ici : sa version se change dans sa définition"
    exit 1
  fi
  if (( N_PROV > 1 )); then
    _clia_msg "$VERSION est la version d'une provenance, et ce dépôt en a $N_PROV"
    _clia_detail "précisez laquelle : clia $SENS NAMESPACE $VERSION"
    _clia_detail "celles de ce dépôt :"
    while IFS= read -r p; do [[ -n "$p" ]] && _clia_detail "  $p"; done < <(provenances)
    exit 2
  fi
  NAMESPACE=$(provenances | head -1)
fi

if [[ -n "$NAMESPACE" ]] && ! provenances | grep -qx -- "$NAMESPACE"; then
  _clia_msg "ce dépôt n'a rien repris de $NAMESPACE"
  _clia_detail "ses provenances :"
  N_PROV=$(provenances | grep -c . || true)
  if (( N_PROV == 0 )); then
    _clia_detail "  aucune — tout ce qu'il porte est né ici"
  else
    while IFS= read -r p; do [[ -n "$p" ]] && _clia_detail "  $p"; done < <(provenances)
  fi
  exit 1
fi

# La version demandée est celle d'un dépôt : qu'il se soit déclaré ainsi se
# vérifie ici, une fois, plutôt qu'à chaque ressource. Une version inconnue
# n'est pas un cas particulier de chaque ressource — c'est la demande qui ne
# désigne rien.
if [[ -n "$VERSION" && "$SENS" != 'migrate' ]]; then
  DEPOT_PROV=$(depot_de "$NAMESPACE")
  if [[ -z "$DEPOT_PROV" ]]; then
    _clia_msg "la provenance $NAMESPACE n'est pas joignable sur cette machine"
    _clia_detail "son clone : clia extension add URI"
    exit 1
  fi
  if ! _clia_commit_de_version "$DEPOT_PROV" "$VERSION" >/dev/null; then
    _clia_msg "$NAMESPACE ne s'est jamais déclaré en version $VERSION"
    _clia_detail "les versions qu'il a publiées :"
    N_VERS=0
    while IFS= read -r v; do
      [[ -n "$v" ]] || continue
      _clia_detail "  $v"
      N_VERS=$((N_VERS + 1))
    done < <(_clia_versions_de_depot "$DEPOT_PROV" | head -10)
    (( N_VERS == 0 )) && _clia_detail "  aucune — son historique ne porte pas de version"
    exit 1
  fi
fi

case "$SENS" in
  migrate)
    if [[ -n "$RESSOURCE" ]]; then
      if [[ ! -d "$CLIA_WORK_DIR/_ressources/$RESSOURCE" ]]; then
        _clia_msg "la ressource $RESSOURCE n'est pas dans ce dépôt"
        _clia_detail "celles qui y sont : clia res ls"
        exit 1
      fi
      migrer_une "$RESSOURCE" 1
    else
      NOM=''
      while IFS=$'\t' read -r NOM _; do
        [[ -n "$NOM" ]] || continue
        migrer_une "$NOM" 0
      done < <(_clia_ressources_de "$CLIA_WORK_DIR")
    fi
    ;;
  *)
    [[ "$SENS" == 'upgrade' ]] && majorer_extensions
    majorer_ressources
    reposer_extensions_du_harnais
    signaler_harnais
    if (( MIGRER == 1 )); then
      while IFS= read -r NOM; do
        [[ -n "$NOM" ]] || continue
        migrer_une "$NOM"
      done <<<"$REPRISES"
    fi
    ;;
esac

# --------------------------------------------------------------------------

rendre

if [[ -z "$GESTES" ]]; then
  case "$SENS" in
    migrate) _clia_msg "aucune ressource n'a d'instance à migrer dans ce dépôt" ;;
    *)       _clia_msg "ce dépôt n'a rien repris d'ailleurs, il n'y a rien à mettre à jour"
             _clia_detail "ce qu'il porte : clia res ls" ;;
  esac
  exit 0
fi

if (( ECHECS > 0 )); then
  _clia_msg "$FAITS geste(s), $ECHECS échec(s)"
  exit 1
fi
if (( FAITS == 0 )); then
  _clia_msg "rien à faire : tout est déjà à jour"
  exit 0
fi
_clia_msg "$FAITS geste(s), aucun échec"
exit 0
