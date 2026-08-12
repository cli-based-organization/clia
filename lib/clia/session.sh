#!/usr/bin/env bash
# session.sh - Commande clia session.
#
# Une session est un segment de travail borne par une intention. Elle est un
# repertoire : son enonce, et le journal des taches qui la composent.
#
#   .dev/logs/SES-<SEQ>-<SLUG>/
#       SES-<SEQ>.md          l'enonce
#       TSK-<SEQ>-<slug>/     le journal d'une tache
#
# Decisions appliquees :
#   RES-034     definition du type session
#   ADR-002     la session est bornee par une intention ; le critere de
#               convergence n'a pas a etre defini a l'ouverture
#   ADR-003 D3  grammaire orientee ressources, nom puis verbe
#   ADR-003 D9  la sortie sert un humain, un agent, et un programme
#   MET-003     la tache est journalisee en sept etapes, la septieme etant le
#               message de commit
#
# Cycle de vie : todo -> open -> closed.

# --------------------------------------------------------------------------
# Localisation
# --------------------------------------------------------------------------

clia_session_dir() {
  printf '%s/logs\n' "$(clia_dev_dir)"
}

# Le fichier de session vivant, point d'entree declare par CLAUDE.md.
clia_session_vivant() {
  printf '%s/workspace/session.md\n' "$CLIA_REPO_ROOT_RESOLVED"
}

# Les enonces de session, un chemin par ligne, dans l'ordre des numeros.
clia_session_files() {
  local dir
  dir=$(clia_session_dir)
  [[ -d "$dir" ]] || return 0
  find "$dir" -mindepth 2 -maxdepth 2 -type f -name 'SES-*.md' 2>/dev/null | sort
}

# La session ouverte.
#
# Deux etats du depot sont admis, et le second est celui d'aujourd'hui :
#   - un enonce porte etat: open. C'est lui.
#   - aucun enonce n'existe. C'est alors le fichier vivant, que RES-034 nomme
#     deja le point d'entree vivant de la session en cours.
#
# Sans ce repli, la commande n'aurait rien a dire d'un depot qui travaille,
# et serait livree inutilisable.
clia_session_ouverte() {
  local f
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    if [[ "$(clia_frontmatter_field "$f" etat 2>/dev/null)" == "open" ]]; then
      printf '%s\n' "$f"
      return 0
    fi
  done < <(clia_session_files)

  local vivant
  vivant=$(clia_session_vivant)
  [[ -f "$vivant" ]] || return 1
  printf '%s\n' "$vivant"
}

# Les repertoires de journal d'une session, un par ligne, le plus recent
# d'abord.
#
# Pour un enonce, c'est son propre repertoire, et lui seul.
#
# Pour le fichier vivant, ce sont TOUS les repertoires de .dev/logs/. Le
# fichier vivant ne declare pas a quel journal il correspond, et il n'y a par
# construction qu'une session en cours : toutes les traces lui appartiennent.
#
# Ce cas n'est pas theorique. Ce depot porte deux repertoires de journal pour
# une meme session, sequelle du renommage du 2026-08-11 qui a fait passer
# 2026-08-09-SES-<slug> a SES-001-<slug>. Ne lire que le plus recent comptait
# huit taches faites sur trente-trois, alors que vingt-cinq le sont.
clia_session_journaux() {
  local file="$1" dir
  if [[ "$file" != "$(clia_session_vivant)" ]]; then
    dirname "$file"
    return 0
  fi
  dir=$(clia_session_dir)
  [[ -d "$dir" ]] || return 1
  find "$dir" -mindepth 1 -maxdepth 1 -type d -printf '%T@\t%p\n' \
    2>/dev/null | sort -rn | cut -f2-
}

# Le repertoire de journal a afficher : le plus recent.
clia_session_journal_dir() {
  clia_session_journaux "$1" | head -1
}

