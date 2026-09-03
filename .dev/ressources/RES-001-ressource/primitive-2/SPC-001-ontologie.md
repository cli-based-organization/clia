---
type: specification
id: SPC-001
titre: "Ontologie de la ressource"
ordre: 2
source: SES-001 tâche 19
editeur: agent
---

# SPC-001 — Ontologie de la ressource

Ce document nomme ce qu'est une ressource dans clia, ce qui la compose, où
chaque chose vit, et qui a le droit d'y toucher. Il est dérivé de SES-001
tâche 19, et il est de deuxième ordre : un agent l'a rédigé à partir de
l'énoncé d'un humain, et un humain le relit.

Ce qu'il fixe est ce que le code doit tenir. Là où l'énoncé laissait un
choix, la décision prise est notée et attribuée.

## 1. Les entités

### 1.1 Ressource

**Un ensemble d'informations manipulables et utiles pour réaliser une
intention.**

C'est la définition conceptuelle, et elle ne parle ni de fichiers ni de
répertoires. Une ressource existe parce qu'une intention lui donne un usage,
non parce qu'un répertoire porte son nom.

### 1.2 Ressource clia

**Une ressource compatible avec le système clia, pour une version donnée.**

La compatibilité est datée : une ressource n'est pas compatible avec clia,
elle l'est avec une version de clia. C'est ce qui rend une mise à jour
nécessaire plutôt que gratuite.

Une ressource clia a un nom, un préfixe, et sa propre version.

### 1.3 Instance de ressource

**Ce qu'un dépôt écrit d'une ressource.** Une instance est un répertoire :

    $CLIA_ZONE_RESSOURCE/<PREFIXE>-<SEQ>-<SLUG>/

Le préfixe est celui de la ressource dont elle est une instance ; la séquence
la numérote dans le dépôt ; le slug la nomme pour un lecteur.

Une instance porte un répertoire par stade, et rien d'autre n'y a sa place :

    primitive-1/   ce à partir de quoi elle est produite, côté humain
    primitive-2/   ce à partir de quoi elle est produite, côté mixte
    genere/        ce qui en est construit
    livrables/     ce qui en est produit

Plus un `Makefile`, quand il y a quelque chose à construire : il porte les
règles qui font `genere/` à partir des primitives — SPC-002 §1.2.

**Décision.** Les livrables vivent dans l'instance, à côté des primitives.
L'énoncé de SES-001 tâche 19 s'interrompait sur ce point ; l'humain a tranché
le 2026-09-02. La conséquence est que tout ce qui concerne une instance est
sous elle, et qu'un livrable reproductible se vérifie sur place.

### 1.4 Primitive de premier ordre

**Un fichier d'entrée que seul un humain peut écrire.**

Ni un agent, ni un automatisme, ni une source externe. C'est le point où le
système s'arrête de dériver et où quelqu'un décide.

Une primitive de premier ordre n'est jamais régénérée. La régénérer serait
remplacer une décision par un calcul.

### 1.5 Primitive de deuxième ordre

**Une primitive mixte**, qui peut être :

* générée par un agent IA,
* générée par un automatisme,
* provenir d'une source externe,
* modifiée par un humain,

ou plusieurs de ces choses à la fois. Le présent document en est une.

Ce qui la distingue du premier ordre n'est pas sa qualité : c'est que sa
provenance est plurielle, et qu'elle peut donc être refaite. Ce qui est de
premier ordre ne peut pas l'être.

### 1.6 Ressource primitive

**Une ressource peut être primitive d'une autre ressource.** Elle est alors
nécessairement d'ordre 2 : elle est produite ailleurs, donc elle n'est pas ce
que quelqu'un a écrit à la main dans l'instance qui l'emploie.

C'est ce qui permet à une chaîne de ressources de se tenir : une ontologie
nourrit une spécification, qui nourrit une implémentation, et chaque maillon
est reproductible parce que ses entrées sont là.

### 1.7 Livrable

**Un objet utilisable en soi.**

Un livrable peut être produit manuellement, par un automatisme, ou par un
agent IA. Ce qui en fait un livrable n'est pas sa provenance : c'est qu'on
puisse s'en servir sans rien reconstituer.

