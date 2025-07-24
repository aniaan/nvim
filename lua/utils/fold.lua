local M = {}

function M.foldexpr()
  if vim.b.ts_folds == nil then
    if vim.bo.filetype == "" or vim.bo.filetype == "bigfile" or vim.bo.filetype:find("dashboard") then
      vim.b.ts_folds = false
      return "0"
    end
    vim.b.ts_folds = pcall(vim.treesitter.get_parser)
  end
  return vim.b.ts_folds and vim.treesitter.foldexpr() or "0"
end

return M
