---
type: requis
version: 0.1.0
title: "Requis du script d'amorçage et du contrat d'extension"
date: 2026-07-29
---

# REQ-003 - Requis du script d'amorçage et du contrat d'extension

- **Sources** : [`PLN-018`](../plans/PLN-018-preparation-installation-outil-et-depot.md) étape 2.1, [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (D1, D2, D6, D8), [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md), [`ADR-014`](../adr/ADR-014-contrat-extension-outil.md), [`ANL-002`](../analyses/ANL-002-setup-installation.md)
- **Convention de priorité** : MUST | SHOULD | MAY

## Objet et périmètre

Exigences du **script d'amorçage** `setup.sh` (couche 1 d'[`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md)) et du **contrat d'extension** qu'il implémente ([`ADR-014`](../adr/ADR-014-contrat-extension-outil.md)). Le script hérite de [`REQ-001`](REQ-001-convention-cli-bash.md). Hors périmètre : les commandes de l'outil qui l'invoquent (voir [`REQ-002`](REQ-002-cli-clia.md)), et les parcours de mise à niveau et de retour en arrière.

**Usages satisfaits** : [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) intégralement ; [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) pour leur part exécutée par le script.

## Exigences fonctionnelles

### Couche 1 : rendre l'outil disponible (`USE-001`)

- **REQ-003-F1** (MUST) : `setup.sh install` rend l'outil appelable par son nom depuis n'importe quel répertoire, dans toute nouvelle session de shell, en écrivant un bloc dans la configuration de shell de l'utilisateur courant.
  - Vérification : après `install` et ouverture d'une nouvelle session, `command -v clia` réussit depuis un répertoire arbitraire.
- **REQ-003-F2** (MUST) : le bloc écrit est délimité par un **marqueur d'ouverture et un marqueur de fermeture** explicites, permettant de l'identifier et de le retirer sans ambiguïté.
  - Vérification : le fichier de configuration contient exactement une paire de marqueurs après une ou plusieurs installations.
- **REQ-003-F3** (MUST) : l'installation est **idempotente et réconciliante**. Réexécutée depuis le même arbre source, elle n'écrit rien et réussit. Réexécutée depuis un arbre source différent, elle **met à jour** le bloc et le signale, au lieu de déclarer l'opération déjà faite.
  - Vérification : deux exécutions successives depuis la même racine laissent le fichier inchangé ; une exécution depuis une racine déplacée met le bloc à jour.
- **REQ-003-F4** (MUST) : l'exécution en mode **dev** : le rattachement pointe vers l'arbre source, sans copie ni construction. Une modification de l'arbre source est immédiatement effective.
  - Vérification : modifier un fichier de l'arbre source change le comportement de la commande sans réinstallation.
- **REQ-003-F5** (MUST) : `setup.sh --check` rend compte de l'état d'installation **sans rien écrire** ; code `0` si installé, `1` sinon.
  - Vérification : aucun fichier modifié ; le code de retour reflète l'état.
- **REQ-003-F6** (MUST) : `setup.sh --uninstall` retire exactement ce que l'installation a posé, et rien d'autre.
  - Vérification : après `install` puis `--uninstall`, le fichier de configuration est identique à son état initial (comparaison octet à octet).
- **REQ-003-F7** (MUST) : les **dépendances requises et l'accès en écriture** sont vérifiés **avant** toute écriture. En cas de manque, le script s'arrête sans rien modifier et nomme ce qui manque.
  - Vérification : avec une dépendance rendue introuvable, `install` échoue et le fichier de configuration est inchangé.
- **REQ-003-F8** (MUST) : après un succès, le script indique comment **activer** le changement dans la session courante.
  - Vérification : la sortie mentionne l'action à effectuer.
- **REQ-003-F9** (MUST NOT) : le script n'écrit **jamais** dans la configuration d'un autre utilisateur et n'exige aucun privilège élevé. Le mode multi-utilisateur est hors périmètre ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), D2).

### Couche 2 : matérialiser le système d'augmentation (`USE-002`)

- **REQ-003-F10** (MUST) : le script matérialise dans un dépôt cible le **paquet distribuable** défini par les zones et le champ `type` ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), D6), sans liste codée en dur.
  - Vérification : l'ajout d'un type de ressource dans la couche type modifie le contenu posé sans modification de code.
- **REQ-003-F11** (MUST NOT) : le paquet posé **n'inclut ni l'outil ni sa source documentaire**. Une cible équipée ne contient aucun exécutable.
  - Vérification : après matérialisation, aucun fichier exécutable du système d'augmentation n'est présent dans la cible.
- **REQ-003-F12** (MUST) : le contenu de domaine et les ressources de conception propres à la cible sont **inchangés** par l'opération.
  - Vérification : empreinte des fichiers hors zone d'augmentation identique avant et après.
- **REQ-003-F13** (MUST) : la matérialisation est **atomique par fichier** (écriture dans un temporaire puis remplacement) et **échoue sans effet de bord** si une précondition n'est pas remplie.
  - Vérification : une précondition non remplie laisse la cible inchangée ; aucun état intermédiaire n'est présenté comme un succès.
- **REQ-003-F14** (MUST) : le script **crée le dépôt versionné** lorsque l'emplacement visé n'en contient pas, et **n'effectue aucune autre opération de versionnage** ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), D5).
  - Vérification : aucun enregistrement, aucune étiquette, aucun changement de révision n'est produit.
- **REQ-003-F15** (MUST) : le script **refuse** d'agir sur un dépôt déjà équipé et sur un emplacement non vide, sauf demande explicite, et oriente vers le parcours approprié.
  - Vérification : les deux cas produisent un refus, un diagnostic et aucune écriture.
- **REQ-003-F16** (MUST) : le script **écrit la marque d'installation** ([`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md), D3) : version posée ou mention d'un état de travail, identifiant de révision source, date, mode de pose, empreintes. Si la marque ne peut pas être déterminée, le parcours échoue **avant** toute écriture.
  - Vérification : la marque existe après un succès et son contenu correspond à l'état réellement posé.
