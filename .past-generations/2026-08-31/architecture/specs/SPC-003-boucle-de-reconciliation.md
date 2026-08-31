# SPC-003 — La boucle de réconciliation

**Répond à** `RQF-004`.
**Contrainte par** `RQN-001`, `RQN-002`, `RQN-003`, `RQN-005`.

## Objet

Fixer la mécanique unique dont dérivent l'instrumentation d'un dépôt, la reprise
d'une ressource, la mise à niveau, la migration et le contrôle de conformité.

**C'est le choix d'architecture principal de ce corpus.** La génération courante
a écrit cette mécanique trois fois sans la reconnaître ; la spécifier une fois
supprime les deux autres.

## S1 — Les quatre temps

```
    DÉCLARER            CONSTATER            DIFFÉRER              APPLIQUER
  l'état voulu   ─▶   l'état réel   ─▶   ce qui les sépare   ─▶   ce qui est
   (déclaration)      (observation)         (le rapport)          applicable
        ▲                                                              │
        └──────────────────────────────────────────────────────────────┘
                    l'application inscrit ce qu'elle a fait
```

| Temps | Propriété |
|---|---|
| **Déclarer** | l'état voulu est une donnée versionnée avec le dépôt (`SPC-002` S5) |
| **Constater** | l'état réel est **observé**, jamais mémorisé d'une exécution passée |
| **Différer** | produit un rapport, et **n'écrit rien** — la propriété est vérifiée automatiquement |
| **Appliquer** | ne s'exécute que sur demande explicite, et est idempotent |

**Constater par observation et non par mémoire** est ce qui rend la boucle
correcte quand quelque chose a été modifié à la main, ce qui est le cas normal.

## S2 — Les cinq gestes sont des entrées dans la même boucle

| Geste | État voulu | État réel |
|---|---|---|
| Instrumenter un dépôt | ce qu'un dépôt instrumenté porte | ce que ce dépôt porte |
| Vérifier la conformité | la déclaration du dépôt | le disque |
| Reprendre une ressource | la ressource telle que sa provenance l'offre | la copie installée |
| Mettre à niveau | les versions offertes par les provenances | les versions installées |
| Migrer des instances | la version du type | la version portée par chaque instance |

**Aucun de ces gestes n'a de garde qui lui soit propre.** Le refus d'écraser, la
vérification d'idempotence, l'inscription à la déclaration vivent dans la boucle.
Un geste ordonne et rapporte ; il ne réimplémente rien.

## S3 — Classement des écarts

Tout écart est classé sur deux axes, et les deux sont nécessaires.

**Par gravité :**

| Classe | Sens | Effet sur le code de retour |
|---|---|---|
| **bloquant** | empêche l'outil de travailler correctement | échec |
| **dérive** | n'empêche rien aujourd'hui, mais éloigne | succès avec avertissement |

**Par réparabilité :**

| Classe | Critère | Ce que fait `apply` |
|---|---|---|
| **applicable** | la réparation ne décide rien | l'applique |
| **réservé** | la réparation déciderait à la place de l'humain | la nomme, montre ce qu'il suggérerait, **n'écrit pas** |
| **impossible** | l'information nécessaire n'existe pas | la nomme, et dit ce qui manque |

**Le critère de la classe réservée est le coeur de la boucle.** Il rend
l'application sûre à lancer, donc lançable souvent, donc réellement employée.
Deux exemples avérés : la provenance d'un dépôt, qu'une valeur devinée rendrait
fausse de façon invisible ; le corps d'un document généré, dont une part
appartient à son auteur.

## S4 — Le rapport

Le rapport nomme, pour chaque contrôle : son identifiant, son verdict, et **ce
que le lecteur peut faire ensuite**.

| Verdict | Ce qui suit |
|---|---|
| conforme | rien |
| applicable | la commande qui le solderait, et le décompte |
| réservé | ce qui est suggéré, et pourquoi l'outil ne l'écrit pas |
| impossible | ce qui manque pour que ce soit réparable |
| échoué | ce qui a été tenté, et pourquoi cela n'a pas marché |

**Un geste échoué est compté comme un échec, jamais comme une réparation.** Un
dépôt qui paraîtrait sain sans l'être est pire que l'écart lui-même.

## S5 — Après application

L'application inscrit ce qu'elle a fait dans la déclaration, et rend le rapport
**d'après** application, non celui d'avant.

Une seconde application immédiate ne trouve plus que les écarts réservés et
impossibles. C'est le test d'idempotence, et il est automatisable tel quel.

## S6 — Ce que la boucle ne touche jamais

| Objet | Motif |
|---|---|
| L'installation de l'outil sur le poste | un dépôt ne réécrit pas le code qui l'instrumente (`RQN-002`) |
| Le corps d'un document appartenant au dépôt | seule une régénération explicite le remplace (`SPC-004` S5) |
| Un travail fait sur place | refus, puis option explicite (`RQN-002`) |

## Ce que cette spécification ne fixe pas

Le format de la déclaration, le nom des contrôles, et la manière dont une
provenance est jointe. Le premier relève de `SPC-002` S5, les autres de
l'implémentation.

## Origine

`ANL-001` C15, E4, P3. `USE-008` de la génération courante en est la première
mise en oeuvre partielle. `FND-001` de G2 sections 4.2 et 7.2 avait identifié le
modèle et l'avait déclaré non transposable ; cette spécification acte que
l'exception qu'elle nommait est devenue le cas général.
