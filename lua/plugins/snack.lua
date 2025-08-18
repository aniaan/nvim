local Picker = require("utils.picker")

return {
  {
    require("consts").SNACKS,
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = false },
      explorer = { enabled = true },

      dashboard = {
        preset = {
          header = [[
      ⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀
╭──────────────────────────────────────────────╮
│ ██████╗ ███╗   ██╗██╗ █████╗  █████╗ ███╗   ██╗ │    :･ﾟ✧
│██╔══██╗████╗  ██║██║██╔══██╗██╔══██╗████╗  ██║ │  ⋆｡°✩
│███████║██╔██╗ ██║██║███████║███████║██╔██╗ ██║ │    ˚✧₊⁺
│██╔══██║██║╚██╗██║██║██╔══██║██╔══██║██║╚██╗██║ │ ⊹  ·  ⋆
│██║  ██║██║ ╚████║██║██║  ██║██║  ██║██║ ╚████║ │   ✦  .
│╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ │  ˚  ⋆
╰──────────────────────────────────────────────╯
          ]],
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },

      picker = {
        win = {
          preview = {
            wo = {
              number = false,
              relativenumber = false,
            },
          },
        },
        layout = {
          layout = {
            backdrop = false,
          },
        },
        sources = {
          files = Picker.normal_layout,
          buffers = Picker.normal_layout,
          lsp_declarations = Picker.normal_layout,
          lsp_definitions = Picker.normal_layout,
          lsp_implementations = Picker.normal_layout,
          lsp_references = Picker.lsp_layout,
          lsp_symbols = Picker.lsp_layout,
          lsp_type_definitions = Picker.normal_layout,
          lsp_workspace_symbols = Picker.normal_layout,
          explorer = Picker.explorer_layout,
        },
      },
    },
    keys = {
      { "<leader>n", false },
      {
        "<leader>N",
        function() Snacks.picker.notifications() end,
        desc = "Notification History",
      },
      {
        "<leader><space>",
        function()
          Snacks.picker.files({
            cwd = vim.uv.cwd(),
            hidden = true,
            exclude = Picker.exclude_pattern,
          })
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep({
            cwd = vim.uv.cwd(),
            hidden = true,
            exclude = Picker.exclude_pattern,
          })
        end,
        desc = "Grep (Root Dir)",
      },

      {
        "<leader>.",
        function() Snacks.picker.lsp_symbols() end,
        desc = "Goto Symbol",
      },

      {
        "<leader>>",
        function() Snacks.picker.lsp_workspace_symbols() end,
        desc = "Goto Symbol (Workspace)",
      },
      {
        "<leader>fe",
        function() Snacks.explorer() end,
        desc = "Explorer Snacks (root dir)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },

      {
        "<leader>,",
        function() Snacks.picker.buffers() end,
        desc = "Buffers",
      },
      {
        "<leader>sH",
        function() Snacks.picker.highlights() end,
        desc = "Highlights",
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle.inlay_hints():map("<leader>uh")
    end,
  },

  {
    "folke/flash.nvim",
    optional = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
}
