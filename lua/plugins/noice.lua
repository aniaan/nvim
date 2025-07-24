return {
  {
    require("consts").NOICE,
    event = "VeryLazy",
    dependencies = {
      require("consts").NUI,
    },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      views = {
        cmdline_popup = {
          position = {
            row = "40%",
          },
        },
      },
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      -- if vim.o.filetype == "lazy" then
      --   vim.cmd([[messages clear]])
      -- end
      require("noice").setup(opts)
    end,
  },
}
