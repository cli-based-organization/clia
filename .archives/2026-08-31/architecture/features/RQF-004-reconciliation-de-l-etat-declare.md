# RQF-004 — Le système réconcilie un état déclaré avec un état constaté

## Ce que le système doit savoir faire

Tenir, pour tout ce qu'il gère, la même mécanique en quatre temps : **déclarer**
l'état voulu, **constater** l'état réel, **différer** les deux, **appliquer** ce
qui est applicable.

Cette capacité est unique et sert plusieurs gestes qui, aujourd'hui, sont écrits
séparément : vérifier la conformité, instrumenter un dépôt, reprendre une
ressource, se remettre à niveau, migrer des instances.

## Ce qui est attendu, point par point

| # | Le système… |
|---|---|
| a | tient l'état voulu dans une déclaration **versionnée avec le dépôt** |
| b | établit l'état réel par observation, jamais par mémoire d'une exécution passée |
| c | rend la différence lisible, contrôle par contrôle, **sans rien modifier** |
| d | applique, sur demande explicite, les écarts dont la réparation ne décide rien |
| e | refuse les écarts dont la réparation déciderait à la place de l'humain, et les nomme |
| f | compte un geste échoué comme un échec, jamais comme une réparation |
| g | est idempotent : appliquer deux fois de suite ne fait rien la seconde fois |
| h | distingue un écart **bloquant** d'une **dérive** qui n'empêche rien aujourd'hui |

## À quoi on constate que c'est tenu

- Un constat sans demande d'application ne modifie aucun octet, ce qui se
  vérifie automatiquement.
- Après une application, un second constat ne trouve plus que les écarts
  déclarés non réparables.
- Les gestes d'instrumentation, de reprise et de mise à niveau **appellent cette
  mécanique** au lieu de la réimplémenter.

## Ce qui est explicitement hors de ce requis

L'installation de clia sur le poste. Un dépôt ne réconcilie pas le code qui
l'instrumente (`CAS-001`, `ANL-001` E9).

## Motivé par

`CAS-002`, `CAS-004`.

## Origine

G3 a construit cette mécanique trois fois sans la nommer (`ANL-001` C15, E4).
`FND-001` de G2 avait identifié le modèle et l'avait déclaré non transposable ;
l'exception qu'elle nommait est devenue le cas général. Principe P3.
