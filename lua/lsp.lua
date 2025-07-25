local diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

-- Diagnostic configuration.
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
      [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
      [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
    },
  },
})

local methods = vim.lsp.protocol.Methods

local M = {}

M.keys = {
  {
    lhs = "gd",
    rhs = function()
      Snacks.picker.lsp_definitions()
    end,
    opts = { desc = "Goto Definition" },
  },
  {
    lhs = "gr",
    rhs = function()
      Snacks.picker.lsp_references()
    end,
    opts = { desc = "References", nowait = true },
  },
  {
    lhs = "gI",
    rhs = function()
      Snacks.picker.lsp_implementations()
    end,

    opts = { desc = "Goto Implementation" },
  },
  {
    lhs = "gy",
    rhs = function()
      Snacks.picker.lsp_type_definitions()
    end,
    opts = { desc = "Goto T[y]pe Definition" },
  },
  {
    lhs = "gD",
    rhs = vim.lsp.buf.declaration,
    opts = { desc = "Goto Declaration" },
  },
  {
    lhs = "K",
    rhs = function()
      return vim.lsp.buf.hover()
    end,
    opts = { desc = "Hover" },
  },
  {
    lhs = "gK",
    rhs = function()
      return vim.lsp.buf.signature_help()
    end,
    opts = { desc = "Signature Help" },
  },
  {
    lhs = "<c-k>",
    rhs = function()
      return vim.lsp.buf.signature_help()
    end,
    mode = "i",
    opts = { desc = "Signature Help" },
  },
  {
    lhs = "<leader>ca",
    rhs = vim.lsp.buf.code_action,
    mode = { "n", "v" },
    opts = { desc = "Code Action" },
  },
  {
    lhs = "<leader>cr",
    rhs = vim.lsp.buf.rename,
    opts = { desc = "Rename" },
  },
  {
    lhs = "<leader>cR",
    rhs = function()
      Snacks.rename.rename_file()
    end,
    opts = { desc = "Rename File" },
  },
}

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, mode, opts)
    mode = mode or "n"
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  ---@param method string
  local function has(method)
    if client:supports_method(method) then
      return true
    end
    return false
  end

  for _, keys in pairs(M.keys) do
    if not keys.has or has(keys.has) then
      local opts = vim.tbl_extend("force", {}, keys.opts or {})
      opts.silent = opts.silent ~= false
      opts.buffer = bufnr

      keymap(keys.lhs, keys.rhs, keys.mode, opts)
    end
  end

  if has(methods.textDocument_inlayHint) then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- Update mappings when registering dynamic capabilities.
-- local register_capability = vim.lsp.handlers[methods.client_registerCapability]
-- vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
--   local client = vim.lsp.get_client_by_id(ctx.client_id)
--   if not client then
--     return
--   end
--
--   on_attach(client, vim.api.nvim_get_current_buf())
--
--   return register_capability(err, res, ctx)
-- end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    local server_configs = vim
      .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ":t:r")
      end)
      :totable()
    vim.lsp.enable(server_configs)
  end,
})

return M
