# Analyse avant réalisation, tâche 25

## Le numéro de type de log, et son ordre

C5 fixe que `SEQ` est le numéro du type de log, identique pour toutes les tâches, et qu'il estime l'ordre de génération.

Les sept types employés depuis le 2026-08-09, dans l'ordre où ils sont produits.

| SEQ | Type | Quand il s'écrit |
|---|---|---|
| 01 | `demande` | Avant tout travail, à la lecture de la tâche |
| 02 | `analyse` | Avant de produire, après avoir établi le contexte |
| 03 | `fait` | Pendant, à mesure que chaque livrable est produit |
| 04 | `validation` | Avant de valider, la démarche prévue |
| 05 | `resultat-validation` | Après exécution des contrôles |
| 06 | `next` | À la clôture |
| 07 | `commit-message` | À la clôture |

**Ce que l'ordre change par rapport à la pratique.** Les sept étaient écrits en bloc à la fin. Sous C7, quatre d'entre eux ont un moment d'écriture distinct : 01 avant, 02 avant de produire, 03 pendant, 05 après les contrôles.

## L'ambiguïté du préfixe TSK

C4 donne `TSK-<SEQ>-<TYPE_LOG>_<YYYY-MM-DD-HH-MM>_<SLUG>.md`, où `SEQ` est le numéro du type de log.

Le même préfixe `TSK` désigne le type Tâche, dont le numéro est celui de la tâche. Un lecteur qui voit `TSK-01` dans un nom de fichier ne sait pas s'il lit une tâche 1 ou un log de type 01.

**Ce qui lève l'ambiguïté en pratique.** Le répertoire. Un log vit dans `TSK-<SEQ tâche>-<slug>/`, donc le contexte est donné par le chemin, ce que D1 exige précisément.

**Ce qui subsiste.** Le nom de fichier seul, hors de son répertoire, reste ambigu. Porté par une objection.

## Ce que D1 impose au chemin

« comprendre le contexte en inspectant les noms de fichiers et de répertoires ».

Le chemin doit donc porter la session, la tâche, le type de log et le moment.

```
.dev/logs/SES-001-ressources-et-concepts-de-base/
          TSK-025-systeme-de-journalisation/
              TSK-01-demande_2026-08-11-09-06_systeme-de-journalisation.md
```

Quatre informations sont lisibles sans ouvrir un fichier : la session, la tâche, le type de log, la date et l'heure.

**Ce que l'ancien format ne donnait pas.** `demande-task-14.md` ne porte ni date, ni heure, ni session dans son nom. La date du répertoire était celle de l'ouverture de session, pas celle de l'écriture.

## Les trois types, et leur frontière

| Type | Ce qu'il porte | Cycle |
|---|---|---|
| `SES` | Une session de travail : contexte, intention, critère de convergence, tâches | `travail` |
| `TSK` | Une tâche d'une session : son énoncé, son état | `travail` |
| `LOG` | Une information de journal, produite pendant une tâche | `point-fixe` |

**Ce qui départage `TSK` et `LOG`.** La tâche est ce qui est demandé, le log est ce qui a été fait. La tâche vient de l'humain, le log de l'agent.

**Ce qui départage `SES` et `workspace/session.md`.** Le fichier de session est le point d'entrée vivant, en édition humaine. Une `SES` est son enregistrement, arrêté.

**Un point à trancher.** `NON-002` Q1 portait la question : « est-ce que les logs sont des ressources ? J'aurais tendance à dire oui. Mais je n'en suis pas certain. » C1 y répond par l'affirmative.

## Pourquoi LOG est point-fixe

Un log constate ce qui a été fait à un moment. Le modifier après coup serait falsifier, exactement comme la teneur d'une décision.

C'est aussi ce qui rend C7 vérifiable : un log écrit au moment de son exécution et jamais modifié porte un horodatage qui veut dire quelque chose.

**Conséquence.** Un log ne porte pas de champ `version`.

## Ce que C8 demande, et son coût

« générer les skills en prenant en compte la méthode MET de journalisation ».

Les sept skills portent une rubrique Procédure qui ne mentionne aucune journalisation. Sous C8, chacun doit renvoyer à `MET-003`.

**Ce que C8 suppose et qui n'existe pas.** Un générateur. `ADR-016` D3 pose que les skills sont dérivables, et rien ne les dérive. C8 sera donc appliqué à la main, ce qui est le geste que la décision déclare provisoire.

## Ce que cette tâche ne peut pas faire

**Migrer les journaux existants.** Cent seize fichiers de log dans l'ancien format, dont trois qui combinent plusieurs tâches. Les renommer leur donnerait un horodatage faux : la date d'écriture réelle n'est pas récupérable, et l'inventer contredirait D3.

**Rendre C7 vérifiable.** Rien ne prouve qu'un log a été écrit au moment qu'il déclare. L'horodatage du nom est déclaratif. Seule la date de commit git le corrobore, et un commit unique en fin de tâche ne distingue pas les sept écritures.
