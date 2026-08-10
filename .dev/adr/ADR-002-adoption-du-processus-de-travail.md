---
type: adr
id: ADR-adoption-du-processus-de-travail
title: "Adoption du processus de travail collaboratif humain, agent IA et cli"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-09
decideurs: ["human:jvtrudel (à statuer)", "claude-opus-5 (rédaction)"]
sources:
  - ANL-001-observation-corpus-repos-et-pratiques
  - ADR-adoption-de-la-notion-de-ressource
  - RES-objection
  - "CONSTITUTION.md, archivé dans .dev/archives/"
  - "workspace/session.md, tâche 4 du 2026-08-09"
definition-associee: aucune
skill-associe: aucun
---

# ADR-002 - Adoption du processus de travail collaboratif humain, agent IA et cli

> Acte le mécanisme de travail du système d'information à trois agents : qui fait quoi, comment une demande devient un livrable, comment le désaccord se traite, et ce qui doit rester écrit. `ADR-001` décide de la nature de ce que le travail produit ; ce document décide de la manière dont il le produit.

## Statut de cette décision

`propose`. Sept objections ouvertes portent sur ce document ou sur ce qu'il présuppose, dont trois bloquantes héritées de `ADR-001` et deux ouvertes par la présente tâche, `NON-009` sur le statut de la session et `NON-010` sur les rôles des trois agents.

Le processus décrit ici n'est pas une invention : il est pratiqué dans ce dépôt depuis le 2026-07-08 et il a produit les trois tâches de la session du 2026-08-09. La section « Ce que ce processus a déjà produit » en rend compte, y compris de deux points où la pratique s'écarte de la règle écrite.

## Contexte

### Ce qui existe déjà

Le `CONSTITUTION.md` archivé de ce dépôt porte un processus complet et opérant : gouvernance objection-sociocratique, cycle de vie du plan en cinq états, canaux d'objection séparés, règle absolue de non-exécution sous objection ouverte, breakpoint et approbation partielle, classification des documents par droits d'édition, interface par fichiers plutôt que par conversation, et rôle de `clia` comme gardien déterministe de l'intégrité.

Ce document a été archivé le 2026-08-08 par le refactor `2373ec7`, avec la quasi-totalité du dépôt. Le processus a donc continué d'être pratiqué sans document en vigueur qui le porte : les trois tâches de la session du 2026-08-09 l'ont suivi de mémoire et par imitation du corpus.

`ADR-002` reprend ce qui a été éprouvé, écarte ce qui ne l'a pas été, et acte les deux ruptures que la pratique a déjà consommées.

### Ce que l'observation impose

`ANL-001` établit cinq faits qui contraignent le processus.

| Fait mesuré | Contrainte |
|---|---|
| Travail par vagues, creux jusqu'à quatre mois, 36 pour cent des commits entre 21h et 6h | Le coût de reprise domine. Rien ne doit dépendre de la mémoire d'une session |
| Tâche médiane de 30 minutes, chantiers de 44 tâches en 14 jours | Deux échelles cohabitent. Le processus doit servir les deux |
| 22 pour cent des tâches journalisées déclarées partielles | Le partiel est un état normal, pas un échec |
| Demandes longues, avec renvois inter-dépôts, interdictions et questions ouvertes | Le point d'entrée doit rester en texte libre |
| Sept concepts perdus, cinq réinventions de la même idée, quatre ruptures de cap non tracées | La journalisation et l'objection sont des dispositifs de mémoire, pas de conformité |

### Le problème précis

Un système à trois agents dont deux sont non humains doit dire qui décide, qui produit, qui garantit, et ce qui se passe quand ils ne sont pas d'accord. Sans cela, l'agent IA comble les silences par des conventions implicites, et le corpus montre le résultat : un `INTENTION.md` écrasé par du contenu générique, dix-huit logs recopiés d'un dépôt à l'autre, trente-trois variantes du même fichier de harnais.

## Décision, en une phrase

