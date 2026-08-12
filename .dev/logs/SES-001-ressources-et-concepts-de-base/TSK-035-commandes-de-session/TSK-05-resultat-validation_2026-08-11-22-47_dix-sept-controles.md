# Résultat de la validation, tâche 35

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les six formes demandées répondent | **Réussi**, alias `session`, `ses`, `s` compris |
| 2 | Aide atteignable sur chaque verbe | **Réussi**, les cinq |
| 3 | La garde refuse à un agent, code 3, sans rien créer | **Réussi** |
| 4 | `CLIA_ACTOR=human` lève la garde | **Réussi** |
| 5 | Cycle complet `new`, `todo`, `ls`, `new`, `close` | **Réussi**, dépôt jetable |
| 6 | `status` compte juste sur le dépôt réel | **Réussi**, 35 / 32, vérifié à la main |
| 7 | Une tâche sans message de commit n'est pas faite | **Réussi** |
| 8 | Une rubrique n'est pas comptée comme tâche | **Réussi** |
| 9 | Une tâche sans point après le numéro est comptée | **Réussi** |
| 10 | Les tests de `clia git save` passent inchangés | **Réussi**, les six |
| 11 | `RES-034` et `NON-037` conformes | **Réussi** |
| 12 | `cue vet` sur les schémas | **Réussi** |
| 13 | Liens relatifs | **Réussi**, après une correction |
| 14 | Schéma du dépôt entier | **155 conformes, 8 non conformes** |
| 15 | Suite de tests | **Réussi, 187 assertions** |
| 16 | Écritures éprouvées en dépôt jetable | **Réussi** |
| 17 | Journal `MET-003` | **Réussi** |

## Ce que les contrôles ont trouvé

**Contrôle 13.** `NON-037` renvoyait à `NON-028-la-session-et-son-journal.md`, qui n'existe pas, et attribuait la question de l'énoncé de session à `NON-028` Q1, qui porte sur la migration des logs. Les deux corrigés : le fichier est `NON-028-consequences-du-systeme-de-journalisation.md`, la question est **Q5**.

**Contrôle 6, avant d'être réussi.** Trois défauts trouvés en confrontant le chiffre affiché au fichier, et non par un test.

| Défaut | Effet | Corrigé par |
|---|---|---|
| Un seul journal lu | 8 faites au lieu de 25 | Lire tous les journaux quand la session est le fichier vivant |
| Format plat ignoré | Les tâches 1 à 24 non comptées | Reconnaître `commit-message-task-<n>` |
| Point exigé après le numéro | 33 tâches au lieu de 35 | Point facultatif |

**Le dernier est instructif.** Le fichier vivant écrit `## 32 [bogue]` et `## 35 [implémentation]` sans point. Un test écrit d'après ma propre convention serait passé au vert : c'est exactement le défaut du 2026-08-11, où un test codifiait le bogue de nommage.

**Contrôle 14.** Les huit non conformes sont antérieurs et inchangés : les `DCN` rédigées par l'humain portant `À RENSEIGNER`.

## Ce que la validation ne couvre pas

**Le comptage sur une session enregistrée n'a jamais servi.** Il est éprouvé en dépôt jetable et sur le fichier vivant, jamais sur une vraie `SES` : aucune n'existe.

**La tolérance au format plat n'a pas de fin déclarée.** Elle vaut pour cent vingt-six fichiers d'un seul dépôt, et rien ne dit quand elle sort du code.

**`clia ses close` n'a pas de critère.** Il change un champ. Rien ne vérifie que la session a convergé, parce que le critère de convergence n'a plus de rubrique. `NON-037` Q1.
