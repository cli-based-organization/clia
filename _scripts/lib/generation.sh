# shellcheck shell=bash
# _scripts/lib/generation.sh — le stade généré, et ce qui le construit.
#
# Implémente SES-001 tâches 22 et 23, verbe « make ». SPC-002 dit ce qu'est un
# stade ; REQ-006 dit comment celui-ci est implémenté sur Linux.
#
# Ce que clia sait, et que make(1) ne sait pas
# -------------------------------------------
#
# make connaît un domaine : des sources, une compilation, des cibles. clia en
# connaît un autre — des primitives obtenues par une collaboration entre
# humains, automatismes et agents, et des livrables qui en sont tirés. Les
# deux domaines se ressemblent, et ce n'est pas le même :
#
#   une primitive est un peu comme un fichier source
#   la génération est un peu comme la compilation
#   un livrable est un peu comme une cible
#
# « Un peu comme » n'est pas « pareil ». Une primitive porte un ordre, un
# éditeur, une origine ; une dépendance peut être une ressource plutôt qu'un
# fichier, et une ressource a une version. Rien de tout cela n'a de sens pour
# make, et c'est ce que clia doit tenir lui-même — SES-001 tâche 23.
#
# Le format
# ---------
#
#   <instance>/generation.yaml   les recettes
#   <instance>/.empreintes.yaml  ce que chaque cible a vu à sa construction
#
# Une recette dit ce qu'elle produit, de quoi, et comment :
#
#   recettes:
#     - cible: genere/resume.md
#       depuis: primitive-1/ENO-001-source.md primitive-2/SPC-001-forme.md
#       ressources: ressource@0.1.0
#       par: livrables/_scripts/resumer.sh
#
# « depuis » et « ressources » sont des listes séparées par des espaces — un
# chemin de clia n'en contient pas. Une cible peut en nommer une autre : c'est
# ce qui fait le graphe.
#
# Deux façons de changer
# ----------------------
#
# Une cible est refaite quand ce qu'elle a vu a changé. Deux choses peuvent
# changer, et elles ne se mesurent pas pareil :
#
#   un fichier   son contenu, par empreinte. Ni sa date, ni sa taille — un
#                clone remet toutes les dates à la même, et une date ne dit
#                pas ce qu'un contenu dit.
#
#   une ressource  sa version, ou son contenu, selon la politique en vigueur.
#
# La politique « ressource.version » tranche :
#
#   fixed-version    seule la version compte. Une ressource qui bouge sans
#                    changer de version ne provoque rien.
#   rolling-release  le contenu compte aussi. Ce qui bouge se répercute.
#
# Défaut : fixed-version. SPC-001 §1.9 pose qu'une ressource installée est
# figée ; une régénération déclenchée par ce qui bouge ailleurs serait le
# contraire de figé. Un dépôt qui développe ses ressources demande l'autre.
#
# Quatre niveaux la règlent, du plus proche au plus lointain :
#
#   $CLIA_MAKE_POLICY_RESSOURCE_VERSION       l'appel
#   <instance>/generation.yaml                la ressource
#   la carte du dépôt                         le dépôt
#   ~/.config/clia/config.yaml                l'utilisateur
#
# Constater n'est pas construire : « make ls » et « make --check » n'écrivent
# rien, et le disent.

_CLIA_G_RECETTES='generation.yaml'
_CLIA_G_EMPREINTES='.empreintes.yaml'

_CLIA_G_POLITIQUES='ressource.version'
_CLIA_G_VERSION_VALEURS='fixed-version rolling-release'
_CLIA_G_VERSION_DEFAUT='fixed-version'

# --------------------------------------------------------------------------
# Les empreintes
# --------------------------------------------------------------------------
#
# sha256sum est employé parce qu'il est là — coreutils, sur toute machine où
# clia tourne. Ce qui compte n'est pas la force cryptographique : c'est qu'un
# même contenu donne toujours la même empreinte, et deux contenus différents
# presque jamais la même.

_clia_g_sha() {
  local f="$1"
  [[ -f "$f" ]] || { printf 'absent\n'; return 0; }
  sha256sum -- "$f" 2>/dev/null | cut -d' ' -f1
}

# _clia_g_sha_arbre <répertoire> — l'empreinte d'un répertoire entier : les
# noms et les contenus. Un fichier ajouté, retiré ou modifié la change.
_clia_g_sha_arbre() {
  local dir="$1"
  [[ -d "$dir" ]] || { printf 'absent\n'; return 0; }
  { cd "$dir" && find . -type f -print0 | LC_ALL=C sort -z \
      | xargs -0 -r sha256sum -- 2>/dev/null; } | sha256sum | cut -d' ' -f1
}

