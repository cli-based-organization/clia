# Ce qui a été fait, tâche 12 de SES-002 — second versement

`MET-003` étape 3. Le chantier B de `PLN-015`, et ce que l'échec du chantier A oblige à corriger ailleurs.

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## Deux règles de conduite — `MET-005` étape 3

**Ce qui a été livré.** La méthodologie d'exécution d'un plan porte désormais les deux formes qui interrompent l'humain, et ce qui les remplace.

> **R1.** Un fichier s'écrit avec l'outil d'écriture, jamais par un document en place dans une commande shell.
>
> **R2.** Un chemin qui ne sert qu'une fois s'écrit en toutes lettres, jamais par une variable.

**Comment s'en servir.** Ce n'est pas une commande : c'est une règle que l'agent applique. Elle se lit dans `clia res show MET-005`, étape 3.

Les six interruptions de `BUG-001` que ces règles auraient évitées y figurent une à une, chacune avec la forme fautive et la forme qui n'aurait rien déclenché — c'est le critère du chantier, et il est satisfait : six lignes.

**Ce qui ne marche pas encore.** Ces règles suppriment six interruptions sur quinze. Les huit autres sont des scripts d'épreuve, et le chantier A vient d'établir qu'aucun hook ne les autorisera non plus.

**Portée.** La règle vaut pour tout travail de l'agent, pas seulement l'exécution d'un plan. Elle vit dans `MET-005` parce que c'est le lieu où l'agent agit, et parce que le chantier laissait le choix du lieu — créer une méthodologie de plus aurait ajouté un item là où la session cherche à en retirer.

---

## Ce que l'échec du chantier A oblige à corriger

**`ANL-012` recommandait une piste sur une propriété qu'elle n'avait pas vérifiée.** L'analyse le déclarait dans ses limites ; la mesure lui donne tort. Deux corrections y sont portées, toutes deux déclarées dans le document :

| Correction | Ce qui change |
|---|---|
| Section « Ce que la mesure a établi » | Un hook décide dans le sens du refus, pas de l'autorisation. La piste D est indémontrable par script, non réfutée |
| Répartition des six cas évitables | **3 et 3, non 4 et 2.** Le premier compte prenait pour deux interruptions les deux documents en place d'un seul appel |

**Le total évitable reste six, et aucune conclusion ne change.** La correction est signalée dans le tableau plutôt que faite en silence.

**`PLN-015` porte l'état réel de ses trois chantiers**, et reste `propose`.

## Ce que le plan avait mal prévu

Il déclarait : « si la mesure échoue, tout le plan tombe ». **La prévision était trop nette.** Le chantier B ne dépendait de rien et il est exécuté ; seul C tombe avec A.

Écrire une conséquence en bloc est plus simple que de la répartir par chantier, et c'est moins vrai.

## Livrables

| Fichier | Nature |
|---|---|
| `MET-005` | Étape 3 : les deux règles, les six cas |
| `ANL-012` | Ce que la mesure établit, et la répartition corrigée |
| `PLN-015` | Section « Statut » : le sort des trois chantiers |
| Journal de la tâche | La mesure, ses quatre passages, l'hypothèse fausse |
