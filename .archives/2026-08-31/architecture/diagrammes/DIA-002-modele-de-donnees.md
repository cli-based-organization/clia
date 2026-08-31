# DIA-002 — Modèle de données

**Situe** `SPC-002`, `SPC-004`, `RQF-002`, `RQF-005`.

## Les quatre entités et leurs liens

```
   ┌───────────────────────────┐                ┌──────────────────────────┐
   │        PROVENANCE         │                │          DÉPÔT           │
   │  un dépôt d'où l'on tient │◀───déclare─────│  déclaration versionnée  │
   │  quelque chose            │                │  · ce qu'il est          │
   └─────────────┬─────────────┘                │  · ce qu'il tient        │
                 │                              └────────────┬─────────────┘
                 │ offre                                     │ active
                 ▼                                           ▼
   ┌─────────────────────────────────────────────────────────────────────┐
   │                              TYPE                                   │
   │  reconnu à sa DÉFINITION, et à rien d'autre           SPC-002 S2    │
   │                                                                     │
   │  nom · préfixe · version · emplacement · gabarit                    │
   │  régime d'édition · cycle de vie · structure · relations            │
   │                                                                     │
   │  ── tout champ déclaré est employé par une capacité livrée ──       │
   └─────────────────────────────┬───────────────────────────────────────┘
                                 │ décrit la forme de
                                 ▼
   ┌─────────────────────────────────────────────────────────────────────┐
   │                            INSTANCE                                 │
   │  adresse  <PRÉFIXE>-<SÉQUENCE>   locale au dépôt, jetable  S3       │
   │  version portée · état · corps                                      │
   └─────────────────────────────┬───────────────────────────────────────┘
                                 │ renvoie vers
                                 ▼
                          d'autres instances,
                    de types déclarés admissibles
```

## Ce qui est une ressource, et ce qui n'en est pas

Le test tranche seul : *si l'objet n'existe que « de » quelque chose, ce n'est
pas une ressource* (`SPC-002` S1).

```
   RESSOURCE                            CONCEPT RATTACHÉ, ou AUTRE
   ─────────                            ──────────────────────────
   un type                              une commande      (de l'outil)
   une instance                         une fonctionnalité(d'une ressource)
   un dépôt                             une catégorie     (de rangement)
                                        une provenance    (d'une reprise)
                                        un skill          (d'une ressource)
```

**Conséquence de rangement :** ce qui se rattache à un type vit sous ce type, et
l'outil le trouve par balayage. Il n'existe aucun catalogue central
(`SPC-002` S7).

## Les trois choses qu'on appelle « version »

`RQN-004` exige que le mot ne paraisse jamais nu. Il y a trois objets, et pour
une ressource reprise, trois états du même objet.

```
   ┌────────────────────┐   ┌────────────────────┐   ┌────────────────────┐
   │ version de         │   │ version du         │   │ version d'un       │
   │ L'INSTALLATION     │   │ DÉPÔT              │   │ TYPE               │
   │                    │   │                    │   │                    │
   │ le code employé    │   │ ce que le dépôt    │   │ ce que la          │
   │                    │   │ publie             │   │ définition déclare │
   └────────────────────┘   └────────────────────┘   └─────────┬──────────┘
                                                               │
                        pour une ressource reprise ────────────┤
                                                               │
        ┌──────────────────┬─────────────────────┬─────────────┘
        ▼                  ▼                     ▼
   ┌──────────┐      ┌──────────┐        ┌──────────────┐
   │ INSTALLÉE│      │  OFFERTE │        │ DISPONIBLES  │
   │ ce que   │      │ ce que la│        │ ce que       │
   │ j'ai     │      │ source a │        │ l'historique │
   │          │      │ aujourd- │        │ garde        │
   │          │      │ hui      │        │              │
   └──────────┘      └──────────┘        └──────────────┘
        └────── l'écart entre les deux est ce que        │
                le contrôle de conformité signale ───────┘
```

Trois formes coexistaient sans être qualifiées dans la génération courante
(`ANL-001` C10).

## Provenance et catégorie

```
   ✗  CE QUI A ÉTÉ CONFONDU                ✓  CE QUI EST VRAI

   _ressources/                            _ressources/
     └── categorie/                          └── categorie/     ← range
          └── type/                               └── type/
                                            
   « la catégorie qualifie                 toutes les ressources d'un dépôt
     la provenance »                       partagent SA provenance, quelle
                                           que soit leur catégorie
```

La confusion a été commise puis corrigée, et ses traces subsistent dans les
données de production : trois formes de provenance dans six dépôts, dont une
non résolue et une fausse (`ANL-001` C11). `SPC-002` S6.

## Profondeur

Deux niveaux de rangement, jamais trois. Un troisième ne ferait que déplacer la
question de savoir où chercher (`SPC-002` S6).