# --------------------------------------------------------------------------
# Les recettes
# --------------------------------------------------------------------------

# _clia_g_recettes <instance> — « cible SEP depuis SEP ressources SEP par ».
_clia_g_recettes() {
  _clia_bloc_yaml "$1/$_CLIA_G_RECETTES" recettes cible depuis ressources par
}

# _clia_g_recette_de <instance> <cible> — la ligne d'une cible, ou rien.
_clia_g_recette_de() {
  local inst="$1" cible="$2" ligne c
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    IFS="$_CLIA_SEP" read -r c _ <<<"$ligne"
    [[ "$c" == "$cible" ]] && { printf '%s\n' "$ligne"; return 0; }
  done < <(_clia_g_recettes "$inst")
  return 1
}

# _clia_g_cibles <instance> — les cibles déclarées, dans l'ordre du fichier.
_clia_g_cibles() {
  local ligne c
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    IFS="$_CLIA_SEP" read -r c _ <<<"$ligne"
    [[ -n "$c" ]] && printf '%s\n' "$c"
  done < <(_clia_g_recettes "$1")
  return 0
}

# _clia_g_ordre <instance> — les cibles, dépendances avant dépendants.
#
# Un tri topologique naïf : on pose ce dont toutes les dépendances internes
# sont déjà posées, et on recommence. Ce qui reste après un tour sans progrès
# est dans un cycle, et clia le refuse plutôt que de boucler.
_clia_g_ordre() {
  local inst="$1" restant='' progres ligne c depuis d pret
  while IFS= read -r c; do restant="$restant $c"; done < <(_clia_g_cibles "$inst")

  while [[ -n "${restant// /}" ]]; do
    progres=0
    local nouveau=''
    for c in $restant; do
      ligne=$(_clia_g_recette_de "$inst" "$c") || continue
      IFS="$_CLIA_SEP" read -r _ depuis _ _ <<<"$ligne"
      pret=1
      for d in $depuis; do
        # Une dépendance qui n'est pas une cible est un fichier : elle est
        # prête par nature.
        [[ " $restant " == *" $d "* ]] && { pret=0; break; }
      done
      if (( pret )); then printf '%s\n' "$c"; progres=1
      else nouveau="$nouveau $c"; fi
    done
    restant="$nouveau"
    if (( ! progres )); then
      _clia_msg "cycle entre cibles :$restant"
      _clia_detail "une cible ne peut pas dépendre d'elle-même, même par un détour"
      return 1
    fi
  done
  return 0
}

# --------------------------------------------------------------------------
# Les politiques
# --------------------------------------------------------------------------

_clia_g_config_utilisateur() {
  printf '%s/clia/config.yaml\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

# _clia_g_variable <nom de politique> — la variable d'environnement qui la
# règle. Elle se déduit du nom, comme celle d'une zone : CLIA_MAKE_POLICY_,
# puis le nom en majuscules, points et tirets changés en soulignés.
_clia_g_variable() {
  printf 'CLIA_MAKE_POLICY_%s\n' "$(printf '%s' "$1" | tr '[:lower:].-' '[:upper:]__')"
}

# _clia_g_politique <nom> <dépôt> <instance> — « valeur SEP niveau ».
#
# Quatre niveaux, du plus proche au plus lointain. Le premier qui déclare
# l'emporte : régler au plus près ne doit jamais être défait par plus loin.
_clia_g_politique() {
  local nom="$1" depot="$2" inst="${3:-}" variable v carte

  variable=$(_clia_g_variable "$nom")
  if [[ -n "${!variable:-}" ]]; then
    printf '%s%sappel\n' "${!variable}" "$_CLIA_SEP"; return 0
  fi

  if [[ -n "$inst" ]]; then
    v=$(_clia_g_politique_dans "$inst/$_CLIA_G_RECETTES" "$nom")
    [[ -n "$v" ]] && { printf '%s%sressource\n' "$v" "$_CLIA_SEP"; return 0; }
  fi

  if carte=$(_clia_carte "$depot" 2>/dev/null); then
    v=$(_clia_g_politique_dans "$carte" "$nom")
    [[ -n "$v" ]] && { printf '%s%sdépôt\n' "$v" "$_CLIA_SEP"; return 0; }
  fi

  v=$(_clia_g_politique_dans "$(_clia_g_config_utilisateur)" "$nom")
  [[ -n "$v" ]] && { printf '%s%sutilisateur\n' "$v" "$_CLIA_SEP"; return 0; }

  case "$nom" in
    ressource.version) printf '%s%sdéfaut\n' "$_CLIA_G_VERSION_DEFAUT" "$_CLIA_SEP" ;;
    *)                 return 1 ;;
  esac
}

