---
type: adr
id: ADR-adoption-de-la-notion-de-ressource
title: "Adoption de la notion de ressource"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-09
decideurs: ["human:jvtrudel (à statuer)", "claude-opus-5 (rédaction)"]
sources:
  - ANL-001-observation-corpus-repos-et-pratiques
  - RES-001-ressource
  - "ADR-008-ressource-de-type-ressource du dépôt noumanity-consultation/micrologic-clients"
  - "resource-types.yaml, archivé dans .dev/archives/"
definition-associee: RES-ressource
skill-associe: skl-001-ressource
---

# ADR-001 - Adoption de la notion de ressource

> Acte l'adoption de la ressource comme unité du travail dans `clia`, avec ses alternatives écartées et ses portes de sortie. Ce que la ressource **est** vit dans `RES-001-ressource.md` ; ce document dit **pourquoi** elle a été adoptée sous cette forme.

## Statut de cette décision

`propose`. Le premier jet est écrit, l'humain n'a pas statué, et trois objections bloquantes sont ouvertes : `NON-001` sur l'identité et le nommage, `NON-002` sur le coût du modèle, `NON-005` sur la validation et les règles non tenues. Les décisions D3, D6 et D9 dépendent directement de leurs réponses.

Un ADR au statut `propose` n'est pas une décision : c'est une proposition tracée. La distinction importe, parce que `ANL-001` établit que le corpus compte quatre-vingt-neuf ADR dont aucun ne porte sur ses quatre ruptures de cap réelles. Un ADR qui se déclare accepté sans l'être aggraverait ce défaut.

## Contexte

### Ce que le travail produit aujourd'hui

`clia` est un cadre de collaboration entre un humain, des automatismes et un agent IA. Le résultat de toute demande y est la production ou la modification de quelque chose. La question que ce document tranche est celle de la nature de ce quelque chose.

Trois régimes ont été pratiqués dans le corpus sur douze mois, et `ANL-001` les documente.

Le régime **conversationnel**, où le résultat du travail vit dans l'échange avec l'agent. Il domine encore, et il est la cause du coût de reprise mesuré : le travail se fait par vagues séparées de creux allant jusqu'à quatre mois, et tout ce qui n'a pas été écrit est à redécouvrir.

Le régime du **livrable**, formulé par la lignée `ticket-driven-ai` en juin 2026 : le travail se borne à produire un livrable défini, dont un catalogue fixe la liste et l'emplacement.

Le régime de la **ressource**, formulé pour la première fois en une phrase dans `noumanity-dev/resource-driven-ai` (« concevoir un système de travail augmenté par IA où le livrable est le point focal du travail »), puis modélisé dans `disruptiva-dev/comm-cli` en mai 2026 avec le trio ressource, relation, cycle de vie, et enfin abouti dans `micrologic-clients` en août 2026 avec quatorze définitions de types dont une qui se prend elle-même pour objet.

### Ce que l'observation impose

`ANL-001` établit six faits qui contraignent la décision.

| Fait | Conséquence |
|---|---|
| Le travail se fait par vagues séparées de creux de plusieurs mois, 36 pour cent des commits entre 21h et 6h | Ce qui n'est pas écrit est perdu. Le coût de reprise est la contrainte dominante |
| Douze numéros de skill sur vingt portent plusieurs noms selon le dépôt | Le numéro de séquence n'est pas un identifiant |
| Trente-trois `CLAUDE.md` pour dix-huit contenus, trois `INTENTION.md` identiques désignant le mauvais client | Rien ne propage, rien ne valide |
| Quatre ruptures de cap majeures sans aucune trace écrite | Le corpus produit des ADR sur la forme et aucun sur la direction |
| Cinq occurrences de la même idée réinventée, sept concepts perdus | Sans objet nommé et adressable, le savoir ne se réutilise pas |
| Le dépôt le plus régulièrement travaillé du corpus n'a aucun harnais | Le coût du cadre n'est pas démontré |

Les cinq premiers plaident pour la ressource. Le sixième oblige à la borner.

### Le problème précis

Le régime conversationnel ne survit pas aux creux. Le régime du livrable a été essayé et abandonné en cinq semaines, et personne n'a écrit pourquoi. Le régime de la ressource existe à l'état de démonstration dans un dépôt de candidature sans remote, avec treize fichiers non commités.

