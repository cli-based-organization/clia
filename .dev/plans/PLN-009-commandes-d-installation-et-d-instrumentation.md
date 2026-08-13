---
type: plan
id: PLN-009
title: "Commandes d'installation et d'instrumentation"
status: draft
statut-plan: execute
date: 2026-08-12
initiateur: humain
sert: [FNC-003]  # a livré clia setup check et init
porte-sur: [setup.sh, bin/clia, RES-020]
---

# PLN-009 - Commandes d'installation et d'instrumentation

> Quatre chantiers, chacun à livrable unique, critère exécutable et limite déclarée. Le premier est un préalable que `PLN-003` réclame depuis le 2026-08-11 : personne n'a écrit ce qu'est un dépôt `clia` conforme, et trois des cinq commandes demandées en dépendent.

## Statut

`execute`. Les quatre chantiers ont été exécutés par la tâche 5 de `SES-002`, le 2026-08-12.

**Un écart au chantier A**, décidé en l'exécutant : la spécification n'exprime pas ses critères en commandes shell, `RES-020` l'interdisant. Le journal de la tâche 5 le déclare.

Le diagnostic et les mesures sont dans le journal de la tâche 4.

**Limite de temps : sept heures**, réparties par chantier. Les durées sont des estimations déclarées comme telles : le dépôt n'a mesuré la durée d'aucun chantier, et `PDC-003` V-S3 exige une déclaration, non une justification.

## Intention

Faire sortir `clia` de son propre dépôt.

**Cible mesurable.** Dans un dépôt git quelconque, `clia setup init` produit un dépôt instrumenté, et `clia res ls` y répond au lieu d'échouer.

C'est le premier critère de convergence de `SES-002` : « le créateur est capable de travailler simultanément sur le développement de `clia` et sur une multitude d'autres projets ».

## Ce que les expérimentations antérieures ont tranché

Dix dépôts de `$HOME/git` portent un `setup.sh`. Quatre ont été examinés, et `ticket-driven-ai` est le précédent direct : deux de ses choix sont repris.

**Deux niveaux, et non un.** Installer le CLI n'est pas instrumenter un dépôt. `setup.sh` fait le premier, `clia setup init` fait le second.

**Le mode développement est un régime de liaison.** `tda install --dev` pose des liens symboliques vers le dépôt source ; sans `--dev`, il copie. C'est la réponse aux exigences 4 et 5 de la demande : le code employé est celui du dépôt de développement, et celui-ci n'est pas modifié.

## Chantiers

### Chantier A - La spécification de conformité d'un dépôt clia

| Élément | Valeur |
|---|---|
| **Livrable** | Une `SPC`, première instance du type |
| **Critère de réussite** | Chaque critère de conformité s'exprime par une commande shell dont le code de retour tranche |
| **Limite de temps** | 2 heures |
| **Dépend de** | rien |

**Contrôle exécutable.** Le nombre de critères déclarés égale le nombre de commandes de vérification écrites, et chacune s'exécute sans erreur sur ce dépôt-ci.

**Pourquoi ce chantier est premier.** `PLN-003` G1 : « Sans les critères, `init` ne sait pas quoi produire et aucun contrôle ne sait quoi vérifier. » Trois des cinq commandes demandées en dépendent.

**Ce qu'il produit accessoirement.** La première instance du type `SPC`, défini par `RES-020` et sans instance depuis sa création. `ANL-010` C1 mesure ce vide, et `ADR-016` D3 est inapplicable tant qu'il dure.

**Deux niveaux de conformité, non un.** Un dépôt peut être *instrumentable* sans être *instrumenté*. La spécification déclare les deux jeux de critères, ce qui permet à un seul `check` de répondre aux deux questions de la demande.

### Chantier B - `clia setup check [PATH]`

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/setup.sh`, verbe `check` |
| **Critère de réussite** | Sur un dépôt vierge, sur ce dépôt-ci, et sur un répertoire sans git, la commande rapporte trois diagnostics distincts |
| **Limite de temps** | 1 heure 30 |
| **Dépend de** | A |

**Contrôle exécutable.** Trois appels en dépôt jetable, trois codes de retour distincts, et chaque critère de la `SPC` apparaît dans la sortie avec son verdict.

**Ce que la commande répond.** Les deux questions de la demande à la fois : un dépôt non instrumenté reçoit le diagnostic d'instrumentabilité, un dépôt instrumenté reçoit le diagnostic de conformité.

**C'est une lecture, déclarée comme telle.** La demande nomme deux commandes `clia setup check` de sémantiques différentes. `NON-039` pose la question du nommage.

**Rien n'est écrit.** `check` diagnostique et ne modifie aucun fichier, y compris sur le dépôt cible.

### Chantier C - `clia setup init [PATH]`

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/setup.sh`, verbe `init` |
| **Critère de réussite** | Après `init` dans un dépôt jetable, `clia setup check` y répond « conforme » |
| **Limite de temps** | 2 heures |
| **Dépend de** | A, B |

**Contrôle exécutable.** La chaîne complète en dépôt jetable : créer, `init`, `check` retourne 0, et `clia res ls` affiche des types au lieu d'échouer.

