#!/usr/bin/env bash
# setup.sh - Commande clia setup.
#
# Instrumente un depot avec le systeme clia, et diagnostique son etat.
#
# A ne pas confondre avec le setup.sh de la racine, qui installe le CLI dans
# le shell de l'utilisateur. Deux niveaux distincts, et les confondre est le
# defaut que ticket-driven-ai avait deja separe :
#
#   ./setup.sh install     installe le CLI            -> le shell
#   clia setup init        instrumente un depot       -> un depot
#
# Decisions appliquees :
#   SPC-001     les criteres de conformite, et ce que l'instrumentation produit
#   ADR-003 D3  grammaire orientee ressources, nom puis verbe
#   ADR-003 D9  la sortie sert un humain, un agent, et un programme
#
# Les references I1 a I4 et C1 a C7 renvoient a SPC-001.

# --------------------------------------------------------------------------
# Ce que l'instrumentation occupe
# --------------------------------------------------------------------------
#
# SPC-001 laisse le nombre et le nom de ces emplacements hors perimetre : les
# changer ne change pas la specification. Ils sont donc declares ici, une
# seule fois, et les trois verbes les lisent.

# Fichiers de harnais, lus depuis harnais.yaml du depot source.
#
# PLN-017 chantier A. BUG-006 : la liste vivait ici a la main, et
# INTENTION.md s'y trouvait avec CLAUDE.md sans que rien ne les distingue.
# Source de verite unique desormais : .dev/harnais.yaml. Un depot source qui
# n'en porte pas encore retombe sur les deux noms anterieurs, pour que la
# commande reste utilisable pendant une migration.
clia_setup_fichiers_harnais() {
  local yaml="${CLIA_HOME:-}/${CLIA_DEV_DIR_NAME:-.dev}/harnais.yaml"
  if [[ -f "$yaml" ]]; then
    python3 -c "
import yaml, sys
d = yaml.safe_load(open(sys.argv[1], encoding='utf-8'))
for h in d.get('harnais', []):
    print(h['nom'])
" "$yaml" 2>/dev/null && return 0
  fi
  printf 'CLAUDE.md\n'
  printf 'INTENTION.md\n'
}

# Les harnais generes depuis un gabarit fichier, TSV : nom, gabarit,
# obligatoire. INTENTION.md est exclu : son gabarit n'est pas un fichier,
# clia_setup_intention le traite a part — voir harnais.yaml.
clia_setup_harnais_a_generer() {
  local source="$1" yaml
  yaml="$source/${CLIA_DEV_DIR_NAME:-.dev}/harnais.yaml"
  [[ -f "$yaml" ]] || return 1
  python3 -c "
import yaml, sys
d = yaml.safe_load(open(sys.argv[1], encoding='utf-8'))
for h in d.get('harnais', []):
    if h['nom'] == 'INTENTION.md':
        continue
    print('%s\t%s\t%s' % (h['nom'], h.get('gabarit', ''), h.get('obligatoire', False)))
" "$yaml"
}

# Repertoires crees vides.
clia_setup_repertoires() {
  printf '%s\n' "${CLIA_DEV_DIR_NAME:-.dev}"
  printf '%s/%s\n' "${CLIA_DEV_DIR_NAME:-.dev}" "${CLIA_RESOURCES_DIR_NAME:-ressources}"
  printf '%s/logs\n' "${CLIA_DEV_DIR_NAME:-.dev}"
  printf 'workspace\n'
}

# Repertoire des definitions de types, repris du depot source.
clia_setup_definitions_dir() {
  printf '%s/%s\n' "${CLIA_DEV_DIR_NAME:-.dev}" "${CLIA_RESOURCES_DIR_NAME:-ressources}"
}

