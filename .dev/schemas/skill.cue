// skill.cue - Frontmatter du type Skill, prefixe skl.
//
// Genere depuis RES-018-skill.md le 2026-08-10. Ne pas editer a la main.
// Famille : controle. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_skill: #Frontmatter & {
	type: "skill"
	id: #Id
	name: string & !=""
	version: #Semver
	status: #Status
	description: string & !=""
}
