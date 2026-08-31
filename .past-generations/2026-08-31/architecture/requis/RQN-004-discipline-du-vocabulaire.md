# RQN-004 — Discipline du vocabulaire

## L'exigence

**Un mot, un objet.** Quand un même mot doit servir à plusieurs objets, la
sortie le qualifie systématiquement ; il n'y apparaît jamais seul.

Tout terme employé par l'outil dans sa sortie ou dans son aide est défini à un
seul endroit, et cet endroit fait foi.

## Portée

L'aide, les messages, les sorties, les noms de commandes et de verbes, les noms
de champs des déclarations.

## Pourquoi c'est opposable

Un vocabulaire flou coûte à chaque lecture, et le coût est invisible parce qu'il
se paie en malentendus plutôt qu'en erreurs. Il est mesurable ici : le mot
« version » désigne six objets distincts dans la génération courante — la
version de l'installation, celle du dépôt, celle d'une ressource, l'installée,
l'offerte, les disponibles — et l'outil emploie le mot nu dans plusieurs
sorties.

## Comment on le constate

| Contrôle | Constat attendu |
|---|---|
| Recherche d'un terme polysémique dans les sorties | Chaque occurrence est qualifiée |
| Deux commandes portant sur le même objet | Le même verbe, le même nom, le même ordre |
| Un terme du domaine | Une seule définition, citée par tout le reste |
| Deux termes concurrents pour un même objet | Un seul survit ; l'autre est un alias déclaré, non un synonyme toléré |

## Le cas le plus coûteux à ce jour

L'espace de nommage. Trois formes coexistent dans six dépôts, dont une non
résolue et une provenance fausse. Le mot désigne tantôt la provenance d'un
dépôt, tantôt un préfixe de domaine, et une catégorie de rangement a dû être
explicitement exclue de son sens dans une spécification.

## Origine

`ANL-001` C10, C11, M3, E5.