> Le travail se fait par **sessions** portant chacune une intention, un ou plusieurs livrables et un critère de convergence ; toute demande y est d'abord **analysée** puis journalisée ; la production est faite de **ressources typées** ; le comportement de l'agent IA est encadré par un **ensemble conventionné de harnais** ; tout désaccord, ambiguïté ou déviation par rapport à l'intention ultime est signalé **au moment où il est identifié** par une objection, que l'humain comme l'agent peuvent émettre ; et la **journalisation est obligatoire**, sans exception.

## Décisions détaillées

### D1 - Trois agents, trois rôles non interchangeables

**Décision.** Le système compte trois agents. Leurs rôles sont distincts et non substituables.

| Agent | Ce qu'il détient | Ce qu'il fait | Ce qu'il ne fait pas |
|---|---|---|---|
| **Humain** | L'intention, la décision, la responsabilité | Formule la demande, répond aux objections, arbitre, versionne | Il n'a pas à produire les livrables ni à tenir les conventions de forme |
| **Agent IA** | La capacité de production et d'analyse | Analyse la demande, produit les ressources, objecte, journalise | Il ne décide pas, ne modifie pas ce qui appartient à l'humain, n'opère pas git |
| **`clia`** | Le déterminisme | Garantit l'intégrité du système d'information : transitions d'état, inspection, validation | Il n'interprète rien, ne produit aucun contenu rédigé |

**Le cas de `clia` comme délégué.** Reprise d'une décision du `CONSTITUTION.md` archivé, dont la formulation est meilleure que ce qu'on écrirait à neuf : parce qu'il est déterministe et opéré par l'humain, `clia` peut légitimement muter des fichiers en édition humaine exclusive. C'est l'humain qui agit, via son outil. Cette règle est ce qui distingue un automatisme d'un agent : `clia` n'a pas de volonté propre, donc il n'a pas besoin de droits propres.

**Motif.** La séparation répond à l'incident fondateur du corpus : le premier log de `commission-scolaire-de-la-capitale` consiste à réparer un `INTENTION.md` écrasé par l'agent avec du contenu générique. Les droits d'écriture ne sont pas une politesse, ce sont une protection.

**Alternative écartée.** Un modèle à deux agents, humain et IA, où le cli est un simple outil sans statut. Écartée parce que le déterminisme est une propriété qui mérite d'être nommée : c'est la seule des trois qui permette de garantir quelque chose. `ANL-001` mesure d'ailleurs ce que son absence coûte, avec un `CONSTITUTION.md` de zéro octet et trois `INTENTION.md` identiques désignant le mauvais client, jamais détectés.

### D2 - Le travail est segmenté en sessions

**Décision.** L'unité de segmentation du travail est la **session**. Une session porte trois choses.

| Élément | Rôle | Quand il est fixé |
|---|---|---|
| **Intention** | Ce que la session cherche à accomplir | À l'ouverture |
| **Livrables** | Ce qu'elle doit produire | À l'ouverture, révisable |
| **Critère de convergence** | Ce à quoi on reconnaîtra qu'elle peut se clore | À tout moment, y compris après le démarrage |

Le critère de convergence n'a pas à être défini à l'ouverture. Une session peut commencer par un travail d'exploration dont le résultat rend seulement possible la formulation du critère.

**Motif.** La session est le seul contenant que la pratique de ce dépôt ait réellement éprouvé : quatre sessions archivées, du 2026-07-09 au 2026-08-03. Elle répond directement à la contrainte de reprise : une session porte son propre contexte, et un agent qui la lit après quatre mois sait où il en est.

Le caractère différé du critère de convergence est fondé sur un fait de cette session même : la section `# CRITÈRE DE CONVERGENCE` de `workspace/session.md` a été ajoutée après la production des trois premières tâches, et son contenu, « le concept de ressource est bien défini, utilisable et instrumenté », n'aurait pas pu être formulé avant que l'observation soit faite.

**Alternative écartée.** Le couple issue non-smart plus ticket extreme-smart de `ticket-driven-ai`, borné à un livrable et douze heures. Écartée pour l'instant, et sans conviction : `ANL-001` établit au défaut D9 que la session est un contenant unique pour deux réalités, la tâche de trente minutes et le chantier de quarante-quatre tâches, et que le second n'a aucune structure interne. La session du 2026-07-31 formule elle-même ce manque. Trois réponses éprouvées existent dans le corpus et n'ont jamais été comparées.

