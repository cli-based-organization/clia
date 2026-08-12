---
type: objection
id: NON-038
title: "Ce que la chaîne de session laisse ouvert"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [PLN-008, RES-034, NON-037]
---

# NON-038 - Ce que la chaîne de session laisse ouvert

> `PLN-008` a six chantiers SMART. Cinq points n'ont pas pu en devenir un : aucun critère de réussite exécutable ne peut être écrit tant qu'une question reste ouverte. La tâche demande un seul `NON` pour tout ce qui n'est pas SMART ; le voici.

## Journal

- 2026-08-12 : ouverte par l'agent, tâche 1 de `SES-002`, avec `PLN-008`.
- 2026-08-12 : **resserrée**. Les réponses à `NON-037` sont arrivées pendant la tâche et tranchent trois des cinq points. Ils sortent de cette objection ; deux subsistent.

## Ce qui est contesté

**Cinq points ont été retirés de `PLN-008`.** Ce n'est pas qu'ils soient sans intérêt : c'est qu'aucun critère de réussite ne peut être écrit pour eux, ce que `PDC-003` V-S2 exige.

| Point | Ce qui manque pour le rendre SMART | Sort |
|---|---|---|
| L'état `abandonnee` | La décision de le rétablir ou non | **Tranché** : `ISU-011` |
| La langue des états | La décision | **Tranché** : `opened`, appliqué |
| Ce que `close` vérifie du critère | Si le critère conditionne la clôture | **Tranché** : `ISU-010` |
| Un lien pointant une session non ouverte | Ce qu'il faut alors afficher | **Ouvert** |
| Le frontmatter absent de l'énoncé de `SES-001` | Le geste, qui appartient à l'humain | **Ouvert** |

**Trois points sur cinq ont été tranchés pendant la tâche.** Les réponses à `NON-037` sont arrivées alors que l'implémentation était en cours : deux deviennent des issues à la demande de l'humain, et la troisième a été appliquée. Deux subsistent, et ce sont les deux que cette objection porte.

## Pourquoi cela ne peut pas rester implicite

**Le troisième point est produit par la tâche elle-même.** `clia ses switch` ne fait que déplacer le lien, comme demandé. Le lien peut donc désigner une session `closed`, et `clia ses status` affiche alors :

```
session           SES-001
etat              closed
```

**C'est cohérent, et c'est peut-être faux.** Une session close affichée comme session en cours est soit exactement ce que l'humain veut — consulter une session terminée sans la rouvrir — soit un état dont il faudrait avertir.

**Le quatrième point est produit par le rétablissement du critère.** Le critère de convergence est de nouveau une rubrique obligatoire. `clia ses close` ferme sans le regarder : il change un champ. Un critère qu'aucun geste ne consulte est un critère décoratif, et c'est le défaut que `NON-005` mesure depuis le 2026-08-09.

**Le cinquième est mesurable, et il a deux faces.**

`SES-001` a bien un énoncé : l'humain a déposé son `session.md` dans le répertoire de session. **Il n'a pas de frontmatter**, donc pas d'`etat`, pas d'`ouverture`, pas d'`id` déclaré.

```
SES-001  (non declare)  2026-08-12  10  35  ressources et concepts de base
SES-002  open           2026-08-11   0   1  generation chain
```

**Et son avancement affiché est faux.** Dix tâches faites sur trente-cinq, alors que trente-deux le sont. Le journal de `SES-001` est réparti sur **deux répertoires** : `2026-08-09-SES-<slug>`, au format antérieur à `MET-003`, porte les tâches 1 à 24. Un énoncé ne lit que son propre répertoire.

**Hier le chiffre était juste, aujourd'hui il ne l'est plus.** Le repli lisait tous les journaux du dépôt, faute d'énoncé ; l'énoncé désigne maintenant un seul répertoire, et l'autre est hors de portée. La forme est plus correcte et la mesure est plus fausse.

## Ce que l'agent a mesuré

| Mesure | Valeur |
|---|---|
| Sessions visibles par `clia ses ls` | 2 sur 2 |
| Énoncés sans frontmatter | **1** sur 2 |
| Répertoires de journal | **3**, pour 2 sessions |
| Avancement affiché de `SES-001` | **10 sur 35**, au lieu de 32 |
| Questions de `NON-037` sans réponse écrite | **2** sur 5 |
| Chantiers retirés de `PLN-008` | **5** |
| Plans du dépôt jamais engagés | **4** sur 8 |

## Questions

### Q1 - Que doit afficher `status` quand le lien pointe une session non ouverte ?

Trois possibilités : l'afficher telle quelle, c'est le comportement actuel ; l'afficher avec un avertissement ; refuser.

La première est la plus fidèle à « `switch` ne fait que modifier le lien ». Elle est aussi celle qui peut faire travailler l'humain dans une session close sans qu'il s'en aperçoive.

### Q2 - L'énoncé de `SES-001` reçoit-il un frontmatter, et ses deux journaux sont-ils réunis ?

L'énoncé existe et ne déclare rien : ni son état, ni son ouverture, ni son identifiant. Le geste appartient à l'humain, le document étant de régime humain.

**Les deux journaux comptent davantage que le frontmatter.** Tant que `2026-08-09-SES-<slug>` reste séparé, l'avancement de `SES-001` s'affiche à dix tâches faites sur trente-cinq, alors qu'il y en a trente-deux. Réunir les deux répertoires corrige la mesure ; le frontmatter ne corrige que l'affichage de l'état.

`NON-028` Q1 porte la migration des cent vingt-six fichiers du format plat.

## Ce qui a été tranché pendant la tâche

| Point | Réponse de l'humain | Ce qui a été fait |
|---|---|---|
| L'état `abandonnee` | « Pas pour l'instant. Ouvrir un `ISU` » | `ISU-011` |
| Le critère de convergence | « Conserver. C'est la responsabilité de l'utilisateur. Ouvrir un `ISU` » | Rubrique rétablie, `ISU-010` |
| La langue des états | « oui, en anglais : todo, opened et closed » | Appliqué, instance migrée |

**`open` est devenu `opened`.** La valeur posée le 2026-08-11 était de moi ; celle-ci est de l'humain.

## Ce que l'agent recommande

**Q1 : afficher telle quelle, avec la ligne `etat` qui dit déjà `closed`.** L'information est là ; la question est de savoir si elle suffit.

**Q2 : réunir les deux journaux avant de renseigner le frontmatter.** Les journaux séparés coûtent une mesure fausse à chaque `clia ses ls` ; le frontmatter absent ne coûte qu'un affichage.

## Relations

- `derive-de` [PLN-008](../plans/PLN-008-chaine-de-session-par-lien-symbolique.md)
- `reference` [NON-037](NON-037-frontiere-et-forme-de-la-session.md)
- `reference` [RES-034](../ressources/RES-034-session.md)
- `reference` [ISU-009](../issues/ISU-009-revision-du-modele-de-frontmatter.md)
