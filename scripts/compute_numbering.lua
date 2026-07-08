#!/usr/bin/env texlua
-- compute_numbering.lua - calcule la numérotation <sec>.<diapo> pour chaque slide
-- Usage: texlua compute_numbering.lua content1.md content2.md ...
-- Output: une ligne par slide : dir TAB sec_num TAB slide_num
--         (sec_num et slide_num vides si la slide n'est pas numérotée)
-- Règles (tâche 11) :
--   - Seules les slides de modèle `plain` ou `tableau` (dérivé de plain) sont comptées.
--   - Une slide sans champ section n'est pas numérotée et ne modifie pas les compteurs.
--   - Un changement de section incrémente sec_num et remet slide_num à 1.
--   - La diapo (slide_num) s'incrémente à chaque nouveau fichier content.md dans la section.
--   - Les variations d'un même content.md partagent le même numéro (1re variation seulement).

local script_dir   = (arg[0] or ""):match("(.*[/\\])") or "./"
local texmf_luatex = "/usr/share/texlive/texmf-dist/tex/luatex/markdown/"
package.path = script_dir .. "lib/?.lua;" .. texmf_luatex .. "?.lua;" .. package.path

local tinyyaml = require("markdown-tinyyaml")

local COUNTED_MODELS = { plain = true, tableau = true, equation = true }

local function parse_slide_info(path)
  local fh = io.open(path, "r")
  if not fh then return nil, nil end
  local raw = fh:read("*a"); fh:close()
  raw = raw:gsub("@([./])", "%1"):gsub("\\ ", " ")
  local segments, buf = {}, {}
  for line in (raw .. "\n"):gmatch("([^\n]*)\n") do
    if line == "---" then segments[#segments+1] = table.concat(buf, "\n"); buf = {}
    else buf[#buf+1] = line end
  end
  local first_yaml = segments[2] or ""
  local ok, data = pcall(tinyyaml.parse, first_yaml)
  if not ok or type(data) ~= "table" then return nil, nil end
  -- Modèle de la 1re variation (le modèle par défaut s'il n'est pas spécifié est "plain")
  local model = ((data.diapo or {}).model) or "plain"
  -- Section de la 1re variation
  local sec = (data.content or {})["section"]
  if type(sec) ~= "string" or sec == "" then sec = nil end
  return model, sec
end

local sec_num   = 0
local slide_num = 0
local prev_sec  = nil

for i = 1, #arg do
  local path = arg[i]
  local dir  = path:match("(.*[/\\])") or "./"
  local model, sec = parse_slide_info(path)

  -- Seulement les modèles plain ou tableau avec une section
  if model and COUNTED_MODELS[model] and sec then
    if sec ~= prev_sec then
      sec_num   = sec_num + 1
      slide_num = 1
      prev_sec  = sec
    else
      slide_num = slide_num + 1
    end
    io.write(dir .. "\t" .. sec_num .. "\t" .. slide_num .. "\n")
  else
    io.write(dir .. "\t\t\n")
  end
end
