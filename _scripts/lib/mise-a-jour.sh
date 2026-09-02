# shellcheck shell=bash
# _scripts/lib/mise-a-jour.sh — amener un dépôt à une autre version.
#
# Implémente SES-001 tâche 17, pour clia-upgrade(1) et clia-downgrade(1).
#
# Les deux commandes font le même travail et ne diffèrent que par le sens
# exigé : une écriture unique, et un « exactement pareil » garanti plutôt que
# ressemblant.
#
# Ce qu'un dépôt tient de clia
# ----------------------------
#
#   les fichiers harnais    posés par clia init depuis les primitives
#   les ressources reprises  copiées par clia extension install
#   les skills posés         copiés sous .claude/skills/
#   les features posées      leur texte, dans la zone gérée du harnais
#
# Tout cela est une copie. La mise à jour la refait depuis la version visée.
#
# La règle des copies éditées
# ---------------------------
#
# Une copie identique à ce dont elle vient est remplacée sans rien dire :
# personne ne perd rien. Une copie qui en diffère est signalée et laissée —
# quelqu'un l'a touchée, et clia ne sait pas si cela comptait. « --force »
# remplace quand même.
#
# C'est la même règle pour le harnais et pour les skills, et ce n'est pas un
# hasard : les deux sont des copies posées, et une règle par nature de fichier
# aurait obligé à se souvenir de laquelle s'applique où.
#
# Ce que l'humain édite, ce sont les primitives — celles de la ressource qui
# les publie. Un harnais posé qui diverge est donc un écart à signaler, non un
# travail à préserver indéfiniment.
#
# La version que le dépôt suit
# ----------------------------
#
# Elle est inscrite dans sa carte, sous « clia-version: ». Sans elle, le sens
# d'une mise à jour ne se vérifie pas : SES-001 tâche 17 exige que la cible
# soit supérieure pour un upgrade, inférieure pour un downgrade, et « la
# version courante » doit donc être quelque part.
#
# Une carte qui ne la déclare pas la reçoit au premier passage, et clia le
# dit : un dépôt instrumenté avant que le champ existe n'a pas à être refusé.

# _clia_mj_version_suivie <dépôt> — la version de clia que le dépôt suit.
_clia_mj_version_suivie() {
  local carte
  carte=$(_clia_carte "$1") || return 1
  _clia_champ_yaml "$carte" clia-version
}

# _clia_mj_inscrire_version <dépôt> <version> — l'inscrit, ou la met à jour.
_clia_mj_inscrire_version() {
  local depot="$1" version="$2" carte tmp
  carte=$(_clia_carte "$depot") || return 1
  if grep -qE '^clia-version:[[:space:]]' "$carte"; then
    tmp=$(mktemp)
    sed -E "s|^clia-version:[[:space:]].*|clia-version: $version|" "$carte" > "$tmp"
    mv -f "$tmp" "$carte"
  else
    printf '\n# La version de clia que ce dépôt suit. Posée par clia upgrade.\nclia-version: %s\n' \
      "$version" >> "$carte"
  fi
  return 0
}

# --------------------------------------------------------------------------
# Poser une copie
# --------------------------------------------------------------------------

# _clia_mj_poser <nouveau> <destination> <référence> <force>
#
# Rend, sur la sortie standard, ce qui s'est passé : « posé », « à jour »,
# « laissé » ou « forcé ». La référence est ce dont la copie venait ; sans
# elle, la copie est réputée touchée.
_clia_mj_poser() {
  local nouveau="$1" dest="$2" reference="$3" force="$4"

  if [[ ! -e "$dest" ]]; then
    mkdir -p "$(dirname "$dest")"
    cp -r "$nouveau" "$dest"
    printf 'posé\n'; return 0
  fi

  if _clia_mj_identiques "$nouveau" "$dest"; then
    printf 'à jour\n'; return 0
  fi

  if [[ -n "$reference" ]] && _clia_mj_identiques "$reference" "$dest"; then
    rm -rf "$dest"
    cp -r "$nouveau" "$dest"
    printf 'posé\n'; return 0
  fi

  if [[ "$force" == '1' ]]; then
    rm -rf "$dest"
    cp -r "$nouveau" "$dest"
    printf 'forcé\n'; return 0
  fi

  printf 'laissé\n'
  return 0
}

