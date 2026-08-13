---
type: objection
id: NON-039
title: "Ce que les commandes d'installation laissent ouvert"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [PLN-009, ISU-012]
---

# NON-039 - Ce que les commandes d'installation laissent ouvert

> Cinq commandes ont été demandées, quatre chantiers sont entrés dans `PLN-009`. Trois points en sont sortis : deux appellent une décision de nommage, le troisième appelle un travail entier que `ISU-012` porte.

## Journal

- 2026-08-12 : ouverte par l'agent, tâche 4 de `SES-002`, avec `PLN-009` et `ISU-012`.

## Ce qui est contesté

Trois points, dont deux tiennent en un mot.

**Deux commandes portent le même nom.** La demande énonce :

```sh
clia setup check [PATH]  # peut-on instrumenter ce repo sans impacter l'existant ?
clia setup check [PATH]  # ce repo est-il instrumenté et conforme à la version déclarée ?
```

**Le mot « remote » entre dans le vocabulaire pour désigner ce qui a déjà un nom.** L'exigence 3 du mode développement dit « remote == repo git local dans un répertoire au choix ». Ce dépôt est aujourd'hui `CLIA_HOME`.

**La mise à jour n'a pas d'objet.** Ni version déclarée, ni mécanisme de migration, ni inventaire des changements. `ISU-012` le mesure.

## Pourquoi cela ne peut pas rester implicite

### Sur le double nommage

`PLN-009` retient une lecture et l'applique : **un dépôt est soit instrumenté, soit non**, et les deux questions sont deux cas d'un même diagnostic. Une seule commande peut donc les couvrir.

**Cette lecture est de l'agent, pas de l'humain.** Elle a l'avantage d'un seul verbe à retenir et d'un seul point d'entrée pour le diagnostic. Elle a le défaut de mêler deux intentions d'usage : « puis-je y aller ? » avant l'instrumentation, « où en suis-je ? » après.

**Ce que le choix engage.** Un utilisateur qui tape `clia setup check` sur un dépôt tiers ne sait pas d'avance laquelle des deux réponses il obtiendra. C'est acceptable si la sortie le dit ; c'est trompeur si elle ne le dit pas.

### Sur le mot « remote »

`CLIA_HOME` désigne déjà « où vit `clia` », et `bin/clia` le documente : « Distinct du depot sur lequel on travaille. » Le confondre a produit un bogue, corrigé le 2026-07-31.

**Deux mots pour une chose sont deux occasions de diverger.** Si « remote » désigne autre chose que `CLIA_HOME` — un dépôt distant au sens git, une source de mise à jour — alors c'est une notion neuve et elle mérite d'être définie plutôt que supposée.

### Sur la mise à jour

**Elle porte un critère de convergence de la session** : « la mise à jour de `clia` et la migration des données est 1. possible et 2. facile ». `PLN-009` ne l'atteint pas.

**Le dépôt a déjà migré trois fois sans mécanisme** : l'identifiant à slug vers l'identifiant à séquence, le renommage du répertoire de session, et `open` vers `opened`. Les trois à la main, sans trace réutilisable. La quatrième fois coûtera autant que les trois premières.

## Ce que l'agent a mesuré

| Mesure | Valeur |
|---|---|
| Commandes demandées | 5 |
| Chantiers entrés dans `PLN-009` | **4** |
| Instances du type `SPC` avant ce plan | **0** |
| Dépôts instrumentés déclarant une version | **0** |
| Migrations de données déjà faites à la main | **3** |
| Dépôts de `$HOME/git` portant un `setup.sh` | **10** |
| Parmi eux, examinés pour ce plan | 4 |

## Questions

### Q1 - `check` est-il un verbe ou deux ?

Trois possibilités.

| Option | Ce qu'elle donne |
|---|---|
| Un seul `check` | Le choix de `PLN-009` : un diagnostic qui s'adapte à l'état constaté |
| Deux verbes | Par exemple `check` avant, `status` après. Deux intentions, deux noms |
| Un verbe et une option | `check` et `check --conformite` |

### Q2 - « remote » désigne-t-il `CLIA_HOME`, ou autre chose ?

Si c'est `CLIA_HOME`, le mot n'entre pas dans le vocabulaire. Si c'est autre chose, il faut dire quoi.

### Q3 - La mise à jour attend-elle, ou passe-t-elle avant l'instrumentation ?

`ISU-012` liste quatre livrables. Le premier — un fichier de version dans le dépôt instrumenté — **peut entrer dans le chantier C de `PLN-009` sans le retarder**, et évite d'avoir à le rétro-ajouter à tous les dépôts instrumentés entre-temps.

Les trois autres sont un travail à part entière.

## Ce que l'agent recommande

**Q3 : poser le fichier de version dès maintenant.** C'est cinq lignes dans un chantier déjà prévu, et son absence coûtera une migration de plus.

**Q1 : un seul verbe, avec une sortie qui nomme l'état constaté.** C'est le choix appliqué ; il est réversible tant qu'aucun dépôt tiers n'en dépend.

**Q2 : ne pas introduire « remote ».** `CLIA_HOME` suffit, et la confusion entre les deux racines a déjà produit un bogue.

## Relations

- `derive-de` [PLN-009](../plans/PLN-009-commandes-d-installation-et-d-instrumentation.md)
- `reference` [ISU-012](../issues/ISU-012-la-mise-a-jour-d-un-depot-instrumente-n-a-pas-d-objet.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
