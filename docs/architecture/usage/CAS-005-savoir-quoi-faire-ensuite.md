# CAS-005 — Savoir où en est le dépôt, et quoi faire ensuite

## Acteur

**Deux acteurs, et c'est le point du cas.** L'humain qui revient après une
interruption, et l'agent qui commence une tâche. Ils ne veulent pas la même
réponse, et une file unique ne peut pas servir les deux.

## Situation avant

L'information existe et elle est dispersée. Ce qui attend une décision humaine,
ce qui attend une exécution, ce qui est en retard, ce qui est ouvert depuis
trois semaines : tout est écrit quelque part, dans autant de fichiers.

## Ce qu'ils veulent

Une réponse à **« que dois-je faire maintenant ? »**, où le *je* est renseigné.

## Le récit

L'humain revient après deux semaines. Il demande l'état, en son nom. Il obtient
ce qui l'attend, **lui** : les questions posées sans réponse, les écarts que
l'outil refuse de trancher, les décisions suspendues. Il ne veut pas savoir ce
que l'agent a à faire.

L'agent commence. Il demande l'état, en son nom. Il obtient ce qui est
exécutable : ce qui a été décidé et pas encore fait, ce qui est prêt et ce qui
est bloqué — avec, pour chaque blocage, **le geste qui le lèverait**.

## À quoi ils voient que c'est fait

- La sortie tient sur un écran, et elle nomme un geste, pas un état.
- Un blocage est présenté avec ce qui le débloquerait, et par qui.
- Deux sources ne donnent pas deux directives contradictoires.

## Ce qui doit échouer, et bien

| Situation | Ce que l'acteur doit obtenir |
|---|---|
| Rien n'attend cet acteur | Le dire, en une ligne. « Rien à faire » est une réponse utile |
| Un item est ouvert depuis longtemps sans mouvement | Le signaler, l'ancienneté étant l'information |
| L'acteur n'est pas précisé | Le demander, ou choisir un défaut **annoncé** — jamais deviner en silence |

## Ce que ce cas n'inclut pas

Aucun document nouveau n'est produit. Le focus est une **projection** sur ce qui
existe déjà : il ne crée ni type, ni instance, ni registre.

## Origine

G2 a construit cette commande et a échoué : `ANL-013` établit qu'elle affichait
trois des vingt-six suites destinées à l'humain, et que le dépôt *« savait dire
ce qui bloque, pas quoi faire pour débloquer »*. L'échec vient de ce qu'une
seule file servait deux acteurs. Le principe P7 de `ANL-001` en tire la leçon.
