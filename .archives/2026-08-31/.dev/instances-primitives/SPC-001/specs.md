
Le répertoire `@_ressources/` contient des répertoires de primitives de ressources et des répertoires de catégories qui, lui, contient des répertoires de ressources.

La ressource est l'entité première du système clia. Tout autre concept doit se rattacher à une ressource.

Aussi, les répertoires de ressource contiennent les primitives nécessaire à la régération des concepts suivants:

- [_]principes: Principes de conception associés à cette ressource
- [_]ontology: concepts et relations spécifiques à cette ressource
- [_]specs: spécifications de cette ressource
- [_]reqs: requis d'implémentation de cette ressource 
- [_]scripts: scripts d'instrumentation de cette ressource
- [_]skills: skills opérants sur cette ressource
- [_]features: fonctionnalités fournis pour/par cette ressource
- [_]methodes: méthodologies permettant d'opérer sur cette ressource

Le caractère underscore indique qu'il s'agit d'un répertoire de templates d'instrumentation.
C'est à dire que l'on met les primitives dans un répertoire et les templates associés dans un répertoire du même nom préfixé de "_"

# SPC-001 — Structure d'un répertoire de ressource

## Objet

Cette spécification fixe ce que contient `_ressources/`, et ce que contient le
répertoire d'une ressource. Elle complète `REQ-002`, qui pose les conventions
générales de répertoires, et elle est mise en oeuvre par `REQ-003`.

Elle ne dit pas ce qu'est une ressource — c'est
`_ressources/ressource/schemas/ressource.yaml` qui le déclare, et lui seul.

## S1 — La ressource est l'entité première

Tout concept du système clia se rattache à une ressource. Un principe, une
spécification, un skill, une fonctionnalité n'existent pas en flottement :
ils sont *de* quelque chose.

**Conséquence directe :** un concept qui ne se rattache à aucune ressource
signale soit qu'il manque une ressource, soit que le concept n'en est pas un.
Les deux méritent d'être dits plutôt que rangés au hasard.

## S2 — Deux natures de répertoire sous `_ressources/`

`_ressources/` contient deux natures de répertoire, et rien d'autre.

| Nature | Ce que c'est | Comment on la reconnaît |
|---|---|---|
| **Ressource** | Le répertoire d'une ressource | Il porte `schemas/<nom>.yaml` |
| **Catégorie** | Un regroupement de ressources | Il ne porte pas de définition, et ses enfants sont des ressources |

Une catégorie qualifie le nom d'une ressource sans en changer la nature.
`_ressources/<CAT>/<RES>/` et `_ressources/<RES>/` désignent des ressources de
même rang ; seul leur nom qualifié diffère.

**Une catégorie n'est pas un namespace.** `USE-003` réserve ce mot à autre
chose : le namespace est celui du **dépôt**, dérivé de son publisher et de son
nom, et déclaré une seule fois dans `.dev/clia.yaml`. Toutes les ressources
d'un dépôt partagent donc son namespace, quelle que soit leur catégorie. La
première version de cette spécification confondait les deux ; `USE-003` a
tranché.

**La profondeur s'arrête là.** Une catégorie contient des ressources, jamais
d'autres catégories. Deux niveaux suffisent à ranger, un troisième ne ferait
que déplacer la question de savoir où chercher.

## S3 — Ce que porte le répertoire d'une ressource

Trois répertoires décrivent **la ressource elle-même**. Ils viennent de
`REQ-002` et ne changent pas.

| Répertoire | Ce qu'il porte |
|---|---|
| `schemas/` | La définition du type, `<nom>.yaml`. Une seule, et c'est elle qui fait de ce répertoire une ressource |
| `templates/` | Le gabarit d'une instance de la ressource |
| `primitives/` | Les fichiers primitifs de la ressource, quand ils ne relèvent d'aucun concept ci-dessous |

Huit paires portent les **concepts rattachés** à la ressource. Chaque paire
suit la même règle : le répertoire nu porte les primitives, le répertoire
préfixé d'un `_` porte les templates d'instrumentation correspondants.

| Concept | Primitives | Templates | Ce qui s'y range |
|---|---|---|---|
| Principes | `principes/` | `_principes/` | Les principes de conception qui gouvernent cette ressource |
| Ontologie | `ontology/` | `_ontology/` | Les concepts et relations propres à cette ressource |
| Spécifications | `specs/` | `_specs/` | Ce que cette ressource doit être et faire |
| Requis | `reqs/` | `_reqs/` | Ce que son implémentation doit satisfaire |
| Scripts | `scripts/` | `_scripts/` | Les scripts qui l'instrumentent, dont ses commandes |
| Skills | `skills/` | `_skills/` | Les procédures exécutables qui opèrent sur elle |
| Fonctionnalités | `features/` | `_features/` | Ce qu'elle fournit à un dépôt instrumenté |
| Méthodes | `methodes/` | `_methodes/` | Les méthodologies pour opérer sur elle |

## S4 — La règle de l'underscore

Le préfixe `_` marque un **répertoire de templates d'instrumentation**.

```
<concept>/     ce qui est vrai dans le dépôt source : les primitives
_<concept>/    ce qui sera posé dans un dépôt cible : les templates
```

La règle vaut aussi au niveau de la racine du dépôt, où `_ressources/` et
`_scripts/` sont des zones d'instrumentation. Elle est donc une, et non deux
conventions qui se ressembleraient.

**Un template n'a pas d'existence propre.** Il est le pendant d'une primitive
et porte son nom. `features/session.md` a pour template
`_features/session.template.md` : le premier dit ce que la fonctionnalité
est, le second ce qu'elle pose dans le dépôt qui l'active.

## S5 — Aucun répertoire vide

Un répertoire n'existe que s'il porte quelque chose. Les onze emplacements de
S3 sont **admis**, non **exigés** : une ressource qui n'a ni méthode ni
ontologie ne porte pas les répertoires correspondants.

Motif : une arborescence qui montre seize répertoires vides oblige le lecteur
à les ouvrir un par un pour découvrir qu'il n'y a rien. Ce qui existe se voit,
ce qui est possible se lit ici.

## S6 — Les catalogues sont distribués

Un concept rattaché vit sous la ressource à laquelle il se rattache, jamais
dans un catalogue central. Le CLI qui liste les fonctionnalités disponibles
balaie `_ressources/*/features/` et `_ressources/*/*/features/` ; il n'a pas
de répertoire unique où regarder.

**Ce que cela coûte :** deux motifs de recherche au lieu d'un.

**Ce que cela évite :** un catalogue central qui ne dit pas de quoi chaque
entrée relève, et qu'il faut maintenir en plus des ressources.

## S7 — Ce qui n'est pas une ressource

Un concept rattaché n'est pas une ressource, même quand le CLI lui consacre
une commande. `clia feature` opère sur les fonctionnalités de toutes les
ressources : c'est une commande du CLI, et son script vit dans
`_scripts/lib/cmd/`, non sous `_ressources/`.

Le test est celui de S1, pris à l'envers : si l'objet n'existe que *de*
quelque chose, il est un concept rattaché. Une fonctionnalité est toujours la
fonctionnalité de quelque chose ; une intention se tient seule.

## Relations

- `derive-de` `REQ-002` — conventions d'usage des répertoires
- `specifie` `REQ-003` — structure d'un répertoire de ressource
- `reference` `USE-003` — créer une nouvelle ressource, d'où vient le namespace