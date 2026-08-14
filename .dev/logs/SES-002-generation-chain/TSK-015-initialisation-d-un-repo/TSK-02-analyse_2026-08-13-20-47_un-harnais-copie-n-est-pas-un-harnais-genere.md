# Analyse, tâche 15 de SES-002

`MET-003` étape 2.

## Les défauts, mesurés sur le dépôt réel

`~/git/cli-based-organization/clia-repos`, initialisé le 2026-08-13.

| Constat | Mesure |
|---|---|
| Pas de `CONSTITUTION.md` | Le dépôt contient `CLAUDE.md`, `INTENTION.md`, `.dev/`, `workspace/`. Rien d'autre |
| `INTENTION.md` porte l'intention de `clia` | **`diff` vide** contre l'`INTENTION.md` du dépôt source |
| **`CLAUDE.md` aussi** | **`diff` vide**. L'humain ne l'a pas relevé ; c'est le même défaut |
| Ni l'un ni l'autre n'est un lien | Deux fichiers réels, `cp -p`, dates du 2026-08-09 préservées |
| Pas de `.dev/intentions/` | Le répertoire n'est pas créé |

## La cause, en une ligne de code

`clia_setup_fichiers_harnais` déclare deux fichiers, et `clia_setup_poser` les **copie du dépôt source**.

```
cp -p "$source" "$cible"
```

**Le mécanisme ne distingue pas un harnais d'un contenu.** `CLAUDE.md` décrit un mode opératoire : le copier est défendable. `INTENTION.md` porte ce que le dépôt veut accomplir : le copier est un défaut, parce qu'aucun dépôt ne partage l'intention d'un autre.

**Le régime lié aggraverait le cas.** En `--dev`, `clia_setup_poser` pose un lien symbolique vers le fichier du dépôt source : le dépôt neuf pointerait alors vers l'intention de `clia`, et la modifier modifierait `clia`.

**Deux harnais manquent simplement à la liste** : `CONSTITUTION.md` et `ARCHITECTURE.md`.

## Ce que la demande corrige, et ce qu'elle ajoute

L'humain ne demande pas de rustine. Il demande un **changement de régime** : les harnais cessent d'être copiés pour être **générés**.

| Exigence | Ce qu'elle règle |
|---|---|
| Génération depuis un YAML source de vérité | La copie disparaît, donc la fuite aussi |
| Fournir une constitution | Le harnais manquant |
| `ARCHITECTURE.md` optionnel | Il décrit `clia`, pas un dépôt quelconque |
| `INTENTION.md` → lien vers `.dev/intentions/INT-001.md` | L'intention devient une **ressource**, pas un fichier de racine |
| `INTENTION.md` est un gabarit vide | Un dépôt neuf déclare sa propre intention |
| Un `INTENTION.md` existant est déplacé puis lié | La migration des dépôts déjà instrumentés |

**La quatrième exigence est la plus structurante.** Elle applique à l'intention ce que `PLN-008` a fait pour la session : le contenu vit dans `.dev/`, la racine ne porte qu'un lien. Le dépôt gagne un type de ressource `intention` réellement instancié — `RES-003` le définit depuis le 2026-08-09 sans qu'aucune instance existe.

## Ce que je décide en avançant

**Un `BUG` et un `PLN`, pas d'`ANL` séparée.** Le diagnostic tient dans les rubriques « L'écart » et « La cause » du bogue. La session cherche à faire descendre le nombre d'items ; un troisième document dirait la même chose une troisième fois.

**`CLAUDE.md` entre dans le périmètre du bogue.** L'humain n'a relevé que `INTENTION.md`, mais la mesure montre le même défaut, et la remédiation qu'il demande — la génération — le couvre déjà.

## Ce que je surveille

**La génération depuis un YAML est-elle découpable en chantiers SMART ?** Elle touche quatre familles de harnais. Si un chantier ne peut pas déclarer un critère exécutable, il sort du plan et je le déclare — c'est ce que `PLN-009` et `PLN-015` ont fait.

**La tâche ne l'exécute pas.** `[plan de rémédiation]`, rangé avec `[planification]` : `MET-005` étape 1.