Il faut donc décider, et le faire en laissant une trace de ce qui a été écarté.

## Décision, en une phrase

> `clia` adopte la **ressource** comme unité du travail : un fichier markdown à frontmatter YAML typé, dont un type déclaré gouverne la forme, dont l'identité est stable et indépendante de son emplacement, et qui fait foi par opposition à la conversation. Chaque type se définit dans une ressource dédiée, s'acte dans un ADR et se produit selon un skill, ces trois documents étant complétés **type par type** et non d'un seul coup.

## Décisions détaillées

### D1 - La ressource est l'unité du travail

**Décision.** Toute production du travail dans un dépôt équipé prend la forme d'une ressource typée. Ce qui n'est pas écrit dans une ressource n'a pas de valeur opposable, quelle que soit sa qualité.

**Motif.** C'est la seule réponse à la contrainte dominante du régime de travail observé. Un système qui repose sur la mémoire de la conversation impose un coût de reprise proportionnel à la durée du creux, et les creux mesurés atteignent quatre mois.

**Alternative écartée.** Le régime conversationnel augmenté de résumés. Écartée parce que le corpus l'a pratiqué douze mois et que le résultat est mesurable : sept concepts perdus, cinq réinventions de la même idée, quatre ruptures de cap sans trace.

### D2 - La forme est le markdown à frontmatter YAML

**Décision.** Une ressource est un fichier markdown portant un frontmatter YAML. Pas un enregistrement de base de données, pas un fichier YAML pur, pas un objet dans un format propriétaire.

**Motif.** Trois raisons, dans cet ordre. Le markdown se lit sans outil, ce qui est la condition pour qu'une ressource survive à l'abandon de `clia`. Il se versionne par git, dont l'humain dispose déjà. Le frontmatter donne une prise machine sans sacrifier la lisibilité.

**Alternatives écartées.**

Une base de données, essayée dans `specruptiva` avec SQLite et dans `nty`. Écartée parce qu'elle rend le contenu illisible sans l'outil, et parce que les deux dépôts qui l'ont essayée sont morts en laissant leurs fichiers `.db` commités et inexploitables.

Le YAML pur, essayé dans `nou-scripts-ia-support` et `poc-formulaire-offline-first` avec `apiVersion` et `kind: Intention`. Écartée pour le contenu rédigé, retenue comme piste pour l'intention seule : voir la porte de sortie de D2.

Un schéma exécutable, CUE, essayé trois fois dans le corpus (`specruptiva`, `poc-cue-validated-yaml-editor`, `jvtrudel-cv`). Non écartée sur le fond, reportée : voir D9.

**Porte de sortie.** Si `clia` acquiert une commande de lecture qui rend l'accès au contenu indépendant du format, la question du format se rouvre. La forme machine-lisible de l'intention est portée par `NON-006` Q6.

### D3 - L'identité est le champ `id`, pas le numéro ni le chemin

**Décision.** L'identité d'une ressource est le champ `id` de son frontmatter, de la forme `<PREFIXE>-<SLUG>`. Le numéro de séquence n'est qu'un ordre d'apparition. Le chemin n'est qu'une localisation. Tout renvoi entre ressources cible l'`id`.

**Motif.** Mesure de `ANL-001`, défaut D1 : douze numéros de skill sur vingt portent plusieurs noms distincts selon le dépôt, `skl-004` en portant cinq. Un dépôt porte sept ADR dont trois paires de doublons de titre, jamais détectées. `CLAUDE.md` désigne aujourd'hui chaque type par un triplet de numéros, désignation qui devient fausse dès qu'un deuxième dépôt est équipé.

**Alternative écartée.** L'identité par le chemin, qui est la position de `ADR-008` et de `RES-001` du dépôt `micrologic-clients`. Cette position est explicitement motivée par le faible volume du dépôt, et son coût y est mesuré : renommer un préfixe a demandé six corrections manuelles. Le calcul est juste pour un dépôt isolé et faux pour un système destiné à équiper plusieurs dépôts, ce qui est l'objet de `clia`.

