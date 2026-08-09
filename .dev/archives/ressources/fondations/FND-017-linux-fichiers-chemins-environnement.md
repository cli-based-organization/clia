---
type: fondation
version: 0.1.0
title: "linux-fichiers-chemins-environnement - Systèmes Linux : fichiers, chemins et variables d'environnement pour l'installation, les données et leur cycle de vie"
status: actif
date: 2026-07-24
---

# FND-017-linux-fichiers-chemins-environnement - Systèmes Linux : fichiers, chemins et variables d'environnement

- **Objectif** : établir une base factuelle et sourcée sur les conventions d'un système Linux (hiérarchie du système de fichiers, résolution des chemins, variables d'environnement) et les mobiliser autour de trois questions de recherche : où et comment installer une application, où et comment gérer ses données, et comment orchestrer le cycle de vie des deux. Complète `FND-008-installateurs-packaging` (qui traite le packaging et les modèles d'installation) en descendant au niveau des invariants du système d'exploitation lui-même. Distribution de référence : Debian 12 (bookworm), sans perte de généricité pour les distributions de type Unix.

## 1. Note de rigueur

Fondation appuyée sur des sources primaires et normatives : Filesystem Hierarchy Standard 3.0 (Linux Foundation), XDG Base Directory Specification 0.8 (freedesktop.org, 2021-05-08), la spécification POSIX.1-2024 (The Open Group Base Specifications, XBD chapitre 8 « Environment Variables »), et les pages de manuel de référence (`hier(7)`, `environ(7)`, `file-hierarchy(7)` de systemd, `bash(1)`). Les faits de niveau standard (FHS, XDG, POSIX) sont stables et rattachés à leur source. Les spécificités de distribution (comportement par défaut de Debian 12) sont datées et à revalider à chaque version majeure de la distribution (section 8). Les points d'appréciation ou de recommandation sont signalés comme tels.

## 2. Cadrage et thèse

**Question générale** : quelles sont les conventions d'un système Linux qui déterminent où poser des fichiers exécutables et des données, comment les rendre trouvables (chemins, `PATH`), comment les paramétrer (variables d'environnement), et comment gérer leur cycle de vie (installation, mise à jour, retour arrière, suppression) ?

**Périmètre** :

- Dans le sujet : la hiérarchie du système de fichiers (FHS) et la variante per-utilisateur (XDG) ; la sémantique des variables d'environnement et la résolution du `PATH` ; la classification des données (configuration, état, cache, données, runtime) et leur cycle de vie ; les invariants d'installation, de mise à jour et de désinstallation au niveau du système de fichiers ; les propriétés Unix transverses (permissions, `umask`, écriture atomique, verrouillage).
- Hors sujet : la taxonomie des gestionnaires de paquets et des formats de paquet (voir `FND-008`) ; les conventions d'interface d'un CLI (options, sous-commandes, aide, voir `FND-007-conventions-cli`) ; l'architecture interne du noyau et des distributions (voir `FND-004` du dépôt de formation) ; le packaging propre à un langage.

