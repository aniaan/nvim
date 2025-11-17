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
        default = { "lsp", "snippets", "buffer", 'path' },
      },

      cmdline = {
        keymap = {
          ["<Tab>"] = { "show", "accept" },
        },
        completion = { menu = { auto_show = true } },
      },

      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          "snippet_forward",
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          function() -- if you are using Neovim's native inline completions
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
        ["C-F"] = {
          -- function() -- sidekick next edit suggestion
          --   return require("sidekick").nes_jump_or_apply()
          -- end,
          function() -- if you are using Neovim's native inline completions
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
      },
    },
  },
}
