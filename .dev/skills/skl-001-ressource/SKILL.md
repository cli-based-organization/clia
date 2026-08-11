---
type: skill
id: skl-001
name: skl-001-ressource
version: 0.1.0
status: draft
description: >-
  Écrire et valider une ressource dans `clia`. Partie A : les règles communes à toute ressource,
  quel que soit son type, auxquelles les autres skills renvoient. Partie B : produire une
  définition de type (`.dev/ressources/RES-<SEQ>-<SLUG>.md`). À utiliser avant de produire ou de
  modifier une ressource, et avant de la déposer.
definition-associee: RES-001
adr-associe: ADR-001
---

# Skill - Écriture et validation d'une ressource

> Ce skill dit **comment** on produit une ressource. Ce qu'une ressource **est** vit dans `RES-001-ressource.md`. **Pourquoi** elle a été adoptée vit dans `ADR-001`. Ne recopier ici ni l'un ni l'autre : un passage qui décrit une propriété du type appartient à la définition, un passage qui cesserait d'être vrai en changeant d'avis appartient à la décision.

## Quand invoquer ce skill

| Situation | Partie à suivre |
|---|---|
| Produire ou modifier n'importe quelle ressource | A, puis le skill du type concerné |
| Produire ou modifier une définition de type | A puis B |
| Vérifier une ressource avant de la déposer | La section Validation |
| Reprendre un travail après un creux, et vérifier l'état d'un répertoire de ressources | La section Validation, en boucle sur le répertoire |

Ne pas invoquer pour un fichier de harnais (`CLAUDE.md`, `ARCHITECTURE.md`), pour le point d'entrée de session, pour un gabarit ou pour du matériel source : `ADR-001` D8 les place hors du modèle.

## Partie A - Règles communes à toute ressource

Ces règles valent pour tous les types. Les autres skills y renvoient plutôt que de les recopier.

### A1 - Frontmatter

Toute ressource ouvre sur un frontmatter YAML délimité par deux lignes `---`, la première en ligne 1.

Cinq champs sont communs à tous les types.

| Champ | Contrainte |
|---|---|
| `type` | Le nom du type, en minuscules, tel que sa définition le déclare |
| `id` | `<PREFIX>-<SEQ>`, l'alias interne. Le slug du nom de fichier n'en fait pas partie |
| `title` | Nom lisible, entre guillemets si le YAML l'exige |
| `version` | Semver, pour les types au cycle `vivant` uniquement |
| `status` | `draft`, `stable` ou `deprecated` |

Les champs propres au type s'ajoutent, et la définition du type les énumère dans son champ `champs-obligatoires`. Lire cette liste avant d'écrire, et non après.

### A2 - Identité et nommage

Le champ `id`, de la forme `<PREFIX>-<SEQ>`, porte l'**alias interne** de la ressource (`ADR-008` D2). C'est la cible de tout renvoi interne. Ce n'est pas l'identité : l'identité désigne l'oeuvre et aucun champ ne la porte à l'interne (`ADR-008` D5, `NON-023` Q1).

**Un alias peut changer, à condition de propager.** Tout changement d'alias met à jour, dans le même geste, toutes les références internes qui le citent (`ADR-008` D3). Aucune commande ne le fait et aucun contrôle ne le vérifie. Le faire à la main demande deux précautions, établies par la migration de la tâche 13 : traiter les identifiants du plus long au plus court, et employer une frontière de mot.

Le nom de fichier est le même pour tous les types, quel que soit leur cycle de vie.

```
<PREFIX>-<SEQ>-<SLUG>.md
```

Exemples : `RES-002-contexte.md`, `NON-001-identite-et-nommage.md`, `FCT-001-corpus-des-depots.md`.

Le slug est en minuscules, sans accent, mots séparés par des traits d'union. Il porte le **libellé**, non l'identité : le corriger ne casse aucun renvoi. Pour une définition de type, le slug porte en outre le **nom canonique du type**, c'est-à-dire la valeur que le champ `type` de ses instances doit prendre.