**Faiblesse assumée.** Cette décision reconduit le défaut D9 au lieu de le résoudre. Elle est prise parce que la session fonctionne pour l'échelle courte et que rien ne justifie de la remplacer avant la comparaison que `NON-008` Q2 demande.

**Porte de sortie.** Si une session dépasse deux semaines ou vingt tâches, c'est le signe qu'il manque une échelle intermédiaire et que D2 doit être révisée.

### D3 - Toute demande passe par une analyse de la demande

**Décision.** Aucune demande n'est exécutée sans avoir été analysée d'abord. L'analyse comporte cinq temps.

1. **Validité.** La demande est-elle recevable : provient-elle du point d'entrée, porte-t-elle sur une tâche existante, est-elle exécutable dans l'état du dépôt ?
2. **Interprétation.** Que veut l'humain : intention, contexte, livrables attendus, portée exacte, ce qui est explicitement exclu ?
3. **Journalisation.** L'interprétation est écrite avant que le travail commence.
4. **Rédaction de la demande interprétée.** Ce que l'agent a compris, sous une forme que l'humain peut contredire.
5. **Validation de l'interprétation.** L'écart entre la demande et son interprétation est soit confirmé, soit soumis par une objection.

**Motif.** C'est le temps où les malentendus coûtent le moins cher. `ANL-001` mesure ce que leur absence coûte : trois dépôts de consultation portant le même `INTENTION.md` désignant le mauvais client, deux dépôts métiers portant l'intention du système lui-même. Aucun de ces défauts ne vient d'une faute de production ; tous viennent d'une demande mal cadrée.

**Ce que cette décision ne fait pas.** Elle pose le principe et les cinq temps, elle ne décrit pas la procédure. Celle-ci appartient à un skill d'analyse de la demande, qui n'existe pas. Le plan de son écriture est produit par `PLN-001`, à la demande de la tâche 4.

**Alternative écartée.** L'exécution directe, avec analyse implicite. Écartée parce qu'elle est indistinguable d'une analyse absente, et parce qu'elle ne laisse aucune trace contestable.

### D4 - La production est faite de ressources typées

**Décision.** Le résultat de toute tâche est une ou plusieurs ressources typées au sens de `ADR-001`. Une réponse conversationnelle n'est pas un résultat.

**Motif.** Renvoi à `ADR-001` D1, dont ce point est l'application au processus. La conséquence propre au processus est qu'une tâche n'est pas terminée quand l'agent a répondu, mais quand la ressource existe et est valide.

**Corollaire.** Avant d'exécuter, l'agent identifie le type de ressource à produire. Si le type n'existe pas, ou si sa définition ne couvre pas le cas, il ouvre une objection au lieu de produire une instance non conforme qui ferait précédent. C'est la règle A5 de `skl-001-ressource`, et la présente tâche en fournit le premier cas réel : le plan `PLN-001` est produit alors que le type Plan n'a aucune définition dans ce dépôt, ce qui est signalé par `NON-010`.

### D5 - Le comportement de l'agent est encadré par un ensemble conventionné de harnais

**Décision.** Le comportement de l'agent IA est fixé par des fichiers de harnais à noms conventionnés, chargés à chaque session, qui font autorité sur lui. Ils sont hors du modèle de ressources (`ADR-001` D8) et le gouvernent.

**Motif.** Un agent sans harnais comble les silences par ses propres conventions, et ces conventions ne survivent pas à la session. C'est la raison d'être du dispositif, et le corpus le démontre par l'absurde : `cryptosecops/noumanity+qguard`, registre de documents légaux et confidentiels partagés avec un tiers, ne porte aucun harnais et l'agent y travaille sans aucune règle.

**Ce que la décision ne règle pas, et c'est important.** Le mot « conventionné » suppose une convention partagée entre dépôts, et rien ne la maintient. `ANL-001` mesure le résultat : trente-trois `CLAUDE.md` pour dix-huit contenus distincts, trente-deux `CONSTITUTION.md` pour quinze contenus, dont un de zéro octet. Le harnais s'installe par copie, et la copie emporte les traces du dépôt source. `NON-006` Q3 et Q4 portent la question.

