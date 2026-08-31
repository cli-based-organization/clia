# DIA-003 — La boucle de réconciliation

**Situe** `SPC-003`, `RQF-004`.

C'est le choix d'architecture principal du corpus : une seule mécanique, dont
cinq gestes sont des entrées.

## La boucle

```
                        ┌───────────────────────────┐
                        │      1. DÉCLARER          │
                        │  l'état voulu, versionné  │
                        │      avec le dépôt        │
                        └─────────────┬─────────────┘
                                      │
                                      ▼
                        ┌───────────────────────────┐
                        │      2. CONSTATER         │
                        │  l'état réel, OBSERVÉ     │
                        │  jamais mémorisé d'une    │
                        │  exécution passée         │
                        └─────────────┬─────────────┘
                                      │
                                      ▼
                        ┌───────────────────────────┐
                        │      3. DIFFÉRER          │
                        │  le rapport               │
                        │  ── N'ÉCRIT RIEN ──       │
                        └─────────────┬─────────────┘
                                      │
                       ┌──────────────┴──────────────┐
                       │  demande explicite ?        │
                       └──────┬───────────────┬──────┘
                          non │               │ oui
                              ▼               ▼
                          ╔═══════╗   ┌───────────────────────────┐
                          ║  FIN  ║   │      4. APPLIQUER         │
                          ║ rien  ║   │  ce qui est APPLICABLE    │
                          ║ écrit ║   │  seulement                │
                          ╚═══════╝   └─────────────┬─────────────┘
                                                    │
                                                    │ inscrit ce
                                                    │ qui a été fait
                                                    └──────────┐
                                                               │
                        ┌──────────────────────────────────────┘
                        ▼
                    retour en 1  ──▶  une seconde application
                                      ne trouve plus que le
                                      réservé et l'impossible
                                      ── test d'idempotence ──
```

## Le classement des écarts

Deux axes, et les deux sont nécessaires.

```
                       │  APPLICABLE   │   RÉSERVÉ     │  IMPOSSIBLE
                       │ ne décide     │ déciderait à  │ l'information
                       │ rien          │ la place de   │ n'existe pas
                       │               │ l'humain      │
   ────────────────────┼───────────────┼───────────────┼───────────────
   BLOQUANT            │  appliqué     │  nommé,       │  nommé, avec
   empêche de          │               │  suggéré,     │  ce qui manque
   travailler          │      ↓        │  non écrit    │
                       │  code 0       │      ↓        │      ↓
                       │               │   code 1      │   code 1
   ────────────────────┼───────────────┼───────────────┼───────────────
   DÉRIVE              │  appliqué     │  nommé,       │  nommé
   n'empêche rien      │               │  suggéré,     │
   aujourd'hui         │      ↓        │  non écrit    │      ↓
                       │  code 0       │      ↓        │   code 0
                       │               │   code 0      │  avertissement
```

**La classe RÉSERVÉ est le coeur du dispositif.** C'est elle qui rend
l'application sûre à lancer — donc lançable souvent, donc réellement employée.
Deux cas avérés : la provenance d'un dépôt, qu'une valeur devinée rendrait
fausse de façon invisible ; le corps d'un document généré, dont une part
appartient à son auteur.

## Les cinq entrées

```
   ┌──────────────────────┐  état voulu              état réel
   │ instrumenter         │  ce qu'un dépôt          ce que ce dépôt
   │ un dépôt             │  instrumenté porte       porte
   ├──────────────────────┤
   │ vérifier la          │  la déclaration          le disque
   │ conformité           │  du dépôt
   ├──────────────────────┤                                        ┌────────┐
   │ reprendre une        │  la ressource telle      la copie      │   LA   │
   │ ressource            │  que la source l'offre   installée  ──▶│ MÊME   │
   ├──────────────────────┤                                        │ BOUCLE │
   │ mettre à             │  les versions            les versions  │        │
   │ niveau               │  offertes                installées    └────────┘
   ├──────────────────────┤
   │ migrer les           │  la version              la version
   │ instances            │  du type                 de chaque instance
   └──────────────────────┘
```

**Aucune de ces entrées n'a de garde qui lui soit propre.** Le refus d'écraser,
la vérification d'idempotence et l'inscription vivent dans la boucle. Une entrée
ordonne et rapporte ; elle ne réimplémente rien.

La génération courante a écrit cette mécanique trois fois sans la reconnaître
(`ANL-001` C15, E4).

## Ce que la boucle ne touche jamais

```
   ┌────────────────────────────────────────────────────────────┐
   │  ✗  l'installation de l'outil sur le poste                 │
   │     un dépôt ne réécrit pas le code qui l'instrumente      │
   ├────────────────────────────────────────────────────────────┤
   │  ✗  le corps d'un document appartenant au dépôt            │
   │     seule une régénération explicite le remplace           │
   ├────────────────────────────────────────────────────────────┤
   │  ✗  un travail fait sur place                              │
   │     refus d'abord, option explicite ensuite                │
   └────────────────────────────────────────────────────────────┘
```
