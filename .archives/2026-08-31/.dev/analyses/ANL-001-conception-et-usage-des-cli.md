---
type: analyse
id: ANL-001
titre: "Conception et usage des CLI, et l'évolution de clia sur trois générations"
version: 0.1.0
status: actif
date: 2026-08-30
---

# ANL-001 - Conception et usage des CLI, et l'évolution de clia

> Onze CLI ont été écrits dans ce corpus en vingt-et-un mois, et aucun n'a survécu à son auteur. clia est le douzième : il a brûlé deux générations en sept semaines, et la troisième est la première à porter à la fois du code éprouvé et un modèle qui tient. Ce qui a convergé n'est pas ce que les deux premières générations documentaient — c'est le mécanisme de découverte, la ressource typée par sa définition, et l'état déclaré. Ce qui reste ouvert tient en une phrase : **le système sait créer des types et ne sait pas créer d'instances.**

## Question posée

La tâche 1 de `SES-002` pose cinq questions, que cette analyse traite comme une seule enquête.

1. Que dit le développement, la conception et l'usage des CLI de ce corpus, et en particulier de clia ?
2. Quelle est l'histoire de clia : qu'est-ce qui marche, qu'est-ce qui marche moins bien ?
3. Quels composants ont convergé et paraissent stabilisés ?
4. Qu'est-ce qui reste à découvrir ou à concevoir ?
5. Quels sont les enjeux, et quels principes de conception sont les plus prometteurs ?

L'enquête sert une décision qui est déjà prise : il faudra un CLI, même si sa forme exacte n'est pas connue. Elle ne discute donc pas de l'opportunité du CLI ; elle établit sur quoi la prochaine génération peut s'appuyer sans le redécouvrir.

## Méthode

Trois corpus, examinés le 2026-08-30, et une exécution.

| Source | Ce qui a été examiné |
|---|---|
| **Génération courante** | `_scripts/` (25 fichiers), `_ressources/` (10 types), `.dev/` (47 fichiers), `setup.sh` |
| **Générations archivées** | `.archives/2026-07/` (G1) et `.archives/2026-08-23/` (G2), lues intégralement pour les analyses et les documents de synthèse, par sondage pour le reste |
| **Corpus local** | `$HOME/git`, 176 dépôts git, restreint par recherche aux dépôts portant un CLI ou une instrumentation clia |
| **Exécution** | Les dix bancs de tests, puis les commandes `clia --help`, `context`, `check`, `res ls`, `res --help`, `skill list`, `feature list`, `release ls` |

Les décomptes de fichiers sont produits par `find` et `wc`. Les dates et les volumes de commits viennent de `git log` sur chaque dépôt. Les constats d'exécution sont ceux des commandes lancées, non ceux de la documentation qui les décrit — l'écart entre les deux est lui-même un objet de cette analyse.

Deux analyses des générations précédentes sont reprises comme sources et non refaites : `ANL-001` de G1 sur l'état des CLI du corpus, et `ANL-011` de G2 sur l'accumulation des items ouverts. Leurs chiffres sont cités comme datés de leur production.

**Une observation n'est pas une norme.** Ce qui suit décrit ce corpus. Les principes de la section R7 sont tirés de ce qui a tenu ici, non d'une littérature générale.

## Constats

### C1 — Onze CLI en vingt-et-un mois, tous abandonnés, aucun réutilisé

`ANL-001` de G1 avait recensé la série. Les dates sont revérifiées par `git log` sur chaque dépôt.

| CLI | Dépôt | Commits | Période | Durée de vie |
|---|---|---|---|---|
| `nou` | `jvtrudel-adhoc/nou` | 10 | 2024-11-10 → 2024-11-19 | 9 jours |
| `shelp` | `jvtrudel-adhoc/shelp` | 5 | 2024-10-19 → 2025-05-04 | intermittent |
| `nou2` | `jvtrudel-adhoc/nou2` | 1 | 2024-12-05 | 1 jour |
| `cpm` | `datalyse/cli-photomanager` | 6 | 2025-04-20 → 2025-05-05 | 15 jours |
| `nty` | `disruptiva-dev/nty` | 14 | 2026-03-27 → 2026-04-08 | 12 jours |
| `devops` | `disruptiva-dev/devops-cli` | 4 | 2026-06-05 | 1 jour |
| `git-resource` | `archive/…git-resource` | 2 | 2026-06-21 | 1 jour |
| `linux-inspect` | `cli-based-organization/linux-inspect` | 2 | 2026-06-20 → 2026-06-21 | 2 jours |
| `tda` | `noumanity-dev/ticket-driven-ai` | 9 | 2026-06-21 → 2026-07-04 | 14 jours |
| `rda` | `noumanity-dev/resource-driven-ai` | **0** | — | jamais commité |
| `cli-convention` | `noumanity-dev/cli-convention` | **0** | — | jamais commité |
| **`clia`** | `cli-based-organization/clia` | **64** | 2026-07-08 → 2026-08-27 | **50 jours, vivant** |

Deux dépôts créés pour capitaliser — `resource-driven-ai` et `cli-convention`, ce dernier explicitement destiné à établir une convention de CLI commune — n'ont jamais reçu un seul commit.

**clia a déjà rompu le motif.** Il porte plus de commits que les onze autres réunis (64 contre 53) et vit depuis plus longtemps que le plus durable d'entre eux, plus de trois fois. Ce n'est pas un projet de plus dans la série : c'est le premier qui a tenu assez longtemps pour se contredire lui-même, ce que les autres n'ont pas eu le temps de faire.

### C2 — Une seule diffusion réussie dans l'histoire du corpus, et elle est morte sans le dire

`tda` est le seul CLI du corpus à avoir équipé des dépôts tiers : huit dépôts identifiables par l'empreinte de leur `CLAUDE.md`, selon `ANL-002` de G2. Il vivait dans un dépôt à lui, avec un `setup.sh` à trois modes et une commande `init`.

