#!/usr/bin/env bash
# test_setup.sh - scenarios de USE-001 (rendre l'outil disponible sur son poste).
#
# Couvre REQ-003-F1 a F9 et SPEC-004. Bac a sable isole : HOME est redirige vers
# un repertoire temporaire, si bien qu'aucun scenario n'ecrit dans la
# configuration de shell reelle de l'utilisateur (REQ-003-NF5).

set -uo pipefail

TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP="${TEST_ROOT}/setup.sh"

pass=0
fail=0

_ok()   { printf '  [OK] %s\n' "$1"; pass=$((pass + 1)); }
_ko()   { printf '  [KO] %s\n' "$1"; fail=$((fail + 1)); }
_check() { if [ "$1" = "$2" ]; then _ok "$3"; else _ko "$3 (attendu: $1, obtenu: $2)"; fi; }

SANDBOX="$(mktemp -d)"
trap 'rm -rf "${SANDBOX}"' EXIT

# HOME redirige : tout ce qui suit ecrit dans le bac a sable, jamais ailleurs.
export HOME="${SANDBOX}/home"
mkdir -p "${HOME}"
RC="${HOME}/.bashrc"
printf '# configuration preexistante\nexport FOO=1\n' > "${RC}"
RC_ORIG="${SANDBOX}/bashrc.orig"
cp "${RC}" "${RC_ORIG}"

printf '== USE-001 : rendre l outil disponible sur son poste ==\n'

# --- 1. etat initial : non installe (flux nominal, prealable) -----------------
"${SETUP}" --check >/dev/null 2>&1
_check 1 "$?" "--check retourne 1 quand rien n'est installe"

# --- 2. installation nominale (REQ-003-F1, F2, F8) ---------------------------
out="$("${SETUP}" install 2>&1)"; rc=$?
_check 0 "${rc}" "install reussit"
grep -q "activez la session courante" <<<"${out}" \
  && _ok "install indique comment activer la session courante" \
  || _ko "install n'indique pas comment activer la session courante"
grep -qxF '# >>> clia setup >>>' "${RC}" \
  && grep -qxF '# <<< clia setup <<<' "${RC}" \
  && _ok "le bloc est delimite par ses deux marqueurs" \
  || _ko "marqueurs de bloc absents"
grep -q "export CLIA_HOME=\"${TEST_ROOT}\"" "${RC}" \
  && _ok "le bloc rattache l'arbre source (mode dev)" \
  || _ko "le bloc ne rattache pas l'arbre source"
grep -q '^export FOO=1$' "${RC}" \
  && _ok "la configuration preexistante est preservee" \
  || _ko "la configuration preexistante a ete perdue"

"${SETUP}" --check >/dev/null 2>&1
_check 0 "$?" "--check retourne 0 apres installation"

# --- 3. idempotence, meme racine (REQ-003-F3, flux 3a) -----------------------
before="$(md5sum < "${RC}")"
out="$("${SETUP}" install 2>&1)"; rc=$?
after="$(md5sum < "${RC}")"
_check 0 "${rc}" "reinstallation a l'identique reussit"
_check "${before}" "${after}" "reinstallation a l'identique n'ecrit rien"
grep -q "deja installe depuis la meme racine" <<<"${out}" \
  && _ok "reinstallation a l'identique le dit explicitement" \
  || _ko "reinstallation a l'identique ne le dit pas"

# --- 4. idempotence reconciliante, racine deplacee (REQ-003-F3, flux 3b) -----
MOVED="${SANDBOX}/arbre-deplace"
mkdir -p "${MOVED}/src/bin"
cp "${SETUP}" "${MOVED}/setup.sh"
cp "${TEST_ROOT}/src/bin/clia" "${MOVED}/src/bin/clia"
chmod +x "${MOVED}/setup.sh" "${MOVED}/src/bin/clia"

out="$("${MOVED}/setup.sh" install 2>&1)"; rc=$?
_check 0 "${rc}" "reinstallation depuis un arbre deplace reussit"
grep -q "mis a jour" <<<"${out}" \
  && _ok "le deplacement de racine est signale" \
  || _ko "le deplacement de racine n'est pas signale"
