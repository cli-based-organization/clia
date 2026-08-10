// intention.cue - Frontmatter du type Intention, prefixe INT.
//
// Genere depuis RES-003-intention.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : vivant. Edition : humain.

package clia

#RES_intention: #Frontmatter & {
	type: "intention"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	portee: string & !=""
	"critere-de-satisfaction": string & !=""
	"critere-de-trahison": string & !=""
}
