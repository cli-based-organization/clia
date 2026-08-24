// cas-d-usage.cue - Frontmatter du type Cas d'usage, prefixe USE.
//
// Genere depuis RES-023-cas-d-usage.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_cas_d_usage: #Frontmatter & {
	type: "cas-d-usage"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	"acteur-principal": string & !=""
	niveau: string & !=""
}
