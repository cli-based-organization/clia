#!/usr/bin/env bash
# git.sh - Suivi de l'historique des ressources.
#
# Decisions appliquees :
#   ADR-008 D6  l'identifiant intrinseque est fourni par git
#   ANL-005 C5  tout chemin porte un identifiant de contenu, blob ou tree
#   ANL-005 C6  le diff entre deux versions s'obtient de deux identifiants
#   ANL-005 T1  un commit ne renomme pas et ne reecrit pas la meme ressource
#   ANL-005 T3  l'historique de la branche principale n'est jamais reecrit
#   ANL-005 T4  tout commit est signe
#
# Le cas ou une ressource est un depot git n'est pas couvert : la tache 19
# l'exclut explicitement.

# --------------------------------------------------------------------------
# Garde commune
# --------------------------------------------------------------------------

clia_git_guard() {
  [[ -n "${CLIA_REPO_ROOT_RESOLVED:-}" ]] || {
    clia_warn "aucun depot clia depuis $(pwd -P)"
    clia_hint "clia --context affiche le depot resolu"
    return 2
  }
  git -C "$CLIA_REPO_ROOT_RESOLVED" rev-parse --git-dir >/dev/null 2>&1 || {
    clia_warn "le depot n'est pas suivi par git : $CLIA_REPO_ROOT_RESOLVED"
    clia_hint "git init, puis un premier commit"
    return 2
  }
}

clia_git() { git -C "$CLIA_REPO_ROOT_RESOLVED" "$@"; }

# --------------------------------------------------------------------------
# C2 : l'agent ne commite pas
# --------------------------------------------------------------------------
#
# CONSTITUTION.md C2 reserve l'ecriture git a l'humain. Seuls les humains
# decident, et commiter est l'acte qui arrete une version.
#
# La detection repose sur les marqueurs que les environnements d'agent posent
# eux-memes. Elle n'est pas infranchissable : un agent qui dispose d'un shell
# appelle git directement. Elle rend la transgression explicite, ce qui est sa
# portee reelle et ce que la constitution declare.
#
# CLIA_ACTOR=human leve la garde. Le poser depuis un agent est une violation
# de C2, non un contournement prevu.

clia_git_acteur_est_agent() {
  [[ "${CLIA_ACTOR:-}" == "human" ]] && return 1
  [[ "${CLIA_ACTOR:-}" == "agent" ]] && return 0
  [[ -n "${CLAUDECODE:-}" ]] && return 0
  [[ -n "${CLAUDE_CODE_ENTRYPOINT:-}" ]] && return 0
  [[ -n "${AIDER_MODEL:-}" ]] && return 0
  return 1
}

# --------------------------------------------------------------------------
# T1 : un commit ne renomme pas et ne reecrit pas la meme ressource
# --------------------------------------------------------------------------
#
# Le geste coupe l'historique du fichier definitivement : ANL-005 C3 le mesure,
# quatre versions deviennent une, et aucun seuil de similarite ne les recupere.
#
# Git ne signale pas ce cas comme un renommage. Quand la reecriture depasse le
# seuil de similarite, il affiche une suppression et une creation, et le lien
# est perdu sans que rien ne l'annonce. Constate le 2026-08-10 en eprouvant
# cette commande : une premiere version du controle cherchait un statut R et
# ne trouvait rien.
#
# La detection porte donc sur l'alias : une ressource supprimee et une
# ressource creee qui portent le meme <PREFIX>-<SEQ> sont la meme ressource,
# renommee et reecrite. Affiche un alias par ligne.

clia_git_t1_suspects() {
  local statut
  statut=$(clia_git status --porcelain --untracked-files=all)

  local supprimes crees
  supprimes=$(printf '%s\n' "$statut" | awk '$1 ~ /D/ {print $NF}' \
              | grep -oE '[A-Za-z]{2,4}-[0-9]{3}' | sort -u || true)
  crees=$(printf '%s\n' "$statut" | awk '$1 ~ /A|\?\?/ {print $NF}' \
          | grep -oE '[A-Za-z]{2,4}-[0-9]{3}' | sort -u || true)

  [[ -n "$supprimes" && -n "$crees" ]] || return 0
  comm -12 <(printf '%s\n' "$supprimes") <(printf '%s\n' "$crees")
}

