---
type: analyse
version: 0.1.0
title: "Intérêt du Model Context Protocol (MCP) pour clia"
date: 2026-07-18
---

# ANL-009 - Intérêt du Model Context Protocol (MCP) pour clia

- **Périmètre** : l'opportunité d'introduire MCP dans le système de `clia` : exposer `clia` comme serveur MCP, ou consommer des serveurs MCP dans le workflow. Ressources mobilisées : `ADR-007` (architecture à deux domaines), `ADR-002`/`SPEC-001`/`REQ-001` (convention CLI bash), `CONSTITUTION.md` (rôle de `clia`), `SPEC-002`/`REQ-002`. Exclusions : contenu métier.
- **Référence** : `FND-013-mcp-model-context-protocol` ; `FND-010-capacites-modeles-ia-usage` (critère « IA/complexité seulement si nécessaire ») ; `ANL-012-usage-ia-projet`.

## Objet

Mobiliser le savoir de la fondation sur MCP pour analyser de façon critique l'intérêt d'en utiliser dans `clia` : quels bénéfices, à quel coût, en cohérence avec l'architecture et les principes du dépôt. L'analyse recommande ; elle n'exécute aucun changement.

## Périmètre et méthode

Deux usages possibles de MCP pour `clia` sont examinés : (A) **exposer `clia` comme serveur MCP** (ses commandes d'inspection deviennent des outils/ressources pour un agent) ; (B) **consommer des serveurs MCP** dans le workflow de développement. Grille : pour chaque usage, bénéfices, coûts, cohérence avec `ADR-007` (séparation déterministe/IA), la convention CLI bash (`ADR-002`/`SPEC-001`/`REQ-001`), la gouvernance (`CONSTITUTION.md`), et le principe « n'utiliser l'IA/la complexité que si nécessaire » (`FND-010-capacites-modeles-ia-usage`, `ANL-012-usage-ia-projet`).

## Rappel du rôle de clia

`clia` est un CLI bash **100 % déterministe**, **opéré par l'humain**, gardien de l'intégrité du système d'information (`CONSTITUTION.md`, `ADR-007`). L'agent IA n'invoque **jamais** les commandes mutantes de session ; il utilise uniquement les commandes d'**inspection en lecture seule** (`res ls`, `ses status`, `--version`, `--config`, `ses check`), via l'outil **Bash** de Claude Code. L'interface de travail est **des fichiers** (markdown versionnés), pas des échanges conversationnels. `clia` cible **Debian 12 / bash 5.2**, avec une seule dépendance déclarée (`yq`).

## Constats

**C1. Ce que MCP (usage A) apporterait.** Exposer `clia` comme serveur MCP transformerait ses commandes d'inspection en **outils/ressources typés et découvrables** pour un agent : accès structuré (JSON-RPC, schémas), inventaire des ressources/sessions consommable par **tout client MCP** (pas seulement le Bash de Claude Code), et possibilité d'attacher une **politique de permission** (`always_ask`) pour tracer/garder certaines opérations. C'est le bénéfice réel du protocole (`FND` §1, §3).

**C2. Ce que `clia` a déjà, sans MCP.** Dans le workflow actuel (mono-dépôt, agent unique dans Claude Code), l'agent accède déjà à l'inspection de `clia` via **Bash**, et à l'état du système via l'**interface fichiers**. `clia` est **auto-documenté et découvrable** (source `clia.doc.yaml`, `-h`/`--man`, `REQ-001-F7/F8`). MCP n'ajoute donc **aucune capacité nécessaire** au workflow présent : il rendrait structuré un accès déjà disponible.

**C3. Coûts et frictions vs contraintes de `clia`.** Un serveur MCP suppose un **processus** (stdio ou HTTP), un **runtime/SDK** (typiquement Python ou Node) et le protocole **JSON-RPC** (`FND` §2, §4). Cela s'oppose frontalement à l'identité de `clia` : un **script bash déterministe, one-shot, sans effet de bord à l'import**, ciblant Debian 12 avec une seule dépendance (`ADR-002`, `SPEC-001`, `REQ-001`). Envelopper `clia` en serveur MCP ajouterait une dépendance de runtime étrangère et un **modèle de processus long** contraire au modèle d'exécution ponctuel du CLI.

**C4. Tension avec l'architecture à deux domaines (`ADR-007`).** `clia` est la **couche déterministe** opérée par l'humain ; MCP est une **couche d'intégration IA** (un serveur expose des outils à l'agent). Exposer `clia` via MCP **brouillerait** la frontière : le gardien déterministe deviendrait une surface d'outils pilotée par l'IA. De plus, la gouvernance interdit à l'agent d'invoquer les commandes **mutantes** de session ; un serveur MCP devrait donc n'exposer que la **lecture seule**, ce qui est faisable mais impose une discipline supplémentaire pour ne pas ouvrir accidentellement des mutations à l'agent.

**C5. Sécurité (`FND` §7).** Tout serveur MCP élargit la surface d'attaque (**tool poisoning** via métadonnées, **prompt injection** via les résultats renvoyés). Pour un `clia` local et déterministe, le risque est **faible mais non nul**. À l'inverse, le modèle actuel place le **human-in-the-loop** au bon endroit : c'est l'humain qui opère les mutations, et l'agent n'a que la lecture. Introduire MCP n'améliore pas cette posture ; il ajoute une surface.

