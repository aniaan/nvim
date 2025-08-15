return {
  {
    require('consts').WHICH_KEY,
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    opts = {
      preset = 'helix',
      spec = {
        {
          mode = { 'n', 'v' },
          { '<leader>a', group = 'ai' },
          { '<leader>b', group = 'buffers' },
          { '<leader>c', group = 'code' },
          { '<leader>f', group = 'find/file' },
          { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
          { '<leader>s', group = 'search' },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { 'g', group = 'goto' },
          { 'z', group = 'fold' },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            --   expand = function()
            --     return require("which-key.extras").expand.win()
            --   end,
          },
        },
      },
    },
  },
}