_clia_mj_identiques() {
  if [[ -d "$1" || -d "$2" ]]; then
    diff -rq "$1" "$2" >/dev/null 2>&1
  else
    cmp -s "$1" "$2"
  fi
}

# --------------------------------------------------------------------------
# Les migrations
# --------------------------------------------------------------------------
#
# SES-001 tâche 17 : toute ressource porte un verbe « migrate », et chaque
# nouvelle version doit fournir son script. Un script par saut, enchaînés dans
# l'ordre du parcours.
#
# Un saut sans script fait échouer la migration avant qu'aucun ne soit lancé :
# une migration à moitié faite laisserait des instances dans un état que rien
# ne nomme.

# Les scripts de migration se lisent dans l'extension, non dans la copie que
# le dépôt porte.
#
# La raison : le script d'un saut arrive avec la version qui l'introduit, et
# la copie du dépôt est par définition à la version qu'on quitte — elle ne
# porte donc pas le script du saut qu'on veut franchir. Ils s'accumulent, et
# la version la plus récente de l'extension les porte tous : c'est là que clia
# les lit, dans un sens comme dans l'autre.
#
# _clia_mj_migrations_de <racine> <nom> — un répertoire temporaire portant les
# scripts, que l'appelant retire. Rien si l'extension n'en offre aucun.
_clia_mj_migrations_de() {
  local racine="$1" nom="$2" commit tmp
  local livrable
  livrable=$(_clia_mj_livrable_rel "$racine" "$nom") || return 1
  commit=$(git -C "$racine" log -1 --format=%H -- "$livrable" 2>/dev/null) || return 1
  [[ -n "$commit" ]] || return 1
  tmp=$(mktemp -d)/migrations
  _clia_m_extraire "$racine" "$commit" "$livrable/migrations" "$tmp" 2>/dev/null || {
    rm -rf "$(dirname "$tmp")"
    return 1
  }
  printf '%s\n' "$tmp"
  return 0
}

# _clia_mj_plan_migration <racine> <def> <dir migrations> <de> <vers>
#
# Rend « version<TAB>script » pour chaque saut. Échoue en nommant le premier
# saut sans script.
_clia_mj_plan_migration() {
  local racine="$1" def="$2" dir="$3" de="$4" vers="$5" v courant="$4" script manque=0
  local plan=''
  while IFS= read -r v; do
    [[ -n "$v" ]] || continue
    script=$(_clia_m_script_migration "$dir" "$courant" "$v" || printf '')
    if [[ -z "$script" ]]; then
      _clia_msg "aucun script de migration pour $courant -> $v"
      manque=1
    else
      plan+="$v"$'\t'"$script"$'\n'
    fi
    courant="$v"
  done < <(_clia_m_sauts "$racine" "$def" "$de" "$vers")
  (( manque )) && return 1
  printf '%s' "$plan"
  return 0
}

# _clia_mj_migrer <dépôt> <nom> <plan> — lance les scripts, dans l'ordre.
#
# Chaque script reçoit le dépôt, la ressource et les deux versions du saut. Il
# est lancé dans un processus fils : ce qu'il touche est le dépôt, non
# l'environnement de clia.
_clia_mj_migrer() {
  local depot="$1" nom="$2" plan="$3" de="$4" v script
  while IFS=$'\t' read -r v script; do
    [[ -n "$script" ]] || continue
    if ! CLIA_WORK_DIR="$depot" bash "$script" "$depot" "$nom" "$de" "$v"; then
      _clia_msg "la migration $de -> $v a échoué : ${script##*/}"
      _clia_detail "les instances sont dans l'état où ce script les a laissées"
      return 1
    fi
    _clia_detail "migré  : $nom $de -> $v"
    de="$v"
  done <<<"$plan"
  return 0
}

# --------------------------------------------------------------------------
# Mettre à jour une ressource
# --------------------------------------------------------------------------
#
# Une ressource du dépôt vient d'une extension, et l'inventaire de la carte
# dit laquelle et sous quelle version. C'est de là que se lisent les versions
# disponibles : l'extension porte son historique, et rien d'autre ne les
# déclare.
#
# Une ressource que l'inventaire ne connaît pas n'est pas mise à jour. Elle a
# été écrite ici, ou posée à la main : clia ne sait pas d'où elle viendrait,
# et CONSTITUTION.md R2 lui interdit de le deviner.