Un renvoi vers une autre ressource cite son `id` dans le texte et son chemin dans le lien markdown.

**Ce qui a changé le 2026-08-10.** `ADR-007` a d'abord fait du numéro l'identité, en renversant la forme `<PREFIX>-<SLUG>`. `ADR-008` a ensuite abrogé ses D1 et D2 : le numéro est un alias interne, et il peut changer sous condition de propagation. La forme `<PREFIX>-<SEQ>` est inchangée et reste le format par défaut, fixé par `PDC-002`.

### A3 - Écriture

Trois règles de forme, non négociables, héritées du corpus et vérifiables mécaniquement.

**Pas de filet horizontal** (`---`, `***`, `___`) comme séparateur de section. La structure passe par les titres. Seule exception : la clôture du frontmatter.

**Pas de retour à la ligne manuel dans un paragraphe.** Un paragraphe tient sur une seule ligne source ; les blocs sont séparés par une ligne vide.

**Pas de tiret cadratin** (U+2014) ni de tiret demi-cadratin (U+2013). Reformuler, ou employer parenthèses, deux points, ou un tiret simple entouré d'espaces.

Deux règles de fond s'y ajoutent, et elles pèsent plus lourd.

**Relisible sans mémoire de session.** Une ressource dont le sens dépend de la conversation qui l'a produite a manqué son objet. C'est la propriété que le régime de travail observé exige : `ANL-001` mesure des creux de travail allant jusqu'à quatre mois.

**Ce qui n'est pas su est écrit comme tel.** Toute ressource dont le contenu est incomplet porte une rubrique nommant ses lacunes ou ses points ouverts. Un document silencieux sur ses manques se lit comme complet.

### A4 - Relations

Une relation est un renvoi typé, écrit dans une section `## Relations` en fin de document, sous la forme suivante :

```
## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-.../index.md)
- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
```

Vocabulaire admis : `specifie`, `derive-de`, `remplace`, `est-remplacee-par`, `reference`, `objecte-a`, `repond-a`. La définition du type restreint ce vocabulaire par son champ `relations-admissibles`.

Une relation dont la cible n'existe pas est un défaut. Le contrôle V5 le détecte.

**Dette connue.** Ce vocabulaire vit provisoirement dans `RES-001`, alors qu'il relève de l'ontologie. `ONT-001` n'existe pas. Voir `NON-004` Q2.

### A5 - Ce qui déclenche une objection plutôt qu'une ressource

Avant d'écrire, vérifier que la ressource est le bon geste. Trois cas appellent une objection.

La demande contredit l'intention ultime du dépôt. `CLAUDE.md` en fait une obligation.

Le type de ressource demandé n'existe pas, ou sa définition ne couvre pas le cas. Écrire quand même produit une instance non conforme qui fera précédent.

La production exigerait de trancher une question qui appartient à l'humain. Le trancher soi-même dans une ressource fait passer une décision pour un constat.

### A6 - Registre : directif et factuel

Une ressource énonce **ce qui est**, non pourquoi on l'a décidé.

Le pourquoi appartient à l'`ADR`, règle B1. Le récit de la production appartient au journal de la tâche. Une ressource qui les porte se substitue à deux documents et devient illisible.

**Cinq interdits.**

| Interdit | Exemple de ce qui est proscrit |
|---|---|
| Défendre un choix de rédaction | « Ce jet propose », « la position retenue est », « trois positions étaient possibles » |
| Comparer avec une version antérieure du document | « premier jet », « ce que ce jet change », « la position antérieure » |
| Raconter la production | « produit le 2026-08-10 à la demande de la tâche 8 » |
| Justifier une propriété du type | « ce champ mérite justification », « au motif que » |
| Rapporter un débat non tranché dans le corps | La question va dans une objection, pas dans une digression |

**Deux obligations.**

Les références externes, quand elles sont nécessaires, prennent la forme d'une **bibliographie numérotée** en fin de document, avec un renvoi par numéro dans le texte.