# _clia_g_politique_dans <fichier> <nom> — la valeur déclarée, ou rien.
_clia_g_politique_dans() {
  local fichier="$1" cible="$2" nom valeur
  [[ -f "$fichier" ]] || return 0
  while IFS="$_CLIA_SEP" read -r nom valeur; do
    [[ "$nom" == "$cible" ]] && { printf '%s\n' "$valeur"; return 0; }
  done < <(_clia_bloc_yaml "$fichier" 'make-politiques' nom valeur)
  return 0
}

# _clia_g_politique_poser <fichier> <nom> <valeur> — écrit, en remplaçant.
_clia_g_politique_poser() {
  local fichier="$1" nom="$2" valeur="$3"
  [[ -f "$fichier" ]] || printf '' > "$fichier"
  _clia_carte_retirer "$fichier" 'make-politiques' nom "$nom" >/dev/null 2>&1 || true
  grep -q '^make-politiques:[[:space:]]*$' "$fichier" 2>/dev/null \
    || printf '\nmake-politiques:\n' >> "$fichier"
  _clia_carte_inserer "$fichier" 'make-politiques' \
    "  - nom: $nom" "    valeur: $valeur"
}

# _clia_g_valeur_admise <nom> <valeur>
_clia_g_valeur_admise() {
  case "$1" in
    ressource.version) [[ " $_CLIA_G_VERSION_VALEURS " == *" $2 "* ]] ;;
    *) return 1 ;;
  esac
}

# --------------------------------------------------------------------------
# Ce qu'une cible a vu
# --------------------------------------------------------------------------

# _clia_g_ressource_dir <dépôt> <nom> — où la ressource installée vit.
_clia_g_ressource_dir() {
  local depot="$1" nom="$2" racine
  for racine in "$depot" "${CLIA_SOURCE_DIR:-}"; do
    [[ -n "$racine" ]] || continue
    [[ -d "$racine/$(_clia_zone_livree)/$nom" ]] && {
      printf '%s/%s/%s\n' "$racine" "$(_clia_zone_livree)" "$nom"; return 0; }
  done
  return 1
}

# _clia_g_signature_ressource <dépôt> <déclaration> <politique> — ce qu'une
# dépendance de ressource vaut aujourd'hui.
#
# La déclaration est « nom » ou « nom@version ». Une version épinglée fige la
# dépendance : elle ne bouge que si quelqu'un la change dans la recette.
_clia_g_signature_ressource() {
  local depot="$1" decl="$2" politique="$3" nom version dir courante
  nom="${decl%@*}"; version=''
  [[ "$decl" == *@* ]] && version="${decl#*@}"

  if [[ -n "$version" ]]; then
    printf '%s@%s\n' "$nom" "$version"
    return 0
  fi

  if ! dir=$(_clia_g_ressource_dir "$depot" "$nom"); then
    printf '%s@absente\n' "$nom"
    return 0
  fi
  courante=$(_clia_champ_yaml "$dir/$nom.yaml" version || printf '—')
  if [[ "$politique" == 'rolling-release' ]]; then
    printf '%s@%s+%s\n' "$nom" "$courante" "$(_clia_g_sha_arbre "$dir")"
  else
    printf '%s@%s\n' "$nom" "$courante"
  fi
}

# _clia_g_empreinte <dépôt> <instance> <depuis> <ressources> <politique> —
# l'empreinte de tout ce dont une cible dépend.
_clia_g_empreinte() {
  local depot="$1" inst="$2" depuis="$3" ressources="$4" politique="$5" d r
  { for d in $depuis;     do printf '%s %s\n' "$d" "$(_clia_g_sha "$inst/$d")"; done
    for r in $ressources; do printf '%s\n' "$(_clia_g_signature_ressource "$depot" "$r" "$politique")"; done
  } | sha256sum | cut -d' ' -f1
}

# _clia_g_empreinte_lue <instance> <cible> — celle du dernier passage.
_clia_g_empreinte_lue() {
  local inst="$1" cible="$2" c e
  while IFS="$_CLIA_SEP" read -r c e; do
    [[ "$c" == "$cible" ]] && { printf '%s\n' "$e"; return 0; }
  done < <(_clia_bloc_yaml "$inst/$_CLIA_G_EMPREINTES" empreintes cible entrees)
  return 0
}