# _clia_mj_racine_extension <dépôt> <provider> — la racine de l'extension.
# _clia_mj_def_offerte <racine> <nom> — le chemin, relatif à la racine, de la
# définition que l'extension publie pour cette ressource.
#
# C'est ce chemin que l'historique suit : les versions disponibles se lisent
# sur lui, et sur lui seul.
_clia_mj_def_offerte() {
  local racine="$1" cible="$2" id nom
  while IFS=$'\t' read -r id nom _ _; do
    [[ "$nom" == "$cible" ]] || continue
    printf '%s/%s/livrables/%s.yaml\n' "$(_clia_zone_ressource)" "$id" "$nom"
    return 0
  done < <(_clia_instances_de "$racine")
  return 1
}

# _clia_mj_livrable_rel <racine> <nom> — le chemin du livrable, relatif.
_clia_mj_livrable_rel() {
  local def
  def=$(_clia_mj_def_offerte "$1" "$2") || return 1
  printf '%s\n' "${def%/*}"
}

_clia_mj_racine_extension() {
  local depot="$1" cible="$2" provider racine
  while IFS=$'\t' read -r provider racine; do
    [[ "$provider" == "$cible" ]] && { printf '%s\n' "$racine"; return 0; }
  done < <(_clia_extensions "$depot")
  return 1
}

# _clia_mj_provenance <dépôt> <nom> — « provider<TAB>version inscrite ».
_clia_mj_provenance() {
  local depot="$1" nom="$2" prefixe id v
  prefixe=$(_clia_champ_yaml "$depot/$(_clia_zone_livree)/$nom/$nom.yaml" prefixe || printf '')
  [[ -n "$prefixe" ]] || return 1
  while IFS="$_CLIA_SEP" read -r id v; do
    [[ "$id" == */"$prefixe" ]] || continue
    printf '%s\t%s\n' "${id%/*}" "$v"
    return 0
  done < <(_clia_installees "$depot")
  return 1
}

# Extrait d'une extension, à un commit, le livrable d'une ressource.
#
# Rien n'est filtré : les primitives de l'instance sont hors du livrable
# depuis SES-001 tâche 19, et ce qui est extrait est exactement ce qui
# s'installe.
_clia_mj_extraire_ressource() {
  local racine="$1" commit="$2" livrable="$3" dest="$4"
  _clia_m_extraire "$racine" "$commit" "$livrable" "$dest" || return 1
  return 0
}