**C6. Confrontation au principe « IA/complexité seulement si nécessaire ».** `FND-010-capacites-modeles-ia-usage` et `ANL-012-usage-ia-projet` posent : n'introduire une couche IA/complexe que si le besoin l'exige, automatiser/simplifier le reste. MCP est précisément une couche d'intégration IA. L'ajouter **sans besoin actuel** contredit ce principe et alourdirait un composant dont la valeur est la **simplicité déterministe**.

**C7. Quand MCP deviendrait pertinent pour `clia`.** Trois conditions, aucune remplie aujourd'hui : (a) `clia` doit être consommé par des **clients/agents non-Claude-Code** (portabilité inter-clients — le cœur de la proposition de valeur MCP, `FND` §1) ; (b) on veut un **accès typé/structuré à l'inventaire** des ressources/sessions **à travers un écosystème multi-dépôts** (un « serveur MCP d'inspection » partagé) ; (c) on veut imposer un **gating de permission uniforme** (`always_ask`) sur des opérations sensibles au-delà de ce que l'opération humaine assure déjà.

**C8. Usage B (consommer des serveurs MCP).** Distinct de l'exposition de `clia` : l'agent qui développe `clia` pourrait bénéficier de serveurs MCP tiers (accès structuré à des données externes). Mais cela relève de la configuration de **l'environnement de travail de l'agent** (Claude Code), pas de `clia` lui-même ; c'est neutre vis-à-vis de la conception de `clia` et ne justifie aucun changement du dépôt.

## Confrontation à la référence

- `FND-013-mcp-model-context-protocol` : la valeur de MCP est la **portabilité inter-clients** et l'**accès structuré**. Or `clia` sert aujourd'hui un seul client (l'agent Claude Code) via Bash, avec un accès déjà découvrable. Le bénéfice différenciant de MCP n'est donc pas activé.
- `ADR-007` + `CONSTITUTION.md` : MCP tendrait à faire de `clia` une surface d'outils IA, en tension avec son rôle de gardien déterministe opéré par l'humain.
- `FND-010-capacites-modeles-ia-usage` : ajouter une couche IA non nécessaire contredit « IA/complexité seulement si nécessaire ».
- `SPEC-001`/`REQ-001` : un serveur MCP contredit le modèle « script bash pur, Debian 12, dépendance unique ».

## Synthèse et recommandations

**Constat central** : MCP est un excellent protocole d'intégration IA, mais **son intérêt pour `clia` n'est pas activé aujourd'hui**. Ses bénéfices (portabilité inter-clients, accès structuré typé) ne répondent à aucun besoin actuel du workflow (mono-dépôt, agent unique dans Claude Code, accès déjà découvrable via Bash et fichiers), tandis que ses coûts (runtime/serveur, JSON-RPC, surface de sécurité) heurtent l'identité déterministe et minimale de `clia` et la séparation `ADR-007`.

Recommandations, par priorité :

1. **(Recommandé) Ne pas introduire MCP dans `clia` maintenant.** Conserver `clia` comme **CLI bash déterministe pur**, consommé via l'outil Bash de Claude Code et l'interface fichiers. C'est l'option alignée sur `ADR-007`, `SPEC-001`/`REQ-001` et le principe de nécessité.
2. **(Alternative légère, si l'on veut de la structure)** Si le seul besoin est un **accès structuré** aux inventaires, ajouter à `clia` une **option de sortie machine** (`--json` / `--format json` sur les commandes d'inspection) : l'agent obtient du structuré via Bash, sans serveur, sans runtime, sans surface MCP. Coût très inférieur à un serveur MCP, cohérent avec la nature bash.
3. **(Condition de réévaluation)** Rouvrir la question MCP seulement si l'une des trois conditions de C7 se matérialise : consommation par des clients non-Claude-Code, besoin d'inspection typée inter-dépôts, ou gating de permission uniforme requis.
4. **(Si un jour retenu)** Exposer **uniquement** les commandes d'**inspection lecture seule** (jamais les mutations de session, cohérent avec la gouvernance), via un serveur **mince** enveloppant `clia`, en **assumant explicitement** la dépendance de runtime et les garde-fous de sécurité (`FND` §7 : moindre privilège, HITL, autorisation).
5. **(Usage B, neutre)** Consommer des serveurs MCP tiers dans l'environnement de travail de l'agent (Claude Code) est un choix d'outillage **indépendant de la conception de `clia`** ; il ne requiert aucun changement du dépôt et peut se décider séparément.

## Portée et péremption

Couverture : l'opportunité MCP au regard de l'état de `clia` et de son workflow au 2026-07-18. Limites : l'analyse suppose le workflow actuel (mono-dépôt, agent Claude Code) ; l'arrivée des livrables d'installation/multi-dépôts (`PLN-012`/`PLN-013`) pourrait activer la condition C7(b) et justifier une réévaluation. Péremption : liée à l'évolution de `clia`, de son écosystème d'usage et du protocole MCP lui-même.
