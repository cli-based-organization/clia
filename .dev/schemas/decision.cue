// decision.cue - Frontmatter du type Décision, prefixe DCN.
//
// Genere depuis RES-009-decision.md le 2026-08-10. Ne pas editer a la main.
// Famille : contenu. Cycle de vie : vivant. Edition : hybride.

package clia

#RES_decision: #Frontmatter & {
	type: "decision"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	instance: string & !=""
	"date-de-decision": #Date
	portee: string & !=""
	effet: "proposee" | "en-vigueur" | "suspendue" | "abrogee" | "remplacee"
}
