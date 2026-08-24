#!/usr/bin/env bash
# session.sh - cycle de vie des sessions (ses / session).
# Sourcé par src/bin/clia. Requiert DEV_DIR, SESSION_FILE, SESSIONS_DIR,
# TEMPLATE_FILE. Voir ADR-006 et SPEC-003.

# _ses_frontmatter_value FILE KEY : valeur d'une clé du frontmatter, ou vide.
_ses_frontmatter_value() {
  local file="$1" key="$2"
  awk -v k="$key" '
    NR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { exit }
    infm {
      if ($1 == k":") { sub(/^[^:]+:[[:space:]]*/, ""); print; exit }
    }
  ' "$file"
}

# _ses_intention_slug FILE : slug dérivé de la première ligne utile de # Intention.
_ses_intention_slug() {
  local file="$1" line
  line="$(awk '
    /^# Intention[[:space:]]*$/ { grab = 1; next }
    grab && /^#/ { exit }
    grab && NF && $0 !~ /^</ { print; exit }
  ' "$file")"
  _slugify "${line:-session}"
}

# _ses_max_plan_seq : plus grand numéro parmi .dev/session-x<NN>.md (0 si aucun).
_ses_max_plan_seq() {
  local f n max=0
  for f in "$DEV_DIR"/session-x*.md; do
    [ -e "$f" ] || continue
    n="$(basename "$f" .md)"; n="${n#session-x}"
    if printf '%s' "$n" | grep -qE '^[0-9]+$' && [ "$n" -gt "$max" ]; then
      max="$n"
    fi
  done
  printf '%s' "$max"
}

# cmd_ses_status : session active ? nombre d'archives.
cmd_ses_status() {
  if [ -f "$SESSION_FILE" ]; then
    printf 'session active : oui (%s)\n' ".dev/session.md"
  else
    printf 'session active : non\n'
  fi
  local count=0
  if [ -d "$SESSIONS_DIR" ]; then
    count="$(find "$SESSIONS_DIR" -maxdepth 1 -name 'SES-*.md' | wc -l | tr -d '[:space:]')"
  fi
  printf 'sessions archivées : %s\n' "$count"
}

# cmd_ses_check [FILE] : valide un fichier session contre SPEC-003. 0 ou 1.
cmd_ses_check() {
  local file="${1:-$SESSION_FILE}" errors=0
  [ -f "$file" ] || _die "fichier session absent : $file" 1
  local i1 i2 i3
  i1="$(grep -n '^# Intention[[:space:]]*$' "$file" | head -n1 | cut -d: -f1)"
  i2="$(grep -n '^# Contexte[[:space:]]*$'  "$file" | head -n1 | cut -d: -f1)"
  i3="$(grep -n '^# Tâches[[:space:]]*$'     "$file" | head -n1 | cut -d: -f1)"
  [ -n "$i1" ] || { _err "section manquante : # Intention"; errors=1; }
  [ -n "$i2" ] || { _err "section manquante : # Contexte"; errors=1; }
  [ -n "$i3" ] || { _err "section manquante : # Tâches"; errors=1; }
  if [ -n "$i1" ] && [ -n "$i2" ] && [ -n "$i3" ]; then
    if ! { [ "$i1" -lt "$i2" ] && [ "$i2" -lt "$i3" ]; }; then
      _err "sections dans le désordre (attendu : Intention, Contexte, Tâches)"; errors=1
    fi
  fi
  if ! grep -qE '^## [0-9]+\.' "$file"; then
    _err "aucune tâche (## <N>. ...) sous # Tâches"; errors=1
  fi
  # S3 : numérotation des tâches strictement croissante à partir de 1.
  local expected=1 num
  while IFS= read -r num; do
    if [ "$num" != "$expected" ]; then
      _err "numérotation des tâches non séquentielle (S3 : attendu $expected, trouvé $num)"; errors=1
      break
    fi
    expected=$((expected + 1))
  done < <(grep -oE '^## [0-9]+\.' "$file" | grep -oE '[0-9]+')
  # S5 : aucun filet --- hors frontmatter.
  local fence_total fence_allowed=0
  fence_total="$(grep -cE '^---[[:space:]]*$' "$file" || true)"
  [ "$(head -n1 "$file")" = "---" ] && fence_allowed=2
  if [ "$fence_total" -gt "$fence_allowed" ]; then
    _err "filet --- hors frontmatter (S5)"; errors=1
  fi
  # S4 : session active -> start-at requis.
  if [ "$file" = "$SESSION_FILE" ] && [ -z "$(_ses_frontmatter_value "$file" start-at)" ]; then
    _err "session active sans start-at dans le frontmatter"; errors=1
  fi
  if [ "$errors" -eq 0 ]; then
    _info "conforme : $(basename "$file")"
    return 0
  fi
  return 1
}

