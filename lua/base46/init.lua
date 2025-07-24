local M = {}

M.get_theme_tb = function(type)
  local name = vim.g.aniaan_theme
  local present1, default_theme = pcall(require, "base46.themes." .. name)

  if present1 then
    return default_theme[type]
  else
    error("No such theme: " .. name)
  end
end

local function apply_hue_theme()
  local config = M.get_theme_tb("config")
  require("base46.hue").setup(config)
  return config.background
end

local function apply_hue_pattle_theme()
  local name = vim.g.aniaan_theme
  local pattle = require("base46.themes." .. name)
  require("base46.hue").apply_palette(pattle)
  return pattle.bg
end

M.setup = function(colors_name)
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = nil
  vim.g.aniaan_theme = colors_name
  vim.o.termguicolors = true

  local bg
  if string.find(colors_name, "mini-p", 1, true) ~= nil then
    bg = apply_hue_pattle_theme()
  else
    vim.o.background = M.get_theme_tb("type")
    bg = apply_hue_theme()
  end

  vim.schedule(function()
    local osc11_sequence = string.format("\027]11;%s\007", bg)
    io.write(osc11_sequence)
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("AniaanResetColor", { clear = true }),
    callback = function()
      io.write("\027]111\027\\")
    end,
  })

  vim.api.nvim_exec_autocmds("ColorScheme", {
    pattern = "*",
  })
end

local function preview_theme(colors_name)
  M.setup(colors_name)
end

M.pick_theme = function()
  local current_theme = vim.g.aniaan_theme
  local themes = {}
  local theme_files = vim.fn.stdpath("config") .. "/lua/base46/themes"

  for _, file in ipairs(vim.fn.readdir(theme_files)) do
    local theme = vim.fn.fnamemodify(file, ":r")
    if theme then
      table.insert(themes, { text = theme, file = theme })
    end
  end

  for i, theme in ipairs(themes) do
    if theme.text == current_theme then
      table.remove(themes, i)
      table.insert(themes, 1, theme)
      break
    end
  end

  Snacks.picker.pick({
    source = "themes",
    items = themes,
    format = "text",
    layout = require("utils.picker").normal_layout.layout,
    confirm = function(picker, item)
      picker:close()
      local selected = item.text
      if selected then
        vim.schedule(function()
          preview_theme(selected)
        end)
      end
    end,
  })
end

return M
