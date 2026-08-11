// registre.cue - Frontmatter du type Registre, prefixe REG.
//
// Genere depuis RES-035-registre.md le 2026-08-11. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : travail. Edition : hybride.
//
// Pas de champ version : un type au cycle travail a une histoire.

package clia

#RES_registre: #Frontmatter & {
	type: "registre"
	id: #Id
	title: string & !=""
	status: #Status
	"registre-de": string & !=""
	tenue: "saisie" | "derivee"
}
