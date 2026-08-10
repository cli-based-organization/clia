// requis-non-fonctionnel.cue - Frontmatter du type Requis non fonctionnel, prefixe RQNF.
//
// Genere depuis RES-022-requis-non-fonctionnel.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_requis_non_fonctionnel: #Frontmatter & {
	type: "requis-non-fonctionnel"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	qualite: string & !=""
	"specification-parente": string & !=""
}
