#!/usr/bin/env texlua
-- model_helper.lua : helpers pour les modeles de diapositives
-- Usage:
--   texlua model_helper.lua ls      TEMPLATES_DIR
--   texlua model_helper.lua explain TEMPLATES_DIR MODEL_NAME
--   texlua model_helper.lua check   CONTENT_MD   TEMPLATES_DIR

local script_dir   = (arg[0] or ""):match("(.*[/\\])") or "./"
local texmf_luatex = "/usr/share/texlive/texmf-dist/tex/luatex/markdown/"
package.path = script_dir .. "lib/?.lua;"
             .. texmf_luatex .. "?.lua;"
             .. package.path

local tinyyaml = require("markdown-tinyyaml")

local function file_read(path)
  local fh = io.open(path, "r")
  if not fh then return nil end
  local s = fh:read("*a")
  fh:close()
  return s
end

local function load_model_yaml(templates_dir, model)
  local path = templates_dir .. "/models/" .. model .. ".yaml"
  local s = file_read(path)
  if not s then return nil, "Fichier introuvable : " .. path end
  local ok, data = pcall(tinyyaml.parse, s)
  if not ok or type(data) ~= "table" then
    return nil, "YAML invalide dans " .. path .. " : " .. tostring(data)
  end
  return data, nil
end

-- Detecter si un segment ressemble a du YAML (commence par cle: )
local function is_yaml_like(s)
  return s:match("^%s*[%a][%a%d%-_]*%s*:") ~= nil
end

