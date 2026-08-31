# SPC-001 — Grammaire de la ligne de commande

**Répond à** `RQF-001`, `RQF-002`.
**Contrainte par** `RQN-003`, `RQN-004`, `RQN-005`.

## Objet

Fixer la forme de toute invocation, la manière dont une commande est trouvée, et
ce qui est vrai de toute commande sans qu'aucune ait à le déclarer.

Cette spécification ne nomme aucun langage ni aucun format de fichier.

## S1 — Les deux axes

Une invocation se lit sur deux axes indépendants : un **objet** et un **verbe**.

```
<outil> <objet> <verbe> [cible] [options]
```

L'ensemble des verbes est petit et **stable** ; l'ensemble des objets est ouvert.
Un objet nouveau hérite des verbes existants sans que le noyau change. C'est la
propriété qui rend l'extensibilité mécanique plutôt que déclarative.

**Les deux ordres sont acceptés** quand l'ambiguïté est impossible :
`<objet> <verbe>` et `<verbe> <objet>` désignent la même demande. La condition
est vérifiable : aucun objet ne porte le nom d'un verbe, et le contrôle en est
automatisé. Si la condition cesse d'être vraie, l'ordre `<objet> <verbe>` fait
foi.

## S2 — Les verbes standard

Sept verbes couvrent la quasi-totalité des besoins. Un besoin qui ne s'y réduit
pas est d'abord le signe que le modèle d'objets est mauvais ; ce n'est qu'ensuite
un verbe à ajouter.

| Verbe | Ce qu'il fait | Écrit ? |
|---|---|---|
| `ls` | énumère, une ligne par élément | non |
| `info` | rend ce qu'une déclaration dit d'un élément | non |
| `new` | crée un élément à partir de sa déclaration | oui |
| `check` | constate l'écart entre le déclaré et le réel | non |
| `apply` | applique les écarts applicables | oui |
| `close` | fait passer un élément à un état terminal | oui |
| `explain` | rend le motif : d'où vient cet objet, ce qu'il sert | non |

**`check` et `apply` sont un couple, et jamais une option l'un de l'autre.** Un
constat qui écrit sous un drapeau est un constat auquel on n'ose pas se fier.
Un verbe qui écrit se lit dans la ligne de commande, il ne se cache pas dans une
option. La forme historique `check --fix` est admise comme alias de `apply`, non
comme sa définition.

## S3 — Ce que porte une commande, et comment elle est trouvée

Une commande est trouvée par **balayage d'emplacements conventionnels**, jamais
par un registre. Elle porte avec elle trois déclarations :

| Déclaration | Ce qu'elle dit | Si absente |
|---|---|---|
| **Description** | ce que la commande fait, en une ligne | la commande apparaît sans description |
| **Périmètre** | ce sur quoi elle agit : un dépôt, ou rien | **le plus restrictif** s'applique |
| **Alias** | les autres noms sous lesquels elle répond | aucun alias |

**La règle du plus restrictif est un invariant.** Une déclaration oubliée
restreint, elle n'ouvre jamais. C'est ce qui rend sûr un mécanisme où n'importe
quel fichier déposé devient invocable.

## S4 — La garde s'applique au point d'entrée

Le point d'entrée résout le périmètre, applique la garde correspondante, et
transmet à la commande le contexte résolu.

**Aucune commande ne vérifie son propre droit d'agir.** Une commande nouvelle
hérite du contrôle sans le déclarer, et une commande ne peut pas l'affaiblir par
omission. C'est l'unique raison pour laquelle S3 peut être aussi permissif.

## S5 — Collisions

Deux commandes de même nom sont **signalées**, jamais arbitrées en silence. La
première trouvée répond, et l'aide indique que la seconde est masquée, en
nommant qui la masque.

Le nom d'une commande est contraint pour qu'il ne puisse désigner qu'une
commande : il ne contient ni séparateur de chemin, ni référence à un répertoire
parent.

## S6 — Aide

| Invocation | Ce qu'elle rend |
|---|---|
| l'outil, sans argument | l'aide générale ; **jamais un effet** |
| l'outil, demande d'aide | l'aide générale : les commandes, les options globales, les codes de retour |
| un objet, demande d'aide | les verbes de cet objet, ses options, ses codes de retour |
| une demande mal formée | ce qui n'est pas compris, puis où trouver la forme attendue |

L'aide générale est **composée à partir de ce qui a été trouvé**. Elle ne peut
donc pas mentir sur ce qui existe, et c'est la seule garantie de son exactitude.

L'aide est une partie de l'outil, non de sa documentation.

## S7 — Options globales

Trois options valent partout et signifient partout la même chose.

| Option | Effet |
|---|---|
| aide | rend l'aide de ce qui la précède, et n'exécute rien |
| version | rend la version **de l'installation**, qualifiée comme telle (`RQN-004`) |
| format | fixe la forme de la sortie : humaine par défaut, structurée sur demande (`SPC-005`) |

Une option qui vaut pour plusieurs commandes signifie la même chose dans
toutes. Une option qui ne vaut que pour une commande est déclarée par elle.

## Ce que cette spécification ne fixe pas

Le nom de l'outil, le nom des objets, la syntaxe exacte des options longues et
courtes, et le mécanisme de complétion. Ce sont des choix d'implémentation ; ils
doivent être uniformes, non identiques à ceux d'un outil existant.

## Origine

`ANL-001` C13, V1, V5, P1. `FND-001` de G2, sections 5.1 et 5.2. La séparation
`check`/`apply` de S2 est nouvelle : elle applique `RQN-002` à ce que la
génération courante exprime par une option.
