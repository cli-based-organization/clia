# Ce qui a été fait, tâche 4 de SES-002

`MET-003` étape 3.

## Trois livrables

| Livrable | Contenu |
|---|---|
| `PLN-009` | Quatre chantiers SMART, 6 h 15 sous une limite de 7 h |
| `ISU-012` | La mise à jour n'a pas d'objet : trois choses lui manquent |
| `NON-039` | Trois questions : le double `check`, le mot « remote », l'ordre de la mise à jour |

La demande prescrivait « un ISU + NON pour tout ce qui n'est pas SMART ». Trois points sont sortis du plan et s'y trouvent.

## Ce que la consultation des expérimentations a donné

Quatre dépôts de `$HOME/git` portent un `setup.sh` comparable. **Un seul est le précédent direct**, `ticket-driven-ai`, et deux de ses choix sont repris dans le plan.

**Deux niveaux d'installation.** Installer le CLI n'est pas instrumenter un dépôt.

**Le mode développement est un régime de liaison.** Liens symboliques vers le dépôt source en mode développement, copies sinon. C'est la réponse exacte aux exigences 4 et 5 de la demande.

`ANL-001` ne traite pas l'installation : ses observations portent sur les ressources et les pratiques de commit. La matière utile était dans le code des dépôts, pas dans l'analyse.

## Le préalable qui commande le plan

**Personne n'a écrit ce qu'est un dépôt `clia` conforme.**

`PLN-003` chantier G1 le dit depuis le 2026-08-11 : sans les critères, `init` ne sait pas quoi produire et aucun contrôle ne sait quoi vérifier.

**Trois des cinq commandes demandées en dépendent.** Le chantier A du plan produit cette spécification, et accessoirement la première instance du type `SPC`, défini depuis des jours et sans instance.

## Deux mesures qui ont surpris

**Le mode développement existe déjà.** `setup.sh install` pointe `CLIA_HOME` vers le dépôt de développement, n'y copie rien, et n'écrit que dans le fichier de démarrage de l'utilisateur. Les cinq exigences de la demande sont satisfaites aujourd'hui, **sans que le mot soit écrit nulle part**. Le chantier D nomme ce qui existe plutôt que de créer un mode.

**`clia` fonctionne déjà sur un dépôt git vierge**, pour la résolution du contexte. Ce qui manque est le contenu de `.dev/`, pas la capacité à s'exécuter ailleurs.

```
depot courant                /tmp/vierge
repertoire de developpement  /tmp/vierge/.dev
--- res ls ---
clia: aucun type de ressource dans /tmp/vierge/.dev
```

## Ce qui est sorti du plan, et pourquoi

| Point | Motif |
|---|---|
| `clia setup upgrade` | Ni version déclarée, ni mécanisme de migration, ni inventaire des changements |
| Le double nommage de `check` | Deux sémantiques sous un même nom |
| Le mot « remote » | Désigne ce que `CLIA_HOME` désigne déjà |

**Le premier est le plus lourd** : il porte un critère de convergence de `SES-002`, et le plan ne l'atteint pas. Quatre chantiers pour cinq commandes demandées, et c'est déclaré dans le plan comme dans l'objection.

**Le dépôt a déjà migré trois fois à la main.** L'identifiant à slug vers l'identifiant à séquence, le renommage du répertoire de session, et `open` vers `opened`. Aucune trace réutilisable.

## Une vérification faite avant d'écrire le plan

`init` doit créer un dépôt git si le dépôt n'existe pas. **`git init` n'est pas un des six verbes que `C2` interdit**, et la garde posée aujourd'hui le laisse passer : éprouvé.
