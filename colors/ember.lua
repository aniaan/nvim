-- ember.lua - A warm, low-saturation light Neovim colorscheme
-- Place at ~/.config/nvim/colors/ember.lua
-- Then `:colorscheme ember` or add `vim.cmd.colorscheme('ember')` to init.lua
--
-- Light-only. Inspired by paper, embers and dusk.
-- No italic. Bold is applied sparingly, matching hue.lua's conventions:
-- only `return`, `import`/`use`/`from`, `const`/`let`/`var`, debug and
-- directive keywords — plus legacy Statement family for non-Treesitter
-- buffers. Function names, decorators, control flow (if/for/while/try),
-- and types all stay regular weight; color alone separates them.
--
-- Covers: Treesitter, LSP/diagnostics, Gitsigns (full), Telescope,
-- which-key, snacks.nvim (incl. picker), flash.nvim (full), blink.cmp,
-- nvim-cmp, NvimTree/Neo-tree, Lualine, mini.* (clue/diff/hipatterns/icons/
-- statusline/surround), lazy.nvim, mason.nvim, noice.nvim, trouble.nvim,
-- render-markdown.nvim, treesitter-context, bufferline, indent-blankline,
-- dap / dap-ui, todo-comments, gitcommit/fugitive.

local M = {}

---------------------------------------------------------------------------
-- Palette — the original 9-step ladder, no extras
---------------------------------------------------------------------------
--   bg0_hard   brightest (floats, popups)
--   bg0        main editor bg
--   bg1        sidebar / lazy panels
--   bg2        cursor line, statusline, code blocks
--   bg3        selection, prompt row
--   bg4        borders, line nrs, indent markers
--   fg_dim     comments, secondary
--   fg         main text
--   fg_bright  titles, selection text
local p = {
  bg0_hard = "#faf5e5",
  bg0 = "#f6f0e0",
  bg1 = "#ede6d2",
  bg2 = "#e4dac2",
  bg3 = "#d8cbae",
  bg4 = "#b8a98b",
  fg_dim = "#6d624b",
  fg = "#3b342b",
  fg_bright = "#2a241d",

  -- 7 accents — warm & low-sat. Each owns a semantic lane:
  --   red     keyword family (legacy Keyword, most @keyword.*)
  --   orange  UI chrome / titles / pills / alerts (MatchParen, IncSearch,
  --           mode-Normal, picker title, markdown H1/H2 fg…)
  --   yellow  types + warnings + Search highlight
  --   green   strings + additions + ok
  --   cyan    members / properties / modules + hints + imports
  --   blue    functions + diagnostic-info + directories
  --   magenta constants, numbers, literals + meta layer
  --           (macro/directive/special-char/attribute/preproc)
  red = "#9c4134",
  orange = "#a15f1e",
  yellow = "#846800",
  green = "#49742e",
  cyan = "#1b6d71",
  blue = "#375e8e",
  magenta = "#8a4467",

  none = "NONE",
}

---------------------------------------------------------------------------
-- Highlight helpers
---------------------------------------------------------------------------
local function hi(name, spec)
  -- enforce flat aesthetic for italics; bold is allowed selectively
  if spec.italic == nil then spec.italic = false end
  vim.api.nvim_set_hl(0, name, spec)
end

local function link(name, to) vim.api.nvim_set_hl(0, name, { link = to }) end

