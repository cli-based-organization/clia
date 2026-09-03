---
type: requis
id: REQ-004
titre: "La conformité d'une ressource, sur Linux"
ordre: 2
source: SES-001 tâche 21
editeur: agent
---

# REQ-004 — La conformité d'une ressource, sur Linux

SPC-001 dit ce qu'une ressource est, et pose sept invariants. Ce document dit
comment ils se mesurent sur un système de fichiers Linux : ce que
`clia <ressource> check` regarde, où il le regarde, ce qu'il conclut, et ce
qu'il ne peut pas voir.

Il est de deuxième ordre : un agent l'a rédigé en lisant le code, et un
humain le relit. Ce qu'il décrit est ce que `_scripts/lib/conformite.sh`
tient au 2026-09-02, et ce que SES-001 tâche 20 demande.

## 1. Ce qu'est la conformité

**Une ressource est conforme quand elle est ce qu'elle prétend être.**

Ce n'est pas une mesure de qualité : un livrable médiocre peut être conforme.
C'est une mesure d'accord entre ce que la ressource déclare et ce que le
système de fichiers porte.

Le verbe est générique — le point d'entrée le tient pour toutes les
ressources, y compris celles qu'une extension apporte. Voir REQ-002 §5.

## 2. Ce qui est jugé

Une ressource peut être **écrite** par le dépôt, **installée** dans le dépôt,
ou les deux — SPC-001 §1.3 et §1.9.

`check` juge ce que le dépôt écrit quand il écrit la ressource, et la copie
installée sinon. C'est la même règle que pour la version : on juge ce qu'on
écrit, à défaut ce qu'on emploie.

L'en-tête le dit, avant tout verdict :

```
ressource  ressource
définition .dev/ressources/RES-001-ressource/livrables/ressource.yaml
état       écrite ici, sous .dev/ressources/RES-001-ressource
version    0.1.0
```

Une ressource sans définition est **refusée** avant tout contrôle, code 1 :
un répertoire qui ne porte pas sa définition n'est pas une ressource, et
n'a donc pas de conformité à mesurer.

## 3. Les cinq contrôles

### C1 — les zones sont respectées

Une instance porte un répertoire par stade — `primitive-1/`, `primitive-2/`,
`genere/`, `livrables/` — plus un `generation.yaml` quand il y a quelque
chose à construire. Toute autre entrée du répertoire est un écart bloquant,
nommée.

Les fichiers cachés ne sont pas contrôlés : `.empreintes.yaml`, que clia
écrit à chaque construction, y échappe donc — REQ-006 §4.1.

`livrables/` n'est pas exigé ici : un répertoire qui n'en porte pas n'est pas
reconnu comme une instance — `_clia_instances_de` l'omet — et il n'y a alors
rien à juger comme instance.

Une copie installée ne porte pas les zones de primitives : elles restent chez
qui les écrit, et ne voyagent pas. Une `primitive-1/` sous la zone livrée est
donc bloquante.

### C2 — les données structurées ont la forme voulue

La définition déclare `nom`, `titre`, `prefixe`, `version` et `description`.
Un champ manquant est bloquant, et le message le nomme.

Trois formes sont exigées :

```
nom       celui du fichier — <nom>.yaml
prefixe   ^[A-Z]{2,5}$
version   X.Y.Z
```

Pour une instance, l'identifiant du répertoire suit
`^[A-Z]{2,5}-[0-9]{3,}-[a-z0-9][a-z0-9-]*$`, et son slug est le nom de la
ressource. `RES-001-autre-chose` pour la ressource `ressource` est bloquant.

### C3 — les primitives de la livraison sont là

La définition peut déclarer ce dont sa livraison a besoin :

```yaml
primitives:
  - fichier: primitive-1/SPC-001-ontologie.md
```

Chaque fichier déclaré doit exister dans l'instance. Un absent est bloquant.

**Sans déclaration, C3 signale** — il ne rend pas « ok ». La reproductibilité
ne se vérifie pas toute seule : clia ne devine pas quelles entrées un livrable
demande, et le dire vaut mieux qu'un verdict qui ne mesurerait rien.