# cmd_ses_plan [x<SEQ>] : crée .dev/session-x<YZ>.md depuis le template.
cmd_ses_plan() {
  [ -f "$TEMPLATE_FILE" ] || _die "template absent : $TEMPLATE_FILE" 1
  local seq
  if [ -n "${1:-}" ]; then
    seq="${1#x}"
    printf '%s' "$seq" | grep -qE '^[0-9]+$' || _die "séquence invalide : $1" 2
  else
    seq="$(( $(_ses_max_plan_seq) + 1 ))"
  fi
  local yz dest
  yz="$(printf '%02d' "$seq")"
  dest="$DEV_DIR/session-x$yz.md"
  [ -e "$dest" ] && _die "existe déjà : session-x$yz.md" 1
  if [ "${DRY_RUN:-0}" = 1 ]; then
    printf '[dry-run] créerait .dev/session-x%s.md depuis le template\n' "$yz"
    return 0
  fi
  cp "$TEMPLATE_FILE" "$dest"
  _info "créé : .dev/session-x$yz.md"
}

# cmd_ses_open [x<SEQ>] : promeut planification ou template en session.md.
cmd_ses_open() {
  [ -f "$SESSION_FILE" ] && _die "une session est déjà active : .dev/session.md" 1
  local src remove_src=0
  if [ -n "${1:-}" ]; then
    local seq="${1#x}"
    printf '%s' "$seq" | grep -qE '^[0-9]+$' || _die "séquence invalide : $1" 2
    src="$DEV_DIR/session-x$(printf '%02d' "$seq").md"
    [ -f "$src" ] || _die "session en planification absente : $(basename "$src")" 1
    remove_src=1
  else
    src="$TEMPLATE_FILE"
    [ -f "$src" ] || _die "template absent : $TEMPLATE_FILE" 1
  fi
  local now body
  now="$(_now_iso)"
  if [ "${DRY_RUN:-0}" = 1 ]; then
    printf '[dry-run] ouvrirait .dev/session.md depuis %s (start-at=%s)\n' "$(basename "$src")" "$now"
    [ "$remove_src" -eq 1 ] && printf '[dry-run] supprimerait %s\n' "$(basename "$src")"
    return 0
  fi
  # corps sans frontmatter éventuel du fichier source.
  body="$(awk 'NR==1 && $0=="---"{infm=1;next} infm && $0=="---"{infm=0;next} !infm{print}' "$src")"
  {
    printf -- '---\nstart-at: %s\n---\n\n' "$now"
    printf '%s\n' "$body"
  } > "$SESSION_FILE"
  [ "$remove_src" -eq 1 ] && rm -f "$src"
  _info "session ouverte : .dev/session.md (start-at=$now)"
}

# cmd_ses_close [SLUG] : archive la session active.
cmd_ses_close() {
  [ -f "$SESSION_FILE" ] || _die "aucune session active à fermer" 1
  local start now slug date hms dest
  start="$(_ses_frontmatter_value "$SESSION_FILE" start-at)"
  now="$(_now_iso)"
  [ -n "$start" ] || start="$now"
  slug="${1:-$(_ses_intention_slug "$SESSION_FILE")}"
  slug="$(_slugify "$slug")"
  [ -n "$slug" ] || slug="session"
  date="$(_iso_date "$start")"
  hms="$(_iso_hms "$start")"
  dest="$SESSIONS_DIR/SES-$date-$hms-$slug.md"
  if [ "${DRY_RUN:-0}" = 1 ]; then
    printf '[dry-run] archiverait .dev/session.md vers .dev/sessions/%s (end-at=%s)\n' "$(basename "$dest")" "$now"
    return 0
  fi
  mkdir -p "$SESSIONS_DIR"
  [ -e "$dest" ] && _die "archive déjà existante : $(basename "$dest")" 1
  # insère end-at dans le frontmatter puis écrit vers l'archive.
  awk -v end="$now" '
    NR==1 && $0=="---" { print; infm=1; next }
    infm && $0=="---" { print "end-at: " end; print; infm=0; next }
    { print }
  ' "$SESSION_FILE" > "$dest"
  rm -f "$SESSION_FILE"
  _info "session archivée : .dev/sessions/$(basename "$dest")"
}

# cmd_ses_new [x<SEQ>] : ferme la session active si présente, puis ouvre.
cmd_ses_new() {
  if [ "${DRY_RUN:-0}" = 1 ]; then
    [ -f "$SESSION_FILE" ] && printf '[dry-run] archiverait la session active\n'
    printf '[dry-run] ouvrirait une nouvelle session\n'
    return 0
  fi
  [ -f "$SESSION_FILE" ] && cmd_ses_close
  cmd_ses_open "${1:-}"
}

# cmd_ses ARGS... : dispatch du groupe ses/session. Aide depuis clia.doc.yaml.
cmd_ses() {
  local sub="${1:-}"
  case "$sub" in
    -h|--help|"") _doc_help_group ses; return 0 ;;
  esac
  shift
  # Aide propre à la sous-commande : clia ses <sub> -h.
  case "${1:-}" in
    -h|--help)
      if _doc_subcommands ses | grep -qx "$sub"; then _doc_help_sub ses "$sub"; return 0
      else _die "sous-commande ses inconnue : $sub" 2; fi
      ;;
  esac
  case "$sub" in
    status) cmd_ses_status "$@" ;;
    check)  cmd_ses_check "$@" ;;
    plan)   cmd_ses_plan "$@" ;;
    open)   cmd_ses_open "$@" ;;
    close)  cmd_ses_close "$@" ;;
    new)    cmd_ses_new "$@" ;;
    *)      _die "sous-commande ses inconnue : $sub" 2 ;;
  esac
}
