# Architecture cible du CLI clia

Ce corpus décrit le CLI à développer lors de la prochaine génération. Il ne
décrit pas la génération courante : celle-ci vit dans `.dev/`, et ce qu'elle a
appris est établi par `.dev/analyses/ANL-001-conception-et-usage-des-cli.md`,
dont ce corpus est la suite.

**Il est technologiquement agnostique.** Rien ici ne suppose bash, ni un
système de fichiers particulier, ni git. Ces choix appartiennent à
l'implémentation, et les avoir tenus hors des spécifications est ce qui
permettra de les changer sans réécrire l'intention.

---

## Les cinq ressources informationnelles

### Pourquoi cinq, et pas un seul document

Un document unique qui dirait à la fois *pourquoi quelqu'un se sert de l'outil*,
*ce que l'outil doit faire*, *à quelle qualité*, *comment il se comporte* et
*comment ses parties tiennent ensemble* est un document que personne ne
maintient : chacune de ces cinq questions vieillit à un rythme différent, et
sous une autorité différente.

Le découpage n'est donc pas une préférence de rangement. Il suit **les cinq
questions distinctes qu'une architecture doit tenir séparées** pour rester
révisable :

| Ressource | Répertoire | La question à laquelle elle répond | Qui en est l'autorité |
|---|---|---|---|
| **Cas d'usage** | `usage/` | *Pourquoi* quelqu'un se sert de l'outil, et à quoi il voit que c'est fait | l'humain |
| **Requis fonctionnel** | `features/` | *Quoi* — ce que le système doit savoir faire | l'humain, sur proposition |
| **Requis non fonctionnel** | `requis/` | *À quelle condition* c'est acceptable | l'humain, sur proposition |
| **Spécification** | `specs/` | *Comment* le système se comporte, précisément et sans dire avec quoi | l'agent, revue par l'humain |
| **Diagramme et plan** | `diagrammes/` | *Où* — comment les parties tiennent ensemble | l'agent, revue par l'humain |

Chacune existe parce que son absence a un coût déjà constaté dans ce dépôt.

| Ressource | Ce que son absence a coûté, mesuré |
|---|---|
| Cas d'usage | Six types de ressource sur dix ne sont activés par aucun dépôt de travail (`ANL-001` C12, M4). Ils ont été conçus sans demande. |
| Requis fonctionnel | En G2, neuf plans, et aucun ne déclarait ce qu'il livrait (`ANL-011` C7). Impossible de dire si un travail avait produit quelque chose. |
| Requis non fonctionnel | Six écarts de qualité relevés en G1 sont restés vingt-et-un mois sans correctif, faute d'un lieu où l'exigence soit opposable (`ANL-001` C16). |
| Spécification | Le code devient la seule vérité ; une refonte perd l'intention avec l'implémentation. G1 a archivé son `setup.sh` et s'est réveillée sans savoir ce qu'il devait faire. |
| Diagramme | En G2, trente-huit types individuellement cohérents et un ensemble que personne ne pouvait tenir dans sa tête (`ANL-001` C3, C6). |

### Ce que chacune est, et n'est pas

#### Cas d'usage — `usage/`, alias `CAS-NNN`

**Est** le récit d'un acteur qui veut obtenir quelque chose : sa situation
avant, ce qu'il fait, ce qu'il obtient, et le signe auquel il reconnaît que
c'est fait. Il est écrit dans les mots de l'acteur.

**N'est pas** une liste de commandes. Un bloc de commandes dans un cas d'usage
décrit une **intention d'usage**, jamais une interface : c'est la spécification
qui fixe l'interface, et elle peut la fixer autrement.

**Test d'admission** : si le document ne nomme pas d'acteur, ou ne dit pas à
quoi celui-ci reconnaît que c'est fait, ce n'est pas un cas d'usage.

#### Requis fonctionnel — `features/`, alias `RQF-NNN`

