# shellcheck shell=bash
# _scripts/tests/banc.sh — les assertions, communes aux bancs.
#
# Sourcé par _scripts/tests/test_*.sh. Chaque assertion imprime une ligne, compte un
# cas, et n'interrompt jamais le banc : un échec doit laisser voir ceux qui
# suivent, sinon corriger le premier ne renseigne que sur le premier.

NB=0
ECHECS=0
SORTIE=''

ok()    { NB=$((NB+1)); printf '  ok     %s\n' "$1"; }
echec() { NB=$((NB+1)); ECHECS=$((ECHECS+1)); printf '  ÉCHEC  %s\n' "$1"
          [[ -n "${2:-}" ]] && printf '         %s\n' "$2"; return 0; }

titre() { printf '\n%s\n' "$1"; }

# rc TITRE ATTENDU COMMANDE… — exécute, compare le code de retour, et
# conserve la sortie pour les assertions de texte qui suivent.
rc() {
  local titre="$1" attendu="$2"; shift 2
  local reel
  SORTIE=$("$@" 2>&1); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-140)"
  fi
}

dit() {
  local titre="$1" motif="$2"
  if grep -q -- "$motif" <<<"$SORTIE"; then
    ok "$titre"
  else
    echec "$titre" "le motif « $motif » est absent de la sortie"
  fi
}

ne_dit_pas() {
  local titre="$1" motif="$2"
  if grep -q -- "$motif" <<<"$SORTIE"; then
    echec "$titre" "le motif « $motif » est présent alors qu'il ne devrait pas"
  else
    ok "$titre"
  fi
}

vrai() {
  local titre="$1"; shift
  if "$@"; then ok "$titre"; else echec "$titre" "condition fausse : $*"; fi
}

faux() {
  local titre="$1"; shift
  if "$@"; then echec "$titre" "condition vraie alors qu'elle devait être fausse : $*"; else ok "$titre"; fi
}

bilan() {
  printf '\n%s\n' '----------------------------------------------------------'
  if (( ECHECS == 0 )); then
    printf '%d cas, aucun échec\n' "$NB"
    return 0
  fi
  printf '%d cas, %d échec(s)\n' "$NB" "$ECHECS"
  return 1
}
