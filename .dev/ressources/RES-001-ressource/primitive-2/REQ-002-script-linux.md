---
type: requis
id: REQ-002
titre: "Un script de ressource, sur Linux"
ordre: 2
source: SES-001 tâche 21
editeur: agent
---

# REQ-002 — Un script de ressource, sur Linux

SPC-001 dit ce qu'une ressource est. Ce document dit comment la deuxième des
trois choses qu'elle apporte — le script — existe sur un système de fichiers
Linux : où il est, ce qu'il déclare, comment le point d'entrée le trouve et
l'exécute, et ce qui se vérifie.

Il est de deuxième ordre : un agent l'a rédigé en lisant le code, et un
humain le relit. Ce qu'il décrit est ce que `_scripts/bin/clia` et
`_scripts/lib/fourniture.sh` tiennent au 2026-09-02.

## 1. Ce qu'est un script

**Un automatisme qu'une ressource apporte au CLI.** Il devient un verbe de la
commande de la ressource — le `CMD` de `clia <ressource> CMD …`.

C'est ce qui fait qu'ajouter une ressource ajoute ce qu'elle sait faire. Le
point d'entrée ne porte aucune liste de commandes : il les trouve.

## 2. Où il vit

```
<zone livrée>/<ressource>/_scripts/<commande>.sh
```

`<commande>` est le préfixe de la ressource en minuscules : la ressource
`session`, de préfixe `SES`, porte `_scripts/ses.sh`, et répond à `clia ses`.

Le point d'entrée fouille trois endroits, dans cet ordre :

```
$CLIA_SOURCE_DIR/_scripts/lib/cmd/*.sh          le noyau
$CLIA_SOURCE_DIR/<zone livrée>/*/_scripts/*.sh  ce que le CLI porte
<dépôt courant>/<zone livrée>/*/_scripts/*.sh   ce que le dépôt porte
```

**Le premier trouvé l'emporte.** Une ressource ajoute donc une commande ;
elle n'en remplace jamais une du noyau, et `version` ne change pas de sens
selon les ressources installées.

Le nom du fichier, sans `.sh`, est le nom de la commande. La fouille prend
tout `*.sh` du répertoire ; seul le fichier nommé d'après le préfixe est lu
par `clia script ls` pour en tirer les verbes.

## 3. Ce qu'il déclare

Quatre déclarations, en commentaires de tête. Elles sont la seule chose que
le point d'entrée lit avant d'exécuter :

```sh
# Description: ce que la commande fait, en une ligne
# Périmètre:   dépôt | aucun
# Signature:   ses open DESCRIPTION        (répétable)
# Option:      ses ls --tout               (répétable)
```

`Description` fait l'entrée de `clia --help`. `Signature` fait l'aide brève :
une commande ne rédige pas son aide, elle déclare ses formes valides, et
l'aide en découle. Une aide écrite à la main aurait pu mentir.

`Périmètre: dépôt` demande un dépôt git ; le point d'entrée le résout et le
passe dans `CLIA_WORK_DIR`. `Périmètre: aucun` s'en passe. **Sans
déclaration, le périmètre vaut « dépôt »** : oublier la ligne restreint, et
n'ouvre jamais.

Un verbe est le deuxième mot d'une signature. Une signature qui n'en porte
pas — `version`, `version --true` — décrit l'appel nu, et n'ajoute aucun
verbe ; un mot commençant par `-` ou `[` est une option ou un argument.

## 4. Comment il est exécuté

```sh
exec bash "$FICHIER" "$@"
```

Trois conséquences, toutes voulues :

* **Le bit d'exécution n'est pas nécessaire.** Le fichier est passé à `bash`,
  non exécuté. Un dépôt cloné sans permissions préservées fonctionne.
* **Le shebang n'est pas suivi.** Un script de ressource est un script bash,
  et rien d'autre. La ligne `#!/usr/bin/env bash` est là pour les éditeurs et
  pour shellcheck.
* **Le processus est remplacé.** Le code de retour du script est celui de
  `clia`, sans intermédiaire qui pourrait le traduire.

L'environnement reçu :

```
CLIA_SOURCE_DIR   le dépôt d'où vient le code exécuté
CLIA_EXECUTABLE   le chemin par lequel clia a été appelé
CLIA_WORK_DIR     le dépôt de travail — périmètre « dépôt » seulement
```

Un script source `$CLIA_SOURCE_DIR/_scripts/lib/commun.sh` pour disposer des
lectures partagées. Il ne les recopie pas : ce qui est commun se tient à un
seul endroit.

## 5. Les verbes que le point d'entrée retient

Huit verbes ne sont déclarés dans aucun fichier de ressource, et valent
pourtant pour toutes :

```
deactivate  provide  check  prim  zone  upgrade  downgrade  migrate
```

Le point d'entrée les intercepte **avant** d'exécuter le script. Une
ressource reprise d'une extension les reçoit donc sans avoir eu à les
écrire — et une ressource qui définirait une signature `ses check` ne serait
pas appelée pour elle.

## 6. La désactivation

Un verbe est actif par défaut. Sa désactivation est déclarée dans la carte du
dépôt :

```yaml
desactives:
  - script: RES/release
```

Le refus vient du point d'entrée, non du script : c'est le même endroit que
la garde de périmètre, et pour la même raison. Une ressource n'a rien à
écrire pour que ses verbes puissent être refusés.

C'est le seul état de fourniture qui soit déclaré. Une fonctionnalité et un
skill se lisent dans le harnais et sous `.claude/` ; un verbe, lui, n'a rien
à inscrire quand il répond, et une carte qui listerait tout ce qui va bien
serait une carte que personne ne relit.

## 7. Les conventions de sortie

**La sortie standard ne porte que ce qu'un autre programme viendrait lire.**
Diagnostics, avertissements et refus vont sur la sortie d'erreur, par
`_clia_msg` et `_clia_detail`. Une commande dont la sortie tient sur une
ligne peut donc être lue par une autre sans être filtrée.

Trois codes de retour :

```
0   la demande est satisfaite, même s'il n'y avait rien à faire
1   refus — la demande est comprise, et clia ne la satisfait pas
2   demande mal formée — l'appelant doit reformuler
```

## 8. Ce qui se vérifie

1. Déposer un fichier `.sh` sous `_scripts/` d'une ressource installée suffit
   à l'exposer dans l'aide et à le rendre invocable.
2. Aucun fichier du noyau n'est modifié pour ajouter une commande.
3. Une commande de ressource ne masque jamais une commande du noyau.
4. L'aide brève ne contient que des signatures déclarées, et toutes.
5. Un verbe désactivé est refusé avec le code 1, et le message nomme la
   carte qui le déclare.
6. Une ressource écrite mais non installée ne répond pas.

`_scripts/tests/test_documentation.sh` et `test_fourniture.sh` les mesurent.

## 9. Ce que ce document ne tranche pas

**Plusieurs scripts sous une même ressource.** La fouille les expose tous
comme commandes, mais `clia script ls` ne lit que celui qui porte le nom du
préfixe. Une ressource qui en déposerait deux aurait une commande visible et
un inventaire incomplet.

**Le langage.** `exec bash` fixe bash. Un script écrit dans un autre langage
n'est pas exécutable par ce chemin, et rien ne le dit à celui qui essaierait.