**Est** une capacité que le système doit avoir, énoncée de sorte qu'on puisse
constater qu'elle y est ou qu'elle n'y est pas. Il nomme le ou les cas d'usage
qui le motivent : un requis sans cas d'usage est une fonctionnalité inventée
pour elle-même, et c'est le défaut que M4 mesure.

**N'est pas** la description du comportement. « Le système sait créer une
instance d'un type » est un requis ; « la commande refuse si l'emplacement est
occupé et sort en 1 » est une spécification.

**Test d'admission** : un requis fonctionnel doit pouvoir être coché ou non
coché par quelqu'un qui ne lit pas le code.

> **Sur le nom du répertoire.** `features/` porte des *requis fonctionnels*, et
> le mot `feature` désigne déjà, dans clia, un tout autre objet : le contenu
> injecté dans la zone `CLIA:FEATURES` du harnais. La collision est réelle. Le
> nom du répertoire est celui que la demande a fixé ; l'alias `RQF` lève
> l'ambiguïté dans les renvois, et c'est lui qui fait foi.

#### Requis non fonctionnel — `requis/`, alias `RQN-NNN`

**Est** une qualité opposable à toute l'implémentation, ou à une portée
nommée : déterminisme, réversibilité, économie du contexte, vérifiabilité.
Il porte **une portée** et **un moyen de le constater**.

**N'est pas** un souhait. « L'outil doit être rapide » n'est pas un requis ;
« aucune commande de lecture ne modifie le disque, ce que chaque banc vérifie
en dernière assertion » en est un.

**Test d'admission** : un requis non fonctionnel qui ne s'applique qu'à une
seule commande est une spécification mal placée.

#### Spécification — `specs/`, alias `SPC-NNN`

**Est** l'énoncé précis du comportement : la grammaire, les états, les
transitions, les refus, les codes de retour, ce qui est écrit et ce qui ne
l'est pas. Elle répond à un ou plusieurs requis fonctionnels, sous la
contrainte des requis non fonctionnels qu'elle nomme.

**N'est pas** une implémentation. Elle ne nomme ni langage, ni bibliothèque,
ni format de fichier — sauf quand le format *est* le contrat, auquel cas elle
le dit explicitement.

**Test d'admission** : deux implémentations indépendantes conformes à la même
spécification doivent être substituables du point de vue de l'acteur.

#### Diagramme et plan d'architecture — `diagrammes/`, alias `DIA-NNN`

**Est** la vue d'ensemble : quelles parties existent, ce que chacune connaît,
et par où passe l'information. C'est ce qu'aucune spécification ne peut
montrer, parce que chacune ne voit que son objet.

**N'est pas** une source de vérité. Un diagramme **situe** ce que les autres
ressources établissent ; il n'introduit rien. Un élément qui n'apparaît que
dans un diagramme signale une spécification manquante, non une décision prise.

**Test d'admission** : tout élément d'un diagramme doit être traçable à une
spécification, un requis ou un cas d'usage.

### Les relations entre les cinq

Une seule chaîne porte la justification, du besoin vers le comportement. Une
seule ressource la traverse sans y appartenir.

```
                 ┌──────────────────────────────────────────────┐
                 │            RQN — requis non fonctionnel      │
                 │       qualités opposables, portée nommée      │
                 └───────────────────┬──────────────────────────┘
                                     │ contraint
                                     ▼
   CAS ────────────▶ RQF ─────────────────────▶ SPC ─────────────▶ code
   cas d'usage      requis fonctionnel         spécification      (hors corpus)
       │  motive         │  est spécifié par        │  est implémenté par
       │                 │                          │
       │                 │                          │
       └─────────────────┴──────────┬───────────────┘
                                    │ situé par
                                    ▼
                        ┌───────────────────────┐
                        │   DIA — diagramme     │
                        │  vue, jamais source   │
                        └───────────────────────┘
```

Les six relations, et rien d'autre :

