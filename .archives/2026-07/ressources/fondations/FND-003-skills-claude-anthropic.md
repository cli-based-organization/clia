---
type: fondation
version: 0.1.0
title: "Le système de skills Claude Code (Anthropic)"
status: actif
date: 2026-06-21
---

# FND-003 - Le système de skills Claude Code (Anthropic)

- **Objectif** : établir une base factuelle exhaustive sur le mécanisme des skills dans Claude Code, pour guider la conception et la maintenance du répertoire `skills/` de la méthodologie ticket-driven-ai.
- **Provenance** : rapatriée depuis `noumanity-dev/ticket-driven-ai/.dev/fondations/FND-001-skills-claude-anthropic.md` (tâche 15). Le corps conserve ses références d'origine (`tda`, `.dev/tickets/`, skills `skl-001/002/003` de ce dépôt-là), qui sont historiques et propres à `ticket-driven-ai`.

## Note de rigueur

Les observations sur le format et le comportement des skills proviennent de trois sources : (1) l'analyse empirique des fichiers `SKILL.md` de ce repo et de repos connexes, (2) les instructions système embarquées dans les sessions Claude Code (disponibles dans le contexte de l'agent), (3) la documentation publique de Claude Code. Certaines affirmations sur le mécanisme interne sont des inférences : elles sont signalées. Les comportements décrits correspondent à Claude Code version 0.x (2026).

## Cadrage

### Question directrice

Comment fonctionne le système de skills Claude Code ? Quelles capacités offre-t-il, quelles sont ses limites, et comment l'utiliser efficacement dans un repo de méthodologie IA ?

### Périmètre

Dans le périmètre : définition, format, invocation, portée, relation aux autres composantes Claude Code, bonnes pratiques, analyse critique.

Hors périmètre : les agent types prédéfinis (claude, Explore, Plan, etc.), les MCP servers, les hooks shell.

### Définitions de base

Un **skill** dans Claude Code est un fichier Markdown structuré, stocké dans un répertoire de skills du projet, qui encode des instructions réutilisables pour guider le comportement de l'agent IA sur un type de tâche donné. L'utilisateur l'invoque avec la syntaxe `/nom-du-skill` ; l'agent peut aussi l'invoquer programmatiquement via l'outil `Skill`.

Un skill n'est pas un script, ni un outil externe : il est du texte d'instruction que l'agent lit et suit comme il suivrait n'importe quelle consigne.

## Corps

### 1. Panorama du système

Le système de skills répond à un besoin pratique : comment encoder, de façon réutilisable, des savoir-faire spécialisés qui dépassent ce que `CLAUDE.md` peut couvrir sans devenir ingérable ?

`CLAUDE.md` est chargé à chaque session et s'applique en permanence. Il est adapté aux règles générales, aux contraintes transversales, aux conventions du repo. Les skills sont on-demand : ils ne s'activent que lorsqu'invoqués. Ils sont adaptés aux playbooks de tâche, aux templates de livrable, aux processus méthodologiques.

Le système distingue deux types d'invocation :
- **Utilisateur** : taper `/skill-name` dans la conversation déclenche le chargement du skill.
- **Agent** : l'outil `Skill` permet à l'agent d'invoquer programmatiquement un skill listé dans les messages système.

### 2. Format technique

Un skill est un fichier `SKILL.md` placé dans un sous-répertoire nommé. La convention observée dans ce repo est `skills/<nom-du-skill>/SKILL.md`, avec un sous-répertoire par skill.

**Frontmatter YAML (obligatoire)**

```yaml
---
name: <identifiant-unique>
description: >-
  Description sur une ligne. Utilisée pour le matching de pertinence
  lors de la sélection automatique.
---
```

Champs documentés :
- `name` : identifiant canonique du skill. Correspond au nom utilisé pour l'invocation.
- `description` : résumé court (YAML literal block ou flow scalar). Critique pour la découverte automatique : c'est ce texte que l'agent lit pour décider si le skill est pertinent.

**Corps Markdown**

Le corps est du Markdown libre. Il n'y a pas de structure imposée par le moteur, mais les bonnes pratiques dégagées par l'analyse des skills existants convergent vers :
- une section "Quand l'utiliser" (critères de déclenchement),
- un processus numéroté,
- des critères de qualité,
- une structure de livrable avec template.

La richesse et la précision du corps sont directement corrélées à la qualité et à la reproductibilité du comportement de l'agent.

**Exemple minimal fonctionnel**

```markdown
---
name: mon-skill
description: >-
  Produire un rapport d'analyse sur X.
---

# Skill - Rapport d'analyse

## Quand l'utiliser
Lorsque la tâche demande une analyse structurée de X.

## Processus
1. Lire la source.
2. Identifier les patterns.
3. Produire le rapport au format ci-dessous.

## Structure
- Titre
- Synthèse
- Analyse détaillée
- Recommandations
```

