# PLN-008 - Implémentation des fonctionnalités d'installation de `clia`

**Statut : proposé**

## Intention

Doter `clia` de véritables fonctionnalités d'installation, pour tenir l'intention de session « fournir un CLI installable pour un utilisateur ». Aujourd'hui `clia` n'a qu'un activateur in-repo (`. setup.sh activate`, PATH du shell courant, non persistant) ; ce plan prépare le passage à une installation **locale, permanente et réversible**, en reprenant le socle éprouvé analysé en tâche 1 (`ANL-2026-07-10-setup-installation`) et en corrigeant ses fragilités.

## Contexte

Demande de la tâche 2 (`[préparer]`) de `session.md`. Le contexte de session signale que les tests d'installation sont « fragmentés et ne se cumulent pas » : le plan intègre donc un **harnais de test d'installation reproductible et cumulatif**, pas seulement le code.

Références mobilisées :
- `ANL-2026-07-10-setup-installation` : socle « dev + permanent + local » de `tda` et ses 5 recommandations.
- `SPEC-001`/`REQ-001` : convention de CLI bash (le `setup.sh` de `clia` est lui-même un CLI bash à mettre en conformité).
- `SPEC-002`/`REQ-002` : `clia`. En particulier `REQ-002-NF2` (racine via `BASH_SOURCE`) et `REQ-002-NF5` (activation `. setup.sh activate`), que ce plan fait évoluer.
- `ADR-004`/`ADR-007` : `setup.sh` appartient à l'ensemble vivant `clia` ; toute modification bumpe `clia` dans `.dev/ressources.yaml`.

État de l'existant (`setup.sh`, 30 lignes) : une seule sous-commande `activate` qui exporte `PATH="$root/src/bin:$PATH"` dans le shell courant. Pas de persistance, pas de `--check`, pas de `--uninstall`, pas de vérification de prérequis.

## Spécification du livrable

Ce plan prépare (il n'implémente pas). Les livrables **de l'exécution ultérieure** seront :

1. `setup.sh` étendu : installeur complet conforme à `SPEC-001` (voir Plan proposé).
2. Amendements de `REQ-002`/`SPEC-002` selon la décision de modèle de racine (objection A).
3. Un harnais de test d'installation reproductible sous `src/` ou `test/` (bac à sable isolé).
4. Bump de l'ensemble `clia` dans `.dev/ressources.yaml`.

Le livrable **de cette tâche-ci** est le présent plan et son log.

## Plan proposé

### 1. Étendre `setup.sh` en installeur complet

Reprendre le patron de `tda` (tâche 1), en gardant `clia` en **mode dev** (PATH vers le `src/bin` du dépôt, aucune copie, aucune compilation) :

- `""` (défaut) : **installer** — insérer un bloc marqué dans le profil shell (`export PATH` vers `src/bin`), après vérification que `src/bin/clia` existe ;
- `--check` : diagnostiquer la présence de l'installation et la racine enregistrée (code 0/1) ;
- `--uninstall` : retirer le bloc, avec confirmation ;
- `--version`, `-h`/`--help`, `--man` : cohérents avec la convention (`REQ-001`) ;
- conserver `. setup.sh activate` comme sous-commande distincte (activation éphémère du shell courant, utile en dev).

### 2. Corriger les fragilités relevées dans l'ANL (tâche 1)

- **Idempotence réconciliante** : à la réinstallation, si le bloc existe mais que la racine a changé, **mettre à jour** le bloc plutôt qu'afficher « déjà installé » (évite un PATH obsolète après déplacement du dépôt).
- **Désinstallation déterministe** : délimiter le bloc par un marqueur d'**ouverture et de fermeture** explicites, plutôt que par une ligne vide (`awk`/`sed` borné, sans sur-suppression).
- **Extraction robuste** de la racine enregistrée (pas de dépendance à une mise en forme fragile).

### 3. Décider et appliquer le périmètre de shell

Assumer `bash`/`~/.bashrc` uniquement (documenté), ou prendre en charge `zsh`/`~/.profile` dès le départ. Choix par défaut proposé : `bash` uniquement, aligné sur `tda` et sur l'environnement courant, avec un message clair si le profil attendu est absent.

### 4. Mettre `setup.sh` en conformité `SPEC-001`/`REQ-001`

`set -euo pipefail`, helpers `_info/_warn/_err` sur stderr, données/version sur stdout, codes de sortie signifiants (0 succès, 1 erreur applicative, 2 erreur d'usage), aide `-h/--help`. Le fichier actuel imprime tout sur stderr et n'a pas ces garde-fous : à reprendre.

### 5. Harnais de test d'installation cumulatif (répond au contexte de session)

Prévoir un script de test reproductible qui, dans un **bac à sable isolé** (faux `$HOME`, faux profil, copie de `src/`), exerce et **cumule** : install -> check (installé) -> réinstall (idempotence/réconciliation) -> uninstall -> check (absent), plus les erreurs d'usage. Objectif : remplacer les tests manuels fragmentés par un test rejouable qui s'accumule (fondation d'une future suite).

### 6. Versionnage

À l'exécution, bump de l'ensemble `clia` et de son membre `setup.sh` dans `.dev/ressources.yaml` (atomique, `ADR-004`). Pas d'impact sur la version du domaine métier (`version.yaml`, `ADR-007`).

## Décisions de premier jet (meilleures pratiques, non bloquantes)

- Mode **dev** conservé (PATH vers le dépôt, pas de copie), comme `tda` et l'existant.
- `bash`/`~/.bashrc` par défaut pour le périmètre shell.
- Marqueur d'ouverture/fermeture pour la robustesse de la désinstallation.

## Objections de l'agent IA

- **[OBJECTION A - modèle de racine, à trancher par l'humain]** Si l'on rend `clia` installé **une seule fois** et disponible en permanence sur le PATH, sa racine reste résolue via `BASH_SOURCE` (`REQ-002-NF2`) : `clia` opérera **toujours sur son propre dépôt d'installation**, pas sur le dépôt où l'utilisateur travaille. Conséquence concrète : une installation « pour un utilisateur » ne permet pas de gérer plusieurs dépôts.
  - Impact : détermine la nature même de l'installation.
  - Deux modèles :
    - **A. Dev / mono-dépôt** (défaut proposé) : une installation = le dépôt qui contient `clia`, exactement comme `tda` en mode dev (`TDA_HOME` = le dépôt). Aucun changement de résolution de racine ; `REQ-002-NF5` évolue (persistance) mais `REQ-002-NF2` est inchangé.
    - **B. Outil global + cible au runtime** : `clia` installé une fois résout le dépôt cible à l'exécution (racine git du répertoire courant, ou option `-C <dir>` comme `tda`). Requiert un changement de résolution de racine et un amendement de `REQ-002-NF2`/`SPEC-002`.
  - Suggestion : trancher A ou B **avant l'exécution**. Par défaut, en l'absence de réponse, j'exécuterai le modèle A (le moins risqué, aligné sur l'existant et sur `tda`).

- **[OBJECTION B - couplage aux fichiers de profil]** Écrire dans `~/.bashrc` est un effet de bord sur un fichier hors dépôt. À l'exécution, cela doit rester **strictement local à l'utilisateur, idempotent et réversible**, et n'être exercé en test que dans un `$HOME` factice (jamais le vrai profil), conformément à la discipline déjà appliquée en tâche 19.
  - Impact : risque de corruption du profil utilisateur si mal borné.
  - Suggestion : non bloquant si les étapes 2 et 5 sont respectées (marqueurs bornés + tests en bac à sable).

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
