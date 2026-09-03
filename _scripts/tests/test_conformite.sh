#!/usr/bin/env bash
# _scripts/tests/test_conformite.sh — la conformité d'une ressource.
#
# Éprouve SES-001 tâche 20 : les cinq contrôles, et le verbe générique qui
# les porte.
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   chaque contrôle échoue pour sa propre raison. Un banc qui ne vérifierait
#   que le cas conforme ne dirait pas si les contrôles regardent quelque
#   chose ;
#
#   un écart bloquant rend 1, un signalement rend 0. La distinction est ce
#   qui rend la commande lançable souvent ;
#
#   CLIA_POLICY_ROLLING_RESSOURCE change le verdict de C5, et de lui seul.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"

INST='.dev/ressources'
LIVREE='.clia/ressources'

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

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

# Écrit le livrable d'une ressource « outil » à une version donnée.
ecrire_outil() {
  local liv="$1" version="$2"
  mkdir -p "$liv/_scripts"
  cat > "$liv/outil.yaml" <<YAML
nom: outil
id: clia:0f9a1b2c-3d4e-5f60-8192-a3b4c5d6e7f8
titre: Outil
prefixe: OUT
version: $version

description: "Une ressource de banc."
YAML
  cat > "$liv/_scripts/out.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: aucun
# Signature: out dis
set -euo pipefail
printf 'un\n'
SH
}

# Un dépôt qui écrit la ressource outil, en une seule version commitée.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d/$INST/RES-001-outil/primitive-1" "$d/$INST/RES-001-outil/primitive-2"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  ecrire_outil "$d/$INST/RES-001-outil/livrables" 0.1.0
  printf 'une primitive\n' > "$d/$INST/RES-001-outil/primitive-1/p.md"
  # La ressource doit être installée pour que sa commande réponde.
  mkdir -p "$d/$LIVREE"
  cp -r "$d/$INST/RES-001-outil/livrables" "$d/$LIVREE/outil"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'outil 0.1.0'
  printf '%s\n' "$d"
}

# ==========================================================================
titre 'Le verbe est tenu pour toutes les ressources, et documente'
# ==========================================================================

SORTIE=$("$CLIA" res --help 2>/dev/null)
dit 'il figure dans l aide d une ressource' 'clia res check \[--explain\]'
SORTIE=$("$CLIA" hrn --help 2>/dev/null)
dit 'et dans celle d une autre, sans qu elle l ait declare' 'clia hrn check \[--explain\]'

rc 'le manuel de clia le decrit' 0 "$CLIA" --man
dit 'sous les verbes des ressources' 'check \[--explain\]'
dit 'et il compte neuf verbes' 'Neuf verbes valent pour toute commande'
dit 'la politique y est declaree' 'CLIA_POLICY_ROLLING_RESSOURCE'

# ==========================================================================
titre 'Une ressource conforme'
# ==========================================================================

D=$(depot conforme)
rc_dans 'clia RESSOURCE check est satisfaite' 0 "$D" out check
dit 'l en-tete nomme la ressource' '^ressource  outil$'
dit 'et dit qu elle est ecrite ici' 'écrite ici, sous \.dev/ressources/RES-001-outil'
dit 'et sa version' '^version    0\.1\.0$'

dit 'C1 passe' '^C1  ok'
dit 'C2 passe' '^C2  ok'
dit 'C4 passe' '^C4  ok  une seule version publiée'
dit 'C5 passe' '^C5  ok  0\.1\.0 est la dernière disponible'
dit 'C3 signale la declaration absente' '^C3  --  la livraison ne déclare pas'
dit 'et le verdict compte les signalements' 'conforme, avec 1 signalement'
dit 'et renvoie vers --explain' 'clia out check --explain'

rc_dans 'clia RESSOURCE check --explain est satisfaite' 0 "$D" out check --explain
dit 'chaque controle est explique' 'C1 — une instance porte un répertoire par stade'
dit 'C2 aussi' 'C2 — la définition déclare nom, titre'
dit 'C3 aussi' 'C3 — un livrable reproductible'
dit 'C4 aussi' 'C4 — SES-001 tâche 17'
dit 'C5 aussi' 'C5 — la version en place est comparée'
ne_dit_pas 'et il ne renvoie plus vers --explain' 'clia out check --explain$'