### 3. Mécanisme d'invocation

**Invocation utilisateur**

Quand l'utilisateur tape `/nom-du-skill`, Claude Code charge le fichier SKILL.md correspondant et le suit comme une directive. L'agent ne simule pas le skill : il l'exécute dans le fil de la conversation, avec accès à tous ses outils.

L'instruction système précise : "When users reference a 'slash command' or '/<something>', they are referring to a skill. Use this tool to invoke it." et "Only invoke a skill that appears in that list [...] Never guess or invent a skill name from training data."

Inférence : le moteur maintient une liste des skills disponibles (lus depuis `skills/`) qu'il expose à l'agent dans les messages système. L'agent ne peut invoquer que les skills de cette liste.

**Invocation agent (outil `Skill`)**

L'outil `Skill` permet à l'agent d'invoquer un skill sans action explicite de l'utilisateur. L'instruction système indique : "When your work should be informed by a skill [...], invoke the relevant Skill tool BEFORE generating any other response about the task." C'est un comportement bloquant : l'agent doit appeler le skill avant de répondre.

Cela ouvre la possibilité de skills déclenchés automatiquement selon le contexte, sans que l'utilisateur n'ait à connaître leur nom.

### 4. Portée et découverte

**Portée projet**

Les skills sont liés au repo courant. Ils ne se propagent pas entre projets, sauf copie explicite. Pour les harness-files de ticket-driven-ai, les skills font partie des fichiers copiés par `tda init` : ils voyagent avec la méthodologie.

**Portée de la liste disponible**

La liste des skills disponibles est construite dynamiquement à partir du répertoire `skills/` du repo. Ajouter un fichier `skills/mon-skill/SKILL.md` le rend automatiquement disponible dans la session suivante. Supprimer le fichier le retire.

**Priorisation**

Lorsque plusieurs skills sont disponibles, l'agent sélectionne le plus pertinent selon la `description` du frontmatter. Une description précise, avec le type de tâche et le livrable attendu, améliore la sélection automatique.

### 5. Capacités et limites

**Capacités**

- Encoder n'importe quelle instruction textuelle : processus, heuristiques, templates, critères, contraintes.
- Garantir la reproductibilité d'un comportement complexe entre sessions.
- Permettre la spécialisation par domaine (un skill par type de livrable, par exemple).
- Opérer avec tous les outils de l'agent (lecture de fichiers, édition, bash, web search, etc.).
- S'intégrer dans un système de gouvernance (CLAUDE.md + CONSTITUTION.md + skills).

**Limites**

