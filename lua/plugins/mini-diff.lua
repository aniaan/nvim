return {
  {
    require('consts').MINI_DIFF,
    event = 'VeryLazy',
    opts = {
      view = {
        style = 'sign',
        signs = {
          add = '┃',
          change = '┃',
          delete = '-',
        },
      },
    },
  },
}
