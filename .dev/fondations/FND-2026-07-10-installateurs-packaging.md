# FND-2026-07-10-installateurs-packaging - Installateurs et outils de packaging

- **Statut** : actif
- **Date** : 2026-07-10
- **Objectif** : établir une base factuelle et sourcée sur les modèles d'installation et les outils de packaging d'un logiciel (localisation des fichiers, taxonomie des gestionnaires de paquets, propriétés d'un installateur robuste, sécurité, versionnage), réutilisable pour concevoir l'installation d'un outil en ligne de commande. Complément de `FND-2026-07-10-conventions-cli`, qui excluait explicitement le packaging et la distribution.

## Note de rigueur

Fondation appuyée sur des sources primaires : Filesystem Hierarchy Standard 3.0 (Linux Foundation, republié par freedesktop.org en 2025), XDG Base Directory Specification (freedesktop.org), GNU Coding Standards, Semantic Versioning 2.0.0, et la documentation officielle des principaux gestionnaires de paquets (Debian/dpkg, RPM/Fedora, Homebrew, Nix, PyPA, npm, Cargo, Go, Flatpak, Snap, AppImage, OCI). Les questions de sécurité de l'installation par script (`curl | bash`) s'appuient sur des sources secondaires de référence. Les affirmations normatives sont rattachées à leur source. Stabilité inégale : les standards de localisation (FHS, XDG) et le versionnage sémantique sont stables ; l'écosystème des outils de packaging évolue plus vite.

## Cadrage

Trois notions à distinguer, souvent confondues :

- **Packaging** : produire un artefact distribuable (paquet, archive, image) à partir du code source ou des binaires, avec métadonnées (nom, version, dépendances).
- **Distribution** : acheminer cet artefact jusqu'à l'utilisateur (dépôt de paquets, registre, release, miroir, CDN).
- **Installation** : poser l'artefact sur la machine cible et le rendre utilisable (fichiers en place, `PATH`, permissions, dépendances résolues, activation).

Périmètre : modèles et outils indépendants d'un projet donné. Hors périmètre : la convention d'interface CLI (voir `FND-2026-07-10-conventions-cli`), et les détails d'empaquetage propres à un langage au-delà de leur principe.

Définitions :
- **Gestionnaire de paquets** : outil qui installe, met à jour, interroge et supprime des paquets en gérant leurs dépendances et métadonnées.
- **Installation par utilisateur (per-user)** vs **système (system-wide)** : dans le `$HOME` de l'utilisateur, sans privilège, ou dans les répertoires système, avec privilège.
- **Idempotence** : réexécuter l'installation produit le même état, sans effet cumulatif indésirable.

## Corps

### 1. Localisation des fichiers : FHS et XDG

Deux standards structurent où poser les fichiers.

Le **Filesystem Hierarchy Standard (FHS 3.0)** régit l'arborescence système :
- `/usr` : logiciels de la distribution ; `/usr/bin`, `/usr/lib`.
- `/usr/local` : logiciels installés localement par l'administrateur, hors distribution (destination par défaut de `make install`) ; `/usr/local/bin`, `/usr/local/lib`.
- `/opt` : paquets applicatifs autonomes, groupés par nom (`/opt/<paquet>/bin`), utile pour une application livrée en bloc.
- Beaucoup de distributions modernes fusionnent `/bin` -> `/usr/bin` (usr-merge).

La **XDG Base Directory Specification** régit les fichiers **par utilisateur**, via des variables d'environnement avec valeurs par défaut :
- `$XDG_DATA_HOME` (défaut `~/.local/share`) : données ; `~/.local/bin` est la convention adoptée pour les exécutables per-user.
- `$XDG_CONFIG_HOME` (défaut `~/.config`) : configuration.
- `$XDG_STATE_HOME` (défaut `~/.local/state`) : état persistant (journaux, historique).
- `$XDG_CACHE_HOME` (défaut `~/.cache`) : données recréables.
- `$XDG_RUNTIME_DIR` : fichiers de session/runtime.

Conséquence pour un installateur per-user moderne : poser les exécutables dans `~/.local/bin` (souvent déjà dans le `PATH` des distributions récentes), la configuration dans `~/.config/<outil>`, l'état dans `~/.local/state/<outil>` ; éviter d'accumuler des fichiers `~/.<outil>rc` à la racine du `$HOME`.

### 2. Gestion du `PATH` et activation

Rendre un exécutable appelable suppose qu'il soit dans un répertoire du `PATH`. Trois approches :
- **Répertoire déjà dans le `PATH`** : poser (ou lier symboliquement) le binaire dans `/usr/local/bin` (système) ou `~/.local/bin` (per-user). Le plus simple et le plus prévisible.
- **Modification d'un fichier de profil** : ajouter `export PATH=...` dans `~/.bashrc`, `~/.profile`, `~/.zshrc`. Persistant mais couplé au shell, intrusif (édition d'un fichier hors du paquet), et nécessite un rechargement (`source`) ou une nouvelle session.
- **Lien symbolique** (`ln -s`) depuis un répertoire du `PATH` vers le binaire réel : découple l'emplacement d'installation de l'exposition (patron de Homebrew avec ses « symlinks » depuis `bin/`).