- **Statiques** : un skill ne peut pas s'adapter dynamiquement à l'état du repo (il ne lit pas les fichiers à l'invocation, sauf si ses instructions le demandent explicitement).
- **Sans vérification** : rien n'oblige l'agent à suivre le skill à la lettre. La fidélité dépend de la clarté des instructions et de la capacité du modèle.
- **Non versionnés automatiquement** : un changement dans `SKILL.md` s'applique immédiatement sans traçabilité native. La traçabilité repose sur git.
- **Pas de logique conditionnelle** : un skill ne peut pas "si condition alors étape A sinon étape B" de façon fiable. Les bifurcations doivent être explicitées en prose.
- **Coût cognitif** : plus un skill est long, plus il consomme de la fenêtre de contexte. Les skills longs et détaillés ont un coût.
- **Découverte opaque** : l'utilisateur ne sait pas quels skills sont disponibles sans consulter `skills/`. Il n'y a pas de commande `tda skill ls` équivalente (bien que cela soit possible à implémenter).

### 6. Relation aux autres composantes Claude Code

| Composante | Chargement | Portée | Usage |
|---|---|---|---|
| `CLAUDE.md` | À chaque session, automatique | Toute la session | Règles permanentes, conventions, structure |
| `CONSTITUTION.md` | À chaque session, automatique | Toute la session (autorité max) | Règles impératives non négociables |
| Skills | On-demand, sur invocation | Une tâche | Playbooks de tâche, templates de livrable |
| Hooks | Événementiel (sur tool call) | Événement précis | Validation automatique, side-effects |
| MCP servers | Configuré, permanent | Outils disponibles | Capacités externes (bases de données, APIs) |

Les skills sont le seul mécanisme on-demand parmi les composantes de gouvernance. Ils permettent d'encapsuler des connaissances spécialisées sans alourdir le contexte permanent.

**Skills vs CLAUDE.md**

La règle pratique : ce qui s'applique toujours va dans `CLAUDE.md`; ce qui s'applique pour un type de tâche précis va dans un skill. Un processus de création d'ADR n'a pas à être dans `CLAUDE.md` si l'agent peut invoquer le skill `skl-002-adr` quand nécessaire.

**Skills vs hooks**

Les hooks réagissent à des événements (avant ou après un appel d'outil). Ils ne guident pas, ils valident ou exécutent. Les skills guident; les hooks gardent.

### 7. Analyse critique

**Force : encapsulation du savoir méthodologique**

Le mécanisme des skills est particulièrement bien adapté à une méthodologie comme ticket-driven-ai, où le comportement de l'agent doit être standardisé autour de types de livrables prédéfinis. Chaque livrable (artefact, ADR, essai de fondation) a ses propres critères de qualité, sa propre structure, son propre processus. Les skills en sont le vecteur naturel.

**Faiblesse : pas d'introspection**

L'agent n'a pas de vue d'ensemble native de ses propres skills. Il ne peut pas répondre à "quels skills sont disponibles ici ?" sans lire le répertoire. Cela crée un angle mort : des skills peuvent exister sans jamais être invoqués parce que ni l'utilisateur ni l'agent ne les connaissent.

Recommandation : documenter les skills disponibles dans `CLAUDE.md` (catalogue) ET dans le README du projet.

**Faiblesse : pas de validation du résultat**

Un skill définit le processus, pas la vérification automatique du livrable produit. L'agent peut suivre le skill et produire un livrable non conforme (section manquante, format incorrect) sans que cela soit détecté. Les hooks peuvent partiellement compenser (ex: un hook qui vérifie l'absence de tiret cadratin), mais la validation reste principalement à la charge de l'agent lui-même.

**Opportunité : skills comme contrat de livrable**

Un skill bien rédigé est un contrat explicite entre l'humain et l'agent : "quand ce type de tâche est demandé, voici ce que l'agent s'engage à produire." Ce contrat est lisible par les deux parties, versionnable, et diffusable via `tda init`.

### 8. Application au projet ticket-driven-ai

Le repo définit trois skills de base qui correspondent aux trois types de livrables du catalogue :

| Skill | Livrable | Emplacement |
|---|---|---|
| `skl-001-artefact-de-travail` | Réponse de l'agent à une tâche | `.dev/tickets/TKT-<XYZ>/` |
| `skl-002-adr` | Décision d'architecture actée | `doc/adr/` |
| `skl-003-essai-de-fondation` | Recherche en profondeur sourcée | `.dev/fondations/` |

Ces skills voyagent avec la méthodologie (copiés par `tda init`) et peuvent être étendus per-repo avec `tda deliverable new` + un nouveau fichier `SKILL.md` correspondant.

**Gap identifié** : la commande `tda deliverable new` crée l'entrée dans `allowed-deliverable` mais ne crée pas le fichier `SKILL.md` correspondant. L'utilisateur doit le créer manuellement. C'est une friction à réduire (piste pour un ticket futur).

**Gap identifié** : il n'existe pas de commande `tda skill ls` pour lister les skills disponibles, ni de lien automatique entre un livrable enregistré et son skill. La cohérence est manuelle.

## Synthèse

Les skills Claude Code sont un mécanisme léger et puissant pour encoder des savoir-faire spécialisés sous forme de playbooks Markdown invocables. Leur force est la portabilité, la lisibilité et la composabilité dans un système de gouvernance. Leurs faiblesses principales sont l'absence d'introspection native et l'absence de validation automatique du livrable produit.

Pour ticket-driven-ai, les skills sont le vecteur d'encodage des conventions de livrable. Leur efficacité dépend de trois facteurs : (1) la précision de la description frontmatter pour la découverte, (2) la clarté du processus et des critères de qualité dans le corps, (3) la cohérence entre le skill et le livrable déclaré dans `tda deliverable ls`.

Deux évolutions seraient à valeur haute : la génération automatique d'un squelette `SKILL.md` par `tda deliverable new`, et une commande `tda skill ls` pour l'introspection.

## Limites

- La description du mécanisme d'invocation interne est partiellement inférée (non documentée publiquement dans les détails).
- Les comportements décrits correspondent à Claude Code version 0.x (2026-06) ; le système est en évolution active.
- Cet essai ne couvre pas les skills globaux (utilisateur) ni les skills des IDE plugins.
- À revalider si une mise à jour majeure de Claude Code modifie le mécanisme de discovery.

## Sources

1. Fichiers `SKILL.md` de ce repo : `skills/skl-001-artefact-de-travail/SKILL.md`, `skills/skl-002-adr/SKILL.md`, `skills/skl-003-essai-de-fondation/SKILL.md` - analyse empirique directe.
2. Instructions système Claude Code embarquées dans la session (2026-06-21) - description du mécanisme Skill tool et des règles d'invocation.
3. `CLAUDE.md` de ce repo - conventions d'usage des skills dans la méthodologie.
4. Analyse des repos connexes : `deeptech-ticket-driven` (référence d'implémentation), `noumanity-ops/system-inspection` (usage terrain).