Le critère de reproductibilité s'applique ici : un livrable reproductible est
un livrable dont toutes les entrées sont dans le dépôt — ses primitives, dans
la même instance.

### 1.7 bis — Les deux sens de « primitive »

Le mot sert à deux niveaux, et les confondre égare.

**Les primitives d'une instance** sont ce à partir de quoi son livrable est
produit : `primitive-1/` et `primitive-2/`. Elles restent chez qui les écrit,
et ne voyagent pas.

**Les primitives d'un livrable** sont ce à partir de quoi ce livrable produit
ce qu'il produit ailleurs. La ressource harness-ia en porte : les fichiers de
harnais qu'un dépôt reçoit à son initialisation. Elles voyagent avec la
ressource, sans quoi un dépôt qui l'installe n'aurait rien à poser.

Ce qui les distingue est le niveau, non la nature. Une primitive d'instance
nourrit l'instance ; une primitive de livrable nourrit ce que le livrable
fait pour un tiers.

**Conséquence pour la reprise.** « clia extension install » copie le livrable
entier, sans filtre. Ce qui ne doit pas voyager est hors du livrable par
construction — SES-001 tâche 14 exigeait un filtre parce que les deux étaient
mêlés ; la structure le tient désormais.

### 1.8 Ressource livrée

**Le livrable d'une instance de ressource clia** : la ressource elle-même,
prête à être installée ailleurs. Elle porte sa définition, ses scripts, ses
fonctionnalités, ses skills et ses gabarits.

**Décision.** Une instance de ressource produit une ressource livrée, et une
seule. `livrables/` porte donc son contenu directement, sans niveau
intermédiaire : le nom de la ressource est déclaré dans sa définition, et le
répéter dans un chemin en ferait deux endroits à tenir d'accord.

### 1.9 Ressource installée

**Une ressource livrée, déposée dans un dépôt pour y être utilisée.**

    $CLIA_ZONE_RESSOURCE_LIVREE/<nom>/

Elle est utilisable : ses fonctionnalités, ses skills et ses scripts
répondent. **Seules les ressources installées sont accessibles par le CLI** —
une ressource qu'un dépôt écrit sans l'avoir installée ne répond pas.

Sa version est **figée**. Une ressource installée ne suit pas ce qui bouge
ailleurs : elle est ce qu'elle était au moment de son installation, et seule
une mise à jour explicite la déplace.

Une ressource installée peut être versionnée avec le dépôt ou non, selon
l'emplacement que `CLIA_ZONE_RESSOURCE_LIVREE` désigne.

## 2. Les zones

| Zone | Variable | Défaut | Ce qu'elle porte |
|---|---|---|---|
| Instances | `CLIA_ZONE_RESSOURCE` | `.dev/ressources` | ce que le dépôt écrit |
| Livrées | `CLIA_ZONE_RESSOURCE_LIVREE` | `.clia/ressources` | ce que le dépôt a installé |

Deux zones, et la séparation n'est pas un rangement : elle sépare **ce qu'on
écrit** de **ce qu'on emploie**.

Ce qu'on écrit change, se discute, se reprend. Ce qu'on emploie est figé, et
sa version est un fait. Les confondre revenait à ce qu'une ressource change
sous les pieds de ce qui s'en sert.

C'est aussi ce qui rend l'installation un geste : passer d'une zone à l'autre
demande une commande, et cette commande est traçable.

**Depuis SES-001 tâche 21, une zone est une notion, non une paire de
constantes.** Une zone est un endroit où vit ce qu'une ressource écrit, et
c'est la ressource qui la déclare, dans sa définition. Le noyau n'en tient
plus la liste : il lit ce que les ressources installées déclarent, et
`clia config ls` rend l'état réel.

Les deux zones ci-dessus restent, et l'une d'elles fait exception : pour lire
la déclaration d'une ressource, il faut d'abord la trouver, et pour la
trouver il faut connaître la zone livrée. Elle appartient donc au noyau.
REQ-005-zone-linux le détaille.

