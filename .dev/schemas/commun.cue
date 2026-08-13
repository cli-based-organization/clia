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

// ADR-007 : l'identite est le champ id, de la forme <PREFIX>-<SEQ>. Elle est
// relative au depot et attribuee a la creation. La seconde forme designe un
// atome de composite : <PREFIX>-<SEQ>-<NN>.
#Id: =~"^[A-Za-z]{2,4}-[0-9]{3}(-[0-9]{2})?$"

// DCN-016, en vigueur le 2026-08-13 : quatre champs d'etat pour toute
// ressource. Trois natures d'etat etaient confondues sous status, qui valait
// draft dans les 157 instances du depot ; la quatriemme, le cycle de vie
// metier, etait portee par huit champs differents selon le type.
#Maturity: "conception" | "mature" | "fin-de-vie" | "obsolete"
#Adoption: "propose" | "adopte" | "conteste" | "obsolete"

// Le frontmatter minimal de toute ressource textuelle.
//
// domain-status est OPTIONNEL ici, et lui seul : ses valeurs sont declarees
// par le RES du type, et vingt-cinq des trente-sept types declarent n'avoir
// aucun cycle de vie metier propre. Le contraindre a l'echelle commune
// exigerait une valeur de types qui n'en ont pas.
#Frontmatter: {
	type:     string & !=""
	id:       #Id
	status:   #Status
	maturity: #Maturity
	adoption: #Adoption
	activated: bool
	"domain-status"?: string & !=""
	title?: string & !=""
	name?:  string & !=""
	...
}

// Vocabulaire de relations, RES-001 augmente par ADR-004 D3.
#Relation: "specifie" | "derive-de" | "remplace" | "est-remplacee-par" |
           "reference" | "objecte-a" | "repond-a" | "compose" | "fait-partie-de"