Il a été délaissé deux semaines après avoir équipé ces dépôts. Ceux-ci portent toujours un `README.md` qui renvoie à la méthode de référence. **Rien ne les met à jour, et rien ne leur dit que la référence est morte.**

C'est le précédent direct de `clia check` : constater qu'un dépôt instrumenté a dérivé de ce qui l'a instrumenté est le problème que `tda` a laissé ouvert, et que G3 est la première génération à outiller.

### C3 — La courbe documentaire des trois générations : 205, 500, 47

| Mesure | G1 (2026-07) | G2 (2026-08-23) | G3 (courante) |
|---|---|---|---|
| Durée de vie | 26 jours | 12 jours | 6 jours au moment de l'archivage de G2, vivante depuis |
| Commits | 20 | 26 | 18 |
| Fichiers markdown | **205** | **500** | **47** (`.dev` + `_ressources`) |
| Types de ressource déclarés | 11 répertoires | **38** définitions `RES` | **10** définitions YAML |
| Objections ouvertes | — | **41** | **1** |
| Décisions / ADR | 14 ADR | 18 ADR + 20 DCN | 0 |
| Schémas de validation | 1 fichier central | **74** fichiers CUE | 10 YAML, dans la définition |
| Gabarits | 5 | 39 | 6 |

G2 a produit en douze jours deux fois et demie le volume documentaire de G1, et G3 en a produit un dixième.

**Ce n'est pas une régression : c'est une inversion de ce qui porte le système.** G1 et G2 mettaient le modèle dans des documents ; G3 le met dans du code exécuté et dans des définitions lues par ce code.

### C4 — La courbe de code est exactement inverse

| Mesure | G1 | G2 | G3 |
|---|---|---|---|
| Lignes de code de production | 1 148 | 4 686 | **5 658** |
| Lignes de tests | **326** | 1 443 (un seul fichier) | **2 889** (10 fichiers) |
| Cas de test exécutés | non mesuré | non mesuré | **1 062** |
| Ratio tests / production | 0,28 | 0,31 | **0,51** |

Le décompte de production couvre `setup.sh`, le point d'entrée, les modules
partagés et les fichiers de commande — y compris, pour G3, ceux qui vivent sous
`_ressources/`, qui sont du code au même titre que les autres.

Les dix bancs ont été exécutés le 2026-08-30 : **1 062 cas, aucun échec.** Chaque banc travaille dans un `HOME` jetable et vérifie, en dernière assertion, que le dépôt réel n'a pas bougé.

G2 portait 500 documents et un seul fichier de test. G3 porte 47 documents et dix bancs. **Le rapport entre ce qui est déclaré et ce qui est vérifié s'est inversé d'un facteur d'environ trente.**

### C5 — G2 a mesuré sa propre asphyxie, et l'a documentée avant de mourir

`ANL-011`, produite le 2026-08-13 dans G2, établit sur son propre dépôt :

| Mesure | Valeur |
|---|---|
| Questions posées à l'humain dans les objections | 217 |
| Réponses reçues | 213, soit **98 %** |
| Objections entièrement répondues | 36 sur 38 |
| Objections effectivement closes | **0** |
| Issues closes | **0 sur 12** |
| Valeurs d'état déclarées pour une objection | 7 |
| Valeurs effectivement employées | **2** |
| Verbes de clôture dans le CLI | **0** |
| Items ouverts, cumul en 5 jours | 12 → 25 → 53 → 57 → **61**, jamais décroissant |

Sa conclusion tient en une phrase : *« le système a un mécanisme d'ouverture et aucun mécanisme de fermeture »*. Onze jours plus tard, G2 était archivée.

**Le goulot n'était pas l'humain.** Il répondait à 98 % des sollicitations. Le goulot était que répondre ne fermait rien.

### C6 — G2 avait aussi mesuré la verbosité justificative de ses propres définitions

`ANL-004` de G2, sur les trente définitions de type d'alors :

| Mesure | Valeur |
|---|---|
| Mots dans le corps des définitions | 17 922 |
| Mots dans des rubriques qui justifient au lieu de prescrire | **3 724**, soit **20,8 %** |
| Marqueurs lexicaux de justification | 146 |
| Rubriques méta reprises par les 30 définitions | 2 sur 2 |
| Rubrique prescriptive « Frontière avec les types voisins », déclarée obligatoire | **1 sur 30** |
| Types disposant d'un ADR qui décide leur adoption | **1 sur 30** |

La cause identifiée est structurelle et non comportementale : **le harnais prescrivait les rubriques qu'il reprochait**, à quarante-cinq lignes d'intervalle dans le même fichier.

G3 en a tiré la conséquence : ses définitions sont des fichiers YAML de contrat, et le commentaire de tête de `ressource.yaml` cite `ANL-004` comme motif du changement de format. **C'est le seul cas du corpus où une analyse d'une génération a produit un changement structurel dans la suivante.**

### C7 — Le système sait créer des types, il ne sait pas créer d'instances

Vérifié par exécution le 2026-08-30.

```
$ clia res ls
PREFIXE  NOM         INSTANCES  NAMESPACE           ETAT
ANL      analyse     0          noumanity.com/clia  activée
FND      fondation   0          noumanity.com/clia  activée
HRN      harness-ia  1          noumanity.com/clia  activée
INT      intention   0          noumanity.com/clia  activée
LOG      log         0          noumanity.com/clia  activée
NON      objection   1          noumanity.com/clia  activée
PLN      plan        0          noumanity.com/clia  activée
RES      ressource   10         noumanity.com/clia  activée
SES      session     1          noumanity.com/clia  activée
SKL      skill       0          noumanity.com/clia  activée
```

