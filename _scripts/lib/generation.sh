# shellcheck shell=bash
# _scripts/lib/generation.sh — le stade généré, et ce qui le construit.
#
# Implémente SES-001 tâche 22, verbe « make ». SPC-002 dit ce qu'est un
# stade ; ce fichier dit comment on passe des primitives au stade généré.
#
# Pourquoi make(1), et non un moteur à nous
# -----------------------------------------
#
# L'énoncé demande de « répliquer le fonctionnement d'un makefile ». Le
# répliquer aurait voulu dire réécrire un graphe de dépendances, un calcul de
# péremption et un ordre d'exécution — trois choses que make tient depuis
# cinquante ans, et que personne ici ne tiendrait mieux.
#
# clia délègue donc, et se contente de ce qu'il sait faire de mieux : trouver
# l'instance, poser l'environnement, et rapporter ce qui s'est produit.
#
#   clia <ressource> make            make -C <instance>
#   clia <ressource> make ls         make -C <instance> -n
#   clia <ressource> make --check    make -C <instance> -q
#
# Ce que la délégation coûte, et qu'il faut dire : clia ne connaît ni les
# cibles, ni les sources, ni les règles. Il ne peut donc rien vérifier de ce
# qui est généré — « --check » demande à make si c'est à jour, et croit sa
# réponse. Un contrôle de conformité du stade généré demanderait que clia
# lise le graphe, donc qu'il cesse de déléguer.
#
# Où cela vit
# -----------
#
#   <instance>/Makefile   les règles, écrites par qui écrit la ressource
#   <instance>/genere/    ce qu'elles produisent
#
# Les deux sont admis par C1 depuis cette tâche — voir conformite.sh. Le
# Makefile est une primitive au sens large : il dit comment produire, et il
# est écrit à la main. Il n'est pas rangé sous primitive-1/ parce qu'il ne
# nourrit pas le livrable, il le construit.

_CLIA_G_MAKEFILES=('GNUmakefile' 'makefile' 'Makefile')

# _clia_g_programme — le programme qui construit.
_clia_g_programme() { printf '%s\n' "${CLIA_MAKE:-make}"; }

# _clia_g_makefile <instance> — le fichier de règles employé, ou rien.
#
# CLIA_MAKEFILE le nomme ; sans lui, les trois noms que make cherche sont
# cherchés dans le même ordre. Nommer le fichier trouvé plutôt que laisser
# make le chercher permet de refuser avant de lancer quoi que ce soit, et de
# dire lequel manque.
_clia_g_makefile() {
  local inst="$1" f
  if [[ -n "${CLIA_MAKEFILE:-}" ]]; then
    [[ -f "$inst/$CLIA_MAKEFILE" ]] || return 1
    printf '%s\n' "$CLIA_MAKEFILE"
    return 0
  fi
  for f in "${_CLIA_G_MAKEFILES[@]}"; do
    [[ -f "$inst/$f" ]] && { printf '%s\n' "$f"; return 0; }
  done
  return 1
}

# --------------------------------------------------------------------------

