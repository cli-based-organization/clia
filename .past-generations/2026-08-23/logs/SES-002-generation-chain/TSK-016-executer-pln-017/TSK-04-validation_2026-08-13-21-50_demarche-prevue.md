# Démarche de validation, tâche 16 de SES-002

`MET-003` étape 4. Écrite avant les contrôles de clôture.

**Réserve** : chacun des quatre critères a été éprouvé sur un dépôt jetable pendant l'exécution, avant de passer au chantier suivant — pas seulement à la fin. Les contrôles ci-dessous rejouent ces mesures ; leur résultat n'est pas une découverte.

1. **Chantier A** : `harnais.yaml` déclare quatre harnais, `ARCHITECTURE.md` optionnel, `CONSTITUTION.md` obligatoire.
2. **Chantier B, critère corrigé** : sur un dépôt jetable, modifier `$source/CLAUDE.md` ne change pas la sortie ; modifier le gabarit la change.
3. **Le fichier racine du dépôt `clia` ressort identique** après les essais du chantier B, vérifié par `diff`.
4. **Chantier C** : `INTENTION.md` est un lien relatif vers `.dev/intentions/INT-001-*.md`, dont le contenu ne porte aucune phrase de l'intention de `clia`, et qui est conforme à son schéma.
5. **Chantier C, les six sections** : le squelette de `INT-001` porte exactement les six sections que `RES-003` déclare, dont la dernière, `Relations`.
6. **Chantier D** : un `INTENTION.md` préexistant est déplacé et lié, son contenu identique mot pour mot avant et après.
7. **Le régime lié tient** : `CLAUDE.md` en `--dev` pointe vers le gabarit, `INTENTION.md` reste une instance locale, jamais un lien vers le dépôt source.
8. **`PLN-017` est passé à `execute`**, l'écart sur le critère B est déclaré dans son propre corps.
9. **`BUG-007` est conforme à son schéma**, et documente un défaut réel, mesuré, non corrigé dans cette tâche.
10. **La suite de tests passe**, avec les quatorze assertions ajoutées.
11. **Le dépôt ne régresse pas** : les instances non conformes après la tâche sont exactement celles d'avant.
12. **`clia setup check` reste `conforme`** sur un dépôt fraîchement instrumenté.
13. **Le journal suit `MET-003`.**