Six types sur dix portent zéro instance. `clia res --help` liste huit verbes — `ls`, `info`, `new`, `activate`, `version`, `upgrade`, `downgrade`, `migrate` — et `new` **crée un type**, non une instance. Le fichier que cette analyse même produit a été écrit à la main, alors que `analyse.yaml` déclare un `emplacement`, un `gabarit`, six champs d'instance et cinq sections.

C'est la question Q4 de `NON-001`, ouverte le 2026-08-25 et toujours sans réponse : *« il manque un verbe »*.

**Conséquence mesurable :** `migrate` existe et ne peut rien migrer, puisque rien ne pose le champ de version dans une instance qu'aucune commande ne crée.

### C8 — Le catalogue de skills est vide, et `PDC-003` promet une génération que rien ne fait

```
$ clia skill list
Skills :

  (aucun)
```

`PDC-003` pose que toute ressource générée provient de primitives et d'un prompt de génération. Quatre types — `analyse`, `fondation`, `plan`, `log` — déclarent `edition: ia`. **Aucun prompt de génération n'existe dans le dépôt.**

Une définition qui déclare `edition: ia` sans prompt promet une génération que personne ne peut faire. C'est la question Q1 de `NON-001`, également sans réponse.

Le seul mécanisme de génération réellement outillé est celui du harnais : `clia harness-ia init` combine `CLAUDE.primitive.md` et les deux zones gérées. Il fonctionne, et il est le seul.

### C9 — Une définition déclare des sections que ses instances ne portent pas, et rien ne le voit

`session.yaml` déclare cinq sections : `CONTEXTE`, `INTENTION`, `LIVRABLES attendus`, `CRITÈRES DE CONVERGENCE`, `Tâches`.

| Instance | Sections portées | Manquantes | Niveau de titre des tâches |
|---|---|---|---|
| `SES-001` | 4 sur 5 | `CRITÈRES DE CONVERGENCE` | `###` |
| `SES-002` | 3 sur 5 | `LIVRABLES attendus`, `CRITÈRES DE CONVERGENCE` | `#` |

**Aucune des deux instances existantes n'est conforme à son type, et les deux divergent l'une de l'autre sur le niveau de titre.** `clia check` porte sept contrôles C1 à C7 ; aucun ne descend au niveau de l'instance. La conformité vérifiée est celle de l'inventaire du dépôt, pas celle de son contenu.

La note de `session.yaml` signale que la section des critères de convergence *« avait été perdue puis rétablie dans la génération précédente ; elle est ici d'emblée »*. Elle est d'emblée dans le type, et absente des deux instances.

### C10 — Deux choses différentes s'appellent « version »

```
$ clia --version
0.1.0                    ← _CLIA_VERSION, la version de l'installation de clia

$ clia release ls
version déclarée   0.3.0 ← .dev/clia.yaml, la version du dépôt
```

`USE-007` a vu la difficulté et l'a tranchée par la négative : *« il n'y a pas de commande `clia version` »*. Le mot reste employé pour trois objets — la version de l'installation, la version du dépôt, la version d'une ressource — et l'aide de `clia res` en ajoute trois autres : l'installée, l'offerte, les disponibles.

Six acceptions d'un même mot, toutes légitimes, aucune qualifiée dans la sortie.

### C11 — Le namespace n'est stable ni dans sa forme ni dans son attribution

Six dépôts du corpus portent un `.dev/clia.yaml`. Leurs namespaces :

| Dépôt | Namespace déclaré |
|---|---|
| `clia` | `noumanity.com/clia` |
| `offre-service-cscn` | `affaire.noumanity.com/offre-service-cscn` |
| `quebecsec-social-laser-hack` | `<publisher>/quebecsec-social-laser-hack` — **non résolu** |

Et dans l'inventaire d'`offre-service-cscn`, la même ressource `session` est attribuée à `clia.noumanity.com/offre-service-cscn` tandis que `fondation` et `analyse` viennent de `noumanity.com/clia`.

**Trois formes de namespace coexistent, et une provenance déclarée est fausse.** `USE-003` avait explicitement reporté « le problème de l'unicité et du contrôle des namespaces », en gardant celui de sa déclaration. Le report est visible dans les données.

`clia check` C1 vérifie que le champ est présent, pas qu'il est résolu ; `--fix` pose délibérément une invite visible plutôt qu'une valeur devinée, ce qui est le bon choix — mais rien n'échoue tant que l'invite reste.

### C12 — La diffusion réelle est de six dépôts sur cent soixante-seize, et elle mobilise quatre types

| Mesure | Valeur |
|---|---|
| Dépôts git sous `$HOME/git` | 176 |
| Dépôts portant `.dev/clia.yaml` | **6** |
| Dépôts dont `CLAUDE.md` déclare l'instrumentation clia | 6, les mêmes |
| Dont dépôts de travail réel, hors développement de clia | **2** |

Les deux dépôts de travail réel — `offre-service-cscn` et `quebecsec-social-laser-hack` — activent, ensemble, quatre types du noyau : `fondation`, `analyse`, `plan`, `session`. Ils ajoutent leurs propres types de domaine (`offre-de-service`, `branding-style`) et cinq skills locaux.

**L'usage réel mobilise quatre types du noyau sur les dix déclarés, et ajoute les siens.** C'est la validation empirique de `PDC-006` : le noyau doit être petit, l'extension fait le reste. C'est aussi la mesure de ce qui est mort-né dans le noyau : `intention`, `log`, `objection`, `skill`, `harness-ia`, `ressource` ne sont activés par aucun dépôt de travail.

### C13 — Le mécanisme de découverte des commandes est le seul composant qui n'a jamais été contesté

Le dispatcher de G3 ne porte aucune commande : il les trouve. Un fichier `<nom>.sh` déposé dans `_scripts/lib/cmd/` ou dans `_ressources/<res>/scripts/` est exposé dans l'aide et devient invocable, sur la foi de trois lignes de commentaire :