**Thèse** : sous Linux, « installer » et « gérer des données » ne sont pas des opérations opaques mais l'application de trois systèmes de conventions bien définis : (1) **où** poser les fichiers (FHS pour le système, XDG pour l'utilisateur), (2) **comment** les rendre trouvables et paramétrables (résolution de chemin, `PATH`, variables d'environnement avec une hiérarchie de précédence stricte), et (3) **selon quel cycle de vie** classer les fichiers par volatilité (configuration, état, cache, données, runtime), chaque classe ayant des garanties de persistance différentes. Maîtriser ces trois systèmes suffit à concevoir une installation et une gestion de données prévisibles, réversibles et respectueuses de l'utilisateur, sans privilège superflu.

**Définitions** :

- **Chemin absolu / relatif** : un chemin absolu commence par `/` (racine) et est résolu indépendamment du répertoire courant ; un chemin relatif est résolu à partir du répertoire de travail courant (`$PWD`).
- **Variable d'environnement** : paire `nom=valeur` transmise par héritage d'un processus à ses enfants (`environ(7)`), servant à paramétrer un programme sans modifier son code ni ses arguments.
- **per-user (per-utilisateur)** vs **system-wide (système)** : sous le `$HOME` de l'utilisateur, sans privilège ; ou dans les répertoires système partagés, avec privilège (`root`).
- **Volatilité d'une donnée** : sa tolérance à la suppression. Une donnée de cache est recréable (volatile) ; une donnée de configuration ou d'état ne l'est pas (persistante) ; une donnée de runtime disparaît à la fin de la session.

## 3. Fondations : les trois systèmes de conventions

Cette section pose les invariants ; les sections 4 à 6 les mobilisent par question de recherche.

### 3.1 Où poser les fichiers : FHS (système) et XDG (utilisateur)

**Filesystem Hierarchy Standard (FHS 3.0)** normalise l'arborescence système (voir aussi `hier(7)`) :

- `/usr` : hiérarchie secondaire, logiciels de la distribution en lecture seule ; `/usr/bin`, `/usr/lib`, `/usr/share` (données indépendantes de l'architecture).
- `/usr/local` : logiciels installés localement par l'administrateur, hors gestionnaire de paquets ; destination par défaut de `make install`. `/usr/local/bin` est dans le `PATH` par défaut.
- `/opt` : paquets applicatifs autonomes groupés par nom (`/opt/<paquet>`), pour une application livrée en bloc.
- `/etc` : configuration système, statique, propre à la machine.
- `/var` : données variables qui persistent entre redémarrages ; `/var/lib/<paquet>` (état applicatif), `/var/log` (journaux), `/var/cache` (cache), `/var/tmp` (temporaire persistant).
- `/run` : données de runtime volatiles depuis le dernier démarrage (tmpfs en mémoire), vidées à chaque boot ; remplace l'ancien `/var/run`.
- `/tmp` : fichiers temporaires, potentiellement vidés au redémarrage ou par une politique de nettoyage.
- `/home/<user>` : répertoire personnel de l'utilisateur (`$HOME`).

Debian applique le « usr-merge » : `/bin`, `/sbin`, `/lib` sont des liens symboliques vers leurs équivalents `/usr`. Une application ne doit donc jamais présumer que `/bin` et `/usr/bin` sont distincts.

**XDG Base Directory Specification (0.8)** normalise les fichiers **per-utilisateur** via des variables d'environnement, chacune avec une valeur par défaut si non définie ou vide :

| Variable | Défaut | Rôle | Analogue système (FHS/systemd) |
|---|---|---|---|
| `$XDG_CONFIG_HOME` | `~/.config` | configuration | `/etc` |
| `$XDG_DATA_HOME` | `~/.local/share` | données applicatives persistantes | `/usr/share`, `/var/lib` |
| `$XDG_STATE_HOME` | `~/.local/state` | état persistant mais non essentiel (journaux, historique, position) | `/var/lib`, `/var/log` |
| `$XDG_CACHE_HOME` | `~/.cache` | données recréables | `/var/cache` |
| `$XDG_RUNTIME_DIR` | (pas de défaut normatif) | fichiers de runtime de session (sockets, verrous) | `/run/user/<uid>` |

Points essentiels de la spécification XDG :

- Il existe aussi `$XDG_CONFIG_DIRS` (défaut `/etc/xdg`) et `$XDG_DATA_DIRS` (défaut `/usr/local/share:/usr/share`) : listes de recherche system-wide, parcourues par ordre de préférence décroissante, permettant à une configuration utilisateur de **surcharger** une configuration système.
- `$XDG_RUNTIME_DIR` n'a **pas** de valeur de repli normative. Sur un système à systemd (Debian 12), il est créé et pointé (`/run/user/<uid>`) par `pam_systemd` à l'ouverture de session, avec des permissions `0700` et une durée de vie liée à la session. Un programme ne doit jamais présumer son existence : si la variable est absente, il faut se rabattre sur un répertoire privé sous `TMPDIR`.
- Convention communautaire complémentaire non issue de la spec XDG mais largement adoptée : `~/.local/bin` pour les exécutables per-user.

`file-hierarchy(7)` (systemd) unifie ces deux vues et confirme les correspondances : il documente `~/.config`, `~/.local/share`, `~/.local/state`, `~/.cache`, `$XDG_RUNTIME_DIR` côté utilisateur, et un compat-symlink de `/var/run` vers `/run`.

### 3.2 Comment rendre trouvable et paramétrer : chemins, `PATH`, variables d'environnement

**Résolution d'un chemin d'exécutable.** Quand une commande est invoquée (POSIX XBD ch. 8, `execvp`/`bash(1)`) :

- si le nom contient une barre oblique `/`, il est traité comme un chemin (absolu ou relatif) et utilisé tel quel ;
- sinon, le shell cherche un exécutable en parcourant les répertoires listés dans `$PATH`, **de gauche à droite**, et retient la **première** correspondance. L'ordre des composants du `PATH` détermine donc quelle version l'emporte en cas d'homonymie.

**Variables d'environnement** (`environ(7)`, POSIX XBD ch. 8) :

- forme `nom=valeur` ; les noms portables sont en majuscules, chiffres et `_`, et ne commencent pas par un chiffre ;
- transmises par **héritage** : un processus enfant reçoit une copie de l'environnement du parent. Modifier l'environnement n'affecte que le processus et sa descendance future, jamais le parent ni les processus déjà lancés.
- variables standard structurantes : `HOME` (répertoire personnel), `PATH` (recherche d'exécutables), `PWD` (répertoire courant), `TMPDIR` (répertoire temporaire préféré, avec repli `/tmp`), `USER`/`LOGNAME`, `SHELL`, `LANG`/`LC_*` (localisation).

**Hiérarchie de précédence de la configuration.** Un programme bien conçu résout un paramètre selon un ordre de priorité décroissante largement conventionnel :

1. argument de ligne de commande (le plus prioritaire, portée : une invocation) ;
2. variable d'environnement (portée : le processus et sa descendance) ;
3. fichier de configuration per-utilisateur (`$XDG_CONFIG_HOME/<outil>`) ;
4. fichier de configuration system-wide (`/etc/<outil>` ou `$XDG_CONFIG_DIRS`) ;
5. valeur par défaut compilée dans le programme (le moins prioritaire).

Cette cascade permet à l'utilisateur de surcharger ponctuellement (CLI) ou durablement (env, config) sans perdre les défauts.

**Fichiers de démarrage du shell (Debian 12, bash).** L'endroit où poser une variable d'environnement dépend du type de shell :

- **shell de connexion (login)** : lit `/etc/profile` puis le premier trouvé parmi `~/.bash_profile`, `~/.bash_login`, `~/.profile`. Le `~/.profile` par défaut de Debian source `~/.bashrc` s'il est en bash, et ajoute `~/.local/bin` et `~/bin` au `PATH` s'ils existent.
- **shell interactif hors connexion (non-login)** : lit `~/.bashrc`.
- **shell non interactif** : lit le fichier désigné par `$BASH_ENV` s'il est défini, sinon aucun fichier de profil.

Conséquence : une variable qui doit valoir pour toutes les sessions (y compris graphiques) se place plutôt dans un fichier de connexion ; une modification du `PATH` uniquement utile en shell interactif peut aller dans `~/.bashrc`. Toute écriture dans ces fichiers est un effet de bord hors artefact, à border et rendre réversible (section 6, et `FND-008` section 2).

### 3.3 Selon quel cycle de vie : classer les données par volatilité

La distinction cardinale, commune à FHS et XDG, est la **classe de volatilité** d'un fichier. Elle dicte où le poser et comment le traiter lors d'une mise à jour ou d'une désinstallation :

- **Configuration** (`~/.config`, `/etc`) : saisie par l'humain ou l'administrateur, précieuse, à ne jamais écraser sans consentement lors d'une mise à jour. Absente à la création d'un compte.
- **État (state)** (`~/.local/state`, `/var/lib`, `/var/log`) : produit par le programme, persistant, mais non essentiel à sa correction : journaux, historique, dernière position, index. Sa perte dégrade l'expérience sans casser le programme.
- **Données (data)** (`~/.local/share`, `/usr/share`) : contenu applicatif persistant et significatif (bibliothèques de ressources, bases documentaires produites par l'utilisateur).
- **Cache** (`~/.cache`, `/var/cache`) : entièrement recréable ; sa suppression n'a d'autre effet qu'un ralentissement temporaire. Un programme doit tolérer sa disparition à tout moment.
- **Runtime** (`$XDG_RUNTIME_DIR`, `/run`) : sockets, verrous, PID, valides le temps d'une session ; disparaît au redémarrage ou à la déconnexion.

Cette taxonomie est le pivot du cycle de vie : une mise à jour touche le code et éventuellement migre l'état/les données, mais préserve la configuration ; une désinstallation « propre » retire le code et le cache, et propose (sans imposer) de retirer configuration, état et données.

## 4. Question de recherche A : installation d'une application

**Q-A. Où poser un exécutable et ses fichiers de support, et comment le rendre appelable, de façon prévisible, sans privilège superflu et réversible ?**

Axes d'analyse et savoir mobilisé :

### A.1 Axe « emplacement de l'exécutable » (portée et privilège)

- **Système** : `/usr/local/bin` (déjà dans le `PATH`, hors gestionnaire de paquets) exige `root`. Réservé à une installation partagée entre utilisateurs.
- **Per-user** : `~/.local/bin` (convention XDG communautaire, ajouté au `PATH` par le `~/.profile` de Debian 12 s'il existe). Sans privilège, isolé à l'utilisateur. C'est le compromis recommandé pour un outil individuel (voir `FND-008` section 8).
- **In-repo (mode dev)** : exposer directement le répertoire `bin/` du dépôt via le `PATH`, sans copie ni build. L'installation se réduit à rendre ce chemin permanent (patron observé dans `ANL-002`).

### A.2 Axe « mécanisme d'exposition au `PATH` »

Trois techniques, par ordre de robustesse décroissante :

1. **Poser (ou lier) l'exécutable dans un répertoire déjà présent dans le `PATH`** (`/usr/local/bin`, `~/.local/bin`) : le plus prévisible, aucune édition de profil.
2. **Lien symbolique** (`ln -s`) depuis un répertoire du `PATH` vers le binaire réel : découple l'emplacement de stockage de l'exposition (patron Homebrew).
3. **Modification d'un fichier de profil** (`export PATH=...` dans `~/.profile`/`~/.bashrc`) : persistant mais couplé au shell, intrusif, et nécessite un rechargement (`source`) ou une nouvelle session. Dernier recours (section 3.2, `FND-008` section 2).

### A.3 Axe « activation et prise d'effet »

- Une modification de `PATH` dans un fichier de profil **n'affecte pas** le shell courant (héritage : l'environnement du shell déjà lancé ne change pas). Il faut `source` le fichier ou ouvrir une nouvelle session. Cette contrainte doit être communiquée à l'utilisateur (constat d'`ANL-002`).
- Poser un binaire dans un répertoire déjà dans le `PATH` prend effet immédiatement pour les nouvelles invocations (sous réserve du cache de hachage des chemins du shell, `hash -r`).

### A.4 Axe « prérequis et intégrité »

- Vérifier la présence des dépendances et de l'artefact **avant** toute écriture (échec net plutôt qu'état à moitié installé).
- Sous Debian 12, les dépendances système attendues (bash, coreutils, `awk`, `sed`) sont présentes par défaut ; une dépendance hors base (par exemple un interpréteur ou un utilitaire additionnel) doit être vérifiée explicitement.
- Intégrité de l'artefact distribué : sommes de contrôle et signatures (voir `FND-008` section 6, critique de `curl | bash`).

## 5. Question de recherche B : gestion des données

**Q-B. Où placer les fichiers produits ou consommés par l'application, comment les classer, et comment garantir des écritures sûres et concurrentes ?**

Axes d'analyse et savoir mobilisé :

### B.1 Axe « classification par volatilité »

Appliquer la taxonomie de la section 3.3. Décision par fichier : est-il de la configuration (précieuse, humaine), de l'état (persistant, non essentiel), de la donnée (persistante, significative), du cache (recréable) ou du runtime (éphémère) ? Le placement en découle mécaniquement via les variables XDG (per-user) ou l'arborescence FHS (système).

### B.2 Axe « résolution de l'emplacement »

- Toujours **lire la variable XDG et se rabattre sur son défaut** plutôt que coder en dur `~/.config` : `${XDG_CONFIG_HOME:-$HOME/.config}/<outil>`. Cela respecte la personnalisation de l'utilisateur.
- Regrouper les fichiers d'un outil sous un sous-répertoire portant son nom (`<base>/<outil>/`) plutôt que de disperser des fichiers `~/.<outil>rc` à la racine du `$HOME` (anti-pattern explicitement combattu par la spec XDG).
- `$XDG_RUNTIME_DIR` : ne jamais présumer son existence ; se rabattre sur un répertoire privé créé sous `${TMPDIR:-/tmp}` avec permissions `0700`.

### B.3 Axe « sûreté des écritures »

- **Écriture atomique** : écrire dans un fichier temporaire du même système de fichiers puis `mv` (rename atomique POSIX) pour publier. Évite un fichier à moitié écrit en cas d'interruption (patron observé dans `ANL-002` pour l'édition de `~/.bashrc`).
- **Permissions et `umask`** : les fichiers sont créés selon le `umask` du processus (typiquement `022`, donnant `644` pour un fichier, `755` pour un répertoire). Les données sensibles (secrets, `$XDG_RUNTIME_DIR`) doivent forcer `0600`/`0700` explicitement, sans dépendre du `umask`.
- **Concurrence** : plusieurs instances peuvent écrire simultanément. Un verrou (`flock` sur un descripteur, fichier de verrou dans `$XDG_RUNTIME_DIR`) sérialise les accès critiques. Les fichiers de verrou et de PID relèvent du runtime, pas de l'état persistant.

### B.4 Axe « portabilité et hypothèses de chemin »

- Ne jamais coder en dur `/home/<user>` : utiliser `$HOME` (`getenv`) ou l'entrée du répertoire personnel.
- Tenir compte du usr-merge (Debian) : `/bin` et `/usr/bin` sont équivalents ; résoudre les outils via le `PATH`, pas par chemin absolu présumé.
- Ne pas présumer que le répertoire courant est accessible en écriture ni qu'il est le lieu des données : le répertoire de travail est un contexte d'invocation, pas un magasin de données.

## 6. Question de recherche C : cycle de vie (installation, mise à jour, retour arrière, désinstallation)

**Q-C. Comment faire évoluer une application et ses données dans le temps de façon idempotente, réconciliante et réversible ?**

Axes d'analyse et savoir mobilisé :

### C.1 Axe « idempotence »

Réexécuter l'installation doit converger vers le même état, sans effet cumulatif. Détecter une installation existante (marqueur borné dans le fichier de profil, présence du binaire ou du lien). Une insertion dans un fichier de profil doit se faire une seule fois (constat et recommandation d'`ANL-002`).

