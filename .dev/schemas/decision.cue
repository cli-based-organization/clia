// decision.cue - Frontmatter du type Décision, prefixe DCN.
//
// Genere depuis RES-009-decision.md v0.2.0 le 2026-08-10. Ne pas editer a la main.
// Famille : contenu. Cycle de vie : vivant. Edition : humain.
//
// La valeur effet: "remplacee" est derivee, non saisie : voir RES-009 R3.
// Une decision est remplacee si et seulement si une autre declare remplace
// vers elle. CUE ne peut pas verifier cette relation, qui porte sur le depot
// entier et non sur un frontmatter isole. Le controle est specifie dans
// MET-002 etape 6 et n'est outille nulle part.

package clia

#RES_decision: #Frontmatter & {
	type: "decision"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	instance: string & !=""
	"date-de-decision": #Date
	portee: string & !=""
	effet: "proposee" | "en-vigueur" | "suspendue" | "abrogee" | "remplacee"
	attestation: "interne" | "source-primaire" | "source-rapportee" | "temoignage"
	diffusion: "public" | "prive" | "confidentiel"
}
