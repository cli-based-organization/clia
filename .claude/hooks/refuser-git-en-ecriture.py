#!/usr/bin/env python3
"""Garde PreToolUse de CONSTITUTION.md C2.

C2 : « Un agent IA n'execute aucune operation git qui ecrit : commit, add,
push, rebase, reset, tag. clia git save est reserve a l'humain. »

Pourquoi un hook, et non une regle deny
---------------------------------------

Une regle deny "Bash(git commit:*)" ne compare que le debut de la ligne : la
forme "git -C . commit" passe a travers. Mesure le 2026-08-12 en depot
jetable, un commit a bien ete cree malgre le deny et malgre
--permission-mode bypassPermissions.

La seule regle deny qui tienne est "Bash(git:*)", qui interdit aussi status,
log et diff. Et deny l'emporte sur allow : la lecture ne peut pas etre
rouverte ensuite.

Pourquoi un parseur, et non une expression reguliere
----------------------------------------------------

Une premiere version employait une expression reguliere. Elle laissait passer
"git -C . commit" : le motif ne prevoyait pas les options globales dont la
valeur est un argument separe. Constate sur un banc de vingt-trois cas, deux
echecs.

La sous-commande git n'est pas le deuxieme mot de la ligne : c'est le premier
mot qui n'est ni une option globale, ni la valeur d'une option globale. Le
determiner demande de parcourir les jetons, pas de comparer un prefixe.

Ce que la garde ne garantit pas
--------------------------------

Un script tiers, un alias, ou un appel indirect depuis python peuvent
atteindre git sans que la ligne de commande le montre. La garde rend la
transgression explicite ; elle ne la rend pas impossible.

C'est la meme portee que clia_acteur_est_agent, qui le declare dans son
propre commentaire, et que CONSTITUTION.md declare dans sa section « Ce que
cette constitution ne garantit pas ».

Sortie : code 0 laisse passer, code 2 refuse et renvoie stderr au modele.
"""

import json
import os
import re
import shlex
import sys

# Les six verbes que C2 nomme.
INTERDITS = {"commit", "add", "push", "rebase", "reset", "tag"}

# Options globales de git dont la valeur est un argument separe. Sans cette
# liste, "git -C . commit" fait prendre "." pour la sous-commande.
AVEC_VALEUR = {
    "-C", "-c", "--git-dir", "--work-tree", "--namespace",
    "--exec-path", "--config-env", "--super-prefix",
}

# Ce qui peut preceder git sur la ligne sans le masquer.
PREFIXES = {"env", "sudo", "command", "nice", "time", "xargs", "nohup", "exec"}

# Ce qui separe deux commandes sur une meme ligne.
SEPARATEURS = {";", "&&", "||", "|", "&", "(", ")", "{", "}", "<", ">", ">>"}


def sous_commande(jetons):
    """Le premier jeton qui n'est ni une option globale ni sa valeur."""
    i = 0
    while i < len(jetons):
        jeton = jetons[i]
        if jeton in AVEC_VALEUR:
            i += 2
            continue
        if jeton.startswith("-"):
            i += 1
            continue
        return jeton
    return None


def est_operateur(jeton):
    """Un jeton fait uniquement de ponctuation shell est un operateur.

    Enumerer les operateurs un par un laissait passer les formes composees :
    << , <<< , 2> , &> . Les reconnaitre par leur composition les couvre
    toutes.
    """
    return bool(jeton) and (jeton in SEPARATEURS
                            or all(c in "();<>|&;" for c in jeton))


def segments(jetons):
    """Decoupe la liste de jetons aux separateurs shell."""
    courant = []
    for jeton in jetons:
        if est_operateur(jeton):
            if courant:
                yield courant
            courant = []
        else:
            courant.append(jeton)
    if courant:
        yield courant


def sauter_prefixes(jetons):
    """Retire env, sudo et compagnie, avec leurs options et affectations."""
    while jetons:
        nom = jetons[0].rsplit("/", 1)[-1]
        if nom not in PREFIXES:
            break
        jetons = jetons[1:]
        while jetons and (jetons[0].startswith("-")
                          or ("=" in jetons[0] and not jetons[0].startswith("/"))):
            jetons = jetons[1:]
    return jetons


def examiner(jetons):
    """Retourne le motif de refus d'un segment, ou None."""
    jetons = sauter_prefixes(jetons)
    if not jetons:
        return None

    nom = jetons[0].rsplit("/", 1)[-1]

    if nom == "git":
        verbe = sous_commande(jetons[1:])
        if verbe in INTERDITS:
            return "git " + verbe

    if nom == "clia":
        reste = [j for j in jetons[1:] if not j.startswith("-")]
        if len(reste) >= 2 and reste[0] in ("git", "g") and reste[1] == "save":
            return "clia git save"

    return None


