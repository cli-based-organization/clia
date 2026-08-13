---
type: objection
id: NON-022
title: "Charge du type Décision et tenue de son champ effet"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [RES-009, MET-002]
---

# NON-022 - Charge du type Décision et tenue de son champ effet

> `RES-009` v0.2.0 ajoute deux champs obligatoires et une section au nom d'une fondation dont l'un des sept apports établit que la charge documentaire est la cause mesurée d'abandon de ce type de document. Et le contrôle qui devait rendre le nouveau mécanisme vérifiable n'existe pas.

## Journal

- 2026-08-10 : ouverte par l'agent, à la tâche 14, dans le mouvement même qui alourdit le type.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Deux choses, liées par une même cause : `RES-009` v0.2.0 promet plus qu'il n'outille.

### La charge augmente au nom d'une source qui dit de ne pas l'augmenter

`FND-003` établit, par l'étude d'adoption de Rösch et al., que le raisonnement architectural est rarement consigné en raison de la tension entre la charge documentaire et le rythme de développement, et que les équipes privilégient des structures simples et faciles à maintenir. Son apport 7 en tire la conséquence : le nombre de champs obligatoires de `RES-009` est un risque d'abandon, non un gage de rigueur.

Le même document produit six autres apports, dont deux ajoutent un champ.

| Version | Champs obligatoires | Sections | Contrôles outillés |
|---|---|---|---|
| v0.1.0 | 9 | 7 | schéma de frontmatter |
| v0.2.0 | 11 | 8 | schéma de frontmatter |

L'exigence a crû de 22 pour cent, l'outillage de zéro.

### Le contrôle central du nouveau mécanisme n'existe pas

`RES-009` R3 pose que `effet: remplacee` est dérivable : une décision est remplacée si et seulement si une autre déclare `remplace` vers elle. C'est ce qui devait distinguer le nouveau mécanisme de l'ancien, dont `FND-003` établit qu'il échoue parce que personne ne met le champ à jour.

Or la dérivation n'est pas implémentée. `MET-002` étape 6 spécifie le contrôle en toutes lettres et déclare qu'il n'existe dans aucun outil au 2026-08-10.

Tant qu'il n'existe pas, le report reste manuel. Le mécanisme neuf a donc, en pratique, exactement le défaut de l'ancien, avec un document de plus pour l'expliquer.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**C'est la cinquième règle écrite et non tenue de cette session.** `next-task-13.yaml` en recensait quatre : le test de `ADR-006` D4 qui échoue, l'agnosticisme de `ADR-006` D2 violé par `ADR-001` D2, le contrôle manuel des harnais de `PDC-001` qui échoue sur `CLAUDE.md`, et l'interdiction de renuméroter de `ADR-007` D2 que rien ne vérifie. `NON-005` conteste cette accumulation depuis le 2026-08-09. Celle-ci est la cinquième en deux jours.

**Le dépôt est déjà dans la zone d'abandon mesurée.** Rösch et al. mesurent qu'environ la moitié des dépôts observés s'arrêtent entre un et cinq enregistrements. Ce dépôt en compte sept, tous produits en deux jours, tous internes, aucun n'ayant jamais été relu ni remplacé. Rien n'établit encore que le type sera employé au-delà de la session qui l'a créé.

**L'argument d'atténuation est faible et il faut le dire.** L'analyse de la tâche 14 justifie les deux champs par le fait qu'ils sont énumérés, courts, et pourvus d'un défaut évident pour une décision interne. C'est vrai, et c'est exactement ce qu'on dit de tout champ qu'on ajoute. Neuf champs ont été ajoutés à ce dépôt avec le même argument.

## Questions

### Q1 - Onze champs obligatoires sont-ils tenables ?

Trois positions.

Les conserver, et mesurer : le dépôt saura dans quelques semaines si le type est encore employé.

Rendre `attestation` et `diffusion` facultatifs avec un défaut déclaré, ce qui réduit la saisie et affaiblit la garantie. Pour `diffusion`, l'affaiblissement porte sur un régime de confidentialité, ce qui est le pire endroit où l'accepter.

Retirer autre chose en compensation. Le candidat est `version` : aucune `DCN` du dépôt n'a jamais dépassé `0.1.0`, et la teneur d'une décision étant immuable, il n'est pas évident que ce type ait besoin d'un numéro de version. C'est la position qui respecte le mieux l'apport 7, et elle touche un champ commun à tous les types.

**Réponse.**

### Q2 - Qui met `effet` à jour tant que la dérivation n'est pas outillée ?

Le champ appartient à l'humain seul, sauf pour la valeur `remplacee` qui est dérivée. Tant que rien ne dérive, la valeur `remplacee` n'a pas de propriétaire déclaré.

Faut-il autoriser l'agent à la reporter lorsqu'il produit la `DCN` qui remplace, ce qui est le geste naturel et contredit la propriété humaine du champ ? Ou laisser le champ faux jusqu'à ce que l'outil existe, ce qui est cohérent et laisse le dépôt dans un état incorrect ?

**Réponse.**

### Q3 - Le contrôle de dérivation doit-il être implémenté avant d'employer le mécanisme ?

Le contrôle est spécifié dans `MET-002` étape 6 et il est simple : comparer l'ensemble des cibles des relations `remplace` à l'ensemble des `DCN` portant `effet: remplacee`.

Il rejoint la liste des contrôles réclamés depuis trois jours sous le nom de `clia validate`, que `next-task-13.yaml` désigne comme le travail le plus rentable. Faut-il conditionner l'emploi de R1 à R3 à son existence, ou accepter un intervalle où la règle est écrite et non tenue ?

**Réponse.**

### Q4 - La section « Motivation du changement » doit-elle exister quand rien n'est remplacé ?

`RES-009` exige la section dans toutes les `DCN`, avec la ligne `Sans objet, cette décision n'en remplace aucune` lorsque c'est le cas. L'argument est qu'une section absente ne se distingue pas d'un oubli.

Le coût est réel : sept des sept `DCN` du dépôt porteraient une section vide, et la huitième aussi, jusqu'au premier revirement. Une section que le corpus porte à cent pour cent en formule creuse est un candidat sérieux à la dérive, exactement comme les champs mesurés par `ANL-001`.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q3.

Q1 fixe le coût du type. Q3 fixe si le mécanisme neuf est vérifiable ou seulement écrit.

L'effet est `conditionnel` : les sept `DCN` du dépôt sont migrées et valides, et `RES-009` v0.2.0 est applicable tel quel. Ce qui est en cause est sa tenue dans le temps, qui ne se constatera pas avant plusieurs semaines.

## Relations

- `objecte-a` [RES-009](../ressources/RES-009-decision.md)
- `objecte-a` [MET-002](../methodologies/MET-002-enregistrement-et-suivi-d-une-decision.md)
- `reference` [FND-003](../fondations/FND-003-decisions-institutionnelles-tracables.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
