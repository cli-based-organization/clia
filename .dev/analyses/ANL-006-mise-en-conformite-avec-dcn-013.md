---
type: analyse
id: ANL-006
title: "Mise en conformité avec DCN-013 : interprétation et implications"
status: draft
date: 2026-08-11
sujet: "Ce que DCN-013 et les réponses à NON-026 changent pour clia, du point de vue de l'agent"
generated:
  by: claude-opus-5
  at: 2026-08-11
---

# ANL-006 - Mise en conformité avec DCN-013

> `DCN-013` fait de la décision humaine la source de vérité du système. Cinq mécanismes en découlent, dont quatre n'existent pas. Le plus urgent est un conflit actif : `CONSTITUTION.md` C1 est plus strict que la décision qu'il devrait servir.

## Objet

Interpréter `DCN-013` et les cinq réponses à `NON-026` du point de vue de l'agent, en déduire les implications pour `clia`, et proposer l'adaptation minimale.

Demandé par la tâche 24 de la session du 2026-08-09.

## Méthode

Lecture des deux sources, `DCN-013` et `NON-026`, puis confrontation de chaque énoncé à l'état du dépôt au 2026-08-11.

Trois mesures accompagnent la confrontation : le nombre de documents concernés, l'existence de l'outil requis, et l'existence d'un conflit avec une règle en vigueur.

Une interprétation est signalée comme telle chaque fois qu'elle comble un silence des sources.

## Constats

### C1 - Ce que DCN-013 pose

Six énoncés, dont deux permissifs que l'agent doit lire avec attention parce qu'ils **élargissent** ce qu'il peut faire.

| Énoncé | Portée |
|---|---|
| La `DCN` est l'autorité ultime en matière de décision | Tout document traitant de décision lui est subordonné |
| Seul l'humain **crée** une `DCN`, via `clia res new` | La création est un geste distinct de la rédaction |
| L'IA **peut** rédiger un premier jet ou modifier une `DCN` | La décision est alors **suspendue** jusqu'à approbation manuelle |
| Le cli peut générer, analyser, vérifier, et **modifier le frontmatter** pour répercuter l'état | Le cli agit sur la couche machine, pas sur la teneur |
| L'ensemble des `DCN` doit être **auto-cohérent** | Contrainte globale, sans mécanisme |
| Un champ manque : actif ou non, et pourquoi non | Nommé comme conséquence par la décision elle-même |

### C2 - CONSTITUTION.md C1 est plus strict que DCN-013

C'est le conflit le plus direct, et il est actif.

| Document | Ce qu'il dit de l'agent |
|---|---|
| `CONSTITUTION.md` C1 | « Un agent IA ne crée ni ne modifie une décision » |
| `DCN-013` | « une [IA] peut faire un premier jet de DCN. Mais ce premier jet n'est pas actif tant qu'il n'a pas été approuvé » |
| `NON-026` Q3 | « il peut être écrit ou modifié par un agent IA. Dans ce cas, la décision est suspendue » |

`DCN-013` est l'autorité ultime par son propre énoncé. `CONSTITUTION.md` C1 lui est donc subordonné et doit être aligné.

**Ce que le conflit a déjà produit.** Deux gabarits vides, `DCN-011` et `DCN-012`, laissés à l'humain aux tâches 21 et 22 au motif que C1 interdisait leur rédaction. Sous `DCN-013`, l'agent aurait pu les rédiger, en régime suspendu.

**Ce que le conflit produit encore.** `PDC-003`, à la tâche 23, a été rédigé et déclaré non actif par analogie avec `DCN-013`, sans qu'aucun texte n'autorise cette analogie. `NON-027` Q1 le porte.

### C3 - La distinction création / rédaction est le mécanisme central

`NON-026` Q3 en donne le motif : « nous avons absolument besoin d'avoir l'attention pleine et complète de l'humain pour que les décisions soient conscientes. Alors, nous ajoutons un mécanisme qui force l'action consciente de l'humain : les fichiers DCN doivent être créés par l'humain (via clia). »

| Geste | Qui | Effet |
|---|---|---|
| **Créer** le fichier, `clia res new decision` | L'humain seul | Acte conscient, non délégable |
| **Rédiger** le contenu | Idéalement l'humain, possiblement l'agent | Si l'agent : décision suspendue |
| **Approuver** | L'humain seul | Lève la suspension |
| **Modifier** le frontmatter d'état | Le cli | Répercute, ne décide pas |

**Interprétation de l'agent.** Ce n'est pas la rédaction qui est protégée, c'est l'**intention**. Un humain qui tape `clia res new decision "..."` a formulé le sujet de sa décision ; ce qu'un agent écrit ensuite reste sous son contrôle, à condition que l'approbation soit un geste distinct.

