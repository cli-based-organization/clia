# Reprise après interruption, tâche 9 de SES-002

Second versement, `MET-003` étape 3. Le premier versement rapporte l'exécution des quatre plans ; celui-ci rapporte ce qui restait après que la tâche a été interrompue.

`derive-de` `TSK-03-fait_2026-08-13-12-39_quatre-plans-executes.md`

## Où la tâche s'est arrêtée

Aucun fichier du dépôt n'a été touché après 12:49, hors les trois logs de clôture eux-mêmes. **Le travail était fait ; ce qui manquait est ce qui vient après.**

| Ce qui manquait | Traité ici |
|---|---|
| La restitution à l'humain — `MET-005` étape 4 porte sur ce qui est **rendu**, pas sur ce qui est écrit | Rendue à la reprise |
| Deux logs portaient un horodatage postérieur à leur écriture | Renommés |
| Le log `analyse` n'a jamais été écrit | **Non réparable**, voir plus bas |
| Le commit | Appartient à l'humain, `CONSTITUTION.md` C2 |

## Les vérifications refaites à la reprise

Une tâche interrompue ne se déclare pas finie sur la foi de son propre journal.

| Contrôle | Résultat |
|---|---|
| Suite de tests | **270 réussis, 0 échoué** |
| `PLN-011` à `PLN-014` | **`execute`**, chacun déclarant la tâche qui l'a exécuté |
| `FNC-001` à `FNC-007` | **7 instances**, listées par `clia res ls fonctionnalite` |
| `clia focus` | Répond, désigne `BUG-002` |
| `clia git check done` | Message de commit trouvé ; **un seul KO, `commit.gpgsign` absent**, condition du dépôt étrangère à la tâche |

## Les horodatages corrigés

Deux noms portaient une heure que le fichier n'a pas connue. `MET-003` fait de l'horodatage un contrôle — celui de `demande` doit précéder tous les autres — et une heure fausse le rend inopérant.

```
TSK-01-demande_...-13-00_...  ->  ...-11-29_...   (écrit à 11:29)
TSK-03-fait_...-14-30_...     ->  ...-12-39_...   (écrit à 12:39)
```

**Le contenu n'est pas touché** : `R2` interdit de réécrire un log, pas de corriger un nom qui ment sur sa date. Décidé en avançant — réversible, document d'agent, une seule lecture raisonnable.

Sans cette correction, la tâche 9 affichait une demande écrite **après** son propre journal de fait.

## Le log `analyse` manque, et il n'est pas écrit après coup

`MET-003` étape 2 le veut écrit avant le premier livrable. L'écrire maintenant produirait exactement ce que la méthodologie nomme comme défaut : *« enregistrer ce qu'il aurait dû comprendre »* au lieu de ce qu'il a compris.

**Ce qui aurait dû s'y trouver n'est pas perdu** : les trois décisions prises en avançant sont dans le premier versement de fait, ce que `MET-005` étape 2 autorise explicitement.

**Ce que le défaut coûte** : rien de traçable ici. Il est relevé parce qu'il est le troisième du genre — `TSK-005` et `TSK-006` n'ont pas de log `analyse` non plus. Trois tâches sur dix : ce n'est plus un oubli, c'est une étape que le procédé ne rend pas obligatoire.

## Ce qui reste, et à qui

**À l'humain** : commiter. `clia git save` lit le message préparé.

**Ouvert** : les cinq suites du log `next`, dont deux appartiennent à l'humain.
