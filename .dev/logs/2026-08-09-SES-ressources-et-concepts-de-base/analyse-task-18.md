# Analyse avant réalisation, tâche 18

## Ce que « non. voir FRG-001. » corrige

La mention est ajoutée sous une réponse déjà consignée, ce qui la rend ambiguë au premier abord. Elle porte sur la formulation de cette réponse, non sur la décision de la tâche 13.

La réponse de la tâche 13 disait : l'identité est le champ `id` de forme `<PREFIX>-<SEQ>`.

Q4, répondue le même jour, dit : `<PREFIX>-<SEQ>` est « l'implémentation par défaut de l'id-interne/alias de l'identifiant ».

Les deux énoncés ne sont pas compatibles. Le second nomme alias ce que le premier nomme identité. `FRG-001` tranche en faveur du second, en posant deux régimes d'identification et un système hybride fondé sur « un système d'alias auto-cohérent facilement utilisable en interne » et « des identifiants complets ».

**Ce qui change n'est pas la forme mais son statut.** `<PREFIX>-<SEQ>` reste le format par défaut, Q11 le confirme. Aucun fichier n'est renommé.

## Ce que la correction entraîne mécaniquement

`ADR-007` D2 interdisait la renumérotation. Son motif écrit : « C'est ce qui rend D1 possible. »

D1 tombe. D2 perd son motif, et Q5 le remplace par son contraire conditionnel : « les modifications internes de l'alias/identifiant doit modifier du même coup toutes les références. »

Une interdiction devient une obligation de propagation. C'est un assouplissement, et il déplace le coût : `ADR-007` D2 garantissait qu'un renvoi interne restait valide sans intervention ; `ADR-008` D3 exige une intervention et rien ne la vérifie.

**`ADR-007` D2 était un ajout de l'agent**, signalé comme tel dans le journal de la tâche 13. Il est retiré par l'humain avec la prémisse qui le portait.

## Le périmètre de l'abrogation, et sa mesure

Sur les cinq décisions de `ADR-007`, deux tombent et trois subsistent.

| Décision | Sort |
|---|---|
| D1, l'identité est `<PREFIX>-<SEQ>` | abrogée par `ADR-008` D2 |
| D2, renuméroter est interdit | abrogée par `ADR-008` D3 |
| D3, le slug porte le libellé | confirmée par Q6 et Q12 |
| D4, le nommage daté est aboli | inchangée |
| D5, l'identifiant est relatif au dépôt | confirmée par Q4 |

## La lacune rencontrée en écrivant

`DCN-008` corrige une partie de `DCN-007`. Trois mécanismes du dépôt échouent à le dire.

La relation `remplace` vaut pour un document entier. L'employer ferait disparaître trois décisions en vigueur.

Le champ `effet: remplacee` a le même défaut à l'échelle de la `DCN`.

`MET-002` étape 6 ne connaît que le revirement complet.

**C'est la première application réelle de `MET-002`.** Le document, écrit à la tâche 14, déclarait son mécanisme central non éprouvé, aucune `DCN` n'en remplaçant une autre. La tâche 18 fournit le premier cas et il ne rentre pas dans le mécanisme, pour un motif que `MET-002` n'avait pas prévu.

Solution retenue : `DCN-007` conserve `effet: en-vigueur`, `DCN-008` déclare `reference` et non `remplace`, l'abrogation est marquée dans le texte de `ADR-007` au niveau de chaque décision. La lacune est portée par `NON-023` Q5 plutôt que contournée en silence.

## Deux réponses qui raccordent des travaux antérieurs

**Q9 confirme `ANL-005`.** L'humain répond que l'identifiant intrinsèque sert à suivre l'historique et attester les modifications, par git. `ANL-005`, produite deux tâches plus tôt, l'établit par mesure et recommande en R1 de ne rien construire par-dessus. La réponse retient la recommandation, et les six contraintes T1 à T6 passent du statut de recommandation à celui de condition.

**Q8 tranche une question ouverte depuis `FND-002`.** L'identité désigne l'oeuvre. `FND-002` établissait par le modèle FRBR qu'un identifiant qui ne déclare pas son niveau confond l'oeuvre et le fichier. Le niveau est désormais déclaré.

## Ce que Q11 impose de produire

« L'ergonomie interne est une exigence non négociable. »

Une exigence non écrite perd tous les arbitrages, ce que la question elle-même énonçait. Le type qui porte une exigence opposable est le principe de conception, `RES-012`. D'où `PDC-002`.

Trois contraintes vérifiables plutôt qu'un énoncé général : le jeu de caractères, la longueur, l'acceptation par le CLI. La mesure de conformité est faite : 91 alias conformes sur 99, les 8 écarts étant les atomes de `ANL-001`.

## Portée écartée

Les corrections que `PLN-002` porte. `RES-001` conserve ses deux rubriques méta, `Statut de ce document` et `Auto-application` : leur retrait est le chantier D, non engagé.

L'implémentation de la propagation d'alias. Q5 en fait une obligation ; la commande n'existe pas et la tâche 18 n'est pas une tâche d'implémentation.

La réponse Q10. Son auteur la déclare non définitive. Elle est enregistrée comme orientation, et ses quatre inconnues sont portées par `NON-023` Q6.