Une mesure citée décrit le type, jamais la décision de l'écrire. `ANL-001` mesure douze numéros de skill sur vingt portant plusieurs noms : ce fait a sa place dans une définition s'il décrit une propriété, dans un `ADR` s'il fonde un choix.

**Ce que la règle ne supprime pas.** La rubrique des points ouverts, exigée par A3, réduite à une table de deux colonnes, question et objection. La rubrique des relations.

Le contrôle est V10.

## Partie B - Produire une définition de type

Une définition de type est une instance du type `ressource`. Elle vit dans `.dev/ressources/`, porte les quatorze champs de frontmatter, et déclare les propriétés du type qu'elle définit.

### B1 - Le critère de départage, à appliquer avant d'écrire

Trois documents accompagnent un type. Ce qui va dans lequel :

| Question | Document |
|---|---|
| **Ce qu'est** le type | La définition, `RES` |
| **Pourquoi** il a été adopté | La décision, `ADR` |
| **Comment** on le produit | Le processus, `skl` |

Test pratique : un passage qui cesserait d'être vrai en changeant d'avis relève de la décision ; un passage qui décrit une suite d'actions relève du processus ; un passage qui décrit une propriété du type telle qu'elle est aujourd'hui relève de la définition.

Ce test se passe avant la rédaction, pas après : `ADR-008` du dépôt `micrologic-clients` documente le dégât inverse, où six ADR sur sept servaient de définition et deux ont dû être amendés en place le jour de leur création.

### B2 - Procédure

1. **Établir la matière.** Chercher si le type existe déjà ailleurs, dans le corpus ou dans un dépôt voisin. Le rapatriement critique d'une définition éprouvée vaut mieux qu'une rédaction à neuf. S'écarter d'un état de l'art se justifie par une mesure, pas par une préférence.
2. **Décider le cycle de vie.** `vivant` si le document se raffine sans changer d'objet. `point-fixe` s'il est arrêté à une date. `travail` s'il a une histoire plutôt que des versions. Ce choix commande le nommage et le versionnage : le décider en premier évite une migration.
3. **Décider le régime d'édition.** `humain`, `ia`, `hybride` avec propriété par bloc, `co-edition`. Si le document porte une question de l'un et une réponse de l'autre, c'est `hybride`, et il faut dire quels blocs appartiennent à qui.
4. **Fixer le préfixe.** Trois lettres, distinct de tous les autres préfixes du dépôt. Vérifier par le contrôle V6. Un changement de préfixe coûte cher : `ANL-001` mesure six corrections manuelles pour un seul changement.
5. **Énumérer les champs obligatoires.** Les cinq communs, plus ceux que le type exige. Chaque champ ajouté est un coût sur chaque instance, saisi à la main et sans vérification. Ne rendre obligatoire que ce qui sert.
6. **Poser les frontières.** Nommer explicitement les types voisins et dire ce qui départage. C'est la section que les définitions du corpus omettent le plus souvent, et c'est celle qui évite les recouvrements.
7. **Écrire les lacunes.** Ce que la définition ne règle pas, et où la question est portée. Ne pas enterrer une question dans une section de lacunes si elle mérite une objection : ouvrir l'objection.
8. **Valider.** Section Validation ci-dessous, contrôles V1 à V10.
9. **Mettre à jour l'index.** `.dev/ressources/index.md` est une vue, pas une source. Il doit refléter la nouvelle ligne.

### B3 - Gabarit d'une définition de type

