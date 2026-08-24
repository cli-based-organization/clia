// rapport-de-recherche.cue - Frontmatter du type Rapport de recherche, prefixe RPT.
//
// Genere depuis RES-027-rapport-de-recherche.md le 2026-08-10. Ne pas editer a la main.
// Famille : implementation. Cycle de vie : point-fixe. Edition : ia.

package clia

#RES_rapport_de_recherche: #Frontmatter & {
	type: "rapport-de-recherche"
	id: #Id
	title: string & !=""
	status: #Status
	date: #Date
	auditoire: string & !=""
	diffusion: "public" | "prive" | "confidentiel"
}
