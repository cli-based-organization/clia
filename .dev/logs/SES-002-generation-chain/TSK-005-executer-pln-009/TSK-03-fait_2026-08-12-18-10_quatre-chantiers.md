# Ce qui a été fait, tâche 5 de SES-002

`MET-003` étape 3. Les quatre chantiers de `PLN-009` sont exécutés.

## Chantier A - La spécification de conformité

`SPC-001`, **première instance du type `SPC`**, défini par `RES-020` et sans instance jusqu'ici. `PLN-003` chantier G1 la réclamait depuis le 2026-08-11.

**Deux jeux de critères, parce qu'un dépôt peut être instrumentable sans être instrumenté.**

| Jeu | Critères | Bloquants |
|---|---|---|
| Instrumentabilité, `I1` à `I4` | 4 | 2 |
| Conformité, `C1` à `C7` | 7 | 4 |

Plus cinq exigences de production, `P1` à `P5`, sur ce que l'instrumentation doit garantir.

### Un écart au plan, et son motif

Le plan demandait que « chaque critère s'exprime par une commande shell dont le code de retour tranche ».

**`RES-020` l'interdit.** La garde d'agnosticisme est la propriété définitionnelle du type : « une spécification qui nomme une technologie devient fausse quand la technologie change ».

**Séparation retenue.** La spécification énonce un état observable ; l'implémentation dit comment le constater. Chaque critère porte une référence, `I1` à `C7`, et le code y renvoie.

Le critère de réussite du chantier devient : chaque critère porte une référence, un énoncé vérifiable, et un verdict binaire. **C'est un écart au plan, décidé en l'exécutant, et il est déclaré.**

## Chantiers B et C - `clia setup check` et `clia setup init`

Un module, `lib/clia/setup.sh`, et deux verbes. Chaque critère de `SPC-001` a sa fonction d'évaluation, et le rapport nomme la référence.

```
CLE          VALEUR
emplacement  /tmp/cible
etat         instrumente
verdict      conforme

REF  VERDICT  CRITERE
I1   ok       l'emplacement existe et est un repertoire
...
C4   ok       des definitions de types existent (37)
C6   ok       la version d'instrumentation est declaree (0.1.0)
```

**Trois diagnostics distincts, éprouvés** : emplacement inexistant, dépôt git vierge, dépôt instrumenté.

**La cible mesurable du plan est atteinte.** Dans un dépôt instrumenté, `clia res ls` répond au lieu d'échouer.

### Le fichier de version, posé sans attendre

`NON-039` Q3 recommandait de le poser dès maintenant. Fait, et déclaré dans le log de demande : cinq lignes ici évitent de le rétro-ajouter à tout dépôt instrumenté entre-temps. `ISU-012` porte le reste de la mise à jour.

### Les cinq garanties, chacune éprouvée

| Réf | Garantie | Comment elle a été vérifiée |
|---|---|---|
| P1 | Tout critère bloquant devient vrai | `check` après `init` retourne 0 |
| P2 | Aucun emplacement occupé n'est écrasé | Un `CLAUDE.md` propre survit à `init` |
| P3 | Le dépôt source n'est pas modifié | Empreinte du source identique avant et après |
| P4 | Un emplacement conservé est annoncé | `conserve, non touche : CLAUDE.md` |
| P5 | Rejouable | Second `init` : `poses : 0, conserves : 43` |

## Chantier D - `. setup.sh install --dev`

**Le mode n'a pas été créé : il existait.** `setup.sh install` satisfaisait déjà les cinq exigences énoncées par l'humain, sans que le mot soit écrit nulle part.

Le drapeau les rend explicites :

```
mode developpement, cinq proprietes :
  1. local      seul l'utilisateur courant est touche, pas de sudo
  2. universel  clia s'execute dans n'importe quel depot git
  3. source     le depot de reference est /home/.../clia
  4. vivant     le code employe est celui de ce depot, non une copie
  5. non intrusif  aucune ecriture dans le depot source
```

**Un mode inconnu est refusé plutôt qu'ignoré**, code 2. Et l'aide distingue désormais les deux niveaux, ce qui était la confusion que `tda` avait déjà séparée.

## Un bogue préexistant, révélé par le régime lié

**`check` déclarait conforme un dépôt où `clia res ls` ne trouvait rien.**

La cause : `find -type f` **ne suit pas les liens symboliques**. En régime lié, les définitions de types *sont* des liens, et aucune n'était comptée.

**Le défaut n'était pas dans le code neuf.** Il dormait dans `core.sh`, `resource.sh` et `registre.sh` depuis leur écriture, invisible tant qu'aucun dépôt ne portait de ressources liées.

Sept emplacements corrigés par `find -L`. Sans cela, **le régime lié était inutilisable**, et c'est le régime que la demande décrit comme le mode de développement.

## Livrables

| Fichier | Nature |
|---|---|
| `SPC-001` | Création, première instance du type |
| `lib/clia/setup.sh` | Création, deux verbes |
| `bin/clia` | Dispatch et aide |
| `setup.sh` | Drapeau `--dev`, aide |
| `core.sh`, `resource.sh`, `registre.sh` | `find -L`, sept emplacements |
| `tests/test_clia.sh` | **33 assertions**, 219 → 252 |

## Ce qui n'a pas été fait

**`clia setup upgrade`.** Hors plan, et `ISU-012` porte pourquoi. L'exécuter serait sortir du plan que la tâche demande d'exécuter.

**Les avertissements `C6` et `C7` restent des avertissements.** Ils deviendront bloquants quand le mécanisme de mise à jour existera. `SPC-001` le déclare.
