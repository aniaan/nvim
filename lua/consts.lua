local M = {}

-- plugin
M.LAZY_NVIM_URL = "https://github.com/folke/lazy.nvim.git"
M.BLINK_CMP = "saghen/blink.cmp"
M.CONFORM = "stevearc/conform.nvim"

local folke = "folke/"
M.FLASH = folke .. "flash.nvim"
M.SNACKS = folke .. "snacks.nvim"
M.WHICH_KEY = folke .. "which-key.nvim"
M.LAZYDEV = folke .. "lazydev.nvim"
M.SIDE_KICK = folke .. "sidekick.nvim"

local treesitter = "nvim-treesitter/"
M.TREESITTER = treesitter .. "nvim-treesitter"
M.TREESITTER_OBJECTS = treesitter .. "nvim-treesitter-textobjects"

M.MARKDOWN = "MeanderingProgrammer/render-markdown.nvim"

local mini = "nvim-mini/"
M.MINI_AI = mini .. "mini.ai"
M.MINI_DIFF = mini .. "mini.diff"
M.MINI_ICONS = mini .. "mini.icons"
M.MINI_PAIRS = mini .. "mini.pairs"

return M
