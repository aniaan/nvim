local M = {}
function M.cowboy()
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert(vim.uv.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then count = 0 end
      if count >= 10 and vim.bo.buftype ~= "nofile" then
        ok = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          id = "cowboy",
          keep = function() return count >= 10 end,
        })
        if not ok then return map end
      else
        count = count + 1
        timer:start(2000, 0, function() count = 0 end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

local function make_flycheck_params() return { textDocument = vim.lsp.util.make_text_document_params() } end

---@param cmd 'run' | 'clear' | 'cancel'
function M.rust_flycheck(cmd)
  local params = cmd == "run" and make_flycheck_params() or nil
  local method = "rust-analyzer/" .. cmd .. "Flycheck"
  -- get_active_clients
  local filter = {
    name = "rust_analyzer",
    method = method,
    bufnr = 0,
  }

  local clients = vim.lsp.get_clients(filter)
  if #clients == 0 then
    vim.notify("No rust-analyzer client found")
    return
  end

  for _, client in ipairs(clients) do
    client:notify(method, params)
  end
end

---@param visual boolean? When true, use the last visual selection range
function M.copy_line_permalink(visual)
  local path = vim.fn.expand("%:.")
  if path == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end
  local link
  if visual then
    -- Use "v" / "." instead of '< / '> because the visual marks are only
    -- written when leaving visual mode, so on the first invocation they
    -- still hold the previous (or empty) selection.
    local a, b = vim.fn.line("v"), vim.fn.line(".")
    local s, e = math.min(a, b), math.max(a, b)
    link = s == e and string.format("%s#L%d", path, s) or string.format("%s#L%d-L%d", path, s, e)
  else
    link = string.format("%s#L%d", path, vim.fn.line("."))
  end
  vim.fn.setreg("+", link)
  vim.notify("Copied: " .. link)
end

return M