# _clia_g_empreinte_ecrire <instance> <cible> <empreinte>
_clia_g_empreinte_ecrire() {
  local inst="$1" cible="$2" empreinte="$3"
  local fichier="$inst/$_CLIA_G_EMPREINTES"
  if [[ ! -f "$fichier" ]]; then
    { printf '# Écrit par clia — ce que chaque cible a vu à sa construction.\n'
      printf '#\n'
      printf '# Ce fichier est un constat, non une déclaration : le modifier ne\n'
      printf '# change rien à ce qui est, il change seulement ce que clia croit.\n'
      printf '\nempreintes:\n'
    } > "$fichier"
  fi
  _clia_carte_retirer "$fichier" empreintes cible "$cible" >/dev/null 2>&1 || true
  _clia_carte_inserer "$fichier" empreintes \
    "  - cible: $cible" "    entrees: $empreinte"
}

# --------------------------------------------------------------------------
# L'état d'une cible
# --------------------------------------------------------------------------
#
# Quatre états, et ils ne demandent pas la même chose :
#
#   à jour        rien à faire
#   à construire  la cible n'existe pas
#   à refaire     ses entrées ont changé depuis son dernier passage
#   à refaire     une cible dont elle dépend va être refaite

# _clia_g_etat <dépôt> <instance> <cible> <politique> <cibles à refaire> —
# « état SEP raison ».
_clia_g_etat() {
  local depot="$1" inst="$2" cible="$3" politique="$4" sales="$5"
  local ligne depuis ressources par empreinte lue d

  ligne=$(_clia_g_recette_de "$inst" "$cible") || {
    printf 'sans recette%srien ne dit comment la produire\n' "$_CLIA_SEP"; return 0; }
  IFS="$_CLIA_SEP" read -r _ depuis ressources par <<<"$ligne"

  if [[ -z "$par" ]]; then
    printf 'sans recette%sla recette ne dit pas « par »\n' "$_CLIA_SEP"; return 0
  fi

  for d in $depuis; do
    [[ " $sales " == *" $d "* ]] && {
      printf 'à refaire%s%s va être refaite\n' "$_CLIA_SEP" "$d"; return 0; }
  done

  if [[ ! -e "$inst/$cible" ]]; then
    printf 'à construire%selle n%sexiste pas encore\n' "$_CLIA_SEP" "'"; return 0
  fi

  empreinte=$(_clia_g_empreinte "$depot" "$inst" "$depuis" "$ressources" "$politique")
  lue=$(_clia_g_empreinte_lue "$inst" "$cible")
  if [[ -z "$lue" ]]; then
    printf 'à refaire%saucune empreinte : ce qu%selle a vu est inconnu\n' \
      "$_CLIA_SEP" "'"; return 0
  fi
  if [[ "$lue" != "$empreinte" ]]; then
    printf 'à refaire%sses entrées ont changé\n' "$_CLIA_SEP"; return 0
  fi
  printf 'à jour%s—\n' "$_CLIA_SEP"
  return 0
}

# --------------------------------------------------------------------------
# La construction
# --------------------------------------------------------------------------

