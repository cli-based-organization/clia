#!/usr/bin/env texlua

local script_dir   = (arg[0] or ""):match("(.*[/\\])") or "./"
local texmf_luatex = "/usr/share/texlive/texmf-dist/tex/luatex/markdown/"
package.path = script_dir .. "lib/?.lua;"
             .. script_dir .. "?.lua;"
             .. texmf_luatex .. "?.lua;"
             .. package.path

local tinyyaml = require("markdown-tinyyaml")

local function normalize_hex(raw, fallback)
  local s = tostring(raw or ""):gsub("^#", "")
  if #s == 3 then
    s = s:sub(1,1):rep(2) .. s:sub(2,2):rep(2) .. s:sub(3,3):rep(2)
  end
  if #s ~= 6 then return fallback end
  return s:upper()
end

local function read_yaml(path)
  local fh = io.open(path, "r")
  if not fh then return {} end
  local content = fh:read("*a")
  fh:close()
  local ok, data = pcall(tinyyaml.parse, content)
  if not ok or type(data) ~= "table" then return {} end
  return data
end

local function get(tbl, keys, default)
  local cur = tbl
  for _, k in ipairs(keys) do
    if type(cur) ~= "table" then return default end
    cur = cur[k]
  end
  if cur == nil then return default end
  return cur
end

local function write_theme_tex(data, out_path)
  local orange = normalize_hex(get(data, {"colors", "orange"}, "#FA4D1F"), "FA4D1F")
  local black  = normalize_hex(get(data, {"colors", "black"},  "#000000"), "000000")
  local white  = normalize_hex(get(data, {"colors", "white"},  "#FFFFFF"), "FFFFFF")

  local frametitle_fg = normalize_hex(get(data, {"palette", "frametitle_fg"}, "#000000"), "000000")
  local progress_bg   = normalize_hex(get(data, {"palette", "progress_bar_bg"}, "#BFBFBF"), "BFBFBF")
  local subitem_fg    = normalize_hex(get(data, {"palette", "subitem_fg"}, "#FA8A70"), "FA8A70")
  local block_body_bg = normalize_hex(get(data, {"palette", "block_body_bg"}, "#F2F2F2"), "F2F2F2")

  local body_font = tostring(get(data, {"fonts", "body", "family"}, "Arimo"))
  local body_bold = tostring(get(data, {"fonts", "body", "bold"}, "Arimo Bold"))
  local body_italic = tostring(get(data, {"fonts", "body", "italic"}, "Arimo Italic"))
  local body_bold_italic = tostring(get(data, {"fonts", "body", "bold_italic"}, "Arimo Bold Italic"))

  local title_font = tostring(get(data, {"fonts", "title", "family"}, "ABeeZee"))
  local title_size = tostring(get(data, {"fonts", "title", "size"}, "\\Large"))
  local frametitle_size = tostring(get(data, {"fonts", "frametitle", "size"}, "\\large"))

  local item_symbol = tostring(get(data, {"symbols", "item"}, "\\textbullet"))
  local subitem_symbol = tostring(get(data, {"symbols", "subitem"}, "\\textendash"))

  local out = assert(io.open(out_path, "w"))
  out:write("% Auto-genere depuis src/theme.yaml\n")
  out:write("\\definecolor{NoumanityOrange}{HTML}{" .. orange .. "}\n")
  out:write("\\definecolor{NoumanityBlack}{HTML}{" .. black .. "}\n")
  out:write("\\definecolor{NoumanityWhite}{HTML}{" .. white .. "}\n")
  out:write("\\definecolor{NouThemeFrametitleFg}{HTML}{" .. frametitle_fg .. "}\n")
  out:write("\\definecolor{NouThemeProgressBarBg}{HTML}{" .. progress_bg .. "}\n")
  out:write("\\definecolor{NouThemeSubitemFg}{HTML}{" .. subitem_fg .. "}\n")
  out:write("\\definecolor{NouThemeBlockBodyBg}{HTML}{" .. block_body_bg .. "}\n")
  out:write("\\def\\NouThemeBodyFont{" .. body_font .. "}\n")
  out:write("\\def\\NouThemeBodyBoldFont{" .. body_bold .. "}\n")
  out:write("\\def\\NouThemeBodyItalicFont{" .. body_italic .. "}\n")
  out:write("\\def\\NouThemeBodyBoldItalicFont{" .. body_bold_italic .. "}\n")
  out:write("\\def\\NouThemeTitleFont{" .. title_font .. "}\n")
  out:write("\\def\\NouThemeTitleSize{" .. title_size .. "}\n")
  out:write("\\def\\NouThemeFrameTitleSize{" .. frametitle_size .. "}\n")
  out:write("\\def\\NouThemeItemSymbol{" .. item_symbol .. "}\n")
  out:write("\\def\\NouThemeSubitemSymbol{" .. subitem_symbol .. "}\n")
  out:close()
end

local function main()
  if #arg < 2 then
    print("Usage: texlua theme_helper.lua <src/theme.yaml> <output.tex>")
    os.exit(1)
  end
  local data = read_yaml(arg[1])
  write_theme_tex(data, arg[2])
end

main()
