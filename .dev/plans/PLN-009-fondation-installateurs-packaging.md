---
type: plan
version: 0.1.0
title: "Recherche de fondation sur les installateurs et le packaging"
status: exécuté
---

# PLN-009 - Recherche de fondation sur les installateurs et le packaging


## Intention

Établir une base factuelle sourcée et réutilisable sur les **installateurs** et les **outils de packaging**, en complément direct de `FND-007-conventions-cli` (qui excluait explicitement le packaging et la distribution de son périmètre). Sert de socle à la conception d'une installation de CLI (voir `PLN-008`).

## Contexte

Demande de la tâche 3 de `session.md` (« Recherche de fondation sur les installateurs et les outils de packaging »). Livrable de type recherche de fondation (`skl-002`, `FND`), théorique et sourcé, distinct de l'analyse de corpus de la tâche 1. Ressource de harnais : générique, sans information de domaine.

## Spécification du livrable

- **FND-008-installateurs-packaging** - `.dev/fondations/FND-008-installateurs-packaging.md` : recherche sourcée couvrant le vocabulaire, les standards de localisation (FHS, XDG), la taxonomie des modèles d'installation et des outils de packaging, les propriétés transverses d'un bon installateur, la sécurité/intégrité, le versionnage, et une application générique à l'installation d'un CLI. Produit par `skl-002`.

## Plan proposé

### 1. Cadrer le périmètre
Distinguer packaging (produire un artefact distribuable), distribution (l'acheminer) et installation (le poser et l'activer chez l'utilisateur). Dans le périmètre : modèles et outils indépendants d'un projet donné. Hors périmètre : convention d'interface CLI (déjà couverte par `FND-007-conventions-cli`).

### 2. Rassembler les sources primaires
FHS 3.0, XDG Base Directory, GNU Coding Standards (`make install`, `DESTDIR`), Semantic Versioning, docs des gestionnaires de paquets (dpkg/rpm/apk, Homebrew, Nix, PyPA, npm, Cargo, Go), formats universels (Flatpak, Snap, AppImage), OCI image spec ; sources secondaires sur la critique de `curl|bash`.

### 3. Rédiger la fondation selon `skl-002`
Cadre invariant (en-tête, note de rigueur, cadrage, corps thématique, synthèse, limites, sources), sections numérotées, chaque fait clé rattaché à une source.

## Objections de l'agent IA

Aucune objection bloquante. Recherche documentaire en lecture seule. Point de vigilance non bloquant : le domaine du packaging est vaste et évolue plus vite que les conventions CLI ; la fondation annonce sa péremption et privilégie les standards stables (FHS, XDG, semver) sur les outils mouvants.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
