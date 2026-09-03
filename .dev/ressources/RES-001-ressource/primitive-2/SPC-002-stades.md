---
type: specification
id: clia:0f1f1bd0-69c2-4971-8a97-e4aa103a5b19
titre: "Les stades d'une ressource"
ordre: 2
source: SES-001 tâche 22
editeur: agent
---

# SPC-002 — Les stades d'une ressource

SPC-001 dit ce qu'une ressource **est**. Ce document dit par quoi elle
**passe** : ses stades, de ce à partir de quoi elle est produite jusqu'à ce
qui en est rendu public.

Il est dérivé de SES-001 tâche 22, et il est de deuxième ordre : un agent l'a
rédigé à partir de l'énoncé d'un humain, et un humain le relit. Là où
l'énoncé laissait un choix, la décision prise est notée et attribuée.

## 1. Les trois stades

**Un stade n'est pas un répertoire.** C'est un moment dans la production
d'une ressource. Il se trouve qu'un répertoire le porte, et REQ-005 dit
lequel — mais un stade est un rôle, pas un emplacement.

### 1.1 Primitive

**Ce à partir de quoi la ressource est produite.** Deux ordres, et SPC-001
§1.4 et §1.5 les définissent :

* **ordre 1** — ce que seul un humain écrit. Ni un agent, ni un automatisme,
  ni une source externe. C'est le point où le système s'arrête de dériver et
  où quelqu'un décide.
* **ordre 2** — ce dont la provenance est plurielle : agent, automatisme,
  source externe, humain, ou plusieurs à la fois.

### 1.2 Générée

**Ce qui est construit à partir des primitives.**

Il vit sous `genere/`, dans l'instance, et il est le seul de ses répertoires
que clia écrit. Les recettes qui le construisent vivent dans
`generation.yaml`, à la racine de l'instance, et `clia <ressource> make` les
applique.

**Décision — clia s'inspire de make(1), et ne l'emploie pas.** SES-001
tâche 22 avait d'abord été comprise comme une délégation ; la tâche 23
corrige, et la raison est de domaine.

make connaît des sources, une compilation, des cibles. clia connaît des
primitives obtenues par une collaboration entre humains, automatismes et
agents, et des livrables qui en sont tirés. Une primitive est un peu comme un
fichier source, la génération un peu comme la compilation, un livrable un peu
comme une cible — et « un peu comme » n'est pas « pareil » :

* une dépendance peut être **une ressource** plutôt qu'un fichier, et une
  ressource a une version que le système sait lire ;
* un fichier compte par **son contenu**, non par sa date : un clone remet
  toutes les dates à la même.

Rien de cela n'a de sens pour make. REQ-006 dit comment c'est implémenté.

### 1.3 Livrée

**Ce qui est rendu public hors de la ressource.**

C'est le stade que SPC-001 §1.8 décrit : le livrable d'une instance, prêt à
être installé ailleurs. Il vit sous `livrables/`.

### 1.4 Ce que ces trois stades ne recouvrent pas

**Installée** n'est pas un quatrième stade : c'est le même livrable, déposé
dans un dépôt qui s'en sert — SPC-001 §1.9. Il change de zone, non de nature.

`zone ls` le rend quand même, parce qu'un lecteur qui demande où vit une
ressource veut le savoir.

## 2. Une instance est une ressource

C'est la note que l'énoncé souligne, et elle a deux conséquences concrètes.

**La première :** les verbes qui valent pour une ressource valent pour son
instance. `clia res prim ls` liste les primitives de l'instance que ce dépôt
écrit de la ressource « ressource ».

**La seconde :** une primitive porte un identifiant de la même forme qu'une
instance — `<PREFIXE>-<SEQ>` — et ce préfixe est celui d'une ressource.
`SPC-001` est une spécification ; `REQ-005` est un requis. Les deux vivent
sous une instance qui n'est ni l'une ni l'autre.

**Donc : toute primitive est une ressource, à un stade.** C'est la
conséquence que l'énoncé tire, et elle explique pourquoi le nom d'une
primitive porte un préfixe plutôt qu'un simple numéro.

Ce que cela ne dit pas encore : rien ne relie `SPC-001`, primitive de
l'instance `RES-001-ressource`, à une ressource `SPC` qui serait installée.
La forme du nom l'annonce ; le code ne le vérifie pas. Voir §6.

## 3. Ce qu'une primitive porte

