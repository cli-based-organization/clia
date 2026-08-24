// issue.cue - Frontmatter du type Issue, prefixe ISU.
//
// Genere depuis RES-031-issue.md le 2026-08-11. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : travail. Edition : hybride.
//
// Pas de champ version : un type au cycle travail a une histoire, pas des
// versions.

package clia

#RES_issue: #Frontmatter & {
	type: "issue"
	id: #Id
	title: string & !=""
	status: #Status
	initiateur: "humain" | "agent"
	etat: "ouverte" | "en-cours" | "close" | "abandonnee"
	ouverture: #Date
}
