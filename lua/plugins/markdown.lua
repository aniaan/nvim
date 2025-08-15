return {
  {
    require('consts').MARKDOWN,
    opts = {
      render_modes = false,
      code = {
        sign = false,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'Avante', 'markdown' },
  },
}
