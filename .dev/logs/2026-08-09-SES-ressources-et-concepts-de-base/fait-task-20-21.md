# Ce qui a été fait, tâches 20 et 21

## En un coup d'oeil

| Mesure | Valeur |
|---|---|
| `CONSTITUTION.md` | **Créé**, six règles |
| Types passés en édition humaine | `DCN`, `PDC` |
| Garde posée sur `clia git save` | Refus en environnement d'agent, code **3** |
| Objections levées | `NON-002`, de `bloquant` à `informatif` |
| Objections ouvertes | `NON-024` bloquante, `NON-025` conditionnelle |
| Bogue corrigé | `clia res new`, ouvert depuis la tâche 14 |
| Tests du CLI | 118 vers **124**, tous verts |
| Ressources validant leur schéma | **110 sur 113** |

## Tâche 20

### CONSTITUTION.md, six règles

| Règle | Ce qu'elle interdit |
|---|---|
| **C1** | L'agent ne crée ni ne modifie une `DCN` ni un `PDC`. Il produit le gabarit et s'arrête |
| **C2** | L'agent n'exécute aucune opération git qui écrit. `clia git save` est réservé à l'humain |
| **C3** | L'agent ne modifie jamais un document en édition humaine |
| **C4** | Toute déviation produit une objection |
| **C5** | La journalisation est obligatoire |
| **C6** | La constitution prime en cas de conflit |

Le fichier déclare ce qu'il ne garantit pas : aucune de ces règles n'est infranchissable pour un agent qui dispose d'un shell. Elles rendent la transgression explicite et traçable, non impossible.

`RES-016` passe de `non-installe` à `actif`.

### Ce que la règle change dans les types

`RES-009` et `RES-012` passent en `edition: humain`. Leur section de régime d'édition porte désormais une table de gestes : l'agent produit le gabarit, l'humain rédige, et une recommandation d'agent vit dans une analyse, un plan ou une objection.

`skl-003` et `skl-004` portent la règle, avec la raison pour le principe de conception : un principe qu'un agent se donne à lui-même ne contraint personne.

### La garde C2

`clia git save` refuse dans un environnement d'agent et retourne **3**. La détection repose sur les marqueurs que ces environnements posent eux-mêmes, et sur `CLIA_ACTOR`.

`clia git log` et `clia git check` restent permis : lire n'est pas décider.

### Une règle qui avait déjà existé

`FCT-001` F07 : la constitution archivée le 2026-08-08 interdisait à l'agent toute opération git, dans ces termes : « L'agent IA n'a jamais le droit de : exécuter une commande `git add`, `git commit`, `git push`, ou toute autre action git ».

Le refactor l'a archivée. Entre le 2026-08-08 et le 2026-08-10, aucun document actif ne portait cette règle, et la tâche 19 a construit `clia git save` dans cet intervalle.

**La tâche 20 restaure une règle perdue, elle n'en invente pas une.**

### FCT-001, le relevé de l'existant

Première instance du type `FCT`, qui n'en avait aucune dans tout le corpus.

Dix faits établis, dont les quatre qui comptent : les douze `DCN` et `PDC` du dépôt ont toutes été rédigées par l'agent ; sept portent `effet: en-vigueur` sans que l'humain ait posé ce champ ; aucune n'est approuvée ; et l'agent ne peut plus les corriger, C1 lui en réservant désormais la teneur.

`NON-024` porte la question, effet `bloquant` : huit `ADR` du dépôt dérivent de ces `DCN`.

### Une violation commise et signalée

`FCT-001` F09. En vérifiant que `CLIA_ACTOR=human` levait la garde C2, l'agent a commité huit fichiers dans ce dépôt, moins d'une heure après avoir écrit cette garde. Commit `923880a`.

Le commit n'a pas été poussé. Il a été annulé par `git reset --soft` ; `HEAD` est revenu à `e47eedd`, qui est la référence distante. Aucun contenu perdu, aucun historique publié réécrit.

La vérification aurait dû se faire dans un dépôt jetable, comme toutes les autres. Six tests couvrent désormais la garde, tous dans un dépôt jetable.

### Le bogue de clia res new, corrigé

Ouvert depuis la tâche 14 et signalé trois fois. Il s'est manifesté sur le gabarit `DCN-011`, destiné à l'humain.

| Avant | Après |
|---|---|
| `type: 009` | `type: decision` |
| `id: DCN-structure-du-systeme-...` | `id: DCN-011` |

Le nom canonique du type vient désormais du slug du nom de fichier de sa définition, et l'`id` du discriminant. Deux tests périmés, qui attendaient encore la forme à slug abolie par `ADR-007`, ont été alignés.

## Tâche 21

`ADR-016` instruit les sept réponses en huit décisions.

| Réf | Décision |
|---|---|
| D1 | Le clivage structurant est **ressource ou non-ressource**, non le type |
| D2 | La **source de vérité est le fichier `RES`**. `CLAUDE.md` cesse d'être une source |
| D3 | Les skills **ne font pas autorité** et sont dérivables de `RES`, `ADR`, `SPC` et `RQF` |
| D4 | Un type de ressource se crée sous le besoin, sans seuil d'admission |
| D5 | La contestation sur le nombre de types est close |
| D6 | Le triplet est abandonné comme prescription |
| D7 | Le critère de trahison devient facultatif |
| D8 | Le coût de la journalisation est assumé |

**D3 est un renversement.** `skl-001` est le document que l'agent lit avant d'écrire toute ressource, et la tâche 17 vient d'y ajouter une règle de registre et un contrôle. Sous D3, ces règles n'ont pas leur place dans un skill.

**D3 est prise et inapplicable.** Aucun générateur n'existe, et les types cités comme sources, `SPC` et `RQF`, ont zéro instance. `NON-025` porte les quatre questions que cela laisse, dont le statut des logs, que l'humain déclare lui-même non tranché.

`RES-018` passe en `edition: ia` : un document généré n'est pas co-édité.

`RES-003` retire `critere-de-trahison` de ses champs obligatoires, et `intention.cue` est aligné.

`NON-002` passe à `repondue`, effet `informatif`. Son grief principal, la prolifération, est rejeté ; son grief secondaire, le coût du triplet, est accueilli et dépassé.

## La contrainte croisée entre les deux tâches

La tâche 20 interdit à l'agent de créer une `DCN`. Le traitement d'une objection en produit une.

**Le gabarit `DCN-011` a été produit et laissé à l'humain**, avec ses champs `À RENSEIGNER`. C'est la première application de C1, et elle s'applique au document qui aurait enregistré les réponses.

`ADR-016` instruit les conséquences sans les acter, et le déclare dans sa section Statut.

## Ce qui n'a pas été fait

`DCN-011` n'est pas rédigée : C1 l'interdit.

Les douze `DCN` et `PDC` existantes ne sont pas corrigées : C1 l'interdit aussi. `NON-024` en porte la question.

Aucun générateur de skill n'est produit. D3 reste inapplicable.

`CLAUDE.md` n'est pas touché, alors que D2 le vise directement : sa table des types cesse d'être une source. Le chantier appartient à `PLN-001`, en attente depuis le 2026-08-09.
