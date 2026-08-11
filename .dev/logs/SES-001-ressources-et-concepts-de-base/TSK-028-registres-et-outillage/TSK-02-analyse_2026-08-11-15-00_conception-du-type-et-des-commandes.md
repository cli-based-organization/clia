# Analyse avant réalisation, tâche 28

Écrite après l'exploration, avant le premier livrable. `MET-003` étape 2.

## Ce que l'exploration a établi

Aucun registre n'existe. Pas de répertoire `.dev/registres`, pas de type, pas de schéma. La condition « si elle n'existe pas déjà » est donc sans effet : tout est à créer.

## L'ambiguïté de REG_TYPE, et ce qui la tranche

La syntaxe de la demande écrit `REG_TYPE-<SEQ>`. Deux lectures étaient possibles, et le mot « catégorie » de l'énoncé penchait pour la première.

**Retenue : un type unique `REG`, plusieurs instances.** Trois raisons.

Le dépôt associe un préfixe à un type, sans exception. Inventer un préfixe par nature de registre créerait une famille de préfixes que rien ne borne.

L'outillage existant fonctionne sans modification : `clia res ls registre`, `clia res new registre` marchent dès la définition écrite.

Ce qui distingue les registres est porté par un champ, `registre-de`, et non par le préfixe. Un registre des décisions et un registre de dette ont la même structure.

L'ambiguïté est signalée et portée par `NON-029`.

## Le champ qui décide de la valeur d'un registre

Un registre est une **vue** sur des ressources qui existent ailleurs. Il ne porte aucun contenu propre.

Deux régimes sont possibles, et le choix n'est pas neutre.

| `tenue` | Ce que cela implique |
|---|---|
| `saisie` | Tenu à la main. Dérive au premier oubli |
| `derivee` | Régénéré depuis les ressources listées. Demande un générateur |

`ANL-001` mesure ce que devient une information tenue à la main : `completed` dans cinquante-deux logs et `complet` dans deux du même dépôt.

**Le champ `tenue` est donc obligatoire.** Un registre qui ne déclare pas son régime laisse croire qu'il est à jour.

`REG-001` vaut `saisie`, faute de générateur. C'est la quatrième obligation de propagation non outillée du dépôt.

## Ce que show et edit doivent faire d'un item

Un item n'a pas de contenu propre : c'est une ligne de tableau qui pointe vers une ressource.

| Verbe | Ce qu'il fait | Motif |
|---|---|---|
| `show` | Affiche l'item, puis la ressource désignée | L'item seul n'apprend rien de plus que `reg ls` |
| `edit` | Ouvre la **ressource désignée** | Éditer une ligne de tableau n'a pas d'intérêt |

**Conséquence déclarée dans l'aide.** Pour corriger la description ou le statut d'un item, on édite le registre lui-même par `clia res edit REG-001`.

## La lecture du tableau, et le piège qu'elle évite

Les items vivent dans une table markdown sous la rubrique `Items`.

Un analyseur naïf compterait les lignes et sauterait les deux premières, l'en-tête et le séparateur. Il casserait dès qu'une ligne vide ou un commentaire s'intercale.

**Le filtre retenu.** Une ligne de données est reconnue à son premier champ : un numéro sur exactement trois chiffres. L'en-tête porte `SEQ`, le séparateur porte des tirets ; ni l'un ni l'autre ne passe.

Un test vérifie explicitement que le séparateur n'est pas pris pour un item.

## Ce que ce type recoupe

**`ISU-001`**, ouverte à la tâche 26 : définir une ressource dans un document ressource. Un item de registre est le même problème, et il est résolu ici par le mécanisme du recueil de faits, `REG-001#003`, qui donne une adresse sans donner de frontmatter.

Un item n'est donc **pas** une ressource de plein droit. C'est une entrée, comme un fait dans un recueil.

**`PLN-005` chantier D**, qui prévoyait le type registre et trois instances demandées par `NON-004` Q4 : dette, bogues, tâches à faire. La tâche 28 en demande une quatrième et l'outillage que le plan ne portait pas.

## Ce que je ne ferai pas

**Les trois autres registres.** La demande n'en réclame qu'un, celui des décisions. Les trois autres restent au chantier D de `PLN-005`.

**Rendre `REG-001` dérivé.** Aucun générateur n'existe, et trois familles de documents en attendent un depuis trois jours.