# Ouverture de document en place : << MARQUEUR, <<-MARQUEUR, <<'MARQUEUR'.
# Le <<< d'une chaine en place ne correspond pas : le troisieme chevron n'est
# ni un guillemet ni une lettre.
HEREDOC = re.compile(r"<<-?\s*(['\"]?)([A-Za-z_][A-Za-z0-9_]*)\1")


def retirer_documents_en_place(commande):
    """Retire le corps des documents en place (heredocs).

    Le corps d'un heredoc est du texte, pas une commande. Sans ce retrait,
    ecrire une documentation qui PARLE de git est refuse comme si elle en
    FAISAIT : constate le 2026-08-12 en conditions reelles, la garde a bloque
    l'ecriture de son propre journal d'analyse, dont un tableau citait
    "git add".

    C'est le faux positif le plus couteux possible pour ce depot, ou la
    plupart des documents sont ecrits par cat > fichier <<'EOF'.
    """
    lignes = commande.split("\n")
    sortie = []
    i = 0
    while i < len(lignes):
        ligne = lignes[i]
        marqueurs = [m.group(2) for m in HEREDOC.finditer(ligne)]
        # L'operateur lui-meme est retire avec son corps : sans cela, le
        # marqueur reste colle a la commande suivante et la masque.
        sortie.append(HEREDOC.sub(" ", ligne))
        i += 1
        for marqueur in marqueurs:
            while i < len(lignes) and lignes[i].strip() != marqueur:
                i += 1
            if i < len(lignes):
                i += 1  # la ligne du marqueur de fin
    return "\n".join(sortie)


def aplatir(commande):
    """Une commande par ligne devient une commande par point-virgule.

    Le lexer avale le saut de ligne comme une espace : sur deux commandes
    ecrites sur deux lignes, la seconde se retrouve dans le segment de la
    premiere et passe inapercue. Constate le 2026-08-12.

    Les continuations par barre oblique inverse sont recollees d'abord :
    elles prolongent une commande, elles n'en ouvrent pas une autre.
    """
    texte = re.sub(r"\\\n", " ", commande)
    return " ; ".join(texte.split("\n"))


def decouper(commande):
    """Jetons de la ligne, operateurs shell compris.

    shlex.split ne connait pas les operateurs : sur "echo hop; git add ."
    il produit le jeton "hop;" et le segment git suivant passe inapercu.
    Constate le 2026-08-12, un cas sur trente-cinq.

    punctuation_chars fait de ; && || | ( ) < > des jetons a part entiere.
    """
    lexer = shlex.shlex(aplatir(retirer_documents_en_place(commande)),
                        posix=True, punctuation_chars=True)
    lexer.whitespace_split = True
    return list(lexer)


def motif_de_refus(commande):
    try:
        # Les guillemets sont retires : "git commit" devient un seul jeton et
        # ne sera donc jamais pris pour une commande. Un grep sur cette
        # chaine reste permis.
        jetons = decouper(commande)
    except ValueError:
        # Guillemets non fermes : la ligne n'est pas analysable. Repli
        # conservateur sur une recherche de mots, quitte a refuser large.
        texte = retirer_documents_en_place(commande)
        mots = texte.replace(";", " ").replace("&", " ").replace("|", " ").split()
        if "git" in mots and any(v in mots for v in INTERDITS):
            return "git (ligne non analysable)"
        return None

    for segment in segments(jetons):
        motif = examiner(segment)
        if motif:
            return motif
    return None


REFUS_CLIA = """Refuse par CONSTITUTION.md C2 : clia git save est reserve a l'humain.

Preparez le message de commit dans le journal de la tache
(TSK-07-commit-message), et laissez l'humain lancer la commande.
"""

REFUS_GIT = """Refuse par CONSTITUTION.md C2 : un agent IA n'execute aucune operation
git qui ecrit. Commande refusee : {motif}

Ce qui reste permis : git status, log, diff, show, blame, et toute lecture.

Ce qui appartient a l'humain : commiter. Preparez le message de commit dans
TSK-07-commit-message, et laissez l'humain lancer clia git save.
"""


def main():
    # CLIA_ACTOR=human leve la garde : c'est l'humain qui agit a travers
    # l'outil. Le poser depuis un agent est une transgression de C2, non un
    # contournement prevu. Le meme choix que clia_acteur_est_agent.
    if os.environ.get("CLIA_ACTOR") == "human":
        return 0

    try:
        entree = json.load(sys.stdin)
    except Exception:
        # Une garde qui plante ne doit pas bloquer le travail : elle laisse
        # passer et reste silencieuse. Le refus est un acte delibere, pas un
        # effet de bord d'une panne.
        return 0

    commande = (entree.get("tool_input") or {}).get("command") or ""
    if not commande.strip():
        return 0

    motif = motif_de_refus(commande)
    if not motif:
        return 0

    if motif == "clia git save":
        sys.stderr.write(REFUS_CLIA)
    else:
        sys.stderr.write(REFUS_GIT.format(motif=motif))
    return 2


if __name__ == "__main__":
    sys.exit(main())