# _clia_mj_ressource <dépôt> <nom> <sens> <cible|''> <force> <migrer>
#
# Rend une ligne « nom<TAB>de<TAB>vers<TAB>issue » sur la sortie standard.
_clia_mj_ressource() {
  local depot="$1" nom="$2" sens="$3" cible="${4:-}" force="$5" migrer="$6"
  local def provider racine def_ext courant commit_cible commit_courant
  local tmp ref='' issue plan attendu

  def="$depot/$(_clia_zone_livree)/$nom/$nom.yaml"
  if [[ ! -f "$def" ]]; then
    _clia_msg "$nom n'est pas une ressource de ce dépôt"
    return 1
  fi
  courant=$(_clia_champ_yaml "$def" version || printf '')

  if ! IFS=$'\t' read -r provider _ < <(_clia_mj_provenance "$depot" "$nom"); then
    _clia_msg "$nom n'a pas été reprise d'une extension"
    _clia_detail "l'inventaire de la carte ne dit pas d'où elle vient"
    _clia_detail "clia ne devine pas une provenance : voir clia-extension(1)"
    return 1
  fi

  if ! racine=$(_clia_mj_racine_extension "$depot" "$provider"); then
    _clia_msg "$provider n'est pas joignable"
    _clia_detail "une source locale absente, ou une source distante non clonée"
    _clia_detail "pour rétablir le clone : clia extension add <URI>"
    return 1
  fi

  if ! def_ext=$(_clia_mj_def_offerte "$racine" "$nom"); then
    _clia_msg "$provider ne publie pas $nom"
    _clia_detail "son instance a-t-elle été retirée ?"
    return 1
  fi
  local livrable_rel="${def_ext%/*}"
  if [[ -z "$cible" ]]; then
    if ! cible=$(_clia_m_derniere "$racine" "$def_ext"); then
      _clia_msg "$provider ne déclare aucune version de $nom dans son historique"
      _clia_detail "une ressource neuve, jamais commitée, n'a pas de version disponible"
      return 1
    fi
  fi

  if ! _clia_v_est_semantique "$courant" || ! _clia_v_est_semantique "$cible"; then
    _clia_msg "$nom : « $courant » ou « $cible » n'a pas la forme X.Y.Z"
    return 1
  fi

  if [[ "$(_clia_m_comparer "$courant" "$cible")" == '0' ]]; then
    printf '%s\t%s\t%s\t%s\n' "$nom" "$courant" "$cible" 'à jour'
    return 0
  fi

  [[ "$sens" == 'upgrade' ]] && attendu='-1' || attendu='1'
  if [[ "$(_clia_m_comparer "$courant" "$cible")" != "$attendu" ]]; then
    if [[ "$sens" == 'upgrade' ]]; then
      _clia_msg "$nom : $cible n'est pas supérieure à $courant"
      _clia_detail "pour reculer : clia $(printf '%s' "$(_clia_champ_yaml "$def" prefixe)" | tr '[:upper:]' '[:lower:]') downgrade $cible"
    else
      _clia_msg "$nom : $cible n'est pas inférieure à $courant"
      _clia_detail "pour avancer : clia $(printf '%s' "$(_clia_champ_yaml "$def" prefixe)" | tr '[:upper:]' '[:lower:]') upgrade $cible"
    fi
    return 1
  fi

  if ! commit_cible=$(_clia_m_commit_de "$racine" "$def_ext" "$cible"); then
    _clia_msg "$provider ne déclare pas la version $cible de $nom"
    _clia_detail "celles qu'elle déclare : clia $(printf '%s' "$(_clia_champ_yaml "$def" prefixe)" | tr '[:upper:]' '[:lower:]') provide"
    return 1
  fi

  # Les migrations sont planifiées avant qu'un fichier soit posé : un saut
  # sans script doit refuser la mise à jour, non la laisser à moitié faite.
  local dir_mig=''
  if [[ "$migrer" == '1' ]]; then
    dir_mig=$(_clia_mj_migrations_de "$racine" "$nom" || printf '')
    plan=$(_clia_mj_plan_migration "$racine" "$def_ext" "$dir_mig" "$courant" "$cible") || {
      [[ -n "$dir_mig" ]] && rm -rf "$(dirname "$dir_mig")"
      _clia_msg "$nom n'a pas été mise à jour"
      _clia_detail "chaque nouvelle version doit fournir son script de migration"
      _clia_detail "sans --migrate, la mise à jour se fait sans toucher aux instances"
      return 1
    }
  fi

  tmp=$(mktemp -d)/ressource
  _clia_mj_extraire_ressource "$racine" "$commit_cible" "$livrable_rel" "$tmp" || {
    _clia_msg "$nom : l'extraction de $cible a échoué"
    return 1
  }

  if commit_courant=$(_clia_m_commit_de "$racine" "$def_ext" "$courant"); then
    ref=$(mktemp -d)/reference
    _clia_mj_extraire_ressource "$racine" "$commit_courant" "$livrable_rel" "$ref" || ref=''
  fi

  issue=$(_clia_mj_poser "$tmp" "$depot/$(_clia_zone_livree)/$nom" "$ref" "$force")
  rm -rf "$(dirname "$tmp")" "${ref:+$(dirname "$ref")}"

  if [[ "$issue" == 'laissé' ]]; then
    [[ -n "$dir_mig" ]] && rm -rf "$(dirname "$dir_mig")"
    printf '%s\t%s\t%s\t%s\n' "$nom" "$courant" "$cible" 'laissé'
    return 0
  fi

  _clia_mj_inscrire_ressource "$depot" "$nom" "$provider" "$cible"

  if [[ "$migrer" == '1' && -n "${plan:-}" ]]; then
    _clia_mj_migrer "$depot" "$nom" "$plan" "$courant" || {
      [[ -n "$dir_mig" ]] && rm -rf "$(dirname "$dir_mig")"
      return 1
    }
  fi
  [[ -n "$dir_mig" ]] && rm -rf "$(dirname "$dir_mig")"

  printf '%s\t%s\t%s\t%s\n' "$nom" "$courant" "$cible" "$issue"
  return 0
}

