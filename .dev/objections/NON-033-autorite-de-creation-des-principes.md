---
type: objection
id: NON-033
title: "L'autorité de création des principes bloque un chantier"
status: draft
initiateur: agent
effet: bloquant
etat: repondue
porte-sur: [RES-012, PDC-003]
---

# NON-033 - L'autorité de création des principes bloque un chantier

> `CONSTITUTION.md` C1 interdit à l'agent de créer un `PDC`. Un chantier de `PLN-005` en demande un. Et `PDC-003` a été produit par l'agent sur une analogie que rien ne fonde.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 29, avec `ISU-005`.
- 2026-08-11 : **reprend `NON-027` Q1**, signalé au ménage de la tâche 30. La question est posée depuis la tâche 23 ; ce qui change est qu'elle bloque maintenant un chantier.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

**Un chantier est bloqué par une règle, non par un manque technique.** Le chantier E de `PLN-005` demande un `PDC` sur la distillation, à la demande de la réponse Q4 de `NON-004`. C1 l'interdit.

**Un précédent existe et n'est pas régularisé.** `PDC-003` a été produit par l'agent à la tâche 23, déclaré non actif par analogie avec `DCN-013`. L'analogie n'est écrite nulle part, et `NON-027` Q1 la porte depuis le 2026-08-11.

**La règle qui bloque est plus stricte que la décision qui lui est supérieure.** `DCN-013` autorise l'agent à rédiger un premier jet de décision, suspendu jusqu'à approbation. C1 interdit les deux types sans distinguer. `ANL-006` C2 établit le conflit ; `PLN-003` chantier A propose de l'aligner ; ni l'un ni l'autre n'est exécuté.

## Pourquoi cela ne peut pas rester implicite

**Le blocage est asymétrique et rend la règle inefficace.** L'agent peut produire le gabarit d'un `PDC`, ce qui ne sert à rien : ce qui compte dans un principe est son contenu.

**Deux conduites contradictoires ont déjà été appliquées.** Aux tâches 21 et 22, deux gabarits vides de `DCN` ont été laissés à l'humain. À la tâche 23, un `PDC` complet a été produit et déclaré non actif. Rien ne dit laquelle est juste.

**Le conflit entre C1 et `DCN-013` est ouvert depuis deux jours** et il produit ces incohérences.

## Questions

### Q1 - Un agent peut-il produire un premier jet de `PDC` ?

C'est la même question que `NON-027` Q1, et elle bloque désormais un chantier.

Trois positions. Étendre aux `PDC` le régime que `DCN-013` fixe pour les décisions. Maintenir l'interdit strict, auquel cas `PDC-003` est à retirer. Ou distinguer selon que l'humain a demandé.

**Réponse.**

### Q2 - Faut-il exécuter le chantier A de `PLN-003` d'abord ?

Il aligne C1 sur `DCN-013` : la création reste à l'humain, la rédaction est permise, le résultat est suspendu. Un fichier, trois éditions, aucun outil.

Tant qu'il n'est pas fait, chaque `PDC` et chaque `DCN` demandés se heurtent au même conflit.

**Réponse.**

### Q3 - Que devient `PDC-003` ?

Il est déclaré non actif dans son propre texte. Si Q1 tranche pour l'interdit strict, il est irrégulier et doit être retiré ou réécrit.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1.

L'effet est `bloquant` : un chantier de `PLN-005` ne peut pas avancer, et un document existant est dans un état irrégulier.

## Relations

- `objecte-a` [RES-012](../ressources/RES-012-principe-de-conception.md)
- `repond-a` [ISU-005](../issues/ISU-005-l-agent-ne-peut-pas-creer-un-principe-de-conception.md)
- `reference` [NON-027](NON-027-regime-smart-et-type-issue.md)
