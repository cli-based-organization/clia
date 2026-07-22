# PLN-014 - Adoption des conventions clefs de l'Open Knowledge Format (OKF)

**Statut : objection**

## Intention

Adopter dans `clia` les conventions clefs de la spécification Open Knowledge Format (OKF) demandées par la tâche 24 de `session.md` : (1) définir trois **zones** (répertoires) du dépôt, (2) doter **tous les fichiers markdown** d'un en-tête YAML portant un champ `type`, et (3) formaliser **toutes les références croisées** entre documents. Le but est de rendre le graphe de ressources de `clia` uniforme, typé et navigable, donc portable inter-agents et outillable, tout en préservant la sémantique déjà plus riche que l'OKF (typologie `ADR-004`, skills-spécifications, versionnage, validation).

## Contexte

- La tâche 24 (`session.md`) énonce trois zones : zone de contenu du dépôt (défaut `@.`), zone de développement (défaut `@.dev`), zone de base de connaissance (défaut `@.knowledge`) ; et deux éléments OKF : champ `type` dans le frontmatter de tout markdown, et formalisation des références croisées. Les descriptions des zones et la règle de références croisées sont **incomplètes** dans `session.md` (phrases tronquées).
- Cette adoption a déjà été analysée : `ANL-2026-07-18-clia-et-open-knowledge-format` recommande une adoption **sélective** (frontmatter `type` + cross-références en liens markdown), **par étapes vu la v0.1 d'OKF**, **tranchée par un ADR lié à `ADR-004`**, en **remplaçant** les puces d'en-tête (pas en les doublant, pour respecter `PDC-006`), et en **arbitrant** le recouvrement `ressources.yaml`/`logs` vs `index.md`/`log.md`.
- `ANL-2026-07-21-usage-semantique-ontologie-repos` (tâche 23) fonde conceptuellement l'opération : la typologie de ressources de `clia` est déjà une **ontologie légère de facto mais tacite** ; l'expliciter (couche type machine-lisible, relations typées et validées, frontmatter `type` uniforme) en restant léger (pas de RDF/OWL) est précisément l'objet de cette adoption.
- État courant du dépôt (2026-07-21) : environ 140 fichiers markdown (91 dans `.dev`, 43 dans `logs`, 2 dans `doc`, 4 à la racine) ; seuls les `logs` portent un frontmatter ; toutes les autres ressources portent leurs métadonnées en **puces d'en-tête**. La zone `.knowledge` **n'existe pas**. Des fichiers sont en **édition humaine uniquement** (`INTENTION.md`, `.dev/session.md`, `.dev/session-x*.md`, `.dev/sessions/*`) et des ressources sont **point fixe / immuables** (`FND`, `ANL`, `logs`, `sessions` : voir `ADR-004`).
- Chantier humain connexe déjà prévu : la **réécriture d'`ADR-004`** (recadrage humain « Ressources livrables »), à laquelle cette adoption est directement liée.
- Contraintes de gouvernance : généricité du harnais (`ADR-005`, aucun contenu de domaine), interface fichiers (`PDC-004`), source de vérité unique (`PDC-006`), déterminisme de `clia` (`PDC-001`), l'agent n'édite jamais les fichiers en édition humaine uniquement, et n'opère aucune action git.

## Spécification du livrable

Le livrable de cette tâche est **ce plan** (une tâche de planification produit un plan, voir `CLAUDE.md`). Le plan décrit l'intervention proposée pour une exécution ultérieure séparée. Les livrables de l'exécution (à produire seulement après approbation et levée des objections) seront : un ADR de décision, un vocabulaire de `type` (couche type), l'amendement des skills et templates, une commande de validation `clia`, et une migration cadrée de l'existant, le tout versionné atomiquement (`.dev/ressources.yaml`). Aucun de ces livrables n'est produit par le présent plan.

## Plan proposé

### Segment 1 : décision et modèle (avant breakpoint)

#### 1. ADR de décision : zones et adoption sélective d'OKF

Produire un ADR (lié à `ADR-004`) qui tranche :

- les **trois zones** et leur sémantique générique : contenu du dépôt (`@.`, artefacts livrés d'intérêt métier), développement (`@.dev`, ressources du système d'augmentation et de travail), base de connaissance (`@.knowledge`, savoir réutilisable). Statuer explicitement sur le sort de `logs/` et de `doc/`, et sur la relation entre `@.knowledge` et les `FND`/`ANL` actuellement dans `@.dev/fondations` et `@.dev/analyses` (déplacement, alias, ou statu quo). Défauts paramétrables pour préserver la généricité (`ADR-005`).
- l'**adoption sélective** d'OKF : frontmatter YAML avec `type` sur les ressources produites par l'agent, cross-références en liens markdown, **en couche d'interopérabilité par-dessus** le modèle `clia` (pas en remplacement de sa sémantique). Différer les conventions OKF non stabilisées (interop sémantique, `index.md`/`log.md`).
- l'arbitrage du recouvrement `ressources.yaml`/`logs` vs `index.md`/`log.md` (recommandation : conserver le manifeste et les logs, mapper vers OKF à l'export).

#### 2. Vocabulaire du champ `type` (couche type explicite)

