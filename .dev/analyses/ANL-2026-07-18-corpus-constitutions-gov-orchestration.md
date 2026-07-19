# ANL-2026-07-18 - Corpus des CONSTITUTION.md : axe gouvernance / orchestration / hybride

- **Date** : 2026-07-18
- **Périmètre** : tous les fichiers `CONSTITUTION.md` trouvés sous `/home/jvtrudel/git` (racine `@../..` depuis `clia`), hors `.git/`. 32 fichiers repérés, dédupliqués par empreinte de contenu en 17 variantes distinctes (dont un fichier vide).
- **Référence** : `FND-2026-07-18-documents-harness-ia` et `ANL-2026-07-18-critique-constitution` (distinction gouvernance / orchestration de processus / hybride).

## Objet

Classer le contenu des `CONSTITUTION.md` de l'écosystème sur l'axe **gouvernance** (acteurs, responsabilités, droits d'édition, interdits, principes non négociables) vs **orchestration de processus** (phases, états, transitions, cycle, points de contrôle) vs **hybride** (les deux mêlés). Objectif : situer la constitution de `clia` dans son écosystème et vérifier si le mélange relevé en `ANL-2026-07-18-critique-constitution` est une norme ou une exception.

## Périmètre et méthode

Corpus recensé par `find … -name CONSTITUTION.md`, puis regroupé par empreinte `md5` pour ne lire qu'un représentant de chaque variante (17 groupes). Grille d'analyse à trois valeurs, dérivée de la référence :

- **G - Gouvernance** : qui peut faire quoi, droits/interdits, autorité, principes non négociables.
- **O - Orchestration** : déroulé du travail (états, cycle, transitions, artefacts, points de contrôle).
- **H - Hybride** : porte les deux couches à la fois.

Chaque famille est localisée par un chemin représentatif et son nombre d'occurrences.

## Inventaire et classement

**Famille 1 - « Règles impératives C1..Cn » (propriété / interdits) : GOUVERNANCE pure.** La plus répandue. Contenu type : autorité et préséance du document, puis interdits numérotés (l'IA ne modifie jamais `ticket.md`/`issue.md`, les harness-files sont source de vérité, les primitives CLI ne sont mutées que par l'outil, `.claude/` est effaçable). Aucun cycle ni état de processus.
- 9 occurrences (en-tête « C1..C5 ») : `noumanity-dev/ticket-driven-ai`, `cryptosecops/{communications,conf-hackfest-2026,pqc-domain,veille}`, `noumanity-ops/{planification,communication,pdg-augmenté}`, `parti-horizon/fondation`.
- 4 occurrences (« C1+C2 » court) : `noumanity-dev/cli-convention`, `cli-based-organization/linux-inspect`, `archive/cli-based-organisation_git-resource`, `noumanity-talents/jvtrudel-cv`.
- 2 occurrences (« C1 détaillé, pourquoi/portée ») : `noumanity-formation/linux-pqc/.dev`, `nou-methodologies-ia/…/deeptech-ticket-driven`.
- 2 occurrences (« article unique : NE MODIFIER `tool/` ») : `nou-scripts-ia-support`, `poc-formulaire-offline-first` (racine).
Verdict : **G**. Ce sont des constitutions au sens strict du field (principes/interdits non négociables), à préoccupation unique.

**Famille 2 - « Objection-sociocratique / cycle de vie d'un plan » : ORCHESTRATION (dominante).** Contenu : principe objection-sociocratique, **cycle de vie d'un plan** (`proposé → objection → résolu → approuvé → exécuté`), définition de l'objection, canaux (hybride), règle absolue de non-exécution.
- 3 occurrences : `noumanity-formation/{intentional-doers-governance,linux-and-quantum-computers}`, `ontpe/dossier-president`.
Verdict : **O** majoritaire, avec la section « Canaux d'objections » en **H** (imputabilité + lieu de processus).

**Famille 3 - « clia complète » : HYBRIDE (gouvernance + orchestration entrelacées).** Superpose la Famille 2 (cycle, objection, règle absolue) et des sections de gouvernance : classification des documents / droits d'édition (G), interface fichiers (principe), gardien déterministe `clia` (G), responsabilité git (G).
- 4 occurrences : `cli-based-organization/clia` (129 lignes, ajoute le breakpoint), `noumanity-consultation/{desjardins-devsecops,commission-scolaire-de-la-capitale}` (117 lignes), `noumanity-consultation/LGS` (106 lignes).
Verdict : **H**. C'est exactement le mélange gouvernance/orchestration relevé dans `ANL-2026-07-18-critique-constitution`.

**Famille 4 - « Constitution de projet à principes » : HYBRIDE bien séparée (exemplaire).** `disruptiva-dev/personal-journal` (115 lignes). Sépare explicitement trois blocs : **Principes** non négociables (tests, local-first, hexagonal, secrets, opérations destructrices → G), **Prise de décision** (matrice « qui décide / processus / où enregistré », proche RACI → G/O), **Amendements** (méta-processus de révision de la constitution → O). Contient aussi une règle de résolution des conflits entre principes.
Verdict : **H**, mais avec les couches **structurellement distinctes** — le contre-modèle de la Famille 3.

**Famille 5 - « Constitution d'architecture / ontologie » : genre distinct.** `disruptiva-dev/comm-cli` (230 lignes) et son ébauche `nou-methodologies-ia/…/resource-centric+tooling` (10 lignes). Ne gouverne pas des acteurs ni un cycle de plan : énonce la structure conceptuelle d'un système (centralité de la donnée, hiérarchie Organisation→Campagne→Action, tripartition **Stratégie/Style/Contenu**, héritage, multi-acteurs, validation, déterminisme, neutralité d'interface, traçabilité).
Verdict : hors-axe strict (principes de **conception**), mais notable : ce document **internalise la séparation des préoccupations** (la tripartition Pourquoi/Comment/Quoi), la discipline même qui manque à la Famille 3.

**Famille 6 - « Guide de contribution » : HYBRIDE léger, orienté humain.** `IPV-001` (95 lignes). Valeurs pragmatiques (opérationnel d'abord, valider sur le terrain, documenter, itérer → G) + processus avant/pendant/après contribution (→ O) + critères de succès.
Verdict : **H** léger, tourné vers la contribution humaine plus que vers la gouvernance d'un agent.

**Famille 7 - Variantes mineures et dérives.**
- `cryptosecops/stratégie` (31 lignes) : C1 `ticket.md` + C3 harness (G) + C2 « relire le ticket si son hash a changé » (facette O). → **H** léger.
- `cryptosecops/noumanity+qguard/.dev` (50 lignes) : C1 `ticket.md` (G) + C2 « toute tâche exécutée produit un artefact ; la réexécution produit un nouvel artefact » (obligation de processus + traçabilité → O). → **H**.
- `archive/jvtrudel-cv` (11 lignes) : ébauche (frontmatter + une phrase). → stub.
- `disruptiva-dev/disks-management` : **fichier vide**. → dérive.

## Constats transverses

**C1. La gouvernance pure domine l'écosystème.** ~17 fichiers sur 32 (Famille 1) sont des constitutions à préoccupation unique de gouvernance (interdits, propriété, autorité), conformes au sens que le field donne au mot « constitution » (`FND-2026-07-18-documents-harness-ia`, §3c). Le mélange gouvernance/orchestration **n'est pas la norme** de l'écosystème.

**C2. Le mélange gouvernance/orchestration est concentré dans une seule lignée.** Il se limite à la Famille 3 (`clia`, `LGS`, `desjardins`, `commission-scolaire`), quatre fichiers d'une même filiation. Le diagnostic de `ANL-2026-07-18-critique-constitution` se confirme donc à l'échelle du corpus : c'est un anti-motif **local**, pas une pratique générale.

**C3. L'orchestration pure existe aussi séparément.** La Famille 2 (3 fichiers) porte le cycle de vie du plan **sans** gouvernance d'acteurs : preuve que les deux couches peuvent vivre dans des documents distincts. C'est l'état vers lequel un refactor de la Famille 3 tendrait.

**C4. Un exemplaire de bonne séparation existe déjà dans l'écosystème.** `personal-journal` (Famille 4) sépare structurellement Principes / Prise de décision / Amendements ; `comm-cli` (Famille 5) internalise une tripartition Pourquoi/Comment/Quoi. Ces deux documents montrent, dans le même dépôt-parent, comment tenir les couches distinctes — modèles utiles pour le recadrage de `CONSTITUTION.md` de `clia`.

**C5. Hétérogénéité et dérives.** Le corpus mêle plusieurs genres sous un même nom de fichier (règles d'agent, cycle de plan, principes d'ingénierie, ontologie de système, guide de contribution), plus des stubs et un fichier vide. Le mot « CONSTITUTION.md » recouvre donc des réalités très différentes selon les dépôts ; l'axe gouvernance/orchestration ne suffit pas seul à les ranger (une quatrième catégorie « principes d'architecture/ontologie » émerge, Famille 5).

## Synthèse et recommandations

**Constat central** : sur l'axe demandé, l'écosystème se répartit ainsi — **gouvernance pure** largement majoritaire (Famille 1, ~17 fichiers), **orchestration** isolée (Famille 2, 3 fichiers), **hybride** minoritaire et de deux sortes (Famille 3 entrelacée et mal séparée ; Famille 4 bien séparée), plus un genre **architecture/ontologie** distinct (Famille 5) et des dérives. Le mélange problématique de `clia` est une **exception de lignée**, pas la règle.

Recommandations (à l'intention du recadrage de `CONSTITUTION.md` de `clia`, tâche humaine « [Recadrage humain] CONSTITUTION.md ») :

1. **Aligner la lignée `clia` (Famille 3) sur la gouvernance pure de la Famille 1** en extrayant l'orchestration (cycle de plan, objection, règle absolue, breakpoint) vers un document dédié, comme le recommande déjà `ANL-2026-07-18-critique-constitution`. Le corpus confirme que c'est le sens majoritaire du terme.
2. **S'inspirer de `personal-journal`** (Famille 4) pour la structure cible : blocs séparés Principes / Décision-Responsabilités / Amendements, chacun mono-couche.
3. **Réutiliser la discipline de tripartition de `comm-cli`** (Pourquoi/Comment/Quoi) comme heuristique générale de séparation des préoccupations dans le harnais.
4. **Traiter les dérives** (fichier vide `disks-management`, stubs) hors de ce périmètre : elles relèvent d'une hygiène de dépôt, pas de l'axe analysé.

Ces recommandations ne modifient rien : elles documentent où se situe `clia` dans son écosystème et confirment la direction du refactor déjà proposé.

## Portée et péremption

Couverture : les 32 `CONSTITUTION.md` présents sous `/home/jvtrudel/git` au 2026-07-18, lus par déduplication (un représentant par variante de contenu ; les variantes internes mineures d'une même famille ne sont pas toutes détaillées). Limites : l'analyse classe le **contenu** sur l'axe demandé, sans juger la qualité de chaque constitution ni son adéquation à son dépôt ; les dépôts hors `/home/jvtrudel/git` ne sont pas couverts. Péremption : ces fichiers sont vivants ; tout amendement (dont le recadrage de `clia`) rend cet état des lieux caduc.
