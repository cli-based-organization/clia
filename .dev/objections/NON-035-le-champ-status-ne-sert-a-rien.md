---
type: objection
id: NON-035
title: "Un champ obligatoire universel qui n'a jamais changé de valeur"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-001, RES-026]
---

# NON-035 - Un champ obligatoire universel qui n'a jamais changé de valeur

> `status` vaut `draft` dans les cent cinquante-quatre instances du dépôt. Il est obligatoire pour tous les types, il est le seul état affiché par le CLI, et il n'a jamais rien appris à personne.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 32, avec `ISU-008` et `ISU-009`.
- 2026-08-11 : **les quatre questions répondues par l'humain.** Traitement à la tâche 33 : `DCN-016` enregistre les quatre champs en premier jet suspendu, `PLN-007` ordonne la mise en oeuvre.
- 2026-08-11 : l'effet passe de `bloquant` à `conditionnel`. **L'objection reste ouverte** : la réponse Q2 est conditionnelle et sa condition n'est pas vérifiée.

## Ce qui est contesté

**Un champ obligatoire à valeur unique.** Cent cinquante-quatre instances, cent cinquante-quatre `draft`. Aucune ressource n'est jamais passée à `stable` en trois jours d'usage intensif.

**C'est ce champ que le CLI affiche.** `clia res ls TYPE` produit une colonne `STATUS` dont toutes les cases sont identiques. L'utilisateur qui veut savoir ce qu'il reste à faire doit ouvrir les fichiers un par un.

**Cent seize instances portent un état utile qui n'est jamais montré.** Huit types déclarent un champ propre : `statut`, `etat`, `effet`, `statut-plan`, `statut-decision`, `exploitation`, `tenue`.

**Trente-huit instances n'ont aucun état, ni universel ni propre.** Sept types sont concernés, dont l'analyse avec dix-sept instances et le skill avec sept.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Un principe de conception est violé.** `PDC-001` pose l'auto-découvrabilité : « toute fonction du système doit être découvrable depuis le système lui-même, sans documentation externe ». `RES-012` pose que le non-respect d'un principe est un bogue. L'humain le formule dans les mêmes termes : « cela n'est pas acceptable ».

**La charge est contestée par ailleurs, et ce champ la gonfle sans contrepartie.** `NON-022` conteste depuis le 2026-08-10 la croissance du nombre de champs obligatoires. Elle compte les champs sans relever que l'un d'eux ne transporte rien.

**Le défaut se propage à chaque nouveau type.** Trois types ont été créés depuis le 2026-08-11, `LOG`, `TSK`, `SES`, `ISU` et `REG`. Les cinq portent `status` obligatoire, et aucun ne l'emploiera davantage que les autres.

## Questions

### Q1 - Le CLI doit-il afficher le champ propre plutôt que `status` ?

C'est le correctif le plus immédiat, et il ne touche aucune ressource. La définition de chaque type déclare ses `champs-obligatoires`, où le champ d'état figure.

Il corrige cent seize instances sur cent cinquante-quatre. Les trente-huit autres continueraient d'afficher `draft`.

**Réponse.**

Mon guess est que 'status' avec les 4 valeurs possibles provient de la décision d'être compatible avec le système OKD. Si ce n'est pas le cas, supprimez ce champ.


Ce qu'il faut faire =>
- avoir un champ représentant la maturité: conception, mature, fin-de-vie, obsolète
- avoir un champ représentant l'adoption: proposé, adopté, contesté, obsolète
- avoir un champ qui dit si on doit le considérer ou non: actif/inactif
- et avoir un champ spécifique au cycle de vie métier => status-metier. les valeurs et le sens étant spécifié dans le RES correspondant


Ajouter ces 4 champs dans DCN-004. Proposer un premier jet de DCN

### Q2 - Le champ `status` doit-il subsister ?

Trois positions. Le conserver et l'employer, ce qui suppose que quelqu'un fasse passer des ressources à `stable`. Le rendre facultatif. Le retirer de `commun.cue`, ce qui est une migration sur cent cinquante-quatre instances.

**Réponse.**

Si OKF en a besoin, préserver. Sinon supprimer

### Q3 - Les sept types sans état doivent-ils en recevoir un ?

Analyse, skill, fondation, méthodologie, principe, fait, comportement attendu. Trente-huit instances.

Leur en donner un aggrave la charge que `NON-022` conteste. Ne pas leur en donner laisse le quart du dépôt sans état.

**Réponse.**

oui, refactorer toutes les ressources pour y ajouter:
- maturity
- adoption
- activated: true | false
- domain-status


### Q4 - Les huit champs d'état doivent-ils être unifiés ?

`statut` et `etat` désignent la même chose dans deux types différents. Leurs valeurs ne se comparent pas : `effet: en-vigueur` et `etat: close` ne se rangent pas sur une même échelle.

L'unification demande l'ontologie que `ISU-004` porte.

**Réponse.**

oui, supprimer tout les autres cas de figure autres que celles qui ont été nommés dans ce NON.

## Ce qui lèverait cette objection

**Trois questions sur quatre sont répondues et instruites** par `DCN-016`.

| Question | État |
|---|---|
| Q1, quel champ afficher | **répondue** : quatre champs remplacent l'existant |
| Q2, `status` doit-il subsister | **conditionnelle**, condition non vérifiée |
| Q3, les sept types sans état | **répondue** : oui, refactorer toutes les ressources |
| Q4, unifier les huit champs | **répondue** : oui, supprimer tous les autres |

**Ce qui reste ouvert est Q2.** Sa réponse est « si OKF en a besoin, préserver ; sinon supprimer », et la condition n'a pas pu être vérifiée : deux sources du corpus se contredisent, et la spécification OKF n'est pas consultable sans outil en ligne.

`DCN-015`, créée le même jour, pose que l'implémentation doit être compatible OKF. Elle oriente vers la préservation sans lever la contradiction.

L'effet passe de `bloquant` à `conditionnel` : le correctif est décidé, ordonné par `PLN-007`, et un seul point reste indéterminé.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-026](../ressources/RES-026-code.md)
- `repond-a` [ISU-008](../issues/ISU-008-le-statut-affiche-n-apprend-rien.md)
- `repond-a` [ISU-009](../issues/ISU-009-revision-du-modele-de-frontmatter.md)
- `reference` [NON-022](NON-022-charge-et-tenue-du-type-decision.md)
- `reference` [DCN-016](../decisions/DCN-016-quatre-champs-d-etat-pour-toute-ressource.md)
