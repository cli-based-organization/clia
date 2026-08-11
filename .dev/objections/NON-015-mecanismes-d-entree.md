---
type: objection
id: NON-015
title: "Mécanismes d'entrée de l'humain dans le système"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-008, RES-009, RES-030, ADR-002]
---

# NON-015 - Mécanismes d'entrée de l'humain dans le système

> La tâche 8 demande de vérifier s'il existe d'autres mécanismes d'entrée que ceux dont l'humain se souvient. Le relevé en trouve sept, et deux d'entre eux sont hors du modèle.

## Journal

- 2026-08-10 : ouverte par l'agent, aux tâches 8 et 9 de la session du 2026-08-09.

## Ce qui est contesté

La tâche 8 énumère trois mécanismes d'entrée existants : le répertoire `source-material`, les objections, les entrevues. Elle demande de vérifier s'il y en a d'autres.

**Le relevé en trouve sept.** Quatre étaient connus, trois ne l'étaient pas.

| Mécanisme | Statut | Modélisé |
|---|---|---|
| Le fichier de session | En usage, point d'entrée principal | Non : `ADR-001` D8 le place hors du modèle |
| `source-material` | Présent dans dix dépôts du corpus | **Non** : aucun type ne le couvre |
| Objection `NON` | En usage, onze instances | Oui, `RES-004` |
| Entrevue `ENT` | Défini, jamais éprouvé | Oui, `RES-030` |
| Fragment `FRG` | Créé par la tâche 8 | Oui, `RES-008` |
| Décision `DCN` | Créée par la tâche 8 | Oui, `RES-009` |
| **La réponse à une question d'objection** | En usage de fait, cent une questions attendent une réponse | **Non** |

Les deux derniers du tableau sont les trouvailles du relevé. `source-material` est employé dans dix dépôts et n'a aucun type. Et la réponse à une objection est le mécanisme d'entrée le plus employé du dépôt sans être reconnu comme tel : cent une questions attendent une réponse écrite de l'humain, et cette réponse est une entrée d'information au même titre qu'un fragment.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Un mécanisme d'entrée non modélisé échappe à toute règle.** `ANL-001` mesure au défaut D2 ce que produit l'absence de règle sur ce qui entre : trois `INTENTION.md` identiques désignant le mauvais client, dix-huit logs recopiés d'un dépôt à l'autre.

**Le fragment recouvre peut-être `source-material`.** Les deux captent de la matière venue d'ailleurs. Si le fragment le remplace, dix dépôts du corpus ont un répertoire à migrer. S'il coexiste, il faut dire ce qui départage.

**La réponse à objection est le point d'entrée le plus actif et le moins outillé.** L'humain répond dans le bloc prévu, et rien n'en tire de conséquence : ni fait, ni décision, ni mise à jour de la ressource contestée. Le mécanisme s'arrête à la réponse.

## Questions

### Q1 - Le fragment remplace-t-il `source-material`, ou coexiste-t-il avec lui ?

`RES-008` propose une distinction : le matériel source est importé dans son format d'origine et reste hors du modèle, le fragment est une ressource typée en markdown. La distinction tient, et elle laisse dix répertoires `source-material` du corpus sans type.

**Réponse.**

### Q2 - La réponse à une question d'objection est-elle une entrée modélisée ?

Cent une questions attendent une réponse. Quand l'humain répond, faut-il en tirer une `DCN` si la réponse tranche un cap, un `FCT` si elle établit un fait, ou rien ?

`RES-009` propose que la réponse suffise tant qu'elle ne change pas une décision antérieure. C'est une position, non une règle outillée.

**Réponse.**

### Q3 - Qui vérifie qu'une décision enregistrée est fidèle à sa source ?

Une `DCN` qui déforme la décision qu'elle enregistre est plus dangereuse qu'une absence de `DCN`, parce qu'elle devient citable.

**Réponse.**

### Q4 - Une décision externe doit-elle porter son texte, ou seulement son renvoi ?

Le cas est réel : vingt PDF réglementaires dans un dépôt du corpus. Porter le texte le rend citable et pose une question de droit de reproduction. Ne porter que le renvoi rend la `DCN` dépendante de la disponibilité de la source.

**Réponse.**

### Q5 - Un fragment non exploité doit-il être signalé au bout d'un temps donné ?

Le champ `exploitation` rend visible ce qui dort, et rien ne le relit. Sans relecture, le fragment devient le dépotoir que son test d'admission voulait éviter.

**Réponse.**

### Q6 - Le fichier de session est-il un mécanisme d'entrée modélisé ?

Il est le principal, et il est hors du modèle. La question recoupe `NON-009` Q1 sur le statut de la session, et elle en est le versant « entrée ».

**Réponse.**

### Q7 - Faut-il un type pour le matériel source, ou reste-t-il hors modèle ?

Dix dépôts du corpus en ont un. `ADR-004` D1 le rend modélisable, puisqu'une ressource n'est plus définie par son format.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2. La première fixe le sort de dix répertoires existants, la seconde outille le mécanisme d'entrée le plus actif du dépôt.

## Relations

- `objecte-a` [RES-008](../ressources/RES-008-fragment.md)
- `objecte-a` [RES-009](../ressources/RES-009-decision.md)
- `objecte-a` [RES-030](../ressources/RES-030-entrevue.md)
- `reference` [NON-009](NON-009-statut-de-la-session-et-convergence.md)
