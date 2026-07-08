#!/usr/bin/env bash
# dev.sh - outil de generation et de gestion de la presentation
#
# Usage (apres `. activate`) :
#   dev.sh gen                          - genere dist/presentation.pdf
#   dev.sh gen --verbatim               - idem, avec pages verbatim intercalees
#   dev.sh gen --dev                    - dist/<YYYY-MM-DD>_presentation-dev.pdf (avec verbatim)
#   dev.sh gen --prod                   - dist/<YYYY-MM-DD>_presentation.pdf (sans verbatim)
#   dev.sh clean                        - vide workdir/
#   dev.sh model ls                     - liste les modeles disponibles
#   dev.sh model explain MODEL          - affiche les champs d'un modele
#   dev.sh diapo init [--params] [--global-params] SEQ MODEL
#                                       - cree src/slide-SEQ/content.md
#   dev.sh diapo check SEQ             - verifie le format d'une diapo
#   dev.sh qrcode URL OUTPUT [--logo PATH] [--ratio N]
#                                       - genere dist/OUTPUT (QR + logo compose)
#   dev.sh --help | -h                  - affiche ce message
#
# Stack (ADR-001) : texlua + LuaLaTeX + Beamer + metropolis. Ni Python ni pandoc.
# Variable attendue : PRESENTATION_ROOT (positionnee par `. activate`)

set -euo pipefail

ROOT="${PRESENTATION_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
SLIDES_SRC="$ROOT/src"
TEMPLATES="$ROOT/templates"
WORKDIR="$ROOT/workdir"
DIST="$ROOT/dist"
WORKDIR_TEX="$WORKDIR/tex"
WORKDIR_ASSETS="$WORKDIR/assets"
THEME_YAML="$ROOT/src/theme.yaml"

usage() {
    grep '^#' "$0" | sed 's/^# //' | sed 's/^#//'
    exit 0
}