```
# Description: ce que la commande fait, en une ligne
# Périmètre: dépôt | aucun
# Alias: autres noms
```

Treize commandes sont exposées ainsi, dont trois vivent sous `_ressources/`. Le champ `Périmètre` fait appliquer la garde d'activation **une fois, dans le dispatcher** : une commande nouvelle en hérite sans rien déclarer, et l'oubli de la ligne restreint au lieu de permettre.

Le mécanisme est emprunté à `_scripts/clia` du dépôt `noumanity-wiki`, antérieur aux trois générations. Il a traversé G1, G2 et G3 sans être remis en cause par aucune objection, aucun ADR, aucune analyse. `test_structure.sh` vérifie qu'aucune commande n'en masque une autre.

### C14 — Le double mode d'installation a survécu à quatre outils

| Outil | Modes offerts |
|---|---|
| `tda` (2026-06) | dev + permanent + local, `--check`, `--uninstall` |
| clia G1 (2026-07) | `install`, `activate`, `--check`, `--uninstall` |
| clia G2 (2026-08) | `install`, `activate` |
| clia G3 (courante) | `--activate` éphémère, `--dev` par lien symbolique, `clia setup uninstall` |

La distinction porte deux propriétés indépendantes qui ont mis trois générations à se séparer proprement : **la durée** de la disponibilité, et le **périmètre** d'exécution permis. G3 est la première à les nommer séparément et à les faire tenir par le dispatcher plutôt que par chaque commande.

Le mode `--activate` n'écrit rien sur le disque — fermer le terminal suffit à le défaire. C'est la seule forme d'installation du corpus qui soit réversible sans commande.

### C15 — `clia check` est une boucle de réconciliation qui ne dit pas son nom

`.dev/clia.yaml` déclare ce que le dépôt est et ce qui y est installé. `clia check` compare cette déclaration au disque, sur sept contrôles, sans rien modifier. `clia check --fix` applique les écarts réparables, et refuse ceux dont la réparation déciderait à la place de l'humain — le namespace, le corps du harnais.

C'est exactement la structure `état désiré / état constaté / différence / application` que `FND-001` de G2 identifiait comme le renversement décisif des CLI modernes, en la déclarant *non transposable* à clia :

> *« Dans clia, la ressource est l'état : il n'y a pas de système distinct à faire converger. La notion d'application déclarative n'a donc pas d'objet ici, sauf pour l'installation du harnais dans un dépôt, qui est le seul cas où un état désiré et un état constaté diffèrent. »*

**L'exception qu'elle nommait est devenue le cas général.** Un dépôt instrumenté *est* un système distinct, qui dérive de sa déclaration ; `clia check`, `clia upgrade` et `clia res activate` sont trois applications de la même boucle, écrites séparément. G3 a construit le mécanisme sans l'avoir reconnu comme tel — c'est le résultat le plus important de cette analyse pour la génération suivante.

### C16 — Ce que le corpus fait des CLI, mesuré une fois et jamais corrigé

`ANL-001` de G1 avait établi, sur l'ensemble des scripts du corpus, six écarts récurrents : robustesse inconstante (`set -euo pipefail` absent des petits scripts), options longues rares, `--version` quasi absent, séparation `stdout`/`stderr` non systématique, codes de retour non normalisés, deux conventions de nommage concurrentes.

G3 satisfait les six, et c'est le seul outil du corpus dans ce cas : `set -euo pipefail` dans chaque fichier, aide par commande, `--version`, tout message de diagnostic sur `stderr` par `_clia_msg`, codes `0`/`1`/`2` documentés dans l'aide générale et redocumentés dans chaque aide de commande, exécutable sans extension exposé par lien symbolique et modules en `.sh`.

**Les recommandations d'une analyse de G1 sont appliquées par G3, sans qu'aucun document ne fasse le lien.** Elles ont été retenues par la personne, non par le système.

## Réponse

### R1 — L'histoire de clia en trois générations

**La préhistoire (2024-11 → 2026-07).** Onze CLI, aucun survivant. Trois d'entre eux — `nou`, `nty`, `tda` — portaient déjà l'idée centrale : des objets typés, validés par schéma, manipulés par un CLI. `tda` a été le seul à équiper des dépôts tiers, et le seul à mourir en laissant des dépôts orphelins qui l'ignorent encore. Deux dépôts créés pour capitaliser l'expérience n'ont jamais reçu un commit. **Le corpus savait quoi construire depuis dix-huit mois ; il ne savait pas comment le faire durer.**

**G1, du 2026-07-08 au 2026-08-08.** Un CLI bash de 1 200 lignes, 326 lignes de tests, une couche de types dans un fichier central `resource-types.yaml`, et 205 documents. Modèle de gouvernance sociocratique : point d'entrée unique, objection bloquante, aucune exécution sous objection ouverte. Elle produit son propre bilan : `ANL-001` mesure l'état des CLI du corpus, `ANL-004` constate l'écart entre l'architecture déclarée et l'architecture effective. Elle se termine par un commit nommé `drastic refactor: archive almost everything`, qui archive `setup.sh` et les tests avec le reste — le dépôt perd du jour au lendemain tout moyen d'être installé.

**G2, du 2026-08-09 au 2026-08-20.** Reconstruction sur douze jours, et emballement mesurable : 38 types, 74 schémas CUE, 41 objections, 20 décisions, 18 ADR, 500 documents. La sophistication conceptuelle est réelle — le régime d'identification à deux niveaux, la distinction information/savoir, la composabilité de la ressource sont des acquis. Mais G2 documente sa propre asphyxie pendant qu'elle se produit : `ANL-004` mesure que 20,8 % du texte de ses définitions justifie au lieu de prescrire ; `ANL-011` mesure que 61 items s'ouvrent en cinq jours et qu'aucun ne se ferme ; `ANL-013` établit que le dépôt *« sait dire ce qui bloque, il ne sait pas dire quoi faire pour débloquer »*. Elle invente `clia focus` pour répondre à « que faire maintenant ? », et constate que la commande répond à la question de l'agent, pas à celle de l'humain. Le 2026-08-24, elle est archivée.