# Fichier de version du depot instrumente.
#
# NON-039 Q3 : pose des maintenant, alors que le mecanisme de mise a jour
# n'existe pas. Cinq lignes ici evitent de le retro-ajouter a tout depot
# instrumente entre-temps. ISU-012 porte le reste.
clia_setup_fichier_version() {
  printf '%s/version\n' "${CLIA_DEV_DIR_NAME:-.dev}"
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

clia_setup_usage() {
  cat <<'EOF'
Usage : clia setup <verbe> [arguments]

Verbes :
  check [PATH]         diagnostique un depot : instrumentable, ou conforme
  init [PATH]          instrumente un depot, et le cree s'il n'existe pas

PATH vaut le repertoire courant par defaut.

Deux niveaux d'installation, a ne pas confondre :
  ./setup.sh install   installe le CLI dans le shell de l'utilisateur
  clia setup init      instrumente un depot avec le systeme clia

Aide detaillee d'un verbe :
  clia setup check --help
  clia setup init --help

Les criteres appliques sont ceux de SPC-001.
EOF
}

clia_setup_usage_verb() {
  case "$1" in
    check) cat <<'EOF'
Usage : clia setup check [PATH]

Diagnostique un depot. La commande ne modifie rien.

Elle repond a deux questions selon l'etat constate :
  depot non instrumente  -> peut-on l'instrumenter sans alterer son contenu ?
  depot instrumente      -> est-il conforme, et a quelle version ?

Les criteres sont ceux de SPC-001 : I1 a I4 pour l'instrumentabilite, C1 a C7
pour la conformite. Un critere bloquant faux rend le verdict defavorable ; un
avertissement nomme ce qui manque sans faire echouer.

Codes de retour :
  0  verdict favorable : conforme, ou instrumentable
  1  verdict defavorable : un critere bloquant est faux
  2  demande mal formee
EOF
;;
    init) cat <<'EOF'
Usage : clia setup init [PATH] [--dev]

Instrumente un depot. Le cree, avec son depot de gestion de versions, s'il
n'existe pas.

  --dev    regime lie : les fichiers de harnais renvoient au depot source,
           et une modification du source est immediatement visible.
           Sans ce drapeau, regime copie : le depot cible est independant.

Ce que la commande garantit, SPC-001 P1 a P5 :
  - apres instrumentation, tout critere de conformite bloquant est vrai
  - aucun emplacement deja occupe n'est ecrase ni modifie
  - le depot source n'est pas modifie
  - un emplacement conserve est annonce, non tu
  - relancer la commande sur un depot deja instrumente ne degrade rien

Codes de retour :
  0  le depot est instrumente
  1  un critere bloquant d'instrumentabilite est faux
  2  demande mal formee
EOF
;;
  esac
}

# --------------------------------------------------------------------------
# Le diagnostic
# --------------------------------------------------------------------------
#
# Chaque critere est evalue par une fonction qui retourne 0 ou non-zero, et
# le rapport est accumule pour etre rendu d'un bloc. Accumuler plutot
# qu'imprimer au fil permet d'aligner les colonnes et de rendre le verdict
# d'ensemble avant le detail.

clia_setup_rapport=''
clia_setup_bloquants_faux=0

clia_setup_verdict() {
  local ref="$1" gravite="$2" enonce="$3" resultat="$4"
  local marque
  if [[ "$resultat" == "vrai" ]]; then
    marque='ok'
  elif [[ "$gravite" == "bloquant" ]]; then
    marque='ECHEC'
    clia_setup_bloquants_faux=$(( clia_setup_bloquants_faux + 1 ))
  else
    marque='avert'
  fi
  clia_setup_rapport+="${ref}	${marque}	${enonce}
"
}

# Vrai si le depot porte la marque d'une instrumentation. C1 sert de test :
# c'est le critere que la resolution du depot courant cherche elle-meme.
clia_setup_est_instrumente() {
  local cible="$1"
  [[ -d "$cible/${CLIA_DEV_DIR_NAME:-.dev}" ]]
}

