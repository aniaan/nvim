local M = {}

function M.get()
  local current_file = vim.fn.expand("%:p")
  local project_root = vim.fn.getcwd()
  local display_path

  if vim.startswith(current_file, project_root) then
    display_path = vim.fn.fnamemodify(current_file, ":.")
  else
    local home = vim.env.HOME
    display_path = current_file
    if vim.startswith(current_file, home) then display_path = "~" .. current_file:sub(#home + 1) end
  end

  -- For narrow windows, shorten path but still split into components
  if vim.api.nvim_win_get_width(0) < math.floor(vim.o.columns / 3) then
    display_path = vim.fn.pathshorten(display_path)
  end

  -- Split path into individual components
  local parts = vim.split(display_path, "/", { trimempty = true })

  -- Get icon with its highlight group
  local filename = parts[#parts]
  local icon, highlight = MiniIcons.get("file", filename)

  local result = {}

  -- Add directories with WinBarDir highlight
  for i = 1, #parts - 1 do
    table.insert(result, string.format("%%#WinBarDir#%s", parts[i]))
    table.insert(result, "%#WinBarSeparator# > ")
  end

  -- Add icon with its own highlight + filename with Winbar highlight
  table.insert(result, string.format("%%#%s#%s %%#Winbar#%s", highlight, icon, filename))

  return table.concat(result)
end

return M
