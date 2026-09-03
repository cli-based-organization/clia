---
type: requis
id: REQ-001
titre: "Une fonctionnalité de ressource, sur Linux"
ordre: 2
source: SES-001 tâche 21
---

# REQ-001 — Une fonctionnalité de ressource, sur Linux

SPC-001 dit ce qu'une ressource est. Ce document dit comment l'une des trois
choses qu'elle apporte — la fonctionnalité — existe sur un système de
fichiers Linux : où elle est, quelle forme elle a, ce que clia en lit, et ce
qui se vérifie.

Il est de deuxième ordre : un agent l'a rédigé en lisant le code, et un
humain le relit. Ce qu'il décrit est ce que `_scripts/lib/fourniture.sh` et
`_scripts/lib/cmd/feature.sh` tiennent au 2026-09-02.

## 1. Ce qu'est une fonctionnalité

**Un extrait de texte qu'une ressource ajoute au harnais IA du dépôt.**

C'est ce qui la distingue d'un skill : elle est toujours dans le contexte de
l'agent, parce qu'elle est dans le fichier que l'agent lit à chaque fois. Un
skill n'y entre qu'à l'invocation.

Une fonctionnalité ne s'exécute pas. Elle est lue.

## 2. Où elle vit

```
<zone livrée>/<ressource>/features/<nom>.md
```

La zone livrée est celle que `CLIA_ZONE_RESSOURCE_LIVREE` désigne,
`.clia/ressources` par défaut — voir REQ-005. `<nom>` est le nom du fichier
sans son extension, et rien d'autre ne le déclare : le nom du fichier **est**
le nom de la fonctionnalité.

Aucun catalogue central ne l'inscrit. clia énumère `features/*.md` sous
chaque ressource installée, et c'est tout ce qui la fait exister. Déposer un
fichier suffit ; en retirer un suffit à la faire disparaître.

## 3. Sa forme

Un fichier UTF-8 portant un frontmatter YAML délimité par deux lignes `---`,
puis un corps markdown :

```markdown
---
nom: session
description: "Ce dépôt travaille par sessions : où elles vivent."
---

Ce dépôt travaille par sessions. Une session est un segment de travail…
```

Seul `description` est lu — par `_clia_t_champ`, qui ne lit que le
frontmatter. Le reste du frontmatter est ignoré par clia et appartient à qui
l'écrit.

Le frontmatter est facultatif : un fichier qui n'en porte pas est tout entier
son corps, et n'a alors aucune description à rendre.

Le corps est posé tel quel dans le harnais, sous un titre `## Fonctionnalité
: <nom>` que clia ajoute. Il doit donc se tenir dans un document qu'il ne
connaît pas : des titres de niveau `###` ou plus bas, et aucune référence à
sa propre position.

## 4. Ce que clia en fait

### 4.1 Les lire

`_clia_f_features <dépôt>` rend une ligne par fonctionnalité :

```
prefixe SEP ressource SEP nom SEP fichier SEP description
```

Le séparateur est `\x1f` — l'unité de séparation d'ASCII. Il est employé
plutôt que la tabulation parce qu'une description peut en contenir une, et
qu'un champ qui peut contenir son propre séparateur n'est pas un champ.

Les ressources sont parcourues dans l'ordre où le CLI les trouve : celles du
dépôt source de clia, puis celles du dépôt de travail. La première trouvée
l'emporte, comme pour les commandes.

### 4.2 Les poser

`clia feature activate <nom> [PREFIXE]` copie le corps — frontmatter retiré —
dans `CLAUDE.md`, à la racine du dépôt de travail, entre deux marqueurs :

```html
<!-- CLIA:FEATURES:BEGIN -->
<!-- BEGIN session feature -->
## Fonctionnalité : session

…le corps…
<!-- END session feature -->
<!-- CLIA:FEATURES:END -->
```

Les marqueurs sont des commentaires HTML : ils ne paraissent pas au rendu
markdown, et un agent qui lit le fichier n'y voit que le texte.

Hors de ces marqueurs, le fichier appartient à qui l'écrit. Dedans, il n'y a
que ce que clia a posé, et lui seul le retire.

Une zone absente est créée en fin de fichier, et clia le dit. Refuser aurait
obligé à préparer le harnais avant de pouvoir rien y poser, pour un fichier
que clia sait terminer lui-même.

### 4.3 L'état

**Il ne se déclare nulle part.** Une fonctionnalité est active quand son bloc
est dans `CLAUDE.md`, et pour aucune autre raison. `clia feature ls` le lit
dans le fichier.

Un inventaire parallèle aurait pu mentir ; le fichier, non. C'est le même
choix que pour les skills, et l'inverse de celui fait pour les scripts, dont
la désactivation est déclarée dans la carte — un verbe actif n'a rien à
inscrire, et l'absence d'inscription doit vouloir dire quelque chose.

### 4.4 Le désigner

Par son nom, et par le préfixe de sa ressource quand deux ressources en
offrent une du même nom. Une désignation ambiguë est **refusée**, et les
candidates sont nommées : clia ne choisit pas à la place de l'appelant.

## 5. Ce qui se vérifie

1. Une fonctionnalité est un fichier `.md` sous `features/` d'une ressource
   installée. Rien d'autre ne la déclare.
2. Son nom est celui de son fichier.
3. Elle est active si et seulement si son bloc borné est dans `CLAUDE.md`.
4. Le texte hors des marqueurs n'est jamais modifié.
5. Une ressource non installée ne fournit rien : ce que le dépôt écrit sous
   `CLIA_ZONE_RESSOURCE` n'est pas lu.

`_scripts/tests/test_fourniture.sh` les mesure.

## 6. Ce que ce document ne tranche pas

**Le harnais visé.** clia pose dans `CLAUDE.md`, à la racine. Un dépôt qui
emploie un autre système IA n'a pas d'autre fichier à donner, et
`_clia_f_harnais` le décide sans le demander à personne.

**Le lien avec `clia hrn gen`.** Le harnais que `clia init` pose et celui que
la ressource harness-ia génère sous sa zone ne sont pas raccordés. Poser une
fonctionnalité écrit dans le premier ; régénérer le second ne la reprend pas.

**L'ordre des fonctionnalités dans le harnais.** Il est celui des
activations. Rien ne le déclare, et deux dépôts qui activent les mêmes
fonctionnalités dans un ordre différent obtiennent deux fichiers différents.
