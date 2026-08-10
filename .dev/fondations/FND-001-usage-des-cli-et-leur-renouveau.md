---
type: fondation
id: FND-usage-des-cli-et-leur-renouveau
title: "Usage des CLI et leur renouveau à l'ère du cloud et de la manipulation de ressources"
status: draft
date: 2026-08-09
sujet: "Interfaces en ligne de commande : propriétés, histoire, causes du renouveau, modèle orienté ressources"
methodologie: "revue documentaire sur sources publiques, faits datés vérifiés à la source"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# FND-001 - Usage des CLI et leur renouveau à l'ère du cloud et de la manipulation de ressources

> Recherche de fondation sur l'interface en ligne de commande : ce qui la distingue, pourquoi elle a reculé, et les cinq causes datées de son retour. La cause la plus récente est celle qui concerne le plus `clia` : l'agent IA travaille mieux avec un CLI qu'avec une API.

## Objet et question de recherche

Cette recherche établit la base factuelle nécessaire à la décision d'adopter un CLI comme composant du système `clia`. Elle répond à quatre questions.

Qu'est-ce qui distingue techniquement un CLI d'une autre interface ? Pourquoi le CLI, donné pour obsolète dans les années 1990, est-il redevenu l'interface de référence des outils d'infrastructure ? Quel modèle de conception s'est imposé pour les CLI qui manipulent des ressources ? Et qu'est-ce qui, dans tout cela, est transposable à un système de travail documentaire augmenté par IA ?

## Méthode et limites

