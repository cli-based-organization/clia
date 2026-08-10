// objection.cue - Frontmatter du type Objection, prefixe NON.
//
// Genere depuis RES-004-objection.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : travail. Edition : hybride.

package clia

#RES_objection: #Frontmatter & {
	type: "objection"
	id: #Id
	title: string & !=""
	status: #Status
	initiateur: string & !=""
	effet: "bloquant" | "conditionnel" | "informatif"
	etat: string & !=""
	"porte-sur": [...string]
}
