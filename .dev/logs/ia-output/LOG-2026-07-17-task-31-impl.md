---
type: log
task: 31-impl
session-date: 2026-07-17
status: partial
duration: 30 min
---

# Résumé de la tâche

Exécution du plan `PLN-016` (deuxième en-tête `## 31.` de `session.md`, « [implémentation] Exécuter le plan PLN-016 »). Le plan est segmenté avec breakpoint : segment 1 (conception) avant arrêt pour validation humaine, segment 2 (méthodologie + implémentation) après. Sur demande humaine, le segment 1 est exécuté **livrable par livrable**, avec point de contrôle entre chaque.

## Travail effectué

- **Décision de granularité** : exécution livrable par livrable (choix humain via question de clarification) ; ce log couvre le **premier livrable** du segment 1 (étapes 1.1 et 1.2 de `PLN-016`).
- **Fichier créé** : `.dev/adr/ADR-010-clia-setup-commandes-modes-installation.md` (`skl-006`), consolidant les décisions déjà tranchées par la tâche 31 (traitement des objections) :
  - D1 : deux couches (couche 1 outil via `setup.sh` ; couche 2 contenu via `clia setup`) ;
  - D2 : couche 1 calquée sur `setup.sh` de `tda` (dev/permanent/local) corrigée selon les 5 recommandations d'`ANL-002` ;
  - D3 : surface `clia setup <init|upgrade|downgrade>` (abandon de `init/update/rollback`) ;
  - D4 : résolution de la racine cible (`-C <dir>`, sinon racine git du cwd) distincte de `BASH_SOURCE` ;
  - D5 : « pas de git » ; `clia setup` ne modifie que les fichiers d'augmentation ; `downgrade` par re-matérialisation ;
  - D6 : définition du paquet distribuable par zones + `type` (harnais générique inclus, ressources de conception et traces exclues), sans manifeste ;
  - D7 : comparaison de versions par frontmatter, source = arbre `clia` local (l'humain contrôle sa révision via git, hors `clia`).
- **Point de conception tranché** : la sémantique du `downgrade` sans git ni snapshot (réconciliation de la cible vers l'arbre source local, direction comme garde-fou).
- **Question laissée ouverte (non bloquante, consignée dans l'ADR)** : la charge du `git init` pour le livrable « créer un nouveau repo git », `clia setup` ne faisant pas de git ; à trancher dans les REQ/SPEC du segment 2.

## Résultats

- `ADR-010` créé (statut `Proposé`, en attente de validation au point de contrôle).
- Livrables restants du segment 1 avant breakpoint : 1.3 (ADR + REQ + SPEC extension à des scripts externes), 1.4 (type de ressource « interface CLI » : ADR + SKILL + adaptation des harnais).

## Commit message proposé

*Note: Ce message est fourni à titre informatif uniquement. C'est à l'humain de décider s'il doit être commité, rejeté, ou modifié. L'agent n'exécute jamais de git commit.*

```
ADR-010: commandes et modes d'installation de clia (PLN-016, 1.1-1.2)

Documente les décisions tranchées par la tâche 31 : deux couches
(setup.sh pour l'outil, clia setup pour le contenu), surface
clia setup <init|upgrade|downgrade>, pas de git, paquet distribuable
défini par zones + type sans manifeste, comparaison de versions par
frontmatter depuis l'arbre clia local.

Premier livrable du segment 1 de PLN-016 (exécution livrable par livrable).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
```

## Objections de l'agent

Aucune objection bloquante. Une question de conception non bloquante subsiste (charge du `git init`, voir ADR-010), à trancher au segment 2.

## Notes

`session.md` comporte deux en-têtes `## 31.` (traitement des objections, déjà loggé dans `LOG-2026-07-17-task-31.md`, puis implémentation). Le présent log emploie le suffixe `-impl` pour éviter la collision, `session.md` étant en édition humaine uniquement. Statut `partial` : le segment 1 se poursuit après validation d'ADR-010.