### C.2 Axe « idempotence réconciliante (mise à jour) »

Au-delà de la simple non-duplication : si une installation existe mais que sa cible a changé (dépôt déplacé, `PATH` obsolète, version antérieure), la réexécution doit **mettre à jour** l'existant plutôt qu'afficher « déjà installé » ou dupliquer. C'est la faiblesse principale relevée dans `ANL-002` (« idempotence aveugle au déplacement ») et la recommandation d'y remédier.

### C.3 Axe « réversibilité (désinstallation) et bornage »

- Une désinstallation propre retire **exactement** ce qui a été posé. D'où l'intérêt de marqueurs d'**ouverture et de fermeture explicites** délimitant tout bloc inséré dans un fichier partagé (recommandation d'`ANL-002` contre la suppression `awk` sensible à une ligne vide).
- Distinguer, à la désinstallation, le **code** (à retirer) du **cache** (à retirer sans risque) de la **configuration, l'état et les données** (à conserver par défaut, ne retirer que sur demande explicite : la donnée de l'utilisateur lui appartient).

### C.4 Axe « migration de l'état et des données entre versions »

- Une mise à jour peut changer le format d'un fichier d'état ou de données. La migration doit être versionnée, testable, et idéalement précédée d'une sauvegarde (copie du répertoire de données avant transformation).
- Le retour arrière (rollback) n'est trivial que si les données n'ont pas migré vers un format non rétrocompatible. Conserver la version qui a produit chaque jeu de données (marqueur de version dans le répertoire de données) rend le rollback décidable.