_clia_g_manuel() {
  local commande="$1"
  sed "s/@CMD@/$commande/g" <<'FIN' | _clia_man "clia-@CMD@-make" 1 "Manuel de l'utilisateur clia"
NOM
clia-@CMD@-make - construire le stade généré à partir des primitives

SYNOPSIS
clia @CMD@ make [CIBLE...]
clia @CMD@ make ls
clia @CMD@ make config ls
clia @CMD@ make --check
clia @CMD@ make --explain

DESCRIPTION
Une ressource passe par trois stades : ses primitives, ce qui en
est généré, ce qui en est livré. Ce verbe construit le deuxième à
partir du premier.

Il ne construit rien lui-même : il lance make(1) dans l'instance
que ce dépôt écrit de la ressource. Les règles sont donc celles
d'un Makefile ordinaire, écrites par qui écrit la ressource.

       <instance>/Makefile   les règles
       <instance>/genere/    ce qu'elles produisent

Le répertoire de travail de make est l'instance. Les chemins d'un
Makefile sont donc relatifs à elle, et un dépôt cloné ailleurs
construit la même chose.

VERBES
ls
       Ce qui serait fait, sans le faire : make -n. C'est le graphe
       de génération tel que make le voit, et le statut de chaque
       cible s'y lit — une cible à jour n'y produit aucune commande.

config ls
       Ce qui règle la génération : le programme employé, le
       fichier de règles lu, et où il est cherché.

OPTIONS
--check
       Demander à make si le stade généré est à jour, sans rien
       construire : make -q. Rend 0 s'il l'est, 1 sinon.

       clia croit la réponse de make. Il ne connaît ni les cibles
       ni les sources, et ne peut donc rien vérifier de plus.

--explain
       Ce que ce verbe fait, et pourquoi il délègue.

--man
       Cette page.

ENVIRONNEMENT
CLIA_MAKE
       Le programme qui construit. Par défaut « make ».

CLIA_MAKEFILE
       Le fichier de règles à lire dans l'instance. Sans lui, les
       noms que make cherche sont cherchés dans le même ordre :
       GNUmakefile, makefile, Makefile.

Ce que make reçoit, en plus de l'environnement de l'appelant :

       CLIA_RESSOURCE   le nom de la ressource
       CLIA_INSTANCE    le répertoire de l'instance
       CLIA_GENERE      le répertoire du stade généré
       CLIA_SOURCE_DIR  le dépôt d'où vient le code de clia
       CLIA_WORK_DIR    le dépôt de travail

CODE DE RETOUR
0
       La construction a réussi, ou il n'y avait rien à faire.

1
       Refus, ou make a échoué. Avec --check, le stade généré
       n'est pas à jour.

2
       Demande mal formée.

EXEMPLES
Construire :

       $ clia @CMD@ make

Voir ce qui serait fait :

       $ clia @CMD@ make ls

Employer un autre fichier de règles :

       $ CLIA_MAKEFILE=Makefile.dev clia @CMD@ make

VOIR AUSSI
clia(1), clia-config(1), make(1), SPC-002-stades
FIN
}

_clia_g_expliquer() {
  local commande="$1"
  cat <<FIN
clia $commande make construit le stade généré d'une ressource à partir de ses
primitives. Il ne construit rien lui-même : il lance make(1) dans l'instance
que ce dépôt écrit.

Ce que clia fait, et c'est tout ce qu'il fait :

  1. il trouve l'instance de la ressource dans ce dépôt
  2. il y cherche le fichier de règles, et refuse s'il manque
  3. il pose CLIA_RESSOURCE, CLIA_INSTANCE et CLIA_GENERE
  4. il lance make(1) avec l'instance pour répertoire de travail
  5. il rapporte ce qui s'est produit

Pourquoi déléguer. L'énoncé demande de répliquer le fonctionnement d'un
makefile. Le répliquer aurait voulu dire réécrire un graphe de dépendances,
un calcul de péremption et un ordre d'exécution — trois choses que make tient
depuis cinquante ans.

Ce que la délégation coûte. clia ne connaît ni les cibles, ni les sources, ni
les règles. « make --check » demande à make si c'est à jour et croit sa
réponse ; « make ls » rend ce que make dirait. Un contrôle de conformité du
stade généré demanderait que clia lise le graphe, donc qu'il cesse de
déléguer.

Le manuel complet : clia $commande make --man
FIN
}

# --------------------------------------------------------------------------

