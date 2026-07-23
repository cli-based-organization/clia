---
type: fondation
version: 0.1.0
title: "Le Model Context Protocol (MCP) : notions, architecture et mise en place"
status: actif
date: 2026-07-18
---

# FND-013 - Le Model Context Protocol (MCP) : notions, architecture et mise en place

- **Objectif** : établir une base factuelle exhaustive et sourcée sur le Model Context Protocol (MCP) : ce qu'il est, son architecture, ses primitives, ses transports, sa mise en place dans l'environnement Claude (Desktop, Claude Code, claude.ai, API), son rapport aux CLI, et sa sécurité. Sert de référence à l'analyse critique de l'intérêt de MCP pour `clia`.

## Note de rigueur

Fondation appuyée sur des sources primaires (spécification et documentation officielles `modelcontextprotocol.io` et le dépôt de spec ; documentation Claude Code et Claude Desktop ; le skill de référence `claude-api` chargé en session pour le connecteur MCP côté API/Managed Agents) et sur des sources secondaires de synthèse et de sécurité (analyses de menaces, guides OAuth 2.1). L'écosystème MCP évolue vite : les faits sur les outils et versions sont périssables ; les principes (architecture host/client/server, JSON-RPC, primitives) sont stables. Recherche menée le 2026-07-18.

## Cadrage / Thèse

**Question** : qu'est-ce qu'un MCP, comment le met-on en place dans l'environnement Claude et avec des CLI, et à quelles conditions de sécurité ?

**Périmètre** : la nature du protocole, son architecture, sa configuration côté Claude, son rapport aux CLI, et ses risques. Hors périmètre : l'écriture pas-à-pas d'un serveur dans un langage donné (renvoyée aux SDK) et le détail des implémentations tierces.

