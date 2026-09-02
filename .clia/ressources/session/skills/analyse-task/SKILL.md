---
name: analyse-task
description: "Prendre une tâche de la session en cours : vérifier l'énoncé, récupérer le prompt exact, et dire ce qu'il ne dit pas. À employer dès qu'une demande désigne une tâche par son numéro — « exécute la tâche 2 », « analyse la tâche 3 »."
---

# Analyser une tâche de la session en cours

Une demande qui nomme un numéro de tâche — « exécute la tâche 2 » — ne porte
pas le travail : le travail est dans l'énoncé de la session. Ce skill dit
comment aller le chercher, et comment le lire.

## 1. Vérifier la forme de l'énoncé

```sh
clia ses check
```

**Si la commande refuse, arrêtez-vous là.** Rapportez les écarts qu'elle
nomme, et n'entamez rien : un énoncé dont la forme n'est pas celle attendue
se lit mal, et le numéro de tâche que vous croyez lire n'est peut-être pas
celui que l'humain a écrit.

Ne corrigez pas l'énoncé vous-même. Il appartient à l'humain.

## 2. Récupérer le prompt

```sh
clia ses show task <NUMERO>
```

La sortie est le texte exact de la tâche : son titre, et tout ce qui le suit
jusqu'à la tâche suivante. C'est la demande de travail — pas un résumé, pas
une reformulation.

Si la commande dit que la tâche n'existe pas, dites-le et arrêtez-vous. Ne
devinez pas quelle tâche était visée.

## 3. Lire la tâche

Lisez le prompt en le rapportant au reste de l'énoncé — l'intention de la
session borne ce que la tâche peut vouloir dire. `focus/` porte le fichier.

Puis répondez à trois questions, dans cet ordre :

* **Ce que la tâche demande.** Le livrable, énoncé en une phrase.
* **Ce qu'elle ne dit pas.** Chaque point que le texte laisse ouvert. Un
  énoncé incomplet ne se comble pas par une supposition silencieuse : posez
  la question, et poursuivez ce qui n'en dépend pas.
* **Ce qui la contredit.** Si la tâche entre en conflit avec l'intention de
  la session ou avec `CONSTITUTION.md`, dites-le et n'exécutez pas.

## 4. Ce qu'il ne faut pas faire

**N'écrivez jamais dans un fichier de session** — ni pour cocher une tâche,
ni pour noter un constat, ni pour corriger une coquille. `CONSTITUTION.md`
place l'agent en lecture seule sur les énoncés. Ce que vous avez à dire, vous
le dites dans votre réponse ; ce que vous produisez va dans le dépôt, à sa
place.