```
---
type: ressource
id: RES-<SEQ>
title: "<Nom du type>"
version: 0.1.0
status: draft
prefixe: <XXX>
emplacement: ".dev/<repertoire>/<XXX>-<SEQ>-<SLUG>.md"
cycle-de-vie: <vivant | point-fixe | travail>
edition: <humain | ia | hybride | co-edition>
famille: <fondamentale | conception | controle | contenu | preparation | implementation>
champs-obligatoires: [type, id, title, version, status, ...]
relations-admissibles: [...]
sections: [...]
skill: <skl-<SEQ>-<nom> | aucun>
adr: <ADR-<SEQ> | aucun>
statut: <actif | deprecie | non-installe>
---

# RES-<SEQ> - <Nom du type>

> Le type en une phrase, qui tient debout seule.

## Objet
## Ce qu'est <le type>
## Ce que <le type> n'est pas
## Champs propres
## Test d'admission
## Cycle de vie et versionnage
## Régime d'édition
## Frontière avec les types voisins
## Structure attendue d'une instance
## Relations
## Points ouverts
```

Seize champs, onze rubriques. Le frontmatter reprend les seize champs obligatoires que `RES-001` déclare.

**Trois rubriques ne sont pas optionnelles** : `Ce que <le type> n'est pas`, `Frontière avec les types voisins` et `Points ouverts`. Elles sont ce qui distingue une définition d'une présentation.

**Onze rubriques descriptives, aucune méta.** Une définition dit ce qu'est le type, ce qu'il n'est pas, ses champs, son cycle de vie, son régime d'édition et la structure de ses instances. Elle ne dit pas pourquoi le type existe : c'est l'`ADR`, règle B1. Elle ne dit pas comment elle a été produite : c'est le journal de la tâche. Voir A6, et le contrôle V10.

`Points ouverts` est une table de deux colonnes, question et objection. Aucune prose.

| Question | Objection |
|---|---|
| Ce que la définition ne règle pas, en une ligne | `NON-<SEQ>` |

## Validation

Dix contrôles, tous exécutables sans outil. Ils constituent aussi le cahier des charges de la future validation par `clia` (`ADR-001` D9).

Poser d'abord la variable :

```sh
F=.dev/ressources/RES-002-contexte.md
```

**Règle d'exclusion, valable pour tout contrôle textuel.** Un contrôle doit ignorer le frontmatter, les blocs de code délimités par trois accents graves, et le code inline entre accents graves. Sans cette exclusion, tout document qui cite une règle est signalé comme la violant.

Cette règle n'est pas théorique : les contrôles V4 et V5 de la première version de ce skill signalaient ce skill lui-même comme non conforme, parce qu'ils trouvaient les tirets cadratins dans leurs propres commandes et les filets du gabarit de la partie B. Un contrôle qui ne sait pas distinguer une mention d'un emploi est inutilisable sur un document de méthode.

### V1 - Le fichier n'est pas vide

```sh
[ -s "$F" ] && echo OK || echo "VIDE"
```

Motif : `ANL-001` a trouvé un `CONSTITUTION.md` de zéro octet dans le corpus, jamais détecté.

### V2 - Le frontmatter est analysable et porte `type` et `id`

```sh
python3 -c "
import yaml,sys
d=yaml.safe_load(open('$F').read().split('---')[1])
assert 'type' in d and 'id' in d, 'champ type ou id manquant'
print('OK', d['id'])"
```

### V3 - Les champs obligatoires déclarés par le type sont présents

```sh
python3 -c "
import yaml
d=yaml.safe_load(open('$F').read().split('---')[1])
req=yaml.safe_load(open('.dev/ressources/RES-001-ressource.md').read().split('---')[1])['champs-obligatoires']
m=[c for c in req if c not in d]
print('OK' if not m else 'MANQUANTS: '+', '.join(m))"
```

Adapter le chemin de la définition de référence au type contrôlé.

### V4 - Aucun tiret cadratin ni demi-cadratin

```sh
python3 -c "
import re
t=open('$F').read().split('\n')
sep=[i for i,l in enumerate(t) if l.strip()=='---']; end=sep[1] if len(sep)>1 else -1
incode=False; bad=[]
for i,l in enumerate(t):
    if i<=end: continue
    if l.strip().startswith('\`\`\`'): incode=not incode; continue
    if incode: continue
    if re.search(r'[–—]', re.sub(r'\`[^\`]*\`','',l)): bad.append(i+1)
print('OK' if not bad else 'TIRETS lignes '+str(bad))"
```

