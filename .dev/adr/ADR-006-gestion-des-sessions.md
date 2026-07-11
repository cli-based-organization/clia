# ADR-006 - Gestion du cycle de vie des sessions

- **Statut** : Accepté
- **Version** : 0.1.0
- **Date** : 2026-07-10
- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `PLN-006`, tâche 18 de `session.md` (objections 1, 2, 5)

## Contexte

Le point d'entrée de l'humain est un fichier session (`session.md`). Le dépôt a besoin d'un modèle de cycle de vie pour ces sessions : comment on prépare une session à l'avance, comment on l'active, comment on l'archive, et quel invariant garantit qu'on ne travaille que dans une seule à la fois. Ce modèle est ce que `clia ses *` automatise.

## Décision (résumé)

> Une session traverse trois états : **en planification** (`.dev/session-x<YZ>.md`, plusieurs permises), **active** (`.dev/session.md`, une seule, invariant global), **archivée** (`.dev/sessions/SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md`, point fixe daté). À chaque transition, le fichier est **déplacé et renommé**. La date et l'heure d'ouverture sont inscrites dans l'en-tête à l'ouverture ; la date et l'heure de fermeture, à la fermeture. Ces transitions sont opérées exclusivement par `clia` (déterministe, `ADR-007`).

## Décisions détaillées

### Trois états, un invariant

- **Décision** :
  - **En planification** : `.dev/session-x<YZ>.md`, `YZ` sur deux chiffres, séquentiel (+1 à partir de la plus élevée). Zéro, une ou plusieurs peuvent coexister. Ce sont des brouillons de session à venir.
  - **Active** : `.dev/session.md`. **Une seule** session active à la fois (invariant global, tous espaces confondus).
  - **Archivée** : `.dev/sessions/SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md`. Point fixe daté (`ADR-004`), non modifiée après archivage.
- *Alternatives écartées* : sessions actives parallèles indexées `x` : rejeté (tâche 18, objection 2), une seule session active garantit un contexte de travail non ambigu.

### Transitions

- **Décision** : chaque transition **déplace et renomme** le fichier (pas de copie laissant un doublon).
  - `plan` : template -> `.dev/session-x<YZ>.md`.
  - `open [x<SEQ>]` : `.dev/session-x<SEQ>.md` (ou le template si aucun `x<SEQ>`) -> `.dev/session.md`. Échoue si une session est déjà active.
  - `close` : `.dev/session.md` -> `.dev/sessions/SES-<DATE>-<HEURE>-<SLUG>.md`.
  - `new [x<SEQ>]` : `close` (si actif) puis `open [x<SEQ>]`.

### Horodatage

- **Décision** : à l'ouverture, `clia` inscrit dans l'en-tête (frontmatter) la date et l'heure d'ouverture (`start-at`, ISO 8601 avec fuseau). À la fermeture, il inscrit la date et l'heure de fermeture (`end-at`). L'heure d'ouverture sert aussi au nommage de l'archive.
- *Alternatives écartées* : dériver l'heure du système de fichiers (mtime) : rejeté, non fiable après copie ou commit.

### Nommage de l'archive

- **Décision** : `SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md`. `DATE` = date d'ouverture (`AAAA-MM-JJ`), `HEURE_OUVERTURE` = `HHMMSS`, `SLUG` dérivé du titre de l'Intention (ou fourni en argument à `clia ses close`). Cohérent avec le nommage point fixe daté d'`ADR-004`.

## Conséquences

**Positives**
- Invariant clair (une session active) ; brouillons de sessions possibles sans polluer l'espace actif ; archives datées immuables et traçables.

**Négatives / risques**
- `clia` doit gérer proprement les cas limites (ouverture alors qu'une session est active, fermeture sans session active, collision de nom d'archive).

## Migration / porte de sortie

Premier jet. Le répertoire `.dev/sessions/` existe déjà (vide). Le format d'en-tête pourra s'enrichir (ex. auteur, tags) sans casser l'invariant.

## Références

- `ADR-004-ressources-livrables` (nommage point fixe daté)
- `ADR-007-architecture-systeme-augmentation` (rôle déterministe de `clia`)
- `SPEC-003-format-markdown-clia-session` (format vérifiable)
- `SPEC-002-cli-clia` (commandes `ses`)
- `PLN-006-cli-clia`
