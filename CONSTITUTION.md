---
type: harnais
version: 0.1.0
title: "CONSTITUTION"
---

# CONSTITUTION

> Processus de gouvernance entre l'humain et l'agent IA dans ce dépôt. Fichier de harnais, vivant, sujet à évolution (voir `skl-004-harnais`).

## Principe

La gouvernance suit un modèle **objection-sociocratique** :

- l'humain soumet un problème (via `session.md`, point d'entrée unique) ;
- l'agent propose une intervention sous forme d'un **plan** (`PLN-<SEQ>-<SLUG>.md`) ;
- avant toute exécution, des **objections raisonnées** peuvent être émises ;
- l'agent ne peut pas exécuter le plan tant que des objections restent **non résolues**.

## Cycle de vie d'un plan

```
proposé -> objection -> résolu -> approuvé -> exécuté
```

- **proposé** : le plan existe, aucune objection n'a encore été traitée.
- **objection** : au moins une objection (humaine ou agent) est ouverte.
- **résolu** : toutes les objections ont reçu une réponse (levée, amendement, ou argumentation acceptée).
- **approuvé** : plus aucune objection ouverte ; l'exécution est autorisée.
- **exécuté** : les livrables prévus par le plan ont été produits.

Le champ **Statut** en tête du fichier de plan reflète l'état courant du cycle.

## Objection raisonnée

Une objection est un **risque concret** identifié dans le plan proposé, pas une simple préférence esthétique. Elle doit pouvoir s'énoncer comme : « si ce plan est exécuté tel quel, [conséquence identifiable] va se produire ou est susceptible de se produire ».

Une objection est levée par :
- un amendement du plan qui neutralise le risque identifié, ou
- une argumentation qui convainc l'objecteur que le risque n'est pas réel ou est acceptable.

## Canaux d'objections (séparés)