Cinq propriétés. Trois se déduisent du fichier, deux se déclarent.

| Propriété | D'où elle vient | Valeurs |
|---|---|---|
| identifiant | le nom du fichier | `<PREFIXE>-<SEQ>` |
| ordre | le répertoire qui la porte | 1, 2 |
| structure | l'extension du fichier | structurée, semi-structurée, non structurée |
| origine | déclarée, `depot` par défaut | depot, externe |
| editeur | déclarée ; `humain` à l'ordre 1 | humain, agent, automatisme |

**Décision — ce qui se déduit ne se déclare pas.** `clia <ressource> prim
<ID> set` refuse l'identifiant, l'ordre et la structure. Une déclaration qui
contredirait le fichier serait une déclaration qui ment, et `prim check` la
traite comme un écart bloquant : c'est la déclaration qui a tort, le fichier
est là où il est.

**Décision — `origine`, non `source`.** L'énoncé dit « quelle est la source :
ce repo ou externe ? ». Le mot `source` sert déjà, dans le frontmatter des
primitives existantes, à nommer l'énoncé qui a demandé le document
(`source: SES-001 tâche 19`). Deux sens sous une même clé se seraient
contredits. Décision prise par l'agent le 2026-09-03, à confirmer.

**Décision — à l'ordre 1, l'éditeur est un humain et ne se déclare pas.**
SPC-001 §1.4 le définit ainsi. Déclarer autre chose n'est pas une variante :
c'est dire que la primitive n'est pas de premier ordre, et la réponse est de
la déplacer à l'ordre 2. `prim set editeur agent` sur une primitive d'ordre 1
est donc refusé, et le message le dit.

## 4. Où les déclarations vivent

**Dans la primitive elle-même.** Le frontmatter d'un markdown, la tête d'un
YAML.

Pas de fichier voisin qui la décrirait. C'est le même choix que pour l'état
d'une fonctionnalité, qui se lit dans le harnais et nulle part ailleurs : un
inventaire parallèle peut mentir, le fichier non.

**Conséquence assumée :** une primitive qui ne peut porter aucune
déclaration — un CSV, une image — n'en porte aucune. `prim ls` rend `—`,
`prim check` le signale sans bloquer, et `prim set` refuse en nommant la
raison. Rien n'est deviné.

## 5. Ce qui se vérifie

`clia <ressource> prim check` porte cinq contrôles, et chacun échoue pour sa
propre raison :

```
P1  chaque nom de fichier porte son identifiant
P2  les identifiants ne se répètent pas dans l'instance
P3  chaque primitive peut porter ses déclarations
P4  les valeurs déclarées sont reconnues, et ne contredisent pas le fichier
P5  chaque primitive dit qui l'écrit
```

P1, P2, P4 sont bloquants. P3 et P5 signalent : ne pas savoir qui a écrit une
primitive d'ordre 2 mérite d'être su, sans que rien soit faux.

P5 est bloquant dans un seul cas : une primitive d'ordre 1 qui déclare un
autre éditeur qu'humain. Elle contredit alors sa propre zone.

## 6. Ce que ce document ne tranche pas

**Ce que le stade généré contient.** Rien ne vérifie que `genere/` ne porte
que des cibles déclarées. Un fichier qu'aucune recette ne produit y survit —
REQ-006 §8.

**Ce qu'une primitive non porteuse déclarerait.** Un fichier voisin —
`<ID>.clia.yaml` — serait le seul recours. Il n'est pas construit, parce
qu'il rouvre exactement ce que §4 ferme : un endroit où la déclaration peut
diverger de ce qu'elle décrit.

**Le lien entre le préfixe d'une primitive et une ressource installée.**
§2 l'annonce, le code ne le vérifie pas. Exiger que `SPC` soit une ressource
installée rendrait toute primitive dépendante d'une extension ; ne rien
exiger laisse le préfixe libre. Le choix appartient à l'humain.

**La provenance d'une primitive externe.** `origine: externe` dit qu'elle
vient d'ailleurs, non d'où. Une deuxième clé serait nécessaire, et l'énoncé
ne la demande pas.

**Les verbes `release config|policy`.** SES-001 tâche 22 les nomme. Ils
tiennent des variables — de configuration, et de politique régulant le
comportement de la livraison — sur le modèle de `clia config ls`. Leur
contenu initial reste à arrêter.