# _clia_g_ferme <instance> <cible…> — la cible et tout ce dont elle dépend,
# de proche en proche. Une dépendance qui n'est pas une cible est un fichier,
# et ne se construit pas.
_clia_g_ferme() {
  local inst="$1"; shift
  local vu='' file=("$@") c ligne depuis d cibles=''
  while IFS= read -r c; do cibles="$cibles $c"; done < <(_clia_g_cibles "$inst")

  while (( ${#file[@]} > 0 )); do
    c="${file[0]}"; file=("${file[@]:1}")
    [[ " $vu " == *" $c "* ]] && continue
    [[ " $cibles " == *" $c "* ]] || continue
    vu="$vu $c"
    ligne=$(_clia_g_recette_de "$inst" "$c") || continue
    IFS="$_CLIA_SEP" read -r _ depuis _ _ <<<"$ligne"
    for d in $depuis; do file+=("$d"); done
  done
  printf '%s\n' "$vu"
}

# _clia_g_appliquer <dépôt> <instance> <cible> <politique> — la recette.
_clia_g_appliquer() {
  local depot="$1" inst="$2" cible="$3" politique="$4"
  local ligne depuis ressources par empreinte

  ligne=$(_clia_g_recette_de "$inst" "$cible") || return 1
  IFS="$_CLIA_SEP" read -r _ depuis ressources par <<<"$ligne"

  if [[ ! -f "$inst/$par" ]]; then
    _clia_msg "$cible : la recette est introuvable — $par"
    _clia_detail "« par » nomme un script, relatif à l'instance"
    return 1
  fi

  mkdir -p "$(dirname "$inst/$cible")"

  if ! ( cd "$inst" \
         && CLIA_CIBLE="$cible" CLIA_DEPUIS="$depuis" \
            CLIA_RESSOURCES="$ressources" CLIA_INSTANCE="$inst" \
            CLIA_GENERE="$inst/genere" \
            bash "$par" ); then
    _clia_msg "$cible : la recette a échoué — $par"
    return 1
  fi

  if [[ ! -e "$inst/$cible" ]]; then
    _clia_msg "$cible : la recette s'est bien terminée, sans produire sa cible"
    _clia_detail "une recette est jugée sur ce qu'elle pose, non sur son code de retour"
    return 1
  fi

  empreinte=$(_clia_g_empreinte "$depot" "$inst" "$depuis" "$ressources" "$politique")
  _clia_g_empreinte_ecrire "$inst" "$cible" "$empreinte"
  return 0
}

# --------------------------------------------------------------------------
# Le manuel
# --------------------------------------------------------------------------

_clia_g_manuel() {
  local commande="$1"
  sed "s/@CMD@/$commande/g" <<'PAGE' | _clia_man "clia-@CMD@-make" 1 "Manuel de l'utilisateur clia"
NOM
clia-@CMD@-make - construire ce qui se génère à partir des primitives

SYNOPSIS
clia @CMD@ make [CIBLE...]
clia @CMD@ make ls
clia @CMD@ make config ls
clia @CMD@ make policy ls
clia @CMD@ make policy set CLE VALEUR
clia @CMD@ make --check
clia @CMD@ make --explain

DESCRIPTION
Une ressource passe par trois stades : ses primitives, ce qui en
est généré, ce qui en est livré. Ce verbe construit ce qui se
génère, et ne refait que ce qui a changé.

Il s'inspire de make(1) sans en être : make connaît des sources,
une compilation et des cibles ; clia connaît des primitives
obtenues par une collaboration entre humains, automatismes et
agents, et des livrables qui en sont tirés. Une dépendance peut y
être une ressource plutôt qu'un fichier, et une ressource a une
version — ce dont make ne saurait rien faire.

LES RECETTES
Elles vivent dans l'instance, sous generation.yaml :

       recettes:
         - cible: genere/resume.md
           depuis: primitive-1/ENO-001-source.md
           ressources: ressource@0.1.0
           par: livrables/_scripts/resumer.sh

cible
       Ce que la recette produit, relatif à l'instance.

depuis
       Les fichiers dont elle dépend, séparés par des espaces. Une
       dépendance qui est elle-même une cible fait le graphe ; les
       dépendances sont construites avant ce qui les emploie.

ressources
       Les ressources dont elle dépend : « nom » ou « nom@version ».
       Une version épinglée fige la dépendance.

par
       Le script qui construit, relatif à l'instance. Il est lancé
       avec l'instance pour répertoire de travail, et reçoit
       CLIA_CIBLE, CLIA_DEPUIS, CLIA_RESSOURCES, CLIA_INSTANCE et
       CLIA_GENERE.

       Une recette est jugée sur ce qu'elle pose : une recette qui
       se termine bien sans produire sa cible est un échec.

CE QUI DECIDE DE REFAIRE
Une cible est refaite quand ce qu'elle a vu a changé. Ce qu'elle a
vu est enregistré à sa construction, sous .empreintes.yaml.

Un fichier compte par son contenu, non par sa date : un clone remet
toutes les dates à la même, et une date ne dit pas ce qu'un contenu
dit.

Une ressource compte selon la politique en vigueur.

LES POLITIQUES
ressource.version
       fixed-version — seule la version d'une ressource compte. Une
       ressource qui bouge sans changer de version ne provoque
       rien. C'est le défaut : SPC-001 pose qu'une ressource
       installée est figée.

       rolling-release — son contenu compte aussi. Ce qui bouge se
       répercute. C'est ce que demande un dépôt qui développe les
       ressources dont il se sert.

Quatre niveaux la règlent, et le plus proche l'emporte :

       $CLIA_MAKE_POLICY_RESSOURCE_VERSION        l'appel
       clia @CMD@ make policy set                 la ressource
       clia make policy set                       le dépôt
       clia setup config set                      l'utilisateur

VERBES
ls
       Le graphe et l'état de chaque cible, sans rien construire.

config ls
       Où les recettes et les empreintes sont, et si elles y sont.

policy ls
       Les politiques, leur valeur, et le niveau qui la donne.

policy set CLE VALEUR
       Poser une politique pour cette ressource, dans
       generation.yaml.

OPTIONS
--check
       Dire si tout est à jour, sans rien construire. Rend 0 s'il
       n'y a rien à faire, 1 sinon.

--explain
       Ce que ce verbe fait, et ce qui le distingue de make(1).

--man
       Cette page.

CODE DE RETOUR
0
       La construction a réussi, ou il n'y avait rien à faire.

1
       Refus, ou une recette a échoué. Avec --check, il reste
       quelque chose à faire.

2
       Demande mal formée.

VOIR AUSSI
clia(1), clia-make(1), clia-config(1), clia-setup(1), SPC-002, REQ-006
PAGE
}

_clia_g_expliquer() {
  local commande="$1"
  cat <<PROSE
clia $commande make construit ce qui se génère dans l'instance que ce dépôt
écrit de la ressource, et ne refait que ce qui a changé.

Ce qu'il fait, dans cet ordre :

  1. il lit les recettes de l'instance, sous generation.yaml
  2. il ordonne les cibles, dépendances avant dépendants
  3. il calcule, pour chaque cible, l'empreinte de tout ce dont elle dépend
  4. il la compare à celle du dernier passage, sous .empreintes.yaml
  5. il applique les recettes de celles qui ont changé, dans l'ordre
  6. il enregistre ce que chacune a vu

Ce qui le distingue de make(1). make connaît un domaine : des sources, une
compilation, des cibles. clia en connaît un autre — des primitives obtenues
par une collaboration entre humains, automatismes et agents, et des livrables
qui en sont tirés. Une primitive est un peu comme un fichier source, la
génération un peu comme la compilation, un livrable un peu comme une cible ;
« un peu comme » n'est pas « pareil ».

Deux différences le montrent. Une dépendance peut être une ressource plutôt
qu'un fichier, et une ressource a une version : la politique ressource.version
dit si c'est la version qui compte, ou aussi le contenu. Et un fichier compte
par son contenu, non par sa date — un clone remet toutes les dates à la même,
et make s'y perdrait.

Ce que clia ne fait pas. Il ne devine aucune recette : une cible sans « par »
n'est pas générable, et il le dit. Il ne juge pas non plus ce qu'une recette
produit — seulement qu'elle l'a produit.

Le manuel complet : clia $commande make --man
PROSE
}

# --------------------------------------------------------------------------
# Le verbe
# --------------------------------------------------------------------------

# _clia_g_make <commande> <fichier> <arguments…>
_clia_g_make() {
  local commande="$1" fichier="$2"; shift 2
  local depot="${CLIA_WORK_DIR:-}" nom id inst zone rel
  local verbe='' cibles=() arg cle='' valeur=''

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    return 2
  fi

  for arg in "$@"; do
    case "$arg" in
      --man)     _clia_g_manuel    "$commande"; return 0 ;;
      --explain) _clia_g_expliquer "$commande"; return 0 ;;
      --check)   [[ -z "$verbe" ]] && verbe='check' ;;
      -*) _clia_msg "option inconnue : $arg"
          _clia_detail "l'usage : clia $commande make --help"; return 2 ;;
      ls|config|policy|set)
        if [[ -z "$verbe" ]]; then
          case "$arg" in
            ls)     verbe='ls' ;;
            config) verbe='config' ;;
            policy) verbe='policy' ;;
            *)      cibles+=("$arg") ;;
          esac
        else
          cibles+=("$arg")
        fi ;;
      *) cibles+=("$arg") ;;
    esac
  done

  case "$verbe" in
    config)
      if (( ${#cibles[@]} > 1 )) || { (( ${#cibles[@]} == 1 )) && [[ "${cibles[0]}" != 'ls' ]]; }; then
        _clia_msg "config n'accepte que « ls » : ${cibles[*]}"; return 2
      fi ;;
    policy)
      case "${cibles[0]:-ls}" in
        ls) (( ${#cibles[@]} <= 1 )) || {
              _clia_msg "policy ls ne prend pas d'argument : ${cibles[*]:1}"; return 2; } ;;
        set)
          (( ${#cibles[@]} == 3 )) || {
            _clia_msg "policy set attend une clé et une valeur"
            _clia_detail "l'usage : clia $commande make policy set CLE VALEUR"; return 2; }
          cle="${cibles[1]}"; valeur="${cibles[2]}" ;;
        *) _clia_msg "policy n'accepte que « ls » ou « set » : ${cibles[0]}"; return 2 ;;
      esac
      cibles=() ;;
  esac

  zone=$(_clia_zone_ressource)
  id=$(_clia_instance_de "$depot" "$nom" || printf '')
  if [[ -z "$id" ]]; then
    _clia_msg "ce dépôt n'écrit pas $nom : il n'y a rien à générer ici"
    _clia_detail "ce qui se génère vit sous une instance, non sous une copie installée"
    _clia_detail "ce que le dépôt écrit : clia res ls"
    return 1
  fi
  inst="$depot/$zone/$id"
  rel="$zone/$id"

  case "$verbe" in
    policy)
      if [[ -n "$cle" ]]; then
        _clia_g_policy_set "$commande" "$inst" "$rel" "$cle" "$valeur"
      else
        _clia_g_policy_ls "$nom" "$depot" "$inst" "$rel"
      fi
      return $? ;;
    config)
      _clia_g_config_ls "$commande" "$nom" "$inst" "$rel"
      return 0 ;;
  esac

  if [[ ! -f "$inst/$_CLIA_G_RECETTES" ]]; then
    _clia_msg "$nom ne porte aucune recette"
    _clia_detail "attendu : $rel/$_CLIA_G_RECETTES"
    _clia_detail "une recette dit ce qu'elle produit, de quoi, et comment"
    _clia_detail "la forme : clia $commande make --man"
    return 1
  fi

  _clia_g_travail "$commande" "$nom" "$depot" "$inst" "$rel" "$verbe" "${cibles[@]}"
}