| Relation | De | Vers | Règle |
|---|---|---|---|
| `motive` | CAS | RQF | Tout RQF nomme au moins un CAS. Un RQF sans CAS est une invention. |
| `specifie` | SPC | RQF | Toute SPC nomme au moins un RQF. Un RQF sans SPC est un requis non conçu. |
| `contraint` | RQN | SPC | Une SPC nomme les RQN qui pèsent sur elle. Un RQN que nulle SPC ne nomme est inopposable. |
| `situe` | DIA | CAS, RQF, RQN, SPC | Un DIA ne renvoie que vers de l'existant. |
| `derive-de` | toute | toute | Succession : ce document procède d'un autre, plus ancien. |
| `reference` | toute | toute | Renvoi simple, sans engagement. |

**Le sens de lecture est unique.** On descend de la demande vers le
comportement, jamais l'inverse. Un besoin découvert en écrivant une
spécification remonte vers un cas d'usage ; il ne s'ajoute pas à la
spécification. C'est ce qui empêche l'appareil de grossir par le bas, ce dont
G2 est morte.

**Ce que la chaîne interdit, et qui a déjà eu lieu :**

- une capacité qui n'a pas de demandeur (RQF orphelin) ;
- une qualité invoquée dans un débat mais écrite nulle part (RQN implicite) ;
- un comportement qui n'existe que dans le code (SPC manquante) ;
- une architecture qui n'existe que dans une tête (DIA manquant) ;
- un document qui justifie au lieu de prescrire — le motif appartient à
  `ANL-001` et aux commentaires de tête du code, jamais ici (`ANL-004`, P5).

### Ce que ce corpus s'interdit à lui-même

Ce corpus applique le principe P2 de `ANL-001` : *ce qui est déclaré est
exécuté, ou n'est pas déclaré.*

En conséquence, tant qu'aucune commande ne valide ces documents :

- ils ne portent **pas** de frontmatter d'état — aucun champ ne prétend à un
  cycle de vie que rien ne fait avancer ;
- ils ne déclarent **pas** de version individuelle — la version du dépôt suffit,
  et `clia release` la tient déjà ;
- leur seule contrainte de forme est celle des tests d'admission ci-dessus,
  qui sont vérifiables à la lecture.

Le jour où `RQF-003` est livré et où une instance se crée et se valide par
commande, ces documents deviennent des instances d'un type, et ce paragraphe
disparaît.

### Numérotation et migration

Les alias `CAS`, `RQF`, `RQN`, `SPC` et `DIA` sont **locaux à ce corpus** et
numérotés à partir de `001`.

`.dev/` porte les ancêtres de trois d'entre eux, pour la génération courante :
`.dev/usages/USE-001..008`, `.dev/reqs/REQ-001..003` et `.dev/specs/SPC-001`.
**`SPC-001` existe donc deux fois dans ce dépôt**, dans deux espaces distincts.
La collision est réelle et transitoire : à l'ouverture de la prochaine
génération, `.dev/usages`, `.dev/reqs` et `.dev/specs` sont repris ici ou
archivés, et l'ambiguïté disparaît. Tant qu'elle dure, un renvoi cite le
chemin, non l'alias seul.

### Inventaire

| Répertoire | Contenu |
|---|---|
| `usage/` | `CAS-001` à `CAS-006` — les six situations qui justifient l'outil |
| `features/` | `RQF-001` à `RQF-006` — les six capacités attendues |
| `requis/` | `RQN-001` à `RQN-006` — les six qualités opposables |
| `specs/` | `SPC-001` à `SPC-005` — le comportement, précisément |
| `diagrammes/` | `DIA-001` à `DIA-004` — les quatre vues |

Point d'entrée conseillé : `diagrammes/DIA-001-vue-d-ensemble.md`, puis
`specs/SPC-003-boucle-de-reconciliation.md`, qui porte le choix
d'architecture principal.
