# Ce qui a été fait, tâche 11 de SES-002 — réexécution

`MET-003` étape 3. `derive-de` `TSK-03-fait_2026-08-13-13-58_un-echec-et-sa-cause.md`, qui rapportait zéro chantier sur sept.

## Ce que l'approbation a débloqué

**Quatre chantiers exécutés.** `DCN-016` est passée `en-vigueur` entre 16:17 et 16:22, et c'est tout ce qui manquait.

| Chantier | État | Mesure |
|---|---|---|
| A. Déclarer les 4 champs dans `RES-001` | **Exécuté** | 7 occurrences des quatre noms, le critère en demande 4 |
| B. Porter les 4 champs dans `commun.cue` | **Exécuté** | Un frontmatter amputé échoue à `cue vet`, un frontmatter complet passe |
| C. Déclarer `domain-status` dans les définitions | **Exécuté** | 37 sur 37 : **12 reportent une énumération, 25 déclarent n'en avoir aucune** |
| D. Poser les 4 champs sur les instances | **Exécuté** | **183 instances**, dont 152 avec `domain-status` |
| E. Supprimer les 154 champs anciens | **Non exécuté** — voir plus bas |
| F, G | Déjà satisfaits au premier passage | |

**Le dépôt ne régresse pas** : 166 conformes, 17 non conformes — exactement les chiffres d'avant la tâche. Les 17 sont les squelettes à `À RENSEIGNER`, antérieurs.

## Ce qui a été décidé en avançant

**`domain-status` est optionnel dans `commun.cue`, et lui seul des quatre.** Ses valeurs sont déclarées par le `RES` du type, et 25 types sur 37 déclarent n'avoir aucun cycle de vie métier propre. Le rendre obligatoire à l'échelle commune exigerait une valeur de types qui n'en ont pas.

**Trois valeurs par défaut ont été posées sans jugement par instance.** Le plan prévenait : « `maturity` et `adoption` demandent un jugement par instance ». 183 instances × 2 champs = 366 jugements qu'aucune tâche ne peut porter en une fois.

| Champ | Valeur posée | Motif |
|---|---|---|
| `maturity` | `conception` | Le dépôt a cinq jours. Aucune ressource n'est mature |
| `activated` | `true` | Rien n'est désactivé aujourd'hui |
| `adoption` | `propose`, sauf 8 | Les 8 exceptions sont les décisions `en-vigueur` : approuvées par l'humain, donc `adopte` |

**Ce que cela reproduit, et qu'il faut nommer** : `maturity` vaut `conception` partout, comme `status` valait `draft` partout. **C'est le défaut même que `DCN-016` corrigeait.** La différence est que le champ existe maintenant et peut varier ; il ne varie pas encore.

**`domain-status`, lui, ne souffre pas de ce défaut** : il reprend la valeur du champ propre existant, et prend 12 valeurs distinctes selon le type.

## Pourquoi le chantier E n'a pas été exécuté

Trois motifs, chacun mesuré.

**Il est irréversible.** `MET-005` étape 2, première ligne : le geste supprime 191 champs dans les instances, et le plan lui-même déclare qu'« une erreur de reprise perdrait les valeurs des huit champs supprimés ».

**Il casserait le CLI.** `clia focus` et `clia res ls` lisent `etat`, `effet` et `statut-plan` : **10 lectures dans `lib/`**. Les supprimer sans réécrire ces lectures rend `clia focus` aveugle — la commande qui vient d'être corrigée trois fois. Le plan ne le dit pas : il a été écrit le 2026-08-11, avant que `clia focus` existe.

**Son critère dépend d'`ISU-009`, toujours ouverte.** Le critère est `grep -c 'effet:\|etat:\|statut:'` égal à 0, ce qui inclut `status` — dont `DCN-016` laisse le sort ouvert faute d'avoir pu vérifier ce qu'OKF exige.

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## Les quatre champs d'état — `FNC-001` étendue

**Ce qui a été livré.** Toute ressource porte désormais quatre champs d'état, et le dépôt entier les valide.

```sh
clia res show PLN-007    # maturity, adoption, activated, domain-status
clia res ls plan         # la colonne d'etat lit toujours statut-plan
```

```
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
```

**Ce qui ne marche pas encore.** `clia res ls` lit encore les anciens champs, non `domain-status` : les deux coexistent, et rien ne garantit qu'ils restent d'accord. **C'est la dette que le chantier E devait solder**, et il ne peut pas l'être sans réécrire le CLI d'abord.

**Ce qui a été livré aussi** : chacune des 37 définitions dit ce que `domain-status` vaut pour son type — `clia res show RES-004` donne les sept états d'une objection, `clia res show RES-025` les quatre d'un plan.
