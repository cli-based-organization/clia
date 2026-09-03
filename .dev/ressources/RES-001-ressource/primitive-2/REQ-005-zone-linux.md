---
type: requis
id: REQ-005
titre: "Une zone, sur Linux"
ordre: 2
source: SES-001 tâche 21
---

# REQ-005 — Une zone, sur Linux

SPC-001 §2 nommait deux zones et les tenait pour acquises. SES-001 tâche 21
en fait une notion : **une zone est un endroit où vit ce qu'une ressource
écrit, et c'est la ressource qui la déclare.**

Ce document dit comment cela existe sur un système de fichiers Linux : ce
qu'une ressource déclare, comment la variable s'en déduit, dans quel ordre la
valeur se résout, ce que l'amorce est, et ce qui se vérifie.

Il est de deuxième ordre : un agent l'a rédigé en écrivant le code, et un
humain le relit. Ce qu'il décrit est ce que `_scripts/lib/commun.sh` et
`_scripts/lib/cmd/config.sh` tiennent au 2026-09-02.

## 1. Ce qu'est une zone

**Un chemin relatif à la racine du dépôt de travail.** Pas un chemin absolu :
une zone désigne un endroit *dans* un dépôt, et un dépôt cloné ailleurs garde
ses zones.

Une zone a trois choses, et rien de plus :

```
un nom          ressource, ressource-livree, harnais
un défaut       .dev/ressources, .clia/ressources, .dev/harnais-ia
une description ce qu'elle porte, en une ligne
```

La variable d'environnement qui la déplace **ne se déclare pas** : elle se
déduit du nom. `CLIA_ZONE_`, puis le nom en majuscules, les tirets changés en
soulignés.

```
ressource         →  CLIA_ZONE_RESSOURCE
ressource-livree  →  CLIA_ZONE_RESSOURCE_LIVREE
bloc-notes        →  CLIA_ZONE_BLOC_NOTES
```

Deux endroits à tenir d'accord — un nom et une variable — auraient fini par
se contredire. Un seul ne le peut pas.

## 2. Qui la déclare

La ressource qui écrit dedans, dans sa définition :

```yaml
zones:
  - nom: harnais
    defaut: .dev/harnais-ia
    description: "les données des harnais IA du dépôt, et ce qui en est généré"
```

C'est ce que la tâche 21 demande : une ressource contrôle l'endroit où elle
génère. Une zone arrive donc avec la ressource, comme ses scripts et ses
skills — et le noyau ne tient aucune liste.

**Seules les ressources installées déclarent.** Ce qu'un dépôt écrit sous
`CLIA_ZONE_RESSOURCE` n'est pas lu : c'est l'invariant 4 de SPC-001, et il
vaut ici comme ailleurs. Une déclaration ajoutée à une instance ne prend
effet qu'une fois la ressource réinstallée.

L'ordre de lecture est celui des commandes : les ressources du dépôt source
de clia, puis celles du dépôt de travail, et **la première trouvée
l'emporte**. Deux ressources qui déclareraient une zone du même nom ne se
mélangent pas — la première tient, et `clia config ls` nomme celle qui la
porte.

## 3. Comment la valeur se résout

Trois sources, dans cet ordre :

```
1. la variable d'environnement    CLIA_ZONE_HARNAIS=doc/harnais clia hrn ls
2. la déclaration de la ressource zones: - nom: harnais …
3. l'amorce du noyau              pour deux zones seulement
```

`_clia_zone <nom> [dépôt]` rend le premier trouvé. Un nom qu'aucune des trois
sources ne porte rend 1 : une zone inconnue est une erreur de programme, non
une valeur vide qui ferait écrire à la racine.

## 4. L'amorce, et pourquoi elle existe

Pour lire la déclaration d'une ressource, il faut d'abord la trouver ; pour
la trouver, il faut connaître la zone livrée. **La zone livrée ne peut donc
pas être déclarée par une ressource.**

Le noyau la tient :

```
ressource-livree  .clia/ressources
```

Une déclaration portant ce nom est **ignorée** — non honorée à moitié. Le
registre la retient d'avance, et `clia config ls` continue de dire `noyau`.

Le noyau tient aussi un dernier recours pour `ressource` (`.dev/ressources`),
pour un dépôt qui n'a pas installé la ressource « ressource ». Ce n'est pas
une déclaration concurrente : c'est ce qui reste quand personne ne déclare,
et la colonne `FOURNIE PAR` dit laquelle des deux répond.

## 5. Le registre, et son coût

`_clia_zones_declarees [dépôt]` rend une ligne par zone :

```
nom SEP defaut SEP ressource SEP description
```

Il parcourt les ressources installées des deux racines et lit le bloc `zones`
de chaque définition. C'est plusieurs `glob` et plusieurs lectures YAML.