**G3, depuis le 2026-08-24.** Inversion complète du rapport entre déclaré et vérifié. 47 documents, 10 types, 4 109 lignes de code, 2 889 lignes de tests, 1 062 cas qui passent, trois versions publiées en quatre jours. La gouvernance sociocratique de G1 et l'appareil décisionnel de G2 ont disparu : plus de constitution, plus d'ADR, plus de registre, une seule objection ouverte. Le harnais tient en une page et quatre règles. **Ce que G3 a gardé des deux précédentes, ce sont leurs mesures, pas leurs modèles.**

**Ce que la série apprend sur elle-même.** La durée de vie des générations diminue — 26 jours, puis 12 — et G3 vit depuis 6 jours à la date de cette analyse. `PDC-008` interprète le raccourcissement des générations comme un signe d'immaturité. La lecture est incomplète : G1 et G2 sont mortes de **surproduction documentaire**, pas d'erreur de conception. Les deux ont produit de bonnes idées qu'aucun mécanisme ne rendait exécutables. G3 est la première à faire l'inverse, et c'est pour cela qu'elle dure.

### R2 — Ce qui marche bien

**B1. Le mécanisme de découverte des commandes.** C13. Trois lignes de commentaire suffisent à exposer une commande ; le dispatcher applique la garde de périmètre une fois pour toutes ; une commande nouvelle hérite du contrôle sans le déclarer. C'est le seul composant que trois générations n'ont jamais remis en cause, et il rend `PDC-006` — l'extensibilité préférée à la complétude — mécaniquement vraie plutôt que déclarative.

**B2. Le banc de tests.** C4. 1 062 cas, dix bancs, chacun dans un `HOME` jetable, chacun vérifiant en dernière assertion que le dépôt réel n'a pas bougé. C'est ce qui autorise les refontes : G3 a changé trois fois la disposition de `_ressources/` en quatre jours sans rien casser. Aucune génération précédente ne pouvait se le permettre.

**B3. L'installation à deux modes, réversible.** C14. `--activate` n'écrit rien et se défait en fermant le terminal ; `--dev` pose un lien symbolique vers le source, si bien que modifier le code change immédiatement la commande. La désinstallation retire exactement ce que l'installation a posé. Quatre outils l'ont cherché, G3 est le premier à le tenir proprement.

**B4. Le harnais généré à zones gérées.** Le seul mécanisme de génération réellement outillé du système. `CLAUDE.md` est produit à partir d'une primitive, et deux zones délimitées par marqueurs sont écrites par `clia skill` et `clia feature`. Une régénération préserve les zones ; le reste du fichier appartient au dépôt. C'est `PDC-003` tenu par une machine, sur un objet — et un seul.

**B5. `.dev/clia.yaml` et `clia check`.** C15. Une carte d'identité versionnée, un inventaire de ce qui est installé, sept contrôles, une réparation qui refuse de décider à la place de l'humain. Il a été motivé par un cas réel — un dépôt instrumenté par une version antérieure et dérivé sans que rien ne le signale — et il résout le problème que `tda` avait laissé ouvert quatre ans plus tôt à l'échelle du corpus.

**B6. Les messages.** `_clia_msg` et `_clia_detail` envoient tout sur `stderr`, et la règle écrite dans le harnais — *« un message dit ce qui s'est produit, puis ce que le lecteur peut faire ensuite »* — est effectivement tenue : la sortie d'erreur du dispatcher pour une commande inconnue nomme l'erreur puis renvoie à `clia --help`. C16 établit que c'est le seul outil du corpus à satisfaire les six recommandations que G1 avait formulées.

**B7. La documentation dans le code.** Chaque fichier de G3 s'ouvre sur un commentaire qui dit pourquoi il est ainsi et non autrement, en citant l'usage ou la spécification dont il procède. C'est là que vit le raisonnement de conception, et non dans des documents séparés qui vieillissent. C'est le correctif direct de ce que `ANL-004` avait mesuré en G2.

### R3 — Ce qui marche moins bien

**M1. Le système crée des types et ne crée pas d'instances.** C7. Six types sur dix portent zéro instance ; `clia res new` crée un type ; aucun verbe ne pose une instance à partir d'un gabarit que la définition déclare pourtant. Cette analyse même en est la preuve : elle est écrite à la main contre un type qui décrit exactement sa forme. **C'est le défaut central**, et tous les suivants en dérivent partiellement.

**M2. La déclaration n'engage pas.** C8, C9. Quatre types déclarent `edition: ia` sans qu'aucun prompt existe. `session.yaml` déclare cinq sections que zéro instance sur deux porte. `analyse.yaml` déclare six champs d'instance que rien ne vérifie. `clia check` s'arrête au niveau de l'inventaire du dépôt. **C'est exactement le défaut que `ANL-011` de G2 avait nommé** — *« une définition excellente que rien ne fait respecter »* — reproduit dans une génération qui a pourtant lu cette analyse.

**M3. Le vocabulaire est surchargé.** C10, C11. Six acceptions de « version », trois formes de namespace, une provenance fausse dans un inventaire de production. Le mot « ressource » désigne à la fois le type, l'instance et le répertoire ; `SPC-001` S7 doit consacrer une section entière à dire ce qui n'en est pas une.