# --------------------------------------------------------------------------
# Mesures
# --------------------------------------------------------------------------
#
# Les numeros de tache declares par l'enonce. Une tache est un titre de niveau
# DEUX ouvert par un numero et un point : "## 12. [bogue] ...".
#
# Les rubriques d'une session sont de niveau un : "# 1. INTENTION". Le niveau
# suffit donc a distinguer une rubrique d'une tache, sans avoir a reperer ou
# commence la rubrique des taches. C'est la forme du fichier vivant, celle des
# quatre sessions archivees, et celle que ce module engendre.
#
# L'awk reste portable : ni match a trois arguments, ni gensub, qui sont des
# extensions de gawk.

clia_session_taches() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  awk '
    /^##[[:space:]]+[0-9]+[.[:space:]]/ {
      ligne = $0
      sub(/^##[[:space:]]+/, "", ligne)
      sub(/[^0-9].*$/, "", ligne)
      if (ligne ~ /^[0-9]+$/) print ligne
    }
  ' "$file"
}

# Une tache est faite quand son journal porte le message de commit.
#
# MET-003 en fait la septieme et derniere etape : sa presence atteste que les
# six autres ont ete ecrites. Le critere ne dit pas qu'une tache est bien
# faite ; il dit qu'elle est journalisee jusqu'au bout, ce qui est verifiable.
clia_session_tache_faite() {
  local file="$1" num="$2" seq journal rep
  seq=$(printf '%03d' "$((10#$num))")
  while IFS= read -r journal; do
    [[ -d "$journal" ]] || continue

    # Forme MET-003 : un repertoire par tache, le message de commit dedans.
    rep=$(find "$journal" -mindepth 1 -maxdepth 1 -type d \
          \( -name "TSK-${seq}-*" -o -name "TSK-${num}-*" \) 2>/dev/null | head -1)
    if [[ -n "$rep" ]] && find "$rep" -maxdepth 1 -type f \
         -name 'TSK-07-commit-message*' 2>/dev/null | grep -q .; then
      return 0
    fi

    # Forme anterieure a MET-003 : un journal plat, dont les fichiers portent
    # le numero de tache dans leur nom, parfois plusieurs a la fois :
    # commit-message-task-20-21.yaml couvre les taches 20 et 21.
    #
    # Reconnue parce que ce depot en porte cent vingt-six fichiers pour les
    # taches 1 a 24. L'ignorer ferait afficher neuf taches faites sur
    # trente-trois, alors que vingt-cinq le sont.
    if clia_session_journal_plat_couvre "$journal" "$num" "$seq"; then
      return 0
    fi
  done < <(clia_session_journaux "$file")
  return 1
}