La zone des instances est demandée des dizaines de fois par commande, et
refaire ce parcours à chaque appel triplait le temps de réponse — mesuré à
2,2 s contre 0,76 s sur `clia res ls`. Le point d'entrée calcule donc le
registre une fois et l'exporte :

```
_CLIA_ZONES_MEMO    le registre, tel quel
_CLIA_ZONES_DEPOT   le dépôt pour lequel il a été calculé
```

Le mémo n'est employé que si le dépôt demandé est celui pour lequel il a été
calculé. Un appel portant sur un autre dépôt refait le parcours.

**Ce que le mémo coûte :** une ressource installée pendant l'exécution ne
déclare ses zones qu'à l'invocation suivante. Installer est un geste, et il
se termine.

## 6. Ce que `clia config ls` rend

Une ligne par variable, trois natures :

```
NATURE     VARIABLE                       SOURCE  FOURNIE PAR  VALEUR
zone       CLIA_ZONE_RESSOURCE_LIVREE     défaut  noyau        .clia/ressources
zone       CLIA_ZONE_RESSOURCE            défaut  ressource    .dev/ressources
politique  CLIA_POLICY_ROLLING_RESSOURCE  défaut  noyau        false
posée      CLIA_SOURCE_DIR                clia    noyau        /home/…/clia
```

* **zone** — un endroit où une ressource écrit.
* **politique** — une décision du système, non un emplacement. Elle ne change
  pas ce que clia sait faire ; elle change ce qu'il conclut.
* **posée** — clia l'écrit lui-même, et la régler n'a aucun effet. Elle est
  rendue parce qu'une variable qu'on croit pouvoir changer et qui sera
  réécrite est un piège.

`SOURCE` vaut `environnement` quand la variable est posée dans
l'environnement — c'est elle qui l'emporte —, `défaut` quand personne ne l'a
posée, et `clia` pour ce que clia écrit.

`--explain` ajoute, sous chaque variable, ce qu'elle règle. La forme change
alors : un bloc par variable, non la table plus des phrases. Une explication
indentée sous une ligne alignée sur des données ferait danser l'indentation
d'un rendu à l'autre.

## 7. Deux sens du mot « zone »

Le mot sert à deux niveaux dans ce système, et les confondre égare.

**Une zone au sens de ce document** est un répertoire du dépôt, déclaré par
une ressource, déplaçable par une variable.

**Une zone gérée** est une région d'un fichier de harnais, bornée par des
commentaires HTML, où clia pose ce qu'il pose et rien d'autre — voir
REQ-001 §4.2 et `_scripts/lib/texte.sh`.

Ce qui les rapproche est l'idée : un endroit dont on sait qui l'écrit. Ce qui
les sépare est l'échelle — un répertoire, une région de fichier — et rien
dans le code ne les relie.

## 8. Ce qui se vérifie

1. Une zone déclarée par une ressource installée est suivie, et la variable
   s'en déduit — tirets compris.
2. L'environnement l'emporte sur la déclaration, et la déclaration sur
   l'amorce.
3. Une déclaration de `ressource-livree` par une ressource est ignorée.
4. Déplacer `CLIA_ZONE_RESSOURCE` déplace vraiment où les instances sont
   cherchées : une instance rangée ailleurs devient visible, et celle de la
   zone par défaut ne l'est plus. Une zone qui ne serait qu'affichée ne
   serait pas une zone.
5. `clia config ls` n'écrit rien.

`_scripts/tests/test_zone.sh` les mesure — 51 cas.

## 9. Ce que ce document ne tranche pas

**Les emplacements qui ne sont pas encore des zones.** Trois au moins :

```
.claude/skills   où les skills sont posés          REQ-003 §8
.dev/sessions    où la ressource session écrit     ses.sh
CLAUDE.md        le harnais où l'on pose           fourniture.sh
```

Chacun est écrit en dur là où il sert. Les convertir est mécanique — une
déclaration dans la définition, un appel à `_clia_zone` — et demande que la
ressource concernée soit réinstallée pour que la déclaration soit lue.

**Le va-et-vient d'un dépôt qui publie.** SPC-001 §5 le laisse ouvert, et
les zones le rendent plus visible : ajouter un bloc `zones` à une instance ne
change rien tant que la copie installée ne le porte pas. Aucune commande ne
mécanise ce passage pour le dépôt qui écrit la ressource — `clia extension
install` refuse ce qui est déjà là, et `clia extension uninstall` ne connaît
que ce que la carte déclare avoir repris.

**Ce qu'une zone garantit.** Rien n'empêche une ressource d'écrire ailleurs
que dans la zone qu'elle déclare. La déclaration dit où elle écrit ; elle ne
l'y contraint pas. Un contrôle de conformité pourrait le mesurer — C1 le fait
déjà pour les instances — et ne le fait pas pour les autres zones.
