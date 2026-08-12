#!/usr/bin/env bash
# test_refuser-git-en-ecriture.sh - Banc de la garde C2.
#
# Une garde sans test est une garde dont on ignore la portee. Celle-ci a
# laisse passer "git -C . commit" dans ses deux premieres versions : le banc
# existe pour que la troisieme ne regresse pas.
#
# Usage : ./.claude/hooks/test_refuser-git-en-ecriture.sh

set -uo pipefail

ICI=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)
GARDE="$ICI/refuser-git-en-ecriture.py"

pass=0
fail=0

# essai ATTENDU COMMANDE
essai() {
  local attendu="$1" cmd="$2" rc obtenu
  printf '{"tool_input":{"command":%s}}' "$(printf '%s' "$cmd" | jq -Rs .)" \
    | CLIA_ACTOR='' python3 "$GARDE" >/dev/null 2>&1
  rc=$?
  (( rc == 2 )) && obtenu=REFUSE || obtenu=PASSE
  if [[ "$obtenu" == "$attendu" ]]; then
    printf '  ok   %-8s %s\n' "$obtenu" "$cmd"
    pass=$((pass + 1))
  else
    printf '  KO   %-8s %s   (attendu %s)\n' "$obtenu" "$cmd" "$attendu"
    fail=$((fail + 1))
  fi
}

command -v jq >/dev/null || { printf 'jq requis\n' >&2; exit 1; }

printf '\nLes six verbes que C2 nomme\n'
essai REFUSE 'git commit -m "x"'
essai REFUSE 'git add .'
essai REFUSE 'git push origin main'
essai REFUSE 'git rebase -i HEAD~3'
essai REFUSE 'git reset --hard HEAD~1'
essai REFUSE 'git tag v1.0'

printf '\nLes formes qui contournaient une regle deny\n'
essai REFUSE 'git -C . commit -m essai'
essai REFUSE 'git -C /chemin/quelconque commit -m essai'
essai REFUSE 'git --git-dir=/x/.git commit -m essai'
essai REFUSE 'git --git-dir /x/.git commit -m essai'
essai REFUSE 'git -c user.name=x commit -m essai'
essai REFUSE 'git -C . -c a=b commit -m x'
essai REFUSE '/usr/bin/git commit -m x'
essai REFUSE 'env git commit -m x'
essai REFUSE 'sudo git push'

printf '\nLes commandes composees\n'
essai REFUSE 'cd /tmp && git commit -m x'
essai REFUSE 'echo hop; git add .'
essai REFUSE 'true || git push'
essai REFUSE 'ls | xargs git add'
essai REFUSE 'bash -c "x"; git commit -m y'

printf '\nclia git save\n'
essai REFUSE 'clia git save'
essai REFUSE 'clia g save'
essai REFUSE 'ls && clia git save'

printf '\nLa lecture reste permise\n'
essai PASSE 'git status --porcelain'
essai PASSE 'git log --oneline -5'
essai PASSE 'git -C . diff --stat'
essai PASSE 'git show HEAD'
essai PASSE 'git -C /x/y log --format=%aI'
essai PASSE 'git check-ignore -v .claude'
essai PASSE 'git ls-files .claude'
essai PASSE 'git log --diff-filter=A --format=%aI -- workspace/session.md'
essai PASSE 'git diff --stat | head'

printf '\nLes autres verbes de clia git\n'
essai PASSE 'clia git check clean'
essai PASSE 'clia git log'
essai PASSE 'clia git diff'
essai PASSE 'clia ses status'

printf '\nCe qui parle de git sans en faire\n'
essai PASSE 'grep -rn "git commit" .dev'
essai PASSE 'echo "git push" > note.txt'
essai PASSE 'bash tests/test_clia.sh'
essai PASSE 'find . -name "*.md" | head'

# Le corps d'un document en place est du texte, pas une commande. La garde a
# bloque l'ecriture de son propre journal le 2026-08-12 : un tableau y citait
# "git add". C'est le faux positif le plus couteux pour ce depot, ou la
# plupart des documents sont ecrits par cat > fichier <<'EOF'.
printf '\nUn document en place qui parle de git\n'
essai PASSE "$(printf 'cat > doc.md <<%s\nIl ne faut jamais faire git commit ni git add.\nEOF' "'EOF'")"
essai PASSE "$(printf 'cat > doc.md <<EOF\ngit push origin main est interdit\nEOF')"
essai PASSE "$(printf 'cat > a.md <<%s\ngit add .\nFIN\ncat > b.md <<%s\ngit reset --hard\nFIN' "'FIN'" "'FIN'")"

# Mais une vraie commande APRES le document en place reste vue.
essai REFUSE "$(printf 'cat > doc.md <<%s\ndu texte\nEOF\ngit commit -m x' "'EOF'")"

# Le saut de ligne separe deux commandes : le lexer l'avale comme une espace,
# et sans traitement la seconde commande se retrouvait dans le segment de la
# premiere. Constate le 2026-08-12.
printf '\nPlusieurs commandes sur plusieurs lignes\n'
essai REFUSE "$(printf 'cd /x\ngit add fichier.md')"
essai REFUSE "$(printf 'echo un\necho deux\ngit push')"
essai PASSE "$(printf 'cd /x\ngit status --porcelain\ngit log --oneline -1')"

# Une continuation prolonge une commande, elle n'en ouvre pas une autre.
essai PASSE "$(printf 'find . -name "*.md" \\\n  | head -3')"
essai REFUSE "$(printf 'git \\\n  commit -m x')"

printf '\nCLIA_ACTOR=human leve la garde\n'
printf '{"tool_input":{"command":"git commit -m x"}}' \
  | CLIA_ACTOR=human python3 "$GARDE" >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
  printf '  ok   PASSE    git commit, avec CLIA_ACTOR=human\n'
  pass=$((pass + 1))
else
  printf '  KO   REFUSE   git commit, avec CLIA_ACTOR=human\n'
  fail=$((fail + 1))
fi

printf '\nUne entree illisible laisse passer plutot que de bloquer\n'
printf 'ceci n est pas du json' | CLIA_ACTOR='' python3 "$GARDE" >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
  printf '  ok   PASSE    entree non JSON\n'
  pass=$((pass + 1))
else
  printf '  KO   REFUSE   entree non JSON\n'
  fail=$((fail + 1))
fi

printf '\nbilan : %d reussis, %d echoues\n' "$pass" "$fail"
(( fail == 0 ))
