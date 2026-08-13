// fonctionnalite.cue - Frontmatter du type Fonctionnalite, prefixe FNC.
//
// Genere depuis RES-037-fonctionnalite.md le 2026-08-13. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : hybride.

package clia

#RES_fonctionnalite: #Frontmatter & {
	type: "fonctionnalite"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	// pressentie : nommee, aucun travail engage.
	etat: "pressentie" | "en-cours" | "livree" | "retiree"
	// La commande ou le geste qui l'emploie, en une ligne. Obligatoire :
	// une fonctionnalite dont on ne peut pas ecrire l'usage n'en est pas une.
	usage: string & !=""
}