Recherche documentaire sur sources publiques, menée le 2026-08-09. Les faits datés ont été vérifiés par consultation directe des sources primaires quand elles existent (documentation officielle, billets d'annonce, spécifications).

Trois limites doivent être connues du lecteur.

La littérature académique sur les interfaces en ligne de commande est mince : le sujet est traité par la pratique et par des guides normatifs, non par la recherche. Les sources principales sont donc des documents de conception d'éditeurs et des guides communautaires, dont l'autorité vient de leur adoption et non d'une revue par les pairs.

L'affirmation quantitative sur le gain de contexte des agents (section 4.5) est rapportée par une source secondaire qui l'attribue à Anthropic. Elle est citée comme rapportée, non comme vérifiée à la source primaire.

La section 7, sur ce qui est transposable à `clia`, n'est pas de la recherche mais de l'interprétation. Elle est séparée du reste pour cette raison.

## 1. Ce qui distingue un CLI

Quatre propriétés, dont trois sont partagées avec d'autres interfaces et une seule est réellement distinctive.

| Propriété | Ce qu'elle signifie | Partagée avec |
|---|---|---|
| **Textualité** | Entrée et sortie sont du texte, lisible par un humain et analysable par une machine | Les API |
| **Déterminisme** | Mêmes entrées, mêmes sorties. Aucune improvisation | Les API |
| **Scriptabilité** | L'appel peut être enregistré, rejoué, versionné | Les API |
| **Composabilité** | La sortie d'une commande est l'entrée d'une autre, sans intégration préalable | **Propre au CLI** |

La composabilité est la propriété distinctive. Une API demande un client, une authentification et un contrat de sérialisation pour être combinée à une autre. Un CLI se combine par le shell, sans code d'intégration. C'est cette propriété qui explique la longévité du modèle, et c'est elle que la section 4.5 retrouve comme argument principal en faveur des CLI pour les agents.

## 2. La lignée Unix

Le modèle est formulé dans les années 1970 autour d'Unix, et sa formulation la plus citée est celle de Doug McIlroy : écrire des programmes qui font une seule chose et la font bien, et qui travaillent ensemble en traitant des flux de texte, parce que le texte est l'interface universelle.

Trois conséquences de cette formulation ont survécu cinquante ans.

L'outil est petit et spécialisé, l'assemblage se fait à l'extérieur.

Le format d'échange est le texte, ce qui rend l'interface indépendante des langages d'implémentation.

L'utilisateur assemble lui-même, ce qui déplace le pouvoir de l'éditeur vers l'usager.

Ce dernier point est un fait politique autant que technique, et il explique en partie l'attachement durable d'une partie des praticiens à ce modèle.

## 3. Le creux, et ce qu'il a coûté

Des années 1990 au milieu des années 2000, l'interface graphique devient l'interface par défaut, y compris pour l'administration de systèmes. Le CLI passe pour une survivance.

Le coût de ce creux est identifiable a posteriori : les opérations effectuées par interface graphique ne laissent pas de trace rejouable. Une configuration produite par des clics n'est ni versionnable, ni reproductible, ni auditable. C'est exactement le problème que la décennie suivante devra résoudre, et le CLI en était la réponse déjà disponible.

## 4. Le renouveau, en cinq causes datées

### 4.1 Le cloud transforme l'infrastructure en API (2013)

Quand l'infrastructure devient un ensemble de ressources accessibles par API, la console web cesse de suffire : elle ne permet ni la répétition, ni l'automatisation, ni la trace.

L'AWS CLI version 1 est mise à disposition générale le 2 septembre 2013. Les CLI équivalents des autres fournisseurs suivent. À partir de là, le CLI n'est plus un outil de nostalgie mais le mode d'accès normal à l'infrastructure.

Le point de bascule n'est pas technique, il est économique : une opération d'infrastructure doit pouvoir être répétée mille fois sans intervention humaine.

### 4.2 Le déclaratif et le modèle orienté ressources (années 2010)

La deuxième cause est plus profonde que la première, et c'est celle qui intéresse directement `clia`.

Avec Kubernetes, le CLI cesse d'être un exécuteur d'ordres pour devenir un **client d'un état désiré**. La commande `kubectl apply` prend un fichier de configuration décrivant l'état voulu, calcule la différence avec l'état courant, et applique cette différence. Elle est idempotente : l'exécuter plusieurs fois est sans effet supplémentaire, elle crée la ressource si elle n'existe pas et la met à jour si elle existe.

Trois propriétés en découlent, et elles changent la nature de l'outil.

L'utilisateur n'a pas besoin de connaître l'état courant. Il déclare l'état voulu.

Le fichier de configuration devient la source de vérité, versionnable, relisible, opposable. Le CLI n'est que le moyen de la faire advenir.

L'opération devient rejouable sans danger, ce qui autorise l'automatisation.

Google formalise le modèle sous-jacent dans ses recommandations de conception d'API, notamment l'AIP-121 sur la conception orientée ressources. Le principe y est énoncé simplement : on modélise des **ressources nommées individuellement** et les relations entre elles, et on expose un **petit ensemble de méthodes standard** qui couvrent la plupart des opérations courantes, typiquement lister, obtenir, créer, mettre à jour, supprimer. Les opérations qui ne s'y réduisent pas sont des méthodes personnalisées, et elles restent l'exception.

C'est le renversement décisif. La grammaire d'un CLI moderne n'est pas une liste de commandes, c'est un **produit cartésien de ressources et de verbes**. `kubectl get pods`, `kubectl get services` : le verbe est stable, la ressource varie. Un nouveau type de ressource hérite de tous les verbes existants sans que le CLI change.

### 4.3 Le CLI comme surface produit (2020)

La troisième cause est un changement de statut : le CLI devient une partie du produit, conçue et soignée comme telle, et non un accessoire d'administration.

GitHub CLI atteint la version 1.0 le 17 septembre 2020. Le billet d'annonce donne des chiffres d'usage de la période bêta qui disent l'ampleur du besoin : plus de 250 000 pull requests créées, plus de 350 000 fusions effectuées, plus de 20 000 tickets ouverts depuis le terminal.

Ce que cette cause établit : un CLI peut être l'interface principale d'un service dont l'interface web est excellente. Les deux ne sont pas en concurrence, elles servent deux régimes d'usage, l'exploration et la répétition.

### 4.4 La conception se formalise (2010-2020)

Le renouveau produit sa propre littérature normative. Deux corpus se sont imposés.

Les **12 facteurs des applications CLI**, formulés chez Heroku par analogie avec les douze facteurs des applications web. Ils portent sur des propriétés concrètes : aide intégrée de qualité, complétion du shell, comportement en cas d'absence d'arguments, gestion des erreurs, sortie exploitable par une machine autant que lisible par un humain.

Les **Command Line Interface Guidelines**, publiées sur `clig.dev`, qui se donnent explicitement pour tâche de reprendre les principes Unix traditionnels et de les actualiser. Leur orientation est résumée par leur mot d'ordre : conception centrée sur l'humain d'abord. Elles couvrent les messages d'erreur, la cohérence des drapeaux, la composabilité, la structure en sous-commandes.

Ce que ce corpus établit : la qualité d'un CLI est une question de conception, avec des critères énonçables, et non une affaire de goût. Deux critères y reviennent et méritent d'être retenus. L'aide intégrée fait partie de l'outil, pas de sa documentation. Et la sortie doit servir deux publics à la fois, l'humain qui lit et le programme qui analyse.

### 4.5 L'agent IA préfère le CLI à l'API (2024-2026)

La cause la plus récente, et celle qui concerne le plus directement `clia`.

Un agent conversationnel qui doit agir sur un système peut le faire par appel d'API ou par commande. La pratique des deux dernières années fait converger les praticiens vers la seconde, et les arguments avancés sont au nombre de quatre.

**L'interface est stable et déjà authentifiée.** Un CLI officiel encapsule une API derrière une surface de terminal qui gère l'authentification et la sérialisation. L'agent appelle une commande et lit une sortie structurée, sans avoir à construire ni maintenir un client.

**La composabilité vaut pour l'agent comme pour l'humain.** Un agent qui dispose d'un terminal peut enchaîner des commandes, filtrer, transformer, sans intégration préalable pour chaque combinaison.

**La divulgation progressive économise le contexte.** C'est l'argument le plus fort. Une commande retourne exactement ce qu'on lui demande, là où une API tend à retourner des objets complets. Un agent qui cherche une occurrence dans un dépôt lance une recherche et lit le résultat filtré, sans charger l'arborescence entière dans sa fenêtre de contexte. Le contexte est traité comme une ressource rare, ce qu'il est.

**Le gain mesuré est important.** Une source secondaire rapporte un résultat attribué à Anthropic, selon lequel laisser un agent écrire du code appelant des outils, plutôt que d'effectuer des appels d'outils directs, a fait passer une tâche de 150 000 à 2 000 jetons, soit une réduction de 98,7 pour cent. Le chiffre est rapporté, non vérifié à la source primaire, et son ordre de grandeur suffit à l'argument.

Un cinquième argument, moins souvent formulé, mérite d'être ajouté : le **déterminisme**. Un agent est non déterministe par nature. Lui donner un outil déterministe permet de partager la responsabilité : ce que le CLI garantit, l'agent n'a plus à le garantir. C'est la seule manière connue de rendre vérifiable une partie du travail d'un agent.

## 5. Le modèle orienté ressources, en détail

Cette section rassemble ce que les sources établissent du modèle, parce que c'est lui que `clia` transpose.

### 5.1 Les deux axes

Une ressource est un objet nommé individuellement, d'un type déclaré, adressable. Un verbe est une opération standard applicable à un type.

La grammaire d'un CLI orienté ressources s'exprime donc en deux axes indépendants. Les sources montrent deux ordres possibles.

| Ordre | Exemple | Effet |
|---|---|---|
| Verbe puis nom | `kubectl get pods` | Le verbe est mis en avant. Court à taper, familier |
| Nom puis verbe | `gh pr create`, `az group list` | La ressource est mise en avant. Extensible par ressource |

Les deux sont attestés dans des outils majeurs. Le second est plus fréquent dans les CLI récents et se prête mieux à l'extensibilité, parce qu'ajouter une ressource y ajoute une branche entière sans toucher aux branches existantes.

### 5.2 Le petit ensemble de méthodes standard

Le principe énoncé par l'AIP-121 est qu'un petit ensemble de méthodes couvre la plupart des besoins, et que les opérations spécifiques restent l'exception. L'ensemble canonique est : lister, obtenir, créer, mettre à jour, supprimer.

La conséquence pratique est une contrainte de conception forte : chaque fois qu'un besoin ne se réduit pas à l'un de ces verbes, il faut se demander si le modèle de ressources est bon avant d'ajouter un verbe.

### 5.3 L'idempotence

Une opération idempotente peut être répétée sans effet supplémentaire. C'est ce qui rend l'automatisation sûre, et c'est la propriété que `kubectl apply` illustre : la commande converge vers l'état déclaré, quel que soit l'état de départ.

L'idempotence a un coût : elle oblige l'outil à savoir lire l'état courant avant d'agir, donc à disposer d'une représentation de cet état.

## 6. Ce que la littérature établit sur la conception

Sept principes reviennent dans les guides et méritent d'être retenus comme critères.

| Principe | Formulation |
|---|---|
| Aide intégrée | L'aide fait partie de l'outil. Chaque commande et sous-commande en a une |
| Deux publics | La sortie doit être lisible par un humain et analysable par un programme |
| Cohérence des drapeaux | Les mêmes options signifient la même chose partout dans l'outil |
| Comportement sans argument | Une invocation nue affiche l'aide ou l'état, elle ne fait rien de destructeur |
| Erreurs utiles | Un message d'erreur dit ce qui a échoué et ce qu'il faut faire |
| Composabilité | La sortie doit pouvoir alimenter une autre commande |
| Découvrabilité | Complétion du shell, noms prévisibles, structure devinable |

## 7. Ce qui est transposable à clia, et ce qui ne l'est pas

Cette section est de l'interprétation, non de la recherche. Elle est séparée pour cette raison.

### 7.1 Ce qui se transpose directement

**Le modèle orienté ressources.** `clia` manipule des ressources typées au sens de `ADR-001` : un type déclaré, un identifiant, un emplacement. C'est exactement l'objet que le modèle décrit. La grammaire en deux axes s'y applique sans effort : lister, obtenir, créer, valider, par type de ressource.

**L'extensibilité par ressource.** L'ordre nom puis verbe permet d'ajouter un type de ressource sans toucher aux autres branches du CLI. C'est ce que `RES-001` appelle l'invariant d'extensibilité, retenu par `ADR-001`.

**Le déterminisme comme partage de responsabilité.** C'est le point le plus important de cette recherche pour `clia`. `ADR-002` D1 assigne à `clia` le rôle de garant du déterminisme, distinct de l'agent IA. La section 4.5 montre que ce partage n'est pas une préférence locale mais la pratique qui s'impose : on donne à l'agent un outil déterministe pour que ce que l'outil garantit cesse d'être à la charge de l'agent.

**La sortie à deux publics.** Dans un système à trois agents, la sortie de `clia` est lue par un humain et par un agent IA. C'est la formulation exacte du principe, avec un public de plus.

**L'idempotence, avec sa contrainte.** Une commande de validation ou d'installation doit pouvoir être rejouée. Ce qui suppose que `clia` sache lire l'état courant, donc qu'un état soit représenté quelque part. C'est précisément ce que le fichier d'état d'installation prévu par `resource-types.yaml` et jamais produit devait porter.

### 7.2 Ce qui ne se transpose pas

**L'état désiré déclaré dans un fichier séparé.** Dans le modèle Kubernetes, le fichier décrit l'état voulu et l'outil fait converger le système. Dans `clia`, la ressource **est** l'état : il n'y a pas de système distinct à faire converger. La notion d'application déclarative n'a donc pas d'objet ici, sauf pour l'installation du harnais dans un dépôt, qui est le seul cas où un état désiré et un état constaté diffèrent.

**Le petit ensemble de méthodes standard, appliqué au contenu.** Créer une ressource n'est pas une opération mécanique : c'est un travail de rédaction, encadré par un skill. `clia` peut créer le fichier, poser le frontmatter, attribuer le numéro ; il ne peut pas produire le contenu. La frontière entre ce que le CLI fait et ce que l'agent fait passe exactement là, et elle est plus haute que dans les CLI d'infrastructure.

**La sortie machine comme format principal.** Les CLI d'infrastructure produisent du JSON destiné à d'autres programmes. Dans `clia`, le consommateur principal reste un humain ou un agent qui lit du texte. La sortie structurée est utile pour la validation, pas pour le contenu.

### 7.3 Ce que la recherche ne dit pas

Aucune source consultée ne traite du cas d'un CLI dont les ressources sont des documents rédigés plutôt que des objets d'infrastructure. La transposition faite en 7.1 est raisonnée, pas attestée.

Aucune source ne traite de la question de la localisation du CLI par rapport au système qu'il outille, c'est-à-dire de la question que l'analyse `ANL-002` doit trancher. Cette question est de génie logiciel ordinaire et ne relève pas de la littérature sur les CLI.

## Sources

- [AIP-121 : Resource-oriented design](https://google.aip.dev/121)
- [AIP-123 : Resource types](https://google.aip.dev/123)
- [Cloud API Design Guide, Google](https://docs.cloud.google.com/apis/design)
- [Declarative Management of Kubernetes Objects Using Configuration Files](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config)
- [Kubectl Reference Docs](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
- [aws/aws-cli, dépôt officiel](https://github.com/aws/aws-cli)
- [About the AWS CLI versions](https://docs.aws.amazon.com/cli/latest/userguide/welcome-versions.html)
- [GitHub CLI 1.0 is now available, GitHub Blog, 2020-09-17](https://github.blog/news-insights/product-news/github-cli-1-0-is-now-available/)
- [Command Line Interface Guidelines, clig.dev](https://clig.dev/)
- [cli-guidelines/cli-guidelines, dépôt](https://github.com/cli-guidelines/cli-guidelines)
- [12 Factor CLI Apps, Jeff Dickey](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)
- [Why CLIs Are Better for AI Coding Agents Than IDEs, Firecrawl](https://www.firecrawl.dev/blog/why-clis-are-better-for-agents)
- [What is a CLI and Why AI Agents Prefer It, Firecrawl](https://www.firecrawl.dev/blog/why-is-cli)
- [Best CLI Tools for Your AI Agents in 2026, Firecrawl](https://www.firecrawl.dev/blog/best-cli-tools)

## Limites et lacunes

**Sources d'autorité inégale.** Les spécifications de Google et la documentation Kubernetes sont des sources primaires. Les guides communautaires tirent leur autorité de leur adoption. Les billets d'analyse sur les agents et les CLI sont récents, commerciaux pour certains, et non revus.

**Le chiffre de 98,7 pour cent est rapporté, pas vérifié.** Il provient d'une source secondaire qui l'attribue à Anthropic.

**Aucune source sur le CLI appliqué à des ressources documentaires.** La section 7.1 est une transposition raisonnée.

**Pas de traitement de l'échec.** La littérature consultée décrit ce qui marche. Aucune source ne documente les CLI orientés ressources qui ont échoué, ni pourquoi. C'est une lacune de la recherche, et elle est symétrique de celle que `ANL-001` relève dans le corpus local, où cinq CLI ont été réinventés sans qu'aucun bilan d'échec ne soit écrit.

## Relations

- `reference` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)
