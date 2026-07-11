# ADR-004 - Ressources livrables : axes, typologie et versionnage

- **Statut** : Accepté
- **Version** : 0.1.0
- **Date** : 2026-07-10
- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `PLN-005`, `ANL-2026-07-10-usage-ressources-livrables`, tâches 12, 14, 15 de `session.md`

## Contexte

Le dépôt produit divers documents (plans, ADR, fondations, analyses, logs, skills, spécifications, requis, bogues). Il faut une compréhension partagée de ce qu'est une ressource livrable, selon quels axes on la classe, et comment on la versionne, y compris de façon atomique pour les ensembles.

## Décision (résumé)

> Une **ressource livrable** est un document ou fichier versionné produit dans le dépôt, source de vérité (par opposition aux échanges conversationnels). On la classe selon **six axes** (dont le cycle de vie). Le **cycle de vie** commande le nommage et le versionnage : les ressources « point fixe » sont datées et non versionnées, les ressources « vivantes » sont séquencées et versionnées en semver, les ressources « de travail » ne sont pas versionnées. Deux ensembles portent une version composite atomique, suivie dans `.dev/ressources.yaml`.

## Décisions détaillées

### Vocabulaire

- **Décision** : *ressource* = tout fichier livrable versionné du dépôt ; *livrable* = ressource produite en réponse à une demande ; *document* = livrable au format texte/markdown. Termes employés comme synonymes usuels, la ressource étant le terme générique.

### Axes d'analyse

- **Décision** : six axes (voir `ANL-2026-07-10-usage-ressources-livrables`) :
  1. cycle de vie (point fixe / vivant / travail) ;
  2. droits d'édition / permissions et rôles (humain-only / IA-only / co-édition) ;
  3. fonction (gouvernance, conception, recherche, analyse, trace-audit, suivi de bogue, intention, diffusion) ;
  4. appartenance au harnais (harnais générique vs propre au repo) ;
  5. nommage (fixe / séquencé / daté) ;
  6. producteur (humain / agent / co).

### Typologie par cycle de vie

- **Point fixe** : produit une fois, non modifié. `FND`, `ANL`, `logs`, `publications/*`, `sessions/*`. Pas de semver.
- **Vivant** : évolue et mûrit ; versionné en semver. `ADR`, `SPEC`, `REQ`, `skl`, `BUG`, base de code, `CLAUDE.md`, `CONSTITUTION.md`.
- **Travail** : cycle court, sans version. `PLN` (un `Changelog` en tête suffit).

### Nommage

- **Décision** :
  - ressources **point fixe** (datées) : `<PREFIX>-<DATE[-HEURE]>-<SLUG>.<EXT>` ; l'heure (`HHMMSS`) est ajoutée uniquement si un même préfixe, une même date et un même slug risquent de collisionner. Exemple : `FND-2026-07-10-conventions-cli.md`. Les logs suivent `LOG-<DATE>-task-<NN>.md`.
  - ressources **vivantes** et **de travail** (séquencées) : `<PREFIX>-<SEQ>-<SLUG>.md`.
  - **harnais** : noms fixes (`CLAUDE.md`, `CONSTITUTION.md`) ; skills en `.dev/skills/skl-<SEQ>-<nom>/SKILL.md`.

### Versionnage atomique

- **Décision** :
  - chaque ressource vivante porte sa version (`version: X.Y.Z`) ; règles semver : MAJEUR = changement incompatible du sens/contrat, MINEUR = ajout rétrocompatible, CORRECTIF = clarification sans effet sémantique.
  - **deux ensembles** portent une version composite : `harness-files` (`CLAUDE.md`, `CONSTITUTION.md`, `skl-*`) et `documents-de-conception` (`ADR-*`, `SPEC-*`, `REQ-*`).
  - **atomicité** : modifier un membre vivant bumpe, dans la même opération, la version du membre et celle de son ensemble, avec mise à jour de `.dev/ressources.yaml`.
  - `BUG-*` est vivant mais hors des deux ensembles : versionné individuellement dans le manifeste.
  - `INTENTION.md` est hors harnais et hors versionnage géré par l'agent (édition humaine).
  - versionnage **piloté par fichiers** (frontmatter + manifeste), jamais par tags git.
  - version initiale : **`0.1.0`** (phase de conception).
- *Alternatives écartées* : versionnage par tags git (rejeté : l'agent n'opère pas git, l'interface est fichiers) ; plus de deux ensembles (rejeté par l'humain, tâche 14).

### Cas `publications/*`

- **Décision** : `publications/*` (documents diffusés) sont des ressources **point fixe** datées, produites une fois. Le répertoire sera créé au premier document publié. Documenté ici car attendu prochainement (tâche 14, réponse agent-6).

### Immuabilité et écarts de conception

- **Décision** : une ressource point fixe ne se modifie pas ; un changement produit une nouvelle instance datée. Exception ponctuelle : en **phase de conception**, des corrections en place de ressources point fixe (ex. renommage des logs et fondations existants, retrait des tirets cadratins à la tâche 7) sont **tolérées** le temps d'établir les conventions (tâche 14, réponse agent-5). Passé cette phase, la règle d'immuabilité s'applique strictement.

## Conséquences

**Positives**
- Classement multi-axes clair ; nommage et versionnage déterministes ; état des versions centralisé dans un manifeste.

**Négatives / risques**
- Discipline requise pour bumper atomiquement membre + ensemble à chaque modification.
- Migration ponctuelle des ressources existantes (renommages, manifeste).

## Migration / porte de sortie

Migration exécutée avec ce plan (PLN-005) : renommage des `FND`, `ANL` et logs, création de `.dev/ressources.yaml`. Un ADR ultérieur pourra affiner les axes ou les ensembles si l'usage l'exige.

## Références

- `ANL-2026-07-10-usage-ressources-livrables`
- `ADR-005-fonction-scope-harnais`
- `.dev/ressources.yaml`
- `PLN-005-typologie-versionnage-ressources`
