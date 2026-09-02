#!/usr/bin/env bash
# _scripts/tests/test_maj.sh — les versions disponibles, et les mises à jour.
#
# Éprouve SES-001 tâche 17.
#
# L'extension éprouvée est fabriquée dans le bac, avec trois versions dans son
# historique : « disponible » veut dire « un commit la déclare », et un banc
# qui dépendrait des versions réelles d'un dépôt voisin ne mesurerait rien.
#
# Quatre propriétés que le banc mesure, et qui n'iraient pas de soi :
#
#   une copie identique à ce dont elle vient est remplacée sans rien dire ;
#   une copie qui en diffère est laissée, et --force la remplace ;
#
#   le sens exigé est vérifié, dans les deux sens ;
#
#   une migration dont un saut manque refuse la mise à jour AVANT qu'aucun
#   fichier ne soit posé ;
#
#   ce qui est repris est ce que le commit portait, et non la dernière
#   version — un downgrade rend bien l'ancien texte.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"
REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

_TITRE_BLOC='^[A-Za-z]+ :$'
_ENTREE='^  [^ ]'

lignes_de_prose() {
  local ligne
  while IFS= read -r ligne; do
    [[ -z "$ligne" ]] && continue
    [[ "$ligne" =~ $_TITRE_BLOC ]] && continue
    [[ "$ligne" =~ $_ENTREE ]] && continue
    printf '%s\n' "$ligne"
  done
}

