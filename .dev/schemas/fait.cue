// fait.cue - Frontmatter du type Faits, prefixe FCT.
//
// Genere depuis RES-005-fait.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : point-fixe. Edition : hybride.

package clia

#RES_fait: #Frontmatter & {
	type: "fait"
	id: #Id
	title: string & !=""
	status: #Status
	sujet: string & !=""
	"date-de-constat": #Date
	diffusion: "public" | "prive" | "confidentiel"
}