| Origine | Consignée dans |
|---|---|
| Humain | `.dev/session.md` |
| Agent IA | le plan concerné (section « Objections de l'agent IA ») |

L'agent a l'obligation de soulever ses propres objections dans le plan qu'il propose : il ne se contente pas d'exécuter une demande à la lettre s'il y voit un risque.

## Règle absolue

Aucune exécution d'un plan tant qu'une objection (humaine ou agent) reste ouverte.

## Breakpoint et exécution segmentée

Un plan peut prévoir un ou plusieurs **breakpoints** : des points d'arrêt déclarés qui suspendent l'exécution après un livrable donné, le temps que l'humain consulte le résultat et décide de la suite (poursuivre, amender, réorienter). Un breakpoint découpe le plan en **segments** exécutés successivement.

L'exécution segmentée articule le breakpoint avec la règle absolue par une **approbation partielle** :

- la règle « aucune exécution sous objection ouverte » s'applique **segment par segment** : un segment dont toutes les objections sont résolues est approuvé et exécutable ;
- une objection peut être **différée** à un segment ultérieur ; elle reste alors **ouverte** et bloque **son** segment, mais **pas** les segments antérieurs déjà approuvés ;
- arrivé au breakpoint, l'agent **s'arrête** et ne produit aucun livrable des segments suivants tant que l'humain n'a pas autorisé la reprise.

Le breakpoint, le découpage en segments et le report éventuel d'objections sont consignés dans le plan ; les décisions de l'humain qui les motivent vivent dans `.dev/session.md`.

## Classification des documents

Tous les documents du dépôt appartiennent à l'une des trois catégories suivantes, qui régissent les droits d'édition :

Ce classement par droits d'édition est l'un des axes d'analyse des ressources. Les autres axes (cycle de vie, fonction, appartenance au harnais) et le mécanisme de versionnage sont définis dans `ADR-004-ressources-livrables`. La fonction, le scope et le principe de réutilisabilité du harnais (aucune information de domaine) sont définis dans `ADR-005-fonction-scope-harnais`.

### Édition par humain uniquement

L'agent IA peut lire, commenter et faire des suggestions, mais **ne doit jamais modifier** ces documents.

- `INTENTION.md` : l'intention globale du dépôt (le « pourquoi » de haut niveau)
- `.dev/session.md` : point d'entrée des demandes humaines
- `.dev/sessions/*.md` : transcriptions des séances passées

Ces documents sont le reflet de l'intention humaine et de la conversation. L'agent n'y a aucun droit d'écriture.

### Édition par IA uniquement

L'humain peut lire et commenter, mais ces documents sont produits et maintenus exclusivement par l'agent IA selon les spécifications du harnais.

- `.dev/plans/PLN-*.md` : plans de travail proposés par l'agent
- `.dev/fondations/FND-*.md` : recherches de fondation
- `.dev/adr/ADR-*.md` : décisions d'architecture
- `.dev/logs/ia-output/*.md` : logs des réponses de l'agent

Cas particulier : les **objections de l'agent** (section dans les fichiers `PLN-*.md`) sont générées par l'agent, mais peuvent être discutées ou contestées par l'humain via `session.md`.

### Co-édition humain et IA

L'humain et l'agent peuvent tous deux modifier ces documents selon leur rôle dans le cycle.

- `CLAUDE.md` : mode opératoire (peut évoluer suite à feedback)
- `CONSTITUTION.md` : processus de gouvernance (peut évoluer suite à feedback)
- `.dev/skills/skl-*/SKILL.md` : spécifications des skills
- `doc/` : documentation utilisateur et de design

**Principe général pour la co-édition :** l'humain propose des amendements via `session.md` ; l'agent amende le document puis demande validation si nécessaire.

## Interface de travail : fichiers, pas conversation

Le système de travail du dépôt repose sur des fichiers markdown versionnés. L'interface input/output **est** des fichiers, pas des échanges conversationnels éphémères.

- **Source de vérité** : toujours le fichier (plan, log, fondation, ADR).
- **Échanges textuels** (stdout/conversation) : secondaires, servent uniquement à orienter vers les fichiers.
- **Plans** : vivent dans `.dev/plans/PLN-<SEQ>-<SLUG>.md`, pas en stdout.
- **Logs** : vivent dans `.dev/logs/ia-output/LOG-<DATE>-task-<NN>.md`, pas en stdout. **Toute tâche traitée en produit un**, sans exception, y compris une tâche dont le seul livrable est un plan (voir `CLAUDE.md`, « Journalisation obligatoire »).

Conséquence : l'humain consulte directement les fichiers plutôt que d'attendre un résumé conversationnel. La réponse textuelle de l'agent se limite à indiquer le fichier produit, son chemin, et un résumé d'une phrase.

## `clia` : gardien déterministe de l'intégrité

`clia` est un CLI **100% déterministe** (mêmes entrées, mêmes sorties, aucune improvisation). Il n'est **ni** l'agent IA, **ni** une ressource de harnais : c'est un composant distinct du système d'augmentation par IA (voir `ADR-007-architecture-systeme-augmentation`). Sa fonction est de prendre en charge les changements d'état du cycle de vie des fichiers (transitions de session, inspection des ressources et des versions) afin de **garantir l'intégrité du système d'information**.

Parce qu'il est déterministe et **opéré par l'humain**, `clia` peut légitimement muter des fichiers en édition humaine uniquement (`session.md`, `.dev/sessions/*`) : c'est l'humain qui agit, via son outil. En conséquence :

- **L'agent IA n'invoque jamais** les commandes mutantes de session (`clia ses plan/open/close/new`) et n'édite jamais ces fichiers ; seul l'humain opère ces transitions.
- L'agent peut, en revanche, utiliser les commandes d'inspection en lecture seule (`clia --version`, `clia --config`, `clia res ls`, `clia ses status`, `clia ses check`) pour se renseigner sans effet de bord.

Le cycle de vie des sessions (planification `x<YZ>` / active / archivée) et le format vérifié par `clia ses check` sont définis dans `ADR-006-gestion-des-sessions` et `SPEC-003-format-markdown-clia-session`.

## Git commit : responsabilité de l'humain

L'agent IA n'a **jamais** le droit de :
- exécuter une commande `git add`, `git commit`, `git push`, ou toute autre action git ;
- proposer à l'humain d'exécuter un git commit ;
- suggérer une stratégie de branche, de merge, ou de synchronisation avec un dépôt distant ;
- discuter du moment ou de la façon de commiter.

**Seule exception :** l'agent produit un fichier log markdown (`.dev/logs/ia-output/LOG-<DATE>-task-<NN>.md`) qui inclut une section « Commit message proposé » à titre informatif. Ce message est une suggestion documentaire, pas une directive d'exécution. L'humain reste seul responsable de décider s'il faut commiter, rejeter, ou modifier le message proposé.
