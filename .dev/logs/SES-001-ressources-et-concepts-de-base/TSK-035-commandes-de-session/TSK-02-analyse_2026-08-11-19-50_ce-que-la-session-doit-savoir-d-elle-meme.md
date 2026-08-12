# Analyse, tâche 35

`MET-003` étape 2. Sept décisions, dont trois ne vont pas de soi.

## Ce que le dépôt possède déjà

| Élément | État |
|---|---|
| `RES-034`, définition de la session | Existe, et **contredit la demande sur trois points** |
| `session.cue`, `session.template.md` | Existent, alignés sur `RES-034` |
| Instances `SES-*` actives | **Aucune** |
| Répertoires de journal `SES-*` | Un, avec **dix** répertoires de tâches |
| Sessions archivées | Quatre, sous une forme antérieure |

**Les quatre sessions archivées valident la demande.** Leur frontmatter porte `start-at` et `end-at`, et leurs sections sont Intention, Contexte, Tâches, **dans cet ordre**. La demande de l'humain ne change pas le modèle : elle **restaure** l'ordre historique et ajoute `LIVRABLES`.

`RES-034` avait inversé l'ordre sans motif écrit. C'est la définition qui déviait, non la demande.

## D1 - Où vit une session

Une par répertoire, comme `RES-034` le pose déjà.

```
.dev/logs/SES-<SEQ>-<SLUG>/
    SES-<SEQ>.md        <- l'énoncé
    TSK-<SEQ>-<slug>/   <- le journal des tâches
```

**Ce que cela permet et qui manquait.** Le cycle `todo => open => closed` suppose que **plusieurs sessions coexistent**, dont des sessions planifiées. `workspace/session.md` est unique : il ne peut pas les porter. Il faut un fichier par session.

## D2 - Ce que devient workspace/session.md

**Rien, et c'est délibéré.**

`CLAUDE.md` en fait le seul point d'entrée des demandes, et `CONSTITUTION.md` C3 le place en régime d'édition humaine. Le convertir en lien symbolique vers la session ouverte serait la forme aboutie, et c'est **un geste qui appartient à l'humain**.

Le CLI est donc écrit pour fonctionner **dans les deux états** :

| État du dépôt | Ce que `clia ses` considère comme session ouverte |
|---|---|
| Une instance porte `etat: open` | Cette instance |
| Aucune | `workspace/session.md`, le fichier vivant |

**Le second cas est celui du dépôt aujourd'hui.** Sans ce repli, `clia ses status` n'aurait rien à dire des trente-cinq tâches en cours, et la commande serait livrée inutilisable.

`RES-034` autorise ce repli par son propre texte : « Le fichier de session est le point d'entrée **vivant** ».

## D3 - Comment se mesure une tâche faite

C'est la question la plus délicate, parce qu'une tâche ne déclare nulle part qu'elle est finie.

| Critère possible | Pourquoi écarté ou retenu |
|---|---|
| Une marque dans l'énoncé | L'énoncé est en régime humain, et aucune tâche n'en porte |
| Un répertoire de journal existe | **Trop faible** : il est créé à l'étape 1, avant tout travail |
| Le journal porte `TSK-07-commit-message` | **Retenu** |

**Le motif.** `MET-003` fait du message de commit la **septième et dernière** étape. Sa présence atteste que les six autres ont été écrites.

**Ce que le critère ne dit pas.** Qu'une tâche est bien faite. Il dit qu'elle est **journalisée jusqu'au bout**, ce qui est vérifiable, là où « bien faite » ne l'est pas.

## D4 - Le temps depuis l'ouverture

Le champ `ouverture` du frontmatter, quand il existe.

`workspace/session.md` n'en a pas. **Repli : la date de création du fichier dans git**, `--diff-filter=A`. C'est une mesure, non une estimation.

## D5 - Qui peut ouvrir et fermer

`status` et `ls` **lisent** : libres.

`new`, `todo`, `close` **écrivent l'état d'un document de régime humain** : réservés à l'humain, code de retour 3.

**Le précédent est exact.** `CONSTITUTION.md` C2 réserve `clia git save` à l'humain, et la garde existe déjà, éprouvée par six tests. Elle est déplacée de `git.sh` vers `core.sh` pour servir aux deux, l'ancien nom restant valide.

**Ce que la garde protège ici.** `ses new` ferme la session en cours et en ouvre une autre : c'est le geste qui décide de ce sur quoi le dépôt travaille. `ADR-002` en fait un acte de l'humain.

## D6 - Trois écarts entre RES-034 et la demande

| Élément | `RES-034` | Demandé | Retenu |
|---|---|---|---|
| `etat` | `ouverte`, `close`, `abandonnee` | `todo`, `open`, `closed` | **Demandé** |
| Sections | Contexte, Intention, Critère de convergence, Tâches | INTENTION, CONTEXTE, LIVRABLES, TÂCHES | **Demandé** |
| Ordre | Contexte d'abord | Intention d'abord | **Demandé** |

`DCN-013` fait de l'humain l'autorité. `RES-034` a été rédigée par l'agent. La demande prévaut, et la définition est révisée.

**Deux choses sont perdues, et ce n'est pas anodin.**

Le **critère de convergence** disparaît des sections. Il est nommé par `ADR-002`, par `workspace/session.md` qui en porte un, et `RES-034` en fait ce qui permet de clore. La demande ne dit pas de le supprimer : elle ne le mentionne pas. Objection.

L'état `abandonnee` disparaît. Une session abandonnée devient `closed`, indistinguable d'une session aboutie. Objection.

**Et une chose est gagnée.** `LIVRABLES` : la session déclare ce qu'elle produit. C'est ce que `PDC-003` V-S1 exige d'un plan, appliqué à la session.

## D7 - Ce que le CLI ne fera pas

**Il ne créera pas `SES-001.md` pour la session en cours.** L'énoncé serait la reprise de `workspace/session.md`, document de régime humain, et l'ouverture d'une session appartient à l'humain par D5. Le geste est proposé, non exécuté.

**Il n'ajoute aucun verbe non demandé.** Pas de `show`, pas de `edit`. La demande nomme six formes ; le module en implémente six.

## Le mélange de langues

`todo`, `open`, `closed` sont anglais dans un frontmatter français, dont le champ s'appelle `etat`. C'est le défaut que `DCN-016` porte déjà pour `maturity`, `adoption` et `activated`, et que `ISU-009` garde ouvert. **Constaté, non corrigé** : la demande est explicite.

## Livrables

| Livrable | Nature |
|---|---|
| `lib/clia/session.sh` | Création |
| `bin/clia`, dispatch et aide | Modification |
| `lib/clia/core.sh`, garde partagée | Modification |
| `RES-034` | Révision |
| `session.cue`, `session.input.cue`, `session.template.md` | Révision |
| `tests/test_clia.sh` | Extension |
| `NON-037` | Création |

## Précaution

**Les gestes d'écriture sont éprouvés dans un dépôt jetable.** Le 2026-08-10, éprouver la garde de `clia git save` sur le dépôt réel a produit un commit non voulu. La leçon est consignée en `FCT-001` F09, et elle s'applique ici mot pour mot : `ses new` et `ses close` écrivent.
