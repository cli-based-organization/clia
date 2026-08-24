// adr.cue - Frontmatter du type Décision d'architecture, prefixe ADR.
//
// Genere depuis RES-019-adr.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_adr: #Frontmatter & {
	type: "adr"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	"statut-decision": "propose" | "accepte" | "remplacee" | "abandonnee"
	date: #Date
	decideurs: [...string]
}
