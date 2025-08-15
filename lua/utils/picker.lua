local M = {}
local H = {}

H.get_layout = function()
  return {
    hidden = { 'preview' },
    position = 'center',
    layout = {
      backdrop = false,
      height = 0.4,
      width = 0.4,
      min_width = 80,
      border = 'none',
      box = 'vertical',
      {
        box = 'vertical',
        border = 'rounded',
        title = '',
        title_pos = 'center',
        { win = 'input', height = 1, border = 'none' },
        { win = 'list', border = 'top' },
      },
      { win = 'preview', title = '', border = 'rounded' },
    },
  }
end

H.get_perview_main_layout = function()
  return {
    preview = 'main',
    hidden = { 'preview' },
    position = 'center',
    layout = {
      backdrop = false,
      height = 0.4,
      width = 0.4,
      min_width = 80,
      border = 'none',
      box = 'vertical',
      {
        box = 'vertical',
        border = 'rounded',
        title = '',
        title_pos = 'center',
        { win = 'input', height = 1, border = 'bottom' },
        { win = 'list', border = 'none' },
      },
      { win = 'preview', title = '', border = 'rounded' },
    },
  }
end

M.exclude_pattern = {
  '.git',
  'node_modules',
  '__pycache__',
  '.venv',
  'venv',
  'target',
  'build',
  'dist',
}

M.normal_layout = {
  layout = H.get_layout(),
}

M.lsp_layout = {
  layout = H.get_layout(),
}

M.explorer_layout = {
  hidden = true,
  layout = {
    hidden = { 'preview' },
    layout = {
      backdrop = false,
      width = 40,
      min_width = 40,
      height = 0,
      position = 'right',
      border = 'none',
      box = 'vertical',
      {
        win = 'input',
        height = 1,
        border = 'rounded',
        title = '',
        title_pos = 'center',
      },
      { win = 'list', border = 'none' },
      { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
    },
  },
}

return M