clia_setup_evaluer_instrumentabilite() {
  local cible="$1"

  [[ -d "$cible" ]] \
    && clia_setup_verdict I1 bloquant "l'emplacement existe et est un repertoire" vrai \
    || clia_setup_verdict I1 bloquant "l'emplacement existe et est un repertoire" faux

  [[ -d "$cible" && -w "$cible" ]] \
    && clia_setup_verdict I2 bloquant "l'emplacement est accessible en ecriture" vrai \
    || clia_setup_verdict I2 bloquant "l'emplacement est accessible en ecriture" faux

  if git -C "$cible" rev-parse --git-dir >/dev/null 2>&1; then
    clia_setup_verdict I3 avertissement "l'emplacement est un depot de gestion de versions" vrai
  else
    clia_setup_verdict I3 avertissement "l'emplacement est un depot de gestion de versions" faux
  fi

  # I4 : aucun emplacement occupe. On ne compte que ceux que l'instrumentation
  # poserait, et un emplacement occupe n'est pas une faute : il sera conserve.
  local occupes=0 chemin
  while IFS= read -r chemin; do
    [[ -e "$cible/$chemin" ]] && occupes=$(( occupes + 1 ))
  done < <(clia_setup_fichiers_harnais; clia_setup_repertoires)
  if (( occupes == 0 )); then
    clia_setup_verdict I4 avertissement "aucun emplacement de l'instrumentation n'est pris" vrai
  else
    clia_setup_verdict I4 avertissement \
      "aucun emplacement de l'instrumentation n'est pris ($occupes deja pris)" faux
  fi
}

clia_setup_evaluer_conformite() {
  local cible="$1" dev definitions

  dev="$cible/${CLIA_DEV_DIR_NAME:-.dev}"
  definitions="$cible/$(clia_setup_definitions_dir)"

  [[ -d "$dev" ]] \
    && clia_setup_verdict C1 bloquant "un repertoire de developpement existe" vrai \
    || clia_setup_verdict C1 bloquant "un repertoire de developpement existe" faux

  [[ -e "$cible/CLAUDE.md" ]] \
    && clia_setup_verdict C2 bloquant "un point d'entree de harnais existe" vrai \
    || clia_setup_verdict C2 bloquant "un point d'entree de harnais existe" faux

  [[ -e "$cible/INTENTION.md" ]] \
    && clia_setup_verdict C3 bloquant "l'intention ultime est declaree" vrai \
    || clia_setup_verdict C3 bloquant "l'intention ultime est declaree" faux

  # C4 : des definitions, et non un repertoire vide. Un depot sans definitions
  # repond "aucun type de ressource" a toute demande.
  #
  # find -L suit les liens : en regime lie, les definitions SONT des liens, et
  # -type f seul n'en compte aucune. Le diagnostic declarait alors non
  # conforme un depot qui fonctionne. Constate le 2026-08-12.
  local nb=0
  if [[ -d "$definitions" ]]; then
    nb=$(find -L "$definitions" -maxdepth 1 -type f -name '*.md' 2>/dev/null | grep -c '' || true)
  fi
  if (( nb > 0 )); then
    clia_setup_verdict C4 bloquant "des definitions de types existent ($nb)" vrai
  else
    clia_setup_verdict C4 bloquant "des definitions de types existent" faux
  fi

  [[ -e "$cible/workspace/session.md" ]] \
    && clia_setup_verdict C5 avertissement "un point d'entree des demandes existe" vrai \
    || clia_setup_verdict C5 avertissement "un point d'entree des demandes existe" faux

  local fichier_version version
  fichier_version="$cible/$(clia_setup_fichier_version)"
  if [[ -f "$fichier_version" ]]; then
    version=$(head -1 "$fichier_version" 2>/dev/null | tr -d '[:space:]')
    clia_setup_verdict C6 avertissement "la version d'instrumentation est declaree ($version)" vrai
    if [[ "$version" == "${CLIA_VERSION:-}" ]]; then
      clia_setup_verdict C7 avertissement "la version declaree est celle du systeme" vrai
    else
      clia_setup_verdict C7 avertissement \
        "la version declaree est celle du systeme (depot $version, systeme ${CLIA_VERSION:-?})" faux
    fi
  else
    clia_setup_verdict C6 avertissement "la version d'instrumentation est declaree" faux
    clia_setup_verdict C7 avertissement "la version declaree est celle du systeme" faux
  fi
}

