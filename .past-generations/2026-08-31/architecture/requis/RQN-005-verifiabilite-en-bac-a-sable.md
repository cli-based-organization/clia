# RQN-005 — Vérifiabilité en bac à sable

## L'exigence

Tout comportement spécifié est couvert par un cas exécutable. Les cas
s'exécutent dans un environnement jetable, et **vérifient en dernière assertion
que l'environnement réel n'a pas bougé**.

Un banc ne s'arrête pas au premier échec : corriger le premier ne renseigne que
sur le premier.

## Portée

L'ensemble du code livré, y compris l'installation et la désinstallation.

## Pourquoi c'est opposable

C'est ce qui autorise les refontes. La génération courante a changé trois fois
la disposition de ses répertoires en quatre jours sans rien casser ; aucune
génération précédente ne pouvait se le permettre, et les deux sont mortes de
refontes qu'elles n'osaient pas mener.

C'est aussi ce qui rend `RQN-001` et `RQN-002` constatables plutôt que promis.

## Comment on le constate

| Contrôle | Constat attendu |
|---|---|
| Exécution du banc complet | Un décompte de cas, et zéro échec |
| Après exécution | Le dépôt réel et la configuration réelle de l'utilisateur sont inchangés |
| Un comportement spécifié | Au moins un cas le vérifie, y compris son refus |
| Un cas en échec | Les suivants s'exécutent quand même |

## Le repère chiffré

| Génération | Lignes de production | Lignes de tests | Ratio |
|---|---|---|---|
| G1 | 1 148 | 326 | 0,28 |
| G2 | 4 686 | 1 443 | 0,31 |
| G3 | 5 658 | 2 889 | **0,51** |

Le ratio de G3 est le plancher, non la cible.

## Origine

`ANL-001` C4, B2, V7.
