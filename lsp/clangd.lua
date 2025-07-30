---@type vim.lsp.Config
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--fallback-style=llvm",
    "--function-arg-placeholders=false",
  },
  filetypes = { "c", "cpp" },
  root_markers = { ".clangd" },
}