### V5 - Aucun filet hors frontmatter, et tous les liens résolvent

```sh
python3 -c "
import re,os
p='$F'; d=os.path.dirname(p)
t=open(p).read().split('\n')
sep=[i for i,l in enumerate(t) if l.strip()=='---']; end=sep[1] if len(sep)>1 else -1
incode=False; filets=[]; casses=[]
for i,l in enumerate(t):
    if i<=end: continue
    if l.strip().startswith('\`\`\`'): incode=not incode; continue
    if incode: continue
    if l.strip() in ('---','***','___'): filets.append(i+1); continue
    for lien in re.findall(r'\]\(([^)#]+)\)', l):
        if lien.startswith('http'): continue
        if not os.path.exists(os.path.join(d,lien)): casses.append((i+1,lien))
print('filets:','OK' if not filets else filets)
print('liens :','OK' if not casses else casses)"
```

### V6 - L'`id` est unique dans le dépôt

```sh
grep -rh '^id:' .dev --include='*.md' | sort | uniq -d
```

Toute sortie est un défaut. Vaut aussi pour vérifier qu'un préfixe n'est pas déjà pris.

### V7 - L'`id` est cohérent avec le nom de fichier

```sh
python3 -c "
import yaml,os,re
p='$F'
d=yaml.safe_load(open(p).read().split('---')[1])
b=os.path.basename(p)[:-3]
m=re.match(r'([A-Za-z]+)-(?:\d{3}|\d{4}-\d{2}-\d{2})-(.+)', b)
attendu=m.group(1)+'-'+m.group(2) if m else None
print('OK' if d.get('id')==attendu else 'ÉCART: id='+str(d.get('id'))+' attendu='+str(attendu))"
```

Exception : un skill vit dans `.dev/skills/skl-<SEQ>-<nom>/SKILL.md`, et son `id` dérive du nom du répertoire, non du fichier.

### V8 - Aucun marqueur de gabarit résiduel

```sh
python3 -c "
import re
t=open('$F').read().split('\n')
sep=[i for i,l in enumerate(t) if l.strip()=='---']
end=sep[1] if len(sep)>1 else -1
pat=re.compile(r'<[A-Z]+>|\[Décrire|\[Description|\[À compléter'
               r'|^\s*(?:[-*]\s*)?(?:TODO|FIXME|todo)\b|\bTODO:|\bFIXME:|lorem')
incode=False; bad=[]
for i,l in enumerate(t):
    if i<=end: continue
    if l.strip().startswith('\`\`\`'): incode=not incode; continue
    if incode: continue
    l=re.sub(r'\`[^\`]*\`','',l)
    if pat.search(l): bad.append(i+1)
print('OK' if not bad else 'MARQUEURS lignes '+str(bad))"
```

Le contrôle exclut le frontmatter, les blocs de code et le code inline : un motif de nommage cité entre accents graves est légitime, un motif laissé dans une phrase est un reste de gabarit.

Le motif `TODO` ne se cherche qu'en tête de ligne, en tête de puce, ou suivi de deux points. Un document qui **parle** d'un TODO n'en porte pas un : la première version de ce contrôle signalait `PLN-001` à tort, pour trois mentions de la note `TODO` de la demande à laquelle il répondait. Un contrôle qui ne distingue pas une mention d'un emploi est inutilisable sur un document de méthode, comme la règle d'exclusion l'énonce plus haut.

Motif : `ANL-001` a trouvé plusieurs `INTENTION.md` restés aux crochets du gabarit et un README de dépôt stratégique resté au gabarit avec ses `todo`.

### V9 - Le contenu est propre à ce dépôt

```sh
md5sum "$F"
```

Comparer avec l'empreinte du même fichier dans les dépôts voisins. Une empreinte identique pour un contenu qui devrait être propre au dépôt est un défaut grave.

