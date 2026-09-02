# shellcheck shell=bash
# _scripts/lib/fourniture.sh — ce qu'une ressource apporte au dépôt.
#
# Implémente SES-001 tâche 15.
#
# Trois choses, et l'énoncé les nomme :
#
#   fonctionnalité  un extrait ajouté au harnais IA. Elle est donc toujours
#                   dans le contexte de l'agent.
#   skill           une procédure déposée sous .claude/, plus la directive
#                   qui dit dans le harnais quand l'employer. Elle n'entre
#                   dans le contexte qu'à l'invocation.
#   script          un verbe de la commande de la ressource — le CMD de
#                   « clia <ressource> CMD … ».
#
# Où elles vivent
# ---------------
#
#   <zone livrée>/<nom>/features/<f>.md      frontmatter, puis le corps
#   <zone livrée>/<nom>/skills/<s>/SKILL.md  ou skills/<s>.md
#   <zone livrée>/<nom>/_scripts/<cmd>.sh    ses « # Signature: » font les verbes
#
# La zone livrée est celle que $CLIA_ZONE_RESSOURCE_LIVREE désigne,
# .clia/ressources par défaut. Une ressource qu'un dépôt écrit sans l'avoir
# installée ne fournit rien : elle n'est pas là où le CLI regarde.
#
# Aucun catalogue central : une fourniture vit sous la ressource qui la donne,
# et clia la trouve. Ajouter une fonctionnalité se fait en déposant un
# fichier, comme pour tout le reste ici.
#
# Ce qui est en lecture, et ce qui est déclaré
# --------------------------------------------
#
# Les verbes ne sont déclarés nulle part en tant que tels : ils se lisent dans
# les signatures que le fichier de commande porte déjà. Une ressource n'a donc
# rien à écrire pour que ses scripts soient listés, et la liste ne peut pas
# mentir sur ce que la commande accepte.
#
# Seule la désactivation d'un script est déclarée, dans la carte du dépôt :
# un verbe est actif par défaut, et il n'y a rien à inscrire pour l'état
# ordinaire. Les fonctionnalités et les skills, eux, ne déclarent rien du
# tout : leur état se lit dans le harnais et sous .claude/.

# --------------------------------------------------------------------------
# Les ressources visibles
# --------------------------------------------------------------------------
#
# Les mêmes que celles dont le point d'entrée tire les commandes : celles du
# dépôt source de clia, puis celles du dépôt de travail. Le premier trouvé
# l'emporte, comme pour les commandes.

# _clia_f_ressources <dépôt> — « prefixe<SEP>nom<SEP>racine », triées par nom.
_clia_f_ressources() {
  local depot="$1" racine nom prefixe vus=''
  for racine in "${CLIA_SOURCE_DIR:-}" "$depot"; do
    [[ -n "$racine" && -d "$racine/$(_clia_zone_livree)" ]] || continue
    while IFS=$'\t' read -r nom prefixe _; do
      [[ -n "$nom" ]] || continue
      [[ " $vus " == *" $nom "* ]] && continue
      vus="$vus $nom"
      printf '%s%s%s%s%s\n' "$prefixe" "$_CLIA_SEP" "$nom" "$_CLIA_SEP" "$racine"
    done < <(_clia_ressources_de "$racine")
  done | sort -t"$_CLIA_SEP" -k2,2
  return 0
}

# Le harnais IA d'un dépôt : le fichier que l'agent lit, à sa racine.
#
# C'est celui que « clia init » pose, et non celui que « clia hrn gen »
# produit sous .dev/harnais-ia/. Les deux ne sont pas encore raccordés — c'est
# une tâche à venir — et clia pose ce qu'il pose là où l'agent le lira.
_clia_f_harnais() { printf '%s/CLAUDE.md\n' "$1"; }

# _clia_f_exiger_harnais <dépôt> — 0 s'il est là, sinon un refus nommé.
_clia_f_exiger_harnais() {
  local h
  h=$(_clia_f_harnais "$1")
  [[ -f "$h" ]] && return 0
  _clia_msg "ce dépôt ne porte pas de harnais IA : CLAUDE.md"
  _clia_detail "une fonctionnalité et un skill y vivent ; clia init le pose"
  return 1
}

# --------------------------------------------------------------------------
# Les fonctionnalités
# --------------------------------------------------------------------------

