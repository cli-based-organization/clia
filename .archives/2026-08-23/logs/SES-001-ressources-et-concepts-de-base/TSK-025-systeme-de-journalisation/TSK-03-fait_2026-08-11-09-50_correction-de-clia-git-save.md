# Ce qui a été fait, tâche 25 — troisième versement

Écrit au moment de la correction, découverte pendant l'exécution des contrôles. Troisième versement du log `fait`.

## Un défaut introduit par cette tâche, et corrigé

Le contrôle de `clia git check done` a révélé que la commande trouvait encore le message de la tâche 23-24 comme le plus récent, alors que celui de la tâche 25 venait d'être écrit.

**Cause.** `clia_git_message_file` cherche `commit-message-task-*.yaml` et `commit-message.yaml`. Le nommage prescrit par le correctif C4 produit `TSK-07-commit-message_<horodatage>_<slug>.yaml`, qui ne correspond à aucun de ces motifs.

Le nouveau format de journalisation cassait donc `clia git save`.

**Correction.** Le motif de recherche accepte désormais les deux formes. Les deux coexistent parce que `NON-028` Q1 laisse la migration ouverte : refuser l'ancienne forme rendrait les 116 logs existants inatteignables.

```
TSK-*-commit-message_*.yaml       MET-003, en vigueur
commit-message-task-*.yaml        forme antérieure
commit-message.yaml
```

**Vérification.** `clia git check done` désigne maintenant le message de cette tâche.

**Test ajouté.** Une assertion vérifie que le nommage de `MET-003` est reconnu et prime, étant plus récent. La suite passe de 124 à 125 assertions, toutes vertes.

## Ce que cet incident montre

Le correctif C4 change une convention de nommage, et l'outillage qui lit ces noms n'était pas dans la liste des huit correctifs.

C'est le même mécanisme que `ADR-008` D3 décrit pour les alias : un changement de nom doit propager la mise à jour à tout ce qui le cite. Ici, ce qui citait le nom était du code, non un renvoi documentaire.
