---
type: analyse
id: ANL-002
titre: "Différentiel du CLI entre la génération 2026-08-23 et la génération courante"
version: 0.1.0
status: actif
date: 2026-08-30
---

# ANL-002 - Différentiel du CLI depuis la génération précédente

> Sur sept objets de commande qu'offrait la génération précédente, **trois ont disparu entièrement** et un quatrième a été réduit de moitié. Ce qui les remplace n'est pas une commande : c'est un mécanisme. Le CLI a cessé de connaître ses commandes pour se mettre à les trouver, et c'est la seule modification dont toutes les autres découlent. Une chose n'a pas suivi le changement de génération et le trahit : la politique de permissions du dépôt gouverne encore un système qui n'existe plus.

## Question posée

En ce qui concerne le CLI, qu'est-ce qui, entre la génération archivée le
2026-08-24 et la génération courante, est **resté le même**, a été **ajouté**, a
été **enlevé**, et a été **modifié** ?

Les deux générations sont nommées `G2` et `G3` dans ce qui suit, conformément à
`ANL-001`.

## Méthode

Comparaison de deux arbres, et exécution des deux surfaces déclarées.

| Source | Ce qui a été examiné |
|---|---|
| **G2** | `.archives/2026-08-23/` : `bin/clia`, les sept modules de `lib/clia/`, `setup.sh`, `tests/`, `harnais.yaml`, `schemas/` |
| **G3** | `_scripts/bin/clia`, `_scripts/lib/`, `_scripts/lib/cmd/`, `_ressources/*/scripts/`, `setup.sh`, `_scripts/tests/` |
| **Exécution** | `clia --help`, puis `--help` de chacune des treize commandes de G3 |
| **Surface de G2** | extraite du `case` de dispatch de `bin/clia` et des blocs d'aide de chaque module — G2 n'étant plus exécutable en l'état, sa surface est lue, non lancée |
| **Périphérie** | `.claude/settings.json` et `.claude/hooks/`, exécuté |

Les décomptes de lignes portent sur `setup.sh`, le point d'entrée, les modules
partagés et les fichiers de commande. Pour G3, les fichiers de commande qui
vivent sous `_ressources/` y sont inclus : ce sont des commandes au même titre
que les autres.

**Une différence n'est pas un jugement.** Ce qui suit constate ; ce qui est
perdu ou gagné par chaque différence est dit quand la mesure le permet, et tu
comme inconnu sinon.

## Constats

### C1 — La surface : sept objets contre treize commandes

**G2** exposait sept objets, chacun portant ses verbes.

| Objet | Alias | Verbes |
|---|---|---|
| `resource` | `res`, `r` | `ls`, `new`, `show`, `explain`, `edit`, `check` |
| `session` | `ses`, `s` | `status`, `ls`, `new`, `close`, `switch`, `todo` |
| `setup` | — | `check`, `init` |
| `focus` | `f` | projection, filtrée par `--humain`, `--agent`, `--tout` |
| `registre` | `reg` | `ls`, `show`, `edit` |
| `git` | `g` | `check`, `save`, `log`/`hist`, `diff`, `clean`, `done` |
| `configuration` | `config`, `c` | `ls`, `set`, `edit`, `path`, `ia policy check` |

Options globales : aide, version, `--context`, `-c`.

**G3** expose treize commandes.

| Commande | Alias | Verbes |
|---|---|---|
| `res` | `ressource`, `resource` | `ls`, `info`, `new`, `activate`, `version`, `upgrade`, `downgrade`, `migrate` |
| `skill` | `skills`, `skl` | `install`, `uninstall`, `status`, `list`/`ls`, `activate` |
| `feature` | `features`, `feat` | `install`, `uninstall`, `status`, `list`/`ls`, `activate` |
| `extension` | `ext`, `extensions` | `add`, `ls`, `install`, `upgrade` |
| `harness-ia` | — | `init`, `status` |
| `release` | — | `ls`, `major`, `minor`, `patch` |
| `setup` | — | `status`, `uninstall` |
| `check` | — | — (`--fix`) |
| `init` | — | — |
| `upgrade` | — | — |
| `downgrade` | — | — |
| `migrate` | — | — |
| `context` | — | — |

Options globales : aide, version.

### C2 — Le dispatch : d'une liste écrite à une découverte