**Coût accepté.** Un champ de frontmatter par ressource, et la discipline de renvoyer par `id`.

**Porte de sortie.** Si `clia` reste mono-dépôt, ou si la discipline de renvoi par `id` s'avère non tenue à l'usage, revenir à l'identité par chemin est moins coûteux que de maintenir une identité fictive. La décision est directement suspendue à `NON-001` Q1.

### D4 - Trois classes de cycle de vie

**Décision.** Trois classes commandent le nommage et le versionnage : `vivant` séquencé et versionné en semver, `point-fixe` daté et non versionné, `travail` séquencé et journalisé.

**Motif.** Les trois régimes existent dans la pratique observée et se comportent différemment. Une définition de type se raffine sans changer d'objet. Une analyse est arrêtée à sa date. Une objection a une histoire et non des versions.

**Alternative écartée.** Une règle uniforme de versionnage pour tout. Écartée parce qu'elle obligerait à versionner des documents dont la modification n'a pas de sens, et parce que le corpus a essayé de tout dater et de séquencer tout, avec des migrations inachevées dans les deux sens.

**Faiblesse assumée.** L'immuabilité du `point-fixe` n'est tenue dans aucun dépôt du corpus, et `RES-001` de `micrologic-clients` le reconnaît. Cette décision conserve la règle et nomme l'écart. Trois positions sont tenables, l'appliquer, l'abandonner, ou la remplacer par un versionnage : `NON-005` Q2 les soumet.

### D5 - Quatre régimes d'édition

**Décision.** `humain`, `ia`, `hybride` avec propriété par bloc, `co-edition`. Chaque type déclare le sien.

**Motif.** Le régime `humain` n'est pas un principe, c'est la trace d'un dégât : le premier log de `commission-scolaire-de-la-capitale` consiste à réparer un `INTENTION.md` écrasé par l'agent avec du contenu générique. Le régime `hybride` avec propriété par bloc est nécessaire dès qu'un document porte une question de l'un et une réponse de l'autre, ce qui est le cas de l'objection.

**Alternative écartée.** Deux régimes seulement, `humain` et `ia`. Écartée parce que l'objection et le contexte ont besoin d'une écriture partagée dont la propriété est délimitée, faute de quoi une partie réécrit les mots de l'autre.

### D6 - Trois documents par type, complétés type par type

**Décision.** Un type de ressource est accompagné de trois documents : la définition qui dit ce qu'il est, l'ADR qui dit pourquoi il a été adopté, le skill qui dit comment on le produit. Ces trois documents ne sont pas exigés simultanément : ils se complètent type par type, à mesure que le type est éprouvé.

**Motif.** La répartition en trois documents est reprise de `ADR-008` de `micrologic-clients`, qui l'a établie en observant un dégât précis : la déclaration d'un type vivait en six endroits sans qu'aucun fasse autorité, et deux ADR avaient dû être amendés en place le jour de leur création parce qu'ils servaient de définition.

La complétion progressive, en revanche, est propre à cette décision et répond au défaut D4 de `ANL-001`. Sept types font vingt-et-un documents, vingt-sept en font quatre-vingt-un, et le corpus montre que le rapport entre outillage produit et travail accompli se dégrade. La séquence de la session du 2026-08-09 est d'ailleurs elle-même une application de cette décision : la tâche 2 a produit sept définitions, la tâche 3 complète le triplet pour un seul type.

**Alternative écartée.** Exiger le triplet complet à l'introduction de chaque type. Écartée parce qu'elle rend l'introduction d'un type si coûteuse qu'elle décourage l'extensibilité, laquelle est un invariant retenu par `RES-001`.

**Porte de sortie.** Si des types se retrouvent durablement sans skill et que leur production dérive, la complétion progressive a échoué et l'exigence simultanée redevient préférable. `NON-002` Q1 soumet la question.

### D7 - Le méta-type s'applique à lui-même

**Décision.** La définition du type `ressource` est une instance du type qu'elle définit. Elle porte les champs qu'elle déclare obligatoires, vit à l'emplacement qu'elle déclare, suit la nomenclature qu'elle fixe.

**Motif.** Un modèle dont le document central échappe à ses propres règles n'est pas un modèle. C'est aussi le seul test de cohérence disponible en l'absence de validation mécanique.

