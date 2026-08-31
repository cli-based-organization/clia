# DIA-004 — Cycle de vie d'une instance

**Situe** `SPC-004`, `RQF-003`.

C'est la capacité qui manque entièrement aujourd'hui. Six types sur dix ne
portent aucune instance, et rien ne ferme ce qui s'ouvre (`ANL-001` M1, M5).

## De la déclaration à l'instance

```
   ┌─────────────────────────┐
   │      DÉFINITION         │   ce que le demandeur fournit :
   │      DU TYPE            │        le type, et le sujet
   │                         │              │
   │  emplacement ───────────┼──────────────┼───▶  où
   │  préfixe ───────────────┼──────────────┼───▶  adresse
   │  gabarit ───────────────┼──────────────┼───▶  structure
   │  version ───────────────┼──────────────┼───▶  version portée
   │  cycle de vie ──────────┼──────────────┼───▶  état initial
   │  régime d'édition ──────┼──────────────┼───▶  qui a le droit d'écrire
   └─────────────────────────┘              │
                                            ▼
                              ┌──────────────────────────┐
                              │        INSTANCE          │
                              └──────────────────────────┘

   ── tout ce qui est dérivable est dérivé, rien de dérivable n'est saisi ──
                                                              SPC-004 S1
```

## Les trois cycles

Un type en déclare un. Trois suffisent aux besoins observés.

```
   POINT FIXE          ce qui vaut à une date
                       analyse, fondation

        ┌────────┐   périmer    ┌─────────┐
        │ actif  │─────────────▶│ périmé  │
        └────────┘              └─────────┘


   VIVANT              ce qui est révisé et versionné
                       définition, spécification

        ┌────────┐   remplacer  ┌───────────┐
        │ actif  │─────────────▶│ remplacé  │
        └───┬────┘              └───────────┘
            │  ▲
            └──┘  réviser — la version avance, l'état ne change pas


   TRAVAIL             ce qui appelle une suite
                       objection, plan, session

                       clore     ┌──────────┐
                    ┌───────────▶│   clos   │
        ┌────────┐  │            └──────────┘
        │ ouvert │──┤
        └────────┘  │            ┌─────────────┐
                    └───────────▶│  abandonné  │
                       abandonner└─────────────┘
```

**`clos` et `abandonné` sont distincts, et la distinction est exigée.** Une
session aboutie et une session laissée en plan qui ne se distinguent pas rendent
tout décompte faux.

## La règle qui commande tout le reste

```
   ┌──────────────────────────────────────────────────────────────┐
   │                                                              │
   │     UN ÉTAT NE CHANGE QUE PARCE QU'UN VERBE L'A CHANGÉ       │
   │                                                              │
   │   ✗  lire le document                                        │
   │   ✗  écrire une réponse à l'intérieur                        │
   │   ✗  le passage du temps                                     │
   │   ✓  une commande, qui laisse une trace                      │
   │                                                              │
   └──────────────────────────────────────────────────────────────┘
```

**Ce que son absence a coûté, mesuré.** En G2 : 217 questions posées à l'humain,
213 réponses reçues, 36 objections sur 38 entièrement répondues, **zéro close**.
Sept valeurs d'état déclarées, deux employées. Zéro verbe de clôture dans le
CLI. Soixante-et-un items ouverts en cinq jours, la courbe jamais décroissante.

Onze jours plus tard, la génération était archivée.

```
   items ouverts, G2, du 2026-08-09 au 2026-08-13

   61 ┤                                        ●
   53 ┤                          ●─────────────
   45 ┤                         ╱
   37 ┤                        ╱
   25 ┤            ●──────────╱
   12 ┤ ●──────────
      └─┬──────────┬──────────┬──────────┬──────┬──
       09         10         11         12     13

              aucun retrait, jamais
```

## La boucle de vérification

```
                       créer
                         │
                         ▼
                   ┌──────────┐
                   │ instance │◀─────────────┐
                   └────┬─────┘              │
                        │                    │ corriger
                        ▼                    │
                   ┌──────────┐   non        │
                   │ valider  │──conforme────┘
                   └────┬─────┘
                        │ conforme
                        ▼
                   ┌──────────┐
                   │  clore   │   ── l'état change, la trace le dit
                   └──────────┘

   la validation ne modifie rien : c'est un constat        SPC-004 S3
   un contrôle sans fondement dans la déclaration n'existe pas
```

## Le régime d'édition engage

```
   humain        │ l'outil pose le fichier et sa structure
                 │ et n'écrit JAMAIS dans le corps
   ──────────────┼──────────────────────────────────────────────
   agent         │ la primitive de génération EXISTE
                 │ sinon → la création est REFUSÉE
                 │ et l'outil nomme ce qui manque au TYPE
   ──────────────┼──────────────────────────────────────────────
   co-édition    │ les zones écrites par l'outil sont délimitées
                 │ et préservées à la régénération
```

Le régime « agent » est celui qui a échoué jusqu'ici : quatre types le déclarent
aujourd'hui, et aucune primitive n'existe (`ANL-001` C8). La règle est donc
formulée comme un refus, non comme une intention.
