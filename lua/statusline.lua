---@alias __statusline_args table Section arguments.
---@alias __statusline_section string Section string.

-- Module definition ==========================================================
local MiniStatusline = {}
local H = {}

--- Module setup
MiniStatusline.setup = function()
  -- Export module
  _G.MiniStatusline = MiniStatusline
  vim.go.statusline =
    "%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.MiniStatusline.active() : v:lua.MiniStatusline.inactive()%}"

  -- Define behavior
  H.create_autocommands()

  -- - Disable built-in statusline in Quickfix window
  vim.g.qf_disable_statusline = 1
end

-- Module functionality =======================================================
--- Compute content for active window
MiniStatusline.active = function()
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  -- local diff = MiniStatusline.section_diff({ trunc_width = 75 })
  local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local filename = MiniStatusline.section_filename({ trunc_width = 140 })
  local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  local location = MiniStatusline.section_location({ trunc_width = 75 })
  local lsp_progress = MiniStatusline.section_lsp_progress({ trunc_width = 75 })

  -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
  -- correct padding with spaces between groups (accounts for 'missing'
  -- sections, etc.)
  return MiniStatusline.combine_groups({
    { hl = mode_hl, strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
    "%<", -- Mark general truncate point
    { hl = "MiniStatuslineFilename", strings = { filename } },
    "%=", -- End left alignment
    { hl = "MiniStatuslineFilename", strings = { lsp_progress } },
    { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
    { hl = mode_hl, strings = { location } },
  })
end

--- Compute content for inactive window
MiniStatusline.inactive = function()
  return "%#MiniStatuslineInactive#%F%="
end

--- Combine groups of sections
---
--- Each group can be either a string or a table with fields `hl` (group's
--- highlight group) and `strings` (strings representing sections).
---
--- General idea of this function is as follows;
--- - String group is used as is (useful for special strings like `%<` or `%=`).
--- - Each table group has own highlighting in `hl` field (if missing, the
---   previous one is used) and string parts in `strings` field. Non-empty
---   strings from `strings` are separated by one space. Non-empty groups are
---   separated by two spaces (one for each highlighting).
---
---@param groups table Array of groups.
---
---@return string String suitable for 'statusline'.
MiniStatusline.combine_groups = function(groups)
  local parts = vim.tbl_map(function(s)
    if type(s) == "string" then
      return s
    end
    if type(s) ~= "table" then
      return ""
    end

    local string_arr = vim.tbl_filter(function(x)
      return type(x) == "string" and x ~= ""
    end, s.strings or {})
    local str = table.concat(string_arr, " ")

    -- Use previous highlight group
    if s.hl == nil then
      return " " .. str .. " "
    end

    -- Allow using this highlight group later
    if str:len() == 0 then
      return "%#" .. s.hl .. "#"
    end

    return string.format("%%#%s# %s ", s.hl, str)
  end, groups)

  return table.concat(parts, "")
end

--- Decide whether to truncate
---
--- This basically computes window width and compares it to `trunc_width`: if
--- window is smaller then truncate; otherwise don't. Don't truncate by
--- default.
---
--- Use this to manually decide if section needs truncation or not.
---
---@param trunc_width number|nil Truncation width. If `nil`, output is `false`.
---
---@return boolean Whether to truncate.
MiniStatusline.is_truncated = function(trunc_width)
  -- Use -1 to default to 'not truncated'
  local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
  return cur_width < (trunc_width or -1)
end

-- Sections ===================================================================
-- Functions should return output text without whitespace on sides.
-- Return empty string to omit section.

--- Section for Vim |mode()|
---
--- Short output is returned if window width is lower than `args.trunc_width`.
---
---@param args __statusline_args
---
---@return ... Section string and mode's highlight group.
MiniStatusline.section_mode = function(args)
  local mode_info = H.modes[vim.fn.mode()]

  local mode = MiniStatusline.is_truncated(args.trunc_width) and mode_info.short or mode_info.long

  return mode, mode_info.hl
end

--- Section for Neovim's builtin diagnostics
---
--- Shows nothing if diagnostics is disabled, no diagnostic is set, or for short
--- output. Otherwise uses |vim.diagnostic.get()| to compute and show number of
--- errors ('E'), warnings ('W'), information ('I'), and hints ('H').
---
--- Short output is returned if window width is lower than `args.trunc_width`.
---
---@param args __statusline_args Use `args.icon` to supply your own icon.
---   Use `args.signs` to use custom signs per severity level name. For example: >lua
---
---     { ERROR = '!', WARN = '?', INFO = '@', HINT = '*' }
--- <
---@return __statusline_section
MiniStatusline.section_diagnostics = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ""
  end

  -- Construct string parts. NOTE: call `diagnostic_is_disabled()` *after*
  -- check for present `count` to not source `vim.diagnostic` on startup.
  local count = H.diagnostic_counts[vim.api.nvim_get_current_buf()]
  if count == nil or H.diagnostic_is_disabled() then
    return ""
  end

  local severity, signs, t = vim.diagnostic.severity, args.signs or {}, {}
  for _, level in ipairs(H.diagnostic_levels) do
    local n = count[severity[level.name]] or 0
    -- Add level info only if diagnostic is present
    if n > 0 then
      table.insert(t, " " .. (signs[level.name] or level.sign) .. n)
    end
  end
  if #t == 0 then
    return ""
  end

  local icon = ""
  return icon .. table.concat(t, "")
end

---@type table<string, string?>
local progress_status = {
  client = nil,
  kind = nil,
  title = nil,
}

local spinner_index = 0
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

---@param args __statusline_args Use `args.icon` to supply your own icon.
MiniStatusline.section_lsp_progress = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ""
  end

  if not progress_status.title or not progress_status.client then
    return ""
  end

  if vim.startswith(vim.api.nvim_get_mode().mode, "i") then
    return ""
  end

  local spin_char = spinner[spinner_index % #spinner + 1]
  spinner_index = spinner_index + 1

  return table.concat({
    string.format("%%#MiniStatuslineSpinner#%s ", spin_char),
    string.format("%%#MiniStatuslineClient#%s  ", progress_status.client),
    string.format("%%#MiniStatuslineTitle#%s...", progress_status.title),
  })
end

--- Section for file name
---
--- Show full file name or relative in short output.
---
--- Short output is returned if window width is lower than `args.trunc_width`.
---
---@param args __statusline_args
---
---@return __statusline_section
MiniStatusline.section_filename = function(args)
  if vim.bo.buftype ~= "" then
    return ""
  end
  return "%f%m%r"
end

--- Section for file information
---
--- Shows 'filetype', 'fileencoding' / 'encoding', 'fileformat', and buffer size.
--- Short output has only non-empty 'filetype' and is returned if window width is
--- lower than `args.trunc_width` or buffer is not normal (as per 'buftype').
---
--- Buffer size is computed based on current text, not file's saved version.
---
--- If `config.use_icons` is true and icon provider is present (see
--- "Dependencies" section in |mini.statusline|), shows icon near the filetype.
---
---@param args __statusline_args
---
---@return __statusline_section
MiniStatusline.section_fileinfo = function(args)
  if vim.bo.buftype ~= "" then
    return ""
  end

  local filetype = vim.bo.filetype
  if MiniIcons ~= nil and filetype ~= "" then
    filetype = MiniIcons.get("filetype", filetype) .. " " .. filetype
  end

  -- Construct output string if truncated or buffer is not normal
  if MiniStatusline.is_truncated(args.trunc_width) then
    return filetype
  end

  -- Construct output string with extra file info
  local encoding = vim.bo.fileencoding or vim.bo.encoding
  local format = vim.bo.fileformat

  return string.format("%s%s%s[%s]", filetype, filetype == "" and "" or " ", encoding, format)
end

--- Section for location inside buffer
---
--- Show location inside buffer in the form:
--- - Normal: `'<cursor line>|<total lines>│<cursor column>|<total columns>'`
--- - Short: `'<cursor line>│<cursor column>'`
---
--- Short output is returned if window width is lower than `args.trunc_width`.
---
---@param args __statusline_args
---
---@return __statusline_section
MiniStatusline.section_location = function(args)
  -- Use virtual column number to allow update when past last column
  if MiniStatusline.is_truncated(args.trunc_width) then
    return "%l│%2v"
  end

  -- Use `virtcol()` to correctly handle multi-byte characters
  return '%l|%L│%2v|%-2{virtcol("$") - 1}'
end

--- Section for current search count
---
--- Show the current status of |searchcount()|. Empty output is returned if
--- window width is lower than `args.trunc_width`, search highlighting is not
--- on (see |v:hlsearch|), or if number of search result is 0.
---
--- `args.options` is forwarded to |searchcount()|. By default it recomputes
--- data on every call which can be computationally expensive (although still
--- usually on 0.1 ms order of magnitude). To prevent this, supply
--- `args.options = { recompute = false }`.
---
---@param args __statusline_args
---
---@return __statusline_section
MiniStatusline.section_searchcount = function(args)
  if vim.v.hlsearch == 0 or MiniStatusline.is_truncated(args.trunc_width) then
    return ""
  end
  -- `searchcount()` can return errors because it is evaluated very often in
  -- statusline. For example, when typing `/` followed by `\(`, it gives E54.
  local ok, s_count = pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
  if not ok or s_count.current == nil or s_count.total == 0 then
    return ""
  end

  if s_count.incomplete == 1 then
    return "?/?"
  end

  local too_many = ">" .. s_count.maxcount
  local current = s_count.current > s_count.maxcount and too_many or s_count.current
  local total = s_count.total > s_count.maxcount and too_many or s_count.total
  return current .. "/" .. total
end

-- Showed diagnostic levels
H.diagnostic_levels = {
  { name = "ERROR", sign = "E" },
  { name = "WARN", sign = "W" },
  { name = "INFO", sign = "I" },
  { name = "HINT", sign = "H" },
}

-- Diagnostic counts per buffer id
H.diagnostic_counts = {}

H.create_autocommands = function()
  local gr = vim.api.nvim_create_augroup("MiniStatusline", {})

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
  end

  -- Use `schedule_wrap()` because `redrawstatus` might error on `:bwipeout`
  -- See: https://github.com/neovim/neovim/issues/32349
  local track_diagnostics = vim.schedule_wrap(function(data)
    H.diagnostic_counts[data.buf] = vim.api.nvim_buf_is_valid(data.buf) and H.get_diagnostic_count(data.buf) or nil
    vim.cmd("redrawstatus")
  end)
  au("DiagnosticChanged", "*", track_diagnostics, "Track diagnostics")

  au("LspProgress", { "begin", "end" }, function(args)
    if not args.data then
      return
    end

    local kind = args.data.params.value.kind

    if kind == "end" then
      progress_status.title = nil
      spinner_index = 0
      vim.defer_fn(function()
        vim.cmd.redrawstatus()
      end, 500)
    else
      progress_status = {
        client = vim.lsp.get_client_by_id(args.data.client_id).name,
        kind = kind,
        title = args.data.params.value.title,
      }
      vim.cmd.redrawstatus()
    end
  end, "Update LSP progress in statusline")
end

-- Mode -----------------------------------------------------------------------
-- Custom `^V` and `^S` symbols to make this file appropriate for copy-paste
-- (otherwise those symbols are not displayed).
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

-- stylua: ignore start
H.modes = setmetatable({
  ['n']    = { long = 'Normal',   short = 'N',   hl = 'MiniStatuslineModeNormal' },
  ['v']    = { long = 'Visual',   short = 'V',   hl = 'MiniStatuslineModeVisual' },
  ['V']    = { long = 'V-Line',   short = 'V-L', hl = 'MiniStatuslineModeVisual' },
  [CTRL_V] = { long = 'V-Block',  short = 'V-B', hl = 'MiniStatuslineModeVisual' },
  ['s']    = { long = 'Select',   short = 'S',   hl = 'MiniStatuslineModeVisual' },
  ['S']    = { long = 'S-Line',   short = 'S-L', hl = 'MiniStatuslineModeVisual' },
  [CTRL_S] = { long = 'S-Block',  short = 'S-B', hl = 'MiniStatuslineModeVisual' },
  ['i']    = { long = 'Insert',   short = 'I',   hl = 'MiniStatuslineModeInsert' },
  ['R']    = { long = 'Replace',  short = 'R',   hl = 'MiniStatuslineModeReplace' },
  ['c']    = { long = 'Command',  short = 'C',   hl = 'MiniStatuslineModeCommand' },
  ['r']    = { long = 'Prompt',   short = 'P',   hl = 'MiniStatuslineModeOther' },
  ['!']    = { long = 'Shell',    short = 'Sh',  hl = 'MiniStatuslineModeOther' },
  ['t']    = { long = 'Terminal', short = 'T',   hl = 'MiniStatuslineModeOther' },
}, {
  -- By default return 'Unknown' but this shouldn't be needed
  __index = function()
    return   { long = 'Unknown',  short = 'U',   hl = '%#MiniStatuslineModeOther#' }
  end,
})
-- stylua: ignore end

-- Diagnostics ----------------------------------------------------------------
H.get_diagnostic_count = function(buf_id)
  return vim.diagnostic.count(buf_id)
end

H.diagnostic_is_disabled = function()
  return not vim.diagnostic.is_enabled({ bufnr = 0 })
end

-- Utilities ------------------------------------------------------------------
H.error = function(msg)
  error("(mini.statusline) " .. msg, 0)
end

H.get_filesize = function()
  local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
  if size < 1024 then
    return string.format("%dB", size)
  elseif size < 1048576 then
    return string.format("%.2fKiB", size / 1024)
  else
    return string.format("%.2fMiB", size / 1048576)
  end
end

return MiniStatusline