### C.5 Axe « transactionnalité et échec »

- Aucune opération de cycle de vie ne doit laisser un état à moitié appliqué. À défaut de vraie transaction, procéder par opérations atomiques (`tmpfile` + `mv`), vérifier les prérequis avant d'écrire, et prévoir un chemin de rollback en cas d'échec en cours de route.
- Diagnostics vers `stderr`, données vers `stdout`, codes de sortie signifiants (patron observé dans `ANL-002`, cohérent avec `FND-007`).

## 7. Synthèse (ce qu'il faut retenir)

1. **Trois systèmes de conventions** suffisent à raisonner l'installation et les données sous Linux : où poser (FHS système / XDG utilisateur), comment rendre trouvable et paramétrer (résolution de chemin, `PATH` de gauche à droite, variables d'environnement héritées avec une cascade de précédence CLI > env > config user > config système > défaut), et selon quelle volatilité classer (configuration, état, cache, données, runtime).
2. **La classe de volatilité est le pivot** : elle décide à la fois de l'emplacement (via la variable XDG ou le répertoire FHS correspondant) et du traitement au fil du cycle de vie (ce qu'une mise à jour préserve, ce qu'une désinstallation retire).
3. **Le per-user sans privilège** (`~/.local/bin`, `~/.config`, `~/.local/state`, `~/.cache`), en lisant les variables XDG avec repli sur leur défaut, est le patron le plus prévisible et le moins intrusif pour un outil individuel ; l'édition d'un fichier de profil est un dernier recours à border (marqueur ouverture/fermeture), rendre idempotent et réversible.
4. **Le cycle de vie robuste** est idempotent, réconciliant (met à jour un état obsolète au lieu de dupliquer), réversible (retire exactement ce qui a été posé, préserve la donnée de l'utilisateur), et transactionnel (écritures atomiques, prérequis vérifiés, pas d'état à moitié appliqué).
5. **Sur Debian 12 précisément** : usr-merge (ne pas distinguer `/bin` de `/usr/bin`), `~/.profile` ajoute `~/.local/bin` au `PATH` s'il existe, `$XDG_RUNTIME_DIR` est fourni par `pam_systemd` (`/run/user/<uid>`, `0700`) et sans repli normatif, les utilitaires de base (bash, coreutils, awk, sed) sont présents.

