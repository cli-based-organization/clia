# PDC-006 - Source de vérité documentaire unique (anti-duplication)

- **Statut** : accepté
- **Version** : 0.1.0
- **Date** : 2026-07-18

## Énoncé

Toute information a une source de vérité unique ; aucune duplication non synchronisée n'est admise.

## Justification

La duplication est la première cause de dérive : deux copies d'une même information divergent inévitablement. Une source unique (DRY documentaire) garantit la cohérence et réduit le coût de maintenance. Pour la documentation d'un CLI, une source unique générée à la volée évite la dérive entre code et documentation (`REQ-001-F8`, `SPEC-001`).

## Portée

Toute information susceptible d'être dupliquée : documentation de `clia` (source YAML unique), métadonnées de ressources, versions (`.dev/ressources.yaml`), et toute future couche d'échange (ex. export OKF).

## Implications

- Impose une source unique par information, les autres vues étant générées ou dérivées, jamais recopiées.
- Interdit l'aide codée en dur, extraite par plage de lignes, ou dupliquée hors de la source documentaire.
- Impose, pour toute nouvelle couche (ex. frontmatter OKF), de ne pas dupliquer une information déjà portée ailleurs mais de la remplacer ou de la mapper.

## Critères de conformité

- La documentation de `clia` provient d'une source unique (`clia.doc.yaml`), générée à la volée (`REQ-001-F8`).
- Aucune information n'existe en deux copies non synchronisées.

## Tensions

- L'exécution complète de la source de vérité documentaire (`PLN-011`) n'est pas achevée : écart partiel entre le principe et l'implémentation (voir bogue associé).
- Avec une éventuelle adoption OKF (`index.md`/`log.md`) : risque de duplication avec `.dev/ressources.yaml` et les logs, à arbitrer (`ANL-2026-07-18-clia-et-open-knowledge-format`).

## Références

- `REQ-001-convention-cli-bash` (F8), `SPEC-001-convention-cli-bash`, `ADR-004-ressources-livrables`
- `ANL-2026-07-18-principes-de-conception-du-repo` (P6)
