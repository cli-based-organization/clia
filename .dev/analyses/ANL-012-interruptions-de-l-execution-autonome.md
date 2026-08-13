---
type: analyse
id: ANL-012
title: "Interruptions de l'exécution autonome"
status: draft
date: 2026-08-13
sujet: "diagnostic de BUG-001 : pourquoi l'agent est interrompu, et ce qui peut y mettre fin"
---

# ANL-012 - Interruptions de l'exécution autonome

> `DCN-017` demande que l'humain n'ait pas à intervenir une fois la tâche lancée. Quinze interruptions ont été relevées sur deux tâches. Quatorze ne viennent d'aucune règle du dépôt.

## Objet

Diagnostiquer `BUG-001`, proposer des correctifs, retenir le plus prometteur.

La question posée : **pourquoi l'agent est-il interrompu, et qu'est-ce qui peut y mettre fin sans supprimer le jugement ?**

## Méthode

Les quinze interruptions consignées dans `BUG-001` portent chacune le motif affiché par l'outil. Elles ont été classées deux fois : par motif, puis par **ce qui les aurait évitées**. Le second classement est celui qui décide, parce qu'un motif ne dit pas qui peut agir.

La configuration du dépôt — `settings.json`, `settings.local.json`, le hook `PreToolUse` — a été lue, ainsi que le journal de la tâche 000 qui l'a produite.

## Constats

### C1. Quatorze interruptions sur quinze ne viennent d'aucune règle du dépôt

| Motif affiché | Occurrences |
|---|---|
| `shell syntax (string) that cannot be statically analyzed` | 8 |
| `Contains simple_expansion` | 4 |
| `Contains expansion` | 2 |
| `Permission rule Bash(sed -i:*) requires confirmation` | 1 |

**Une seule venait d'une règle du dépôt**, et elle a été retirée le 2026-08-12. Les quatorze autres viennent de ce qu'une ligne de commande contenant une variable, une substitution ou un document en place **ne peut être comparée à aucune règle** : l'outil ne sait pas ce qu'elle fera, donc il demande.

### C2. La discipline de conduite règle moins de la moitié des cas

`settings.json` porte, depuis la tâche 000, cette conclusion : « la réponse est d'écrire les fichiers avec l'outil d'écriture plutôt qu'avec un document en place ». Le classement par remède la mesure.

| Ce qui aurait évité l'interruption | Nombre |
|---|---|
| Écrire le fichier avec l'outil d'écriture | 3 |
| Écrire le chemin en toutes lettres au lieu d'une variable | 3 |
| Une règle du dépôt — déjà corrigée | 1 |
| **Rien que l'agent puisse changer dans sa conduite** | **8** |

**La répartition des six premières a été corrigée le 2026-08-13**, en reprenant les cas un par un pour le chantier B de `PLN-015` : 3 et 3, non 4 et 2. Le premier compte avait pris pour deux interruptions distinctes les deux documents en place d'un même appel. **Le total évitable reste six, et aucune conclusion ne change.**

**Les huit irréductibles sont des scripts d'épreuve** : activer l'environnement, créer un dépôt jetable, y lancer `clia setup init`, comparer une empreinte avant et après. Ils ont besoin de variables et de substitution — c'est ce qui les rend reproductibles.

**La conduite supprime six interruptions sur quinze**, et laisse celles qui accompagnent le travail le plus utile : éprouver ce qu'on vient d'écrire. C'est un correctif réel et insuffisant.

### C3. Le dépôt n'a aucun moyen d'autoriser

Trois mécanismes existent. Aucun ne couvre une ligne non analysable.

| Mécanisme | Ce qu'il fait | Pourquoi il ne suffit pas |
|---|---|---|
| `allow` | Compare un préfixe de ligne | Une ligne non analysable n'est comparée à rien |
| `deny` | Interdit | Mesuré à la tâche 000 : ne compare que le début de la ligne |
| hook `PreToolUse` | Décide | **Celui du dépôt ne sait que refuser** |

Le hook `refuser-git-en-ecriture.py` sort en 0 ou en 2. **Le code 0 signifie « je ne m'oppose pas », pas « j'autorise »** : la demande de permission a lieu ensuite comme si le hook n'existait pas.

**C'est la cause racine.** Le dépôt a écrit ses interdits et n'a jamais écrit ses permissions. Le seul point du système où une commande non analysable peut être jugée sur son contenu réel est inoccupé.

### C4. `DCN-017` est vide

La règle que `BUG-001` déclare enfreinte n'existe pas : ni objet, ni décision, ni portée, ni conséquences. Cinq champs du frontmatter portent `À RENSEIGNER`.

`RES-036` définit le bogue **par la règle qu'il enfreint**. Ici, il n'y a rien à enfreindre — seulement un titre qui énonce une intention.

### C5. `settings.local.json` est trois fois plus gros que la politique versionnée

12 936 octets contre 3 602. Il porte des règles nées dans d'autres dépôts — `cryptosecops`, `disruptiva-dev`, `ticket-driven-ai` — et des chemins qui n'existent pas ici, comme `./src/bin/clia`.

