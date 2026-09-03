---
type: specification
id: clia:4749080f-037d-4fc5-8a93-4615d3042cc0
titre: "L'identité d'une ressource"
ordre: 2
source: SES-001 tâche 24
editeur: agent
---

# SPC-003 — L'identité d'une ressource

SPC-001 dit ce qu'une ressource **est**. SPC-002 dit par quoi elle **passe**.
Ce document dit à quoi on la **reconnaît**.

Il est dérivé de SES-001 tâche 24, et il est de deuxième ordre : un agent l'a
rédigé à partir de l'énoncé d'un humain, et un humain le relit. Là où
l'énoncé laissait un choix, la décision prise est notée et attribuée.

## 1. Une ressource se reconnaît à une seule chose

**Elle porte des informations d'identification et d'essentialisation — une
IIE.**

Tout le reste — un fichier, un répertoire, un dépôt git — est une **forme de
représentation**. Ce qui fait d'une représentation une ressource, c'est
qu'une IIE la désigne.

C'est pourquoi la présence d'une IIE est le premier critère de conformité :
les autres jugent une ressource, celui-ci juge qu'il y en a une — REQ-004 §3.

## 2. Trois natures d'information

| Nature | Ce qu'elle fait | Exemple |
|---|---|---|
| **identité** | atteste l'unicité | `id: clia:0f9a…` |
| **essentielle** | définit ce que la ressource est | `nom`, `titre`, `prefixe`, `version`, `description` |
| **accidentelle** | décrit comment elle est, ce qui lui est arrivé | une empreinte, une date, un état, un journal |

**L'IIE porte les deux premières, et elles seules.** Les accidentelles vivent
où elles servent : `.empreintes.yaml` dit ce qu'une cible a vu, la carte dit
ce que le dépôt a installé, git dit ce qui s'est passé. Aucune ne dit ce
qu'une ressource est.

**Décision — la version est essentielle, non accidentelle.** SPC-001 §1.2
pose qu'une ressource clia n'est pas compatible avec clia mais avec une
version de clia ; sa propre version fait donc partie de ce qu'elle est. Une
ressource à deux versions est deux ressources compatibles avec deux états du
système. Décision prise par l'agent le 2026-09-03, à confirmer.

## 3. L'identité est polymorphe

Une même ressource se désigne de trois façons, selon d'où l'on parle.

| Forme | Écriture | Portée |
|---|---|---|
| absolue | `clia:<uuid>` | partout, et pour toujours |
| relative | `<PREFIXE>-<SEQ>` | dans un dépôt |
| partageable | `<NAMESPACE>/<PREFIXE>-<SEQ>` | entre dépôts |

Le `NAMESPACE` est une chaîne d'autorité contrôlée par l'éditeur —
`clia.noumanity.com` pour ce dépôt-ci, édité par Groupe Innovation Numanity
inc.

**Décision — seule la forme absolue est déclarée.** Un uuid ne se déduit de
rien ; les deux autres se dérivent :

* la séquence, du nom de l'instance — `RES-001-ressource` donne `001` ;
* le namespace, de la carte du dépôt qui publie.

Déclarer ce qui se déduit ferait deux endroits à tenir d'accord, et une
déclaration qui contredirait le dépôt serait une déclaration qui ment. C'est
la même règle que pour les propriétés d'une primitive — SPC-002 §3.

**Décision — l'autorité est celle qui publie, non celle qui lit.** Une
ressource reprise d'une extension garde le namespace de son éditeur. Deux
dépôts qui l'emploient la nomment donc pareil, ce qui est le seul intérêt
d'une forme partageable.

**Une ressource sans séquence se désigne par son seul préfixe.** Une
ressource clia — par opposition à l'une de ses instances — n'a pas de
séquence : `RES`, et `clia.noumanity.com/clia/RES`.

## 4. Interne ou externe

**L'IIE est dans la représentation, ou à côté d'elle.**

### 4.1 Interne

La représentation porte son IIE. Trois porteurs, et le type du fichier les
départage :

```
.yaml, .yml           les clés de tête
.md                   le frontmatter
autre fichier texte   un en-tête de commentaires — « # clia-id: clia:… »
```

Un répertoire la porte dans un fichier qui lui appartient : une ressource
installée dans `<nom>/<nom>.yaml`, une instance dans le livrable de sa
définition. Un dépôt la porte dans sa carte.