`bin/clia` de G2 portait un `case` de sept branches, chacune nommant un module
et une fonction. Ajouter une commande demandait de modifier le point d'entrée.

`_scripts/bin/clia` de G3 ne nomme aucune commande. Il balaie deux
emplacements, lit trois lignes de commentaire sur chaque fichier trouvé —
description, périmètre, alias — et compose son aide à partir de ce qu'il a
trouvé.

| Mesure | G2 | G3 |
|---|---|---|
| Lignes du point d'entrée | 175 | 214 |
| Commandes nommées dans le point d'entrée | **7** | **0** |
| Geste pour ajouter une commande | modifier `bin/clia` **et** ajouter un module | déposer un fichier |
| Emplacements balayés | — | `_scripts/lib/cmd/`, `_ressources/*/scripts/`, `_ressources/*/*/scripts/` |

Trois des treize commandes de G3 vivent sous `_ressources/` et non sous
`_scripts/lib/cmd/` : `res`, `skill` et `harness-ia`. Elles sont exposées
exactement comme les autres.

### C3 — La garde de périmètre est appliquée une fois, au point d'entrée

G2 n'avait pas de notion de périmètre. Chaque module résolvait le dépôt courant
ou s'en passait, et rien ne l'y contraignait.

G3 déclare, sur chaque commande, une ligne `Périmètre:` qui vaut `dépôt` ou
`aucun`. Le point d'entrée la lit, résout le dépôt de travail, applique la garde
du mode d'activation, et transmet le contexte résolu.

**L'absence de déclaration vaut `dépôt`** : oublier la ligne restreint, et ne
dispense jamais de la garde.

### C4 — Les définitions de type : du markdown justificatif au contrat YAML

| Mesure | G2 | G3 |
|---|---|---|
| Forme d'une définition | markdown, rubriques prescrites | YAML, champs |
| Nombre de types déclarés | **38** | **10** |
| Fichiers de schéma | **74** fichiers CUE | 0 — le schéma est dans la définition |
| Gabarits | 39 | 6 |
| Part du texte justifiant au lieu de prescrire | **20,8 %**, mesuré par `ANL-004` de G2 | non mesurable : la forme ne l'admet pas |

Le commentaire de tête de `_ressources/ressource/schemas/ressource.yaml` nomme
`ANL-004` comme motif du changement de forme. C'est le seul endroit du corpus où
une génération cite explicitement une analyse de la précédente pour justifier un
choix.

### C5 — Le code : plus long, et mieux vérifié

| Mesure | G2 | G3 | Écart |
|---|---|---|---|
| Lignes de code de production | 4 686 | **5 658** | +21 % |
| Fichiers de production | 10 | **18** | +80 % |
| Lignes de tests | 1 443 | **2 889** | +100 % |
| Fichiers de tests | **1** | **10**, plus une bibliothèque d'assertions | |
| Cas exécutés | non instrumenté | **1 062**, aucun échec le 2026-08-30 | |
| Ratio tests / production | 0,31 | **0,51** | +65 % |

Chaque banc de G3 travaille dans un répertoire personnel jetable et vérifie, en
dernière assertion, que le dépôt réel et la configuration réelle n'ont pas bougé.

### C6 — L'installation : du bloc dans le shell au lien symbolique

| Aspect | G2 | G3 |
|---|---|---|
| Installation permanente | un bloc encadré ajouté à `~/.bashrc` | un lien symbolique dans le répertoire d'exécutables de l'utilisateur |
| Trace sur le disque | le bloc | le lien, et un fichier de configuration sous le répertoire de configuration |
| Activation éphémère | `. setup.sh activate` | `. setup.sh install --activate`, ou `. setup.sh activate` |
| Portée en mode éphémère | non restreinte | **restreinte au dépôt source** |
| Désinstallation | `./setup.sh uninstall` | `clia setup uninstall` — un verbe du CLI |
| Lignes de `setup.sh` | 295 | 405 |

La restriction de portée du mode éphémère est neuve : en G2, une activation
donnait accès à tout dépôt ; en G3, elle ne permet de travailler que sur le
dépôt source, et c'est le mode `--dev` qui ouvre les autres.

### C7 — L'état du dépôt : d'un fichier de harnais à une carte d'identité

G2 portait `harnais.yaml` à la racine du dépôt **source** : il déclarait les
quatre fichiers de harnais que `clia setup init` générait, et rien d'autre. Un
dépôt instrumenté ne déclarait rien de lui-même.