**M4. Le noyau déclare plus que l'usage ne mobilise.** C12. Quatre types du noyau sur dix sont activés par les dépôts de travail. Six ne le sont par aucun. `NON-001` avait ouvert la question sous le titre exact : *« les ressources core déclarent plus que le système ne tient »*. La mesure d'usage la confirme.

**M5. Il n'y a pas de verbe de fermeture.** `NON-001` est ouverte depuis le 2026-08-25. Rien dans le CLI ne la fermera. C'est le mécanisme qui a tué G2, reproduit à petite échelle : G3 n'a qu'une objection, donc le défaut ne se voit pas encore, mais il est structurellement identique.

**M6. La diffusion reste marginale et fragile.** C12. Six dépôts sur 176, dont deux de travail réel, dont l'un porte un namespace non résolu et une provenance erronée. Le seul précédent de diffusion du corpus — `tda`, C2 — montre que la fragilité ne vient pas du nombre mais de l'absence de lien vivant entre l'outil et ce qu'il a instrumenté. `clia check` répond au constat ; rien ne répond encore à la notification.

**M7. Le savoir des générations se perd, sauf quand une personne le porte.** C16. Les six recommandations de `ANL-001` de G1 sont appliquées par G3 sans qu'aucun document ne fasse le lien ; les mesures de `ANL-004` ont produit un changement de format sans qu'aucune ressource ne l'enregistre. Trois générations ont produit 752 documents, dont 705 sont archivés et illisibles par les commandes actuelles. **Le système d'information ne sait pas encore mobiliser son propre savoir**, ce que son `INTENTION.md` annonce pourtant comme sa première capacité native.

### R4 — Ce qui a convergé et paraît stabilisé

Un composant est tenu pour convergé quand il a traversé au moins deux générations sans être contesté, et qu'il est aujourd'hui couvert par des tests.

| # | Composant | Traversé | Tests | Statut |
|---|---|---|---|---|
| **V1** | Découverte des commandes par fichier et déclaration en commentaire | G1, G2, G3, et antérieur | `test_structure.sh` | **stabilisé** |
| **V2** | Installation à deux modes, réversible, et désinstallation exacte | tda, G1, G2, G3 | `test_activate.sh`, `test_clia.sh` | **stabilisé** |
| **V3** | Le type est une donnée déclarative, pas du code | G1 (central), G2 (RES+CUE), G3 (YAML distribué) | `test_res.sh` | **stabilisé, forme convergée en G3** |
| **V4** | Le harnais est une ressource générée à zones gérées | tda, G1, G2, G3 | `test_harnais.sh` | **stabilisé** |
| **V5** | Grammaire à deux axes, ressource × verbe, les deux ordres acceptés | G2, G3 | `test_res.sh` | **stabilisé** |
| **V6** | Codes de retour 0/1/2, diagnostics sur `stderr`, aide par commande | G1, G2, G3 | tous les bancs | **stabilisé** |
| **V7** | Banc de tests en bac à sable, dépôt réel vérifié intact | G1, G2, G3 | lui-même | **stabilisé** |
| **V8** | État déclaré du dépôt et contrôle de conformité | G3 seulement | `test_check.sh`, 199 cas | **prometteur, une seule génération** |
| **V9** | Provenance par extension : dépôt distant, clone en cache, inventaire versionné | G3 seulement | `test_extension.sh`, `test_upgrade.sh` | **prometteur, une seule génération** |

Quatre principes ont convergé au même titre, en ce qu'ils sont aujourd'hui **appliqués par des mécanismes** et non seulement écrits :

- `PDC-006`, l'extensibilité préférée à la complétude — tenu par V1 et V9 ;
- `PDC-003`, les primitives et la régénération — tenu par V4, pour un seul objet ;
- `PDC-002`, la collaboration à trois registres — tenu par le refus de `--fix` de trancher le namespace ;
- `PDC-004`, l'écrit destiné à un lecteur humain — tenu par V6 et par le style des messages.

**Ce qui n'a pas convergé et doit être considéré comme abandonné** : la gouvernance sociocratique à objection bloquante (G1, G2), l'appareil décisionnel ADR/DCN/registre (G2), la validation par schémas CUE (G2), la commande de focus (G2), la constitution comme document séparé (G1, G2). Aucun de ces cinq n'est repris par G3, et aucun ne manque à l'usage mesuré en C12.

### R5 — Ce qui reste à découvrir ou à concevoir

**D1. Le cycle de vie d'une instance.** Créer, valider, faire évoluer, clore. C'est M1 et M5 réunis, et c'est le chantier principal. Il suppose de trancher `NON-001` Q2 — quel champ porte l'état — et Q4 — quel verbe crée une instance.

**D2. La génération comme mécanisme, pas comme promesse.** `PDC-003` vaut pour toutes les ressources générées et n'est outillé que pour le harnais. Où vit le prompt, comment une régénération se déclenche, ce qu'elle préserve : `NON-001` Q1 pose la question et donne trois emplacements possibles.

**D3. La validation d'une instance contre sa définition.** C9. Le contrôle existe au niveau du dépôt et pas au niveau du document. Une définition qui déclare des sections, des champs et des relations admissibles porte déjà tout ce qu'il faut pour être vérifiée ; il manque le contrôle.

**D4. La mobilisation du savoir accumulé.** M7. Trois générations, 752 documents, aucune commande pour les interroger. C'est la première capacité annoncée par `INTENTION.md` et la seule qui n'ait jamais été outillée dans aucune génération.

**D5. Le focus.** `PDC-005` demande de limiter le contexte au minimum nécessaire et de rendre facile l'identification du contexte et le changement de focus. G2 a tenté la commande et `ANL-013` a établi pourquoi elle a échoué : elle répondait à la question de l'agent. **Le focus est une projection sur un état, pas un type ni une commande de plus** — reste à concevoir sur quoi elle projette.

