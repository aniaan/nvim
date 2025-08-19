local consts = require("consts")
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
