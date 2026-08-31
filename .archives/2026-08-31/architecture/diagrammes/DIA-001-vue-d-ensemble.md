# DIA-001 — Vue d'ensemble

**Situe** `SPC-001`, `SPC-002`, `SPC-003`, `RQF-001`, `RQF-004`.

Un diagramme ne décide rien. Tout élément qui apparaît ici est établi ailleurs,
et le renvoi est donné.

## Les trois acteurs et leurs registres

```
        ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
        │    HUMAIN    │      │     CLI      │      │    AGENT     │
        │              │      │ automatisme  │      │      IA      │
        ├──────────────┤      ├──────────────┤      ├──────────────┤
        │ décide       │      │ ce qui est   │      │ ce qui       │
        │ arbitre      │      │ déterminis-  │      │ demande du   │
        │ répond       │      │ te et        │      │ jugement     │
        │              │      │ vérifiable   │      │              │
        └──────┬───────┘      └──────┬───────┘      └──────┬───────┘
               │                     │                     │
               │   demande           │   garantit          │   produit
               ▼                     ▼                     ▼
        ┌──────────────────────────────────────────────────────────┐
        │                    LE DÉPÔT INSTRUMENTÉ                  │
        │        texte versionné, lisible sans l'outil             │
        └──────────────────────────────────────────────────────────┘
```

**Ce que le CLI garantit, l'agent n'a plus à le garantir.** C'est le seul motif
pour lequel une partie du travail d'un agent devient vérifiable (`RQN-001`).

**Le refus est la forme du respect des registres.** Quand une réparation
déciderait à la place de l'humain, l'outil nomme l'écart et n'écrit pas
(`SPC-003` S3, classe réservée).

## Les couches du CLI

```
   ╔══════════════════════════════════════════════════════════════╗
   ║  A. POINT D'ENTRÉE                                           ║
   ║     trouve · résout le périmètre · applique la garde         ║
   ║     compose l'aide à partir de ce qu'il a trouvé   SPC-001   ║
   ║     ─ ne connaît aucune commande ─                           ║
   ╚═══════════════════════════╤══════════════════════════════════╝
                               │ transmet le contexte résolu
   ┌───────────────────────────┴──────────────────────────────────┐
   │  B. LES VERBES                                               │
   │     ls · info · new · check · apply · close · explain        │
   │     petit ensemble stable, ouvert par objet       SPC-001 S2 │
   └───────────────────────────┬──────────────────────────────────┘
                               │ s'appuient sur
   ┌───────────────────────────┴──────────────────────────────────┐
   │  C. LA BOUCLE                          SPC-003               │
   │     déclarer → constater → différer → appliquer              │
   │     une seule mécanique, cinq entrées                        │
   └───────────────────────────┬──────────────────────────────────┘
                               │ lit et écrit
   ┌───────────────────────────┴──────────────────────────────────┐
   │  D. LE MODÈLE                          SPC-002               │
   │     type · instance · dépôt · provenance                     │
   │     déclaré en données, jamais en code                       │
   └──────────────────────────────────────────────────────────────┘
```

**Le sens des flèches est unique** : une couche connaît celle du dessous, jamais
celle du dessus. Le point d'entrée ne connaît aucune commande ; la boucle ne
connaît aucun verbe ; le modèle ne connaît rien.

## Ce que le noyau ne contient pas

```
                 ┌─────────────────────────────────┐
                 │            NOYAU                │
                 │  point d'entrée · verbes ·      │
                 │  boucle · lecture du modèle     │
                 └────────────┬────────────────────┘
                              │ trouve, n'énumère pas
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
   ┌──────────┐         ┌──────────┐         ┌──────────┐
   │  types   │         │commandes │         │ gabarits │
   │déclarés  │         │ déposées │         │primitives│
   └──────────┘         └──────────┘         └──────────┘
        │                     │                     │
        └─────────────────────┴─────────────────────┘
                     tous découverts par balayage
                     tous extensibles sans toucher au noyau
                                                RQF-001, RQF-002
```

C'est le seul mécanisme que trois générations n'ont jamais remis en cause
(`ANL-001` C13). Sa généralisation aux types, aux gabarits et aux primitives est
l'axe de conception le plus sûr (principe P1).

## Les deux frontières à ne pas franchir

| Frontière | Ce qu'elle sépare | Établie par |
|---|---|---|
| **Installer / instrumenter** | l'outil sur le poste ↔ le dépôt outillé | `RQN-002`, `ANL-001` E9 |
| **Poser / rédiger** | le fichier, le nom, la structure ↔ ce qu'il y a à dire | `SPC-004` S6, `ANL-001` E7 |

G1 est morte d'avoir franchi la première : elle a archivé son moyen
d'installation avec le reste de son code.
