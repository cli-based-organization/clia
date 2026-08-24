# Analyse avant réalisation, tâche 34

`MET-003` étape 2.

## Sept bogues réels, et ce qu'ils ont en commun

Le dépôt en porte sept, constatés en trois jours. Quatre sont documentés dans le code, trois dans les journaux.

| Date | Bogue | Règle enfreinte |
|---|---|---|
| 2026-08-09 | 14 ADR archivés comptés parmi 3 ADR actifs | Les archives portent l'état révolu |
| 2026-08-10 | Les gabarits comptés comme instances | `RES-001` les place hors du modèle |
| 2026-08-10 | `type: 009` au lieu de `type: decision` | `ADR-007` : l'id ne porte plus le slug |
| 2026-08-11 | Nommage daté pour les types point-fixe | `ADR-007` D4 : le nommage daté est aboli |
| 2026-08-11 | `clia git save` cassé par le nouveau nommage | `MET-003` C4 change le nom des logs |
| 2026-08-11 | Un test codifiait le bogue du nommage | `ADR-007` D4 |
| 2026-08-11 | Le statut affiché n'apprend rien | `PDC-001` auto-découvrabilité |

**Ce que les sept partagent, sans exception.** Chacun est un **écart entre un comportement attendu et un comportement constaté**, et l'attendu vient d'une **règle écrite** : une décision, un principe, une définition.

C'est ce qui donne la définition, et elle est tirée des cas, non d'une idée.

## Ce qui distingue le bogue de ses voisins

| Voisin | Ce qui départage |
|---|---|
| `ISU`, issue | L'issue n'a **aucune règle de référence**. Le bogue en a une, et l'écart se mesure contre elle |
| `CMP`, comportement attendu | Le comportement dit ce qui **doit** être. Le bogue dit ce qui **n'est pas** |
| `NON`, objection | L'objection conteste une règle. Le bogue constate qu'une règle n'est pas tenue |

**La troisième frontière est la plus utile.** `NON-005` conteste depuis le 2026-08-09 l'accumulation de règles écrites et non tenues. Un bogue est le **cas particulier** d'une de ces règles, constaté sur un objet précis.

**Ce que cela implique.** Un bogue est plus SMART qu'une issue : il a une règle, donc un critère de réussite, et il est reproductible, donc vérifiable. C'est ce qui justifie un type distinct plutôt qu'une catégorie d'issue.

## Le cas le plus instructif des sept

Le sixième : **un test codifiait le bogue**.

`un type point-fixe est nomme par date` vérifiait la forme que `ADR-007` D4 abolit, et passait au vert pendant deux jours.

**Ce qu'il enseigne.** Un bogue peut être protégé par ce qui devrait le détecter. La rubrique de correction doit donc dire si un contrôle existait, et ce qu'il faisait.

## Ce que le type doit porter, tiré des cas

| Rubrique | Ce que les sept cas montrent |
|---|---|
| L'écart | Ce qui est attendu, ce qui est constaté |
| La règle enfreinte | Toujours identifiable : `ADR-007` D4, `PDC-001`, `RES-001` |
| La reproduction | Six des sept sont reproductibles par une commande |
| La cause | Toujours trouvée, et souvent différente du symptôme |
| La correction | Ce qui a été fait, et le contrôle ajouté |

**La cause diffère du symptôme dans cinq cas sur sept.** Le symptôme du troisième bogue était `type: 009` ; la cause était que le générateur dépendait de l'`id`, dont la forme avait changé.

## Ce que je ne suivrai pas, et pourquoi

`DCN-016`, produite hier, demande quatre champs d'état : `maturity`, `adoption`, `activated`, `domain-status`.

**Elle porte `effet: suspendue`.** C'est un premier jet en attente d'approbation, et `PLN-007` déclare qu'exécuter avant approbation reviendrait à appliquer une décision qui n'en est pas une.

Le type `BUG` suit donc le modèle **en vigueur** : `status` plus un champ propre. Sa migration vers les quatre champs est portée par `PLN-007` chantier D, qui vise les cent cinquante-sept instances.

**Le signaler évite un précédent.** Créer un type sous un modèle non approuvé forcerait la main sur `DCN-016`.

## Ce que je ne ferai pas

**Le registre de bogues.** `PLN-005` chantier D le porte, et `NON-029` Q1 laisse ouverte la question du type unique ou de la catégorie.

**Documenter les sept bogues comme instances.** La tâche demande le type, non ses instances. Six des sept sont corrigés, et `RES-031` pose qu'on ne consigne que ce qui risque d'être perdu ou contesté.