# _clia_g_make <commande> <fichier> <arguments…>
_clia_g_make() {
  local commande="$1" fichier="$2"; shift 2
  local depot="${CLIA_WORK_DIR:-}" nom id inst zone
  local programme makefile verbe='' cibles=() arg

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    return 2
  fi

  for arg in "$@"; do
    case "$arg" in
      --man)     _clia_g_manuel    "$commande"; return 0 ;;
      --explain) _clia_g_expliquer "$commande"; return 0 ;;
      --check)   verbe='check' ;;
      -*) _clia_msg "option inconnue : $arg"
          _clia_detail "l'usage : clia $commande make --help"; return 2 ;;
      ls)     [[ -z "$verbe" ]] && verbe='ls' || cibles+=("$arg") ;;
      config) verbe='config' ;;
      *)      cibles+=("$arg") ;;
    esac
  done

  if [[ "$verbe" == 'config' ]]; then
    # « config » et « config ls » disent la même chose : l'énoncé écrit le
    # second, et un verbe qui n'a qu'une forme n'a pas à l'exiger.
    if (( ${#cibles[@]} > 1 )) || { (( ${#cibles[@]} == 1 )) && [[ "${cibles[0]}" != 'ls' ]]; }; then
      _clia_msg "config n'accepte que « ls » : ${cibles[*]}"
      return 2
    fi
    cibles=()
  fi

  zone=$(_clia_zone_ressource)
  id=$(_clia_instance_de "$depot" "$nom" || printf '')
  if [[ -z "$id" ]]; then
    _clia_msg "ce dépôt n'écrit pas $nom : il n'y a rien à construire ici"
    _clia_detail "un stade généré vit sous une instance, non sous une copie installée"
    _clia_detail "ce que le dépôt écrit : clia res ls"
    return 1
  fi
  inst="$depot/$zone/$id"
  programme=$(_clia_g_programme)

  if [[ "$verbe" == 'config' ]]; then
    _clia_g_config "$nom" "$inst" "$zone/$id" "$programme"
    return 0
  fi

  if ! command -v "$programme" >/dev/null 2>&1; then
    _clia_msg "$programme est introuvable"
    _clia_detail "clia délègue la construction à make(1) ; installez-le, ou"
    _clia_detail "nommez-en un autre : CLIA_MAKE=<programme>"
    return 1
  fi

  if ! makefile=$(_clia_g_makefile "$inst"); then
    if [[ -n "${CLIA_MAKEFILE:-}" ]]; then
      _clia_msg "$zone/$id/$CLIA_MAKEFILE est absent"
      _clia_detail "CLIA_MAKEFILE le nomme ; c'est ce fichier qui est cherché"
    else
      _clia_msg "$nom ne porte aucun fichier de règles"
      _clia_detail "cherchés sous $zone/$id : ${_CLIA_G_MAKEFILES[*]}"
      _clia_detail "les règles disent comment genere/ se construit — SPC-002"
    fi
    return 1
  fi

  export CLIA_RESSOURCE="$nom"
  export CLIA_INSTANCE="$inst"
  export CLIA_GENERE="$inst/genere"

  case "$verbe" in
    ls)
      printf 'ressource  %s\n' "$nom"
      printf 'instance   %s\n' "$zone/$id"
      printf 'règles     %s\n\n' "$makefile"
      "$programme" -C "$inst" -f "$inst/$makefile" -n "${cibles[@]}"
      return $? ;;
    check)
      if "$programme" -C "$inst" -f "$inst/$makefile" -q "${cibles[@]}" >/dev/null 2>&1; then
        _clia_msg "$nom : le stade généré est à jour"
        return 0
      fi
      _clia_msg "$nom : le stade généré n'est pas à jour"
      _clia_detail "ce qui serait fait : clia $commande make ls"
      _clia_detail "pour le construire  : clia $commande make"
      return 1 ;;
    *)
      if "$programme" -C "$inst" -f "$inst/$makefile" "${cibles[@]}"; then
        _clia_msg "$nom : construit sous $zone/$id/genere"
        _clia_detail "rien n'est commité"
        return 0
      fi
      _clia_msg "$nom : $programme a échoué"
      _clia_detail "les règles sont dans $zone/$id/$makefile"
      return 1 ;;
  esac
}

# Ce qui règle la génération. Deux variables, et le reste se déduit.
_clia_g_config() {
  local nom="$1" inst="$2" rel="$3" programme="$4" makefile source_mf
  local source_p='défaut'
  [[ -n "${CLIA_MAKE:-}" ]] && source_p='environnement'

  if makefile=$(_clia_g_makefile "$inst"); then
    if [[ -n "${CLIA_MAKEFILE:-}" ]]; then source_mf='environnement'; else source_mf='trouvé'; fi
  else
    makefile='—'
    if [[ -n "${CLIA_MAKEFILE:-}" ]]; then source_mf='environnement, absent'; else source_mf='aucun'; fi
  fi

  printf 'ressource  %s\n' "$nom"
  printf 'instance   %s\n' "$rel"
  printf 'genere     %s\n\n' "$rel/genere"

  { printf 'VARIABLE%sVALEUR%sSOURCE%sCE QU%sELLE REGLE\n' \
      "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP" "'"
    printf 'CLIA_MAKE%s%s%s%s%sle programme qui construit\n' \
      "$_CLIA_SEP" "$programme" "$_CLIA_SEP" "$source_p" "$_CLIA_SEP"
    printf 'CLIA_MAKEFILE%s%s%s%s%sle fichier de règles lu dans l%sinstance\n' \
      "$_CLIA_SEP" "$makefile" "$_CLIA_SEP" "$source_mf" "$_CLIA_SEP" "'"
  } | column -t -s "$_CLIA_SEP"
  return 0
}
