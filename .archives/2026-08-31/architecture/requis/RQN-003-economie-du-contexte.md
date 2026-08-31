# RQN-003 — Économie du contexte

## L'exigence

Toute sortie rend **exactement ce qui a été demandé**, et rien de plus. La
divulgation est progressive : on obtient un aperçu, puis on demande le détail.

## Portée

Toute sortie destinée à être lue — par un humain comme par un agent.

## Pourquoi c'est opposable

Le contexte d'un agent est une ressource rare et payante. C'est l'argument
principal en faveur d'un CLI plutôt qu'une interface programmatique : une
commande retourne le résultat filtré, là où une interface tend à retourner des
objets complets.

Pour l'humain, la contrainte est la même sous un autre nom : une sortie qui ne
tient pas dans un écran n'est pas lue.

## Comment on le constate

| Contrôle | Constat attendu |
|---|---|
| Une liste | Une ligne par élément, les colonnes qui distinguent, rien d'autre |
| Un état | Ce qui varie ; jamais un champ identique dans toutes les lignes |
| Un rapport | Le constat d'abord, le détail sur demande |
| Une projection de focus | Un écran, un geste |

**Le contre-exemple mesuré :** en G2, la commande de liste affichait un champ
qui valait la même chose dans les cent soixante-trois instances du dépôt, et
n'affichait jamais celui qui variait.

## Ce que l'exigence interdit

Une sortie qui dit tout « au cas où ». L'information non demandée n'est pas
gratuite : elle coûte l'attention de l'humain et le contexte de l'agent.

## Origine

`PDC-005`. `FND-001` de G2 section 4.5. `ANL-011` de G2, constat C4.