lignes_trop_longues() {
  local ligne
  while IFS= read -r ligne; do
    (( ${#ligne} > 80 )) && printf '%s\n' "$ligne"
  done
  return 0
}

git_() { git -C "$1" -c user.email=banc@example.invalid -c user.name=banc "${@:2}"; }

dans()   { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }
sortie() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" 2>/dev/null ); }

rc_dans() {
  local titre="$1" attendu="$2" d="$3"; shift 3
  local reel
  SORTIE=$( ( cd "$d" && "$CLIA" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-160)"
  fi
}

# Une extension dont la ressource « outil » traverse trois versions.
#
# 0.1.0  le script dit « un »
# 0.2.0  le script dit « deux », et le saut porte son script de migration
# 0.3.0  le script dit « trois », et le saut n'en porte aucun
extension() {
  local d="$BAC/ext"
  local r="$d/_ressources/outil"
  mkdir -p "$r/_scripts" "$r/migrations"
  git -C "$d" init -q
  printf 'namespace: outil.exemple.test/ext\nversion: 0.1.0\n' > "$d/clia.yaml"

  ecrire_outil() {
    cat > "$r/outil.yaml" <<YAML
nom: outil
titre: Outil
prefixe: OUT
version: $1

description: "Une ressource de banc."
YAML
    cat > "$r/_scripts/out.sh" <<SH
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: aucun
# Signature: out dis
set -euo pipefail
printf '%s\n' '$2'
SH
  }

  ecrire_outil 0.1.0 un
  git_ "$d" add -A >/dev/null; git_ "$d" commit -q -m 'outil 0.1.0'

  ecrire_outil 0.2.0 deux
  cat > "$r/migrations/0.1.0-0.2.0.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf 'migration %s -> %s pour %s\n' "$3" "$4" "$2" > "$1/.migration-faite"
SH
  cat > "$r/migrations/0.2.0-0.1.0.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf 'retour %s -> %s\n' "$3" "$4" > "$1/.migration-faite"
SH
  git_ "$d" add -A >/dev/null; git_ "$d" commit -q -m 'outil 0.2.0'

  ecrire_outil 0.3.0 trois
  git_ "$d" add -A >/dev/null; git_ "$d" commit -q -m 'outil 0.3.0'

  printf '%s\n' "$d"
}

# Un dépôt qui a repris la ressource en 0.1.0.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  printf '# Conventions\n\nMon texte.\n' > "$d/CLAUDE.md"
  ( cd "$d" && "$CLIA" extension add "$EXT" >/dev/null 2>&1 )
  # La reprise pose la dernière ; on ramène la ressource en 0.1.0 pour avoir
  # de quoi monter.
  ( cd "$d" && "$CLIA" extension install outil.exemple.test >/dev/null 2>&1 )
  ( cd "$d" && "$CLIA" out downgrade 0.1.0 >/dev/null 2>&1 )
  printf '%s\n' "$d"
}

EXT=$(extension)

# ==========================================================================
titre 'clia setup version dit la version du CLI'
# ==========================================================================

rc 'clia setup version' 0 "$CLIA" setup version
dit 'elle vient du depot source' 'le CLI vient de'
dit 'et renvoie a celle du depot de travail' 'clia version'
vrai 'la sortie standard tient sur une ligne' \
  test "$("$CLIA" setup version 2>/dev/null | wc -l)" -eq 1

rc 'clia setup version ls' 0 "$CLIA" setup version ls
dit 'l en-tete nomme les colonnes' 'VERSION *COMMIT'
dit 'la version du CLI est marquee' "^-> *$("$CLIA" setup version 2>/dev/null | sed 's/+.*//')"
dit 'la premiere version y est aussi' '0\.1\.0'
vrai 'la plus recente est en tete' \
  test "$("$CLIA" setup version ls 2>/dev/null | sed -n '2p' | grep -c '^->')" -eq 1

rc 'un verbe inconnu sous version est mal forme' 2 "$CLIA" setup version bidule
rc 'version ls ne prend pas d argument' 2 "$CLIA" setup version ls trop

SORTIE=$("$CLIA" setup --help 2>/dev/null)
dit 'la signature figure dans l aide' 'clia setup version ls'
RESTE=$("$CLIA" setup --help 2>/dev/null | lignes_de_prose)
vrai 'et l aide ne porte toujours aucune prose' test -z "$RESTE"

# ==========================================================================
titre 'Les deux commandes sont decouvertes, et documentees'
# ==========================================================================

rc 'clia --help les liste' 0 "$CLIA" --help
dit 'upgrade y figure' '^  upgrade  *Amène le dépôt'
dit 'downgrade aussi' '^  downgrade  *Ramène le dépôt'

for cmd in upgrade downgrade; do
  rc "clia $cmd --help" 0 "$CLIA" "$cmd" --help
  dit "sa signature y est" "clia $cmd \[--with-instances"
  dit "avec ses options" '\-\-force'
  RESTE=$("$CLIA" "$cmd" --help 2>/dev/null | lignes_de_prose)
  vrai "l aide de $cmd ne porte aucune prose" test -z "$RESTE"
  [[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

  rc "clia $cmd --man" 0 "$CLIA" "$cmd" --man
  dit "la page porte son nom" "^CLIA-$(printf '%s' "$cmd" | tr '[:lower:]' '[:upper:]')(1)"
  for section in NOM SYNOPSIS DESCRIPTION OPTIONS SORTIE \
                 'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
    dit "la section $section y est" "^$section\$"
  done
  LONGUES=$("$CLIA" "$cmd" --man 2>/dev/null | lignes_trop_longues)
  vrai "aucune ligne du manuel de $cmd ne depasse 80 colonnes" test -z "$LONGUES"
  [[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"
done

SORTIE=$("$CLIA" res --help 2>/dev/null)
dit 'les verbes generiques figurent dans l aide d une ressource' 'clia res upgrade'
dit 'downgrade aussi' 'clia res downgrade'
dit 'et migrate aussi' 'clia res migrate \[DE VERS\]'

# ==========================================================================
titre 'Mettre a jour une ressource'
# ==========================================================================

D=$(depot travail)
vrai 'la ressource est en 0.1.0' \
  grep -q '^version: 0.1.0$' "$D/_ressources/outil/outil.yaml"
rc_dans 'et son script dit ce que 0.1.0 disait' 0 "$D" out dis
dit 'un' '^un$'

rc_dans 'clia RESSOURCE upgrade prend la derniere' 0 "$D" out upgrade
dit 'et nomme le saut' '0.1.0 -> 0.3.0'
vrai 'la definition porte la nouvelle version' \
  grep -q '^version: 0.3.0$' "$D/_ressources/outil/outil.yaml"
rc_dans 'et le script est celui de 0.3.0' 0 "$D" out dis
dit 'trois' '^trois$'
vrai 'l inventaire suit' \
  grep -A1 'resource: outil.exemple.test/ext/OUT' "$D/clia.yaml" | grep -q 'version: 0.3.0'
vrai 'et il ne porte qu une entree' \
  test "$(grep -c 'resource: outil.exemple.test/ext/OUT' "$D/clia.yaml")" -eq 1

rc_dans 'remonter quand on y est deja ne fait rien' 0 "$D" out upgrade
dit 'et clia le dit' 'est déjà en 0.3.0'

rc_dans 'un upgrade vers une version inferieure est refuse' 1 "$D" out upgrade 0.2.0
dit 'et clia renvoie a downgrade' 'clia out downgrade 0.2.0'

rc_dans 'clia RESSOURCE downgrade ramene' 0 "$D" out downgrade 0.1.0
dit 'et nomme le saut' '0.3.0 -> 0.1.0'
rc_dans 'et le script est redevenu celui de 0.1.0' 0 "$D" out dis
dit 'un' '^un$'

rc_dans 'un downgrade vers une version superieure est refuse' 1 "$D" out downgrade 0.3.0
dit 'et clia renvoie a upgrade' 'clia out upgrade 0.3.0'
rc_dans 'une version que l extension ne declare pas est refusee' 1 "$D" out upgrade 9.9.9
dit 'et clia le dit' 'ne déclare pas la version 9.9.9'
rc_dans 'une option inconnue est mal formee' 2 "$D" out upgrade --bidule

# Une ressource que l'inventaire ne connaît pas n'a pas de provenance.
mkdir -p "$D/_ressources/local/_scripts"
printf 'nom: local\ntitre: Local\nprefixe: LOC\nversion: 0.1.0\n' > "$D/_ressources/local/local.yaml"
printf '#!/usr/bin/env bash\n# Description: locale.\n# Périmètre: aucun\n# Signature: loc ls\nexit 0\n' \
  > "$D/_ressources/local/_scripts/loc.sh"
rc_dans 'une ressource sans provenance n est pas mise a jour' 1 "$D" loc upgrade
dit 'et clia refuse de deviner' "ne devine pas une provenance"

# ==========================================================================
titre 'La regle des copies editees'
# ==========================================================================

E=$(depot editee)
printf '\nune ligne ajoutee sur place\n' >> "$E/_ressources/outil/_scripts/out.sh"
rc_dans 'une ressource modifiee sur place est laissee' 1 "$E" out upgrade
dit 'et clia dit ce qui serait perdu' 'serait perdu'
vrai 'elle est intacte' grep -q 'une ligne ajoutee sur place' "$E/_ressources/outil/_scripts/out.sh"
vrai 'et sa version n a pas bouge' grep -q '^version: 0.1.0$' "$E/_ressources/outil/outil.yaml"

rc_dans 'avec --force elle est remplacee' 0 "$E" out upgrade --force
dit 'et clia dit ce qui est perdu' 'posée de force'
vrai 'la ligne ajoutee est partie' \
  test "$(grep -c 'une ligne ajoutee sur place' "$E/_ressources/outil/_scripts/out.sh")" -eq 0

# ==========================================================================
titre 'Migrer les instances'
# ==========================================================================

M=$(depot migration)
rc_dans 'un saut qui porte son script migre' 0 "$M" out upgrade --migrate 0.2.0
dit 'et clia nomme le saut franchi' 'migré  : outil 0.1.0 -> 0.2.0'
vrai 'le script a bien tourne' test -f "$M/.migration-faite"
vrai 'et il a recu les deux versions' grep -q '0.1.0 -> 0.2.0' "$M/.migration-faite"

rm -f "$M/.migration-faite"
rc_dans 'un saut sans script refuse la mise a jour' 1 "$M" out upgrade --migrate
dit 'en nommant le saut qui manque' 'aucun script de migration pour 0.2.0 -> 0.3.0'
dit 'et en disant la regle' 'doit fournir son script de migration'
vrai 'et rien n a ete pose' grep -q '^version: 0.2.0$' "$M/_ressources/outil/outil.yaml"
vrai 'ni migre' test ! -e "$M/.migration-faite"

rc_dans 'sans --migrate le meme saut passe' 0 "$M" out upgrade
vrai 'la ressource est montee' grep -q '^version: 0.3.0$' "$M/_ressources/outil/outil.yaml"
vrai 'et rien n a ete migre' test ! -e "$M/.migration-faite"

# clia RESSOURCE migrate, explicitement.
rc_dans 'clia RESSOURCE migrate franchit un saut nomme' 0 "$M" out migrate 0.1.0 0.2.0
vrai 'et le script a tourne' test -f "$M/.migration-faite"
rc_dans 'un saut sans script est refuse' 1 "$M" out migrate 0.2.0 0.3.0
dit 'et clia dit ou le ranger' 'migrations/<de>-<vers>.sh'
rc_dans 'migrate avec une seule version est mal forme' 2 "$M" out migrate 0.1.0
rc_dans 'migrer sans saut le dit' 0 "$M" out migrate 0.3.0 0.3.0

# La descente a son propre script, et c'est un autre fichier : 0.2.0-0.1.0.sh
# accompagne 0.2.0, comme 0.1.0-0.2.0.sh. Un saut n'est pas réversible tout
# seul, et l'extension doit fournir les deux.
rm -f "$M/.migration-faite"
dans "$M" out downgrade 0.2.0 >/dev/null 2>&1
rc_dans 'un downgrade migre en sens inverse' 0 "$M" out downgrade --migrate 0.1.0
dit 'et clia nomme le saut descendant' 'migré  : outil 0.2.0 -> 0.1.0'
vrai 'le script de descente a tourne' grep -q 'retour 0.2.0 -> 0.1.0' "$M/.migration-faite"

rc_dans 'une descente sans script est refusee' 1 "$M" out upgrade --migrate 0.3.0
dit 'car 0.3.0 n a pas fourni le sien' 'aucun script de migration pour 0.2.0 -> 0.3.0'

# ==========================================================================
titre 'Mettre a jour le depot'
# ==========================================================================

R=$(depot repo)
vrai 'la carte ne declare pas encore la version suivie' \
  test "$(grep -c '^clia-version:' "$R/clia.yaml")" -eq 0

rc_dans 'clia upgrade est satisfaite' 0 "$R" upgrade
dit 'et clia dit que la version suivie n etait pas declaree' 'ne déclare pas quelle version'
dit 'et nomme le saut' 'clia (non déclarée) ->'
dit 'et rappelle de relire le diff' 'relisez git diff'
vrai 'la carte la declare maintenant' grep -q '^clia-version: ' "$R/clia.yaml"

SUIVIE=$(sed -nE 's/^clia-version:[[:space:]]*//p' "$R/clia.yaml")
rc_dans 'refaire le meme upgrade le dit' 0 "$R" upgrade
dit 'que le depot suit deja cette version' "suit déjà clia $SUIVIE"

rc_dans 'un upgrade vers une version anterieure est refuse' 1 "$R" upgrade 0.1.0
dit 'et clia renvoie a downgrade' 'clia downgrade 0.1.0'
rc_dans 'un downgrade fonctionne' 0 "$R" downgrade 0.7.0
vrai 'et la carte suit' grep -q '^clia-version: 0.7.0$' "$R/clia.yaml"
rc_dans 'un downgrade vers une version posterieure est refuse' 1 "$R" downgrade "$SUIVIE"
dit 'et clia renvoie a upgrade' "clia upgrade $SUIVIE"

rc_dans 'une version que clia ne porte pas est refusee' 1 "$R" upgrade 99.0.0
dit 'et clia renvoie a la liste' 'clia setup version ls'
rc_dans 'une option inconnue est mal formee' 2 "$R" upgrade --bidule
rc_dans 'deux versions sont mal formees' 2 "$R" upgrade 0.8.0 0.9.0

# Le harnais suit la règle des copies.
H=$(depot harnais)
dans "$H" upgrade >/dev/null 2>&1
printf '\nma convention à moi\n' >> "$H/CLAUDE.md"
rc_dans 'un harnais edite est laisse' 0 "$H" upgrade --force 2>/dev/null || true
SORTIE=$( ( cd "$H" && "$CLIA" downgrade 0.7.0 ) 2>&1 )
dit 'le compte rendu nomme chaque fichier' 'CLAUDE.md'

# --all touche aussi les ressources des autres extensions.
A=$(depot toutes)
dans "$A" upgrade >/dev/null 2>&1
vrai 'sans --all la ressource de l extension reste ou elle est' \
  grep -q '^version: 0.1.0$' "$A/_ressources/outil/outil.yaml"
rc_dans 'avec --all elle monte' 0 "$A" upgrade --all
vrai 'a la derniere que son extension declare' \
  grep -q '^version: 0.3.0$' "$A/_ressources/outil/outil.yaml"

# ==========================================================================
titre 'La publication signale le script de migration manquant'
# ==========================================================================

P=$(depot publication)
git_ "$P" add -A >/dev/null; git_ "$P" commit -q -m 'etat de depart'
rc_dans 'clia res release est satisfaite' 0 "$P" res release patch outil
dit 'et clia signale le script absent' 'aucun script de migration pour'
dit 'en disant ou le ranger' 'migrations/'

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