clean() {
    rm -rf "$WORKDIR/tex" "$WORKDIR/assets" \
           "$WORKDIR"/main.tex "$WORKDIR"/main.pdf \
           "$WORKDIR"/*.aux "$WORKDIR"/*.log \
           "$WORKDIR"/*.nav "$WORKDIR"/*.snm \
           "$WORKDIR"/*.toc "$WORKDIR"/*.out \
           "$WORKDIR"/*.fdb_latexmk "$WORKDIR"/*.fls \
           "$WORKDIR"/build.log 2>/dev/null || true
    echo "[OK] workdir nettoye"
}

gen() {
    # config.yaml principal (fallback vers src/global-params.yaml si absent) ;
    # resolu ici (pas au chargement du script) car seule cette commande en a besoin.
    local config_yaml
    if [ -f "$ROOT/config.yaml" ]; then
        config_yaml="$ROOT/config.yaml"
    else
        config_yaml="$ROOT/src/global-params.yaml"
    fi

    local opt_verbatim=false
    local mode=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --verbatim) opt_verbatim=true; shift ;;
            --dev)
                [ -n "$mode" ] && { echo "[ERREUR] --dev et --prod sont exclusifs" >&2; exit 1; }
                mode="dev"; shift ;;
            --prod)
                [ -n "$mode" ] && { echo "[ERREUR] --dev et --prod sont exclusifs" >&2; exit 1; }
                mode="prod"; shift ;;
            *) echo "[ERREUR] Option inconnue : $1" >&2; exit 1 ;;
        esac
    done

    # Convention de sortie : dev (avec verbatim) ou prod (sans verbatim), prefixes par la date.
    # Sans --dev/--prod : comportement historique (dist/presentation.pdf).
    local out_name="presentation.pdf"
    local today; today=$(date +%F)
    case "$mode" in
        dev)  opt_verbatim=true;  out_name="${today}_presentation-dev.pdf" ;;
        prod) opt_verbatim=false; out_name="${today}_presentation.pdf" ;;
    esac

    mkdir -p "$WORKDIR_TEX" "$WORKDIR_ASSETS" "$DIST"

    cp "$TEMPLATES/theme/"*.sty "$WORKDIR/"
    texlua "$ROOT/scripts/theme_helper.lua" "$THEME_YAML" "$WORKDIR/theme.generated.tex"

    # Pre-passe : calculer la numerotation <sec>.<diapo> pour chaque slide
    declare -A _sec_nums
    declare -A _slide_nums
    local _nb_inputs=()
    for _sd in "$SLIDES_SRC"/slide-*/; do
        [ -f "${_sd}content.md" ] && _nb_inputs+=("${_sd}content.md")
    done
    if [ ${#_nb_inputs[@]} -gt 0 ]; then
        while IFS=$'\t' read -r _dir _sn _dn; do
            _sec_nums["$_dir"]="$_sn"
            _slide_nums["$_dir"]="$_dn"
        done < <(texlua "$ROOT/scripts/compute_numbering.lua" "${_nb_inputs[@]}")
    fi

    local slide_tex_files=()
    for slide_dir in "$SLIDES_SRC"/slide-*/; do
        local content_md="$slide_dir/content.md"
        [ -f "$content_md" ] || continue
        local name; name=$(basename "$slide_dir")
        local num="${name#slide-}"
        local _sn="${_sec_nums[$slide_dir]:-}"
        local _dn="${_slide_nums[$slide_dir]:-}"

        # Mode verbatim : intercaler la page verbatim avant le slide (si verbatim.md existe)
        if $opt_verbatim && [ -f "$slide_dir/verbatim.md" ]; then
            local verbatim_out="$WORKDIR_TEX/${name}-verbatim.tex"
            NOU_SEC_NUM="$_sn" NOU_SLIDE_NUM="$_dn" \
            texlua "$ROOT/scripts/render_slide.lua" \
                "$content_md" \
                "$config_yaml" \
                "$verbatim_out" \
                "$TEMPLATES" \
                "$WORKDIR_ASSETS" \
                "$slide_dir/verbatim.md" \
                "$num"
            slide_tex_files+=("$verbatim_out")
        fi

        local out="$WORKDIR_TEX/${name}.tex"
        NOU_SEC_NUM="$_sn" NOU_SLIDE_NUM="$_dn" \
        texlua "$ROOT/scripts/render_slide.lua" \
            "$content_md" \
            "$config_yaml" \
            "$out" \
            "$TEMPLATES" \
            "$WORKDIR_ASSETS"
        slide_tex_files+=("$out")
    done

    if [ ${#slide_tex_files[@]} -eq 0 ]; then
        echo "[ERREUR] Aucun content.md trouve dans $SLIDES_SRC/slide-*/" >&2
        exit 1
    fi

    local main_tex="$WORKDIR/main.tex"
    {
        cat "$TEMPLATES/preamble.tex"
        echo '\begin{document}'
        for f in "${slide_tex_files[@]}"; do
            echo "\\input{$f}"
        done
        echo '\end{document}'
    } > "$main_tex"

    if command -v latexmk >/dev/null 2>&1; then
        latexmk -lualatex -outdir="$WORKDIR" -interaction=nonstopmode "$main_tex" \
            > "$WORKDIR/build.log" 2>&1
    else
        lualatex -interaction=nonstopmode -output-directory="$WORKDIR" "$main_tex" \
            > "$WORKDIR/build.log" 2>&1
        lualatex -interaction=nonstopmode -output-directory="$WORKDIR" "$main_tex" \
            >> "$WORKDIR/build.log" 2>&1
    fi

    if [ -f "$WORKDIR/main.pdf" ]; then
        cp "$WORKDIR/main.pdf" "$DIST/$out_name"
        echo "[OK] dist/$out_name genere"
    else
        echo "[ERREUR] Compilation LuaLaTeX echouee - voir workdir/build.log" >&2
        tail -40 "$WORKDIR/build.log" >&2
        exit 1
    fi
}

# ---------------------------------------------------------------------------
# Commandes model
# ---------------------------------------------------------------------------

model_cmd() {
    case "${1:-}" in
        ls)
            texlua "$ROOT/scripts/model_helper.lua" ls "$TEMPLATES"
            ;;
        explain)
            local model="${2:-}"
            if [ -z "$model" ]; then
                echo "[ERREUR] Usage : dev.sh model explain MODEL" >&2; exit 1
            fi
            texlua "$ROOT/scripts/model_helper.lua" explain "$TEMPLATES" "$model"
            ;;
        *)
            echo "Usage : dev.sh model {ls|explain MODEL}" >&2; exit 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Commandes diapo
# ---------------------------------------------------------------------------

diapo_cmd() {
    case "${1:-}" in
        init)  shift; diapo_init "$@" ;;
        check) shift; diapo_check "$@" ;;
        *)
            echo "Usage : dev.sh diapo {init|check} ..." >&2; exit 1
            ;;
    esac
}