LONGUES=$(sortie "$D" out check --explain | lignes_trop_longues)
vrai 'aucune ligne ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

rc_dans 'une option inconnue est mal formee' 2 "$D" out check --bidule

# ==========================================================================
titre 'C1 — les zones'
# ==========================================================================

Z=$(depot zones)
mkdir -p "$Z/$INST/RES-001-outil/brouillon"
rc_dans 'ce qui n a pas sa place dans l instance est bloquant' 1 "$Z" out check
dit 'et clia le nomme' '^C1  !!  .*brouillon'
dit 'et la ressource est dite non conforme' "n'est pas conforme"
rm -rf "$Z/$INST/RES-001-outil/brouillon"
rc_dans 'retire, elle redevient conforme' 0 "$Z" out check

# Un répertoire sans livrables/ n'est plus une instance : ce n'est pas un
# écart de conformité, c'est une instance que rien ne reconnaît.
mv "$Z/$INST/RES-001-outil/livrables" "$Z/$INST/RES-001-outil/livrable"
rc_dans 'sans livrables, l instance n en est plus une' 0 "$Z" out check
dit 'et check juge la copie installee' '^état       installée'
SORTIE=$(sortie "$Z" res ls)
ne_dit_pas 'et res ls ne la dit plus ecrite' 'outil *0\.1\.0 *écrite'
mv "$Z/$INST/RES-001-outil/livrable" "$Z/$INST/RES-001-outil/livrables"

Z2=$(depot zones-copie)
mkdir -p "$Z2/$LIVREE/outil/primitive-1"
rc_dans 'une copie installee qui porte des primitives est bloquante' 1 "$Z2" out check
dit 'et clia dit ce qui ne voyage pas' '^C1  !!  .*ne voyage pas'

# ==========================================================================
titre 'C2 — la forme des donnees'
# ==========================================================================

F=$(depot format)
sed -i '/^titre:/d' "$F/$INST/RES-001-outil/livrables/outil.yaml"
rc_dans 'un champ absent est bloquant' 1 "$F" out check
dit 'et clia nomme le champ' '^C2  !!  .*titre manque'

F2=$(depot format-prefixe)
sed -i 's/^prefixe: OUT$/prefixe: out/' "$F2/$INST/RES-001-outil/livrables/outil.yaml"
rc_dans 'un prefixe mal forme est bloquant' 1 "$F2" out check
dit 'et clia rappelle la regle' 'deux à cinq majuscules'

F3=$(depot format-version)
sed -i 's/^version: 0.1.0$/version: toute-neuve/' "$F3/$INST/RES-001-outil/livrables/outil.yaml"
rc_dans 'une version non semantique est bloquante' 1 "$F3" out check
dit 'et clia rappelle la forme' "n'a pas la forme X.Y.Z"

F4=$(depot format-id)
mv "$F4/$INST/RES-001-outil" "$F4/$INST/RES-001-autre-chose"
rc_dans 'un slug qui ne dit pas la ressource est bloquant' 1 "$F4" out check
dit 'et clia le dit' '^C2  !!  .*ne dit pas outil'

# ==========================================================================
titre 'C3 — les primitives de la livraison'
# ==========================================================================

P=$(depot primitives)
printf '\nprimitives:\n  - fichier: primitive-1/p.md\n' \
  >> "$P/$INST/RES-001-outil/livrables/outil.yaml"
rc_dans 'une primitive declaree et presente passe' 0 "$P" out check
dit 'et clia les compte' '^C3  ok  les 1 primitive'

printf '\nprimitives:\n  - fichier: primitive-2/SPC-001.md\n' \
  >> "$P/$INST/RES-001-outil/livrables/outil.yaml"
rc_dans 'une primitive declaree et absente est bloquante' 1 "$P" out check
dit 'et clia la nomme' '^C3  !!  .*SPC-001\.md'

# ==========================================================================
titre 'C4 — les scripts de migration'
# ==========================================================================

M=$(depot migrations)
ecrire_outil "$M/$INST/RES-001-outil/livrables" 0.2.0
git_ "$M" add -A >/dev/null; git_ "$M" commit -q -m 'outil 0.2.0'

rc_dans 'un saut montant sans script est bloquant' 1 "$M" out check
dit 'et clia nomme le saut' '^C4  !!  .*0\.1\.0-0\.2\.0'

