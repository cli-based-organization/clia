---
type: objection
id: NON-040
title: "Portée de la politique d'autorisation"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [BUG-001, DCN-017, ANL-012, PLN-015]
---

# NON-040 - Portée de la politique d'autorisation

> Le correctif de `BUG-001` consiste à donner au dépôt le pouvoir d'autoriser l'agent sans demander. Jusqu'où, et au nom de quelle règle : ni l'un ni l'autre n'est écrit.

## Journal

Ouverte le 2026-08-13, tâche 10 de `SES-002`, en produisant `ANL-012` et `PLN-015`.

**C'est la seule objection de cette tâche.** `ANL-012` a tranché seule tout le reste : le diagnostic, le classement des quinze interruptions, l'écart des trois pistes, le choix de la quatrième. Deux points seulement passent du côté « s'arrêter » du filtre de `MET-005` étape 2, et les voici.

## Ce qui est contesté

### Q1. Jusqu'où la politique autorise-t-elle ?

Deux lectures existent, et elles mènent à des travaux incompatibles.

| Lecture | Ce que le hook autorise | Ce que cela vaut |
|---|---|---|
| **Liste blanche** | Une commande dont tous les exécutables sont nommés dans une liste du dépôt | L'agent reste borné. Chaque outil neuf demande une mise à jour |
| **Complément du refus** | Tout ce que `deny` et le hook `C2` n'interdisent pas | Plus rien ne se demande. C'est `bypassPermissions`, écrit dans le dépôt |

**La seconde n'est pas un choix de mise en œuvre, c'est un changement de régime.** Elle rendrait `BUG-001` invisible au lieu de le résoudre : zéro interruption, et zéro jugement.

Je propose la première. **Je ne la retiens pas d'autorité** : elle décide de ce qu'un agent peut faire sur cette machine sans que personne le voie.

### Q2. Quelle règle le correctif sert-il ?

`BUG-001` déclare enfreindre `DCN-017`. **`DCN-017` est un squelette vide** : ni objet, ni décision, ni portée, ni conséquences, et cinq champs à renseigner.

`RES-036` définit le bogue par la règle qu'il enfreint. Sans le corps de `DCN-017`, `BUG-001` constate un écart à une intention, pas à une règle.

`CONSTITUTION.md` C1 réserve la rédaction des décisions à l'humain. **Je ne peux pas combler ce vide**, et le plan ne peut pas déclarer atteindre une cible que personne n'a écrite.

### Q3. Que devient `settings.local.json` ?

Il pèse 12 936 octets contre 3 602 pour la politique versionnée, et porte des règles nées dans d'autres dépôts — `cryptosecops`, `disruptiva-dev`, `ticket-driven-ai` — ainsi que des chemins qui n'existent pas ici.

Ce n'est pas une cause d'interruption. **C'est un obstacle au diagnostic** : on ne peut pas savoir, en lisant le dépôt, ce qui est effectivement autorisé.

Le nettoyer est réversible et sans risque — mais le fichier appartient à l'utilisateur, pas au dépôt, et il porte peut-être des règles utiles ailleurs. Je ne le touche pas sans un mot.

## Pourquoi cela ne peut pas rester implicite

**Q1 est le seul point de cette tâche dont l'erreur ne coûterait pas une correction.** Une liste blanche trop large donne à l'agent un pouvoir que personne ne regarde, et l'effet ne se voit pas : il se voit quand quelque chose a déjà été fait.

Les trois autres lignes du filtre rangeraient Q1 du côté « avancer » — c'est du code, c'est réversible, une lecture raisonnable existe. **La quatrième suffit à arrêter**, et `MET-005` pose que les quatre se lisent ensemble.

**Q2 bute sur `C1`**, qui est un interdit et non un jugement.

## Questions

1. La politique autorise-t-elle **par liste blanche d'exécutables**, ou **tout ce qui n'est pas interdit** ?
2. Si liste blanche : quels exécutables au départ ? Je propose ceux qui figurent déjà en `allow` dans `settings.json`, plus ceux qu'exigent les scripts d'épreuve — `mktemp`, `md5sum`, `readlink`, `source`.
3. Une commande qui écrit **hors du dépôt et hors du répertoire de travail temporaire** doit-elle rester demandée, quelle que soit la liste ?
4. `DCN-017` sera-t-elle rédigée ? Sans son corps, le plan vise une intention et non une règle.
5. `settings.local.json` peut-il être réduit aux règles qui concernent ce dépôt ?

## Ce qui lèverait cette objection

Une réponse à Q1 et Q3 suffit à débloquer `PLN-015` : ce sont les deux qui décident du contenu de la politique.

Q2 peut être tranchée en avançant si Q1 l'est — la liste initiale est un détail réversible.

Q4 appartient à l'humain seul, `CONSTITUTION.md` C1.

Q5 est un oui ou un non.

## Relations

- `derive-de` [ANL-012](../analyses/ANL-012-interruptions-de-l-execution-autonome.md)
- `porte-sur` [BUG-001](../bogues/BUG-001-execution-de-claude-cli-sans-interruption.md)
- `reference` [PLN-015](../plans/PLN-015-politique-d-autorisation-du-depot.md)
