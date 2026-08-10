// analyse.cue - Frontmatter du type Analyse, prefixe ANL.
//
// Genere depuis RES-010-analyse.md le 2026-08-10. Ne pas editer a la main.
// Famille : conception. Cycle de vie : point-fixe. Edition : ia.

package clia

#RES_analyse: #Frontmatter & {
	type: "analyse"
	id: #Id
	title: string & !=""
	status: #Status
	date: #Date
	sujet: string & !=""
}
