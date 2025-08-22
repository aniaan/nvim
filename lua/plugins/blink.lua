local consts = require("consts")
return {
  {
    consts.BLINK_CMP,
    version = "*",
    lazy = false,
    opts = {
      fuzzy = { implementation = "rust" },
      completion = {
        documentation = {
          auto_show = true,
        },
      },

      sources = {
        default = { "lsp", "snippets", "buffer" },
      },

      cmdline = {
        keymap = {
          ["<Tab>"] = { "show", "accept" },
        },
        completion = { menu = { auto_show = true } },
      },

      keymap = {
        preset = "enter",
      },
    },
  },
}