grep -q "export CLIA_HOME=\"${MOVED}\"" "${RC}" \
  && _ok "le bloc pointe desormais vers la nouvelle racine" \
  || _ko "le bloc n'a pas ete mis a jour"
_check 1 "$(grep -cxF '# >>> clia setup >>>' "${RC}")" "une seule paire de marqueurs apres mise a jour"

# --- 5. retrait exact (REQ-003-F6) -------------------------------------------
out="$("${SETUP}" --uninstall 2>&1)"; rc=$?
_check 0 "${rc}" "--uninstall reussit"
if diff -q "${RC_ORIG}" "${RC}" >/dev/null 2>&1; then
  _ok "--uninstall restitue la configuration a l'octet pres"
else
  _ko "--uninstall ne restitue pas la configuration d'origine"
fi
"${SETUP}" --uninstall >/dev/null 2>&1
_check 0 "$?" "--uninstall sur une configuration non installee reussit sans effet"

# --- 6. dependance absente (REQ-003-F7, flux 2a) -----------------------------
cp "${RC_ORIG}" "${RC}"
# PATH minimal : les utilitaires dont setup.sh a besoin pour s'executer, mais
# ni yq ni git. Retirer tout le PATH ferait echouer le script sur un utilitaire
# absent (code 127) plutot que sur le controle de dependances qu'on veut eprouver.
FAKEBIN="${SANDBOX}/bin-sans-deps"
mkdir -p "${FAKEBIN}"
for u in env bash dirname mktemp awk grep chmod mv rm cat; do
  ln -sf "$(command -v "$u")" "${FAKEBIN}/$u"
done
out="$(PATH="${FAKEBIN}" "${SETUP}" install 2>&1)"; rc=$?
_check 1 "${rc}" "install echoue quand une dependance manque"
grep -qi "dependance" <<<"${out}" \
  && _ok "le diagnostic nomme la dependance manquante" \
  || _ko "le diagnostic ne nomme pas la dependance manquante"
if diff -q "${RC_ORIG}" "${RC}" >/dev/null 2>&1; then
  _ok "aucune ecriture n'a eu lieu malgre l'echec"
else
  _ko "une ecriture a eu lieu malgre l'echec"
fi

# --- 7. configuration non accessible en ecriture (REQ-003-F7, flux 2b) -------
chmod 0444 "${RC}"
out="$("${SETUP}" install 2>&1)"; rc=$?
chmod 0644 "${RC}"
_check 1 "${rc}" "install echoue quand la configuration n'est pas accessible en ecriture"
if diff -q "${RC_ORIG}" "${RC}" >/dev/null 2>&1; then
  _ok "aucune ecriture n'a eu lieu (configuration protegee)"
else
  _ko "une ecriture a eu lieu malgre la protection"
fi

# --- 8. contrat d'extension et erreurs d'usage (REQ-003-F19, F20) ------------
out="$("${SETUP}" --contract-version 2>&1)"; rc=$?
_check 0 "${rc}" "--contract-version reussit"
grep -qx '1.0.0' <<<"${out}" \
  && _ok "--contract-version annonce la version du contrat" \
  || _ko "--contract-version n'annonce pas la version attendue"

"${SETUP}" commande-inexistante >/dev/null 2>&1
_check 2 "$?" "une commande inconnue sort en code 2"

"${SETUP}" --help >/dev/null 2>&1
_check 0 "$?" "--help sort en code 0"

# --- 9. la configuration reelle n'a jamais ete touchee (REQ-003-NF5) ---------
[ "${HOME}" = "${SANDBOX}/home" ] \
  && _ok "tous les scenarios se sont executes dans le bac a sable" \
  || _ko "HOME a fui hors du bac a sable"

printf '\n== USE-002 : creer un depot neuf deja equipe ==\n'

