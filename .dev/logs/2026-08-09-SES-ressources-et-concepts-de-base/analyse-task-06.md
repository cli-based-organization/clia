# Analyse préalable, tâche 6

## Ce que l'implémentation devait prouver, et non seulement faire

Cinq tâches de documents ont produit vingt-neuf fichiers de méthode et douze objections. La sixième est la première à confronter ce corpus à une machine.

Trois décisions écrites attendaient cette confrontation.

`ADR-001` D3, l'identité par le champ `id` plutôt que par le numéro de séquence, était une déduction tirée d'une mesure faite sur d'autres dépôts. Un CLI qui doit résoudre un identifiant l'éprouve directement.

`ADR-003` D5, la frontière entre ce que l'outil garantit et ce que l'agent interprète, était une règle. `res new` la matérialise : il crée le fichier, pose le frontmatter, attribue le numéro, et s'arrête.

`ADR-003` D7, la source machine-lisible des types dérivée des définitions et non écrite à la main, était une tension déclarée non résolue. L'implémentation la résout en fait : `clia` lit les frontmatter des définitions à chaque appel, sans fichier intermédiaire. La circularité que D7 signalait n'existait que si l'on supposait un fichier dérivé ; la dérivation à la lecture la supprime.

## Le bogue que le code devait éviter

`ANL-001` documente, dans la session archivée du 2026-07-31, un bogue précis de la version antérieure de `clia` : quel que soit le répertoire de lancement, le dépôt de référence était toujours le même.

Le code sépare donc explicitement deux racines. `CLIA_HOME` est résolu depuis l'emplacement réel du fichier exécuté, liens symboliques suivis, et sert à trouver les modules. `CLIA_REPO_ROOT_RESOLVED` est résolu à chaque exécution depuis le répertoire courant, en remontant jusqu'au premier marqueur.

Deux tests portent sur cette séparation, et l'un vérifie explicitement que `CLIA_HOME` n'est pas pris pour le dépôt courant. C'est un test de régression sur un bogue qui n'existe plus dans un code qui n'existait plus : le seul moyen de ne pas le refaire.

## Trois bogues trouvés par les tests, dont un instructif

**SIGPIPE sur un `exit` prématuré.** `clia_type_resolve` filtrait la liste des types avec un `awk` qui sortait au premier résultat. Fermer le tube fait recevoir `SIGPIPE` au producteur, ce que `pipefail` transforme en échec du pipeline entier, code 141. La commande `clia res ls objection` échouait alors que le type existait. Correction : l'`awk` lit toute son entrée et n'imprime qu'à la fin.

**Les archives comptées comme instances actives.** `clia res ls` annonçait dix-sept ADR là où le dépôt en a trois : quatorze vivent sous `.dev/archives/`. Correction : exclusion par défaut, configurable par `CLIA_EXCLUDE_DIRS`, et un test vérifie que l'exclusion se désactive.

**Une valeur de type comportant une espace, scindée au reformatage.** Un fichier archivé porte `type: harnais IA`, et le décompte par `uniq -c` puis reformatage en `awk` produisait deux lignes `harnais`. Correction : le décompte est fait en `awk` sur la ligne entière.

Le premier bogue est le plus instructif des trois, parce qu'il s'est reproduit dans les tests eux-mêmes : deux assertions employaient un `awk` dont le bloc `END { exit 1 }` écrasait le code de sortie du bloc précédent. La même méconnaissance d'`awk` a produit un bogue dans le code et un faux échec dans le test qui devait le trouver.

## Ce que les tests ont révélé du modèle, et non du code

Deux échecs de test n'étaient ni des bogues de code ni des erreurs de test : ils portaient sur le modèle.

**`clia res show 002` est ambigu.** Dans un dépôt à deux types, `CHO-002` et `RES-002` coexistent. Le CLI refuse et nomme les candidats. C'est la démonstration à l'usage du défaut D1 de `ANL-001` : le numéro de séquence n'est pas un identifiant, c'est un rang dans une série, et les séries coexistent. La preuve est consignée dans le journal de `NON-001`, dont la question Q1 cesse d'être théorique.

Cette découverte a aussi produit une distinction que les documents n'avaient pas faite : `<PREFIXE>-<SEQ>` est une **adresse**, utile parce que courte et lisible dans le nom de fichier ; `<PREFIXE>-<SLUG>` est une **identité**. Les nommer pareil est ce qui a produit la confusion, y compris dans la demande de la tâche.

**`clia res ls` compte neuf analyses là où il y en a deux.** `ANL-001` est un répertoire de neuf fichiers, format imposé par la tâche 1, et `RES-001` pose qu'une ressource est un fichier. Le décompte est donc juste au sens du modèle et faux au sens du contenu. Nouvelle objection, `NON-012`.

## Deux réponses de fait apportées à des objections ouvertes

**`NON-011` Q7** demandait ce que `clia` doit faire d'un type inconnu : refuser, signaler, ou tolérer. L'implémentation distingue la lecture de l'écriture. En lecture, `res ls` affiche les types employés sans définition avec la mention `aucune` : taire la dette serait la cacher. En écriture, `res new` refuse, en expliquant qu'une première instance ferait précédent. La réponse est réversible et soumise à arbitrage.

**`NON-001` Q7** demandait qui attribue le numéro de séquence. L'implémentation répond : `clia`, en prenant le maximum existant plus un. Cela ne règle pas les collisions entre deux travaux parallèles, que la question soulevait, mais retire la tâche à l'agent.

## Une friction d'usage corrigée

Le type défini s'appelle `Faits`, au pluriel. `clia res ls fait` échouait donc, et le message d'erreur ne disait pas pourquoi. Le nom exact du champ `title` devenait une devinette.

Correction : tolérance du singulier et du pluriel, comme `kubectl` répond à `pod` et à `pods`. C'est un cas de découvrabilité au sens de `FND-001` section 6, et le coût est de quatre lignes.

## Ce qui a été refusé

Une commande de validation. Les neuf contrôles de `skl-001-ressource` en sont le cahier des charges et `ADR-003` D9 l'annonce, mais la session d'outillage est annoncée et la demande ne la mentionne pas.

Toute écriture de contenu par l'outil.

Toute opération git, y compris le simple signalement d'état que `NON-010` Q6 propose. La question est ouverte, non tranchée.

Un README du CLI. `clia --help`, `clia res --help`, `clia config --help` et `setup.sh help` couvrent l'usage, et `FND-001` section 6 pose que l'aide fait partie de l'outil et non de sa documentation.

## Effet de bord nettoyé

Les essais manuels ont créé un fichier de configuration dans `~/.config/clia/`, qui n'existait pas avant. Il a été supprimé après vérification de son contenu : le poste est revenu à son état initial.

Les tests, eux, redirigent `XDG_CONFIG_HOME` vers un répertoire temporaire et travaillent dans un dépôt temporaire. Aucun test ne touche le dépôt de travail ni la configuration de l'utilisateur, et cette isolation est la condition pour qu'ils soient rejouables.
