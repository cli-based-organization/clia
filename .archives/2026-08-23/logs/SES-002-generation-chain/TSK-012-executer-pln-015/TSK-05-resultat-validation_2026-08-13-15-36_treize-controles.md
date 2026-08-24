# Résultat de la validation, tâche 12 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Le journal rapporte les quatre passages fidèlement | **Réussi**, y compris le premier essai invalidé |
| 2 | La trace établit que le hook a été appelé | **Réussi pour les deux passages, mais la trace ne le montre plus** — voir plus bas |
| 3 | Le critère du chantier B est satisfait | **Réussi**, six cas, six lignes |
| 4 | Les six cas sont des interruptions réelles | **Réussi** : interruptions 1, 2, 3, 5, 7 et 9 de `BUG-001` |
| 5 | `PLN-015` n'est pas passé à `execute` | **Réussi**, `statut-plan: propose` |
| 6 | Le sort de chaque chantier est déclaré | **Réussi** : A échoué, B exécuté, C hors d'atteinte |
| 7 | Les corrections à `ANL-012` sont signalées | **Réussi**, les deux |
| 8 | Conformité au schéma des trois documents | **Réussi**, 3 sur 3 |
| 9 | La suite de tests | **Réussi, 279 assertions**, inchangé |
| 10 | Le dépôt ne régresse pas | **Réussi** : 164 conformes, 17 non conformes, inchangé |
| 11 | `clia focus` n'est pas affecté | **Échoué, et c'est une trouvaille** — voir plus bas |
| 12 | Le journal suit `MET-003` | **Réussi** : deux versements de `fait`, 15:25 et 15:32 |
| 13 | La tâche ne se déclare pas réussie sur un chantier échoué | **Réussi** |

## Le contrôle 2, et ce que la trace ne prouve plus

Le hook a bien laissé `appele decision=allow outil=Bash` lors du passage `allow` — c'est ce qui a permis de conclure que sa décision était rendue et non suivie.

**Mais le fichier de trace a été effacé avant le dernier passage**, et ne contient plus que `decision=deny`. La preuve du passage `allow` n'existe que dans la sortie de commande rapportée au journal de fait, pas dans un artefact conservé.

**Ce que cela coûte** : la mesure est reproductible — les scripts sont dans le répertoire de travail — mais elle n'est pas rejouable à l'identique depuis les traces. C'est déclaré plutôt que passé sous silence.

## Le contrôle 11 a échoué, et il a trouvé quelque chose

`PLN-015` est **toujours rangé en `A EXECUTER`**.

C'est cohérent avec le code : il reste `propose`, et il ne cite aucune décision suspendue. **Et c'est faux du point de vue de l'humain** : son chantier A a échoué, B est fait, C dépendait de A. Il n'y a plus rien à exécuter.

**C'est `BUG-004` sous une troisième forme**, constatée une heure après sa correction. Le bogue a été mis à jour : ce n'est pas le lien vers une décision suspendue qui manque, **c'est l'exécutabilité qui n'est modélisée nulle part** — ni dans `PDC-003`, ni dans le frontmatter du plan.

**Je n'ai pas corrigé `clia focus` une seconde fois.** La tâche est l'exécution de `PLN-015` ; élargir la détection serait un chantier à part entière, et il demande de décider où l'exécutabilité doit vivre. Le cas est consigné dans `BUG-004`, qui reste ouvert.

## Ce que la tâche établit, et qui n'est pas confortable

**La piste retenue par `ANL-012` ne fonctionne pas là où elle a été éprouvée.** Un hook décide dans le sens du refus, pas de l'autorisation.

**Elle n'est pas réfutée pour autant.** Le mode non interactif ne produit jamais la demande de confirmation que `BUG-001` constate : l'établir demanderait une session interactive et un humain qui regarde l'écran. **C'est la seule chose que cette tâche ne pouvait pas faire elle-même.**

**Six interruptions sur quinze ont un correctif écrit et applicable dès maintenant.** Les huit autres n'en ont aucun, hors le mode de permission à l'invocation.

## Ce que la validation ne couvre pas

**Les deux règles de conduite n'ont pas été éprouvées à l'usage.** Elles seront tenues, ou non, par les tâches suivantes. La seule mesure qui compte est le nombre d'interruptions de la prochaine tâche, et elle appartient à l'humain qui la vit.

**Aucune mesure n'a été faite en session interactive.** C'est la limite qui décide du sort de `PLN-015`, et elle demande un geste humain.
