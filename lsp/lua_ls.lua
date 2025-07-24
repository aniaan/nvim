---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml" },
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim",
          "Snacks",
          "MiniIcons"
        },
      },
      runtime = {
        version = "LuaJIT",
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
