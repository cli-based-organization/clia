# Résultat de la validation

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Le banc de la garde | **Réussi, 51 cas** |
| 2 | Les six verbes, toutes formes | **Réussi** |
| 3 | La lecture passe | **Réussi** |
| 4 | Un document qui cite sans exécuter | **Réussi**, après correction |
| 5 | Bout en bout sous le mode le plus permissif | **Réussi, 0 commit** |
| 6 | La lecture de bout en bout | **Réussi** |
| 7 | JSON valide | **Réussi** |
| 8 | `.claude/` versionnable | **Réussi**, non ignoré |
| 9 | Les commandes réelles de la session | **Réussi, 10 sur 10** |
| 10 | Suite de tests du dépôt | **Réussi, 219 assertions** |
| 11 | Journal `MET-003` | **Réussi** |

## Le contrôle qui compte le plus

**Le cinquième.** Une tentative réelle, dans un dépôt jetable, avec le mode qui contourne toutes les vérifications de permission : aucun commit n'a été créé, et le refus a été rapporté avec son motif.

C'est ce qui distingue cette politique d'une préférence : elle tient même quand l'invocation demande de ne rien vérifier.

## Ce que la validation n'a pas couvert

**La garde n'a pas été éprouvée dans un autre dépôt que celui-ci.** L'intention de `SES-002` est l'usage dans n'importe quel dépôt, et la politique dépend de `python3` et de la variable de répertoire projet.

**Le banc ne couvre que les formes auxquelles j'ai pensé.** Trois défauts sur quatre ont été trouvés en éprouvant, dont un seulement en usage réel — ce qui suggère que d'autres formes échappent encore au banc.

**Rien ne vérifie que la politique reste chargée.** Les réglages sont lus au démarrage d'une session : une session ouverte avant leur écriture ne les applique pas.
