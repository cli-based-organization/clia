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
```

**pré-condition** : `PATH` est un dépôt git, ou le répertoire courant l'est.

**post-condition** : rien n'est modifié. La commande ne répare pas, elle
constate.

## Ce qui est vérifié

| Contrôle | Ce qu'il dit |
|---|---|
| C1 | le dépôt porte `.dev/clia.yaml`, avec namespace, version, maturité et génération |
| C2 | le harnais installé est de la même version que celui qu'offre clia |
| C3 | chaque extension déclarée est clonée sur cette machine |
| C4 | chaque chose inventoriée existe encore sur le disque |
| C5 | chaque ressource du disque est inventoriée |
| C6 | aucune déclaration ne subsiste dans un emplacement abandonné |

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