Cette lecture rend le mécanisme cohérent avec sa justification. Elle a une conséquence pratique : `clia res new decision` doit **refuser** à un agent, ce qu'il ne fait pas aujourd'hui.

### C4 - Le champ manquant, et ce qu'il doit porter

`DCN-013` le nomme : « on a besoin d'un champ dans le frontmatter qui détermine si la décision est active ou non et si non, pourquoi elle est inactive (proposée par l'IA, obsolète, abrogé, ...) ».

Le champ `effet` de `RES-009` porte déjà cinq valeurs : `proposee`, `en-vigueur`, `suspendue`, `abrogee`, `remplacee`.

| Besoin de `DCN-013` | Couvert par `effet` |
|---|---|
| Active | `en-vigueur` |
| Proposée par l'IA | **non**, `proposee` ne dit pas par qui |
| Obsolète | partiellement, `abrogee` et `remplacee` |
| Suspendue en attente d'approbation | `suspendue`, sans motif |

**Interprétation.** Le besoin n'est pas un champ nouveau mais un **motif d'inactivité**. Deux options : ajouter un champ `motif-inactivite`, ou enrichir l'énumération de `effet` avec `redigee-par-agent`. La seconde est plus économique et rend l'état lisible d'un seul regard.

**Ce que le champ rend possible.** Le contrôle d'auto-cohérence que `DCN-013` exige sans l'outiller : une `DCN` rédigée par un agent et non approuvée ne peut être citée comme fondement par aucun document.

### C5 - Les ADR deviennent non actifs

`NON-026` Q1, réponse : « Rendre les ADR non-active. »

Q2 en donne le régime : « Non. Les ressources générées tirent leur contenu de ressources sources qui font autorité. Un humain ne modifie jamais une ADR, il modifie les documents [sources]. »

| Mesure | Valeur au 2026-08-11 |
|---|---|
| ADR du dépôt | **17** |
| ADR déclarant une `DCN` source | **6**, par la relation `derive-de` |
| ADR sans aucune source | **11** |
| Générateur qui dériverait un ADR | **aucun** |

**Interprétation.** « Non actif » ne signifie pas « supprimé ». Un ADR reste lisible et cité ; il cesse de **faire autorité**. Ce qui fait autorité est la `DCN` dont il dérive.

**Conséquence que les sources ne disent pas.** Les 17 ADR portent aujourd'hui des décisions numérotées, D1, D2, D3, que le reste du dépôt cite comme fondement. `RES-001` cite `ADR-008` D2 pour l'identité, `RES-019` cite `ADR-017` D5 pour son propre régime. Si les ADR ne font plus autorité, ces citations pointent vers du vide tant que les `DCN` correspondantes n'existent pas.

C'est l'implication la plus lourde de la mise en conformité, et aucune source ne la traite.

### C6 - Deux mécanismes de génération à nommer

`NON-026` Q5 distingue la génération **déterministe par gabarit** de la génération **non déterministe par IA**, et adopte un mécanisme hybride en cinq étapes.

| Étape | Ce qu'elle produit |
|---|---|
| 1 | Analyse des ressources sources |
| 2 | Émission d'objections `NON` au besoin |
| 3 | Un fichier de contenu intermédiaire au format YAML |
| 4 | Validation du YAML par une référence cuelang |
| 5 | Le fichier final, YAML plus gabarit classique |

**Ce que le dépôt possède déjà.** Les étapes 4 et 5 : trente gabarits `.template.md` et soixante-deux schémas `.cue`, dont les `*.input.cue` qui sont exactement la référence de l'étape 4. Le mécanisme déterministe existe et fonctionne.

**Ce qui manque.** Les étapes 1 à 3, qui sont la part non déterministe, et le nom des deux mécanismes que la réponse demande de trouver.

**Interprétation de l'agent.** Les `*.input.cue` ont été produits sans qu'aucun document ne dise à quoi ils servaient. Cette réponse leur donne rétroactivement leur fonction : ils sont le contrat de l'étape 4.

### C7 - Une conséquence sur la forme des ressources

`NON-026` Q5, dernière ligne : « il faudrait penser à inclure DANS la ressource RES l'ensemble des dépendances nécessaires à son usage. (répertoire RES plutôt que fichier + ressource composante d'une autre ressource) ».

Une définition deviendrait un répertoire portant sa définition, son gabarit, ses schémas et sa méthode de génération.

`ADR-004` D3 le rend possible : une ressource peut être un fichier, un répertoire ou un dépôt, et chaque composant est un atome.

| Aujourd'hui | Sous cette conséquence |
|---|---|
| `.dev/ressources/RES-009-decision.md` | `.dev/ressources/RES-009-decision/` |
| `.dev/templates/decision.template.md` | `.../RES-009-decision/decision.template.md` |
| `.dev/schemas/decision.cue`, `decision.input.cue` | `.../RES-009-decision/*.cue` |

