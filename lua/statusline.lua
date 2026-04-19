---@alias __statusline_args table Section arguments.
---@alias __statusline_section string Section string.

local MiniStatusline = {}
local H = {}
local icons = require("icons")

MiniStatusline.setup = function()
  _G.MiniStatusline = MiniStatusline
  vim.go.statusline = "%!v:lua.MiniStatusline.active()"

  H.create_autocommands()
  vim.g.qf_disable_statusline = 1
end

-- Layout =====================================================================
-- [MODE]  git_block  ✢          [LSP]   ✗N ▲N ●N ●N   ft   [L|T│C|M]
-- (Path is shown in the winbar, not here — see lua/winbar.lua.)
MiniStatusline.active = function()
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  local git           = MiniStatusline.section_git({ trunc_width = 75 })
  local modified      = vim.bo.modified and "✢" or ""
  local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local filetype      = MiniStatusline.section_filetype({ trunc_width = 75 })
  local lsp_progress, lsp_hl = MiniStatusline.section_lsp_progress({ trunc_width = 75 })
  local location      = MiniStatusline.section_location({ trunc_width = 75 })

  -- Wrap filetype with its own hl so we can put it in the same group as
  -- diagnostics — that way the gap between them is one space (intra-group)
  -- instead of two (inter-group).
  local filetype_part = filetype ~= "" and H.with_hl("MiniStatuslineFiletype", filetype) or ""

  return MiniStatusline.combine_groups({
    { hl = mode_hl,                  strings = { mode } },
    { hl = "MiniStatuslineDevinfo",  strings = { git } },
    { hl = "MiniStatuslineModified", strings = { modified } },
    "%<", -- truncate point
    "%=", -- right align
    -- LSP first in the right group: when its width fluctuates it only pushes
    -- itself left, leaving the stable `diags / ft / location` trio anchored
    -- right. Anywhere else and the flicker would jitter the stable elements.
    { hl = lsp_hl,                   strings = { lsp_progress } },
    { hl = "MiniStatuslineDevinfo",  strings = { diagnostics, filetype_part } },
    { hl = mode_hl,                  strings = { location } },
  })
end

MiniStatusline.combine_groups = function(groups)
  local parts = vim.tbl_map(function(s)
    if type(s) == "string" then return s end
    if type(s) ~= "table" then return "" end

    local string_arr = vim.tbl_filter(function(x) return type(x) == "string" and x ~= "" end, s.strings or {})
    local str = table.concat(string_arr, " ")

    if s.hl == nil then return " " .. str .. " " end
    if str:len() == 0 then return "%#" .. s.hl .. "#" end

    return string.format("%%#%s# %s ", s.hl, str)
  end, groups)

  return table.concat(parts, "")
end

MiniStatusline.is_truncated = function(trunc_width)
  local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
  return cur_width < (trunc_width or -1)
end

-- Sections ===================================================================
MiniStatusline.section_mode = function(args)
  local mode_info = H.modes[vim.fn.mode()]
  local mode = MiniStatusline.is_truncated(args.trunc_width) and mode_info.short or mode_info.long
  return mode, mode_info.hl
end

-- Original git block: branch glyph + name immediately followed by glyph+count
-- per non-zero diff bucket, no separator between buckets.
MiniStatusline.section_git = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  if not vim.b.gitsigns_head then return "" end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0)
      and H.with_hl("MiniStatuslineGitAdd", "  " .. git_status.added)
    or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and H.with_hl("MiniStatuslineGitChange", "  " .. git_status.changed)
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and H.with_hl("MiniStatuslineGitDelete", "  " .. git_status.removed)
    or ""
  local branch_name = H.with_hl("MiniStatuslineGitBranch", " " .. git_status.head)

  return branch_name .. added .. changed .. removed
end

-- Always render all four severities (even at zero) so column positions stay
-- stable — the eye finds counts faster when icons don't shift around.
MiniStatusline.section_diagnostics = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  local count = H.diagnostic_counts[vim.api.nvim_get_current_buf()] or {}
  if H.diagnostic_is_disabled() then return "" end

  local severity = vim.diagnostic.severity
  local t = {}
  for _, level in ipairs(H.diagnostic_levels) do
    local n = count[severity[level.name]] or 0
    table.insert(t, H.with_hl(level.hl, level.icon .. " " .. n))
  end
  return table.concat(t, " ")
end

MiniStatusline.section_filetype = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  return vim.bo.filetype or ""
end

