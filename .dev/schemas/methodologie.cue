// methodologie.cue - Frontmatter du type Méthodologie, prefixe MET.
//
// Genere depuis RES-013-methodologie.md le 2026-08-10. Ne pas editer a la main.
// Famille : conception. Cycle de vie : vivant. Edition : ia.

package clia

#RES_methodologie: #Frontmatter & {
	type: "methodologie"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	domaine: string & !=""
}
