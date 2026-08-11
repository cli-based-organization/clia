# Demande interprétée, tâche 28

Écrit le 2026-08-11 à 14:51, avant toute exploration. `MET-003` étape 1.

## Énoncé

Tâche 28, `[implémentation]` : registres et outillage.

> Les registres sont une catégorie de ressource qui permet de contenir une liste de ressources.
>
> Créer, si elle n'existe pas déjà, un registre des décisions.
>
> Et ajouter une classe de commandes pour instrumenter les registres.

```sh
clia registre|reg CMD [OPTIONS...] [ARGS...]

clia reg ls                       # donner la liste des registres
clia reg ls REG_TYPE-<SEQ>        # les items => SEQ RESSOURCE_ALIAS description status

clia reg show|edit REG_TYPE-<SEQ> SEQ
```

## Ce que je sais avant d'explorer

`PLN-005` chantier D prévoit le type registre et trois instances, demandées par la réponse Q4 de `NON-004` : dette, bogues, tâches à faire prochainement.

La tâche 28 en demande une quatrième, le **registre des décisions**, et surtout l'**outillage**, que le plan ne portait pas.

## Une ambiguïté à trancher : REG_TYPE

La syntaxe écrit `REG_TYPE-<SEQ>`. Deux lectures.

**(a) `REG_TYPE` est un placeholder pour le préfixe d'un type de registre.** Chaque catégorie de registre aurait son préfixe : un pour les décisions, un pour la dette, un pour les bogues. Le mot « catégorie » dans l'énoncé va dans ce sens.

**(b) `REG_TYPE` désigne le préfixe `REG`, et `<SEQ>` le numéro de l'instance.** Un seul type, plusieurs instances : `REG-001` pour les décisions, `REG-002` pour la dette.

**Lecture retenue : (b).** Elle suit la convention du dépôt, un type égale un préfixe, et elle fonctionne avec l'outillage existant sans inventer de préfixes. L'ambiguïté est signalée et portée par une objection.

## Ce qu'un registre pose comme question de fond

Un registre des décisions est une **vue** sur des ressources qui existent déjà. Deux régimes sont possibles.

**Saisi.** Le registre est un document tenu à la main. Il dérive au premier oubli, ce que `ANL-001` mesure sur d'autres champs.

**Dérivé.** Le registre est régénéré depuis les ressources qu'il liste. Rien ne dérive dans ce dépôt, et trois familles de documents attendent déjà un générateur.

La demande ne tranche pas. J'interprète, je signale.

## Ressources livrables

| Livrable | Nature |
|---|---|
| `RES-035`, le type registre | Création |
| Artefacts dérivés | Création |
| `REG-001`, registre des décisions | Création |
| `lib/clia/registre.sh` | Création, quatre verbes |
| `bin/clia` | Modification, dispatch |
| `tests/test_clia.sh` | Modification |
| Une objection | Création |

## Ce que je vérifierai avant de produire

Si un registre existe déjà sous une autre forme. L'énoncé dit « si elle n'existe pas déjà ».