# --------------------------------------------------------------------------
# check : l'etat du depot est-il conforme
# --------------------------------------------------------------------------
#
# Deux etats, et ils ne verifient pas la meme chose.
#
#   clean  rien a commiter. L'etat attendu au demarrage d'une tache.
#   done   pret a commiter. L'etat attendu a la fin d'une tache.
#
# Chaque controle affiche son verdict. Le code de retour vaut 0 si tous
# passent, 1 sinon : la sortie sert un humain qui lit et un script qui teste.

clia_git_check_ligne() {
  # $1 verdict (ok|ko|note), $2 libelle, $3 detail
  printf '%-5s %-38s %s\n' "$1" "$2" "${3:-}"
}

clia_git_check_clean() {
  local echecs=0 n

  n=$(clia_git status --porcelain | grep -c '' || true)
  if (( n == 0 )); then
    clia_git_check_ligne ok "arbre de travail propre" ""
  else
    clia_git_check_ligne KO "arbre de travail propre" "$n fichier(s) en attente"
    echecs=$((echecs + 1))
  fi

  n=$(clia_git status --porcelain --untracked-files=all | grep -c '^??' || true)
  if (( n == 0 )); then
    clia_git_check_ligne ok "aucun fichier non suivi" ""
  else
    clia_git_check_ligne KO "aucun fichier non suivi" "$n fichier(s)"
    echecs=$((echecs + 1))
  fi

  return $(( echecs > 0 ))
}

clia_git_check_done() {
  local echecs=0 n

  # 1. Il y a quelque chose a commiter. Une tache qui ne produit rien n'est
  #    pas une tache terminee.
  n=$(clia_git status --porcelain --untracked-files=all | grep -c '' || true)
  if (( n > 0 )); then
    clia_git_check_ligne ok "des modifications a commiter" "$n fichier(s)"
  else
    clia_git_check_ligne KO "des modifications a commiter" "aucune"
    echecs=$((echecs + 1))
  fi

  # 2. Un message de commit est prepare. C'est le livrable de journalisation
  #    que CLAUDE.md rend obligatoire.
  local msg
  if msg=$(clia_git_message_file 2>/dev/null); then
    clia_git_check_ligne ok "message de commit prepare" "${msg#$CLIA_REPO_ROOT_RESOLVED/}"
  else
    clia_git_check_ligne KO "message de commit prepare" "aucun commit-message-task-*"
    echecs=$((echecs + 1))
  fi

  # 3. T4 : tout commit est signe. Verifie la configuration, non les commits
  #    passes : ceux-la ne se signent plus.
  if [[ "$(clia_git config --get commit.gpgsign 2>/dev/null || true)" == "true" ]]; then
    clia_git_check_ligne ok "signature des commits activee" "T4"
  else
    clia_git_check_ligne KO "signature des commits activee" "T4, commit.gpgsign absent"
    echecs=$((echecs + 1))
  fi

  # 4. T1 : aucun renommage accompagne d'une reecriture de la meme ressource
  #    dans ce qui va etre commite. Le geste coupe l'historique definitivement.
  local suspects
  suspects=$(clia_git_t1_suspects)
  if [[ -z "$suspects" ]]; then
    clia_git_check_ligne ok "aucun renommage avec reecriture" "T1"
  else
    clia_git_check_ligne KO "aucun renommage avec reecriture" "T1, $(printf '%s' "$suspects" | tr '\n' ' ')"
    clia_hint "separer en deux commits : le renommage, puis la reecriture"
    echecs=$((echecs + 1))
  fi

  # 5. T3 : l'historique local n'a pas diverge de la reference distante.
  #    Sans distante, le controle est sans objet et il le dit.
  local amont
  if amont=$(clia_git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null); then
    local derriere
    derriere=$(clia_git rev-list --count "@{upstream}..HEAD" 2>/dev/null || printf '0')
    local devant
    devant=$(clia_git rev-list --count "HEAD..@{upstream}" 2>/dev/null || printf '0')
    if (( devant == 0 )); then
      clia_git_check_ligne ok "historique non reecrit" "T3, $derriere commit(s) d'avance sur $amont"
    else
      clia_git_check_ligne KO "historique non reecrit" "T3, $amont a $devant commit(s) que HEAD n'a pas"
      echecs=$((echecs + 1))
    fi
  else
    clia_git_check_ligne note "historique non reecrit" "T3, aucune reference distante"
  fi

  return $(( echecs > 0 ))
}

