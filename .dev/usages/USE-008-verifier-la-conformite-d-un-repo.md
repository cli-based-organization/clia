# Vérifier la conformité d'un repo clia

Un repo clia déclare ce qu'il est et ce qui y est installé dans `.dev/clia.yaml`.

```yaml
namespace: noumanity.com/clia
version: 0.1.1
maturity: unstable
generation: 3

installe:
  - type: harness
    namespace: noumanity.com/clia
    nom: harness-ia
    version: 0.1.0
  - type: extension
    namespace: acme.com/outils
    nom: outils
    version: 0.2.0
    uri: git@github.com:acme/outils.git
  - type: ressource
    namespace: noumanity.com/clia
    nom: intention
    version: 0.1.0
```

Un dépôt dérive de cette déclaration sans que personne s'en aperçoive : le
harnais vieillit pendant que clia avance, une extension est déclarée sur une
machine et absente sur une autre, une ressource est supprimée à la main.

```sh
# vérifie le repo courant
clia check

# vérifie un autre repo
clia check PATH

# répare ce qui est réparable, puis vérifie de nouveau
clia check --fix
```

**pré-condition** : `PATH` est un dépôt git, ou le répertoire courant l'est.

**post-condition** : sans `--fix`, rien n'est modifié — la commande constate.
Avec `--fix`, les écarts réparables le sont, et le rapport rendu est celui
d'après réparation.

## Ce qui est vérifié

| Contrôle | Ce qu'il dit |
|---|---|
| C1 | le dépôt porte `.dev/clia.yaml`, avec namespace, version, maturité et génération |
| C2 | le harnais installé est de la même version que celui qu'offre clia |
| C3 | chaque extension déclarée est clonée sur cette machine |
| C4 | chaque chose inventoriée existe encore sur le disque |
| C5 | chaque ressource du disque est inventoriée |
| C6 | aucune déclaration ne subsiste dans un emplacement abandonné |

## Ce que `--fix` répare

Le constat compte les écarts réparables et nomme la commande qui les
solderait ; `--fix` l'exécute. Un écart est réparable quand sa réparation ne
décide rien à la place de l'humain.

| Contrôle | Le geste |
|---|---|
| C1 | `.dev/clia.yaml` est posé, ou complété, avec des valeurs à compléter |
| C2 | un harnais absent est posé, et inscrit à l'inventaire |
| C3 | le clone manquant d'une extension déclarée est rétabli depuis son URI |
| C4 | une entrée inventoriée dont l'objet a disparu est retirée |
| C5 | une ressource du disque est inscrite, provenance supposée locale |
| C6 | `.dev/extensions.yaml` est fondu dans l'inventaire, puis retiré |

## Ce que `--fix` ne répare pas

Deux écarts restent à l'humain, parce que les réparer serait décider pour lui.

**Le namespace du dépôt.** Il dérive du couple `(publisher|user)/repo_name`,
et il désigne la provenance de tout ce que le dépôt produit. `--fix` pose
`<publisher>/<nom du dépôt>`, une invite visible, et montre ce que le remote
git suggère — il ne l'écrit pas. Un namespace deviné faux serait invisible.

**Un harnais en retard d'une version.** Sa version ne se lit pas sur le
fichier : seule sa régénération l'établit, et `clia harness-ia init --force`
réécrit un corps qui appartient au dépôt. `--fix` le dit, et s'arrête là.

De même, une extension déclarée sans URI n'est pas reclonable : rien ne dit
d'où. L'écart demeure, et le rapport le nomme.

Un geste qui échoue — un clone hors réseau, un fichier non inscriptible — est
rapporté comme un échec, jamais compté comme réparé : un dépôt qui paraîtrait
sain sans l'être serait pire que l'écart lui-même.

Les gestes de `--fix` modifient des fichiers versionnés. `git diff` les
montre, `git checkout` les défait : c'est là le filet, et c'est pourquoi la
commande ne demande pas de confirmation.

## Codes de retour

```
0  conforme, ou seulement des avertissements
1  au moins un écart bloquant
2  demande mal formée
```

Un écart **bloquant** empêche clia de travailler correctement sur le dépôt :
configuration absente, extension déclarée introuvable. Un **avertissement**
signale une dérive qui n'empêche rien aujourd'hui : harnais en retard d'une
version, ressource non inventoriée.

## Le cas qui a motivé cet usage

`~/git/clia-experiments-repo/offre-service-cscn` a été instrumenté par une
version de clia antérieure à `.dev/clia.yaml`. Il porte ses extensions dans
`.dev/extensions.yaml`, un emplacement que clia ne pose plus.

Rien ne l'avait signalé. `clia check` doit le dire, et dire quoi faire.
`clia check --fix` le fait : les extensions de `.dev/extensions.yaml` sont
fondues dans l'inventaire, le fichier est retiré, et ce qui reste — le
namespace, la version du harnais — est laissé à l'humain avec la commande
qui le solde.