**Ce que la commande fait.** Elle crée le dépôt git s'il n'existe pas, pose l'arborescence conventionnelle, et installe les fichiers de harnais.

**Le régime de liaison.** En mode développement, les fichiers de harnais sont des liens symboliques vers `CLIA_HOME` ; hors mode développement, des copies. C'est le choix de `tda`, repris.

**Ce qui protège le dépôt cible.** `init` refuse d'écraser un fichier existant : il l'annonce et le laisse. Le geste est celui de `clia_session_poser_lien`, qui refuse déjà d'écraser un point d'entrée.

**Ce qui protège le dépôt source.** Aucune écriture dans `CLIA_HOME`, ce que l'exigence 5 de la demande impose. Le contrôle : relever l'empreinte du dépôt source avant et après un `init`, elle est identique.

### Chantier D - `. setup.sh install --dev`

| Élément | Valeur |
|---|---|
| **Livrable** | `setup.sh`, drapeau `--dev` |
| **Critère de réussite** | `. setup.sh install --dev` déclare le mode et ses cinq propriétés ; `install` sans drapeau les déclare aussi |
| **Limite de temps** | 45 minutes |
| **Dépend de** | rien |

**Contrôle exécutable.** `. setup.sh install --dev` sur un faux fichier de démarrage produit le même bloc que `install`, et sa sortie nomme le mode.

**Ce que le chantier ne crée pas.** Le mode existe déjà : `setup.sh install` pointe `CLIA_HOME` vers le dépôt de développement, n'y copie rien, et n'écrit que dans le fichier de démarrage de l'utilisateur. **Les cinq exigences de la demande sont satisfaites aujourd'hui, sans que le mot soit écrit nulle part.**

Le chantier nomme ce qui existe et le rend vérifiable. C'est le geste que `ANL-010` recommande : écrire d'abord la spécification descriptive de ce qui existe, non la spécification prescriptive de ce qui manque.

## Ce qui est sorti du plan

Trois points ne satisfont pas `PDC-003` et vivent dans un `ISU` et un `NON`, comme la tâche le demande.

| Point écarté | Motif |
|---|---|
| `clia setup upgrade [VERSION]` | Ni version déclarée par un dépôt instrumenté, ni mécanisme de migration, ni inventaire de ce qui change. Aucun critère de réussite ne peut être écrit |
| Le double nommage de `check` | Deux sémantiques sous un même nom. Le plan retient une lecture ; le choix appartient à l'humain |
| Le mot « remote » | Le dépôt source est déjà désigné par `CLIA_HOME`. Introduire un second mot pour la même chose demande une décision |

`MET-004` étape 6 : ne pas implémenter un livrable dont le préalable est ouvert, même s'il est SMART.

**Le premier point est le plus lourd.** Le second critère de convergence de `SES-002` est « la mise à jour de `clia` et la migration des données est possible et facile ». Ce plan ne l'atteint pas, et `ISU-012` porte pourquoi.

## Livrables attendus

| Chantier | Livrable | Durée |
|---|---|---|
| A | Une `SPC` | 2 h |
| B | `setup.sh`, verbe `check` | 1 h 30 |
| C | `setup.sh`, verbe `init` | 2 h |
| D | `setup.sh`, drapeau `--dev` | 45 min |
| | **Total** | **6 h 15** |

Sous la limite de sept heures.

## Ordre d'exécution

```
A ──> B ──> C

D, indépendant
```

**Un point d'arrêt.** Après A : si la spécification ne peut pas être écrite en critères exécutables, B et C n'ont pas de fondement et le plan s'arrête là.

## Objections de l'agent

**Le chantier A est un livrable de spécification écrit par l'agent, et il fera autorité sur trois commandes.** `ANL-010` recommande d'écrire d'abord la spécification descriptive de l'existant ; ici il n'y a pas d'existant à décrire pour `init`, donc elle sera prescriptive. C'est le régime que `FND-004` associe à XHTML 2.0, et dont l'histoire est mauvaise.

**Le chantier C écrit dans des dépôts tiers.** C'est la première commande de `clia` qui sorte de son propre dépôt. Une erreur y coûte plus cher qu'ailleurs, et la garde de non-écrasement est une précaution, non une garantie.

**Ce plan n'atteint pas le second critère de convergence de sa session.** La mise à jour en est absente, faute de pouvoir écrire un critère de réussite. Le plan livre quatre chantiers sur cinq commandes demandées.

**Le mode développement est déclaré satisfait sans avoir été éprouvé ailleurs.** Les cinq exigences de la demande sont tenues par le `setup.sh` actuel d'après lecture du code, non d'après un usage dans un autre dépôt.

## Relations

- `reference` [PLN-003](PLN-003-mise-en-conformite-avec-dcn-013.md)
- `reference` [ANL-010](../analyses/ANL-010-source-de-verite-de-l-implementation.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
- `reference` [ISU-012](../issues/ISU-012-la-mise-a-jour-d-un-depot-instrumente-n-a-pas-d-objet.md)
- `reference` [NON-039](../objections/NON-039-ce-que-les-commandes-d-installation-laissent-ouvert.md)
