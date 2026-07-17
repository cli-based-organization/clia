# ANL-2026-07-10 - Setup et installation du CLI `tda` (dépôt `ticket-driven-ai`)

- **Date** : 2026-07-10
- **Périmètre** : `../../noumanity-dev/ticket-driven-ai/setup.sh` (script d'installation) et `bin/tda` (artefact installé). Exclus : `.git/`, `skills/`, `doc/`, `.dev/`, `BRAINDUMP*`.
- **Référence** : aucune référence normative fournie par la tâche. Analyse descriptive et critique ; la synthèse est orientée vers l'installation de `clia`.

## Objet

Décrire les fonctionnalités de setup du script `setup.sh` du dépôt `ticket-driven-ai`, en particulier son mécanisme d'installation, afin d'éclairer l'intention de session « fournir un CLI installable pour un utilisateur ». `setup.sh` (v0.1.0, 251 lignes) installe la commande `tda`, CLI de la méthodologie ticket-driven-ai (binaire unique `bin/tda`, ~68 Ko).

## Périmètre et méthode

Lecture intégrale de `setup.sh` et inventaire du corpus d'installation. Grille d'analyse en cinq dimensions :

1. **Interface** : sous-commandes/options exposées, dispatch, aide.
2. **Modèle d'installation** : où et comment l'installation prend effet.
3. **Idempotence et cycle de vie** : réinstallation, vérification, désinstallation.
4. **Robustesse** : garde-fous shell, gestion d'erreurs, opérations sur fichiers.
5. **Ergonomie et cohérence** : messages, documentation, conventions.

## Inventaire

Corpus pertinent :

- `setup.sh` : script d'installation autonome. Structure interne :
  - **Constantes** (`readonly`) : `SETUP_VERSION` (0.1.0), `SETUP_DIR` (répertoire du script, résolu via `BASH_SOURCE`), `SETUP_MARKER` (marqueur d'idempotence inséré dans `~/.bashrc`), `SETUP_BASHRC` (`~/.bashrc`).
  - **Utilitaires de journalisation** : `_setup_info/_ok/_warn/_err/_die` (préfixe `[setup]`, glyphes `✓ ⚠ ✗` ; `warn/err` vers stderr ; `die` sort avec code 1).
  - **Aide** : `_setup_help_short` (résumé) et `_setup_help_long` (page façon man).
  - **Détection** : `_setup_is_installed` (`grep -qF` du marqueur dans `~/.bashrc`).
  - **Commandes** : `_setup_cmd_check`, `_setup_cmd_uninstall`, `_setup_cmd_install`.
  - **Point d'entrée** : `main` (dispatch `case` sur `$1`).
- `bin/tda` : artefact installé (binaire du CLI). L'installation ne fait que le rendre accessible via `PATH` ; elle ne le copie pas et ne le compile pas.

Bruit exclu : le reste du dépôt (méthodologie, skills, docs) n'entre pas dans le périmètre d'installation.

## Constats

### Interface (dimension 1)

Dispatch simple par `case "${1:-}"` sur un seul argument :

- `-h` : aide courte ; `--help` : aide longue ; `--version` : version brute (`0.1.0`) ;
- `--check` : diagnostic d'installation (propage le code retour) ;
- `--uninstall` : désinstallation ;
- `""` (aucun argument) : installation ;
- `*` : option inconnue -> message d'erreur + aide courte, code de sortie 1.

L'aide est bilingue de fait à la convention du dépôt (messages en français). Elle documente clairement les trois propriétés revendiquées de l'installation : **dev**, **permanent**, **local**.

### Modèle d'installation (dimension 2) — focus

L'installation est **non intrusive et sans privilège**. `_setup_cmd_install` :

1. affiche le dépôt source (`SETUP_DIR`) et la cible (`~/.bashrc`) ;
2. vérifie la présence de `bin/tda` (sinon `_setup_die`) ;
3. vérifie l'absence d'installation préalable (marqueur) ;
4. **ajoute en fin de `~/.bashrc`** le bloc :

   ```
   # tda (ticket-driven-ai) — ajouté par setup.sh
   export TDA_HOME="${SETUP_DIR}"
   export PATH="${TDA_HOME}/bin:${PATH}"
   ```

Les trois propriétés se lisent directement dans ce mécanisme :

- **dev** : `PATH` pointe vers `bin/` du **dépôt source lui-même** ; aucune copie, aucune compilation. Toute modification du dépôt est immédiatement active. `TDA_HOME` donne au CLI la racine de sa méthodologie.
- **permanent** : le bloc réside dans `~/.bashrc`, donc rechargé à chaque shell interactif.
- **local** : écrit uniquement dans le `$HOME` de l'utilisateur courant ; pas de `sudo`, pas de `/usr/local/bin`.

Activation : l'installation n'agit pas sur le shell courant ; elle exige `source ~/.bashrc` (documenté dans les messages de sortie et l'aide). Aucune étape de build ni installation de dépendances : le CLI est un unique script exécutable.

### Idempotence et cycle de vie (dimension 3)

- **Idempotence** : `_setup_is_installed` empêche la double insertion du bloc. Une réinstallation impose explicitement `./setup.sh --uninstall && ./setup.sh` (indiqué à l'utilisateur).
- **Vérification** : `--check` confirme la présence et extrait `TDA_HOME` de `~/.bashrc` (via `grep | head -1 | sed`), avec propagation du code retour (0 installé, 1 non).
- **Désinstallation** : `--uninstall` avertit, **demande confirmation** (`[o/N]`), puis retire le bloc via `awk` dans un fichier temporaire suivi d'un `mv` (évite d'éditer `~/.bashrc` en cours de lecture).

### Robustesse (dimension 4)

Bonnes pratiques observées :

- `set -euo pipefail` en tête.
- Constantes `readonly` ; résolution robuste de `SETUP_DIR` via `cd "$(dirname "${BASH_SOURCE[0]}")" && pwd`.
- Diagnostics vers **stderr**, données/version vers **stdout** ; codes de sortie signifiants (0/1).
- Désinstallation par tmpfile + `mv` (atomicité relative, pas d'édition en place).
- Prérequis vérifié (`bin/tda`) avant toute écriture.

### Fragilités localisées (dimensions 3-5)

- **Idempotence aveugle au déplacement** : le marqueur détecte la *présence* d'une install, pas un changement de `TDA_HOME`. Si le dépôt est déplacé, une simple relance affiche « déjà installé » sans corriger le `PATH` obsolète ; il faut penser à `--uninstall` d'abord (`setup.sh:189-193`).
- **`awk` de désinstallation dépendant d'une ligne vide** : la suppression court du marqueur jusqu'à la première **ligne vide** (`skip && /^$/`). Le bloc inséré n'a pas de ligne vide de fin propre ; si d'autres exports suivent immédiatement sans ligne vide, le motif pourrait sur-supprimer, et une ligne vide résiduelle (celle qui précède le marqueur) peut subsister (`setup.sh:164-169, 196-201`).
- **Extraction de `TDA_HOME` fragile** : `--check` suppose une unique ligne `TDA_HOME=` et un formatage stable (`grep | head -1 | sed | tr -d '"'`) ; sensible à un `~/.bashrc` contenant d'autres occurrences (`setup.sh:134`).
- **Shell unique** : couplage exclusif à `~/.bashrc`. Aucune prise en charge de `zsh`/`fish` ni de `~/.profile` ; les propriétés « permanent » et « local » ne valent que sous bash.
- **Incohérence documentaire de commande** : l'aide longue de `setup.sh` illustre `tda -C <repo> install` (`setup.sh:118`), tandis que le `README.md` du dépôt documente `tda -C <repo> init` pour la même étape d'initialisation d'un repo. Divergence de nom de sous-commande à lever (dans le dépôt cible, hors périmètre d'édition ici).

## Synthèse et recommandations

**Ce qu'il faut retenir.** `setup.sh` est un installeur bash **local, sans privilège, en mode dev** : il n'installe rien au sens classique (ni copie, ni build), il rend le dépôt exécutable en préfixant `PATH` et en exportant une variable de home, de façon **idempotente** et **réversible**, via un unique bloc marqué dans `~/.bashrc`. Le modèle est simple, lisible et robuste sur l'essentiel ; ses limites tiennent au couplage `bash`/`~/.bashrc`, à une idempotence qui ne réconcilie pas un `TDA_HOME` obsolète, et à une désinstallation `awk` sensible à la mise en forme.

**Recommandations pour l'installation de `clia`** (priorisées) :

1. **Reprendre le socle** : mode local sans `sudo`, bloc marqué idempotent, `--check`/`--uninstall`, activation par `source`, prérequis vérifié avant écriture. C'est un patron sain et cohérent avec `SPEC-001`/`REQ-001`.
2. **Rendre l'idempotence réconciliante** : à la réinstallation, si le bloc existe mais que la racine a changé, **mettre à jour** le bloc au lieu d'afficher « déjà installé » (évite les `PATH` obsolètes après déplacement du dépôt).
3. **Fiabiliser la désinstallation** : délimiter le bloc par un marqueur d'**ouverture et de fermeture** explicites plutôt que par une ligne vide, pour une suppression déterministe.
4. **Décider du périmètre de shell** : assumer bash uniquement (documenté) ou prendre en charge `zsh`/`~/.profile` dès le départ selon la cible utilisateur.
5. **Fixer les noms de commandes tôt** et garder aide et README synchronisés (l'incohérence `install`/`init` observée illustre le coût d'une divergence non tracée).

## Portée et péremption

Analyse d'un unique script (`setup.sh` v0.1.0) et du rôle de `bin/tda`, à la date du 2026-07-10. Couverture : intégralité de `setup.sh` ; `bin/tda` traité seulement comme artefact installé (non audité). Le dépôt `ticket-driven-ai` évolue indépendamment de ce dépôt : les numéros de ligne et la version du script peuvent se périmer. Les constats de fragilité sont des observations sur l'existant cible, non des demandes de modification de ce dépôt tiers.
