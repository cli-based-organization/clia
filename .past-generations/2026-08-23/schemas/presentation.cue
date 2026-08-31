// presentation.cue - Frontmatter du type Présentation, prefixe PRS.
//
// Genere depuis RES-029-presentation.md le 2026-08-10. Ne pas editer a la main.
// Famille : implementation. Cycle de vie : point-fixe. Edition : ia.

package clia

#RES_presentation: #Frontmatter & {
	type: "presentation"
	id: #Id
	title: string & !=""
	status: #Status
	date: #Date
	auditoire: string & !=""
	evenement: string & !=""
}