**Alternative écartée.** Placer les règles de comportement dans `.claude/`, répertoire propre à l'outil. Écartée par la règle C2 de `ticket-driven-ai`, dont le motif reste valable : `.claude/` est un espace de travail effaçable, et une règle qui n'existe que là disparaît sans trace.

### D6 - L'objection est émise au moment de l'identification, par l'un ou l'autre agent

**Décision.** Toute ambiguïté, incohérence, ou déviation par rapport à l'intention ultime est signalée **au moment où elle est identifiée**, par une objection, que l'humain comme l'agent IA peuvent émettre. L'objection déclare son effet, `bloquant`, `conditionnel` ou `informatif`, conformément à `RES-004`.

**Motif du signalement immédiat.** Une ambiguïté identifiée et non signalée est résolue par l'agent en silence, et sa résolution devient un fait accompli que personne n'a décidé. Le report a un second coût, mesuré : `ANL-001` établit que les questions ouvertes se perdent dans ce corpus, avec sept concepts abandonnés et cinq réinventions de la même idée.

**Rupture actée avec le processus antérieur.** Le `CONSTITUTION.md` archivé posait une règle absolue, aucune exécution tant qu'une objection reste ouverte, tempérée par un mécanisme de breakpoint et d'approbation partielle. Cette règle est remplacée par la déclaration d'effet à l'ouverture de l'objection.

Deux motifs à ce remplacement. La règle absolue, prise au mot, rend tout travail impossible dès la première objection sérieuse : les trois objections bloquantes ouvertes le 2026-08-09 auraient interdit les tâches 3 et 4. Et le mécanisme de compensation, breakpoint plus segments plus objections différées, demande de tenir un état à trois dimensions que rien ne vérifie.

**Ce que la rupture perd.** Le breakpoint offrait à l'humain un point d'arrêt déclaré à l'avance, ce que la déclaration d'effet ne donne pas. Si le besoin réapparaît, il est moins coûteux de le réintroduire comme propriété d'une session que comme propriété d'un plan.

**Porte de sortie.** Si des travaux avancent sur la base d'objections `conditionnel` jamais résolues, et que le provisoire s'installe, la règle absolue redevient préférable à la gradation.

### D7 - La journalisation est obligatoire

**Décision.** Toute tâche traitée produit un journal, sans exception, y compris une tâche dont le seul livrable est un plan ou une analyse. Une tâche n'est pas terminée tant que son journal n'est pas écrit.

**Motif.** Le journal est un dispositif de mémoire, non de conformité. Il porte trois choses que la ressource produite ne porte pas : ce que l'agent a compris de la demande, ce qu'il a écarté et pourquoi, et ce qu'il n'a pas réussi à faire. `ANL-001` établit que ces trois informations sont exactement celles que le corpus a perdues, et que leur absence explique les quatre ruptures de cap non tracées.

Le corpus fournit aussi la preuve que le journal fonctionne quand il existe : les soixante-neuf logs archivés de `clia` ont permis, huit mois plus tard, de reconstituer l'incident de l'`INTENTION.md` écrasé et d'en déduire l'origine d'une règle du harnais.

**Tension assumée.** La journalisation coûte. Le harnais actuel prescrit sept fichiers par requête pour des tâches dont la durée médiane observée est de trente minutes, et `ANL-001` en fait un défaut, D4. Cette décision maintient l'obligation et laisse le format ouvert : c'est le nombre de fichiers qui est en cause, pas le principe. `NON-002` Q5 porte la question du seuil.

**Alternative écartée.** Une journalisation à discrétion, réservée aux tâches importantes. Écartée parce que l'importance d'une tâche n'est connue qu'après, et que les tâches qu'on juge mineures sont précisément celles dont le raisonnement est perdu.

### D8 - L'interface de travail est le fichier, pas la conversation

**Décision.** La source de vérité est le fichier. La conversation sert à orienter vers les fichiers, à poser des questions et à porter les objections avant qu'elles soient écrites. Un contenu qui n'existe que dans la conversation n'existe pas.

