---
type: analyse
id: ANL-001-03
title: "Observations sur la manière de travailler de l'humain"
version: 0.1.0
status: draft
date: 2026-08-09
sujet: "Régime de travail de l humain, mesuré"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Observations sur la manière de travailler de l'humain

> Ce que le corpus révèle du régime de travail réel : rythme, durée d'attention, forme des demandes, rapport à git, rapport à l'agent. Ces observations sont des contraintes de conception, pas des jugements.

## Rythme

Sur les 527 commits de 2026, la répartition horaire est la suivante.

| Tranche | Commits | Part |
|---|---|---|
| 00h à 06h | 97 | 18 pour cent |
| 06h à 09h | 22 | 4 pour cent |
| 09h à 12h | 67 | 13 pour cent |
| 12h à 17h | 123 | 23 pour cent |
| 17h à 21h | 123 | 23 pour cent |
| 21h à 24h | 95 | 18 pour cent |

Trente-six pour cent du travail versionné a lieu entre 21h et 6h. Vingt-et-un pour cent tombe le samedi ou le dimanche. Le mardi est le jour le plus productif, le lundi le moins.

L'activité annuelle est très inégale : creux profond de novembre 2025 à février 2026, entre sept et quatorze commits par mois, puis reprise brutale, 126 commits en mai, 207 en juin. Vingt-neuf dépôts sont créés en juin et juillet 2026, contre six en janvier et février.

**Conséquence pour la conception.** Le travail se fait par vagues intenses séparées de mois de latence. Un système qui suppose une pratique régulière ne survivra pas à ces creux. Deux exigences en découlent : le coût de reprise après trois mois d'absence doit être faible, et l'état du travail doit être lisible sans mémoire de session. C'est l'argument le plus fort en faveur du point d'entrée unique, et un argument contre les mécanismes qui exigent une discipline continue, comme la numérotation séquentielle manuelle.

## Durée d'attention

Les soixante-neuf logs de sortie archivés de `clia` déclarent des durées de tâche dont la médiane est de trente minutes, avec un maximum à quatre-vingt-dix minutes. Sur ces soixante-neuf tâches, quinze sont déclarées partielles, soit vingt-deux pour cent.

À l'échelle du dépôt, la durée de vie typique est de deux jours : trente-six dépôts du corpus ont un ou deux commits, et une trentaine de dépôts couvrent moins d'une semaine entre leur premier et leur dernier commit.

Les quatre sessions archivées de `clia` donnent une autre mesure.

| Session | Durée | Tâches |
|---|---|---|
| Offre de service commission scolaire | 37 heures | 21 |
| CLI installable | 6,5 jours | 4 |
| Fonctionnalités de base d'installation | 14 jours | 44 |
| Nettoyage pour la version 0.1.0 | 2,7 jours | 4 |

**Conséquence pour la conception.** Deux échelles cohabitent et le système n'en modélise qu'une. La tâche de trente minutes est bien servie par la session et le log. Le projet de deux semaines à quarante-quatre tâches ne l'est pas : rien ne le structure entre le début et la fin, et la troisième session en est la preuve. C'est exactement la tension que la session du 2026-07-31 nomme dans sa tâche 2, quand elle constate qu'il y a beaucoup à faire, qu'il est impossible de tout faire en même temps, et qu'il faut un moyen de garder en mémoire et de prioriser. Le ticket extreme-smart de la lignée A répondait à cette tension avec une timebox de douze heures. La session de `clia` l'a remplacé par un contenant plus souple, et la souplesse a rouvert le problème.

## Forme des demandes

Les tâches de session sont rédigées dans un style reconnaissable et constant. Un exemple pris dans la session du 2026-07-31, tâche 2, en donne la mesure : la tâche pose un titre catégorisé, `[conception] issues`, décrit l'état actuel, renvoie à deux autres dépôts par chemin relatif avec la notation `@`, insère une note d'intention entre parenthèses (`todo => ajouter Extreme smart aux principes de conception`), isole une section `Problématique =>`, énumère les livrables attendus (une recherche de fondation, une analyse), pose une dizaine de questions ouvertes, demande d'émettre des objections, et se termine par une interdiction explicite : ne pas implémenter le plan.

