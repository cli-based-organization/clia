# Ce qui a été fait, tâche 10 de SES-002

`MET-003` étape 3.

**Un écart à déclarer** : ce versement est écrit après la démarche de validation de 13:40, alors que les livrables étaient sortis avant. `MET-003` veut le fait versé à mesure. L'ordre réel des travaux est celui des livrables ; l'ordre des logs ne le reflète pas ici.

## Les trois livrables

| Livrable | Ce qu'il porte |
|---|---|
| `ANL-012` | Le diagnostic, cinq constats, quatre pistes, celle qui est retenue |
| `PLN-015` | Trois chantiers SMART, et deux points sortis du plan avec leur motif |
| `NON-040` | Cinq questions, une seule objection |

## Le diagnostic, en un chiffre

**Quatorze interruptions sur quinze ne viennent d'aucune règle du dépôt.** Une seule venait d'une règle `ask`, retirée le 2026-08-12.

Les quatorze autres viennent de ce qu'une ligne contenant une variable, une substitution ou un document en place **ne peut être comparée à aucune règle**. L'outil ne sait pas ce qu'elle fera, donc il demande.

## Ce que l'analyse corrige

`settings.json` portait, depuis la tâche 000, la conclusion que la réponse était « d'écrire les fichiers avec l'outil d'écriture ». Le classement des quinze interruptions **par ce qui les aurait évitées** la mesure :

```
outil d'écriture au lieu d'un document en place :  4
chemin littéral au lieu d'une variable          :  2
une règle du dépôt, déjà corrigée               :  1
rien que la conduite puisse changer             :  8
```

**La discipline règle six cas sur quinze.** Les huit autres sont des scripts d'épreuve — créer un dépôt jetable, y lancer `clia setup init`, comparer une empreinte — qui ont besoin de variables pour être reproductibles.

## La cause racine

**Le dépôt a écrit ses interdits et jamais ses permissions.**

Le hook `refuser-git-en-ecriture.py` sort en 0 ou en 2. **Le code 0 signifie « je ne m'oppose pas », pas « j'autorise »** : la demande a lieu ensuite comme si le hook n'existait pas. Le seul point du système où une commande non analysable peut être jugée sur son contenu réel est inoccupé.

## Le plan, et ce qu'il ne couvre pas

Trois chantiers exécutables sans attendre personne :

| Chantier | Critère |
|---|---|
| A. Mesurer qu'un hook peut autoriser | Sur un dépôt jetable, une commande avec `$(date)` s'exécute sans demande ; sans le hook, elle la déclenche |
| B. La règle de conduite dans le harnais | Les six interruptions évitables reprises comme exemples, chacune avec la forme qui ne l'aurait pas déclenchée |
| C. `clia config ia policy check` | Les quatre mécanismes affichés, au moins un manque nommé, sortie 0 ou 1 |

**Deux points sont sortis du plan** : le hook qui autorise, et `clia config ia policy apply`. Aucun critère exécutable ne peut être écrit pour eux tant que « légitime » n'est pas défini, et le définir décide de ce qu'un agent peut faire sans que personne le voie.

**Le plan traite la moitié du bogue et le dit.** `BUG-001` restera ouvert à la fin.

## Une seule objection

`NON-040`, cinq questions. Deux décident du contenu de la politique — jusqu'où elle autorise, et si l'écriture hors du dépôt reste demandée. Une porte sur `DCN-017`, qui est un squelette vide : **la règle que `BUG-001` déclare enfreinte n'existe pas.**

**Trois des quatre lignes du filtre rangeraient Q1 du côté « avancer ».** C'est la quatrième qui arrête : se tromper ne coûterait pas une correction, mais un pouvoir que personne ne regarde. `MET-005` pose que les quatre se lisent ensemble.

## Ce qui a été décidé en avançant

**Les trois champs `À RENSEIGNER` de `BUG-001` sont renseignés** : `regle: DCN-017`, `constate-le: 2026-08-12`, `etat: ouvert`. Le corps du document donnait déjà les trois valeurs en toutes lettres — c'est une transcription. Le bogue devient conforme à son schéma, et `clia focus` le range enfin à corriger au lieu de le signaler comme incomplet.

## Sur les fonctionnalités livrées

`MET-005` étape 4 ne s'applique pas : **cette tâche ne livre aucune fonctionnalité.** Elle produit une analyse, un plan et une objection. La fonctionnalité que `PLN-015` servira, `FNC-006`, sera touchée par la tâche qui l'exécutera.

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/analyses/ANL-012-interruptions-de-l-execution-autonome.md` | Création |
| `.dev/plans/PLN-015-politique-d-autorisation-du-depot.md` | Création |
| `.dev/objections/NON-040-portee-de-la-politique-d-autorisation.md` | Création |
| `.dev/bogues/BUG-001-...md` | Trois champs renseignés |