**Motif.** C'est la condition de la contrainte de reprise, et le pendant nécessaire de `ADR-001` D1.

**Écart entre la règle et la pratique, signalé.** Le `CONSTITUTION.md` archivé allait plus loin : la réponse textuelle de l'agent devait se limiter au chemin du fichier produit et à un résumé d'une phrase. Cette règle n'est pas tenue, et elle ne l'a pas été non plus dans la session du 2026-08-09, où les réponses de l'agent ont compté plusieurs paragraphes.

Deux lectures s'affrontent, et ce document ne tranche pas. Soit la règle est juste et la pratique doit s'y plier. Soit la réponse conversationnelle a une fonction propre, celle de rendre lisible ce qui vient d'être produit et de porter les objections avant qu'elles soient écrites, et la règle doit être révisée. `NON-010` Q6 porte la question.

## Ce que ce processus a déjà produit

Cette section n'est pas une justification, c'est une mesure. Le processus décrit a été appliqué aux trois premières tâches de la session du 2026-08-09.

| Mesure | Résultat |
|---|---|
| Tâches traitées | 3 |
| Ressources produites | 25 fichiers markdown, plus un inventaire YAML de 166 dépôts |
| Tâches journalisées | 3 sur 3, avec 7 fichiers de journal chacune |
| Objections émises par l'agent | 10, dont 3 bloquantes |
| Objections émises par l'humain | 0 |
| Ambiguïtés de la demande signalées | 3, dont une remarque tronquée dans la tâche 4 |
| Décisions actées | 2 ADR, tous deux au statut `propose` |

Deux écarts entre le processus écrit et le processus pratiqué doivent être notés, parce que les taire reproduirait le défaut que ce document combat.

**Aucun plan n'a précédé l'exécution.** Le `CONSTITUTION.md` archivé exige que l'agent propose un plan avant d'exécuter, et que le plan passe par cinq états. Les trois tâches ont été exécutées directement. Ni l'humain ni l'agent ne l'ont signalé sur le moment. Cet écart n'est pas neutre : il retire à l'humain le point de contrôle qui précède la production.

**Les réponses conversationnelles ont dépassé la phrase prescrite.** Voir D8.

## Conséquences

### Ce que la décision apporte

Le travail devient reprenable. Une session porte son intention, ses livrables et son critère de convergence ; un journal porte ce qui a été compris et écarté.

Le désaccord devient un objet. Dix objections écrites en une journée, dont trois qui bloquent, valent mieux qu'un accord tacite sur des questions non posées.

Les rôles sont opposables. L'agent ne décide pas, l'humain n'a pas à tenir les conventions de forme, `clia` ne rédige rien.

### Ce que la décision coûte

Sept fichiers de journal par tâche, pour une tâche médiane de trente minutes.

Une analyse de la demande avant toute exécution, dont le coût est visible et le bénéfice invisible quand elle réussit.

Un temps d'écriture d'objections qui n'est pas du temps de production.

### Ce que la décision ne règle pas

L'échelle intermédiaire entre la tâche et la session. D2 reconduit le défaut D9 de `ANL-001`.

Le statut de la session dans le modèle : `ADR-001` D8 l'exclut des ressources, D2 en fait l'unité du travail. `NON-009` porte la contradiction.

La convention des harnais entre dépôts. D5 emploie le mot « conventionné » sans mécanisme.

Le format de la journalisation, dont seul le principe est acté.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-009](../objections/NON-009-statut-de-la-session-et-convergence.md) | bloquant | D2 |
| [NON-010](../objections/NON-010-roles-des-agents-et-production.md) | conditionnel | D1, D4, D8 |
| [NON-002](../objections/NON-002-cout-du-modele.md) | bloquant | D7 |
| [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md) | bloquant | D1, D6 |
| [NON-008](../objections/NON-008-regime-de-travail.md) | informatif | D2, D6 |
| [NON-006](../objections/NON-006-portee-du-systeme.md) | conditionnel | D5 |

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `reference` [ADR-001](ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [RES-004](../ressources/RES-004-objection.md)
- `specifie` [PLN-001](../plans/PLN-001-point-d-entree-et-analyse-de-la-demande.md)
