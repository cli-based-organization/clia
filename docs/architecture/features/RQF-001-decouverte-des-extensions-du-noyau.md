# RQF-001 — Le noyau découvre ses commandes, il ne les connaît pas

## Ce que le système doit savoir faire

Exposer et rendre invocable toute commande **présente**, sans qu'aucune liste
centrale ne l'énumère et sans qu'aucun fichier du noyau soit modifié pour
l'ajouter.

Chaque commande porte, avec elle, de quoi être découverte : ce qu'elle fait, sur
quoi elle agit, et sous quels autres noms elle répond.

## Ce qui est attendu, point par point

| # | Le système… |
|---|---|
| a | trouve les commandes à des emplacements conventionnels, et non dans un registre |
| b | lit, sur chaque commande, sa description, son périmètre d'action et ses alias |
| c | applique **une seule fois, au point d'entrée**, la garde qui découle du périmètre |
| d | traite l'absence de déclaration par le comportement le **plus restrictif** |
| e | signale deux commandes de même nom au lieu d'en choisir une |
| f | compose l'aide générale à partir de ce qu'il a trouvé |

## À quoi on constate que c'est tenu

Déposer un fichier de commande valide le fait apparaître dans l'aide et le rend
invocable, sans autre geste. Le retirer le fait disparaître. Aucun fichier du
noyau n'a changé dans un cas ni dans l'autre.

## Ce qui est explicitement hors de ce requis

Le mécanisme vaut pour les commandes. Son extension aux types, aux gabarits, aux
prompts et aux contrôles est portée par `RQF-002` : c'est le même principe, et
ce sont deux capacités distinctes à constater.

## Motivé par

`CAS-006`. Accessoirement `CAS-001`, dont l'aide est la première chose que
l'installateur voit.

## Origine

Seul composant traversant G1, G2, G3 et leurs antécédents sans être contesté
(`ANL-001` C13, V1). Principe P1.