clia_git_check() {
  if clia_is_help "${1:-}"; then clia_git_usage_check; return 0; fi
  local etat="${1:-}"
  case "$etat" in
    clean) clia_git_check_clean ;;
    done)  clia_git_check_done ;;
    '')
      clia_warn "etat manquant"
      clia_hint "clia git check clean|done"
      return 2 ;;
    *)
      clia_warn "etat inconnu : $etat"
      clia_hint "etats connus : clean, done"
      return 2 ;;
  esac
}

# --------------------------------------------------------------------------
# save : commiter a partir du message prepare
# --------------------------------------------------------------------------
#
# Le message n'est pas redige par clia : il est lu dans le journal de la
# tache, ce que CLAUDE.md rend obligatoire. clia garantit, l'agent redige.
#
# Deux formats sont acceptes, .yaml comme .md : le depot produit du yaml,
# la demande de la tache 19 nomme du md.

clia_git_message_file() {
  local dev
  dev=$(clia_dev_dir) || return 1
  local trouve
  # Deux formats de nommage coexistent depuis la tache 25 :
  #   TSK-07-commit-message_<horodatage>_<slug>.yaml   MET-003, en vigueur
  #   commit-message-task-<SEQ>.yaml                   forme anterieure
  # Les deux sont acceptes : NON-028 Q1 laisse la migration ouverte.
  trouve=$(find "$dev/logs" -type f \
             \( -name 'TSK-*-commit-message_*.yaml' -o -name 'TSK-*-commit-message_*.md' \
                -o -name 'commit-message-task-*.yaml' -o -name 'commit-message-task-*.md' \
                -o -name 'commit-message.yaml' -o -name 'commit-message.md' \) \
             -printf '%T@\t%p\n' 2>/dev/null | sort -rn | head -1 | cut -f2)
  [[ -n "$trouve" ]] || return 1
  printf '%s\n' "$trouve"
}

# Rend un message de commit a partir du fichier prepare.
# Le format yaml du depot porte type, scope, sujet, corps, note_pour_l_humain.
# Tout autre format est repris tel quel : clia n'impose pas de structure.
clia_git_render_message() {
  local f="$1"
  case "$f" in
    *.yaml|*.yml)
      python3 - "$f" <<'PY'
import sys, yaml
d = yaml.safe_load(open(sys.argv[1], encoding="utf-8")) or {}
if not isinstance(d, dict) or "sujet" not in d:
    sys.stdout.write(open(sys.argv[1], encoding="utf-8").read()); raise SystemExit
t, s = d.get("type", ""), d.get("scope", "")
entete = f"{t}({s}): {d['sujet']}" if t and s else (f"{t}: {d['sujet']}" if t else d["sujet"])
parts = [entete]
if d.get("corps"): parts.append(d["corps"].rstrip())
if d.get("note_pour_l_humain"): parts.append("Note pour l'humain :\n" + d["note_pour_l_humain"].rstrip())
print("\n\n".join(parts))
PY
      ;;
    *) cat "$f" ;;
  esac
}