Point d'attention : modifier un fichier de profil est un effet de bord hors artefact ; il doit être **marqué**, **idempotent** et **réversible** (voir section 6).

### 3. Taxonomie des modèles d'installation

1. **Gestionnaire de paquets système** (installation privilégiée, intégrée) : `apt`/`dpkg`, `dnf`/`rpm`, `apk`, `pacman`. Avantages : dépendances gérées, intégrité cryptographique, désinstallation propre, mises à jour centralisées. Inconvénient : nécessite un paquet par distribution et souvent des privilèges.
2. **Gestionnaire multiplateforme sans privilège** : Homebrew (macOS/Linux, préfixe dédié, formules), Nix (store immuable, installations reproductibles et atomiques). Installe sans `sudo` dans un préfixe utilisateur ou partagé.
3. **Gestionnaire par langage** : npm (Node), pip/PyPA (Python), Cargo (Rust), gem (Ruby), `go install` (Go). Installe des outils écrits dans ce langage, souvent per-user, avec leur propre résolution de dépendances.
4. **Format universel autonome** : AppImage (un fichier exécutable portable, sans installation), Flatpak et Snap (applications sandboxées avec leurs dépendances, dépôts dédiés). Cible surtout les applications de bureau.
5. **Image de conteneur** (OCI) : distribuer l'outil et son environnement complet ; « installation » = `pull` de l'image ; exécution isolée.
6. **Compilation depuis les sources** : `./configure && make && make install` (convention GNU), avec `DESTDIR` pour la mise en paquet et `--prefix` pour la destination. Flexible, mais reporte la charge sur l'utilisateur.
7. **Script d'installation** (`install.sh`, souvent `curl ... | bash`) : un script détecte la plateforme, télécharge le binaire et le pose. Simple pour l'auteur, mais pose des problèmes de sécurité (section 6).

### 4. Anatomie d'un paquet et outils de packaging

Un paquet associe des **fichiers** à des **métadonnées** : nom, version, dépendances, scripts de pré/post-installation, somme de contrôle, signature.

- **Debian (`.deb`, dpkg/apt)** : arborescence `DEBIAN/control` (métadonnées, dépendances) ; hooks `postinst`/`prerm` ; politique Debian stricte.
- **RPM (`.rpm`, dnf/yum)** : fichier `.spec` décrivant build, fichiers, dépendances, scriptlets ; guidelines Fedora.
- **Alpine (`apk`)** : `APKBUILD` léger, orienté conteneurs.
- **Arch (`pacman`)** : `PKGBUILD`.
- **Homebrew** : « formule » Ruby, installe dans un préfixe (`Cellar`) puis lie dans `bin/`.
- **Nix** : dérivations fonctionnelles, store adressé par hash, reproductibilité et rollback atomique.
- **Langages** : `package.json` (npm), `pyproject.toml` normalisé par PEP 517/518/621 et les wheels PyPA (Python), `Cargo.toml` (Rust), gemspec (Ruby), modules Go.
- **Universels** : manifeste Flatpak, `snapcraft.yaml` (Snap), recette AppImage ; image OCI (spec Open Container Initiative).

