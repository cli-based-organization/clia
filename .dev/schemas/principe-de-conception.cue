// principe-de-conception.cue - Frontmatter du type Principe de conception, prefixe PDC.
//
// Genere depuis RES-012-principe-de-conception.md le 2026-08-10. Ne pas editer a la main.
// Famille : conception. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_principe_de_conception: #Frontmatter & {
	type: "principe-de-conception"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	portee: string & !=""
}
