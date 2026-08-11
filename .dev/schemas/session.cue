// session.cue - Frontmatter du type Session, prefixe SES.
//
// Genere depuis RES-034-session.md le 2026-08-11. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : travail. Edition : hybride.

package clia

#RES_session: #Frontmatter & {
	type: "session"
	id: #Id
	title: string & !=""
	status: #Status
	ouverture: #Date
	etat: "ouverte" | "close" | "abandonnee"
}
