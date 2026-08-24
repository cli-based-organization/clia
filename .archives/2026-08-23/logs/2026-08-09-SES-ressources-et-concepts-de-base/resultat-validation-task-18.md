# Résultat de la validation, tâche 18

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma, les sept fichiers touchés | **7 sur 7 conformes** |
| Schéma, dépôt entier | **97 conformes, 2 non conformes** |
| Sections déclarées et présentes, documents créés | **0 manquante** |
| Liens relatifs | **0 cassé** |
| Rubriques méta dans les quatre documents créés | **0** |
| Fichiers renommés | **0** |
| `FRG-001` et les blocs de réponse de l'humain | **intacts** |
| Tests du CLI | **91 réussis, 0 échoué** |

## Fidélité aux réponses

Contrôles 1 à 5.

Les douze réponses sont reportées dans `DCN-008` dans le texte de l'humain, entre guillemets, sans reformulation. Les fautes de frappe du texte source sont conservées.

`FRG-001` n'est pas modifié, y compris ses deux phrases interrompues aux lignes 42 et 84. Le fichier appartient à l'humain, et son champ `exploitation` reste à `À RENSEIGNER`.

Les blocs de réponse de `NON-001` ne sont pas touchés. Seuls le frontmatter, le journal, la section « Ce qui lèverait cette objection » et les relations sont modifiés, tous appartenant à l'agent selon le régime hybride de `RES-004`.

La réponse Q10 est enregistrée comme orientation par `ADR-008` D7, avec la citation de son auteur : « C'est une question complexe pour laquelle je n'ai pas de solution définitive. »

## Périmètre de l'abrogation

Contrôles 6 à 9.

Relecture des cinq décisions de `ADR-007`, une par une.

| Décision | Sort | Vérification |
|---|---|---|
| D1 | abrogée | Contredite par Q1 et Q4 |
| D2 | abrogée | Son motif écrit, « c'est ce qui rend D1 possible », dépend de D1 |
| D3 | subsiste | Confirmée par Q6 et Q12 |
| D4 | subsiste | Aucune réponse ne la touche |
| D5 | subsiste | Confirmée par Q4 |

La relation employée vers `ADR-007` est `reference`. `remplace` ferait disparaître trois décisions en vigueur.

`DCN-007` conserve `effet: en-vigueur`.

## Propagation

Contrôles 10 à 13. Recherche dans le dépôt actif, hors archives et journaux, de toute affirmation portant la position abrogée.

| Document | Traitement |
|---|---|
| `skl-001` A2 | **Corrigé.** Harnais actif qui commandait à l'agent que l'identité n'est jamais modifiée |
| `.dev/ressources/index.md` | **Corrigé.** Portait encore `<PREFIXE>-<SLUG>`, périmé depuis la tâche 13 |
| `RES-001` | **Corrigé.** Section « Identité », invariant I1, versionnage |
| `ADR-007` | **Annoté.** Avertissement d'abrogation partielle en tête, marque sur D1 et D2 |
| `DCN-007` | **Non corrigé.** Une décision enregistrée ne se réécrit pas |
| `FND-003` étape 6 | **Non corrigé.** Point fixe qui rapporte l'état de son jour |

Aucun fichier renommé, aucun renvoi réécrit. `git status` ne porte aucune ligne `R`.

## Mesure recalculée

Contrôles 19 et 20. Le premier comptage, fait par `grep` sur les lignes `id:`, incluait des gabarits et des citations de journaux. Le recalcul filtre archives, gabarits et journaux.

| Longueur | Alias | Écart avec le premier comptage |
|---|---|---|
| 7 caractères | **92** | +1 |
| 10 caractères | **7** | -1 |
| **Total** | **99** | inchangé |

`PDC-002` et `fait-task-18.md` sont corrigés avec les valeurs recalculées.

## Forme

Contrôles 14 à 18.

`RES-001` passe de `1.0.0` à `2.0.0`. Le bump majeur suit ses propres règles de semver : « changement incompatible du sens ou du contrat ». L'identité change de nature.

`RES-001` conserve deux rubriques méta, `Statut de ce document` et `Auto-application`, et une section déclarée manquante, `Frontmatter`, portée sous le titre « Frontmatter d'une définition de type ». Les trois écarts sont **antérieurs à cette tâche** et relèvent du chantier D de `PLN-002`, non engagé.

Les quatre documents créés portent zéro rubrique méta.

## Ce que la validation a corrigé dans le journal

Une affirmation fausse a été écrite puis corrigée : `NON-001` n'était pas la seule objection bloquante du dépôt.

| État | Valeur |
|---|---|
| Objections bloquantes avant la tâche | 7 |
| Objections bloquantes après | **6** |
| Objections répondues, sur 22 | **1** |

Les six qui subsistent : `NON-002`, `NON-005`, `NON-009`, `NON-014`, `NON-017`, `NON-018`.

**`NON-014` porte sur le même sujet que l'objection levée**, le trilemme de nommage, et n'a pas été relue à cette occasion. Elle pourrait être partiellement répondue par `ADR-008`.

## Ce que la validation n'établit pas

**Rien ne vérifie la propagation d'un changement d'alias.** `ADR-008` D3 en fait une obligation. La commande n'existe pas, le contrôle non plus.

**L'identité de l'oeuvre n'a pas de porteur.** `RES-001` le déclare et renvoie à `NON-023` Q1. Le dépôt ne peut donc pas reconnaître deux copies d'une même oeuvre.

**Le remplacement partiel reste non modélisé.** Le traitement retenu, une annotation dans le texte, fonctionne pour un lecteur humain et n'est lisible par aucun outil.