Ce n'est pas une cause d'interruption : les règles y sont permissives. C'est un obstacle au diagnostic — **on ne sait pas, en lisant le dépôt, ce qui est effectivement autorisé.**

## Réponse à la question posée

### Les quatre pistes

| Piste | Ce qu'elle supprime | Ce qu'elle coûte |
|---|---|---|
| A. Discipline de conduite | 6 sur 15 | Rien. Insuffisant seul |
| B. `--permission-mode bypassPermissions` | 15 sur 15 | Tout jugement disparaît, sauf `deny` et le hook |
| C. Scripts d'épreuve dans un fichier, puis exécution | ~8 sur 15 | L'analyse statique est contournée sans être remplacée |
| **D. Un hook qui autorise sur critère** | **15 sur 15** | Écrire la politique, et l'éprouver |

### Ce que je retiens : D, complété par A

**D est le seul qui supprime les interruptions sans supprimer le jugement.** La politique devient un fichier du dépôt : versionnée, testable, lisible. L'humain la lit une fois au lieu de la ré-appliquer quinze fois par tâche.

C'est aussi ce que `BUG-001` propose : `clia config ia policy check` pour diagnostiquer, `apply` pour corriger.

**A l'accompagne** parce qu'il est gratuit et qu'il réduit la surface sur laquelle la politique doit se prononcer. Une règle de conduite écrite dans le harnais coûte zéro ligne de code.

**B reste bon comme outil, pas comme régime.** Pour une exécution non interactive ponctuelle, c'est le bon choix, et `settings.json` le dit déjà. En permanence, il rendrait `BUG-001` invisible plutôt que résolu.

**C est écarté** : un script dans un fichier n'est pas plus jugé qu'une ligne non analysable, il est seulement moins visible.

### Ce que le correctif doit tenir

| Exigence | Pourquoi |
|---|---|
| Le hook `C2` continue de refuser | `CONSTITUTION.md`, et il a été mesuré sous `bypassPermissions` |
| La politique est un fichier du dépôt | Sinon le diagnostic reste impossible, voir C5 |
| Elle est éprouvée par un banc de cas | Le hook `C2` en a un de 42 cas ; c'est le précédent |
| Elle nomme ce qu'elle n'autorise pas | Une politique qui autorise tout est `bypassPermissions` sous un autre nom |

## Ce que la mesure a établi, et qui contredit la piste retenue

**Ajouté le 2026-08-13, tâche 12, après l'exécution du chantier A de `PLN-015`.**

La piste D reposait sur une propriété non vérifiée : qu'un hook puisse autoriser. Quatre passages en dépôt jetable donnent ceci.

| Règle `ask` | Hook | Résultat |
|---|---|---|
| `["Bash"]` | aucun | Refusée |
| `["Bash"]` | rend `allow` | **Refusée**, alors que le hook a bien été appelé |
| `[]` | aucun | Exécutée |
| `[]` | rend `deny` | **Refusée** par le seul effet du hook |

**Un hook décide dans le sens du refus, pas dans celui de l'autorisation.** Sa décision `allow` ne lève pas une règle `ask` du projet.

**La piste D n'est pas démontrée fausse : elle est indémontrable par script.** Le mode non interactif ne produit jamais la demande de confirmation qui fait l'objet de `BUG-001` — sans règle `ask`, la commande contenant `$(date)` s'exécute. Établir qu'un hook supprime cette demande exigerait une session interactive et un humain qui regarde l'écran.

**Ce que la recommandation devient.** La piste A tient et a été exécutée : elle supprime six interruptions sur quinze. **Les huit autres n'ont, à ce jour, aucun correctif établi** hors de la piste B — le mode de permission à l'invocation, qui reste un outil et non un régime.

## Limites

**Le mécanisme d'autorisation par hook n'avait jamais servi dans ce dépôt** au moment de l'écriture. Il a été mesuré depuis, et la section ci-dessus le rapporte.

**Les quinze interruptions viennent de deux tâches**, celles que l'humain a pris la peine de consigner. `BUG-001` dit qu'il y en a eu d'autres. La répartition par cause est donc établie sur un échantillon documenté, non sur la population.

**Aucune des quinze n'a été rejouée.** Le classement par remède repose sur la lecture des lignes de commande, pas sur une reproduction. Le premier chantier du plan corrige ce point en mesurant sur un dépôt jetable.

**La portée de ce que la politique autorisera n'est pas tranchée ici** : c'est une décision de sécurité, et elle fait l'objet de `NON-040`.

## Relations

- `derive-de` [BUG-001](../bogues/BUG-001-execution-de-claude-cli-sans-interruption.md)
- `reference` [DCN-017](../decisions/DCN-017-le-systeme-clia-doit-etre-utilisable-sans-intervention-humaine-autre-que-le-lancement-d-une-commande-tache.md)
- `reference` [NON-040](../objections/NON-040-portee-de-la-politique-d-autorisation.md)