Six traits sont récurrents.

Le titre porte une catégorie entre crochets. Les catégories observées sont `conception`, `bogue`, `traitement des objections`.

Les renvois inter-dépôts sont fréquents et se font par chemin relatif. L'humain travaille en gardant plusieurs dépôts en vue simultanément.

L'interdiction est aussi importante que la demande. `Ne pas implémenter le plan`, `Ne pas implémenter`, apparaissent régulièrement. L'humain sépare nettement la conception de l'exécution et veut contrôler le passage de l'une à l'autre.

Les objections sont numérotées et traitées comme un cycle explicite : une tâche de session s'intitule `[traitement des objections] ANL-016` et contient quatre sous-sections `objection 1` à `objection 4` avec la réponse de l'humain à chacune.

Le livrable est nommé par son type. L'humain écrit « produire une FND », « produire une ANL », « esquisser un plan dans l'analyse et NON PAS dans un fichier PLN ». La typologie des ressources est active dans sa pensée au moment de formuler la demande, pas seulement dans la documentation.

Les questions sont nombreuses et ouvertes. Une tâche unique peut en contenir dix. L'humain n'attend pas une exécution, il attend un travail de réflexion documenté.

**Conséquence pour la conception.** Le point d'entrée doit accueillir un texte long, structuré librement, avec des renvois, des interdictions, des questions et des réponses à objections. Un formulaire ou un gabarit contraint serait un recul. En revanche, la catégorie entre crochets et le type de livrable nommé sont deux éléments que la machine pourrait lire, et ne lit pas aujourd'hui.

## Rapport à git

Le rapport à git est utilitaire et assumé comme tel. Sur les 1 085 messages de commit depuis août 2025, 133 sont exactement `save`, 55 sont `init`, 31 sont `TKT-00X - Save changes`. Cent soixante-quatorze suivent la convention `conventional commits`, et ils sont concentrés dans les dépôts de code.

L'exception est instructive : `clients-data/vortex-finops`, avec ses 53 commits aux messages descriptifs et réguliers (`finops: ingestion coûts services us-east-1`). Quand le travail est mécanique et répétitif, l'historique est soigné. Quand le travail est de conception, l'historique est un simple filet de sécurité.

Les chiffres structurels sont plus préoccupants que le style. Quatre-vingt-quatorze dépôts sur cent soixante-six n'ont aucun remote. Quarante-cinq n'ont jamais été commités. Soixante-et-un portent du travail non commité, dont 108 fichiers dans `archive/jvtrudel-cv` et 27 dans `nou-methodologies-ia`. Plusieurs remotes ne correspondent pas au nom du répertoire local (`walk-and-talk` pour `dile-ola`, `datalyse/platform` pour `noumanity-infra/platform`, `nou-ai-methodology` pour `nou-methodologies-ia`) et un porte une faute de frappe jamais corrigée (`intentional-dooers-governance`).

**Conséquence pour la conception.** Le harnais actuel de `clia` interdit à l'agent toute opération git, en réservant la gestion de versions à l'humain. Cette règle est cohérente avec un principe de responsabilité, et elle coûte cher au vu de ces chiffres : l'humain ne commite pas, et l'agent n'a pas le droit de le lui rappeler. La règle mérite d'être reconsidérée, non pas pour autoriser l'agent à commiter, mais au moins pour l'autoriser à signaler l'état. Le dépôt `archive/cli-based-organisation_git-resource` avait pris l'autre chemin, traiter git comme une ressource instrumentable, et personne n'a écrit pourquoi il a été abandonné.

## Rapport à l'agent

Trois observations se dégagent des harnais et des logs.

