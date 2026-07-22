# PLN-014 - Refonte des ressources livrables : conventions OKF et cycle de vie unifié

**Statut : approuvé**

## Changelog

- **Révision 3 (2026-07-21)** : incorporation de la **tâche 26** de `session.md` (« [résolution des objections] PLN-014 »). L'humain a répondu aux onze objections. Toutes sont **résolues** ; aucune n'est ouverte. Le modèle cible est désormais tranché (voir « Modèle décidé » ci-dessous) : abolition de l'immuabilité et du triple cycle de vie au profit d'une seule catégorie de **ressources livrables vivantes** versionnées, plus des **traces immuables** (logs, sessions) qui ne sont pas des ressources livrables ; zones simplifiées (`.knowledge` abandonné, tout dans `.dev`, `logs` rapatriés dans `.dev`, `doc` inchangé) ; frontmatter remplaçant les puces ; abolition de `ressources.yaml` (version portée par le frontmatter) ; renommage daté vers séquencé avec réparation des références ; première réécriture d'`ADR-004`. Statut passé à **approuvé**. Le breakpoint après le segment 1 est conservé (revue humaine du nouveau modèle avant la migration mécanique de masse).
- **Révision 2 (2026-07-21)** : incorporation de la **tâche 25** (abolir la distinction vivant / point fixe). Élargissement du plan au cycle de vie, ajout des objections 7 à 11.
- **Révision 1 (2026-07-21)** : création (tâche 24, adoption sélective d'OKF).

## Intention

Refondre le modèle des ressources livrables de `clia`, en réunissant trois demandes convergentes de `session.md` (tâches 24, 25, 26) : adopter les conventions clefs d'OKF (zones, frontmatter `type`, références croisées formalisées), abolir la distinction de cycle de vie (toutes les ressources livrables deviennent vivantes), et appliquer les résolutions d'objections de la tâche 26. But : un graphe de ressources uniforme, typé, navigable et versionné par le frontmatter, sans manifeste central, tout en préservant la sémantique déjà plus riche que l'OKF et en protégeant les traces d'audit.

## Contexte

- **Tâches 24, 25, 26 (`session.md`)** : voir l'historique du Changelog. La tâche 26 fournit les décisions humaines qui lèvent toutes les objections et fixent le modèle cible.
- **Analyses de référence** : `ANL-2026-07-18-clia-et-open-knowledge-format` (adoption OKF sélective, remplacement des puces, arbitrage du manifeste) et `ANL-2026-07-21-usage-semantique-ontologie-repos` (expliciter l'ontologie légère tacite : couche type, relations typées et validées, rester léger sans RDF/OWL).
- **État courant du dépôt (2026-07-21)** : environ 140 fichiers markdown (91 `.dev`, 43 `logs`, 2 `doc`, 4 racine) ; seuls les `logs` portent un frontmatter ; les autres ressources portent leurs métadonnées en **puces d'en-tête**. `ADR-004` définit aujourd'hui **trois** cycles (point fixe daté non versionné ; vivant séquencé semver ; travail non versionné), le cycle commandant le nommage et le versionnage, avec un manifeste `.dev/ressources.yaml` et deux ensembles composites atomiques.
- **Chantier humain** : ce plan porte la **première réécriture d'`ADR-004`** (résolution 3).
- **Contraintes de gouvernance** : généricité du harnais (`ADR-005`), interface fichiers (`PDC-004`), source de vérité unique (`PDC-006`), déterminisme de `clia` (`PDC-001`), traçabilité (`PDC-009`) ; l'agent n'édite jamais les fichiers en édition humaine uniquement et n'opère aucune action git.

## Modèle décidé (résolutions de la tâche 26)

- **Cycle de vie unifié.** On abolit la notion de ressource immuable et le triple cycle de vie. Il reste **une seule catégorie de ressources livrables : vivantes** (elles évoluent et portent une version). Concernées : `FND`, `ANL`, `ADR`, `SPEC`, `REQ`, `PDC`, `skl`, `BUG`, `PLN`, et les harnais (`CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`). La catégorie « travail » est abolie (`PLN` devient vivant, résolution 10). (Résolutions 2, 10.)
- **Traces immuables, hors ressources livrables.** Les `logs/ia-output` (traces d'audit horodatées) et les `.dev/sessions/*` (archives de séance) **ne sont pas des ressources livrables** mais des **traces / métadonnées** : elles **demeurent immuables**. (Résolutions 9, 11.)
- **Fichiers en édition humaine uniquement : exemptés.** L'agent ne modifie pas `INTENTION.md`, `.dev/session.md`, `.dev/session-x*.md`, `.dev/sessions/*`. La règle de frontmatter ne leur est pas appliquée par l'agent. (Résolution 1.)
- **Zones.** On abandonne `.knowledge` pour l'instant. Tout va dans `.dev`. Les `logs` sont **rapatriés dans `.dev`**. `doc/` reste à la racine, inchangé. Zones effectives : contenu (`@.`) et développement (`@.dev`). (Résolution 4.)
- **Métadonnées.** Le frontmatter YAML **remplace** les puces d'en-tête (pas de duplication, `PDC-006`). Chaque ressource livrable porte au minimum `type` et `version`. (Résolutions 5, 8.)
- **Versionnage.** Chaque ressource vivante porte sa `version` dans son frontmatter. On **abolit le manifeste `ressources.yaml`** ; il n'y a plus de manifeste ni d'ensembles composites atomiques. (Résolutions 5, 8.)
- **Nommage.** On **renomme** les ressources livrables datées (`FND`, `ANL`) vers un nommage **séquencé** (`FND-<SEQ>-<SLUG>`, `ANL-<SEQ>-<SLUG>`), et on **répare toutes les références**. Les `logs`, traces immuables, conservent leur nommage horodaté (`LOG-<DATE>-task-<NN>`). (Résolution 7.)
- **Références croisées.** Formalisées en liens markdown, réparées après renommage, validables par `clia`. (Tâche 24.)
- **Généricité.** Le vocabulaire de `type` et les zones restent génériques. (Résolution 6.)

## Spécification du livrable

Le livrable **de la tâche 26** est ce plan révisé (statut approuvé). L'**exécution** est une tâche distincte (comme tâche 3 après tâche 2, tâche 11 après tâche 10). Les livrables d'exécution seront : la première réécriture d'`ADR-004`, le vocabulaire de `type`, l'amendement des skills et harnais, la migration de l'existant (frontmatter, renommage, réparation des références, rapatriement des `logs`, abolition de `ressources.yaml`), et une validation `clia`. Aucun de ces livrables n'est produit par la tâche 26 ; ce plan les prépare et les autorise.

## Plan proposé

### Segment 1 : décision et modèle (avant breakpoint)

#### 1. Première réécriture d'`ADR-004`

Réécrire `ADR-004` pour graver le **Modèle décidé** ci-dessus : cycle de vie unifié (une catégorie de ressources livrables vivantes), distinction ressources livrables vs traces immuables (logs, sessions), zones (`@.`, `@.dev`, `doc` inchangé, pas de `.knowledge`), métadonnées en frontmatter, versionnage par frontmatter sans manifeste, nommage séquencé pour les ressources livrables, adoption OKF sélective (frontmatter `type`, liens). Documenter la porte de sortie et les conséquences (notamment sur `clia`, voir note ci-dessous).

#### 2. Vocabulaire du champ `type` et schéma de frontmatter

Définir le vocabulaire contrôlé des valeurs de `type` (mappé sur les préfixes : `plan`, `fondation`, `analyse`, `adr`, `spec`, `requis`, `bug`, `principe`, `skill`, `harnais`, `log`, `session`) et le schéma de frontmatter (`type`, `version`, `title`, `description`, champs de relations, `timestamp` pour les traces). Ce schéma devient la source de vérité de la couche type (la table de `CLAUDE.md` en devient une vue, `PDC-006`).

**BREAKPOINT.** Arrêt après les livrables 1 et 2. L'humain valide le nouveau modèle (`ADR-004` réécrit + schéma de `type`) avant la migration mécanique de masse (frontmatter partout, renommage des `FND`/`ANL`, réparation des références, rapatriement des `logs`, suppression de `ressources.yaml`), opérations difficilement réversibles. Rien du segment 2 n'est produit tant que la reprise n'est pas autorisée.

### Segment 2 : mise en oeuvre (après breakpoint)

#### 3. Frontmatter dans les templates des skills

Amender les templates et critères des skills producteurs (`skl-002`, `skl-003`, `skl-006`, `skl-008`, `skl-009`, `skl-010`, `skl-012`, `skl-013`, `skl-014`, `skl-015`) pour émettre le frontmatter (`type`, `version`, champs réservés) **en remplacement** des puces d'en-tête.

#### 4. Références croisées en liens et validation `clia`

Formaliser les références croisées en liens markdown avec un petit vocabulaire de relations (`specifie`, `derive-de`, `remplace`, `reference`, `produit-par`, `viole`). Prévoir une commande d'inspection `clia` (déterministe, lecture seule) vérifiant l'intégrité référentielle et la cohérence des `type` ; une référence pendante est un bogue (`ADR-003`). La conception ici ; l'implémentation `clia` relève de la réconciliation ultérieure du cli.

#### 5. Migration de l'existant

Appliquer le Modèle décidé aux fichiers existants : ajouter le frontmatter (en remplaçant les puces) à toutes les ressources livrables ; **renommer** les `FND`/`ANL` datées en séquencées et **réparer toutes les références** ; **rapatrier** `logs/ia-output` sous `.dev` ; **supprimer** `.dev/ressources.yaml` ; ajouter le frontmatter `type: log` aux traces sans altérer leur contenu ni leur immuabilité. Exemptions : fichiers en édition humaine uniquement (`INTENTION.md`, sessions) non touchés. Migration vérifiable par la commande du livrable 4.

#### 6. Ajustement des harnais

Mettre à jour `CLAUDE.md` (typologie, nomenclature, section « Versionnage à deux domaines » à réviser vu l'abolition du manifeste, zones), `CONSTITUTION.md` (mentions d'immuabilité), `ARCHITECTURE.md` (zones et cartographie). Chaque ressource vivante porte sa nouvelle `version` dans son frontmatter.

## Note de conséquence sur `clia` (hors périmètre d'exécution de ce plan)

L'abolition de `ressources.yaml` a un impact sur `clia`, qui lit ce manifeste (`clia res ls`, inspection des versions). Conformément à l'ordre de travail décidé (conception, puis méthodologie, puis implémentation, voir tâche 2), ce plan conçoit le nouveau modèle ; la **réconciliation de `clia`** (lecture des versions depuis le frontmatter plutôt que le manifeste) est un chantier d'implémentation ultérieur, distinct. Signalé pour éviter une exécution partielle qui casserait `clia`.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les onze objections soulevées aux révisions 1 et 2 ont été résolues par la tâche 26 de `session.md` :

1. Fichiers en édition humaine uniquement. **Résolue** (résolution 1) : la règle est respectée, ces fichiers ne sont pas modifiés par l'agent (exemptés).
2. Immuabilité des ressources point fixe. **Résolue** (résolution 2) : la notion de ressource immuable est abolie pour les ressources livrables ; elles évoluent et leur structure est modifiée en conséquence.
3. Séquencement vs réécriture d'`ADR-004`. **Résolue** (résolution 3) : ce plan porte la première réécriture d'`ADR-004`.
4. Sous-spécification (zones, références croisées). **Résolue** (résolution 4) : `.knowledge` abandonné, tout dans `.dev`, `logs` rapatriés dans `.dev`, `doc` inchangé.
5. Duplication (`PDC-006`). **Résolue** (résolution 5) : le frontmatter remplace les puces ; `ressources.yaml` est aboli.
6. Généricité (`ADR-005`). **Résolue** (résolution 6) : acceptée, à maintenir sans blocage.
7. Nommage vs cycle de vie. **Résolue** (résolution 7) : renommer les ressources datées en séquencées et réparer les références.
8. Portée du versionnage. **Résolue** (résolution 8) : la version est ajoutée dans le frontmatter ; plus de manifeste.
9. Traces d'audit. **Résolue** (résolution 9) : les logs ne sont pas des livrables mais des traces / métadonnées ; ils demeurent immuables.
10. Catégorie « travail ». **Résolue** (résolution 10) : les `PLN` évoluent, deviennent vivants ; la catégorie « travail » est abolie.
11. Archives de session. **Résolue** (résolution 11) : ne pas toucher aux sessions.

Note de vigilance pour l'exécution (non bloquante) : le renommage de masse des `FND`/`ANL` et la suppression de `ressources.yaml` sont des opérations difficilement réversibles et à fort couplage (références croisées, `clia`). Le breakpoint après la réécriture d'`ADR-004` est maintenu pour permettre une revue humaine avant cette migration.

## Note sur les objections humaines

Les objections et résolutions de l'humain vivent dans `.dev/session.md` (tâches 24, 25, 26), pas dans ce plan.
