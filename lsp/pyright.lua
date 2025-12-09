local function get_python_path(root_dir)
  -- Prefer already activated virtual environment
  local venv = vim.env.VIRTUAL_ENV
  if venv then return vim.fs.joinpath(venv, "bin", "python") end

  -- Check for virtual environments in the project directory
  for _, name in ipairs({ ".venv", "venv" }) do
    local path = vim.fs.joinpath(root_dir, name, "bin", "python")
    if vim.uv.fs_stat(path) then return path end
  end

  -- Fallback to system Python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "pyrightconfig.json",
    ".git",
  },
  before_init = function(_, config)
    local python_path = get_python_path(config.root_dir)
    config.settings.python.pythonPath = python_path
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}

