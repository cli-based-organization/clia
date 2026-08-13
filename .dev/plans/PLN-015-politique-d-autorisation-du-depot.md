---
type: plan
id: PLN-015
title: "Politique d'autorisation du dépôt"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-plan: propose
date: 2026-08-13
initiateur: agent
sert: [FNC-006]  # étend la configuration de l'utilisateur : clia config ia policy
porte-sur: [BUG-001, .claude/settings.json, .claude/hooks]
---

# PLN-015 - Politique d'autorisation du dépôt

> Le dépôt a écrit ses interdits et jamais ses permissions. Quatorze interruptions sur quinze viennent de là : une ligne de commande qu'aucune règle ne peut comparer, et aucun mécanisme pour la juger sur son contenu.

## Statut

`propose`. **Partiellement exécuté par la tâche 12 de `SES-002`, le 2026-08-13** — `MET-005` étape 5 : un plan partiellement exécuté ne passe pas à `execute`.

| Chantier | Sort |
|---|---|
| A | **Exécuté, critère non satisfait.** Un hook décide dans le sens du refus, pas dans celui de l'autorisation |
| B | **Exécuté.** `MET-005` étape 3 porte les deux règles et les six cas |
| C | **Exécuté à la réexécution du 2026-08-13 16:30.** `clia config ia policy check` |

**Le chantier C avait été déclaré hors d'atteinte, et c'était une erreur.** Le premier passage a conclu qu'« une commande qui diagnostique une politique dont on ne sait pas si elle peut agir n'a pas d'objet ». **On le sait désormais** : le chantier A a établi qu'un hook refuse et n'autorise pas. Le diagnostic a donc un objet précis — dire ce que le dépôt peut et ce qu'il ne peut pas, cette impossibilité comprise.

**Une connaissance négative reste une connaissance.** C'est ce que le premier passage n'a pas vu.

**Ce que la mesure du chantier A a établi.** Le hook est appelé et sa décision `deny` est appliquée ; sa décision `allow` ne lève pas une règle `ask` du projet. Et le mode non interactif ne produit jamais la demande de confirmation que `BUG-001` constate : la piste D est **indémontrable par script**, non réfutée.

**Ce que le plan avait prévu** : « si la mesure échoue, tout le plan tombe ». La prévision était trop nette — le chantier B tient, et il est exécuté.

Produit par la tâche 10, qui ne l'a pas exécuté : `MET-005` étape 1.

## Intention

Que l'agent aille au bout d'une tâche sans que l'humain ait à répondre quinze fois, **sans que le jugement disparaisse pour autant**.

**Cible mesurable.** Sur la tâche suivante, le nombre d'interruptions dues à l'analyse statique du shell est nul, et la politique qui l'a permis se lit dans un fichier du dépôt.

## Chantiers

### Chantier A - Mesurer qu'un hook peut autoriser

| Élément | Valeur |
|---|---|
| **Livrable** | Un compte rendu de mesure dans le journal de la tâche qui l'exécute |
| **Critère de réussite** | Sur un dépôt jetable, avec un hook d'essai qui rend `allow`, une commande contenant `$(date)` s'exécute **sans demande de confirmation** ; le même essai sans le hook la déclenche |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Pourquoi ce chantier existe.** Le hook du dépôt sort en 0 ou en 2. Le code 0 signifie « je ne m'oppose pas », pas « j'autorise » : la demande a lieu ensuite. Qu'un hook puisse rendre une décision d'autorisation est documenté et **n'a jamais servi ici**.

**Si la mesure échoue, tout le plan tombe** et la piste B de `ANL-012` — le mode de permission à l'invocation — redevient la seule. C'est la raison pour laquelle ce chantier est premier et ne dépend de rien.

### Chantier B - La règle de conduite, dans le harnais

