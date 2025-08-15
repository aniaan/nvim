return {
  {
    require('consts').MINI_AI,
    event = 'VeryLazy',
    config = function()
      local ai = require('mini.ai')
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          u = ai.gen_spec.function_call(), -- u for "Usage"
        },
      })
    end,
  },
}
