# Initialisation de clia dans un repo

clia est un système d'information installable dans n'importe quel repo git

Le cli `clia` expose les automatismes déterministes, notamment l'initialisation d'un repo existant ou la création d'un nouveau repo instrumenté clia.

L'interface est similaire à `git init` avec installation des assets core de clia:

- harness-ia:
  - CLAUDE.md
  - CONSTITUTION.md
  - skills
- INTENTION.md


## Cas d'usage 1: nouveau repo

**pré-condition**: le repo REPO_PATH n'existe pas.

```sh
clia init REPO_PATH

```

**post-condition**: le répertoire REPO_PATH est un repo git contenant un fichier CLAUDE.md, INTENTION.md et .dev/session.md

## Cas d'usage 2: repo git existant

cas d'usage non supporté => retourne une erreur