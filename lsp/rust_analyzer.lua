---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allTargets = false,
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },
      diagnostics = {
        -- enable = true,
        -- experimental = {
        --   enable = true,
        -- },
        disabled = { "proc-macro-disabled" },
      },
      checkOnSave = false,
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
      check = {
        -- command = "clippy",
        workspace = false,
        ignore = { "dead_code", "unused_macros" },
      },
      files = {
        excludeDirs = {
          ".direnv",
          ".git",
          ".github",
          ".gitlab",
          "bin",
          "node_modules",
          "target",
          "venv",
          ".venv",
          "__pycache__",
        },
      },
    },
  },
}