CLIA="${TEST_ROOT}/src/bin/clia"
CIBLES="${SANDBOX}/cibles"
mkdir -p "${CIBLES}"

# --- 10. dry-run n'ecrit rien (REQ-003-F22) ----------------------------------
out="$("${CLIA}" --dry-run setup init -C "${CIBLES}" projet-dry 2>&1)"; rc=$?
_check 0 "${rc}" "dry-run reussit"
[ ! -e "${CIBLES}/projet-dry" ] \
  && _ok "dry-run n'a rien ecrit" \
  || _ko "dry-run a cree la cible"
grep -q 'a poser' <<<"${out}" \
  && _ok "dry-run enumere ce qui serait pose" \
  || _ko "dry-run n'enumere rien"

# --- 11. init nominal (REQ-003-F10, F14, F16) --------------------------------
out="$("${CLIA}" setup init -C "${CIBLES}" projet 2>&1)"; rc=$?
TGT="${CIBLES}/projet"
_check 0 "${rc}" "init reussit sur un emplacement neuf"
[ -d "${TGT}/.git" ] \
  && _ok "le depot versionne est cree" \
  || _ko "le depot versionne n'a pas ete cree"
missing=""
for f in CLAUDE.md CONSTITUTION.md ARCHITECTURE.md INTENTION.md .dev/resource-types.yaml version.yaml; do
  [ -f "${TGT}/${f}" ] || missing="${missing} ${f}"
done
[ -z "${missing}" ] \
  && _ok "le harnais et ses actifs sont poses" \
  || _ko "fichiers manquants dans la cible :${missing}"
[ -d "${TGT}/.dev/skills" ] && [ -d "${TGT}/.dev/templates" ] \
  && _ok "competences et gabarits sont poses" \
  || _ko "competences ou gabarits absents"

# --- 12. l'outil n'est PAS distribue (REQ-003-F11, ADR-010 D6) ---------------
[ ! -e "${TGT}/src" ] && [ ! -e "${TGT}/setup.sh" ] \
  && _ok "l'outil et son script d'amorcage ne sont pas copies dans la cible" \
  || _ko "l'outil a ete copie dans la cible"
_check 0 "$(find "${TGT}" -type f -perm -u+x -not -path '*/.git/*' | wc -l)" \
  "la cible ne contient aucun executable"

# --- 13. repertoires de ressources vides -------------------------------------
[ -d "${TGT}/.dev/adr" ] && [ -z "$(ls "${TGT}/.dev/adr" 2>/dev/null | grep -v gitkeep || true)" ] \
  && _ok "les repertoires de ressources sont crees et vides" \
  || _ko "les repertoires de ressources ne sont pas vides"
[ ! -e "${TGT}/.dev/session.md" ] && [ ! -d "${TGT}/.dev/logs" ] \
  && _ok "ni point d'entree ni traces ne sont distribues" \
  || _ko "point d'entree ou traces distribues a tort"

# --- 14. marque d'installation (REQ-003-F16, ADR-013 D3) ---------------------
MARK="${TGT}/.dev/installation.yaml"
[ -f "${MARK}" ] \
  && _ok "la marque d'installation est ecrite" \
  || _ko "la marque d'installation est absente"
[ -n "$(yq -r '.version // ""' "${MARK}" 2>/dev/null)" ] \
  && _ok "la marque porte une version" \
  || _ko "la marque ne porte pas de version"
[ -n "$(yq -r '."source-revision" // ""' "${MARK}" 2>/dev/null)" ] \
  && _ok "la marque porte la revision source" \
  || _ko "la marque ne porte pas de revision source"
_check 1 "$(yq -r '.files | length > 0' "${MARK}" 2>/dev/null | grep -c true)" \
  "la marque porte les empreintes des fichiers poses"

# --- 15. refus sur cible deja equipee (REQ-003-F15, flux 2b) -----------------
out="$("${CLIA}" setup init -C "${CIBLES}" projet 2>&1)"; rc=$?
_check 1 "${rc}" "init refuse sur une cible deja equipee"
grep -qi "deja equipee" <<<"${out}" \
  && _ok "le refus nomme la cause" \
  || _ko "le refus ne nomme pas la cause"

