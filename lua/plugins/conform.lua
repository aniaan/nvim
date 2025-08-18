return {
  {
    require("consts").CONFORM,
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ bufnr = vim.api.nvim_get_current_buf() }) end,
        desc = "Format",
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        toml = { "taplo" },
        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },
        -- For filetypes without a formatter:
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
