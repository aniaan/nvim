local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "fish",
  "gitcommit",
  "html",
  "javascript",
  "json",
  "json5",
  "jsonc",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "rust",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "sql",
}

local function setup_treesitter_move()
  local move = require("nvim-treesitter-textobjects.move")

  local moves = {
    { key = "]f", func = move.goto_next_start, target = "@function.outer", desc = "Next function start" },
    { key = "]c", func = move.goto_next_start, target = "@class.outer", desc = "Next class start" },
    { key = "]a", func = move.goto_next_start, target = "@parameter.inner", desc = "Next parameter start" },

    { key = "[f", func = move.goto_previous_start, target = "@function.outer", desc = "Previous function start" },
    { key = "[c", func = move.goto_previous_start, target = "@class.outer", desc = "Previous class start" },
    { key = "[a", func = move.goto_previous_start, target = "@parameter.inner", desc = "Previous parameter start" },
  }

  for _, config in ipairs(moves) do
    vim.keymap.set({ "n", "x", "o" }, config.key, function()
      config.func(config.target, "textobjects")
    end, { desc = config.desc })
  end
end

local function register_filetypes()
  vim.filetype.add({
    pattern = {
      [".*/waybar/config"] = "jsonc",
      [".*/kitty/.+%.conf"] = "kitty",
      [".*/ghostty/config"] = "ghostty",
      ["%.env%.[%w_.-]+"] = "sh",
    },
  })
  vim.treesitter.language.register("bash", "kitty")
  vim.treesitter.language.register("bash", "ghostty")
end

local function install()
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })
end

return {
  {
    require("consts").TREESITTER,
    branch = "main",
    dependencies = {
      { require("consts").TREESITTER_OBJECTS, branch = "main" },
    },
    build = ":TSUpdate",
    opts = {},
    config = function(_)
      register_filetypes()
      install()
      setup_treesitter_move()
    end,
  },
}