| Élément | Valeur |
|---|---|
| **Livrable** | Une section de `MET-005`, ou une méthodologie propre |
| **Critère de réussite** | Les six interruptions de `BUG-001` que la conduite aurait évitées sont reprises comme exemples, chacune avec la forme qui ne l'aurait pas déclenchée |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Ce que la règle dit**, tirée du classement de `ANL-012` C2 : écrire un fichier avec l'outil d'écriture et non par un document en place ; écrire un chemin en toutes lettres plutôt qu'une variable, quand il ne sert qu'une fois.

**Ce qu'elle ne prétend pas.** Elle supprime six interruptions sur quinze. Les huit autres sont des scripts d'épreuve, et aucune discipline ne les rendra analysables statiquement.

**Ce chantier est gratuit et indépendant du reste.** Il tient même si le chantier A échoue.

### Chantier C - `clia config ia policy check`

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/config.sh`, verbe `ia policy check` |
| **Critère de réussite** | Sur ce dépôt, la commande affiche pour chacun des quatre mécanismes — `allow`, `deny`, `ask`, hooks — s'il est présent, et nomme au moins un point manquant ; sortie en 0 si la politique est complète, 1 sinon |
| **Limite de temps** | 2 heures |
| **Dépend de** | A |

**Ce que la commande répond** : « ce dépôt peut-il exécuter une tâche sans interruption, et sinon, qu'est-ce qui manque ? » C'est la première des deux commandes que `BUG-001` demande.

**Elle ne modifie rien.** Diagnostiquer et corriger sont deux verbes, comme `clia setup check` et `init`.

## Ce qui est sorti du plan, et pourquoi

**Deux chantiers manquent pour que `BUG-001` soit clos** : le hook de politique lui-même, et `clia config ia policy apply`. Ils ne sont pas ici.

| Point sorti | Ce qui le bloque |
|---|---|
| Le hook qui autorise, et son banc de cas | `NON-040` Q1 et Q3 : jusqu'où la politique autorise, et si l'écriture hors du dépôt reste demandée |
| `clia config ia policy apply` | Dépend du précédent : appliquer suppose de savoir quoi |

**Aucun critère de réussite exécutable ne peut être écrit pour eux.** « Le hook autorise les commandes légitimes » n'est pas mesurable tant que « légitime » n'est pas défini, et le définir décide de ce qu'un agent peut faire sans que personne le voie. `PDC-003` interdit d'appeler cela un chantier SMART.

**Ce n'est pas une paralysie.** Les trois chantiers du plan suppriment déjà six interruptions sur quinze, établissent que le mécanisme existe, et rendent l'état de la politique lisible par une commande. Le reste attend une réponse à cinq questions.

## Livrables attendus

| Livrable | Chantier |
|---|---|
| Compte rendu de mesure du mécanisme d'autorisation | A |
| Règle de conduite dans `MET-005` | B |
| `clia config ia policy check` | C |

**Durée totale déclarée : 4 heures.**

## Objections de l'agent

**Le plan traite la moitié du bogue.** `BUG-001` sera encore ouvert à la fin : les interruptions dues aux scripts d'épreuve resteront tant que `NON-040` n'est pas répondue. Le plan le déclare plutôt que de le masquer.

**Le chantier A peut invalider les deux autres.** Si un hook ne peut pas autoriser, C n'a plus d'objet sous cette forme. L'ordre des chantiers le prend en compte, le coût est d'une heure.

**La cible mesurable porte sur une tâche future.** « Zéro interruption sur la tâche suivante » ne se vérifie qu'après, et dépend de ce que cette tâche fait. C'est la seule forme honnête : le bogue se constate à l'usage.

## Relations

- `derive-de` [ANL-012](../analyses/ANL-012-interruptions-de-l-execution-autonome.md)
- `porte-sur` [BUG-001](../bogues/BUG-001-execution-de-claude-cli-sans-interruption.md)
- `reference` [NON-040](../objections/NON-040-portee-de-la-politique-d-autorisation.md)
- `reference` [MET-005](../methodologies/MET-005-execution-d-un-plan.md)