### D8 - Ce qui n'est pas une ressource

**Décision.** Sont hors du modèle : les fichiers de harnais (`CLAUDE.md`, `ARCHITECTURE.md`), le point d'entrée de session, les gabarits, le matériel source importé, et les assets binaires.

**Motif.** Les fichiers de harnais ont autorité sur le comportement de l'agent : les soumettre au modèle qu'ils instituent créerait une boucle. Le point d'entrée est éphémère par destination. Le matériel source doit rester verbatim pour être citable. Les assets ne peuvent pas porter de frontmatter.

**Faiblesse assumée.** L'exclusion des assets est une limitation de portée que rien ne déclare aujourd'hui, alors que trois dépôts du corpus commitent des PDF générés sans règle et qu'un dépôt d'assets visuels porte un harnais complet qui n'a aucune prise sur son contenu. `NON-006` Q1 et Q2 soumettent la question. Le statut de `INTENTION.md` reste par ailleurs disputé et est traité par `RES-003` et `NON-003` Q1.

### D9 - La validation est humaine et outillée par des contrôles textuels

**Décision.** En l'absence de `clia`, la conformité d'une ressource est vérifiée par l'agent au moment de la produire, à l'aide de contrôles textuels reproductibles listés dans `skl-001-ressource`, et l'agent signale ses propres écarts dans son log.

**Motif.** C'est la seule position tenable entre deux insuffisances. Ne rien vérifier reproduit le défaut D2 de `ANL-001`, où un `CONSTITUTION.md` de zéro octet et trois `INTENTION.md` identiques désignant le mauvais client n'ont été détectés que par une comparaison de cent soixante-six dépôts. Attendre un outil reporte indéfiniment la conformité.

**Alternative écartée pour l'instant.** La validation par schéma exécutable, CUE, que le corpus a eue entre les mains trois fois et perdue trois fois sans décision écrite. Cette décision est la première trace de cet abandon, et elle le déclare **temporaire** : la question est rouverte par `NON-005` Q4 et Q5.

**Porte de sortie.** Dès que `clia` existe, les contrôles de `skl-001` deviennent son cahier des charges de validation. Ils ont été conçus pour cela : chacun est une commande.

## Conséquences

### Ce que la décision apporte

Le travail devient adressable. Une ressource a un `id`, un type, un emplacement, et peut être citée, contestée et réutilisée. C'est la condition pour que le savoir cesse d'être perdu.

Le coût de reprise baisse. Une ressource est relisible sans mémoire de session, ce qui est la propriété que le régime conversationnel ne peut pas donner.

L'objection devient possible. Une ressource est opposable ; une conversation ne l'est pas.

L'extensibilité est préservée. Ajouter un type demande une définition, sans toucher au harnais.

### Ce que la décision coûte

Un frontmatter et un `id` par fichier, saisis à la main et sans vérification mécanique.

Trois documents par type, à terme, soit vingt-et-un documents pour les sept types fondamentaux.

Une discipline de renvoi par `id` qui n'est soutenue par aucun outil.

Le risque, nommé par `ANL-001` au défaut D4 et par `NON-002`, que le système consacre à se décrire une part croissante de l'énergie qu'il devait libérer.

### Ce que la décision ne règle pas

La propagation entre dépôts. Le harnais s'installe encore par copie, et la copie emporte les traces d'autres dépôts. `NON-006` Q3 le porte.

La validation mécanique. Reportée par D9.

Le régime de travail. Les deux échelles observées, la tâche de trente minutes et le chantier de deux semaines, ne sont pas modélisées. `NON-008` le porte.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-001](../objections/NON-001-identite-et-nommage.md) | bloquant | D3 |
| [NON-002](../objections/NON-002-cout-du-modele.md) | bloquant | D6 |
| [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md) | bloquant | D4, D9 |
| [NON-003](../objections/NON-003-frontiere-contexte-intention-faits.md) | conditionnel | D8 |
| [NON-006](../objections/NON-006-portee-du-systeme.md) | conditionnel | D2, D8 |

## Relations

- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `reference` [skl-001-ressource](../skills/skl-001-ressource/SKILL.md)
