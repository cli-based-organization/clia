# CAS-004 — Reprendre ce qui vient d'ailleurs, et le tenir à jour

## Acteur

**Le porteur d'un dépôt** qui ne veut pas réinventer un type, un skill ou une
procédure qu'un autre dépôt a déjà établi.

## Situation avant

Un autre dépôt — celui de clia, ou celui d'une équipe — porte des ressources
utilisables. Le dépôt courant n'en sait rien, ou il en a repris une copie il y a
trois semaines et ignore qu'elle a changé depuis.

## Ce qu'il veut

Trois gestes, dans cet ordre :

1. **Déclarer une provenance** et voir ce qu'elle offre.
2. **Reprendre** ce qui l'intéresse, avec tout ce que la ressource porte.
3. **Savoir qu'il est en retard**, et se remettre à niveau quand il le décide.

## Le récit

Il déclare le dépôt d'origine. L'outil le rend consultable et inscrit la
provenance dans la déclaration versionnée du dépôt, tandis que la copie de
travail reste sur la machine et n'est pas versionnée.

Il liste ce qui est offert, en reprend une partie. Chaque reprise est inscrite :
quoi, d'où, en quelle version.

Plus tard, l'outil lui signale qu'une ressource est en retard sur ce que sa
provenance offre aujourd'hui. Il demande la mise à jour. **La copie est
remplacée, non fusionnée** : si elle a été modifiée sur place, l'outil refuse et
nomme ce qui serait perdu.

## À quoi il voit que c'est fait

- La déclaration du dépôt dit, pour chaque chose reprise, d'où elle vient et en
  quelle version.
- Un retard est signalé sans être imposé : le dépôt travaille avec la version
  qu'il a.
- Aucune modification faite sur place n'est perdue en silence.

## Ce qui doit échouer, et bien

| Situation | Ce que l'acteur doit obtenir |
|---|---|
| La provenance est injoignable | Un refus qui distingue « pas de réseau » de « n'existe plus » |
| La version installée n'est plus au catalogue | Le dire **avant** de continuer, la comparaison étant impossible |
| Une ressource est née dans le dépôt | Le dire, plutôt que d'aller chercher ailleurs un homonyme |
| Un retour en arrière est demandé sur des instances déjà migrées | Le dire : la migration ne redescend pas, et l'inventer déciderait du format |

## Ce que ce cas n'inclut pas

Mettre à jour **clia lui-même** n'est pas ce geste : un dépôt ne réécrit pas le
code qui l'instrumente (`CAS-001`, `RQN-002`).

## Origine

`USE-005`, `USE-006` et `USE-007` de la génération courante. Le besoin est
attesté : les deux dépôts de travail réel du corpus reprennent quatre types du
noyau et y ajoutent les leurs (`ANL-001` C12).