# dev.sh diapo init [--params] [--global-params] SEQ MODEL
diapo_init() {
    local include_params=false
    local include_global=false
    local args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --params)        include_params=true; shift ;;
            --global-params) include_global=true; shift ;;
            *)               args+=("$1"); shift ;;
        esac
    done

    local seq="${args[0]:-}"
    local model="${args[1]:-}"

    if [ -z "$seq" ] || [ -z "$model" ]; then
        echo "[ERREUR] Usage : dev.sh diapo init [--params] [--global-params] SEQ MODEL" >&2
        exit 1
    fi

    # Normaliser le numero de sequence sur 2 chiffres
    local seq_fmt; seq_fmt=$(printf "%02d" "$seq" 2>/dev/null) || {
        echo "[ERREUR] SEQ doit etre un entier positif" >&2; exit 1
    }

    # Verifier que le modele existe
    if [ ! -f "$TEMPLATES/models/${model}.yaml" ]; then
        echo "[ERREUR] Modele inconnu : $model" >&2
        echo "  Modeles disponibles :"
        texlua "$ROOT/scripts/model_helper.lua" ls "$TEMPLATES" >&2
        exit 1
    fi

    local slide_dir="$SLIDES_SRC/slide-${seq_fmt}"
    local out_file="$slide_dir/content.md"

    if [ -f "$out_file" ]; then
        echo "[ERREUR] $out_file existe deja" >&2
        exit 1
    fi

    mkdir -p "$slide_dir"

    # Generer le contenu du template
    {
        printf -- '---\n'
        printf 'diapo:\n'
        printf '  model: %s\n' "$model"
        printf 'content:\n'
        # Charger les champs requis depuis le yaml du modele via texlua
        # (liste simple pour les champs content requis)
        _diapo_required_fields "$model"
        if $include_params; then
            printf 'params:\n'
        fi
        if $include_global; then
            printf 'global-params:\n'
        fi
        printf -- '---\n'
        printf '\n'
        printf 'Contenu Markdown de la slide.\n'
    } > "$out_file"

    echo "[OK] $out_file cree (modele : $model)"
}

# Emet les champs requis du modele sous forme de lignes YAML content: (via texlua)
_diapo_required_fields() {
    texlua "$ROOT/scripts/model_helper.lua" fields "$TEMPLATES" "$1"
}

# dev.sh diapo check SEQ
diapo_check() {
    local seq="${1:-}"
    if [ -z "$seq" ]; then
        echo "[ERREUR] Usage : dev.sh diapo check SEQ" >&2; exit 1
    fi

    local seq_fmt; seq_fmt=$(printf "%02d" "$seq" 2>/dev/null) || {
        echo "[ERREUR] SEQ doit etre un entier positif" >&2; exit 1
    }

    local content_md="$SLIDES_SRC/slide-${seq_fmt}/content.md"
    if [ ! -f "$content_md" ]; then
        echo "[ERREUR] Fichier introuvable : $content_md" >&2; exit 1
    fi

    texlua "$ROOT/scripts/model_helper.lua" check "$content_md" "$TEMPLATES"
}

# ---------------------------------------------------------------------------
# Commande qrcode
# ---------------------------------------------------------------------------

# dev.sh qrcode URL OUTPUT [--logo PATH] [--ratio N]
qrcode_cmd() {
    local logo="$ROOT/src/assets/isotipo-noumanity.png"
    local ratio="0.30"
    local args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --logo)  logo="$2"; shift 2 ;;
            --ratio) ratio="$2"; shift 2 ;;
            *)       args+=("$1"); shift ;;
        esac
    done

    local url="${args[0]:-}"
    local out="${args[1]:-}"
    if [ -z "$url" ] || [ -z "$out" ]; then
        echo "[ERREUR] Usage : dev.sh qrcode URL OUTPUT [--logo PATH] [--ratio N]" >&2
        exit 1
    fi

    command -v qrencode >/dev/null 2>&1 || { echo "[ERREUR] qrencode requis" >&2; exit 1; }
    command -v convert  >/dev/null 2>&1 || { echo "[ERREUR] convert (ImageMagick) requis" >&2; exit 1; }

    mkdir -p "$DIST" "$WORKDIR_ASSETS"
    local base_png="$WORKDIR_ASSETS/qrcode-base.png"
    # -l H : correction d'erreur elevee, tolere un logo central sans casser le scan.
    qrencode -o "$base_png" -s 10 -m 2 -l H "$url"

    local target="$DIST/$out"
    if [ -f "$logo" ]; then
        local qr_w; qr_w=$(identify -format "%w" "$base_png")
        local logo_size; logo_size=$(awk -v w="$qr_w" -v r="$ratio" 'BEGIN{printf "%d", w*r}')
        local logo_small="$WORKDIR_ASSETS/qrcode-logo.png"
        convert "$logo" -resize "${logo_size}x${logo_size}" "$logo_small"
        convert "$base_png" "$logo_small" -gravity center -compose over -composite "$target"
    else
        cp "$base_png" "$target"
    fi
    echo "[OK] $target genere"
}

# ---------------------------------------------------------------------------
# Dispatch principal
# ---------------------------------------------------------------------------

case "${1:-}" in
    gen)    shift; gen "$@" ;;
    clean)  clean ;;
    model)  shift; model_cmd "$@" ;;
    diapo)  shift; diapo_cmd "$@" ;;
    qrcode) shift; qrcode_cmd "$@" ;;
    --help|-h) usage ;;
    "")     usage ;;
    *)      echo "[ERREUR] Commande inconnue : $1" >&2; usage ;;
esac