**D6. Les mécanismes d'entrée.** La réponse humaine à `NON-001` Q3 pose qu'un dépôt doit avoir au moins un mécanisme d'entrée, que la session en est un et n'est pas le seul, et qu'une session est une ressource informationnelle indépendante de sa représentation. Rien n'est conçu au-delà de cette réponse.

**D7. L'identité, le namespace et la découverte.** C11. L'unicité et le contrôle des namespaces ont été explicitement reportés par `USE-003` ; les données montrent le coût du report. À concevoir avec la question, jamais posée, de savoir comment un dépôt découvre les extensions disponibles.

**D8. La notification.** C2, M6. `clia check` sait constater qu'un dépôt a dérivé, à condition qu'on le lance. Le cas `tda` montre que le problème n'est pas le constat mais l'absence de lien vivant entre l'outil et ce qu'il a instrumenté.

**D9. La polymorphie des ressources.** `PDC-009` pose qu'une ressource n'est ni sa représentation, ni son support, ni son format, et qu'elle peut être transformée avec ou sans perte. Rien dans les trois générations ne transforme quoi que ce soit. C'est le principe le plus ambitieux et le moins engagé.

### R6 — Les enjeux

Neuf enjeux, ordonnés par ce qu'ils commandent. Un enjeu est une tension que la conception doit trancher, non une tâche.

**E1 — La déclaration doit engager, ou disparaître.** Un type qui déclare des sections, des champs, un gabarit et un régime d'édition sans que rien ne les fasse tenir produit exactement la dérive que `ANL-011` a mesurée en G2 et que C9 mesure en G3. *Trancher : soit la définition devient exécutoire (validation, génération, création d'instance), soit elle est réduite à ce qui est effectivement tenu.* Aucune position intermédiaire n'a tenu sur trois générations.

**E2 — Tout ce qui s'ouvre doit avoir un verbe qui le ferme.** C5, M5. G2 est morte de ce défaut, avec 61 items ouverts et zéro fermé. La règle est générale : objection, session, plan, tâche, écart de conformité. *Trancher : quel objet porte l'état, et quel verbe le fait changer.*

**E3 — Le noyau doit être dimensionné par l'usage, pas par la théorie.** C12, M4. Quatre types sur dix sont mobilisés. *Trancher : le noyau est-il ce que clia livre, ou ce que les dépôts activent ?* La seconde réponse implique que six types sortent du noyau vers une extension.

**E4 — La réconciliation est-elle le principe d'architecture, ou un cas particulier ?** C15. G3 a construit trois fois la même boucle — `check`, `upgrade`, `res activate` — sans la nommer. *Trancher : faire de l'état déclaré et de sa réconciliation la colonne vertébrale du CLI, ou garder trois mécanismes proches et distincts.* C'est le choix architectural le plus lourd de conséquences pour la génération suivante.

**E5 — Le vocabulaire doit être discipliné.** C10, C11, M3. Six acceptions de « version », trois formes de namespace. *Trancher : un mot, un objet ; et qualifier dans la sortie ce que le mot seul ne distingue pas.*

**E6 — Le savoir des générations doit être accessible ou assumé perdu.** M7, D4. 705 documents archivés, illisibles par les commandes. *Trancher : ou bien les archives entrent dans le modèle de ressources et deviennent interrogeables, ou bien on assume qu'une génération repart de ses mesures et non de ses documents.* La seconde option est celle qui a effectivement fonctionné entre G2 et G3, et elle mérite d'être choisie plutôt que subie.

**E7 — La frontière entre ce que le CLI fait et ce que l'agent fait doit être écrite.** `FND-001` de G2 l'avait située précisément : le CLI pose le fichier, le frontmatter, le numéro ; il ne produit pas le contenu. Cette frontière n'est écrite dans aucune spécification de G3. *Trancher : où passe la ligne, et qu'est-ce qui la rend vérifiable.*

**E8 — La durée de vie d'une génération doit devenir un objet mesuré.** `PDC-008` définit la maturité par la rareté des changements de génération et n'offre aucun moyen de la constater. Trois générations en sept semaines, une régression documentaire d'un facteur dix, aucun indicateur. *Trancher : quels signaux annoncent qu'une génération s'épuise* — le volume documentaire non exécuté et le nombre d'items ouverts sans verbe de fermeture sont deux candidats mesurés par cette analyse.

**E9 — L'installation et l'instrumentation doivent rester séparées.** G1 est morte en archivant son `setup.sh` avec le reste, et s'est réveillée sans moyen d'être installée. G3 tient la séparation — `setup.sh` installe clia, `clia` instrumente un dépôt, et `USE-007` interdit explicitement à `clia upgrade` de déplacer clia lui-même. *Trancher : cette séparation est-elle un invariant, et qu'est-ce qui la garantit lors d'une refonte ?*

### R7 — Les principes de conception les plus prometteurs

Sept principes, tirés de ce qui a tenu dans ce corpus. Les quatre premiers sont des reformulations opérationnelles de principes existants ; les trois derniers sont nouveaux et proposés à la décision.

**P1 — Le noyau ne connaît aucune commande ; il les découvre.** *Existant, formule de `PDC-006`.* C'est le seul mécanisme jamais contesté en trois générations, et le seul qui rende l'extensibilité mécanique. Sa généralisation est l'axe de conception le plus sûr : ce qui vaut pour les commandes vaut pour les types, les gabarits, les prompts et les contrôles — le noyau les trouve, il ne les énumère pas.

**P2 — Ce qui est déclaré est exécuté, ou n'est pas déclaré.** *Nouveau, réponse à E1.* Une définition ne décrit pas : elle commande. Si un champ `sections` existe, un contrôle le vérifie ; si `edition: ia` existe, un prompt existe ; si `gabarit` existe, un verbe l'instancie. Le corollaire est plus important que la règle : **un attribut qu'on ne sait pas faire tenir doit être retiré de la définition**, pas laissé en promesse.

