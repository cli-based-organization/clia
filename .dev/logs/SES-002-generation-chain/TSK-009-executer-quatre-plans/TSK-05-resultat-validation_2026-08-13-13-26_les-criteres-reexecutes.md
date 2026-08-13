# Les sept critères réexécutés, tâche 9 de SES-002

`derive-de` `TSK-05-resultat-validation_2026-08-13-12-49_quatorze-controles.md`

La tâche ayant été interrompue puis reprise, les sept critères de réussite des quatre plans ont été **exécutés à nouveau, un par un**, sans se fier au journal précédent. `MET-005` étape 3 : un critère est exécuté, pas supposé.

## Les sept critères

| Plan | Critère | Résultat |
|---|---|---|
| `PLN-011` A | `clia res ls objection` affiche au moins deux valeurs distinctes | **Réussi**, trois : `ouverte`, `repondue`, et `?` pour une instance sans champ |
| `PLN-012` A | Chaque item ouvert reçoit exactement une catégorie et un destinataire | **Échoué, puis corrigé** — voir plus bas |
| `PLN-012` B | La sortie tient en dix lignes et nomme une seule action | **Réussi**, 8 lignes |
| `PLN-013` A | Le critère range les 39 objections sans cas ambigu | **Réexécuté par jugement** — voir plus bas |
| `PLN-013` B | Une décision prise en avançant a un endroit déclaré | **Réussi**, `MET-003` étape 2 |
| `PLN-014` A | Les fonctionnalités livrées se rangent dans le type sans forcer | **Réussi**, 7 instances conformes |
| `PLN-014` B | Chaque plan déclare la fonctionnalité qu'il sert | **Réussi**, 14 sur 14 |

## Le critère de PLN-012 A échouait, et cachait trois items

**Trois items ouverts du dépôt ne recevaient aucune catégorie et n'apparaissaient nulle part.**

| Item | Pourquoi il disparaissait |
|---|---|
| `NON-013` | Aucun champ `etat` |
| `BUG-001` | `etat: À RENSEIGNER`, gabarit non rempli |
| `BUG-003` | Idem |

`focus.sh` ne traitait que les valeurs attendues et laissait tomber les autres en silence. **Le plus grave est `BUG-001` : un bogue rapporté par l'humain, invisible de la commande qui existe pour dire quoi faire.** L'humain a ouvert une tâche 10 pour le traiter ; `clia focus` ne l'a jamais désigné.

**Corrigé.** Seuls les états clos déclarés par le schéma font disparaître un item. Un état absent ou inconnu range l'item à défricher, en nommant le défaut : `NON-013 (etat absent)`, `BUG-001 (etat À RENSEIGNER)`.

**Cinq assertions ajoutées**, dont une objection `caduque` qui doit bien disparaître, pour que la correction ne devienne pas l'excès inverse.

**Le compteur passe de 55 à 58.** Il monte, et c'est le résultat juste : ces trois items existaient. Le compteur descendait en partie parce qu'il ne comptait pas tout.

## Le critère de PLN-013 A, réexécuté par jugement

Le rangement complet est dans `TSK-03-fait_2026-08-13-13-15`.

```
par recherche de mots :  29 arreter / 10 avancer / 0 ambigu
par jugement          :  26 arreter / 12 avancer / 1 non range
```

**Douze objections sur trente-neuf n'avaient pas lieu d'être ouvertes.** Deux d'entre elles ont été traitées depuis en avançant, sans coût de retour en arrière.

**Le cas non rangé est `NON-013`**, qui n'est pas une objection mais un brouillon de deux lignes. Le filtre ne s'y applique pas, faute d'incertitude formulée.

## Les contrôles de fond

| Contrôle | Résultat |
|---|---|
| Suite de tests | **275 réussis, 0 échoué**, 270 → 275 |
| Instances contre leur schéma `cue` | **159 conformes, 16 non conformes** |
| `clia setup check` | `conforme`, trois avertissements de version |
| `clia git check done` | Message trouvé ; seul KO `commit.gpgsign`, condition du dépôt |

**Les seize non conformes sont antérieures à la tâche.** Cinq `PDC`, six `DCN`, un `FRG`, deux `BUG`, un `NON`. Aucun livrable de la tâche 9 n'en fait partie : `MET-005`, les sept `FNC` et `RES-037` passent.

**Le chiffre diffère de celui du 12:49** (180 / 10) parce que le périmètre du contrôle diffère ; celui-ci porte sur les 175 instances préfixées des répertoires de `.dev`, et son script est dans le journal de session. Les deux mesures ne sont pas comparables, et je ne prétends pas reproduire la première.

## Ce que la validation ne couvre toujours pas

**Aucune fonctionnalité n'a été éprouvée par un autre que moi.** L'usage réel n'a pas eu lieu.

**La cible de `PLN-013` ne se mesurera qu'à la tâche 19** : « moins d'objections que de tâches sur les dix suivantes ». Une tâche écoulée ne mesure rien.

**Le champ `sert` n'est contraint par aucun schéma.** Rien ne vérifie qu'une `FNC` déclarée par un plan existe.