Motif : c'est le défaut le plus coûteux qu'ait révélé `ANL-001`. Trois dépôts de consultation partagent le même `INTENTION.md` au bit près, désignant un client qui n'est pas le leur, et les mêmes dix-huit logs. Parmi ces logs, celui qui documente l'écrasement d'un `INTENTION.md` par du contenu générique a été copié dans les deux dépôts où l'`INTENTION.md` est justement resté générique.

### V10 - Aucune rubrique méta

```sh
grep -nE '^## (Statut de ce document|Le problème que ce type résout|Ce que la fondation a changé|Auto-application)' "$F"
```

Aucune sortie attendue. Une rubrique méta est une rubrique dont le sujet est le document lui-même, ou la décision de l'écrire, plutôt que ce qu'il définit.

La liste ci-dessus est close. Elle ne détecte pas une justification logée dans une rubrique descriptive, ce que `NON-023` ne couvre pas et que `PLN-002` déclare comme limite du contrôle.

Motif : `ANL-004` mesure que 20,8 pour cent du texte des trente définitions est logé dans ces rubriques, et que les deux premières sont reprises par 30 définitions sur 30. Elles étaient prescrites par ce skill jusqu'au 2026-08-10. Voir A6.

### Boucle sur un répertoire

```sh
for F in .dev/ressources/*.md; do
  printf '%-46s ' "$F"
  [ -s "$F" ] || { echo VIDE; continue; }
  python3 -c "
import yaml,sys
d=yaml.safe_load(open('$F').read().split('---')[1])
sys.exit(0 if 'type' in d and 'id' in d else 1)" || { echo "frontmatter"; continue; }
  echo "frontmatter OK, poursuivre avec V3 a V9"
done
```

La boucle ne remplace pas les contrôles individuels : elle sert à repérer rapidement un fichier vide ou un frontmatter cassé sur un répertoire entier, typiquement à la reprise après un creux.

## Erreurs fréquentes, observées dans le corpus

| Erreur | Où elle a été mesurée | Contrôle |
|---|---|---|
| Fichier de harnais copié sans être adapté | Trois `INTENTION.md` identiques désignant le mauvais client | V9 |
| Traces d'un autre dépôt recopiées | Dix-huit logs aux empreintes identiques dans trois dépôts | V9 |
| Fichier vide non détecté | Un `CONSTITUTION.md` de zéro octet | V1 |
| Gabarit resté aux crochets | Plusieurs `INTENTION.md`, un README de dépôt stratégique | V8 |
| Doublons de titre non détectés | Trois paires d'ADR dans un dépôt de méthode | V6 |
| Valeur de champ dérivée | `completed` dans 52 logs, `complet` dans 2 du même dépôt | V3, puis l'ontologie |
| Arborescence peuplée de `.gitkeep` | Neuf répertoires vides dans un dépôt | Ne pas créer un répertoire tant qu'il est vide |
| Renvoi par numéro de séquence | Vingt-sept triplets dans `CLAUDE.md` | A2 |
| Définition écrite dans un ADR | Six ADR sur sept dans un dépôt | B1 |

## Ce que ce skill ne fait pas

Il ne valide rien mécaniquement : il fournit des commandes que l'agent exécute et dont il rapporte le résultat dans son log. `ADR-001` D9 déclare cette position temporaire, et `NON-005` en porte la contestation.

Il ne couvre pas la production des autres types de ressources. Chaque type a son skill, qui renvoie à la partie A de celui-ci pour les règles communes. Six des sept types fondamentaux n'ont pas encore de skill.

## Relations

- `specifie` [RES-001](../../ressources/RES-001-ressource.md)
- `derive-de` [ADR-001](../../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [ANL-001](../../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)

## Points ouverts

| Question | Objection |
|---|---|
| Les contrôles V1 à V10 doivent-ils devenir une commande `clia` | `NON-005` Q4 |
| Le vocabulaire de relations de A4 doit vivre dans une ontologie | `NON-004` Q2 |
| Le nombre de champs obligatoires est-il tenable sans validation | `NON-002` Q4, `NON-005` Q6 |