clia_session_journal_plat_couvre() {
  local journal="$1" num="$2" seq="$3" f nums
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    nums=$(basename "$f" | sed -E 's/^commit-message-task-//; s/\.[a-z]+$//' \
           | tr '-' '\n')
    while IFS= read -r n; do
      [[ "$n" == "$num" || "$n" == "$seq" ]] && return 0
      [[ "$n" =~ ^[0-9]+$ ]] && (( 10#$n == 10#$num )) && return 0
    done <<< "$nums"
  done < <(find "$journal" -maxdepth 1 -type f -name 'commit-message-task-*' \
           2>/dev/null)
  return 1
}

# La date d'ouverture, au format ISO.
#
# Le champ ouverture quand il existe. Le fichier vivant n'en a pas : sa date
# de creation dans git est alors employee, ce qui est une mesure et non une
# estimation.
clia_session_ouverture() {
  local file="$1" val
  val=$(clia_frontmatter_field "$file" ouverture 2>/dev/null) || val=''
  if [[ -n "$val" && "$val" != "À RENSEIGNER" ]]; then
    printf '%s\n' "$val"
    return 0
  fi
  # Un depot sans aucun commit fait sortir git en 128, ce que set -e propage.
  # Le repli est silencieux : l'absence de date n'est pas une erreur.
  { git -C "$CLIA_REPO_ROOT_RESOLVED" log --diff-filter=A --format=%aI -- "$file" \
    2>/dev/null || true; } | tail -1
}

# Duree ecoulee depuis une date ISO, en jours et heures.
clia_session_duree() {
  local depuis="$1" debut maintenant delta jours heures
  [[ -n "$depuis" ]] || { printf '(inconnue)\n'; return 0; }
  debut=$(date -d "$depuis" +%s 2>/dev/null) || { printf '(inconnue)\n'; return 0; }
  maintenant=$(date +%s)
  delta=$(( maintenant - debut ))
  (( delta < 0 )) && delta=0
  jours=$(( delta / 86400 ))
  heures=$(( (delta % 86400) / 3600 ))
  if (( jours > 0 )); then
    printf '%d j %d h\n' "$jours" "$heures"
  elif [[ "$depuis" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    # Une date sans heure vaut minuit : afficher les heures ecoulees depuis
    # minuit ferait dire vingt-deux heures d'une session ouverte a l'instant.
    printf 'aujourd hui\n'
  else
    printf '%d h\n' "$heures"
  fi
}

clia_session_titre() {
  local file="$1" t
  t=$(clia_frontmatter_field "$file" title 2>/dev/null) || t=''
  [[ -n "$t" ]] && { printf '%s\n' "$t"; return 0; }
  # Le fichier vivant n'a pas de frontmatter : son titre est celui du
  # repertoire de journal auquel il correspond.
  local journal
  journal=$(clia_session_journal_dir "$file" 2>/dev/null) || journal=''
  if [[ -n "$journal" ]]; then
    basename "$journal" | sed -E 's/^SES-[0-9]{3}-//' | tr '-' ' '
    return 0
  fi
  printf '(sans titre)\n'
}

clia_session_id() {
  local file="$1" id
  id=$(clia_frontmatter_field "$file" id 2>/dev/null) || id=''
  [[ -n "$id" ]] && { printf '%s\n' "$id"; return 0; }
  printf '(vivant)\n'
}

clia_session_etat() {
  local file="$1" etat
  etat=$(clia_frontmatter_field "$file" etat 2>/dev/null) || etat=''
  [[ -n "$etat" ]] && { printf '%s\n' "$etat"; return 0; }
  printf 'open\n'
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

clia_session_usage() {
  cat <<'EOF'
Usage : clia session|ses|s <verbe> [arguments]

Verbes :
  status              etat de la session en cours : taches, avancement, duree
  ls                  liste les sessions, planifiees, ouverte et fermees
  new DESCRIPTION     ouvre une session. Ferme celle qui est ouverte
  close               ferme la session ouverte
  todo DESCRIPTION    cree une session en planification

Cycle de vie :
  todo -> open -> closed

Une session est un repertoire de .dev/logs/ : son enonce SES-<SEQ>.md, et le
journal des taches qui la composent.

new, close et todo sont reserves a l'humain : ils decident de ce sur quoi le
depot travaille, et ecrivent l'etat d'un document en regime d'edition humaine.

Aide detaillee d'un verbe :
  clia ses status --help
  clia ses ls --help
  clia ses new --help
  clia ses close --help
  clia ses todo --help
EOF
}

clia_session_usage_verb() {
  case "$1" in
    status) cat <<'EOF'
Usage : clia session status

Affiche l'etat de la session en cours :
  son identifiant, son titre et son etat
  le nombre de taches declarees et le nombre de taches faites
  la date d'ouverture et le temps ecoule depuis

Une tache est comptee faite quand son journal porte le message de commit,
septieme et derniere etape de MET-003. Le critere ne dit pas qu'une tache
est bien faite : il dit qu'elle est journalisee jusqu'au bout.

La session en cours est l'enonce qui porte etat: open. A defaut, c'est le
fichier de session vivant, workspace/session.md.
EOF
;;
    ls) cat <<'EOF'
Usage : clia session ls

Liste les sessions du depot, quel que soit leur etat : en planification,
ouverte, fermees. Une colonne par identifiant, etat, ouverture, avancement
et titre.

Le fichier de session vivant est affiche s'il n'existe aucun enonce ouvert.

Alias : list
EOF
;;
    new) cat <<'EOF'
Usage : clia session new DESCRIPTION

Ouvre une session. La session ouverte, s'il y en a une, est fermee d'abord.

Cree le repertoire .dev/logs/SES-<SEQ>-<SLUG>/ et son enonce SES-<SEQ>.md,
dont les quatre rubriques sont a rediger : INTENTION, CONTEXTE, LIVRABLES,
TACHES.

Reserve a l'humain. Ouvrir une session decide de ce sur quoi le depot
travaille : ADR-002 en fait un acte de l'humain, et CONSTITUTION.md C3
place l'enonce en regime d'edition humaine.
EOF
;;
    close) cat <<'EOF'
Usage : clia session close

Ferme la session ouverte : son etat passe a closed et sa date de fermeture
est inscrite.

Reserve a l'humain.

Le fichier de session vivant ne peut pas etre ferme : il ne porte pas de
frontmatter. Enregistrez-le d'abord comme enonce.
EOF
;;
    todo) cat <<'EOF'
Usage : clia session todo DESCRIPTION

Cree une session en planification, etat todo. Elle n'ouvre rien et ne ferme
rien : la session en cours reste la session en cours.

Reserve a l'humain.
EOF
;;
  esac
}

