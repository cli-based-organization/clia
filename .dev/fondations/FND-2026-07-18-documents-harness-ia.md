# FND-2026-07-18 - Documents de harnais IA : méthodologies, outils et rôles

- **Statut** : actif
- **Date** : 2026-07-18
- **Objectif** : établir une base factuelle et sourcée sur les documents de harnais qui encadrent le travail avec des agents IA : les grandes classes de méthodologie de travail avec IA, le panorama des principaux outils et frameworks, l'inventaire des documents de harnais connus et leur rôle, et une analyse critique distinguant les harnais de **gouvernance** des harnais d'**orchestration de processus**. Sert de référence pour l'analyse critique de `CONSTITUTION.md`.

## Note de rigueur

Fondation appuyée sur un mélange de sources primaires (le standard `AGENTS.md` publié sur agents.md et stewardé par la Linux Foundation ; le dépôt et la documentation de GitHub Spec Kit ; les bonnes pratiques d'ingénierie de Anthropic pour Claude Code) et de sources secondaires de synthèse (guides comparatifs des fichiers de configuration, panoramas de frameworks d'agents, littérature RACI et politique/procédure). Le domaine évolue vite : les faits sur les outils (versions, formats de fichiers) sont plus périssables que les principes méthodologiques (séparation gouvernance/processus, human-in-the-loop). Les affirmations normatives sont rattachées à leur source. Recherche menée le 2026-07-18.

## Cadrage

**Question** : quels documents encadrent le travail d'un agent IA, selon quelles méthodologies, et comment distinguer ce qui relève de la gouvernance de ce qui relève de l'orchestration du processus ?