### 5. Propriétés transverses d'un installateur robuste

Critères récurrents d'un bon installateur, quel que soit le modèle :
- **Idempotence** : réexécuter n'aggrave rien ; détecter une installation existante.
- **Réversibilité** : une désinstallation propre retire exactement ce qui a été posé (d'où l'intérêt des métadonnées de paquet ou de marqueurs bornés dans les fichiers modifiés).
- **Mise à jour** : chemin d'upgrade clair, idéalement réconciliant (mettre à jour un chemin obsolète plutôt que dupliquer).
- **Moindre privilège** : préférer le per-user sans `sudo` quand c'est possible ; ne demander de privilège que pour une installation système.
- **Vérification de prérequis** : présence des dépendances et de l'artefact avant d'écrire.
- **Intégrité** : sommes de contrôle et signatures (voir section 6).
- **Déterminisme et reproductibilité** : même entrée, même résultat (Nix en est l'expression la plus poussée).
- **Diagnostic clair** : messages sur stderr, codes de sortie signifiants, pas d'état à moitié installé en cas d'échec (transactionnalité, à défaut opérations atomiques par `tmpfile` + `mv`).

### 6. Sécurité et intégrité

- **Intégrité par signature et somme de contrôle** : les gestionnaires de paquets système signent cryptographiquement leurs dépôts et vérifient des checksums ; c'est leur avantage majeur de sécurité.
- **Critique de `curl | bash`** : installer en canalisant un script distant directement dans un shell présente des risques documentés : exécution partielle si le transfert est interrompu (un script tronqué peut exécuter une commande destructrice incomplète), absence de signature/checksum du script lui-même (on ne se fie qu'à TLS), et possibilité pour le serveur de **détecter** le pipe et de servir un contenu différent. Bonnes pratiques : télécharger le script, l'inspecter, puis l'exécuter ; préférer un paquet signé du gestionnaire de la distribution ; fournir des sommes de contrôle publiées hors bande.
- **Effets de bord hors artefact** : toute écriture dans un fichier de profil ou de configuration existant doit être bornée par un marqueur d'ouverture/fermeture, idempotente et réversible, pour ne jamais corrompre le fichier de l'utilisateur.

### 7. Versionnage et distribution

- **Semantic Versioning 2.0.0** : `MAJEUR.MINEUR.CORRECTIF` ; MAJEUR pour une rupture de compatibilité, MINEUR pour un ajout rétrocompatible, CORRECTIF pour un correctif rétrocompatible ; suffixes de préversion (`-rc.1`) et de build. Permet aux dépendances d'exprimer des contraintes de version.
- **Canaux de release** : stable / bêta / nightly ; l'installateur peut cibler un canal.
- **Distribution** : dépôt de paquets signé (système), registre (langages), releases attachées à une forge (binaires + sommes de contrôle), miroirs/CDN.

### 8. Application : installer un outil en ligne de commande (générique)

Pour un CLI simple (un exécutable, éventuellement quelques fichiers de support), les options se hiérarchisent ainsi :

- **Le plus intégré** : fournir des paquets natifs (`.deb`, `.rpm`, formule Homebrew) — meilleure intégrité et désinstallation, au prix d'un paquet par plateforme.
- **Le plus simple sans privilège** : poser (ou lier) l'exécutable dans `~/.local/bin` (conforme XDG, souvent déjà dans le `PATH`), configuration dans `~/.config/<outil>`. Per-user, réversible, sans `sudo`.
- **Le mode « dev / in-repo »** : exposer directement l'exécutable depuis son dépôt via le `PATH` (aucune copie), pratique quand l'outil vit dans le dépôt qu'il sert ; l'installation se réduit à rendre ce chemin permanent.
- **Le script d'installation** : acceptable s'il est téléchargeable et inspectable, idempotent, réversible et borné ; à ne pas réduire au `curl | bash` opaque.

Recommandations générales, par ordre de priorité : privilégier un répertoire déjà dans le `PATH` plutôt que d'éditer un fichier de profil ; si un profil doit être modifié, borner et rendre l'opération idempotente et réversible ; suivre XDG pour la localisation des fichiers per-user ; fournir `check`/`uninstall` ; publier des sommes de contrôle ; versionner en semver.

## Synthèse

Installer un logiciel, c'est poser des fichiers à des emplacements normalisés (FHS pour le système, XDG pour le per-user), les rendre appelables via le `PATH`, et gérer leur cycle de vie (mise à jour, désinstallation) avec intégrité. Le paysage va du gestionnaire de paquets système (intégrité et désinstallation fortes, privilège requis) au script d'installation (simple mais risqué), en passant par les gestionnaires multiplateformes sans privilège (Homebrew, Nix), par langage, les formats universels et les conteneurs. Un bon installateur, quel que soit le modèle, est idempotent, réversible, à moindre privilège, vérifie ses prérequis, garantit l'intégrité, et échoue sans laisser d'état à moitié installé. Pour un CLI simple, poser l'exécutable dans un répertoire du `PATH` (idéalement `~/.local/bin`, per-user, conforme XDG) est le compromis le plus prévisible ; l'édition d'un fichier de profil est un dernier recours à border soigneusement.

## Limites

- Ne couvre pas en détail la construction interne des paquets pour chaque écosystème (fichiers `.spec`, dérivations Nix, wheels), seulement leur principe.
- L'écosystème des outils de packaging évolue vite : les faits sur les outils (section 4) sont plus périssables que les standards (FHS, XDG, semver).
- Ne traite pas la signature de code par plateforme (notarisation macOS, Authenticode Windows) au-delà du principe d'intégrité.
- Cible principalement les environnements de type Unix ; Windows (MSI, winget, Chocolatey) n'est évoqué qu'en creux.

## Sources

- Filesystem Hierarchy Standard 3.0 (Linux Foundation) : https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html
- XDG Base Directory Specification (freedesktop.org) : https://specifications.freedesktop.org/basedir/latest/
- GNU Coding Standards, « Managing Releases » et « Makefile Conventions » (`make install`, `DESTDIR`, `--prefix`) : https://www.gnu.org/prep/standards/html_node/Managing-Releases.html
- Semantic Versioning 2.0.0 : https://semver.org/
- Debian Policy Manual (paquets `.deb`) : https://www.debian.org/doc/debian-policy/
- Fedora Packaging Guidelines (RPM) : https://docs.fedoraproject.org/en-US/packaging-guidelines/
- Homebrew Documentation : https://docs.brew.sh/
- Nix Reference Manual : https://nixos.org/manual/nix/stable/
- Python Packaging User Guide (PyPA ; PEP 517/518/621) : https://packaging.python.org/
- npm Documentation : https://docs.npmjs.com/
- The Cargo Book (Rust) : https://doc.rust-lang.org/cargo/
- Flatpak Documentation : https://docs.flatpak.org/ ; Snapcraft : https://snapcraft.io/docs ; AppImage : https://docs.appimage.org/
- OCI Image Format Specification : https://github.com/opencontainers/image-spec
- Discussion de sécurité « curl | bash » : https://www.kicksecure.com/wiki/Dev/curl_bash_pipe ; https://www.sysdig.com/blog/friends-dont-let-friends-curl-bash