**Un fichier qui ne peut porter aucune IIE interne — un CSV, une image, un
binaire — a besoin d'une IIE externe.** C'est la même limite que pour les
propriétés d'une primitive, et pour la même raison : il n'y a nulle part où
écrire.

### 4.2 Externe

Un fichier structuré porte l'IIE, et il **doit** dire vers quoi elle pointe :

```yaml
id: clia:0f9a1b2c-3d4e-5f60-8192-a3b4c5d6e7f8
nom: rapport-2026
titre: "Rapport 2026"
prefixe: RAP
version: 1.0.0
description: "Le rapport annuel."
representation: rapport-2026.pdf
```

**Sans `representation`, une IIE externe n'identifie rien.** clia le refuse.

**Décision — le chemin est relatif au fichier qui porte l'IIE.** C'est de là
qu'elle pointe. Une URI, elle, est absolue par nature, et est reconnue à son
`://`. Décision prise par l'agent le 2026-09-03.

### 4.3 Ce qui vaut pour un fichier vaut pour toute représentation

Une ressource est **une IIE plus une représentation**, et l'IIE est interne ou
externe. C'est vrai d'un fichier, d'un répertoire, d'un dépôt git.

Ce qui change avec la forme, c'est ce que « pointer vers la représentation »
veut dire : un chemin pour un fichier, une URI pour une ressource distante,
une adresse de dépôt et une révision pour un dépôt git. Seul le premier cas
est implémenté aujourd'hui — voir §7.

## 5. La composition

**Une ressource peut être composée d'autres ressources.** Elle les nomme par
leur identité absolue :

```yaml
composee-de: clia:0f9a1b2c-… clia:1a2b3c4d-…
```

**Pointer vers l'IIE d'une ressource suffit à désigner l'ensemble de ses
fichiers.** C'est tout l'intérêt d'une identité : elle dispense d'énumérer.

La liste est un scalaire séparé par des espaces, et non une liste YAML
imbriquée — le lecteur du noyau rend un champ par entrée. REQ-006 §2 fait le
même choix, pour la même raison.

## 6. Ce que le code en tient

| Ce qui est fait | Où |
|---|---|
| lire une IIE, dériver ses formes | `_scripts/lib/identite.sh` |
| C0 — la présence et la forme absolue | `_scripts/lib/conformite.sh` |
| décrire la forme entière | `livrables/schemas/iie.cue` |
| la juger | `livrables/outils/valider-iie.sh` |
| la lire et la juger depuis le CLI | `clia res iie ls`, `clia res iie check` |
| en poser une à la création | `clia res new` |

**Décision — deux niveaux de validation, et c'est délibéré.** Le noyau
vérifie la présence et la forme absolue, en bash : ce contrôle doit répondre
partout, y compris là où cue n'est pas installé. La forme entière est jugée
par cue, contre le schéma que la ressource porte.

L'énoncé pose cue comme choix d'implémentation ; en faire une dépendance du
noyau aurait rendu `clia check` inutilisable sans lui, et clia n'a jusqu'ici
besoin que de bash, git et coreutils.

## 7. Ce que ce document ne tranche pas

**L'identité d'une instance, distincte de celle de sa ressource.** SPC-002 §2
pose qu'une instance est une ressource ; elle devrait donc porter sa propre
IIE. Aujourd'hui, l'instance et la ressource livrée partagent le fichier de
définition, et donc l'identité. Les séparer demande de dire où l'IIE d'une
instance vivrait.

**L'IIE d'un dépôt.** La carte peut porter `id:`, et `clia res iie ls` le
rend. Rien n'en tire encore de conséquence, et rien ne dit quel préfixe un
dépôt porte.

**La découverte hors d'un dépôt.** SES-001 tâche 24 demande que
`clia res ls`, hors d'un dépôt, trouve « tous les repos qui sont des
ressources ». Rien ne dit où clia chercherait : le disque entier, un
registre, les sources déclarées ailleurs. La question appartient à l'humain,
et `clia res iie ls` ne répond que dans un dépôt.

**La forme relative d'une primitive.** `SPC-003` est une forme relative, et
elle est dérivée du nom du fichier. Rien ne relie encore ce préfixe à une
ressource `SPC` qui serait installée — SPC-002 §6 laisse la même question
ouverte.

**Les représentations qui ne sont pas des chemins.** §4.3 les nomme ; seul le
chemin relatif et l'URI sont reconnus. Un dépôt git comme représentation
demanderait au moins une adresse et une révision.
