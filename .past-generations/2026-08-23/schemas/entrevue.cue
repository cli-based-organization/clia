// entrevue.cue - Frontmatter du type Entrevue, prefixe ENT.
//
// Genere depuis RES-030-entrevue.md le 2026-08-10. Ne pas editer a la main.
// Famille : contenu. Cycle de vie : travail. Edition : hybride.

package clia

#RES_entrevue: #Frontmatter & {
	type: "entrevue"
	id: #Id
	title: string & !=""
	status: #Status
	date: #Date
	interlocuteur: string & !=""
	"objet-de-l-entrevue": string & !=""
}