clia_git_save() {
  if clia_is_help "${1:-}"; then clia_git_usage_save; return 0; fi

  # C2 avant tout le reste : ne rien preparer que l'appelant n'a pas le droit
  # de faire aboutir.
  if clia_git_acteur_est_agent; then
    clia_warn "C2 : commiter appartient a l'humain"
    clia_hint "l'agent prepare le message dans le journal, l'humain lance clia git save"
    clia_hint "voir CONSTITUTION.md, regle C2"
    return 3
  fi

  local msg
  msg=$(clia_git_message_file) || {
    clia_warn "aucun message de commit prepare"
    clia_hint "ecrire .dev/logs/<session>/commit-message-task-<SEQ>.yaml"
    return 1
  }

  local n
  n=$(clia_git status --porcelain --untracked-files=all | grep -c '' || true)
  (( n > 0 )) || {
    clia_warn "rien a commiter"
    return 1
  }

  local rendu
  rendu=$(clia_git_render_message "$msg") || {
    clia_warn "message illisible : ${msg#$CLIA_REPO_ROOT_RESOLVED/}"
    return 1
  }
  [[ -n "${rendu//[[:space:]]/}" ]] || {
    clia_warn "message vide : ${msg#$CLIA_REPO_ROOT_RESOLVED/}"
    return 1
  }

  # T1 est verifie avant d'ecrire, pas apres : un historique coupe ne se
  # repare pas.
  local suspects
  suspects=$(clia_git_t1_suspects)
  [[ -z "$suspects" ]] || {
    clia_warn "T1 : renommage et reecriture de la meme ressource"
    printf '%s\n' "$suspects" | sed 's/^/      /' >&2
    clia_hint "separer en deux commits, sinon l'historique de ces ressources est coupe"
    return 1
  }

  clia_git add -A
  clia_git commit --quiet --file - <<< "$rendu" || return 1

  local sha
  sha=$(clia_git rev-parse --short HEAD)
  printf '%s\n' "$sha"
  clia_warn "commit $sha, $n fichier(s), message de ${msg#$CLIA_REPO_ROOT_RESOLVED/}"
  if [[ "$(clia_git log -1 --format='%G?')" == "N" ]]; then
    clia_hint "commit non signe : T4 de ANL-005 n'est pas tenue"
  fi
}

# --------------------------------------------------------------------------
# log : l'historique d'une ressource
# --------------------------------------------------------------------------
#
# ANL-005 etablit que git log --follow ne suit qu'un fichier unique et reste
# sans effet sur un repertoire. La voie qui couvre les deux formes est
# l'identifiant de contenu : git rev-parse <commit>:<chemin>, blob pour un
# fichier, tree pour un repertoire.
#
# La colonne CONTENU est cet identifiant. Deux lignes qui le partagent
# designent la meme version : le contenu n'a pas change entre ces commits.

clia_git_log() {
  if clia_is_help "${1:-}"; then clia_git_usage_log; return 0; fi
  local wanted="${1:-}"
  [[ -n "$wanted" ]] || {
    clia_warn "ressource manquante"
    clia_hint "clia git log RES-001"
    return 2
  }

  local file
  file=$(clia_resource_find "$wanted") || {
    clia_warn "ressource introuvable : $wanted"
    return 1
  }

  # Une ressource composite est un repertoire : son historique est celui du
  # repertoire, non celui de son index.
  local cible="$file"
  case "$file" in
    */index.md) cible=$(dirname "$file") ;;
  esac
  local rel="${cible#$CLIA_REPO_ROOT_RESOLVED/}"

  {
    printf 'COMMIT\tDATE\tCONTENU\tSIG\tAUTEUR\tSUJET\n'
    local c sha
    while IFS= read -r c; do
      sha=$(clia_git rev-parse -q --verify "$c:$rel" 2>/dev/null) || continue
      clia_git log -1 --format="%h	%ad	${sha:0:12}	%G?	%an	%s" --date=short "$c"
    done < <(clia_git rev-list HEAD -- "$rel")
  } | column -t -s $'\t'

  local total
  total=$(clia_git rev-list --count HEAD -- "$rel")
  clia_warn "$rel : $total commit(s)"
  clia_hint "clia git diff $wanted <CONTENU-A> <CONTENU-B> compare deux versions"
}

# --------------------------------------------------------------------------
# diff : comparer deux versions par leur identifiant de contenu
# --------------------------------------------------------------------------
#
# ANL-005 C6 : le diff s'obtient de deux identifiants seuls, sans commit ni
# chemin. Le troisieme argument est donc facultatif.