**Définitions** :
- **MCP (Model Context Protocol)** : protocole ouvert standardisant la façon dont une application d'IA fournit du contexte et des capacités à un modèle, en connectant des **clients** à des **serveurs** exposant outils, données et gabarits. Souvent décrit comme « le port USB-C des applications d'IA ». Introduit par Anthropic (fin 2024), désormais standard ouvert (transféré à l'Agentic AI Foundation de la Linux Foundation).
- **Serveur MCP** : programme qui expose des capacités (tools/resources/prompts) à des clients.
- **Client MCP** : composant qui maintient une connexion à un serveur et en obtient du contexte.
- **Hôte MCP** : l'application d'IA qui coordonne un ou plusieurs clients.

## 1. Qu'est-ce que MCP

MCP répond à un problème d'intégration combinatoire : sans standard, chaque application d'IA doit coder une intégration ad hoc pour chaque source de données ou outil (problème « M×N »). MCP fournit une interface commune (« M+N ») : un serveur écrit une fois est consommable par tout client compatible.

Techniquement, MCP repose sur **JSON-RPC 2.0** : clients et serveurs s'échangent des requêtes et réponses ; des **notifications** servent quand aucune réponse n'est attendue. Le protocole gère un cycle de vie explicite (initialisation, négociation de capacités, opération, fermeture).

## 2. Architecture : hôte, client, serveur ; deux couches

Trois participants (documentation officielle) :
- **Hôte** : l'application d'IA (ex. Claude Desktop, Claude Code, un agent) qui orchestre un ou plusieurs clients.
- **Client** : maintient une connexion **1:1** avec un serveur et en obtient le contexte. Un hôte peut instancier plusieurs clients isolés, chacun avec son canal JSON-RPC stateful.
- **Serveur** : fournit le contexte et les capacités.

Deux couches :
- **Couche données** : le protocole JSON-RPC (cycle de vie, primitives tools/resources/prompts, notifications).
- **Couche transport** : les mécanismes de communication (établissement de connexion, cadrage des messages, autorisation).

## 3. Primitives

**Primitives exposées par le serveur** :
- **Tools (outils)** : fonctions exécutables que l'IA peut invoquer pour agir (ex. interroger une base, écrire un fichier). Chaque outil a un nom, une description et un schéma de paramètres.
- **Resources (ressources)** : sources de données fournissant du contexte (fichiers, enregistrements), adressées par URI, en lecture.
- **Prompts** : gabarits réutilisables structurant les interactions avec le modèle.

**Primitives côté client (que le serveur peut solliciter)**, selon les versions du protocole : **sampling** (le serveur demande une complétion au modèle via le client), **roots** (portées de système de fichiers accordées), **elicitation** (le serveur demande une information à l'utilisateur). L'ensemble est négocié à l'initialisation (capacités).

## 4. Transports

- **stdio (local)** : le serveur tourne comme **sous-processus** de l'hôte, communication via stdin/stdout. Typiquement **un seul client** (mono-hôte, local). Le plus simple pour un outil local.
- **Streamable HTTP (distant)** : serveur distant sur HTTP, sert **plusieurs clients** ; supporte le streaming (remplace le transport SSE historique, désormais legacy). Requiert une couche d'autorisation (voir §7).

Le choix du transport découle du déploiement : local et personnel (stdio) vs partagé/distant (HTTP).

## 5. Mise en place dans l'environnement Claude

**Claude Desktop (serveurs locaux stdio)** : édition du fichier de configuration
`~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) ou `%APPDATA%\Claude\claude_desktop_config.json` (Windows). Structure : une clé `mcpServers` mappant un nom vers `{ "command", "args", "env" }`. Exemple (serveur filesystem officiel) :

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/moi/projets"],
      "env": {}
    }
  }
}
```

Claude Desktop lance le serveur en sous-processus et dialogue en stdio ; les serveurs et outils connectés apparaissent dans l'UI « Connectors » (bouton `+` de la zone de saisie). Les serveurs distants (beta) sont pris en charge via connecteurs.

**Claude Code (CLI)** : au lieu d'éditer le JSON à la main, commande dédiée
`claude mcp add <nom> <commande> [args...]` pour un serveur stdio ; `--transport stdio|http`, `--scope project|user` (portée dépôt vs utilisateur), `--json` pour passer une spec JSON. Exemple :
`claude mcp add --transport stdio project-db -- npx -y @modelcontextprotocol/server-postgres postgresql://localhost:5432/mydb`.
Une portée `project` enregistre le serveur dans un fichier de projet (`.mcp.json`) partagé par le dépôt. Après ajout, une nouvelle session rend les outils disponibles. `claude mcp list` / `claude mcp remove` gèrent l'inventaire.

**claude.ai (connecteurs distants)** : ajout de connecteurs (serveurs distants) via l'interface, avec autorisation OAuth pour les services tiers.

**API (Claude Developer Platform)** : deux voies (voir le skill `claude-api`) :
- **Connecteur MCP de la Messages API** : paramètres `mcp_servers` (déclaration `{type:"url", name, url}`) **et** un `mcp_toolset` (`{type:"mcp_toolset", mcp_server_name}`) dans `tools`, sous un en-tête beta ; Anthropic établit la connexion MCP côté serveur.
- **Managed Agents** : l'agent déclare `mcp_servers` (sans secret) ; les identifiants vivent dans des **vaults** attachés à la session (`vault_ids`), avec rafraîchissement OAuth géré.

## 6. MCP et les CLI

Le rapport entre MCP et les CLI est triple :

1. **Un serveur MCP local est lancé par une commande** : la configuration (`command`, `args`) est presque toujours l'invocation d'un **exécutable en ligne de commande** — `npx`, `uvx`, `python`, `node`, ou un binaire — qui implémente le serveur et parle stdio. Mettre en place un serveur local, c'est donc fournir une **ligne de commande** que l'hôte exécute.
2. **Exposer un CLI existant comme serveur MCP** : on enveloppe les fonctionnalités d'un CLI dans un serveur MCP (via les SDK officiels ou des frameworks comme FastMCP), le serveur traduisant les appels d'outils en invocations du CLI et renvoyant des résultats structurés. Le CLI garde sa logique ; le serveur ajoute la couche protocole/typage.
3. **Le client/hôte est lui-même souvent un CLI** : Claude Code est un CLI qui **consomme** MCP (`claude mcp add`) et peut, selon la configuration, être exposé comme serveur pour d'autres hôtes. MCP n'est donc pas réservé aux applications graphiques.

Enseignement : la mise en place « avec des CLI » recouvre à la fois **configurer** des serveurs (souvent des commandes) depuis un client CLI (Claude Code), et **transformer** un CLI en serveur MCP pour l'exposer à un agent.

## 7. Sécurité

MCP élargit la surface d'attaque ; les risques et parades documentés :
- **Prompt injection** : des instructions cachées dans des données externes détournent l'agent. Problème non résolu de façon convaincante à ce jour (Simon Willison) ; MCP l'amplifie en multipliant les sources de contenu injectable.
- **Tool poisoning** : l'agent fait confiance aux **métadonnées** des outils (nom, description, schéma) pour décider quoi appeler ; un serveur malveillant ou compromis y glisse des instructions cachées, invisibles à l'utilisateur mais lues par le modèle. Toute session utilisant l'outil est alors compromise.
- **Confused deputy / sur-permission** : un serveur agit avec des droits trop larges pour le compte de l'agent.
- **Parades** :
  - **Human-in-the-loop** : n'autoriser aucune opération destructrice/irréversible sans point de contrôle humain ; annoter les outils par classe de risque et imposer une approbation pour le destructif.
  - **Autorisation OAuth 2.1 + PKCE** pour les serveurs distants ; déléguer de préférence à un fournisseur OAuth/OIDC externe (le serveur MCP devient simple *relying party* qui vérifie jetons et *scopes*).
  - **Consentement incrémental** (mise à jour 2026 de la spec) : ne demander que le minimum d'accès par opération, pas tout d'emblée.
  - **Moindre privilège, validation des entrées, gouvernance du registre d'outils, surveillance continue** : plusieurs couches, pas une seule.

## 8. Écosystème et maturité

MCP est passé d'une initiative Anthropic (fin 2024) à un standard ouvert largement adopté (clients : Claude Desktop, Claude Code, IDE et agents divers ; nombreux serveurs officiels et communautaires : filesystem, git, bases de données, GitHub, etc.). La gouvernance est assurée par une fondation ouverte (Linux Foundation / Agentic AI Foundation). Le protocole reste en évolution active (transports, autorisation, consentement).

## Synthèse

MCP est un protocole ouvert, fondé sur JSON-RPC 2.0, qui standardise la fourniture de contexte et de capacités à un modèle via une architecture **hôte / client / serveur** et trois primitives serveur (**tools, resources, prompts**). Deux transports : **stdio** (local, mono-client, un sous-processus lancé par une commande) et **Streamable HTTP** (distant, multi-clients, avec autorisation OAuth 2.1). Dans l'environnement Claude, on met en place un serveur par un fichier de configuration (`claude_desktop_config.json`), par la commande `claude mcp add` (Claude Code), par des connecteurs (claude.ai), ou par les paramètres `mcp_servers`/`mcp_toolset` de l'API et les vaults des Managed Agents. Le rapport aux CLI est intime : un serveur local **est** une commande, un CLI existant peut être **exposé** comme serveur, et le client (Claude Code) est lui-même un CLI. La contrepartie est une surface de sécurité élargie (prompt injection, tool poisoning) qui exige HITL, moindre privilège et autorisation robuste.

## Limites

- Écosystème et versions périssables (2026-07-18) ; transports et autorisation évoluent.
- La fondation décrit le protocole et sa configuration, pas l'écriture détaillée d'un serveur (SDK spécifiques).
- Les détails d'implémentation des connecteurs Claude (Desktop/claude.ai) peuvent changer d'une version à l'autre.
- Les mitigations de prompt injection restent un problème ouvert du champ.

## Sources

- Model Context Protocol - Architecture overview : https://modelcontextprotocol.io/docs/learn/architecture
- Model Context Protocol - Spécification (dépôt) : https://github.com/modelcontextprotocol/modelcontextprotocol
- Model Context Protocol - Autorisation (tutoriel sécurité) : https://modelcontextprotocol.io/docs/tutorials/security/authorization
- Claude Code - Connect to MCP servers : https://code.claude.com/docs/en/mcp-quickstart
- Claude Help Center - Local MCP servers on Claude Desktop : https://support.claude.com/en/articles/10949351-getting-started-with-local-mcp-servers-on-claude-desktop
- MCP explained (overview technique) : https://codilime.com/blog/model-context-protocol-explained/
- Model Context Protocol - Wikipedia : https://en.wikipedia.org/wiki/Model_Context_Protocol
- MCP Security Risks & Best Practices : https://www.truefoundry.com/blog/mcp-security-risks-best-practices
- MCP threat modeling (tool poisoning, prompt injection), MDPI : https://www.mdpi.com/2624-800X/6/3/84
- MCP OAuth 2.1 / PKCE (guide) : https://www.osohq.com/learn/authorization-for-ai-agents-mcp-oauth-21
- Skill `claude-api` (session, 2026-07-18) - connecteur MCP de la Messages API et vaults des Managed Agents.