**Périmètre** : les documents de harnais (fichiers d'instructions persistants lus par un agent) et les méthodologies associées, pour le travail d'ingénierie assisté par IA. Hors périmètre : l'architecture interne des modèles, le prompt engineering ponctuel, et les détails d'implémentation propres à un framework.

**Définitions** :
- **Document de harnais (harness)** : fichier persistant, versionné, lu par l'agent pour cadrer son comportement, par opposition aux échanges conversationnels éphémères. Recouvre les fichiers d'instructions, de mémoire, de règles, de principes (« constitution ») et les gabarits de processus.
- **Gouvernance** : ce qui définit les acteurs, leurs domaines de responsabilité et d'intervention, les droits et interdits, les principes non négociables. Répond à « qui peut faire quoi, sous quelles contraintes ».
- **Orchestration de processus** : ce qui définit l'enchaînement du travail : phases, états, transitions, artefacts produits, points de contrôle. Répond à « dans quel ordre, en produisant quoi ».

## 1. Grandes classes de méthodologie de travail avec IA

On peut ordonner les méthodologies sur un axe croissant de structure, avec un axe orthogonal de gouvernance humaine.

1. **Prompting conversationnel ad hoc (« vibe coding »)** : instructions données au fil de l'eau, sans structure persistante. Rapide, mais non reproductible ; la connaissance de projet n'est pas capitalisée.
2. **Méthodologie pilotée par fichiers d'instructions / de mémoire** : un ou plusieurs fichiers persistants (voir section 3) sont relus à chaque session pour fournir contexte, conventions et règles. C'est la couche « configuration » qui rend le comportement de l'agent stable et reproductible.
3. **Développement piloté par les spécifications (Spec-Driven Development, SDD)** : la spécification devient la source de vérité exécutable dont l'agent dérive l'implémentation. GitHub Spec Kit en est l'incarnation de référence, avec un processus en phases barrées (« gated ») : `Constitution → Specify → Plan → Tasks → Implement`, chaque phase produisant un artefact markdown consommé par la suivante.
4. **Orchestration agentique programmatique** : le flux de travail est codé dans un framework multi-agents (voir section 2). Quatre styles d'orchestration se sont stabilisés : par graphe d'états (LangGraph), par rôles (CrewAI), par conversation (AutoGen/AG2), par transfert/handoff (OpenAI Agents SDK), plus le style hiérarchique (Google ADK).
5. **Gouvernance human-in-the-loop (HITL)** : couche transverse de contrôle humain. Des **portes d'approbation** (approval gates) suspendent l'exécution autonome jusqu'à autorisation humaine explicite ; l'autonomie est **graduée par le risque** (automatiser le routinier, router les décisions à fort impact vers un humain). Le motif consensuel pour 2025 et au-delà est l'autonomie hybride : l'agent opère dans des garde-fous et escalade au franchissement d'une limite.

Ces classes se composent : un projet SDD utilise des fichiers d'instructions et peut poser des portes HITL. La tendance de fond est le passage du prompting ad hoc vers des processus explicites, versionnés et gouvernés.

## 2. Panorama des principaux outils et frameworks

**Agents de codage (lisant un fichier de harnais par projet)** : chaque outil lit un fichier différent. Codex CLI lit `AGENTS.md` ; Claude Code lit `CLAUDE.md` ; Gemini CLI lit `GEMINI.md` ; GitHub Copilot lit `.github/copilot-instructions.md` ; Cursor lit `.cursor/rules/*.mdc` (plus l'ancien `.cursorrules`) ; Windsurf lit `.windsurf/rules/*.md` (plus l'ancien `.windsurfrules`). Aider et d'autres suivent des conventions voisines.

**Toolkits de processus (SDD)** : GitHub Spec Kit fournit un processus prêt à l'emploi (`Spec → Plan → Tasks → Implement`), des gabarits structurés et des commandes CLI, compatible avec plus de 30 agents (Copilot, Claude Code, Gemini CLI, etc.). Il découple explicitement la conformité et la gouvernance du cœur du processus : des extensions (« CI Guard », « Architecture Guard ») ajoutent des portes de conformité sans les imposer au socle.

**Frameworks d'orchestration multi-agents** : LangGraph (orchestration par graphe d'états, devenu runtime par défaut de LangChain, v1.0 fin 2025) ; CrewAI (multi-agents par rôles, faible courbe d'apprentissage) ; AutoGen/AG2 (équipes conversationnelles, cœur événementiel asynchrone) ; OpenAI Agents SDK (handoff) ; Google ADK (hiérarchique). Motif courant : LangChain pour les outils et la récupération, CrewAI ou AutoGen pour l'orchestration multi-agents.

**Gouvernance d'entreprise** : côté Claude Code, les permissions se résolvent par ordre de précédence (politique managée d'entreprise, options de ligne de commande, réglages de projet, réglages utilisateur), via des fichiers de configuration (`managed-settings.json`, `settings.json`) qui refusent par défaut les outils destructifs et bornent le mode bypass.

## 3. Inventaire des documents de harnais connus et leur rôle

Les documents se répartissent en quatre rôles distincts, souvent confondus dans un même fichier.

**a) Contexte et connaissance de projet** (le « README pour agents ») :
- `AGENTS.md` : format ouvert et quasi universel (plus de 60 000 dépôts), stewardé par l'Agentic AI Foundation de la Linux Foundation, issu d'une collaboration (OpenAI Codex, Amp, Jules/Google, Cursor, Factory). Contient vue d'ensemble du projet, commandes de build/test, style de code, tests, considérations de sécurité, conventions de commit. Principe : « un seul AGENTS.md fonctionne pour de nombreux agents » ; en monorepo, le plus proche du fichier édité gagne.
- `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md` : équivalents propres à un outil. Claude Code ne lit pas nativement `AGENTS.md` (avril 2026) ; on l'y relie par un import `@AGENTS.md` en tête de `CLAUDE.md`.

