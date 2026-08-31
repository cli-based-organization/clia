# CAS-002 — Instrumenter un dépôt, et le tenir conforme

## Acteur

**Le porteur d'un dépôt** : la personne qui veut travailler dans un dépôt avec
l'aide d'un agent, et qui veut que cette aide soit cadrée par des conventions
plutôt que redécouverte à chaque session.

## Situation avant

Deux situations, et l'outil doit les distinguer :

- le dépôt n'existe pas encore ;
- le dépôt existe, a été instrumenté un jour, et a dérivé depuis — parce que
  l'outil a avancé, parce qu'un fichier a été supprimé à la main, ou parce que
  ce qui est déclaré n'a jamais été installé sur cette machine.

## Ce qu'il veut

Que le dépôt **déclare ce qu'il est et ce qu'il tient d'ailleurs**, que cette
déclaration soit versionnée avec le reste, et qu'une commande lui dise à tout
moment si le disque et la déclaration disent la même chose.

## Le récit

Il demande l'instrumentation. Le dépôt reçoit une carte d'identité, un harnais
pour l'agent, et un moyen d'exprimer sa demande de travail.

Des semaines plus tard, il revient. Il demande l'état. L'outil lui rend un
constat contrôle par contrôle, sans rien modifier, et nomme la commande qui
solderait chaque écart. S'il le demande, l'outil répare ce qui est réparable —
et **s'arrête devant tout écart dont la réparation déciderait à sa place**.

## À quoi il voit que c'est fait

- Le dépôt porte une déclaration lisible de ce qu'il est.
- Un constat sans option ne modifie **rien**, et il peut le vérifier.
- Un écart non réparé est nommé, avec ce qui manque pour le réparer.
- Un écart réparé est compté comme réparé ; un geste qui échoue est compté
  comme un échec, jamais comme une réparation.

## Ce qui doit échouer, et bien

| Situation | Ce que l'acteur doit obtenir |
|---|---|
| La provenance d'une ressource ne peut pas être devinée | Une invite visible, jamais une valeur inventée |
| Une reprise écraserait un travail fait sur place | Un refus, le nom de ce qui serait perdu, et l'option qui passe outre |
| Le dépôt n'a jamais été instrumenté | La distinction claire entre « rien à faire » et « rien compris » |

## Ce que ce cas n'inclut pas

Reprendre une ressource d'un autre dépôt est `CAS-004`. Produire une instance
d'un type est `CAS-003`.

## Origine

`USE-002` et `USE-008` de la génération courante. Le cas motivant est réel : un
dépôt instrumenté par une version antérieure, portant ses déclarations dans un
emplacement abandonné, et que rien n'avait signalé. Le précédent historique est
`tda`, qui a équipé huit dépôts puis est mort sans qu'aucun ne l'apprenne
(`ANL-001` C2).
