# CAS-006 — Étendre clia sans le modifier

## Acteur

**Le contributeur** : la personne, ou l'agent, qui a besoin d'un geste que clia
ne fait pas, ou d'un type de document que clia ne connaît pas.

## Situation avant

Le besoin est réel et local : un domaine a ses documents, une équipe a ses
procédures. Rien de cela n'a vocation à entrer dans le noyau.

## Ce qu'il veut

Ajouter la capacité **sans toucher au noyau**, et sans que le noyau ait besoin
d'être au courant.

## Le récit

Pour une commande, il dépose un fichier à l'emplacement prévu, avec les
déclarations minimales qui disent ce qu'elle fait et sur quoi elle agit. Elle
apparaît dans l'aide et devient invocable. **Elle hérite des gardes du noyau
sans les déclarer** — et l'oubli d'une déclaration restreint, il n'ouvre jamais.

Pour un type, il déclare la définition. Le type apparaît, ses instances se
créent, se valident et se comptent comme celles du noyau.

Puis il publie son dépôt. Un autre le déclare comme provenance, et reprend ce
qui l'intéresse — `CAS-004` vu de l'autre côté.

## À quoi il voit que c'est fait

- Aucun fichier du noyau n'a été modifié.
- La chose nouvelle est traitée comme les anciennes : même aide, mêmes verbes,
  mêmes codes de retour.
- Deux extensions qui portent le même nom sont **signalées**, non arbitrées en
  silence.

## Ce qui doit échouer, et bien

| Situation | Ce que l'acteur doit obtenir |
|---|---|
| La déclaration de périmètre est absente | Le comportement le plus restrictif, jamais le plus permissif |
| Un nom est déjà pris | Le dire, en nommant qui le porte |
| Une extension déclare un type déjà connu | Le dire, et laisser l'humain trancher |

## Ce que ce cas n'inclut pas

Le contenu d'une instance reste au producteur. L'outil pose le fichier, le nom,
le numéro et la structure ; il n'écrit pas ce qu'il y a à dire (`ANL-001` E7).

## Origine

`PDC-006`, l'extensibilité préférée à la complétude, et le constat que le
mécanisme de découverte des commandes est le seul composant que trois
générations n'ont jamais remis en cause (`ANL-001` C13, V1, P1).
