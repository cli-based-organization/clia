# La demande, tâche 15 de SES-002

`MET-003` étape 1. Écrit avant toute exploration.

## L'énoncé, repris sans reformulation

> ## 15. [plan de rémédiation] initialisation d'un repo clia: comportement attendu
>
> suite à l'initialisation du repo ~/git/cli-based-organization/clia-repos avec la commande `clia setup init --dev ... `, je constate les défauts suivant
>
> - Il n'y a pas de harnais IA CONSTITUTION.md
> - Le fichier INTENTION.md a été peuplé avec le fichier intention du repo clia
>
> Ce qu'il faut faire =>
>
> - tout les harnais générés (CLAUDE.md, SKILLs, CONSTITUTION.md, ARCHITECTURE.md ) proviennent de fichiers de source de vérité yaml + génération à partir d'un template
> - fournir un fichier constitution.
> - le fichier ARCHITECTURE.md est optionnel
> - le fichier INTENTION.md est un symlink sur .dev/intentions/INT-001.md
> - le fichier INTENTION.md est un template vide à remplir.
> - si un fichier INTENTION.md existe déjà, le déplacer vers INT-001.md et en faire un symlink sur INTENTION.md

## Ce que je comprends

**Deux défauts constatés à l'usage**, sur un dépôt réel que je peux inspecter.

**Le second est le plus grave.** Un `INTENTION.md` peuplé avec l'intention du dépôt `clia` n'est pas un fichier manquant : c'est **le contenu d'un dépôt qui fuit dans un autre**. Un dépôt neuf hérite d'une intention qui n'est pas la sienne, et rien ne le signale.

**Six exigences** suivent, et elles ne sont pas toutes de même nature :

| Exigence | Nature |
|---|---|
| Les harnais viennent d'un YAML source de vérité + template | Architecture de génération |
| Fournir un fichier constitution | Livrable manquant |
| `ARCHITECTURE.md` optionnel | Règle |
| `INTENTION.md` est un lien vers `.dev/intentions/INT-001.md` | Structure |
| `INTENTION.md` est un gabarit vide | Correction du défaut 2 |
| Un `INTENTION.md` existant est déplacé puis lié | Migration |

**La quatrième reprend le motif de `PLN-008`** : le fichier de session vit dans `.dev/logs/`, et `workspace/session.md` n'est qu'un lien symbolique. Le même geste est demandé pour l'intention.

## Le type de la tâche

`[plan de rémédiation]`, comme la tâche 10. Je le range avec `[planification]` : **elle produit un plan, elle ne l'exécute pas.** `MET-005` étape 1.

## Les livrables prévus

| Livrable | Ce qu'il porte |
|---|---|
| Un `BUG` | Les deux défauts constatés, mesurés sur le dépôt réel |
| Un `PLN` | La remédiation, en chantiers SMART |

**Pas d'analyse séparée.** Le diagnostic tient dans les rubriques « L'écart » et « La cause » du bogue. La session dit que le nombre d'items doit descendre ; produire un document de plus quand deux suffisent irait contre.

## Ce que je surveille

**Le dépôt `clia-repos` est inspectable.** Les deux défauts doivent être mesurés sur lui, non déduits du code. C'est ce qui distingue un bogue constaté d'un bogue supposé.

**La génération depuis un YAML est un chantier, pas une phrase.** Elle touche `CLAUDE.md`, les skills, `CONSTITUTION.md` et `ARCHITECTURE.md` — quatre familles de harnais. Si elle n'est pas découpable en chantiers SMART, elle sort du plan et je le déclare.

**`MET-005` étape 6** : la tâche se terminera sur une directive unique, cohérente avec `clia focus`.