## 3. Qui a le droit de quoi

### 3.1 Sur les ressources installées

**Seules ces commandes du CLI y touchent :**

    upgrade   downgrade   activate   deactivate   install   uninstall

Rien d'autre n'écrit dans la zone livrée. Un fichier qui y apparaît autrement
est un écart, non une variante.

**Restriction — les agents IA ne touchent pas aux ressources installées.**
Ni pour les corriger, ni pour les adapter, ni pour les déplacer. Une
ressource installée qui ne convient pas se corrige dans son instance, puis se
réinstalle.

**Autorisation — les agents IA ont le droit d'employer les commandes que les
ressources fournissent.** Ce qui est interdit est de toucher au contenu de la
zone, non de s'en servir.

Cette restriction n'est pas mécanique. Un agent qui dispose d'un terminal
peut l'enfreindre ; CONSTITUTION.md le déclare déjà pour ses propres règles.
Sa portée est de rendre la transgression explicite et traçable.

### 3.2 Sur les primitives

Une primitive de premier ordre est écrite par un humain, et par lui seul. Un
agent qui en aurait besoin d'une qui manque la demande — il ne la comble pas.

Une primitive de deuxième ordre est ouverte aux quatre provenances. Un agent
peut donc la produire, et un humain la corriger.

## 4. Les invariants

Ce que le code doit tenir, et que le banc doit mesurer :

1. Une instance vit sous `$CLIA_ZONE_RESSOURCE/<PREFIXE>-<SEQ>-<SLUG>/`.
2. Une instance porte `primitive-1/`, `primitive-2/` et `livrables/`, et
   `primitive-2/` n'est posé qu'au besoin.
3. Une ressource installée vit sous `$CLIA_ZONE_RESSOURCE_LIVREE/<nom>/`.
4. Le CLI ne trouve ses ressources que dans la zone livrée.
5. La version d'une ressource installée ne bouge pas sans une des six
   commandes nommées.
6. Un livrable est reproductible : toutes ses entrées sont dans son instance.
7. Une ressource primitive d'une autre est d'ordre 2.

## 5. Ce que ce document ne tranche pas

**La séquence d'une instance.** `<PREFIXE>-<SEQ>` numérote les instances dans
un dépôt. Rien ne dit encore si la séquence est propre au préfixe — RES-001
et SES-001 coexistant — ou globale au dépôt. Les générations précédentes la
tenaient par préfixe, et c'est ce que le code suppose ici.

**Le nom des livrables autres que la ressource elle-même.** Une instance
d'une autre ressource que RES — une session, une analyse — produit un
livrable qui n'est pas une ressource clia. Ce document ne dit pas comment il
se nomme dans `livrables/`.

**La migration des dépôts existants.** Ce qui suivait la disposition
précédente doit être déplacé. Le geste est décrit dans SES-001 tâche 19 ; sa
mécanisation n'est pas spécifiée ici, et le déplacement du 2026-09-02 a été
fait à la main.

**Qui l'emporte entre deux zones livrées.** Le CLI lit celle du dépôt source
puis celle du dépôt de travail, et le premier trouvé l'emporte. Un dépôt qui
installe une ressource que le CLI porte déjà se la voit donc masquer. La
règle vient de SES-001 tâche 12, où seules les ressources du CLI étaient en
jeu ; les deux zones la rendent visible, et elle mérite d'être rejugée.

**La restriction sur les agents.** §3.1 la déclare. La porter dans
CONSTITUTION.md est une décision de permission, et CONSTITUTION.md réserve
l'écriture des permissions à l'humain. La formulation proposée :

> | Toucher une ressource installée | **décide** | exécute sur demande | ne
> touche pas |

**Le double exemplaire dans un dépôt qui publie.** Un dépôt qui écrit une
ressource et s'en sert la porte deux fois : dans son instance, et dans sa
zone livrée. C'est la conséquence directe de « seules les ressources livrées
sont accessibles par le CLI », et cela veut dire qu'éditer une ressource
qu'on développe demande de la réinstaller pour l'employer. Rien ne mécanise
encore ce va-et-vient.