**Mesure.** 31 définitions, 30 gabarits, 62 schémas, soit **123 fichiers** à déplacer, et tous les renvois à réécrire.

C'est la conséquence la plus coûteuse, et elle est écrite au conditionnel dans la source : « il faudrait penser à ». Elle est traitée comme une piste, non comme une décision.

### C8 - Un verbe d'initialisation est demandé

`NON-026` Q4 : « une commande `clia [-C ROOT_PATH] setup init <.|[PATH/]REPO_NAME>` génère le nécessaire pour qu'un repo soit un repo conforme clia », et « on doit définir les critères pour que clia soit un repo clia conforme ».

`setup.sh` porte `install` et `activate`. Il n'a aucun verbe d'initialisation, et l'option `-C` n'existe nulle part dans le CLI.

**Ce que la demande implique et que personne n'a écrit.** Les critères de conformité d'un dépôt `clia`. Sans eux, `init` ne sait pas quoi produire et aucun contrôle ne sait quoi vérifier.

## Réponse à la question posée

### Les implications, par ordre d'urgence

| Rang | Implication | Documents touchés | Outil requis |
|---|---|---|---|
| **1** | `CONSTITUTION.md` C1 contredit `DCN-013` | 1 | aucun |
| **2** | `clia res new decision` doit refuser à un agent | 1 module | garde, existe déjà pour `git save` |
| **3** | Le motif d'inactivité manque au frontmatter | `RES-009`, 2 schémas, 13 instances | aucun |
| **4** | 11 ADR sur 17 n'ont aucune source | 17 | aucun |
| **5** | Les citations de décisions d'ADR pointent vers du vide | **248 renvois dans 58 fichiers** | aucun |
| **6** | Les étapes 1 à 3 du mécanisme de génération manquent | 2 décisions non tenues | générateur |
| **7** | Les critères de conformité d'un dépôt ne sont pas écrits | aucun | `clia setup init` |
| **8** | La forme en répertoire des définitions | 125 fichiers | migration |

### L'adaptation minimale

Trois changements suffisent à rendre le dépôt conforme à `DCN-013` sans rien construire.

**A1. Aligner `CONSTITUTION.md` C1 sur `DCN-013`.** L'agent peut rédiger un premier jet ; la décision est suspendue jusqu'à approbation. La création reste réservée à l'humain.

**A2. Poser la garde de création.** `clia res new decision` refuse dans un environnement d'agent, comme `clia git save` le fait déjà. Le mécanisme existe, il suffit de l'appliquer à un second verbe.

**A3. Enrichir le champ `effet`.** Ajouter la valeur `redigee-par-agent` à l'énumération de `RES-009`, et la déclarer non active.

Ces trois changements portent sur un fichier de harnais, un module de code et une définition. Ils ne demandent aucun outil nouveau et ne touchent aucune instance existante.

### Ce que l'adaptation minimale ne règle pas

Les rangs 4 à 8. Ils demandent soit un arbitrage de l'humain, soit un outil, soit une migration.

Le rang 5 est le plus inconfortable : rendre les ADR non actifs invalide les fondements cités par deux cent quarante-huit renvois dans cinquante-huit fichiers, et aucune source ne dit comment traiter cet intervalle.

## Limites

**Les sources sont partiellement rédigées.** `DCN-013` porte cinq champs `À RENSEIGNER`, dont `effet`. Elle décide que la `DCN` est l'autorité ultime et ne déclare pas son propre état.

**Une réponse est inachevée.** `NON-026` Q3 ouvre une énumération, « 1. l'humain inspire par des demandes vagues et incomplète », et s'arrête au point 2. Le mécanisme de prédilection n'est décrit qu'à moitié, et la source elle-même porte un `todo` : le consigner dans une `MET`.

**Le compte des renvois est mesuré et non vérifié un par un.** Deux cent quarante-huit occurrences de la forme `ADR-<SEQ> D<n>` dans cinquante-huit fichiers actifs, journaux exclus, comptées par recherche textuelle. Certaines citent la même décision plusieurs fois.

**Aucune mesure du coût.** Le temps de mise en conformité n'est pas estimé, faute de base de comparaison : aucune migration comparable n'a été mesurée dans ce dépôt.

**Le point de vue est celui de l'agent, et il est intéressé.** Trois des huit implications élargissent ce que l'agent peut faire, et l'agent est celui qui les interprète. La lecture de C3, qui fait porter la protection sur l'intention plutôt que sur la rédaction, en est le cas le plus net.

## Relations

- `derive-de` [ANL-005](ANL-005-tracabilite-de-l-historique-des-ressources.md)
- `reference` [RES-009](../ressources/RES-009-decision.md)
- `reference` [RES-019](../ressources/RES-019-adr.md)
- `reference` [NON-026](../objections/NON-026-consequences-de-l-adr-derive.md)
