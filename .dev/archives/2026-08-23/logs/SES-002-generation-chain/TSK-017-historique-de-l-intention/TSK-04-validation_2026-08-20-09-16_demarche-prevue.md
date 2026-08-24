# Démarche de validation, tâche 17 de SES-002

`MET-003` étape 4. Écrite avant l'exécution des contrôles.

1. `ANL-014` existe dans `.dev/analyses/` et respecte le schéma `analyse.template.md` (frontmatter complet, sections requises).
2. Elle répond aux deux volets explicites de la demande : quels dépôts utilisent la notion, quels documents en discutent.
3. Les liens `Relations` pointent vers des ressources qui existent réellement dans `clia` (`RES-003`, `ADR-003`, `PLN-017`).
4. `clia res ls ANL` affiche `ANL-014` sans erreur.
5. Aucun fichier hors `.dev/analyses/` et `.dev/logs/SES-002-generation-chain/TSK-017-.../` n'a été modifié — c'est une tâche de lecture sur `$HOME/git/*`, rien n'y a été écrit.
6. Le journal suit `MET-003` : les horodatages de `demande`, `analyse`, `fait` sont distincts et croissants.
