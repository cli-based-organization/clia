---
type: fonctionnalite
id: FNC-002
title: "Gestion des sessions"
version: 0.1.0
status: draft
etat: livree
usage: clia ses status|ls|new|close|todo|switch
---

# FNC-002 - Gestion des sessions

> Ouvrir, suivre et changer de session de travail, sans que le point d'entrée déclaré par `CLAUDE.md` ne bouge jamais.

## Ce qu'elle fait

Une session est un répertoire de `.dev/logs/` contenant son énoncé et le journal de ses tâches. `workspace/session.md` est un lien symbolique vers l'énoncé courant : changer de session déplace le lien, rien d'autre.

`clia ses status` compte les tâches déclarées et celles qui sont journalisées jusqu'au message de commit.

## Comment s'en servir

```sh
clia ses status                  # tâches, avancement, durée
clia ses ls                      # toutes les sessions
clia ses new "Description"       # ferme l'ouverte, ouvre la neuve, déplace le lien
clia ses switch SES-001          # déplace le lien, et RIEN d'autre
clia ses close                   # ferme la session courante
```

`switch` accepte `SES-001`, `1` ou le slug du répertoire.

## Ce qu'elle ne fait pas

`new`, `close`, `todo` et `switch` refusent de s'exécuter pour un agent, code 3 : `CONSTITUTION.md` C3.

`close` ne regarde pas le critère de convergence : `ISU-010`.

Une session abandonnée ne se distingue pas d'une session aboutie : `ISU-011`.

## Ce qui la porte

`lib/clia/session.sh`, `RES-034`. Livrée par la tâche 35 de `SES-001`, complétée par `PLN-008`.

## Relations

- `reference` [RES-034](../ressources/RES-034-session.md)
- `reference` [ISU-010](../issues/ISU-010-le-critere-de-convergence-n-est-verifie-par-rien.md)