---------------------------------------------------------------------------
-- Apply
---------------------------------------------------------------------------
local function apply()
  -- editor chrome ----------------------------------------------------------
  hi("Normal", { fg = p.fg, bg = p.bg0 })
  hi("NormalFloat", { fg = p.fg, bg = p.bg0_hard })
  hi("NormalNC", { fg = p.fg, bg = p.bg0 })
  hi("FloatBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("FloatTitle", { fg = p.fg_bright, bg = p.bg0_hard, bold = true })
  hi("WinSeparator", { fg = p.bg4 })
  hi("VertSplit", { fg = p.bg4 })
  hi("Cursor", { fg = p.bg0, bg = p.fg })
  hi("CursorLine", { bg = p.bg2 })
  hi("CursorColumn", { bg = p.bg2 })
  hi("ColorColumn", { bg = p.bg1 })
  hi("LineNr", { fg = p.bg4 })
  hi("CursorLineNr", { fg = p.fg, bg = p.bg2, bold = true })
  hi("SignColumn", {})
  hi("Folded", { fg = p.fg_dim, bg = p.bg1 })
  hi("FoldColumn", { fg = p.fg_dim })
  hi("MatchParen", { fg = p.orange, bg = p.bg3, bold = true })
  hi("Visual", { bg = p.bg3 })
  hi("VisualNOS", { bg = p.bg3 })
  hi("Search", { fg = p.bg0, bg = p.yellow })
  hi("IncSearch", { fg = p.bg0, bg = p.orange })
  hi("CurSearch", { fg = p.bg0, bg = p.orange })
  hi("Substitute", { fg = p.bg0, bg = p.magenta })
  hi("NonText", { fg = p.bg4 })
  hi("Whitespace", { fg = p.bg4 })
  hi("SpecialKey", { fg = p.bg4 })
  hi("EndOfBuffer", { fg = p.bg0 })
  hi("Conceal", { fg = p.fg_dim })
  hi("Directory", { fg = p.blue })
  hi("Title", { fg = p.fg_bright })
  hi("ErrorMsg", { fg = p.red })
  hi("WarningMsg", { fg = p.yellow })
  hi("MoreMsg", { fg = p.green })
  hi("ModeMsg", { fg = p.fg })
  hi("Question", { fg = p.blue })
  hi("QuickFixLine", { bg = p.bg1, bold = true })

  hi("Pmenu", { fg = p.fg, bg = p.bg0_hard })
  hi("PmenuSel", { fg = p.fg_bright, bg = p.bg3 })
  hi("PmenuMatch", { fg = p.orange, bg = p.bg0_hard, bold = true })
  hi("PmenuMatchSel", { fg = p.orange, bg = p.bg3, bold = true })
  hi("PmenuSbar", { bg = p.bg1 })
  hi("PmenuThumb", { bg = p.bg4 })
  hi("PmenuKind", { fg = p.cyan, bg = p.bg0_hard })
  hi("PmenuKindSel", { fg = p.cyan, bg = p.bg3 })
  hi("PmenuExtra", { fg = p.fg_dim, bg = p.bg0_hard })
  hi("PmenuExtraSel", { fg = p.fg_dim, bg = p.bg3 })
  hi("WildMenu", { fg = p.fg_bright, bg = p.bg3 })

  -- Flat statusline: only the mode pill carries a bg, the rest blends into
  -- the editor background like in the ember mockups.
  hi("StatusLine", { fg = p.fg, bg = p.bg0 })
  hi("StatusLineNC", { fg = p.fg_dim, bg = p.bg0 })
  hi("TabLine", { fg = p.fg_dim, bg = p.bg1 })
  hi("TabLineSel", { fg = p.fg_bright, bg = p.bg0 })
  hi("TabLineFill", { bg = p.bg1 })
  hi("WinBar", { fg = p.fg, bg = p.bg0 })
  hi("WinBarNC", { fg = p.fg_dim, bg = p.bg0 })

  -- diff / git ------------------------------------------------------------
  hi("diffAdded", { fg = p.green })
  hi("diffChanged", { fg = p.yellow })
  hi("diffRemoved", { fg = p.red })
  hi("DiffAdd", { fg = p.green, bg = p.bg1, bold = true })
  hi("DiffChange", { fg = p.yellow, bg = p.bg1, bold = true })
  hi("DiffDelete", { fg = p.red, bg = p.bg1, bold = true })
  hi("DiffText", { bg = p.bg3 })

  -- diagnostics -----------------------------------------------------------
  hi("DiagnosticError", { fg = p.red })
  hi("DiagnosticWarn", { fg = p.yellow })
  hi("DiagnosticInfo", { fg = p.blue })
  hi("DiagnosticHint", { fg = p.cyan })
  hi("DiagnosticOk", { fg = p.green })
  hi("DiagnosticVirtualTextError", { fg = p.red })
  hi("DiagnosticVirtualTextWarn", { fg = p.yellow })
  hi("DiagnosticVirtualTextInfo", { fg = p.blue })
  hi("DiagnosticVirtualTextHint", { fg = p.cyan })
  hi("DiagnosticUnderlineError", { sp = p.red, undercurl = true })
  hi("DiagnosticUnderlineWarn", { sp = p.yellow, undercurl = true })
  hi("DiagnosticUnderlineInfo", { sp = p.blue, undercurl = true })
  hi("DiagnosticUnderlineHint", { sp = p.cyan, undercurl = true })
  hi("DiagnosticFloatingError", { fg = p.red, bg = p.bg0_hard })
  hi("DiagnosticFloatingWarn", { fg = p.yellow, bg = p.bg0_hard })
  hi("DiagnosticFloatingInfo", { fg = p.blue, bg = p.bg0_hard })
  hi("DiagnosticFloatingHint", { fg = p.cyan, bg = p.bg0_hard })
  hi("DiagnosticDeprecated", { fg = p.fg_dim, strikethrough = true })
  -- "greyed out" unused code — just a paler fg, no new palette slot needed
  hi("DiagnosticUnnecessary", { fg = p.bg4 })

  -- syntax (legacy) -------------------------------------------------------
  hi("Comment", { fg = p.fg_dim })
  hi("Constant", { fg = p.magenta })
  hi("String", { fg = p.green })
  hi("Character", { fg = p.green })
  hi("Number", { fg = p.magenta })
  hi("Boolean", { fg = p.magenta })
  hi("Float", { fg = p.magenta })
  hi("Identifier", { fg = p.fg })
  hi("Function", { fg = p.blue })
  hi("Statement", { fg = p.red, bold = true })
  hi("Conditional", { fg = p.fg_bright, bold = true })
  hi("Repeat", { fg = p.fg_bright, bold = true })
  hi("Label", { fg = p.red })
  hi("Operator", { fg = p.fg_dim })
  hi("Keyword", { fg = p.red })
  hi("Exception", { fg = p.fg_bright, bold = true })
  hi("PreProc", { fg = p.magenta })
  hi("Include", { fg = p.cyan })
  hi("Define", { fg = p.magenta })
  hi("Macro", { fg = p.magenta })
  hi("PreCondit", { fg = p.magenta })
  hi("Type", { fg = p.yellow })
  hi("StorageClass", { fg = p.yellow })
  hi("Structure", { fg = p.yellow })
  hi("Typedef", { fg = p.yellow })
  hi("Special", { fg = p.magenta })
  hi("SpecialChar", { fg = p.magenta })
  hi("Tag", { fg = p.red })
  hi("Delimiter", { fg = p.fg_dim })
  hi("SpecialComment", { fg = p.fg_dim })
  hi("Debug", { fg = p.red })
  hi("Underlined", { fg = p.blue, underline = true })
  hi("Ignore", { fg = p.fg_dim })
  hi("Error", { fg = p.red })
  hi("Todo", { fg = p.bg0, bg = p.yellow, bold = true })
  hi("Bold", { bold = true })

  -- Treesitter ------------------------------------------------------------
  link("@comment", "Comment")
  hi("@comment.todo", { fg = p.bg0, bg = p.yellow, bold = true })
  hi("@comment.note", { fg = p.bg0, bg = p.blue, bold = true })
  hi("@comment.warning", { fg = p.bg0, bg = p.orange, bold = true })
  hi("@comment.error", { fg = p.bg0, bg = p.red, bold = true })
  link("@variable", "Identifier")
  hi("@variable.parameter", { fg = p.fg })
  hi("@variable.member", { fg = p.cyan })
  hi("@variable.builtin", { fg = p.orange })
  hi("@constant", { fg = p.magenta })
  hi("@constant.builtin", { fg = p.orange })
  hi("@constant.macro", { fg = p.orange })
  hi("@module", { fg = p.cyan })
  hi("@module.builtin", { fg = p.cyan })
  link("@label", "Label")
  hi("@string", { fg = p.green })
  hi("@string.escape", { fg = p.magenta })
  hi("@string.regexp", { fg = p.magenta })
  hi("@string.special", { fg = p.magenta })
  hi("@character", { fg = p.green })
  hi("@character.special", { fg = p.magenta })
  hi("@boolean", { fg = p.magenta })
  hi("@number", { fg = p.magenta })
  hi("@number.float", { fg = p.magenta })
  hi("@type", { fg = p.yellow })
  hi("@type.builtin", { fg = p.yellow })
  hi("@type.definition", { fg = p.yellow })
  hi("@attribute", { fg = p.magenta })
  hi("@attribute.builtin", { fg = p.magenta })
  hi("@property", { fg = p.cyan })
  hi("@function", { fg = p.blue })
  hi("@function.builtin", { fg = p.blue })
  hi("@function.call", { fg = p.blue })
  hi("@function.macro", { fg = p.magenta })
  hi("@function.method", { fg = p.blue })
  hi("@function.method.call", { fg = p.blue })
  hi("@constructor", { fg = p.yellow })
  hi("@operator", { fg = p.fg_dim })
  hi("@keyword", { fg = p.red })
  hi("@keyword.function", { fg = p.red })
  hi("@keyword.operator", { fg = p.red })
  hi("@keyword.import", { fg = p.cyan, bold = true })
  hi("@keyword.storage", { fg = p.red, bold = true })
  hi("@keyword.repeat", { fg = p.red })
  hi("@keyword.return", { fg = p.red, bold = true })
  hi("@keyword.exception", { fg = p.red })
  hi("@keyword.conditional", { fg = p.red })
  hi("@keyword.debug", { fg = p.cyan, bold = true })
  hi("@keyword.directive", { fg = p.magenta, bold = true })
  hi("@keyword.directive.define", { fg = p.magenta, bold = true })
  hi("@punctuation", { fg = p.fg_dim })
  hi("@punctuation.delimiter", { fg = p.fg_dim })
  hi("@punctuation.bracket", { fg = p.fg_dim })
  hi("@punctuation.special", { fg = p.magenta })
  hi("@tag", { fg = p.red })
  hi("@tag.attribute", { fg = p.yellow })
  hi("@tag.delimiter", { fg = p.fg_dim })

  -- markdown / markup
  hi("@markup.heading", { fg = p.blue })
  hi("@markup.heading.1.markdown", { fg = p.red })
  hi("@markup.heading.2.markdown", { fg = p.orange })
  hi("@markup.heading.3.markdown", { fg = p.yellow })
  hi("@markup.heading.4.markdown", { fg = p.green })
  hi("@markup.heading.5.markdown", { fg = p.cyan })
  hi("@markup.heading.6.markdown", { fg = p.blue })
  hi("@markup.strong", { fg = p.orange, bold = true })
  hi("@markup.emphasis", { fg = p.yellow })
  hi("@markup.strikethrough", { fg = p.fg_dim, strikethrough = true })
  hi("@markup.underline", { fg = p.cyan, underline = true })
  hi("@markup.link", { fg = p.blue })
  hi("@markup.link.url", { fg = p.cyan, underline = true })
  hi("@markup.link.label", { fg = p.blue })
  hi("@markup.list", { fg = p.orange })
  hi("@markup.list.checked", { fg = p.green })
  hi("@markup.list.unchecked", { fg = p.fg_dim })
  hi("@markup.quote", { fg = p.fg_dim })
  hi("@markup.raw", { fg = p.green })
  hi("@markup.raw.block", { fg = p.green })
  hi("@markup.math", { fg = p.magenta })
  hi("@markup.environment", { fg = p.magenta })
  hi("@markup.note", { fg = p.bg0, bg = p.blue })
  hi("@markup.warning", { fg = p.bg0, bg = p.orange })
  hi("@markup.danger", { fg = p.bg0, bg = p.red })
  hi("@diff.plus", { fg = p.green })
  hi("@diff.minus", { fg = p.red })
  hi("@diff.delta", { fg = p.yellow })

  -- Treesitter legacy names still emitted by some grammars
  link("@namespace", "@module")
  link("@field", "@variable.member")
  link("@method", "@function.method")
  link("@method.call", "@function.method.call")
  link("@parameter", "@variable.parameter")
  link("@text", "Normal")
  link("@text.emphasis", "@markup.emphasis")
  link("@text.strong", "@markup.strong")
  link("@text.underline", "@markup.underline")
  link("@text.strike", "@markup.strikethrough")
  link("@text.title", "Title")
  link("@text.title.1", "@markup.heading.1.markdown")
  link("@text.title.2", "@markup.heading.2.markdown")
  link("@text.title.3", "@markup.heading.3.markdown")
  link("@text.literal", "@markup.raw")
  link("@text.reference", "@markup.link")
  link("@text.uri", "@markup.link.url")
  link("@text.todo", "@comment.todo")
  link("@text.note", "@markup.note")
  link("@text.warning", "@markup.warning")
  link("@text.danger", "@markup.danger")
  link("@text.diff.add", "@diff.plus")
  link("@text.diff.delete", "@diff.minus")

  -- LSP semantic tokens ---------------------------------------------------
  link("@lsp.type.class", "@type")
  link("@lsp.type.comment", "@comment")
  link("@lsp.type.decorator", "@attribute")
  link("@lsp.type.enum", "@type")
  link("@lsp.type.enumMember", "@constant")
  link("@lsp.type.function", "@function")
  link("@lsp.type.interface", "@type")
  link("@lsp.type.macro", "@function.macro")
  link("@lsp.type.method", "@function.method")
  link("@lsp.type.namespace", "@module")
  link("@lsp.type.parameter", "@variable.parameter")
  link("@lsp.type.property", "@property")
  link("@lsp.type.struct", "@type")
  link("@lsp.type.type", "@type")
  link("@lsp.type.typeParameter", "@type.definition")
  link("@lsp.type.variable", "@variable")
  link("@lsp.mod.readonly", "@constant")
  link("@lsp.mod.defaultLibrary", "@constant.builtin")
  link("@lsp.mod.deprecated", "DiagnosticDeprecated")
  link("@lsp.typemod.function.defaultLibrary", "@function.builtin")
  link("@lsp.typemod.variable.defaultLibrary", "@variable.builtin")
  link("@lsp.typemod.variable.readonly", "@constant")
  link("@lsp.typemod.parameter.readonly", "@variable.parameter")

  -- treesitter-context
  hi("TreesitterContext", { bg = p.bg2 })
  hi("TreesitterContextLineNumber", { fg = p.fg_dim, bg = p.bg2 })

  -- Gitsigns (full set) ---------------------------------------------------
  hi("GitSignsAdd", { fg = p.green, bold = true })
  hi("GitSignsAddLn", { link = "GitSignsAdd" })
  hi("GitSignsAddInline", { link = "GitSignsAdd" })
  hi("GitSignsChange", { fg = p.yellow, bold = true })
  hi("GitSignsChangeLn", { link = "GitSignsChange" })
  hi("GitSignsChangeInline", { link = "GitSignsChange" })
  hi("GitSignsDelete", { fg = p.red, bold = true })
  hi("GitSignsDeleteLn", { link = "GitSignsDelete" })
  hi("GitSignsDeleteInline", { link = "GitSignsDelete" })
  hi("GitSignsUntracked", { fg = p.blue })
  hi("GitSignsUntrackedLn", { link = "GitSignsUntracked" })
  hi("GitSignsUntrackedInline", { link = "GitSignsUntracked" })

  -- Spell checking --------------------------------------------------------
  hi("SpellBad", { sp = p.red, undercurl = true })
  hi("SpellCap", { sp = p.blue, undercurl = true })
  hi("SpellLocal", { sp = p.cyan, undercurl = true })
  hi("SpellRare", { sp = p.magenta, undercurl = true })

  -- LSP references / inlay hints / code lens -----------------------------
  hi("LspReferenceText", { bg = p.bg1 })
  hi("LspReferenceRead", { bg = p.bg1 })
  hi("LspReferenceWrite", { bg = p.bg3 })
  -- No bg: a tinted patch under every parameter/type hint chops up the line
  -- visually. fg=bg4 keeps the hint as ghosted text, lighter than Comment so
  -- it doesn't fight real comments for attention.
  hi("LspInlayHint", { fg = p.fg_dim })
  hi("LspCodeLens", { fg = p.fg_dim })
  hi("LspCodeLensSeparator", { fg = p.bg4 })
  hi("LspSignatureActiveParameter", { fg = p.orange, bg = p.bg1 })
  link("IlluminatedWordText", "LspReferenceText")
  link("IlluminatedWordRead", "LspReferenceRead")
  link("IlluminatedWordWrite", "LspReferenceWrite")

  -- MsgArea / messages / health ------------------------------------------
  hi("MsgArea", { fg = p.fg, bg = p.bg0 })
  hi("MsgSeparator", { fg = p.bg4, bg = p.bg0 })
  link("healthError", "DiagnosticError")
  link("healthSuccess", "DiagnosticOk")
  link("healthWarning", "DiagnosticWarn")

  -- Telescope -------------------------------------------------------------
  hi("TelescopeNormal", { fg = p.fg, bg = p.bg0_hard })
  hi("TelescopeBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("TelescopeTitle", { fg = p.fg_bright, bg = p.bg0_hard })
  hi("TelescopePromptNormal", { fg = p.fg, bg = p.bg1 })
  hi("TelescopePromptBorder", { fg = p.bg1, bg = p.bg1 })
  hi("TelescopePromptTitle", { fg = p.bg0, bg = p.orange })
  hi("TelescopePromptPrefix", { fg = p.orange, bg = p.bg1 })
  hi("TelescopeResultsTitle", { fg = p.bg0_hard, bg = p.bg0_hard })
  hi("TelescopeResultsNormal", { fg = p.fg, bg = p.bg0_hard })
  hi("TelescopeResultsBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("TelescopePreviewTitle", { fg = p.bg0, bg = p.green })
  hi("TelescopePreviewNormal", { fg = p.fg, bg = p.bg0_hard })
  hi("TelescopePreviewBorder", { fg = p.bg4, bg = p.bg0_hard })
  link("TelescopePreviewLine", "CursorLine")
  link("TelescopePreviewMatch", "Search")
  hi("TelescopeSelection", { fg = p.fg_bright, bg = p.bg3 })
  hi("TelescopeSelectionCaret", { fg = p.orange, bg = p.bg3 })
  hi("TelescopeMatching", { fg = p.orange })
  hi("TelescopeMultiSelection", { fg = p.magenta })

  -- which-key -------------------------------------------------------------
  hi("WhichKey", { fg = p.cyan })
  hi("WhichKeyBorder", { link = "FloatBorder" })
  hi("WhichKeyDesc", { fg = p.fg })
  hi("WhichKeyFloat", { fg = p.fg, bg = p.bg0_hard })
  hi("WhichKeyGroup", { fg = p.red })
  hi("WhichKeySeparator", { fg = p.green })
  hi("WhichKeyValue", { link = "Comment" })

  -- flash.nvim ------------------------------------------------------------
  -- Backdrop: dim the untouched text by using bg4 — it's our faintest fg
  -- so keystroke-relevant text (at fg/fg_bright) stays readable.
  hi("FlashBackdrop", { fg = p.bg4 })
  hi("FlashMatch", { fg = p.bg0, bg = p.cyan, bold = true })
  hi("FlashCurrent", { fg = p.bg0, bg = p.yellow, bold = true, underline = true })
  hi("FlashLabel", { fg = p.bg0, bg = p.red, bold = true })
  hi("FlashPrompt", { fg = p.magenta, bg = p.bg0, bold = true })
  hi("FlashPromptIcon", { fg = p.blue, bold = true })
  hi("FlashCursor", { fg = p.bg0, bg = p.green, bold = true, reverse = true })

  -- blink.cmp -------------------------------------------------------------
  hi("BlinkCmpMenu", { fg = p.fg, bg = p.bg0_hard })
  hi("BlinkCmpMenuBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("BlinkCmpMenuSelection", { fg = p.fg_bright, bg = p.bg3 })
  hi("BlinkCmpLabel", { fg = p.fg })
  hi("BlinkCmpLabelMatch", { fg = p.orange })
  hi("BlinkCmpLabelDeprecated", { fg = p.fg_dim, strikethrough = true })
  hi("BlinkCmpLabelDescription", { fg = p.fg_dim })
  hi("BlinkCmpKind", { fg = p.cyan })
  hi("BlinkCmpKindFunction", { fg = p.blue })
  hi("BlinkCmpKindMethod", { fg = p.blue })
  hi("BlinkCmpKindVariable", { fg = p.fg })
  hi("BlinkCmpKindKeyword", { fg = p.red })
  hi("BlinkCmpKindClass", { fg = p.yellow })
  hi("BlinkCmpKindInterface", { fg = p.yellow })
  hi("BlinkCmpKindText", { fg = p.green })
  hi("BlinkCmpKindSnippet", { fg = p.magenta })
  hi("BlinkCmpKindConstant", { fg = p.magenta })
  hi("BlinkCmpKindField", { fg = p.fg })
  hi("BlinkCmpKindProperty", { fg = p.fg })
  hi("BlinkCmpKindModule", { fg = p.cyan })
  hi("BlinkCmpKindColor", { fg = p.magenta })
  hi("BlinkCmpKindFile", { fg = p.blue })
  hi("BlinkCmpKindFolder", { fg = p.yellow })
  hi("BlinkCmpKindReference", { fg = p.cyan })
  hi("BlinkCmpKindEnum", { fg = p.yellow })
  hi("BlinkCmpKindEnumMember", { fg = p.magenta })
  hi("BlinkCmpKindStruct", { fg = p.yellow })
  hi("BlinkCmpKindEvent", { fg = p.orange })
  hi("BlinkCmpKindOperator", { fg = p.orange })
  hi("BlinkCmpKindTypeParameter", { fg = p.yellow })
  hi("BlinkCmpKindUnit", { fg = p.magenta })
  hi("BlinkCmpKindValue", { fg = p.magenta })
  hi("BlinkCmpDoc", { fg = p.fg, bg = p.bg0_hard })
  hi("BlinkCmpDocBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("BlinkCmpSignatureHelp", { fg = p.fg, bg = p.bg0_hard })
  hi("BlinkCmpSignatureHelpActiveParameter", { fg = p.orange })
  hi("BlinkCmpGhostText", { fg = p.fg_dim })

  -- nvim-cmp legacy
  link("CmpItemAbbr", "BlinkCmpLabel")
  link("CmpItemAbbrMatch", "BlinkCmpLabelMatch")
  link("CmpItemAbbrMatchFuzzy", "BlinkCmpLabelMatch")
  link("CmpItemAbbrDeprecated", "BlinkCmpLabelDeprecated")
  link("CmpItemKind", "BlinkCmpKind")
  link("CmpItemKindFunction", "BlinkCmpKindFunction")
  link("CmpItemKindMethod", "BlinkCmpKindMethod")
  link("CmpItemKindVariable", "BlinkCmpKindVariable")
  link("CmpItemKindKeyword", "BlinkCmpKindKeyword")
  link("CmpItemKindClass", "BlinkCmpKindClass")
  link("CmpItemKindText", "BlinkCmpKindText")
  link("CmpItemKindSnippet", "BlinkCmpKindSnippet")
  link("CmpItemKindConstant", "BlinkCmpKindConstant")
  link("CmpItemKindColor", "BlinkCmpKindColor")
  link("CmpItemKindFile", "BlinkCmpKindFile")
  link("CmpItemKindFolder", "BlinkCmpKindFolder")
  link("CmpItemKindReference", "BlinkCmpKindReference")
  link("CmpItemKindEnum", "BlinkCmpKindEnum")
  link("CmpItemKindEnumMember", "BlinkCmpKindEnumMember")
  link("CmpItemKindStruct", "BlinkCmpKindStruct")
  link("CmpItemKindEvent", "BlinkCmpKindEvent")
  link("CmpItemKindOperator", "BlinkCmpKindOperator")
  link("CmpItemKindTypeParameter", "BlinkCmpKindTypeParameter")
  link("CmpItemKindUnit", "BlinkCmpKindUnit")
  link("CmpItemKindValue", "BlinkCmpKindValue")
  link("CmpItemMenu", "Comment")

  -- snacks.nvim -----------------------------------------------------------
  hi("SnacksNormal", { fg = p.fg, bg = p.bg0_hard })
  hi("SnacksNormalNC", { fg = p.fg, bg = p.bg0_hard })
  hi("SnacksBackdrop", { bg = p.bg1 })
  hi("SnacksDashboardHeader", { fg = p.orange })
  hi("SnacksDashboardFooter", { fg = p.fg_dim })
  hi("SnacksDashboardDesc", { fg = p.fg })
  hi("SnacksDashboardKey", { fg = p.magenta })
  hi("SnacksDashboardIcon", { fg = p.yellow })
  hi("SnacksDashboardTitle", { fg = p.blue })
  hi("SnacksIndent", { fg = p.bg2 })
  hi("SnacksIndentScope", { fg = p.bg4 })
  hi("SnacksNotifierInfo", { fg = p.blue })
  hi("SnacksNotifierWarn", { fg = p.yellow })
  hi("SnacksNotifierError", { fg = p.red })
  hi("SnacksNotifierDebug", { fg = p.magenta })
  hi("SnacksNotifierTrace", { fg = p.fg_dim })
  hi("SnacksNotifierHistory", { fg = p.fg, bg = p.bg0_hard })
  hi("SnacksNotifierTitle", { fg = p.orange })
  hi("SnacksNotifierFooter", { fg = p.fg_dim })
  hi("SnacksNotifierBorderInfo", { fg = p.blue })
  hi("SnacksNotifierBorderWarn", { fg = p.yellow })
  hi("SnacksNotifierBorderError", { fg = p.red })
  hi("SnacksNotifierBorderDebug", { fg = p.magenta })
  hi("SnacksNotifierBorderTrace", { fg = p.fg_dim })
  hi("SnacksInputBorder", { fg = p.orange, bg = p.bg0_hard })
  hi("SnacksInputTitle", { fg = p.bg0, bg = p.orange })
  hi("SnacksTerminal", { fg = p.fg, bg = p.bg0_hard })
  hi("SnacksTerminalBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("SnacksWinBar", { fg = p.fg_bright, bg = p.bg2 })
  hi("SnacksWinBarNC", { fg = p.fg_dim, bg = p.bg2 })

  -- snacks picker
  -- Picker windows share `bg0` with the editor: orange title pills and the
  -- bg4 border do the structural work, so the panel reads as paper rather
  -- than a slightly-too-bright overlay.
  hi("SnacksPickerNormal", { fg = p.fg, bg = p.bg0 })
  hi("SnacksPickerBorder", { fg = p.bg4, bg = p.bg0 })
  hi("SnacksPickerTitle", { fg = p.bg0, bg = p.orange })
  hi("SnacksPickerPrompt", { fg = p.orange })
  hi("SnacksPickerMatch", { fg = p.orange })
  hi("SnacksPickerSelected", { fg = p.fg_bright, bg = p.bg3 })
  -- Toggle pills (h/i/f/m/R near the title). All snacks-defined per-toggle
  -- groups (`SnacksPickerToggleHidden` etc.) link to this base by default.
  -- Muted hint style — fg_dim on bg2 — so the pill reads as a quiet
  -- keyboard indicator rather than a competing badge to the title.
  hi("SnacksPickerToggle", { fg = p.bg0, bg = p.orange })
  link("SnacksPickerBufFlags", "Comment")
  link("SnacksPickerDir", "Comment")
  link("SnacksPickerGitStatusIgnored", "Comment")
  link("SnacksPickerGitStatusUntracked", "Comment")
  link("SnacksPickerKeymapRhs", "Comment")
  link("SnacksPickerListCursorLine", "CursorLine")
  link("SnacksPickerPathHidden", "Comment")
  link("SnacksPickerPathIgnored", "Comment")
  link("SnacksPickerTotals", "Comment")
  link("SnacksPickerUnselected", "Comment")
  hi("SnacksPickerInput", { fg = p.fg, bg = p.bg0 })
  hi("SnacksPickerInputBorder", { fg = p.bg4, bg = p.bg0 })
  hi("SnacksPickerInputTitle", { fg = p.bg0, bg = p.orange })
  link("SnacksPickerList", "SnacksPickerNormal")
  link("SnacksPickerListBorder", "SnacksPickerBorder")
  link("SnacksPickerPreview", "SnacksPickerNormal")
  link("SnacksPickerPreviewBorder", "SnacksPickerBorder")
  link("SnacksPickerPreviewTitle", "TelescopePreviewTitle")

  -- mini.clue -------------------------------------------------------------
  link("MiniClueBorder", "FloatBorder")
  hi("MiniClueDescGroup", { fg = p.red })
  hi("MiniClueDescSingle", { fg = p.fg })
  hi("MiniClueNextKey", { fg = p.cyan })
  link("MiniClueNextKeyWithPostkeys", "DiagnosticFloatingError")
  hi("MiniClueSeparator", { fg = p.blue })
  link("MiniClueTitle", "FloatTitle")

  -- mini.diff
  link("MiniDiffSignAdd", "diffAdded")
  link("MiniDiffSignChange", "diffChanged")
  link("MiniDiffSignDelete", "diffRemoved")
  link("MiniDiffOverAdd", "DiffAdd")
  link("MiniDiffOverChange", "DiffText")
  link("MiniDiffOverChangeBuf", "MiniDiffOverChange")
  link("MiniDiffOverContext", "DiffChange")
  hi("MiniDiffOverContextBuf", {})
  link("MiniDiffOverDelete", "DiffDelete")

  -- mini.hipatterns
  hi("MiniHipatternsFixme", { fg = p.bg0, bg = p.red, bold = true })
  hi("MiniHipatternsHack", { fg = p.bg0, bg = p.yellow, bold = true })
  hi("MiniHipatternsNote", { fg = p.bg0, bg = p.cyan, bold = true })
  hi("MiniHipatternsTodo", { fg = p.bg0, bg = p.blue, bold = true })

  -- mini.icons — map the "extra" names onto our 8 accents.
  -- mini expects azure + purple as distinct groups; we alias them to
  -- blue + magenta respectively rather than invent new tokens.
  hi("MiniIconsAzure", { fg = p.blue })
  hi("MiniIconsBlue", { fg = p.blue })
  hi("MiniIconsCyan", { fg = p.cyan })
  hi("MiniIconsGreen", { fg = p.green })
  hi("MiniIconsGrey", { fg = p.bg4 })
  hi("MiniIconsOrange", { fg = p.orange })
  hi("MiniIconsPurple", { fg = p.magenta })
  hi("MiniIconsRed", { fg = p.red })
  hi("MiniIconsYellow", { fg = p.yellow })
  link("MiniSurround", "IncSearch")

  -- mini.statusline — flat layout: only the mode pill is filled, every other
  -- segment is plain text on bg0. Mode colours: Normal=orange, Insert=green,
  -- Visual=magenta, Replace=red, Command=yellow.
  hi("MiniStatuslineDevinfo", { fg = p.fg_dim, bg = p.bg0 }) -- container for diags
  link("MiniStatuslineFileinfo", "MiniStatuslineDevinfo") -- "utf-8 : LF" muted
  -- Modified marker (✢).
  hi("MiniStatuslineModified", { fg = p.red, bg = p.bg0, bold = true })
  link("MiniStatuslineInactive", "StatusLineNC")
  hi("MiniStatuslineModeNormal", { fg = p.bg0, bg = p.orange, bold = true })
  hi("MiniStatuslineModeInsert", { fg = p.bg0, bg = p.green, bold = true })
  hi("MiniStatuslineModeVisual", { fg = p.bg0, bg = p.magenta, bold = true })
  hi("MiniStatuslineModeReplace", { fg = p.bg0, bg = p.red, bold = true })
  hi("MiniStatuslineModeCommand", { fg = p.bg0, bg = p.yellow, bold = true })
  hi("MiniStatuslineModeOther", { fg = p.bg0, bg = p.cyan, bold = true })
  hi("MiniStatuslineLsp", { fg = p.orange, bg = p.bg0 })
  hi("MiniStatuslineCopilot", { fg = p.magenta, bg = p.bg0 })
  -- Branch + filetype: clearer than dim, but no bg pill — they sit between
  -- the mode pill on the left and the dim "encoding" tail on the right.
  hi("MiniStatuslineGitBranch", { fg = p.fg, bg = p.bg0 })
  hi("MiniStatuslineFiletype", { fg = p.fg, bg = p.bg0 })
  hi("MiniStatuslineGitAdd", { fg = p.green, bg = p.bg0 })
  hi("MiniStatuslineGitChange", { fg = p.yellow, bg = p.bg0 })
  hi("MiniStatuslineGitDelete", { fg = p.red, bg = p.bg0 })
  -- Diagnostics: hint=green (was cyan) to match the four-dot ember mockup
  -- (✗ red, ▲ yellow, ● blue info, ● green hint).
  hi("MiniStatuslineDiagError", { fg = p.red, bg = p.bg0 })
  hi("MiniStatuslineDiagWarn", { fg = p.yellow, bg = p.bg0 })
  hi("MiniStatuslineDiagInfo", { fg = p.blue, bg = p.bg0 })
  hi("MiniStatuslineDiagHint", { fg = p.green, bg = p.bg0 })

  -- lazy.nvim -------------------------------------------------------------
  hi("LazyNormal", { fg = p.fg, bg = p.bg0_hard })
  hi("LazyButton", { bg = p.bg2 })
  hi("LazyButtonActive", { bg = p.bg3 })
  link("LazyDimmed", "Comment")
  hi("LazyH1", { fg = p.orange, bg = p.bg3, bold = true })
  hi("LazyComment", { fg = p.fg_dim })
  hi("LazyCommit", { fg = p.yellow })
  hi("LazyCommitIssue", { fg = p.red })
  hi("LazyCommitScope", { fg = p.magenta })
  hi("LazyCommitType", { fg = p.orange })
  hi("LazyDir", { fg = p.cyan })
  hi("LazyHandlerCmd", { fg = p.yellow })
  hi("LazyHandlerEvent", { fg = p.green })
  hi("LazyHandlerFt", { fg = p.cyan })
  hi("LazyHandlerKeys", { fg = p.magenta })
  hi("LazyHandlerRuntime", { fg = p.blue })
  hi("LazyHandlerSource", { fg = p.fg_dim })
  hi("LazyHandlerStart", { fg = p.green })
  hi("LazyProgressDone", { fg = p.green, bold = true })
  hi("LazyProgressTodo", { fg = p.bg4, bold = true })
  hi("LazyReasonCmd", { fg = p.yellow })
  hi("LazyReasonEvent", { fg = p.green })
  hi("LazyReasonFt", { fg = p.cyan })
  hi("LazyReasonImport", { fg = p.fg_dim })
  hi("LazyReasonKeys", { fg = p.magenta })
  hi("LazyReasonPlugin", { fg = p.orange })
  hi("LazyReasonRuntime", { fg = p.blue })
  hi("LazyReasonSource", { fg = p.fg_dim })
  hi("LazyReasonStart", { fg = p.green })
  hi("LazySpecial", { fg = p.orange })
  hi("LazyTaskOutput", { fg = p.fg })
  hi("LazyUrl", { fg = p.cyan, underline = true })
  hi("LazyValue", { fg = p.magenta })

  -- mason.nvim ------------------------------------------------------------
  hi("MasonHeader", { fg = p.bg0, bg = p.orange, bold = true })
  hi("MasonHeaderSecondary", { fg = p.bg0, bg = p.blue, bold = true })
  hi("MasonHighlight", { fg = p.orange })
  hi("MasonHighlightBlock", { fg = p.bg0, bg = p.orange })
  hi("MasonHighlightBlockBold", { fg = p.bg0, bg = p.orange, bold = true })
  hi("MasonHighlightSecondary", { fg = p.blue })
  hi("MasonHighlightBlockSecondary", { fg = p.bg0, bg = p.blue })
  hi("MasonHighlightBlockBoldSecondary", { fg = p.bg0, bg = p.blue, bold = true })
  hi("MasonMuted", { fg = p.fg_dim })
  hi("MasonMutedBlock", { fg = p.fg_bright, bg = p.bg2 })
  hi("MasonError", { fg = p.red })
  hi("MasonWarning", { fg = p.yellow })

  -- noice.nvim ------------------------------------------------------------
  hi("NoiceCmdline", { fg = p.fg, bg = p.bg0_hard })
  hi("NoiceCmdlineIcon", { fg = p.orange })
  hi("NoiceCmdlineIconSearch", { fg = p.yellow })
  hi("NoiceCmdlinePopup", { fg = p.fg, bg = p.bg0_hard })
  hi("NoiceCmdlinePopupBorder", { fg = p.blue })
  hi("NoiceCmdlinePrompt", { fg = p.orange })
  hi("NoiceConfirmBorder", { fg = p.yellow })
  hi("NoiceMini", { fg = p.fg, bg = p.bg2 })
  hi("NoicePopup", { fg = p.fg, bg = p.bg0_hard })
  hi("NoicePopupBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("NoicePopupmenu", { fg = p.fg, bg = p.bg0_hard })
  hi("NoicePopupmenuBorder", { fg = p.bg4, bg = p.bg0_hard })
  hi("NoicePopupmenuMatch", { fg = p.orange })
  hi("NoicePopupmenuSelected", { fg = p.fg_bright, bg = p.bg3 })
  hi("NoiceLspProgressClient", { fg = p.blue })
  hi("NoiceLspProgressTitle", { fg = p.fg })
  hi("NoiceLspProgressSpinner", { fg = p.orange })
  link("NoiceVirtualText", "DiagnosticVirtualTextInfo")

  -- trouble.nvim ----------------------------------------------------------
  hi("TroubleNormal", { fg = p.fg, bg = p.bg0_hard })
  hi("TroubleNormalNC", { fg = p.fg, bg = p.bg0_hard })
  hi("TroubleCount", { fg = p.orange, bold = true })
  hi("TroubleFoldIcon", { fg = p.orange, bold = true })
  hi("TroubleIndent", { fg = p.bg3 })
  hi("TroubleLocation", { fg = p.fg_dim })
  hi("TroubleFile", { fg = p.blue })
  hi("TroubleSource", { fg = p.fg_dim })
  hi("TroubleText", { fg = p.fg })
  link("TroubleCode", "Comment")
  link("TroublePos", "Comment")
  link("TroubleSignError", "DiagnosticError")
  link("TroubleSignHint", "DiagnosticHint")
  link("TroubleSignInformation", "DiagnosticInfo")
  link("TroubleSignOther", "DiagnosticInfo")
  link("TroubleSignWarning", "DiagnosticWarn")
  link("TroubleTextError", "TroubleText")
  link("TroubleTextHint", "TroubleText")
  link("TroubleTextInformation", "TroubleText")
  link("TroubleTextWarning", "TroubleText")

  -- render-markdown.nvim --------------------------------------------------
  -- Header bgs use the neutral warm bg ladder: H1/H2 get the deeper bg2
  -- tint for prominence, H3–H6 share bg1. The heading fg colour carries
  -- the rainbow distinction across levels.
  hi("RenderMarkdownBullet", { fg = p.orange })
  link("RenderMarkdownChecked", "DiagnosticOk")
  hi("RenderMarkdownCode", { bg = p.bg1 })
  hi("RenderMarkdownCodeInline", { bg = p.bg1 })
  hi("RenderMarkdownDash", { fg = p.orange })
  hi("RenderMarkdownH1", { fg = p.red })
  hi("RenderMarkdownH1Bg", { bg = p.bg2 })
  hi("RenderMarkdownH2", { fg = p.orange })
  hi("RenderMarkdownH2Bg", { bg = p.bg2 })
  hi("RenderMarkdownH3", { fg = p.yellow })
  hi("RenderMarkdownH3Bg", { bg = p.bg1 })
  hi("RenderMarkdownH4", { fg = p.green })
  hi("RenderMarkdownH4Bg", { bg = p.bg1 })
  hi("RenderMarkdownH5", { fg = p.cyan })
  hi("RenderMarkdownH5Bg", { bg = p.bg1 })
  hi("RenderMarkdownH6", { fg = p.blue })
  hi("RenderMarkdownH6Bg", { bg = p.bg1 })
  link("RenderMarkdownTodo", "Todo")
  link("RenderMarkdownUnchecked", "DiagnosticWarn")

  -- NvimTree --------------------------------------------------------------
  hi("NvimTreeNormal", { fg = p.fg, bg = p.bg1 })
  hi("NvimTreeNormalNC", { fg = p.fg, bg = p.bg1 })
  hi("NvimTreeWinSeparator", { fg = p.bg4, bg = p.bg1 })
  hi("NvimTreeCursorLine", { bg = p.bg3 })
  hi("NvimTreeFolderIcon", { fg = p.yellow })
  hi("NvimTreeFolderName", { fg = p.fg })
  hi("NvimTreeOpenedFolderName", { fg = p.fg_bright })
  hi("NvimTreeEmptyFolderName", { fg = p.fg_dim })
  hi("NvimTreeFileIcon", { fg = p.fg_dim })
  hi("NvimTreeSpecialFile", { fg = p.orange })
  hi("NvimTreeImageFile", { fg = p.magenta })
  hi("NvimTreeExecFile", { fg = p.green })
  hi("NvimTreeSymlink", { fg = p.cyan })
  hi("NvimTreeGitDirty", { fg = p.yellow })
  hi("NvimTreeGitNew", { fg = p.green })
  hi("NvimTreeGitDeleted", { fg = p.red })
  hi("NvimTreeGitStaged", { fg = p.green })
  hi("NvimTreeGitMerge", { fg = p.orange })
  hi("NvimTreeGitRenamed", { fg = p.yellow })
  hi("NvimTreeGitIgnored", { fg = p.bg4 })
  hi("NvimTreeModifiedFile", { fg = p.yellow })
  hi("NvimTreeOpenedFile", { fg = p.fg_bright })
  hi("NvimTreeRootFolder", { fg = p.orange })
  hi("NvimTreeIndentMarker", { fg = p.bg3 })
  hi("NvimTreeWindowPicker", { fg = p.fg_bright, bg = p.orange, bold = true })

  -- Neo-tree --------------------------------------------------------------
  link("NeoTreeNormal", "NvimTreeNormal")
  link("NeoTreeNormalNC", "NvimTreeNormalNC")
  link("NeoTreeDirectoryIcon", "NvimTreeFolderIcon")
  link("NeoTreeDirectoryName", "NvimTreeFolderName")
  link("NeoTreeRootName", "NvimTreeRootFolder")
  link("NeoTreeGitModified", "NvimTreeGitDirty")
  link("NeoTreeGitAdded", "NvimTreeGitNew")
  link("NeoTreeGitDeleted", "NvimTreeGitDeleted")
  link("NeoTreeIndentMarker", "NvimTreeIndentMarker")
  link("NeoTreeCursorLine", "NvimTreeCursorLine")
  hi("NeoTreeDirectoryIconOpen", { fg = p.orange })
  hi("NeoTreeTitleBar", { fg = p.bg0, bg = p.orange })
  hi("NeoTreeTabActive", { fg = p.fg_bright, bg = p.bg0_hard })
  hi("NeoTreeTabInactive", { fg = p.fg_dim, bg = p.bg1 })
  hi("NeoTreeTabSeparatorActive", { fg = p.orange, bg = p.bg0_hard })
  hi("NeoTreeTabSeparatorInactive", { fg = p.bg4, bg = p.bg1 })
  hi("NeoTreeDimText", { fg = p.fg_dim })
  hi("NeoTreeFileNameOpened", { fg = p.fg_bright })
  hi("NeoTreeModified", { fg = p.yellow })
  link("NeoTreeGitConflict", "DiagnosticError")
  link("NeoTreeGitIgnored", "NvimTreeGitIgnored")
  link("NeoTreeGitUnstaged", "NvimTreeGitDirty")
  link("NeoTreeGitStaged", "NvimTreeGitStaged")

  -- lualine helpers -------------------------------------------------------
  hi("LualineNormal", { fg = p.bg0, bg = p.orange })
  hi("LualineInsert", { fg = p.bg0, bg = p.green })
  hi("LualineVisual", { fg = p.bg0, bg = p.magenta })
  hi("LualineReplace", { fg = p.bg0, bg = p.red })
  hi("LualineCommand", { fg = p.bg0, bg = p.yellow })

  -- rainbow brackets ------------------------------------------------------
  hi("RainbowDelimiterRed", { fg = p.red })
  hi("RainbowDelimiterOrange", { fg = p.orange })
  hi("RainbowDelimiterYellow", { fg = p.yellow })
  hi("RainbowDelimiterGreen", { fg = p.green })
  hi("RainbowDelimiterCyan", { fg = p.cyan })
  hi("RainbowDelimiterBlue", { fg = p.blue })
  hi("RainbowDelimiterViolet", { fg = p.magenta })

  -- bufferline ------------------------------------------------------------
  hi("BufferLineBackground", { fg = p.fg_dim, bg = p.bg1 })
  hi("BufferLineBuffer", { fg = p.fg_dim, bg = p.bg1 })
  hi("BufferLineBufferSelected", { fg = p.fg_bright, bg = p.bg0, bold = true })
  hi("BufferLineBufferVisible", { fg = p.fg, bg = p.bg2 })
  hi("BufferLineCloseButton", { fg = p.fg_dim, bg = p.bg1 })
  hi("BufferLineCloseButtonSelected", { fg = p.red, bg = p.bg0 })
  hi("BufferLineCloseButtonVisible", { fg = p.fg_dim, bg = p.bg2 })
  hi("BufferLineFill", { bg = p.bg1 })
  hi("BufferLineIndicatorSelected", { fg = p.orange, bg = p.bg0 })
  hi("BufferLineModified", { fg = p.yellow, bg = p.bg1 })
  hi("BufferLineModifiedSelected", { fg = p.yellow, bg = p.bg0 })
  hi("BufferLineModifiedVisible", { fg = p.yellow, bg = p.bg2 })
  hi("BufferLineSeparator", { fg = p.bg4, bg = p.bg1 })
  hi("BufferLineSeparatorSelected", { fg = p.bg4, bg = p.bg0 })
  hi("BufferLineSeparatorVisible", { fg = p.bg4, bg = p.bg2 })
  hi("BufferLineTab", { fg = p.fg_dim, bg = p.bg1 })
  hi("BufferLineTabSelected", { fg = p.orange, bg = p.bg0 })
  hi("BufferLineTabClose", { fg = p.red, bg = p.bg1 })
  hi("BufferLineDuplicate", { fg = p.fg_dim, bg = p.bg1 })
  hi("BufferLineDuplicateSelected", { fg = p.fg_dim, bg = p.bg0 })
  hi("BufferLineDuplicateVisible", { fg = p.fg_dim, bg = p.bg2 })

  -- indent-blankline (ibl v3) --------------------------------------------
  hi("IblIndent", { fg = p.bg2 })
  hi("IblWhitespace", { fg = p.bg2 })
  hi("IblScope", { fg = p.bg4 })
  link("IndentBlanklineChar", "IblIndent")
  link("IndentBlanklineContextChar", "IblScope")
  link("IndentBlanklineSpaceChar", "IblIndent")
  link("IndentBlanklineSpaceCharBlankline", "IblIndent")

  -- dap / dap-ui ----------------------------------------------------------
  hi("DapBreakpoint", { fg = p.red })
  hi("DapBreakpointCondition", { fg = p.orange })
  hi("DapBreakpointRejected", { fg = p.fg_dim })
  hi("DapLogPoint", { fg = p.blue })
  hi("DapStopped", { fg = p.green })
  hi("DapStoppedLine", { bg = p.bg2 })
  hi("DapUIBreakpointsCurrentLine", { fg = p.yellow, bold = true })
  hi("DapUIBreakpointsDisabledLine", { fg = p.fg_dim })
  hi("DapUIBreakpointsInfo", { fg = p.green })
  hi("DapUIBreakpointsLine", { fg = p.yellow })
  hi("DapUIBreakpointsPath", { fg = p.cyan })
  hi("DapUICurrentFrameName", { fg = p.magenta, bold = true })
  hi("DapUIDecoration", { fg = p.cyan })
  hi("DapUIFloatBorder", { fg = p.cyan })
  hi("DapUILineNumber", { fg = p.cyan })
  hi("DapUIModifiedValue", { fg = p.orange, bold = true })
  hi("DapUIPlayPause", { fg = p.green })
  hi("DapUIRestart", { fg = p.green })
  hi("DapUIScope", { fg = p.cyan })
  hi("DapUISource", { fg = p.magenta })
  hi("DapUIStepBack", { fg = p.cyan })
  hi("DapUIStepInto", { fg = p.cyan })
  hi("DapUIStepOut", { fg = p.cyan })
  hi("DapUIStepOver", { fg = p.cyan })
  hi("DapUIStop", { fg = p.red })
  hi("DapUIStoppedThread", { fg = p.cyan })
  hi("DapUIThread", { fg = p.green })
  hi("DapUIType", { fg = p.magenta })
  hi("DapUIValue", { fg = p.fg })
  hi("DapUIVariable", { fg = p.fg })
  hi("DapUIWatchesEmpty", { fg = p.red })
  hi("DapUIWatchesError", { fg = p.red })
  hi("DapUIWatchesValue", { fg = p.yellow })
  hi("DapUIWinSelect", { fg = p.cyan, bold = true })

  -- todo-comments ---------------------------------------------------------
  -- PERF + TEST collapse onto magenta — both share the "metric / sideband"
  -- semantic, and we don't have a dedicated purple in the palette.
  hi("TodoBgFIX", { fg = p.bg0, bg = p.red, bold = true })
  hi("TodoBgHACK", { fg = p.bg0, bg = p.yellow, bold = true })
  hi("TodoBgNOTE", { fg = p.bg0, bg = p.cyan, bold = true })
  hi("TodoBgPERF", { fg = p.bg0, bg = p.magenta, bold = true })
  hi("TodoBgTEST", { fg = p.bg0, bg = p.magenta, bold = true })
  hi("TodoBgTODO", { fg = p.bg0, bg = p.blue, bold = true })
  hi("TodoBgWARN", { fg = p.bg0, bg = p.orange, bold = true })
  hi("TodoFgFIX", { fg = p.red })
  hi("TodoFgHACK", { fg = p.yellow })
  hi("TodoFgNOTE", { fg = p.cyan })
  hi("TodoFgPERF", { fg = p.magenta })
  hi("TodoFgTEST", { fg = p.magenta })
  hi("TodoFgTODO", { fg = p.blue })
  hi("TodoFgWARN", { fg = p.orange })
  hi("TodoSignFIX", { fg = p.red })
  hi("TodoSignHACK", { fg = p.yellow })
  hi("TodoSignNOTE", { fg = p.cyan })
  hi("TodoSignPERF", { fg = p.magenta })
  hi("TodoSignTEST", { fg = p.magenta })
  hi("TodoSignTODO", { fg = p.blue })
  hi("TodoSignWARN", { fg = p.orange })

  -- dashboard / alpha -----------------------------------------------------
  hi("DashboardHeader", { fg = p.orange })
  hi("DashboardFooter", { fg = p.fg_dim })
  hi("DashboardShortCut", { fg = p.magenta })
  hi("DashboardCenter", { fg = p.fg })
  hi("DashboardKey", { fg = p.magenta })
  hi("DashboardDesc", { fg = p.fg })
  hi("DashboardIcon", { fg = p.yellow })
  link("AlphaHeader", "DashboardHeader")
  link("AlphaFooter", "DashboardFooter")
  link("AlphaShortcut", "DashboardShortCut")
  link("AlphaButtons", "DashboardCenter")
  link("AlphaButtonsDesc", "DashboardDesc")

  -- gitcommit / fugitive --------------------------------------------------
  hi("gitcommitSummary", { fg = p.fg_bright })
  hi("gitcommitOverflow", { fg = p.red })
  hi("gitcommitComment", { fg = p.fg_dim })
  hi("gitcommitBranch", { fg = p.orange, bold = true })
  hi("gitcommitHeader", { fg = p.magenta })
  hi("gitcommitSelectedFile", { fg = p.green, bold = true })
  hi("gitcommitDiscardedFile", { fg = p.red, bold = true })
  link("fugitiveSection", "Title")
  link("fugitiveHeader", "Title")
  link("fugitiveSymbolicRef", "Identifier")
  link("fugitiveHash", "Comment")
  link("fugitiveRemote", "Constant")
end

---------------------------------------------------------------------------
-- Entry point
---------------------------------------------------------------------------
function M.load()
  if vim.g.colors_name then vim.cmd("hi clear") end
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
  vim.o.termguicolors = true
  vim.o.background = "light" -- ember is light-only
  vim.g.colors_name = "ember"
  apply()
end

function M.palette() return p end

M.load()

return M
