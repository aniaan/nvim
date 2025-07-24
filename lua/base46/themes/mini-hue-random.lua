local hues = require("base46.hue")

local M = setmetatable({}, {
  __index = function(M, k)
    if type(k) ~= "string" then
      return
    end
    if k == "type" then
      return vim.o.background
    end

    if k == "config" then
      math.randomseed(vim.loop.hrtime())
      local base_colors = hues.gen_random_base_colors()

      return {
        background = base_colors.background,
        foreground = base_colors.foreground,
        n_hues = 8,
        saturation = vim.o.background == "dark" and "medium" or "high",
        accent = "bg",
      }
    end
  end,
})

return M