# --------------------------------------------------------------------------
# ls, --check, et la construction : un même parcours
# --------------------------------------------------------------------------
#
# Les trois répondent à la même question — qu'est-ce qui a changé — et ne
# diffèrent que par ce qu'ils en font. Un seul parcours les sert, sans quoi
# « ls » et la construction finiraient par ne plus dire la même chose.

_clia_g_travail() {
  local commande="$1" nom="$2" depot="$3" inst="$4" rel="$5" verbe="$6"; shift 6
  local demandees=("$@")
  local politique niveau ordre=() retenues='' c etat raison ligne depuis ressources
  local sales='' tampon='' n_sales=0

  IFS="$_CLIA_SEP" read -r politique niveau < <(_clia_g_politique ressource.version "$depot" "$inst")

  mapfile -t ordre < <(_clia_g_ordre "$inst") || return 1
  (( ${#ordre[@]} > 0 )) || {
    _clia_msg "$nom : $rel/$_CLIA_G_RECETTES ne déclare aucune recette"
    return 1; }

  if (( ${#demandees[@]} > 0 )); then
    for c in "${demandees[@]}"; do
      _clia_g_recette_de "$inst" "$c" >/dev/null || {
        _clia_msg "aucune recette ne produit $c"
        _clia_detail "ce que l'instance sait produire : clia $commande make ls"
        return 1; }
    done
    retenues=$(_clia_g_ferme "$inst" "${demandees[@]}")
  fi

  for c in "${ordre[@]}"; do
    [[ -z "$retenues" || " $retenues " == *" $c "* ]] || continue
    IFS="$_CLIA_SEP" read -r etat raison < <(_clia_g_etat "$depot" "$inst" "$c" "$politique" "$sales")
    [[ "$etat" == 'à jour' ]] || { sales="$sales $c"; n_sales=$((n_sales + 1)); }
    ligne=$(_clia_g_recette_de "$inst" "$c")
    IFS="$_CLIA_SEP" read -r _ depuis ressources _ <<<"$ligne"
    tampon+=$(printf '%s%s%s%s%s%s%s' "$c" "$_CLIA_SEP" "$etat" "$_CLIA_SEP" \
      "$raison" "$_CLIA_SEP" "${depuis:-—}${ressources:+ $ressources}")$'\n'
  done

  case "$verbe" in
    ls)
      _clia_g_entete "$nom" "$rel" "$politique" "$niveau"
      { printf 'CIBLE%sETAT%sPOURQUOI%sDEPEND DE\n' "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP"
        printf '%s' "$tampon"
      } | column -t -s "$_CLIA_SEP"
      _clia_msg "$nom : $n_sales cible(s) à faire sur ${#ordre[@]}"
      _clia_detail "rien n'a été construit — pour le faire : clia $commande make"
      return 0 ;;
    check)
      if (( n_sales == 0 )); then
        _clia_msg "$nom : tout est à jour"
        return 0
      fi
      _clia_msg "$nom : $n_sales cible(s) à faire —$sales"
      _clia_detail "ce qui a changé : clia $commande make ls"
      _clia_detail "pour le construire : clia $commande make"
      return 1 ;;
  esac

  if (( n_sales == 0 )); then
    _clia_msg "$nom : rien à faire, tout est à jour"
    return 0
  fi

  local faites=0
  for c in $sales; do
    _clia_g_appliquer "$depot" "$inst" "$c" "$politique" || {
      _clia_msg "$nom : arrêt après $faites cible(s)"
      _clia_detail "ce qui reste : clia $commande make ls"
      return 1; }
    printf '%s\n' "$c"
    faites=$((faites + 1))
  done

  _clia_msg "$nom : $faites cible(s) construite(s)"
  _clia_detail "ce que chacune a vu est inscrit dans $rel/$_CLIA_G_EMPREINTES"
  _clia_detail "rien n'est commité"
  return 0
}

_clia_g_entete() {
  printf 'ressource  %s\n' "$1"
  printf 'instance   %s\n' "$2"
  printf 'politique  ressource.version = %s  (%s)\n\n' "$3" "$4"
}

_clia_g_config_ls() {
  local commande="$1" nom="$2" inst="$3" rel="$4" f etat
  printf 'ressource  %s\n' "$nom"
  printf 'instance   %s\n\n' "$rel"
  { printf 'FICHIER%sCHEMIN%sETAT\n' "$_CLIA_SEP" "$_CLIA_SEP"
    for f in "$_CLIA_G_RECETTES" "$_CLIA_G_EMPREINTES"; do
      if [[ -f "$inst/$f" ]]; then etat='présent'; else etat='absent'; fi
      case "$f" in
        "$_CLIA_G_RECETTES")   printf 'recettes%s%s/%s%s%s\n'   "$_CLIA_SEP" "$rel" "$f" "$_CLIA_SEP" "$etat" ;;
        "$_CLIA_G_EMPREINTES") printf 'empreintes%s%s/%s%s%s\n' "$_CLIA_SEP" "$rel" "$f" "$_CLIA_SEP" "$etat" ;;
      esac
    done
  } | column -t -s "$_CLIA_SEP"
  _clia_msg "les recettes sont écrites à la main ; les empreintes, par clia"
  _clia_detail "les politiques : clia $commande make policy ls"
  return 0
}

_clia_g_policy_ls() {
  local nom="$1" depot="$2" inst="$3" rel="$4" p valeur niveau
  printf 'ressource  %s\n' "$nom"
  printf 'instance   %s\n\n' "$rel"
  { printf 'POLITIQUE%sVALEUR%sNIVEAU%sVALEURS ADMISES\n' "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP"
    for p in $_CLIA_G_POLITIQUES; do
      IFS="$_CLIA_SEP" read -r valeur niveau < <(_clia_g_politique "$p" "$depot" "$inst")
      printf '%s%s%s%s%s%s%s\n' "$p" "$_CLIA_SEP" "$valeur" "$_CLIA_SEP" \
        "$niveau" "$_CLIA_SEP" "$_CLIA_G_VERSION_VALEURS"
    done
  } | column -t -s "$_CLIA_SEP"
  return 0
}

_clia_g_policy_set() {
  local commande="$1" inst="$2" rel="$3" cle="$4" valeur="$5"

  if [[ " $_CLIA_G_POLITIQUES " != *" $cle "* ]]; then
    _clia_msg "politique inconnue : $cle"
    _clia_detail "celles qui existent : $_CLIA_G_POLITIQUES"
    return 2
  fi
  if ! _clia_g_valeur_admise "$cle" "$valeur"; then
    _clia_msg "valeur inconnue pour $cle : $valeur"
    _clia_detail "valeurs admises : $_CLIA_G_VERSION_VALEURS"
    return 2
  fi

  if [[ ! -f "$inst/$_CLIA_G_RECETTES" ]]; then
    _clia_msg "$rel/$_CLIA_G_RECETTES est absent"
    _clia_detail "une politique se pose à côté des recettes qu'elle règle"
    _clia_detail "la forme d'une recette : clia $commande make --man"
    return 1
  fi

  _clia_g_politique_poser "$inst/$_CLIA_G_RECETTES" "$cle" "$valeur" || return 1
  _clia_msg "$cle = $valeur, pour cette ressource"
  _clia_detail "inscrit dans $rel/$_CLIA_G_RECETTES"
  _clia_detail "pour tout le dépôt : clia make policy set $cle $valeur"
  _clia_detail "rien n'est commité"
  return 0
}