clia_git_diff() {
  if clia_is_help "${1:-}"; then clia_git_usage_diff; return 0; fi
  local a b
  if [[ $# -ge 3 ]]; then a="$2"; b="$3"
  elif [[ $# -eq 2 ]]; then a="$1"; b="$2"
  else
    clia_warn "deux identifiants de contenu sont requis"
    clia_hint "clia git log RES-001 les affiche dans la colonne CONTENU"
    return 2
  fi
  clia_git diff "$a" "$b"
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

clia_git_usage() {
  cat <<'EOF'
Usage : clia git <verbe> [arguments]

Verbes :
  check clean              verifie que rien n'est en attente
  check done               verifie que la tache est prete a etre commitee
  save                     commite, avec le message prepare dans le journal
                           reserve a l'humain, CONSTITUTION.md C2
  log RESSOURCE            historique d'une ressource, par identifiant de contenu
  diff RESSOURCE A B       compare deux versions par leur identifiant de contenu

clia ne redige aucun message de commit : il lit celui que l'agent a prepare
dans .dev/logs/<session>/commit-message-task-<SEQ>.yaml

Aide detaillee d'un verbe :
  clia git check --help
  clia git save --help
  clia git log --help
  clia git diff --help
EOF
}

clia_git_usage_check() {
  cat <<'EOF'
Usage : clia git check clean|done

clean  rien a commiter, aucun fichier non suivi.
       L'etat attendu au demarrage d'une tache.

done   pret a commiter. Cinq controles :
         des modifications existent
         un message de commit est prepare
         la signature des commits est activee        (T4)
         aucun renommage avec reecriture en attente  (T1)
         l'historique local n'a pas diverge          (T3)

Les contraintes T1, T3 et T4 viennent de ANL-005. T1 est la seule dont la
violation coupe l'historique d'un fichier de facon definitive.

Sortie : une ligne par controle, ok ou KO. Code 0 si tous passent, 1 sinon.
EOF
}

clia_git_usage_save() {
  cat <<'EOF'
Usage : clia git save

Reserve a l'humain. CONSTITUTION.md C2 : l'agent ne commite pas. La commande
refuse de s'executer dans un environnement d'agent et retourne 3.

L'agent prepare le message dans le journal de sa tache ; l'humain lance la
commande.

Commite toutes les modifications avec le message prepare le plus recent,
cherche dans .dev/logs sous les noms :
  TSK-<NN>-commit-message_<horodatage>_<slug>.yaml   MET-003, en vigueur
  commit-message-task-<SEQ>.yaml                     forme anterieure
  commit-message.yaml

Un fichier yaml portant les cles type, scope, sujet, corps et
note_pour_l_humain est rendu au format conventionnel. Tout autre contenu est
repris tel quel.

Refuse de commiter si un renommage accompagne une reecriture de la meme
ressource : le geste coupe l'historique definitivement (T1 de ANL-005).

Sortie : l'identifiant court du commit sur stdout.
EOF
}

clia_git_usage_log() {
  cat <<'EOF'
Usage : clia git log RESSOURCE

Affiche l'historique d'une ressource, un commit par ligne.

La colonne CONTENU porte l'identifiant de contenu de la ressource a ce
commit : un blob pour un fichier, un tree pour un repertoire. Deux lignes
qui le partagent designent la meme version.

Cet identifiant est deterministe, independant du chemin et de l'histoire.
C'est pourquoi il fonctionne la ou git log --follow echoue, notamment sur un
repertoire, ou l'option est acceptee sans effet (ANL-005 C2).

La colonne SIG porte l'etat de signature du commit : N pour non signe.

Une ressource composite est designee par son alias ; son historique est celui
de son repertoire, non de son index.
EOF
}

clia_git_usage_diff() {
  cat <<'EOF'
Usage : clia git diff RESSOURCE CONTENU-A CONTENU-B
        clia git diff CONTENU-A CONTENU-B

Compare deux versions d'une ressource par leur identifiant de contenu, tel
que clia git log l'affiche dans la colonne CONTENU.

Le nom de la ressource est facultatif : deux identifiants de contenu
suffisent a produire un diff, sans commit ni chemin (ANL-005 C6).
EOF
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

clia_git_main() {
  local verb="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$verb" in
    ''|-h|--help|help) clia_git_usage; return 0 ;;
  esac
  clia_git_guard || return $?
  case "$verb" in
    check)      clia_git_check "$@" ;;
    save)       clia_git_save "$@" ;;
    log|hist)   clia_git_log "$@" ;;
    diff)       clia_git_diff "$@" ;;
    *)
      clia_warn "verbe inconnu : $verb"
      clia_git_usage >&2
      return 2 ;;
  esac
}
