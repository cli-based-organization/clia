# shellcheck shell=bash
# _scripts/lib/conformite.sh — la conformité d'une ressource.
#
# Implémente SES-001 tâche 20.
#
# Six contrôles, et ils portent sur deux choses à la fois : l'instance que le
# dépôt écrit, quand il en écrit une, et la copie qu'il a installée. Une
# ressource peut être l'une, l'autre, ou les deux — voir SPC-001-ontologie.
#
#   C0  l'IIE est là, et bien formée
#   C1  les zones sont respectées
#   C2  les données structurées ont la forme voulue
#   C3  les primitives que la livraison déclare sont là
#   C4  les scripts de migration que l'historique appelle sont là
#   C5  la version en place est la dernière disponible
#
# Ce que « conforme » veut dire ici
# ---------------------------------
#
# Un écart bloquant dit que la ressource n'est pas ce qu'elle prétend être :
# une zone qui n'est pas la sienne, une définition qui ment, un saut de
# version qu'on ne saurait pas franchir.
#
# Un signalement dit que quelque chose mériterait d'être fait, sans que rien
# soit faux. Retarder d'une version en est un — et c'est ce que SES-001
# tâche 20 demande, avec la porte de sortie qu'elle nomme :
# CLIA_POLICY_ROLLING_RESSOURCE=true en fait un écart bloquant, pour un dépôt
# qui veut suivre au plus près.
#
# Constater n'est pas réparer. Cette commande n'écrit rien.

# shellcheck source=identite.sh
. "${CLIA_SOURCE_DIR:-}/_scripts/lib/identite.sh"

_CLIA_C_BLOQUANTS=0
_CLIA_C_SIGNALEMENTS=0
_CLIA_C_EXPLIQUER=0

_clia_c_rolling() { [[ "$(_clia_politique CLIA_POLICY_ROLLING_RESSOURCE)" == 'true' ]]; }

# _clia_c_verdict <id> <ok|bloquant|signalement> <ce qu'il dit>
_clia_c_verdict() {
  local id="$1" nature="$2" texte="$3" marque
  case "$nature" in
    ok)          marque='ok' ;;
    bloquant)    marque='!!'; _CLIA_C_BLOQUANTS=$((_CLIA_C_BLOQUANTS + 1)) ;;
    signalement) marque='--'; _CLIA_C_SIGNALEMENTS=$((_CLIA_C_SIGNALEMENTS + 1)) ;;
  esac
  printf '%-3s %-2s  %s\n' "$id" "$marque" "$texte"
}

# _clia_c_explique <texte…> — ce que le contrôle vérifie, sous son verdict.
# Rendu seulement avec --explain : le compte rendu ordinaire dit ce qui est,
# non ce qui serait vérifié.
_clia_c_explique() {
  (( _CLIA_C_EXPLIQUER )) || return 0
  local ligne
  for ligne in "$@"; do
    if [[ -z "$ligne" ]]; then printf '\n'; else printf '       %s\n' "$ligne"; fi
  done
  printf '\n'
}

# --------------------------------------------------------------------------
# C0 — l'IIE
# --------------------------------------------------------------------------
#
# SES-001 tâche 24 : « la présence d'un IIE est le premier critère de
# conformité ». C'est le premier parce que c'est le seul qui décide si l'objet
# jugé est une ressource. Les quatre autres jugent une ressource ; celui-ci
# juge qu'il y en a une.

