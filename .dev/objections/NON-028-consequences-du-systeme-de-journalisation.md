---
type: objection
id: NON-028
title: "Conséquences du système de journalisation"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-032, RES-033, RES-034, MET-003]
---

# NON-028 - Conséquences du système de journalisation

> Le nouveau format s'applique à partir de cette tâche. Cent seize logs restent dans l'ancien, dont trois qui combinent plusieurs tâches. Et la règle centrale, écrire au moment de l'exécution, n'est vérifiable par rien.

## Journal

- 2026-08-11 : ouverte par l'agent, à la tâche 25, avec `RES-032`, `RES-033`, `RES-034` et `MET-003`.

## Ce qui est contesté

Non pas les correctifs, qui sont des décisions de l'humain. Cinq conséquences qu'ils laissent indéterminées.

**Le journal existant n'est pas migré.** Cent seize fichiers dans l'ancien format, dans un répertoire nommé par date et non par numéro de session. Trois d'entre eux violent le correctif C3 : `fait-task-17-19`, `fait-task-20-21`, `fait-task-23-24`.

**La règle centrale n'est pas vérifiable.** `MET-003` exige que chaque log soit écrit au moment de l'exécution. L'horodatage du nom et le champ `ecrit-le` sont **déclaratifs** : rien n'empêche de les antidater.

**Le préfixe du nom de fichier est ambigu.** `TSK-01-demande` porte `TSK` pour désigner un type de log numéroté 01, alors que `TSK` est le préfixe du type Tâche, dont le numéro est celui de la tâche. Hors de son répertoire, le nom seul ne se lit pas.

**La forme de `MET-003` comme ressource source est une interprétation.** Le correctif C6 dit « produire une méthode MET de journalisation (ressource source) **interne à RES log** ». La méthode a été produite comme document séparé et déclarée dans `RES-032`. La lecture « écrite dans le fichier `RES` » supposait le mécanisme d'imbrication que `ISU-001` porte et que rien n'implémente.

**Le répertoire de session change de forme sans que rien ne migre.** L'ancien est `2026-08-09-SES-ressources-et-concepts-de-base`, le nouveau `SES-001-ressources-et-concepts-de-base`. Les deux coexistent, et le journal de cette session est réparti entre les deux.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Le dépôt porte deux formats de journal simultanément.** Un lecteur qui cherche le journal de la session en trouve deux répertoires, l'un daté et l'autre numéroté, avec des conventions de nommage incompatibles. C'est le défaut `D1` que la tâche corrige, reproduit à l'échelle du répertoire.

**Une règle non vérifiable est une règle non tenue en puissance.** `NON-005` conteste cette accumulation depuis le 2026-08-09. `MET-003` en ajoute une, et c'est sa règle centrale.

**L'antériorité du défaut est mesurée et son auteur est connu.** Onze tâches ont été journalisées en bloc à la clôture par l'agent. Rien n'établit qu'il ne recommencera pas quand la tâche sera longue.

## Questions

### Q1 - Les 116 logs de l'ancien format sont-ils migrés ?

Trois positions.

Ne rien migrer, et déclarer que le nouveau format vaut à partir du 2026-08-11. Le dépôt porte alors deux conventions, ce que `ANL-001` identifie comme le mode de défaillance dominant du corpus.

Migrer les noms, ce qui suppose d'inventer un horodatage que rien ne connaît. La date d'écriture réelle n'est pas récupérable, et l'inventer contredirait `D3`.

Migrer la structure sans les horodatages : un répertoire par tâche, noms conservés. Coût moyen, résultat partiel.

**Réponse.**

### Q2 - Comment vérifier qu'un log a été écrit au moment qu'il déclare ?

L'horodatage est déclaratif. Trois pistes.

Comparer avec la date de commit git, ce qui ne distingue pas les sept écritures d'un commit unique de fin de tâche.

Exiger un commit par log, ce qui multiplie les commits par sept et contredit la pratique.

Accepter que la règle repose sur la discipline, et la déclarer non outillée.

La troisième est la position actuelle, et elle est celle que `NON-005` conteste.

**Réponse.**

### Q3 - Le préfixe `TSK` du nom de log doit-il changer ?

`TSK-01-demande` désigne un type de log, non une tâche. Le répertoire lève l'ambiguïté, le nom seul non.

Candidats : conserver `TSK`, ce que le correctif C4 prescrit littéralement ; employer `LOG-01-demande`, cohérent avec le préfixe du type ; ou n'employer que le numéro, `01-demande`.

**Réponse.**

### Q4 - Une tâche a-t-elle un fichier d'énoncé distinct ?

`RES-033` fait de la tâche un répertoire, et laisse l'énoncé vivre dans le log de type `demande`.

Un fichier d'énoncé distinct rendrait la tâche lisible sans ouvrir un log, et dupliquerait ce que `workspace/session.md` porte déjà.

**Réponse.**

### Q5 - Quand le fichier de session vivant devient-il une `SES` ?

`RES-034` distingue `workspace/session.md`, point d'entrée vivant en édition humaine, de la ressource `SES` qui l'enregistre.

Aucun geste ne fait passer de l'un à l'autre. À la clôture d'une session, qui produit la `SES`, et avec quel contenu ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 décide si le dépôt porte une convention ou deux. Q2 dit si la règle centrale de `MET-003` est vérifiable ou seulement écrite.

L'effet est `conditionnel` : les trois types sont utilisables, `MET-003` est applicable, et le journal de la tâche 25 en est la première instance conforme.

## Relations

- `objecte-a` [RES-032](../ressources/RES-032-log.md)
- `objecte-a` [RES-033](../ressources/RES-033-tache.md)
- `objecte-a` [RES-034](../ressources/RES-034-session.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
- `reference` [ISU-001](../issues/ISU-001-definir-une-ressource-dans-un-document-ressource.md)