# « prefixe<SEP>ressource<SEP>nom<SEP>fichier<SEP>description »
_clia_f_features() {
  local depot="$1" prefixe nom racine f n desc
  while IFS="$_CLIA_SEP" read -r prefixe nom racine; do
    [[ -n "$nom" ]] || continue
    for f in "$racine/$(_clia_zone_livree)/$nom/features"/*.md; do
      [[ -f "$f" ]] || continue
      n=$(basename "$f" .md)
      desc=$(_clia_t_champ "$f" description 2>/dev/null || printf '')
      printf '%s%s%s%s%s%s%s%s%s\n' \
        "$prefixe" "$_CLIA_SEP" "$nom" "$_CLIA_SEP" "$n" "$_CLIA_SEP" \
        "$f" "$_CLIA_SEP" "$desc"
    done
  done < <(_clia_f_ressources "$depot")
  return 0
}

# --------------------------------------------------------------------------
# Les skills
# --------------------------------------------------------------------------
#
# Deux formes sont admises : un répertoire portant SKILL.md — la forme que
# Claude Code emploie, et qui laisse le skill porter ses propres fichiers — ou
# un fichier seul. La seconde est commode pour un skill qui tient en une page ;
# l'activation les ramène toutes deux à la première.

# « prefixe<SEP>ressource<SEP>nom<SEP>fichier<SEP>description »
_clia_f_skills() {
  local depot="$1" prefixe nom racine s n fichier desc
  while IFS="$_CLIA_SEP" read -r prefixe nom racine; do
    [[ -n "$nom" ]] || continue
    for s in "$racine/$(_clia_zone_livree)/$nom/skills"/*; do
      [[ -e "$s" ]] || continue
      if [[ -d "$s" ]]; then
        n=$(basename "$s")
        fichier="$s/SKILL.md"
        [[ -f "$fichier" ]] || continue
      else
        [[ "$s" == *.md ]] || continue
        n=$(basename "$s" .md)
        fichier="$s"
      fi
      desc=$(_clia_t_champ "$fichier" description 2>/dev/null || printf '')
      printf '%s%s%s%s%s%s%s%s%s\n' \
        "$prefixe" "$_CLIA_SEP" "$nom" "$_CLIA_SEP" "$n" "$_CLIA_SEP" \
        "$fichier" "$_CLIA_SEP" "$desc"
    done
  done < <(_clia_f_ressources "$depot")
  return 0
}

# --------------------------------------------------------------------------
# Les scripts
# --------------------------------------------------------------------------
#
# Un verbe est le deuxième mot d'une signature. Une signature qui n'en porte
# pas — « version », « version --true » — décrit l'appel nu de la commande,
# et n'ajoute aucun verbe. Un mot commençant par un tiret ou par un crochet
# est une option ou un argument, non un verbe.

# « prefixe<SEP>ressource<SEP>verbe<SEP>signature »
_clia_f_scripts() {
  local depot="$1" prefixe nom racine commande fichier sig verbe vus
  while IFS="$_CLIA_SEP" read -r prefixe nom racine; do
    [[ -n "$nom" ]] || continue
    commande=$(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]')
    fichier="$racine/$(_clia_zone_livree)/$nom/_scripts/$commande.sh"
    [[ -f "$fichier" ]] || continue
    vus=''
    while IFS= read -r sig; do
      [[ -n "$sig" ]] || continue
      verbe=$(printf '%s' "$sig" | awk '{print $2}')
      [[ -n "$verbe" ]] || continue
      [[ "$verbe" == -* || "$verbe" == \[* ]] && continue
      [[ " $vus " == *" $verbe "* ]] && continue
      vus="$vus $verbe"
      printf '%s%s%s%s%s%s%s\n' \
        "$prefixe" "$_CLIA_SEP" "$nom" "$_CLIA_SEP" "$verbe" "$_CLIA_SEP" "$sig"
    done < <(_clia_signatures_de "$fichier")
  done < <(_clia_f_ressources "$depot")
  return 0
}

# --------------------------------------------------------------------------
# Les scripts désactivés
# --------------------------------------------------------------------------
#
# La carte les déclare, un par entrée :
#
#   desactives:
#     - script: RES/release
#
# Rien n'est inscrit pour un verbe actif : l'état ordinaire d'un verbe est de
# répondre, et un inventaire de tout ce qui va bien serait un inventaire que
# personne ne relit.

# _clia_f_desactives <dépôt> — « PREFIXE/verbe », un par ligne.
_clia_f_desactives() {
  local carte id
  carte=$(_clia_carte "$1") || return 0
  while IFS="$_CLIA_SEP" read -r id; do
    [[ -n "$id" ]] && printf '%s\n' "$id"
  done < <(_clia_bloc_yaml "$carte" desactives script)
  return 0
}

# _clia_f_est_desactive <dépôt> <PREFIXE> <verbe>
_clia_f_est_desactive() {
  local depot="$1" cible="$2/$3" id
  while IFS= read -r id; do
    [[ "$id" == "$cible" ]] && return 0
  done < <(_clia_f_desactives "$depot")
  return 1
}

# --------------------------------------------------------------------------
# Désigner une fourniture
# --------------------------------------------------------------------------
#
# Par son nom, et par le préfixe de sa ressource quand deux ressources en
# offrent une du même nom. clia ne choisit pas à la place de l'appelant :
# une désignation ambiguë est refusée, et les candidates sont nommées.

# _clia_f_resoudre <nom> [prefixe] — la ligne unique, lue sur l'entrée
# standard parmi les lignes candidates.
#
# Trois issues, et l'appelant les distingue : 0, la ligne est rendue ; 3, la
# désignation est ambiguë et clia l'a déjà dit ; 1, rien ne correspond — et
# c'est à l'appelant de le dire, parce que lui seul sait de quoi il parlait.
_clia_f_resoudre() {
  local nom="$1" prefixe="${2:-}" ligne p n retenue='' nb=0
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    IFS="$_CLIA_SEP" read -r p _ n _ <<<"$ligne"
    [[ "$n" == "$nom" ]] || continue
    [[ -n "$prefixe" && "$p" != "$prefixe" ]] && continue
    retenue="$ligne"; nb=$((nb + 1))
  done

  if (( nb == 1 )); then printf '%s\n' "$retenue"; return 0; fi
  if (( nb > 1 )); then
    _clia_msg "désignation ambiguë : $nom"
    _clia_detail "plus d'une ressource en offre une de ce nom"
    _clia_detail "nommez la ressource : … $nom PREFIXE"
    return 3
  fi
  return 1
}