Une ressource seulement installée n'a rien à livrer ici, et C3 le constate
sans rien exiger.

### C4 — les scripts de migration sont là

Chaque saut entre deux versions successives de l'historique doit porter son
script :

```
<livrable>/migrations/<de>-<vers>.sh
```

Les versions sont lues dans l'historique git de la définition, par
`git log --follow --reverse` sur son chemin : une version est déclarée au
commit qui l'a introduite. `--follow` est nécessaire — la disposition des
ressources a changé, et sans lui l'historique s'arrêterait au déplacement.

Un saut montant sans script est **bloquant** : `clia <ressource> upgrade
--migrate` le refuserait. Un saut sans script de retour est **signalé** :
seule la descente en pâtit, et elle est plus rare.

### C5 — la version en place est la dernière disponible

La version de la définition est comparée à la dernière que l'historique de
son dépôt d'origine déclare. Pour une ressource installée, ce dépôt est
l'extension d'où elle vient, retrouvée par la carte et les sources.

Retarder est un **signalement** par défaut : une version figée est un choix,
non une faute — SPC-001 §1.9.

`CLIA_POLICY_ROLLING_RESSOURCE=true` en fait un écart **bloquant**, pour un
dépôt qui veut suivre au plus près. La politique est déclarée par
`_clia_politiques_noyau` et lue par `_clia_politique` : sa valeur par défaut
n'est écrite qu'une fois, et `clia config ls` la rend.

## 4. Ce que le rapport dit

Une ligne par contrôle, trois marques :

```
C1  ok  les zones sont respectées
C3  --  la livraison ne déclare pas ses primitives
C4  !!  saut(s) sans script de migration : 0.1.0-0.2.0
```

* `ok` — rien à faire.
* `--` — un signalement : quelque chose mériterait d'être fait, sans que
  rien soit faux.
* `!!` — un écart bloquant : la ressource n'est pas ce qu'elle prétend être.

Les codes de retour :

```
0   conforme, avec ou sans signalements
1   au moins un écart bloquant, ou aucune définition à lire
2   demande mal formée — check n'accepte que --explain
```

Un signalement ne fait pas échouer. C'est ce qui rend la commande lançable
souvent, et une commande qu'on lance souvent est une commande qui sert.

## 5. `--explain`

Sous chaque verdict, ce que le contrôle vérifie et pourquoi. Le compte rendu
ordinaire dit ce qui **est** ; `--explain` dit ce qui **serait vérifié**, et
les deux ne se mélangent pas.

Sans l'option, le rapport renvoie vers elle en dernière ligne. Avec, il ne le
fait plus : on y est déjà.

## 6. Ce que check ne fait pas

**Il n'écrit rien.** Constater n'est pas réparer. Un constat qui écrirait
serait un constat auquel on n'oserait pas se fier, donc un constat qu'on ne
lancerait pas.

Le banc le mesure : l'état de travail du dépôt réel est comparé avant et
après.

## 7. Ce qui se vérifie

1. Chaque contrôle échoue pour sa propre raison — un banc qui ne vérifierait
   que le cas conforme ne dirait pas si les contrôles regardent quelque
   chose.
2. Un écart bloquant rend 1 ; un signalement rend 0.
3. `CLIA_POLICY_ROLLING_RESSOURCE` change le verdict de C5, et de lui seul.
4. Le verbe répond pour toute ressource, y compris une reprise d'extension.
5. Rien n'est écrit.

`_scripts/tests/test_conformite.sh` les mesure — 71 cas.

## 8. Ce que ce document ne tranche pas

**Ce qui est conforme pour un livrable qui n'est pas une ressource.** C1 juge
les zones d'une instance ; il ne dit rien de ce qu'une instance de session ou
d'analyse doit porter sous `livrables/`. SPC-001 §5 laisse la même question
ouverte.

**La conformité d'un dépôt entier.** `clia check` juge le dépôt — son état et
ses harnais — et `clia <ressource> check` juge une ressource. Rien ne parcourt
toutes les ressources d'un dépôt en une fois.