# --------------------------------------------------------------------------
# Lecture
# --------------------------------------------------------------------------

clia_session_status() {
  if clia_is_help "${1:-}"; then clia_session_usage_verb status; return 0; fi
  clia_require_repo

  local file
  if ! file=$(clia_session_ouverte) || [[ -z "$file" ]]; then
    clia_warn "aucune session ouverte"
    clia_hint "clia ses new DESCRIPTION en ouvre une"
    return 1
  fi

  local journal total faits num
  journal=$(clia_session_journal_dir "$file" 2>/dev/null) || journal=''
  total=0; faits=0
  while IFS= read -r num; do
    [[ -n "$num" ]] || continue
    total=$(( total + 1 ))
    if clia_session_tache_faite "$file" "$num"; then
      faits=$(( faits + 1 ))
    fi
  done < <(clia_session_taches "$file")

  local ouverture
  ouverture=$(clia_session_ouverture "$file")

  {
    printf 'CLE\tVALEUR\n'
    printf 'session\t%s\n' "$(clia_session_id "$file")"
    printf 'titre\t%s\n' "$(clia_session_titre "$file")"
    printf 'etat\t%s\n' "$(clia_session_etat "$file")"
    printf 'enonce\t%s\n' "${file#$CLIA_REPO_ROOT_RESOLVED/}"
    printf 'journal\t%s\n' "${journal:+${journal#$CLIA_REPO_ROOT_RESOLVED/}}"
    printf 'taches\t%s\n' "$total"
    printf 'taches faites\t%s\n' "$faits"
    printf 'taches restantes\t%s\n' "$(( total - faits ))"
    printf 'ouverture\t%s\n' "${ouverture:-(inconnue)}"
    printf 'depuis\t%s\n' "$(clia_session_duree "$ouverture")"
  } | column -t -s $'\t'

  if [[ "$file" == "$(clia_session_vivant)" ]]; then
    clia_warn "session non enregistree : le fichier vivant tient lieu d'enonce"
    clia_hint "clia ses new l'enregistrerait sous .dev/logs/SES-<SEQ>-<SLUG>/"
  fi
}

clia_session_ls() {
  if clia_is_help "${1:-}"; then clia_session_usage_verb ls; return 0; fi
  clia_require_repo

  local files
  files=$(clia_session_files)

  {
    printf 'ID\tETAT\tOUVERTURE\tFAITES\tTACHES\tTITRE\n'
    local f
    while IFS= read -r f; do
      [[ -n "$f" ]] || continue
      clia_session_ls_ligne "$f"
    done <<< "$files"

    # Le fichier vivant n'est affiche que s'il tient lieu de session ouverte.
    local vivant ouverte
    vivant=$(clia_session_vivant)
    ouverte=$(clia_session_ouverte 2>/dev/null) || ouverte=''
    if [[ -f "$vivant" && "$ouverte" == "$vivant" ]]; then
      clia_session_ls_ligne "$vivant"
    fi
  } | column -t -s $'\t'
}

