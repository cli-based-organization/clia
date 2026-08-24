// concept.cue - Frontmatter du type Concept, prefixe CPT.
//
// Genere depuis RES-007-concept.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_concept: #Frontmatter & {
	type: "concept"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	"terme-ontologique": string & !=""
	origine: string & !=""
	"emplois-attestes": string & !=""
}