**b) Règles et contraintes activables** :
- `.cursor/rules/*.mdc` : markdown à frontmatter (`description`, `globs`, `alwaysApply`) contrôlant quand chaque règle s'active.
- `.windsurf/rules/*.md` : champ `trigger` (Always On, Manual, Model Decision, Glob). Formats non interopérables entre outils (une règle Cursor ne signifie rien pour Windsurf), d'où la pratique d'une bibliothèque canonique unique compilée vers chaque format. Plafonds de taille par fichier (12 000 caractères chez Cursor/Windsurf).

**c) Principes non négociables (« constitution »)** :
- `constitution.md` (dans `.specify/memory/constitution.md` chez Spec Kit) : ensemble de **principes gouvernants non négociables** que le modèle doit respecter en toute circonstance. Contient typiquement : préférences et contraintes technologiques (bibliothèques approuvées/bannies, versions), exigences de sécurité, principes architecturaux (simplicité, pas de sur-ingénierie), standards de documentation, standards d'équipe. C'est le **premier** artefact produit, avant toute spécification ; chaque commande ultérieure le relit automatiquement.
- À ne pas confondre avec la « constitution » de Claude au sens de Anthropic (principes de comportement du modèle lui-même), concept homonyme mais distinct (gouvernance du modèle, pas du projet).

**d) Artefacts de processus** :
- `spec.md`, `plan.md`, `tasks.md` (Spec Kit) : la spécification, le plan technique, la décomposition en tâches. Ils portent l'**orchestration** : chaque phase est barrée et produit l'entrée de la suivante.
- Fichiers de configuration de gouvernance (`managed-settings.json`, `settings.json`) : droits, permissions, garde-fous.

**Enseignement transverse** : ces rôles sont **différents**. Le contexte (a) est de la connaissance, les règles (b) des contraintes activables, la constitution (c) des principes de gouvernance, les artefacts (d) du processus. Les bonnes pratiques de Anthropic pour Claude Code insistent sur la **concision** et la **séparation des préoccupations** : garder chaque fichier court (de l'ordre de 200 lignes), se demander pour chaque ligne « son retrait ferait-il faire une erreur à l'agent ? » sinon la couper, et ne pas mettre ce que l'agent peut inférer du dépôt.

## 4. Analyse critique : harnais de gouvernance vs harnais d'orchestration de processus

**Distinction fondamentale.** Deux couches, deux natures :

- **Gouvernance** : acteurs et domaines de responsabilité, droits d'édition, interdits, principes non négociables, permissions, portes d'approbation HITL. Change **lentement**. Répond à « qui, quoi, sous quelles contraintes ». Équivalents field : la constitution Spec Kit, les `managed-settings.json`, les politiques HITL.
- **Orchestration de processus** : phases, états, transitions, artefacts, points de contrôle et de reprise. Change **plus vite** (le processus se raffine). Répond à « dans quel ordre, produisant quoi ». Équivalents field : `Spec → Plan → Tasks → Implement`, les graphes LangGraph, les pipelines de tâches CrewAI.

**Convergence des sources vers la séparation.** Trois corpus indépendants recommandent de séparer ces couches :
1. **SDD / Spec Kit** sépare la constitution (principes) des artefacts de processus (spec/plan/tasks) et **découple** la conformité en extensions plutôt que de la coudre au socle.
2. **Littérature politique/procédure et RACI** : une **politique** énonce les principes et l'imputabilité (accountability) ; une **procédure** décrit les étapes. La RACI attribue les rôles (un seul responsable « R » par activité, pour respecter la ségrégation des tâches) et se lie aux workflows sans les absorber. On garde la matrice de responsabilités séparée du détail procédural (renvoyer aux SOP pour l'étape fine).
3. **Bonnes pratiques Claude Code** : concision et périmètre ciblé ; ne pas mélanger des contenus de natures et de rythmes de changement différents dans un même fichier.

