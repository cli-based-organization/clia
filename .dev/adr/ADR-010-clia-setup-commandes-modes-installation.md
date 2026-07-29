---
type: adr
version: 0.1.0
title: "Commandes et modes d'installation de `clia` (deux couches, `clia setup`)"
status: Proposé
date: 2026-07-23
---

# ADR-010 - Commandes et modes d'installation de `clia` (deux couches, `clia setup`)

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `PLN-016` (segment 1, étapes 1.1 et 1.2), tâche 31 de `session.md` (résolutions des objections 2 à 5), `ANL-002-setup-installation`, `FND-008-installateurs-packaging`

## Contexte

La session doit livrer deux capacités : créer et initialiser un nouveau repo doté du système d'augmentation `clia`, et mettre à niveau ou revenir en arrière (`upgrade`/`downgrade`) sur les ressources `clia` d'un repo existant. `PLN-016` combine `PLN-012` et `PLN-013` et fixe, après traitement des objections (tâche 31), les décisions à documenter ici.

Deux préoccupations distinctes se dégagent, qu'il faut nommer avant de spécifier quoi que ce soit :

1. rendre la commande `clia` disponible pour l'utilisateur sur sa machine (installation de l'outil) ;
2. poser et faire évoluer le système d'augmentation à l'intérieur d'un repo cible (installation du contenu d'augmentation dans un projet).

Le dépôt `ticket-driven-ai` (`tda`) traite déjà ces deux préoccupations : `setup.sh` installe la commande `tda` (couche 1), et `tda -C <repo> install` pose la méthodologie dans un repo (couche 2). `ANL-002` a analysé `setup.sh` et en a tiré des recommandations. La tâche 31 demande de reproduire cette approche en corrigeant les fragilités relevées par `ANL-002`, sans git, avec un vocabulaire `upgrade`/`downgrade`.

Contraintes directrices : `clia` est 100% déterministe (`ADR-007`, `PDC-001`) ; le harnais est générique et réutilisable, sans information de domaine (`ADR-005`, `PDC-003`) ; la frontière méthode/domaine sépare la zone d'augmentation du contenu métier ; l'interdiction de git vise l'agent IA, mais la tâche 31 (objection 4) impose en plus que `clia setup` lui-même n'effectue aucune opération git.

## Décision (résumé)