- **REQ-003-F17** (SHOULD) : un mode **lien** vers l'arbre source est offert en complément du mode **copie**, qui est le défaut ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), D6).

### Contrat d'extension (`ADR-014`)

- **REQ-003-F18** (MUST) : le script est invocable **de deux façons** : en autonome, avant que l'outil existe dans l'environnement, et comme extension invoquée par l'outil. Les deux points d'entrée partagent le même corps de code.
  - Vérification : la même opération produit le même effet et le même code de retour par les deux voies.
- **REQ-003-F19** (MUST) : le script **déclare la version de contrat** qu'il implémente. L'outil refuse de l'invoquer si la version majeure diffère de la sienne.
  - Vérification : une version majeure divergente produit un refus explicite, sans invocation.
- **REQ-003-F20** (MUST) : le script respecte les conventions de flux et de codes de retour de [`REQ-001`](REQ-001-convention-cli-bash.md) : diagnostics sur stderr, résultat sur stdout, `0` succès, `1` échec d'exécution, `2` invocation invalide.
- **REQ-003-F21** (MUST) : le script **fournit sa documentation** à la source documentaire unique de l'outil. À défaut, il n'est pas exposé ([`ADR-014`](../adr/ADR-014-contrat-extension-outil.md), D4).
- **REQ-003-F22** (MUST) : le script honore les options globales `--debug` et `--dry-run` qui lui sont transmises ([`REQ-001-F10`](REQ-001-convention-cli-bash.md)).
  - Vérification : `--dry-run` décrit l'opération sans produire aucun effet de bord.

## Exigences non fonctionnelles

- **REQ-003-NF1** (MUST) : déterminisme. Mêmes entrées, mêmes sorties ; aucune heuristique, aucune dépendance au réseau.
- **REQ-003-NF2** (MUST) : cible **Debian 12**, shell **bash** uniquement. Aucun support multi-shell.
- **REQ-003-NF3** (MUST) : généricité. Le script ne contient aucune information de domaine ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)).
- **REQ-003-NF4** (MUST) : aucune opération de versionnage hors de la création d'un dépôt à un emplacement qui n'en contient pas. Toute autre opération reste à l'humain ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)).
- **REQ-003-NF5** (MUST) : les scénarios de vérification s'exécutent dans un **bac à sable isolé** et n'écrivent jamais dans la configuration de shell réelle de l'utilisateur.

## Tensions et dépendances

- **F3 (idempotence réconciliante) contre F6 (retrait exact)** : la mise à jour d'un bloc et son retrait exact reposent tous deux sur les marqueurs de F2. Un marqueur mal choisi casse les deux à la fois.
- **F11 (l'outil n'est pas distribué) contre l'autonomie de la cible** : un dépôt équipé ne peut pas s'utiliser sans que l'outil ait été installé séparément. Conséquence assumée d'[`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (D6), à énoncer dans la documentation d'accueil d'un dépôt équipé.
- **F18 (deux points d'entrée)** est le risque principal : un comportement qui diverge selon la voie d'appel annulerait le bénéfice de la décision D8.
- **F16 (marque d'installation)** dépend de [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md) : tant qu'aucune étiquette n'existe, toute installation provient d'un état de travail, ce que la marque doit savoir exprimer.

## Traçabilité

| Exigence | Usage satisfait | Décision applicable |
|---|---|---|
| F1 à F9 | [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) | [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D1, D2 |
| F10 à F17 | [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) | [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D5, D6 ; [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md) D3 |
| F18 à F22 | [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md), [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) | [`ADR-014`](../adr/ADR-014-contrat-extension-outil.md) |
