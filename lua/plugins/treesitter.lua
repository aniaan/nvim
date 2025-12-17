local ensure_installed = {
  "kitty",
  "bash",
  "c",
  "cpp",
  "fish",
  "gitcommit",
  "html",
  "javascript",
  "json",
  "json5",
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
    -- { key = "[c", func = move.goto_previous_start, target = "@class.outer", desc = "Previous class start" },
    { key = "[a", func = move.goto_previous_start, target = "@parameter.inner", desc = "Previous parameter start" },
  }

  for _, config in ipairs(moves) do
    vim.keymap.set(
      { "n", "x", "o" },
      config.key,
      function() config.func(config.target, "textobjects") end,
      { desc = config.desc }
    )
  end
end

local function install()
  vim.schedule(function() require("nvim-treesitter").install(ensure_installed) end)
  local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
  })
end

return {
  {
    require("consts").TREESITTER,
    branch = "main",
    dependencies = {
      { require("consts").TREESITTER_OBJECTS, branch = "main" },
      {
        require("consts").TREESITTER_CONTEXT,
        opts = {
          max_lines = 3,
          multiline_threshold = 1,
          min_window_height = 20,
        },
        keys = {
          {
            "[c",
            function()
              vim.schedule(function() require("treesitter-context").go_to_context() end)
              return "<Ignore>"
            end,
            desc = "Jump to upper context",
            expr = true,
          },
        },
      },
    },
    build = ":TSUpdate",
    opts = {},
    config = function(_)
      install()
      setup_treesitter_move()
    end,
  },
}
