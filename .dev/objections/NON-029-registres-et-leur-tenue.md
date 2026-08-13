---
type: objection
id: NON-029
title: "Les registres, leur catégorie et leur tenue"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [RES-035, REG-001]
---

# NON-029 - Les registres, leur catégorie et leur tenue

> La demande parle d'une « catégorie de ressource » et écrit `REG_TYPE-<SEQ>` ; l'implémentation retient un type unique. Et le seul registre du dépôt est tenu à la main, ce qui en fait la quatrième obligation de propagation sans contrôle.

## Journal

- 2026-08-11 : ouverte par l'agent, à la tâche 28, avec `RES-035` et `REG-001`.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Quatre points.

**La lecture de `REG_TYPE` est une interprétation.** L'énoncé écrit « les registres sont une **catégorie** de ressource » et la syntaxe `REG_TYPE-<SEQ>`. Les deux suggèrent plusieurs types, chacun avec son préfixe. L'implémentation retient un type unique et un champ `registre-de`.

**`REG-001` est tenu à la main.** Son champ `tenue` vaut `saisie`. Toute décision ajoutée, retirée ou changée d'état doit y être reportée, et rien ne le vérifie.

**Le registre des décisions duplique une information qui existe ailleurs.** Chaque ligne reprend le `title` et le `effet` d'une `DCN`. `ANL-001` établit que la duplication non tenue est le mode de défaillance dominant du corpus.

**Un item n'est pas une ressource, et rien ne le dit dans le vocabulaire.** `RES-035` pose qu'un item porte une adresse `REG-001#003`, sur le modèle du recueil de faits. Ni l'un ni l'autre n'est décrit par une ontologie, et `ISU-001` porte la question sans qu'elle soit tranchée.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Un registre faux est pire que pas de registre.** Sa fonction est de donner à voir d'un seul regard. Un registre qui a dérivé donne à voir un état qui n'existe plus, et rien dans sa lecture ne le signale.

**La quatrième obligation de propagation s'ajoute à trois qui ne sont pas tenues.** Les alias par `ADR-008` D3, le remplacement des décisions par `RES-009` R3, et la mise à jour du savoir vers ses ressources générées par `NON-004` Q3. `NON-005` conteste cette accumulation depuis le 2026-08-09.

**Le choix du type unique engage les trois registres à venir.** `PLN-005` chantier D en prévoit trois : dette, bogues, tâches à faire. S'ils devaient avoir des préfixes distincts, il faut le décider avant de les créer, non après.

## Questions

### Q1 - Un registre est-il un type unique ou une catégorie à plusieurs préfixes ?

Trois positions.

Un type unique `REG`, ce que l'implémentation retient. La nature du registre est portée par un champ, et l'outillage existant fonctionne sans modification.

Une catégorie, avec un préfixe par nature : `RDC` pour les décisions, `RDT` pour la dette, `RBG` pour les bogues. Plus lisible dans un alias, et rien ne borne le nombre de préfixes.

Une famille au sens de `ADR-005`, ce qui suppose que les registres partagent un processus et non seulement une structure.

**Réponse.**

### Q2 - `REG-001` doit-il être dérivé plutôt que saisi ?

Le registre des décisions reprend, pour chaque `DCN`, son titre et son champ `effet`. L'information existe deux fois.

Un générateur le régénérerait en une commande. Aucun n'existe, et trois familles de documents en attendent un.

Faut-il attendre le générateur, ou accepter un registre saisi et son risque de dérive ?

**Réponse.**

### Q3 - Que vaut le statut d'un item quand la ressource n'en a pas ?

Trois `DCN` portent des champs `À RENSEIGNER`, et `REG-001` leur attribue le statut `a-renseigner`, qui n'est pas une valeur du champ `effet`.

C'est un constat du registre, non une reprise. Un registre qui invente des valeurs de statut cesse d'être une vue.

Faut-il une énumération de statuts propre au registre, ou l'interdiction d'inventer, avec un statut vide quand la ressource n'en déclare pas ?

**Réponse.**

### Q4 - Un item de registre est-il une ressource ?

`RES-035` pose qu'un item porte une adresse `REG-001#003` et n'a pas de frontmatter. C'est une entrée, comme un fait dans un recueil.

`ISU-001` demande comment définir une ressource dans un document ressource. Le registre emploie le mécanisme sans que la question soit tranchée : si un item devenait une ressource de plein droit, `REG-001` compterait pour quatorze ressources et non pour une.

**Réponse.**

### Q5 - Les trois registres restants sont-ils créés maintenant ?

`NON-004` Q4 demande un registre de dette, un de bogues et un de tâches à faire. `PLN-005` chantier D les porte. La tâche 28 n'en demande qu'un.

La matière du registre de dette existe déjà : la rubrique `dette_nommee` de chaque log `next`, tenue depuis la tâche 13.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 engage les trois registres à venir. Q2 décide si le registre est une vue fiable ou une copie qui dérive.

L'effet est `conditionnel` : `REG-001` est utilisable, l'outillage fonctionne, et rien de ce qui existe n'est invalidé.

## Relations

- `objecte-a` [RES-035](../ressources/RES-035-registre.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
- `reference` [ISU-001](../issues/ISU-001-definir-une-ressource-dans-un-document-ressource.md)