local lsp_msg = ""
local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥", "" }

---@param args __statusline_args
MiniStatusline.section_lsp_progress = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "", nil end
  if lsp_msg == "" then return "", nil end
  if vim.startswith(vim.api.nvim_get_mode().mode, "i") then return "", nil end
  return lsp_msg, "MiniStatuslineLsp"
end

MiniStatusline.section_location = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "%l" end
  return '%l|%L'
end

-- Internals ==================================================================
H.diagnostic_levels = {
  { name = "ERROR", icon = icons.diagnostics.ERROR, hl = "MiniStatuslineDiagError" },
  { name = "WARN",  icon = icons.diagnostics.WARN,  hl = "MiniStatuslineDiagWarn"  },
  { name = "INFO",  icon = icons.diagnostics.INFO,  hl = "MiniStatuslineDiagInfo"  },
  { name = "HINT",  icon = icons.diagnostics.HINT,  hl = "MiniStatuslineDiagHint"  },
}

H.diagnostic_counts = {}

H.create_autocommands = function()
  local gr = vim.api.nvim_create_augroup("MiniStatusline", {})

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
  end

  -- schedule_wrap because redrawstatus errors on :bwipeout (neovim/neovim#32349)
  local track_diagnostics = vim.schedule_wrap(function(data)
    H.diagnostic_counts[data.buf] = vim.api.nvim_buf_is_valid(data.buf) and H.get_diagnostic_count(data.buf) or nil
    vim.cmd("redrawstatus")
  end)
  au("DiagnosticChanged", "*", track_diagnostics, "Track diagnostics")

  local track_lsp_progress = vim.schedule_wrap(function(args)
    if not args.data then return end

    local data = args.data.params.value
    local kind = data.kind
    if kind == "end" then
      lsp_msg = ""
      vim.defer_fn(function() vim.cmd.redrawstatus() end, 500)
    else
      local percentage = data.percentage or 100
      local idx = math.max(1, math.floor(percentage / 10))
      lsp_msg = spinners[idx] .. " " .. percentage .. "%% " .. data.title
      vim.cmd.redrawstatus()
    end
  end)
  au("LspProgress", { "begin", "report", "end" }, track_lsp_progress, "Track LSP progress")
end

local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

-- stylua: ignore start
H.modes = setmetatable({
  ['n']    = { long = 'NORMAL',   short = 'N',   hl = 'MiniStatuslineModeNormal' },
  ['v']    = { long = 'VISUAL',   short = 'V',   hl = 'MiniStatuslineModeVisual' },
  ['V']    = { long = 'V-LINE',   short = 'V-L', hl = 'MiniStatuslineModeVisual' },
  [CTRL_V] = { long = 'V-BLOCK',  short = 'V-B', hl = 'MiniStatuslineModeVisual' },
  ['s']    = { long = 'SELECT',   short = 'S',   hl = 'MiniStatuslineModeVisual' },
  ['S']    = { long = 'S-LINE',   short = 'S-L', hl = 'MiniStatuslineModeVisual' },
  [CTRL_S] = { long = 'S-BLOCK',  short = 'S-B', hl = 'MiniStatuslineModeVisual' },
  ['i']    = { long = 'INSERT',   short = 'I',   hl = 'MiniStatuslineModeInsert' },
  ['R']    = { long = 'REPLACE',  short = 'R',   hl = 'MiniStatuslineModeReplace' },
  ['c']    = { long = 'COMMAND',  short = 'C',   hl = 'MiniStatuslineModeCommand' },
  ['r']    = { long = 'PROMPT',   short = 'P',   hl = 'MiniStatuslineModeOther' },
  ['!']    = { long = 'SHELL',    short = 'Sh',  hl = 'MiniStatuslineModeOther' },
  ['t']    = { long = 'TERMINAL', short = 'T',   hl = 'MiniStatuslineModeOther' },
}, {
  __index = function()
    return   { long = 'UNKNOWN',  short = 'U',   hl = '%#MiniStatuslineModeOther#' }
  end,
})
-- stylua: ignore end

H.get_diagnostic_count = function(buf_id) return vim.diagnostic.count(buf_id) end
H.diagnostic_is_disabled = function() return not vim.diagnostic.is_enabled({ bufnr = 0 }) end

H.with_hl = function(hl_group, text) return "%#" .. hl_group .. "#" .. text .. "%#MiniStatuslineDevinfo#" end

return MiniStatusline