clia_session_ls_ligne() {
  local f="$1" journal total faits num
  journal=$(clia_session_journal_dir "$f" 2>/dev/null) || journal=''
  total=0; faits=0
  while IFS= read -r num; do
    [[ -n "$num" ]] || continue
    total=$(( total + 1 ))
    if clia_session_tache_faite "$f" "$num"; then
      faits=$(( faits + 1 ))
    fi
  done < <(clia_session_taches "$f")
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(clia_session_id "$f")" \
    "$(clia_session_etat "$f")" \
    "$(clia_session_ouverture "$f" | cut -dT -f1)" \
    "$faits" "$total" \
    "$(clia_session_titre "$f")"
}

# --------------------------------------------------------------------------
# Ecriture
# --------------------------------------------------------------------------
#
# CONSTITUTION.md C3 : l'agent ne modifie pas un document en regime d'edition
# humaine. L'enonce d'une session en est un, et son etat decide de ce sur quoi
# le depot travaille. La garde est celle de clia git save, partagee par core.sh.

clia_session_refuser_agent() {
  local verbe="$1"
  clia_acteur_est_agent || return 0
  clia_warn "clia ses $verbe est reserve a l'humain"
  clia_hint "ouvrir et fermer une session decide de ce sur quoi le depot travaille"
  clia_hint "ADR-002 en fait un acte de l'humain, CONSTITUTION.md C3 le protege"
  clia_hint "l'agent prepare le contenu ; l'humain ouvre, ferme et approuve"
  return 3
}

