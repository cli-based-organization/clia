# Demande interprétée, tâche 1 de SES-002

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande

Six choses, dont une méthodologique.

| Réf | Demande |
|---|---|
| A | Prendre en compte les réponses et précisions à `NON-037` |
| B | Rétablir « CRITÈRE de convergence » comme section obligatoire du gabarit |
| C | Documenter dans `RES-032` la forme adoptée à la main : l'énoncé vit dans `.dev/logs/SES-<SEQ>-<SLUG>/session.md`, et `workspace/session.md` est un lien symbolique |
| D | `clia ses new DESCRIPTION` modifie le lien symbolique vers la nouvelle session |
| E | `clia ses switch SESSION_ALIAS` ne fait que modifier le lien symbolique |
| F | **Faire un plan SMART. Tout ce qui n'est pas SMART fait l'objet d'un seul `NON`** |

## L'intention derrière

**Rendre le système utilisable dans n'importe quel dépôt**, ce que l'intention de `SES-002` déclare. La session doit pouvoir changer sans que le point d'entrée déclaré par `CLAUDE.md` bouge.

**L'humain a déjà tranché en agissant.** La forme au lien symbolique était la question Q5 de `NON-037`, que j'avais posée hier soir. Elle est faite, à la main, et la demande est de l'inscrire dans le système plutôt que de la discuter.

## Ce que la demande confirme et ce qu'elle infirme

| Ce que j'avais écrit hier | Ce que la demande en fait |
|---|---|
| `NON-037` Q5 : le lien symbolique est la forme qui supprimerait tout repli | **Retenue**, et déjà appliquée |
| `NON-037` Q1 : le critère de convergence doit-il subsister | **Oui**, demande B |
| L'énoncé se nomme `SES-<SEQ>.md` | **Infirmé** : il se nomme `session.md` |
| Le repli sur le fichier vivant sans frontmatter | Devient inutile : le lien pointe sur un énoncé |

**Le nom du fichier change et je l'avais choisi seul hier.** `clia ses new` produit `SES-<SEQ>.md` ; l'humain a écrit `session.md`. C'est sa forme qui fait foi.

## Ce que F impose à la méthode

`PDC-003` fixe le régime extrême SMART : livrable unique, critère de réussite exécutable, limite de temps déclarée. `MET-004` prescrit qu'un chantier non SMART sort du plan.

**La demande resserre `MET-004` sur un point.** Elle veut **un seul** `NON` pour tout ce qui n'est pas SMART, non un par chantier écarté.

## Le livrable

Un plan `PLN`, les chantiers SMART exécutés, et un seul `NON`.

## Ce qui reste à vérifier avant de planifier

Les réponses de l'humain dans `NON-037`, que je n'ai pas encore lues. Elles peuvent changer B, et elles portent aussi Q2, Q3 et Q4.

## Conformité

Tâche 1 de `workspace/session.md`, seul point d'entrée admis.

**Une garde s'applique et me vise.** `clia ses new` et `clia ses switch` écrivent le lien symbolique du point d'entrée. La garde posée hier les réserve à l'humain.
