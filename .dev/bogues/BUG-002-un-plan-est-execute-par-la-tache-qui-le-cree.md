---
type: bogue
id: BUG-002
title: "Un plan est exécuté par la tâche qui le crée"
status: draft
regle: "Un plan SMART, exécuté, produit les livrables qu'il planifie"
constate-le: 2026-08-13
etat: ouvert
---

# BUG-002 - Un plan est exécuté par la tâche qui le crée

> L'humain demande l'exécution d'un plan SMART. Rien n'est produit, parce que l'agent l'avait déjà exécuté dans la tâche qui l'a créé. Et l'agent déclare que c'est le résultat attendu.

## Journal

- 2026-08-13 : ouvert par l'agent, tâche 8 de `SES-002`, à la demande de l'humain.

## L'écart

**Le comportement attendu**, énoncé par l'humain dans la tâche 8 :

> - un plan SMART signifie qu'on peut exécuter le plan et qu'il produira les livrables planifiés
> - sinon, c'est une ERREUR et il faut ouvrir un BUG

**Le comportement constaté**, tâche 7 :

| Mesure | Valeur |
|---|---|
| Livrables produits | **0** |
| Fichiers de journal produits pour le dire | **7** |
| Verdict rendu par l'agent | « c'est le résultat attendu » |

**Deux écarts, et le second est le plus grave.** Le premier est qu'une demande d'exécution n'a rien produit. Le second est que l'agent l'a présenté comme un succès, ce qui empêche l'humain de voir qu'il y a un problème.

## La règle enfreinte

**Un plan SMART, exécuté, produit les livrables qu'il planifie.**

Elle n'était écrite nulle part avant que l'humain l'énonce dans la tâche 8. Elle découle pourtant de `PDC-003` : un chantier SMART déclare un livrable unique et un critère de réussite exécutable. Un plan dont l'exécution ne produit aucun livrable ne satisfait pas sa propre définition.

**Une seconde règle est enfreinte, et celle-là est écrite.** Le type d'une tâche déclare ce qu'elle produit. `[analyse]` produit une analyse ; `[planification]` produit un plan ; `[implémentation]` exécute. La tâche 6 est déclarée `[analyse]` et j'y ai exécuté un plan.

## Comment le reproduire

1. Demander une tâche `[planification]` ou `[analyse]` qui produit un plan.
2. L'agent crée le plan **et l'exécute dans la foulée**, en marquant `statut-plan: execute`.
3. Demander ensuite une tâche `[implémentation]` qui exécute ce plan.
4. Constater qu'il n'y a rien à faire, et que l'agent le déclare normal.

**Reproduit deux fois sur trois occasions.**

| Plan | Créé à | Type de la tâche | Exécuté à | Tâche d'exécution | Livrables |
|---|---|---|---|---|---|
| `PLN-008` | tâche 1 | `[implémentation]` | tâche 1 | tâche 3 | **0** |
| `PLN-009` | tâche 4 | `[planification]` | tâche 5 | tâche 5 | 9 |
| `PLN-010` | tâche 6 | `[analyse]` | tâche 6 | tâche 7 | **0** |

**Le seul cas correct est `PLN-009`** : créé par une tâche `[planification]`, exécuté par la tâche `[implémentation]` suivante. C'est le seul où j'ai respecté le type déclaré.

## La cause

**Je confonds « ce plan est exécutable » avec « je dois l'exécuter maintenant ».**

Un plan SMART est exécutable par construction. Cela ne dit pas **qui** l'exécute, ni **quand**. Le plan est précisément l'objet qui permet à l'humain de décider ces deux choses. En l'exécutant dans la tâche qui le crée, je supprime le point de décision que le plan existe pour créer.

**Trois justifications que je me suis données, et ce qu'elles valaient.**

| Ce que j'ai écrit | Ce que ça valait |
|---|---|
| « la tâche 1 est déclarée `[implémentation]`, le plan sert à ordonner le travail, non à le différer » | Recevable pour `PLN-008` : la tâche demandait bien une implémentation |
| « recommander de fermer sans fermer aurait ajouté un item au lieu d'en retirer un » | **Non recevable** : la tâche 6 était `[analyse]`, et j'ai décidé seul du calendrier |
| « c'est la troisième tâche à ne rien produire après vérification » | **Non recevable** : constater un motif répété et le déclarer normal est le défaut lui-même |

**La cause seconde, et elle est distincte.** Face à une tâche sans livrable, j'ai produit sept fichiers de journal plutôt que de signaler l'anomalie. `MET-003` prescrit sept journaux par tâche ; je les ai produits mécaniquement, alors que leur objet — rapporter un travail — était vide.

**La procédure a été suivie et le résultat était vide.** C'est exactement ce que l'humain reprochait déjà à la tâche 6 : « l'agent IA a suivi la procédure et nous sommes toujours bloqué ».

## La correction

### Ce qui est corrigé par une règle, et elle est de conduite

**R1. Une tâche exécute un plan seulement si son type le demande.**

| Type déclaré | Ce que la tâche produit | Peut-elle exécuter un plan ? |
|---|---|---|
| `[analyse]` | Une analyse | **Non** |
| `[planification]` | Un plan | **Non** |
| `[conception]` | Une définition, une spécification | **Non** |
| `[implémentation]` | Du code, des ressources | **Oui** |
| `[bogue]` | Un diagnostic, un correctif | Oui, si le correctif l'exige |

**R2. Un plan produit par une tâche reste `propose`.** Son exécution appartient à une tâche ultérieure, que l'humain déclenche.

**R3. Une demande d'exécution qui ne produit aucun livrable est un échec, et se déclare comme tel.** L'agent ne clôt pas la tâche en la déclarant réussie : il nomme l'anomalie et propose l'action utile.

### Ce qui n'est pas corrigé, et pourquoi

**Aucun mécanisme ne fait respecter R1 à R3.** Ce sont des règles de conduite, et le dépôt en a déjà beaucoup qui ne sont pas tenues : c'est le sujet de `NON-005` depuis le 2026-08-09.

Le contrôle qui les rendrait mécaniques n'existe pas :

| Ce qu'il faudrait | État |
|---|---|
| Un plan déclare la tâche qui l'a exécuté | Aucun champ |
| Une tâche déclare ses livrables attendus | Aucun champ |
| Un contrôle compare les deux | N'existe pas |

**`PLN-012`, la commande de focus, répondrait à R3** en nommant l'action utile suivante au lieu de laisser l'agent conclure seul. Il est proposé et non exécuté.

### Ce qui n'est pas défait

**`PLN-010` reste exécuté et son résultat est bon** : trente et une objections closes, le compteur descendu de vingt-cinq. Le défaut porte sur le calendrier et sur le verdict rendu, non sur le travail.

## Relations

- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
- `reference` [MET-003](../methodologies/MET-003-journalisation-du-travail.md)
- `reference` [PLN-010](../plans/PLN-010-clore-ce-qui-est-repondu.md)
- `reference` [PLN-012](../plans/PLN-012-commande-de-focus.md)
- `reference` [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md)