# Met l'inventaire en accord avec la version posée.
_clia_mj_inscrire_ressource() {
  local depot="$1" nom="$2" provider="$3" version="$4" carte prefixe
  carte=$(_clia_carte "$depot") || return 1
  prefixe=$(_clia_champ_yaml "$depot/$(_clia_zone_livree)/$nom/$nom.yaml" prefixe || printf '')
  [[ -n "$prefixe" ]] || return 1
  _clia_carte_retirer "$carte" use.extensions resource  "$provider/$prefixe" \
    || _clia_carte_retirer "$carte" use.extensions ressource "$provider/$prefixe" \
    || true
  _clia_carte_inserer "$carte" use.extensions \
    "  - resource: $provider/$prefixe" \
    "    version: $version"
  return 0
}

# --------------------------------------------------------------------------
# Mettre à jour un dépôt
# --------------------------------------------------------------------------
#
# SES-001 tâche 17 : « met à jour les fichiers harnais, les ressources, les
# skills et les features de clia ». Sans --all, ce qui vient de clia ; avec,
# toutes les ressources, chacune depuis l'extension dont elle vient.
#
# Une ressource de clia est amenée à la version que clia déclarait à la
# version visée, et non à sa dernière : c'est ce qui fait qu'un dépôt aligné
# sur clia 0.9.0 tient un ensemble cohérent, et non un mélange.

_clia_mj_namespace_source() {
  local carte
  carte=$(_clia_carte "$CLIA_SOURCE_DIR") || return 1
  _clia_champ_yaml "$carte" namespace
}

# Les primitives de harness-ia à un commit du dépôt source.
#
# Trois emplacements sont essayés, parce que la disposition a changé au fil
# des versions et qu'un downgrade lit forcément une disposition ancienne. Le
# premier qui répond l'emporte ; aucun ne répond quand la version visée
# n'avait pas de harnais, et clia le dit.
_clia_mj_primitives_au_commit() {
  local commit="$1" chemin sortie
  for chemin in \
      "$(_clia_zone_ressource)/RES-002-harness-ia/livrables/primitives/" \
      "$(_clia_zone_livree)/harness-ia/primitives/" \
      '_ressources/harness-ia/primitives/'; do
    sortie=$(git -C "$CLIA_SOURCE_DIR" ls-tree --name-only "$commit" "$chemin" 2>/dev/null)
    [[ -n "$sortie" ]] && { printf '%s\n' "$sortie"; return 0; }
  done
  return 0
}

