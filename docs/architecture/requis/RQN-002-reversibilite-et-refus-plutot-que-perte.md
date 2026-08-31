# RQN-002 — Réversibilité, et refus plutôt que perte

## L'exigence

Aucun geste de l'outil ne détruit du travail sans qu'un refus explicite ait
d'abord été opposé et qu'une option ait été fournie pour passer outre.

Tout ce que l'outil pose, il sait le retirer — exactement, et rien d'autre.

## Portée

Toute commande qui écrit, hors du dépôt comme dedans.

## Pourquoi c'est opposable

Un outil qui peut faire perdre du travail est un outil qu'on n'ose pas lancer,
et un outil qu'on n'ose pas lancer ne sert à rien. La réversibilité n'est pas une
précaution : c'est ce qui rend l'automatisme utilisable.

## Comment on le constate

| Contrôle | Constat attendu |
|---|---|
| Installation puis retrait | La configuration de l'utilisateur retrouve son état à l'octet près |
| Reprise d'une copie modifiée sur place | Un refus, le nom de ce qui serait perdu, une option pour forcer |
| Application d'une réparation | Ce qui est écrit est versionné, donc visible et défaisable par le contrôle de version |
| Essai sans installation | Fermer le terminal suffit à revenir en arrière |

## La règle qui en découle

**Un dépôt ne réécrit jamais le code qui l'instrumente.** Mettre à jour ce
qu'un dépôt tient d'ailleurs et déplacer l'outil lui-même sont deux gestes
distincts, sous deux autorités distinctes.

## Origine

G1 a archivé son propre moyen d'installation avec le reste de son code et s'est
réveillée sans pouvoir être installée (`ANL-001` R1, E9). La règle finale est
posée par `USE-007`.
