# ADR-005 - Fonction, scope et réutilisabilité du harnais

- **Statut** : Accepté
- **Version** : 0.2.0
- **Date** : 2026-07-10
- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `PLN-005`, `PLN-006`, `ANL-2026-07-10-usage-ressources-livrables`, tâches 14, 15 et 18 de `session.md`

## Contexte

La typologie des ressources (PLN-005) posait la question de savoir ce qui doit vivre dans `CONSTITUTION.md`. L'humain a élargi (tâche 15) : le **harnais doit être générique et réutilisable dans n'importe quel dépôt**, sans aucune information de domaine métier ni spécifique au repo. Cet objectif est central. Il faut donc définir précisément ce qu'est le harnais, son scope, et le principe qui garantit sa réutilisabilité.

## Décision (résumé)

> Le harnais se compose de `CLAUDE.md`, `CONSTITUTION.md` et des skills (`skl-*`). Il est **strictement générique** : aucune information de domaine métier ni spécifique au repo. `INTENTION.md`, `session.md` et `sessions/*` n'en font pas partie (ils portent le domaine et sont en édition humaine). Cette généricité est **forcée par une règle présente dans tous les skills** et vérifiée à chaque évolution du harnais (`skl-004`).

## Décisions détaillées

### Composition du harnais

- **Décision** : le harnais = `CLAUDE.md` (mode opératoire), `CONSTITUTION.md` (gouvernance), `skl-*` (skills, apparatus méthodologique). Ces ressources forment l'ensemble versionné `harness-files`.
- *Alternatives écartées* : inclure `INTENTION.md` dans le harnais : rejeté, `INTENTION.md` porte l'intention de domaine du repo et est en édition humaine ; l'y inclure contaminerait la réutilisabilité.

### Principe de réutilisabilité (généricité)

- **Décision** : aucune ressource de harnais ne contient d'information de domaine métier ni spécifique à un repo (noms de clients, sujets, chemins propres au projet, exemples métier). Le harnais doit pouvoir être copié tel quel dans un autre dépôt. Toute illustration dans un skill utilise des exemples neutres ou des placeholders.
- *Alternatives écartées* : tolérer des exemples de domaine « pour la clarté » : rejeté, ils rendent le harnais non transférable.

### Scope respectif des fichiers de harnais

- **Décision** :
  - `INTENTION.md` : le pourquoi de domaine, global et stable (hors harnais, humain-only).
  - `CONSTITUTION.md` : le processus de gouvernance et de décision, générique.
  - `CLAUDE.md` : le mode opératoire concret, générique (règles, conventions, renvois).
  - un **ADR** : une décision structurante datée, y compris sur le harnais lui-même.
  - Ce qui est propre au domaine ne va jamais dans le harnais.

### Le harnais n'inclut pas les documents de conception (précision, tâche 18)

- **Décision** : les documents de conception (`ADR`, `SPEC`, `REQ`, `FND`, `ANL`, `BUG`) ne font **pas** partie du harnais. Le harnais (`CLAUDE.md`, `CONSTITUTION.md`, skills) est une **implémentation** des décisions consignées dans ces documents de conception : il traduit en mode opératoire ce que la conception acte. `clia` (le CLI déterministe) n'est pas non plus une ressource de harnais. Ces trois composants (conception, harnais, `clia`) forment le système d'augmentation par IA, décrit dans `ADR-007-architecture-systeme-augmentation`.
- *Alternatives écartées* : ranger les ADR ou `clia` dans le harnais : rejeté (tâche 18, objection 6), cela confond la source d'une décision avec son implémentation et brouille les frontières du système.

### Enforcement

- **Décision** : chaque skill porte une règle rappelant que, s'il produit ou modifie une ressource de harnais, celle-ci doit rester générique. `skl-004-harnais` et `skl-001-skill-writer` portent cette règle en critère de qualité explicite. `skl-004` vérifie la généricité à chaque évolution du harnais.

## Conséquences

**Positives**
- Le harnais devient un actif réutilisable inter-dépôts (objectif central de l'humain).
- Séparation nette entre apparatus méthodologique (générique) et contenu de domaine (propre au repo).

**Négatives / risques**
- Les exemples des skills perdent en concret (placeholders au lieu de cas réels).
- Une vigilance continue est requise pour ne pas réintroduire du domaine ; d'où la règle dans tous les skills.

## Migration / porte de sortie

Correctif immédiat : l'exemple de `skl-008` cite un nom de domaine (« Commission scolaire de la Capitale-Nationale ») et doit être rendu générique. Toute future violation détectée est corrigée via `skl-004`.

## Références

- `ANL-2026-07-10-usage-ressources-livrables`
- `ADR-004-ressources-livrables` (typologie et versionnage)
- `ADR-007-architecture-systeme-augmentation` (les trois composants du système)
- `PLN-005-typologie-versionnage-ressources`
- `PLN-006-cli-clia`