**P3 — Une seule boucle : déclarer, constater, différer, appliquer.** *Nouveau, réponse à E4.* `check`, `upgrade`, `activate`, `init`, `migrate` sont cinq entrées dans une même mécanique. En faire une seule réduit le code, unifie les messages, et donne gratuitement l'idempotence et le mode « constat sans effet », qui sont les deux propriétés que `FND-001` identifiait comme décisives. C'est le principe le plus structurant proposé ici.

**P4 — Ce qui s'ouvre se ferme par un verbe.** *Nouveau, réponse à E2.* Aucun état ne change parce qu'un document a été lu ou une réponse écrite : il change parce qu'une commande l'a changé, et cette commande laisse une trace. C'est le correctif direct de ce qui a tué G2, et il est vérifiable : le nombre d'items ouverts doit pouvoir décroître.

**P5 — Le raisonnement vit où le code vit.** *Existant en pratique, jamais écrit, cf. B7 et `ANL-004`.* Le motif d'un choix appartient au fichier qui le porte, non à un document séparé qui vieillira sans qu'on le sache. Ce qui doit être partagé entre plusieurs fichiers devient une spécification ; le reste reste un commentaire de tête. G2 a mesuré à 20,8 % le coût de la règle inverse.

**P6 — Un acteur agit dans son registre, et le refus est la forme du respect.** *Existant, `PDC-002`.* Le geste le plus juste de G3 est le refus de `clia check --fix` de deviner un namespace. La forme générale : quand une réparation déciderait à la place de l'humain, l'outil nomme l'écart, montre ce qu'il suggérerait, et n'écrit pas. C'est ce qui rend un automatisme sûr à lancer, et donc ce qui le rend lançable souvent.

**P7 — Le focus est une projection sur l'état, jamais un objet de plus.** *Existant, `PDC-005`, corrigé par `ANL-013`.* G2 a créé une commande et un type pour répondre à « que faire maintenant ? », et a produit une file destinée à l'agent que l'humain regardait par-dessus son épaule. La leçon : le focus se calcule à partir de ce qui existe déjà, il se paramètre par l'acteur, et il n'ajoute aucun document.

**Un principe est explicitement écarté.** `PDC-007`, la convergence, énonce qu'il vaut mieux avancer vite que d'attendre la perfection. Il n'est pas contesté, mais il ne discrimine rien : les trois générations l'ont toutes respecté, et deux sont mortes. Ce qui a manqué n'est pas la vitesse, c'est le **critère de convergence** — la mesure qui dit si une itération rapproche du comportement attendu. `session.yaml` déclare une section `CRITÈRES DE CONVERGENCE` que ni `SES-001` ni `SES-002` ne portent (C9). Le principe le plus prometteur n'est donc pas d'avancer vite : c'est de **rendre la convergence mesurable**, faute de quoi elle reste une intention.

## Limites

**La lecture des archives est inégale.** Les documents de synthèse de G1 et G2 — analyses, harnais, constitutions, définitions de type — ont été lus intégralement. Les 705 documents archivés ne l'ont pas été. Un raisonnement décisif peut se trouver dans un document non lu, en particulier parmi les 41 objections et les 20 décisions de G2.

**Les chiffres de G1 et G2 sont repris de leurs propres analyses.** Les mesures de `ANL-011` et `ANL-004` de G2 n'ont pas été refaites. Elles portent chacune leurs propres limites, que leurs auteurs déclarent — notamment un comptage lexical qui sous-estime, et un classement de rubriques qui n'est pas mécanique.

**Le balayage du corpus local est ciblé, non exhaustif.** Les 176 dépôts n'ont pas été inspectés un par un : la recherche a porté sur les marqueurs d'instrumentation clia et sur les dépôts nommés par `ANL-001` de G1. Un CLI first-party peut avoir échappé au recensement, et les chiffres de dispersion de `ANL-002` de G2 — 94 dépôts sans remote, 45 jamais commités — ne sont pas revérifiés.

**La distinction entre convergé et prometteur repose sur un seuil arbitraire.** Deux générations traversées sans contestation, plus une couverture de tests. V8 et V9 n'ont qu'une génération et sont classés à part pour cette raison ; le seuil n'est pas justifié par autre chose que la prudence.

**Les enjeux et les principes sont une construction.** Les constats C1 à C16 sont vérifiables ; R6 et R7 les interprètent. Un autre découpage est possible, et P2, P3 et P4 sont proposés à la décision — ils ne sont pas des observations.

**Rien n'est mesuré sur l'usage humain réel.** Aucune donnée n'existe sur le temps passé, les commandes effectivement tapées, ni les moments où l'outil a gêné. Les deux dépôts de travail réel sont une trace de l'usage, pas une mesure de l'expérience.

**L'analyse est écrite à la main.** `analyse.yaml` déclare `edition: ia` et un gabarit ; aucun générateur n'existe. C7 en fait un constat, et ce document en est l'illustration.

## Relations

- `reference` `.dev/objections/NON-001-les-ressources-core-declarent-plus-que-le-systeme-ne-tient.md`
- `reference` `.dev/specs/SPC-001-structure-d-un-repertoire-de-ressource.md`
- `reference` `.dev/usages/USE-007-upgrade-des-ressources-installées.md`
- `reference` `.dev/usages/USE-008-verifier-la-conformite-d-un-repo.md`
- `derive-de` `.archives/2026-07/ressources/analyses/ANL-001-etat-clis-existants.md`
- `derive-de` `.archives/2026-08-23/analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md`
- `derive-de` `.archives/2026-08-23/analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md`
- `derive-de` `.archives/2026-08-23/fondations/FND-001-usage-des-cli-et-leur-renouveau.md`
- `specifie` `docs/architecture/` — l'architecture cible qu'elle motive
