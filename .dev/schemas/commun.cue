// commun.cue - Champs partages par toutes les ressources.
//
// Genere depuis les definitions de .dev/ressources/ le 2026-08-10.
// Ne pas editer a la main : la source de verite est la definition du type.
// Voir ADR-003 D7 : la couche machine-lisible est derivee, jamais ecrite.

package clia

#Status:     "draft" | "stable" | "deprecated"
#CycleDeVie: "vivant" | "point-fixe" | "travail"
#Edition:    "humain" | "ia" | "hybride" | "co-edition"
#Famille:    "fondamentale" | "conception" | "controle" | "contenu" | "preparation" | "implementation"
#Date:       =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
#Semver:     =~"^[0-9]+[.][0-9]+[.][0-9]+$"

// ADR-001 D3 : l'identite est le champ id, jamais le numero de sequence.
#Id: =~"^[A-Za-z]{2,4}-[a-z0-9]+(-[a-z0-9]+)*$"

// Le frontmatter minimal de toute ressource textuelle.
#Frontmatter: {
	type:   string & !=""
	id:     #Id
	status: #Status
	title?: string & !=""
	name?:  string & !=""
	...
}

// Vocabulaire de relations, RES-001 augmente par ADR-004 D3.
#Relation: "specifie" | "derive-de" | "remplace" | "est-remplacee-par" |
           "reference" | "objecte-a" | "repond-a" | "compose" | "fait-partie-de"