**Anti-motif : le document fourre-tout.** Mêler gouvernance et orchestration dans un seul fichier a des coûts documentés : couplage de contenus à rythmes de changement différents (un raffinement de processus force à rééditer un document de principes stable), perte de lisibilité et de navigabilité, réutilisation inter-projets dégradée (la gouvernance des acteurs est souvent plus générique que le processus, ou l'inverse), et dilution du caractère « non négociable » des principes quand ils voisinent des détails procéduraux révisables. Le terme « constitution », dans le field, désigne spécifiquement la couche de **principes/gouvernance** ; y loger de l'orchestration de processus est un abus de portée.

**Point d'attention HITL.** Les portes d'approbation (breakpoints) relèvent des **deux** couches : la décision d'exiger une approbation est une règle de **gouvernance** (imputabilité, classes de risque) ; le mécanisme d'arrêt/reprise et l'état persistant sont de l'**orchestration**. Une conception propre distingue la politique (« quelles actions exigent une approbation ») du mécanisme (« comment l'exécution s'arrête et reprend »).

## Synthèse

Le travail avec IA s'est structuré du prompting ad hoc vers des processus explicites, versionnés et gouvernés. Les documents de harnais remplissent quatre rôles distincts (contexte, règles activables, principes/constitution, artefacts de processus) que les outils tendent à porter dans des fichiers séparés. La leçon transverse, convergente entre le SDD (Spec Kit), la littérature politique/procédure et RACI, et les bonnes pratiques d'ingénierie de Anthropic, est la **séparation des préoccupations** : distinguer la **gouvernance** (acteurs, responsabilités, principes non négociables, permissions, HITL) de l'**orchestration de processus** (phases, états, transitions, artefacts, points de contrôle), parce qu'elles diffèrent par nature, par rythme de changement et par réutilisabilité. Un document nommé « constitution » gagne à se cantonner à la couche gouvernance/principes.

## Limites

- Panorama d'outils daté (2026-07-18) et périssable : formats de fichiers, versions de frameworks et adoptions évoluent vite.
- Ne couvre pas en détail l'implémentation interne de chaque framework d'orchestration.
- La littérature RACI/politique-procédure vient du management d'entreprise ; sa transposition au travail humain-agent est analogique, pas identique.
- Centrée sur l'écosystème des agents de codage et du SDD ; n'aborde pas les agents non logiciels.

## Sources

- AGENTS.md (standard, Linux Foundation / AAIF) : https://agents.md/
- Guide des fichiers de configuration des agents de codage : https://www.deployhq.com/blog/ai-coding-config-files-guide
- AGENTS.md vs CLAUDE.md vs .cursorrules (spec 2026) : https://www.morphllm.com/agents-md-guide
- GitHub Spec Kit (dépôt) : https://github.com/github/spec-kit
- Spec-driven development with AI (GitHub Blog) : https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
- Spec Kit (documentation, workflow Spec/Plan/Tasks/Implement) : https://github.github.com/spec-kit/
- Spec Kit, phase Constitution : https://den.dev/blog/github-spec-kit/
- Anthropic, bonnes pratiques Claude Code : https://www.anthropic.com/engineering/claude-code-best-practices
- Anthropic, constitution de Claude (concept homonyme, gouvernance du modèle) : https://www.anthropic.com/constitution
- Panorama des frameworks d'agents (LangChain) : https://www.langchain.com/resources/ai-agent-frameworks
- Human-in-the-loop, portes d'approbation : https://createos.sh/blogs/human-in-the-loop-ai-agents
- Human-in-the-loop, conception des workflows d'approbation (StackAI) : https://www.stackai.com/insights/human-in-the-loop-ai-agents-how-to-design-approval-workflows-for-safe-and-scalable-automation
- RACI (matrice de responsabilités) : https://asana.com/resources/raci-chart
- Politique et procédure (séparation) : https://www.trenegy.com/publications/use-policy-procedure-development-improve-processes
- Cursor vs Windsurf (formats de règles) : https://www.builder.io/blog/windsurf-vs-cursor