mkdir -p "$M/$INST/RES-001-outil/livrables/migrations"
printf '#!/usr/bin/env bash\nexit 0\n' > "$M/$INST/RES-001-outil/livrables/migrations/0.1.0-0.2.0.sh"
git_ "$M" add -A >/dev/null; git_ "$M" commit -q -m 'la migration montante'
rc_dans 'le script montant pose, le retour est signale' 0 "$M" out check
dit 'et clia nomme le saut de retour' '^C4  --  .*0\.2\.0-0\.1\.0'

printf '#!/usr/bin/env bash\nexit 0\n' > "$M/$INST/RES-001-outil/livrables/migrations/0.2.0-0.1.0.sh"
git_ "$M" add -A >/dev/null; git_ "$M" commit -q -m 'la migration descendante'
rc_dans 'les deux poses, C4 passe' 0 "$M" out check
dit 'et clia le dit' '^C4  ok  les 1 saut'

# ==========================================================================
titre 'C5 — la version en place'
# ==========================================================================

V=$(depot version)
ecrire_outil "$V/$INST/RES-001-outil/livrables" 0.2.0
mkdir -p "$V/$INST/RES-001-outil/livrables/migrations"
printf '#!/usr/bin/env bash\nexit 0\n' > "$V/$INST/RES-001-outil/livrables/migrations/0.1.0-0.2.0.sh"
printf '#!/usr/bin/env bash\nexit 0\n' > "$V/$INST/RES-001-outil/livrables/migrations/0.2.0-0.1.0.sh"
git_ "$V" add -A >/dev/null; git_ "$V" commit -q -m 'outil 0.2.0'

rc_dans 'a la derniere version, C5 passe' 0 "$V" out check
dit 'et clia le dit' '^C5  ok  0\.2\.0 est la dernière'

# Revenir en arrière sans commiter : la définition dit 0.1.0, l'historique
# offre 0.2.0.
sed -i 's/^version: 0.2.0$/version: 0.1.0/' "$V/$INST/RES-001-outil/livrables/outil.yaml"
rc_dans 'en retard, C5 signale sans bloquer' 0 "$V" out check
dit 'et clia dit ce qui est disponible' '^C5  --  0\.1\.0, alors que 0\.2\.0'
dit 'la ressource reste conforme' 'conforme, avec'

SORTIE=$( ( cd "$V" && CLIA_POLICY_ROLLING_RESSOURCE=true "$CLIA" out check ) 2>&1 )
REEL=$?
vrai 'avec la politique rolling, le meme ecart bloque' test "$REEL" -ne 0
dit 'et clia le dit bloquant' '^C5  !!  0\.1\.0, alors que 0\.2\.0'

SORTIE=$( ( cd "$V" && CLIA_POLICY_ROLLING_RESSOURCE=false "$CLIA" out check ) 2>&1 )
dit 'a false, il redevient un signalement' '^C5  --  0\.1\.0, alors que'

# ==========================================================================
titre 'Une ressource installee, non ecrite ici'
# ==========================================================================

I=$(depot installee)
rm -rf "${I:?}/$INST"
git_ "$I" add -A >/dev/null; git_ "$I" commit -q -m 'plus que la copie installee'

rc_dans 'check repond sur une ressource seulement installee' 0 "$I" out check
dit 'et dit d ou elle vient' '^état       installée'
dit 'C1 ne juge que la copie' '^C1  ok  la copie installée'
dit 'C3 ne s applique pas' "^C3  ok  ce dépôt n'écrit pas"
dit 'et C5 n a rien a quoi comparer' '^C5  --  aucune version disponible'

# ==========================================================================
titre 'Ce que check refuse'
# ==========================================================================

S=$(depot sans-definition)
rm -f "$S/$INST/RES-001-outil/livrables/outil.yaml" "$S/$LIVREE/outil/outil.yaml"
rc_dans 'une ressource sans definition est refusee' 1 "$S" out check
dit 'et clia dit ce qui manque' 'ne porte pas de définition'

# Le verdict du dépôt réel n'est pas ce qui est mesuré ici — il dépend de
# l'état de ses ressources, qui bouge. Ce qui est mesuré, c'est que le
# constat n'écrit rien.
SORTIE=$("$CLIA" res check 2>&1) || true
ok 'check répond sur le dépôt réel'
vrai 'et il n y ecrit rien' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
