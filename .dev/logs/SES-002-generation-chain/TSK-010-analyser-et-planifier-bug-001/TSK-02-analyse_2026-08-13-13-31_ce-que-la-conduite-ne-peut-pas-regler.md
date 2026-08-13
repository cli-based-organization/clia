# Analyse, tâche 10 de SES-002

`MET-003` étape 2. Écrit après l'exploration, avant le premier livrable.

## Ce que le contexte a établi

**`BUG-001` documente quinze interruptions**, relevées sur les tâches 4 et 5, et déclare que d'autres n'ont pas été consignées. Chacune porte le motif affiché par l'outil, ce qui rend le diagnostic mesurable plutôt que supposé.

| Motif affiché | Occurrences |
|---|---|
| `shell syntax (string) that cannot be statically analyzed` | 8 |
| `Contains simple_expansion` | 4 |
| `Contains expansion` | 2 |
| `Permission rule Bash(sed -i:*) requires confirmation` | 1 |

**Quatorze sur quinze viennent de l'analyse statique de la ligne de commande**, non d'une règle du dépôt. Une seule venait d'une règle `ask`, et elle a été retirée le 2026-08-12 par la tâche 000.

**La tâche 000 a déjà traité une partie du bogue.** `settings.json` est versionné, la règle fautive retirée, les commandes courantes passées en `allow`, et un hook porte `C2`. Le bogue est postérieur à ce travail dans son constat, antérieur dans ses causes.

## L'hypothèse antérieure, et pourquoi elle est incomplète

`settings.json` porte cette conclusion, écrite le 2026-08-12 :

> Les six autres viennent de l'analyse statique du shell, qu'aucune règle ne peut satisfaire : la réponse est d'écrire les fichiers avec l'outil d'écriture plutôt qu'avec un document en place dans une commande shell.

**La première moitié est juste, la seconde ne couvre pas les cas.** J'ai classé les quinze interruptions par ce qui les aurait évitées.

| Ce qui aurait évité l'interruption | Nombre |
|---|---|
| Écrire le fichier avec l'outil d'écriture, au lieu d'un document en place | 4 |
| Écrire le chemin en toutes lettres au lieu d'une variable | 2 |
| Une règle du dépôt — déjà corrigée | 1 |
| **Rien de ce que l'agent peut changer dans sa conduite** | **8** |

**Les huit derniers sont des scripts d'épreuve** : activer l'environnement, créer un dépôt jetable avec `mktemp`, y lancer `clia setup init`, comparer une empreinte avant et après. Ce travail a besoin de variables et de substitution de commandes — c'est ce qui le rend reproductible.

**Une conduite plus disciplinée supprime six interruptions sur quinze.** Elle en laisse huit, et ce sont celles qui accompagnent le travail le plus utile : éprouver ce qu'on vient d'écrire.

## Ce que cela dit de la cause

La cause n'est pas une mauvaise configuration, ni une mauvaise habitude de l'agent. **C'est que le dépôt n'a aucun moyen de décider à la place de l'humain.**

Trois mécanismes existent, et aucun ne couvre le cas :

| Mécanisme | Ce qu'il fait | Pourquoi il ne suffit pas |
|---|---|---|
| `allow` | Compare un préfixe de ligne | Une ligne non analysable n'est comparée à rien |
| `deny` | Interdit | Mesuré à la tâche 000 : ne compare que le début de la ligne |
| hook `PreToolUse` | Décide | **Celui du dépôt ne sait que refuser** : il sort en 0 ou en 2, et 0 signifie « je ne m'oppose pas », pas « j'autorise » |

**Le hook existant est la moitié d'un mécanisme.** Il porte l'interdit de `C2` et rien d'autre. Un hook peut aussi rendre une décision d'autorisation, et c'est le seul point du système où une commande non analysable statiquement peut être jugée sur son contenu réel.

## Les pistes de correctif, et celle que je retiens

| Piste | Ce qu'elle supprime | Ce qu'elle coûte |
|---|---|---|
| A. Discipline de conduite | 6 sur 15 | Rien. Insuffisant seul |
| B. `--permission-mode bypassPermissions` à l'invocation | 15 sur 15 | Tout jugement disparaît, sauf `deny` et le hook |
| C. Écrire les scripts d'épreuve dans un fichier, puis l'exécuter | ~8 sur 15 | Un fichier par épreuve, et l'analyse statique est contournée sans être jugée |
| **D. Un hook qui autorise sur critère** | **15 sur 15** | Il faut écrire et éprouver la politique |

**Je retiens D, complété par A.** Motif : c'est le seul qui supprime les interruptions **sans** supprimer le jugement. La politique devient un fichier du dépôt, versionné, testable, et l'humain la lit au lieu de la ré-appliquer quinze fois par tâche.

C'est aussi ce que l'humain a écrit dans `BUG-001` : `clia config ia policy check` puis `apply`.

**B est écarté comme régime permanent, pas comme outil.** Il reste le bon choix pour une exécution non interactive ponctuelle, et `settings.json` le dit déjà.

**C est écarté** parce qu'il déplace le problème : un script dans un fichier n'est pas plus jugé qu'une ligne non analysable, il est seulement moins visible.

## Ce que j'ai décidé en avançant

`MET-005` étape 2, rubrique de `MET-003` étape 2.

**Renseigner les trois champs `À RENSEIGNER` de `BUG-001`.** Le corps du document donne déjà les trois valeurs en toutes lettres : la règle est `DCN-017`, le constat porte sur les tâches 4 et 5, l'état est ouvert. C'est une transcription, pas une décision. Réversible, et l'anomalie empêchait `clia focus` de proposer le bogue à la correction.

**Ne pas mesurer moi-même que le hook peut autoriser.** Le mécanisme est documenté mais n'a jamais servi dans ce dépôt. Le vérifier demande un dépôt jetable et une session distincte : c'est le premier chantier du plan, avec son critère. Planifier une mesure vaut mieux que l'affirmer.

## Ce qui s'arrête, et pourquoi

Deux points passent du côté « s'arrêter » du filtre, et forment une seule objection.

**La portée de ce que le hook autorisera est une décision de sécurité.** Deux lectures mènent à des travaux incompatibles : une liste blanche d'exécutables, ou « tout ce que `deny` n'interdit pas ». La seconde revient à `bypassPermissions` sous un autre nom. Se tromper ici ne coûte pas une correction : cela donne à l'agent un pouvoir que personne ne regarde.

**`DCN-017` est un squelette vide.** `BUG-001` déclare enfreindre cette règle, et la règle n'est pas écrite : ni objet, ni décision, ni portée. `RES-036` définit le bogue par la règle qu'il enfreint — ici, il n'y a rien à enfreindre. Et `CONSTITUTION.md` C1 réserve la rédaction des décisions à l'humain : je ne peux pas la combler.
