local M = {}
local current_colors_name = nil

M.get_theme_val = function(colors_name, type)
  local theme = require("base46.themes." .. colors_name)
  return theme[type]
end

local function apply_hue_theme(colors_name)
  local config = M.get_theme_val(colors_name, "config")
  require("base46.hue").setup(config)
  return config.background
end

local function apply_hue_pattle_theme(colors_name)
  local pattle = require("base46.themes." .. colors_name)
  require("base46.hue").apply_palette(pattle)
  return pattle.bg
end

M.setup = function(colors_name)
  vim.cmd("highlight clear")

  vim.g.colors_name = nil
  current_colors_name = colors_name

  local bg
  if string.find(colors_name, "mini-p", 1, true) ~= nil then
    bg = apply_hue_pattle_theme(colors_name)
  else
    vim.o.background = M.get_theme_val(colors_name, "type")
    bg = apply_hue_theme(colors_name)
  end

  vim.schedule(function()
    local osc11_sequence = string.format("\027]11;%s\007", bg)
    io.write(osc11_sequence)
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("AniaanResetColor", { clear = true }),
    callback = function() io.write("\027]111\027\\") end,
  })

  vim.api.nvim_exec_autocmds("ColorScheme", {
    pattern = "*",
  })
end

local function preview_theme(colors_name) M.setup(colors_name) end

M.pick_theme = function()
  local themes = {}
  local theme_files = vim.fn.stdpath("config") .. "/lua/base46/themes"

  for _, file in ipairs(vim.fn.readdir(theme_files)) do
    local theme = vim.fn.fnamemodify(file, ":r")
    if theme then table.insert(themes, { text = theme, file = theme }) end
  end

  for i, theme in ipairs(themes) do
    if theme.text == current_colors_name then
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
      if selected then vim.schedule(function() preview_theme(selected) end) end
    end,
  })
end

return M
