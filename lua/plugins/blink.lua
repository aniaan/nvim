local consts = require("consts")
local symbol_kinds = {
  Array = "󰅪",
  Class = "",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰆧",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = "",
  Operator = "󰆕",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
}
return {
  {
    consts.BLINK_CMP,
    version = "*",
    lazy = false,
    opts = {
      appearance = {
        -- kind_icons = symbol_kinds,
      },
      completion = {
        documentation = {
          auto_show = true,
        },
      },

      sources = {
        default = { "lsp", "snippets", "buffer" },
      },

      cmdline = {
        enabled = false,
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
  },
}