-- Parser un content.md en liste de variations {yaml_raw, body}
-- Le YAML de la variation N herite de la variation N-1 (deep_merge dans check).
local function parse_variations(raw)
  local segments = {}
  local buf      = {}
  for line in (raw .. "\n"):gmatch("([^\n]*)\n") do
    if line == "---" then
      segments[#segments+1] = table.concat(buf, "\n")
      buf = {}
    else
      buf[#buf+1] = line
    end
  end
  if #buf > 0 then segments[#segments+1] = table.concat(buf, "\n") end

  -- segments[1] : vide (avant le premier ---); ignore.
  -- Paires suivantes : (yaml_segment, content_segment)
  -- Si un segment n'est pas yaml-like, c'est du content sans yaml (heritage).
  local variations = {}
  local i = 2
  while i <= #segments do
    local seg = segments[i]
    if is_yaml_like(seg) then
      local yaml_raw  = seg
      local body      = (segments[i+1] or ""):match("^%s*(.*%S)%s*$") or ""
      variations[#variations+1] = { yaml_raw = yaml_raw, body = body }
      i = i + 2
    else
      local body = seg:match("^%s*(.*%S)%s*$") or ""
      variations[#variations+1] = { yaml_raw = nil, body = body }
      i = i + 1
    end
  end
  return variations
end

-- Fusion profonde de deux tables (override ecrase base)
local function deep_merge(base, override)
  if type(base) ~= "table" or type(override) ~= "table" then
    return override
  end
  local result = {}
  for k, v in pairs(base) do result[k] = v end
  for k, v in pairs(override) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = deep_merge(result[k], v)
    else
      result[k] = v
    end
  end
  return result
end

-- Commande : ls - liste les modeles disponibles
local function cmd_ls(templates_dir)
  local pipe = io.popen('ls "' .. templates_dir .. '/models/"*.yaml 2>/dev/null')
  if not pipe then
    io.stderr:write("[ERREUR] Impossible de lister les modeles dans " .. templates_dir .. "/models/\n")
    os.exit(1)
  end
  local found = false
  for line in pipe:lines() do
    local name = line:match("([^/]+)%.yaml$")
    if name then
      found = true
      local data = load_model_yaml(templates_dir, name)
      local desc = (data and data.description) or "(aucune description)"
      io.write(string.format("  %-14s  %s\n", name, desc))
    end
  end
  pipe:close()
  if not found then
    io.write("  (aucun modele trouve dans " .. templates_dir .. "/models/)\n")
  end
end

-- Commande : explain - affiche la description et les champs d'un modele
local function cmd_explain(templates_dir, model)
  if not model or model == "" then
    io.stderr:write("[ERREUR] Nom du modele requis\n")
    os.exit(1)
  end
  local data, err = load_model_yaml(templates_dir, model)
  if not data then
    io.stderr:write("[ERREUR] " .. err .. "\n")
    os.exit(1)
  end

  local sep = string.rep("-", 50)
  io.write("Modele : " .. (data.name or model) .. "\n")
  io.write(sep .. "\n")
  io.write((data.description or "") .. "\n\n")

  local fields  = data.fields  or {}
  local cf      = fields.content or {}
  local pf      = fields.params  or {}

  io.write("Champs section content:\n")
  local req = cf.required or {}
  if #req > 0 then
    io.write("  Obligatoires :\n")
    for _, f in ipairs(req) do
      io.write(string.format("    %-16s  [%s] %s\n", f.name, f.type or "string", f.description or ""))
    end
  end
  local opt = cf.optional or {}
  if #opt > 0 then
    io.write("  Optionnels :\n")
    for _, f in ipairs(opt) do
      io.write(string.format("    %-16s  [%s] %s\n", f.name, f.type or "string", f.description or ""))
    end
  end
  if #req == 0 and #opt == 0 then
    io.write("  (aucun champ content specifique - utilise config.yaml)\n")
  end

  local popt = pf.optional or {}
  if #popt > 0 then
    io.write("\nChamps section params:\n")
    io.write("  Optionnels :\n")
    for _, f in ipairs(popt) do
      io.write(string.format("    %-16s  [%s] %s\n", f.name, f.type or "string", f.description or ""))
    end
  end

  if data.notes then
    io.write("\nNotes :\n  " .. data.notes:gsub("\n", "\n  ") .. "\n")
  end

  if data.example then
    io.write("\nExemple content.md :\n")
    io.write(data.example .. "\n")
  end
end

-- Commande : check - valide le format d'un content.md
local function cmd_check(content_md, templates_dir)
  if not content_md or content_md == "" then
    io.stderr:write("[ERREUR] Chemin du content.md requis\n")
    os.exit(1)
  end

  local raw = file_read(content_md)
  if not raw then
    io.stderr:write("[ERREUR] Fichier introuvable : " .. content_md .. "\n")
    os.exit(1)
  end

  local errors = {}
  local warns  = {}

  -- Verifier la presence du front matter
  if not raw:match("^%-%-%-") then
    errors[#errors+1] = "Le fichier ne commence pas par --- (front matter YAML manquant)"
  end

  local variations = parse_variations(raw)
  if #variations == 0 then
    errors[#errors+1] = "Aucune variation detectee"
  end

  -- Analyser la premiere variation pour connaitre le modele
  local first_var = variations[1] or {}
  local first_meta = {}
  if first_var.yaml_raw then
    local cleaned = first_var.yaml_raw:gsub("@([./])", "%1"):gsub("\\ ", " ")
    local ok, data = pcall(tinyyaml.parse, cleaned)
    if ok and type(data) == "table" then
      first_meta = data
    else
      errors[#errors+1] = "YAML invalide dans la variation 1 : " .. tostring(data)
    end
  end

  -- Detecter le format
  local is_new = (first_meta.diapo ~= nil)
  local model_name

  if is_new then
    if not (first_meta.diapo and first_meta.diapo.model) then
      errors[#errors+1] = "diapo.model absent dans la variation 1"
    else
      model_name = first_meta.diapo.model
    end
  else
    warns[#warns+1] = "Format ancien detecte (sans section diapo:) - nouveau format recommande"
    model_name = first_meta.model
    if not model_name then
      errors[#errors+1] = "Champ model absent (format ancien)"
    end
  end

  -- Verifier que le modele existe et controle les champs requis
  if model_name then
    local model_data, err = load_model_yaml(templates_dir, model_name)
    if not model_data then
      errors[#errors+1] = "Modele inconnu : " .. model_name .. " (" .. (err or "") .. ")"
    else
      -- Fusionner les metas de toutes les variations pour la verification des champs
      local merged = first_meta
      for vi = 2, #variations do
        local v = variations[vi]
        if v.yaml_raw then
          local cleaned_v = v.yaml_raw:gsub("@([./])", "%1"):gsub("\\ ", " ")
          local ok, data = pcall(tinyyaml.parse, cleaned_v)
          if ok and type(data) == "table" then
            merged = deep_merge(merged, data)
          end
        end
      end

      -- Verifier les champs obligatoires dans content:
      local required = ((model_data.fields or {}).content or {}).required or {}
      local content_vals = is_new and (first_meta.content or {}) or first_meta
      for _, f in ipairs(required) do
        if content_vals[f.name] == nil then
          errors[#errors+1] = "Champ requis absent : content." .. f.name
        end
      end

      -- Verifier le nombre de variations vs diapo.variations
      if is_new and first_meta.diapo and first_meta.diapo.variations then
        local declared = tonumber(first_meta.diapo.variations)
        if declared and declared ~= #variations then
          warns[#warns+1] = string.format(
            "diapo.variations declare %d mais %d variation(s) detectee(s)",
            declared, #variations)
        end
      end
    end
  end

  -- Rapport
  for _, w in ipairs(warns)  do io.write("[WARN]   " .. w .. "\n") end
  for _, e in ipairs(errors) do io.write("[ERREUR] " .. e .. "\n") end

  if #errors > 0 then
    io.write("[KO] " .. content_md .. " - " .. #errors .. " erreur(s)\n")
    os.exit(1)
  else
    io.write("[OK] " .. content_md .. " (" .. #variations .. " variation(s))\n")
  end
end

-- Commande : fields - emet les champs content requis (usage interne diapo init)
local function cmd_fields(templates_dir, model)
  if not model or model == "" then os.exit(0) end
  local data = load_model_yaml(templates_dir, model)
  if not data then os.exit(0) end
  local req = ((data.fields or {}).content or {}).required or {}
  for _, f in ipairs(req) do
    io.write("  " .. f.name .. ": \n")
  end
end

-- Dispatch
local cmd = arg[1] or ""
if     cmd == "ls"      then cmd_ls(arg[2] or "templates")
elseif cmd == "explain" then cmd_explain(arg[2] or "templates", arg[3])
elseif cmd == "check"   then cmd_check(arg[2], arg[3] or "templates")
elseif cmd == "fields"  then cmd_fields(arg[2] or "templates", arg[3])
else
  io.stderr:write("Usage: texlua model_helper.lua {ls|explain|check|fields} ...\n")
  io.stderr:write("  ls      TEMPLATES_DIR\n")
  io.stderr:write("  explain TEMPLATES_DIR MODEL_NAME\n")
  io.stderr:write("  check   CONTENT_MD TEMPLATES_DIR\n")
  io.stderr:write("  fields  TEMPLATES_DIR MODEL_NAME  (interne : champs requis)\n")
  os.exit(1)
end
