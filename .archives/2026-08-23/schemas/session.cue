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
	// Une session en planification n'a pas de date d'ouverture.
	ouverture: #Date | "À RENSEIGNER"
	// Cycle de vie : todo -> opened -> closed.
	etat: "todo" | "opened" | "closed"
	// Inscrite par clia ses close.
	fermeture?: #Date
}
