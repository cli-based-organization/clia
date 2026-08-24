// specification.cue - Frontmatter du type Spécification, prefixe SPC.
//
// Genere depuis RES-020-specification.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_specification: #Frontmatter & {
	type: "specification"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
}