clia_setup_check() {
  if clia_is_help "${1:-}"; then clia_setup_usage_verb check; return 0; fi

  local cible="${1:-$(pwd -P)}"
  # Un chemin relatif est resolu depuis le repertoire courant, sans exiger
  # qu'il existe : I1 doit pouvoir constater son absence.
  [[ "$cible" == /* ]] || cible="$(pwd -P)/${cible#./}"
  cible="${cible%/}"

  clia_setup_rapport=''
  clia_setup_bloquants_faux=0

  local niveau
  if clia_setup_est_instrumente "$cible"; then
    niveau='instrumente'
    clia_setup_evaluer_instrumentabilite "$cible"
    clia_setup_evaluer_conformite "$cible"
  else
    niveau='non instrumente'
    clia_setup_evaluer_instrumentabilite "$cible"
  fi

  local verdict
  if (( clia_setup_bloquants_faux > 0 )); then
    if [[ "$niveau" == "instrumente" ]]; then verdict='non conforme'
    else verdict='non instrumentable'; fi
  else
    if [[ "$niveau" == "instrumente" ]]; then verdict='conforme'
    else verdict='instrumentable'; fi
  fi

  {
    printf 'CLE\tVALEUR\n'
    printf 'emplacement\t%s\n' "$cible"
    printf 'etat\t%s\n' "$niveau"
    printf 'verdict\t%s\n' "$verdict"
  } | column -t -s $'\t'

  printf '\n'
  { printf 'REF\tVERDICT\tCRITERE\n'; printf '%s' "$clia_setup_rapport"; } \
    | column -t -s $'\t'

  if (( clia_setup_bloquants_faux > 0 )); then
    clia_warn "$clia_setup_bloquants_faux critere(s) bloquant(s) en echec"
    [[ "$niveau" == "non instrumente" ]] \
      || clia_hint "clia setup init le remettrait en conformite"
    return 1
  fi
  [[ "$niveau" == "non instrumente" ]] \
    && clia_hint "clia setup init l'instrumenterait"
  return 0
}

# --------------------------------------------------------------------------
# L'instrumentation
# --------------------------------------------------------------------------

clia_setup_conserves=0
clia_setup_poses=0

# Pose un fichier de harnais, sans jamais ecraser. SPC-001 P2 et P4 : un
# emplacement occupe est conserve, et il est annonce.
clia_setup_poser() {
  local source="$1" cible="$2" regime="$3" nom="$4"

  if [[ -e "$cible" ]]; then
    clia_warn "conserve, non touche : $nom"
    clia_setup_conserves=$(( clia_setup_conserves + 1 ))
    return 0
  fi
  if [[ ! -e "$source" ]]; then
    clia_warn "absent du depot source, ignore : $nom"
    return 0
  fi

  mkdir -p "$(dirname "$cible")"
  if [[ "$regime" == "lie" ]]; then
    local rel
    rel=$(realpath --relative-to="$(dirname "$cible")" "$source" 2>/dev/null) || rel="$source"
    ln -s "$rel" "$cible"
  else
    cp -p "$source" "$cible"
  fi
  clia_setup_poses=$(( clia_setup_poses + 1 ))
  return 0
}

# Genere un harnais depuis son gabarit, plutot que de copier le fichier
# racine du depot source.
#
# PLN-017 chantier B, BUG-006. clia_setup_poser copiait "$source/$nom" : un
# depot neuf heritait donc de ce que le fichier racine du depot source
# contenait. Ici la sortie depend du gabarit dans .dev/templates/harnais/,
# jamais du fichier racine du depot source : editer le gabarit change ce qui
# est genere, editer $source/CLAUDE.md ne le change pas.
#
# Ce decouplage n'oblige pas la sortie a DIFFERER de $source/CLAUDE.md. Le
# critere initial du plan exigeait un diff non vide ; corrige en executant,
# journal de la tache 16 : CLAUDE.md et CONSTITUTION.md decrivent le systeme
# clia et non le projet clia, et un contenu identique d'un depot a l'autre y
# est correct. Ce que BUG-006 reproche est la dependance a la source, pas
# une eventuelle identite de contenu.
clia_setup_generer_harnais() {
  local source="$1" cible="$2" regime="$3" nom="$4" gabarit="$5"
  local chemin_gabarit="$source/${CLIA_DEV_DIR_NAME:-.dev}/templates/harnais/$gabarit"

  if [[ -e "$cible" ]]; then
    clia_warn "conserve, non touche : $nom"
    clia_setup_conserves=$(( clia_setup_conserves + 1 ))
    return 0
  fi
  if [[ ! -f "$chemin_gabarit" ]]; then
    clia_warn "gabarit absent du depot source, ignore : $nom"
    return 0
  fi

  mkdir -p "$(dirname "$cible")"
  if [[ "$regime" == "lie" ]]; then
    local rel
    rel=$(realpath --relative-to="$(dirname "$cible")" "$chemin_gabarit" 2>/dev/null) || rel="$chemin_gabarit"
    ln -s "$rel" "$cible"
  else
    cp -p "$chemin_gabarit" "$cible"
  fi
  clia_setup_poses=$(( clia_setup_poses + 1 ))
  return 0
}

# Cree la premiere instance du type intention, et pose INTENTION.md comme un
# lien relatif vers elle.
#
# PLN-017 chantiers C et D, BUG-006. Motif : le fichier de session vit dans
# .dev/logs/ et workspace/session.md n'est qu'un lien symbolique (PLN-008) ;
# l'intention suit la meme regle. Le contenu est un gabarit VIDE, derive des
# champs et sections que RES-003 declare — ADR-018 D2, deriver plutot que
# rediger — et non copie du fichier source : aucune phrase de l'intention du
# depot source ne doit s'y trouver.
clia_setup_intention() {
  local source="$1" cible="$2"
  local lien="$cible/INTENTION.md"
  local dir_int="$cible/${CLIA_DEV_DIR_NAME:-.dev}/intentions"

  # Chantier D : un INTENTION.md deja instrumente A LA MAIN, avant que ce
  # mecanisme existe, est un fichier reel non vide a cet emplacement — pas un
  # lien. On le deplace vers .dev/intentions/INT-001-*.md et on pose le lien
  # a sa place, SANS reecrire son contenu : ANL-005 T1, un renommage
  # accompagne d'une reecriture coupe l'historique.
  if [[ -e "$lien" && ! -L "$lien" && -s "$lien" ]]; then
    mkdir -p "$dir_int"
    local slug fichier
    slug=$(basename "$lien" .md | tr '[:upper:]' '[:lower:]')
    fichier="$dir_int/INT-001-${slug}.md"
    mv "$lien" "$fichier"
    local rel
    rel=$(realpath --relative-to="$cible" "$fichier" 2>/dev/null) || rel="$fichier"
    ln -s "$rel" "$lien"
    clia_setup_poses=$(( clia_setup_poses + 1 ))
    clia_warn "migre : INTENTION.md -> ${dir_int#$cible/}/INT-001-${slug}.md"
    return 0
  fi

  if [[ -e "$lien" ]]; then
    clia_warn "conserve, non touche : INTENTION.md"
    clia_setup_conserves=$(( clia_setup_conserves + 1 ))
    return 0
  fi

  local def_res003 champs sections
  def_res003="$source/$(clia_setup_definitions_dir)/RES-003-intention.md"
  if [[ -f "$def_res003" ]]; then
    champs=$(clia_frontmatter_field "$def_res003" champs-obligatoires 2>/dev/null)
    sections=$(clia_frontmatter_field "$def_res003" sections 2>/dev/null)
  fi
  champs=$(printf '%s' "${champs:-}" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
  [[ -n "$champs" ]] || champs=$(printf 'type\nid\ntitle\nversion\nstatus\nportee\ncritere-de-satisfaction\n')

  mkdir -p "$dir_int"
  local fichier="$dir_int/INT-001-intention.md"

  {
    printf -- '---\n'
    local c
    while IFS= read -r c; do
      [[ -n "$c" ]] || continue
      case "$c" in
        type)    printf 'type: intention\n' ;;
        id)      printf 'id: INT-001\n' ;;
        title)   printf 'title: "À définir"\n' ;;
        status)  printf 'status: draft\n' ;;
        version) printf 'version: 0.1.0\n' ;;
        *)       printf '%s: À RENSEIGNER\n' "$c" ;;
      esac
    done <<< "$champs"
    # DCN-016 : trois champs universels, non declares par RES-003 ni aucune
    # autre definition — voir RES-001, section « Les quatre champs d'etat ».
    # Absents ici, l'instance echoue cue vet des sa creation.
    printf 'maturity: conception\n'
    printf 'adoption: propose\n'
    printf 'activated: true\n'
    printf -- '---\n\n'
    printf '# INT-001 - À définir\n\n'
    printf '> À rédiger.\n'
    if [[ -n "${sections:-}" ]]; then
      # « || [[ -n "$sec" ]] » : sans cette garde, la derniere section de la
      # liste n'est pas suivie d'un saut de ligne et « read » echoue en la
      # lisant. Meme piege que celui corrige a la tache 14 sur clia res
      # explain — Relations, derniere section de RES-003, disparaissait.
      printf '%s' "$sections" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//' \
        | while IFS= read -r sec || [[ -n "$sec" ]]; do
            [[ -n "$sec" ]] || continue
            printf '\n## %s\n' "$sec"
          done
    else
      printf '\n## Relations\n'
    fi
  } > "$fichier"

  local rel
  rel=$(realpath --relative-to="$cible" "$fichier" 2>/dev/null) || rel="$fichier"
  ln -s "$rel" "$lien"
  clia_setup_poses=$(( clia_setup_poses + 1 ))
  return 0
}

clia_setup_init() {
  if clia_is_help "${1:-}"; then clia_setup_usage_verb init; return 0; fi

  local regime='copie' cible=''
  while (( $# > 0 )); do
    case "$1" in
      --dev)  regime='lie'; shift ;;
      -*)     clia_warn "option inconnue : $1"
              clia_setup_usage_verb init >&2
              return 2 ;;
      *)      if [[ -n "$cible" ]]; then
                clia_warn "un seul emplacement attendu"
                return 2
              fi
              cible="$1"; shift ;;
    esac
  done
  [[ -n "$cible" ]] || cible="$(pwd -P)"
  [[ "$cible" == /* ]] || cible="$(pwd -P)/${cible#./}"
  cible="${cible%/}"

  # Le depot source est CLIA_HOME : c'est de la que viennent les fichiers de
  # harnais et les definitions de types.
  local source="${CLIA_HOME:-}"
  if [[ -z "$source" || ! -d "$source" ]]; then
    clia_warn "depot source introuvable : CLIA_HOME n'est pas resolu"
    clia_hint "activez clia : . setup.sh activate"
    return 1
  fi

  # Le regime lie n'a de sens que si le source survit au cible. On ne peut pas
  # le garantir, mais on peut refuser le cas ou le source est le cible.
  if [[ "$cible" == "$source" ]]; then
    clia_warn "le depot cible est le depot source"
    clia_hint "clia setup init instrumente un AUTRE depot que celui de clia"
    return 1
  fi

  # I1 et I2, avant tout ecrit. Le repertoire est cree s'il manque : c'est ce
  # que la demande prescrit, « cree un repo git si le repo n'existe pas ».
  if [[ ! -d "$cible" ]]; then
    mkdir -p "$cible" || { clia_warn "creation impossible : $cible"; return 1; }
    clia_warn "cree : $cible"
  fi
  if [[ ! -w "$cible" ]]; then
    clia_warn "emplacement non accessible en ecriture : $cible"
    return 1
  fi

  if ! git -C "$cible" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$cible" init -q || { clia_warn "initialisation git impossible"; return 1; }
    clia_warn "depot de gestion de versions cree"
  fi

  clia_setup_conserves=0
  clia_setup_poses=0

  local chemin
  while IFS= read -r chemin; do
    [[ -n "$chemin" ]] || continue
    if [[ -d "$cible/$chemin" ]]; then
      clia_setup_conserves=$(( clia_setup_conserves + 1 ))
    else
      mkdir -p "$cible/$chemin"
      clia_setup_poses=$(( clia_setup_poses + 1 ))
    fi
  done < <(clia_setup_repertoires)

  # PLN-017 chantiers B, C, D : les harnais sont GENERES depuis un gabarit,
  # jamais copies du fichier racine du depot source. BUG-006.
  local nom gabarit obligatoire
  while IFS=$'\t' read -r nom gabarit obligatoire; do
    [[ -n "$nom" ]] || continue
    clia_setup_generer_harnais "$source" "$cible/$nom" "$regime" "$nom" "$gabarit"
  done < <(clia_setup_harnais_a_generer "$source")

  clia_setup_intention "$source" "$cible"

  # Les definitions de types, fichier par fichier : le repertoire cible peut
  # deja en contenir, et P2 interdit d'ecraser.
  local definitions_source definitions_cible nom
  definitions_source="$source/$(clia_setup_definitions_dir)"
  definitions_cible="$cible/$(clia_setup_definitions_dir)"
  if [[ -d "$definitions_source" ]]; then
    while IFS= read -r chemin; do
      [[ -n "$chemin" ]] || continue
      nom=$(basename "$chemin")
      clia_setup_poser "$chemin" "$definitions_cible/$nom" "$regime" \
        "$(clia_setup_definitions_dir)/$nom"
    done < <(find "$definitions_source" -maxdepth 1 -type f -name '*.md' | sort)
  else
    clia_warn "le depot source ne porte aucune definition de type"
  fi

  # C6 : la version d'instrumentation. Toujours ecrite, jamais liee : elle
  # decrit le depot cible, pas le source.
  local fichier_version
  fichier_version="$cible/$(clia_setup_fichier_version)"
  if [[ -f "$fichier_version" ]]; then
    clia_warn "conserve, non touche : $(clia_setup_fichier_version)"
  else
    printf '%s\n' "${CLIA_VERSION:-0.0.0}" > "$fichier_version"
    clia_setup_poses=$(( clia_setup_poses + 1 ))
  fi

  printf '%s\n' "$cible"
  clia_warn "instrumente : $cible (regime $regime)"
  clia_hint "poses : $clia_setup_poses, conserves : $clia_setup_conserves"
  clia_hint "clia setup check \"$cible\" verifie la conformite"
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

clia_setup_main() {
  local verb="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$verb" in
    check)              clia_setup_check "$@" ;;
    init)               clia_setup_init "$@" ;;
    ''|-h|--help|help)  clia_setup_usage ;;
    *)
      clia_warn "verbe inconnu : $verb"
      clia_setup_usage >&2
      return 2 ;;
  esac
}