## 8. Limites et péremption

- Cible les systèmes de type Unix, distribution de référence Debian 12 (bookworm). Les spécificités de distribution (contenu du `~/.profile` par défaut, présence de systemd, fourniture de `$XDG_RUNTIME_DIR`) sont à revalider sur une autre distribution ou une version ultérieure de Debian.
- Ne couvre pas : les gestionnaires de paquets et formats de paquet (voir `FND-008`), l'interface CLI (voir `FND-007`), l'architecture du noyau et des distributions (voir `FND-004` du dépôt de formation), le sandboxing (Flatpak/Snap), les services systemd (units utilisateur `systemd --user`), ni la sécurité applicative au-delà des permissions de fichiers.
- Standards stables (FHS 3.0, XDG 0.8 de 2021, POSIX.1-2024) ; les comportements de distribution sont plus périssables. Revalider les faits datés de la section 3.2 et 7 à chaque version majeure de la distribution cible.
- Les renvois à `ANL-002` portent sur un script tiers (`ticket-driven-ai/setup.sh`) observé le 2026-07-10 ; ce sont des illustrations de patrons, pas des garanties sur l'état courant de ce dépôt tiers.

## 9. Sources

- Filesystem Hierarchy Standard 3.0 (Linux Foundation) : https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html
- XDG Base Directory Specification (freedesktop.org, v0.8, 2021-05-08) : https://specifications.freedesktop.org/basedir/latest/
- POSIX.1-2024, The Open Group Base Specifications, XBD chapitre 8 « Environment Variables » : https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap08.html
- `environ(7)` (Linux man-pages) : https://man7.org/linux/man-pages/man7/environ.7.html
- `hier(7)` (Linux man-pages, description de la hiérarchie du système de fichiers) : https://man7.org/linux/man-pages/man7/hier.7.html
- `file-hierarchy(7)` (systemd, Debian bookworm) : https://manpages.debian.org/bookworm/systemd/file-hierarchy.7.en.html
- `bash(1)`, section « INVOCATION » (fichiers de démarrage login / non-login) : https://manpages.debian.org/bookworm/bash/bash.1.en.html
- Debian Policy Manual (usr-merge, conventions de fichiers) : https://www.debian.org/doc/debian-policy/
- Ressources internes complémentaires : `FND-007-conventions-cli`, `FND-008-installateurs-packaging`, `FND-004-linux-noyau-distributions-materiel` (dépôt de formation), `ANL-002-setup-installation`.
