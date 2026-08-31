---
type: usage
version: 0.1.1
title: "Créer un dépôt neuf déjà équipé du système d'augmentation"
status: proposé
date: 2026-07-29
acteur-principal: ACT-003
niveau: but-utilisateur
---

# USE-002 - Créer un dépôt neuf déjà équipé du système d'augmentation

## En-tête

- **Portée** : le système d'augmentation et le dépôt cible, considérés comme boîte noire.
- **Parties prenantes et intérêts** : [`ACT-001`](../acteurs/ACT-001-operateur-du-depot.md), qui travaillera dans le dépôt créé et veut pouvoir commencer immédiatement ; [`ACT-010`](../acteurs/ACT-010-organisation-commanditaire.md), dont l'intérêt de réutilisabilité se mesure ici, au coût d'équipement d'un dépôt neuf.
- **Préconditions** : l'outil d'augmentation est disponible sur le poste ([`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md)) ; l'acteur dispose d'un droit d'écriture à l'emplacement visé.
- **Garantie de succès** : à l'emplacement visé existe un dépôt versionné, neuf, contenant le système d'augmentation générique et rien du contenu de conception propre au dépôt d'origine ; l'acteur peut y ouvrir une première séance de travail sans étape supplémentaire.
- **Garantie minimale** : en cas d'échec, l'emplacement visé n'est pas laissé à moitié équipé : soit il est inchangé, soit ce qui a été posé est identifiable et retirable.

## Flux nominal

1. L'acteur désigne l'emplacement du dépôt à créer, soit par son nom, soit en désignant le répertoire courant.
2. Le système vérifie que l'emplacement est utilisable et qu'aucun dépôt équipé ne s'y trouve déjà.
3. Le système crée le dépôt versionné à cet emplacement.
4. Le système y matérialise le système d'augmentation générique : fichiers de harnais, compétences, gabarits, couche type, et les répertoires de ressources vides prêts à recevoir la conception propre au nouveau dépôt.
5. Le système enregistre dans le dépôt la **version du système d'augmentation** qui vient d'y être posée.
6. Le système rend compte de ce qui a été créé.
7. L'acteur ouvre sa première séance de travail dans le dépôt.

## Flux alternatifs et d'échec

- **2a. L'emplacement contient déjà un dépôt versionné, non équipé** : le parcours se poursuit sans recréer le dépôt ; seuls les pas 4 et 5 s'appliquent.
- **2b. L'emplacement contient déjà un dépôt équipé** : le système refuse et oriente vers le parcours de mise à niveau ([`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md)). Aucune écriture.
- **2c. L'emplacement existe et n'est pas vide** : le système refuse plutôt que de mêler ses fichiers à un contenu inconnu, sauf demande explicite de l'acteur.
- **4a. L'écriture échoue en cours de route** : le système s'arrête, signale l'échec et laisse l'emplacement dans un état identifiable ; il ne prétend pas avoir réussi.
- **5a. La version du système d'augmentation posé n'est pas déterminable** : le parcours échoue avant d'écrire quoi que ce soit, faute de pouvoir garantir que les parcours [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md) et [`USE-005`](USE-005-ramener-un-depot-a-une-version-anterieure.md) sauront d'où ils partent.

## Critères d'acceptation

- Après le parcours, l'emplacement visé est un dépôt versionné contenant les fichiers de harnais, les compétences, les gabarits et la couche type.
- Aucune ressource de conception propre au dépôt d'origine n'est présente dans le dépôt créé ; les répertoires de ressources y sont vides.
- Le dépôt créé porte, de façon lisible, la version du système d'augmentation qui y a été posée.
- Une première séance de travail peut y être ouverte sans étape manuelle supplémentaire.
- Sur un emplacement déjà équipé, le parcours refuse et n'écrit rien.
- En cas d'échec en cours d'écriture, aucun état intermédiaire n'est présenté comme un succès.

## Relations

- **Acteur** : [`ACT-003`](../acteurs/ACT-003-installateur.md) utilise ce parcours pour équiper un dépôt neuf.
- **Suppose** : [`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md).
- **Satisfait par** : [`REQ-003`](../requis/REQ-003-installation-et-extension.md) (F10 à F17) pour la matérialisation, et [`REQ-002`](../requis/REQ-002-cli-clia.md) (F13, F15, F16) pour la commande qui l'expose. Spécifié par [`SPEC-004`](../specs/SPEC-004-script-amorcage-et-extension.md) et [`SPEC-002`](../specs/SPEC-002-cli-clia.md), groupe `setup`. Cadre décidé par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (D5, D6, D8, D9) et [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md) (D3).
- **Source** : cas d'usage 2 de la tâche 38 de `.dev/session.md`.
