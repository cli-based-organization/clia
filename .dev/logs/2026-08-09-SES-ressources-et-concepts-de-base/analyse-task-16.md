# Analyse avant réalisation, tâche 16

## Ce que la question demande d'établir

L'énoncé demande si l'historique est conservable. Deux lectures existent, et elles n'ont pas la même réponse.

| Lecture | Question réelle |
|---|---|
| Par le chemin | `git log` retourne-t-il tous les commits qui ont touché la ressource ? |
| Par le contenu | Existe-t-il, pour chaque version, un identifiant vérifiable et un diff ? |

La première est celle que la commande suggère. La seconde est celle qui répond au besoin de l'énoncé, qui parle de chaîne de modifications et de diff.

Les mesures ont porté sur les deux.

## Le point de bascule de l'analyse

`git log --follow` fonctionne pour un fichier et pas pour un répertoire. La documentation le dit en toutes lettres : « works only for a single file ».

Cette limite aurait conduit à une réponse négative pour le répertoire, et à proposer un mécanisme externe.

La mesure D a écarté cette voie. Tout chemin, fichier ou répertoire, porte déjà un identifiant de contenu, et `git rev-parse HEAD:<chemin>` le retourne. Trois expériences ont établi ses propriétés : déterminisme, indépendance du chemin, indépendance de l'histoire.

**La réponse est donc positive pour les deux formes, par une voie que la question ne suggérait pas.**

## Ce que les mesures ont réfuté

Deux hypothèses tenues pour vraies au départ, et fausses.

**Abaisser le seuil de similarité récupérerait un historique rompu.** Faux. Mesure I : à 10 pour cent comme à 1 pour cent, un commit retourné au lieu de quatre. Git ne stocke pas les renommages, il les recalcule ; deux contenus sans recouvrement ne se relient à aucun seuil.

**Le renommage d'un répertoire changerait son identité.** Faux. Mesure R : identifiant inchangé après déplacement. Le chemin ne fait pas partie de l'identité d'un arbre.

## Le geste qui coupe l'historique

Mesure C3 : un commit qui renomme et réécrit la même ressource au-delà du seuil de similarité rompt la chaîne, définitivement.

Mesure C4 : les deux mêmes gestes en deux commits la préservent.

La contrainte T1 en découle, et elle est la seule des six qui porte sur le découpage d'un commit plutôt que sur une configuration ou une interdiction.

## Ce qui manque au dépôt

Mesure C8 : zéro commit signé sur huit. Clé GPG expirée le 2026-06-18, clés SSH disponibles.

Sans signature, la chaîne de hachages atteste la cohérence d'une suite de versions. Elle n'atteste ni l'auteur ni la date. C'est exactement l'écart entre ce que l'énoncé suppose et ce que le dépôt possède.

La contrainte T4 est donc la seule des six qui soit à la fois non tenue et résoluble par une ligne de configuration.

## Pourquoi les recommandations ne proposent aucun mécanisme nouveau

Les constats C5 et C6 établissent que la chaîne et le diff existent nativement, pour les trois formes d'implémentation, par une seule requête.

Les sept options examinées se répartissent en deux groupes : celles qui ajoutent ce qui manque, l'auteur et la date, et celles qui reconstruisent ce qui existe déjà. Seules les premières sont retenues.

## Traitement de la prémisse « git est un blockchain »

L'énoncé fonde son raisonnement dessus. La prémisse est inexacte, et l'écart porte sur ce qui compte ici.

Ce que git partage avec une blockchain suffit à la chaîne de modifications et au diff. Ce qui lui manque, consensus, horodatage vérifiable, non-réécriture, est ce qui transforme une chaîne cohérente en preuve.

Le constat C9 le pose sous forme de table plutôt qu'en objection : la prémisse ne change pas la réponse aux trois questions, elle change ce que le dépôt peut affirmer de son historique. La recommandation R7 en tire la conséquence.

## Ce qui n'a pas été mesuré

Le changement de forme d'une ressource, un fichier devenu répertoire. La contrainte T6 en est déduite, non mesurée.

Le coût de calcul sur un dépôt réel. Huit commits ne permettent aucune extrapolation.

Les trois outils d'ancrage externe. Aucun n'est installé ; leurs verdicts reposent sur leur documentation.
