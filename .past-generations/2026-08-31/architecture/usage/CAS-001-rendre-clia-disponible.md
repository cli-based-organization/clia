# CAS-001 — Rendre clia disponible sur un poste, et l'en retirer

## Acteur

**L'installateur** : la personne qui veut se servir de clia sur sa machine, ou
l'y remettre après un changement d'emplacement. Elle n'a pas de privilèges
d'administration et ne veut pas en demander.

## Situation avant

La commande n'existe pas sur le poste, ou elle existe et l'installateur ne sait
plus d'où elle vient ni sur quelle copie du code elle travaille.

## Ce qu'il veut

Trois choses distinctes, qu'il confond souvent tant qu'on ne les lui a pas
séparées :

1. **Essayer** sans rien laisser sur sa machine.
2. **Travailler** durablement, la commande disponible dans toute session.
3. **Défaire** exactement ce qui a été posé, sans reste.

## Le récit

L'installateur récupère le dépôt source et demande la disponibilité. L'outil
lui dit ce qu'il va poser, où, et sous quel régime. S'il en existe déjà une, il
refuse et nomme celle qui existe plutôt que de l'écraser.

Quand il n'en a plus besoin, il demande le retrait. Ce qui avait été posé
disparaît ; ce qui ne l'avait pas été n'est pas touché.

```sh
# intention d'usage, non une interface
essayer          # rien n'est écrit sur le disque
installer        # disponible dans les sessions suivantes
retirer          # exactement ce qui a été posé
```

## À quoi il voit que c'est fait

- La commande répond, et sait dire **d'où vient le code qu'elle exécute** et
  **sur quoi elle travaille**.
- Après un essai, fermer le terminal suffit à revenir à l'état d'avant.
- Après un retrait, aucune trace ne subsiste dans sa configuration de shell.

## Ce qui doit échouer, et bien

| Situation | Ce que l'acteur doit obtenir |
|---|---|
| Une installation existe déjà | Un refus qui nomme l'existante, et l'option qui passe outre |
| Le dépôt source a été déplacé | Un message qui dit que le lien est rompu et comment le refaire |
| Une dépendance manque | Le nom de ce qui manque, **avant** que quoi que ce soit soit écrit |

## Ce que ce cas n'inclut pas

L'installation de clia et l'instrumentation d'un dépôt sont deux gestes
distincts, et le rester est un invariant (`ANL-001` E9). Instrumenter un dépôt
est `CAS-002`.

## Origine

`USE-001` de la génération courante, et le constat que G1 a archivé son moyen
d'installation avec le reste de son code, se réveillant sans pouvoir être
installée (`ANL-001` R1).
