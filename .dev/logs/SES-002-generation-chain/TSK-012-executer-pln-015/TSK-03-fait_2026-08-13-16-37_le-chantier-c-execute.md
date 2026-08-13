# Ce qui a été fait, tâche 12 — réexécution

`MET-003` étape 3. Troisième versement. `derive-de` `TSK-03-fait_2026-08-13-15-32_le-chantier-b-execute.md`.

## Le chantier C n'était pas hors d'atteinte

Le premier passage l'avait déclaré tel, avec ce motif : « une commande qui diagnostique une politique dont on ne sait pas si elle peut agir n'a pas d'objet ».

**C'était une erreur de raisonnement.** On sait désormais ce que le dépôt peut : le chantier A a établi qu'un hook refuse et n'autorise pas. Le diagnostic a donc un objet précis — dire ce que la politique porte, **et nommer l'impossibilité mesurée**.

**Une connaissance négative reste une connaissance.** Le premier passage l'a traitée comme une absence de connaissance.

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## `clia config ia policy check` — `FNC-006` étendue

**Ce qui a été livré.** Le dépôt répond à « puis-je exécuter une tâche sans interrompre l'humain, et sinon qu'est-ce qui manque ? ».

**Comment s'en servir.**

```sh
clia config ia policy check
```

```
MECANISME     ETAT        CE QU IL PORTE
allow         ok          48 regle(s) : ce qui est courant et sur
deny          ok          7 regle(s) : ce qui reste interdit
ask           ok          12 regle(s) : ce qui demande l'humain
hooks         ok          2 evenement(s) outille(s)
autorisation  impossible  un hook refuse, il n'autorise pas : mesure du 2026-08-13

clia: 1 point(s) manquant(s)
```

**Sortie 0 si la politique est complète, 1 sinon.** Elle ne modifie rien : diagnostiquer et corriger sont deux verbes, comme `clia setup check` et `init`.

**La cinquième ligne est le cœur.** Elle porte ce qu'aucune configuration ne comble : la mesure du chantier A. C'est ce qui distingue ce diagnostic d'une simple lecture de `settings.json`.

**Ce qui ne marche pas encore.** `clia config ia policy apply` n'existe pas et sort en 2 en le disant. Il attend `NON-040`, et un mécanisme d'autorisation qui n'est pas démontré.

---

## Un défaut trouvé en éprouvant

**Le premier jet affichait « politique complète » avec cinq manques.** Le décompte se faisait dans un bloc redirigé vers `column`, donc dans un sous-shell : la variable y était incrémentée puis perdue. Corrigé — le décompte précède l'affichage.

C'est le même piège que le `grep -c` de la tâche 9 : **une sortie qui a l'air juste et un code de retour qui ment.**

## Livrables

| Fichier | Nature |
|---|---|
| `lib/clia/config.sh` | `clia config ia policy check` |
| `tests/test_clia.sh` | **8 assertions**, 289 → 297 |
| `.dev/plans/PLN-015-...md` | Statut : le chantier C exécuté, et pourquoi il ne l'était pas |