clia_session_next_seq() {
  local dir max
  dir=$(clia_session_dir)
  max=$(find "$dir" -mindepth 1 -maxdepth 1 -type d -name 'SES-*' 2>/dev/null \
        | sed -E 's#.*/SES-([0-9]{3}).*#\1#' | grep -E '^[0-9]{3}$' \
        | sort -n | tail -1)
  printf '%03d\n' $(( 10#${max:-0} + 1 ))
}

# Ecrit l'enonce d'une session neuve. Les quatre rubriques sont celles que
# l'humain a nommees, dans l'ordre ou il les a nommees.
clia_session_ecrire_enonce() {
  local file="$1" seq="$2" titre="$3" etat="$4" ouverture="$5"
  {
    printf -- '---\n'
    printf 'type: session\n'
    printf 'id: SES-%s\n' "$seq"
    printf 'title: "%s"\n' "$titre"
    printf 'status: draft\n'
    printf 'ouverture: %s\n' "$ouverture"
    printf 'etat: %s\n' "$etat"
    printf -- '---\n\n'
    printf '# SES-%s - %s\n\n' "$seq" "$titre"
    printf '> À rédiger.\n\n'
    # Les rubriques sont de niveau un, les taches de niveau deux : c'est ce qui
    # permet de compter les taches sans ambiguite.
    printf '# 1. INTENTION\n\nÀ rédiger.\n\n'
    printf '# 2. CONTEXTE\n\nÀ rédiger.\n\n'
    printf '# 3. LIVRABLES\n\nÀ rédiger.\n\n'
    printf '# 4. TÂCHES\n\n'
    # Aucune tache d'exemple : elle serait comptee, et une session neuve
    # afficherait une tache alors qu'elle n'en porte aucune.
    printf 'À rédiger. Une rubrique de niveau deux par tâche, numérotée :\n'
    printf '`## <n>. [type] Titre de la tâche`\n'
  } > "$file"
}

clia_session_creer() {
  local etat="$1"; shift
  local description="$*"
  [[ -n "$description" ]] || { clia_warn "description manquante"; return 2; }
  clia_require_repo

  local slug seq dir file ouverture
  slug=$(clia_slug "$description")
  [[ -n "$slug" ]] || { clia_warn "la description ne produit aucun slug"; return 2; }
  seq=$(clia_session_next_seq)
  dir="$(clia_session_dir)/SES-${seq}-${slug}"
  file="$dir/SES-${seq}.md"

  if [[ -e "$dir" ]]; then
    clia_warn "existe deja : ${dir#$CLIA_REPO_ROOT_RESOLVED/}"
    return 1
  fi

  if [[ "$etat" == "todo" ]]; then
    ouverture='À RENSEIGNER'
  else
    ouverture=$(date +%Y-%m-%d)
  fi

  mkdir -p "$dir"
  clia_session_ecrire_enonce "$file" "$seq" "$description" "$etat" "$ouverture"

  printf '%s\n' "$file"
  clia_warn "cree : ${file#$CLIA_REPO_ROOT_RESOLVED/} (etat $etat)"
  clia_hint "clia ne redige pas le contenu : les quatre rubriques sont a remplir"
}

clia_session_new() {
  if clia_is_help "${1:-}"; then clia_session_usage_verb new; return 0; fi
  clia_session_refuser_agent new || return 3
  clia_require_repo
  [[ -n "${1:-}" ]] || { clia_warn "description manquante"; return 2; }

  # Une session ouverte est fermee d'abord : l'humain l'a demande ainsi, et
  # deux sessions ouvertes rendraient status ambigu.
  local ouverte
  ouverte=$(clia_session_ouverte 2>/dev/null) || ouverte=''
  if [[ -n "$ouverte" && "$ouverte" != "$(clia_session_vivant)" ]]; then
    clia_session_fermer_fichier "$ouverte" || return 1
  elif [[ -n "$ouverte" ]]; then
    clia_warn "le fichier de session vivant reste en place, il n'est pas ferme"
    clia_hint "${ouverte#$CLIA_REPO_ROOT_RESOLVED/} ne porte pas de frontmatter"
  fi

  clia_session_creer open "$@"
}

clia_session_todo() {
  if clia_is_help "${1:-}"; then clia_session_usage_verb todo; return 0; fi
  clia_session_refuser_agent todo || return 3
  clia_session_creer todo "$@"
}

# Passe un enonce a l'etat closed et inscrit sa date de fermeture.
# La reecriture est atomique : une interruption ne laisse pas d'enonce tronque.
clia_session_fermer_fichier() {
  local file="$1" tmp
  [[ -f "$file" ]] || { clia_warn "enonce introuvable : $file"; return 1; }
  if [[ -z "$(clia_frontmatter_field "$file" etat 2>/dev/null)" ]]; then
    clia_warn "sans frontmatter, rien a fermer : ${file#$CLIA_REPO_ROOT_RESOLVED/}"
    return 1
  fi

  tmp=$(mktemp "${file}.XXXXXX")
  awk -v jour="$(date +%Y-%m-%d)" '
    NR == 1 { print; next }
    !corps && /^---[[:space:]]*$/ {
      if (!vu_fermeture) printf "fermeture: %s\n", jour
      corps = 1; print; next
    }
    !corps && /^etat:/ { print "etat: closed"; next }
    !corps && /^fermeture:/ { vu_fermeture = 1; printf "fermeture: %s\n", jour; next }
    { print }
  ' "$file" > "$tmp"
  chmod --reference="$file" "$tmp" 2>/dev/null || true
  mv -f "$tmp" "$file"
  clia_warn "fermee : ${file#$CLIA_REPO_ROOT_RESOLVED/}"
}

clia_session_close() {
  if clia_is_help "${1:-}"; then clia_session_usage_verb close; return 0; fi
  clia_session_refuser_agent close || return 3
  clia_require_repo

  local ouverte
  if ! ouverte=$(clia_session_ouverte) || [[ -z "$ouverte" ]]; then
    clia_warn "aucune session ouverte"
    return 1
  fi
  if [[ "$ouverte" == "$(clia_session_vivant)" ]]; then
    clia_warn "le fichier de session vivant ne peut pas etre ferme"
    clia_hint "il ne porte pas de frontmatter et tient lieu d'enonce par defaut"
    clia_hint "clia ses new l'enregistrerait sous .dev/logs/SES-<SEQ>-<SLUG>/"
    return 1
  fi
  clia_session_fermer_fichier "$ouverte"
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

clia_session_main() {
  local verb="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$verb" in
    status|st)          clia_session_status "$@" ;;
    ls|list)            clia_session_ls "$@" ;;
    new)                clia_session_new "$@" ;;
    close)              clia_session_close "$@" ;;
    todo)               clia_session_todo "$@" ;;
    ''|-h|--help|help)  clia_session_usage ;;
    *)
      clia_warn "verbe inconnu : $verb"
      clia_session_usage >&2
      return 2 ;;
  esac
}
