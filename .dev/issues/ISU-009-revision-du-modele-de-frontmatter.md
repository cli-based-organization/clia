---
type: issue
id: ISU-009
title: "Révision du modèle de frontmatter"
status: draft
initiateur: humain
etat: ouverte
ouverture: 2026-08-11
---

# ISU-009 - Révision du modèle de frontmatter

> Un champ obligatoire universel qui n'a jamais changé de valeur, huit champs d'état propres qui ne se comparent pas, sept types sans aucun état, et une contestation de la charge ouverte depuis quatre jours.

## Journal

- 2026-08-11 : ouverte à la demande de l'humain, tâche 32.

## La problématique

`ISU-008` établit qu'un champ obligatoire ne sert à rien. La question plus large est celle du modèle qui l'a produit.

Quatre constats se croisent.

**Un champ universel inutile.** `status` vaut `draft` dans les cent cinquante-quatre instances du dépôt. Il est obligatoire pour tous les types par `commun.cue`.

**Huit champs d'état concurrents.** `statut`, `etat`, `effet`, `statut-plan`, `statut-decision`, `exploitation`, `tenue`, et `etat` encore pour l'issue et la tâche. Ils ne se comparent pas entre eux.

**Sept types sans aucun état.** Analyse, skill, fondation, méthodologie, principe, fait, comportement attendu. Trente-huit instances.

**Une charge contestée.** `NON-022` conteste depuis le 2026-08-10 la croissance du nombre de champs obligatoires, mesurée à vingt-deux pour cent sur un seul type.

## Ce qui la rend difficile

**Le modèle est appliqué à cent cinquante-quatre instances.** Tout changement de `commun.cue` les touche toutes.

**Aucun générateur n'existe.** Les soixante-deux schémas portent « Généré depuis RES-xyz. Ne pas éditer à la main », et rien ne les génère. `ISU-002` le porte.

**La charge et l'information tirent en sens contraires.** `NON-022` demande moins de champs ; `ISU-008` demande un champ qui informe. Ajouter un champ d'état aux sept types qui n'en ont pas aggrave la charge.

**Deux natures d'état se confondent.** La maturité d'un document, `draft` ou `stable`, et l'avancement du travail, `ouverte` ou `close`. Le modèle traite la première comme universelle et la seconde comme propre au type, sans que ce partage soit décidé nulle part.

**Le vocabulaire est incohérent.** `statut` et `etat` désignent la même chose dans deux types différents, et `NON-004` Q2 demande une ontologie qui n'existe pas.

## Ce qui a été tenté

**Le champ `status` vient du modèle initial du 2026-08-09**, repris de `RES-001` de `micrologic-clients`. Aucune décision ne l'a jamais réexaminé.

**Les champs propres ont été ajoutés type par type**, à mesure que chaque définition était écrite. Aucun ne dérive d'un modèle commun.

**`NON-022` a mesuré la charge** sans relever qu'un des champs comptés ne sert à rien.

## Pistes

**P1. Distinguer explicitement deux natures d'état.** Un champ de maturité documentaire, un champ d'avancement du travail. Les deux universels, et les champs propres deviennent des raffinements.

**P2. Rendre `status` facultatif.** Il subsiste pour les types où la maturité compte, disparaît ailleurs. Le moins coûteux ; il laisse les sept types sans état.

**P3. Unifier le vocabulaire.** Un seul nom pour l'état de travail, quel que soit le type. Demande l'ontologie que `ISU-004` porte.

**P4. Déclarer le champ d'état dans la définition du type.** Un champ `champ-etat` dans chaque `RES` dirait lequel fait foi. Rend le modèle explicite au prix d'un champ de plus sur trente-six définitions.

**P5. Ne rien changer avant le générateur.** Toute révision touche soixante-deux schémas qu'aucun outil ne régénère. `ISU-002` d'abord.

**P6. Mesurer avant de décider.** Aucune mesure n'existe du coût réel de saisie d'un champ, ni du taux de champs jamais renseignés. `NON-022` conteste une charge sans la chiffrer autrement qu'en nombre de champs.

## Ce qui la clôturerait

Une décision sur le partage entre l'universel et le propre au type.

La question du vocabulaire peut rester ouverte : elle relève de l'ontologie, portée par `ISU-004`.

## Relations

- `objecte-a` [NON-035](../objections/NON-035-le-champ-status-ne-sert-a-rien.md)
- `reference` [ISU-008](ISU-008-le-statut-affiche-n-apprend-rien.md)
- `reference` [ISU-002](ISU-002-aucun-generateur-de-ressources-derivees.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
