# RQN-006 — Portabilité et sobriété des dépendances

## L'exigence

Les dépendances externes sont **nommées, peu nombreuses, et vérifiées avant tout
effet de bord**. Une dépendance manquante produit un refus qui la nomme, et rien
n'a été écrit à ce moment-là.

Aucune dépendance n'est requise pour **lire** ce que le dépôt contient : un
dépôt instrumenté reste compréhensible sans l'outil qui l'a instrumenté.

## Portée

L'installation, et toute commande.

## Pourquoi c'est opposable

Un dépôt instrumenté survit à l'outil qui l'a instrumenté. Le corpus en compte
huit, équipés par un outil mort depuis, et dont le contenu reste lisible parce
qu'il est en texte. C'est la propriété qui a le mieux résisté au temps dans
toute cette histoire.

Le vérifier **avant** d'écrire est ce qui distingue un refus propre d'une
installation à moitié faite.

## Comment on le constate

| Contrôle | Constat attendu |
|---|---|
| Dépendance retirée du chemin | Refus nommant ce qui manque, et aucun fichier écrit |
| Dépôt instrumenté, outil absent | Tout le contenu reste lisible et modifiable à la main |
| Liste des dépendances | Explicite, courte, justifiée une par une |
| Format des déclarations | Lisible et éditable sans outil dédié |

## Le corollaire de forme

Ce que le dépôt porte est du **texte**, structuré par des conventions et non par
un format propriétaire. C'est la condition de tout le reste : de la lecture par
un humain, de la lecture par un agent, du suivi par un contrôle de version, et
de la survie à l'outil.

## Origine

`ANL-001` C2. La liste de dépendances vérifiée avant écriture est une pratique
de G1 conservée par G3.