G3 pose `.dev/clia.yaml` dans le dépôt **instrumenté** : sa provenance, sa
version, sa maturité, sa génération, et l'inventaire de tout ce qu'il tient
d'ailleurs — harnais, extensions, ressources, skills, fonctionnalités, avec
pour chacun la provenance et la version.

C'est ce qui rend `clia check` possible : sans déclaration, il n'y a rien à
comparer au disque.

### C8 — Le harnais : de quatre fichiers générés à un seul, avec zones gérées

| Aspect | G2 | G3 |
|---|---|---|
| Fichiers générés | `CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`, `INTENTION.md` | `CLAUDE.md` seul |
| Source de la génération | `harnais.yaml` et des gabarits `*.tmpl` | une primitive sous la ressource `harness-ia` |
| Zones réécrites par l'outil | aucune | deux, délimitées par marqueurs : skills, fonctionnalités |
| Ce qui appartient au dépôt | rien : le fichier entier était généré | tout le corps, hors des deux zones |
| Régénération | écrase | préserve les deux zones ; le reste n'est réécrit que sur demande explicite |

`INTENTION.md` change aussi de nature : G2 le dérivait d'une définition de type ;
G3 en fait un lien symbolique vers une instance, `.dev/intentions/INT-001-*.md`.

### C9 — Trois objets ont disparu entièrement, et un quatrième de moitié

| Objet de G2 | Verbes perdus | Ce qui en reste en G3 |
|---|---|---|
| `session` | `status`, `ls`, `new`, `close`, `switch`, `todo` | **rien dans le CLI.** La session devient une *fonctionnalité* : une directive injectée dans le harnais, qui apprend à l'agent à lire `.dev/session.md` |
| `focus` | la projection entière, et ses filtres par acteur | **rien** |
| `registre` | `ls`, `show`, `edit` | **rien** |
| `git` | `check`, `save`, `log`, `diff`, `clean`, `done` | `release` commite et tague ; le reste est rendu à `git` lui-même |
| `configuration` | `ls`, `set`, `edit`, `path`, `ia policy check` | **rien.** `ENHANCEMENT.md` réclame son retour sous `clia setup config ls` |
| `resource` | `show`, `explain`, `edit` | `info` réunit `show` et `explain` ; `edit` n'a pas de successeur |

### C10 — Le quatrième code de retour a disparu avec la garde d'acteur

G2 employait un code de retour `3` : le refus lié à l'acteur. Il était rendu par
`clia git save` et par quatre verbes de `session` — `new`, `todo`, `switch`,
`close` — quand la commande était lancée depuis un environnement d'agent.

La garde était fondée sur `CONSTITUTION.md` C2 : *« un agent IA n'exécute aucune
opération git qui écrit »*.

G3 n'a que trois codes, `0`, `1` et `2`. Aucune commande n'interroge l'acteur.
Et `clia release major|minor|patch` **commite et pose un tag**, sans garde
d'aucune sorte.

**La garde n'a pas disparu : elle a changé d'hôte.** Elle vit désormais dans
`.claude/hooks/refuser-git-en-ecriture.py`, un hook `PreToolUse` de
l'environnement d'agent, dont le banc de tests passe — 51 cas, aucun échec le
2026-08-30. Le motif du déplacement est écrit dans le hook lui-même : une règle
de refus par préfixe laissait passer `git -C . commit`, mesuré le 2026-08-12.

### C11 — La politique de permissions n'a pas suivi le changement de génération

`.claude/settings.json` est un artefact de G2 conservé tel quel. Il gouverne
encore un système qui n'existe plus.

| Ce que le fichier déclare | État dans G3 |
|---|---|
| Ses commentaires citent `CONSTITUTION.md` C1, C2, C3 comme fondement | **le fichier n'existe pas** |
| Il protège `Edit(CONSTITUTION.md)` | **absent** |
| Il protège `Edit(ARCHITECTURE.md)` | **absent** |
| Il protège `Edit(workspace/session.md)` | **absent** — la session vit dans `.dev/session.md` |
| Il protège `Edit(.dev/decisions/**)` | **absent** — le type décision n'existe plus |
| Il protège `Edit(.dev/principes/**)` | présent |
| Il autorise `cue vet` et `cue version` | **CUE a été abandonné avec G2** |
| Il autorise nommément 8 bancs de tests | **10 existent** ; `test_check.sh` et `test_upgrade.sh` manquent |
| Il renvoie à `DCN-017` | **le registre des décisions n'existe plus** |