> L'installation de `clia` s'organise en **deux couches**. La **couche 1** (installation de l'outil) reste un script d'amorçage `setup.sh` calqué sur celui de `tda`, en mode **dev + permanent + local**, corrigé selon `ANL-002`. La **couche 2** (installation du contenu d'augmentation dans un repo cible) est le groupe **`clia setup <init|upgrade|downgrade>`**, qui **matérialise et réconcilie** les fichiers du système d'augmentation dans le repo cible, **sans jamais invoquer git**. Le **paquet distribuable** est l'ensemble générique du harnais réutilisable (fichiers de harnais racine, `skills`, `templates`, `resource-types.yaml`, l'outil `clia`), identifié par les **zones** et le champ `type`, et versionné **par le frontmatter** de chaque ressource (plus de manifeste). `upgrade`/`downgrade` comparent, ressource par ressource, la version de frontmatter installée dans la cible à celle de l'**arbre `clia` source local**, dont l'humain contrôle la version via git (hors `clia`).

## Décisions détaillées

### D1 - Deux couches distinctes

- **Décision** : séparer explicitement l'installation de l'outil (couche 1) et l'installation du contenu d'augmentation dans un repo (couche 2).
  - **Couche 1 (outil)** : script `setup.sh` à la racine du dépôt `clia`, exécuté une fois par utilisateur, qui rend la commande `clia` appelable.
  - **Couche 2 (contenu)** : commande `clia setup ...`, exécutée sur un repo cible, qui pose et fait évoluer les fichiers d'augmentation.
- *Alternatives écartées* : tout confier à `clia` (y compris l'amorçage de la commande elle-même) : rejeté, l'amorçage précède l'existence de la commande dans le `PATH`, il lui faut un script autonome. Tout confier à un `setup.sh` monolithique (modèle `tda`) : conservé pour la couche 1, mais la couche 2 gagne à vivre dans `clia` (déterministe, documenté, découvrable via `clia.doc.yaml`, cohérent avec `REQ-002`).

### D2 - Couche 1 : `setup.sh`, modes dev + permanent + local, corrigé selon `ANL-002`

- **Décision** : reproduire le socle de `setup.sh` de `tda` (`ANL-002`, recommandation 1) : installation **per-user, sans `sudo`** ; **dev** (le `PATH` pointe vers le dépôt `clia` lui-même, aucune copie ni build, toute modification immédiatement active) ; **permanent** (bloc marqué dans `~/.bashrc`, survit aux sessions) ; **local** (uniquement pour l'utilisateur courant) ; activation par `source ~/.bashrc` ; prérequis vérifiés avant écriture ; sous-commandes `--check` et `--uninstall`. Appliquer les corrections de `ANL-002` :
  - **idempotence réconciliante** (recommandation 2) : à la réinstallation, si le bloc existe mais que la racine a changé, **mettre à jour** le bloc au lieu d'afficher « déjà installé » ;
  - **désinstallation déterministe** (recommandation 3) : délimiter le bloc par des **marqueurs d'ouverture et de fermeture** explicites plutôt que par une ligne vide ;
  - **périmètre de shell assumé** (recommandation 4) : **bash uniquement** sur cible **Debian 12** (cohérent avec la tâche 5 de session), documenté ;
  - **noms de commandes fixés tôt** (recommandation 5) et gardés synchronisés avec l'aide.
- *Alternatives écartées* : poser un lien dans `~/.local/bin` (conforme XDG, `FND-008` section 8) : viable et plus « propre », mais écarté au profit du mode dev in-repo, qui sert un outil vivant dans son propre dépôt et évite toute copie ; support multi-shell (`zsh`, `fish`, `~/.profile`) : hors périmètre (cible Debian 12 bash).

### D3 - Couche 2 : surface de commandes `clia setup <init|upgrade|downgrade>`

- **Décision** : retenir le groupe `clia setup` avec trois sous-commandes (résolution de l'objection 2, « utiliser upgrade/downgrade ») :
  - `clia setup init` : matérialiser le système d'augmentation dans un repo cible qui n'en a pas encore (squelette le plus mince viable) ;
  - `clia setup upgrade` : réconcilier les ressources d'augmentation de la cible **vers l'avant** (versions de l'arbre source plus récentes que celles de la cible) ;
  - `clia setup downgrade` : réconcilier les ressources d'augmentation de la cible **vers l'arrière** (versions de l'arbre source antérieures à celles de la cible).
  Le vocabulaire `init/update/rollback` de `PLN-012` est **abandonné**. La grammaire suit `SPEC-002` : `clia [GLOBAL_OPTIONS] setup <sous-commande> [OPTIONS]`, avec aide générée depuis `clia.doc.yaml` (`REQ-001-F9`).
- *Alternatives écartées* : commandes de premier niveau (`clia init`, `clia upgrade`, `clia downgrade`) : rejeté, le regroupement `setup` isole clairement la couche 2 et laisse `clia` cohérent avec ses autres groupes (`res`, `ses`) ; conserver `rollback` : rejeté (directive humaine).

### D4 - Résolution de la racine cible

- **Décision** : la **racine cible** de la couche 2 est distincte de la racine de l'outil (`BASH_SOURCE`, `SPEC-002`). Elle est résolue dans l'ordre : option explicite `clia setup -C <dir> ...`, à défaut la **racine git du répertoire courant**, à défaut le répertoire courant. `clia` agit toujours sur cette cible résolue, jamais sur son propre arbre d'installation.
- *Alternatives écartées* : agir implicitement sur l'arbre de l'outil : rejeté, confond outil et cible ; exiger toujours `-C` : rejeté, moins ergonomique que le défaut « repo courant ».

### D5 - « Pas de git » : `clia setup` ne modifie que les fichiers d'augmentation

- **Décision** (résolution de l'objection 4) : `clia setup` **n'exécute aucune opération git** (ni `init`, ni `commit`, ni `checkout`, ni tag). Son seul effet est d'**écrire, mettre à jour ou retirer les fichiers du système d'augmentation** dans la cible (voir D6). La gestion de versions (commits, branches, tags, retour arrière par l'historique) reste **entièrement à l'humain**. En conséquence :
  - le `downgrade` n'est **pas** un `git revert` : c'est une **re-matérialisation** des fichiers d'augmentation depuis l'arbre `clia` source local (voir D7) ;
  - `clia setup` échoue sans effet de bord si une précondition n'est pas remplie (atomicité par `tmpfile` + `mv`, `FND-008` section 5), laissant le repo dans un état propre pour que l'humain décide de committer ou non.
- *Alternatives écartées* : rollback via l'historique git piloté par `clia` (option envisagée avant la tâche 31, `PLN-015` ayant clarifié que `clia` peut faire du git) : **rejeté** par la tâche 31 ; instantanés gérés par `clia` : rejeté (état supplémentaire à maintenir, redondant avec git que l'humain possède déjà).

### D6 - Définition du paquet distribuable (sans manifeste)

- **Décision** (étape 1.2 de `PLN-016`) : le paquet distribuable par `clia setup` est le **harnais générique et réutilisable** (`ADR-005`), et non le contenu de conception propre au développement de `clia`. Il est défini par les **zones** et le champ **`type`**, et non par une liste centrale :
  - **inclus** (zone d'augmentation générique) : les fichiers de harnais racine (`CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`), `INTENTION.md` en tant que **gabarit** à personnaliser, les `skills` (`.dev/skills/`), les `templates` (`.dev/templates/`), la couche type machine-lisible (`.dev/resource-types.yaml`), l'outil `clia` (`src/`, `clia.doc.yaml`) et le squelette de `version.yaml` ;
  - **exclus** : les instances de ressources de conception propres à ce dépôt (les `ADR`, `SPEC`, `REQ`, `FND`, `ANL`, `BUG`, `PDC`, `PLN` qui documentent le développement de `clia`), les **traces** (`.dev/logs/`, `.dev/sessions/`) et le **point d'entrée** (`session.md`), qui sont propres au repo cible et non distribués. Un repo cible reçoit des **répertoires de ressources vides**, prêts à accueillir sa propre conception.
- *Alternatives écartées* : distribuer aussi les ressources de conception de `clia` : rejeté, elles sont spécifiques au domaine « développer `clia` » et violeraient la généricité du harnais (`ADR-005`, `PDC-003`) ; réintroduire un manifeste central listant les fichiers du paquet : rejeté, `PLN-014` a aboli `ressources.yaml` ; l'appartenance se déduit des zones et du `type`.

### D7 - Comparaison de versions et source de distribution

- **Décision** (résolution de l'objection 5, par conséquence de l'objection 4) : la **source** des versions est l'**arbre `clia` installé localement** (déterministe, hors ligne). `upgrade`/`downgrade` comparent, **ressource par ressource**, la `version` (semver) lue dans le **frontmatter** de la copie installée dans la cible à celle de la copie dans l'arbre source :
  - dans la cible mais absente de la source, ou versions égales : **inchangée** ;
  - source plus récente que cible : candidate à `upgrade` ;
  - source antérieure à cible : candidate à `downgrade`.
  La **direction** (`upgrade` vs `downgrade`) exprime l'intention de l'humain et sert de garde-fou : `upgrade` n'applique que des transitions montantes, `downgrade` que des transitions descendantes ; une transition de sens contraire est signalée, non appliquée. L'humain contrôle la version de l'arbre source en le plaçant, **via git (hors `clia`)**, à la révision voulue avant d'invoquer `clia setup`. La distribution distante (`curl | bash`, signatures, `FND-008` section 6) est **hors périmètre**.
- *Alternatives écartées* : tirer les versions d'une release distante : hors périmètre (réseau, signatures, risques `curl | bash`) ; conserver un historique de versions interne à `clia` pour le `downgrade` : rejeté (redondant avec git, état à maintenir, contraire au déterminisme sans état persistant).

## Question de conception ouverte (non tranchée ici)

Le livrable de session « créer un nouveau repo git et l'initialiser » suppose un `git init`. La décision D5 exclut toute opération git de `clia setup`. La charge du `git init` d'un repo neuf revient donc soit à une **étape humaine préalable** (l'humain crée et initialise le repo git, puis lance `clia setup init`), soit à la **couche 1** (`setup.sh` ou un utilitaire d'amorçage distinct). Ce point est laissé aux REQ/SPEC de la couche 2 (`PLN-016`, segment 2) et n'est pas bloquant pour la présente décision.

## Conséquences

**Positives**

- Frontière nette entre installation de l'outil (couche 1) et installation du contenu (couche 2), reprenant un modèle éprouvé (`tda`) tout en corrigeant ses fragilités connues (`ANL-002`).
- `clia setup` reste 100% déterministe et sans effet git : l'humain garde la maîtrise entière de l'historique de versions.
- Le paquet distribuable se déduit des zones et du `type` : pas de manifeste à tenir à jour (`PLN-014`), et le harnais reste générique (`ADR-005`).
- `downgrade` symétrique de `upgrade` : un seul moteur de réconciliation par frontmatter, deux directions.

**Négatives / risques**

- Le `downgrade` dépend de la capacité de l'humain à placer l'arbre `clia` source à la révision cible (via git) : `clia` ne conserve aucun historique interne. Un `downgrade` vers une version non disponible localement est impossible sans action git préalable de l'humain.
- La couche 1 en mode dev couple `clia` à `~/.bashrc` et à bash (Debian 12) : non portable hors de cette cible (choix assumé).
- La distinction inclus/exclus du paquet (D6) doit rester cohérente avec `resource-types.yaml` et les zones ; toute nouvelle catégorie de ressource devra préciser son appartenance au paquet.

## Migration / porte de sortie

Décision révisable si la distribution distante entre dans le périmètre (elle imposerait alors intégrité par signature, `FND-008` section 6) ou si un besoin de `downgrade` hors ligne vers une version arbitraire justifiait un historique interne à `clia`. Les REQ/SPEC de la couche 2 (`PLN-016`, segment 2) préciseront le contrat détaillé ; cet ADR fixe le cadre.

## Références

- `PLN-016-installation-cycle-de-vie-clia` (segment 1, étapes 1.1 et 1.2)
- `ANL-002-setup-installation` (analyse de `setup.sh` de `tda` et recommandations)
- `FND-008-installateurs-packaging` (propriétés d'un installateur robuste, sécurité, versionnage)
- `ADR-004-ressources-livrables` (zones, frontmatter, abolition du manifeste)
- `ADR-005-fonction-scope-harnais` (généricité du harnais)
- `ADR-007-architecture-systeme-augmentation` (trois composants, `clia` déterministe)
- `SPEC-002-cli-clia` et `REQ-002-cli-clia` (interface et exigences de `clia`, à amender au segment 2)
- `REQ-001-convention-cli-bash` (conformité, cohérence dispatch/documentation)
- `PDC-001-determinisme-de-clia`, `PDC-003-separation-methode-domaine-genericite-harnais`
- `CONSTITUTION.md` (Git : responsabilité de l'humain)
