-- stylua: ignore start
-- ============================================================================
-- Leader key configuration
-- ============================================================================
vim.g.mapleader = " "      -- Set main leader key to space
vim.g.maplocalleader = " " -- Set local leader key to space
vim.g.snacks_animate = false

-- ============================================================================
-- Performance optimization - disable unnecessary providers
-- ============================================================================
vim.g.loaded_python3_provider = 0  -- Disable Python3 provider to improve startup speed
vim.g.loaded_perl_provider = 0     -- Disable Perl provider
vim.g.loaded_ruby_provider = 0     -- Disable Ruby provider
vim.g.loaded_node_provider = 0     -- Disable Node.js provider

vim.g.copilot_enabled = true       -- Enable GitHub Copilot

local opt = vim.o

-- ============================================================================
-- Basic editor settings
-- ============================================================================
opt.termguicolors = true              -- Enable true color support for richer, more accurate colors
opt.mouse = "a"                       -- Enable mouse support in all modes
opt.mousescroll = "ver:3,hor:0"       -- Mouse scroll settings: 3 lines vertical, disable horizontal
opt.swapfile = false                  -- Disable swap files
opt.undofile = true                   -- Enable persistent undo, survives restarts
opt.cursorline = true                 -- Highlight current line
opt.wrap = true                      -- Disable line wrapping
opt.clipboard = "unnamedplus"         -- Sync with system clipboard (non-SSH environments)

-- ============================================================================
-- Indentation and tab settings
-- ============================================================================
opt.sw = 2              -- Use 2 spaces for auto-indentation (shiftwidth)
opt.ts = 2              -- Display tab as 2 spaces width (tabstop)
opt.et = true           -- Convert tabs to spaces (expandtab)
opt.smartindent = true  -- Smart indentation based on syntax
opt.shiftround = true   -- Round indentation to multiples of shiftwidth

-- ============================================================================
-- Display and interface settings
-- ============================================================================
opt.list = true                                -- Show invisible characters (spaces, tabs, etc.)
opt.listchars = "tab:» ,trail:·,nbsp:·"      -- Set display style for invisible characters
opt.signcolumn = "number"                     -- Merge sign column with number column
opt.linebreak = true                          -- Break lines at word boundaries, don't split words
opt.number = true                             -- Show line numbers
-- opt.relativenumber = false                 -- Show relative line numbers
opt.cmdheight = 0                             -- Command line height 0 (minimal mode)
opt.laststatus = 3                            -- Global statusline
opt.confirm = true                            -- Confirm before unsaved changes
opt.ruler = false                             -- Disable default ruler
opt.showmode = false                          -- Don't show mode (statusline shows it)
opt.showtabline = 0                           -- Never show tabline


-- Fill character settings

opt.fillchars = table.concat(
  { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)

-- Window settings
opt.splitbelow = true                 -- Open new windows below current window
opt.splitright = true                -- Open new windows to the right of current window
opt.splitkeep = "screen"              -- Keep screen position when splitting
opt.winminwidth = 5                   -- Minimum window width

-- ============================================================================
-- Cursor and scrolling settings
-- ============================================================================
opt.guicursor =                     -- Cursor style settings, disable blinking
  "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:ver25-Cursor"

opt.smoothscroll = true             -- Enable smooth scrolling

-- ============================================================================
-- Folding settings
-- ============================================================================
opt.foldlevelstart = 99    -- Expand all folds when opening files
opt.foldtext = ""          -- Use default fold text

-- ============================================================================
-- Search settings
-- ============================================================================
opt.ignorecase = true        -- Ignore case when searching
opt.smartcase = true         -- Override ignorecase if search contains uppercase letters

-- ============================================================================
-- Timing and responsiveness settings
-- ============================================================================
opt.updatetime = 300      -- Time to save swap file and trigger CursorHold (milliseconds)
opt.timeoutlen = 500      -- Time to wait for key sequence completion
opt.ttimeoutlen = 10      -- Time to wait for terminal key codes (milliseconds)

-- ============================================================================
-- Completion and popup menu settings
-- ============================================================================
opt.completeopt = "menuone,noselect,fuzzy,nosort"
opt.pumheight = 10                          -- Maximum popup menu height (10 items)
opt.pumblend = 10                           -- Popup menu transparency (0-100)

-- ============================================================================
-- Advanced editing features
-- ============================================================================
-- opt.virtualedit = "block"                     -- Allow cursor beyond line end in visual block mode
-- opt.diffopt:append("vertical,context:99")   -- Diff mode: vertical split, show extensive context
-- opt.formatoptions = "jcroqlnt"              -- Text formatting options
-- opt.jumpoptions = "view"                    -- Jump options
-- opt.spelllang = { "en" }                    -- Spell check language


-- ============================================================================
-- Messages and notifications settings
-- ============================================================================
-- shortmess options explanation:
-- a: Enable all abbreviations (l+m+r+w) - "999L,888B", "[+]", "[RO]", "[w]"
-- o: Overwrite file-read message with file-write message (reduce :wn and autowrite duplicates)
-- O: File-read message overwrites previous message (reduce message accumulation)
-- s: Don't show search hit bottom/top messages
-- t: Truncate too long file messages
-- T: Truncate too long other messages
-- W: Don't show file write messages "[w]" and "[a]"
-- I: Don't show intro message on startup
-- c: Don't show completion menu messages
-- C: Don't show messages while scanning for completions ("scanning tags")
-- F: Don't show file info (like line count when saving)
-- S: Don't show search count messages ("[1/5]")
opt.shortmess = "aoOstTWIcCFS"

-- stylua: ignore end

-- ============================================================================
-- SSH environment clipboard support
-- ============================================================================
-- Define paste function for SSH environments
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

-- If in SSH environment, use OSC52 protocol for clipboard synchronization
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

