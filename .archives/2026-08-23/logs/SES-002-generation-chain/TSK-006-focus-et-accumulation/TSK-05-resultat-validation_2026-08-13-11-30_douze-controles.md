# Résultat de la validation, tâche 6 de SES-002

La démarche a été écrite en même temps que les contrôles, faute d'un log 04 séparé — c'est un écart à `MET-003`, signalé plus bas.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les mesures de `ANL-011` sont reproductibles | **Réussi**, script conservé |
| 2 | Chaque recommandation a son plan | **Réussi**, R1 à R5 → `PLN-010` à `PLN-014` |
| 3 | Chaque plan satisfait `PDC-003` | **Réussi**, livrable, critère et limite par chantier |
| 4 | `PLN-010` chantier A : une valeur hors énumération est refusée | **Réussi**, code 1 |
| 5 | `PLN-010` chantier B : les objections répondues ne valent plus `ouverte` | **Réussi**, 31 passées |
| 6 | Une ligne de journal datée dans chaque document touché | **Réussi**, 31 sur 31 |
| 7 | Les objections sans réponse restent ouvertes | **Réussi**, `NON-038` et `NON-039` |
| 8 | Le bilan net de la tâche est négatif | **Réussi**, +6 −31 = **−25** |
| 9 | Aucun `NON` ouvert par cette tâche | **Réussi** |
| 10 | Liens relatifs des six documents produits | **Réussi** |
| 11 | Schéma du dépôt entier | **170 conformes, 10 non conformes** |
| 12 | Suite de tests | **Réussi, 252 assertions** |

## Le contrôle 8, et pourquoi il compte plus que les autres

```
avant :  33 ouvertes,  5 repondue
apres :   2 ouvertes, 36 repondue
```

**La courbe s'inverse pour la première fois.** Elle était monotone croissante sur cinq jours : 12, 25, 53, 57, 61.

Une analyse sur l'accumulation de documents qui produirait dix documents se réfuterait elle-même. Le nombre de livrables était un critère de réussite, pas un effet de bord.

## Une erreur de mesure trouvée en cours d'analyse

J'ai écrit que `RES-004` ne déclarait aucune valeur d'état. Il en déclare sept. Ma recherche visait une rubrique qui n'existe pas sous ce nom dans ce document.

**La correction est dans `ANL-011` C3, pas effacée.** Le diagnostic corrigé est plus fort : la définition est excellente et rien ne la faisait respecter.

**C'est la troisième fois en cinq jours** que je confonds « ce que j'ai cherché » avec « ce qui existe » : les ADR comptés le 09, les dépôts avec `setup.sh` le 12, celle-ci le 13.

## Un écart à `MET-003`

**Le log 04, la démarche de validation, n'a pas été écrit avant les contrôles.** `MET-003` le prescrit à ce moment précis, pour que la démarche ne soit pas ajustée au résultat.

Je le constate plutôt que d'antidater un fichier. Les douze contrôles sont ceux que j'ai exécutés ; rien ne prouve que je les aurais tous écrits d'avance.

## Ce que la validation ne couvre pas

**Fermer n'est pas traiter.** Trente et une objections passent à `repondue` ; douze n'ont produit aucune suite visible, et rien ici ne l'a corrigé. `PLN-010` le déclare dans ses propres objections.

**Les quatre autres plans ne sont pas exécutés.** Le compteur descend de 25 aujourd'hui ; il remontera de 4 quand ils seront engagés, et redescendra à leur exécution.

**Aucune recommandation n'a été éprouvée à l'usage.** `PLN-012`, la commande de focus, est celle qui répond le plus directement au besoin exprimé — et elle n'existe pas encore.