Définir le vocabulaire contrôlé des valeurs de `type`, mappé sur la typologie `ADR-004` et les préfixes (`plan`, `fondation`, `analyse`, `adr`, `spec`, `requis`, `bug`, `principe`, `skill`, `log`, `session`, `harnais`, ...), plus les champs réservés utiles (`title`, `description`, `tags`, `timestamp`). En faire une **source de vérité unique et lisible par la machine** (extension de `.dev/ressources.yaml` ou schéma dédié), la table de `CLAUDE.md` devenant une vue et non une source parallèle (`PDC-006`). Ceci matérialise la « couche type explicite » recommandée par `ANL-2026-07-21`.

**BREAKPOINT.** Arrêt après les livrables 1 et 2. L'humain valide la décision (zones, périmètre d'adoption, vocabulaire de `type`, sort des fichiers humain-only et immuables) avant toute modification des skills et toute migration. Rien du segment 2 n'est produit tant que la reprise n'est pas autorisée.

### Segment 2 : mise en oeuvre (après breakpoint et levée des objections)

#### 3. Frontmatter dans les templates des skills

Amender les templates et critères des skills producteurs (`skl-002`, `skl-003`, `skl-006`, `skl-009`, `skl-010`, `skl-012`, `skl-013`, `skl-014`, `skl-015`, `skl-008`) pour émettre le frontmatter OKF (`type` + champs réservés) **en remplacement** des puces d'en-tête, sans duplication (`PDC-006`).

#### 4. Références croisées en liens markdown et validation

Formaliser les références croisées (`ADR-005`, `PDC-006`, ...) en liens markdown, avec un petit vocabulaire de relations explicite (par exemple `specifie`, `derive-de`, `remplace`, `reference`, `produit-par`, `viole`). Ajouter une commande d'inspection `clia` (déterministe, lecture seule) qui vérifie l'intégrité référentielle et la cohérence des `type` ; une référence pendante devient un bogue (`ADR-003`).

#### 5. Migration cadrée de l'existant

Migrer les ressources existantes vers le frontmatter, selon des règles d'exemption strictes (voir objections) : exclusion des fichiers en édition humaine uniquement, traitement explicite des ressources point fixe sous la tolérance « phase de conception » d'`ADR-004` ou report. Migration mécanique, vérifiable par la commande du livrable 4.

#### 6. Ajustement des harnais et versionnage atomique

Mettre à jour `CLAUDE.md` (conventions transverses, zones), `ARCHITECTURE.md` (cartographie des zones), et `.dev/ressources.yaml` (bumps atomiques membres + ensembles). Réconcilier avec la réécriture d'`ADR-004` selon la séquence décidée par l'humain.

## Objections de l'agent IA

1. **Fichiers en édition humaine uniquement.** La règle « tous les fichiers markdown ont un header YAML avec `type` » est **inapplicable par l'agent** à `INTENTION.md`, `.dev/session.md`, `.dev/session-x*.md` et `.dev/sessions/*` : la `CONSTITUTION.md` interdit à l'agent de les modifier. Si ce plan est exécuté tel quel, soit l'agent enfreint les droits d'édition, soit ces fichiers restent non conformes. Neutralisation requise : soit l'humain applique le frontmatter à ces fichiers (ou via `clia`, opéré par l'humain), soit l'ADR les exempte explicitement. À trancher dans `session.md`.

2. **Immuabilité des ressources point fixe.** Ajouter un frontmatter aux `FND`, `ANL`, `logs` et `sessions` déjà produits est une **modification en place de ressources immuables** (`ADR-004`). C'est toléré « en phase de conception » mais interdit ensuite. Si le plan migre ces ressources sans décision explicite, il viole l'immuabilité ou crée un précédent. Neutralisation : l'ADR autorise explicitement une migration unique en phase de conception, ou exempte le point fixe et n'applique le frontmatter qu'aux ressources futures.

3. **Séquencement vs réécriture d'`ADR-004`.** L'`ANL` OKF rattache l'impact de l'adoption à la **réécriture d'`ADR-004`** (recadrage humain à venir). Exécuter l'adoption OKF avant cette réécriture risque de produire un ADR et une migration à refaire si la réécriture change la typologie ou les zones. Neutralisation : décider l'ordre (adoption d'abord et `ADR-004` s'y conforme, ou l'inverse). Le breakpoint est placé pour laisser ce choix à l'humain.

4. **Sous-spécification de la tâche.** Les descriptions des zones (`@.dev` « Contient les éléments », `@.knowledge`) et la règle « Toutes les références croisées entre documents » sont **tronquées** dans `session.md`. La sémantique de `@.knowledge` face aux `FND`/`ANL` (qui sont du savoir mais vivent dans `@.dev`) et face à `doc/` n'est pas définie. Exécuter sans clarifier risque un découpage de zones erroné. Neutralisation : préciser en `session.md` le contenu attendu de chaque zone et l'intention exacte de la règle de références croisées.

5. **Risque de duplication (`PDC-006`).** Si le frontmatter `type` s'ajoute **par-dessus** les puces d'en-tête existantes plutôt que de les remplacer, ou si l'on adopte `index.md`/`log.md` d'OKF en doublon de `ressources.yaml`/`logs`, on crée une double source de vérité contraire à `PDC-006`. Le plan prévoit le remplacement et le mapping, mais l'exécution devra le vérifier ressource par ressource.

6. **Généricité du harnais (`ADR-005`).** Les défauts de zones (`.`, `.dev`, `.knowledge`) et le vocabulaire de `type` doivent rester **génériques** (aucun type ni chemin propre à un domaine métier). Risque faible mais à surveiller : ne pas coder en dur des zones ou types spécifiques au présent dépôt.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
