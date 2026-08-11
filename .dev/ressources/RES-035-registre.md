---
type: ressource
id: RES-035
title: "Registre"
status: draft
version: 0.1.0
prefixe: REG
emplacement: ".dev/registres/REG-<SEQ>-<SLUG>.md"
cycle-de-vie: travail
edition: hybride
famille: preparation
champs-obligatoires: [type, id, title, status, registre-de, tenue]
relations-admissibles: [registre, ressource, decision, objection, issue, tache]
sections: [Objet, Portée, Items, Ce que le registre ne contient pas, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-035 - Registre

> Un registre contient une **liste de ressources** d'une même nature, chacune avec son alias, une description courte et un statut. Il ne porte aucun contenu propre : c'est une vue.

## Objet

Ce document définit le type `registre`. Sa fonction est de rendre visible d'un seul regard un ensemble de ressources dispersées.

## Ce qu'est un registre

Une ressource de travail qui porte une table d'items. Chaque item désigne une ressource.

| Colonne | Contenu |
|---|---|
| `SEQ` | Numéro de l'item dans le registre, sur trois chiffres |
| `RESSOURCE` | L'alias de la ressource désignée, `<PREFIX>-<SEQ>` |
| `DESCRIPTION` | Une ligne, sans retour |
| `STATUS` | L'état de la ressource, tel que le registre le déclare |

Un item porte une adresse citable de la forme `REG-001#003`, sur le modèle du recueil de faits de `RES-005`.

## Ce qu'un registre n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **collection** | Un registre ne contient pas les ressources, il les désigne |
| Un **index** | L'index d'un répertoire liste ce qu'il contient. Un registre rassemble des ressources qui peuvent vivre n'importe où |
| Un **plan** | Le plan ordonne des chantiers et déclare des dépendances. Le registre énumère |
| Une **issue** | L'issue porte une problématique. Un registre de bogues porte des renvois vers des issues |

**Un registre ne porte aucun contenu propre.** Ce qu'il dit d'une ressource est repris de cette ressource, jamais élaboré.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `registre-de` | Texte libre | La nature de ce qui est registré : décisions, dette, bogues, tâches à faire |
| `tenue` | `saisie`, `derivee` | Comment le registre est mis à jour |

### Le champ tenue

C'est le champ qui décide de la valeur du registre.

| Valeur | Ce qu'elle affirme | Risque |
|---|---|---|
| `saisie` | Le registre est tenu à la main | Dérive au premier oubli |
| `derivee` | Le registre est régénéré depuis les ressources qu'il liste | Aucun, si le générateur existe |

Un registre `saisie` est une obligation de propagation de plus : toute ressource ajoutée, retirée ou changée d'état doit être reportée. `ANL-001` mesure ce que devient une information tenue à la main.

## Test d'admission

Un registre est produit si les deux conditions sont réunies.

1. Les ressources à registrer sont **dispersées**, et rien ne permet de les voir ensemble.
2. Leur nombre justifie une vue : en dessous de trois, une liste dans un document existant suffit.

## Cycle de vie et versionnage

`travail`. Un registre a une histoire, pas des versions. Il ne porte pas de champ `version`.

Un item retiré n'est pas supprimé : son statut passe à `retire`, et son numéro n'est jamais réattribué.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| La table d'items | Les deux, en append |
| Le statut d'un item | Celui qui possède la ressource désignée |
| Le champ `tenue` | L'humain seul |

**Un registre de décisions n'est pas une décision.** Il désigne des `DCN` sans en porter la teneur, donc `CONSTITUTION.md` C1 ne s'y applique pas. Un agent peut le tenir ; il ne peut pas changer l'état d'une décision par ce moyen.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `PLN` | Énumérer contre ordonner |
| `ISU` | Désigner contre porter une problématique |
| `FCT` | Des renvois contre des énoncés établis |
| Un index de répertoire | Ce qui est dispersé contre ce qui est au même endroit |

## Structure attendue d'une instance

```
# REG-<SEQ> - <Titre>

> Ce que le registre rassemble, en une phrase.

## Objet
## Portée
## Items

| SEQ | RESSOURCE | DESCRIPTION | STATUS |
|---|---|---|---|
| 001 | DCN-001 | ... | en-vigueur |

## Ce que le registre ne contient pas
## Relations
```

La rubrique « Ce que le registre ne contient pas » est obligatoire. Un registre lu comme exhaustif alors qu'il ne l'est pas est pire que pas de registre.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-005](RES-005-fait.md)
- `reference` [RES-025](RES-025-plan.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un registre est-il un type unique ou une catégorie à plusieurs préfixes | `NON-029` |
| Un registre `saisie` est-il tenable sans contrôle | `NON-029` |
| Qui régénère un registre `derivee`, et quand | `NON-029` |