Le hook, lui, fonctionne. C'est sa justification écrite qui pointe vers le vide.

## Réponse

### Ce qui est resté le même

Onze choses, et ce sont celles sur lesquelles la génération suivante peut
s'appuyer sans les rouvrir.

| # | Ce qui n'a pas changé |
|---|---|
| **S1** | **La séparation entre où clia vit et sur quoi il travaille.** G2 : `CLIA_HOME` et le dépôt résolu. G3 : `CLIA_SOURCE_DIR` et `CLIA_WORK_DIR`. Les noms changent, les deux concepts sont les mêmes |
| **S2** | **La résolution de soi par suivi des liens symboliques**, pour que le code trouve ses modules même atteint par un lien |
| **S3** | **La grammaire à deux axes**, objet puis verbe, avec des alias courts |
| **S4** | **`res ls` et `res new`**, seuls verbes de ressource présents dans les deux générations sous le même nom |
| **S5** | **Le comportement sans argument** : l'aide, jamais un effet |
| **S6** | **Une aide par objet**, atteignable par la même option partout |
| **S7** | **Les diagnostics sur la sortie d'erreur**, les données sur la sortie standard |
| **S8** | **Les codes `0`, `1` et `2`**, avec le même sens |
| **S9** | **La discipline de robustesse du shell** : arrêt sur erreur, variables non liées interdites, échec propagé dans les tubes, dans chaque fichier |
| **S10** | **Le harnais est généré, jamais copié.** G2 l'avait établi pour corriger un défaut mesuré ; G3 le conserve et l'étend |
| **S11** | **Le raisonnement vit dans le code.** Chaque fichier des deux générations s'ouvre sur un commentaire qui dit pourquoi il est ainsi, en citant ce dont il procède |

`S10` mérite d'être relevé : c'est le seul mécanisme de génération réellement
outillé des deux générations, et il a survécu à un changement complet
d'architecture.

### Ce qui a été ajouté

Quatorze choses. La première commande toutes les autres.

| # | Ajout | Portée |
|---|---|---|
| **A1** | **Le dispatch par découverte.** Le point d'entrée ne nomme aucune commande ; il les trouve, et compose son aide à partir de ce qu'il a trouvé | structurel |
| **A2** | **La déclaration de périmètre**, et la garde appliquée une fois au point d'entrée, dont toute commande nouvelle hérite | structurel |
| **A3** | **La déclaration d'alias**, portée par la commande elle-même | mineur |
| **A4** | **`.dev/clia.yaml`** : le dépôt instrumenté déclare ce qu'il est et ce qu'il tient d'ailleurs | structurel |
| **A5** | **`clia check`** : sept contrôles, un rapport qui n'écrit rien, et `--fix` qui répare ce qui ne décide rien | structurel |
| **A6** | **Les extensions** : `add`, `ls`, `install`, `upgrade`. Un dépôt tiers devient une provenance, clonée en cache et déclarée dans l'inventaire versionné | structurel |
| **A7** | **Les versions de ressource** : `res version`, `upgrade`, `downgrade`, `migrate`, et leurs équivalents globaux | structurel |
| **A8** | **`clia release`** : `ls`, `major`, `minor`, `patch`. Absent de G2, présent en G1 — **c'est une réapparition** |
| **A9** | **`clia skill`** : le skill entre dans le dépôt, puis dans `.claude/skills/`, et une section d'activation est posée dans le harnais | fonctionnel |
| **A10** | **`clia feature`** : le corps de la fonctionnalité est injecté directement dans le harnais, sans fichier chargé séparément | fonctionnel |
| **A11** | **Les zones gérées du harnais**, délimitées par marqueurs, préservées à la régénération | structurel |
| **A12** | **`res activate`** : reprendre une ressource offerte par une provenance, avec tout ce qu'elle porte | fonctionnel |
| **A13** | **`clia setup uninstall`** : la désinstallation devient un verbe du CLI | mineur |
| **A14** | **Le banc de tests éclaté**, dix fichiers sur une bibliothèque d'assertions commune, 1 062 cas, chacun vérifiant que le dépôt réel n'a pas bougé | structurel |

