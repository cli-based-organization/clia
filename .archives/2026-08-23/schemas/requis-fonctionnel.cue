// requis-fonctionnel.cue - Frontmatter du type Requis fonctionnel, prefixe RQF.
//
// Genere depuis RES-021-requis-fonctionnel.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_requis_fonctionnel: #Frontmatter & {
	type: "requis-fonctionnel"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	"specification-parente": string & !=""
}