# --- 16. refus sur emplacement non vide (flux 2c) ----------------------------
mkdir -p "${CIBLES}/occupe" && printf 'contenu\n' > "${CIBLES}/occupe/fichier.txt"
out="$("${CLIA}" setup init -C "${CIBLES}" occupe 2>&1)"; rc=$?
_check 1 "${rc}" "init refuse sur un emplacement non vide"
[ ! -f "${CIBLES}/occupe/CLAUDE.md" ] \
  && _ok "aucune ecriture sur l'emplacement non vide refuse" \
  || _ko "des fichiers ont ete poses malgre le refus"

# --- 17. depot versionne existant mais non equipe (flux 2a) ------------------
mkdir -p "${CIBLES}/depot-nu" && git -C "${CIBLES}/depot-nu" init -q
out="$("${CLIA}" setup init -C "${CIBLES}" depot-nu 2>&1)"; rc=$?
_check 0 "${rc}" "init equipe un depot versionne existant mais non equipe"
[ -f "${CIBLES}/depot-nu/CLAUDE.md" ] \
  && _ok "le harnais est pose sans recreer le depot" \
  || _ko "le harnais n'a pas ete pose"

printf '\n== USE-003 : connaitre les versions disponibles ==\n'

# --- 18. versions sur un depot equipe (lecture seule) ------------------------
before="$(find "${TGT}" -type f -not -path '*/.git/*' | sort | xargs md5sum 2>/dev/null | md5sum)"
out="$("${CLIA}" setup versions -C "${TGT}" 2>&1)"; rc=$?
after="$(find "${TGT}" -type f -not -path '*/.git/*' | sort | xargs md5sum 2>/dev/null | md5sum)"
_check 0 "${rc}" "versions reussit sur un depot equipe"
_check "${before}" "${after}" "versions n'ecrit rien"
grep -q "installee ici" <<<"${out}" \
  && _ok "versions distingue la version installee" \
  || _ko "versions n'indique pas la version installee"

# --- 19. versions hors depot equipe (flux 3a) --------------------------------
out="$("${CLIA}" setup versions -C "${CIBLES}/occupe" 2>&1)"; rc=$?
_check 0 "${rc}" "versions reussit hors d'un depot equipe"
grep -qiE "aucun systeme|hors d un depot" <<<"${out}" \
  && _ok "versions signale qu'aucune version n'est installee ici" \
  || _ko "versions ne signale pas l'absence d'installation"

# --- 20. depot equipe sans marque (flux 3b, ADR-013 D5) ----------------------
rm -f "${MARK}"
out="$("${CLIA}" setup versions -C "${TGT}" 2>&1)"; rc=$?
_check 1 "${rc}" "versions signale un depot equipe sans marque"
grep -qi "regulariser" <<<"${out}" \
  && _ok "l'etat a regulariser est nomme comme tel" \
  || _ko "l'etat a regulariser n'est pas nomme"

# --- 21. decouvrabilite du groupe (REQ-001-F7, REQ-002-F19) ------------------
"${CLIA}" -h 2>&1 | grep -q '^  setup ' \
  && _ok "clia -h enumere le groupe setup" \
  || _ko "clia -h n'enumere pas le groupe setup"
out="$("${CLIA}" setup -h 2>&1)"
grep -q 'init' <<<"${out}" && grep -q 'versions' <<<"${out}" \
  && _ok "clia setup -h enumere ses sous-commandes" \
  || _ko "clia setup -h n'enumere pas ses sous-commandes"
"${CLIA}" setup init -h >/dev/null 2>&1
_check 0 "$?" "chaque sous-commande a sa propre aide"
"${CLIA}" setup sous-commande-inexistante >/dev/null 2>&1
_check 2 "$?" "une sous-commande inconnue sort en code 2"

printf '\n%s reussites, %s echecs\n' "${pass}" "${fail}"
[ "${fail}" -eq 0 ]