_clia_c0_identite() {
  local def="$1" depot="$2" id representation

  id=$(_clia_id_champ "$def" id)

  if [[ -z "$id" ]]; then
    _clia_c_verdict C0 bloquant "aucune identité déclarée : « id: » manque"
  elif ! _clia_id_est_absolue "$id"; then
    _clia_c_verdict C0 bloquant "« id: $id » n'a pas la forme clia:<uuid>"
  elif _clia_id_externe "$def"; then
    representation=$(_clia_id_champ "$def" representation)
    # Le chemin est relatif au fichier qui porte l'IIE : c'est de là qu'elle
    # pointe. Une URI, elle, est absolue par nature.
    if [[ "$representation" == *://* ]] || [[ -e "$(dirname "$def")/$representation" ]]; then
      _clia_c_verdict C0 ok "identité externe, vers $representation"
    else
      _clia_c_verdict C0 bloquant "elle pointe vers ce qui n'est pas là : $representation"
    fi
  else
    _clia_c_verdict C0 ok "$id"
  fi

  _clia_c_explique \
    "C0 — une ressource clia est reconnaissable à une seule chose : elle" \
    "porte des informations d'identification et d'essentialisation." \
    "" \
    "L'identité absolue est déclarée, parce qu'un uuid ne se déduit de" \
    "rien :" \
    "" \
    "    id: clia:0f9a1b2c-3d4e-5f60-8192-a3b4c5d6e7f8" \
    "" \
    "Les deux autres formes s'en dérivent — <PREFIXE>-<SEQ> dans un dépôt," \
    "<NAMESPACE>/<PREFIXE>-<SEQ> entre dépôts. Elles ne se déclarent donc" \
    "pas : la séquence vient du nom de l'instance, le namespace de la carte." \
    "" \
    "Une IIE externe — qui identifie autre chose que le fichier qui la" \
    "porte — doit dire vers quoi elle pointe, sous « representation: »." \
    "Sans cela elle n'identifie rien. Le chemin y est relatif au fichier qui" \
    "porte l'IIE ; une URI, elle, est absolue." \
    "" \
    "C'est le premier contrôle parce que c'est le seul qui décide si l'objet" \
    "jugé est une ressource. Les autres jugent une ressource ; celui-ci juge" \
    "qu'il y en a une. Voir SPC-003-identite."
}

# --------------------------------------------------------------------------
# C1 — les zones
# --------------------------------------------------------------------------

_clia_c1_zones() {
  local depot="$1" nom="$2" id="$3" inst dir entree intrus=''

  inst=$(_clia_zone_ressource)

  if [[ -n "$id" ]]; then
    dir="$depot/$inst/$id"
    for entree in "$dir"/*; do
      [[ -e "$entree" ]] || continue
      case "$(basename "$entree")" in
        primitive-1|primitive-2|genere|livrables) ;;
        generation.yaml) ;;
        *) intrus="${intrus:+$intrus }$(basename "$entree")" ;;
      esac
    done
  fi

  local livree copie=''
  livree=$(_clia_zone_livree)
  if [[ -d "$depot/$livree/$nom" ]]; then
    for entree in primitive-1 primitive-2; do
      [[ -e "$depot/$livree/$nom/$entree" ]] && copie="${copie:+$copie }$entree"
    done
  fi

  if [[ -n "$intrus" ]]; then
    _clia_c_verdict C1 bloquant "l'instance porte ce qui n'y a pas sa place : $intrus"
  elif [[ -n "$copie" ]]; then
    _clia_c_verdict C1 bloquant "la copie installée porte $copie, qui ne voyage pas"
  elif [[ -n "$id" ]]; then
    _clia_c_verdict C1 ok "les zones sont respectées"
  else
    _clia_c_verdict C1 ok "la copie installée ne porte que son livrable"
  fi

  _clia_c_explique \
    "C1 — une instance porte un répertoire par stade, et rien d'autre :" \
    "primitive-1/, primitive-2/, genere/ et livrables/. Les trois premiers" \
    "sont au besoin — SPC-002 pour ce qu'est un stade." \
    "" \
    "generation.yaml y est admis : il porte les recettes qui construisent" \
    "genere/ à partir des primitives, et « clia <ressource> make » les" \
    "applique." \
    "" \
    "livrables/ n'est pas contrôlé ici : un répertoire qui n'en porte pas" \
    "n'est pas reconnu comme une instance, et « clia res ls » l'omet." \
    "" \
    "Une copie installée ne porte pas les zones de primitives : elles" \
    "restent chez qui les écrit, et ne voyagent pas."
}

# --------------------------------------------------------------------------
# C2 — les données structurées
# --------------------------------------------------------------------------

_CLIA_C_PREFIXE='^[A-Z]{2,5}$'
_CLIA_C_ID='^[A-Z]{2,5}-[0-9]{3,}-[a-z0-9][a-z0-9-]*$'

_clia_c2_format() {
  local def="$1" nom="$2" id="$3" champ valeur ecarts=''

  for champ in nom titre prefixe version description; do
    valeur=$(_clia_champ_yaml "$def" "$champ" || printf '')
    [[ -n "$valeur" ]] || ecarts="${ecarts:+$ecarts, }$champ manque"
  done

  valeur=$(_clia_champ_yaml "$def" nom || printf '')
  [[ "$valeur" == "$nom" ]] || \
    ecarts="${ecarts:+$ecarts, }« nom: $valeur » ne dit pas $nom"

  valeur=$(_clia_champ_yaml "$def" prefixe || printf '')
  [[ "$valeur" =~ $_CLIA_C_PREFIXE ]] || \
    ecarts="${ecarts:+$ecarts, }« prefixe: $valeur » n'est pas deux à cinq majuscules"

  valeur=$(_clia_champ_yaml "$def" version || printf '')
  _clia_v_est_semantique "$valeur" || \
    ecarts="${ecarts:+$ecarts, }« version: $valeur » n'a pas la forme X.Y.Z"

  if [[ -n "$id" ]]; then
    if [[ ! "$id" =~ $_CLIA_C_ID ]]; then
      ecarts="${ecarts:+$ecarts, }l'identifiant $id n'a pas la forme PREFIXE-SEQ-SLUG"
    elif [[ "${id#*-*-}" != "$nom" ]]; then
      ecarts="${ecarts:+$ecarts, }le slug de $id ne dit pas $nom"
    fi
  fi

  if [[ -n "$ecarts" ]]; then
    _clia_c_verdict C2 bloquant "$ecarts"
  else
    _clia_c_verdict C2 ok "la définition déclare ce qu'il faut, dans la forme voulue"
  fi

  _clia_c_explique \
    "C2 — la définition déclare nom, titre, prefixe, version et description." \
    "Le nom qu'elle déclare est celui du fichier ; le préfixe s'écrit en deux" \
    "à cinq majuscules ; la version a la forme X.Y.Z." \
    "" \
    "Pour une instance, l'identifiant du répertoire a la forme" \
    "PREFIXE-SEQ-SLUG, et son slug est le nom de la ressource."
}

# --------------------------------------------------------------------------
# C3 — les primitives de la livraison
# --------------------------------------------------------------------------
#
# Une définition peut déclarer ce dont sa livraison a besoin :
#
#   primitives:
#     - fichier: primitive-1/SPC-001-ontologie.md
#
# Sans cette déclaration, la reproductibilité ne se vérifie pas : clia ne
# devine pas quelles entrées un livrable demande. Il le dit plutôt que de
# rendre un « ok » qui ne mesurerait rien.

_clia_c3_primitives() {
  local depot="$1" id="$2" def="$3" inst fichier absents='' n=0

  if [[ -z "$id" ]]; then
    _clia_c_verdict C3 ok "ce dépôt n'écrit pas cette ressource : rien à livrer ici"
    _clia_c_explique \
      "C3 — les primitives que la définition déclare doivent être là." \
      "Une ressource seulement installée ne se livre pas ici, et n'a donc" \
      "aucune primitive à porter."
    return 0
  fi

  inst="$depot/$(_clia_zone_ressource)/$id"
  while IFS="$_CLIA_SEP" read -r fichier; do
    [[ -n "$fichier" ]] || continue
    n=$((n + 1))
    [[ -e "$inst/$fichier" ]] || absents="${absents:+$absents }$fichier"
  done < <(_clia_bloc_yaml "$def" primitives fichier)

  if (( n == 0 )); then
    _clia_c_verdict C3 signalement "la livraison ne déclare pas ses primitives"
  elif [[ -n "$absents" ]]; then
    _clia_c_verdict C3 bloquant "primitive(s) déclarée(s) et absente(s) : $absents"
  else
    _clia_c_verdict C3 ok "les $n primitive(s) déclarée(s) sont là"
  fi

  _clia_c_explique \
    "C3 — un livrable reproductible est un livrable dont toutes les entrées" \
    "sont là. La définition les déclare :" \
    "" \
    "    primitives:" \
    "      - fichier: primitive-1/<nom>.md" \
    "" \
    "Sans déclaration, la reproductibilité ne se vérifie pas : clia ne" \
    "devine pas ce qu'une livraison demande, et le dit plutôt que de rendre" \
    "un « ok » qui ne mesurerait rien."
}

# --------------------------------------------------------------------------
# C4 — les scripts de migration
# --------------------------------------------------------------------------

_clia_c4_migrations() {
  local racine="$1" def_rel="$2" livrable="$3"
  local v precedent='' montants='' descendants='' n=0 versions=0

  if [[ -z "$racine" || -z "$def_rel" ]]; then
    _clia_c_verdict C4 signalement "aucun historique joignable : les sauts sont inconnus"
    _clia_c_explique \
      "C4 — chaque saut de version que l'historique déclare doit porter son" \
      "script de migration. Sans historique joignable, ils ne se lisent pas."
    return 0
  fi

  while IFS=$'\t' read -r v _; do
    [[ -n "$v" ]] || continue
    versions=$((versions + 1))
    if [[ -n "$precedent" ]]; then
      n=$((n + 1))
      [[ -f "$livrable/migrations/$precedent-$v.sh" ]] || \
        montants="${montants:+$montants }$precedent-$v"
      [[ -f "$livrable/migrations/$v-$precedent.sh" ]] || \
        descendants="${descendants:+$descendants }$v-$precedent"
    fi
    precedent="$v"
  done < <(_clia_m_versions "$racine" "$def_rel")

  if (( versions == 0 )); then
    _clia_c_verdict C4 signalement "aucune version publiée : les sauts sont inconnus"
  elif (( n == 0 )); then
    _clia_c_verdict C4 ok "une seule version publiée : aucun saut à franchir"
  elif [[ -n "$montants" ]]; then
    _clia_c_verdict C4 bloquant "saut(s) sans script de migration : $montants"
  elif [[ -n "$descendants" ]]; then
    _clia_c_verdict C4 signalement "saut(s) sans script de retour : $descendants"
  else
    _clia_c_verdict C4 ok "les $n saut(s) portent leur script, dans les deux sens"
  fi

  _clia_c_explique \
    "C4 — SES-001 tâche 17 : chaque nouvelle version fournit son script de" \
    "migration, sous <livrable>/migrations/<de>-<vers>.sh." \
    "" \
    "Un saut montant sans script est bloquant : « clia <ressource> upgrade" \
    "--migrate » le refuserait. Un saut sans script de retour est signalé :" \
    "seule la descente en pâtit, et elle est plus rare."
}

# --------------------------------------------------------------------------
# C5 — la version en place
# --------------------------------------------------------------------------

_clia_c5_version() {
  local racine="$1" def_rel="$2" courante="$3" derniere nature

  if [[ -z "$racine" || -z "$def_rel" ]] || ! derniere=$(_clia_m_derniere "$racine" "$def_rel"); then
    _clia_c_verdict C5 signalement "aucune version disponible : rien à quoi comparer"
    _clia_c_explique \
      "C5 — la version en place doit être la dernière que l'historique" \
      "déclare. Sans historique, la comparaison n'a pas lieu."
    return 0
  fi

  if [[ "$(_clia_m_comparer "$courante" "$derniere")" == '0' ]]; then
    _clia_c_verdict C5 ok "$courante est la dernière disponible"
  else
    if _clia_c_rolling; then nature='bloquant'; else nature='signalement'; fi
    _clia_c_verdict C5 "$nature" "$courante, alors que $derniere est disponible"
  fi

  _clia_c_explique \
    "C5 — la version en place est comparée à la dernière que l'historique" \
    "de son dépôt d'origine déclare." \
    "" \
    "Retarder est un signalement par défaut : une version figée est un choix," \
    "non une faute. CLIA_POLICY_ROLLING_RESSOURCE=true en fait un écart" \
    "bloquant, pour un dépôt qui veut suivre au plus près."
}

# --------------------------------------------------------------------------
# Le rapport
# --------------------------------------------------------------------------

# _clia_c_verifier <commande> <fichier> <arguments…>
_clia_c_verifier() {
  local commande="$1" fichier="$2"; shift 2
  local depot="${CLIA_WORK_DIR:-}" nom id def arg
  local racine='' def_rel='' livrable='' courante provider

  for arg in "$@"; do
    case "$arg" in
      --explain) _CLIA_C_EXPLIQUER=1 ;;
      *) _clia_msg "check n'accepte que --explain : $arg"; return 2 ;;
    esac
  done

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    return 2
  fi

  id=$(_clia_instance_de "$depot" "$nom" || printf '')

  # La définition qui fait foi est celle de l'instance quand le dépôt écrit la
  # ressource, et celle de la copie installée sinon. C'est la même règle que
  # pour la version : on juge ce qu'on écrit, à défaut ce qu'on emploie.
  if [[ -n "$id" ]]; then
    livrable="$depot/$(_clia_zone_ressource)/$id/livrables"
    def="$livrable/$nom.yaml"
    racine="$depot"
    def_rel="$(_clia_zone_ressource)/$id/livrables/$nom.yaml"
  else
    livrable="$depot/$(_clia_zone_livree)/$nom"
    def="$livrable/$nom.yaml"
    if IFS=$'\t' read -r provider _ < <(_clia_mj_provenance "$depot" "$nom"); then
      racine=$(_clia_mj_racine_extension "$depot" "$provider" || printf '')
      [[ -n "$racine" ]] && def_rel=$(_clia_mj_def_offerte "$racine" "$nom" || printf '')
      [[ -n "$def_rel" ]] || racine=''
    fi
  fi

  if [[ ! -f "$def" ]]; then
    _clia_msg "$nom ne porte pas de définition : ${def#"$depot"/}"
    _clia_detail "une ressource est un répertoire qui porte sa définition"
    return 1
  fi
  courante=$(_clia_champ_yaml "$def" version || printf '')

  printf 'ressource  %s\n' "$nom"
  printf 'définition %s\n' "${def#"$depot"/}"
  if [[ -n "$id" ]]; then
    printf 'état       écrite ici, sous %s\n' "$(_clia_zone_ressource)/$id"
  else
    printf 'état       installée, venue de %s\n' "${provider:-(provenance non déclarée)}"
  fi
  printf 'version    %s\n' "${courante:-—}"
  # La forme partageable de la ressource, non de son instance : c'est la
  # définition qui porte l'IIE, et une définition n'a pas de séquence.
  #
  # L'autorité est celle qui publie la ressource, non celle du dépôt qui la
  # lit : une ressource reprise d'une extension garde le namespace de son
  # éditeur, sans quoi deux dépôts la nommeraient différemment.
  local prefixe_def autorite
  prefixe_def=$(_clia_champ_yaml "$def" prefixe || printf '')
  if [[ -z "$id" && -n "${provider:-}" ]]; then
    printf 'identité   %s/%s\n\n' "$provider" "${prefixe_def:-—}"
  else
    autorite=$(_clia_id_partageable "$depot" "$prefixe_def")
    printf 'identité   %s\n\n' "$autorite"
  fi

  _clia_c0_identite   "$def" "$depot"
  _clia_c1_zones      "$depot" "$nom" "$id"
  _clia_c2_format     "$def" "$nom" "$id"
  _clia_c3_primitives "$depot" "$id" "$def"
  _clia_c4_migrations "$racine" "$def_rel" "$livrable"
  _clia_c5_version    "$racine" "$def_rel" "$courante"

  printf '\n'
  if (( _CLIA_C_BLOQUANTS > 0 )); then
    _clia_msg "$nom : $_CLIA_C_BLOQUANTS écart(s) bloquant(s), elle n'est pas conforme"
    (( _CLIA_C_EXPLIQUER )) || _clia_detail "ce que chaque contrôle vérifie : clia $commande check --explain"
    return 1
  fi
  if (( _CLIA_C_SIGNALEMENTS > 0 )); then
    _clia_msg "$nom : conforme, avec $_CLIA_C_SIGNALEMENTS signalement(s)"
  else
    _clia_msg "$nom : conforme"
  fi
  (( _CLIA_C_EXPLIQUER )) || _clia_detail "ce que chaque contrôle vérifie : clia $commande check --explain"
  return 0
}
