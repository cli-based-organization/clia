# SPC-005 — Contrat de sortie, codes de retour et formats

**Répond à** `RQF-001`, `RQF-006`.
**Contrainte par** `RQN-003`, `RQN-004`.

## Objet

Fixer ce que l'outil écrit, où il l'écrit, et ce que son code de retour signifie.

La sortie sert **trois lecteurs** : l'humain qui lit, l'agent qui interprète, et
le programme qui analyse. Les trois lisent la même exécution.

## S1 — Deux flux, une règle

| Flux | Ce qui y va |
|---|---|
| **Sortie standard** | ce qu'un autre programme viendrait lire : les données demandées |
| **Sortie d'erreur** | tout le reste : diagnostics, avertissements, progression, refus |

La règle se teste : *rediriger la sortie standard vers un fichier doit produire
un fichier exploitable, et laisser l'humain informé à l'écran.*

## S2 — Anatomie d'un message

Un message dit **ce qui s'est produit**, puis **ce que le lecteur peut faire
ensuite**.

```
<outil>: <ce qui s'est produit>
         <ce que le lecteur peut faire ensuite>
```

Un constat sans suite oblige à deviner, et c'est le défaut le plus coûteux
mesuré dans ce corpus : une génération entière a su dire ce qui bloquait sans
jamais dire quoi faire pour débloquer.

**« Rien à faire » est une réponse pleine**, et elle se distingue de « rien
compris ».

## S3 — Codes de retour

Trois codes, et pas davantage. Ils sont documentés dans l'aide générale, et
redocumentés dans l'aide de chaque commande.

| Code | Sens |
|---|---|
| `0` | la demande est satisfaite, **même s'il n'y avait rien à faire** |
| `1` | refus : la demande est comprise, et l'outil ne la satisfait pas |
| `2` | la demande est mal formée |

**La distinction entre 1 et 2 est opposable** : `2` dit que l'appelant s'est
trompé de formulation, `1` dit que l'outil a compris et refuse. Un agent qui
reçoit `2` doit reformuler ; un agent qui reçoit `1` doit changer de geste.

Un constat qui trouve des dérives sans écart bloquant sort en `0` : la dérive
avertit, elle n'empêche pas (`SPC-003` S3).

## S4 — Deux formats, un contrat par format

| Format | Destinataire | Contrat |
|---|---|---|
| **humain**, par défaut | humain, agent | lisible, aligné, tenant dans un écran ; **aucune stabilité garantie** |
| **structuré**, sur demande | programme, agent | stable ; toute rupture est un changement de version majeure |

Le format humain peut changer sans préavis, et c'est ce qui permet de
l'améliorer. **Un appelant qui analyse le format humain le fait à ses risques,
et l'aide le dit.**

## S5 — Ce qu'une liste affiche

Une liste affiche **ce qui varie**, et rien d'autre.

Un champ qui vaut la même chose dans toutes les lignes n'apprend rien et coûte
une colonne. C'est un défaut mesuré : en G2, la commande de liste affichait un
champ identique dans les cent soixante-trois instances du dépôt, et n'affichait
jamais celui qui variait.

Une liste vide se dit en une ligne, et distingue « aucun élément » de « aucun
élément **ici**, et voici où en trouver ».

## S6 — Ce qu'un rapport affiche

Le constat d'abord, le détail sur demande. Un rapport tient dans un écran ; ce
qui ne tient pas est atteignable par une seconde commande, nommée dans la
première.

## S7 — Progression et silence

Une commande qui n'écrit rien ne dit rien : le succès silencieux est le
comportement attendu d'un outil composable.

Une commande longue rend compte de sa progression sur la sortie d'erreur, jamais
sur la sortie standard.

## Origine

`ANL-001` C16, B6, V6 ; `RQN-003`, `RQN-004`. `FND-001` de G2, section 6 :
l'aide fait partie de l'outil, et la sortie sert deux publics — trois ici. S4 et
S5 sont nouveaux : le premier lève une ambiguïté jamais tranchée, le second
corrige un défaut mesuré en G2 et non reproduit depuis, mais non spécifié.
