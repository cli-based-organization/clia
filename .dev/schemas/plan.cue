// plan.cue - Frontmatter du type Plan de travail, prefixe PLN.
//
// Genere depuis RES-025-plan.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : travail. Edition : ia.

package clia

#RES_plan: #Frontmatter & {
	type: "plan"
	id: #Id
	title: string & !=""
	status: #Status
	"statut-plan": "propose" | "approuve" | "execute" | "abandonne"
	date: #Date
	initiateur: string & !=""
}
