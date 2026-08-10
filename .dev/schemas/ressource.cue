// ressource.cue - Frontmatter du type Ressource, prefixe RES.
//
// Genere depuis RES-001-ressource.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_ressource: #Frontmatter & {
	type: "ressource"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	prefixe: =~"^[A-Za-z]{2,4}$" | "aucun"
	emplacement: string & !=""
	"cycle-de-vie": #CycleDeVie
	edition: #Edition
	famille: #Famille
	"champs-obligatoires": [...string]
	"relations-admissibles": [...string]
	sections: [...string]
	skill: string & !=""
	adr: string & !=""
	statut: "actif" | "deprecie" | "non-installe"
}