L'humain veut être contredit. La gouvernance objection-sociocratique n'est pas une politesse : les objections sont numérotées, tracées, réévaluées dans des analyses dédiées, et `micrologic-clients` en a fait une ressource de première classe avec quatre instances. La règle du `CLAUDE.md` de `clia`, émettre des objections en cas de conflit avec l'intention ultime, est prise au sérieux dans la pratique.

L'humain se méfie de l'écriture de l'agent sur ce qui lui appartient. La règle C1 de `ticket-driven-ai`, l'agent ne modifie jamais un `ticket.md`, et la règle équivalente de `clia` sur `INTENTION.md` et les fichiers de session, viennent tous deux d'incidents réels. Le premier log de `commission-scolaire-de-la-capitale` documente l'écrasement de `INTENTION.md` par du contenu générique. La méfiance est fondée sur l'expérience.

L'humain délègue la production, pas la décision. La séparation `Ne pas implémenter le plan` est systématique. Le régime de travail est : l'humain pose la question, l'agent produit une analyse et des objections, l'humain répond aux objections, puis autorise. Le mécanisme de breakpoint et d'approbation partielle décrit dans le `CLAUDE.md` archivé formalise exactement cela.

**Conséquence pour la conception.** Le système n'a pas à automatiser la décision, il a à outiller le cycle question, analyse, objection, réponse, autorisation. Ce cycle est le vrai objet de `clia`, et il n'a aujourd'hui aucune ressource dédiée dans le dépôt : ni objection, ni réponse, ni autorisation. `micrologic-clients` a produit `RES-011-objection` ; `clia` ne l'a pas.

## Rapport au vocabulaire

L'humain travaille par nomination. Les mots sont posés avant les mécanismes, et les mots tiennent. Le vocabulaire stabilisé sur douze mois comprend intention, contexte, ressource, livrable, harnais, objection, skill, fondation, distillation, extreme-smart, phore, pilier, topologie. Certains de ces mots viennent de loin : `topologie de style` de `ptyle` en 2023, `phore` de `nty` en 2026.

Le revers est une dérive lexicale non contrôlée. Le même objet s'appelle `livrable` dans la lignée A et `ressource` dans la lignée B. Les statuts de log valent `completed` dans cinquante-deux fichiers et `complet` dans deux autres. Les répertoires de travail s'appellent `améliorations`, `issues`, `tickets`, `needs`, `features` selon le dépôt. Le nom du fichier de point d'entrée est `session.md` à la racine dans un dépôt, `.dev/session.md` dans une dizaine d'autres, et `workspace/session.md` dans le `CLAUDE.md` actuel de `clia`.

**Conséquence pour la conception.** Le corpus a besoin d'un lexique tenu en un seul endroit, avec le mot retenu et les synonymes écartés. C'est précisément ce que la ressource Ontologie devrait porter, et il n'en existe qu'une instance dans tout le corpus.

## Synthèse des contraintes de conception observées

| Observation | Contrainte pour `clia` |
|---|---|
| Travail par vagues, creux de plusieurs mois | Coût de reprise faible, état lisible sans mémoire de session |
| Tâche médiane de 30 minutes, projet de 2 semaines | Deux échelles à modéliser, pas une |
| Vingt-deux pour cent des tâches déclarées partielles | Le partiel est un état normal, à représenter |
| Demandes longues, avec renvois, interdictions et questions | Point d'entrée en texte libre, pas de formulaire |
| Catégorie entre crochets et type de livrable nommés à la main | Deux signaux lisibles par la machine, non exploités |
| Commits `save`, 94 dépôts sans remote | L'agent doit pouvoir signaler l'état git, même sans y toucher |
| Cycle objection, réponse, autorisation | Ressources Objection et réponse nécessaires dans `clia` |
| Dérive lexicale entre dépôts et lignées | Lexique unique tenu, synonymes écartés explicitement |
| Le savoir se conserve quand il est destiné à sortir | Le type Publication doit exister et être outillé |

## Relations

- `fait-partie-de` [ANL-001](index.md)