**A4, A5, A6 et A7 forment un tout.** Ce sont quatre faces du même mécanisme :
déclarer un état, constater le réel, en montrer l'écart, appliquer ce qui est
applicable. G3 l'a construit quatre fois sans le nommer une seule
(`ANL-001` C15, E4).

### Ce qui a été enlevé

Onze choses. Aucune n'a été remplacée par un équivalent, sauf la première et la
dernière.

| # | Retrait | Ce qui le remplace |
|---|---|---|
| **E1** | **`clia session`**, six verbes | une *fonctionnalité* : une directive dans le harnais, et rien dans le CLI |
| **E2** | **`clia focus`**, la projection entière | **rien.** `ANL-013` de G2 avait établi qu'elle répondait à la question de l'agent, pas à celle de l'humain |
| **E3** | **`clia registre`**, trois verbes | **rien** : les registres n'existent plus comme type |
| **E4** | **`clia git`**, six verbes | `git` lui-même, et `release` pour ce qui touche à la publication |
| **E5** | **`clia config`**, cinq verbes | **rien.** `ENHANCEMENT.md` réclame son retour sous une autre forme |
| **E6** | **`res show`, `res explain`, `res edit`** | `info` réunit les deux premiers ; `edit` n'a pas de successeur |
| **E7** | **Les 74 schémas CUE** | les champs déclarés dans la définition — **qu'aucun contrôle ne vérifie encore** |
| **E8** | **Vingt-huit types de ressource** sur trente-huit | dix subsistent |
| **E9** | **`CONSTITUTION.md` et `ARCHITECTURE.md`** comme harnais générés | rien : `CLAUDE.md` seul, et quatre règles en une page |
| **E10** | **Le code de retour `3`**, le refus lié à l'acteur | rien dans le CLI ; la garde vit dans un hook de l'environnement d'agent |
| **E11** | **L'installation par bloc dans le fichier de démarrage du shell** | un lien symbolique et un fichier de configuration |

**E7 est le retrait le plus lourd de conséquences.** G2 portait 74 fichiers de
schéma et n'avait aucun verbe pour les employer ; G3 n'a plus de schéma et n'a
toujours aucun verbe de validation. Le résultat est le même — rien n'est
vérifié — mais G3 l'obtient sans porter le coût. `ANL-001` C9 mesure ce que cela
laisse passer : aucune des deux instances de session du dépôt n'est conforme au
type qu'elle prétend suivre.

### Ce qui a été modifié

Douze choses, où l'objet demeure et sa forme change.

| # | Objet | G2 | G3 |
|---|---|---|---|
| **M1** | **Emplacement du code** | `bin/` et `lib/clia/` à la racine | `_scripts/bin/`, `_scripts/lib/`, `_scripts/lib/cmd/`, et `_ressources/*/scripts/` — le préfixe souligné marquant une zone d'instrumentation |
| **M2** | **Découpage des modules** | 7 modules, un par objet, jusqu'à 792 lignes | 13 fichiers de commande, plus 3 modules partagés |
| **M3** | **Forme d'une définition de type** | markdown prescrit, avec rubriques justificatives | contrat YAML |
| **M4** | **Validation** | 74 fichiers CUE, non employés par une commande | les champs de la définition, non employés par une commande |
| **M5** | **Instrumenter un dépôt** | `clia setup init` | `clia init`, promu au premier niveau |
| **M6** | **Diagnostiquer un dépôt** | `clia setup check` : instrumentable, ou conforme | `clia check` : sept contrôles nommés, contre un inventaire déclaré |
| **M7** | **`setup`** | l'objet portait l'instrumentation | l'objet ne porte plus que l'installation : `status`, `uninstall` |
| **M8** | **Modes d'installation** | `activate` éphémère, `install` permanent | `install --activate` restreint au dépôt source, `install --dev` ouvert à tout dépôt |
| **M9** | **Garde d'écriture git pour l'agent** | dans le CLI : refus et code `3` | dans un hook de l'environnement d'agent — et `clia release` commite sans garde |
| **M10** | **Harnais** | quatre fichiers générés, déclarés dans `harnais.yaml` | un fichier, une primitive sous sa ressource, deux zones gérées |
| **M11** | **`INTENTION.md`** | dérivé d'une définition de type | lien symbolique vers une instance `INT-001` |
| **M12** | **Tests** | un fichier de 1 443 lignes | dix bancs sur une bibliothèque commune, 2 889 lignes, 1 062 cas |