# Repose dans le harnais les fonctionnalités actives d'une ressource, et sous
# .claude les skills posés. Les fonctionnalités sont toujours reposées : la
# zone gérée n'appartient qu'à clia. Les skills suivent la règle des copies,
# leur référence étant ce que la ressource portait avant la mise à jour.
_clia_mj_reposer() {
  local depot="$1" nom="$2" avant="$3" force="$4"
  local harnais="$depot/CLAUDE.md"
  local f n src dest issue nb=0

  for f in "$depot/$(_clia_zone_livree)/$nom/features"/*.md; do
    [[ -f "$f" ]] || continue
    n=$(basename "$f" .md)
    _clia_t_pose "$harnais" "$n" feature || continue
    _clia_t_retirer "$harnais" "$n" feature
    local bloc
    bloc=$(mktemp)
    { _clia_t_borne_debut "$n" feature
      printf '## Fonctionnalité : %s\n\n' "$n"
      _clia_t_corps "$f"
      _clia_t_borne_fin "$n" feature
    } > "$bloc"
    _clia_t_inserer "$harnais" features "$bloc"
    rm -f "$bloc"
    _clia_detail "reposée : fonctionnalité $n"
    nb=$((nb + 1))
  done

  for src in "$depot/$(_clia_zone_livree)/$nom/skills"/*; do
    [[ -e "$src" ]] || continue
    if [[ -d "$src" ]]; then n=$(basename "$src"); else n=$(basename "$src" .md); fi
    dest="$depot/.claude/skills/$n"
    [[ -d "$dest" ]] || continue
    local neuf reference=''
    neuf=$(mktemp -d)/skill
    mkdir -p "$neuf"
    if [[ -d "$src" ]]; then cp -r "$src/." "$neuf/"; else cp "$src" "$neuf/SKILL.md"; fi
    if [[ -n "$avant" && -e "$avant/skills/$n" ]]; then
      reference=$(mktemp -d)/reference
      mkdir -p "$reference"
      if [[ -d "$avant/skills/$n" ]]; then cp -r "$avant/skills/$n/." "$reference/"
      else cp "$avant/skills/$n" "$reference/SKILL.md"; fi
    elif [[ -n "$avant" && -f "$avant/skills/$n.md" ]]; then
      reference=$(mktemp -d)/reference
      mkdir -p "$reference"
      cp "$avant/skills/$n.md" "$reference/SKILL.md"
    fi
    issue=$(_clia_mj_poser "$neuf" "$dest" "$reference" "$force")
    rm -rf "$(dirname "$neuf")" "${reference:+$(dirname "$reference")}"
    case "$issue" in
      'à jour') ;;
      'laissé') _clia_msg "skill $n : la copie sous .claude a été modifiée, elle est laissée"
                _clia_detail "--force la remplacerait" ;;
      *)        _clia_detail "reposé  : skill $n"
                nb=$((nb + 1)) ;;
    esac
  done
  return 0
}

# _clia_mj_depot <sens> <arguments…>
_clia_mj_depot() {
  local sens="$1"; shift
  local depot="${CLIA_WORK_DIR:-}" cible='' tout=0 force=0 migrer=0 arg
  local carte_src suivie commit_cible commit_suivi ns_src attendu

  for arg in "$@"; do
    case "$arg" in
      --all)                      tout=1 ;;
      --with-instances|--migrate) migrer=1 ;;
      --force)                    force=1 ;;
      -*) _clia_msg "option inconnue pour $sens : $arg"
          _clia_detail "les options : --all, --with-instances (ou --migrate), --force"
          return 2 ;;
      *)  if [[ -n "$cible" ]]; then
            _clia_msg "$sens n'attend qu'une version : $cible et $arg"
            return 2
          fi
          cible="$arg" ;;
    esac
  done

  if ! carte_src=$(_clia_carte_relative "$CLIA_SOURCE_DIR"); then
    _clia_msg "le dépôt source de clia ne porte pas de carte"
    _clia_detail "source : $CLIA_SOURCE_DIR"
    return 1
  fi
  _clia_carte "$depot" >/dev/null || {
    _clia_msg "ce dépôt ne porte pas de carte clia"
    _clia_detail "clia init la pose ; clia check dit ce qui manque"
    return 1
  }

  if [[ -z "$cible" ]]; then
    cible=$(_clia_m_derniere "$CLIA_SOURCE_DIR" "$carte_src") || {
      _clia_msg "aucune version de clia n'est disponible"
      _clia_detail "l'historique du dépôt source n'en déclare aucune"
      return 1
    }
  fi
  if ! commit_cible=$(_clia_m_commit_de "$CLIA_SOURCE_DIR" "$carte_src" "$cible"); then
    _clia_msg "clia ne porte pas la version $cible"
    _clia_detail "celles qu'il porte : clia setup version ls"
    return 1
  fi

  suivie=$(_clia_mj_version_suivie "$depot" || printf '')
  if [[ -z "$suivie" ]]; then
    _clia_msg "ce dépôt ne déclare pas quelle version de clia il suit"
    _clia_detail "le sens de la mise à jour ne peut pas être vérifié cette fois"
    _clia_detail "« clia-version: » sera inscrit dans sa carte"
  else
    if [[ "$(_clia_m_comparer "$suivie" "$cible")" == '0' ]]; then
      _clia_msg "ce dépôt suit déjà clia $cible"
      _clia_detail "les fichiers sont vérifiés quand même"
    else
      [[ "$sens" == 'upgrade' ]] && attendu='-1' || attendu='1'
      if [[ "$(_clia_m_comparer "$suivie" "$cible")" != "$attendu" ]]; then
        if [[ "$sens" == 'upgrade' ]]; then
          _clia_msg "$cible n'est pas supérieure à $suivie, que ce dépôt suit"
          _clia_detail "pour reculer : clia downgrade $cible"
        else
          _clia_msg "$cible n'est pas inférieure à $suivie, que ce dépôt suit"
          _clia_detail "pour avancer : clia upgrade $cible"
        fi
        return 1
      fi
    fi
    commit_suivi=$(_clia_m_commit_de "$CLIA_SOURCE_DIR" "$carte_src" "$suivie" || printf '')
  fi

  _clia_msg "clia ${suivie:-(non déclarée)} -> $cible"

  # ---- les fichiers harnais
  local chemin nom dest ref issue laisses=0 poses=0
  while IFS= read -r chemin; do
    [[ -n "$chemin" ]] || continue
    nom=$(basename "$chemin")
    dest="$depot/$nom"
    local neuf
    neuf=$(mktemp)
    _clia_m_fichier_au_commit "$CLIA_SOURCE_DIR" "$commit_cible" "$chemin" > "$neuf" || {
      rm -f "$neuf"; continue; }
    ref=''
    if [[ -n "${commit_suivi:-}" ]]; then
      ref=$(mktemp)
      _clia_m_fichier_au_commit "$CLIA_SOURCE_DIR" "$commit_suivi" "$chemin" > "$ref" \
        || { rm -f "$ref"; ref=''; }
    fi
    issue=$(_clia_mj_poser "$neuf" "$dest" "$ref" "$force")
    rm -f "$neuf"
    [[ -n "$ref" ]] && rm -f "$ref"
    case "$issue" in
      'à jour') _clia_detail "à jour  : $nom" ;;
      'laissé') _clia_msg "laissé  : $nom (modifié depuis sa pose)"
                _clia_detail "ce que l'humain édite, ce sont les primitives ; --force le remplacerait"
                laisses=$((laisses + 1)) ;;
      *)        _clia_detail "$issue   : $nom"
                poses=$((poses + 1)) ;;
    esac
  done < <(_clia_mj_primitives_au_commit "$commit_cible")

  # Une version ancienne peut n'avoir porté aucune primitive à cet
  # emplacement : les ressources n'existaient pas encore. Le dire vaut mieux
  # que rendre « 0 fichier posé » sans expliquer pourquoi.
  if [[ -z "$(_clia_mj_primitives_au_commit "$commit_cible")" ]]; then
    _clia_msg "clia $cible ne porte aucune primitive de harnais"
    _clia_detail "cette version rangeait ses harnais ailleurs, ou n'en avait pas"
    _clia_detail "les fichiers harnais du dépôt sont laissés tels quels"
  fi

  # ---- les ressources
  ns_src=$(_clia_mj_namespace_source || printf '')
  local prov version_ressource nom_res ligne avant echecs=0 majs=0
  while IFS=$'\t' read -r nom_res _ _; do
    [[ -n "$nom_res" ]] || continue
    IFS=$'\t' read -r prov _ < <(_clia_mj_provenance "$depot" "$nom_res") || continue
    local de_clia=0
    [[ -n "$ns_src" && ( "$prov" == "$ns_src" || "$ns_src" == "$prov"/* ) ]] && de_clia=1
    (( de_clia || tout )) || continue

    version_ressource=''
    if (( de_clia )); then
      local def_src
      def_src=$(_clia_mj_def_offerte "$CLIA_SOURCE_DIR" "$nom_res" || printf '')
      [[ -n "$def_src" ]] && version_ressource=$(_clia_m_fichier_au_commit \
        "$CLIA_SOURCE_DIR" "$commit_cible" "$def_src" \
        | grep -m1 -E '^version:[[:space:]]' | sed -E 's/^version:[[:space:]]*//' || printf '')
    fi

    avant=$(mktemp -d)/avant
    cp -r "$depot/$(_clia_zone_livree)/$nom_res" "$avant" 2>/dev/null || avant=''

    if ligne=$(_clia_mj_ressource "$depot" "$nom_res" "$sens" "$version_ressource" "$force" "$migrer"); then
      local n de vers issue_r
      IFS=$'\t' read -r n de vers issue_r <<<"$ligne"
      case "$issue_r" in
        'à jour') _clia_detail "à jour  : ressource $n ($vers)" ;;
        'laissé') _clia_msg "laissé  : ressource $n (modifiée depuis sa reprise)"
                  laisses=$((laisses + 1)) ;;
        *)        _clia_detail "$issue_r   : ressource $n ($de -> $vers)"
                  majs=$((majs + 1))
                  _clia_mj_reposer "$depot" "$n" "$avant" "$force" ;;
      esac
    else
      echecs=$((echecs + 1))
    fi
    [[ -n "$avant" ]] && rm -rf "$(dirname "$avant")"
  done < <(_clia_ressources_de "$depot")

  _clia_mj_inscrire_version "$depot" "$cible"

  _clia_msg "$poses fichier(s) harnais posé(s), $majs ressource(s) mise(s) à jour"
  (( laisses )) && _clia_detail "$laisses laissé(s) : ils diffèrent de ce dont ils viennent"
  (( echecs ))  && _clia_detail "$echecs refus : voir les messages ci-dessus"
  _clia_detail "la carte déclare désormais clia-version: $cible"
  _clia_detail "relisez git diff avant de commiter ; rien n'est commité"
  (( echecs )) && return 1
  return 0
}