### Ce que ce différentiel dit

**Une seule modification commande tout le reste.** A1 — le passage d'une liste
écrite à une découverte — est ce qui rend possibles A2, A3, A9, A10, A12, M1 et
M2. Sans elle, chaque ajout de G3 aurait demandé de modifier le point d'entrée.

**Le retrait n'est pas un abandon : c'est un déplacement d'assiette.** Sur les
onze retraits, cinq portent sur des objets que G2 avait construits pour se
gouverner elle-même — registre, focus, configuration, constitution, décisions.
Ils ont disparu avec le régime qu'ils servaient. Les six autres portent sur des
capacités qui manquent aujourd'hui, et E5 comme E6 sont déjà réclamées.

**Ce qui est ajouté est massivement de la réconciliation.** Quatre des quatorze
ajouts, et les quatre plus structurants, sont des faces du même mécanisme non
nommé. C'est le résultat qui justifie le mieux `SPC-003` du corpus
d'architecture.

**Un défaut a traversé le changement de génération sans être vu.** C11 :
la politique de permissions du dépôt cite une constitution absente, protège
quatre emplacements dont trois n'existent plus, autorise un outil abandonné, et
ignore deux des dix bancs de tests. Le hook fonctionne, et son fondement écrit
pointe vers le vide.

C'est exactement le défaut que `clia check` a été construit pour attraper — un
dépôt qui dérive de sa déclaration sans que personne s'en aperçoive — et il
passe au travers, parce que les sept contrôles portent sur l'inventaire de
`.dev/clia.yaml` et non sur la périphérie du dépôt.

**Le geste que ce constat appelle** est de reprendre `.claude/settings.json` et
son hook : réécrire leur fondement sur ce qui existe, ajouter les deux bancs
manquants, retirer l'autorisation de l'outil abandonné, et trancher si la garde
d'écriture git doit revenir dans le CLI — puisque `clia release` commite
aujourd'hui sans qu'aucune règle ne s'y oppose. Ce geste n'est pas fait ici :
il touche la politique de sécurité du dépôt, et cela appartient à l'humain.

## Limites

**G2 n'a pas été exécutée.** Sa surface est lue dans son dispatch et ses blocs
d'aide. Un verbe implémenté sans être documenté dans l'aide, ou documenté sans
être implémenté, serait mal classé. Aucun contrôle croisé n'a été fait sur ce
point.

**Le différentiel porte sur le CLI, non sur le système.** Les définitions de
type, les schémas et les harnais sont comptés parce qu'ils commandent le
comportement du CLI ; le reste des cinq cents documents de G2 est hors sujet et
n'a pas été comparé.

**« Resté le même » est une lecture d'intention, pas une identité de code.**
Aucune des onze choses de la première catégorie n'est identique ligne à ligne ;
elles sont jugées inchangées parce que le concept, la forme et la place tenue
sont les mêmes. Un autre lecteur pourrait ranger `S1` ou `S4` dans les
modifications.

**La frontière entre « ajouté » et « modifié » est un choix.** `clia check` est
classé comme un ajout parce que ses sept contrôles et son inventaire n'ont pas
d'antécédent, alors que `clia setup check` existait ; on pourrait le classer
comme une modification. Le classement est déclaré ici pour être contestable.

**Rien n'est mesuré sur ce que les retraits ont coûté à l'usage.** Aucune donnée
n'existe sur l'emploi réel de `clia focus`, `clia session` ou `clia config` avant
leur disparition. Que personne ne les réclame, sauf `config`, est une indication
faible et non une mesure.

**La périphérie n'a été examinée que pour `.claude/`.** D'autres artefacts de G2
peuvent avoir survécu ailleurs sans être migrés ; ils n'ont pas été cherchés.

## Relations

- `derive-de` `.dev/analyses/ANL-001-conception-et-usage-des-cli.md`
- `reference` `.archives/2026-08-23/` — la génération comparée
- `reference` `.archives/2026-08-23/analyses/ANL-013-pourquoi-l-humain-ne-peut-pas-agir.md`
- `reference` `.archives/2026-08-23/analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md`
- `reference` `ENHANCEMENT.md` — le retour réclamé de `clia config`
- `reference` `docs/architecture/specs/SPC-003-boucle-de-reconciliation.md`
